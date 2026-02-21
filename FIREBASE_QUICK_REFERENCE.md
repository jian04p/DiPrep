# 🚀 Firebase Setup - Quick Reference Card

## 5-Minute Quick Start

### 1. Create Firebase Project
```
https://console.firebase.google.com
→ Create project → Name: diprep
```

### 2. Enable Authentication
```
Build → Authentication → Email/Password → Enable → Save
```

### 3. Create Firestore
```
Build → Firestore Database → Create → Test Mode → Asia Pacific (Singapore) → Create
```

### 4. Download Config Files
```
Settings ⚙️ → Project Settings → General
- iOS: Download GoogleService-Info.plist
- Android: Download google-services.json
```

### 5. Add to Project
```
iOS: Add to Xcode → Runner folder (Check "Copy items if needed")
Android: Place in android/app/google-services.json
```

### 6. Run App
```bash
flutter clean
flutter pub get
flutter run
```

### 7. Test It
```
Register → john@example.com / TestPass123
Check Firebase Console for user
Login → Should work ✅
```

---

## Common Commands

### Clean & Reset
```bash
flutter clean
flutter pub get
flutter pub get  # Run twice if first time
```

### Run App
```bash
flutter run                    # Default device
flutter run -d windows        # Windows
flutter run -d 089112526E002614  # Specific device
```

### Analyze Code
```bash
flutter analyze
flutter analyze lib/providers/auth_provider.dart
```

---

## Firebase Console Navigation

```
Console
├── Project Overview
├── Build
│   ├── Authentication ◄── Go here first!
│   ├── Firestore Database ◄── Create database
│   ├── Cloud Functions
│   ├── Hosting
│   └── ...
├── Settings ⚙️ ◄── Download config files
└── Release
```

---

## Key Files

| File | Purpose | Status |
|------|---------|--------|
| `lib/providers/auth_provider.dart` | Auth logic | ✅ Ready |
| `lib/screens/mobile/login_screen.dart` | Login UI | ✅ Ready |
| `lib/screens/mobile/register_screen.dart` | Register UI | ✅ Ready |
| `pubspec.yaml` | Dependencies | ✅ firebase_auth added |
| `FIREBASE_AUTH_SETUP.md` | Full guide | ✅ Complete |
| `FIREBASE_SETUP_STEPS.md` | Step-by-step | ✅ Complete |

---

## Code Usage

### Login
```dart
final success = await authProvider.login(
  'john@example.com',
  'password123'
);
```

### Register
```dart
final success = await authProvider.register(
  'John Doe',
  'john@example.com',
  'password123',
  phone: '+63 9171234567',
  location: 'Manila'
);
```

### Get User
```dart
final user = authProvider.user;
print(user?.name);
print(user?.email);
```

### Check Auth Status
```dart
if (authProvider.isAuthenticated) {
  // User is logged in
}
```

### Get Error
```dart
final error = authProvider.authError;
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(content: Text(error ?? 'Error'))
);
```

---

## Firestore Security Rules

### Replace ALL existing rules with:

```firestore
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth.uid == userId;
      allow create: if request.auth.uid != null;
    }
    match /emergencies/{doc=**} {
      allow read: if true;
      allow write: if request.auth != null;
    }
  }
}
```

---

## Troubleshooting Quick Fixes

### "Firebase not initialized"
→ Already done in main.dart ✅

### App won't run
→ `flutter clean && flutter pub get && flutter run`

### Authentication fails
→ Check Firestore Rules are published

### User not found
→ User doesn't exist - Register first

### Permissions denied
→ Update Firestore Rules (see above)

### GoogleService-Info.plist missing (iOS)
→ Download from Settings → Add to Xcode

### google-services.json missing (Android)
→ Download from Settings → Place in android/app/

---

## What's Integrated

✅ Firebase Auth (Email/Password)
✅ Cloud Firestore (User Database)
✅ Registration with validation
✅ Login with error handling
✅ User profile storage
✅ Security rules
✅ Error messages
✅ Auto-login after register
✅ Password hashing
✅ Session management

---

## Test Accounts

### Example 1:
```
Name: Test User
Email: test@example.com
Phone: +63 9171234567
Location: Manila, Philippines
Password: Test@123!
```

### Example 2:
```
Name: Jennifer Santos
Email: jennifer@example.com
Phone: +63 917 555 1234
Location: Pasig, Metro Manila
Password: Secure@123
```

---

## Before Going Live

- [ ] Firebase project created
- [ ] Auth enabled
- [ ] Firestore created
- [ ] Config files added
- [ ] Security rules updated
- [ ] Test account registered
- [ ] Login works
- [ ] User data in Firestore
- [ ] App tested on device
- [ ] No hardcoded credentials
- [ ] Errors handled gracefully

---

## Important Links

```
Firebase Console: https://console.firebase.google.com
Auth Docs: https://firebase.flutter.dev/docs/auth/overview/
Firestore Docs: https://firebase.flutter.dev/docs/firestore/overview/
Rules Guide: https://firebase.google.com/docs/firestore/security/start
```

---

## Performance Notes

### Free Tier Limits (Firebase)
- 50,000 reads/day
- 20,000 writes/day
- 1GB storage
- Perfect for development/testing
- Scales as you grow

### Best Practices
- Cache user data locally
- Batch Firestore queries
- Use security rules for filtering
- Monitor usage in Console

---

## Next Steps

1. **Right Now**: Follow FIREBASE_SETUP_STEPS.md
2. **Today**: Test register and login
3. **This Week**: Add password reset email
4. **Next**: Add Google Sign-In provider

---

## Questions?

**Everything you need is here:**
1. FIREBASE_CONNECTION_README.md (overview)
2. FIREBASE_INTEGRATION_SUMMARY.md (what changed)
3. FIREBASE_AUTH_SETUP.md (detailed setup)
4. FIREBASE_SETUP_STEPS.md (step-by-step)

**Or visit:**
- Firebase Console
- Flutter Firebase Docs
- Stack Overflow (tag: firebase)

---

**You're ready to go! Follow FIREBASE_SETUP_STEPS.md next.** ✅🔥

Last Updated: February 9, 2024
Version: 1.0 - Complete
