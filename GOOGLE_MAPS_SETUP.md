# DiPrep Maps Setup Guide - FREE OpenStreetMap

## Overview
DiPrep now uses **OpenStreetMap** with **flutter_map** - completely free, no API keys required, no billing needed!

## What Changed
- ✅ Switched from Google Maps to OpenStreetMap
- ✅ No API keys needed
- ✅ No Google Cloud Console setup required
- ✅ No billing concerns
- ✅ Same great functionality (markers, circles, user location)

## Features
- 📍 Real-time map with evacuation centers and hazard zones
- 🎯 Tap locations to navigate and zoom
- 📊 Visual risk indicators and capacity information
- 🗺️ Interactive draggable location list
- 🔍 User location tracking with permission handling

## Quick Start
The map is already configured and will work immediately:

1. Run the app:
```bash
flutter clean
flutter pub get
flutter run
```

2. Go to the "Map" tab after logging in

3. The map will:
   - Show your current location
   - Display evacuation centers (green markers)
   - Display hazard zones (orange/red markers)
   - Show risk radius circles around hazard zones
   - Allow tapping to navigate

## What You See

### Map Markers
- 🏢 **Green markers** = Evacuation centers with capacity info
- ⚠️ **Orange/Red markers** = Hazard zones with risk levels

### Location List (Bottom Sheet)
- Tap tab to switch between evacuation centers and hazard zones
- Tap any location to navigate map to that spot
- See capacity and risk details

## No Configuration Needed!

Unlike Google Maps:
- ❌ No API keys to get
- ❌ No Google Cloud Console access needed
- ❌ No billing setup required
- ❌ No Android SHA-1 fingerprint needed
- ❌ No iOS bundle ID restrictions needed

Just run the app and the maps work!

## Technical Details

**Map Source**: OpenStreetMap (via Mapbox tiles)
**Package**: flutter_map 6.0.0
**Coordinate System**: WGS84 (latitude, longitude)
**Default Location**: Manila, Metro Manila, Philippines

## Customization

To change locations or add more evacuation centers/hazard zones:

Edit `lib/screens/mobile/home_screen.dart` and update:

```dart
final List<Map<String, dynamic>> evacuationCenters = const [
  {
    'name': 'Your Location Name',
    'latitude': 14.5995,
    'longitude': 120.9842,
    'capacity': 500,
    'type': 'evacuation',
  },
  // Add more...
];

final List<Map<String, dynamic>> hazardZones = const [
  {
    'name': 'Hazard Zone Name',
    'latitude': 14.5800,
    'longitude': 120.9800,
    'severity': 'high', // 'high' or 'medium'
    'type': 'flood',
  },
  // Add more...
];
```

## Permissions

Location permissions are still requested for:
- Getting user's current position
- Centering map on user location
- Better disaster alerts

Users can grant or deny location permission - the map still works!

## Troubleshooting

### Map shows blank/gray
- Check internet connection (needs to download map tiles)
- Wait a few seconds for tiles to load
- Zoom in/out to trigger tile loading

### Location not showing
- Make sure you granted location permission
- Check if location services are enabled on device
- Default falls back to Manila center if permission denied

### Markers not showing
- Ensure you're in the correct latitude/longitude range
- Default example uses Manila area (14.5-14.6 N, 120.9-121.0 E)

## Security
✅ No API keys to leak
✅ No billing data needed
✅ OpenStreetMap is open source and community-driven
✅ Your data doesn't go to Google

## Free Resources
- OpenStreetMap: https://www.openstreetmap.org/
- flutter_map docs: https://pub.dev/packages/flutter_map
- latlong2 docs: https://pub.dev/packages/latlong2

---

That's it! Your maps are ready to go, completely free! 🎉


