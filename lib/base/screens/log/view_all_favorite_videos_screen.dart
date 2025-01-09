import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stroke_master/base/video_frame/large/video_icon.dart';
import 'package:stroke_master/base/util/styles/app_styles.dart';
import 'package:stroke_master/state/auth/providers/authentication_provider.dart';
import 'package:stroke_master/state/video/providers/favorite_videos_provider.dart';

class ViewAllFavoriteVideosScreen extends ConsumerWidget {
  const ViewAllFavoriteVideosScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final userId = ref.watch(authenticationProvider).userId ?? "";

    final favorites = ref.watch(favoriteVideosProvider(userId));

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          "Your Favorites",
          style: AppStyles.appBarTitleStyle.copyWith(color: theme.primaryColorLight),
        ),
      ),
      body:
           favorites.isEmpty
          ? Center(
        child: Text(
          "No favorite videos here 😔",
          style: AppStyles.mediumTextStyle.copyWith(color: theme.primaryColorLight),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: favorites.length,
        itemBuilder: (context, index) {
          final video = favorites[index];
          return VideoIcon(video: video, theme: theme, userId: userId);
        },
      ),
    );
  }
}
