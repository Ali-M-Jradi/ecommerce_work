import 'package:flutter/material.dart';

class HighlightedText extends StatelessWidget {
  final String text;
  final String highlight;
  final TextStyle? style;
  final Color highlightColor;
  final TextStyle? highlightStyle;
  final int? maxLines;
  final TextOverflow? overflow;

  const HighlightedText({
    super.key,
    required this.text,
    required this.highlight,
    this.style,
    this.highlightColor = Colors.amber,
    this.highlightStyle,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    if (highlight.isEmpty || highlight.trim().isEmpty) {
      return Text(
        text,
        style: style,
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
          style: style,
        ));
      }
      
      // Add highlighted text
      spans.add(TextSpan(
        text: text.substring(index, index + lowerHighlight.length),
        style: highlightStyle ?? 
          (style?.copyWith(
            backgroundColor: highlightColor,
            fontWeight: FontWeight.bold,
          ) ?? TextStyle(
            backgroundColor: highlightColor,
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
        style: style,
      ));
    }

    return RichText(
      text: TextSpan(children: spans),
      maxLines: maxLines,
      overflow: overflow ?? TextOverflow.ellipsis,
    );
  }
}
