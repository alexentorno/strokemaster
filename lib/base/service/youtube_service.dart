import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/video.dart';
import '../util/keys.dart';


class YouTubeApiService {
  static const String _baseUrl = 'https://www.googleapis.com/youtube/v3';
  static const String _apiKey = API_KEY;

  Future<List<Video>> fetchPlaylistVideos(String playlistId) async {
    final url = Uri.parse('$_baseUrl/playlistItems?part=snippet&playlistId=$playlistId&key=$_apiKey&maxResults=10');
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


