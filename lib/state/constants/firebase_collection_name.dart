import 'package:flutter/foundation.dart';

@immutable
class FirebaseCollectionName {
  static const users = 'users';
  static const likesDislikes = 'likesDislikes';
  static const videos = 'videos';
  static const favorites = 'favorites';
  static const likedDisliked = 'likedDisliked';

  const FirebaseCollectionName._();
}
