import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import '../../providers/auth_provider.dart';
import '../../providers/theme_provider.dart';
import '../../services/directions_repository.dart';
import '../../utils/constants.dart';
import 'chatbot_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late final TabController _tabController;
  LatLng? _userLocation;
  GoogleMapController? _mapController;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  final DirectionsRepository _directionsRepository = DirectionsRepository();
  DirectionsResult? _directionsResult;
  bool _notificationsEnabled = true;
  bool _locationEnabled = true;
  bool _emergencyAlertsEnabled = true;
  bool _batterySaverEnabled = false;
  bool _tipsEnabled = true;
  bool _isInteractingWithMap = false;
  
  // Manila center coordinates
  static const LatLng _manilaCenter = LatLng(14.5995, 120.9842);

  // Sample evacuation centers and hazard zones
  final List<Map<String, dynamic>> evacuationCenters = const [
    {
      'name': 'Barangay Hall - Zone A',
      'latitude': 14.6091,
      'longitude': 120.9824,
      'capacity': 500,
      'type': 'evacuation',
    },
    {
      'name': 'Sports Complex - Zone B',
      'latitude': 14.5945,
      'longitude': 120.9750,
      'capacity': 800,
      'type': 'evacuation',
    },
    {
      'name': 'Public School - Zone C',
      'latitude': 14.5850,
      'longitude': 120.9900,
      'capacity': 600,
      'type': 'evacuation',
    },
  ];
  final List<Map<String, dynamic>> hazardZones = const [
    {
      'name': 'Flood-Prone Area',
      'latitude': 14.5800,
      'longitude': 120.9800,
      'severity': 'high',
      'type': 'flood',
    },
    {
      'name': 'Industrial Zone',
      'latitude': 14.6150,
      'longitude': 120.9700,
      'severity': 'medium',
      'type': 'chemical',
    },
  ];

  final List<Map<String, dynamic>> preparednessTips = const [
    {
      'title': 'Typhoon Safety',
      'icon': '🌪️',
      'description': 'Prepare emergency kits, know evacuation routes',
      'details': 'Stay indoors, avoid windows. Have water, food, and first aid ready.',
      'image': 'assets/images/typhoon.svg',
    },
    {
      'title': 'Earthquake Safety',
      'icon': '🏚️',
      'description': 'Drop, Cover, Hold On protocol',
      'details': 'Identify safe spots. Move away from heavy objects.',
      'image': 'assets/images/earthquake.svg',
    },
    {
      'title': 'Flooding Awareness',
      'icon': '🌊',
      'description': 'Know your evacuation center location',
      'details': 'Never cross flooded areas. Move to higher ground immediately.',
      'image': 'assets/images/flooding.svg',
    },
    {
      'title': 'Fire Safety',
      'icon': '🔥',
      'description': 'Know emergency exits and fire extinguisher use',
      'details': 'Evacuate immediately. Never use elevators during fire.',
      'image': 'assets/images/fire.svg',
    },
    {
      'title': 'Chemical Spill',
      'icon': '☢️',
      'description': 'Avoid contaminated areas, follow official guidance',
      'details': 'Close windows. Stay tuned to emergency broadcasts.',
      'image': 'assets/images/chemical.svg',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _getUserLocation();
    _initializeMarkers();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  Future<void> _getUserLocation() async {
    try {
      final permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() => _userLocation = _manilaCenter);
        return;
      }
      
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      
      setState(() {
        _userLocation = LatLng(position.latitude, position.longitude);
      });
    } catch (e) {
      // Fallback to Manila center
      setState(() => _userLocation = _manilaCenter);
    }
  }

  void _initializeMarkers() {
    _markers.clear();
    
    // Add evacuation center markers
    for (var i = 0; i < evacuationCenters.length; i++) {
      final center = evacuationCenters[i];
      _markers.add(
        Marker(
          markerId: MarkerId('evacuation_$i'),
          position: LatLng(center['latitude'], center['longitude']),
          infoWindow: InfoWindow(
            title: center['name'],
            snippet: 'Capacity: ${center['capacity']} people',
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        ),
      );
    }
    
    // Add hazard zone markers
    for (var i = 0; i < hazardZones.length; i++) {
      final zone = hazardZones[i];
      final hue = zone['severity'] == 'high' 
          ? BitmapDescriptor.hueRed 
          : BitmapDescriptor.hueOrange;
      
      _markers.add(
        Marker(
          markerId: MarkerId('hazard_$i'),
          position: LatLng(zone['latitude'], zone['longitude']),
          infoWindow: InfoWindow(
            title: zone['name'],
            snippet: '${zone['severity'].toString().toUpperCase()} Risk',
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(hue),
        ),
      );
    }
  }

  double _calculateDistance(LatLng from, LatLng to) {
    const p = 0.017453292519943295;
    final a = 0.5 -
        cos((to.latitude - from.latitude) * p) / 2 +
        cos(from.latitude * p) *
            cos(to.latitude * p) *
            (1 - cos((to.longitude - from.longitude) * p)) /
            2;
    return 12742 * asin(sqrt(a));
  }

  Future<void> _navigateToNearestEvacuationCenter() async {
    if (_userLocation == null) return;
    
    // Find nearest evacuation center
    double minDistance = double.infinity;
    Map<String, dynamic>? nearestCenter;
    
    for (var center in evacuationCenters) {
      final distance = _calculateDistance(
        _userLocation!,
        LatLng(center['latitude'], center['longitude']),
      );
      
      if (distance < minDistance) {
        minDistance = distance;
        nearestCenter = center;
      }
    }
    
    if (nearestCenter == null) return;
    
    final destination = LatLng(
      nearestCenter['latitude'],
      nearestCenter['longitude'],
    );
    
    // Get directions
    final result = await _directionsRepository.getDirections(
      origin: _userLocation!,
      destination: destination,
    );
    
    if (result != null) {
      setState(() {
        _directionsResult = result;
        
        // Add polyline
        _polylines.clear();
        _polylines.add(
          Polyline(
            polylineId: const PolylineId('route'),
            color: AppColors.primary,
            width: 5,
            points: result.polylinePoints,
          ),
        );
      });
      
      // Animate camera to show route
      if (_mapController != null && result.polylinePoints.isNotEmpty) {
        _mapController!.animateCamera(
          CameraUpdate.newLatLngBounds(result.bounds, 100),
        );
      }
      
      // Show navigation info
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Navigate to Nearest Evacuation Center'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Destination: ${nearestCenter?['name'] ?? "Unknown"}'),
                const SizedBox(height: 8),
                Text(
                  'Distance: ${_directionsResult?.distance ?? "N/A"}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  'Duration: ${_directionsResult?.duration ?? "N/A"}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          ),
        );
      }
    }
  }

  Future<void> _animateToLocation(LatLng location) async {
    if (_mapController == null) return;
    
    _mapController!.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: location, zoom: 16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DiPrep - Disaster Preparedness'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthProvider>().logout();
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      ),
      body: _selectedIndex == 0
          ? _buildPreparednessMainPage(context)
          : _selectedIndex == 1
              ? _buildMapsTab(context)
              : _selectedIndex == 2
                  ? const ChatbotScreen()
                  : _selectedIndex == 3
                      ? _buildSettingsTab(context)
                      : _buildProfileTab(context),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() => _selectedIndex = index);
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.gray800,
        showUnselectedLabels: true,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble),
            label: 'AI Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildProfileTab(BuildContext context) {
      return Consumer<AuthProvider>(
        builder: (context, auth, _) {
          final user = auth.user;
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 48,
                    backgroundColor: AppColors.primary,
                    child: Icon(Icons.person, size: 56, color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    user?.name ?? 'User',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    user?.email ?? 'No email',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        icon: const Icon(Icons.edit),
                        label: const Text('Edit Profile'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[200],
                          foregroundColor: AppColors.primary,
                        ),
                        onPressed: () {
                          // TODO: Implement edit profile navigation
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Edit Profile not implemented.')),
                          );
                        },
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.lock),
                        label: const Text('Change Password'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[200],
                          foregroundColor: AppColors.primary,
                        ),
                        onPressed: () {
                          // TODO: Implement change password navigation
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Change Password not implemented.')),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.logout),
                    label: const Text('Logout'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      context.read<AuthProvider>().logout();
                      Navigator.pushReplacementNamed(context, '/');
                    },
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

  Widget _buildPreparednessMainPage(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome Section (light background, keeps accent colors)
          Consumer<AuthProvider>(
            builder: (context, auth, _) => Card(
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              color: isLight ? AppColors.primary : AppColors.primary,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Builder(
                      builder: (_) {
                        final userName = auth.user?.name;
                        final hasName = userName != null && userName.trim().isNotEmpty;
                        final welcomeText = hasName ? 'Welcome back, $userName!' : 'Welcome back!';
                        return Text(
                          welcomeText,
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                        );
                      },
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Your preparedness hub for quick safety guides.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.white70,
                          ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: isLight
                            ? Colors.white.withValues(alpha: 0.15)
                            : AppColors.primary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.security, color: Colors.white, size: 18),
                          const SizedBox(width: 8),
                          Text(
                            'Stay ready, not scared.',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          
          // Disaster Preparedness Cards
          Text(
            'Disaster Safety Guides',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          
          // Preparedness Cards Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: preparednessTips.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.9,
            ),
            itemBuilder: (context, index) {
              final tip = preparednessTips[index];
              return _buildPreparednessCard(context, tip);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPreparednessCard(BuildContext context, Map<String, dynamic> tip) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    return Card(
      elevation: 6,
      shadowColor: AppColors.primary.withValues(alpha: 0.35),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _showPreparednessDetail(context, tip),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: isLight
                ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.primary.withValues(alpha: 0.22),
                      AppColors.primaryLight.withValues(alpha: 0.26),
                    ],
                  )
                : LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.primaryDark.withValues(alpha: 0.24),
                      AppColors.primary.withValues(alpha: 0.18),
                    ],
                  ),
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.18)),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.25),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 48,
                    height: 48,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: tip['image'] != null
                          ? SvgPicture.asset(
                              tip['image'],
                              fit: BoxFit.cover,
                            )
                          : Container(
                              color: Colors.white,
                              child: Center(
                                child: Text(
                                  tip['icon'] ?? '⚠️',
                                  style: const TextStyle(fontSize: 26),
                                ),
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tip['title'] ?? '',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: isLight ? Colors.white : Colors.white,
                              ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          tip['description'] ?? '',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: isLight ? Colors.white70 : Colors.white70,
                              ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Learn more',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  Icon(
                    Icons.arrow_forward,
                    size: 16,
                    color: Colors.white,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsTab(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        Text(
          'Settings',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Column(
            children: [
              SwitchListTile(
                title: const Text('Push Notifications'),
                subtitle: const Text('Emergency updates and advisories'),
                value: _notificationsEnabled,
                onChanged: (value) => setState(() => _notificationsEnabled = value),
              ),
              const Divider(height: 1),
              SwitchListTile(
                title: const Text('Location Services'),
                subtitle: const Text('Enable maps and nearest center routing'),
                value: _locationEnabled,
                onChanged: (value) => setState(() => _locationEnabled = value),
              ),
              const Divider(height: 1),
              SwitchListTile(
                title: const Text('Emergency Alerts'),
                subtitle: const Text('Critical hazard notifications'),
                value: _emergencyAlertsEnabled,
                onChanged: (value) => setState(() => _emergencyAlertsEnabled = value),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.brightness_6),
                title: const Text('Theme'),
                subtitle: Text(
                  themeProvider.themeMode == ThemeMode.light
                      ? 'Light'
                      : themeProvider.themeMode == ThemeMode.dark
                          ? 'Dark'
                          : 'System',
                ),
              ),
              const Divider(height: 1),
              RadioListTile<ThemeMode>(
                title: const Text('System default'),
                value: ThemeMode.system,
                groupValue: themeProvider.themeMode,
                onChanged: (_) => themeProvider.setSystemMode(),
              ),
              const Divider(height: 1),
              RadioListTile<ThemeMode>(
                title: const Text('Light mode'),
                value: ThemeMode.light,
                groupValue: themeProvider.themeMode,
                onChanged: (_) => themeProvider.setLightMode(),
              ),
              const Divider(height: 1),
              RadioListTile<ThemeMode>(
                title: const Text('Dark mode'),
                value: ThemeMode.dark,
                groupValue: themeProvider.themeMode,
                onChanged: (_) => themeProvider.setDarkMode(),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Column(
            children: [
              SwitchListTile(
                title: const Text('Battery Saver'),
                subtitle: const Text('Reduce background activity'),
                value: _batterySaverEnabled,
                onChanged: (value) => setState(() => _batterySaverEnabled = value),
              ),
              const Divider(height: 1),
              SwitchListTile(
                title: const Text('Safety Tips'),
                subtitle: const Text('Show daily preparedness tips'),
                value: _tipsEnabled,
                onChanged: (value) => setState(() => _tipsEnabled = value),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Column(
            children: const [
              ListTile(
                leading: Icon(Icons.language),
                title: Text('Language'),
                subtitle: Text('English'),
              ),
              Divider(height: 1),
              ListTile(
                leading: Icon(Icons.privacy_tip),
                title: Text('Privacy Policy'),
              ),
              Divider(height: 1),
              ListTile(
                leading: Icon(Icons.description),
                title: Text('Terms of Service'),
              ),
              Divider(height: 1),
              ListTile(
                leading: Icon(Icons.help_outline),
                title: Text('Help & Feedback'),
              ),
              Divider(height: 1),
              ListTile(
                leading: Icon(Icons.info_outline),
                title: Text('About'),
                subtitle: Text('DiPrep Emergency App'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showPreparednessDetail(BuildContext context, Map<String, dynamic> tip) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle bar
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                
                // Title and Icon
                Row(
                  children: [
                    if (tip['image'] != null)
                      SizedBox(
                        width: 80,
                        height: 80,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: SvgPicture.asset(
                            tip['image'],
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    else
                      Text(
                        tip['icon'] ?? '⚠️',
                        style: const TextStyle(fontSize: 60),
                      ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tip['title'] ?? '',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'Safety Guide',
                              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                
                // Tutorial Content
                Text(
                  'What to Do',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Text(
                    tip['details'] ?? 'Learn the essential safety procedures',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.justify,
                  ),
                ),
                const SizedBox(height: 24),
                
                // Safety Checklist
                Text(
                  'Preparation Checklist',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 12),
                ..._buildChecklistItems(tip),
                
                const SizedBox(height: 32),
                
                // Close Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Got It!'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildChecklistItems(Map<String, dynamic> tip) {
    final checklistMap = {
      'Typhoon Safety': [
        'Secure windows and doors',
        'Stock food and water (1-2 weeks)',
        'Keep first aid kit ready',
        'Charge all devices',
        'Know evacuation routes',
      ],
      'Earthquake Safety': [
        'Identify safe spots in each room',
        'Secure heavy furniture',
        'Know how to stop gas leaks',
        'Store emergency supplies',
        'Practice drop, cover, hold on',
      ],
      'Flooding Awareness': [
        'Know evacuation center location',
        'Have waterproof documents ready',
        'Stock non-perishable food',
        'Keep emergency medicines',
        'Have rescue equipment nearby',
      ],
      'Fire Safety': [
        'Know all emergency exits',
        'Have fire extinguisher ready',
        'Prepare escape plan',
        'Keep important documents safe',
        'Teach family escape procedures',
      ],
      'Chemical Spill Safety': [
        'Know nearby hazmat facilities',
        'Have masks and gloves ready',
        'Know decontamination areas',
        'Stock potassium iodide (if needed)',
        'Know safe routes away from hazards',
      ],
    };

    final checklist = checklistMap[tip['title']] ?? [];
    
    return checklist.map((item) => Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            margin: const EdgeInsets.only(right: 12, top: 2),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Icon(
              Icons.check,
              size: 16,
              color: AppColors.primary,
            ),
          ),
          Expanded(
            child: Text(
              item,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    )).toList();
  }

  Widget _buildEvacuationCenterCard(Map<String, dynamic> center) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: InkWell(
          onTap: () => _animateToLocation(
            LatLng(
              center['latitude'],
              center['longitude'],
            ),
          ),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Text('🏢', style: TextStyle(fontSize: 20)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            center['name'] as String,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Capacity: ${center['capacity']} people',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.location_on,
                      color: AppColors.primary,
                      size: 20,
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

  Widget _buildHazardZoneCard(Map<String, dynamic> zone) {
    final color = zone['severity'] == 'high' ? AppColors.critical : AppColors.high;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: color.withValues(alpha: 0.3),
            width: 2,
          ),
        ),
        child: InkWell(
          onTap: () => _animateToLocation(
            LatLng(
              zone['latitude'],
              zone['longitude'],
            ),
          ),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Text('⚠️', style: TextStyle(fontSize: 20)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            zone['name'] as String,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: color.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              '${zone['severity'].toString().toUpperCase()} Risk',
                              style: TextStyle(
                                fontSize: 11,
                                color: color,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
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

  Widget _buildMapsTab(BuildContext context) {
    return _userLocation == null
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.hasBoundedWidth
                  ? constraints.maxWidth
                  : MediaQuery.sizeOf(context).width;
              final height = constraints.hasBoundedHeight
                  ? max(400.0, constraints.maxHeight)
                  : 400.0;
              return SizedBox(
                width: width,
                height: height,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    minHeight: 400,
                    minWidth: double.infinity,
                  ),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Google Map with explicit size constraints for hit testing
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        child: GoogleMap(
                          onMapCreated: (controller) {
                            _mapController = controller;
                          },
                          onTap: (latLng) => _animateToLocation(latLng),
                          onCameraMoveStarted: () {
                            if (!_isInteractingWithMap) {
                              setState(() => _isInteractingWithMap = true);
                            }
                          },
                          onCameraIdle: () {
                            if (_isInteractingWithMap) {
                              setState(() => _isInteractingWithMap = false);
                            }
                          },
                          initialCameraPosition: CameraPosition(
                            target: _userLocation ?? _manilaCenter,
                            zoom: 14.0,
                          ),
                          markers: _markers,
                          polylines: _polylines,
                          myLocationEnabled: true,
                          myLocationButtonEnabled: true,
                          zoomControlsEnabled: true,
                          scrollGesturesEnabled: true,
                          zoomGesturesEnabled: true,
                          rotateGesturesEnabled: true,
                          tiltGesturesEnabled: true,
                          compassEnabled: true,
                          mapToolbarEnabled: true,
                          gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
                            Factory<OneSequenceGestureRecognizer>(() => EagerGestureRecognizer()),
                          },
                        ),
                      ),
                      // Bottom sheet with locations and route info
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: IgnorePointer(
                          ignoring: _isInteractingWithMap,
                          child: DraggableScrollableSheet(
                            initialChildSize: 0.25,
                            minChildSize: 0.15,
                            maxChildSize: 0.6,
                            expand: false,
                            builder: (context, scrollController) => DecoratedBox(
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                              ),
                              child: ConstrainedBox(
                                constraints: const BoxConstraints.expand(),
                                child: Column(
                                  children: [
                                    // Handle bar
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Container(
                                        width: 40,
                                        height: 4,
                                        decoration: BoxDecoration(
                                          color: Colors.grey[300],
                                          borderRadius: BorderRadius.circular(2),
                                        ),
                                      ),
                                    ),
                                    // Show route info if available
                                    if (_directionsResult != null)
                                      Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color: AppColors.primary.withValues(alpha: 0.1),
                                            borderRadius: BorderRadius.circular(8),
                                            border: Border.all(
                                              color: AppColors.primary.withValues(alpha: 0.3),
                                            ),
                                          ),
                                          padding: const EdgeInsets.all(12.0),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                'Route Details',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        'Distance: ${_directionsResult?.distance ?? "N/A"}',
                                                        style: const TextStyle(fontSize: 13),
                                                      ),
                                                      const SizedBox(height: 4),
                                                      Text(
                                                        'Duration: ${_directionsResult?.duration ?? "N/A"}',
                                                        style: const TextStyle(fontSize: 13),
                                                      ),
                                                    ],
                                                  ),
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        _directionsResult = null;
                                                        _polylines.clear();
                                                      });
                                                    },
                                                    style: ElevatedButton.styleFrom(
                                                      backgroundColor: Colors.grey[300],
                                                      foregroundColor: Colors.black,
                                                    ),
                                                    child: const Text('Clear'),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          TabBar(
                                            controller: _tabController,
                                            labelColor: AppColors.primary,
                                            unselectedLabelColor: Colors.grey,
                                            indicatorColor: AppColors.primary,
                                            tabs: const [
                                              Tab(text: '🏢 Evacuation Centers'),
                                              Tab(text: '⚠️ Hazard Zones'),
                                            ],
                                          ),
                                          Expanded(
                                            child: AnimatedBuilder(
                                              animation: _tabController,
                                              builder: (context, _) {
                                                final isEvacuation = _tabController.index == 0;
                                                final data = isEvacuation ? evacuationCenters : hazardZones;
                                                return ListView.builder(
                                                  controller: scrollController,
                                                  physics: const ClampingScrollPhysics(),
                                                  itemCount: data.length,
                                                  itemBuilder: (context, index) {
                                                    return isEvacuation
                                                        ? _buildEvacuationCenterCard(
                                                            data[index] as Map<String, dynamic>,
                                                          )
                                                        : _buildHazardZoneCard(
                                                            data[index] as Map<String, dynamic>,
                                                          );
                                                  },
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
  }
}

// (unused helper removed)

