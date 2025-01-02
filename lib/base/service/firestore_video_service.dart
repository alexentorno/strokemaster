import 'package:cloud_firestore/cloud_firestore.dart';

class VideoService {
  final String userId;

  VideoService({required this.userId});

  Future<void> updateLikeDislikeState({
    required String videoId,
    required bool liked,
    required bool disliked,
    required int likes,
    required int dislikes,
  }) async {
    final globalDocRef = FirebaseFirestore.instance.collection('likesDislikes').doc(videoId);
    await globalDocRef.set({
      'likes': likes,
      'dislikes': dislikes,
    }, SetOptions(merge: true));

    final userDocRef = globalDocRef.collection('users').doc(userId);
    await userDocRef.set({
      'liked': liked,
      'disliked': disliked,
    }, SetOptions(merge: true));
  }

  Future<void> loadInitialPreferences({
    required String videoId,
    required Function(bool) setLiked,
    required Function(bool) setDisliked,
    required Function(int) setLikes,
    required Function(int) setDislikes,
    required Function(bool) setFavorited,
  }) async {
    final favoriteDoc = await FirebaseFirestore.instance
        .collection('favorites')
        .doc(userId)
        .collection('videos')
        .doc(videoId)
        .get();

    if (favoriteDoc.exists) {
      final favoriteData = favoriteDoc.data()!;
      setFavorited(favoriteData['isFavorite'] ?? false);
    } else {
      setFavorited(false);
    }

    final likesDislikesDoc = await FirebaseFirestore.instance
        .collection('likesDislikes')
        .doc(videoId)
        .get();

    if (likesDislikesDoc.exists) {
      final likesDislikesData = likesDislikesDoc.data()!;
      setLikes(likesDislikesData['likes'] ?? 0);
      setDislikes(likesDislikesData['dislikes'] ?? 0);
    } else {
      setLikes(0);
      setDislikes(0);
    }

    final userDoc = await FirebaseFirestore.instance
        .collection('likesDislikes')
        .doc(videoId)
        .collection('users')
        .doc(userId)
        .get();

    if (userDoc.exists) {
      final userData = userDoc.data()!;
      setLiked(userData['liked'] ?? false);
      setDisliked(userData['disliked'] ?? false);
    } else {
      setLiked(false);
      setDisliked(false);
    }
  }


  Future<void> updateFavoriteState({
    required String videoId,
    required bool isFavorite,
  }) async {
    if (userId.isEmpty) return;

    final favoriteDocRef = FirebaseFirestore.instance
        .collection('favorites')
        .doc(userId)
        .collection('videos')
        .doc(videoId);

    if (isFavorite) {
      await favoriteDocRef.set({
        'isFavorite': true,
        'videoId': videoId,
      }, SetOptions(merge: true));
    } else {
      await favoriteDocRef.delete();
    }

    print("Updated favorite state for user $userId in Firestore.");
  }

}
