# Flutter 초보자 가이드

**대상:** Flutter(및 Dart)를 처음 접하는 분.  
**목표:** “Flutter가 뭔지”, “화면·위젯·상태”가 어떻게 구성되는지 이해하는 것.

---

## 1. Flutter란?

- **Google**에서 만든 **크로스 플랫폼** 모바일(및 웹·데스크톱) 앱 프레임워크입니다.
- **한 코드베이스**로 **iOS**와 **Android** 앱을 동시에 만들 수 있습니다.
- **Dart**라는 언어로 작성합니다. (문법이 Java/JavaScript와 비슷해 익히기 수월한 편입니다.)
- UI는 **위젯(Widget)** 을 조합해서 만듭니다. “Everything is a widget”이 Flutter의 핵심 문장입니다.

---

## 2. Dart 맛보기 (처음 보는 분용)

- **변수:** `var`, `String`, `int`, `bool` 등. 타입을 생략하면 `var name = '홍길동';` 처럼 쓸 수 있습니다.
- **함수:** `void main() { }`, `int add(int a, int b) => a + b;` 처럼 선언합니다.
- **클래스:** 다른 언어와 비슷하게 `class Truck { ... }` 로 정의하고, `Truck()` 로 생성합니다.
- **비동기:** `Future`, `async`/`await` 로 API 호출 같은 비동기 작업을 처리합니다.
- **null 안전성:** Dart 3에서는 `?`, `!` 로 null 가능 여부를 표시합니다.

```dart
Future<List<Truck>> fetchTrucks() async {
  final response = await http.get(Uri.parse('http://localhost:3000/trucks'));
  return (jsonDecode(response.body) as List).map((e) => Truck.fromJson(e)).toList();
}
```

---

## 3. Flutter 핵심 개념 (처음 보는 분용)

### 3.1 위젯 (Widget)

- 화면에 보이는 **모든 것**이 위젯입니다. 버튼, 텍스트, 리스트, 레이아웃(Column, Row)까지.
- **위젯은 불변(immutable)** 입니다. 값을 바꾸려면 **새 위젯**을 만들어서 다시 그립니다.
- **StatelessWidget:** 자신만의 상태가 없음. 전달받은 데이터만 표시.
- **StatefulWidget:** 상태(state)를 갖고, 상태가 바뀌면 `setState()` 로 다시 그리기.

### 3.2 위젯 트리

- 화면은 **위젯이 중첩된 트리**로 표현됩니다.
- 예: `MaterialApp` → `Scaffold` → `Column` → `Text`, `ElevatedButton` …
- 레이아웃 위젯: **Column**(세로 배치), **Row**(가로 배치), **Stack**(겹치기), **ListView**(스크롤 목록) 등.

### 3.3 상태 관리

- “데이터가 바뀌면 화면이 갱신된다”를 구현하는 방법이 **상태 관리**입니다.
- 작은 앱: **StatefulWidget**의 `setState()` 만으로도 가능.
- 규모가 커지면: **Provider**, **Riverpod**, **Bloc** 등의 패키지를 쓰는 경우가 많습니다.
- 이 프로젝트는 아직 Flutter 앱 구조가 단순하므로, 우선 `setState` 정도만 알아도 됩니다.

### 3.4 화면 이동 (네비게이션)

- **Navigator**로 화면을 “스택”처럼 쌓았다가 뒤로 가기 합니다.
- `Navigator.push()` → 새 화면, `Navigator.pop()` → 이전 화면.

---

## 4. 이 프로젝트에서의 사용

- **frontend/mobile-flutter** 가 Flutter 앱 폴더입니다.
- **운영 관리자 프로그램도 Flutter Web로 개발**하여 모바일 앱과 동일 기술 스택을 재사용합니다.
- **지도:** Google Maps / Kakao Map API 연동으로 “주변 트럭”을 지도에 표시합니다.
- **API 호출:** REST API는 **http** 패키지나 **dio** 등으로 `GET`/`POST` 하고, **shared/api-spec/rest-api.md** 스펙을 따릅니다.
- **실시간:** Socket.io 클라이언트 패키지로 **shared/api-spec/realtime-events.md** 의 이벤트를 구독·발행합니다.
- **인증:** Firebase Auth SDK로 로그인 후, 받은 **ID 토큰**을 API 요청 헤더에 넣어 보냅니다.

---

## 5. 실행·개발 환경

- **Flutter SDK** 설치 후 `flutter doctor` 로 환경 점검.
- `flutter pub get` → 의존성 설치 (package.json의 `npm install`과 비슷).
- `flutter run` → 연결된 기기 또는 에뮬레이터에서 앱 실행.
- SETUP.md에 Flutter 설치 링크가 있습니다.

---

## 6. 참고 링크

- [Flutter 공식](https://flutter.dev/)
- [Dart 언어 투어](https://dart.dev/guides/language/language-tour)
- [Flutter 위젯 카탈로그](https://docs.flutter.dev/ui/widgets)
