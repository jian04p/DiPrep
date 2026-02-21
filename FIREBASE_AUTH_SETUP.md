# Firebase Authentication Setup Guide - DiPrep

## Overview
Your DiPrep app now uses **Firebase Authentication** to securely manage user accounts and **Cloud Firestore** to store user data in the cloud.

## What's Now Integrated
✅ **Firebase Authentication** - Secure email/password login and registration
✅ **Cloud Firestore** - User data stored in database
✅ **Real-time Sync** - User data syncs across all devices
✅ **Production-Ready** - Enterprise-level security

## Step 1: Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com)
2. Click **"Create a project"**
3. Enter project name: `diprep` (or your preferred name)
4. Click **Continue**
5. Disable Google Analytics (optional) and click **Create Project**
6. Wait for project creation to complete

## Step 2: Set Up Authentication

1. In Firebase Console, click **Build** → **Authentication**
2. Click **Get Started**
3. Click **Email/Password**
4. Enable **Email/Password** toggle
5. Enable **Email link sign-in** (optional, for password reset)
6. Click **Save**

## Step 3: Set Up Cloud Firestore

1. In Firebase Console, click **Build** → **Firestore Database**
2. Click **Create Database**
3. Choose region: **Asia Pacific (Singapore)** (or closest to you)
4. Start in **Test Mode** (for development; use Production Rules later)
5. Click **Create**
6. Firestore will create the database

## Step 4: Configure iOS

1. Download **GoogleService-Info.plist** from Firebase Console:
   - Click Settings ⚙️ (top left)
   - Click **Project Settings**
   - Go to **General** tab
   - Click the **iOS** app
   - Download **GoogleService-Info.plist**

2. In Xcode:
   - Open `ios/Runner.xcworkspace`
   - Right-click **Runner** → **Add Files to Runner**
   - Select the downloaded **GoogleService-Info.plist**
   - Check "Copy items if needed"
   - Click **Add**

3. Build phases:
   - Select **Runner** project
   - Go to **Build Phases**
   - Expand **Copy Bundle Resources**
   - Verify **GoogleService-Info.plist** is listed

## Step 5: Configure Android

1. Download **google-services.json**:
   - In Firebase Console, click Settings ⚙️
   - Click **Project Settings**
   - Go to **General** tab
   - Click the **Android** app
   - Download **google-services.json**

2. Copy to project:
   - Place the file in: `android/app/google-services.json`
   - The file is already referenced in `android/app/build.gradle.kts`

3. Verify build.gradle.kts includes:
   ```gradle
   plugins {
       id 'com.google.gms.google-services'
   }
   ```

## Step 6: Update Firestore Security Rules

⚠️ **For Production, Update These Rules!**

1. In Firebase Console → **Firestore Database** → **Rules** tab
2. Replace default rules with:

```firestore
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    // Users collection - only own data
    match /users/{userId} {
      allow read, write: if request.auth.uid == userId;
      allow create: if request.auth.uid != null;
    }
    
    // Public data (optional)
    match /emergencies/{doc=**} {
      allow read: if true;
      allow write: if request.auth != null;
    }
  }
}
```

3. Click **Publish** to apply rules

## Step 7: Test Authentication

Run the app:

```bash
flutter clean
flutter pub get
flutter run
```

### Create a Test Account:
1. Go to **Register** screen
2. Enter:
   - Name: Test User
   - Email: test@example.com
   - Phone: (optional)
   - Location: (optional)
   - Password: Test@123!

3. Click **Create Account**
4. Check Firebase Console → **Authentication** to see new user

### View User Data:
1. Go to Firebase Console → **Firestore Database**
2. Navigate to **Collections** → **users**
3. Click on the user ID
4. See stored data:
   ```
   name: Test User
   email: test@example.com
   phone: (if provided)
   location: (if provided)
   createdAt: timestamp
   updatedAt: timestamp
   ```

## User Data Structure

Each user is stored in Firestore with:

```json
{
  "name": "User Full Name",
  "email": "user@example.com",
  "phone": "+63 9XX XXX XXXX",
  "location": "City, Region",
  "createdAt": "2024-02-09 16:30:45",
  "updatedAt": "2024-02-09 16:30:45"
}
```

