import 'package:flutter/material.dart';
import 'package:flutter_demo/base/bottom_nav_bar.dart';
import 'package:flutter_demo/base/screens/login/login_screen.dart';
import 'package:flutter_demo/base/util/app_routes.dart';
import 'package:flutter_demo/theme/theme.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider(
      create: (BuildContext context) => ThemeProvider()..init(),
      child: Consumer<ThemeProvider>(
        builder: (context, ThemeProvider notifier, child) {
          return GetMaterialApp(
            title: "StrokeMaster",
            themeMode: notifier.isDark? ThemeMode.dark : ThemeMode.light,
            darkTheme: notifier.darkTheme,
            theme: notifier.lightTheme,
            debugShowCheckedModeBanner: false,
            routes: {
              AppRoutes.homePage: (context) => BottomNavBar(),
              AppRoutes.loginPage: (context) => LoginScreen(),
              // AppRoutes.allVideos: (context) => const ViewAllVideosScreen(),
              // AppRoutes.ticketScreen: (context) => const TicketScreen(),
              // AppRoutes.hotelDetail: (context) => const HotelScreen(),
            },
          );
        }
      ),
    );
  }
}

