import 'package:flutter/material.dart';
import '/base/util/styles/app_styles.dart';

class TitleAndLinkWidget extends StatelessWidget {

  final String title;
  final String details;
  final VoidCallback func;

  const TitleAndLinkWidget({super.key,
                      required this.title, 
                      required this.details,
                      required this.func});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppStyles.headlineStyle2.copyWith(color: theme.primaryColorLight)),
        InkWell(
          onTap: func,
          child: Text(details, style: AppStyles.linkStyle.copyWith(color: theme.highlightColor)),
        )
      ],
    );
  }
}