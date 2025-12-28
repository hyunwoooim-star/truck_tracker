const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

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
 * Cloud Function: Send push notification when new chat message arrives
 * Trigger: Firestore onCreate on chatRooms/{chatRoomId}/messages/{messageId}
 * Logic: Notify the other participant (not the sender)
 */
exports.notifyChatMessage = functions.firestore
  .document('chatRooms/{chatRoomId}/messages/{messageId}')
  .onCreate(async (snap, context) => {
    const chatRoomId = context.params.chatRoomId;
    const messageId = context.params.messageId;
    const messageData = snap.data();

    const senderId = messageData.senderId;
    const senderName = messageData.senderName || 'Someone';
    const text = messageData.text || '';
    const imageUrl = messageData.imageUrl || null;

    console.log(`🔔 New chat message in room ${chatRoomId} from ${senderName}`);

    // Get chat room to find the recipient
    const chatRoomDoc = await admin.firestore().collection('chatRooms').doc(chatRoomId).get();
    if (!chatRoomDoc.exists) {
      console.log(`⚠️  Chat room ${chatRoomId} not found`);
      return { success: false, reason: 'chat room not found' };
    }

    const chatRoomData = chatRoomDoc.data();
    const customerId = chatRoomData.customerId;
    const truckOwnerId = chatRoomData.truckOwnerId || null;

    // Determine recipient (not the sender)
    const recipientId = senderId === customerId ? truckOwnerId : customerId;

    if (!recipientId) {
      console.log(`⚠️  No recipient found for chat room ${chatRoomId}`);
      return { success: false, reason: 'no recipient' };
    }

    // Get recipient's FCM token
    const recipientDoc = await admin.firestore().collection('users').doc(recipientId).get();
    if (!recipientDoc.exists || !recipientDoc.data().fcmToken) {
      console.log(`⚠️  Recipient ${recipientId} has no FCM token`);
      return { success: false, reason: 'no FCM token' };
    }

    const fcmToken = recipientDoc.data().fcmToken;

    // Prepare notification body
    let body = text || '사진을 보냈습니다';
    if (body.length > 50) {
      body = body.substring(0, 50) + '...';
    }

    const message = {
      token: fcmToken,
      notification: {
        title: `💬 ${senderName}`,
        body: body,
      },
      data: {
        chatRoomId: chatRoomId,
        messageId: messageId,
        senderId: senderId,
        type: 'chat_message',
        timestamp: new Date().toISOString(),
      },
      android: {
        notification: {
          icon: 'ic_chat',
          color: '#2196F3',
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
      console.log(`✅ Successfully sent chat notification:`, response);
      return { success: true, messageId: response };
    } catch (error) {
      console.error(`❌ Error sending chat notification:`, error);
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
