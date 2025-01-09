import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stroke_master/base/screens/log/widgets/rating_widget.dart';
import 'package:stroke_master/base/util/app_routes.dart';
import 'package:stroke_master/base/util/styles/app_styles.dart';
import 'package:stroke_master/base/video_frame/compact/video_icon_compact.dart';
import 'package:stroke_master/base/widgets/show_logo.dart';
import 'package:stroke_master/base/widgets/title_and_link_widget.dart';
import 'package:stroke_master/state/auth/providers/authentication_provider.dart';
import 'package:stroke_master/state/video/providers/favorite_videos_provider.dart';

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

            const SizedBox(height: 10),
            TitleAndLinkWidget(
              title: "Your Favorites",
              details: 'View all',
              func: () => router.push("/view_all_favorite_exercises"),
            ),
            const SizedBox(height: 10),

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
            ) : SingleChildScrollView(
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

            const SizedBox(height: 20),
            const TitleAndLinkWidget(
              title: "Rate your feelings of the exercise",
            ),
            const SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                ...favorites.asMap().entries.map((entry) {
                  final index = entry.key;
                  final video = entry.value;

                  return Column(
                    children: [
                      if (index != 0) const Divider(thickness: 1),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                video.name,
                                style: AppStyles.mediumTextStyle
                                    .copyWith(color: theme.primaryColorLight),
                              ),
                            ),
                            RatingWidget(
                              videoId: video.id,
                              userId: userId,
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
