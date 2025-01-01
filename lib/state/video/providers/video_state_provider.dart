import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stroke_master/base/models/video.dart';

class FavoriteVideosNotifier extends StateNotifier<List<Video>> {
  final String userId;

  FavoriteVideosNotifier(this.userId) : super([]) {
    fetchFavorites(); // Automatically fetch favorites on initialization.
  }

  Future<void> fetchFavorites() async {
    if (userId.isEmpty) return;

    final querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('likedDisliked')
        .where('isFavorite', isEqualTo: true)
        .get();

    final favorites = querySnapshot.docs.map((doc) {
      final data = doc.data();
      return Video(
        id: doc.id,
        name: data['name'] ?? '',
        thumbnailUrl: data['thumbnailUrl'] ?? '',
        where: data['where'] ?? 'On Water',
        difficulty: data['difficulty'] ?? 'Beginner',
        isFavorite: data['isFavorite'] ?? false,
        likes: data['likes'] ?? 0,
        dislikes: data['dislikes'] ?? 0,
      );
    }).toList();

    state = favorites; // Update the state with the fetched favorites.
  }


  // Add a video to favorites (local and Firestore)
  Future<void> addToFavorites(Video video) async {
    state = [...state, video]; // Update local state.

    final docRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('likedDisliked')
        .doc(video.id);

    await docRef.set({'isFavorite': true}, SetOptions(merge: true));
  }

  // Remove a video from favorites (local and Firestore)
  Future<void> removeFromFavorites(Video video) async {
    state = state.where((v) => v.id != video.id).toList(); // Update local state.

    final docRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('likedDisliked')
        .doc(video.id);

    await docRef.update({'isFavorite': false});
  }
}

// Provider for managing favorite videos
final favoriteVideosProvider =
StateNotifierProvider.family<FavoriteVideosNotifier, List<Video>, String>(
      (ref, userId) => FavoriteVideosNotifier(userId),
);
