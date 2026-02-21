# 🚀 DiPrep Flutter Conversion Guide

## Complete React to Flutter Migration Documentation

---

## 📋 Table of Contents

1. [Overview](#overview)
2. [Technology Stack Mapping](#technology-stack-mapping)
3. [Project Structure](#project-structure)
4. [Dependencies & Packages](#dependencies--packages)
5. [Component-to-Widget Mapping](#component-to-widget-mapping)
6. [State Management](#state-management)
7. [Navigation System](#navigation-system)
8. [Styling & Theming](#styling--theming)
9. [Code Examples](#code-examples)
10. [Screen-by-Screen Conversion](#screen-by-screen-conversion)
11. [Data Models](#data-models)
12. [Local Storage](#local-storage)
13. [Best Practices](#best-practices)

---

## 1. Overview

This guide provides a complete blueprint for converting the DiPrep React web application to a native Flutter mobile application while maintaining identical UI/UX design.

### Current Stack (React)
- **Language:** TypeScript
- **Framework:** React 18+
- **Styling:** Tailwind CSS v4
- **State:** React Hooks (useState, useEffect)
- **Storage:** localStorage
- **Icons:** Lucide React

### Target Stack (Flutter)
- **Language:** Dart
- **Framework:** Flutter 3.x+
- **Styling:** Flutter Material Design / Custom Widgets
- **State:** Provider / Riverpod / Bloc (recommended: Provider)
- **Storage:** shared_preferences
- **Icons:** Flutter Icons / Custom Icons

---

## 2. Technology Stack Mapping

### Core Framework

| React | Flutter | Notes |
|-------|---------|-------|
| React Component | StatelessWidget / StatefulWidget | Use StatefulWidget for components with state |
| JSX | Widget Tree | Dart's widget composition |
| Props | Constructor Parameters | Pass data via widget constructors |
| useState | State<T> in StatefulWidget | Local component state |
| useEffect | initState() / didUpdateWidget() | Lifecycle methods |
| Context API | Provider / InheritedWidget | Global state management |

### UI Components

| React/Tailwind | Flutter Widget | Package |
|----------------|----------------|---------|
| `<div>` | Container / Column / Row | Built-in |
| `<button>` | ElevatedButton / TextButton | Material |
| `<input>` | TextField / TextFormField | Material |
| `className="rounded-xl"` | BorderRadius.circular(12) | Built-in |
| `className="p-4"` | Padding(padding: EdgeInsets.all(16)) | Built-in |
| `className="shadow-lg"` | BoxShadow | Built-in |
| Card component | Card widget | Material |
| Modal/Dialog | showDialog() | Material |
| Toast | SnackBar / Flushbar | Material / Package |

### Navigation

| React | Flutter | Package |
|-------|---------|---------|
| useState for screens | Navigator.push() | Built-in |
| Conditional rendering | Named routes | Built-in |
| Bottom tabs | BottomNavigationBar | Material |
| Stack navigation | Navigator | Built-in |

### Storage

| React | Flutter | Package |
|-------|---------|---------|
| localStorage.setItem() | SharedPreferences.setString() | shared_preferences |
| localStorage.getItem() | SharedPreferences.getString() | shared_preferences |
| JSON.parse() | jsonDecode() | dart:convert |
| JSON.stringify() | jsonEncode() | dart:convert |

---

## 3. Project Structure

### Recommended Flutter Project Structure

```
diprep_flutter/
├── lib/
│   ├── main.dart                          # App entry point
│   ├── app.dart                           # Root app widget
│   │
│   ├── models/                            # Data models
│   │   ├── user.dart
│   │   ├── notification.dart
│   │   ├── incident.dart
│   │   ├── hotline.dart
│   │   ├── safety_guideline.dart
│   │   └── emergency_contact.dart
│   │
│   ├── providers/                         # State management
│   │   ├── auth_provider.dart
│   │   ├── notification_provider.dart
│   │   ├── theme_provider.dart
│   │   └── settings_provider.dart
│   │
│   ├── screens/                           # Main screens
│   │   ├── mobile/
│   │   │   ├── launch_screen.dart
│   │   │   ├── onboarding_screen.dart
│   │   │   ├── login_screen.dart
│   │   │   ├── register_screen.dart
│   │   │   ├── home_screen.dart
│   │   │   ├── notifications_screen.dart
│   │   │   ├── notification_detail_screen.dart
│   │   │   ├── maps_screen.dart
│   │   │   ├── hotlines_screen.dart
│   │   │   ├── safety_guidelines_screen.dart
│   │   │   ├── profile_screen.dart
│   │   │   ├── settings_screen.dart
│   │   │   └── history_screen.dart
│   │   │
│   │   └── admin/
│   │       ├── admin_login_screen.dart
│   │       ├── admin_dashboard.dart
│   │       ├── user_management_screen.dart
│   │       ├── notification_management_screen.dart
│   │       ├── map_management_screen.dart
│   │       ├── safety_management_screen.dart
│   │       └── system_settings_screen.dart
│   │
│   ├── widgets/                           # Reusable widgets
│   │   ├── common/
│   │   │   ├── custom_button.dart
│   │   │   ├── custom_text_field.dart
│   │   │   ├── loading_indicator.dart
│   │   │   └── empty_state.dart
│   │   │
│   │   ├── mobile/
│   │   │   ├── notification_card.dart
│   │   │   ├── menu_item_card.dart
│   │   │   ├── hotline_card.dart
│   │   │   ├── confirmation_toast.dart
│   │   │   └── bottom_nav_bar.dart
│   │   │
│   │   └── admin/
│   │       ├── admin_sidebar.dart
│   │       ├── data_table.dart
│   │       └── stat_card.dart
│   │
│   ├── services/                          # Business logic & APIs
│   │   ├── auth_service.dart
│   │   ├── notification_service.dart
│   │   ├── storage_service.dart
│   │   ├── location_service.dart
│   │   └── api_service.dart              # Future backend integration
│   │
│   ├── utils/                             # Helper functions
│   │   ├── constants.dart
│   │   ├── validators.dart
│   │   ├── date_formatter.dart
│   │   └── color_utils.dart
│   │
│   ├── config/                            # App configuration
│   │   ├── routes.dart
│   │   └── theme.dart
│   │
│   └── l10n/                              # Internationalization (future)
│       ├── app_en.arb
│       └── app_es.arb
│
├── assets/                                # Static assets
│   ├── images/
│   │   └── logo.png
│   ├── icons/
│   └── fonts/
│
├── test/                                  # Unit & widget tests
├── integration_test/                      # Integration tests
├── android/                               # Android-specific files
├── ios/                                   # iOS-specific files
├── pubspec.yaml                          # Dependencies
└── README.md
```

---

## 4. Dependencies & Packages

### pubspec.yaml

```yaml
name: diprep_flutter
description: DiPrep Emergency Alert System - Flutter Edition
version: 1.0.0+1

environment:
  sdk: '>=3.0.0 <4.0.0'
  flutter: ">=3.10.0"

dependencies:
  flutter:
    sdk: flutter

  # State Management
  provider: ^6.1.1                    # Recommended for this project
  # OR
  # riverpod: ^2.4.9                  # Alternative state management
  # flutter_bloc: ^8.1.3              # Alternative state management

  # UI Components
  cupertino_icons: ^1.0.6
  flutter_svg: ^2.0.9                 # For SVG icons
  google_fonts: ^6.1.0                # Custom fonts
  
  # Navigation
  go_router: ^12.1.3                  # Modern routing (optional)
  
  # Local Storage
  shared_preferences: ^2.2.2
  flutter_secure_storage: ^9.0.0     # For sensitive data
  
  # HTTP & API (future)
  http: ^1.1.2
  dio: ^5.4.0                         # Advanced HTTP client
  
  # Maps & Location
  google_maps_flutter: ^2.5.0
  geolocator: ^10.1.0
  geocoding: ^2.1.1
  
  # UI Enhancements
  smooth_page_indicator: ^1.1.0       # Onboarding dots
  flutter_slidable: ^3.0.0            # Swipe to delete
  shimmer: ^3.0.0                     # Loading skeleton
  cached_network_image: ^3.3.0
  
  # Utilities
  intl: ^0.18.1                       # Date formatting
  url_launcher: ^6.2.2                # Tel: links for calls
  permission_handler: ^11.1.0         # Permissions
  fluttertoast: ^8.2.4               # Toast messages
  
  # Animations
  lottie: ^2.7.0                      # Lottie animations (optional)
  animations: ^2.0.10
  
  # Icons
  line_icons: ^2.0.3                  # Similar to Lucide React
  
  # Forms & Validation
  flutter_form_builder: ^9.1.1
  form_builder_validators: ^9.1.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.1
  mockito: ^5.4.4
  build_runner: ^2.4.7

flutter:
  uses-material-design: true
  
  assets:
    - assets/images/
    - assets/icons/
  
  fonts:
    - family: CustomIcon
      fonts:
        - asset: assets/fonts/CustomIcon.ttf
```

---

## 5. Component-to-Widget Mapping

### React Component → Flutter Widget Patterns

#### Example 1: Simple Component

**React (LaunchScreen.tsx):**
```tsx
export function LaunchScreen({ onLogin, onRegister }: LaunchScreenProps) {
  return (
    <div className="h-screen flex flex-col justify-between bg-gradient-to-br from-blue-500 to-blue-700 p-8">
      <div className="flex-1 flex flex-col justify-center items-center text-white">
        <Shield className="w-32 h-32" />
        <h1 className="text-4xl mb-4">DiPrep</h1>
        <p className="text-xl">Emergency Alert System</p>
      </div>
      <button onClick={onLogin} className="w-full bg-white text-blue-600 py-4 rounded-2xl">
        Login
      </button>
    </div>
  );
}
```

**Flutter (launch_screen.dart):**
```dart
import 'package:flutter/material.dart';

class LaunchScreen extends StatelessWidget {
  final VoidCallback onLogin;
  final VoidCallback onRegister;

  const LaunchScreen({
    Key? key,
    required this.onLogin,
    required this.onRegister,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF3B82F6), // blue-500
              Color(0xFF1D4ED8), // blue-700
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.shield,
                        size: 128,
                        color: Colors.white,
                      ),
                      SizedBox(height: 32),
                      Text(
                        'DiPrep',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Emergency Alert System',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white.withOpacity(0.9),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: onLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Color(0xFF2563EB),
                        minimumSize: Size(double.infinity, 56),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 4,
                      ),
                      child: Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    OutlinedButton(
                      onPressed: onRegister,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: BorderSide(color: Colors.white, width: 2),
                        minimumSize: Size(double.infinity, 56),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        'Register',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
```

#### Example 2: Stateful Component

**React (NotificationsScreen.tsx):**
```tsx
export function NotificationsScreen({ onBack, darkMode }: Props) {
  const [notifications, setNotifications] = useState(initialNotifications);
  const [toast, setToast] = useState<any>(null);

  const handleSwipeDelete = (id: number) => {
    setNotifications(prev => prev.filter(n => n.id !== id));
    setToast({ message: 'Notification dismissed', type: 'info' });
  };

  return (
    <div className="h-screen flex flex-col">
      {/* UI */}
    </div>
  );
}
```

**Flutter (notifications_screen.dart):**
```dart
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class NotificationsScreen extends StatefulWidget {
  final bool darkMode;

  const NotificationsScreen({Key? key, required this.darkMode}) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<NotificationModel> notifications = initialNotifications;

  void handleSwipeDelete(int id) {
    setState(() {
      notifications = notifications.where((n) => n.id != id).toList();
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Notification dismissed'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.darkMode ? Color(0xFF111827) : Colors.white,
      appBar: AppBar(
        title: Text('Notifications'),
        backgroundColor: widget.darkMode ? Color(0xFF1F2937) : Color(0xFFEAB308),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${notifications.where((n) => !n.read).length} new',
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return Slidable(
            key: Key(notification.id.toString()),
            endActionPane: ActionPane(
              motion: ScrollMotion(),
              children: [
                SlidableAction(
                  onPressed: (context) => handleSwipeDelete(notification.id),
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  icon: Icons.delete,
                  label: 'Delete',
                ),
              ],
            ),
            child: NotificationCard(
              notification: notification,
              darkMode: widget.darkMode,
              onTap: () => _viewDetail(notification),
            ),
          );
        },
      ),
    );
  }
}
```

---

## 6. State Management

### Recommended: Provider Pattern

#### Setup Provider

**providers/auth_provider.dart:**
```dart
import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../services/storage_service.dart';

class AuthProvider with ChangeNotifier {
  User? _currentUser;
  bool _isAuthenticated = false;
  final StorageService _storage = StorageService();

  User? get currentUser => _currentUser;
  bool get isAuthenticated => _isAuthenticated;

  Future<void> login(String email, String password) async {
    // Mock login logic
    _currentUser = User(
      id: '1',
      name: 'John Doe',
      email: email,
    );
    _isAuthenticated = true;
    
    await _storage.saveUser(_currentUser!);
    notifyListeners();
  }

  Future<void> logout() async {
    _currentUser = null;
    _isAuthenticated = false;
    
    await _storage.clearUser();
    notifyListeners();
  }

  Future<void> loadUser() async {
    _currentUser = await _storage.getUser();
    _isAuthenticated = _currentUser != null;
    notifyListeners();
  }
}
```

#### Use Provider in Widget

```dart
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser;

    return Scaffold(
      body: Column(
        children: [
          Text('Welcome, ${user?.name ?? 'User'}'),
          ElevatedButton(
            onPressed: () => authProvider.logout(),
            child: Text('Logout'),
          ),
        ],
      ),
    );
  }
}
```

#### Setup in main.dart

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
      ],
      child: MyApp(),
    ),
  );
}
```

---

## 7. Navigation System

### Bottom Navigation (Mobile App)

**React Approach:**
```tsx
const [currentScreen, setCurrentScreen] = useState<MobileScreen>('home');
```

**Flutter Approach:**

**widgets/mobile/bottom_nav_bar.dart:**
```dart
import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Color(0xFF2563EB),
      unselectedItemColor: Colors.grey,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications),
          label: 'Alerts',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.map),
          label: 'Maps',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.book),
          label: 'Safety',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }
}
```

**Main Mobile Screen with Navigation:**
```dart
class MobileApp extends StatefulWidget {
  @override
  State<MobileApp> createState() => _MobileAppState();
}

class _MobileAppState extends State<MobileApp> {
  int _currentIndex = 0;
  
  final List<Widget> _screens = [
    HomeScreen(),
    NotificationsScreen(),
    MapsScreen(),
    SafetyGuidelinesScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
```

### Stack Navigation

**config/routes.dart:**
```dart
import 'package:flutter/material.dart';

class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String notificationDetail = '/notification-detail';
  
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => LaunchScreen());
      case onboarding:
        return MaterialPageRoute(builder: (_) => OnboardingScreen());
      case login:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case home:
        return MaterialPageRoute(builder: (_) => MobileApp());
      case notificationDetail:
        final args = settings.arguments as NotificationModel;
        return MaterialPageRoute(
          builder: (_) => NotificationDetailScreen(notification: args),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
```

---

## 8. Styling & Theming

### Color System

**utils/constants.dart:**
```dart
import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFF2563EB);      // blue-600
  static const Color primaryLight = Color(0xFF3B82F6);  // blue-500
  static const Color primaryDark = Color(0xFF1D4ED8);   // blue-700
  
  // Alert Severity Colors
  static const Color critical = Color(0xFFDC2626);      // red-600
  static const Color high = Color(0xFFEA580C);          // orange-600
  static const Color medium = Color(0xFFEAB308);        // yellow-500
  static const Color low = Color(0xFF16A34A);           // green-600
  static const Color info = Color(0xFF2563EB);          // blue-600
  static const Color success = Color(0xFF16A34A);       // green-600
  
  // Neutrals
  static const Color white = Colors.white;
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
  
  // Dark Mode
  static const Color darkBackground = Color(0xFF111827);
  static const Color darkSurface = Color(0xFF1F2937);
  static const Color darkCard = Color(0xFF374151);
}

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.gray50,
    
    colorScheme: ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.primaryLight,
      error: AppColors.critical,
      background: AppColors.gray50,
      surface: Colors.white,
    ),
    
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
    ),
    
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        minimumSize: Size(double.infinity, 56),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 2,
        textStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.gray300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.gray300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.primary, width: 2),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    ),
    
    cardTheme: CardTheme(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: Colors.white,
    ),
  );
  
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.darkBackground,
    
    colorScheme: ColorScheme.dark(
      primary: AppColors.primaryLight,
      secondary: AppColors.primary,
      error: AppColors.critical,
      background: AppColors.darkBackground,
      surface: AppColors.darkSurface,
    ),
    
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.darkSurface,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    
    cardTheme: CardTheme(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: AppColors.darkSurface,
    ),
  );
}
```

### Applying Theme

**main.dart:**
```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'DiPrep',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeProvider.themeMode,
          onGenerateRoute: AppRoutes.generateRoute,
          initialRoute: AppRoutes.splash,
        );
      },
    );
  }
}
```

---

## 9. Code Examples

### Full Screen Example: Home Screen

**screens/mobile/home_screen.dart:**
```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/theme_provider.dart';
import '../../utils/constants.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _showEmergencyBanner = true;
  bool _showQuickAction = false;

  final List<MenuItem> _menuItems = [
    MenuItem(
      icon: Icons.map,
      label: 'Maps',
      color: AppColors.success,
      route: '/maps',
    ),
    MenuItem(
      icon: Icons.phone,
      label: 'Hotlines',
      color: AppColors.critical,
      route: '/hotlines',
    ),
    MenuItem(
      icon: Icons.notifications,
      label: 'Notifications',
      color: AppColors.medium,
      badge: 3,
      route: '/notifications',
    ),
    MenuItem(
      icon: Icons.shield,
      label: 'Safety',
      color: AppColors.info,
      route: '/safety',
    ),
    MenuItem(
      icon: Icons.history,
      label: 'History',
      color: Colors.purple,
      route: '/history',
    ),
    MenuItem(
      icon: Icons.settings,
      label: 'Settings',
      color: AppColors.gray500,
      route: '/settings',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;
    final user = authProvider.currentUser;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: isDark
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.gray800, AppColors.gray900],
                )
              : LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFDEEBFF), Color(0xFFB6D4FE)],
                ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Emergency Alert Banner
              if (_showEmergencyBanner)
                _buildEmergencyBanner(),
              
              // Header
              _buildHeader(user, isDark, authProvider),
              
              // Menu Grid
              Expanded(
                child: _buildMenuGrid(isDark),
              ),
            ],
          ),
        ),
      ),
      
      // Floating Action Button
      floatingActionButton: _buildFloatingActionButton(isDark),
    );
  }

  Widget _buildEmergencyBanner() {
    return Container(
      color: AppColors.critical,
      padding: EdgeInsets.all(12),
      child: Row(
        children: [
          Icon(Icons.warning, color: Colors.white, size: 20),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Severe Weather Alert - Hurricane Warning',
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
          IconButton(
            icon: Icon(Icons.close, color: Colors.white70),
            onPressed: () {
              setState(() {
                _showEmergencyBanner = false;
              });
            },
            padding: EdgeInsets.zero,
            constraints: BoxConstraints(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(User? user, bool isDark, AuthProvider authProvider) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [AppColors.gray800, AppColors.gray900]
              : [Color(0xFF2563EB), Color(0xFF1D4ED8)],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome back,',
                    style: TextStyle(
                      color: isDark ? AppColors.gray300 : Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    user?.name ?? 'User',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.person, color: Colors.white),
                    onPressed: () => Navigator.pushNamed(context, '/profile'),
                  ),
                  IconButton(
                    icon: Icon(Icons.logout, color: Colors.white),
                    onPressed: () => authProvider.logout(),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 16),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.critical,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.notifications, color: Colors.white, size: 16),
                SizedBox(width: 8),
                Text(
                  '3 New Alerts',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuGrid(bool isDark) {
    return Padding(
      padding: EdgeInsets.all(24),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1,
        ),
        itemCount: _menuItems.length,
        itemBuilder: (context, index) {
          final item = _menuItems[index];
          return _buildMenuItem(item, isDark);
        },
      ),
    );
  }

  Widget _buildMenuItem(MenuItem item, bool isDark) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, item.route),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.gray800 : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            if (!isDark)
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
          ],
        ),
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: item.color,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      item.icon,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    item.label,
                    style: TextStyle(
                      color: isDark ? Colors.white : AppColors.gray800,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            if (item.badge != null)
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.critical,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '${item.badge}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton(bool isDark) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_showQuickAction) _buildQuickActionMenu(isDark),
        SizedBox(height: 16),
        FloatingActionButton(
          onPressed: () {
            setState(() {
              _showQuickAction = !_showQuickAction;
            });
          },
          backgroundColor: AppColors.critical,
          child: AnimatedRotation(
            turns: _showQuickAction ? 0.125 : 0,
            duration: Duration(milliseconds: 200),
            child: Icon(Icons.add, size: 32),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActionMenu(bool isDark) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _quickActionButton(Icons.warning, 'Report Incident', AppColors.critical),
          SizedBox(height: 8),
          _quickActionButton(Icons.phone, 'Emergency Call', AppColors.info),
          SizedBox(height: 8),
          _quickActionButton(Icons.location_on, 'Find Safe Zone', AppColors.success),
        ],
      ),
    );
  }

  Widget _quickActionButton(IconData icon, String label, Color color) {
    return InkWell(
      onTap: () {
        // Handle action
        setState(() {
          _showQuickAction = false;
        });
      },
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Row(
          children: [
            Icon(icon, color: color, size: 20),
            SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MenuItem {
  final IconData icon;
  final String label;
  final Color color;
  final String route;
  final int? badge;

  MenuItem({
    required this.icon,
    required this.label,
    required this.color,
    required this.route,
    this.badge,
  });
}
```

### Reusable Widget Example: Notification Card

**widgets/mobile/notification_card.dart:**
```dart
import 'package:flutter/material.dart';
import '../../models/notification.dart';
import '../../utils/constants.dart';

class NotificationCard extends StatelessWidget {
  final NotificationModel notification;
  final bool darkMode;
  final VoidCallback onTap;

  const NotificationCard({
    Key? key,
    required this.notification,
    required this.darkMode,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorData = _getIconAndColor(notification.type);
    
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: notification.read
              ? (darkMode ? AppColors.gray800 : AppColors.gray50)
              : (darkMode ? AppColors.gray800.withOpacity(0.7) : Colors.white),
          border: Border(
            bottom: BorderSide(
              color: darkMode ? AppColors.gray700 : AppColors.gray200,
            ),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: colorData['color'],
                shape: BoxShape.circle,
              ),
              child: Icon(
                colorData['icon'],
                color: Colors.white,
                size: 20,
              ),
            ),
            SizedBox(width: 12),
            
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          notification.title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: colorData['textColor'],
                          ),
                        ),
                      ),
                      if (!notification.read)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: AppColors.info,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Text(
                    notification.message,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      color: darkMode ? AppColors.gray400 : AppColors.gray600,
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        notification.time,
                        style: TextStyle(
                          fontSize: 12,
                          color: darkMode ? AppColors.gray500 : AppColors.gray400,
                        ),
                      ),
                      Text(
                        ' • ',
                        style: TextStyle(
                          color: darkMode ? AppColors.gray500 : AppColors.gray400,
                        ),
                      ),
                      Text(
                        notification.location,
                        style: TextStyle(
                          fontSize: 12,
                          color: darkMode ? AppColors.gray500 : AppColors.gray400,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Map<String, dynamic> _getIconAndColor(String type) {
    switch (type) {
      case 'critical':
        return {
          'icon': Icons.warning,
          'color': AppColors.critical,
          'textColor': AppColors.critical,
        };
      case 'warning':
        return {
          'icon': Icons.notifications,
          'color': AppColors.high,
          'textColor': AppColors.high,
        };
      case 'success':
        return {
          'icon': Icons.check_circle,
          'color': AppColors.success,
          'textColor': AppColors.success,
        };
      default:
        return {
          'icon': Icons.info,
          'color': AppColors.info,
          'textColor': AppColors.info,
        };
    }
  }
}
```

---

## 10. Screen-by-Screen Conversion

### Complete Screen Mapping

| React Screen | Flutter Screen | Key Features |
|--------------|----------------|--------------|
| LaunchScreen.tsx | launch_screen.dart | Gradient background, logo, buttons |
| Onboarding.tsx | onboarding_screen.dart | PageView, smooth_page_indicator |
| LoginScreen.tsx | login_screen.dart | TextFormField, validation |
| RegisterScreen.tsx | register_screen.dart | Form, password strength indicator |
| HomeScreen.tsx | home_screen.dart | GridView, gradient header, FAB |
| NotificationsScreen.tsx | notifications_screen.dart | ListView.builder, Slidable |
| NotificationDetailScreen.tsx | notification_detail_screen.dart | ScrollView, ExpansionTile |
| MapsScreen.tsx | maps_screen.dart | google_maps_flutter, markers |
| HotlinesScreen.tsx | hotlines_screen.dart | ListView, url_launcher for calls |
| SafetyGuidelinesScreen.tsx | safety_guidelines_screen.dart | ExpansionTile, categories |
| ProfileScreen.tsx | profile_screen.dart | Form, ImagePicker for avatar |
| SettingsScreen.tsx | settings_screen.dart | SwitchListTile, ListTile |
| HistoryScreen.tsx | history_screen.dart | ListView with grouped data |

---

## 11. Data Models

### User Model

**models/user.dart:**
```dart
class User {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? location;
  final String? avatarUrl;
  final List<EmergencyContact> emergencyContacts;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.location,
    this.avatarUrl,
    this.emergencyContacts = const [],
  });

  // From JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String?,
      location: json['location'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
      emergencyContacts: (json['emergencyContacts'] as List<dynamic>?)
              ?.map((e) => EmergencyContact.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'location': location,
      'avatarUrl': avatarUrl,
      'emergencyContacts': emergencyContacts.map((e) => e.toJson()).toList(),
    };
  }

  // Copy with
  User copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? location,
    String? avatarUrl,
    List<EmergencyContact>? emergencyContacts,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      location: location ?? this.location,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      emergencyContacts: emergencyContacts ?? this.emergencyContacts,
    );
  }
}
```

### Notification Model

**models/notification.dart:**
```dart
enum NotificationType { critical, warning, info, success }

