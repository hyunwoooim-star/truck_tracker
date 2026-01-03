const functions = require('firebase-functions');
const { defineSecret } = require('firebase-functions/params');
const admin = require('firebase-admin');
const axios = require('axios');
admin.initializeApp();

// Kakao OAuth 설정
const KAKAO_CLIENT_ID = '9b29da5ab6db839b37a65c79afe9b52e'; // REST API 키
const kakaoClientSecret = defineSecret('KAKAO_CLIENT_SECRET');

// Naver OAuth 설정
const NAVER_CLIENT_ID = '9szh6EOxjf8b40x9ZHKH';
const naverClientSecret = defineSecret('NAVER_CLIENT_SECRET');

// CORS whitelist for security
const allowedOrigins = [
  'https://truck-tracker-fa0b0.web.app',
  'https://truck-tracker-fa0b0.firebaseapp.com',
  'http://localhost:3000',
  'http://localhost:5000',
  'http://localhost:8080',
];

/**
 * Set CORS headers with whitelist validation
 * Only allows requests from approved origins
 */
function setCorsHeaders(req, res) {
  const origin = req.headers.origin;

  if (allowedOrigins.includes(origin)) {
    res.set('Access-Control-Allow-Origin', origin);
  } else {
    // Reject unauthorized origins
    res.set('Access-Control-Allow-Origin', 'null');
  }

  res.set('Access-Control-Allow-Methods', 'GET, POST, OPTIONS');
  res.set('Access-Control-Allow-Headers', 'Content-Type, Authorization');
  res.set('Access-Control-Max-Age', '3600');
}

exports.createCustomToken = functions.https.onRequest(async (req, res) => {
  // Apply CORS security
  setCorsHeaders(req, res);

  if (req.method === 'OPTIONS') {
    res.status(204).send('');
    return;
  }

  const { kakaoId, naverId, provider, email, displayName, photoURL } = req.body;

  if (!provider || (!kakaoId && !naverId)) {
    res.status(400).json({ error: 'Missing required parameters' });
    return;
  }

  const uid = provider === 'kakao' ? `kakao_${kakaoId}` : `naver_${naverId}`;

  try {
    // Try to get existing user or create new one
    try {
      await admin.auth().getUser(uid);
    } catch (error) {
      if (error.code === 'auth/user-not-found') {
        await admin.auth().createUser({
          uid: uid,
          email: email,
          displayName: displayName,
          photoURL: photoURL,
        });
      } else {
        throw error;
      }
    }

    const customToken = await admin.auth().createCustomToken(uid);
    res.json({ token: customToken });
  } catch (error) {
    console.error('Error creating custom token:', error);
    res.status(500).json({ error: error.message });
  }
});

/**
 * Cloud Function: Send push notification when truck opens for business
 * Trigger: Firestore onUpdate on trucks/{truckId}
 * Logic: When isOpen changes from false to true, send FCM to topic truck_{truckId}
 */
exports.notifyTruckOpening = functions.firestore
  .document('trucks/{truckId}')
  .onUpdate(async (change, context) => {
    const truckId = context.params.truckId;
    const beforeData = change.before.data();
    const afterData = change.after.data();

    // Check if isOpen changed from false to true
    const wasOpen = beforeData.isOpen || false;
    const isNowOpen = afterData.isOpen || false;

    if (!wasOpen && isNowOpen) {
      console.log(`🔔 Truck ${truckId} just opened! Sending notifications...`);

      const truckName = afterData.truckNumber || 'Food Truck';
      const foodType = afterData.foodType || 'Food';
      const location = afterData.locationDescription || 'nearby';

      const topic = `truck_${truckId}`;

      const message = {
        topic: topic,
        notification: {
          title: `${truckName} is now OPEN! 🚚`,
          body: `Your favorite ${foodType} truck is now serving at ${location}. Order now!`,
        },
        data: {
          truckId: truckId,
          type: 'truck_opened',
          timestamp: new Date().toISOString(),
        },
        android: {
          notification: {
            icon: 'ic_truck',
            color: '#FFC107',
            sound: 'default',
            clickAction: 'FLUTTER_NOTIFICATION_CLICK',
          },
        },
        apns: {
          payload: {
            aps: {
              sound: 'default',
              badge: 1,
            },
          },
        },
      };

      try {
        const response = await admin.messaging().send(message);
        console.log(`✅ Successfully sent notification for truck ${truckId}:`, response);
        return { success: true, messageId: response };
      } catch (error) {
        console.error(`❌ Error sending notification for truck ${truckId}:`, error);
        return { success: false, error: error.message };
      }
    } else {
      console.log(`ℹ️  Truck ${truckId} updated, but isOpen status unchanged (wasOpen: ${wasOpen}, isNowOpen: ${isNowOpen})`);
      return { success: false, reason: 'isOpen status not changed to true' };
    }
  });

