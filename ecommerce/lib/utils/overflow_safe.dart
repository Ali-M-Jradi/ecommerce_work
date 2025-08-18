import 'package:flutter/material.dart';

/// A widget wrapper that automatically handles overflow prevention for common Flutter widgets
class OverflowSafe extends StatelessWidget {
  final Widget child;
  final bool enableScrolling;
  final EdgeInsets padding;
  final ScrollPhysics? physics;

  const OverflowSafe({
    super.key,
    required this.child,
    this.enableScrolling = false,
    this.padding = const EdgeInsets.all(8.0),
    this.physics,
  });

  @override
  Widget build(BuildContext context) {
    Widget safeChild = _wrapChildForOverflowPrevention(child);

    if (enableScrolling) {
      return SingleChildScrollView(
        padding: padding,
        physics: physics ?? const ClampingScrollPhysics(),
        child: safeChild,
      );
    }

    return Padding(
      padding: padding,
      child: safeChild,
    );
  }

  Widget _wrapChildForOverflowPrevention(Widget widget) {
    if (widget is Column) {
      return _wrapColumn(widget);
    } else if (widget is Row) {
      return _wrapRow(widget);
    } else if (widget is Text) {
      return _wrapText(widget);
    } else if (widget is ListTile) {
      return _wrapListTile(widget);
    }
    return widget;
  }

  Widget _wrapColumn(Column column) {
    return Column(
      mainAxisAlignment: column.mainAxisAlignment,
      crossAxisAlignment: column.crossAxisAlignment,
      mainAxisSize: MainAxisSize.min, // Prevent overflow
      textDirection: column.textDirection,
      verticalDirection: column.verticalDirection,
      textBaseline: column.textBaseline,
      children: column.children.map(_wrapChildForOverflowPrevention).toList(),
    );
  }

  Widget _wrapRow(Row row) {
    return Row(
      mainAxisAlignment: row.mainAxisAlignment,
      crossAxisAlignment: row.crossAxisAlignment,
      mainAxisSize: MainAxisSize.min, // Prevent overflow
      textDirection: row.textDirection,
      verticalDirection: row.verticalDirection,
      textBaseline: row.textBaseline,
      children: row.children.map((child) {
        if (child is Text) {
          return Flexible(child: _wrapText(child));
        }
        return _wrapChildForOverflowPrevention(child);
      }).toList(),
    );
  }

  Widget _wrapText(Text text) {
    return Text(
      text.data ?? '',
      style: text.style,
      strutStyle: text.strutStyle,
      textAlign: text.textAlign,
      textDirection: text.textDirection,
      locale: text.locale,
      softWrap: text.softWrap ?? true,
      overflow: text.overflow ?? TextOverflow.ellipsis,
      textScaleFactor: text.textScaleFactor,
      maxLines: text.maxLines ?? 3, // Default max lines to prevent overflow
      semanticsLabel: text.semanticsLabel,
      textWidthBasis: text.textWidthBasis,
      textHeightBehavior: text.textHeightBehavior,
    );
  }

  Widget _wrapListTile(ListTile listTile) {
    return ListTile(
      leading: listTile.leading,
      title: listTile.title is Text 
          ? _wrapText(listTile.title as Text)
          : listTile.title,
      subtitle: listTile.subtitle is Text 
          ? _wrapText(listTile.subtitle as Text)
          : listTile.subtitle,
      trailing: listTile.trailing,
      isThreeLine: listTile.isThreeLine,
      dense: listTile.dense,
      visualDensity: listTile.visualDensity,
      shape: listTile.shape,
      selectedColor: listTile.selectedColor,
      iconColor: listTile.iconColor,
      textColor: listTile.textColor,
      contentPadding: listTile.contentPadding,
      enabled: listTile.enabled,
      onTap: listTile.onTap,
      onLongPress: listTile.onLongPress,
      mouseCursor: listTile.mouseCursor,
      selected: listTile.selected,
      focusColor: listTile.focusColor,
      hoverColor: listTile.hoverColor,
      splashColor: listTile.splashColor,
      tileColor: listTile.tileColor,
      selectedTileColor: listTile.selectedTileColor,
      enableFeedback: listTile.enableFeedback,
      horizontalTitleGap: listTile.horizontalTitleGap,
      minVerticalPadding: listTile.minVerticalPadding,
      minLeadingWidth: listTile.minLeadingWidth,
    );
  }
}

/// Extension to add overflow safety to any widget
extension OverflowSafeExtension on Widget {
  Widget overflowSafe({
    bool enableScrolling = false,
    EdgeInsets padding = const EdgeInsets.all(8.0),
    ScrollPhysics? physics,
  }) {
    return OverflowSafe(
      enableScrolling: enableScrolling,
      padding: padding,
      physics: physics,
      child: this,
    );
  }
}

/// A safe text widget that always prevents overflow
class SafeText extends StatelessWidget {
  final String data;
  final TextStyle? style;
  final int? maxLines;
  final TextOverflow overflow;
  final TextAlign? textAlign;
  final double? maxWidth;

  const SafeText(
    this.data, {
    super.key,
    this.style,
    this.maxLines = 1,
    this.overflow = TextOverflow.ellipsis,
    this.textAlign,
    this.maxWidth,
  });

  @override
  Widget build(BuildContext context) {
    Widget textWidget = Text(
      data,
      style: style,
      maxLines: maxLines,
      overflow: overflow,
      textAlign: textAlign,
    );

    if (maxWidth != null) {
      return ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth!),
        child: textWidget,
      );
    }

    return textWidget;
  }
}

/// A safe row that automatically wraps its children with Flexible
class SafeRow extends StatelessWidget {
  final List<Widget> children;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisSize mainAxisSize;

  const SafeRow({
    super.key,
    required this.children,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisSize = MainAxisSize.min,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: mainAxisSize,
      children: children.map((child) {
        if (child is Text) {
          return Flexible(child: child);
        } else if (child is Icon || child is IconButton) {
          return child; // Don't wrap icons
        }
        return Flexible(child: child);
      }).toList(),
    );
  }
}

/// A safe column that automatically handles overflow
class SafeColumn extends StatelessWidget {
  final List<Widget> children;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisSize mainAxisSize;

  const SafeColumn({
    super.key,
    required this.children,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.mainAxisSize = MainAxisSize.min,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: mainAxisSize,
      children: children,
    );
  }
}
