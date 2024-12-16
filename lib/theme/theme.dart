import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/base/util/styles/app_styles.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ThemeProvider extends ChangeNotifier {
  bool _isDark = false;
  bool get isDark => _isDark;

  //Use shared_preferences to save last changed theme value
  late SharedPreferences storage;

// Custom dark theme
  final darkTheme = ThemeData(
    disabledColor:const Color.fromARGB(55, 189, 189, 189),
    hintColor: AppStyles.textColorDark,
    highlightColor: AppStyles.linkColorDark,
    primaryColorLight: AppStyles.textColorDark, // Bottom navbar icon selected
    canvasColor: AppStyles.bottomNavBarColorDark, // Bottom navbar background color
    appBarTheme: AppBarTheme(color: AppStyles.bgColorDark),
    scaffoldBackgroundColor: AppStyles.bgColorDark,
    primaryColor: AppStyles.primaryColorDark, //Color for logo
    brightness: Brightness.dark,

  );
// Custom light theme
  final lightTheme = ThemeData(
    disabledColor:const Color.fromARGB(55, 23, 23, 23),
    hintColor: AppStyles.textColor,
    highlightColor: AppStyles.linkColor,
    primaryColorLight: AppStyles.textColor,
    canvasColor: AppStyles.bottomNavBarColor, // Bottom navbar background color
    appBarTheme: AppBarTheme(color: AppStyles.bgColor),
    scaffoldBackgroundColor: AppStyles.bgColor,
    primaryColor: AppStyles.primaryColor, //Color for logo
    brightness: Brightness.light,

  );

  //Mode toggle action
  changeTheme() {
    _isDark = !_isDark;

    // Save the value to storage
    storage.setBool("isDark", _isDark);
    _updateSystemUI();
    notifyListeners();
  }
// Init method of provider
  init() async {
    storage = await SharedPreferences.getInstance();
    _isDark = storage.getBool("isDark")??false;
    notifyListeners();
  }

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