/**
 * Cloud Function: Send push notification when order status changes
 * Trigger: Firestore onUpdate on orders/{orderId}
 * Logic: When status changes, notify customer and truck owner
 */
exports.notifyOrderStatus = functions.firestore
  .document('orders/{orderId}')
  .onUpdate(async (change, context) => {
    const orderId = context.params.orderId;
    const beforeData = change.before.data();
    const afterData = change.after.data();

    // Check if status changed
    const beforeStatus = beforeData.status;
    const afterStatus = afterData.status;

    if (beforeStatus === afterStatus) {
      console.log(`ℹ️  Order ${orderId} updated, but status unchanged`);
      return { success: false, reason: 'status unchanged' };
    }

    console.log(`🔔 Order ${orderId} status changed: ${beforeStatus} → ${afterStatus}`);

    const customerId = afterData.customerId;
    const truckId = afterData.truckId;
    const truckName = afterData.truckName || 'Food Truck';

    // Status messages in Korean
    const statusMessages = {
      pending: '주문이 접수되었습니다',
      confirmed: '주문이 확인되었습니다',
      preparing: '음식을 준비 중입니다',
      ready: '주문이 완료되었습니다! 픽업해주세요',
      completed: '주문이 완료되었습니다',
      cancelled: '주문이 취소되었습니다'
    };

    const statusEmojis = {
      pending: '📝',
      confirmed: '✅',
      preparing: '👨‍🍳',
      ready: '🎉',
      completed: '✨',
      cancelled: '❌'
    };

    const message = {
      token: customerId, // FCM token stored in user profile
      notification: {
        title: `${statusEmojis[afterStatus] || '📦'} ${truckName}`,
        body: statusMessages[afterStatus] || `주문 상태: ${afterStatus}`,
      },
      data: {
        orderId: orderId,
        truckId: truckId,
        status: afterStatus,
        type: 'order_status',
        timestamp: new Date().toISOString(),
      },
      android: {
        notification: {
          icon: 'ic_order',
          color: '#4CAF50',
          sound: 'default',
          clickAction: 'FLUTTER_NOTIFICATION_CLICK',
        },
      },
      apns: {
        payload: {
          aps: {
            sound: 'default',
            badge: 1,
          },
        },
      },
    };

    try {
      // Get user's FCM token from Firestore
      const userDoc = await admin.firestore().collection('users').doc(customerId).get();
      if (!userDoc.exists || !userDoc.data().fcmToken) {
        console.log(`⚠️  User ${customerId} has no FCM token`);
        return { success: false, reason: 'no FCM token' };
      }

      message.token = userDoc.data().fcmToken;
      const response = await admin.messaging().send(message);
      console.log(`✅ Successfully sent order notification:`, response);
      return { success: true, messageId: response };
    } catch (error) {
      console.error(`❌ Error sending order notification:`, error);
      return { success: false, error: error.message };
    }
  });

/**
 * Cloud Function: Send push notification when new coupon is created
 * Trigger: Firestore onCreate on coupons/{couponId}
 * Logic: Notify all followers of the truck
 */
