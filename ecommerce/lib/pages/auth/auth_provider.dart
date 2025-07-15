import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  bool isLoading = false;
  String? error;
  // User? user; // Uncomment and implement your User model

  Future<void> login(String email, String password) async {
    // TODO: Implement login logic
  }

  Future<void> register(String name, String email, String password) async {
    // TODO: Implement registration logic
  }

  Future<void> resetPassword(String email) async {
    // TODO: Implement password reset logic
  }

  void logout() {
    // TODO: Implement logout logic
  }
}
