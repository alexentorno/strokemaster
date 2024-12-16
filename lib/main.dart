import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'base/bottom_nav_bar.dart';
import 'base/screens/home/view_all_videos_screen.dart';
import 'base/screens/login/login_screen.dart';
import 'base/util/app_routes.dart';
import 'theme/theme.dart';

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
              AppRoutes.viewAllTodaysTopExercises: (context) => const ViewAllVideosScreen(),
            },
          );
        }
      ),
    );
  }
}

