# Firebase 초보자 가이드

**대상:** Firebase를 처음 접하는 분.  
**목표:** “인증(Auth)”과 “푸시(FCM)”가 뭔지, “백엔드와 어떻게 연동하는지” 이해하는 것.

---

## 1. Firebase란?

- **Google**에서 제공하는 **BaaS**(Backend as a Service) 모음입니다.
- “서버를 직접 안 만들어도 되는 기능들”을 API·SDK로 쓸 수 있습니다.
- 이 프로젝트에서 쓰는 것:
  - **Firebase Authentication (Auth)** — 로그인·회원가입 (이메일, 소셜 등)
  - **Firebase Cloud Messaging (FCM)** — 푸시 알림 (예: 찜한 트럭 영업 시작)

---

## 2. Firebase Authentication (인증)

### 2.1 흐름 (감 잡기)

1. **앱(Flutter)** 에서 사용자가 로그인하면, Firebase Auth SDK가 **ID 토큰**을 만들어 줍니다.
2. 앱은 이 토큰을 **API 요청 시** `Authorization: Bearer <ID_TOKEN>` 헤더에 넣어 보냅니다.
3. **백엔드(NestJS)** 는 그 토큰을 **Firebase Admin SDK**로 검증합니다. 검증이 성공하면 “이 사용자는 누구다(uid)”를 알 수 있습니다.
4. 백엔드는 그 **uid**로 우리 DB의 **users** 테이블을 조회해 역할(사장님/일반) 등을 판단하고, API를 처리합니다.

### 2.2 백엔드에서 해야 할 것

- **Firebase Admin SDK** 설치 (서비스 계정 키 또는 키 파일 설정).
- 토큰 검증: `admin.auth().verifyIdToken(idToken)` → 성공 시 `decodedToken.uid` 사용.
- `.env` 에 `FIREBASE_PROJECT_ID`, `FIREBASE_CLIENT_EMAIL`, `FIREBASE_PRIVATE_KEY` 등 설정 (SETUP.md 참고).

### 2.3 “처음 접하는 분” 요약

- “로그인 화면·회원가입”은 **클라이언트(Firebase Auth SDK)** 가 처리합니다.
- 백엔드는 “토큰이 진짜인지 검사”하고, “그 사용자로 DB 조회·권한 체크”만 하면 됩니다.

---

## 3. Firebase Cloud Messaging (FCM, 푸시)

### 3.1 흐름 (감 잡기)

1. **앱**이 FCM SDK로 **디바이스 토큰**을 받아서, 우리 **백엔드**에 보냅니다. (예: `PATCH /users/me` 에 `fcm_token` 저장)
2. 백엔드는 “단골 트럭 영업 시작” 같은 **이벤트**가 발생하면, 그 트럭을 찜한 사용자들의 **fcm_token**을 DB에서 꺼냅니다.
3. **Firebase Admin SDK**의 `messaging().send()` (또는 멀티캐스트)로 해당 토큰들에 **푸시 메시지**를 보냅니다.
4. 사용자 기기에 알림이 뜹니다.

### 3.2 백엔드에서 해야 할 것

- 같은 Firebase 프로젝트의 **서비스 계정**으로 Admin SDK 초기화 (인증과 동일).
- 푸시 보낼 때: 사용자별 `fcm_token` + 메시지 payload를 FCM API에 전달.

### 3.3 “처음 접하는 분” 요약

- “푸시를 받는 앱 설정”은 **클라이언트(FCM SDK)** + **Firebase Console에서 앱 등록**이 필요합니다.
- 백엔드는 “언제 누구에게 보낼지”만 정하고, “실제 발송”은 FCM API(Admin SDK)에 맡깁니다.

---

## 4. 이 프로젝트에서의 사용

- **인증:** 모든 “사장님 전용·사용자 개인” API는 Bearer 토큰 검증 후 접근합니다. (Phase 2-1에서 구현)
- **푸시:** Phase 5-1에서 “단골 트럭 영업 시작 시 푸시” 구현 시 FCM 사용.
- **설정:** SETUP.md의 Firebase 프로젝트·키 준비, `.env` 항목을 참고하세요.

---

## 5. 참고 링크

- [Firebase 공식](https://firebase.google.com/)
- [Firebase Auth 문서](https://firebase.google.com/docs/auth)
- [FCM 문서](https://firebase.google.com/docs/cloud-messaging)
- [Firebase Admin SDK (Node)](https://firebase.google.com/docs/admin/setup)
