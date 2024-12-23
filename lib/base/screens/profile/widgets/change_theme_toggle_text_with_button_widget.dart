import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stroke_master/base/util/styles/app_styles.dart';
import 'package:stroke_master/main.dart';

class ChangeThemeToggleTextWithButton extends ConsumerWidget {
  const ChangeThemeToggleTextWithButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeNotifier = ref.watch(themeNotifierProvider);
    final isDark = themeNotifier.isDark; // Current theme mode

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Change theme",
              style: TextStyle(
                color: isDark
                    ? themeNotifier.darkTheme.primaryColorLight
                    : themeNotifier.lightTheme.primaryColorLight,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            Row(
              children: [
                // Bright Button
                ElevatedButton(
                  onPressed: () {
                    if (isDark) themeNotifier.toggleTheme(); // Switch to Bright mode
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDark
                        ? Colors.grey[300]
                        : AppStyles.primaryColor, // Active/Inactive colors
                    foregroundColor: isDark ? Colors.black : Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    "Bright",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Dark Button
                ElevatedButton(
                  onPressed: () {
                    if (!isDark) themeNotifier.toggleTheme(); // Switch to Dark mode
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDark
                        ? AppStyles.primaryColor
                        : Colors.grey[300], // Active/Inactive colors
                    foregroundColor: isDark
                        ? AppStyles.textColorDark
                        : Colors.black, // Text color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    "Dark",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
