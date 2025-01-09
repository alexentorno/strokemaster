import 'package:flutter/foundation.dart' show immutable;

@immutable
class FirebaseFieldName {
  static const userId = 'uid';
  static const displayName = 'display_name';
  static const email = 'email';
  static const fcmToken = 'fcm_token';
  static const id = 'id';
  static const liked = 'liked';
  static const disliked = 'disliked';
  static const timestamp = 'timestamp';
  static const likes = 'likes';
  static const dislikes = 'dislikes';
  static const isFavorite = 'isFavorite';
  static const rating = 'rating';
  static const videoId = 'videoId';
  static const name = 'name';
  static const thumbnailUrl = 'thumbnailUrl';
  static const where = 'where';
  static const difficulty = 'difficulty';

  const FirebaseFieldName._();
}
