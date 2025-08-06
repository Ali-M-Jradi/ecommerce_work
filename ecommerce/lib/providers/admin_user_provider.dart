import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class AdminUserProvider with ChangeNotifier {
  List<User> _users = [];
  bool _isLoading = false;

  List<User> get users => List.unmodifiable(_users);
  List<User> get activeUsers => _users.where((user) => user.isActive).toList();
  bool get isLoading => _isLoading;

  AdminUserProvider() {
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    _setLoading(true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final usersJson = prefs.getString('admin_users');
      if (usersJson != null) {
        final List<dynamic> usersList = json.decode(usersJson);
        _users = usersList.map((json) => User.fromJson(json)).toList();
      } else {
        _users = _getDefaultUsers();
        await _saveUsers();
      }
    } catch (e) {
      debugPrint('Error loading users: $e');
      _users = _getDefaultUsers();
    }
    _setLoading(false);
  }

  List<User> _getDefaultUsers() {
    return [
      User(
        id: '1',
        email: 'admin@ecommerce.com',
        firstName: 'Admin',
        lastName: 'User',
        role: UserRole.admin,
        status: UserStatus.active,
        emailVerified: true,
        phoneNumber: '+1234567890',
        city: 'New York',
        country: 'USA',
        lastLoginAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      User(
        id: '2',
        email: 'john.doe@example.com',
        firstName: 'John',
        lastName: 'Doe',
        role: UserRole.customer,
        status: UserStatus.active,
        emailVerified: true,
        phoneNumber: '+1987654321',
        city: 'Los Angeles',
        country: 'USA',
        lastLoginAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      User(
        id: '3',
        email: 'jane.smith@example.com',
        firstName: 'Jane',
        lastName: 'Smith',
        role: UserRole.customer,
        status: UserStatus.active,
        emailVerified: false,
        phoneNumber: '+1555666777',
        city: 'Chicago',
        country: 'USA',
        lastLoginAt: DateTime.now().subtract(const Duration(days: 3)),
      ),
      User(
        id: '4',
        email: 'moderator@ecommerce.com',
        firstName: 'Sarah',
        lastName: 'Wilson',
        role: UserRole.moderator,
        status: UserStatus.active,
        emailVerified: true,
        phoneNumber: '+1444555666',
        city: 'Boston',
        country: 'USA',
        lastLoginAt: DateTime.now().subtract(const Duration(hours: 5)),
      ),
      User(
        id: '5',
        email: 'inactive.user@example.com',
        firstName: 'Bob',
        lastName: 'Johnson',
        role: UserRole.customer,
        status: UserStatus.inactive,
        emailVerified: true,
        phoneNumber: '+1333444555',
        city: 'Seattle',
        country: 'USA',
        lastLoginAt: DateTime.now().subtract(const Duration(days: 30)),
      ),
    ];
  }

  Future<void> _saveUsers() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final usersJson = json.encode(_users.map((user) => user.toJson()).toList());
      await prefs.setString('admin_users', usersJson);
    } catch (e) {
      debugPrint('Error saving users: $e');
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  Future<void> addUser(User user) async {
    _users.add(user);
    await _saveUsers();
    notifyListeners();
  }

  Future<void> updateUser(User updatedUser) async {
    final index = _users.indexWhere((user) => user.id == updatedUser.id);
    if (index != -1) {
      _users[index] = updatedUser.copyWith(updatedAt: DateTime.now());
      await _saveUsers();
      notifyListeners();
    }
  }

  Future<void> deleteUser(User user) async {
    _users.removeWhere((u) => u.id == user.id);
    await _saveUsers();
    notifyListeners();
  }

  Future<void> changeUserStatus(User user, UserStatus newStatus) async {
    final updatedUser = user.copyWith(
      status: newStatus,
      updatedAt: DateTime.now(),
    );
    await updateUser(updatedUser);
  }

  Future<void> changeUserRole(User user, UserRole newRole) async {
    final updatedUser = user.copyWith(
      role: newRole,
      updatedAt: DateTime.now(),
    );
    await updateUser(updatedUser);
  }

  Future<void> updateLastLogin(User user) async {
    final updatedUser = user.copyWith(
      lastLoginAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    await updateUser(updatedUser);
  }

  User? getUserById(String id) {
    try {
      return _users.firstWhere((user) => user.id == id);
    } catch (e) {
      return null;
    }
  }

  User? getUserByEmail(String email) {
    try {
      return _users.firstWhere((user) => user.email.toLowerCase() == email.toLowerCase());
    } catch (e) {
      return null;
    }
  }

  List<User> searchUsers(String query) {
    if (query.isEmpty) return _users;
    
    return _users.where((user) {
      return user.email.toLowerCase().contains(query.toLowerCase()) ||
             user.firstName.toLowerCase().contains(query.toLowerCase()) ||
             user.lastName.toLowerCase().contains(query.toLowerCase()) ||
             user.fullName.toLowerCase().contains(query.toLowerCase()) ||
             (user.phoneNumber?.contains(query) ?? false);
    }).toList();
  }

  List<User> getUsersByRole(UserRole role) {
    return _users.where((user) => user.role == role).toList();
  }

  List<User> getUsersByStatus(UserStatus status) {
    return _users.where((user) => user.status == status).toList();
  }

  String _generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  Future<User> createUser({
    required String email,
    required String firstName,
    required String lastName,
    String? phoneNumber,
    String? profilePictureUrl,
    UserRole role = UserRole.customer,
    UserStatus status = UserStatus.active,
    String? address,
    String? city,
    String? country,
    String? postalCode,
    bool emailVerified = false,
    bool phoneVerified = false,
    Map<String, dynamic>? preferences,
  }) async {
    final user = User(
      id: _generateId(),
      email: email,
      firstName: firstName,
      lastName: lastName,
      phoneNumber: phoneNumber,
      profilePictureUrl: profilePictureUrl,
      role: role,
      status: status,
      address: address,
      city: city,
      country: country,
      postalCode: postalCode,
      emailVerified: emailVerified,
      phoneVerified: phoneVerified,
      preferences: preferences,
    );

    await addUser(user);
    return user;
  }

  Future<void> refreshUsers() async {
    await _loadUsers();
  }

  // Statistics
  int get totalUsers => _users.length;
  int get activeUsersCount => _users.where((user) => user.status == UserStatus.active).length;
  int get inactiveUsersCount => _users.where((user) => user.status == UserStatus.inactive).length;
  int get suspendedUsersCount => _users.where((user) => user.status == UserStatus.suspended).length;
  int get pendingUsersCount => _users.where((user) => user.status == UserStatus.pending).length;
  
  int get adminUsersCount => _users.where((user) => user.role == UserRole.admin).length;
  int get customerUsersCount => _users.where((user) => user.role == UserRole.customer).length;
  int get moderatorUsersCount => _users.where((user) => user.role == UserRole.moderator).length;

  int get verifiedEmailsCount => _users.where((user) => user.emailVerified).length;
  int get verifiedPhonesCount => _users.where((user) => user.phoneVerified).length;

  // Recent activity
  List<User> get recentlyLoggedInUsers {
    final now = DateTime.now();
    return _users
        .where((user) => user.lastLoginAt != null && 
                        now.difference(user.lastLoginAt!).inDays <= 7)
        .toList()
      ..sort((a, b) => b.lastLoginAt!.compareTo(a.lastLoginAt!));
  }

  List<User> get recentlyRegisteredUsers {
    final now = DateTime.now();
    return _users
        .where((user) => now.difference(user.createdAt).inDays <= 7)
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }
}
