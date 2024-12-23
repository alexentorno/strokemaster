import 'package:flutter/material.dart';
import 'package:stroke_master/base/screens/search/video_screen.dart';
import 'package:stroke_master/base/util/styles/app_styles.dart';
import '../../../models/video.dart';

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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          color: theme.scaffoldBackgroundColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Thumbnail
              Image.network(
                video.thumbnailUrl,
                width: double.infinity,
                height: 180,
                fit: BoxFit.cover,
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      video.name,
                      style: AppStyles.mediumTextStyle.copyWith(
                        color: theme.primaryColorLight,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Where: ${video.where}",
                      style: AppStyles.mediumTextStyle.copyWith(
                        fontSize: 16,
                        color: theme.primaryColorLight,
                      ),
                    ),
                    SizedBox(height: 15,),
                    Text(
                      "Difficulty: ${video.difficulty}",
                      style: AppStyles.mediumTextStyle.copyWith(
                        fontSize: 16,
                        color: theme.primaryColorLight,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextButton.icon(
                      onPressed: () =>
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                            builder: (_) => VideoScreen(id: video.id)
                            )
                        ),
                      icon: const Icon(
                        Icons.play_circle,
                        size: 30,
                        color: Colors.green,
                      ),
                      label: Text(
                        "Watch Video",
                        style: AppStyles.mediumTextStyle.copyWith(
                          fontSize: 16,
                          color: Colors.green,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
