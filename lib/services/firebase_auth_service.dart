import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

/// Firebase Authentication service for managing user sessions (Auth only, no Firestore)
class FirebaseAuthService {
  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;

  /// Check if user is logged in
  Future<bool> isLoggedIn() async {
    return _auth.currentUser != null;
  }

  /// Get current Firebase user
  firebase_auth.User? getCurrentFirebaseUser() {
    return _auth.currentUser;
  }

  /// Get current user email
  String? getCurrentUserEmail() {
    return _auth.currentUser?.email;
  }

  /// Get current user name
  String? getCurrentUserName() {
    return _auth.currentUser?.displayName;
  }

  /// Register new user
  Future<Map<String, dynamic>> register(String name, String email, String password) async {
    try {
      // Create user in Firebase Auth
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Update display name
      await credential.user!.updateDisplayName(name);
      
      // Reload user to get updated info
      await credential.user!.reload();

      return {'success': true};
    } on firebase_auth.FirebaseAuthException catch (e) {
      String message = 'Registration failed';
      
      if (e.code == 'weak-password') {
        message = 'The password provided is too weak';
      } else if (e.code == 'email-already-in-use') {
        message = 'An account already exists for that email';
      } else if (e.code == 'invalid-email') {
        message = 'The email address is invalid';
      } else if (e.message != null) {
        message = e.message!;
      }
      
      return {'success': false, 'message': message};
    } catch (e) {
      return {'success': false, 'message': 'An error occurred: $e'};
    }
  }

  /// Login user
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      return {'success': true};
    } on firebase_auth.FirebaseAuthException catch (e) {
      String message = 'Login failed';
      
      if (e.code == 'user-not-found') {
        message = 'No user found for that email';
      } else if (e.code == 'wrong-password') {
        message = 'Wrong password provided';
      } else if (e.code == 'invalid-email') {
        message = 'The email address is invalid';
      } else if (e.code == 'user-disabled') {
        message = 'This user account has been disabled';
      } else if (e.code == 'invalid-credential') {
        message = 'Invalid email or password';
      } else if (e.message != null) {
        message = e.message!;
      }
      
      return {'success': false, 'message': message};
    } catch (e) {
      return {'success': false, 'message': 'An error occurred: $e'};
    }
  }

  /// Logout user
  Future<void> logout() async {
    await _auth.signOut();
  }

  /// Send password reset email
  Future<Map<String, dynamic>> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return {'success': true, 'message': 'Password reset email sent'};
    } on firebase_auth.FirebaseAuthException catch (e) {
      String message = 'Password reset failed';
      
      if (e.code == 'user-not-found') {
        message = 'No user found for that email';
      } else if (e.code == 'invalid-email') {
        message = 'The email address is invalid';
      } else if (e.message != null) {
        message = e.message!;
      }
      
      return {'success': false, 'message': message};
    } catch (e) {
      return {'success': false, 'message': 'An error occurred: $e'};
    }
  }

  /// Listen to auth state changes
  Stream<firebase_auth.User?> authStateChanges() {
    return _auth.authStateChanges();
  }

  /// Delete user account
  Future<Map<String, dynamic>> deleteAccount() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        return {'success': false, 'message': 'No user logged in'};
      }

      // Delete user from Firebase Auth
      await user.delete();
      
      return {'success': true};
    } catch (e) {
      return {'success': false, 'message': 'Failed to delete account: $e'};
    }
  }
}
