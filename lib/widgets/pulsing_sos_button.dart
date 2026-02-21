import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../services/sos_manager.dart';

/// A pulsing SOS button component with animation and permission handling
class PulsingSosButton extends StatefulWidget {
  final String userId;
  final VoidCallback? onSosActivated;
  final VoidCallback? onSosDeactivated;

  const PulsingSosButton({
    super.key,
    required this.userId,
    this.onSosActivated,
    this.onSosDeactivated,
  });

  @override
  State<PulsingSosButton> createState() => _PulsingSosButtonState();
}

class _PulsingSosButtonState extends State<PulsingSosButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isActive = false;
  bool _isLoading = false;
  final SosManager _sosManager = SosManager();

  @override
  void initState() {
    super.initState();

    // Initialize pulsing animation
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  /// Show explanation dialog for background location permission
  Future<bool> _showPermissionExplanationDialog() async {
    return await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: const [
                  Icon(Icons.location_on, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Background Location Required'),
                ],
              ),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Why we need this permission:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '• Broadcast your location during emergencies\n'
                    '• Continue tracking even when app is closed\n'
                    '• Ensure help can reach you quickly\n'
                    '• Works 24/7 for your safety',
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Your location is only tracked when SOS is active.',
                    style: TextStyle(
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Grant Permission'),
              ),
            ],
          ),
        ) ??
        false;
  }

  /// Handle SOS button press
  Future<void> _handleSosPress() async {
    // Validate userId
    if (widget.userId.isEmpty) {
      _showErrorDialog('Error', 'User ID is not set. Please log in again.');
      return;
    }

    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      if (!_isActive) {
        // Activating SOS
        // First, show explanation dialog
        final userAccepted = await _showPermissionExplanationDialog();
        if (!userAccepted) {
          setState(() => _isLoading = false);
          return;
        }

        // Check location services
        final locationEnabled = await SosManager.isLocationServiceEnabled();
        if (!locationEnabled) {
          _showErrorDialog(
            'Location Services Disabled',
            'Please enable location services in your device settings.',
          );
          setState(() => _isLoading = false);
          return;
        }

        // Request permissions and start SOS
        final success = await _sosManager.startSOS(widget.userId);

        if (success) {
          setState(() => _isActive = true);
          widget.onSosActivated?.call();
          _showSuccessSnackbar('SOS Activated - Broadcasting your location');
        } else {
          // Check permission status to show appropriate message
          final permissionStatus = await Permission.locationAlways.status;
          if (permissionStatus.isDenied || permissionStatus.isPermanentlyDenied) {
            _showPermissionDeniedDialog();
          } else {
            _showErrorDialog(
              'SOS Activation Failed',
              'Unable to start SOS service. Please try again.',
            );
          }
        }
      } else {
        // Deactivating SOS
        final confirmed = await _showDeactivationConfirmation();
        if (confirmed) {
          await _sosManager.stopSOS(widget.userId);
          setState(() => _isActive = false);
          widget.onSosDeactivated?.call();
          _showSuccessSnackbar('SOS Deactivated');
        }
      }
    } catch (e) {
      _showErrorDialog('Error', 'An unexpected error occurred: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// Show deactivation confirmation dialog
  Future<bool> _showDeactivationConfirmation() async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Deactivate SOS?'),
            content: const Text(
              'Are you sure you want to stop the emergency broadcast?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Deactivate'),
              ),
            ],
          ),
        ) ??
        false;
  }

  /// Show permission denied dialog with settings option
  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Permission Required'),
        content: SingleChildScrollView(
          child: Text(
            'Background location permission is required for SOS functionality. '
            'Please grant "Allow all the time" permission in app settings.',
            maxLines: 5,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              openAppSettings();
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  /// Show error dialog
  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: Text(
            message,
            maxLines: 10,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  /// Show success snackbar
  void _showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _isActive ? _scaleAnimation.value : 1.0,
          child: child,
        );
      },
      child: GestureDetector(
        onTap: _handleSosPress,
        child: Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: _isActive
                  ? [Colors.red.shade700, Colors.red.shade900]
                  : [Colors.red.shade400, Colors.red.shade600],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.red.withOpacity(0.6),
                blurRadius: _isActive ? 30 : 20,
                spreadRadius: _isActive ? 10 : 5,
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Outer ring animation (only when active)
              if (_isActive)
                Container(
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withOpacity(0.5),
                      width: 3,
                    ),
                  ),
                ),
              // Content
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _isActive ? Icons.emergency : Icons.warning_amber_rounded,
                    size: 80,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _isActive ? 'SOS ACTIVE' : 'SOS',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                  if (_isActive)
                    const Padding(
                      padding: EdgeInsets.only(top: 4),
                      child: Text(
                        'TAP TO STOP',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              ),
              // Loading indicator
              if (_isLoading)
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black.withOpacity(0.5),
                  ),
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 3,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