class NotificationModel {
  final int id;
  final NotificationType type;
  final String title;
  final String message;
  final String fullMessage;
  final String time;
  final bool read;
  final String location;
  final List<String> instructions;

  NotificationModel({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.fullMessage,
    required this.time,
    required this.read,
    required this.location,
    required this.instructions,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as int,
      type: _parseNotificationType(json['type'] as String),
      title: json['title'] as String,
      message: json['message'] as String,
      fullMessage: json['fullMessage'] as String,
      time: json['time'] as String,
      read: json['read'] as bool,
      location: json['location'] as String,
      instructions: (json['instructions'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.toString().split('.').last,
      'title': title,
      'message': message,
      'fullMessage': fullMessage,
      'time': time,
      'read': read,
      'location': location,
      'instructions': instructions,
    };
  }

  static NotificationType _parseNotificationType(String typeString) {
    switch (typeString) {
      case 'critical':
        return NotificationType.critical;
      case 'warning':
        return NotificationType.warning;
      case 'success':
        return NotificationType.success;
      default:
        return NotificationType.info;
    }
  }

  NotificationModel copyWith({bool? read}) {
    return NotificationModel(
      id: id,
      type: type,
      title: title,
      message: message,
      fullMessage: fullMessage,
      time: time,
      read: read ?? this.read,
      location: location,
      instructions: instructions,
    );
  }
}
```

---

## 12. Local Storage

### Storage Service

**services/storage_service.dart:**
```dart
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/user.dart';
import '../models/notification.dart';

class StorageService {
  static const String _keyUser = 'user';
  static const String _keyNotifications = 'notifications';
  static const String _keySettings = 'settings';
  static const String _keyHistory = 'history';

  // Save User
  Future<void> saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = jsonEncode(user.toJson());
    await prefs.setString(_keyUser, userJson);
  }

  // Get User
  Future<User?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_keyUser);
    if (userJson == null) return null;
    
