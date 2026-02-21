# Firebase Setup - Step by Step Guide

## Prerequisites
- Google Account
- Your DiPrep Flutter app with firebase_auth integrated ✅

---

## STEP 1: Create Firebase Project

### 1.1 Go to Firebase Console
```
https://console.firebase.google.com
```

### 1.2 Click "Create a project"
- Project name: **diprep** (or your preferred name)
- Uncheck "Enable Google Analytics" (optional)
- Click **Create project**
- Wait 2-3 minutes for project to be created

### 1.3 You're now in Firebase Console ✅

---

## STEP 2: Set Up Email/Password Authentication

### 2.1 Navigate to Authentication
1. Left sidebar → **Build** section
2. Click **Authentication**

### 2.2 Enable Email/Password
1. Click **Get Started** (or "Sign-in method")
2. Find **Email/Password** provider
3. Click on it
4. Toggle **Enable** to ON
5. Optionally enable **Email link sign-in**
6. Click **Save**

### Result
✅ Email/Password is now enabled

---

## STEP 3: Create Cloud Firestore Database

### 3.1 Navigate to Firestore
1. Left sidebar → **Build** section
2. Click **Firestore Database** (or **Cloud Firestore**)

### 3.2 Create Database
1. Click **Create Database**
2. Security rules: Choose **Test Mode** (for development)
3. Location: Select **Asia Pacific (Singapore)** (or closest region)
4. Click **Create**
5. Wait for database to be created

### Result
✅ Firestore database is ready

---

## STEP 4: Download iOS Configuration

### 4.1 Get GoogleService-Info.plist
1. Click Settings ⚙️ (top left, next to "Project Overview")
2. Click **Project Settings**
3. Go to **General** tab
4. Scroll to "Your apps" section
5. Find or click the **iOS** app (or add one if needed)
6. Click the download icon next to **GoogleService-Info.plist**

### 4.2 Add to Xcode
1. Open `ios/Runner.xcworkspace` in Xcode
2. Right-click **Runner** folder in sidebar
3. Select **Add Files to "Runner"**
4. Select the downloaded **GoogleService-Info.plist**
5. Check "Copy items if needed"
6. Click **Add**

### 4.3 Verify in Build Phases
1. Select **Runner** project
2. Go to **Build Phases** tab
3. Expand **Copy Bundle Resources**
4. Verify **GoogleService-Info.plist** is listed

### Result
✅ iOS is configured

---

## STEP 5: Download Android Configuration

### 5.1 Get google-services.json
1. Go back to Firebase Console → Settings ⚙️
2. Click **Project Settings**
3. Go to **General** tab
4. Scroll to "Your apps"
5. Find the **Android** app (or add one if needed)
6. Click download icon next to **google-services.json**

### 5.2 Add to Project
1. Copy the downloaded **google-services.json**
2. Paste it into: `android/app/google-services.json`

### 5.3 Verify build.gradle.kts
Check that `android/app/build.gradle.kts` contains:

```gradle
plugins {
    id 'com.google.gms.google-services'
}
```

This should already be there! ✅

### Result
✅ Android is configured

---

## STEP 6: Test Your Setup

### 6.1 Run the App
```bash
cd "c:\Users\Jennifer\Downloads\Dev\DiPrep Latest"
flutter clean
flutter pub get
flutter run
```

### 6.2 Create a Test Account
1. Open the app
2. Go to **Register**
3. Fill in:
   - Name: **John Doe**
   - Email: **john@example.com**
   - Phone: **+63 9171234567** (optional)
   - Location: **Manila, Philippines** (optional)
   - Password: **TestPass123**
4. Click **Create Account**

### 6.3 Check Firebase Console
1. Go to Firebase Console
2. **Authentication** → **Users** tab
3. You should see **john@example.com** listed ✅
4. Go to **Firestore** → **Collections** → **users**
5. Click on the user ID
6. Verify you see the user data:
   ```json
   {
     "name": "John Doe",
     "email": "john@example.com",
     "phone": "+63 9171234567",
     "location": "Manila, Philippines",
     "createdAt": timestamp,
     "updatedAt": timestamp
   }
   ```

### 6.4 Test Login
1. Go back to **Login** screen
2. Enter: **john@example.com** / **TestPass123**
3. Should login successfully ✅

---

## STEP 7: Update Firestore Security Rules (IMPORTANT!)

### 7.1 Go to Firestore Rules
1. Firebase Console → **Firestore Database**
2. Go to **Rules** tab

### 7.2 Replace with Secure Rules
Replace ALL existing rules with:

```firestore
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    // Users collection - only authenticated users can read/write their own data
    match /users/{userId} {
      allow read, write: if request.auth.uid == userId;
      allow create: if request.auth.uid != null;
    }
    
    // Emergency alerts - everyone can read, only authenticated can write
    match /emergencies/{doc=**} {
      allow read: if true;
      allow write: if request.auth != null;
    }
  }
}
```

### 7.3 Publish Rules
Click **Publish** to apply the rules

### Result
✅ Security rules are now protecting your database

---

## Common Issues & Solutions

### "Firebase not initialized"
**Solution:** Firebase initializes automatically in main.dart ✅

### "GoogleService-Info.plist not found"
**Solution:** Make sure you:
1. Downloaded the file from Firebase Console
2. Added it to Xcode (Runner folder)
3. Checked "Copy items if needed"
4. Verified it's in Build Phases → Copy Bundle Resources

### "google-services.json not found"
**Solution:** 
1. Download from Firebase Console
2. Place in `android/app/google-services.json`
3. Verify path is correct

### "Permission denied" when logging in
**Solution:** Update Firestore security rules (Step 7 above)

### "Email already in use"
**Solution:** That email is already registered. Use a different email.

### "Weak password"
**Solution:** Password must be 6+ characters

---

## Verify Everything Works

### Checklist:

- [ ] Firebase project created
- [ ] Email/Password authentication enabled
- [ ] Firestore database created
- [ ] GoogleService-Info.plist added to iOS
- [ ] google-services.json added to Android
- [ ] App builds without errors
- [ ] Can register new account
- [ ] User appears in Firebase Authentication
- [ ] User data appears in Firestore
- [ ] Can login with registered account
- [ ] Security rules updated

If all checkmarks are done, you're ready! ✅

---

## Next Steps

### Recommended:
1. Test more user accounts
2. Test error scenarios (wrong password, etc.)
3. Check Firebase usage in Console
4. Plan for production security

### For Production:
1. Remove Test Mode rules
2. Enable email verification
3. Set up password reset
4. Enable multi-factor authentication
5. Monitor Firebase usage and costs

---

## Support

**All authentication logic is in:**
- `lib/providers/auth_provider.dart` - Core auth logic
- `lib/screens/mobile/login_screen.dart` - Login UI
- `lib/screens/mobile/register_screen.dart` - Register UI

**For questions:**
- Check FIREBASE_AUTH_SETUP.md for detailed API reference
- Check FIREBASE_INTEGRATION_SUMMARY.md for overview
- See Firebase official docs: https://firebase.flutter.dev

---

**You're all set! Your DiPrep app now has enterprise-grade authentication!** 🔥🎉
