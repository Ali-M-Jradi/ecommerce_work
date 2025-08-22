import 'package:flutter/material.dart';
import '../../utils/parameter_test_helper.dart';
import '../../utils/app_colors.dart';

class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 900;
    
    // Use app colors for consistent theming
    final primaryColor = AppColors.primary(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        automaticallyImplyLeading: false,
        backgroundColor: primaryColor,
        elevation: 0,
        toolbarHeight: 80,
        actions: [
          // Quick Test Button
          IconButton(
            icon: const Icon(Icons.science),
            tooltip: 'Test Parameters',
            onPressed: () => ParameterTestHelper.showTestDialog(context),
          ),
          const SizedBox(width: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.logout),
              label: const Text('LOGOUT'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white.withOpacity(0.2),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              primaryColor.withOpacity(0.05),
              Colors.transparent,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min, // Added to prevent overflow
            children: [
              // Welcome section
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        Icons.dashboard,
                        size: 32,
                        color: primaryColor,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min, // Added to prevent overflow
                        children: [
                          Text(
                            'Welcome to Admin Dashboard',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: primaryColor,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Manage your ecommerce platform efficiently',
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              
              // Admin tiles grid
              Expanded(
                child: GridView.count(
                  crossAxisCount: isWide ? 4 : 2,
                  crossAxisSpacing: 16, // Reduced from 20
                  mainAxisSpacing: 16, // Reduced from 20
                  childAspectRatio: 1.2, // Increased from 1.1 for more height
                  padding: const EdgeInsets.all(8), // Added padding
                  children: [
                    _AdminTile(
                      icon: Icons.settings,
                      label: 'Parameters',
                      onTap: () => Navigator.of(context).pushNamed('/admin/parameters'),
                    ),
                    _AdminTile(
                      icon: Icons.tune,
                      label: 'Settings',
                      onTap: () => Navigator.of(context).pushNamed('/admin/settings'),
                    ),
                    _AdminTile(
                      icon: Icons.attach_money,
                      label: 'Currencies',
                      onTap: () => Navigator.of(context).pushNamed('/admin/currencies'),
                    ),
                    _AdminTile(
                      icon: Icons.card_giftcard,
                      label: 'Loyalty Program',
                      onTap: () => Navigator.of(context).pushNamed('/admin/loyalty'),
                    ),
                    _AdminTile(
                      icon: Icons.category,
                      label: 'Attributes',
                      onTap: () => Navigator.of(context).pushNamed('/admin/attributes'),
                    ),
                    _AdminTile(
                      icon: Icons.inventory,
                      label: 'Categories',
                      onTap: () => Navigator.of(context).pushNamed('/admin/categories'),
                    ),
                    _AdminTile(
                      icon: Icons.inventory_2,
                      label: 'Products',
                      onTap: () => Navigator.of(context).pushNamed('/admin/products'),
                    ),
                    _AdminTile(
                      icon: Icons.people,
                      label: 'Users',
                      onTap: () => Navigator.of(context).pushNamed('/admin/users'),
                    ),
                    _AdminTile(
                      icon: Icons.branding_watermark,
                      label: 'Brands',
                      onTap: () => Navigator.of(context).pushNamed('/admin/brands'),
                    ),
                    _AdminTile(
                      icon: Icons.price_check,
                      label: 'Prices',
                      onTap: () => Navigator.of(context).pushNamed('/admin/prices'),
                    ),
                    _AdminTile(
                      icon: Icons.shopping_bag,
                      label: 'Orders',
                      onTap: () => Navigator.of(context).pushNamed('/admin/orders'),
                    ),
                    _AdminTile(
                      icon: Icons.content_paste,
                      label: 'Content Management',
                      onTap: () => Navigator.of(context).pushNamed('/admin/content'),
                    ),
                    _AdminTile(
                      icon: Icons.bug_report,
                      label: 'Content Test',
                      onTap: () => Navigator.of(context).pushNamed('/admin/content-test'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}




class _AdminTile extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _AdminTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  State<_AdminTile> createState() => _AdminTileState();
}

class _AdminTileState extends State<_AdminTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.02,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _elevationAnimation = Tween<double>(
      begin: 2.0,
      end: 8.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = AppColors.primary(context);
    
    return MouseRegion(
      onEnter: (_) {
        setState(() => _isHovered = true);
        _animationController.forward();
      },
      onExit: (_) {
        setState(() => _isHovered = false);
        _animationController.reverse();
      },
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: _isHovered 
                        ? primaryColor.withOpacity(0.2)
                        : Colors.grey.withOpacity(0.1),
                    blurRadius: _elevationAnimation.value * 2,
                    offset: Offset(0, _elevationAnimation.value),
                  ),
                ],
                border: _isHovered
                    ? Border.all(color: primaryColor.withOpacity(0.3), width: 1)
                    : null,
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: widget.onTap,
                  splashColor: primaryColor.withOpacity(0.1),
                  highlightColor: primaryColor.withOpacity(0.05),
                  child: Container(
                    padding: const EdgeInsets.all(16.0), // Reduced from 24.0
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min, // Added to prevent overflow
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16), // Reduced from 20
                          decoration: BoxDecoration(
                            color: _isHovered
                                ? primaryColor.withOpacity(0.15)
                                : primaryColor.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            widget.icon,
                            size: 24, // Reduced from 28
                            color: primaryColor,
                          ),
                        ),
                        const SizedBox(height: 12), // Reduced from 16
                        Flexible( // Wrapped in Flexible to prevent overflow
                          child: Text(
                            widget.label,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14, // Slightly smaller font size
                                  color: _isHovered
                                      ? primaryColor
                                      : Colors.grey.shade700,
                                ),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
