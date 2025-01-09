import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stroke_master/base/util/styles/app_styles.dart';

class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Register",
          style: AppStyles.appBarTitleStyle.copyWith(color: theme.primaryColor),
        ),
        Row(
          children: [
            Text(
              "Already have an account?",
              style: AppStyles.mediumTextStyle.copyWith(
                color: theme.primaryColorLight,
              ),
            ),
            TextButton(
              onPressed: () => context.push("/login"),
              child: Text(
                "Login",
                style: AppStyles.mediumTextStyle.copyWith(
                  color: theme.highlightColor,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
