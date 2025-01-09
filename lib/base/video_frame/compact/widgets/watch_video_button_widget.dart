import 'package:flutter/material.dart';
import 'package:stroke_master/base/util/styles/app_styles.dart';

class WatchVideoButton extends StatelessWidget {
  final VoidCallback onPressed;

  const WatchVideoButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: const Icon(
        Icons.play_circle,
        size: 30,
        color: Colors.green,
      ),
      label: Text(
        "Watch Video",
        style: AppStyles.mediumTextStyle.copyWith(
          fontSize: 16,
          color: Colors.green,
        ),
      ),
    );
  }
}
