import 'package:flutter/material.dart';
import 'package:stroke_master/base/animation/loading_animation_screen.dart';
import 'package:stroke_master/base/models/video.dart';
import 'package:stroke_master/base/video_frame/large/video_icon.dart';
import 'package:stroke_master/base/util/styles/app_styles.dart';

class VideoList extends StatelessWidget {
  final List<Video> videos;
  final bool isLoading;
  final bool hasError;
  final String userId;

  const VideoList({
    super.key,
    required this.videos,
    required this.isLoading,
    required this.hasError,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (isLoading) {
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.3,
        child: const Center(child: LoadingAnimationScreen()),
      );
    }

    if (hasError) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Center(
          child: Text(
            "Error loading videos 😔",
            style: AppStyles.mediumTextStyle.copyWith(
              color: theme.primaryColorLight,
            ),
          ),
        ),
      );
    }

    if (videos.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Center(
          child: Text(
            "No videos found 😔",
            style: AppStyles.mediumTextStyle.copyWith(
              color: theme.primaryColorLight,
            ),
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: videos.length,
      itemBuilder: (context, index) {
        final video = videos[index];
        return VideoIcon(
          video: video,
          theme: theme,
          userId: userId,
        );
      },
    );
  }
}
