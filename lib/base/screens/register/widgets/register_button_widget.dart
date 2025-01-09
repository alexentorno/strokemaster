import 'package:flutter/material.dart';
import 'package:stroke_master/base/util/styles/app_styles.dart';

class RegisterButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPressed;

  const RegisterButton({
    required this.isLoading,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 50),
        backgroundColor: theme.primaryColor,
      ),
      onPressed: isLoading ? null : onPressed,
      child: Text(
        "Register",
        style: AppStyles.mediumTextStyle.copyWith(color: Colors.white),
      ),
    );
  }
}