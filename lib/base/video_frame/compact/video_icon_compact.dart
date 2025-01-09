import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stroke_master/base/models/video.dart';
import 'package:stroke_master/base/screens/video_player/video_screen.dart';
import 'package:stroke_master/base/service/firestore_video_service.dart';
import 'package:stroke_master/base/util/styles/app_styles.dart';
import 'package:stroke_master/state/auth/providers/authentication_provider.dart';

import 'widgets/favorite_icon_widget.dart';
import 'widgets/like_dislike_buttons_widget.dart';
import 'widgets/watch_video_button_widget.dart';

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
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    userId = ref.watch(authenticationProvider).userId ?? "";
    if (userId.isNotEmpty) {
      videoService = VideoService(userId: userId);

      await videoService.loadInitialPreferences(
        videoId: widget.video.id,
        setLiked: (liked) => setState(() => isLiked = liked),
        setDisliked: (disliked) => setState(() => isDisliked = disliked),
        setLikes: (likes) => setState(() => widget.video.likes = likes),
        setDislikes: (dislikes) => setState(() => widget.video.dislikes = dislikes),
        setFavorited: (favorited) => setState(() => isFavorited = favorited),
      );
    }
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

    videoService.updateLikeDislikeState(
      videoId: widget.video.id,
      liked: isLiked,
      disliked: isDisliked,
      likes: widget.video.likes,
      dislikes: widget.video.dislikes,
    );
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

    videoService.updateLikeDislikeState(
      videoId: widget.video.id,
      liked: isLiked,
      disliked: isDisliked,
      likes: widget.video.likes,
      dislikes: widget.video.dislikes,
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
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(right: 15, bottom: 10),
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
              Stack(
                children: [
                  // Thumbnail
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
                  // Favorite Icon
                  FavoriteIcon(
                    isFavorited: isFavorited,
                    onPressed: toggleFavorite,
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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

                    LikeDislikeButtons(
                      isLiked: isLiked,
                      isDisliked: isDisliked,
                      likesCount: widget.video.likes,
                      dislikesCount: widget.video.dislikes,
                      onLikePressed: toggleLike,
                      onDislikePressed: toggleDislike,
                    ),
                    WatchVideoButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => VideoScreen(id: widget.video.id),
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
