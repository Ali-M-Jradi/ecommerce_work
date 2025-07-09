import 'package:flutter/foundation.dart';

class User {
  final String email;
  final String? firstName;
  final String? lastName;

  User({
    required this.email,
    this.firstName,
    this.lastName,
  });

  String get displayName {
    if (firstName != null && firstName!.isNotEmpty) {
      return firstName!;
    }
    return email.split('@').first;
  }
}

class UserProvider with ChangeNotifier {
  User? _currentUser;
  
  User? get currentUser => _currentUser;
  
  bool get isLoggedIn => _currentUser != null;
  
  void login(String email, {String? firstName, String? lastName}) {
    _currentUser = User(
      email: email,
      firstName: firstName,
      lastName: lastName,
    );
    notifyListeners();
  }
  
  void logout() {
    _currentUser = null;
    notifyListeners();
  }
}
