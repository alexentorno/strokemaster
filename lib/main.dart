import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stroke_master/base/models/video.dart';
import 'package:stroke_master/base/service/push_notification_service.dart';
import 'package:stroke_master/base/service/youtube_service.dart';
import 'package:stroke_master/base/util/app_routes.dart';
import 'package:stroke_master/firebase_options.dart';

import 'theme/theme_notifier.dart';

void fetchAndUploadVideos() async {
  final apiService = YouTubeApiService();

  try {
    // Fetch videos from multiple playlists.
    List<Video> videos = [];
    videos.addAll(await apiService.fetchPlaylistVideos('PLQujqPRf2C8OLp4acePQ67upU14NfwbQN'));
    videos.addAll(await apiService.fetchPlaylistVideos('PLQujqPRf2C8MWZkZ9N24b8UwhZijF3QN2'));
    videos.addAll(await apiService.fetchPlaylistVideos('PLU8uVkF9zP5T8LCIBzXDPcFWpJ163nOGK'));

    // Upload videos to Firestore.
    await apiService.uploadVideosToFirestore(videos);
  } catch (e) {
    print("Error occurred: $e");
  }
}


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  fetchAndUploadVideos();
  runApp(const ProviderScope(child: MyApp()));
}

final themeNotifierProvider = ChangeNotifierProvider((ref) => ThemeNotifier()..init());

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    super.initState();
    print("Initializing push notifications");
    PushNotificationService().initialize();
  }

  @override
  Widget build(BuildContext context) {
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
