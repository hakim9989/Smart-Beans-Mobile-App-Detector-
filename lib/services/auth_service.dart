import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

/// Authentication service for managing user sessions
class AuthService {
  static const String _userKey = 'current_user';
  static const String _isLoggedInKey = 'is_logged_in';
  static const String _usersKey = 'registered_users';

  /// Check if user is logged in
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  /// Get current user
  Future<User?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_userKey);
    
    if (userJson == null) return null;
    
    return User.fromJson(jsonDecode(userJson));
  }

  /// Register new user
  Future<bool> register(String name, String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    
    // Get existing users
    final usersJson = prefs.getString(_usersKey);
    Map<String, dynamic> users = {};
    
    if (usersJson != null) {
      users = Map<String, dynamic>.from(jsonDecode(usersJson));
    }
    
    // Check if email already exists
    if (users.containsKey(email)) {
      return false;
    }
    
    // Create new user
    final user = User(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      email: email,
      name: name,
      createdAt: DateTime.now(),
    );
    
    // Store user credentials
    users[email] = {
      'user': user.toJson(),
      'password': password, // In production, hash this!
    };
    
    await prefs.setString(_usersKey, jsonEncode(users));
    
    // Auto login after registration
    await _setCurrentUser(user);
    
    return true;
  }

  /// Login user
  Future<bool> login(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getString(_usersKey);
    
    if (usersJson == null) return false;
    
    final users = Map<String, dynamic>.from(jsonDecode(usersJson));
    
    if (!users.containsKey(email)) return false;
    
    final userData = users[email];
    
    if (userData['password'] != password) return false;
    
    // Login successful
    final user = User.fromJson(userData['user']);
    await _setCurrentUser(user);
    
    return true;
  }

  /// Logout user
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
    await prefs.setBool(_isLoggedInKey, false);
  }

  /// Set current user
  Future<void> _setCurrentUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(user.toJson()));
    await prefs.setBool(_isLoggedInKey, true);
  }
}
