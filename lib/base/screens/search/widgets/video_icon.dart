import 'package:flutter/material.dart';
import 'package:stroke_master/base/models/video.dart';
import 'package:stroke_master/base/screens/search/video_screen.dart';
import 'package:stroke_master/base/util/styles/app_styles.dart';

class VideoItem extends StatefulWidget {
  final Video video;
  final ThemeData theme;

  const VideoItem({super.key, required this.video, required this.theme});

  @override
  State<VideoItem> createState() => _VideoItemState();
}

class _VideoItemState extends State<VideoItem> {
  bool isLiked = false;
  bool isDisliked = false;
  bool isFavorited = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 8,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
            color: widget.theme.scaffoldBackgroundColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Thumbnail
              Image.network(
                widget.video.thumbnailUrl,
                width: double.infinity,
                height: 180,
                fit: BoxFit.cover,
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Video Title
                    Text(
                      widget.video.name,
                      style: AppStyles.mediumTextStyle.copyWith(
                        color: widget.theme.primaryColorLight,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Where
                    Text(
                      "Where: ${widget.video.where}",
                      style: AppStyles.mediumTextStyle.copyWith(
                        fontSize: 16,
                        color: widget.theme.primaryColorLight,
                      ),
                    ),

                    // Difficulty
                    const SizedBox(height: 15),
                    Text(
                      "Difficulty: ${widget.video.difficulty}",
                      style: AppStyles.mediumTextStyle.copyWith(
                        fontSize: 16,
                        color: widget.theme.primaryColorLight,
                      ),
                    ),

                    const SizedBox(height: 15),

                    // Buttons Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Like and Dislike Buttons
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  isLiked = !isLiked;
                                  if (isLiked) isDisliked = false; // Ensure dislike is deactivated
                                });
                              },
                              icon: Icon(
                                isLiked
                                    ? Icons.thumb_up_alt
                                    : Icons.thumb_up_alt_outlined,
                                color: isLiked
                                    ? widget.theme.primaryColor
                                    : widget.theme.primaryColorLight,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  isDisliked = !isDisliked;
                                  if (isDisliked) isLiked = false; // Ensure like is deactivated
                                });
                              },
                              icon: Icon(
                                isDisliked
                                    ? Icons.thumb_down_alt
                                    : Icons.thumb_down_alt_outlined,
                                color: isDisliked
                                    ? Colors.red
                                    : widget.theme.primaryColorLight,
                              ),
                            ),
                          ],
                        ),

                        // Add to Favorites Button
                        TextButton.icon(
                          onPressed: () {
                            setState(() {
                              isFavorited = !isFavorited;
                            });
                          },
                          icon: Icon(
                            isFavorited ? Icons.favorite : Icons.favorite_border,
                            color: Colors.green,
                          ),
                          label: Text(
                            isFavorited ? "Favorited" : "Add to Favorites",
                            style: AppStyles.mediumTextStyle.copyWith(
                              fontSize: 16,
                              color: Colors.green,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Watch Video Button
                    TextButton.icon(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => VideoScreen(id: widget.video.id),
                        ),
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
