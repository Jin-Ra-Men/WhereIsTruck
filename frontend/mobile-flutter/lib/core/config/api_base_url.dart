class ApiBaseUrl {
  ApiBaseUrl._();

  /// 빌드/실행 시 `--dart-define=API_BASE_URL=...`로 주입할 수 있습니다.
  static const String _fromDefine = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:3000',
  );

  static String get value => _fromDefine;
}

