import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stroke_master/state/auth/providers/authentication_provider.dart';
import 'package:stroke_master/typedef/user_id.dart';

part 'user_id_provider.g.dart';

@riverpod
UserId? userId(Ref ref) {
  return ref.watch(authenticationProvider).userId;
}

//Same as UserId? userId(Ref ref) => ref.watch(authenticationProvider).userId;