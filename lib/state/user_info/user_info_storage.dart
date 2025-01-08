import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stroke_master/state/constants/firebase_collection_name.dart';
import 'package:stroke_master/state/constants/firebase_field_name.dart';
import 'package:stroke_master/state/user_info/models/user_info_payload.dart';
import 'package:stroke_master/typedef/user_id.dart';

class UserInfoStorage {
  const UserInfoStorage();

  Future<bool> saveOrUpdateUserInfo(
      { required UserId userId,
        String? displayName,
        String? email,
        String? fcmToken
      }) async {
    try {
      var userInfo = await FirebaseFirestore.instance
          .collection(FirebaseCollectionName.users)
          .where(FirebaseFieldName.userId, isEqualTo: userId)
          .limit(1)
          .get();


      if (userInfo.docs.isNotEmpty) {
        Map<String, dynamic> updatedData = {};

        if (displayName != null) {
          updatedData[FirebaseFieldName.displayName] = displayName;
        }
        if (email != null) {
          updatedData[FirebaseFieldName.email] = email;
        }
        if (fcmToken != null) {
          updatedData[FirebaseFieldName.fcmToken] = fcmToken;
        }

        if (updatedData.isNotEmpty) {
          await userInfo.docs.first.reference.update(updatedData);
        }

        return true;
      }

      final payload = UserInfoPayload(
          userId: userId, displayName: displayName, email: email, fcmToken: fcmToken);

      await FirebaseFirestore.instance
          .collection(FirebaseCollectionName.users)
          .add(payload);

      return true;
    } catch (e) {
      // throw Exception('Failed to save user info: $e');
      return false;
    }
  }

  Future<UserInfoPayload?> getUserInfo(String userId) async {
    try {
      var userInfo = await FirebaseFirestore.instance
          .collection(FirebaseCollectionName.users)
          .where(FirebaseFieldName.userId, isEqualTo: userId)
          .limit(1)
          .get();

      if (userInfo.docs.isNotEmpty) {
        final doc = userInfo.docs.first;
        return UserInfoPayload.fromFirestore(doc.data());
      } else {
        return null;
      }
    } catch (e) {
      throw Exception('Failed to get user info: $e');
    }
  }

}
