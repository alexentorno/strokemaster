import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stroke_master/base/bottom_nav_bar.dart';
import 'package:stroke_master/base/screens/login/login_screen.dart';
import 'package:stroke_master/state/auth/providers/is_logged_in_provider.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final isLoggedIn = ref.watch(isLoggedInProvider);
      if (isLoggedIn) {
        return BottomNavBar();
      } else {
        return const LoginScreen();
      }
    });
  }
}
