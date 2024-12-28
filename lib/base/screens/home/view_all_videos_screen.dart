import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stroke_master/base/screens/home/home_screen.dart';
import 'package:stroke_master/base/screens/search/widgets/video_icon.dart';
import 'package:stroke_master/base/util/styles/app_styles.dart';

class ViewAllVideosScreen extends ConsumerWidget {
  const ViewAllVideosScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    // Watch the videosProvider
    final videosAsyncValue = ref.watch(videosProvider);

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
            return VideoItem(video: video, theme: theme);
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
