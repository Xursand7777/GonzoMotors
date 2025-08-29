import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppTheme {
  // Material light
  static ThemeData light = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6750A4)),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );

  // Material dark
  static ThemeData dark = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF6750A4),
      brightness: Brightness.dark,
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );

  // Получаем CupertinoTheme из текущего Material Theme (палитра + шрифты)
  static CupertinoThemeData cupertinoFrom(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return CupertinoThemeData(
      // primaryColor влияет на навбар, свичи, активные элементы
      primaryColor: cs.primary,
      scaffoldBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
      barBackgroundColor: cs.surface,
      textTheme: CupertinoTextThemeData(
        textStyle: textTheme.bodyMedium,
        navTitleTextStyle: textTheme.titleLarge,
        navLargeTitleTextStyle: textTheme.headlineSmall,
        actionTextStyle: textTheme.labelLarge,
      ),
    );
  }
}
