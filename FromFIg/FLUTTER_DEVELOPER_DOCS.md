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
         ┌───────┴────────┐
         │                │
┌────────▼────────┐ ┌────▼──────────┐
│  MobileApp      │ │   AdminApp    │
│  (Stateful)     │ │   (Stateful)  │
└────────┬────────┘ └────┬──────────┘
         │               │
    ┌────▼────┐     ┌────▼────┐
    │ Bottom  │     │  Admin  │
    │   Nav   │     │Sidebar  │
    └────┬────┘     └────┬────┘
         │               │
    ┌────▼────────────────▼────┐
    │      13 Mobile Screens   │
    │      7 Admin Screens     │
    └──────────────────────────┘
```

### Folder Structure (Detailed)

```
lib/
├── main.dart                       # Entry point, provider setup
├── app.dart                        # Root MaterialApp widget
│
├── core/                           # Core functionality
│   ├── constants/
│   │   ├── app_constants.dart     # App-wide constants
│   │   ├── api_constants.dart     # API endpoints
│   │   └── storage_keys.dart      # Storage key constants
│   │
│   ├── theme/
│   │   ├── app_colors.dart        # Color definitions
│   │   ├── app_theme.dart         # Light/dark themes
│   │   └── text_styles.dart       # Typography
│   │
│   ├── routes/
│   │   ├── app_routes.dart        # Route names
│   │   └── route_generator.dart   # Route configuration
│   │
│   └── utils/
│       ├── validators.dart         # Form validators
│       ├── formatters.dart         # Date/time formatters
│       └── helpers.dart            # Helper functions
│
├── data/                           # Data layer
│   ├── models/
│   │   ├── user.dart
│   │   ├── notification_model.dart
│   │   ├── incident.dart
│   │   ├── hotline.dart
│   │   ├── safety_guideline.dart
│   │   ├── emergency_contact.dart
│   │   └── admin.dart
│   │
│   ├── repositories/               # Data access layer
│   │   ├── auth_repository.dart
│   │   ├── notification_repository.dart
│   │   ├── user_repository.dart
│   │   └── settings_repository.dart
│   │
│   └── services/
│       ├── storage_service.dart    # Local storage
│       ├── api_service.dart        # HTTP requests
│       ├── location_service.dart   # GPS/geolocation
│       └── notification_service.dart # Push notifications
│
├── domain/                         # Business logic
│   ├── providers/
│   │   ├── auth_provider.dart
│   │   ├── notification_provider.dart
│   │   ├── theme_provider.dart
│   │   ├── settings_provider.dart
│   │   ├── map_provider.dart
│   │   └── admin_provider.dart
│   │
│   └── use_cases/                  # Business use cases
│       ├── login_use_case.dart
│       ├── send_alert_use_case.dart
│       └── report_incident_use_case.dart
│
├── presentation/                   # UI layer
│   ├── screens/
│   │   ├── mobile/
│   │   │   ├── splash/
│   │   │   │   └── splash_screen.dart
│   │   │   ├── auth/
│   │   │   │   ├── launch_screen.dart
│   │   │   │   ├── onboarding_screen.dart
│   │   │   │   ├── login_screen.dart
│   │   │   │   └── register_screen.dart
│   │   │   ├── home/
│   │   │   │   └── home_screen.dart
│   │   │   ├── notifications/
│   │   │   │   ├── notifications_screen.dart
│   │   │   │   └── notification_detail_screen.dart
│   │   │   ├── maps/
│   │   │   │   └── maps_screen.dart
│   │   │   ├── hotlines/
│   │   │   │   └── hotlines_screen.dart
│   │   │   ├── safety/
│   │   │   │   └── safety_guidelines_screen.dart
│   │   │   ├── profile/
│   │   │   │   └── profile_screen.dart
│   │   │   ├── settings/
│   │   │   │   └── settings_screen.dart
│   │   │   └── history/
│   │   │       └── history_screen.dart
│   │   │
│   │   └── admin/
│   │       ├── admin_login_screen.dart
│   │       ├── dashboard/
│   │       │   └── admin_dashboard.dart
│   │       ├── users/
│   │       │   └── user_management_screen.dart
│   │       ├── notifications/
│   │       │   └── notification_management_screen.dart
│   │       ├── maps/
│   │       │   └── map_management_screen.dart
│   │       ├── safety/
│   │       │   └── safety_management_screen.dart
│   │       └── settings/
│   │           └── system_settings_screen.dart
│   │
│   └── widgets/
│       ├── common/
│       │   ├── custom_app_bar.dart
│       │   ├── custom_button.dart
│       │   ├── custom_text_field.dart
│       │   ├── loading_indicator.dart
│       │   ├── empty_state.dart
│       │   ├── error_widget.dart
│       │   └── confirmation_dialog.dart
│       │
│       ├── mobile/
│       │   ├── notification_card.dart
│       │   ├── menu_item_card.dart
│       │   ├── hotline_card.dart
│       │   ├── bottom_nav_bar.dart
│       │   ├── emergency_banner.dart
│       │   └── fab_menu.dart
│       │
│       └── admin/
│           ├── admin_sidebar.dart
│           ├── stat_card.dart
│           ├── data_table_widget.dart
│           └── chart_widget.dart
│
└── l10n/                           # Internationalization
    ├── app_en.arb
    └── app_es.arb
