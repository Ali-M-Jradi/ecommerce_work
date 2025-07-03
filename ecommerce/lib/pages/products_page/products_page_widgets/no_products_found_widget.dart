import 'package:flutter/material.dart';
import '../../../localization/app_localizations_helper.dart';

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
              AppLocalizationsHelper.of(context).noProductsFound,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 12),
            if (searchQuery != null && searchQuery!.isNotEmpty)
              Text(
                AppLocalizationsHelper.of(context).noProductsMatchSearch(searchQuery!),
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                ),
                textAlign: TextAlign.center,
              )
            else if (hasActiveFilters)
              Text(
                AppLocalizationsHelper.of(context).noProductsMatchFilters,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                ),
                textAlign: TextAlign.center,
              )
            else
              Text(
                AppLocalizationsHelper.of(context).noProductsAvailable,
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
                    AppLocalizationsHelper.of(context).tryAdjustingFilters,
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
                      label: Text(AppLocalizationsHelper.of(context).clearAllFilters),
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
