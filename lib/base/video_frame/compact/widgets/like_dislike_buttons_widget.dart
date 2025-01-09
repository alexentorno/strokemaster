import 'package:flutter/material.dart';
import 'package:stroke_master/base/util/styles/app_styles.dart';

class LikeDislikeButtons extends StatelessWidget {
  final bool isLiked;
  final bool isDisliked;
  final int likesCount;
  final int dislikesCount;
  final VoidCallback onLikePressed;
  final VoidCallback onDislikePressed;

  const LikeDislikeButtons({
    super.key,
    required this.isLiked,
    required this.isDisliked,
    required this.likesCount,
    required this.dislikesCount,
    required this.onLikePressed,
    required this.onDislikePressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        IconButton(
          onPressed: onLikePressed,
          icon: Icon(
            isLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
            color: isLiked ? theme.primaryColor : theme.primaryColorLight,
          ),
        ),
        Text(
          '$likesCount',
          style: AppStyles.mediumTextStyle.copyWith(
            color: theme.primaryColorLight,
          ),
        ),
        IconButton(
          onPressed: onDislikePressed,
          icon: Icon(
            isDisliked ? Icons.thumb_down : Icons.thumb_down_outlined,
            color: isDisliked ? Colors.red : theme.primaryColorLight,
          ),
        ),
        Text(
          '$dislikesCount',
          style: AppStyles.mediumTextStyle.copyWith(
            color: theme.primaryColorLight,
          ),
        ),
      ],
    );
  }
}
