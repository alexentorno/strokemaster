import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stroke_master/base/models/video.dart';
import 'package:stroke_master/state/constants/firebase_collection_name.dart';
import 'package:stroke_master/state/constants/firebase_field_name.dart';

class FavoriteVideosNotifier extends StateNotifier<List<Video>> {
  final String userId;
  late final StreamSubscription _subscription;

  FavoriteVideosNotifier(this.userId) : super([]) {
    _listenToFavorites();
  }

  void _listenToFavorites() {
    if (userId.isEmpty) return;

    _subscription = FirebaseFirestore.instance
        .collection(FirebaseCollectionName.favorites)
        .doc(userId)
        .collection(FirebaseCollectionName.videos)
        .snapshots()
        .listen((snapshot) async {
      final List<Video> favorites = await Future.wait(snapshot.docs.map((doc) async {
        final data = doc.data();

        final likesDislikesDoc = await FirebaseFirestore.instance
            .collection(FirebaseCollectionName.likesDislikes)
            .doc(doc.id)
            .get();

        final videoDoc = await FirebaseFirestore.instance
            .collection(FirebaseCollectionName.videos)
            .doc(data[FirebaseFieldName.videoId])
            .get();
        final videoData = videoDoc.data() ?? {};

        return Video(
          id: doc.id,
          name: videoData[FirebaseFieldName.name] ?? 'Unknown',
          thumbnailUrl: videoData[FirebaseFieldName.thumbnailUrl] ?? '',
          where: videoData[FirebaseFieldName.where] ?? 'Unknown',
          difficulty: videoData[FirebaseFieldName.difficulty] ?? 'Unknown',
          isFavorite: data[FirebaseFieldName.isFavorite] ?? false,
          likes: likesDislikesDoc.data()?[FirebaseFieldName.likes] ?? 0,
          dislikes: likesDislikesDoc.data()?[FirebaseFieldName.dislikes] ?? 0,
        );
      }));

      if (state != favorites) {
        state = favorites;
      }
    });
  }

  Future<void> addToFavorites(Video video) async {
    final docRef = FirebaseFirestore.instance
        .collection(FirebaseCollectionName.favorites)
        .doc(userId)
        .collection(FirebaseCollectionName.videos)
        .doc(video.id);

    await docRef.set({
      FirebaseFieldName.name: video.name,
      FirebaseFieldName.thumbnailUrl: video.thumbnailUrl,
      FirebaseFieldName.where: video.where,
      FirebaseFieldName.difficulty: video.difficulty,
      FirebaseFieldName.isFavorite: true,
    });
  }

  Future<void> removeFromFavorites(Video video) async {
    final docRef = FirebaseFirestore.instance
        .collection(FirebaseCollectionName.favorites)
        .doc(userId)
        .collection(FirebaseCollectionName.videos)
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
