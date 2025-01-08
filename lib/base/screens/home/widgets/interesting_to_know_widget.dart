import 'package:flutter/material.dart';
import 'package:stroke_master/base/util/styles/app_styles.dart';

class InterestingToKnowWidget extends StatelessWidget {
  final String phrase;

  const InterestingToKnowWidget({
    super.key,
    required this.phrase,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFB2DFFC),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        '"$phrase"',
        style: AppStyles.mediumTextStyle.copyWith(
          fontSize: 16,
          color: Colors.black,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }
}
