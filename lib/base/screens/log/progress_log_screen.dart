import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stroke_master/base/screens/home/widgets/video_icon_compact.dart';
import 'package:stroke_master/base/util/styles/app_styles.dart';
import 'package:stroke_master/base/widgets/show_logo.dart';
import 'package:stroke_master/state/auth/providers/authentication_provider.dart';
import 'package:stroke_master/state/video/providers/video_state_provider.dart';

class LogsScreen extends ConsumerWidget {
  const LogsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final userId = ref.watch(authenticationProvider).userId ?? "";
    final favorites = ref.watch(favoriteVideosProvider(userId));

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          children: [
            const ShowLogo(),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                "Logs",
                style: AppStyles.appBarTitleStyle
                    .copyWith(color: theme.primaryColorLight),
              ),
            ),

            // Show a horizontally scrollable list of videos or a message if none exist
            favorites.isEmpty
                ? Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  "No favorite videos yet 😔",
                  style: AppStyles.mediumTextStyle.copyWith(
                    color: theme.primaryColorLight,
                  ),
                ),
              ),
            )
                : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: favorites.map((video) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: VideoIconCompact(video: video),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
