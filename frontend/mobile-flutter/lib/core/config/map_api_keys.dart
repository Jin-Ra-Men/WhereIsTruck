import 'package:flutter/foundation.dart';

/// 맵 키를 플랫폼별로 선택하기 위한 헬퍼입니다.
///
/// 주의:
/// - Flutter는 루트 `.env`를 자동으로 읽지 않습니다.
/// - 따라서 `flutter run` 시 `--dart-define=...` 또는
///   `--dart-define-from-file=<path>`(가능할 경우)로 값을 주입해야 합니다.
class MapApiKeys {
  MapApiKeys._();

  static const String _mapApiKey = String.fromEnvironment('MAP_API_KEY', defaultValue: '');
  static const String _kakaoJsApiKey = String.fromEnvironment('KAKAO_JS_API_KEY', defaultValue: '');
  static const String _kakaoRestApiKey = String.fromEnvironment('KAKAO_REST_API_KEY', defaultValue: '');
  static const String _kakaoNativeAppKey = String.fromEnvironment(
    'KAKAO_NATIVE_APP_KEY',
    defaultValue: '',
  );

  /// 웹이면 JavaScript 키, 모바일이면 native app 키를 우선으로 사용합니다.
  /// (없으면 기존 `MAP_API_KEY`로 폴백)
  static String get kakaoMapKeyForCurrentPlatform {
    if (kIsWeb) {
      return _kakaoJsApiKey.isNotEmpty ? _kakaoJsApiKey : _mapApiKey;
    }
    return _kakaoNativeAppKey.isNotEmpty ? _kakaoNativeAppKey : _mapApiKey;
  }

  /// REST 키가 필요한 경우를 대비한 getter입니다(서버/서버대행 로직에서 주로 사용).
  static String get kakaoRestApiKey => _kakaoRestApiKey.isNotEmpty ? _kakaoRestApiKey : _mapApiKey;
}

