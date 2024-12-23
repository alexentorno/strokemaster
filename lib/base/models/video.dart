
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

  factory Video.fromJson(Map<String, dynamic> json) {
    print(json);
    final snippet = json['snippet'];
    return Video(
      id: json['id']['videoId'],
      name: snippet['title'],
      thumbnailUrl: snippet['thumbnails']['high']['url'],
      where: 'On Water', // Example criteria, you can add custom logic
      difficulty: 'Advanced', // Example difficulty, adjust per criteria
    );
  }

  factory Video.fromJson2(Map<String, dynamic> json) {
    print(json);
    final snippet = json['snippet'];
    return Video(
      id: snippet['resourceId']['videoId'],
      name: snippet['title'],
      thumbnailUrl: snippet['thumbnails']['high']['url'],
      where: 'On Water', // Example criteria, you can add custom logic
      difficulty: 'Advanced', // Example difficulty, adjust per criteria
    );
  }
}

