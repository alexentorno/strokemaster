import 'package:flutter/material.dart';
import 'package:stroke_master/base/util/styles/app_styles.dart';

class LoginButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isLoading;
  final ThemeData theme;

  const LoginButton({
    required this.onPressed,
    required this.isLoading,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 50),
        backgroundColor: theme.primaryColor,
      ),
      onPressed: isLoading ? null : onPressed,
      child: Text(
        isLoading ? "Logging in..." : "Login",
        style: AppStyles.mediumTextStyle.copyWith(color: Colors.white),
      ),
    );
  }
}
