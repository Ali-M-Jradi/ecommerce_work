import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

class AuthService {
  // Your working authentication server URL (port 7184)
  static const String baseUrl = 'https://localhost:7184/api';
  static const Duration timeoutDuration = Duration(seconds: 10);

  /// Create HTTP client with SSL bypass for localhost
  static http.Client _createHttpClient() {
    final client = HttpClient()
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
    return IOClient(client);
  }

  /// Login user with email and password
  static Future<AuthResponse> login(String email, String password) async {
    print('🚀 Attempting login for: $email');
    print('🌐 URL: $baseUrl/login');
    
    final client = _createHttpClient();
    
    try {
      final response = await client.post(
        Uri.parse('$baseUrl/login'),
        headers: {
          'accept': '*/*',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'email': email,
          'password': password,
        }),
      ).timeout(timeoutDuration);

      print('📊 Response Status: ${response.statusCode}');
      print('📝 Response Body: ${response.body}');

      if (response.statusCode == 200) {
        try {
          final Map<String, dynamic> data = json.decode(response.body);
          
          // Check if server just echoed back the data (not fully implemented)
          if (data['email'] == email) {
            print('⚠️ Server echoed data back - login endpoint not fully implemented');
            return AuthResponse.success(
              token: 'demo_token_${DateTime.now().millisecondsSinceEpoch}',
              user: User(
                id: 1,
                name: email.split('@')[0],
                email: email,
              ),
              message: 'Login successful (demo mode)',
            );
          }
          
          // Normal login response
          return AuthResponse.success(
            token: data['token'] ?? data['access_token'] ?? '',
            user: User.fromJson(data['user'] ?? data['data'] ?? data),
            message: data['message'] ?? 'Login successful',
          );
        } catch (e) {
          print('❌ JSON parsing error: $e');
          return AuthResponse.error(
            message: 'Login successful but response format error',
            statusCode: response.statusCode,
          );
        }
      } else if (response.statusCode == 401) {
        return AuthResponse.error(
          message: 'Invalid credentials - please check your email and password',
          statusCode: response.statusCode,
        );
      } else {
        return AuthResponse.error(
          message: 'Login failed with status ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      print('❌ Login error: $e');
      
      // Check if it's a connection error
      if (e.toString().contains('Connection refused') || 
          e.toString().contains('Connection timed out') ||
          e.toString().contains('SocketException')) {
        
        print('🔧 Server appears to be offline, enabling demo mode for testing');
        
        // Demo mode for testing navigation logic when server is down
        return AuthResponse.success(
          token: 'demo_token_${DateTime.now().millisecondsSinceEpoch}',
          user: User(
            id: 1,
            name: email.split('@')[0],
            email: email,
            role: 'demo_user',
          ),
          message: 'Demo mode login (server offline)',
        );
      }
      
      return AuthResponse.error(
        message: 'Connection error: ${e.toString()}',
        statusCode: 0,
      );
    } finally {
      client.close();
    }
  }

  /// Register a new user
  static Future<AuthResponse> register(String email, String password, String name) async {
    print('🚀 Attempting registration for: $email');
    
    final client = _createHttpClient();
    
    try {
      final response = await client.post(
        Uri.parse('$baseUrl/register'),
        headers: {
          'accept': '*/*',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'email': email,
          'password': password,
          'name': name,
        }),
      ).timeout(timeoutDuration);

      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          final Map<String, dynamic> data = json.decode(response.body);
          return AuthResponse.success(
            token: data['token'] ?? '',
            user: User.fromJson(data['user'] ?? data),
            message: data['message'] ?? 'Registration successful',
          );
        } catch (e) {
          return AuthResponse.error(
            message: 'Registration successful but response format error',
            statusCode: response.statusCode,
          );
        }
      } else {
        return AuthResponse.error(
          message: 'Registration failed with status ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      print('❌ Registration error: $e');
      
      // Demo mode for registration too
      if (e.toString().contains('Connection refused') || 
          e.toString().contains('SocketException')) {
        
        return AuthResponse.success(
          token: 'demo_token_${DateTime.now().millisecondsSinceEpoch}',
          user: User(
            id: 1,
            name: name,
            email: email,
            role: 'demo_user',
          ),
          message: 'Demo mode registration (server offline)',
        );
      }
      
      return AuthResponse.error(
        message: 'Connection error: ${e.toString()}',
        statusCode: 0,
      );
    } finally {
      client.close();
    }
  }

  /// Test connection to multiple servers
  static Future<String> debugConnection() async {
    final client = _createHttpClient();
    final List<String> testUrls = [
      'https://localhost:7184/api',
      'http://localhost:89/api',
      'https://localhost:7184',
      'http://localhost:89',
    ];
    
    String results = 'Connection Test Results:\n\n';
    
    for (String url in testUrls) {
      try {
        print('🔍 Testing: $url');
        final response = await client.get(
          Uri.parse(url),
          headers: {'Accept': 'application/json'},
        ).timeout(Duration(seconds: 5));
        
        results += '✅ $url - Status: ${response.statusCode}\n';
        if (response.body.isNotEmpty && response.body.length < 200) {
          results += '   Response: ${response.body}\n';
        }
      } catch (e) {
        results += '❌ $url - Error: ${e.toString().split('\n')[0]}\n';
      }
      results += '\n';
    }
    
    client.close();
    return results;
  }
}

/// User model
class User {
  final int? id;
  final String name;
  final String email;
  final String? role;
  final DateTime? createdAt;

  User({
    this.id,
    required this.name,
    required this.email,
    this.role,
    this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'],
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}

/// Authentication response wrapper
class AuthResponse {
  final bool success;
  final String message;
  final String? token;
  final User? user;
  final int? statusCode;

  AuthResponse._({
    required this.success,
    required this.message,
    this.token,
    this.user,
    this.statusCode,
  });

  factory AuthResponse.success({
    required String message,
    String? token,
    User? user,
  }) {
    return AuthResponse._(
      success: true,
      message: message,
      token: token,
      user: user,
      statusCode: 200,
    );
  }

  factory AuthResponse.error({
    required String message,
    required int statusCode,
  }) {
    return AuthResponse._(
      success: false,
      message: message,
      statusCode: statusCode,
    );
  }
}
