import 'package:flutter/material.dart';
import 'package:flutter_demo/base/util/styles/app_styles.dart';

class HeadingText extends StatelessWidget {
  final String text;
  final TextAlign align;
  const HeadingText({super.key, 
                              required this.text, 
                              this.align = TextAlign.start});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Text(
      text, 
      textAlign: align,
      style: AppStyles.headlineStyle1.copyWith(color: theme.primaryColorLight));
  }
}