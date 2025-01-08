import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:stroke_master/state/auth/backend/authenticator.dart';
import 'package:stroke_master/state/user_info/user_info_storage.dart';

class PushNotificationService {
  static final PushNotificationService _instance =
  PushNotificationService._internal();

  factory PushNotificationService() => _instance;

  PushNotificationService._internal();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final Authenticator _authenticator = const Authenticator();
  final UserInfoStorage _userInfoStorage = const UserInfoStorage();

  Future<String?> getFcmToken() async => await _firebaseMessaging.getToken();

  Future<void> initialize() async {

    _firebaseMessaging.setAutoInitEnabled(false);

    try {
      final settings = await _firebaseMessaging.requestPermission();

      switch (settings.authorizationStatus) {
        case AuthorizationStatus.authorized:
          print('User granted push notification permissions.');
          break;
        case AuthorizationStatus.provisional:
          print('User granted provisional push notification permissions.');
          break;
        case AuthorizationStatus.denied:
          print('User denied push notification permissions.');
          return;
        default:
          print('Unknown authorization status.');
          return;
      }

      final token = await getFcmToken();
      print('FCM Token: $token');

      final userId = _authenticator.userId;
      if (token != null && userId != null) {
        await _userInfoStorage.saveOrUpdateUserInfo(userId: userId, fcmToken: token);

        // Listen for token refresh
        _firebaseMessaging.onTokenRefresh.listen((newToken) async {
          await _userInfoStorage.saveOrUpdateUserInfo(userId: userId, fcmToken: newToken);
        });
      }

      // Handle initial message and foreground/background scenarios
      final initialMessage = await _firebaseMessaging.getInitialMessage();
      if (initialMessage != null) {
        _handleMessage(initialMessage, 'App opened from TERMINATED state');
      }

      FirebaseMessaging.onMessage.listen((message) {
        _handleMessage(message, 'Notification received in FOREGROUND');
      });

      FirebaseMessaging.onMessageOpenedApp.listen((message) {
        _handleMessage(message, 'App opened from BACKGROUND');
      });
    } catch (e) {
      print('Error initializing push notifications: $e');
    }
  }

  // Just for logging purposes
  void _handleMessage(RemoteMessage message, String context) {
    print('[$context]');
    print('Title: ${message.notification?.title}');
    print('Body: ${message.notification?.body}');
    print('Data: ${message.data}');
  }
}
