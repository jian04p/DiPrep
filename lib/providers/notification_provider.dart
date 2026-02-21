import 'package:flutter/foundation.dart';

class NotificationProvider with ChangeNotifier {
  final List<Map<String, dynamic>> _notifications = [
    {
      'id': 1,
      'type': 'critical',
      'title': 'Severe Weather Alert',
      'message': 'Hurricane Warning in effect',
      'fullMessage': 'A Category 4 hurricane is approaching your area. Evacuation orders are in effect for Zone A. Please relocate to a safe zone immediately.',
      'time': '2 minutes ago',
      'location': 'San Francisco, CA',
      'read': false,
      'instructions': [
        'Evacuate to higher ground',
        'Take essential items',
        'Call emergency services if needed',
      ],
    },
  ];

  List<Map<String, dynamic>> get notifications => _notifications;

  int get unreadCount => _notifications.where((n) => !n['read']).length;

  void markAsRead(int id) {
    final index = _notifications.indexWhere((n) => n['id'] == id);
    if (index != -1) {
      _notifications[index]['read'] = true;
      notifyListeners();
    }
  }

  void deleteNotification(int id) {
    _notifications.removeWhere((n) => n['id'] == id);
    notifyListeners();
  }

  void addNotification(Map<String, dynamic> notification) {
    _notifications.insert(0, notification);
    notifyListeners();
  }
}
