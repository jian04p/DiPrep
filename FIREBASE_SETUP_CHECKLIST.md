# ✅ Firebase Setup Checklist

## Current Status: 🟡 FIREBASE CONFIGURATION REQUIRED

Your app is integrated and ready, but requires Firebase configuration files to enable the SOS feature.

## ✅ Completed Steps

- [x] Dependencies installed
- [x] Firebase initialized in main.dart
- [x] SOS button added to HomeScreen
- [x] Android permissions configured
- [x] iOS permissions configured
- [x] Google services plugin added
- [x] Service files created

## 🔴 Required: Firebase Configuration

### Step 1: Create Firebase Project

1. Go to https://console.firebase.google.com
2. Click **"Add project"** or select existing project
3. Follow the setup wizard
4. Enable **Firestore Database**:
   - Go to Build → Firestore Database
   - Click "Create database"
   - Start in **test mode** (for development)
   - Choose your region

### Step 2: Add Android App

1. In Firebase Console, click **"Add app"** → Android icon
2. Enter package name: `com.example.diprep_flutter`
   - (Found in: `android/app/build.gradle.kts`)
3. Download **google-services.json**
4. Place it at: `android/app/google-services.json`
5. Delete the example file: `android/app/google-services.json.example`

### Step 3: Add iOS App (Optional - for iOS testing)

1. In Firebase Console, click **"Add app"** → iOS icon
2. Enter bundle ID (find in Xcode project)
3. Download **GoogleService-Info.plist**
4. Place it at: `ios/Runner/GoogleService-Info.plist`
5. Delete the example file: `ios/Runner/GoogleService-Info.plist.example`

### Step 4: Configure Firestore Security Rules

1. In Firebase Console → Firestore Database → Rules
2. Replace with:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Allow authenticated users to read/write their own emergency data
    match /emergencies/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // For testing without auth (REMOVE in production!)
    // match /emergencies/{userId} {
    //   allow read, write: if true;
    // }
  }
}
```

3. Click **"Publish"**

**Note**: For development/testing without Firebase Auth, you can temporarily use the testing rule (commented out above).

### Step 5: Test the Integration

```bash
# Clean build
flutter clean

# Get dependencies
flutter pub get

# Run on device (physical device required for GPS)
flutter run
```

## 🧪 Testing Checklist

Once Firebase is configured:

- [ ] App launches without errors
- [ ] Navigate to Home screen
- [ ] SOS button is visible
- [ ] Tap SOS button
- [ ] Permission explanation dialog appears
- [ ] Grant "Always" location permission
- [ ] SOS activates (button pulses, shows "SOS ACTIVE")
- [ ] Check Firestore Console - see `emergencies/{userId}` document
- [ ] Document updates every 10 seconds with new GPS coordinates
- [ ] Lock phone - verify updates continue in background
- [ ] Tap button again to deactivate
- [ ] Document status changes to "inactive"

## 🚨 Current App Features

The SOS feature is now integrated into your home screen:

**Location**: `lib/screens/mobile/home_screen.dart`

- Large pulsing red button
- Automatically requests permissions
- Shows explanation dialogs
- Provides visual feedback
- Integrated with your existing AuthProvider

**How to access**:
1. Launch app
2. Login
3. Navigate to Home screen
4. SOS button appears at the top of the screen

## 📱 Quick Commands

```bash
# Run the app
flutter run

# Build for release (Android)
flutter build apk --release

# Build for release (iOS)
flutter build ios --release

# Check for issues
flutter doctor

# View logs
flutter logs
```

## ⚠️ Important Notes

1. **Physical Device Required**: GPS and background services don't work well on emulators
2. **Location Services**: Must be enabled on device
3. **Firebase Setup**: App will run but SOS feature requires Firebase
4. **First GPS Fix**: May take 30-60 seconds outdoors for accurate location
5. **Battery Usage**: Background GPS tracking consumes battery - inform users

## 🆘 If You See Errors

### "MissingPluginException"
```bash
flutter clean
flutter pub get
flutter run
```

### "Firebase not initialized"
- Check `google-services.json` exists in `android/app/`
- Verify package name matches in Firebase Console

### "Permission denied"
- Go to device Settings → Apps → DiPrep
- Ensure Location is set to "Allow all the time"

### "No location updates"
- Check device location services are ON
- Ensure GPS is enabled (High Accuracy mode)
- Go outdoors for better satellite reception

## 📞 Next Steps

After Firebase is configured:

1. Test SOS feature thoroughly
2. Adjust GPS update interval if needed (currently 10s)
3. Customize button appearance/position
4. Add emergency contacts notification
5. Implement analytics tracking
6. Add crash reporting (Firebase Crashlytics)

---

**Status**: Ready for Firebase configuration 🚀

Once you add the Firebase config files, your SOS emergency feature will be fully operational!