exports.notifyCouponCreated = functions.firestore
  .document('coupons/{couponId}')
  .onCreate(async (snap, context) => {
    const couponId = context.params.couponId;
    const couponData = snap.data();

    const truckId = couponData.truckId;
    const truckName = couponData.truckName || 'Food Truck';
    const discountValue = couponData.discountValue || 0;
    const discountType = couponData.discountType || 'percentage';
    const code = couponData.code || '';

    console.log(`🔔 New coupon created for truck ${truckId}: ${code}`);

    // Format discount message
    let discountText = '';
    if (discountType === 'percentage') {
      discountText = `${discountValue}% 할인`;
    } else if (discountType === 'fixed') {
      discountText = `${discountValue}원 할인`;
    } else if (discountType === 'free_item') {
      discountText = '무료 증정';
    }

    const topic = `truck_${truckId}`;

    const message = {
      topic: topic,
      notification: {
        title: `🎁 ${truckName} 새 쿠폰 발행!`,
        body: `${discountText} 쿠폰이 발행되었습니다! 코드: ${code}`,
      },
      data: {
        couponId: couponId,
        truckId: truckId,
        code: code,
        type: 'coupon_created',
        timestamp: new Date().toISOString(),
      },
      android: {
        notification: {
          icon: 'ic_coupon',
          color: '#FF5722',
          sound: 'default',
          clickAction: 'FLUTTER_NOTIFICATION_CLICK',
        },
      },
      apns: {
        payload: {
          aps: {
            sound: 'default',
            badge: 1,
          },
        },
      },
    };

    try {
      const response = await admin.messaging().send(message);
      console.log(`✅ Successfully sent coupon notification:`, response);
      return { success: true, messageId: response };
    } catch (error) {
      console.error(`❌ Error sending coupon notification:`, error);
      return { success: false, error: error.message };
    }
  });

/**
 * Cloud Function: Send push notification when new order is created
 * Trigger: Firestore onCreate on orders/{orderId}
 * Logic: Notify truck owner of new order (especially for bank transfers)
 */
exports.notifyNewOrder = functions.firestore
  .document('orders/{orderId}')
  .onCreate(async (snap, context) => {
    const orderId = context.params.orderId;
    const orderData = snap.data();

    console.log(`🔔 New order created: ${orderId}`);

    const userId = orderData.userId;
    const truckId = orderData.truckId;
    const truckName = orderData.truckName || 'Food Truck';
    const totalAmount = orderData.totalAmount || 0;
    const paymentMethod = orderData.paymentMethod || 'card';
    const items = orderData.items || [];
    const specialRequests = orderData.specialRequests || '';

    // Extract depositor name for bank transfer orders
    let depositorName = null;
    if (paymentMethod === 'bank_transfer' && specialRequests) {
      const match = specialRequests.match(/입금자명:\s*(.+)/);
      if (match) {
        depositorName = match[1].trim();
      }
    }

    // Format amount with thousand separators
    const formattedAmount = totalAmount.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',');

    // Get truck owner's user ID from trucks collection
    const truckDoc = await admin.firestore().collection('trucks').doc(truckId).get();
    if (!truckDoc.exists) {
      console.log(`⚠️  Truck ${truckId} not found`);
      return { success: false, reason: 'truck not found' };
    }

    const truckOwnerId = truckDoc.data().ownerId;
    if (!truckOwnerId) {
      console.log(`⚠️  Truck ${truckId} has no owner`);
      return { success: false, reason: 'no owner' };
    }

    // Get owner's FCM token
    const ownerDoc = await admin.firestore().collection('users').doc(truckOwnerId).get();
    if (!ownerDoc.exists || !ownerDoc.data().fcmToken) {
      console.log(`⚠️  Owner ${truckOwnerId} has no FCM token`);
      return { success: false, reason: 'no FCM token' };
    }

    const fcmToken = ownerDoc.data().fcmToken;

    // Create notification message
    let notificationBody = `${items.length}개 메뉴 - ₩${formattedAmount}`;
    if (paymentMethod === 'bank_transfer') {
      notificationBody += ` (계좌이체${depositorName ? ` - ${depositorName}` : ''})`;
    }

    const message = {
      token: fcmToken,
      notification: {
        title: `🛒 새 주문이 들어왔습니다!`,
        body: notificationBody,
      },
      data: {
        orderId: orderId,
        truckId: truckId,
        userId: userId,
        totalAmount: totalAmount.toString(),
        paymentMethod: paymentMethod,
        type: 'new_order',
        timestamp: new Date().toISOString(),
      },
      android: {
        notification: {
          icon: 'ic_order',
          color: paymentMethod === 'bank_transfer' ? '#FF9800' : '#4CAF50',
          sound: 'default',
          clickAction: 'FLUTTER_NOTIFICATION_CLICK',
          priority: 'high',
        },
      },
      apns: {
        payload: {
          aps: {
            sound: 'default',
            badge: 1,
            alert: {
              title: '🛒 새 주문이 들어왔습니다!',
              body: notificationBody,
            },
          },
        },
      },
    };

    try {
      const response = await admin.messaging().send(message);
      console.log(`✅ Successfully sent new order notification to owner:`, response);

      // Also store in notifications collection for in-app display
      await admin.firestore().collection('notifications').doc().set({
        userId: truckOwnerId,
        type: 'newOrder',
        title: '새 주문이 들어왔습니다!',
        body: notificationBody,
        orderId: orderId,
        truckId: truckId,
        isRead: false,
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
      });

      return { success: true, messageId: response };
    } catch (error) {
      console.error(`❌ Error sending new order notification:`, error);
      return { success: false, error: error.message };
    }
  });

