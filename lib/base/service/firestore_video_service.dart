import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stroke_master/base/models/video.dart';

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
      'timestamp': liked ? FieldValue.serverTimestamp() : null,
    }, SetOptions(merge: true));
  }

  Future<List<Video>> fetchTopExercisesInLast24Hours() async {
    final now = DateTime.now();
    final yesterday = now.subtract(const Duration(hours: 24));

    final likesDislikesCollection =
    FirebaseFirestore.instance.collection('likesDislikes');
    final querySnapshot = await likesDislikesCollection.get();

    final likeCounts = <String, int>{};

    // Iterate over each document in 'likesDislikes' to access 'users' sub-collection
    for (var doc in querySnapshot.docs) {
      final videoId = doc.id;
      final usersSubCollection = doc.reference.collection('users');
      final usersSnapshot = await usersSubCollection
          .where('timestamp', isGreaterThan: Timestamp.fromDate(yesterday))
          .get();

      // Count the number of likes from users
      for (var userDoc in usersSnapshot.docs) {
        final userData = userDoc.data();
        if (userData['liked'] == true) {
          likeCounts[videoId] = (likeCounts[videoId] ?? 0) + 1;
        }
      }
    }

    // Sort by likes and take top 3
    final topVideoIds = likeCounts.entries
        .toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final top3Ids = topVideoIds.take(3).map((entry) => entry.key).toList();

    // Fetch video details for top 3
    final videoSnapshots = await Future.wait(
        top3Ids.map((id) => FirebaseFirestore.instance.collection('videos').doc(id).get()));

    // Fetch liked/disliked preferences for the user
    final likedDislikedCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('likedDisliked');
    final likedDislikedSnapshot = await likedDislikedCollection.get();
    final likedDislikedMap = {
      for (var doc in likedDislikedSnapshot.docs)
        doc.id: doc.data(), // {liked: true/false, disliked: true/false}
    };

    return videoSnapshots.map((snapshot) {
      final data = snapshot.data()!;
      final videoId = data['id'];
      final userPreferences = likedDislikedMap[videoId] ?? {};

      return Video(
        id: snapshot.id,
        name: data['name'],
        thumbnailUrl: data['thumbnailUrl'],
        where: data['where'],
        difficulty: data['difficulty'],
        isFavorite: data['isFavorite'],
        likes: data['likes'] ?? 999,
        dislikes: data['dislikes'] ?? 999,
        isLiked: userPreferences['liked'] ?? false,
        isDisliked: userPreferences['disliked'] ?? false,
      );
    }).toList();
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
    print('Updating favorite state');
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
  }

}
