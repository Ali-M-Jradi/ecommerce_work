import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/admin_user_provider.dart';
import '../../models/user.dart';
import '../../utils/app_colors.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  String _searchQuery = '';
  UserStatus? _selectedStatus;
  UserRole? _selectedRole;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 768;

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Management'),
        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => context.read<AdminUserProvider>().refreshUsers(),
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: Consumer<AdminUserProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              _buildHeader(provider),
              _buildFilters(),
              Expanded(
                child: isDesktop 
                    ? _buildDesktopView(provider)
                    : _buildMobileView(provider),
              ),
            ],
          );
        },
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: AppColors.primary(context).withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: FloatingActionButton.extended(
          onPressed: () => _showUserModal(context),
          backgroundColor: AppColors.primary(context),
          foregroundColor: Colors.white,
          elevation: 8,
          highlightElevation: 12,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          icon: const Icon(Icons.person_add, size: 24),
          label: const Text(
            'Add User',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(AdminUserProvider provider) {
    return Container(
      padding: const EdgeInsets.all(24),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primaryContainer,
            Theme.of(context).colorScheme.secondaryContainer,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.people,
                size: 32,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'User Management',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                    Text(
                      'Manage user accounts, roles, and permissions',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildStatsRow(provider),
        ],
      ),
    );
  }

  Widget _buildStatsRow(AdminUserProvider provider) {
    return Row(
      children: [
        Expanded(child: _buildStatCard('Total Users', provider.totalUsers.toString(), Icons.people)),
        const SizedBox(width: 16),
        Expanded(child: _buildStatCard('Active', provider.activeUsersCount.toString(), Icons.check_circle)),
        const SizedBox(width: 16),
        Expanded(child: _buildStatCard('Admins', provider.adminUsersCount.toString(), Icons.admin_panel_settings)),
        const SizedBox(width: 16),
        Expanded(child: _buildStatCard('Verified', provider.verifiedEmailsCount.toString(), Icons.verified)),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withOpacity(0.8),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.primary),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 768;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: isDesktop
          ? Row(
              children: [
                Expanded(
                  flex: 3,
                  child: TextField(
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      hintText: 'Search users...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      isDense: true,
                    ),
                    onChanged: (value) => setState(() => _searchQuery = value),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: DropdownButtonFormField<UserStatus>(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    hint: const Text('Status'),
                    value: _selectedStatus,
                    onChanged: (status) => setState(() => _selectedStatus = status),
                    items: [
                      const DropdownMenuItem<UserStatus>(
                        value: null,
                        child: Text('All Statuses'),
                      ),
                      ...UserStatus.values.map((status) => DropdownMenuItem(
                        value: status,
                        child: Text(status.name.toUpperCase()),
                      )),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: DropdownButtonFormField<UserRole>(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    hint: const Text('Role'),
                    value: _selectedRole,
                    onChanged: (role) => setState(() => _selectedRole = role),
                    items: [
                      const DropdownMenuItem<UserRole>(
                        value: null,
                        child: Text('All Roles'),
                      ),
                      ...UserRole.values.map((role) => DropdownMenuItem(
                        value: role,
                        child: Text(role.name.toUpperCase()),
                      )),
                    ],
                  ),
                ),
              ],
            )
          : Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    hintText: 'Search users...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    isDense: true,
                  ),
                  onChanged: (value) => setState(() => _searchQuery = value),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<UserStatus>(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        hint: const Text('Status'),
                        value: _selectedStatus,
                        onChanged: (status) => setState(() => _selectedStatus = status),
                        items: [
                          const DropdownMenuItem<UserStatus>(
                            value: null,
                            child: Text('All Statuses'),
                          ),
                          ...UserStatus.values.map((status) => DropdownMenuItem(
                            value: status,
                            child: Text(status.name.toUpperCase()),
                          )),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: DropdownButtonFormField<UserRole>(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        hint: const Text('Role'),
                        value: _selectedRole,
                        onChanged: (role) => setState(() => _selectedRole = role),
                        items: [
                          const DropdownMenuItem<UserRole>(
                            value: null,
                            child: Text('All Roles'),
                          ),
                          ...UserRole.values.map((role) => DropdownMenuItem(
                            value: role,
                            child: Text(role.name.toUpperCase()),
                          )),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
    );
  }

  Widget _buildDesktopView(AdminUserProvider provider) {
    final filteredUsers = _getFilteredUsers(provider);

    return Card(
      margin: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainer,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              children: [
                Text(
                  'Users (${filteredUsers.length})',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: filteredUsers.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.people_outline,
                          size: 64,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No users found',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Theme.of(context).colorScheme.outline,
                          ),
                        ),
                      ],
                    ),
                  )
                : SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width),
                      child: DataTable(
                        columnSpacing: 16,
                        headingRowHeight: 48,
                        dataRowMinHeight: 56,
                        dataRowMaxHeight: 72,
                        columns: const [
                          DataColumn(label: Text('User', overflow: TextOverflow.ellipsis)),
                          DataColumn(label: Text('Email', overflow: TextOverflow.ellipsis)),
                          DataColumn(label: Text('Role', overflow: TextOverflow.ellipsis)),
                          DataColumn(label: Text('Status', overflow: TextOverflow.ellipsis)),
                          DataColumn(label: Text('Last Login', overflow: TextOverflow.ellipsis)),
                          DataColumn(label: Text('Created', overflow: TextOverflow.ellipsis)),
                          DataColumn(label: Text('Actions', overflow: TextOverflow.ellipsis)),
                        ],
                      rows: filteredUsers.map((user) => DataRow(
                        cells: [
                          DataCell(
                            ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 180),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CircleAvatar(
                                    radius: 16,
                                    backgroundColor: Theme.of(context).colorScheme.primary,
                                    child: Text(
                                      user.initials,
                                      style: TextStyle(
                                        color: Theme.of(context).colorScheme.onPrimary,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Flexible(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          user.fullName,
                                          style: const TextStyle(fontWeight: FontWeight.w500),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                        if (user.phoneNumber != null)
                                          Text(
                                            user.phoneNumber!,
                                            style: Theme.of(context).textTheme.bodySmall,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          DataCell(
                            ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 200),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Flexible(
                                    child: Text(
                                      user.email,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  if (user.emailVerified)
                                    const Icon(
                                      Icons.verified,
                                      size: 16,
                                      color: Colors.green,
                                    ),
                                ],
                              ),
                            ),
                          ),
                          DataCell(
                            ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 100),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: _getRoleColor(user.role),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  user.roleDisplayName,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                          DataCell(
                            ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 100),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: _getStatusColor(user.status),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  user.statusDisplayName,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                          DataCell(
                            ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 120),
                              child: Text(
                                user.lastLoginAt != null
                                    ? _formatDate(user.lastLoginAt!)
                                    : 'Never',
                                style: Theme.of(context).textTheme.bodySmall,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                          ),
                          DataCell(
                            ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 120),
                              child: Text(
                                _formatDate(user.createdAt),
                                style: Theme.of(context).textTheme.bodySmall,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                          ),
                          DataCell(
                            ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 100),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit, size: 18),
                                    onPressed: () => _showUserModal(context, user: user),
                                    tooltip: 'Edit',
                                    padding: const EdgeInsets.all(4),
                                    constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, size: 18),
                                    onPressed: () => _showDeleteConfirmation(context, user, provider),
                                    tooltip: 'Delete',
                                    padding: const EdgeInsets.all(4),
                                    constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )).toList(),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileView(AdminUserProvider provider) {
    final filteredUsers = _getFilteredUsers(provider);

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredUsers.length,
      itemBuilder: (context, index) {
        final user = filteredUsers[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: Text(
                user.initials,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text(
              user.fullName,
              style: const TextStyle(fontWeight: FontWeight.w500),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        user.email,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    if (user.emailVerified)
                      const Icon(Icons.verified, size: 16, color: Colors.green),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: _getRoleColor(user.role),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        user.roleDisplayName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: _getStatusColor(user.status),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        user.statusDisplayName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            trailing: PopupMenuButton(
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: const Row(
                    children: [Icon(Icons.edit, size: 16), SizedBox(width: 8), Text('Edit')],
                  ),
                  onTap: () => _showUserModal(context, user: user),
                ),
                PopupMenuItem(
                  child: const Row(
                    children: [Icon(Icons.delete, size: 16), SizedBox(width: 8), Text('Delete')],
                  ),
                  onTap: () => _showDeleteConfirmation(context, user, provider),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  List<User> _getFilteredUsers(AdminUserProvider provider) {
    var users = provider.searchUsers(_searchQuery);
    
    if (_selectedStatus != null) {
      users = users.where((user) => user.status == _selectedStatus).toList();
    }
    
    if (_selectedRole != null) {
      users = users.where((user) => user.role == _selectedRole).toList();
    }
    
    return users;
  }

  Color _getRoleColor(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return AppColors.error(context);
      case UserRole.moderator:
        return AppColors.warning(context);
      case UserRole.customer:
        return AppColors.info(context);
    }
  }

  Color _getStatusColor(UserStatus status) {
    switch (status) {
      case UserStatus.active:
        return AppColors.success(context);
      case UserStatus.inactive:
        return Colors.grey;
      case UserStatus.suspended:
        return AppColors.error(context);
      case UserStatus.pending:
        return AppColors.warning(context);
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays < 1) {
      if (difference.inHours < 1) {
        return '${difference.inMinutes}m ago';
      }
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  void _showUserModal(BuildContext context, {User? user}) {
    showDialog(
      context: context,
      builder: (context) => _UserFormDialog(user: user),
    );
  }

  void _showDeleteConfirmation(BuildContext context, User user, AdminUserProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete User'),
        content: Text('Are you sure you want to delete "${user.fullName}"? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              provider.deleteUser(user);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('User "${user.fullName}" deleted successfully')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class _UserFormDialog extends StatefulWidget {
  final User? user;

  const _UserFormDialog({this.user});

  @override
  State<_UserFormDialog> createState() => _UserFormDialogState();
}

class _UserFormDialogState extends State<_UserFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressController;
  late final TextEditingController _cityController;
  late final TextEditingController _countryController;
  late final TextEditingController _postalCodeController;
  late UserRole _selectedRole;
  late UserStatus _selectedStatus;
  late bool _emailVerified;
  late bool _phoneVerified;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.user?.email ?? '');
    _firstNameController = TextEditingController(text: widget.user?.firstName ?? '');
    _lastNameController = TextEditingController(text: widget.user?.lastName ?? '');
    _phoneController = TextEditingController(text: widget.user?.phoneNumber ?? '');
    _addressController = TextEditingController(text: widget.user?.address ?? '');
    _cityController = TextEditingController(text: widget.user?.city ?? '');
    _countryController = TextEditingController(text: widget.user?.country ?? '');
    _postalCodeController = TextEditingController(text: widget.user?.postalCode ?? '');
    _selectedRole = widget.user?.role ?? UserRole.customer;
    _selectedStatus = widget.user?.status ?? UserStatus.active;
    _emailVerified = widget.user?.emailVerified ?? false;
    _phoneVerified = widget.user?.phoneVerified ?? false;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _countryController.dispose();
    _postalCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.user != null;
    final screenWidth = MediaQuery.of(context).size.width;
    final dialogWidth = screenWidth > 600 ? 500.0 : screenWidth * 0.9;

    return AlertDialog(
      title: Text(isEditing ? 'Edit User' : 'Add New User'),
      content: SizedBox(
        width: dialogWidth,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height * 0.5,
              ),
              child: IntrinsicHeight(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                screenWidth > 600
                    ? Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _firstNameController,
                              decoration: const InputDecoration(
                                labelText: 'First Name *',
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Please enter first name';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: _lastNameController,
                              decoration: const InputDecoration(
                                labelText: 'Last Name *',
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Please enter last name';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          TextFormField(
                            controller: _firstNameController,
                            decoration: const InputDecoration(
                              labelText: 'First Name *',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter first name';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _lastNameController,
                            decoration: const InputDecoration(
                              labelText: 'Last Name *',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter last name';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email *',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter email';
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(
                    labelText: 'Phone Number',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                screenWidth > 600
                    ? Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<UserRole>(
                              value: _selectedRole,
                              decoration: const InputDecoration(
                                labelText: 'Role',
                                border: OutlineInputBorder(),
                              ),
                              items: UserRole.values.map((role) => DropdownMenuItem(
                                value: role,
                                child: Text(role.name.toUpperCase()),
                              )).toList(),
                              onChanged: (role) => setState(() => _selectedRole = role!),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: DropdownButtonFormField<UserStatus>(
                              value: _selectedStatus,
                              decoration: const InputDecoration(
                                labelText: 'Status',
                                border: OutlineInputBorder(),
                              ),
                              items: UserStatus.values.map((status) => DropdownMenuItem(
                                value: status,
                                child: Text(status.name.toUpperCase()),
                              )).toList(),
                              onChanged: (status) => setState(() => _selectedStatus = status!),
                            ),
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          DropdownButtonFormField<UserRole>(
                            value: _selectedRole,
                            decoration: const InputDecoration(
                              labelText: 'Role',
                              border: OutlineInputBorder(),
                            ),
                            items: UserRole.values.map((role) => DropdownMenuItem(
                              value: role,
                              child: Text(role.name.toUpperCase()),
                            )).toList(),
                            onChanged: (role) => setState(() => _selectedRole = role!),
                          ),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<UserStatus>(
                            value: _selectedStatus,
                            decoration: const InputDecoration(
                              labelText: 'Status',
                              border: OutlineInputBorder(),
                            ),
                            items: UserStatus.values.map((status) => DropdownMenuItem(
                              value: status,
                              child: Text(status.name.toUpperCase()),
                            )).toList(),
                            onChanged: (status) => setState(() => _selectedStatus = status!),
                          ),
                        ],
                      ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _addressController,
                  decoration: const InputDecoration(
                    labelText: 'Address',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                screenWidth > 600
                    ? Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _cityController,
                              decoration: const InputDecoration(
                                labelText: 'City',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: _countryController,
                              decoration: const InputDecoration(
                                labelText: 'Country',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          TextFormField(
                            controller: _cityController,
                            decoration: const InputDecoration(
                              labelText: 'City',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _countryController,
                            decoration: const InputDecoration(
                              labelText: 'Country',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ],
                      ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _postalCodeController,
                  decoration: const InputDecoration(
                    labelText: 'Postal Code',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: CheckboxListTile(
                        title: const Text('Email Verified'),
                        value: _emailVerified,
                        onChanged: (value) => setState(() => _emailVerified = value ?? false),
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                    ),
                    Expanded(
                      child: CheckboxListTile(
                        title: const Text('Phone Verified'),
                        value: _phoneVerified,
                        onChanged: (value) => setState(() => _phoneVerified = value ?? false),
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                    ),
                  ],
                ),
              ],
            ),
              ),
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _saveUser,
          child: Text(isEditing ? 'Update' : 'Create'),
        ),
      ],
    );
  }

  void _saveUser() async {
    if (_formKey.currentState!.validate()) {
      final provider = context.read<AdminUserProvider>();
      
      try {
        if (widget.user != null) {
          // Update existing user
          final updatedUser = widget.user!.copyWith(
            email: _emailController.text.trim(),
            firstName: _firstNameController.text.trim(),
            lastName: _lastNameController.text.trim(),
            phoneNumber: _phoneController.text.trim().isEmpty ? null : _phoneController.text.trim(),
            role: _selectedRole,
            status: _selectedStatus,
            address: _addressController.text.trim().isEmpty ? null : _addressController.text.trim(),
            city: _cityController.text.trim().isEmpty ? null : _cityController.text.trim(),
            country: _countryController.text.trim().isEmpty ? null : _countryController.text.trim(),
            postalCode: _postalCodeController.text.trim().isEmpty ? null : _postalCodeController.text.trim(),
            emailVerified: _emailVerified,
            phoneVerified: _phoneVerified,
          );
          await provider.updateUser(updatedUser);
          
          if (mounted) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('User updated successfully')),
            );
          }
        } else {
          // Create new user
          await provider.createUser(
            email: _emailController.text.trim(),
            firstName: _firstNameController.text.trim(),
            lastName: _lastNameController.text.trim(),
            phoneNumber: _phoneController.text.trim().isEmpty ? null : _phoneController.text.trim(),
            role: _selectedRole,
            status: _selectedStatus,
            address: _addressController.text.trim().isEmpty ? null : _addressController.text.trim(),
            city: _cityController.text.trim().isEmpty ? null : _cityController.text.trim(),
            country: _countryController.text.trim().isEmpty ? null : _countryController.text.trim(),
            postalCode: _postalCodeController.text.trim().isEmpty ? null : _postalCodeController.text.trim(),
            emailVerified: _emailVerified,
            phoneVerified: _phoneVerified,
          );
          
          if (mounted) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('User created successfully')),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
        }
      }
    }
  }
}