## Features Now Available

### Login Screen
- Real email/password validation
- Firebase authentication
- Error messages for:
  - User not found
  - Wrong password
  - Network errors
  - Account disabled

### Register Screen
- Full user registration with Firebase
- Phone and location optional fields
- Password strength validation (6+ characters)
- Email uniqueness check
- Automatic Firestore user profile creation

### User Data
- Stored securely in Cloud Firestore
- Synced across all user devices
- Accessible from home screen via `context.read<AuthProvider>().user`

## API Reference

### Login
```dart
await authProvider.login(email, password);
// Returns: bool (success/failure)
// Error: authProvider.authError (string with error message)
```

### Register
```dart
await authProvider.register(
  name,
  email,
  password,
  phone: phone,        // optional
  location: location,  // optional
);
// Returns: bool (success/failure)
// Error: authProvider.authError (string with error message)
```

### Logout
```dart
await authProvider.logout();
// Clears local storage and signs out
```

### Get Current User
```dart
final user = authProvider.user;
// Returns: User? (null if not logged in)
// Access: user?.name, user?.email, user?.phone, user?.location
```

## Error Handling

The app handles these Firebase errors:

| Error | Message |
|-------|---------|
| Invalid email | "Invalid email address" |
| User not found | "User not found" |
| Wrong password | "Wrong password" |
| Weak password | "Password is too weak" |
| Email in use | "Email already registered" |
| Network error | "Network error. Check connection" |

## Database Queries (Advanced)

### Get Specific User
```dart
final doc = await FirebaseFirestore.instance
    .collection('users')
    .doc(userId)
    .get();
```

### List All Users (requires Rules update)
```dart
final snapshot = await FirebaseFirestore.instance
    .collection('users')
    .get();
```

### Real-time Updates
```dart
FirebaseFirestore.instance
    .collection('users')
    .doc(userId)
    .snapshots()
    .listen((doc) {
      // Handle real-time updates
    });
```

## Troubleshooting

### "Firebase not initialized"
- Ensure `firebase_core` is initialized in `main.dart`
- Already configured ✅

### "Authentication disabled"
- Go to Firebase Console → Authentication
- Enable Email/Password provider

### "Firestore not found"
- Go to Firebase Console → Firestore Database
- Create database (use Test Mode for development)

### "User not found during login"
- Create user first via Register screen
- Check Firebase Console → Authentication to verify user exists

### "Permission denied" on Firestore
- Go to Firestore → Rules
- Use the rules provided above
- Ensure `request.auth.uid == userId` for security

## Next Steps

### For Production:
1. **Enable Email Verification**
   - Firebase Console → Authentication → Email Templates
   - Configure verification email

2. **Add Password Reset**
   - Firebase Console → Authentication → Email Templates
   - Configure password reset email

3. **Enable Additional Providers**
   - Google Sign-In
   - Phone Authentication
   - Apple Sign-In (iOS only)

4. **Update Security Rules**
   - Use Production Rules (not Test Mode)
   - Implement proper role-based access

5. **Set Up Backup**
   - Enable Firestore backups
   - Configure retention policy

### For Development:
- Keep using Test Mode for Firestore
- Test error scenarios
- Monitor Firebase usage in Console

## Useful Links

- [Firebase Console](https://console.firebase.google.com)
- [Firebase Auth Documentation](https://firebase.flutter.dev/docs/auth/overview/)
- [Firestore Documentation](https://firebase.flutter.dev/docs/firestore/overview/)
- [Firebase Security Rules](https://firebase.google.com/docs/firestore/security/start)

## Security Notes

✅ **What's Secure:**
- Passwords hashed by Firebase
- Data encrypted in transit (SSL/TLS)
- User can only access own data
- Authentication required for Firestore access

⚠️ **To Improve Security:**
- Update Firestore rules for production
- Enable email verification
- Implement rate limiting (Firebase allows this)
- Add multi-factor authentication
- Use environment variables for API keys

---

**Your app is now connected to Firebase!** 🔥

Users can create real accounts, and their data is stored securely in the cloud.

