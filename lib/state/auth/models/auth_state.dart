import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:stroke_master/typedef/user_id.dart';

import 'auth_result.dart';

part 'auth_state.freezed.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState({
    required AuthResult? result,
    required bool isLoading,
    required UserId? userId,
  }) = _AuthState;

  const AuthState._(); //private constructor for custom widgets

  factory AuthState.unknown() => const AuthState(
    result: null,
    isLoading: false,
    userId: null,
  );
}
