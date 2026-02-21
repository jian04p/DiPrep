# 🎨 DiPrep Visual Summary & Quick Reference

## Complete Visual Architecture & Component Guide

---

## 📑 Quick Navigation

- [Color System](#color-system)
- [Screen Flow Diagram](#screen-flow-diagram)
- [Architecture Layers](#architecture-layers)
- [Component Hierarchy](#component-hierarchy)
- [Feature Map](#feature-map)
- [User Journey](#user-journey)
- [Data Model Relationships](#data-model-relationships)

---

## Color System

### Severity Alert Colors

```
┌─────────────────────────────────────────────────────┐
│ CRITICAL    🔴 #DC2626    Red-600                 │
│ HIGH        🟠 #EA580C    Orange-600               │
│ MEDIUM      🟡 #EAB308    Yellow-500               │
│ LOW         🟢 #16A34A    Green-600                │
│ INFO        🔵 #2563EB    Blue-600                 │
└─────────────────────────────────────────────────────┘
```

### Component Colors

```
┌─────────────────────────────────────────────────────┐
│ Background      #F9FAFB  (Gray-50, Light Mode)    │
│ Background      #111827  (Gray-900, Dark Mode)    │
│ Primary         #2563EB  (Blue-600)               │
│ Surface         #FFFFFF  (White)                  │
│ Text Primary    #111827  (Gray-900)               │
│ Text Secondary  #6B7280  (Gray-500)               │
│ Border          #E5E7EB  (Gray-200)               │
│ Success         #10B981  (Emerald-500)            │
│ Error           #EF4444  (Red-500)                │
│ Warning         #F59E0B  (Amber-500)              │
└─────────────────────────────────────────────────────┘
```

---

## Screen Flow Diagram

### Navigation Structure

```
                    ┌─────────────────┐
                    │  LaunchScreen   │
                    │  (Branding)     │
                    └────────┬────────┘
                             │
                    ┌────────▼────────┐
                    │ OnboardingScreen│
                    │  (Optional)     │
                    └────────┬────────┘
                             │
         ┌───────────────────┴───────────────────┐
         │                                       │
    ┌────▼─────┐                         ┌──────▼──────┐
    │LoginScreen│                        │RegisterScreen│
    └────┬─────┘                         └──────┬───────┘
         │                                       │
         └───────────────────┬───────────────────┘
                             │
                    ┌────────▼────────┐
                    │  HomeScreen     │
                    │  (6-Card Menu)  │
                    └────────┬────────┘
                             │
         ┌───────────┬───────┼───────┬─────────┬──────────┐
         │           │       │       │         │          │
    ┌────▼──┐  ┌─────▼──┐ ┌──▼───┐ ┌──▼───┐ ┌─▼──────┐ ┌─▼──────┐
    │Notif- │  │  Maps  │ │Hotline│ │Safety│ │Profile │ │Settings│
    │ications│  │ Screen │ │Screen │ │Screen│ │Screen │ │Screen │
    └────┬──┘  └───────┘ └───────┘ └──────┘ └────────┘ └──────┘
         │
    ┌────▼──────────────────┐
    │NotificationDetailScreen│
    │(Full Alert View)       │
    └──────────────────────┘
```

---

## Architecture Layers

### System Architecture Pyramid

```
                       ┌─────────────────────┐
                       │   Presentation      │
                       │   Layer (UI)        │
                       │  [Screens, Widgets] │
                       └──────────┬──────────┘
                                  │
                       ┌──────────▼───────────┐
                       │   Business Logic    │
                       │   Layer (State)     │
                       │  [Providers, Use   │
                       │   Cases]            │
                       └──────────┬──────────┘
                                  │
                       ┌──────────▼───────────┐
                       │   Service Layer     │
                       │   (External APIs)   │
                       │  [API, Storage,     │
                       │   Location]         │
                       └──────────┬──────────┘
                                  │
                       ┌──────────▼───────────┐
                       │   Data Layer        │
                       │   (Persistence)     │
                       │  [Models, Database] │
                       └─────────────────────┘
```

### Provider Dependency Tree

```
MultiProvider
├── AuthProvider (Session)
├── ThemeProvider (UI State)
├── NotificationProvider (Alerts)
├── LocationProvider (GPS)
└── SettingsProvider (Preferences)
```

---

## Component Hierarchy

### HomeScreen Component Tree

```
HomeScreen
├── AppBar
│   ├── Title ("DiPrep")
│   ├── User Avatar
│   └── Notification Badge
├── ScrollView
│   └── Column
│       ├── WelcomeCard
│       │   ├── Title
│       │   ├── User Name
│       │   └── Time Greeting
│       ├── AlertStatusCard (Red Background)
│       │   ├── Icon
│       │   ├── "View Active Alerts"
│       │   └── Badge (Active Count)
│       ├── MenuCard 1 (Notifications)
│       │   ├── Icon (🔔)
│       │   └── Label
│       ├── MenuCard 2 (Maps)
│       │   ├── Icon (🗺️)
│       │   └── Label
│       ├── MenuCard 3 (Hotlines)
│       │   ├── Icon (☎️)
│       │   └── Label
│       ├── MenuCard 4 (Safety)
│       │   ├── Icon (🛟)
│       │   └── Label
│       ├── MenuCard 5 (Profile)
│       │   ├── Icon (👤)
│       │   └── Label
│       └── MenuCard 6 (Settings)
│           ├── Icon (⚙️)
│           └── Label
└── BottomNavigationBar
    ├── Home (Active)
    ├── Notifications
    ├── Map
    └── Profile
```

### Notification Card Component

```
NotificationCard
├── BorderLeft (Colored by Severity)
├── Column
│   ├── Row
│   │   ├── Title (Bold)
│   │   └── SeverityBadge
│   │       ├── Background Color
│   │       └── Text ("CRITICAL", etc.)
│   ├── Message (Truncated to 2 lines)
│   ├── Row
│   │   ├── Category Icon
│   │   ├── Category Label
│   │   ├── Spacer
│   │   └── Timestamp
│   └── Row
│       ├── ActionButton (View)
│       └── ActionButton (Dismiss)
└── GestureDetector (Tap to Detail)
```

---

## Feature Map

### Mobile App Features

```
┌─ AUTHENTICATION
│  ├─ Login
│  ├─ Registration
│  ├─ Session Management
│  └─ Biometric (Future)
│
├─ ALERTS & NOTIFICATIONS
│  ├─ Real-time Push Notifications
│  ├─ Alert Details View
│  ├─ Alert History
│  ├─ Filter & Search
│  └─ Mark as Read/Unread
│
├─ EMERGENCY RESOURCES
│  ├─ Hotline Directory
│  ├─ One-Tap Calling
│  ├─ Safety Guidelines
│  └─ Offline Content
│
├─ MAPS & LOCATION
│  ├─ Incident Map View
│  ├─ Severity Visualization
│  ├─ GPS Integration
│  └─ Incident Reports (Future)
│
├─ USER ACCOUNT
│  ├─ Profile Management
│  ├─ Notification Preferences
│  ├─ Theme Selection
│  └─ Privacy Settings
│
└─ SYSTEM
   ├─ Offline Support
   ├─ Data Caching
   ├─ Dark Mode
   └─ Multi-language (Future)
```

### Admin Portal Features

```
┌─ DASHBOARD
│  ├─ System Metrics
│  ├─ Active Alerts Count
│  ├─ User Statistics
│  └─ Delivery Rate
│
├─ ALERT MANAGEMENT
│  ├─ Create Alert
│  ├─ Edit Active Alert
│  ├─ Close/Resolve Alert
│  ├─ View Alert History
│  └─ Bulk Operations
│
├─ USER MANAGEMENT
│  ├─ View All Users
│  ├─ Edit User Details
│  ├─ Deactivate/Delete User
│  └─ Permission Management
│
├─ CONTENT MANAGEMENT
│  ├─ Safety Guidelines
│  ├─ Hotline Numbers
│  ├─ Emergency Categories
│  └─ Media Upload
│
├─ ANALYTICS & REPORTING
│  ├─ Alert Distribution Report
│  ├─ User Activity Report
│  ├─ Response Time Metrics
│  └─ Export Reports
│
└─ SYSTEM SETTINGS
   ├─ Alert Configuration
   ├─ Severity Levels
   ├─ Backup Locations
   └─ API Keys
```

---

## User Journey

### End User Journey

```
1. DISCOVERY
   ├─ User opens app for first time
   ├─ Sees LaunchScreen (DiPrep branding)
   └─ Taps "Get Started"

2. ONBOARDING
   ├─ Views 3-step feature intro
   ├─ Learns about alerts, maps, hotlines
   └─ Taps "Complete"

3. AUTHENTICATION
   ├─ Chooses between Login/Register
   ├─ Enters email & password
   ├─ System verifies credentials
   └─ Stores JWT token

4. FIRST USE
   ├─ Arrives at HomeScreen
   ├─ Sees 6 main feature cards
   ├─ Explores app navigation
   └─ Adjusts settings/preferences

5. DAILY USE
   ├─ Receives emergency alert (push)
   ├─ Views in NotificationsScreen
   ├─ Taps alert for full details
   ├─ Views associated map/hotlines
   └─ Marks as read

6. ONGOING
   ├─ Checks app periodically
   ├─ Accesses safety guidelines
   ├─ Updates profile information
   └─ Adjusts notification preferences

7. EMERGENCY EVENT
   ├─ Critical alert received
   ├─ Sound/vibration trigger
   ├─ Views detailed instructions
   ├─ One-tap call emergency hotline
   └─ Views incident on map
```

### Coordinator Journey

```
1. LOGIN
   ├─ Coordinator accesses admin portal
   ├─ Enters admin credentials
   └─ Authenticates

2. MONITOR
   ├─ Views AdminDashboard
   ├─ Checks active alerts
   ├─ Reviews user statistics
   └─ Monitors delivery rates

3. INCIDENT OCCURS
   ├─ Receives emergency report
   ├─ Navigates to CreateAlertScreen
   ├─ Fills alert form:
   │   ├─ Title & Message
   │   ├─ Severity Level
   │   ├─ Category
   │   ├─ Geographic Area (radius)
   │   └─ Priority
   └─ Previews and submits

4. DISTRIBUTION
   ├─ System processes alert
   ├─ Targets affected users
   ├─ Sends push notifications
   └─ Coordinator sees delivery metrics

5. UPDATES
   ├─ Situation evolves
   ├─ Coordinator edits active alert
   ├─ Changes message/severity
   ├─ System sends update to users
   └─ Coordinator monitors feedback

6. RESOLUTION
   ├─ Emergency ended
   ├─ Coordinator resolves alert
   ├─ System notifies users
   ├─ Alert archived
   └─ Coordinator reviews report
```

---

## Data Model Relationships

### Entity Relationship Diagram

```
┌─────────────────┐
│     USER        │
├─────────────────┤
│ id (PK)         │ ◄─────────────────┐
│ email           │                   │
│ name            │                   │
│ phone           │                   │ 1..M
│ role            │                   │
│ created_at      │                   │
└─────────────────┘                   │
        │                             │
        │ 1..M                        │
        │                             │
        ▼                    ┌─────────────────────┐
┌─────────────────┐          │   NOTIFICATION     │
│    INCIDENT     │          ├─────────────────────┤
├─────────────────┤          │ id (PK)            │
│ id (PK)         │          │ user_id (FK)       │
│ title           │          │ incident_id (FK)   │
│ description     │          │ title              │
│ status          │          │ message            │
│ severity        │          │ severity           │
│ latitude        │          │ read_at            │
│ longitude       │          │ created_at         │
│ radius_km       │          └─────────────────────┘
│ start_time      │                   ▲
│ end_time        │                   │ 1..M
│ created_by (FK) │───┘               │
│ created_at      │        ┌──────────┘
└─────────────────┘        │
        │                  │
        └─ M..1 ────────────┘

┌──────────────────┐
│    SETTINGS      │
├──────────────────┤
│ id (PK)          │
│ user_id (FK)     │
│ dark_mode        │
│ notifications_on │
│ language         │
│ updated_at       │
└──────────────────┘
```

### Data Flow Diagram

```
    ┌─────────────┐
    │ MobileApp   │
    │   (User)    │
    └──────┬──────┘
           │
           │ HTTP Request
           ▼
    ┌─────────────────────┐
    │  Backend API        │
    │  (Node/Firebase)    │
    └──────┬──────────────┘
           │
    ┌──────┴────────────────┐
    │                       │
    ▼                       ▼
┌─────────────────┐  ┌──────────────────┐
│  Database       │  │  Notification    │
│  (Users, Alerts)│  │  Service         │
└─────────────────┘  │  (Firebase FCM)  │
                     └────────┬─────────┘
                              │
                              │ Push Notification
                              ▼
                         ┌──────────┐
                         │MobileApp │
                         │ (Other   │
                         │ Users)   │
                         └──────────┘
```

---

## Quick Reference Tables

### Screen Resolution Guidance

| Device Type | Width | Height | Density |
|------------|-------|--------|---------|
| Phone (Small) | 360px | 640px | 1x |
| Phone (Medium) | 412px | 732px | 1.5x |
| Phone (Large) | 480px | 854px | 2x |
| Tablet | 768px | 1024px | 1.5x |

### Spacing Reference

| Value | Size | Use Case |
|-------|------|----------|
| XS | 4px | Minimal gaps |
| SM | 8px | Small spacing |
| MD | 12px | Medium spacing |
| LG | 16px | Standard padding |
| XL | 24px | Large spacing |
| XXL | 32px | Sections |

### Font Sizes

| Style | Size | Weight | Usage |
|-------|------|--------|-------|
| H1 | 32px | Bold | Page titles |
| H2 | 24px | Bold | Section headers |
| Body | 16px | Regular | Main content |
| Caption | 12px | Regular | Helper text |

---

**Status:** ✅ Visual Architecture Documented | Design System Complete

