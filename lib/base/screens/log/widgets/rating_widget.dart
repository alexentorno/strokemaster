import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RatingWidget extends StatefulWidget {
  final String videoId;
  final String userId;

  const RatingWidget({super.key, required this.videoId, required this.userId});

  @override
  _RatingWidgetState createState() => _RatingWidgetState();
}

class _RatingWidgetState extends State<RatingWidget> {
  int _rating = 0;

  @override
  void initState() {
    super.initState();
    _fetchRating();
  }

  Future<void> _fetchRating() async {
    final doc = await FirebaseFirestore.instance
        .collection('favorites')
        .doc(widget.userId)
        .collection('videos')
        .doc(widget.videoId)
        .get();

    if (doc.exists && doc.data()?['rating'] != null) {
      setState(() {
        _rating = doc.data()!['rating'];
      });
    }
  }

  Future<void> _setRating(int newRating) async {
    setState(() {
      _rating = newRating;
    });

    await FirebaseFirestore.instance
        .collection('favorites')
        .doc(widget.userId)
        .collection('videos')
        .doc(widget.videoId)
        .set({
      'rating': newRating,
    }, SetOptions(merge: true));
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
