import 'package:flutter/material.dart';
import 'package:stroke_master/base/models/video.dart';
import 'package:stroke_master/base/screens/home/widgets/video_icon_compact.dart';

class HomeVideoList extends StatelessWidget {
  final List<Video> videos;

  const HomeVideoList({super.key, required this.videos});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300, // Set the height for the scrollable list
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: videos.length,
        itemBuilder: (context, index) {
          return VideoIconCompact(
            video: videos[index],

          );
        },
      ),
    );
  }
}
