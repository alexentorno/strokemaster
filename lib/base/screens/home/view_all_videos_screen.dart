import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stroke_master/base/screens/home/home_screen.dart';
import 'package:stroke_master/base/screens/search/widgets/video_icon.dart';
import 'package:stroke_master/base/util/styles/app_styles.dart';
import 'package:stroke_master/state/auth/providers/authentication_provider.dart';

class ViewAllVideosScreen extends ConsumerWidget {
  const ViewAllVideosScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final videosAsyncValue = ref.watch(videoProvider);
    final userId = ref.watch(authenticationProvider).userId ?? "";

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          "Today's Top Exercises",
          style: AppStyles.appBarTitleStyle.copyWith(color: theme.primaryColorLight),
        ),
      ),
      body: videosAsyncValue.when(
        data: (videos) => ListView.builder(
          padding: const EdgeInsets.all(10),
          itemCount: videos.length,
          itemBuilder: (context, index) {
            final video = videos[index];
            return VideoIcon(video: video, theme: theme, userId: userId);
          },
        ),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stack) => Center(
          child: Text("Error loading videos: $error"),
        ),
      ),
    );
  }
}
