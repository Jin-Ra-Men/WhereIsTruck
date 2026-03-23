import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../config/api_base_url.dart';

class FcmRegistrationService {
  FcmRegistrationService._();

  static Future<void> initializeForAndroidAndRegisterToken() async {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) {
      return;
    }

    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp();
    }

    final auth = FirebaseAuth.instance;
    if (auth.currentUser == null) {
      // 로그인 기능 연동 전까지는 익명 로그인으로 Firebase ID 토큰을 확보합니다.
      await auth.signInAnonymously();
    }

    final messaging = FirebaseMessaging.instance;
    await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    final token = await messaging.getToken();
    await _registerTokenToBackend(token);

    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
      await _registerTokenToBackend(newToken);
    });
  }

  static Future<void> _registerTokenToBackend(String? fcmToken) async {
    if (fcmToken == null || fcmToken.isEmpty) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final idToken = await user.getIdToken();
    if (idToken == null || idToken.isEmpty) return;

    final uri = Uri.parse('${ApiBaseUrl.value}/users/me');
    final response = await http.patch(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $idToken',
      },
      body: jsonEncode({
        'fcm_token': fcmToken,
      }),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      debugPrint(
        'FCM 토큰 등록 실패: ${response.statusCode} ${response.body}',
      );
    }
  }
}

