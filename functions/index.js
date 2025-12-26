const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

exports.createCustomToken = functions.https.onRequest(async (req, res) => {
  // Enable CORS
  res.set('Access-Control-Allow-Origin', '*');
  if (req.method === 'OPTIONS') {
    res.set('Access-Control-Allow-Methods', 'POST');
    res.set('Access-Control-Allow-Headers', 'Content-Type');
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
