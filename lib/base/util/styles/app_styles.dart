import 'package:flutter/material.dart';

@immutable
class AppStyles {

  static const String logoFontFamily = 'Righteous';
  static const String appBarFontFamily = 'SofiaSansBold';

  static Color linkColor = const Color.fromARGB(255, 88, 139, 234);
  static Color linkColorDark = const Color.fromARGB(255, 90, 198, 189);
  static Color bottomNavBarColor = const Color.fromARGB(255, 232, 232, 232);
  static Color bottomNavBarColorDark = const Color.fromARGB(255, 18, 21, 32);
  static Color appBarColor = const Color.fromARGB(255, 159, 181, 220);
  static Color appBarColorDark = const Color.fromARGB(255, 35, 67, 117);
  static Color bgColor = const Color.fromARGB(255, 255, 255, 255);
  static Color bgColorDark = const Color.fromARGB(255, 39, 44, 57);
  static Color primaryColor = const Color.fromARGB(255, 45, 70, 199);
  static Color primaryColorDark = const Color.fromARGB(255, 101, 186, 229);
  static Color textColor = const Color.fromARGB(255, 0, 0, 0);
  static Color textColorDark = const Color.fromARGB(255, 209, 230, 241);

  static TextStyle mediumTextStyle = const TextStyle(
      fontFamily: appBarFontFamily, fontSize: 18, fontWeight: FontWeight.bold);

  static TextStyle appBarTitleStyle = const TextStyle(
      fontFamily: appBarFontFamily, fontSize: 32, fontWeight: FontWeight.bold);

  static TextStyle logoTitleStyle = const TextStyle(
      fontFamily: logoFontFamily, fontSize: 37);

  static TextStyle linkStyle = TextStyle(
    fontSize: 16, fontWeight: FontWeight.w500, color: AppStyles.textColor);

  static TextStyle headlineStyle1 = TextStyle(
    fontSize: 26, fontWeight: FontWeight.bold);

  static TextStyle headlineStyle2 = TextStyle(
    fontSize: 21, fontWeight: FontWeight.bold);

  static TextStyle headlineStyle3 = const TextStyle(
    fontSize: 17, fontWeight: FontWeight.w500);

  static TextStyle headlineStyle4 = const TextStyle(
    fontSize: 14, fontWeight: FontWeight.w500);


}