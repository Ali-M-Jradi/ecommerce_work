import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  print('Testing Remember Me functionality...');
  
  // Simulate what happens during login
  final prefs = await SharedPreferences.getInstance();
  
  // Test case 1: Remember Me = true
  print('\n=== Test Case 1: Remember Me = true ===');
  await prefs.setString('auth_token', 'test_token_123');
  await prefs.setString('user_data', '{"email":"test@example.com","name":"Test User"}');
  await prefs.setBool('remember_me', true);
  
  // Check if data is stored
  print('Stored token: ${prefs.getString('auth_token')}');
  print('Stored user: ${prefs.getString('user_data')}');
  print('Remember me: ${prefs.getBool('remember_me')}');
  
  // Test case 2: Remember Me = false  
  print('\n=== Test Case 2: Remember Me = false ===');
  await prefs.remove('auth_token');
  await prefs.remove('user_data');
  await prefs.setBool('remember_me', false);
  
  // Check if data is cleared
  print('Stored token: ${prefs.getString('auth_token')}');
  print('Stored user: ${prefs.getString('user_data')}');
  print('Remember me: ${prefs.getBool('remember_me')}');
  
  // Test case 3: Loading on app start
  print('\n=== Test Case 3: App Start Simulation ===');
  
  // Restore remember me = true case
  await prefs.setString('auth_token', 'test_token_456');
  await prefs.setString('user_data', '{"email":"user@test.com","name":"Another User"}');
  await prefs.setBool('remember_me', true);
  
  final rememberMe = prefs.getBool('remember_me') ?? false;
  print('Remember me setting: $rememberMe');
  
  if (rememberMe) {
    final token = prefs.getString('auth_token');
    final userData = prefs.getString('user_data');
    print('Should restore session - Token: $token, User: $userData');
  } else {
    print('Should NOT restore session');
  }
  
  print('\nTest completed!');
}
