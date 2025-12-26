# 🔐 Authentication System Deployment Guide

## ✅ Authentication Status

### **Fully Implemented & Ready:**
1. ✅ **Email/Password Authentication**
   - Sign up with email and password
   - Sign in with existing account
   - Form validation (email format, password length)
   - Legal agreement checkboxes for sign-up
   - Error handling with Korean messages

2. ✅ **Kakao Login** (requires Cloud Functions deployment)
   - Integration with Kakao SDK
   - Custom token generation via Cloud Function
   - User profile sync (name, email, photo)

3. ✅ **Naver Login** (requires Cloud Functions deployment)
   - Integration with Naver Login SDK
   - Custom token generation via Cloud Function
   - User profile sync (name, email, photo)

4. ✅ **User Management**
   - Automatic Firestore user document creation
   - User role management (customer/owner)
   - Owned truck ID tracking
   - Profile photo and display name support

5. ✅ **AuthWrapper Routing**
   - Auto-redirect to Owner Dashboard if user owns a truck
   - Auto-redirect to Map/Truck List for regular customers
   - Loading states during authentication check
   - Error fallback to login screen

---

## 🚀 Deployment Instructions

### **Step 1: Deploy Cloud Functions**

The Cloud Function `createCustomToken` is required for Kakao and Naver login to work.

```bash
# Navigate to project root
cd C:\Users\plmqa\OneDrive\Desktop\truck_tracker

# Deploy Cloud Functions to Firebase
firebase deploy --only functions
```

**Expected Output:**
```
✔  Deploy complete!

Functions:
  createCustomToken(us-central1): https://us-central1-truck-tracker-fa0b0.cloudfunctions.net/createCustomToken
```

**What this does:**
- Deploys the `createCustomToken` function to Firebase Cloud Functions
- This function creates Firebase custom tokens for Kakao/Naver users
- Kakao/Naver login buttons will work after deployment

---

### **Step 2: Configure Kakao SDK**

1. **Ensure `.env` file has Kakao App Key:**

```env
KAKAO_NATIVE_APP_KEY=your_kakao_native_app_key_here
```