```

---

## 3. UI Design System

### Color Palette

#### Primary Colors
```dart
class AppColors {
  // Brand Colors
  static const Color primary = Color(0xFF2563EB);      // #2563EB (blue-600)
  static const Color primaryLight = Color(0xFF3B82F6); // #3B82F6 (blue-500)
  static const Color primaryDark = Color(0xFF1D4ED8);  // #1D4ED8 (blue-700)
  
  // Emergency Severity Colors (CRITICAL)
  static const Color critical = Color(0xFFDC2626);     // #DC2626 (red-600)
  static const Color high = Color(0xFFEA580C);         // #EA580C (orange-600)
  static const Color medium = Color(0xFFEAB308);       // #EAB308 (yellow-500)
  static const Color low = Color(0xFF16A34A);          // #16A34A (green-600)
  
  // Functional Colors
  static const Color success = Color(0xFF16A34A);      // green-600
  static const Color warning = Color(0xFFEA580C);      // orange-600
  static const Color error = Color(0xFFDC2626);        // red-600
  static const Color info = Color(0xFF2563EB);         // blue-600
  
  // Neutral Palette
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color gray50 = Color(0xFFF9FAFB);
  static const Color gray100 = Color(0xFFF3F4F6);
  static const Color gray200 = Color(0xFFE5E7EB);
  static const Color gray300 = Color(0xFFD1D5DB);
  static const Color gray400 = Color(0xFF9CA3AF);
  static const Color gray500 = Color(0xFF6B7280);
  static const Color gray600 = Color(0xFF4B5563);
  static const Color gray700 = Color(0xFF374151);
  static const Color gray800 = Color(0xFF1F2937);
  static const Color gray900 = Color(0xFF111827);
  
  // Dark Theme Colors
  static const Color darkBackground = Color(0xFF111827);    // gray-900
  static const Color darkSurface = Color(0xFF1F2937);       // gray-800
  static const Color darkCard = Color(0xFF374151);          // gray-700
}
```

### Typography

```dart
class AppTextStyles {
  // Headers
  static const TextStyle h1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    height: 1.5,
  );
  
  static const TextStyle h2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    height: 1.5,
  );
  
  static const TextStyle h3 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.5,
  );
  
  static const TextStyle h4 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.5,
  );
  
  // Body Text
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    height: 1.5,
  );
  
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    height: 1.5,
  );
  
  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    height: 1.5,
  );
  
  // Buttons
  static const TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.5,
  );
  
  // Labels
  static const TextStyle label = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.5,
  );
}
```

### Spacing System

```dart
class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
}
```

### Border Radius

```dart
class AppRadius {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 20.0;
  static const double xxl = 24.0;
  static const double full = 9999.0;
}
```

### Shadows

```dart
class AppShadows {
  static const BoxShadow sm = BoxShadow(
    color: Color(0x0D000000), // 5% opacity
    blurRadius: 4,
    offset: Offset(0, 1),
  );
  