    final userMap = jsonDecode(userJson) as Map<String, dynamic>;
    return User.fromJson(userMap);
  }

  // Clear User (Logout)
  Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyUser);
  }

  // Save Notifications
  Future<void> saveNotifications(List<NotificationModel> notifications) async {
    final prefs = await SharedPreferences.getInstance();
    final notificationsJson = jsonEncode(
      notifications.map((n) => n.toJson()).toList(),
    );
    await prefs.setString(_keyNotifications, notificationsJson);
  }

  // Get Notifications
  Future<List<NotificationModel>> getNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final notificationsJson = prefs.getString(_keyNotifications);
    if (notificationsJson == null) return [];
    
    final notificationsList = jsonDecode(notificationsJson) as List<dynamic>;
    return notificationsList
        .map((json) => NotificationModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  // Save Settings
  Future<void> saveSetting(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is bool) {
      await prefs.setBool(key, value);
    } else if (value is String) {
      await prefs.setString(key, value);
    } else if (value is int) {
      await prefs.setInt(key, value);
    }
  }

  // Get Setting
  Future<T?> getSetting<T>(String key) async {
    final prefs = await SharedPreferences.getInstance();
    if (T == bool) {
      return prefs.getBool(key) as T?;
    } else if (T == String) {
      return prefs.getString(key) as T?;
    } else if (T == int) {
      return prefs.getInt(key) as T?;
    }
    return null;
  }

  // Check if first launch
  Future<bool> isFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('first_launch') ?? true;
  }

  // Set first launch completed
  Future<void> setFirstLaunchCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('first_launch', false);
  }
}
```

---

## 13. Best Practices

### Performance Optimization

1. **Use const constructors** where possible
```dart
const Text('Hello');  // Better
Text('Hello');        // Avoid if static
```

2. **ListView.builder for long lists**
```dart
ListView.builder(
  itemCount: notifications.length,
  itemBuilder: (context, index) => NotificationCard(notification: notifications[index]),
);
```

3. **Avoid rebuilding entire tree**
```dart
// Use Consumer for targeted rebuilds
Consumer<AuthProvider>(
  builder: (context, auth, child) => Text(auth.user.name),
)
```

4. **Image caching**
```dart
CachedNetworkImage(
  imageUrl: avatarUrl,
  placeholder: (context, url) => CircularProgressIndicator(),
  errorWidget: (context, url, error) => Icon(Icons.error),
)
```

### Code Organization

1. **Separate business logic from UI**
2. **Use services for API calls and storage**
3. **Keep widgets small and focused**
4. **Use constants file for colors, strings, dimensions**
5. **Follow consistent naming conventions**

### Testing

```dart
// Widget Test Example
testWidgets('Login button submits form', (WidgetTester tester) async {
  await tester.pumpWidget(MaterialApp(home: LoginScreen()));
  
  await tester.enterText(find.byType(TextField).first, 'test@example.com');
  await tester.enterText(find.byType(TextField).last, 'password123');
  
  await tester.tap(find.text('Login'));
  await tester.pump();
  
  // Verify navigation or state change
});
```

---

## 🎯 Implementation Checklist

### Phase 1: Setup & Core
- [ ] Create Flutter project
- [ ] Add all dependencies to pubspec.yaml
- [ ] Setup folder structure
- [ ] Create theme configuration
- [ ] Setup routes
- [ ] Implement data models

### Phase 2: Authentication
- [ ] Launch screen
- [ ] Onboarding flow
- [ ] Login screen
- [ ] Register screen
- [ ] Auth provider
- [ ] Storage service

### Phase 3: Mobile Features
- [ ] Home screen with menu grid
- [ ] Bottom navigation
- [ ] Notifications screen with swipe-to-delete
- [ ] Notification detail screen
- [ ] Maps screen with Google Maps
- [ ] Hotlines screen with tap-to-call
- [ ] Safety guidelines with accordion
- [ ] Profile screen
- [ ] Settings screen with theme toggle
- [ ] History screen

### Phase 4: Admin Portal
- [ ] Admin login
- [ ] Admin dashboard
- [ ] User management (CRUD)
- [ ] Notification management
- [ ] Map management
- [ ] Safety guidelines management
- [ ] System settings

### Phase 5: Polish
- [ ] Dark mode implementation
- [ ] Animations and transitions
- [ ] Error handling
- [ ] Loading states
- [ ] Empty states
- [ ] Form validation
- [ ] Confirmation dialogs

### Phase 6: Testing & Deployment
- [ ] Unit tests
- [ ] Widget tests
- [ ] Integration tests
- [ ] Android build configuration
- [ ] iOS build configuration
- [ ] App icons and splash screens
- [ ] Play Store / App Store submission

---

## 📚 Additional Resources

### Official Documentation
- **Flutter Docs:** https://docs.flutter.dev
- **Dart Docs:** https://dart.dev/guides
- **Material Design 3:** https://m3.material.io

### State Management
- **Provider:** https://pub.dev/packages/provider
- **Riverpod:** https://riverpod.dev
- **Bloc:** https://bloclibrary.dev

### Community
- **Flutter Community:** https://flutter.dev/community
- **Stack Overflow:** Tag `flutter`
- **GitHub:** https://github.com/flutter

---

## 🎓 Conclusion

This guide provides a complete roadmap for converting DiPrep from React to Flutter while maintaining identical UI/UX. The key is to:

1. **Understand the widget tree concept** (vs. React's component tree)
2. **Use Provider for state management** (vs. React hooks)
3. **Map Tailwind classes to Flutter properties**
4. **Leverage Material Design widgets**
5. **Follow Flutter best practices for performance**

Remember: Flutter is declarative like React, so the mental model is similar. The main differences are in syntax (Dart vs. TypeScript) and how styling is applied (properties vs. CSS classes).

**Happy coding! 🚀**

---

*This conversion guide is maintained alongside the DiPrep project. Last updated: January 2026*
