import 'package:cloud_firestore/cloud_firestore.dart';

class VideoService {
  final String userId;

  VideoService({required this.userId});

  // Load the initial preferences (like/dislike state and counts)
  Future<void> loadInitialPreferences({
    required String videoId,
    required Function(bool) setLiked,
    required Function(bool) setDisliked,
    required Function(int) setLikes,
    required Function(int) setDislikes,
    required Function(bool) setFavorited,
  }) async {
    if (userId.isEmpty) return;

    final docRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('likedDisliked')
        .doc(videoId);

    final docSnapshot = await docRef.get();
    if (docSnapshot.exists) {
      final data = docSnapshot.data();
      setLiked(data?['liked'] ?? false);
      setDisliked(data?['disliked'] ?? false);
      setFavorited(data?['isFavorite'] ?? false);
    }

    final videoRef = FirebaseFirestore.instance.collection('videos').doc(videoId);
    final videoSnapshot = await videoRef.get();
    if (videoSnapshot.exists) {
      final videoData = videoSnapshot.data();
      setLikes(videoData?['likes'] ?? 0);
      setDislikes(videoData?['dislikes'] ?? 0);
    }
  }


  // Update the like/dislike state in Firestore
  Future<void> updateLikeDislikeState({
    required String videoId,
    required bool liked,
    required bool disliked,
    required int likes,
    required int dislikes,
  }) async {
    if (userId.isEmpty) return;

    final docRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('likedDisliked')
        .doc(videoId);

    await docRef.set({
      'liked': liked,
      'disliked': disliked,
    });

    final videoRef = FirebaseFirestore.instance.collection('videos').doc(videoId);

    await videoRef.update({
      'likes': likes,
      'dislikes': dislikes,
    });

    print("Updated like/dislike state in Firestore.");
  }

  // Update the favorite state in Firestore
  Future<void> updateFavoriteState({
    required String videoId,
    required bool isFavorite,
  }) async {
    if (userId.isEmpty) return;

    // Update user's favorite status for the video
    final userDocRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('likedDisliked')
        .doc(videoId);

    await userDocRef.set({'isFavorite': isFavorite}, SetOptions(merge: true));

    // Update the favorite status in the video document
    final videoDocRef = FirebaseFirestore.instance.collection('videos').doc(videoId);

    await videoDocRef.update({'isFavorite': isFavorite});

    print("Updated favorite state in Firestore.");
  }
}