  static const BoxShadow md = BoxShadow(
    color: Color(0x1A000000), // 10% opacity
    blurRadius: 8,
    offset: Offset(0, 2),
  );
  
  static const BoxShadow lg = BoxShadow(
    color: Color(0x1A000000), // 10% opacity
    blurRadius: 16,
    offset: Offset(0, 4),
  );
  
  static const BoxShadow xl = BoxShadow(
    color: Color(0x26000000), // 15% opacity
    blurRadius: 24,
    offset: Offset(0, 8),
  );
}
```

---

## 4. Feature Specifications

### Authentication System

#### Requirements
- Email/password login
- User registration with validation
- Persistent login (remember me)
- Logout functionality
- Separate admin authentication

#### Implementation Details
```dart
// Auth States
enum AuthState {
  initial,      // App just opened
  authenticated, // User logged in
  unauthenticated, // User logged out
  loading,      // Auth in progress
  error,        // Auth failed
}

// User roles
enum UserRole {
  user,         // Regular end-user
  admin,        // System administrator
  superAdmin,   // Super admin (future)
}
```

#### Validation Rules
- **Email**: Must be valid email format (RFC 5322)
- **Password**: 
  - Minimum 8 characters
  - At least 1 uppercase letter
  - At least 1 lowercase letter
  - At least 1 number
  - At least 1 special character
- **Name**: 2-50 characters, letters and spaces only
- **Phone**: Valid format based on locale

---

### Notification System

#### Notification Types & Priority

```dart
enum NotificationType {
  critical,   // Immediate danger (red)
  high,       // Serious situation (orange)
  medium,     // Watch/monitor (yellow)
  low,        // Information (green)
  info,       // General updates (blue)
}

enum NotificationCategory {
  weather,
  fire,
  flood,
  earthquake,
  medical,
  security,
  traffic,
  general,
}
```

#### Notification Model

```dart
class NotificationModel {
  final String id;
  final NotificationType type;
  final NotificationCategory category;
  final String title;
  final String message;
  final String fullMessage;
  final DateTime timestamp;
  final bool read;
  final String location;
  final List<String> instructions;
  final Map<String, dynamic>? metadata;
  
  // Color based on type
  Color get color {
    switch (type) {
      case NotificationType.critical:
        return AppColors.critical;
      case NotificationType.high:
        return AppColors.high;
      case NotificationType.medium:
        return AppColors.medium;
      case NotificationType.low:
        return AppColors.low;
      default:
        return AppColors.info;
    }
  }
  
  // Icon based on category
  IconData get icon {
    switch (category) {
      case NotificationCategory.weather:
        return Icons.cloud;
      case NotificationCategory.fire:
        return Icons.local_fire_department;
      case NotificationCategory.flood:
        return Icons.water;
      case NotificationCategory.earthquake:
        return Icons.warning;
      case NotificationCategory.medical:
        return Icons.medical_services;
      case NotificationCategory.security:
        return Icons.security;
      case NotificationCategory.traffic:
        return Icons.traffic;
      default:
        return Icons.info;
    }
  }
}
```

#### Notification Behaviors

1. **Swipe to Dismiss**
   - Use `flutter_slidable` package
   - Swipe right to delete
   - Show undo option (3 seconds)

2. **Auto-refresh**
   - Poll every 30 seconds when app is active
   - Use WebSocket for real-time (future)

3. **Badge Count**
   - Show unread count on home screen
   - Update bottom nav badge
   - Clear on screen visit

---

### Maps & Location System

#### Requirements
- Display Google Maps
- Show incident markers
- Filter by incident type
- Show safe zones (hospitals, shelters, police)
- Get directions to safe zones
- Report new incidents
- Real-time updates

#### Marker Types

```dart
enum MarkerType {
  incident,        // Emergency incident
  hospital,        // Medical facility
  fireStation,     // Fire department
  policeStation,   // Police station
  shelter,         // Emergency shelter
  safeZone,        // Designated safe area
}

