# 오류 내역 (Error Log)

발생한 오류·실패 원인·해결 방법을 별도로 기록합니다.

형식:
- **일시:** YYYY-MM-DD (또는 HH:mm)
- **상황:** 어떤 작업 중 발생했는지
- **증상/메시지:** 에러 메시지 또는 증상
- **원인:** (알게 된 원인)
- **해결:** (적용한 해결 방법)

---

## 기록 예시 (삭제 가능)

| 일시 | 상황 | 증상/메시지 | 원인 | 해결 |
|------|------|-------------|------|------|
| 2025-03-06 | 로컬 npm install | `npm이(가) 인식되지 않습니다` | Node.js 미설치 또는 PATH 미반영 | Node.js LTS 설치 후 터미널 재시작 |

---

## 오류 기록

| 일시 | 상황 | 증상/메시지 | 원인 | 해결 |
|------|------|-------------|------|------|
| 2026-03-23 | Android FCM 연동 검증 중 `flutter build apk --debug` 실행 | `[!] No Android SDK found. Try setting the ANDROID_HOME environment variable.` | 로컬 환경에 Android SDK가 설치/연결되지 않음 | Android Studio에서 SDK 설치 후 `flutter config --android-sdk <SDK 경로>` 또는 `ANDROID_HOME` 설정 예정 |
| 2026-03-23 | Android APK 빌드(`assembleDebug`) | `Could not find method jvmTarget() for arguments [17]` | Groovy Gradle 변환 후 Kotlin 옵션 대입 문법 불일치 | `android/app/build.gradle`에서 `jvmTarget = JavaVersion.VERSION_17.toString()`로 수정 |
| 2026-03-23 | Android APK 빌드(`assembleDebug`) | `Dart library 'dart:html' is not available on this platform.` | 웹 전용 Kakao 지도 코드가 Android 빌드 경로에 포함됨 | Kakao 지도 뷰를 web/stub 파일로 분리하고 조건부 import 적용 |
