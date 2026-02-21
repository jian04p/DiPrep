# 🏗️ DiPrep System Logic Documentation

## Complete System Architecture & Business Logic

---

## 📋 Table of Contents

1. [System Overview](#system-overview)
2. [System Actors](#system-actors)
3. [Architecture Layers](#architecture-layers)
4. [Core Data Models](#core-data-models)
5. [Business Logic Flows](#business-logic-flows)
6. [Mobile Use Cases](#mobile-use-cases)
7. [Admin Use Cases](#admin-use-cases)
8. [System Workflows](#system-workflows)
9. [Error Handling & Recovery](#error-handling--recovery)
10. [Security Measures](#security-measures)

---

## 1. System Overview

### Purpose
DiPrep is a real-time emergency alert distribution and management system designed to rapidly disseminate critical information to affected populations while providing coordinators with tools to manage incident response.

### Core Capabilities
- **Real-time Alert Distribution**: Instant notification delivery across mobile and web
- **Incident Management**: Create, update, and resolve emergency incidents
- **Location-Based Filtering**: Target alerts to geographic areas
- **Priority System**: Five-tier severity classification (Critical, High, Medium, Low, Info)
- **Dual Interface**: Separate mobile (user) and admin (coordinator) systems
- **Offline Support**: Cached data and local storage for connectivity loss
- **Audit Trail**: Complete logging of all system actions

---

## 2. System Actors

### Primary Users

1. **End User / Citizen**
   - Role: Receives alerts and accesses emergency resources
   - Permissions: View own profile, settings, alert history
   - Actions: Login, receive notifications, view maps

2. **Admin / Coordinator**
   - Role: Creates and manages alerts and incidents
   - Permissions: Full system access, user management, reporting
   - Actions: Create alerts, manage users, view analytics

3. **System Admin**
   - Role: Manages system configuration and security
   - Permissions: System settings, user roles, audit logs
   - Actions: Configure thresholds, manage accounts, deploy updates

---

## 3. Architecture Layers

### Presentation Layer
```
LaunchScreen → LoginScreen → HomeScreen → [Navigation]
                                    ├── NotificationsScreen
                                    ├── MapsScreen
                                    ├── HotlinesScreen
                                    ├── SafetyScreen
                                    ├── ProfileScreen
                                    └── SettingsScreen
```

### Business Logic Layer
```
Providers (State Management)
├── AuthProvider
├── NotificationProvider
├── LocationProvider
└── SettingsProvider
```

### Service Layer
```
Services (External Communication)
├── ApiService
├── StorageService
├── LocationService
├── NotificationService
└── LoggingService
```

### Data Layer
```
Repositories & Models
├── UserRepository
├── NotificationRepository
├── IncidentRepository
└── SettingsRepository
```

---

## 4. Core Data Models

### User Model
```dart
class User {
  final String id;
  final String email;
  final String name;
  final String phone;
  final String role; // 'user' | 'admin' | 'system_admin'
  final List<String> deviceIds;
  final DateTime createdAt;
  final DateTime lastLogin;
  final bool isActive;

  User({required this.id, required this.email, required this.name});
}
```

### Notification Model
```dart
class Notification {
  final String id;
  final String title;
  final String message;
  final String severity; // 'critical'|'high'|'medium'|'low'|'info'
  final String category; // 'weather'|'accident'|'health'|'security'
  final DateTime createdAt;
  final DateTime? readAt;
  final Map<String, dynamic>? metadata;

  Notification({required this.id, required this.title});
}
```

### Incident Model
```dart
class Incident {
  final String id;
  final String title;
  final String description;
  final String status; // 'active'|'resolved'|'archived'
  final String severity;
  final double latitude;
  final double longitude;
  final double radiusKm;
  final DateTime startTime;
  final DateTime? endTime;
  final String createdBy;

  Incident({required this.id, required this.title});
}
```

---

## 5. Business Logic Flows

### Alert Distribution Flow

```
1. Admin Creates Alert
   └─> Validate alert data
   └─> Assign severity & category
   └─> Select geographic area
   └─> Create Notification record
   └─> Queue for distribution

2. System Distributes Alert
   └─> Get target users (by location/preference)
   └─> Send push notification
   └─> Store in local history
   └─> Update alert status

3. User Receives Alert
   └─> Parse notification
   └─> Extract metadata
   └─> Display in NotificationsScreen
   └─> Trigger sound/vibration (if enabled)
   └─> Allow mark-as-read
```

### Authentication Flow

```
1. User Launches App
   └─> Check stored token in SharedPreferences
   └─> If token exists → Validate with backend
   └─> If valid → Proceed to HomeScreen
   └─> If invalid → Proceed to LaunchScreen

2. User Taps Login
   └─> Navigate to LoginScreen
   └─> Input email & password
   └─> Validate form fields locally
   └─> Submit to API

3. API Processes Login
   └─> Verify credentials
   └─> Generate JWT token
   └─> Return token + user data

4. App Stores Session
   └─> Save token to secure storage
   └─> Update AuthProvider state
   └─> Navigate to HomeScreen
   └─> Initialize NotificationProvider
```

---

## 6. Mobile Use Cases

### Primary Use Cases (by frequency)

#### UC-M1: Receive Emergency Alert
- **Actor**: End User
- **Trigger**: Admin publishes alert to target zone
- **Normal Flow**:
  1. Backend sends push notification
  2. App receives and decodes notification
  3. Stores in local Notifications list
  4. Displays badge on app icon
  5. Plays alert sound (if enabled)
  6. User taps notification to view details

#### UC-M2: View Alert Details
- **Actor**: End User
- **Trigger**: User taps notification in NotificationsScreen
- **Normal Flow**:
  1. Navigate to NotificationDetailScreen
  2. Display title, message, severity badge
  3. Show category icon
  4. Display timestamp and last updated
  5. Show action buttons (Emergency Hotline, Safety Guidelines)
  6. Allow "Mark as Read" action

#### UC-M3: Login to App
- **Actor**: End User (New or Returning)
- **Trigger**: User launches app or session expired
- **Normal Flow**:
  1. App detects no valid token
  2. Navigate to LaunchScreen
  3. User taps "Login"
  4. Enter email and password
  5. Validate input locally
  6. Send login request to backend
  7. Receive JWT token
  8. Store in secure storage
  9. Update AuthProvider
  10. Navigate to HomeScreen

#### UC-M4: Access Emergency Hotlines
- **Actor**: End User
- **Trigger**: User taps "Emergency Hotlines" card or detail action
- **Normal Flow**:
  1. Navigate to HotlinesScreen
  2. Display list of contact buttons (Police, Fire, Ambulance, etc.)
  3. User taps a hotline
  4. Open phone dialer with pre-filled number
  5. User confirms to call

#### UC-M5: View Safety Guidelines
- **Actor**: End User
- **Trigger**: User taps "Safety Guidelines" card
- **Normal Flow**:
  1. Navigate to SafetyGuidelinesScreen
  2. Display categorized list of procedures
  3. User selects category (Earthquake, Fire, Weather, etc.)
  4. Show detailed procedures with text and images
  5. Allow bookmarking for offline access

#### UC-M6: Update Profile
- **Actor**: End User
- **Trigger**: User taps "Profile" in navigation menu
- **Normal Flow**:
  1. Navigate to ProfileScreen
  2. Display pre-filled user data
  3. Allow edit of name, phone, email
  4. Validate input
  5. Save changes to backend
  6. Update ProfileProvider
  7. Show success toast

#### UC-M7: Toggle Dark Mode
- **Actor**: End User
- **Trigger**: User taps theme toggle in SettingsScreen
- **Normal Flow**:
  1. Navigate to SettingsScreen
  2. Toggle "Dark Mode" switch
  3. Update ThemeProvider
  4. Persist preference to SharedPreferences
  5. Rebuild UI with new theme

#### UC-M8: View Notification History
- **Actor**: End User
- **Trigger**: User taps "View History" or "Notifications" tab
- **Normal Flow**:
  1. Display list of all notifications (newest first)
  2. Show timestamp, severity badge, title
  3. Allow sort by date/severity
  4. Allow filter by category
  5. Swipe to delete (locally archived)

#### UC-M9: Report Incident (Future Feature)
- **Actor**: End User
- **Trigger**: User taps "Report Incident" card
- **Normal Flow**:
  1. Navigate to IncidentReportScreen
  2. Capture GPS location
  3. Input incident title and description
  4. Select severity level
  5. Add photo (optional)
  6. Submit to backend
  7. Backend processes and creates Incident
  8. Alert coordinators of new report

#### UC-M10: Access Maps
- **Actor**: End User
- **Trigger**: User taps "View Map" card
- **Normal Flow**:
  1. Navigate to MapsScreen
  2. Initialize Google Maps widget
  3. Center on user location (with permission)
  4. Display incident markers from current alert
  5. Color code by severity
  6. Allow tap on marker for incident details

#### UC-M11: Logout
- **Actor**: End User
- **Trigger**: User taps "Logout" in settings
- **Normal Flow**:
  1. Clear token from secure storage
  2. Reset all providers to initial state
  3. Navigate to LaunchScreen
  4. Backend invalidates session

#### UC-M12: Enable/Disable Notifications
- **Actor**: End User
- **Trigger**: User toggles notification settings
- **Normal Flow**:
  1. Navigate to SettingsScreen
  2. Toggle "Allow Notifications"
  3. Request system permission (Android/iOS)
  4. Save preference to backend
  5. Update SettingsProvider
  6. Stop/start receiving push notifications

#### UC-M13: Rate Alert Usefulness
- **Actor**: End User
- **Trigger**: User views alert detail screen
- **Normal Flow**:
  1. Display thumbs-up/thumbs-down buttons
  2. User selects rating
  3. Submit feedback to backend
  4. Store for analytics

---

## 7. Admin Use Cases

### Admin Operations

#### UC-A1: Create Emergency Alert
- **Actor**: Admin/Coordinator
- **Trigger**: Emergency event occurs
- **Normal Flow**:
  1. Navigate to NotificationManagementScreen
  2. Tap "Create New Alert"
  3. Input title, message, severity
  4. Select category (weather, accident, health, security)
  5. Define geographic target (radius or polygon)
  6. Optionally add image/video
  7. Set notification priority (urgent/normal)
  8. Review and confirm
  9. System distributes to targeted users
  10. Alert appears in admin's "Active Alerts" list

#### UC-A2: Update Active Alert
- **Actor**: Admin/Coordinator
- **Trigger**: Situation changes (escalation, resolution, etc.)
- **Normal Flow**:
  1. Open alert from "Active Alerts" list
  2. Tap "Edit"
  3. Modify message, severity, or scope
  4. Save changes
  5. System sends update notification to already-notified users
  6. History records all changes

#### UC-A3: Resolve/Close Alert
- **Actor**: Admin/Coordinator
- **Trigger**: Emergency has ended
- **Normal Flow**:
  1. Open active alert
  2. Tap "Resolve" button
  3. Add resolution note (optional)
  4. Confirm status change
  5. Alert status changes to "resolved"
  6. Remove from "Active" list
  7. Users see notification that alert is resolved

#### UC-A4: Manage Users
- **Actor**: System Admin
- **Trigger**: Need to view, edit, or remove users
- **Normal Flow**:
  1. Navigate to UserManagementScreen
  2. View list of all users (with filters)
  3. Search by email or name
  4. Tap user to view details
  5. Options: Edit, Deactivate, Delete
  6. Changes logged in audit trail

#### UC-A5: Generate Reports
- **Actor**: Admin/Coordinator
- **Trigger**: Periodic review or incident investigation
- **Normal Flow**:
  1. Navigate to ReportsScreen
  2. Select report type (Alert Distribution, User Activity, Incident Analysis)
  3. Filter by date range
  4. Select export format (PDF, CSV, JSON)
  5. System generates and downloads report

#### UC-A6: Configure System Settings
- **Actor**: System Admin
- **Trigger**: Need to adjust global parameters
- **Normal Flow**:
  1. Navigate to SystemSettingsScreen
  2. Adjust thresholds (max alert radius, cooldown period, etc.)
  3. Configure alert categories and severity levels
  4. Update hotline numbers
  5. Set backup locations
  6. Save changes (logged in audit trail)

#### UC-A7: View System Analytics
- **Actor**: Admin/Coordinator
- **Trigger**: Monitoring system performance
- **Normal Flow**:
  1. Open AdminDashboardScreen
  2. View real-time metrics:
     - Total active users
     - Active alerts count
     - Notification delivery rate
     - Average response time
  3. View charts for trends
  4. Drill down into specific metrics

#### UC-A8: Manage Safety Guidelines
- **Actor**: Admin/Coordinator
- **Trigger**: Updating emergency procedures
- **Normal Flow**:
  1. Navigate to SafetyManagementScreen
  2. View list of categories
  3. Create new or edit existing guideline
  4. Upload images and format text
  5. Assign to categories
  6. Publish to app (versioned)
  7. Users see updated guidelines

---

## 8. System Workflows

### Real-Time Alert Distribution Workflow

```
┌─────────────────────────────────────────┐
│  Admin Creates Alert (AdminApp)        │
└─────────────┬──────────────────────────┘
              │ Submit
              ▼
┌─────────────────────────────────────────┐
│  Backend Validates Alert                │
│  - Check fields                         │
│  - Verify geographic scope              │
│  - Check permissions                    │
└─────────────┬──────────────────────────┘
              │ Valid
              ▼
┌─────────────────────────────────────────┐
│  Backend Queries Target Users           │
│  - Geo-match users in radius/polygon   │
│  - Filter by preferences               │
│  - Exclude opted-out users             │
└─────────────┬──────────────────────────┘
              │ User List
              ▼
┌─────────────────────────────────────────┐
│  Push Notification Service              │
│  - Queue for delivery                   │
│  - Format for iOS/Android              │
│  - Batch send                          │
└─────────────┬──────────────────────────┘
              │ Delivery
              ▼
┌─────────────────────────────────────────┐
│  User Devices Receive Notification     │
│  - Decrypt payload                      │
│  - Trigger system notification         │
│  - Play sound (if enabled)             │
│  - Show badge                          │
└─────────────┬──────────────────────────┘
              │ User Taps
              ▼
┌─────────────────────────────────────────┐
│  MobileApp Processes Notification      │
│  - Extract metadata                     │
│  - Display NotificationDetailScreen    │
│  - Log view event                      │
└─────────────────────────────────────────┘
```

### Alert Status Lifecycle

```
DRAFT → SCHEDULED → ACTIVE → RESOLVING → RESOLVED → ARCHIVED
  ↓                                          ↑
  └──────── CANCELLED ◄──────────────────────┘
```

---

## 9. Error Handling & Recovery

### Common Error Scenarios

| Error | Cause | Recovery |
|-------|-------|----------|
| Network timeout | Internet unavailable | Retry with exponential backoff |
| Invalid token | Session expired | Redirect to login |
| Permission denied | User unauthorized | Show permission request |
| Location denied | GPS not enabled | Show tutorial |
| API rate limit | Too many requests | Queue and retry later |
| Notification fail | Device offline | Store and send when online |

### Resilience Strategies

1. **Offline-First Architecture**
   - Cache all data locally
   - Queue operations when offline
   - Sync when connectivity restored

2. **Graceful Degradation**
   - Show cached data if API unavailable
   - Disable features that require connection
   - Inform user of limited functionality

3. **Retry Logic**
   - Exponential backoff (1s, 2s, 4s, 8s...)
   - Max 3 retries before user notification
   - Manual retry button

---

## 10. Security Measures

### Authentication & Authorization
- **OAuth 2.0** for mobile authentication
- **JWT** tokens with 24-hour expiry
- **Refresh tokens** for seamless re-auth
- **Role-based access control** (RBAC)

### Data Protection
- **End-to-end encryption** for sensitive data
- **Secure storage** via platform-specific solutions
- **HTTPS only** for all API calls
- **Token hashing** in storage

### Audit & Compliance
- **Complete audit trail** of all actions
- **Timestamps** on all records
- **User attribution** of changes
- **GDPR/CCPA** compliant data handling

---

**Status:** ✅ System Architecture Documented | Ready for Implementation

