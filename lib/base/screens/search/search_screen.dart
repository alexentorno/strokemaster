import 'package:flutter/material.dart';
import 'package:stroke_master/base/models/video.dart';
import 'package:stroke_master/base/screens/search/widgets/custom_filter_chips_widget.dart';
import 'package:stroke_master/base/screens/search/widgets/search_field_widget.dart';
import 'package:stroke_master/base/screens/search/widgets/video_icon.dart';
import 'package:stroke_master/base/widgets/show_logo.dart';
import 'package:stroke_master/base/util/styles/app_styles.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String searchQuery = "";
  List<String> selectedWhere = [];
  List<String> selectedDifficulty = [];

  List<String> whereOptions = ["On Water", "Gym", "Warm up"];
  List<String> difficultyOptions = ["Beginner", "Advanced", "Professional"];

  List<Video> get filteredVideos {
    return Video.videos.where((video) {
      final matchesSearch = video.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
          video.where.toLowerCase().contains(searchQuery.toLowerCase());

      final matchesWhere = selectedWhere.isEmpty || selectedWhere.contains(video.where);
      final matchesDifficulty = selectedDifficulty.isEmpty || selectedDifficulty.contains(video.difficulty);

      return matchesSearch && matchesWhere && matchesDifficulty;
    }).toList();
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
                      child: const ShowLogo()
                  ),
                ),
              ),

              SliverList(
                delegate: SliverChildListDelegate([
                  // Title Text
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Text("Search",
                        style: AppStyles.appBarTitleStyle.copyWith(color: theme.primaryColorLight)),
                  ),

                  // Search Field Widget
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    child: SearchField(
                      theme: theme,
                      onChanged: (value) {
                        setState(() {
                          searchQuery = value;
                        });
                      },
                    ),
                  ),

                  // Filters Section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: CustomFilterChips(
                      options: whereOptions,
                      selectedItems: selectedWhere,
                      onSelectionChanged: (newSelection) {
                        setState(() {
                          selectedWhere = newSelection;
                        });
                      },
                      label: "Where?",
                    ),
                  ),

                  const SizedBox(height: 15),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: CustomFilterChips(
                      options: difficultyOptions,
                      selectedItems: selectedDifficulty,
                      onSelectionChanged: (newSelection) {
                        setState(() {
                          selectedDifficulty = newSelection;
                        });
                      },
                      label: "Difficulty level",
                    ),
                  ),

                  // Video List with proper height and smooth transition
                  filteredVideos.isEmpty
                      ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Center(
                      child: Text(
                        "No videos found 😔",
                        style: AppStyles.mediumTextStyle.copyWith(color: theme.primaryColorLight),
                      ),
                    ),
                  )
                      : ListView.builder(
                    shrinkWrap: true, // Make the list take only as much space as needed
                    physics: const NeverScrollableScrollPhysics(), // Disable scrolling within this list
                    itemCount: filteredVideos.length,
                    itemBuilder: (context, index) {
                      final video = filteredVideos[index];
                      return VideoItem(video: video, theme: theme,);
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
