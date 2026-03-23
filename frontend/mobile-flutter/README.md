# where_is_truck_mobile

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## 관리자 웹 UI(Phase 4-10) 시작점

- 엔트리: `lib/main.dart`
- 화면: `lib/features/admin/ui/admin_dashboard_page.dart`
- API 클라이언트: `lib/features/admin/data/admin_api_client.dart`

### 실행 순서 (로컬)

1. 이 폴더에서 `flutter pub get`
2. `flutter run -d chrome`

관리자 토큰은 `admin_dashboard_page.dart`의 `bearerToken` 값을 실제 Firebase ID 토큰으로 교체해 테스트합니다.

## Kakao Map 키(플랫폼별) 설정

Flutter는 루트 `.env`를 자동으로 읽지 않으므로, `flutter run` 시 값을 주입해야 합니다.

- 웹(Chrome): `--dart-define=KAKAO_JS_API_KEY=...`
- Android/iOS: `--dart-define=KAKAO_NATIVE_APP_KEY=...`

키 선택 로직은 `lib/core/config/map_api_keys.dart`의 `MapApiKeys.kakaoMapKeyForCurrentPlatform`을 사용하세요.
