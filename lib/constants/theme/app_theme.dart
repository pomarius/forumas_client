import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData appTheme = ThemeData(
    useMaterial3: true,
    colorScheme: AppColors.colorScheme,
    scaffoldBackgroundColor: AppColors.colorScheme.background,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.colorScheme.surface,
      foregroundColor: AppColors.colorScheme.onSurface,
      elevation: 0,
      scrolledUnderElevation: 0,
    ),
  );
}
