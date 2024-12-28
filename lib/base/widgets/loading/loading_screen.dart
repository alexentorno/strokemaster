import 'package:flutter/material.dart';
import 'package:stroke_master/base/animation/loading_animation_screen.dart';
import 'package:stroke_master/base/util/styles/app_styles.dart';

class LoadingScreen {
  LoadingScreen._();

  static final LoadingScreen _sharedInstance = LoadingScreen._();

  factory LoadingScreen.instance() => _sharedInstance;

  OverlayEntry? _currentOverlay;

  void show({required BuildContext context, String text = 'Loading...'}) {
    final theme = Theme.of(context);
    if (_currentOverlay != null) return;

    final overlayState = Overlay.of(context);

    _currentOverlay = OverlayEntry(builder: (context) {
      return Material(
        color: Colors.black.withOpacity(0.5),
        child: Center(
          child: Container(
            width: 150,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: theme.scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  width: 100,
                  height: 100,
                  child: LoadingAnimationScreen(),
                ),
                const SizedBox(height: 12),
                Text(
                  text,
                  textAlign: TextAlign.center,
                  style: AppStyles.mediumTextStyle.copyWith(
                    color: Theme.of(context).primaryColorLight,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });

    overlayState.insert(_currentOverlay!);
  }

  void hide() {
    _currentOverlay?.remove();
    _currentOverlay = null;
  }
}
