class Video {
  final String name;          // Video title
  final String where;         // On Water, Gym, etc.
  final String difficulty;    // Beginner, Advanced, Professional
  final String thumbnailUrl;  // Video thumbnail image
  final String videoUrl;      // Video URL

  Video({
    required this.name,
    required this.where,
    required this.difficulty,
    required this.thumbnailUrl,
    required this.videoUrl,
  });

  static final List<Video> videos = [
    Video(
      name: "Crossover Drill",
      where: "On Water",
      difficulty: "Advanced",
      thumbnailUrl: "https://i.ytimg.com/vi/q0JlQatBa24/hqdefault.jpg?sqp=-oaymwE2CPYBEIoBSFXyq4qpAygIARUAAIhCGAFwAcABBvABAfgB_gmAAtAFigIMCAAQARhYIGIoZTAP&rs=AOn4CLBtcLazeRYEKUjVRzAY1DKdg-50nQ", // Replace with actual thumbnail
      videoUrl: "https://www.youtube.com/watch?v=iDxekedHHFw",
    ),
    Video(
      name: "Canoe and Kayak Fitness Workout",
      where: "Gym",
      difficulty: "Beginner",
      thumbnailUrl: "https://i.ytimg.com/vi/q0JlQatBa24/hqdefault.jpg?sqp=-oaymwE2CPYBEIoBSFXyq4qpAygIARUAAIhCGAFwAcABBvABAfgB_gmAAtAFigIMCAAQARhYIGIoZTAP&rs=AOn4CLBtcLazeRYEKUjVRzAY1DKdg-50nQ",
      videoUrl: "https://www.youtube.com/watch?v=5wixDPOfW8g",
    ),
    Video(
      name: "R-6 Physical Activity - Lesson 4",
      where: "Warm up",
      difficulty: "Beginner",
      thumbnailUrl: "https://i.ytimg.com/vi/q0JlQatBa24/hqdefault.jpg?sqp=-oaymwE2CPYBEIoBSFXyq4qpAygIARUAAIhCGAFwAcABBvABAfgB_gmAAtAFigIMCAAQARhYIGIoZTAP&rs=AOn4CLBtcLazeRYEKUjVRzAY1DKdg-50nQ",
      videoUrl: "https://www.youtube.com/results?search_query=R-6+Physical+Activity",
    ),
  ];

}
