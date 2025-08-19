import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import '../../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoading = false;
  String? _error;
  User? _user;
  String? _token;
  bool _isLoggedIn = false;

  // Getters
  bool get isLoading => _isLoading;
  String? get error => _error;
  User? get user => _user;
  String? get token => _token;
  bool get isLoggedIn => _isLoggedIn;

  AuthProvider() {
    _loadUserFromStorage();
  }

  /// Load user and token from shared preferences on app start
  Future<void> _loadUserFromStorage() async {
    try {
      const secure = FlutterSecureStorage();
      String? storedToken = await secure.read(key: 'auth_token');
      String? storedUserJson = await secure.read(key: 'user_data');
      // Fallback to SharedPreferences for older installs
      if (storedToken == null || storedUserJson == null) {
        final prefs = await SharedPreferences.getInstance();
        storedToken = storedToken ?? prefs.getString('auth_token');
        storedUserJson = storedUserJson ?? prefs.getString('user_data');
      }

  if (storedToken != null && storedUserJson != null) {
        _token = storedToken;
        final userMap = json.decode(storedUserJson) as Map<String, dynamic>;
        _user = User.fromJson(userMap);
        _isLoggedIn = true;
        
        print('AuthProvider: Loaded user ${_user?.email} from storage');
        
        // Optionally verify token is still valid
        await _verifyToken();
      }
    } catch (e) {
      print('Error loading user from storage: $e');
    }
    notifyListeners();
  }

  /// Verify if stored token is still valid
  Future<void> _verifyToken() async {
    if (_token == null) return;
    // Skip verification for demo tokens used when server is offline
    if (_token!.startsWith('demo_token_')) {
      print('AuthProvider: Skipping verification for demo token');
      _isLoggedIn = true;
      return;
    }
    
    try {
      final response = await AuthService.getUserProfile(_token!);
      if (response.success && response.user != null) {
        _user = response.user;
        _isLoggedIn = true;
      } else {
        // Clear only on explicit unauthorized/forbidden
        if (response.statusCode == 401 || response.statusCode == 403) {
          print('AuthProvider: Token invalid (status ${response.statusCode}), clearing stored auth');
          await _clearStoredAuth();
        } else {
          // Keep session if server error or unexpected shape
          print('AuthProvider: Profile check failed with status ${response.statusCode}, preserving session');
          _isLoggedIn = _user != null && _token != null;
        }
      }
    } catch (e) {
      // Do not clear on network errors; preserve login for offline usage
      print('AuthProvider: Token verification error, preserving session: $e');
      _isLoggedIn = _user != null && _token != null;
    }
  }

  /// Store authentication data
  Future<void> _storeAuthData(String token, User user) async {
    try {
      const secure = FlutterSecureStorage();
      await secure.write(key: 'auth_token', value: token);
      await secure.write(key: 'user_data', value: json.encode(user.toJson()));
      // Also mirror minimal info to SharedPreferences for non-sensitive UI reads (optional)
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', token);
        await prefs.setString('user_data', json.encode(user.toJson()));
      } catch (_) {}
      print('AuthProvider: Stored auth data for ${user.email}');
    } catch (e) {
      print('Error storing auth data: $e');
    }
  }

  /// Clear stored authentication data
  Future<void> _clearStoredAuth() async {
    try {
      const secure = FlutterSecureStorage();
      await secure.delete(key: 'auth_token');
      await secure.delete(key: 'user_data');
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('auth_token');
        await prefs.remove('user_data');
      } catch (_) {}
      _token = null;
      _user = null;
      _isLoggedIn = false;
    } catch (e) {
      print('Error clearing auth data: $e');
    }
  }

  /// Login with email and password
  /// rememberMe: when true, persist token/user across app restarts; when false, keep in-memory only
  Future<bool> login(String email, String password, {bool rememberMe = false}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      print('AuthProvider: Attempting login for $email');
      
      // Use the smart login method with automatic URL fallback
      // No need for separate connection testing - login method handles it
      final response = await AuthService.login(email, password);
      
      if (response.success) {
        _token = response.token;
        _user = response.user;
        _isLoggedIn = true;
        _error = null;
        
        // Persist only if rememberMe is true; otherwise clear any previously stored auth
        if (_token != null && _user != null) {
          if (rememberMe) {
            await _storeAuthData(_token!, _user!);
          } else {
            await _clearStoredAuth();
          }
        }
        
        print('AuthProvider: Login successful for ${_user?.email}');
        return true;
      } else {
        _error = response.message;
        print('AuthProvider: Login failed - ${response.message}');
        return false;
      }
    } catch (e) {
      _error = 'Login failed: ${e.toString()}';
      print('AuthProvider: Login exception - $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Register new user
  Future<bool> register(String name, String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      print('AuthProvider: Attempting registration for $email');
      final response = await AuthService.register(name, email, password);
      
      if (response.success) {
        _token = response.token;
        _user = response.user;
        _isLoggedIn = true;
        _error = null;
        
        // Store authentication data
        if (_token != null && _user != null) {
          await _storeAuthData(_token!, _user!);
        }
        
        print('AuthProvider: Registration successful for ${_user?.email}');
        return true;
      } else {
        _error = response.message;
        print('AuthProvider: Registration failed - ${response.message}');
        return false;
      }
    } catch (e) {
      _error = 'Registration failed: ${e.toString()}';
      print('AuthProvider: Registration exception - $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Reset password
  Future<bool> resetPassword(String email) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      print('AuthProvider: Attempting password reset for $email');
      final response = await AuthService.forgotPassword(email);
      
      if (response.success) {
        _error = null;
        print('AuthProvider: Password reset email sent to $email');
        return true;
      } else {
        _error = response.message;
        print('AuthProvider: Password reset failed - ${response.message}');
        return false;
      }
    } catch (e) {
      _error = 'Password reset failed: ${e.toString()}';
      print('AuthProvider: Password reset exception - $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Logout current user
  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      if (_token != null) {
        print('AuthProvider: Attempting logout');
        final response = await AuthService.logout(_token!);
        print('AuthProvider: Logout response - ${response.message}');
      }
    } catch (e) {
      print('AuthProvider: Logout exception - $e');
    } finally {
      // Clear local data regardless of API response
      await _clearStoredAuth();
      _isLoading = false;
      notifyListeners();
      print('AuthProvider: Logout completed');
    }
  }

  /// Refresh user profile
  Future<void> refreshUserProfile() async {
    if (_token == null) return;

    try {
      final response = await AuthService.getUserProfile(_token!);
      if (response.success && response.user != null) {
        _user = response.user;
        notifyListeners();
      }
    } catch (e) {
      print('Error refreshing user profile: $e');
    }
  }

  /// Clear any error messages
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
