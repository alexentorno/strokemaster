/*class AppRoutes{

  static const loginPage = "/login";

  static const registerPage = "/register";

  static const homePage = "/home";

  static const SearchPage = "/search";

  static const viewAllTodaysTopExercises = "/todays_top_view_all";

  static const progressLogPage = "/progress_log";

  static const profilePage = "/profile";

}
*/
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stroke_master/base/screens/home/view_all_videos_screen.dart';
import 'package:stroke_master/base/screens/login/login_screen.dart';
import 'package:stroke_master/base/screens/register/register_screen.dart';
import 'package:stroke_master/base/screens/start_screen.dart';


final GoRouter router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const StartScreen();
      },
    ),
    GoRoute(
      path: '/login',
      builder: (BuildContext context, GoRouterState state) {
        return const LoginScreen();
      },
    ),
    GoRoute(
      path: '/register',
      builder: (BuildContext context, GoRouterState state) {
        return const RegisterScreen();
      },
    ),
    GoRoute(
      path: '/view_todays_top_exercises',
      builder: (BuildContext context, GoRouterState state) {
        return const ViewAllVideosScreen();
      },
    ),
  ],
);
