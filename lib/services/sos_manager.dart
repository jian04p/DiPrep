import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart' as ph;

/// High-reliability SOS Manager for background GPS tracking and emergency alerts
class SosManager {
  static final SosManager _instance = SosManager._internal();
  factory SosManager() => _instance;
  SosManager._internal();

  final FlutterBackgroundService _backgroundService = FlutterBackgroundService();
  bool _isServiceRunning = false;

  /// Initialize the background service
  Future<bool> initializeService() async {
    try {
      await _backgroundService.configure(
        androidConfiguration: AndroidConfiguration(
          onStart: onStart,
          autoStart: false,
          isForegroundMode: true,
          notificationChannelId: 'sos_emergency_channel',
          initialNotificationTitle: 'SOS Active',
          initialNotificationContent: 'Emergency broadcast is active',
          foregroundServiceNotificationId: 888,
          foregroundServiceTypes: [AndroidForegroundType.location],
        ),
        iosConfiguration: IosConfiguration(
          autoStart: false,
          onForeground: onStart,
          onBackground: onIosBackground,
        ),
      );
      return true;
    } catch (e) {
      print('Failed to initialize SOS service: $e');
      return false;
    }
  }

  /// Check and request all required permissions
  Future<ph.PermissionStatus> checkAndRequestPermissions() async {
    // Check location permission
    ph.PermissionStatus locationStatus = await ph.Permission.locationAlways.status;
    
    if (!locationStatus.isGranted) {
      locationStatus = await ph.Permission.locationAlways.request();
    }

    // Check notification permission (Android 13+)
    if (await ph.Permission.notification.isDenied) {
      await ph.Permission.notification.request();
    }

    return locationStatus;
  }

  /// Start the SOS emergency broadcast
  Future<bool> startSOS(String userId) async {
    // Validate userId
    if (userId.isEmpty) {
      print('SOS Error: userId is empty');
      return false;
    }

    if (_isServiceRunning) {
      print('SOS service already running');
      return true;
    }

    // Check permissions first
    final permissionStatus = await checkAndRequestPermissions();
    if (!permissionStatus.isGranted) {
      print('Location permission not granted');
      return false;
    }

    // Initialize and start the service
    final initialized = await initializeService();
    if (!initialized) {
      return false;
    }

    try {
      // Pass userId to the background service
      await _backgroundService.startService();
      _backgroundService.invoke('setUserId', {'userId': userId});
      _isServiceRunning = true;
    } catch (e) {
      print('SOS Error starting service: $e');
      _isServiceRunning = false;
      return false;
    }

    return true;
  }

  /// Stop the SOS emergency broadcast
  Future<void> stopSOS(String userId) async {
    if (!_isServiceRunning) {
      return;
    }

    // Update Firestore to mark as inactive
    try {
      await FirebaseFirestore.instance
          .collection('emergencies')
          .doc(userId)
          .update({
        'status': 'inactive',
        'endedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Failed to update Firestore on stop: $e');
    }

    _backgroundService.invoke('stopService');
    _isServiceRunning = false;
  }

  bool get isServiceRunning => _isServiceRunning;

  /// Background service entry point for iOS
  @pragma('vm:entry-point')
  static Future<bool> onIosBackground(ServiceInstance service) async {
    WidgetsFlutterBinding.ensureInitialized();
    DartPluginRegistrant.ensureInitialized();
    return true;
  }

  /// Background service entry point for Android
  @pragma('vm:entry-point')
  static void onStart(ServiceInstance service) async {
    DartPluginRegistrant.ensureInitialized();

    String? currentUserId;
    Timer? gpsTimer;

    // Listen for userId from main isolate
    service.on('setUserId').listen((event) {
      currentUserId = event?['userId'] as String?;
      print('SOS Service: UserId set to $currentUserId');

      // Start GPS broadcast timer
      gpsTimer?.cancel();
      gpsTimer = Timer.periodic(const Duration(seconds: 10), (timer) async {
        if (currentUserId != null) {
          await _broadcastLocation(currentUserId!, service);
        }
      });
    });

    // Listen for stop command
    service.on('stopService').listen((event) {
      gpsTimer?.cancel();
      service.stopSelf();
    });

    // Handle Android-specific foreground service
    if (service is AndroidServiceInstance) {
      service.on('setAsForeground').listen((event) {
        service.setAsForegroundService();
      });

      service.on('setAsBackground').listen((event) {
        service.setAsBackgroundService();
      });
    }

    // Immediate first broadcast
    if (currentUserId != null) {
      await _broadcastLocation(currentUserId!, service);
    }
  }

  /// Broadcast current GPS location to Firestore with retry logic
  static Future<void> _broadcastLocation(
    String userId,
    ServiceInstance service,
  ) async {
    if (userId.isEmpty) {
      print('SOS: Cannot broadcast - userId is empty');
      return;
    }

    const int maxRetries = 3;
    int retryCount = 0;

    while (retryCount < maxRetries) {
      try {
        // Get current position with timeout
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
          timeLimit: const Duration(seconds: 5),
        ).timeout(
          const Duration(seconds: 10),
          onTimeout: () {
            throw Exception('GPS timeout - location not available');
          },
        );

        // Write to Firestore
        await FirebaseFirestore.instance
            .collection('emergencies')
            .doc(userId)
            .set({
          'latitude': position.latitude,
          'longitude': position.longitude,
          'timestamp': FieldValue.serverTimestamp(),
          'status': 'active',
          'accuracy': position.accuracy,
          'altitude': position.altitude,
          'speed': position.speed,
          'heading': position.heading,
        }, SetOptions(merge: true)).timeout(
          const Duration(seconds: 10),
          onTimeout: () {
            throw Exception('Firestore write timeout');
          },
        );

        // Update notification with location info
        if (service is AndroidServiceInstance) {
          try {
            service.setForegroundNotificationInfo(
              title: 'SOS Active',
              content: 'Broadcasting location: ${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)}',
            );
          } catch (e) {
            print('SOS: Failed to update notification: $e');
          }
        }

        print('SOS: Location broadcast successful');
        return; // Success, exit retry loop

      } catch (e) {
        retryCount++;
        print('SOS: Broadcast failed (attempt $retryCount/$maxRetries): $e');

        if (retryCount < maxRetries) {
          // Exponential backoff: 2s, 4s, 8s
          await Future.delayed(Duration(seconds: 2 * retryCount));
        } else {
          // Final retry failed, update notification
          if (service is AndroidServiceInstance) {
            try {
              service.setForegroundNotificationInfo(
                title: 'SOS Active (Retry Connection)',
                content: 'Location update queued - will retry',
              );
            } catch (e) {
              print('SOS: Failed to update retry notification: $e');
            }
          }
        }
      }
    }
  }

  /// Check location service status
  static Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  /// Open app settings for permission management
  static Future<void> openAppSettings() async {
    try {
      await ph.openAppSettings();
    } catch (e) {
      print('Failed to open app settings: $e');
    }
  }
}
