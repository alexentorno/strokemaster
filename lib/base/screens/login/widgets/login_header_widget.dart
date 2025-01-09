import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stroke_master/base/util/styles/app_styles.dart';

class LoginHeader extends StatelessWidget {
  final ThemeData theme;

  const LoginHeader({super.key, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Login",
          style: AppStyles.appBarTitleStyle.copyWith(color: theme.primaryColor),
        ),
        Row(
          children: [
            Text(
              "Don't have an account?",
              style: AppStyles.mediumTextStyle.copyWith(color: theme.primaryColorLight),
            ),
            TextButton(
              onPressed: () => context.push("/register"),
              child: Text(
                "Register",
                style: AppStyles.mediumTextStyle.copyWith(color: theme.highlightColor),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
