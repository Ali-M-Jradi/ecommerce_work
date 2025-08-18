import 'package:flutter/material.dart';

/// A utility class to prevent overflow issues in Flutter layouts
class OverflowPrevention {
  
  /// Wraps a widget in a SafeArea with SingleChildScrollView to prevent overflow
  static Widget scrollableContent({
    required Widget child,
    EdgeInsets padding = const EdgeInsets.all(16.0),
    ScrollPhysics? physics,
    Axis scrollDirection = Axis.vertical,
  }) {
    return SafeArea(
      child: SingleChildScrollView(
        scrollDirection: scrollDirection,
        physics: physics ?? const ClampingScrollPhysics(),
        padding: padding,
        child: child,
      ),
    );
  }

  /// Creates a constrained text widget that prevents overflow
  static Widget constrainedText(
    String text, {
    TextStyle? style,
    int? maxLines = 1,
    TextOverflow overflow = TextOverflow.ellipsis,
    double? maxWidth,
    TextAlign? textAlign,
  }) {
    Widget textWidget = Text(
      text,
      style: style,
      maxLines: maxLines,
      overflow: overflow,
      textAlign: textAlign,
    );

    if (maxWidth != null) {
      return ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: textWidget,
      );
    }

    return textWidget;
  }

  /// Creates a flexible row with overflow prevention
  static Widget flexibleRow({
    required List<Widget> children,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    MainAxisSize mainAxisSize = MainAxisSize.min,
  }) {
    return Row(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: mainAxisSize,
      children: children.map((child) {
        if (child is Text) {
          return Flexible(child: child);
        }
        return child;
      }).toList(),
    );
  }

  /// Creates a flexible column with overflow prevention
  static Widget flexibleColumn({
    required List<Widget> children,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.start,
    MainAxisSize mainAxisSize = MainAxisSize.min,
  }) {
    return Column(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: mainAxisSize,
      children: children,
    );
  }

  /// Creates a data table with horizontal scrolling and proper constraints
  static Widget responsiveDataTable({
    required List<DataColumn> columns,
    required List<DataRow> rows,
    double? minWidth,
  }) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: minWidth ?? 800.0, // Minimum width for table
        ),
        child: DataTable(
          columnSpacing: 16,
          headingRowHeight: 48,
          dataRowMinHeight: 56,
          dataRowMaxHeight: 72,
          columns: columns,
          rows: rows,
        ),
      ),
    );
  }

  /// Creates a form field with proper overflow handling
  static Widget responsiveFormField({
    required Widget child,
    String? label,
    String? hint,
    bool isRequired = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              isRequired ? '$label *' : label,
              style: const TextStyle(fontWeight: FontWeight.w500),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        child,
        if (hint != null)
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              hint,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
      ],
    );
  }

  /// Creates a card with proper content constraints
  static Widget constrainedCard({
    required Widget child,
    EdgeInsets margin = const EdgeInsets.all(8.0),
    EdgeInsets padding = const EdgeInsets.all(16.0),
    double? maxWidth,
    double? maxHeight,
  }) {
    Widget cardChild = Card(
      margin: margin,
      child: Padding(
        padding: padding,
        child: child,
      ),
    );

    if (maxWidth != null || maxHeight != null) {
      return ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: maxWidth ?? double.infinity,
          maxHeight: maxHeight ?? double.infinity,
        ),
        child: cardChild,
      );
    }

    return cardChild;
  }

  /// Creates a list item with overflow protection
  static Widget constrainedListTile({
    Widget? leading,
    required Widget title,
    Widget? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
    double? maxWidth,
  }) {
    Widget listTile = ListTile(
      leading: leading,
      title: title,
      subtitle: subtitle,
      trailing: trailing,
      onTap: onTap,
    );

    if (maxWidth != null) {
      return ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: listTile,
      );
    }

    return listTile;
  }

  /// Creates a wrap widget with proper spacing and overflow handling
  static Widget responsiveWrap({
    required List<Widget> children,
    double spacing = 8.0,
    double runSpacing = 8.0,
    Axis direction = Axis.horizontal,
    WrapAlignment alignment = WrapAlignment.start,
  }) {
    return Wrap(
      direction: direction,
      alignment: alignment,
      spacing: spacing,
      runSpacing: runSpacing,
      children: children,
    );
  }

  /// Creates a grid view with responsive columns
  static Widget responsiveGridView({
    required List<Widget> children,
    double crossAxisSpacing = 8.0,
    double mainAxisSpacing = 8.0,
    double childAspectRatio = 1.0,
    int? fixedCrossAxisCount,
    double? maxCrossAxisExtent,
    EdgeInsets padding = const EdgeInsets.all(8.0),
  }) {
    if (fixedCrossAxisCount != null) {
      return GridView.count(
        padding: padding,
        crossAxisCount: fixedCrossAxisCount,
        crossAxisSpacing: crossAxisSpacing,
        mainAxisSpacing: mainAxisSpacing,
        childAspectRatio: childAspectRatio,
        children: children,
      );
    } else {
      return GridView.extent(
        padding: padding,
        maxCrossAxisExtent: maxCrossAxisExtent ?? 200.0,
        crossAxisSpacing: crossAxisSpacing,
        mainAxisSpacing: mainAxisSpacing,
        childAspectRatio: childAspectRatio,
        children: children,
      );
    }
  }
}
