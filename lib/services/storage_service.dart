import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/user.dart';

class StorageService {
  static const String _keyUser = 'diprep_user';

  /// Save user to local storage
  Future<void> saveUser(User user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = jsonEncode(user.toJson());
      await prefs.setString(_keyUser, userJson);
    } catch (e) {
      print('Error saving user: $e');
    }
  }

  /// Get user from local storage
  Future<User?> getUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString(_keyUser);
      if (userJson == null) return null;

      final userMap = jsonDecode(userJson) as Map<String, dynamic>;
      return User.fromJson(userMap);
    } catch (e) {
      print('Error retrieving user: $e');
      return null;
    }
  }

  /// Clear user from storage (logout)
  Future<void> clearUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_keyUser);
    } catch (e) {
      print('Error clearing user: $e');
    }
  }

  /// Check if first launch
  Future<bool> isFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('first_launch') ?? true;
  }

  /// Mark first launch as complete
  Future<void> setFirstLaunchCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('first_launch', false);
  }
}
