import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../theme/theme.dart';
import '../../../util/styles/app_styles.dart';

class ChangeThemeToggleTextWithButton extends StatelessWidget {
  const ChangeThemeToggleTextWithButton({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Consumer<ThemeProvider>(
      builder: (context, ThemeProvider notifier, child) {
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Change theme",
                    style: TextStyle(
                      color: theme.primaryColorLight,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),),
                Row(
                  children: [
                    // Bright Button
                    ElevatedButton(
                      onPressed: () {
                        if (notifier.isDark) notifier.changeTheme();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: notifier.isDark
                            ? Colors.grey[300]
                            : AppStyles.primaryColor, // Active/Inactive colors
                        foregroundColor: notifier.isDark
                            ? Colors.black
                            : Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text("Bright", style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    ElevatedButton(
                      onPressed: () {
                        if (!notifier.isDark) notifier.changeTheme();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: notifier.isDark
                            ? AppStyles.primaryColor
                            : Colors.grey[300], // Active/Inactive colors
                        foregroundColor: notifier.isDark
                            ? AppStyles.textColorDark
                            : Colors.black, // Text color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text("Dark", style: TextStyle(
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
      },
    ) ;
  }
}
