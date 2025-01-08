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
    final screenWidth = MediaQuery.of(context).size.width;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Expanded ensures the title wraps within the available width
        Expanded(
          child: Text(
            title,
            style: AppStyles.mediumTextStyle.copyWith(
              color: theme.primaryColorLight,
              fontSize: screenWidth < 350
                  ? 20 // for very small screens
                  : screenWidth < 450
                  ? 22 // for mid-range screens
                  : 26, // for larger screens
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
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
