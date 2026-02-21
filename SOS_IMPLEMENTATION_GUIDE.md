# SOS Emergency Feature - Implementation Guide

## 🚨 Overview

This high-reliability "One-Tap SOS" feature provides background GPS tracking and emergency broadcasting for Flutter applications on Android 15/16 and iOS.

## ✅ Completed Deliverables

### 1. **sos_manager.dart** - Background Service Logic
**Location**: `lib/services/sos_manager.dart`

**Features**:
- ✅ Background persistence using `flutter_background_service`
- ✅ GPS tracking every 10 seconds using `geolocator`
- ✅ Firestore integration writing to `emergencies/{userId}`
- ✅ Automatic retry logic with exponential backoff (3 attempts)
- ✅ Android 15/16 foreground service with location type
- ✅ iOS background location tracking
- ✅ Permission handling for location and notifications

**Data Schema**:
```dart
{
  'latitude': double,
  'longitude': double,
  'timestamp': Timestamp,
  'status': 'active' | 'inactive',
  'accuracy': double,
  'altitude': double,
  'speed': double,
  'heading': double,
  'endedAt': Timestamp (when stopped)
}
```

### 2. **pulsing_sos_button.dart** - Animated Widget
**Location**: `lib/widgets/pulsing_sos_button.dart`

**Features**:
- ✅ Large circular button (200x200)
- ✅ Pulsing animation using `AnimationController`
- ✅ Permission explanation dialog
- ✅ Visual feedback for active/inactive states
- ✅ Loading indicator during state changes
- ✅ Error handling with user-friendly messages
- ✅ Deactivation confirmation dialog

### 3. **AndroidManifest.xml** Configuration
**Location**: `android/app/src/main/AndroidManifest.xml`

**Added Permissions**:
```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
<uses-permission android:name="android.permission.ACCESS_BACKGROUND_LOCATION"/>
<uses-permission android:name="android.permission.FOREGROUND_SERVICE"/>
<uses-permission android:name="android.permission.FOREGROUND_SERVICE_LOCATION"/>
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
<uses-permission android:name="android.permission.WAKE_LOCK"/>
```

**Service Declaration**:
```xml
<service
    android:name="id.flutter.flutter_background_service.BackgroundService"
    android:exported="false"
    android:foregroundServiceType="location">
</service>
```

### 4. **Info.plist** Configuration
**Location**: `ios/Runner/Info.plist`

**Added Keys**:
```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>DiPrep needs your location to broadcast your position during emergencies when you activate SOS.</string>

<key>NSLocationAlwaysUsageDescription</key>
<string>DiPrep requires background location access to continuously broadcast your position during active SOS emergencies, even when the app is closed.</string>

<key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
<string>DiPrep needs access to your location at all times to provide emergency SOS tracking.</string>

<key>UIBackgroundModes</key>
<array>
    <string>location</string>
    <string>fetch</string>
    <string>processing</string>
</array>
```

## 📦 Dependencies Added

Updated `pubspec.yaml` with:
```yaml
flutter_background_service: ^5.0.5
geolocator: ^11.0.0
permission_handler: ^11.3.0
cloud_firestore: ^4.15.0
firebase_core: ^2.27.0
```

## 🚀 Quick Start

### Step 1: Install Dependencies
```bash
flutter pub get
```

### Step 2: Setup Firebase
1. Create a Firebase project at https://console.firebase.google.com
2. Add your Android app (package name from `android/app/build.gradle.kts`)
3. Download `google-services.json` → place in `android/app/`
4. Add your iOS app (bundle ID from Xcode)
5. Download `GoogleService-Info.plist` → place in `ios/Runner/`

### Step 3: Configure Firebase in Your App

Update your `android/build.gradle.kts`:
```kotlin
dependencies {
    classpath("com.google.gms:google-services:4.4.0")
}
```

Update your `android/app/build.gradle.kts`:
```kotlin
plugins {
    id("com.google.gms.google-services")
}
```

### Step 4: Initialize Firebase in main.dart

```dart
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}
```

### Step 5: Use the SOS Button

