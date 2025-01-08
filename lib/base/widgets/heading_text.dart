import 'package:flutter/material.dart';
import '/base/util/styles/app_styles.dart';

class HeadingText extends StatelessWidget {
  final String text;
  final TextAlign align;

  const HeadingText({
    super.key,
    required this.text,
    this.align = TextAlign.start,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;

    return Text(
      text,
      textAlign: align,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: AppStyles.headlineStyle1.copyWith(
        color: theme.primaryColorLight,
        fontSize: screenWidth < 350
            ? 18
            : 22,
      ),
    );
  }
}
