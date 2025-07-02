import 'package:flutter/material.dart';

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
    this.hintText = 'Search products...',
    this.onClear,
  });

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.grey[100] ?? Colors.grey.shade100,
        borderRadius: BorderRadius.circular(25.0),
        border: Border.all(color: Colors.grey[300] ?? Colors.grey.shade300),
      ),
      child: TextField(
        controller: widget.controller,
        focusNode: widget.focusNode,
        onChanged: (value) {
          widget.onChanged(value);
          setState(() {}); // Trigger rebuild to show/hide clear button
        },
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: TextStyle(color: Colors.grey[600] ?? Colors.grey.shade600),
          prefixIcon: Icon(
            Icons.search,
            color: Colors.grey[600] ?? Colors.grey.shade600,
          ),
          suffixIcon: widget.controller.text.isNotEmpty
              ? IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: Colors.grey[600] ?? Colors.grey.shade600,
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
