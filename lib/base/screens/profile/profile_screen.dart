import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stroke_master/main.dart';
import '/base/util/media.dart';
import '/base/util/styles/app_styles.dart';
import '/base/widgets/heading_text.dart';
import 'widgets/change_theme_toggle_text_with_button_widget.dart';
import 'widgets/logout_button_widget.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Access the current theme using Riverpod
    final themeNotifier = ref.watch(themeNotifierProvider);
    final theme = themeNotifier.isDark ? themeNotifier.darkTheme : themeNotifier.lightTheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          "Your profile",
          style: AppStyles.appBarTitleStyle.copyWith(color: theme.primaryColorLight),
        ),
      ),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            children: [
              const Padding(padding: EdgeInsets.only(top: 15)),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // User avatar
                  Container(
                    margin: const EdgeInsets.only(right: 10),
                    width: 85,
                    height: 85,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: const DecorationImage(image: AssetImage(AppMedia.defaultProfile)),
                    ),
                  ),
                  // Column with user details
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const HeadingText(
                        text: "Alexander Pekhenko", // TODO: User's first and last name
                      ),
                      const SizedBox(height: 15),
                      Text(
                        "alexpekhenko@gmail.com", // TODO: User's email
                        style: TextStyle(
                          color: theme.primaryColorLight,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 3),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                    ],
                  ),
                  Expanded(child: Container()),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Icon(
                      FluentSystemIcons.ic_fluent_settings_regular,
                      color: theme.primaryColorLight,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Divider(color: Colors.grey.shade300),
              const SizedBox(height: 8),
              const ChangeThemeToggleTextWithButton(),
              const SizedBox(height: 25),
            ],
          ),
          // Logout Button at the Bottom Center
          const LogoutButton()
        ],
      ),
    );
  }
}
