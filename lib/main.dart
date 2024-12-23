import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:stroke_master/base/bottom_nav_bar.dart';
import 'package:stroke_master/base/screens/start_screen.dart';
import 'package:stroke_master/base/util/app_routes.dart';
import 'package:stroke_master/firebase_options.dart';
import 'package:stroke_master/state/auth/providers/is_logged_in_provider.dart';
import 'base/screens/login/login_screen.dart';
import 'theme/theme_notifier.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
}

// Define a provider for ThemeNotifier
final themeNotifierProvider = ChangeNotifierProvider((ref) => ThemeNotifier()..init());

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeNotifier = ref.watch(themeNotifierProvider);

    return MaterialApp.router(
      routerConfig: router,
      title: "StrokeMaster",
      themeMode: themeNotifier.isDark ? ThemeMode.dark : ThemeMode.light,
      darkTheme: themeNotifier.darkTheme,
      theme: themeNotifier.lightTheme,
      debugShowCheckedModeBanner: false,
    );
  }
}
