# 🔗 Firebase Setup - Complete Connection Guide

## ✅ App Status: Ready to Build

Your app is now configured to build with or without Firebase. The app will:
- ✅ Build successfully even without google-services.json
- ✅ Run the UI and all features
- ⏳ SOS feature requires Firebase to send location data to Firestore

---

## 🚀 Step-by-Step Firebase Connection

### STEP 1: Go to Firebase Console

**URL**: https://console.firebase.google.com

1. Sign in with your Google account (create one if needed)
2. Click **"Add project"** or select existing project
3. Enter project name: `diprep-flutter` (or your choice)
4. Click **"Create project"** (takes 2-3 minutes)

---

### STEP 2: Create Firestore Database

Once project is created:

1. Left sidebar → **Build** → **Firestore Database**
2. Click **"Create Database"**
3. Choose **Start in test mode** (for development)
4. Select region: **us-central1** (or closest to you)
5. Click **"Create"**

**Important**: Test mode allows unrestricted access during development. You'll secure it later.

---

### STEP 3: Add Android App to Firebase

1. In Firebase Console, click **gear icon** (Project Settings)
2. Click **"Add app"** → Android icon
3. Enter:
   - **Android package name**: `com.example.diprep_flutter`
   - (Found in: `android/app/build.gradle.kts` → `applicationId`)
4. Click **"Register app"**
5. **Download** `google-services.json`
6. **Save** to: `android/app/google-services.json`
   - Replace the existing placeholder file

---

### STEP 4: Download Config Files

After registration, Firebase provides download links:

**For Android**:
- ✅ Already doing this above

**For iOS (Optional but recommended)**:
1. Back to Firebase Project Settings
2. Click **"Add app"** → iOS icon
3. Enter:
   - **iOS bundle ID**: Find in Xcode or in `ios/Runner.xcodeproj`
   - **App Store ID**: Leave blank for now
4. Download **GoogleService-Info.plist**
5. Place at: `ios/Runner/GoogleService-Info.plist`

---

### STEP 5: Set Firestore Security Rules

In Firebase Console:

1. **Firestore Database** → **Rules** tab
2. Replace all content with:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Allow authenticated users to read/write their own emergency data
    match /emergencies/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

3. Click **"Publish"**

**Note**: This requires Firebase Authentication. For quick testing without auth:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /emergencies/{userId} {
      // Allow all for testing - REMOVE IN PRODUCTION!
      allow read, write: if true;
    }
  }
}
```

---

### STEP 6: Enable Authentication (Optional but Recommended)

To properly secure your data:

1. **Authentication** → **Get started**
2. Enable **Email/Password** provider
3. Create a test user for testing

Then use proper security rules from Step 5.

---

### STEP 7: Rebuild App with Firebase

```bash
# Navigate to project
cd "c:\Users\Jennifer\Downloads\Dev\DiPrep Latest"

# Clean cache
flutter clean

# Get fresh dependencies
flutter pub get

# Build and run
flutter run
```

---

## 🧪 Testing the SOS Feature

Once Firebase is connected:

1. **App launches** → Navigate to **Home Screen**
2. **See SOS Button** → Large red pulsing button
3. **Tap SOS Button** → Permission explanation dialog
4. **Grant Permission** → "Always" for background location
5. **Button pulses** → Status shows "SOS ACTIVE"
6. **Check Firestore**:
   - Open Firebase Console
   - Go to **Firestore Database** → **emergencies** collection
   - See document with userId
   - Watch for updates every 10 seconds with new GPS coordinates
7. **Background Test**:
   - Activate SOS
   - Press phone home button (app goes to background)
   - Wait 10+ seconds
   - Check Firestore → should still see updates
8. **Deactivate SOS**:
   - Tap button again
   - Confirm deactivation
   - Check Firestore → status changes to "inactive"

---

## 📊 Firestore Data Structure

What you'll see in Firestore:

```
emergencies (collection)
├── user123 (document - one per user)
│   ├── latitude: -33.8688 (number)
│   ├── longitude: 151.2093 (number)
│   ├── timestamp: Jan 23, 2026, 10:30:00 (timestamp)
│   ├── status: "active" (string)
│   ├── accuracy: 5.0 (number)
│   ├── altitude: 100.0 (number)
│   ├── speed: 0.0 (number)
│   ├── heading: 0.0 (number)
│   └── endedAt: Jan 23, 2026, 10:40:00 (timestamp - when stopped)
```

Updates happen every 10 seconds while SOS is active.

---

## 🔐 Security Rules Summary

| Rule | Allows | Use Case |
|------|--------|----------|
| `allow if request.auth != null && request.auth.uid == userId` | Only authenticated user can access their data | Production (secure) |
| `allow if true` | Anyone can read/write | Testing/Development only |
| `allow if request.auth != null` | Any authenticated user | Shared emergency data |

---

## 📱 Required Device Settings

For SOS to work on user's phone:

**Android**:
1. Settings → Apps → DiPrep
2. Permissions → Location → **Allow all the time**
3. Settings → Location → **On** (High Accuracy)

**iOS**:
1. Settings → DiPrep → Location → **Always**
2. Settings → Privacy → Location Services → **On**

---

## 🆘 Troubleshooting Firebase Connection

### Build Error: "google-services.json missing"
- ✅ FIXED: App now builds without it
- Download real `google-services.json` from Firebase to enable SOS

### Error: "MissingPluginException"
```bash
flutter clean
flutter pub get
flutter run
```

### Error: "Permission denied" (Firestore)
- Check Firebase security rules are published
- Ensure user is authenticated (if using auth)
- Or temporarily use `allow if true` for testing

### GPS not updating in Firestore
- Check app has "Always" location permission
- Ensure device location services are ON
- Check device is outdoors (GPS needs sky view)
- Wait 30-60 seconds for first GPS lock

### Can't see Firestore documents
- Check you're in correct Firebase project
- Look in `emergencies` collection
- Document ID should be the userId

---

## 📝 Files You'll Modify

After downloading from Firebase:

1. **`android/app/google-services.json`** ← Download from Firebase
   - Replace the placeholder file

2. **`ios/Runner/GoogleService-Info.plist`** ← Download from Firebase (optional)
   - Place in `ios/Runner/`

3. **Firebase Console** → Firestore Rules
   - Publish your security rules

That's it! No code changes needed.

---

## ✨ Next Steps

1. **Complete Steps 1-5** (takes ~10 minutes)
2. **Download google-services.json**
3. **Place** in `android/app/`
4. **Run** `flutter run`
5. **Test** SOS feature
6. **Monitor** Firestore for location updates

---

## 🎯 Success Indicators

You'll know it's working when:

✅ App builds without errors  
✅ Home screen displays SOS button  
✅ Tapping SOS shows permission dialog  
✅ Permission granted → button pulses  
✅ Firestore shows `emergencies/{userId}` document  
✅ Document updates every 10 seconds  
✅ App can be closed, updates continue  
✅ Tapping again deactivates SOS  

---

**You're almost there!** Just 5 Firebase steps and you'll have a fully operational emergency broadcast system. 🚀
