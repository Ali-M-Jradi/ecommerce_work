import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AuthDebugPage extends StatefulWidget {
  const AuthDebugPage({super.key});

  @override
  State<AuthDebugPage> createState() => _AuthDebugPageState();
}

class _AuthDebugPageState extends State<AuthDebugPage> {
  String _debugInfo = 'Loading...';

  @override
  void initState() {
    super.initState();
    _loadDebugInfo();
  }

  Future<void> _loadDebugInfo() async {
    final prefs = await SharedPreferences.getInstance();
    
    final rememberMe = prefs.getBool('remember_me');
    final token = prefs.getString('auth_token');
    final userData = prefs.getString('user_data');
    
    String info = 'Authentication Debug Info (STANDARD LOGIC):\n\n';
    info += 'Remember Me: $rememberMe\n';
    info += 'Logic: ${rememberMe == true ? "PERMANENT storage (persists on restart)" : "TEMPORARY session (cleared on restart)"}\n';
    info += 'Token: ${token?.substring(0, 20) ?? 'null'}${token != null && token.length > 20 ? '...' : ''}\n';
    info += 'User Data: $userData\n\n';
    
    if (userData != null) {
      try {
        final userMap = json.decode(userData);
        info += 'Parsed User:\n';
        userMap.forEach((key, value) {
          info += '  $key: $value\n';
        });
      } catch (e) {
        info += 'Error parsing user data: $e\n';
      }
    }
    
    setState(() {
      _debugInfo = info;
    });
  }

  Future<void> _clearAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('user_data');
    await prefs.remove('remember_me');
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Authentication data cleared')),
    );
    
    _loadDebugInfo();
  }

  Future<void> _setTestAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', 'test_token_123456789');
    await prefs.setString('user_data', '{"email":"test@example.com","name":"Test User"}');
    await prefs.setBool('remember_me', true); // true = permanent storage
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Test auth data set (permanent storage)')),
    );
    
    _loadDebugInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Auth Debug'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  _debugInfo,
                  style: const TextStyle(fontFamily: 'monospace'),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _loadDebugInfo,
                  child: const Text('Refresh'),
                ),
                ElevatedButton(
                  onPressed: _clearAuthData,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text('Clear Auth'),
                ),
                ElevatedButton(
                  onPressed: _setTestAuthData,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: const Text('Set Test'),
                ),
              ],
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Back'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
