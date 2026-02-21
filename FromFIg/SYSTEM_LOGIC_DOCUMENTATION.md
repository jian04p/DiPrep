# SafeAlert System Logic & Architecture Documentation

## Table of Contents
1. [System Overview](#system-overview)
2. [System Architecture](#system-architecture)
3. [Actors](#actors)
4. [Use Cases](#use-cases)
5. [Component Architecture](#component-architecture)
6. [Data Models](#data-models)
7. [State Management](#state-management)
8. [User Flows](#user-flows)
9. [Business Logic](#business-logic)

---

## 1. System Overview

**SafeAlert** is a dual-interface emergency alert system consisting of:
- **Mobile Application**: For end-users to receive alerts, access safety information, and report incidents
- **Admin Web Portal**: For administrators to manage users, send alerts, and configure system settings

**Technology Stack**:
- Frontend: React with TypeScript
- Styling: Tailwind CSS v4
- State: React Hooks (useState, useEffect)
- Storage: localStorage for client-side persistence
- Icons: Lucide React

---

## 2. System Architecture

### 2.1 High-Level Architecture

```
┌─────────────────────────────────────────────────────┐
│                    App.tsx                          │
│              (Main Entry Point)                     │
│  - View Mode Toggle (Mobile/Admin)                 │
│  - Responsive Screen Detection                     │
└────────────────┬────────────────────────────────────┘
                 │
        ┌────────┴─────────┐
        │                  │
┌───────▼────────┐  ┌─────▼──────────┐
│  MobileApp     │  │   AdminApp     │
│  Component     │  │   Component    │
└───────┬────────┘  └─────┬──────────┘
        │                 │
        │                 │
   Mobile Screens    Admin Screens
```

### 2.2 Application Layers

1. **Presentation Layer**: UI Components (Screens)
2. **State Management Layer**: React State Hooks
3. **Business Logic Layer**: Component logic and handlers
4. **Persistence Layer**: localStorage

---

## 3. Actors

### 3.1 Primary Actors

1. **End User (Mobile User)**
   - Role: General public using the mobile application
   - Capabilities: View alerts, access safety info, report incidents
   - Authentication: Email/Password

2. **Administrator**
   - Role: System administrator managing the platform
   - Capabilities: User management, alert creation, system configuration
   - Authentication: Admin credentials

### 3.2 Secondary Actors

3. **System**
   - Automatic notifications
   - Background services
   - Data persistence

---

## 4. Use Cases

### 4.1 Mobile Application Use Cases

#### UC-M01: User Registration
- **Actor**: End User
- **Precondition**: User has not registered
- **Main Flow**:
  1. User navigates to registration screen
  2. User enters name, email, phone, password
  3. System validates input
  4. System creates user account
  5. User is redirected to home screen
- **Postcondition**: User account created and logged in

#### UC-M02: User Login
- **Actor**: End User
- **Precondition**: User has registered account
- **Main Flow**:
  1. User enters email and password
  2. System validates credentials
  3. System authenticates user
  4. User redirected to home screen
- **Postcondition**: User authenticated and logged in

#### UC-M03: View Emergency Map
- **Actor**: End User
- **Precondition**: User is logged in
- **Main Flow**:
  1. User selects Maps from home screen
  2. System displays map with incident markers
  3. User can view incident details by tapping markers
  4. User can filter incidents by category
- **Postcondition**: User views location-based emergency information

#### UC-M04: Access Emergency Hotlines
- **Actor**: End User
- **Precondition**: User is logged in
- **Main Flow**:
  1. User selects Hotlines from home screen
  2. System displays categorized emergency contacts
  3. User taps phone icon to initiate call
  4. System triggers device phone app
- **Postcondition**: User can contact emergency services

#### UC-M05: View Notifications
- **Actor**: End User
- **Precondition**: User is logged in
- **Main Flow**:
  1. User selects Notifications from home screen
  2. System displays list of notifications
  3. User can swipe to dismiss notifications
  4. User can tap notification for details
- **Postcondition**: User views and manages notifications

#### UC-M06: View Notification Details
- **Actor**: End User
- **Precondition**: User has selected a notification
- **Main Flow**:
  1. System displays full notification details
  2. User can view severity, category, timestamp
  3. User can share or save notification
- **Postcondition**: User views complete notification information

#### UC-M07: Access Safety Guidelines
- **Actor**: End User
- **Precondition**: User is logged in
- **Main Flow**:
  1. User selects Safety from home screen
  2. System displays categorized safety guidelines
  3. User expands categories to view details
  4. User can bookmark guidelines
- **Postcondition**: User accesses safety information

#### UC-M08: Manage Profile
- **Actor**: End User
- **Precondition**: User is logged in
- **Main Flow**:
  1. User navigates to Profile screen
  2. User edits personal information
  3. User adds/removes emergency contacts
  4. System validates and saves changes
- **Postcondition**: User profile updated

#### UC-M09: Configure Settings
- **Actor**: End User
- **Precondition**: User is logged in
- **Main Flow**:
  1. User navigates to Settings screen
  2. User toggles dark mode
  3. User configures notification preferences
  4. User sets location permissions
  5. System saves settings
- **Postcondition**: User preferences updated

#### UC-M10: View History
- **Actor**: End User
- **Precondition**: User is logged in
- **Main Flow**:
  1. User navigates to History screen
  2. System displays activity history
  3. User can filter by date/type
  4. User can export history
- **Postcondition**: User views activity logs

#### UC-M11: Complete Onboarding
- **Actor**: End User (First Time)
- **Precondition**: First app launch
- **Main Flow**:
  1. System displays onboarding slides
  2. User navigates through features introduction
  3. User completes onboarding
  4. System marks onboarding as complete
- **Postcondition**: User understands app features

#### UC-M12: Report Incident (Quick Action)
- **Actor**: End User
- **Precondition**: User is logged in
- **Main Flow**:
  1. User taps floating action button
  2. User selects "Report Incident"
  3. User provides incident details
  4. System logs incident
- **Postcondition**: Incident reported

### 4.2 Admin Application Use Cases

#### UC-A01: Admin Login
- **Actor**: Administrator
- **Precondition**: Admin has credentials
- **Main Flow**:
  1. Admin enters username and password
  2. System validates admin credentials
  3. System authenticates admin
  4. Admin redirected to dashboard
- **Postcondition**: Admin authenticated

#### UC-A02: View Dashboard Statistics
- **Actor**: Administrator
- **Precondition**: Admin is logged in
- **Main Flow**:
  1. System displays dashboard with statistics
  2. Admin views total users, active alerts, locations
  3. Admin sees trend indicators
- **Postcondition**: Admin has system overview

#### UC-A03: Manage Users (CRUD)
- **Actor**: Administrator
- **Precondition**: Admin is logged in
- **Main Flow**:
  1. Admin navigates to User Management
  2. Admin can:
     - Create: Add new user
     - Read: View user details
     - Update: Edit user information
     - Delete: Remove user account
  3. System updates user database
- **Postcondition**: User records modified

#### UC-A04: Manage Emergency Information
- **Actor**: Administrator
- **Precondition**: Admin is logged in
- **Main Flow**:
  1. Admin navigates to Emergency Info
  2. Admin adds/edits emergency hotlines
  3. Admin categorizes emergencies
  4. System saves emergency data
- **Postcondition**: Emergency information updated

#### UC-A05: Manage Map Locations
- **Actor**: Administrator
- **Precondition**: Admin is logged in
- **Main Flow**:
  1. Admin navigates to Map Management
  2. Admin adds/updates incident locations
  3. Admin sets incident category and severity
  4. System updates map data
- **Postcondition**: Map locations updated

#### UC-A06: Create and Schedule Notifications
- **Actor**: Administrator
- **Precondition**: Admin is logged in
- **Main Flow**:
  1. Admin navigates to Notification Management
  2. Admin creates notification with:
     - Title, message, severity
     - Target audience
     - Schedule time
  3. System queues notification
  4. System sends notification at scheduled time
- **Postcondition**: Notification sent to users

#### UC-A07: Manage Safety Guidelines
- **Actor**: Administrator
- **Precondition**: Admin is logged in
- **Main Flow**:
  1. Admin navigates to Safety Guidelines
  2. Admin creates/edits guidelines
  3. Admin categorizes guidelines
  4. System publishes guidelines
- **Postcondition**: Safety guidelines updated

#### UC-A08: Configure System Settings
- **Actor**: Administrator
- **Precondition**: Admin is logged in
- **Main Flow**:
  1. Admin navigates to System Settings
  2. Admin configures:
     - System name/logo
     - Notification defaults
     - Security settings
  3. System applies settings
- **Postcondition**: System configuration updated

---

## 5. Component Architecture

### 5.1 Mobile Application Components

```
MobileApp (Container)
├── Onboarding
├── LaunchScreen
├── LoginScreen
├── RegisterScreen
├── HomeScreen
│   └── ConfirmationToast
├── MapsScreen
├── HotlinesScreen
├── NotificationsScreen
│   └── NotificationDetailScreen
├── SafetyGuidelinesScreen
├── ProfileScreen
├── SettingsScreen
└── HistoryScreen
```

### 5.2 Admin Application Components

```
AdminApp (Container)
├── AdminLogin
├── Dashboard
├── UserManagement
├── EmergencyInfo
├── MapManagement
├── NotificationManagement
├── SafetyGuidelinesManagement
└── SystemSettings
```

### 5.3 Shared Components

- UI Components (from `/components/ui/`)
- ImageWithFallback (Protected)

---

## 6. Data Models

### 6.1 User Model
```typescript
interface User {
  id: string;
  name: string;
  email: string;
  phone: string;
  password: string; // Hashed in production
  status: 'Active' | 'Inactive';
  joined: string; // ISO date
  emergencyContacts?: EmergencyContact[];
  preferences?: UserPreferences;
}
```

### 6.2 Emergency Contact Model
```typescript
interface EmergencyContact {
  id: string;
  name: string;
  relationship: string;
  phone: string;
}
```

### 6.3 Notification Model
```typescript
interface Notification {
  id: string;
  title: string;
  message: string;
  severity: 'Critical' | 'High' | 'Medium' | 'Low';
  category: string;
  timestamp: string;
  read: boolean;
  priority: number;
}
```

### 6.4 Map Incident Model
```typescript
interface MapIncident {
  id: string;
  type: 'Fire' | 'Flood' | 'Accident' | 'Medical' | 'Crime';
  location: {
    lat: number;
    lng: number;
    address: string;
  };
  severity: 'Critical' | 'High' | 'Medium' | 'Low';
  status: 'Active' | 'Resolved';
  timestamp: string;
  description: string;
  responders?: number;
}
```

### 6.5 Hotline Model
```typescript
interface Hotline {
  id: string;
  name: string;
  category: string;
  phone: string;
  available: boolean;
  description?: string;
}
```

### 6.6 Safety Guideline Model
```typescript
interface SafetyGuideline {
  id: string;
  category: string;
  title: string;
  content: string;
  icon: string;
  lastUpdated: string;
}
```

### 6.7 Admin Model
```typescript
interface Admin {
  id: string;
  name: string;
  email: string;
  role: 'Super Admin' | 'Admin' | 'Moderator';
  permissions: string[];
}
```

### 6.8 User Preferences Model
```typescript
interface UserPreferences {
  darkMode: boolean;
  notifications: {
    push: boolean;
    email: boolean;
    sms: boolean;
  };
  location: boolean;
  language: string;
}
```

### 6.9 Activity History Model
```typescript
interface ActivityHistory {
  id: string;
  userId: string;
  action: string;
  timestamp: string;
  details: any;
}
```

---

## 7. State Management

### 7.1 App-Level State (App.tsx)
```typescript
- viewMode: 'mobile' | 'admin'
```

### 7.2 Mobile App State (MobileApp.tsx)
```typescript
- currentScreen: MobileScreen
- user: User | null
- selectedNotification: Notification | null
- darkMode: boolean
- hasCompletedOnboarding: boolean
```

### 7.3 Admin App State (AdminApp.tsx)
```typescript
- currentScreen: AdminScreen
- admin: Admin | null
```

### 7.4 Screen-Specific State Examples

**HomeScreen**:
```typescript
- showEmergencyBanner: boolean
- showQuickAction: boolean
```

**NotificationsScreen**:
```typescript
- notifications: Notification[]
- filter: string
```

**UserManagement**:
```typescript
- users: User[]
- searchTerm: string
- showAddModal: boolean
```

---

## 8. User Flows

### 8.1 First-Time User Flow
```
1. App Launch
   ↓
2. Onboarding Screen
   - Swipe through feature introduction
   - Complete onboarding
   ↓
3. Launch Screen
   ↓
4. Register Screen
   - Enter details
   - Submit
   ↓
5. Home Screen
   - Authenticated
```

### 8.2 Returning User Flow
```
1. App Launch
   ↓
2. Launch Screen
   ↓
3. Login Screen
   - Enter credentials
   - Authenticate
   ↓
4. Home Screen
```

### 8.3 View Notification Flow
```
1. Home Screen
   ↓
2. Tap Notifications
   ↓
3. Notifications List
   - Can swipe to dismiss
   - Tap notification
   ↓
4. Notification Detail Screen
   - View full details
   - Back to list
```

### 8.4 Emergency Call Flow
```
1. Home Screen
   ↓
2. Tap Hotlines
   ↓
3. Hotlines Screen
   - View categorized contacts
   - Tap phone icon
   ↓
4. Initiate Device Call
```

### 8.5 Admin Create Notification Flow
```
1. Admin Dashboard
   ↓
2. Navigate to Notifications
   ↓
3. Notification Management Screen
   - Click "Create Notification"
   ↓
4. Fill Notification Form
   - Title, message, severity
   - Schedule time
   ↓
5. Submit
   ↓
6. Notification Queued/Sent
```

---

## 9. Business Logic

### 9.1 Authentication Logic

**Mobile Login**:
```typescript
function handleLogin(email: string, password: string) {
  // 1. Validate input
  if (!email || !password) return error;
  
  // 2. Check credentials (mock)
  const user = mockUsers.find(u => u.email === email);
  
  // 3. Set user state
  if (user) {
    setUser(user);
    setCurrentScreen('home');
  }
}
```

**Admin Login**:
```typescript
function handleAdminLogin(username: string, password: string) {
  // 1. Validate credentials
  if (username === 'admin' && password === 'admin123') {
    const admin = { name: 'Admin', role: 'Super Admin' };
    setAdmin(admin);
    setCurrentScreen('dashboard');
  }
}
```

### 9.2 Navigation Logic

**Screen Navigation**:
```typescript
function navigate(screen: MobileScreen | AdminScreen) {
  setCurrentScreen(screen);
}

function goBack() {
  // Return to previous screen or home
  setCurrentScreen('home');
}
```

### 9.3 Notification Logic

**Swipe to Dismiss**:
```typescript
function handleSwipe(notificationId: string, direction: 'left' | 'right') {
  if (Math.abs(swipeDistance) > threshold) {
    // Remove notification from list
    setNotifications(prev => prev.filter(n => n.id !== notificationId));
    showToast('Notification dismissed');
  }
}
```

**Filter Notifications**:
```typescript
function filterNotifications(category: string) {
  return notifications.filter(n => 
    category === 'all' || n.category === category
  );
}
```

### 9.4 Map Logic

**Display Incident Markers**:
```typescript
function renderIncidents() {
  return incidents.map(incident => ({
    position: { lat: incident.location.lat, lng: incident.location.lng },
    color: getSeverityColor(incident.severity),
    type: incident.type
  }));
}
```

**Filter Incidents**:
```typescript
function filterIncidents(type: string) {
  return incidents.filter(i => 
    type === 'all' || i.type === type
  );
}
```

### 9.5 Settings Logic

**Toggle Dark Mode**:
```typescript
function toggleDarkMode() {
  setDarkMode(prev => !prev);
  // Apply to all screens via prop drilling
}
```

**Save Preferences**:
```typescript
function savePreferences(prefs: UserPreferences) {
  setUser(prev => ({ ...prev, preferences: prefs }));
  localStorage.setItem('preferences', JSON.stringify(prefs));
}
```

### 9.6 CRUD Operations (Admin)

**Create User**:
```typescript
function createUser(userData: Partial<User>) {
  const newUser = {
    id: generateId(),
    ...userData,
    status: 'Active',
    joined: new Date().toISOString()
  };
  setUsers(prev => [...prev, newUser]);
}
```

**Update User**:
```typescript
function updateUser(id: string, updates: Partial<User>) {
  setUsers(prev => prev.map(u => 
    u.id === id ? { ...u, ...updates } : u
  ));
}
```

**Delete User**:
```typescript
function deleteUser(id: string) {
  if (confirm('Delete user?')) {
    setUsers(prev => prev.filter(u => u.id !== id));
  }
}
```

### 9.7 Onboarding Logic

**Check Onboarding Status**:
```typescript
useEffect(() => {
  const completed = localStorage.getItem('onboardingComplete');
  if (completed === 'true') {
    setHasCompletedOnboarding(true);
    setCurrentScreen('launch');
  } else {
    setCurrentScreen('onboarding');
  }
}, []);
```

**Complete Onboarding**:
```typescript
function completeOnboarding() {
  localStorage.setItem('onboardingComplete', 'true');
  setHasCompletedOnboarding(true);
  setCurrentScreen('launch');
}
```

### 9.8 History Tracking

**Log Activity**:
```typescript
function logActivity(action: string, details: any) {
  const activity = {
    id: generateId(),
    userId: user.id,
    action,
    timestamp: new Date().toISOString(),
    details
  };
  
  const history = JSON.parse(localStorage.getItem('history') || '[]');
  history.push(activity);
  localStorage.setItem('history', JSON.stringify(history));
}
```

### 9.9 Emergency Contact Management

**Add Emergency Contact**:
```typescript
function addEmergencyContact(contact: EmergencyContact) {
  setUser(prev => ({
    ...prev,
    emergencyContacts: [...(prev.emergencyContacts || []), contact]
  }));
}
```

**Remove Emergency Contact**:
```typescript
function removeEmergencyContact(contactId: string) {
  setUser(prev => ({
    ...prev,
    emergencyContacts: prev.emergencyContacts?.filter(c => c.id !== contactId)
  }));
}
```

### 9.10 Notification Scheduling (Admin)

**Schedule Notification**:
```typescript
function scheduleNotification(notification: Notification, scheduleTime: Date) {
  const scheduled = {
    ...notification,
    id: generateId(),
    scheduledFor: scheduleTime.toISOString(),
    status: 'Scheduled'
  };
  
  // In production, this would use a backend service
  setScheduledNotifications(prev => [...prev, scheduled]);
}
```

---

## 10. Relationships and Dependencies

### 10.1 Component Dependencies

**MobileApp depends on**:
- All mobile screen components
- User state
- Navigation logic

**AdminApp depends on**:
- All admin screen components
- Admin state
- Navigation logic

### 10.2 Data Dependencies

**HomeScreen depends on**:
- User data (for display)
- Notification count
- Dark mode preference

**NotificationsScreen depends on**:
- Notification data
- Filter state

**Dashboard depends on**:
- System statistics
- Admin data

---

## 11. Key Features Summary

### Mobile Application
1. **Onboarding**: First-time user introduction
2. **Authentication**: Login/Register
3. **Emergency Maps**: Location-based incident viewing
4. **Hotlines**: Quick access to emergency contacts
5. **Notifications**: Alert management with swipe gestures
6. **Safety Guidelines**: Categorized safety information
7. **Profile Management**: Personal info + emergency contacts
8. **Settings**: Dark mode, preferences
9. **History**: Activity tracking
10. **Quick Actions**: Floating action button for rapid access

### Admin Portal
1. **Dashboard**: System overview with statistics
2. **User Management**: Full CRUD operations
3. **Emergency Info Management**: Hotline management
4. **Map Management**: Incident location updates
5. **Notification Management**: Create and schedule alerts
6. **Safety Guidelines Management**: Content management
7. **System Settings**: Configuration options

---

## 12. Security Considerations (For Production)

1. **Authentication**: JWT tokens, secure password hashing
2. **Authorization**: Role-based access control
3. **Data Validation**: Input sanitization
4. **HTTPS**: Encrypted communication
5. **Rate Limiting**: Prevent abuse
6. **Audit Logging**: Track admin actions

---

## 13. Future Enhancements

1. **Real-time Updates**: WebSocket integration
2. **Push Notifications**: FCM/APNS integration
3. **Geolocation**: Real-time user location
4. **Multi-language**: i18n support
5. **Analytics**: User behavior tracking
6. **Offline Mode**: Service workers
7. **Media Upload**: Image/video incident reporting
8. **Chat Support**: In-app messaging

---

## Diagram Suggestions

### UML Diagrams to Create:

1. **Class Diagram**: Show all data models and their relationships
2. **Component Diagram**: System architecture and component relationships
3. **Sequence Diagrams**: For each major use case (login, create notification, etc.)
4. **State Diagram**: Application state transitions
5. **Activity Diagram**: User and admin workflows
6. **Deployment Diagram**: System deployment architecture

### Use Case Diagrams to Create:

1. **Mobile User Use Case Diagram**: All mobile use cases with End User actor
2. **Admin Use Case Diagram**: All admin use cases with Administrator actor
3. **System Use Case Diagram**: Combined view showing all actors and use cases

---

This documentation provides the complete logic and structure of your DiPrep application for creating comprehensive UML and use case diagrams.