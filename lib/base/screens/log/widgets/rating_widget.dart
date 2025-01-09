import 'package:flutter/material.dart';
import 'package:stroke_master/base/service/firestore_video_service.dart';

class RatingWidget extends StatefulWidget {
  final String videoId;
  final String userId;

  const RatingWidget({
    super.key,
    required this.videoId,
    required this.userId,
  });

  @override
  _RatingWidgetState createState() => _RatingWidgetState();
}

class _RatingWidgetState extends State<RatingWidget> {
  late int _rating;
  late VideoService _videoService;

  @override
  void initState() {
    super.initState();
    _rating = 0;
    _videoService = VideoService(userId: widget.userId);
    _fetchRating();
  }

  Future<void> _fetchRating() async {
    final rating = await _videoService.fetchRating(videoId: widget.videoId);
    setState(() {
      _rating = rating ?? 0;
    });
  }

  Future<void> _setRating(int newRating) async {
    setState(() {
      _rating = newRating;
    });
    await _videoService.setRating(videoId: widget.videoId, rating: newRating);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return IconButton(
          icon: Icon(
            index < _rating ? Icons.star : Icons.star_border,
            color: Colors.amber,
          ),
          onPressed: () {
            _setRating(index + 1);
          },
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        );
      }),
    );
  }
}
