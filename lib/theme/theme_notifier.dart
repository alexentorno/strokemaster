import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/base/util/styles/app_styles.dart';

class ThemeNotifier extends ChangeNotifier {
  bool _isDark = false;
  bool get isDark => _isDark;

  // Use shared_preferences to save the last changed theme value
  late SharedPreferences _storage;

  // Custom dark theme
  ThemeData get darkTheme => ThemeData(
    cardColor: AppStyles.appBarColor,
    disabledColor: const Color.fromARGB(55, 189, 189, 189),
    hintColor: AppStyles.textColorDark,
    highlightColor: AppStyles.linkColorDark,
    primaryColorLight: AppStyles.textColorDark, // Bottom navbar icon selected
    canvasColor: AppStyles.bottomNavBarColorDark, // Bottom navbar background color
    appBarTheme: AppBarTheme(color: AppStyles.bgColorDark),
    scaffoldBackgroundColor: AppStyles.bgColorDark,
    primaryColor: AppStyles.primaryColorDark, // Color for logo
    brightness: Brightness.dark,
  );

  // Custom light theme
  ThemeData get lightTheme => ThemeData(
    cardColor: Colors.grey[200],
    disabledColor: const Color.fromARGB(55, 23, 23, 23),
    hintColor: AppStyles.textColor,
    highlightColor: AppStyles.linkColor,
    primaryColorLight: AppStyles.textColor,
    canvasColor: AppStyles.bottomNavBarColor, // Bottom navbar background color
    appBarTheme: AppBarTheme(color: AppStyles.bgColor),
    scaffoldBackgroundColor: AppStyles.bgColor,
    primaryColor: AppStyles.primaryColor, // Color for logo
    brightness: Brightness.light,
  );

  // Toggle theme and save the value to storage
  void toggleTheme() {
    _isDark = !_isDark;

    // Save the value to storage
    _storage.setBool("isDark", _isDark);
    _updateSystemUI();
    notifyListeners();
  }

  // Initialize the provider with saved theme preference
  Future<void> init() async {
    _storage = await SharedPreferences.getInstance();
    _isDark = _storage.getBool("isDark") ?? false;
    _updateSystemUI();
    notifyListeners();
  }

  // Update system UI overlay style based on theme
  void _updateSystemUI() {
    SystemChrome.setSystemUIOverlayStyle(
      _isDark
          ? const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // Transparent for better blending
        statusBarIconBrightness: Brightness.light, // Icons for dark theme
        statusBarBrightness: Brightness.dark, // iOS compatibility
      )
          : const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark, // Icons for light theme
        statusBarBrightness: Brightness.light, // iOS compatibility
      ),
    );
  }
}
