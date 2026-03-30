import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../services/firebase_auth_service.dart';

/// Provider for managing authentication state
class AuthProvider with ChangeNotifier {
  final FirebaseAuthService _authService = FirebaseAuthService();
  firebase_auth.User? _user;
  
  AuthProvider() {
    // Listen to auth state changes
    _authService.authStateChanges().listen((user) {
      _user = user;
      notifyListeners();
    });
  }
  
  /// Get current user
  firebase_auth.User? get user => _user;
  
  /// Get user name
  String get userName => _user?.displayName ?? 'User';
  
  /// Get user email
  String get userEmail => _user?.email ?? '';
  
  /// Check if user is logged in
  bool get isLoggedIn => _user != null;
}
