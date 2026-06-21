import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'api_service.dart';

class NotificationService {
  static Future<void> init() async {
    if (kIsWeb) return;
    try {
      await Firebase.initializeApp();
      await _requestPermission();
      _onMessageListener();
    } catch (e) {
      print('FCM init error: $e');
    }
  }

  static Future<void> _requestPermission() async {
    try {
      final messaging = FirebaseMessaging.instance;
      await messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
    } catch (_) {}
  }

  static Future<String?> getToken() async {
    if (kIsWeb) return null;
    try {
      return await FirebaseMessaging.instance.getToken();
    } catch (_) {
      return null;
    }
  }

  static Future<void> registerToken(String userIdentifier) async {
    if (kIsWeb) return;
    final token = await getToken();
    if (token != null) {
      await ApiService.registerFcmToken(userIdentifier, token);
    }
  }

  static void _onMessageListener() {
    if (kIsWeb) return;
    FirebaseMessaging.onMessage.listen((message) {
      print('FCM message: ${message.notification?.title}');
    });
  }
}
