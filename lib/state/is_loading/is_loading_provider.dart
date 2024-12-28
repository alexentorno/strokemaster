import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stroke_master/state/auth/providers/authentication_provider.dart';

part 'is_loading_provider.g.dart';

@riverpod
bool isLoading(Ref ref) {
  final authProvider = ref.watch(authenticationProvider);
  return authProvider.isLoading;
}
