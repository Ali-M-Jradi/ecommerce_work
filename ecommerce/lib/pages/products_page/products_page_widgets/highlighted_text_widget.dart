import 'package:flutter/material.dart';

class HighlightedText extends StatelessWidget {
  final String text;
  final String highlight;
  final TextStyle? style;
  final Color? highlightColor;
  final TextStyle? highlightStyle;
  final int? maxLines;
  final TextOverflow? overflow;

  const HighlightedText({
    super.key,
    required this.text,
    required this.highlight,
    this.style,
    this.highlightColor,
    this.highlightStyle,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final effectiveHighlightColor = highlightColor ?? (isDark ? colorScheme.primary : colorScheme.primaryContainer);
    final effectiveTextColor = style?.color ?? (isDark ? colorScheme.onSurface : colorScheme.onSurface);
    if (highlight.isEmpty || highlight.trim().isEmpty) {
      return Text(
        text,
        style: style?.copyWith(color: effectiveTextColor) ?? TextStyle(color: effectiveTextColor),
        maxLines: maxLines,
        overflow: overflow,
      );
    }

    final List<TextSpan> spans = [];
    final String lowerText = text.toLowerCase();
    final String lowerHighlight = highlight.trim().toLowerCase();
    
    if (lowerHighlight.isEmpty) {
      return Text(
        text,
        style: style,
        maxLines: maxLines,
        overflow: overflow,
      );
    }
    
    int start = 0;
    int index = lowerText.indexOf(lowerHighlight);
    
    while (index != -1) {
      // Add text before highlight
      if (index > start) {
        spans.add(TextSpan(
          text: text.substring(start, index),
          style: style?.copyWith(color: effectiveTextColor) ?? TextStyle(color: effectiveTextColor),
        ));
      }
      
      // Add highlighted text
      spans.add(TextSpan(
        text: text.substring(index, index + lowerHighlight.length),
        style: highlightStyle ?? 
          (style?.copyWith(
            backgroundColor: effectiveHighlightColor,
            color: colorScheme.onPrimary,
            fontWeight: FontWeight.bold,
          ) ?? TextStyle(
            backgroundColor: effectiveHighlightColor,
            color: colorScheme.onPrimary,
            fontWeight: FontWeight.bold,
          )),
      ));
      
      start = index + lowerHighlight.length;
      index = lowerText.indexOf(lowerHighlight, start);
    }
    
    // Add remaining text
    if (start < text.length) {
      spans.add(TextSpan(
        text: text.substring(start),
        style: style?.copyWith(color: effectiveTextColor) ?? TextStyle(color: effectiveTextColor),
      ));
    }

    return RichText(
      text: TextSpan(children: spans),
      maxLines: maxLines,
      overflow: overflow ?? TextOverflow.ellipsis,
    );
  }
}
