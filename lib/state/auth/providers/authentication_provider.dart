
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stroke_master/state/auth/backend/authenticator.dart';
import 'package:stroke_master/state/auth/models/auth_result.dart';
import 'package:stroke_master/state/auth/models/auth_state.dart';

part 'authentication_provider.g.dart';

@riverpod
class Authentication extends _$Authentication {
  final _authenticator = const Authenticator();
  // final _userInfoStorage = const UserInfoStorage();

  @override
  AuthState build() {
    if (_authenticator.isAlreadyLoggedIn) {
      return AuthState(
        result: AuthResult.success,
        isLoading: false,
        userId: _authenticator.userId,
      );
    }
    return AuthState.unknown();
  }

  Future<void> loginWithEmailAndPassword(String email, String password) async {
    state = state.copyWith(isLoading: true);

    // Simulate a network request on slow environments
    await Future.delayed(const Duration(seconds: 3));

    final result = await _authenticator.loginWithEmailAndPassword(email, password);

    state = AuthState(
      result: result,
      isLoading: false,
      userId: _authenticator.userId,
    );
  }

  Future<void> logOut() async {
    await _authenticator.logOut();
    state = AuthState.unknown();
  }

  Future<void> registerWithEmailAndPassword({required String name, required String email, required String password}) async {
    state = state.copyWith(isLoading: true);

    final result = await _authenticator
        .registerWithEmailAndPassword(email, password);

    final userId = _authenticator.userId;

    if (result == AuthResult.success && userId != null) {
      // saveUserInfo(userId, email, name);
    }

    state = AuthState(
      result: result,
      isLoading: false,
      userId: _authenticator.userId,
    );
  }

  // Future<void> saveUserInfo(String userId, String email, String name) {
  //   return _userInfoStorage.saveUserInfo(
  //     userId: userId,
  //     displayName: name,
  //     email: email,
  //   );
  // }
}
