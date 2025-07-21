import 'package:flutter/material.dart';
import '../../../localization/app_localizations_helper.dart';

class SearchBarWidget extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final String hintText;
  final Function(String) onChanged;
  final VoidCallback? onClear;

  const SearchBarWidget({
    super.key,
    required this.controller,
    this.focusNode,
    required this.onChanged,
    this.hintText = '',
    this.onClear,
  });

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: isDark ? colorScheme.surface : colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(25.0),
        border: Border.all(color: isDark ? colorScheme.outline : colorScheme.secondary),
      ),
      child: TextField(
        controller: widget.controller,
        focusNode: widget.focusNode,
        onChanged: (value) {
          widget.onChanged(value);
          setState(() {}); // Trigger rebuild to show/hide clear button
        },
        decoration: InputDecoration(
          hintText: widget.hintText.isEmpty 
              ? AppLocalizationsHelper.of(context).searchProductsHint 
              : widget.hintText,
          hintStyle: TextStyle(color: colorScheme.onSurface.withOpacity(0.6)),
          prefixIcon: Icon(
            Icons.search,
            color: colorScheme.onSurface.withOpacity(0.7),
          ),
          suffixIcon: widget.controller.text.isNotEmpty
              ? IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: colorScheme.onSurface.withOpacity(0.7),
                  ),
                  onPressed: () {
                    widget.controller.clear();
                    widget.onClear?.call();
                    setState(() {}); // Trigger rebuild to hide clear button
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20.0,
            vertical: 15.0,
          ),
        ),
      ),
    );
  }
}