/**
 * Cloud Function: Send push notification for nearby trucks
 * Trigger: Firestore onUpdate on trucks/{truckId}
 * Logic: When truck location changes, notify users within radius
 * Uses Haversine formula for distance calculation
 */
exports.notifyNearbyTrucks = functions.firestore
  .document('trucks/{truckId}')
  .onUpdate(async (change, context) => {
    const truckId = context.params.truckId;
    const beforeData = change.before.data();
    const afterData = change.after.data();

    // Check if location changed
    const beforeLat = beforeData.latitude;
    const beforeLng = beforeData.longitude;
    const afterLat = afterData.latitude;
    const afterLng = afterData.longitude;

    if (beforeLat === afterLat && beforeLng === afterLng) {
      console.log(`ℹ️  Truck ${truckId} updated, but location unchanged`);
      return { success: false, reason: 'location unchanged' };
    }

    console.log(`🔔 Truck ${truckId} location changed: (${beforeLat}, ${beforeLng}) → (${afterLat}, ${afterLng})`);

    const truckName = afterData.truckNumber || 'Food Truck';
    const foodType = afterData.foodType || 'Food';
    const locationDescription = afterData.locationDescription || 'nearby';

    // Haversine formula to calculate distance
    function haversineDistance(lat1, lon1, lat2, lon2) {
      const R = 6371; // Earth radius in km
      const dLat = (lat2 - lat1) * Math.PI / 180;
      const dLon = (lon2 - lon1) * Math.PI / 180;
      const a =
        Math.sin(dLat / 2) * Math.sin(dLat / 2) +
        Math.cos(lat1 * Math.PI / 180) * Math.cos(lat2 * Math.PI / 180) *
        Math.sin(dLon / 2) * Math.sin(dLon / 2);
      const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
      return R * c; // Distance in km
    }

    // Get all users with notification preferences
    const usersSnapshot = await admin.firestore()
      .collection('notificationSettings')
      .where('nearbyTrucks', '==', true)
      .get();

    if (usersSnapshot.empty) {
      console.log(`ℹ️  No users with nearby truck notifications enabled`);
      return { success: false, reason: 'no users' };
    }

    let notificationsSent = 0;
    const promises = [];

    for (const userDoc of usersSnapshot.docs) {
      const userId = userDoc.id;
      const settings = userDoc.data();
      const nearbyRadius = settings.nearbyRadius || 1.0; // Default 1km

      // Get user's location
      const userProfileDoc = await admin.firestore().collection('users').doc(userId).get();
      if (!userProfileDoc.exists) continue;

      const userProfile = userProfileDoc.data();
      const userLat = userProfile.lastKnownLatitude;
      const userLng = userProfile.lastKnownLongitude;
      const fcmToken = userProfile.fcmToken;

      if (!userLat || !userLng || !fcmToken) continue;

      // Calculate distance
      const distance = haversineDistance(userLat, userLng, afterLat, afterLng);

      if (distance <= nearbyRadius) {
        console.log(`📍 User ${userId} is ${distance.toFixed(2)}km away from truck ${truckId}`);

        const message = {
          token: fcmToken,
          notification: {
            title: `🚚 근처에 ${truckName}이(가) 있어요!`,
            body: `${foodType} 트럭이 ${locationDescription}에서 ${distance.toFixed(1)}km 떨어진 곳에 있습니다`,
          },
          data: {
            truckId: truckId,
            distance: distance.toFixed(2),
            type: 'nearby_truck',
            timestamp: new Date().toISOString(),
          },
          android: {
            notification: {
              icon: 'ic_location',
              color: '#FF9800',
              sound: 'default',
              clickAction: 'FLUTTER_NOTIFICATION_CLICK',
            },
          },
          apns: {
            payload: {
              aps: {
                sound: 'default',
                badge: 1,
              },
            },
          },
        };

        promises.push(
          admin.messaging().send(message)
            .then(() => {
              notificationsSent++;
              console.log(`✅ Sent nearby notification to user ${userId}`);
            })
            .catch(error => {
              console.error(`❌ Error sending to user ${userId}:`, error);
            })
        );
      }
    }

    await Promise.all(promises);
    console.log(`✅ Sent ${notificationsSent} nearby truck notifications`);
    return { success: true, count: notificationsSent };
  });

