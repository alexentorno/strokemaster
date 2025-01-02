import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stroke_master/base/models/video.dart';

class FavoriteVideosNotifier extends StateNotifier<List<Video>> {
  final String userId;
  late final StreamSubscription _subscription;

  FavoriteVideosNotifier(this.userId) : super([]) {
    _listenToFavorites();
  }

  void _listenToFavorites() {
    if (userId.isEmpty) return;

    _subscription = FirebaseFirestore.instance
        .collection('favorites')
        .doc(userId)
        .collection('videos')
        .snapshots()
        .listen((snapshot) {
      final List<Video> favorites = snapshot.docs.map((doc) {
        final data = doc.data();
        return Video(
          id: doc.id,
          name: data['name'] ?? '',
          thumbnailUrl: data['thumbnailUrl'] ?? '',
          where: data['where'] ?? 'On Water',
          difficulty: data['difficulty'] ?? 'Beginner',
          isFavorite: data['isFavorite'] ?? false,
          likes: 0, // Likes/dislikes handled separately
          dislikes: 0,
        );
      }).toList();
      state = favorites;
    });
  }

  Future<void> addToFavorites(Video video) async {
    final docRef = FirebaseFirestore.instance
        .collection('favorites')
        .doc(userId)
        .collection('videos')
        .doc(video.id);

    await docRef.set({
      'name': video.name,
      'thumbnailUrl': video.thumbnailUrl,
      'where': video.where,
      'difficulty': video.difficulty,
      'isFavorite': true,
    });
  }

  Future<void> removeFromFavorites(Video video) async {
    final docRef = FirebaseFirestore.instance
        .collection('favorites')
        .doc(userId)
        .collection('videos')
        .doc(video.id);

    await docRef.delete();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}


// Provider for managing favorite videos
final favoriteVideosProvider =
StateNotifierProvider.family<FavoriteVideosNotifier, List<Video>, String>(
      (ref, userId) => FavoriteVideosNotifier(userId),
);
