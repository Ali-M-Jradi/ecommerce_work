import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
    _isLoading = true; // Set loading state initially
    _loadUserFromStorage();
  }

  /// Load user and token from shared preferences on app start
  Future<void> _loadUserFromStorage() async {
    try {
      print('🔧 DEBUG: _loadUserFromStorage starting...');
      final prefs = await SharedPreferences.getInstance();
      final rememberMe = prefs.getBool('remember_me') ?? false;
      final storedToken = prefs.getString('auth_token');
      final storedUserJson = prefs.getString('user_data');
      
      print('🔧 DEBUG: Initial values - rememberMe: $rememberMe, token exists: ${storedToken != null}, user data exists: ${storedUserJson != null}');
      
      // Load stored credentials when remember me IS checked (permanent storage)
      if (rememberMe) {
        print('🔧 DEBUG: Remember me is TRUE, attempting to load stored credentials...');
        
        if (storedToken != null && storedUserJson != null) {
          _token = storedToken;
          final userMap = json.decode(storedUserJson) as Map<String, dynamic>;
          _user = User.fromJson(userMap);
          _isLoggedIn = true;
          
          print('AuthProvider: Loaded remembered user ${_user?.email} from storage');
          
          // Verify token is still valid
          await _verifyToken();
        } else {
          print('AuthProvider: Remember me enabled but no credentials found');
        }
      } else {
        print('🔧 DEBUG: Remember me is FALSE - starting with clean session');
      }
    } catch (e) {
      print('Error loading user from storage: $e');
    } finally {
      _isLoading = false; // Clear loading state
      notifyListeners();
      print('AuthProvider: Loading completed. IsLoggedIn: $_isLoggedIn');
    }
  }

  /// Verify if stored token is still valid
  Future<void> _verifyToken() async {
    if (_token == null) return;
    
    try {
      print('AuthProvider: Verifying token validity...');
      final response = await AuthService.getUserProfile(_token!);
      if (response.success && response.user != null) {
        _user = response.user;
        _isLoggedIn = true;
        print('AuthProvider: Token verification successful');
      } else {
        print('AuthProvider: Token verification failed - ${response.message}');
        print('🔧 DEBUG: Status Code: ${response.statusCode}');
        
        // Only clear stored data if it's a definitive authentication failure (401/403)
        // Don't clear for server errors (404, 500, etc.) as the endpoint might not be implemented
        if (response.statusCode == 401 || response.statusCode == 403) {
          print('🔧 DEBUG: Authentication failed (401/403) - clearing stored data');
          await _clearStoredAuth();
        } else {
          print('🔧 DEBUG: Server error (${response.statusCode}) - keeping stored data');
          // For demo tokens or server endpoint not implemented, keep user logged in
          if (_token!.startsWith('demo_token_') || response.statusCode == 404) {
            print('🔧 DEBUG: Demo token or endpoint not found - staying logged in');
            _isLoggedIn = true;
            // Create a basic user profile if we don't have one but we have a user already loaded
            if (_user == null) {
              print('🔧 DEBUG: Creating fallback user profile for demo token');
              _user = User(
                id: 1,
                name: 'Demo User',
                email: 'demo@example.com',
                role: 'user',
              );
            }
          } else {
            // Other server errors - log out for this session but keep stored data
            _isLoggedIn = false;
          }
        }
      }
    } catch (e) {
      print('AuthProvider: Token verification failed with exception: $e');
      // On network error or other issues, keep the user logged in
      // Don't clear auth data for network connectivity issues
      if (e.toString().contains('connection') || 
          e.toString().contains('network') ||
          e.toString().contains('timeout')) {
        print('AuthProvider: Keeping user logged in despite network error');
        _isLoggedIn = true;
        // If we have a demo token, ensure we stay logged in
        if (_token!.startsWith('demo_token_') && _user == null) {
          _user = User(
            id: 1,
            name: 'Demo User',
            email: 'demo@example.com',
            role: 'demo_user',
          );
        }
      } else {
        await _clearStoredAuth();
      }
    }
  }

  /// Store authentication data with remember me preference
  Future<void> _storeAuthData(String token, User user, {bool rememberMe = false}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      print('🔧 DEBUG: _storeAuthData called with rememberMe: $rememberMe for user: ${user.email}');
      
      if (rememberMe) {
        // Store permanently when remember me IS checked
        await prefs.setString('auth_token', token);
        await prefs.setString('user_data', json.encode(user.toJson()));
        await prefs.setBool('remember_me', true);
        print('AuthProvider: Stored auth data permanently for ${user.email} (Remember Me: ON)');
        
        // Verify storage
        final storedToken = prefs.getString('auth_token');
        final storedRememberMe = prefs.getBool('remember_me');
        print('🔧 DEBUG: Verification - stored token exists: ${storedToken != null}, remember_me: $storedRememberMe');
      } else {
        // Store temporarily in memory only when remember me is NOT checked
        await prefs.remove('auth_token');
        await prefs.remove('user_data');
        await prefs.setBool('remember_me', false);
        print('AuthProvider: Auth data stored temporarily for ${user.email} (Remember Me: OFF)');
        
        // Verify removal
        final storedToken = prefs.getString('auth_token');
        final storedRememberMe = prefs.getBool('remember_me');
        print('🔧 DEBUG: Verification - token removed: ${storedToken == null}, remember_me: $storedRememberMe');
      }
    } catch (e) {
      print('Error storing auth data: $e');
    }
  }

  /// Clear stored authentication data
  Future<void> _clearStoredAuth() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');
      await prefs.remove('user_data');
      await prefs.remove('remember_me');
      _token = null;
      _user = null;
      _isLoggedIn = false;
    } catch (e) {
      print('Error clearing auth data: $e');
    }
  }

  /// Login with email and password
  Future<bool> login(String email, String password, {bool rememberMe = false}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      print('AuthProvider: Attempting login for $email (Remember Me: $rememberMe - ${rememberMe ? "Permanent storage" : "Temporary session"})');
      
      // Use the smart login method with automatic URL fallback
      // No need for separate connection testing - login method handles it
      final response = await AuthService.login(email, password);
      
      if (response.success) {
        _token = response.token;
        _user = response.user;
        _isLoggedIn = true;
        _error = null;
        
        // Store authentication data based on remember me preference (STANDARD LOGIC)
        if (_token != null && _user != null) {
          await _storeAuthData(_token!, _user!, rememberMe: rememberMe);
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
        
        // Store authentication data (always remember for new registrations)
        if (_token != null && _user != null) {
          await _storeAuthData(_token!, _user!, rememberMe: true);
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