class MapMarker {
  final String id;
  final MarkerType type;
  final LatLng position;
  final String name;
  final String? description;
  final NotificationType? severity;  // For incidents
  final bool isActive;
  
  BitmapDescriptor get icon {
    // Return custom marker icon based on type
  }
  
  Color get color {
    // Return color based on severity/type
  }
}
```

#### Map Features
- Zoom controls
- Current location button
- Layer toggles (traffic, terrain)
- Clustering for many markers
- Info windows on marker tap
- Route planning

---

### Emergency Hotlines

#### Hotline Model

```dart
class Hotline {
  final String id;
  final String name;
  final String number;
  final HotlineCategory category;
  final IconData icon;
  final Color color;
  final bool available24x7;
  final String? description;
}

enum HotlineCategory {
  emergency,      // 911, etc.
  fire,
  police,
  medical,
  disaster,
  mentalHealth,
  poison,
  utility,
}
```

#### Features
- **Tap to Call**: Use `url_launcher` package
- **Call Confirmation**: Show dialog before dialing
- **Call History**: Track called numbers
- **Favorites**: Mark frequently used numbers

#### Implementation
```dart
Future<void> makeCall(String phoneNumber) async {
  final Uri launchUri = Uri(
    scheme: 'tel',
    path: phoneNumber,
  );
  
  if (await canLaunchUrl(launchUri)) {
    await launchUrl(launchUri);
    // Log call in history
    await _logCallHistory(phoneNumber);
  } else {
    // Show error
  }
}
```

---

### Safety Guidelines

#### Guideline Model

```dart
class SafetyGuideline {
  final String id;
  final String title;
  final EmergencyCategory category;
  final List<String> steps;
  final List<String> doList;      // What TO do
  final List<String> dontList;    // What NOT to do
  final String? additionalInfo;
  final List<String>? resources;  // External links
}

enum EmergencyCategory {
  fire,
  flood,
  earthquake,
  tornado,
  hurricane,
  medicalEmergency,
  activeShooter,
  chemicalSpill,
  powerOutage,
}
```

#### UI Implementation
- **Accordion/ExpansionTile** for each category
- **Numbered steps** for procedures
- **Color-coded** by emergency type
- **Search functionality**
- **Offline access** (cached content)

---

### Profile & Settings

#### User Profile Fields
```dart
class UserProfile {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? location;
  final String? avatarUrl;
  final List<EmergencyContact> emergencyContacts;
  final DateTime createdAt;
  final DateTime updatedAt;
}

class EmergencyContact {
  final String id;
  final String name;
  final String phone;
  final String relationship;
  final bool isPrimary;
}
```

#### Settings Structure
```dart
class AppSettings {
  // Notifications
  bool pushNotificationsEnabled;
  bool emailNotificationsEnabled;
  bool smsNotificationsEnabled;
  Set<NotificationType> notificationFilters;
  
  // Location
  bool locationServicesEnabled;
  bool backgroundLocationEnabled;
  double locationUpdateRadius; // km
  
  // Appearance
  bool darkModeEnabled;
  bool autoTheme; // Follow system
  String language; // en, es, etc.
  
  // Privacy
  bool shareLocationAnonymously;
  bool allowDataCollection;
  
