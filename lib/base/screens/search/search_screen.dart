import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stroke_master/base/models/video.dart';
import 'package:stroke_master/base/service/youtube_service.dart';
import 'package:stroke_master/base/util/styles/app_styles.dart';
import 'package:stroke_master/base/widgets/show_logo.dart';
import 'package:stroke_master/state/auth/providers/authentication_provider.dart';

import 'widgets/filters_section_widget.dart';
import 'widgets/search_field_widget.dart';
import 'widgets/video_list_widget.dart';

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
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final videoAsync = ref.watch(videoProvider);

    final List<Video> filteredVideos = videoAsync.when(
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

                  SearchField(
                    controller: _searchController,
                    onSearchChanged: _onSearchChanged,
                  ),

                  FiltersSection(
                    selectedWhere: selectedWhere,
                    selectedDifficulty: selectedDifficulty,
                    onWhereSelectionChanged: (newSelection) {
                      setState(() {
                        selectedWhere = newSelection;
                      });
                      _searchVideos();
                    },
                    onDifficultySelectionChanged: (newSelection) {
                      setState(() {
                        selectedDifficulty = newSelection;
                      });
                      _searchVideos();
                    },
                  ),

                  const SizedBox(height: 15),

                  Consumer(
                    builder: (context, ref, child) {
                      final videoState = ref.watch(videoProvider);
                      print(videoState.error);
                      return VideoList(
                        videos: filteredVideos,
                        isLoading: videoState.isLoading,
                        hasError: videoState.hasError,
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
