import 'package:flutter/material.dart';
import '../../../localization/app_localizations_helper.dart';

class SortControlsWidget extends StatelessWidget {
  final String sortBy;
  final bool isGridView;
  final Function(String?) onSortChanged;
  final Function(bool) onViewChanged;
  final VoidCallback? onFilterPressed;
  final bool hasActiveFilters;

  const SortControlsWidget({
    super.key,
    required this.sortBy,
    required this.isGridView,
    required this.onSortChanged,
    required this.onViewChanged,
    this.onFilterPressed,
    this.hasActiveFilters = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      color: isDark ? colorScheme.surface : colorScheme.surface,
      child: Row(
        children: [
          // Sort by dropdown
          Expanded(
            flex: 3,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.0),
              decoration: BoxDecoration(
                border: Border.all(color: isDark ? colorScheme.outline : colorScheme.outlineVariant),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: sortBy,
                  icon: Icon(
                    Icons.arrow_drop_down,
                    color: isDark ? colorScheme.primary : colorScheme.primary,
                  ),
                  style: TextStyle(
                    color: isDark ? colorScheme.onSurface : colorScheme.onSurface,
                    fontSize: 14,
                  ),
                  dropdownColor: isDark ? colorScheme.surface : colorScheme.surface,
                  items: [
                    DropdownMenuItem(
                      value: 'A to Z',
                      child: Text(
                        AppLocalizationsHelper.of(context).sortAtoZ,
                        style: TextStyle(color: isDark ? colorScheme.onSurface : colorScheme.onSurface),
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'Z to A',
                      child: Text(
                        AppLocalizationsHelper.of(context).sortZtoA,
                        style: TextStyle(color: isDark ? colorScheme.onSurface : colorScheme.onSurface),
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'Price Low',
                      child: Text(
                        AppLocalizationsHelper.of(context).sortPriceLow,
                        style: TextStyle(color: isDark ? colorScheme.onSurface : colorScheme.onSurface),
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'Price High',
                      child: Text(
                        AppLocalizationsHelper.of(context).sortPriceHigh,
                        style: TextStyle(color: isDark ? colorScheme.onSurface : colorScheme.onSurface),
                      ),
                    ),
                  ],
                  onChanged: onSortChanged,
                ),
              ),
            ),
          ),
          SizedBox(width: 12.0),
          // View toggle buttons
          Expanded(
            flex: 2,
            child: Row(
              children: [
              Expanded(
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: isGridView
                        ? (isDark ? colorScheme.primary : colorScheme.primary)
                        : (isDark ? colorScheme.secondary : colorScheme.secondaryContainer),
                    borderRadius: BorderRadiusDirectional.only(
                        topStart: Radius.circular(8.0),
                        bottomStart: Radius.circular(8.0),
                      ),
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.grid_view,
                        color: Colors.white,
                        size: 20,
                      ),
                      tooltip: AppLocalizationsHelper.of(context).gridViewTooltip,
                      onPressed: () => onViewChanged(true),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: !isGridView
                          ? Colors.deepPurple.shade700
                          : Colors.deepPurple.shade300,
                      borderRadius: BorderRadiusDirectional.only(
                        topEnd: Radius.circular(8.0),
                        bottomEnd: Radius.circular(8.0),
                      ),
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.list,
                        color: Colors.white,
                        size: 20,
                      ),
                      tooltip: AppLocalizationsHelper.of(context).listViewTooltip,
                      onPressed: () => onViewChanged(false),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 12.0),
          // Filter button
          Container(
            height: 40,
            decoration: BoxDecoration(
              color: hasActiveFilters
                  ? (isDark ? colorScheme.primary : colorScheme.primary)
                  : (isDark ? colorScheme.surface : colorScheme.surface),
              border: Border.all(color: isDark ? colorScheme.outline : colorScheme.outlineVariant),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Stack(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.filter_list,
                    color: hasActiveFilters
                        ? colorScheme.onPrimary
                        : (isDark ? colorScheme.onSurface : colorScheme.onSurface),
                    size: 20,
                  ),
                  tooltip: AppLocalizationsHelper.of(context).filtersTooltip,
                  onPressed: onFilterPressed,
                ),
                if (hasActiveFilters)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        shape: BoxShape.circle,
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
}
