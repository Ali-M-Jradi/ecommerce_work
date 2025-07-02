import 'package:flutter/material.dart';

class NoProductsFoundWidget extends StatelessWidget {
  final String? searchQuery;
  final bool hasActiveFilters;
  final VoidCallback? onClearFilters;

  const NoProductsFoundWidget({
    super.key,
    this.searchQuery,
    this.hasActiveFilters = false,
    this.onClearFilters,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.search_off,
              size: 80,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 20),
            Text(
              'No Products Found',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 12),
            if (searchQuery != null && searchQuery!.isNotEmpty)
              Text(
                'No products match your search for "${searchQuery!}"',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                ),
                textAlign: TextAlign.center,
              )
            else if (hasActiveFilters)
              Text(
                'No products match your current filters',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                ),
                textAlign: TextAlign.center,
              )
            else
              Text(
                'No products available at the moment',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                ),
                textAlign: TextAlign.center,
              ),
            const SizedBox(height: 24),
            if (hasActiveFilters || (searchQuery != null && searchQuery!.isNotEmpty))
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Try adjusting your search or filters',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade500,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (hasActiveFilters && onClearFilters != null)
                    ElevatedButton.icon(
                      onPressed: onClearFilters,
                      icon: const Icon(Icons.clear_all),
                      label: const Text('Clear All Filters'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple.shade600,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
