import 'package:flutter/material.dart';

class MiscUtils {
  const MiscUtils._();

  static Size getTextSize(Text text, [double? width]) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text.data, style: text.style),
      textDirection: TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: width ?? double.infinity);
    return textPainter.size;
  }

  static double getPercent(double current, double max, [double min = 0]) {
    return ((max - current) / (max - min)).clamp(0, 1);
  }
}
