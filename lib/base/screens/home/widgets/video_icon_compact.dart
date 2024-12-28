import 'package:flutter/material.dart';
import 'package:stroke_master/base/models/video.dart';
import 'package:stroke_master/base/screens/search/video_screen.dart';
import 'package:stroke_master/base/util/styles/app_styles.dart';

class VideoIconCompact extends StatefulWidget {
  final Video video;

  const VideoIconCompact({
    super.key,
    required this.video,
  });

  @override
  _VideoIconCompactState createState() => _VideoIconCompactState();
}

class _VideoIconCompactState extends State<VideoIconCompact> {
  bool isLiked = false;
  bool isDisliked = false;
  bool isFavorited = false;

  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
      if (isLiked) {
        isDisliked = false; // Cannot like and dislike at the same time
      }
    });
  }

  void toggleDislike() {
    setState(() {
      isDisliked = !isDisliked;
      if (isDisliked) {
        isLiked = false; // Cannot like and dislike at the same time
      }
    });
  }

  void toggleFavorite() {
    setState(() {
      isFavorited = !isFavorited;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.all(10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 5,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: 250,
          color: theme.scaffoldBackgroundColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Thumbnail
              Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    width: 245,
                    height: 140,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        widget.video.thumbnailUrl,
                        width: double.infinity,
                        height: 140,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: IconButton(
                          onPressed: toggleFavorite,
                          icon: Icon(
                            isFavorited ? Icons.favorite : Icons.favorite_border,
                            size: 23,
                            color: Colors.green,
                          ),
                          constraints: const BoxConstraints(),
                          padding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Video Title
                    Text(
                      widget.video.name,
                      style: AppStyles.mediumTextStyle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 5),

                    // Where
                    Text(
                      widget.video.where,
                      style: AppStyles.mediumTextStyle.copyWith(
                        fontSize: 16,
                        color: theme.primaryColor,
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Like and Dislike Buttons
                    Row(
                      children: [
                        IconButton(
                          onPressed: toggleLike,
                          icon: Icon(
                            isLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
                            color: isLiked
                            ? theme.primaryColor
                            : theme.primaryColorLight,
                          ),
                        ),
                        IconButton(
                          onPressed: toggleDislike,
                          icon: Icon(
                            isDisliked
                                ? Icons.thumb_down
                                : Icons.thumb_down_outlined,
                            color: isDisliked
                                ? Colors.red
                                : theme.primaryColorLight,
                          ),
                        ),
                      ],
                    ),

                    // const SizedBox(height: 5),

                    // Watch Video Button
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: TextButton.icon(
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
