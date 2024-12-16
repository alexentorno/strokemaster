import 'package:flutter/material.dart';
import 'package:stroke_master/base/models/video.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:stroke_master/base/util/styles/app_styles.dart';

class VideoItem extends StatelessWidget {
  final Video video;
  final ThemeData theme;

  const VideoItem({super.key, required this.video, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 8,
      shadowColor: theme.primaryColorLight.withOpacity(1),
      child: Container(
        color: theme.scaffoldBackgroundColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              child: Image.network(video.thumbnailUrl, width: double.infinity, fit: BoxFit.cover),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(video.name, style: AppStyles.mediumTextStyle.copyWith(color: theme.primaryColorLight, fontSize: 20)),
                  SizedBox(height: 8),
                  Text("Where: ${video.where}", style: AppStyles.mediumTextStyle.copyWith(fontSize: 16, color: theme.primaryColorLight)),
                  Text("Difficulty: ${video.difficulty}", style: AppStyles.mediumTextStyle.copyWith(fontSize: 16, color: theme.primaryColorLight)),
                  SizedBox(height: 8),
                  TextButton.icon(
                    onPressed: () {
                      // Open video URL
                      launchUrl(Uri.parse(video.videoUrl));
                    },
                    icon: const Icon(Icons.play_circle, size: 30, color: Colors.green,),
                    label: Text("Watch Video", style: AppStyles.mediumTextStyle.copyWith(fontSize: 16, color: Colors.green),),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
