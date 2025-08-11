import 'lib/services/auth_service.dart';

void main() async {
  print('🧪 Testing Auth Service Demo Mode...\n');
  
  // Test 1: Login with demo mode (server down)
  print('Test 1: Login with server offline (demo mode)');
  final loginResult = await AuthService.login('test@example.com', 'password123');
  
  if (loginResult.success) {
    print('✅ Login successful in demo mode!');
    print('📄 Message: ${loginResult.message}');
    print('🎫 Token: ${loginResult.token}');
    print('👤 User: ${loginResult.user?.name} (${loginResult.user?.email})');
  } else {
    print('❌ Login failed: ${loginResult.message}');
  }
  
  print('\n' + '='*50 + '\n');
  
  // Test 2: Connection test
  print('Test 2: Connection test to multiple servers');
  final connectionResult = await AuthService.debugConnection();
  print(connectionResult);
  
  print('\n🎉 Auth Service test completed!');
}
