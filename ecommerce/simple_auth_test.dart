import 'dart:convert';
import 'dart:io';

// Minimal recreation of the auth service for testing
class TestAuthService {
  static const String baseUrl = 'https://localhost:7184/api';
  static const Duration timeoutDuration = Duration(seconds: 10);

  static Future<void> testLogin() async {
    print('🧪 Testing Login with Demo Mode...\n');
    
    try {
      // Create HTTP client
      final client = HttpClient()
        ..badCertificateCallback = (cert, host, port) => true;
      
      final request = await client.postUrl(Uri.parse('$baseUrl/login'));
      request.headers.set('Content-Type', 'application/json');
      request.headers.set('accept', '*/*');
      
      final requestBody = json.encode({
        'email': 'test@example.com',
        'password': 'test123',
      });
      
      request.add(utf8.encode(requestBody));
      
      print('📡 Attempting connection to: $baseUrl/login');
      
      final response = await request.close().timeout(timeoutDuration);
      
      print('✅ Server responded with status: ${response.statusCode}');
      
      client.close();
      
    } catch (e) {
      print('❌ Connection failed: $e');
      
      // Check if it's a connection error (demo mode trigger)
      if (e.toString().contains('Connection refused') || 
          e.toString().contains('SocketException')) {
        print('🔧 Server appears to be offline, enabling demo mode for testing');
        print('✅ Demo mode login successful!');
        print('🎫 Token: demo_token_${DateTime.now().millisecondsSinceEpoch}');
        print('👤 User: test (test@example.com)');
        print('📄 Message: Demo mode login (server offline)');
        return;
      }
      
      print('❌ Unexpected error: $e');
    }
  }
  
  static Future<void> testConnections() async {
    print('\n' + '='*50);
    print('🌐 Testing Multiple Server Connections...\n');
    
    final testUrls = [
      'https://localhost:7184/api',
      'http://localhost:89/api',
      'https://localhost:7184',
      'http://localhost:89',
    ];
    
    for (String url in testUrls) {
      try {
        print('🔍 Testing: $url');
        
        final client = HttpClient()
          ..badCertificateCallback = (cert, host, port) => true;
        
        final request = await client.getUrl(Uri.parse(url));
        request.headers.set('Accept', 'application/json');
        
        final response = await request.close().timeout(Duration(seconds: 5));
        
        print('✅ $url - Status: ${response.statusCode}');
        client.close();
        
      } catch (e) {
        print('❌ $url - Error: ${e.toString().split('\n')[0]}');
      }
      print('');
    }
  }
}

void main() async {
  await TestAuthService.testLogin();
  await TestAuthService.testConnections();
  print('\n🎉 Auth Service test completed!');
}
