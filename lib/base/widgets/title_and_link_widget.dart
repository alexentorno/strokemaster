import 'package:flutter/material.dart';
import '/base/util/styles/app_styles.dart';

class TitleAndLinkWidget extends StatelessWidget {
  final String title;
  final String details;
  final VoidCallback? func;

  const TitleAndLinkWidget({
    super.key,
    required this.title,
    this.details = "",
    this.func,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppStyles.mediumTextStyle.copyWith(
            color: theme.primaryColorLight,
            fontSize: 26,
          ),
        ),
        if (details.isNotEmpty)
          InkWell(
            onTap: func ?? () {},
            child: Text(
              details,
              style: AppStyles.linkStyle.copyWith(
                color: theme.highlightColor,
              ),
            ),
          ),
      ],
    );
  }
}
