import 'dart:collection';

import 'package:flutter/foundation.dart' show immutable;
import 'package:stroke_master/state/constants/firebase_field_name.dart';
import 'package:stroke_master/typedef/user_id.dart';

@immutable
class UserInfoPayload extends MapView<String, String> {
  UserInfoPayload({
    required UserId userId,
    required String? displayName,
    required String? email,
  }) : super(
    {
      FirebaseFieldName.userId: userId,
      FirebaseFieldName.displayName: displayName ?? '',
      FirebaseFieldName.email: email ?? '',
    },
  );

  String get displayName => this[FirebaseFieldName.displayName] ?? '';
  String get email => this[FirebaseFieldName.email] ?? '';

  // Factory constructor to create UserInfoPayload from Firestore document
  factory UserInfoPayload.fromFirestore(Map<String, dynamic> firestoreData) {
    return UserInfoPayload(
      userId: firestoreData[FirebaseFieldName.userId] as String,
      displayName: firestoreData[FirebaseFieldName.displayName] as String?,
      email: firestoreData[FirebaseFieldName.email] as String?,
    );
  }
}
