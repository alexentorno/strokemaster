
import 'package:stroke_master/base/models/rules/assign_video_logic.dart';

class Video {
  final String id;
  final String name;
  final String thumbnailUrl;
  final String where;       // e.g., "On Water" or "Gym"
  final String difficulty;  // Difficulty level

  Video({
    required this.id,
    required this.name,
    required this.thumbnailUrl,
    required this.where,
    required this.difficulty,
  });

  factory Video.fromJsonSearchVideos(Map<String, dynamic> json) {
    print(json);
    final snippet = json['snippet'];
    final title = snippet['title'];
    return Video(
      id: json['id']['videoId'],
      name: title,
      thumbnailUrl: snippet['thumbnails']['high']['url'],
      where: assignWhere(title),
      difficulty: assignDifficulty(title),
    );
  }

  factory Video.fromJsonPlaylistItem(Map<String, dynamic> json) {
    print(json);
    final snippet = json['snippet'];
    final title = snippet['title'];
    return Video(
      id: snippet['resourceId']['videoId'],
      name: title,
      thumbnailUrl: snippet['thumbnails']['high']['url'],
      where: assignWhere(title),
      difficulty: assignDifficulty(title),
    );
  }
}

