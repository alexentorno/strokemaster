import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stroke_master/state/auth/backend/authenticator.dart';
import 'package:stroke_master/state/auth/models/auth_result.dart';
import 'package:stroke_master/state/auth/models/auth_state.dart';
import 'package:stroke_master/state/user_info/user_info_storage.dart';

part 'authentication_provider.g.dart';

@riverpod
class Authentication extends _$Authentication {
  final _authenticator = const Authenticator();
  final _userInfoStorage = const UserInfoStorage();

  @override
  AuthState build() {
    if (_authenticator.isAlreadyLoggedIn) {
      // Fetch user info from Firestore
      final userId = _authenticator.userId;
      print('User ID: $userId');
      if (userId != null) {
        _loadUserInfo(userId);
      }
      return AuthState(
        result: AuthResult.success,
        isLoading: true, // Temporarily loading while fetching user info
        userId: _authenticator.userId,
        email: _authenticator.email,
        displayName: null, // Placeholder until Firestore fetch completes
      );
    }
    return AuthState.unknown();
  }

  Future<void> _loadUserInfo(String userId) async {
    final userInfo = await _userInfoStorage.getUserInfo(userId);
    if (userInfo != null) {
      state = state.copyWith(
        displayName: userInfo.displayName,
        email: userInfo.email,
        isLoading: false,
      );
    } else {
      state = state.copyWith(isLoading: false); // No user info found
    }
  }

  Future<void> loginWithEmailAndPassword(String email, String password) async {
    state = state.copyWith(isLoading: true);

    // Simulate a network request on slow environments
    // await Future.delayed(const Duration(seconds: 3));

    final result = await _authenticator.loginWithEmailAndPassword(email, password);

    state = AuthState(
      result: result,
      isLoading: false,
      userId: _authenticator.userId,
      email: _authenticator.email,
      displayName: _authenticator.displayName,
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
      saveUserInfo(userId, email, name);
    }

    state = AuthState(
      result: result,
      isLoading: false,
      userId: _authenticator.userId,
      email: _authenticator.email,
      displayName: _authenticator.displayName,
    );
  }

  Future<void> saveUserInfo(String userId, String email, String name) {
    return _userInfoStorage.saveUserInfo(
      userId: userId,
      displayName: name,
      email: email,
    );
  }
}
