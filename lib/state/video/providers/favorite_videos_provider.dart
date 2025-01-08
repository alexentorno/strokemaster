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
        .listen((snapshot) async {
      final List<Video> favorites = await Future.wait(snapshot.docs.map((doc) async {
        final data = doc.data();

        print(data);

        final likesDislikesDoc = await FirebaseFirestore.instance
            .collection('likesDislikes')
            .doc(doc.id)
            .get();

        final videoDoc = await FirebaseFirestore.instance
            .collection('videos')
            .doc(data['videoId'])
            .get();
        final videoData = videoDoc.data() ?? {};

        return Video(
          id: doc.id,
          name: videoData['name'] ?? 'Unknown',
          thumbnailUrl: videoData['thumbnailUrl'] ?? '',
          where: videoData['where'] ?? 'Unknown',
          difficulty: videoData['difficulty'] ?? 'Unknown',
          isFavorite: data['isFavorite'] ?? false,
          likes: likesDislikesDoc.data()?['likes'] ?? 0,
          dislikes: likesDislikesDoc.data()?['dislikes'] ?? 0,
        );
      }));

      if (state != favorites) {
        state = favorites;
      }
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
