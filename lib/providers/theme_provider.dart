// added this controller so the whole app can flip between light/dark without pulling in a
// state-management package, for the dark mode enhancement
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';

class ThemeProvider {
  static const String _kDarkModeKey = 'is_dark_mode';

  // a ValueNotifier is enough here - MaterialApp listens to it directly and rebuilds on change
  static final ValueNotifier<ThemeMode> themeMode = ValueNotifier(
    ThemeMode.light,
  );

  static bool get isDarkMode => themeMode.value == ThemeMode.dark;

  // reads the saved preference on app startup so dark mode survives a restart
  static Future<void> loadSavedTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool(_kDarkModeKey) ?? false;
    themeMode.value = isDark ? ThemeMode.dark : ThemeMode.light;
  }

  // flips + persists the preference; wired to the Dark Mode switch on SettingsScreen
  static Future<void> setDarkMode(bool isDark) async {
    themeMode.value = isDark ? ThemeMode.dark : ThemeMode.light;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kDarkModeKey, isDark);
  }

  // light theme keeps today's look: white app bars, FB_PRIMARY-tinted icons/titles
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white,
    primaryColor: FB_PRIMARY,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 2,
      iconTheme: IconThemeData(color: FB_PRIMARY),
    ),
    colorScheme: ColorScheme.fromSeed(
      seedColor: FB_PRIMARY,
      brightness: Brightness.light,
    ),
  );

  // dark theme swaps backgrounds to near-black and brightens accents so FB_PRIMARY still reads well
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF121212),
    primaryColor: FB_LIGHT_PRIMARY,
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1E1E1E),
      foregroundColor: Colors.white,
      elevation: 2,
      iconTheme: IconThemeData(color: FB_LIGHT_PRIMARY),
    ),
    colorScheme: ColorScheme.fromSeed(
      seedColor: FB_PRIMARY,
      brightness: Brightness.dark,
    ),
    cardColor: const Color(0xFF1E1E1E),
  );
}
