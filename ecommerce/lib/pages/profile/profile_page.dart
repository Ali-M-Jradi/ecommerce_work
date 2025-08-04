import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:ecommerce/utils/localization_helper.dart';
import 'package:ecommerce/providers/user_provider.dart';
import 'package:ecommerce/providers/language_provider.dart';
import 'package:ecommerce/l10n/app_localizations.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  int _currentBackgroundIndex = 0;
  
  // Background colors for animated gradient (same as login page for consistency)
  List<List<Color>> get _backgroundColors {
    final colorScheme = Theme.of(context).colorScheme;
    return [
      [colorScheme.surface, colorScheme.surfaceVariant],
      [colorScheme.primary, colorScheme.secondary],
      [colorScheme.secondary, colorScheme.primary],
      [colorScheme.background, colorScheme.surface],
    ];
  }

  // Controller for the tab view
  final _tabController = PageController();
  
  // Section currently in view
  int _currentSection = 0;
  
  // Get localized sections
  List<String> _getSections(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return [
      localizations.profilePersonalInfo,
      localizations.profileOrders,
      localizations.profileAddresses,
      localizations.profileWishlist,
      localizations.profileSettings,
    ];
  }

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startBackgroundAnimation();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOut,
    ));
    
    // Start animations
    _animationController.forward();
    _slideController.forward();
  }

  void _startBackgroundAnimation() {
    Future.delayed(const Duration(seconds: 8), () {
      if (mounted) {
        setState(() {
          _currentBackgroundIndex = (_currentBackgroundIndex + 1) % _backgroundColors.length;
        });
        _startBackgroundAnimation();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _slideController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isRTL = LocalizationHelper.isRTL(context);
    
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Consumer<UserProvider>(
        builder: (context, userProvider, _) {
          final user = userProvider.currentUser;
          
          if (user == null) {
            // Redirect to login if not logged in
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacementNamed(context, '/login');
            });
            
            return const Center(child: CircularProgressIndicator());
          }
          
          return AnimatedContainer(
            duration: const Duration(seconds: 5),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: _backgroundColors[_currentBackgroundIndex],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  // App Bar with back button and title
                  _buildProfileAppBar(isRTL),
                  
                  // Profile Header with avatar and user info
                  _buildProfileHeader(user),
                  
                  // Tab Navigation
                  _buildTabNavigation(isRTL),
                  
                  // Main Content Area
                  Expanded(
                    child: PageView(
                      controller: _tabController,
                      onPageChanged: (index) {
                        setState(() {
                          _currentSection = index;
                        });
                      },
                      children: [
                        _buildPersonalInfoSection(user),
                        _buildOrdersSection(),
                        _buildAddressesSection(),
                        _buildWishlistSection(),
                        _buildSettingsSection(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileAppBar(bool isRTL) {
    final localizations = AppLocalizations.of(context)!;
    
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(
              isRTL ? Icons.arrow_forward : Icons.arrow_back,
              color: colorScheme.onSurface,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          Text(
            localizations.myProfile,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          IconButton(
            icon: Icon(Icons.edit, color: colorScheme.onSurface),
            onPressed: () {
              // Handle profile editing
              HapticFeedback.lightImpact();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(User user) {
    final colorScheme = Theme.of(context).colorScheme;
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            // Profile Avatar
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colorScheme.surface.withOpacity(0.2),
                border: Border.all(
                  color: colorScheme.onSurface,
                  width: 3,
                ),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.shadow.withOpacity(0.1),
                    blurRadius: 15,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  user.displayName.substring(0, 1).toUpperCase(),
                  style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // User Name
            Text(
              user.displayName,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            // User Email
            Text(
              user.email,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white.withOpacity(0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabNavigation(bool isRTL) {
    final sections = _getSections(context);
    
    return Container(
      height: 60,
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: sections.length,
        itemBuilder: (context, index) {
          final isActive = _currentSection == index;
          
          return GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              _tabController.animateToPage(
                index,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: isActive ? Colors.white : Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Center(
                child: Text(
                  sections[index],
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                    color: isActive ? Colors.deepPurple.shade700 : Colors.white,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // Personal Info Section
  Widget _buildPersonalInfoSection(User user) {
    final localizations = AppLocalizations.of(context)!;
    
    return SlideTransition(
      position: _slideAnimation,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              spreadRadius: 0,
            ),
          ],
        ),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildProfileCard(
              icon: Icons.person_outline,
              title: localizations.profilePersonalInformation,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoRow(localizations.profileDisplayName, user.displayName),
                  _buildInfoRow(localizations.email, user.email),
                  _buildInfoRow(localizations.profilePhone, '+1 (555) 123-4567'), // Placeholder
                ],
              ),
            ),
            const SizedBox(height: 20),
            _buildProfileCard(
              icon: Icons.security_outlined,
              title: localizations.profileSecurity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildActionButton(
                    localizations.profileChangePassword,
                    Icons.lock_outline,
                    () {
                      // Handle change password
                    },
                  ),
                  _buildActionButton(
                    localizations.profileTwoFactorAuth,
                    Icons.shield_outlined,
                    () {
                      // Handle 2FA
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _buildProfileCard(
              icon: Icons.notifications_outlined,
              title: localizations.profileNotifications,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSwitchRow(localizations.profileEmailNotifications, true, (value) {
                    // Handle toggle
                  }),
                  _buildSwitchRow(localizations.profilePushNotifications, true, (value) {
                    // Handle toggle
                  }),
                  _buildSwitchRow(localizations.profileOrderUpdates, true, (value) {
                    // Handle toggle
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Orders Section
  Widget _buildOrdersSection() {
    final localizations = AppLocalizations.of(context)!;
    
    return SlideTransition(
      position: _slideAnimation,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              spreadRadius: 0,
            ),
          ],
        ),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildProfileCard(
              icon: Icons.shopping_bag_outlined,
              title: localizations.profileRecentOrders,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildOrderCard(
                    orderNumber: '#123456',
                    date: 'July 5, 2025',
                    status: localizations.profileOrderDelivered,
                    items: 3,
                    total: '\$49.99',
                  ),
                  _buildOrderCard(
                    orderNumber: '#123457',
                    date: 'June 27, 2025',
                    status: localizations.profileOrderProcessing,
                    items: 1,
                    total: '\$35.50',
                    statusColor: Colors.orange,
                  ),
                  _buildOrderCard(
                    orderNumber: '#123458',
                    date: 'June 15, 2025',
                    status: localizations.profileOrderDelivered,
                    items: 2,
                    total: '\$27.99',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: TextButton(
                onPressed: () {
                  // Navigate to order history
                },
                child: Text(
                  localizations.profileViewAllOrders,
                  style: TextStyle(
                    color: Colors.deepPurple.shade700,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Addresses Section
  Widget _buildAddressesSection() {
    final localizations = AppLocalizations.of(context)!;
    
    return SlideTransition(
      position: _slideAnimation,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              spreadRadius: 0,
            ),
          ],
        ),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildProfileCard(
              icon: Icons.home_outlined,
              title: localizations.profileShippingAddresses,
              actionText: localizations.profileAddNew,
              onAction: () {
                // Add new address
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildAddressCard(
                    label: localizations.profileAddressHome,
                    isDefault: true,
                    address: '123 Main Street, Apt 4B\nNew York, NY 10001\nUnited States',
                  ),
                  _buildAddressCard(
                    label: localizations.profileAddressWork,
                    isDefault: false,
                    address: '456 Business Ave\nNew York, NY 10002\nUnited States',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Wishlist Section
  Widget _buildWishlistSection() {
    return SlideTransition(
      position: _slideAnimation,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              spreadRadius: 0,
            ),
          ],
        ),
        child: GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.7,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: 4, // Placeholder
          itemBuilder: (context, index) {
            return _buildWishlistItemCard();
          },
        ),
      ),
    );
  }

  // Settings Section
  Widget _buildSettingsSection() {
    final localizations = AppLocalizations.of(context)!;
    
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, _) {
        final currentLocale = languageProvider.currentLocale;
        
        return SlideTransition(
          position: _slideAnimation,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildProfileCard(
                  icon: Icons.language,
                  title: localizations.profileLanguage,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLanguageSelector(
                        currentLocale, languageProvider),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                _buildProfileCard(
                  icon: Icons.dark_mode_outlined,
                  title: localizations.profileAppearance,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSwitchRow(localizations.profileDarkMode, false, (value) {
                        // Handle dark mode toggle
                      }),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                _buildProfileCard(
                  icon: Icons.logout,
                  title: localizations.profileAccount,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildActionButton(
                        localizations.logout,
                        Icons.exit_to_app,
                        () {
                          // Handle logout
                          Provider.of<UserProvider>(context, listen: false).logout();
                          Navigator.pushReplacementNamed(context, '/');
                        },
                        color: Colors.red.shade400,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }
    );
  }

  // Helper methods for UI components
  Widget _buildProfileCard({
    required IconData icon,
    required String title,
    required Widget child,
    String? actionText,
    VoidCallback? onAction,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 0,
          ),
        ],
        border: Border.all(
          color: Colors.grey.shade100,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    icon,
                    color: Colors.deepPurple.shade700,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              if (actionText != null && onAction != null)
                TextButton(
                  onPressed: onAction,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    backgroundColor: Colors.deepPurple.shade50,
                  ),
                  child: Text(
                    actionText,
                    style: TextStyle(
                      color: Colors.deepPurple.shade700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    String label,
    IconData icon,
    VoidCallback onTap, {
    Color? color,
  }) {
    return InkWell(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
            Icon(
              icon,
              size: 20,
              color: color ?? Colors.grey.shade700,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchRow(
    String label,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          Switch(
            value: value,
            onChanged: (newValue) {
              HapticFeedback.lightImpact();
              onChanged(newValue);
            },
            activeColor: Colors.deepPurple.shade700,
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCard({
    required String orderNumber,
    required String date,
    required String status,
    required int items,
    required String total,
    Color statusColor = Colors.green,
  }) {
    final localizations = AppLocalizations.of(context)!;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                orderNumber,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                date,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    fontSize: 12,
                    color: statusColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                '$items ${items == 1 ? localizations.profileItemSingular : localizations.profileItemPlural}',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${localizations.total}:',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
              Text(
                total,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  // View order details
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                ),
                child: Text(
                  localizations.profileViewDetails,
                  style: TextStyle(
                    color: Colors.deepPurple.shade700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAddressCard({
    required String label,
    required bool isDefault,
    required String address,
  }) {
    final localizations = AppLocalizations.of(context)!;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDefault ? Colors.deepPurple.shade200 : Colors.grey.shade200,
        ),
        color: isDefault ? Colors.deepPurple.shade50 : Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (isDefault) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.deepPurple.shade100,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        localizations.profileAddressDefault,
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.deepPurple.shade700,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.edit_outlined,
                      size: 20,
                      color: Colors.grey.shade600,
                    ),
                    onPressed: () {
                      // Edit address
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.delete_outline,
                      size: 20,
                      color: Colors.grey.shade600,
                    ),
                    onPressed: () {
                      // Delete address
                    },
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            address,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWishlistItemCard() {
    final localizations = AppLocalizations.of(context)!;
    
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product image
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              child: Container(
                color: Colors.grey.shade100,
                width: double.infinity,
                child: Center(
                  child: Image.asset(
                    'assets/images/three_leaves.png',
                    height: 60,
                    width: 60,
                    color: Colors.deepPurple.shade200,
                  ),
                ),
              ),
            ),
          ),
          
          // Product info
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  localizations.profileProductName,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '\$19.99',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.deepPurple.shade700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    // Add to cart
                    HapticFeedback.lightImpact();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple.shade700,
                    minimumSize: const Size(double.infinity, 32),
                    padding: EdgeInsets.zero,
                  ),
                  child: Text(
                    localizations.profileAddToCart,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageSelector(Locale currentLocale, LanguageProvider provider) {
    final isRTL = LocalizationHelper.isRTL(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey.shade100,
                        ),
                        child: Center(
                          child: Text(
                            currentLocale.languageCode == 'en' ? '🇺🇸' : '🇦🇪',
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        currentLocale.languageCode == 'en' ? 'English' : 'العربية',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const Icon(
                    Icons.arrow_drop_down,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton(
            onPressed: () {
              HapticFeedback.lightImpact();
              // Toggle language
              provider.toggleLanguage(); // Use the existing toggle method
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple.shade700,
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(12),
            ),
            child: const Icon(
              Icons.sync,
              color: Colors.white,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}
