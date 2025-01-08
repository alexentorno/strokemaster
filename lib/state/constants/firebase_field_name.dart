import 'package:flutter/foundation.dart' show immutable;

@immutable
class FirebaseFieldName {
  static const userId = 'uid';
  static const displayName = 'display_name';
  static const email = 'email';
  static const fcmToken = 'fcm_token';

  const FirebaseFieldName._();
}