  // Advanced
  bool autoRefreshEnabled;
  int refreshInterval; // seconds
  bool offlineModeEnabled;
}
```

---

## 5. Screen Specifications

### Mobile Screens (13 Total)

#### 1. Launch Screen
**Purpose**: App branding and entry point

**Layout**:
```
┌─────────────────────────┐
│                         │
│         (Logo)          │
│          🛡️             │
│                         │
│        DiPrep           │
│  Emergency Alert System │
│                         │
│                         │
│     [   Login    ]      │
│     [  Register  ]      │
│                         │
└─────────────────────────┘
```

**Specifications**:
- Full-screen gradient background (blue-500 to blue-700)
- Logo/icon: 128x128px
- Title: 36sp, bold, white
- Subtitle: 20sp, regular, white 90%
- Buttons: Full-width, 56dp height, 16dp radius

---

#### 2. Onboarding Screen (3 pages)
**Purpose**: Introduce app features to new users

**Pages**:
1. **Welcome**: "Stay Safe with DiPrep"
2. **Features**: "Real-time Alerts & Resources"
3. **Get Started**: "Join Our Community"

**Components**:
- PageView with smooth transitions
- Page indicators (dots)
- Skip button (top-right)
- Next/Get Started button (bottom)

---

#### 3. Home Screen
**Purpose**: Main dashboard with quick access

**Layout**:
```
┌─────────────────────────────────┐
│  [Emergency Banner if active]   │ ← Red banner, dismissible
├─────────────────────────────────┤
│  👤 Welcome, John!         🔔3  │
│  📍 San Francisco, CA           │
│  [3 New Alerts]                 │
├─────────────────────────────────┤
│ ┌───────────┐  ┌──────────┐    │
│ │  🗺️ Maps  │  │ 📞 Call  │    │
│ └───────────┘  └──────────┘    │
│ ┌───────────┐  ┌──────────┐    │
│ │ 🔔 Alerts │  │ 📋Safety │    │
│ │   Badge:3 │  │          │    │
│ └───────────┘  └──────────┘    │
│ ┌───────────┐  ┌──────────┐    │
│ │ 📜 History│  │ ⚙️Settings│   │
│ └───────────┘  └──────────┘    │
├─────────────────────────────────┤
│  🏠   🔔   🗺️   📋   👤        │ ← Bottom Nav
└─────────────────────────────────┘
        [+] ← FAB
