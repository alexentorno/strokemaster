import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stroke_master/base/screens/log/view_all_favorite_videos_screen.dart';
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
      path: '/view_all_favorite_exercises',
      builder: (BuildContext context, GoRouterState state) {
        return const ViewAllFavoriteVideosScreen();
      },
    ),
  ],
);
