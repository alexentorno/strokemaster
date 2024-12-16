import 'dart:convert';
import 'package:http/http.dart' as http;

class YouTubeService {
  final String apiKey = "AIzaSyAt16NfiYClTGw8ShMu5ewi5hy0NBTSK4Q";

  Future<List<dynamic>> fetchCanoeVideos() async {
    final String query = "sprint canoe warm-up";
    final url =
        "https://www.googleapis.com/youtube/v3/search?part=snippet&q=$query&type=video&key=$apiKey";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['items'];
    } else {
      throw Exception("Failed to load videos");
    }
  }
}
