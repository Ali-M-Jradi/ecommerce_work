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
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      color: Colors.white,
      child: Row(
        children: [
          // Sort by dropdown
          Expanded(
            flex: 3,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.deepPurple.shade300),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: sortBy,
                  icon: Icon(
                    Icons.arrow_drop_down,
                    color: Colors.deepPurple.shade700,
                  ),
                  style: TextStyle(
                    color: Colors.deepPurple.shade700,
                    fontSize: 14,
                  ),
                  items: [
                    DropdownMenuItem(
                      value: 'A to Z',
                      child: Text(AppLocalizationsHelper.of(context).sortAtoZ),
                    ),
                    DropdownMenuItem(
                      value: 'Z to A',
                      child: Text(AppLocalizationsHelper.of(context).sortZtoA),
                    ),
                    DropdownMenuItem(
                      value: 'Price Low',
                      child: Text(AppLocalizationsHelper.of(context).sortPriceLow),
                    ),
                    DropdownMenuItem(
                      value: 'Price High',
                      child: Text(AppLocalizationsHelper.of(context).sortPriceHigh),
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
                          ? Colors.deepPurple.shade700
                          : Colors.deepPurple.shade300,
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
              color: hasActiveFilters ? Colors.deepPurple.shade700 : Colors.white,
              border: Border.all(color: Colors.deepPurple.shade300),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Stack(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.filter_list,
                    color: hasActiveFilters ? Colors.white : Colors.deepPurple.shade700,
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
