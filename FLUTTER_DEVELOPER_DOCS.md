# 📱 DiPrep Flutter Developer Documentation

## Complete Technical Specifications for Flutter Rebuild

---

## 📋 Table of Contents

1. [Project Overview](#project-overview)
2. [Architecture Specifications](#architecture-specifications)
3. [UI Design System](#ui-design-system)
4. [Feature Specifications](#feature-specifications)
5. [Screen Specifications](#screen-specifications)
6. [Data Flow & State Management](#data-flow--state-management)
7. [API Integration Guide](#api-integration-guide)
8. [Testing Requirements](#testing-requirements)
9. [Performance Benchmarks](#performance-benchmarks)
10. [Deployment Checklist](#deployment-checklist)

---

## 1. Project Overview

### App Summary
**DiPrep** is a dual-interface emergency alert system with:
- **Mobile App**: End-user interface for receiving alerts and accessing emergency resources
- **Admin Portal**: Management interface for coordinators to create alerts and manage system

### Target Platforms
- **Primary**: iOS 13+, Android 8+ (API 26+)
- **Future**: Web (Flutter Web), Desktop (Windows/macOS/Linux)

### Tech Stack Requirements
```yaml
Flutter SDK: >=3.10.0
Dart SDK: >=3.0.0
State Management: Provider (recommended) or Riverpod
Backend: Supabase/Firebase (future integration)
Maps: Google Maps Flutter
Storage: SharedPreferences + Secure Storage
```

---

## 2. Architecture Specifications

### High-Level Architecture

```
┌─────────────────────────────────────────────────────┐
│                    main.dart                        │
│              (App Entry Point)                      │
└────────────────┬────────────────────────────────────┘
                 │
         MultiProvider Setup
         │                │
┌────────▼────────┐ ┌────▼──────────┐
│  MobileApp      │ │   AdminApp    │
│  (Stateful)     │ │   (Stateful)  │
└────────┬────────┘ └────┬──────────┘
         │               │
      13 Screens      7 Screens
```

### Recommended Folder Structure

```
lib/
├── core/
│   ├── constants/
│   │   ├── app_constants.dart
│   │   ├── api_constants.dart
│   │   └── storage_keys.dart
│   ├── theme/
│   │   ├── app_colors.dart
│   │   ├── app_theme.dart
│   │   └── text_styles.dart
│   └── utils/
│       ├── validators.dart
│       └── formatters.dart
├── data/
│   ├── models/
│   ├── repositories/
│   └── services/
├── domain/
│   ├── providers/
│   └── use_cases/
└── presentation/
    ├── screens/
    └── widgets/
```

---

## 3. UI Design System

### Color Palette

```dart
class AppColors {
  // Primary
  static const Color primary = Color(0xFF2563EB);      // Blue-600
  static const Color primaryLight = Color(0xFF3B82F6); // Blue-500
  static const Color primaryDark = Color(0xFF1D4ED8);  // Blue-700

  // Alert Severity
  static const Color critical = Color(0xFFDC2626);    // Red-600 🔴
  static const Color high = Color(0xFFEA580C);        // Orange-600 🟠
  static const Color medium = Color(0xFFEAB308);      // Yellow-500 🟡
  static const Color low = Color(0xFF16A34A);         // Green-600 🟢
  static const Color info = Color(0xFF2563EB);        // Blue-600 🔵

  // Neutrals
  static const Color gray50 = Color(0xFFF9FAFB);
  static const Color gray900 = Color(0xFF111827);
}
```

### Typography Scale

```dart
class TextStyles {
  static const TextStyle h1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    height: 1.2,
  );
  
  static const TextStyle h2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    height: 1.3,
  );
  
  static const TextStyle body = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    height: 1.5,
  );
  
  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    height: 1.4,
  );
}
```

### Spacing Scale

```dart
class Spacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;
}
```

---

## 4. Feature Specifications

### Core Features (Priority Order)

1. **Authentication** - Login, Registration, Session Management
2. **Notifications** - Real-time alerts with priority levels
3. **Maps** - Incident visualization with markers
4. **Hotlines** - Quick access to emergency numbers
5. **Safety Guidelines** - Categorized emergency procedures
6. **User Profile** - Personal information management
7. **Settings** - Preferences and permissions
8. **Dark Mode** - System theme support
9. **History** - Activity logs and archive
10. **Admin Dashboard** - Management and analytics

---

## 5. Screen Specifications

### Mobile Screens (13 Total)

#### Auth Flow (4 screens)
1. **LaunchScreen** - Branding and initial CTA
2. **OnboardingScreen** - 3-step feature introduction
3. **LoginScreen** - Email/password authentication
4. **RegisterScreen** - User registration

#### Main App (9 screens)
5. **HomeScreen** - Dashboard with 6 menu cards
6. **NotificationsScreen** - Alert list with swipe-to-delete
7. **NotificationDetailScreen** - Full alert with instructions
8. **MapsScreen** - Interactive incident map
9. **HotlinesScreen** - Emergency phone numbers
10. **SafetyGuidelinesScreen** - Emergency procedures
11. **ProfileScreen** - User information editor
12. **SettingsScreen** - App preferences
13. **HistoryScreen** - Activity timeline

### Admin Screens (7 Total)

1. **AdminLoginScreen** - Secure admin access
2. **AdminDashboardScreen** - Overview statistics
3. **UserManagementScreen** - CRUD table for users
4. **NotificationManagementScreen** - Create/edit alerts
5. **MapManagementScreen** - Incident marker control
6. **SafetyManagementScreen** - Content management
7. **SystemSettingsScreen** - Global configuration

---

## 6. Data Flow & State Management

### Provider Pattern (Recommended)

```dart
// Usage in widget:
Consumer<AuthProvider>(
  builder: (context, auth, child) {
    return Text(auth.user?.name ?? 'Guest');
  },
)
```

### Key Providers

- **AuthProvider** - Authentication state
- **NotificationProvider** - Alerts list & count
- **ThemeProvider** - Dark/light mode
- **SettingsProvider** - User preferences
- **LocationProvider** - GPS coordinates
- **AdminProvider** - Admin dashboard data

---

## 7. API Integration Guide

### Future Backend (Supabase/Firebase)

```dart
Future<User> loginUser(String email, String password) async {
  try {
    final response = await apiService.post('/auth/login', {
      'email': email,
      'password': password,
    });
    return User.fromJson(response);
  } catch (e) {
    throw Exception('Login failed: $e');
  }
}
```

### Endpoints to Implement

```
POST   /auth/login
POST   /auth/register
GET    /notifications
POST   /incidents/report
GET    /maps/incidents
GET    /hotlines
GET    /safety-guidelines
PUT    /users/:id
GET    /admin/users
POST   /admin/alerts
```

---

## 8. Testing Requirements

### Unit Tests
- Models (serialization/deserialization)
- Validators (email, password strength)
- Formatters (date, time)

### Widget Tests
- LaunchScreen renders correctly
- Login button exists and responds
- Notifications list displays data

### Integration Tests
- Complete login flow
- Notification receive flow
- Alert filtering and sorting

### Performance Tests
- Notification list scroll (60 fps)
- Map marker rendering (30+ markers)
- Image loading time (<2s)

---

## 9. Performance Benchmarks

### Target Metrics

| Metric | Target | Actual |
|--------|--------|--------|
| App startup time | <2s | — |
| Notification list scroll | 60 fps | — |
| Map with 50 markers | 30+ fps | — |
| Image load time | <2s | — |
| Storage query | <100ms | — |

---

## 10. Deployment Checklist

### Pre-Release

- [ ] All screens implemented and tested
- [ ] Lighthouse score 90+
- [ ] No console errors
- [ ] Offline mode working
- [ ] Push notifications configured
- [ ] Icons and splash screens ready
- [ ] Privacy policy written
- [ ] Terms of service finalized

### Android Build

- [ ] Sign keystore created
- [ ] Build signed APK
- [ ] Test on Android 8+ devices
- [ ] Upload to Play Store (internal testing)
- [ ] 14-day review period
- [ ] Gradual rollout (25% → 50% → 100%)

### iOS Build

- [ ] Provisioning profiles created
- [ ] Build IPA
- [ ] Test on iOS 13+ devices
- [ ] Submit to App Store
- [ ] 1-3 day review period
- [ ] Release when approved

---

**Status:** ✅ Specifications Complete | Ready for Implementation

