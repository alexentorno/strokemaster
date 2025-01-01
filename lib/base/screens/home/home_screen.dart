import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stroke_master/base/animation/loading_animation_screen.dart';
import 'package:stroke_master/base/models/video.dart';
import 'package:stroke_master/base/screens/home/quotes/sprint_canoe_quotes.dart';
import 'package:stroke_master/base/screens/home/widgets/interesting_to_know_widget.dart';
import 'package:stroke_master/base/screens/home/widgets/video_icon_compact.dart';
import 'package:stroke_master/base/service/youtube_service.dart';
import 'package:stroke_master/base/util/app_routes.dart';
import 'package:stroke_master/base/util/styles/app_styles.dart';
import 'package:stroke_master/base/widgets/show_logo.dart';
import 'package:stroke_master/base/widgets/title_and_link_widget.dart';
import 'package:stroke_master/state/auth/providers/authentication_provider.dart';

final videoProvider = FutureProvider<List<Video>>((ref) async {
  final userId = ref.watch(authenticationProvider).userId ?? "";
  // print("User ID: $userId");
  return await YouTubeApiService().fetchVideosWithPreferences(userId);
});


class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return "Good morning";
    } else if (hour < 18) {
      return "Good afternoon";
    } else {
      return "Good evening";
    }
  }

  IconData _getGreetingIcon() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return Icons.sunny;
    } else if (hour < 18) {
      return Icons.wb_cloudy;
    } else {
      return Icons.nightlight_round;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authenticationProvider);
    final theme = Theme.of(context);
    final videos = ref.watch(videoProvider);
    final randomIndex = Random().nextInt(quotes.length);


    final userName = authState.displayName ?? "User";

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: ListView(
        children: [
          const ShowLogo(),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Greeting Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(_getGreetingIcon(), color: theme.primaryColor),
                        const SizedBox(width: 10),
                        Text(
                          "${_getGreeting()}, $userName",
                          style: AppStyles.headlineStyle3,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Title and Link
                TitleAndLinkWidget(
                  title: "Today's Top Exercises",
                  details: 'View all',
                  func: () => router.push("/view_todays_top_exercises"),
                ),
                const SizedBox(height: 20),

                // Video List
                videos.when(
                  data: (videos) => SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: videos
                          .map((video) => VideoIconCompact(
                        video: video,
                      ))
                          .toList(),
                    ),
                  ),
                  loading: () => Center(
                    child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.2,
                        child: const Center(child: LoadingAnimationScreen())),
                  ),
                  error: (error, stack) => Center(
                    child: Text("Error loading videos: $error"),
                  ),
                ),

                const SizedBox(height: 20),

                // Title and Link
                const TitleAndLinkWidget(
                  title: "Interesting to know:",
                ),
                const SizedBox(height: 10),

                InterestingToKnowWidget(
                  phrase: quotes[randomIndex],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
