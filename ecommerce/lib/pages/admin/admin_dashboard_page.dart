import 'package:flutter/material.dart';
import '../../utils/parameter_test_helper.dart';

class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isWide = MediaQuery.of(context).size.width > 900;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.deepOrange, // Changed for visibility
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
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: isWide ? 4 : 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _AdminTile(
              icon: Icons.settings,
              label: 'Parameters',
              color: colorScheme.primary,
              onTap: () => Navigator.of(context).pushNamed('/admin/parameters'),
            ),
            _AdminTile(
              icon: Icons.tune,
              label: 'Settings',
              color: colorScheme.secondary,
              onTap: () => Navigator.of(context).pushNamed('/admin/settings'),
            ),
            _AdminTile(
              icon: Icons.attach_money,
              label: 'Currencies',
              color: colorScheme.primary,
              onTap: () => Navigator.of(context).pushNamed('/admin/currencies'),
            ),
            _AdminTile(
              icon: Icons.card_giftcard,
              label: 'Loyalty Program',
              color: colorScheme.secondary,
              onTap: () => Navigator.of(context).pushNamed('/admin/loyalty'),
            ),
            _AdminTile(
              icon: Icons.category,
              label: 'Attributes',
              color: colorScheme.primary,
              onTap: () => Navigator.of(context).pushNamed('/admin/attributes'),
            ),
            _AdminTile(
              icon: Icons.inventory,
              label: 'Categories',
              color: colorScheme.secondary,
              onTap: () => Navigator.of(context).pushNamed('/admin/categories'),
            ),
            _AdminTile(
              icon: Icons.inventory_2,
              label: 'Products',
              color: colorScheme.tertiary,
              onTap: () => Navigator.of(context).pushNamed('/admin/products'),
            ),
            _AdminTile(
              icon: Icons.people,
              label: 'Users',
              color: colorScheme.primary,
              onTap: () => Navigator.of(context).pushNamed('/admin/users'),
            ),
            _AdminTile(
              icon: Icons.branding_watermark,
              label: 'Brands',
              color: colorScheme.secondary,
              onTap: () => Navigator.of(context).pushNamed('/admin/brands'),
            ),
            _AdminTile(
              icon: Icons.price_check,
              label: 'Prices',
              color: colorScheme.tertiary,
              onTap: () => Navigator.of(context).pushNamed('/admin/prices'),
            ),
            _AdminTile(
              icon: Icons.shopping_bag,
              label: 'Orders',
              color: colorScheme.primary,
              onTap: () => Navigator.of(context).pushNamed('/admin/orders'),
            ),
            _AdminTile(
              icon: Icons.content_paste,
              label: 'Content Management',
              color: colorScheme.secondary,
              onTap: () => Navigator.of(context).pushNamed('/admin/content'),
            ),
            _AdminTile(
              icon: Icons.bug_report,
              label: 'Content Test',
              color: colorScheme.tertiary,
              onTap: () => Navigator.of(context).pushNamed('/admin/content-test'),
            ),
          ],
        ),
      ),
    );
  }
}




class _AdminTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _AdminTile({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: color),
              const SizedBox(height: 16),
              Text(label, style: Theme.of(context).textTheme.titleMedium),
            ],
          ),
        ),
      ),
    );
  }
}