/**
 * Cloud Function: Notify admins when a new owner verification request is submitted
 * Trigger: Firestore onCreate on owner_requests/{requestId}
 * Logic: Send FCM to all admins via topic 'admin_notifications'
 */
exports.notifyAdminOwnerRequest = functions.firestore
  .document('owner_requests/{requestId}')
  .onCreate(async (snap, context) => {
    const requestId = context.params.requestId;
    const requestData = snap.data();

    console.log(`📋 New owner verification request: ${requestId}`);

    // Get request details
    const displayName = requestData.displayName || '이름 없음';
    const email = requestData.email || '';

    try {
      // Send notification to admin topic
      const message = {
        topic: 'admin_notifications',
        notification: {
          title: '🏪 새로운 사장님 인증 요청',
          body: `${displayName}님이 사장님 인증을 요청했습니다.`,
        },
        data: {
          type: 'owner_verification_request',
          requestId: requestId,
          email: email,
          displayName: displayName,
          clickAction: 'FLUTTER_NOTIFICATION_CLICK',
        },
        android: {
          notification: {
            icon: '@mipmap/ic_launcher',
            color: '#FFC107',
            sound: 'default',
            clickAction: 'FLUTTER_NOTIFICATION_CLICK',
          },
          priority: 'high',
        },
        apns: {
          payload: {
            aps: {
              sound: 'default',
              badge: 1,
            },
          },
        },
      };

      await admin.messaging().send(message);
      console.log(`✅ Admin notification sent for request ${requestId}`);

      // Also store in notifications collection for in-app display
      const adminsSnapshot = await admin.firestore()
        .collection('users')
        .where('role', '==', 'admin')
        .get();

      const batch = admin.firestore().batch();
      adminsSnapshot.docs.forEach(adminDoc => {
        const notificationRef = admin.firestore()
          .collection('notifications')
          .doc();
        batch.set(notificationRef, {
          userId: adminDoc.id,
          type: 'owner_verification_request',
          title: '새로운 사장님 인증 요청',
          body: `${displayName}님이 사장님 인증을 요청했습니다.`,
          data: { requestId, email, displayName },
          isRead: false,
          createdAt: admin.firestore.FieldValue.serverTimestamp(),
        });
      });

      await batch.commit();
      console.log(`✅ Stored notifications for ${adminsSnapshot.docs.length} admins`);

      return { success: true };
    } catch (error) {
      console.error('❌ Error sending admin notification:', error);
      return { success: false, error: error.message };
    }
  });

