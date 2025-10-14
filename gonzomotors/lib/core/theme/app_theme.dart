import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppTheme {
  // Material light
  static ThemeData light = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6750A4)),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: const Color(0xFF6750A4),
      unselectedItemColor: Colors.grey.shade500,
      selectedIconTheme: const IconThemeData(size: 24, color: Color(0xFF6750A4)),
      unselectedIconTheme: IconThemeData(size: 24, color: Colors.grey.shade500),
      showSelectedLabels: true,
      showUnselectedLabels: true,
      selectedLabelStyle: const TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 12,
        color: Color(0xFF6750A4),
      ),
      unselectedLabelStyle: TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 12,
        color: Colors.grey.shade500,
      ),
    ),
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
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: const Color(0xFF121212),
      selectedItemColor: const Color(0xFFD0BCFF),
      unselectedItemColor: Colors.grey.shade600,
      selectedIconTheme: const IconThemeData(size: 24, color: Color(0xFFD0BCFF)),
      unselectedIconTheme: IconThemeData(size: 24, color: Colors.grey.shade600),
      showSelectedLabels: true,
      showUnselectedLabels: true,
      selectedLabelStyle: const TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 12,
        color: Color(0xFFD0BCFF),
      ),
      unselectedLabelStyle: TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 12,
        color: Colors.grey.shade600,
      ),
    ),
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
