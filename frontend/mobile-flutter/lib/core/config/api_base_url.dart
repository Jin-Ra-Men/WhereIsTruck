import 'package:flutter/foundation.dart';

class ApiBaseUrl {
  ApiBaseUrl._();

  /// 빌드/실행 시 `--dart-define=API_BASE_URL=...`로 주입할 수 있습니다.
  static const String _fromDefine = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: '',
  );

  static String get value {
    if (_fromDefine.isNotEmpty) {
      return _fromDefine;
    }

    // Android 에뮬레이터에서는 호스트 PC localhost를 10.0.2.2로 접근합니다.
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:3000';
    }

    return 'http://localhost:3000';
  }
}

