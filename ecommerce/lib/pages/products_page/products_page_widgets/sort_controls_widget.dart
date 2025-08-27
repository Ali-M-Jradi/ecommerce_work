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
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      color: isDark ? colorScheme.surface : colorScheme.surface,
      child: Row(
        children: [
          // Sort by dropdown
            Expanded(
              flex: 3,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(color: colorScheme.primary.withOpacity(0.18)),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: sortBy,
                    isExpanded: true,
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color: colorScheme.onPrimary,
                    ),
                    style: TextStyle(
                      color: colorScheme.onPrimary,
                      fontSize: 14,
                    ),
                    dropdownColor: colorScheme.surface,
                    // Ensure the displayed selected item (button label) uses onPrimary color and is left-aligned
                    selectedItemBuilder: (context) => [
                      Align(alignment: Alignment.centerLeft, child: Padding(padding: const EdgeInsets.only(left: 4.0), child: Text(AppLocalizationsHelper.of(context).sortAtoZ, style: TextStyle(color: colorScheme.onPrimary)))),
                      Align(alignment: Alignment.centerLeft, child: Padding(padding: const EdgeInsets.only(left: 4.0), child: Text(AppLocalizationsHelper.of(context).sortZtoA, style: TextStyle(color: colorScheme.onPrimary)))),
                      Align(alignment: Alignment.centerLeft, child: Padding(padding: const EdgeInsets.only(left: 4.0), child: Text(AppLocalizationsHelper.of(context).sortPriceLow, style: TextStyle(color: colorScheme.onPrimary)))),
                      Align(alignment: Alignment.centerLeft, child: Padding(padding: const EdgeInsets.only(left: 4.0), child: Text(AppLocalizationsHelper.of(context).sortPriceHigh, style: TextStyle(color: colorScheme.onPrimary)))),
                    ],
                    items: [
                      DropdownMenuItem(
                        value: 'A to Z',
                        child: Text(
                          AppLocalizationsHelper.of(context).sortAtoZ,
                          style: TextStyle(color: colorScheme.onSurface),
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'Z to A',
                        child: Text(
                          AppLocalizationsHelper.of(context).sortZtoA,
                          style: TextStyle(color: colorScheme.onSurface),
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'Price Low',
                        child: Text(
                          AppLocalizationsHelper.of(context).sortPriceLow,
                          style: TextStyle(color: colorScheme.onSurface),
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'Price High',
                        child: Text(
                          AppLocalizationsHelper.of(context).sortPriceHigh,
                          style: TextStyle(color: colorScheme.onSurface),
                        ),
                      ),
                    ],
                    onChanged: onSortChanged,
                  ),
                ),
              ),
            ),
          const SizedBox(width: 12.0),
          // View toggle buttons
            Expanded(
              flex: 2,
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(color: colorScheme.outline),
                  color: colorScheme.primaryContainer,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 220),
                        height: 40,
                        decoration: BoxDecoration(
                          color: isGridView ? colorScheme.primary : colorScheme.surfaceVariant,
                          borderRadius: const BorderRadiusDirectional.only(
                            topStart: Radius.circular(8.0),
                            bottomStart: Radius.circular(8.0),
                          ),
                        ),
                        child: IconButton(
                          icon: Icon(
                            Icons.grid_view,
                            color: isGridView ? colorScheme.onPrimary : colorScheme.onSurface,
                            size: 20,
                          ),
                          tooltip: AppLocalizationsHelper.of(context).gridViewTooltip,
                          onPressed: () => onViewChanged(true),
                        ),
                      ),
                    ),
                    Expanded(
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 220),
                        height: 40,
                        decoration: BoxDecoration(
                          color: !isGridView ? colorScheme.primary : colorScheme.surfaceVariant,
                          borderRadius: const BorderRadiusDirectional.only(
                            topEnd: Radius.circular(8.0),
                            bottomEnd: Radius.circular(8.0),
                          ),
                        ),
                        child: IconButton(
                          icon: Icon(
                            Icons.list,
                            color: !isGridView ? colorScheme.onPrimary : colorScheme.onSurface,
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
              ),
            const SizedBox(width: 12.0),
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
                      decoration: const BoxDecoration(
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
