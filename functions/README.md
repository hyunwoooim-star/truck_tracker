# Truck Tracker - Firebase Cloud Functions

Firebase Cloud Functions for Truck Tracker application.

## 📋 Overview

This directory contains serverless backend functions for the Truck Tracker app:

1. **Authentication**: Custom token generation for OAuth providers (Kakao, Naver)
2. **Push Notifications**: Automatic FCM notifications when trucks open for business

## 🚀 Deployed Functions

### 1. `createCustomToken` (HTTPS Trigger)

**Purpose**: Generate Firebase custom tokens for social login (Kakao/Naver OAuth)

**Endpoint**: `https://us-central1-truck-tracker-fa0b0.cloudfunctions.net/createCustomToken`

**Request**:
```json
{
  "provider": "kakao",
  "kakaoId": "123456789",
  "email": "user@example.com",
  "displayName": "홍길동",
  "photoURL": "https://..."
}
```

**Response**:
```json
{
  "token": "eyJhbGc..."
}
```

**Implementation**: `index.js:5-47`

---

### 2. `notifyTruckOpening` (Firestore Trigger)

**Purpose**: Send push notifications to users when their favorited truck opens for business

**Trigger**: Firestore `trucks/{truckId}` document update

**Logic**:
1. Detects when `isOpen` field changes from `false` to `true`
2. Sends FCM notification to topic `truck_{truckId}`
3. All users who favorited the truck are subscribed to this topic

**Notification Format**:
```json
{
  "notification": {
    "title": "BM-001 is now OPEN! 🚚",
    "body": "Your favorite 닭꼬치 truck is now serving at 강남역 2번 출구. Order now!"
  },
  "data": {
    "truckId": "abc123",
    "type": "truck_opened",
    "timestamp": "2025-12-27T12:00:00.000Z"
  }
}
```

**Platform-Specific Behavior**:
- **Android**: High priority, default notification channel
- **iOS**: Sound enabled, badge count +1

**Implementation**: `index.js:54-115`

---

## 🔗 Flutter App Integration

### Topic Subscription Flow

When a user favorites a truck:

1. **Flutter App**: `favorite_repository.dart:42`
   ```dart
   await FcmService().subscribeToTruck(truckId);
   ```

2. **FCM Service**: `fcm_service.dart:164`
   ```dart
   await _messaging.subscribeToTopic('truck_$truckId');
   ```

3. **Firestore**: Favorite document created in `favorites/{userId_truckId}`

When a user unfavorites:

1. **Flutter App**: `favorite_repository.dart:68`
   ```dart
   await FcmService().unsubscribeFromTruck(truckId);
   ```

2. **FCM Service**: `fcm_service.dart:174`
   ```dart
   await _messaging.unsubscribeFromTopic('truck_$truckId');
   ```

### Truck Status Update Flow

When a truck owner starts business:

1. **Flutter App**: Owner dashboard updates `trucks/{truckId}` document
   ```dart
   await _firestore.collection('trucks').doc(truckId).update({
     'isOpen': true,
     'status': 'onRoute',
     // ...
   });
   ```

2. **Cloud Function**: `notifyTruckOpening` triggers automatically

3. **FCM**: Notification sent to all subscribed users (topic: `truck_{truckId}`)

---

## 🛠️ Development

### Prerequisites

- Node.js 20 or higher
- Firebase CLI (`npm install -g firebase-tools`)
- Firebase project: `truck-tracker-fa0b0`

### Installation

```bash
cd functions
npm install
```

### Local Testing

```bash
# Start Firebase Emulator Suite
firebase emulators:start

# The functions will be available at:
# - HTTPS functions: http://localhost:5001/truck-tracker-fa0b0/us-central1/{functionName}
# - Firestore triggers: Automatically triggered by Firestore emulator events
```

### Deployment

```bash
# Login to Firebase (if not already logged in)
firebase login

# Deploy all functions
firebase deploy --only functions

# Deploy specific function
firebase deploy --only functions:notifyTruckOpening
firebase deploy --only functions:createCustomToken
```

### View Logs

```bash
# Real-time logs
firebase functions:log

# Filter by function
firebase functions:log --only notifyTruckOpening
```

