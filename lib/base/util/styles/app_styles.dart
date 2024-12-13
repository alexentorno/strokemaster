import 'package:flutter/material.dart';

class AppStyles {

  static const String logoFontFamily = 'Righteous';
  static const String appBarFontFamily = 'SofiaSans';

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
  static Color ticketTop = const Color.fromARGB(255, 240, 191, 85);
  static Color ticketBottom = const Color.fromARGB(255, 227, 124, 96);
  static Color planeColor = const Color.fromRGBO(0, 188, 212, 1);
  static Color findTicketColor = const Color.fromRGBO(156, 39, 176, 0.851);
  static Color circleColor = const Color.fromRGBO(76, 175, 80, 1);
  static Color ticketWhite = const Color.fromRGBO(255, 255, 255, 1);
  static Color alternativeTicketViewColor = const Color.fromARGB(255, 245, 115, 79);
  static Color alternativePlaneColor = const Color.fromARGB(255, 94, 161, 238);
  static Color profileStatusColor = const Color.fromRGBO(254, 244, 243, 1);
  static Color profileStatusColor2 = const Color.fromARGB(255, 82, 86, 153);

  static TextStyle appBarTitleStyle = const TextStyle(
      fontFamily: appBarFontFamily, fontSize: 32, fontWeight: FontWeight.bold);

  static TextStyle logoTitleStyle = const TextStyle(
      fontFamily: logoFontFamily, fontSize: 37);

  static TextStyle linkStyle = TextStyle(
    fontSize: 16, fontWeight: FontWeight.w500, color: AppStyles.textColor);

  static TextStyle headlineStyle1 = TextStyle(
    fontSize: 26, fontWeight: FontWeight.bold);

  static TextStyle headlineStyle2 = TextStyle(
    fontSize: 21, fontWeight: FontWeight.bold, color: AppStyles.textColor);    

  static TextStyle headlineStyle3 = const TextStyle(
    fontSize: 17, fontWeight: FontWeight.w500);

  static TextStyle headlineStyle4 = const TextStyle(
    fontSize: 14, fontWeight: FontWeight.w500);


}