```

**Key Features**:
- 2x3 grid of action cards
- Each card: 56dp icon container, label below
- Badge on Notifications card
- Floating Action Button for quick actions
- Emergency banner (dismissible)
- Gradient header with user greeting

---

#### 4. Notifications Screen
**Purpose**: List all emergency alerts

**Layout**:
```
┌─────────────────────────────────┐
│ ← Notifications      🔍  [3 new]│
├─────────────────────────────────┤
│ ┌─────────────────────────────┐ │
│ │ 🔴 Severe Weather Alert     │ │
│ │ Hurricane warning...  •  5m │ │
│ │ 📍 Downtown Area      [❌]  │ │← Swipe to delete
│ └─────────────────────────────┘ │
│ ┌─────────────────────────────┐ │
│ │ 🟡 Flood Watch              │ │
│ │ Heavy rainfall expected 2h  │ │
│ │ 📍 River Valley       [❌]  │ │
│ └─────────────────────────────┘ │
│                                 │
│ ...more notifications...        │
├─────────────────────────────────┤
│    [Mark All as Read]           │
└─────────────────────────────────┘
```

**Specifications**:
- Color-coded by severity
- Time ago format (5m, 2h, 1d)
- Unread indicator (blue dot)
- Swipe-to-delete gesture
- Pull-to-refresh
- Search/filter option

---

#### 5. Maps Screen
**Purpose**: Interactive map with incidents

**Layout**:
```
┌─────────────────────────────────┐
│ ← Maps Navigation  [Filters]    │
├─────────────────────────────────┤
│ [Fire] [Flood] [Medical]        │← Filter chips
├─────────────────────────────────┤
│                                 │
│      [Google Maps View]         │
│     🔴 🟢 🔵 (markers)          │
│                                 │
│                     [📍] ← GPS  │
├─────────────────────────────────┤
│ Nearby Locations:               │
│ ┌─────────────────────────────┐ │
│ │ 🏥 Central Hospital   1.2km │ │
│ │ [Get Directions]            │ │
│ └─────────────────────────────┘ │
└─────────────────────────────────┘
```

**Features**:
- Custom marker icons by type
- Tap marker for incident details
- Filter by incident type
- Current location button
- List of nearby safe zones
- Get directions button
- Report incident FAB

---

### Admin Screens (7 Total)

#### 1. Admin Dashboard
**Purpose**: Overview and quick stats

**Layout**:
```
┌──────┬──────────────────────────────────────┐
│      │  📊 Dashboard                        │
│      ├──────────────────────────────────────┤
│ Side │  ┌─────┐ ┌─────┐ ┌─────┐ ┌─────┐   │
│ bar  │  │1,234│ │ 45  │ │ 12  │ │ 89  │   │
│      │  │Users│ │Alert│ │Incid│ │Action│   │
│      │  └─────┘ └─────┘ └─────┘ └─────┘   │
│ 👥   │                                      │
│ 🔔   │  Recent Activity:                    │
│ 🗺️   │  • User registered: john@...        │
│ 📋   │  • Alert sent: "Weather Advisory"   │
│ ⚙️   │  • Incident: Fire at Main St        │
│      │                                      │
└──────┴──────────────────────────────────────┘
```

**Components**:
- Stat cards (total users, active alerts, etc.)
- Recent activity feed
- Quick action buttons
- Charts (future): Line graph of alerts over time

---

#### 2. User Management
**Purpose**: CRUD operations for users

**Features**:
- Data table with pagination
- Search by name/email
- Filter by role/status
- Add new user button
- Edit/Delete actions
- Export to CSV (future)

---

## 6. Data Flow & State Management

### Provider Architecture

```dart
// Example: NotificationProvider
class NotificationProvider with ChangeNotifier {
  List<NotificationModel> _notifications = [];
  bool _isLoading = false;
  String? _error;
  
  // Getters
  List<NotificationModel> get notifications => _notifications;
  List<NotificationModel> get unreadNotifications =>
      _notifications.where((n) => !n.read).toList();
  int get unreadCount => unreadNotifications.length;
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  // Load notifications
  Future<void> loadNotifications() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      _notifications = await NotificationRepository().fetchAll();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }
  
  // Mark as read
  void markAsRead(String id) {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      _notifications[index] = _notifications[index].copyWith(read: true);
      notifyListeners();
      
      // Persist to storage
      NotificationRepository().updateReadStatus(id, true);
    }
  }
  
  // Delete notification
  void deleteNotification(String id) {
    _notifications.removeWhere((n) => n.id == id);
    notifyListeners();
    
    NotificationRepository().delete(id);
  }
}
```

### State Flow Diagram

```
User Action → Widget → Provider → Repository → Service → Storage/API
                ↑                                              ↓
                └───────── notifyListeners() ←─────────────────┘
```

---

## 7. API Integration Guide

### Future Backend Integration

#### API Endpoints (Recommended Structure)

```
Authentication:
POST   /api/auth/login
POST   /api/auth/register
POST   /api/auth/logout
POST   /api/auth/refresh
GET    /api/auth/me

Users:
GET    /api/users
GET    /api/users/:id
POST   /api/users
PUT    /api/users/:id
DELETE /api/users/:id

Notifications:
GET    /api/notifications
GET    /api/notifications/:id
POST   /api/notifications
PUT    /api/notifications/:id
DELETE /api/notifications/:id
PATCH  /api/notifications/:id/read

Incidents:
GET    /api/incidents
GET    /api/incidents/:id
POST   /api/incidents
PUT    /api/incidents/:id
DELETE /api/incidents/:id

