import 'dart:async';

import 'package:flutter/material.dart';
import 'package:stroke_master/base/animation/loading_animation_screen.dart';
import 'package:stroke_master/base/models/video.dart';
import 'package:stroke_master/base/screens/search/widgets/custom_filter_chips_widget.dart';
import 'package:stroke_master/base/screens/search/widgets/video_icon.dart';
import 'package:stroke_master/base/service/youtube_service.dart';
import 'package:stroke_master/base/util/styles/app_styles.dart';
import 'package:stroke_master/base/widgets/show_logo.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final YouTubeApiService _apiService = YouTubeApiService();
  List<Video> _videos = [];
  bool _isLoading = false;

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
      _searchVideos();
    });
  }


  void _searchVideos() async {
    setState(() {
      _isLoading = true;
    });

    try {
      List<Video> videos = [];
      // Fetch videos from playlists
      videos.addAll(await _apiService.fetchPlaylistVideos('PLQujqPRf2C8OLp4acePQ67upU14NfwbQN'));
      videos.addAll(await _apiService.fetchPlaylistVideos('PLQujqPRf2C8MWZkZ9N24b8UwhZijF3QN2'));
      videos.addAll(await _apiService.fetchPlaylistVideos('PLU8uVkF9zP5T8LCIBzXDPcFWpJ163nOGK'));

      // Apply filters and search query
      final filteredVideos = videos.where((video) {
        final matchesWhere = selectedWhere.isEmpty || selectedWhere.contains(video.where);
        final matchesDifficulty = selectedDifficulty.isEmpty || selectedDifficulty.contains(video.difficulty);
        final matchesSearchQuery = searchQuery.isEmpty ||
            video.name.toLowerCase().contains(searchQuery.toLowerCase());
        return matchesWhere && matchesDifficulty && matchesSearchQuery;
      }).toList();

      setState(() {
        _videos = filteredVideos;
      });
    } catch (e) {
      print('Error fetching videos: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }


  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _searchVideos(); // Fetch videos on screen load
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

    return Container(
      color: theme.scaffoldBackgroundColor,
      child: SafeArea(
        child: Scaffold(
          body: CustomScrollView(
            slivers: [
              // SliverAppBar with pinned logo
              SliverAppBar(
                backgroundColor: theme.scaffoldBackgroundColor,
                pinned: true,
                floating: false,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    color: theme.scaffoldBackgroundColor,
                    child: const ShowLogo(),
                  ),
                ),
              ),

              SliverList(
                delegate: SliverChildListDelegate([
                  // Title Text
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
                      onSubmitted: (_) => _searchVideos(),
                    ),
                  ),

                  // Filters Section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: CustomFilterChips(
                      label: "Where?",
                      options: whereOptions,
                      selectedItems: selectedWhere.isNotEmpty ? selectedWhere : [],
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
                      selectedItems: selectedDifficulty.isNotEmpty ? selectedDifficulty : [],
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
                  if (_isLoading)
                    SizedBox(
                        height: MediaQuery.of(context).size.height * 0.3,
                        child: const Center(child: LoadingAnimationScreen())),

                  // Video List
                  if (_videos.isEmpty && !_isLoading)
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
                      shrinkWrap: true, // List only takes needed space
                      physics: const NeverScrollableScrollPhysics(), // Disable scrolling within the list
                      itemCount: _videos.length,
                      itemBuilder: (context, index) {
                        final video = _videos[index];
                        return VideoItem(
                          video: video,
                          theme: theme,
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
