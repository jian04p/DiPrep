import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart';
import '../services/storage_service.dart';

class AuthProvider with ChangeNotifier {
  User? _user;
  bool _isAuthenticated = false;
  bool _isLoading = false;
  String? _authError;
  final StorageService _storage = StorageService();
  final fb_auth.FirebaseAuth _firebaseAuth = fb_auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get user => _user;
  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  String? get authError => _authError;

  /// Load saved user from storage on app startup
  Future<void> loadUser() async {
    try {
      if (_firebaseAuth.currentUser != null) {
        // Get user data from Firestore
        final doc = await _firestore
            .collection('users')
            .doc(_firebaseAuth.currentUser!.uid)
            .get();

        if (doc.exists) {
          _user = User(
            id: _firebaseAuth.currentUser!.uid,
            name: doc['name'] ?? _firebaseAuth.currentUser!.displayName ?? 'User',
            email: _firebaseAuth.currentUser!.email ?? '',
            phone: doc['phone'] ?? '',
            location: doc['location'] ?? '',
          );
          _isAuthenticated = true;
        }
      } else {
        _user = await _storage.getUser();
        _isAuthenticated = _user != null;
      }
      notifyListeners();
    } catch (e) {
      _isAuthenticated = false;
      notifyListeners();
    }
  }

  /// Login as a demo/guest user without Firebase auth
  void loginAsDemo() {
    _user = User(
      id: 'demo',
      name: 'Demo User',
      email: 'demo@diprep.app',
      phone: '',
      location: '',
    );
    _isAuthenticated = true;
    notifyListeners();
  }

  /// Login user with email and password
  Future<bool> login(String email, String password) async {
    try {
      _isLoading = true;
      _authError = null;
      notifyListeners();

      // Firebase authentication
      final fb_auth.UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      if (userCredential.user != null) {
        // Get user data from Firestore
        final doc = await _firestore
            .collection('users')
            .doc(userCredential.user!.uid)
            .get();

        if (doc.exists) {
          _user = User(
            id: userCredential.user!.uid,
            name: doc['name'] ?? 'User',
            email: email,
            phone: doc['phone'] ?? '',
            location: doc['location'] ?? '',
          );
        }
        _isAuthenticated = true;
        await _storage.saveUser(_user!);

        _isLoading = false;
        notifyListeners();
        return true;
      }
      return false;
    } on fb_auth.FirebaseAuthException catch (e) {
      _isLoading = false;
      _authError = e.message ?? 'Login failed';
      notifyListeners();
      return false;
    } catch (e) {
      _isLoading = false;
      _authError = 'An error occurred: $e';
      notifyListeners();
      return false;
    }
  }

  /// Register user with email and password
  Future<bool> register(
    String name,
    String email,
    String password, {
    String phone = '',
    String location = '',
  }) async {
    try {
      _isLoading = true;
      _authError = null;
      notifyListeners();

      // Create Firebase auth account
      final fb_auth.UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      if (userCredential.user != null) {
        // Update display name
        await userCredential.user!.updateDisplayName(name);

        // Save user data to Firestore
        await _firestore.collection('users').doc(userCredential.user!.uid).set(
          {
            'name': name,
            'email': email,
            'phone': phone,
            'location': location,
            'createdAt': FieldValue.serverTimestamp(),
            'updatedAt': FieldValue.serverTimestamp(),
          },
        );

        _user = User(
          id: userCredential.user!.uid,
          name: name,
          email: email,
          phone: phone,
          location: location,
        );
        _isAuthenticated = true;
        await _storage.saveUser(_user!);

        _isLoading = false;
        notifyListeners();
        return true;
      }
      return false;
    } on fb_auth.FirebaseAuthException catch (e) {
      _isLoading = false;
      if (e.code == 'weak-password') {
        _authError = 'Password is too weak';
      } else if (e.code == 'email-already-in-use') {
        _authError = 'Email already registered';
      } else {
        _authError = e.message ?? 'Registration failed';
      }
      notifyListeners();
      return false;
    } catch (e) {
      _isLoading = false;
      _authError = 'An error occurred: $e';
      notifyListeners();
      return false;
    }
  }

  /// Logout user
  Future<void> logout() async {
    _user = null;
    _isAuthenticated = false;
    await _storage.clearUser();
    notifyListeners();
  }
}
