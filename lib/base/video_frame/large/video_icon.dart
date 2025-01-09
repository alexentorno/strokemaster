import 'package:flutter/material.dart';
import 'package:stroke_master/base/models/video.dart';
import 'package:stroke_master/base/screens/video_player/video_screen.dart';
import 'package:stroke_master/base/service/firestore_video_service.dart';
import 'package:stroke_master/base/util/styles/app_styles.dart';

class VideoIcon extends StatefulWidget {
  final Video video;
  final ThemeData theme;
  final String userId;

  const VideoIcon({
    super.key,
    required this.video,
    required this.theme,
    required this.userId,
  });

  @override
  State<VideoIcon> createState() => _VideoIconState();
}

class _VideoIconState extends State<VideoIcon> {
  late VideoService videoService;
  bool isLiked = false;
  bool isDisliked = false;
  bool isFavorited = false;
  int likes = 0;
  int dislikes = 0;

  @override
  void initState() {
    super.initState();
    videoService = VideoService(userId: widget.userId);

    // Load initial preferences and set states
    videoService.loadInitialPreferences(
      videoId: widget.video.id,
      setLiked: (value) => setState(() => isLiked = value),
      setDisliked: (value) => setState(() => isDisliked = value),
      setLikes: (value) => setState(() => likes = value),
      setDislikes: (value) => setState(() => dislikes = value),
      setFavorited: (value) => setState(() => isFavorited = value),
    );
  }

  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
      if (isLiked) {
        likes++;
        if (isDisliked) {
          dislikes--;
          isDisliked = false;
        }
      } else {
        likes--;
      }
    });

    videoService.updateLikeDislikeState(
      videoId: widget.video.id,
      liked: isLiked,
      disliked: isDisliked,
      likes: likes,
      dislikes: dislikes,
    );
  }

  void toggleDislike() {
    setState(() {
      isDisliked = !isDisliked;
      if (isDisliked) {
        dislikes++;
        if (isLiked) {
          likes--;
          isLiked = false;
        }
      } else {
        dislikes--;
      }
    });

    videoService.updateLikeDislikeState(
      videoId: widget.video.id,
      liked: isLiked,
      disliked: isDisliked,
      likes: likes,
      dislikes: dislikes,
    );
  }

  void toggleFavorite() {
    setState(() => isFavorited = !isFavorited);

    videoService.updateFavoriteState(
      videoId: widget.video.id,
      isFavorite: isFavorited,
    );
  }

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
                    Text(
                      widget.video.name,
                      style: AppStyles.mediumTextStyle.copyWith(
                        color: widget.theme.primaryColorLight,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // "Where?" and "Difficulty"
                    Text("Where: ${widget.video.where}",
                        style: AppStyles.mediumTextStyle.copyWith(
                            fontSize: 16,
                            color: widget.theme.primaryColorLight)),
                    Text("Difficulty: ${widget.video.difficulty}",
                        style: AppStyles.mediumTextStyle.copyWith(
                            fontSize: 16,
                            color: widget.theme.primaryColorLight)),

                    const SizedBox(height: 8),

                    // Like, Dislike, and Favorite Buttons Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              onPressed: toggleLike,
                              icon: Icon(
                                isLiked ? Icons.thumb_up_alt : Icons.thumb_up_alt_outlined,
                                color: isLiked ? widget.theme.primaryColor : widget.theme.primaryColorLight,
                              ),
                            ),
                            Text('$likes', style: AppStyles.mediumTextStyle),
                            const SizedBox(width: 10),
                            IconButton(
                              onPressed: toggleDislike,
                              icon: Icon(
                                isDisliked ? Icons.thumb_down_alt : Icons.thumb_down_alt_outlined,
                                color: isDisliked ? Colors.red : widget.theme.primaryColorLight,
                              ),
                            ),
                            Text('$dislikes', style: AppStyles.mediumTextStyle),
                          ],
                        ),

                        // Add to Favorites Button
                        IconButton(
                          onPressed: toggleFavorite,
                          icon: Icon(
                            isFavorited ? Icons.favorite : Icons.favorite_border,
                            color: Colors.green,
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
