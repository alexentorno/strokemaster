import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stroke_master/base/models/video.dart';
import 'package:stroke_master/base/screens/search/video_screen.dart';
import 'package:stroke_master/base/service/firestore_video_service.dart';
import 'package:stroke_master/base/util/styles/app_styles.dart';
import 'package:stroke_master/state/auth/providers/authentication_provider.dart';
import 'package:stroke_master/state/video/providers/video_state_provider.dart';


class VideoIconCompact extends ConsumerStatefulWidget {
  final Video video;

  const VideoIconCompact({
    super.key,
    required this.video,
  });

  @override
  _VideoIconCompactState createState() => _VideoIconCompactState();
}

class _VideoIconCompactState extends ConsumerState<VideoIconCompact> {
  late bool isLiked;
  late bool isDisliked;
  late bool isFavorited;
  late String userId;
  late VideoService videoService;

  @override
  void initState() {
    super.initState();
    isLiked = widget.video.isLiked;
    isDisliked = widget.video.isDisliked;
    isFavorited = widget.video.isFavorite;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    userId = ref.watch(authenticationProvider).userId ?? "";
    if (userId.isNotEmpty) {
      videoService = VideoService(userId: userId);
      _loadInitialPreferences();
    }
  }

  void _loadInitialPreferences() async {
    await videoService.loadInitialPreferences(
      videoId: widget.video.id,
      setLiked: (liked) => setState(() => isLiked = liked),
      setDisliked: (disliked) => setState(() => isDisliked = disliked),
      setLikes: (likes) => setState(() => widget.video.likes = likes),
      setDislikes: (dislikes) => setState(() => widget.video.dislikes = dislikes),
      setFavorited: (favorited) => setState(() => isFavorited = favorited),
    );
  }

  void _updateLikeDislikeState() async {
    await videoService.updateLikeDislikeState(
      videoId: widget.video.id,
      liked: isLiked,
      disliked: isDisliked,
      likes: widget.video.likes,
      dislikes: widget.video.dislikes,
    );
  }

  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
      if (isLiked) {
        widget.video.likes++;
        if (isDisliked) {
          widget.video.dislikes--;
          isDisliked = false;
        }
      } else {
        widget.video.likes--;
      }
    });

    _updateLikeDislikeState();
  }

  void toggleDislike() {
    setState(() {
      isDisliked = !isDisliked;
      if (isDisliked) {
        widget.video.dislikes++;
        if (isLiked) {
          widget.video.likes--;
          isLiked = false;
        }
      } else {
        widget.video.dislikes--;
      }
    });
    _updateLikeDislikeState();
  }

  void toggleFavorite() async {
    setState(() {
      isFavorited = !isFavorited;
      widget.video.isFavorite = isFavorited;
    });

    await videoService.updateFavoriteState(
      videoId: widget.video.id,
      isFavorite: isFavorited,
    );

    if (isFavorited) {
      ref.read(favoriteVideosProvider(userId).notifier).addToFavorites(widget.video);
    } else {
      ref.read(favoriteVideosProvider(userId).notifier).removeFromFavorites(widget.video);
    }
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
              // Thumbnail and Favorite icon
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
                        Text(
                          '${widget.video.likes}', // Display likes count
                          style: AppStyles.mediumTextStyle.copyWith(
                            color: theme.primaryColorLight,
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
                        Text(
                          '${widget.video.dislikes}',
                          style: AppStyles.mediumTextStyle.copyWith(
                            color: theme.primaryColorLight,
                          ),
                        ),
                      ],
                    ),

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

class AuthState {
  final String? userId;

  AuthState({this.userId});
}
