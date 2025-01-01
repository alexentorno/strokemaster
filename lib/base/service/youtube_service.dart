/*
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/video.dart';
import '../util/keys.dart';


class YouTubeApiService {
  static const String _baseUrl = 'https://www.googleapis.com/youtube/v3';
  static const String _apiKey = API_KEY;

  Future<List<Video>> fetchPlaylistVideos(String playlistId) async {
    final url = Uri.parse('$_baseUrl/playlistItems?part=snippet&playlistId=$playlistId&key=$_apiKey&maxResults=20');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> items = data['items'];
      return items.map((item) => Video.fromJsonPlaylistItem(item)).toList();
    } else {
      throw Exception('Failed to load videos');
    }
  }

  Future<List<Video>> fetchVideos(String query) async {
    final url = Uri.parse('$_baseUrl/search?part=snippet&q=$query&key=$_apiKey&type=video&maxResults=10');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> items = data['items'];
      return items.map((item) => Video.fromJsonSearchVideos(item)).toList();
    } else {
      throw Exception('Failed to load videos');
    }
  }
}


*/

import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
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
    final videoCollection = _firestore.collection('videos');

    final existingDocs = await videoCollection.get();
    final existingIds = existingDocs.docs.map((doc) => doc.id).toSet();

    final batch = _firestore.batch();

    for (var video in videos) {
      if (!existingIds.contains(video.id)) {
        final videoDoc = videoCollection.doc(video.id);

        batch.set(videoDoc, {
          'id': video.id,
          'name': video.name,
          'thumbnailUrl': video.thumbnailUrl,
          'where': video.where,
          'difficulty': video.difficulty,
          'likes': 0,
          'dislikes': 0,
          'isFavorite': false,
        });
      }
    }

    await batch.commit();
    print("Videos uploaded successfully!");
  }


  Future<List<Video>> fetchVideosWithPreferences(String userId) async {
    final videoCollection = _firestore.collection('videos');
    final likedDislikedCollection = _firestore.collection('users').doc(userId).collection('likedDisliked');

    final videoSnapshot = await videoCollection.get();
    final likedDislikedSnapshot = await likedDislikedCollection.get();

    final likedDislikedMap = {
      for (var doc in likedDislikedSnapshot.docs)
        doc.id: doc.data(), // {liked: true/false, disliked: true/false}
    };

    return videoSnapshot.docs.map((doc) {
      final data = doc.data();
      final videoId = data['id'];
      final userPreferences = likedDislikedMap[videoId] ?? {};

      return Video(
        id: data['id'],
        name: data['name'],
        thumbnailUrl: data['thumbnailUrl'],
        where: data['where'],
        difficulty: data['difficulty'],
        isFavorite: data['isFavorite'] ?? false,
        likes: data['likes'] ?? 999,
        dislikes: data['dislikes'] ?? 999,
        isLiked: userPreferences['liked'] ?? false,
        isDisliked: userPreferences['disliked'] ?? false,
      );
    }).toList();
  }

}
