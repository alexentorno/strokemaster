import 'package:flutter/material.dart';

import '../util/styles/app_styles.dart';

class ShowLogo extends StatelessWidget {
  const ShowLogo({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Text("StrokeMaster",
        style: AppStyles.logoTitleStyle.copyWith(color: theme.primaryColor),),
    );
  }
}