2. **Get Kakao App Key:**
   - Go to [Kakao Developers](https://developers.kakao.com/)
   - Create/select your app
   - Go to **My Application > App Keys**
   - Copy the **Native App Key**
   - Paste it into `.env` file

3. **Configure Kakao Redirect URIs:**
   - In Kakao Developers Console
   - Go to **Platform > Web**
   - Add redirect URI: `https://truck-tracker-fa0b0.web.app`
   - Add redirect URI: `http://localhost:8080` (for testing)

---

### **Step 3: Configure Naver Login**

Naver Login requires additional setup in the Naver Developers Console:

1. **Create Naver Application:**
   - Go to [Naver Developers](https://developers.naver.com/apps/)
   - Create a new application
   - Select **"로그인 오픈API"** (Login Open API)

2. **Get Client ID and Secret:**
   - In your application settings, find:
     - **Client ID**
     - **Client Secret**

3. **Update `.env` (if needed):**
   ```env
   NAVER_CLIENT_ID=your_naver_client_id
   NAVER_CLIENT_SECRET=your_naver_client_secret
   ```

4. **Configure Callback URL:**
   - Set callback URL in Naver app settings
   - For web: `https://truck-tracker-fa0b0.web.app`
   - For local testing: `http://localhost:8080`

---

### **Step 4: Deploy Flutter Web App**

```bash
# Build Flutter web app
flutter build web

# Deploy to Firebase Hosting
firebase deploy --only hosting
```

**Expected Output:**
```
✔  Deploy complete!

Hosting URL: https://truck-tracker-fa0b0.web.app
```

---

### **Step 5: Test Authentication Flow**

1. **Test Email/Password:**
   - Go to `https://truck-tracker-fa0b0.web.app`
   - Click "회원가입" (Sign Up)
   - Fill in email, password, agree to terms
   - Click "회원가입" button
   - ✅ Should create user and navigate to Truck List

2. **Test Kakao Login:**
   - Click "카카오로 계속하기" button
   - Log in with Kakao account
   - ✅ Should authenticate and navigate to app

3. **Test Naver Login:**
   - Click "네이버로 계속하기" button
   - Log in with Naver account
   - ✅ Should authenticate and navigate to app

4. **Test Owner vs Customer Routing:**
   - **Customer**: User without `ownedTruckId` → MapFirstScreen
   - **Owner**: User with `ownedTruckId` → OwnerDashboardScreen

---

## 🛠 Troubleshooting

### Issue: Kakao login fails with "Cloud Function error"

**Solution:**
- Verify Cloud Functions are deployed: `firebase functions:list`
- Check function logs: `firebase functions:log`
- Ensure CORS is enabled in `functions/index.js` (already configured)

### Issue: Naver login fails

**Solution:**
- Verify Naver Client ID and Secret in `.env`
- Check callback URL matches your deployment URL
- Review Naver app permissions (must include profile, email)

### Issue: "이용약관에 동의해주세요" error during sign-up

**Cause:** User didn't check the required legal agreement checkboxes.

**Solution:**
- Ensure both checkboxes are checked before clicking "회원가입"

### Issue: User redirects to LoginScreen after successful login

**Cause:** `ownedTruckId` check is failing or user doesn't exist in Firestore.

**Solution:**
- Check Firebase Console → Firestore → `users` collection
- Verify user document was created with correct fields
- Check AuthWrapper logic in `main.dart`

---

## 📊 Firestore User Document Structure

When a user signs up or logs in, a document is created in the `users` collection:

```javascript
{
  "uid": "abc123...",
  "email": "user@example.com",
  "displayName": "User Name",
  "photoURL": "https://...",
  "loginMethod": "email" | "kakao" | "naver",
  "role": "customer" | "owner",
  "ownedTruckId": null | 1,  // null for customers, truck ID for owners
  "createdAt": Timestamp,
  "updatedAt": Timestamp
}
```

---

## 🔥 Firebase Configuration Files

### `firebase.json`
```json
{
  "hosting": {
    "public": "build/web",
    "ignore": ["firebase.json", "**/.*", "**/node_modules/**"],
    "rewrites": [
      {
        "source": "**",
        "destination": "/index.html"
      }
    ]
  },
  "functions": {
    "source": "functions"
  }
}
```

### `functions/package.json`
```json
{
  "name": "functions",
  "description": "Firebase Cloud Functions for Truck Tracker",
  "dependencies": {
    "firebase-admin": "^12.0.0",
    "firebase-functions": "^5.0.0"
  },
  "engines": {
    "node": "20"
  }
}
```

---

## ✅ Ready for Production?

### Pre-Deployment Checklist:

- [ ] Cloud Functions deployed (`firebase deploy --only functions`)
- [ ] Kakao App Key added to `.env`
- [ ] Naver Client ID/Secret added to `.env`
- [ ] Kakao redirect URIs configured
- [ ] Naver callback URL configured
- [ ] Flutter web built (`flutter build web`)
- [ ] Hosting deployed (`firebase deploy --only hosting`)
- [ ] Tested email sign-up/login
- [ ] Tested Kakao login (if configured)
- [ ] Tested Naver login (if configured)
- [ ] Verified AuthWrapper routing (owner vs customer)
- [ ] Checked Firestore security rules

---

## 🎯 Complete Deployment Command

```bash
# Build and deploy everything at once
flutter build web && firebase deploy
```

This will:
1. Build the Flutter web app
2. Deploy hosting (web app)
3. Deploy Cloud Functions (for Kakao/Naver auth)

---

## 🔒 Security Notes

1. **Environment Variables:**
   - Never commit `.env` file to git
   - Keep Kakao/Naver keys secret
   - Regenerate keys if accidentally exposed

2. **Firestore Security Rules:**
   - Ensure users can only read/write their own documents
   - Review `firestore.rules` before production

3. **Cloud Functions:**
   - CORS is enabled for all origins (suitable for development)
   - For production, restrict CORS to your domain only

---

## 📞 Support

If you encounter any issues:
1. Check Firebase Console for error logs
2. Review browser console for client-side errors
3. Check `firebase functions:log` for Cloud Function errors
4. Verify all API keys and configurations are correct

---

## ✨ Features Summary

| Feature | Status | Notes |
|---------|--------|-------|
| Email/Password Auth | ✅ Ready | Fully functional |
| Kakao Login | ✅ Ready | Requires Cloud Functions deployment |
| Naver Login | ✅ Ready | Requires Cloud Functions deployment |
| Google Login | ❌ Not Implemented | Future enhancement |
| Sign-up Flow | ✅ Ready | Includes legal agreements |
| User Document Creation | ✅ Ready | Auto-creates in Firestore |
| AuthWrapper Routing | ✅ Ready | Owner vs Customer detection |
| Error Handling | ✅ Ready | Korean error messages |
| Password Validation | ✅ Ready | Min 6 characters |
| Email Validation | ✅ Ready | Format check |
| Guest Mode | ✅ Ready | "둘러보기" button |

---

**The project is READY for `firebase deploy` once you configure Kakao and Naver API keys!** 🚀
