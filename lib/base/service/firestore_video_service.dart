import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stroke_master/base/models/video.dart';
import 'package:stroke_master/state/constants/firebase_collection_name.dart';
import 'package:stroke_master/state/constants/firebase_field_name.dart';

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
    final globalDocRef = FirebaseFirestore.instance
        .collection(FirebaseCollectionName.likesDislikes)
        .doc(videoId);

    await globalDocRef.set({
      FirebaseFieldName.likes: likes,
      FirebaseFieldName.dislikes: dislikes,
    }, SetOptions(merge: true));

    final userDocRef = globalDocRef
        .collection(FirebaseCollectionName.users)
        .doc(userId);
    await userDocRef.set({
      FirebaseFieldName.liked: liked,
      FirebaseFieldName.disliked: disliked,
      FirebaseFieldName.timestamp: liked ? FieldValue.serverTimestamp() : null,
    }, SetOptions(merge: true));
  }

  Future<List<Video>> fetchTopExercisesInLast24Hours() async {
    final now = DateTime.now();
    final yesterday = now.subtract(const Duration(hours: 24));

    final likesDislikesCollection = FirebaseFirestore.instance
        .collection(FirebaseCollectionName.likesDislikes);
    final querySnapshot = await likesDislikesCollection.get();

    final likeCounts = <String, int>{};

    for (var doc in querySnapshot.docs) {
      final videoId = doc.id;
      final usersSubCollection = doc.reference.collection(FirebaseCollectionName.users);
      final usersSnapshot = await usersSubCollection
          .where(FirebaseFieldName.timestamp, isGreaterThan: Timestamp.fromDate(yesterday))
          .get();

      for (var userDoc in usersSnapshot.docs) {
        final userData = userDoc.data();
        if (userData[FirebaseFieldName.liked] == true) {
          likeCounts[videoId] = (likeCounts[videoId] ?? 0) + 1;
        }
      }
    }

    final topVideoIds = likeCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final top3Ids = topVideoIds.take(3).map((entry) => entry.key).toList();

    final videoSnapshots = await Future.wait(
        top3Ids.map((id) => FirebaseFirestore.instance
            .collection(FirebaseCollectionName.videos)
            .doc(id)
            .get()));

    final likedDislikedCollection = FirebaseFirestore.instance
        .collection(FirebaseCollectionName.users)
        .doc(userId)
        .collection(FirebaseCollectionName.likedDisliked);
    final likedDislikedSnapshot = await likedDislikedCollection.get();
    final likedDislikedMap = {
      for (var doc in likedDislikedSnapshot.docs)
        doc.id: doc.data(),
    };

    return videoSnapshots.map((snapshot) {
      final data = snapshot.data()!;
      final videoId = data[FirebaseFieldName.videoId];
      final userPreferences = likedDislikedMap[videoId] ?? {};

      return Video(
        id: snapshot.id,
        name: data[FirebaseFieldName.name],
        thumbnailUrl: data[FirebaseFieldName.thumbnailUrl],
        where: data[FirebaseFieldName.where],
        difficulty: data[FirebaseFieldName.difficulty],
        isFavorite: data[FirebaseFieldName.isFavorite],
        likes: data[FirebaseFieldName.likes] ?? 0,
        dislikes: data[FirebaseFieldName.dislikes] ?? 0,
        isLiked: userPreferences[FirebaseFieldName.liked] ?? false,
        isDisliked: userPreferences[FirebaseFieldName.disliked] ?? false,
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
        .collection(FirebaseCollectionName.favorites)
        .doc(userId)
        .collection(FirebaseCollectionName.videos)
        .doc(videoId)
        .get();

    if (favoriteDoc.exists) {
      final favoriteData = favoriteDoc.data()!;
      setFavorited(favoriteData[FirebaseFieldName.isFavorite] ?? false);
    } else {
      setFavorited(false);
    }

    final likesDislikesDoc = await FirebaseFirestore.instance
        .collection(FirebaseCollectionName.likesDislikes)
        .doc(videoId)
        .get();

    if (likesDislikesDoc.exists) {
      final likesDislikesData = likesDislikesDoc.data()!;
      setLikes(likesDislikesData[FirebaseFieldName.likes] ?? 0);
      setDislikes(likesDislikesData[FirebaseFieldName.dislikes] ?? 0);
    } else {
      setLikes(0);
      setDislikes(0);
    }

    final userDoc = await FirebaseFirestore.instance
        .collection(FirebaseCollectionName.likesDislikes)
        .doc(videoId)
        .collection(FirebaseCollectionName.users)
        .doc(userId)
        .get();

    if (userDoc.exists) {
      final userData = userDoc.data()!;
      setLiked(userData[FirebaseFieldName.liked] ?? false);
      setDisliked(userData[FirebaseFieldName.disliked] ?? false);
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
        .collection(FirebaseCollectionName.favorites)
        .doc(userId)
        .collection(FirebaseCollectionName.videos)
        .doc(videoId);

    if (isFavorite) {
      await favoriteDocRef.set({
        FirebaseFieldName.isFavorite: true,
        FirebaseFieldName.videoId: videoId,
      }, SetOptions(merge: true));
    } else {
      await favoriteDocRef.delete();
    }
  }

  Future<int?> fetchRating({required String videoId}) async {
    final doc = await FirebaseFirestore.instance
        .collection(FirebaseCollectionName.favorites)
        .doc(userId)
        .collection(FirebaseCollectionName.videos)
        .doc(videoId)
        .get();

    return doc.exists && doc.data()?[FirebaseFieldName.rating] != null
        ? doc.data()![FirebaseFieldName.rating] as int
        : null;
  }

  Future<void> setRating({required String videoId, required int rating}) async {
    await FirebaseFirestore.instance
        .collection(FirebaseCollectionName.favorites)
        .doc(userId)
        .collection(FirebaseCollectionName.videos)
        .doc(videoId)
        .set({
      FirebaseFieldName.rating: rating,
    }, SetOptions(merge: true));
  }
}
