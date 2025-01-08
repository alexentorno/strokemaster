import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stroke_master/base/animation/loading_animation_screen.dart';
import 'package:stroke_master/base/models/video.dart';
import 'package:stroke_master/base/screens/search/widgets/custom_filter_chips_widget.dart';
import 'package:stroke_master/base/screens/search/widgets/video_icon.dart';
import 'package:stroke_master/base/service/youtube_service.dart';
import 'package:stroke_master/base/util/styles/app_styles.dart';
import 'package:stroke_master/base/widgets/show_logo.dart';
import 'package:stroke_master/state/auth/providers/authentication_provider.dart';

// Assuming you have a provider for fetching videos
final videoProvider = FutureProvider<List<Video>>((ref) async {
  final userId = ref.watch(authenticationProvider).userId ?? "";
  final apiService = YouTubeApiService();
  return await apiService.fetchVideosWithPreferences(userId);
});

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String searchQuery = "";
  List<String> selectedWhere = [];
  List<String> selectedDifficulty = [];

  List<String> whereOptions = ["On Water", "Gym", "Warm up"];
  List<String> difficultyOptions = ["Beginner", "Advanced", "Professional"];

  Timer? _debounce;

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        searchQuery = _searchController.text;
      });
    });
  }

  void _searchVideos() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final videoAsync = ref.watch(videoProvider);

    final filteredVideos = videoAsync.when(
      data: (videos) {
        return videos.where((video) {
          final matchesSearchQuery = video.name.toLowerCase().contains(searchQuery.toLowerCase());
          final matchesWhere = selectedWhere.isEmpty || selectedWhere.contains(video.where);
          final matchesDifficulty = selectedDifficulty.isEmpty || selectedDifficulty.contains(video.difficulty);
          return matchesSearchQuery && matchesWhere && matchesDifficulty;
        }).toList();
      },
      loading: () => [],
      error: (err, stack) => [],
    );

    return Container(
      color: theme.scaffoldBackgroundColor,
      child: SafeArea(
        child: Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: theme.scaffoldBackgroundColor,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    color: theme.scaffoldBackgroundColor,
                    child: const ShowLogo(),
                  ),
                ),
              ),

              SliverList(
                delegate: SliverChildListDelegate([
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    child: Text(
                      "Search",
                      style: AppStyles.appBarTitleStyle.copyWith(color: theme.primaryColorLight),
                    ),
                  ),

                  // Search Field Widget
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search videos...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        prefixIcon: const Icon(Icons.search),
                      ),
                      onChanged: (_) => _searchVideos(),
                    ),
                  ),

                  // Filters Section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: CustomFilterChips(
                      label: "Where?",
                      options: whereOptions,
                      selectedItems: selectedWhere,
                      onSelectionChanged: (newSelection) {
                        setState(() {
                          selectedWhere = newSelection;
                        });
                        _searchVideos();
                      },
                    ),
                  ),

                  const SizedBox(height: 15),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: CustomFilterChips(
                      label: "Difficulty level",
                      options: difficultyOptions,
                      selectedItems: selectedDifficulty,
                      onSelectionChanged: (newSelection) {
                        setState(() {
                          selectedDifficulty = newSelection;
                        });
                        _searchVideos();
                      },
                    ),
                  ),

                  const SizedBox(height: 15),

                  // Loading Indicator
                  if (videoAsync.isLoading)
                    SizedBox(
                        height: MediaQuery.of(context).size.height * 0.3,
                        child: const Center(child: LoadingAnimationScreen())),

                  // Video List
                  if (videoAsync.hasError)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Center(
                        child: Text(
                          "Error loading videos 😔",
                          style: AppStyles.mediumTextStyle.copyWith(
                            color: theme.primaryColorLight,
                          ),
                        ),
                      ),
                    )
                  else if (filteredVideos.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Center(
                        child: Text(
                          "No videos found 😔",
                          style: AppStyles.mediumTextStyle.copyWith(
                            color: theme.primaryColorLight,
                          ),
                        ),
                      ),
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: filteredVideos.length,
                      itemBuilder: (context, index) {
                        final video = filteredVideos[index];

                        return VideoIcon(
                          video: video,
                          theme: theme,
                          userId: ref.watch(authenticationProvider).userId ?? "",
                        );
                      },
                    ),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