```dart
import 'package:diprep_flutter/widgets/pulsing_sos_button.dart';

// In your widget:
PulsingSosButton(
  userId: currentUser.id, // Your user ID
  onSosActivated: () {
    print('Emergency broadcast started');
  },
  onSosDeactivated: () {
    print('Emergency broadcast stopped');
  },
)
```

## 🔧 How It Works

### Permission Flow
1. User taps SOS button
2. Explanation dialog appears
3. User accepts → system permission request
4. If denied → settings dialog with "Open Settings" option
5. If granted → service starts

### Background Service Flow
1. Service initializes as foreground service
2. GPS position retrieved every 10 seconds
3. Position written to Firestore
4. On network failure → exponential backoff retry (3 attempts)
5. Notification shows current lat/lng or error state

### Reliability Features
- **Retry Logic**: 3 attempts with 2s, 4s, 8s delays
- **Foreground Service**: Won't be killed by Android
- **Background Modes**: iOS keeps service alive
- **High Accuracy GPS**: Uses `LocationAccuracy.high`
- **Error Handling**: User-friendly error messages
- **State Management**: Prevents duplicate service instances

## 📱 Testing Guide

### Android Testing
```bash
# Build and run
flutter run

# Check foreground service notification
# Should see persistent "SOS Active" notification

# Test in background
# 1. Activate SOS
# 2. Press home button
# 3. Check Firestore - updates should continue every 10s

# Test permissions
adb shell pm revoke <your.package.name> android.permission.ACCESS_FINE_LOCATION
# Then retest - should show permission dialog
```

### iOS Testing
```bash
# Run on device (simulator won't show location permissions correctly)
flutter run -d <your-device-id>

# Test background location:
# 1. Activate SOS
# 2. Swipe up and close app
# 3. Check Firestore for continued updates
# 4. Check Settings > Privacy > Location Services > DiPrep
#    Should see "Always" selected
```

### Firestore Testing
1. Open Firebase Console
2. Navigate to Firestore Database
3. Look for collection: `emergencies`
4. Document ID will be your userId
5. Watch for real-time updates every 10 seconds

## 🛡️ Security Considerations

1. **Firestore Rules**: Add security rules to restrict access
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /emergencies/{userId} {
      // Only authenticated user can read/write their own emergency data
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

2. **User Authentication**: Ensure userId is from authenticated user
3. **Data Privacy**: Location data is sensitive - inform users clearly
4. **Battery Usage**: Warn users about battery consumption

## 🐛 Troubleshooting

### "Service not starting"
- Check if Firebase is initialized
- Verify permissions in AndroidManifest.xml and Info.plist
- Check device location services are enabled

### "Permission denied"
- Ensure background location permission is granted
- On Android 11+, request background permission separately
- Check app settings for "Allow all the time"

### "Firestore write failing"
- Verify Firebase configuration files are present
- Check internet connectivity
- Review Firestore security rules
- Check Firebase quota limits

### "GPS not accurate"
- Ensure device has clear sky view
- Wait for GPS to lock (first fix can take 30-60s)
- Check location services mode is "High accuracy"

## 📊 Monitoring

Monitor SOS broadcasts in Firestore Console:
```
emergencies/{userId}
├── latitude: -33.8688
├── longitude: 151.2093
├── timestamp: Jan 23, 2026 10:30:00
├── status: "active"
├── accuracy: 5.0
└── ... other fields
```

## 🔄 Future Enhancements

Possible improvements:
- [ ] Add geofencing for automatic SOS deactivation
- [ ] Battery optimization modes
- [ ] Offline queuing of location updates
- [ ] Emergency contact notification
- [ ] Audio/video recording during SOS
- [ ] Integration with emergency services APIs
- [ ] Historical SOS event tracking
- [ ] Analytics dashboard for SOS usage

## 📝 License & Support

For production use:
1. Test thoroughly on physical devices
2. Implement comprehensive error logging
3. Add analytics to track SOS activations
4. Consider legal requirements for emergency features
5. Ensure compliance with location data regulations (GDPR, CCPA, etc.)

---

**Built with ❤️ for emergency response reliability**
