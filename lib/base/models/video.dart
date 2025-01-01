import 'package:stroke_master/base/models/rules/assign_video_logic.dart';

class Video {
  final String id;
  final String name;
  final String thumbnailUrl;
  final String where;
  final String difficulty;
  bool isFavorite;
  int likes;
  int dislikes;
  bool isLiked;
  bool isDisliked;

  Video({
    required this.id,
    required this.name,
    required this.thumbnailUrl,
    required this.where,
    required this.difficulty,
    this.isFavorite = false,
    this.likes = 0,
    this.dislikes = 0,
    this.isLiked = false,
    this.isDisliked = false,
  });

  // Factory constructor for search video API
  factory Video.fromJsonSearchVideos(Map<String, dynamic> json) {
    final snippet = json['snippet'];
    final title = snippet['title'];
    return Video(
      id: json['id']['videoId'],
      name: title,
      thumbnailUrl: snippet['thumbnails']['high']['url'],
      where: assignWhere(title),
      difficulty: assignDifficulty(title),
      likes: 0,
      dislikes: 0,
      isFavorite: false,
    );
  }

  // Factory constructor for playlist item API
  factory Video.fromJsonPlaylistItem(Map<String, dynamic> json) {
    final snippet = json['snippet'];
    final title = snippet['title'];
    return Video(
      id: snippet['resourceId']['videoId'],
      name: title,
      thumbnailUrl: snippet['thumbnails']['high']['url'],
      where: assignWhere(title),
      difficulty: assignDifficulty(title),
      likes: 0,
      dislikes: 0,
      isFavorite: false,
    );
  }

  factory Video.fromFirestore(Map<String, dynamic> data) {
    return Video(
      id: data['id'],
      name: data['name'],
      thumbnailUrl: data['thumbnailUrl'],
      where: data['where'],
      difficulty: data['difficulty'],
      isFavorite: data['isFavorite'] ?? false,
      likes: data['likes'] ?? 0,
      dislikes: data['dislikes'] ?? 0,
    );
  }

  void toggleFavorite() {
    isFavorite = !isFavorite;
  }
}