Settings:
GET    /api/settings
PUT    /api/settings
```

#### API Service Implementation

```dart
class ApiService {
  final Dio _dio;
  static const String baseUrl = 'https://api.diprep.com/v1';
  
  ApiService() : _dio = Dio(BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: Duration(seconds: 10),
    receiveTimeout: Duration(seconds: 10),
    headers: {
      'Content-Type': 'application/json',
    },
  )) {
    _dio.interceptors.add(AuthInterceptor());
    _dio.interceptors.add(LogInterceptor());
  }
  
  Future<List<NotificationModel>> getNotifications() async {
    try {
      final response = await _dio.get('/notifications');
      return (response.data as List)
          .map((json) => NotificationModel.fromJson(json))
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }
}
```

---

## 8. Testing Requirements

### Unit Tests
- All business logic functions
- Data model serialization/deserialization
- Validators and formatters
- Utility functions

### Widget Tests
- Individual widgets render correctly
- User interactions trigger correct callbacks
- State changes update UI properly

### Integration Tests
- Complete user flows (login → home → notifications)
- Navigation between screens
- Data persistence

### Test Coverage Target
- **Minimum**: 70%
- **Goal**: 85%+

---

## 9. Performance Benchmarks

### Target Metrics
- **App Launch**: < 2 seconds
- **Screen Transitions**: < 300ms
- **API Calls**: < 1 second response
- **Map Rendering**: < 2 seconds initial load
- **Memory Usage**: < 150MB average
- **Build Size**: 
  - Android: < 25MB (release APK)
  - iOS: < 30MB (release IPA)

---

## 10. Deployment Checklist

### Pre-Launch
- [ ] All features implemented and tested
- [ ] Dark mode fully functional
- [ ] Offline mode working
- [ ] Error handling in place
- [ ] Analytics integrated
- [ ] Crashlytics/Sentry setup
- [ ] Performance optimized
- [ ] Security review completed
- [ ] Privacy policy added
- [ ] Terms of service added

### App Store Assets
- [ ] App icons (all sizes)
- [ ] Screenshots (iPhone, iPad, Android)
- [ ] App preview videos
- [ ] Store descriptions
- [ ] Keywords for ASO
- [ ] Privacy questionnaire completed

### Build Configuration
- [ ] Version number incremented
- [ ] Build number incremented
- [ ] Release signing configured
- [ ] ProGuard rules (Android)
- [ ] Bitcode enabled (iOS)
- [ ] App Transport Security configured

### Post-Launch
- [ ] Monitor crash reports
- [ ] Track analytics
- [ ] Collect user feedback
- [ ] Plan updates and iterations

---

## 📞 Support & Resources

### Documentation References
- **Main Documentation**: `/SYSTEM_LOGIC_DOCUMENTATION.md`
- **UML Diagrams**: `/diagrams/` folder (11 diagrams)
- **Storyboard**: `/PROJECT_STORYBOARD.md`
- **Conversion Guide**: `/FLUTTER_CONVERSION_GUIDE.md`

### Contact
For questions about implementation details, refer to the comprehensive documentation provided in this repository.

---

**Document Version**: 1.0  
**Last Updated**: January 2026  
**Project**: DiPrep Emergency Alert System  
**Platform**: Flutter/Dart

---

## Appendix: Quick Reference

### Essential Packages
```yaml
provider: ^6.1.1
google_maps_flutter: ^2.5.0
shared_preferences: ^2.2.2
flutter_slidable: ^3.0.0
url_launcher: ^6.2.2
```

### Color Quick Reference
- Critical: #DC2626
- High: #EA580C
- Medium: #EAB308
- Low: #16A34A
- Primary: #2563EB

### Screen Count
- Mobile: 13 screens
- Admin: 7 screens
- **Total**: 20 screens

---

*This documentation should be used alongside the Flutter Conversion Guide and UML diagrams for complete implementation details.*
