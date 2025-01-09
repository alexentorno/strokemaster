import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:stroke_master/state/constants/firebase_collection_name.dart';
import 'package:stroke_master/state/constants/firebase_field_name.dart';
import '../models/video.dart';
import '../util/keys.dart';

class YouTubeApiService {
  static const String _baseUrl = 'https://www.googleapis.com/youtube/v3';
  static const String _apiKey = API_KEY;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Video>> fetchPlaylistVideos(String playlistId) async {
    final url = Uri.parse(
        '$_baseUrl/playlistItems?part=snippet&playlistId=$playlistId&key=$_apiKey&maxResults=20');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> items = data['items'];
      return items.map((item) => Video.fromJsonPlaylistItem(item)).toList();
    } else {
      throw Exception('Failed to load videos');
    }
  }

  Future<void> uploadVideosToFirestore(List<Video> videos) async {
    final videoCollection = _firestore.collection(FirebaseCollectionName.videos);

    final existingDocs = await videoCollection.get();
    final existingIds = existingDocs.docs.map((doc) => doc.id).toSet();

    final batch = _firestore.batch();

    for (var video in videos) {
      if (!existingIds.contains(video.id)) {
        final videoDoc = videoCollection.doc(video.id);

        batch.set(videoDoc, {
          FirebaseFieldName.id: video.id,
          FirebaseFieldName.name: video.name,
          FirebaseFieldName.thumbnailUrl: video.thumbnailUrl,
          FirebaseFieldName.where: video.where,
          FirebaseFieldName.difficulty: video.difficulty,
          FirebaseFieldName.likes: 0,
          FirebaseFieldName.dislikes: 0,
          FirebaseFieldName.isFavorite: false,
        });
      }
    }

    await batch.commit();
    print("Videos uploaded successfully!");
  }

  Future<List<Video>> fetchVideosWithPreferences(String userId) async {
    final videoCollection = _firestore.collection(FirebaseCollectionName.videos);
    final likedDislikedCollection = _firestore
        .collection(FirebaseCollectionName.users)
        .doc(userId)
        .collection(FirebaseCollectionName.likedDisliked);

    final videoSnapshot = await videoCollection.get();
    final likedDislikedSnapshot = await likedDislikedCollection.get();

    final likedDislikedMap = {
      for (var doc in likedDislikedSnapshot.docs)
        doc.id: doc.data(), // {liked: true/false, disliked: true/false}
    };

    return videoSnapshot.docs.map((doc) {
      final data = doc.data();
      final videoId = data[FirebaseFieldName.id];
      final userPreferences = likedDislikedMap[videoId] ?? {};

      return Video(
        id: data[FirebaseFieldName.id],
        name: data[FirebaseFieldName.name],
        thumbnailUrl: data[FirebaseFieldName.thumbnailUrl],
        where: data[FirebaseFieldName.where],
        difficulty: data[FirebaseFieldName.difficulty],
        isFavorite: data[FirebaseFieldName.isFavorite] ?? false,
        likes: data[FirebaseFieldName.likes] ?? 999,
        dislikes: data[FirebaseFieldName.dislikes] ?? 999,
        isLiked: userPreferences[FirebaseFieldName.liked] ?? false,
        isDisliked: userPreferences[FirebaseFieldName.disliked] ?? false,
      );
    }).toList();
  }
}