/**
 * Cloud Function: Update admin stats when owner_requests changes
 * Trigger: Firestore onWrite on owner_requests/{requestId}
 * Logic: Recalculate and update stats/admin_overview document
 */
exports.updateAdminStats = functions.firestore
  .document('owner_requests/{requestId}')
  .onWrite(async (change, context) => {
    console.log('📊 Updating admin stats...');

    try {
      const db = admin.firestore();

      // Count pending requests
      const pendingSnapshot = await db
        .collection('owner_requests')
        .where('status', '==', 'pending')
        .count()
        .get();

      // Count approved requests
      const approvedSnapshot = await db
        .collection('owner_requests')
        .where('status', '==', 'approved')
        .count()
        .get();

      // Count rejected requests
      const rejectedSnapshot = await db
        .collection('owner_requests')
        .where('status', '==', 'rejected')
        .count()
        .get();

      // Count total users
      const usersSnapshot = await db
        .collection('users')
        .count()
        .get();

      // Count total trucks
      const trucksSnapshot = await db
        .collection('trucks')
        .count()
        .get();

      const stats = {
        pendingOwnerRequests: pendingSnapshot.data().count,
        totalApprovedOwners: approvedSnapshot.data().count,
        totalRejectedOwners: rejectedSnapshot.data().count,
        totalUsers: usersSnapshot.data().count,
        totalTrucks: trucksSnapshot.data().count,
        lastUpdated: admin.firestore.FieldValue.serverTimestamp(),
      };

      await db.collection('stats').doc('admin_overview').set(stats, { merge: true });

      console.log('✅ Admin stats updated:', stats);
      return { success: true, stats };
    } catch (error) {
      console.error('❌ Error updating admin stats:', error);
      return { success: false, error: error.message };
    }
  });

/**
 * Cloud Function: Exchange Kakao OAuth code for Firebase custom token
 * Used for web-based Kakao login
 */
exports.exchangeKakaoCode = functions
  .https.onRequest(async (req, res) => {
  setCorsHeaders(req, res);

  if (req.method === 'OPTIONS') {
    res.status(204).send('');
    return;
  }

  const { code, redirectUri } = req.body;

  if (!code || !redirectUri) {
    res.status(400).json({ error: 'Missing code or redirectUri' });
    return;
  }

  try {
    // 1. Exchange code for access token (Client Secret OFF이므로 제외)
    const tokenResponse = await axios.post(
      'https://kauth.kakao.com/oauth/token',
      new URLSearchParams({
        grant_type: 'authorization_code',
        client_id: KAKAO_CLIENT_ID,
        redirect_uri: redirectUri,
        code: code,
      }),
      { headers: { 'Content-Type': 'application/x-www-form-urlencoded' } }
    );

    const accessToken = tokenResponse.data.access_token;
    console.log('📱 Kakao access token obtained');

    // 2. Get user info from Kakao
    const userResponse = await axios.get('https://kapi.kakao.com/v2/user/me', {
      headers: { Authorization: `Bearer ${accessToken}` },
    });

    const kakaoUser = userResponse.data;
    const kakaoId = kakaoUser.id.toString();
    const email = kakaoUser.kakao_account?.email;
    const displayName = kakaoUser.kakao_account?.profile?.nickname || '카카오 사용자';
    const photoURL = kakaoUser.kakao_account?.profile?.profile_image_url;

    console.log(`👤 Kakao user: ${kakaoId}, ${displayName}, ${email}`);

    // 3. Create or get Firebase user
    const uid = `kakao_${kakaoId}`;

    try {
      await admin.auth().getUser(uid);
    } catch (error) {
      if (error.code === 'auth/user-not-found') {
        await admin.auth().createUser({
          uid: uid,
          email: email || undefined,
          displayName: displayName,
          photoURL: photoURL || undefined,
        });
      } else {
        throw error;
      }
    }

    // 4. Create custom token
    const customToken = await admin.auth().createCustomToken(uid);

    console.log('✅ Kakao web login successful');
    res.json({ token: customToken });
  } catch (error) {
    console.error('❌ Kakao code exchange failed:', error.response?.data || error.message);
    res.status(500).json({ error: error.message });
  }
});

