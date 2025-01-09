import 'package:flutter/material.dart';

class FavoriteIcon extends StatelessWidget {
  final bool isFavorited;
  final VoidCallback onPressed;

  const FavoriteIcon({
    Key? key,
    required this.isFavorited,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 12,
      right: 12,
      child: Container(
        width: 35,
        height: 35,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: IconButton(
            onPressed: onPressed,
            icon: Icon(
              isFavorited ? Icons.favorite : Icons.favorite_border,
              size: 23,
              color: Colors.green,
            ),
            constraints: const BoxConstraints(),
            padding: EdgeInsets.zero,
          ),
        ),
      ),
    );
  }
}
