# 🚨 SOS Feature - Quick Reference

## File Structure
```
lib/
├── services/
│   └── sos_manager.dart          # Background service logic
├── widgets/
│   └── pulsing_sos_button.dart   # Animated SOS button
└── examples/
    └── sos_example.dart          # Usage example

android/app/src/main/
└── AndroidManifest.xml           # Android permissions & service config

ios/Runner/
└── Info.plist                    # iOS permissions & background modes
```

## Quick Integration (3 Steps)

### 1️⃣ Initialize Firebase (main.dart)
```dart
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}
```

### 2️⃣ Add Button to Your Screen
```dart
import 'package:diprep_flutter/widgets/pulsing_sos_button.dart';

PulsingSosButton(
  userId: 'user123', // Replace with actual user ID
  onSosActivated: () => print('SOS ON'),
  onSosDeactivated: () => print('SOS OFF'),
)
```

### 3️⃣ Run
```bash
flutter pub get
flutter run
```

## Key Features ✨

| Feature | Implementation |
|---------|---------------|
| **GPS Interval** | 10 seconds |
| **Retry Logic** | 3 attempts, exponential backoff |
| **Firestore Path** | `emergencies/{userId}` |
| **Animation** | Pulsing scale (1.0 → 1.15) |
| **Permissions** | Auto-requested with explanation |
| **Platform Support** | Android 15/16, iOS |

## Firestore Document Structure
```javascript
{
  latitude: -33.8688,
  longitude: 151.2093,
  timestamp: Timestamp,
  status: "active",
  accuracy: 5.0,
  altitude: 100.0,
  speed: 0.0,
  heading: 0.0
}
```

## Permission Handling

### Android
- Runtime permission dialogs
- "Allow all the time" required for background
- Falls back to app settings if denied

### iOS
- Explanation shown before system prompt
- Requires "Always" permission
- Background modes enabled automatically

## Testing Checklist ✅

- [ ] Dependencies installed (`flutter pub get`)
- [ ] Firebase configured (google-services.json, GoogleService-Info.plist)
- [ ] Firebase initialized in main.dart
- [ ] Test on physical device (not simulator)
- [ ] Grant "Always" location permission
- [ ] Activate SOS → check Firestore updates
- [ ] Lock phone → verify background updates continue
- [ ] Test poor signal → verify retry logic
- [ ] Deactivate SOS → verify status='inactive'

## Troubleshooting 🔧

| Issue | Solution |
|-------|----------|
| Service won't start | Check Firebase initialization |
| Permission denied | Grant "Always" in app settings |
| No Firestore updates | Check internet & Firebase rules |
| GPS inaccurate | Wait 60s for GPS lock outdoors |
| Build errors | Run `flutter clean && flutter pub get` |

## Security Rules (Firestore)
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /emergencies/{userId} {
      allow read, write: if request.auth.uid == userId;
    }
  }
}
```

## Next Steps 🎯

1. Setup Firebase project
2. Download config files
3. Add to `android/app/` and `ios/Runner/`
4. Test on physical device
5. Configure Firestore security rules
6. Deploy! 🚀

---

**For full documentation**: See [SOS_IMPLEMENTATION_GUIDE.md](SOS_IMPLEMENTATION_GUIDE.md)