/**
 * Cloud Function: Exchange Naver OAuth code for Firebase custom token
 * Used for web-based Naver login
 */
exports.exchangeNaverCode = functions
  .runWith({ secrets: [naverClientSecret] })
  .https.onRequest(async (req, res) => {
  setCorsHeaders(req, res);

  if (req.method === 'OPTIONS') {
    res.status(204).send('');
    return;
  }

  const { code, state, redirectUri } = req.body;

  if (!code || !state) {
    res.status(400).json({ error: 'Missing code or state' });
    return;
  }

  try {
    // 디버깅: 요청 파라미터 로깅
    const secretValue = naverClientSecret.value();
    console.log('🔍 네이버 요청 파라미터:', {
      client_id: NAVER_CLIENT_ID,
      client_secret_length: secretValue ? secretValue.length : 0,
      client_secret_preview: secretValue ? secretValue.substring(0, 3) + '***' : 'EMPTY',
      code_length: code ? code.length : 0,
      state: state,
    });

    // 1. Exchange code for access token (GET method - Naver standard)
    const tokenUrl = `https://nid.naver.com/oauth2.0/token?grant_type=authorization_code&client_id=${NAVER_CLIENT_ID}&client_secret=${encodeURIComponent(secretValue)}&code=${encodeURIComponent(code)}&state=${encodeURIComponent(state)}`;

    console.log('🔗 Naver token URL (without secret):', tokenUrl.replace(secretValue, '***'));

    const tokenResponse = await axios.get(tokenUrl);

    console.log('📦 Naver token response:', JSON.stringify(tokenResponse.data));

    const accessToken = tokenResponse.data.access_token;
    if (!accessToken) {
      throw new Error('No access token in response: ' + JSON.stringify(tokenResponse.data));
    }
    console.log('📱 Naver access token obtained, length:', accessToken.length);

    // 2. Get user info from Naver
    console.log('🔍 Calling Naver user info API...');
    const userResponse = await axios.get('https://openapi.naver.com/v1/nid/me', {
      headers: { Authorization: `Bearer ${accessToken}` },
    });
    console.log('👤 Naver user info response:', JSON.stringify(userResponse.data));

    const naverUser = userResponse.data.response;
    const naverId = naverUser.id;
    const email = naverUser.email;
    const displayName = naverUser.name || naverUser.nickname || '네이버 사용자';
    const photoURL = naverUser.profile_image;

    console.log(`👤 Naver user: ${naverId}, ${displayName}, ${email}`);

    // 3. Create or get Firebase user
    const uid = `naver_${naverId}`;

    try {
      await admin.auth().getUser(uid);
      console.log('👤 Existing Naver user found:', uid);
    } catch (error) {
      if (error.code === 'auth/user-not-found') {
        try {
          await admin.auth().createUser({
            uid: uid,
            email: email || undefined,
            displayName: displayName,
            photoURL: photoURL || undefined,
          });
          console.log('👤 New Naver user created:', uid);
        } catch (createError) {
          // 이메일 중복 시 이메일 없이 생성
          if (createError.code === 'auth/email-already-exists') {
            console.log('⚠️ Email already exists, creating user without email');
            await admin.auth().createUser({
              uid: uid,
              displayName: displayName,
              photoURL: photoURL || undefined,
            });
            console.log('👤 New Naver user created (no email):', uid);
          } else {
            throw createError;
          }
        }
      } else {
        throw error;
      }
    }

    // 4. Create custom token
    const customToken = await admin.auth().createCustomToken(uid);

    console.log('✅ Naver web login successful');
    res.json({ token: customToken });
  } catch (error) {
    console.error('❌ Naver code exchange failed');
    console.error('Error message:', error.message);
    console.error('Error response status:', error.response?.status);
    console.error('Error response data:', JSON.stringify(error.response?.data));
    res.status(500).json({
      error: error.message,
      details: error.response?.data,
      status: error.response?.status
    });
  }
});
