import 'package:firebase_auth/firebase_auth.dart';
import 'package:stroke_master/state/auth/models/auth_result.dart';
import 'package:stroke_master/typedef/user_id.dart';


class Authenticator {
  const Authenticator();

  UserId? get userId => FirebaseAuth.instance.currentUser?.uid;
  String? get email => FirebaseAuth.instance.currentUser?.email;
  String? get displayName => FirebaseAuth.instance.currentUser?.displayName;

  bool get isAlreadyLoggedIn => userId != null;

  Future<void> logOut() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<AuthResult> loginWithEmailAndPassword(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return AuthResult.success;
    } catch (e) {
      print('Error loggong in: $e');
      return AuthResult.failure;
    }
  }

  Future<AuthResult> registerWithEmailAndPassword(String email, String password,) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      return AuthResult.success;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        return AuthResult.userAlreadyExists;
      }
      return AuthResult.failure;
    } catch (e) {
      return AuthResult.failure;
    }
  }
}
