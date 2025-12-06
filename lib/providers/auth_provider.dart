import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

/// Auth Provider for authentication state management
/// 
/// Students will learn:
/// - Authentication state management
/// - User session handling
/// - Auth state streams
class AuthProvider with ChangeNotifier {
  // ignore: unused_field
  final AuthService _authService = AuthService(); // Students will use this when implementing Firebase

  UserModel? _currentUser;
  bool _isLoading = false;
  String? _error;

  // Getters
  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _currentUser != null;

  AuthProvider() {
    // Listen to auth state changes
    _initAuthListener();
  }

  /// Initialize auth state listener
  /// 
  /// TODO: Students will implement this
  /// - Listen to AuthService.authStateChanges stream
  /// - Update _currentUser when auth state changes
  void _initAuthListener() {
    // TODO: Listen to _authService.authStateChanges
    // _authService.authStateChanges.listen((user) {
    //   _currentUser = user;
    //   notifyListeners();
    // });
  }

  /// Sign up a new user
  Future<bool> signUp({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String phoneNumber,
    String? bio,
    String? address,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // TODO: Call _authService.signUp() with all parameters
      // _currentUser = await _authService.signUp(...);
      // return true;
      
      // TEMPORARY: Mock authentication for development
      // This allows students to test the UI before implementing Firebase
      // Validate email format
      if (!email.contains('@') || !email.contains('.')) {
        _error = 'Please enter a valid email address';
        _isLoading = false;
        notifyListeners();
        return false;
      }
      
      // Validate password length
      if (password.length < 6) {
        _error = 'Password must be at least 6 characters';
        _isLoading = false;
        notifyListeners();
        return false;
      }
      
      // Create mock user (students will replace this with Firebase implementation)
      _currentUser = UserModel(
        uid: 'mock_user_${DateTime.now().millisecondsSinceEpoch}',
        email: email,
        displayName: '$firstName $lastName',
        firstName: firstName,
        lastName: lastName,
        phoneNumber: phoneNumber,
        bio: bio,
        address: address,
        createdAt: DateTime.now(),
      );
      
      return true;
    } catch (e) {
      _error = 'Sign up failed: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Sign in existing user
  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // TODO: Call _authService.signIn()
      // _currentUser = await _authService.signIn(email: email, password: password);
      // return true;
      
      // TEMPORARY: Mock authentication for development
      // This allows students to test the UI before implementing Firebase
      // Validate email format
      if (!email.contains('@') || !email.contains('.')) {
        _error = 'Please enter a valid email address';
        _isLoading = false;
        notifyListeners();
        return false;
      }
      
      // Validate password length
      if (password.length < 6) {
        _error = 'Password must be at least 6 characters';
        _isLoading = false;
        notifyListeners();
        return false;
      }
      
      // Create mock user (students will replace this with Firebase implementation)
      // Extract name from email for display
      final emailParts = email.split('@');
      final name = emailParts[0];
      _currentUser = UserModel(
        uid: 'mock_user_${email.hashCode}',
        email: email,
        displayName: name,
        firstName: name.split('.').first.isEmpty ? name : name.split('.').first,
        lastName: name.contains('.') ? name.split('.').last : name,
        phoneNumber: '123-456-7890', // Mock phone number
        createdAt: DateTime.now(),
        lastLoginAt: DateTime.now(),
      );
      
      return true;
    } catch (e) {
      _error = 'Sign in failed: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Sign out current user
  Future<void> signOut() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // TODO: Call _authService.signOut()
      // await _authService.signOut();
      _currentUser = null;
    } catch (e) {
      _error = 'Sign out failed: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Update user profile
  Future<bool> updateProfile(UserModel user) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // TODO: Call _authService.updateProfile()
      // await _authService.updateProfile(user);
      // _currentUser = user;
      return true;
    } catch (e) {
      _error = 'Update profile failed: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Send password reset email
  Future<bool> sendPasswordResetEmail(String email) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // TODO: Call _authService.sendPasswordResetEmail()
      // await _authService.sendPasswordResetEmail(email);
      return true;
    } catch (e) {
      _error = 'Failed to send password reset email: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}