---

## 📁 File Structure

```
functions/
├── index.js              # Main function definitions
├── package.json          # Node.js dependencies
├── package-lock.json     # Dependency lock file
├── node_modules/         # Installed packages
├── .gitignore           # Git ignore rules
├── tsconfig.json        # TypeScript configuration (for future migration)
└── README.md            # This file
```

---

## 🔍 Verification

### Check Deployment Status

```bash
# List all deployed functions
firebase functions:list

# Expected output:
# ✓ createCustomToken (https)
# ✓ notifyTruckOpening (firestore.trucks.onUpdate)
```

### Test Notification Function

1. **Option 1**: Use Firebase Console
   - Go to Firestore Database
   - Find a truck document in `trucks` collection
   - Update `isOpen: false` → `isOpen: true`
   - Check logs for notification sent

2. **Option 2**: Use Flutter App
   - Login as truck owner
   - Start business from Owner Dashboard
   - Check customer app for notification (must have favorited the truck)

### Test Custom Token Function

```bash
curl -X POST https://us-central1-truck-tracker-fa0b0.cloudfunctions.net/createCustomToken \
  -H "Content-Type: application/json" \
  -d '{
    "provider": "kakao",
    "kakaoId": "test123",
    "email": "test@example.com",
    "displayName": "Test User"
  }'
```

---

## 🐛 Troubleshooting

### Function Not Triggering

1. **Check Firestore Rules**: Ensure write permissions exist
2. **Check Logs**: `firebase functions:log`
3. **Verify Trigger**: Confirm `isOpen` field actually changes from `false` to `true`
4. **Check Topic Subscription**: Users must be subscribed to `truck_{truckId}` topic

### Notification Not Received

1. **Check FCM Token**: Ensure user has valid FCM token
2. **Check Topic Subscription**: Verify user is subscribed (`fcm_service.dart:164`)
3. **Check App State**: Android may delay notifications when app is in background
4. **Check Permissions**: Ensure notification permissions granted on device

### Deployment Errors

1. **Node Version**: Ensure Node 20 is installed (`node --version`)
2. **Firebase Login**: Run `firebase login` if authentication fails
3. **Project ID**: Verify `.firebaserc` has correct project ID
4. **Dependencies**: Run `npm install` in functions directory

---

## 📊 Monitoring

### Firebase Console

1. Go to [Firebase Console](https://console.firebase.google.com)
2. Select project: `truck-tracker-fa0b0`
3. Navigate to **Functions** → View logs, metrics, errors

### Key Metrics to Monitor

- **Invocations**: Number of times function executed
- **Execution time**: Average function duration
- **Errors**: Failed function executions
- **Active instances**: Number of concurrent function instances

---

## 🔐 Security

### Environment Variables

No sensitive data is hardcoded. Firebase Admin SDK credentials are automatically provided by Firebase environment.

### CORS Configuration

`createCustomToken` function allows cross-origin requests from any domain (`Access-Control-Allow-Origin: *`). For production, consider restricting to your app's domain.

---

## 📝 Future Enhancements

### Potential Additional Functions

1. **Order Notifications**: Notify truck owner of new orders
2. **Review Notifications**: Notify truck owner of new reviews
3. **Schedule Change Notifications**: Notify users when favorited truck changes schedule
4. **Proximity Notifications**: Notify users when favorited truck is nearby
5. **Daily Summary**: Send daily business summary to truck owners

### Migration to TypeScript

Current implementation uses JavaScript. TypeScript configuration (`tsconfig.json`) is already in place for future migration.

**Migration Steps**:
1. Rename `index.js` to `index.ts`
2. Add type definitions for Firebase Admin SDK
3. Add return type annotations
4. Run `npm run build` to compile TypeScript

---

## 📞 Support

For issues or questions:
- Check Firebase Functions documentation: https://firebase.google.com/docs/functions
- Check FCM documentation: https://firebase.google.com/docs/cloud-messaging
- Review app logs: `firebase functions:log`

---

**Last Updated**: 2025-12-27
**Node Version**: 20
**Firebase Admin SDK**: 12.0.0
**Firebase Functions SDK**: 5.0.0
