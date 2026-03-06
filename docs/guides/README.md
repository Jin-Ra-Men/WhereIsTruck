# WhereIsTruck 기술 스택 가이드

이 프로젝트에서 사용하는 **주요 기술**을, 해당 기술을 **처음 접하는 사람**도 이해할 수 있도록 정리한 가이드입니다.  
각 문서는 “이게 뭔지”, “왜 쓰는지”, “기본 사용법” 위주로 구성되어 있습니다.

---

## 프로젝트에서 쓰는 기술 요약

| 분류 | 기술 | 역할 |
|------|------|------|
| 백엔드 런타임 | **Node.js** | JavaScript를 서버에서 실행 |
| 백엔드 프레임워크 | **NestJS** | REST API·실시간 서버 구조화 |
| ORM | **TypeORM** | DB 테이블 ↔ 객체 매핑 |
| DB | **PostgreSQL** | 관계형 DB |
| 공간 데이터 | **PostGIS** | 위도·경도·반경 검색 |
| 실시간 통신 | **Socket.io** | 영업 시작/위치 등 실시간 이벤트 |
| 인증·푸시 | **Firebase** | 로그인, 푸시 알림(FCM) |
| 모바일 앱 | **Flutter** | iOS/Android 앱 (Dart) |
| 지도 | Map API (Google / Kakao) | 지도·좌표 (키 설정만, 별도 가이드 없음) |

---

## 가이드 목록

| 문서 | 대상 | 내용 |
|------|------|------|
| [NODEJS-GUIDE.md](./NODEJS-GUIDE.md) | Node.js를 처음 쓰는 분 | Node.js란, npm, 모듈, 비동기 개념 |
| [NESTJS-GUIDE.md](./NESTJS-GUIDE.md) | NestJS를 처음 쓰는 분 | 모듈·컨트롤러·서비스·의존성 주입 |
| [TYPEORM-GUIDE.md](./TYPEORM-GUIDE.md) | TypeORM을 처음 쓰는 분 | 엔티티·Repository·쿼리 기본 |
| [POSTGRES-GUIDE.md](./POSTGRES-GUIDE.md) | PostgreSQL·PostGIS 초보 | DB·스키마·PostGIS·공간 쿼리 |
| [SOCKETIO-GUIDE.md](./SOCKETIO-GUIDE.md) | Socket.io를 처음 쓰는 분 | 이벤트·방·클라이언트/서버 역할 |
| [FIREBASE-GUIDE.md](./FIREBASE-GUIDE.md) | Firebase를 처음 쓰는 분 | Auth·FCM 개념과 백엔드 연동 |
| [FLUTTER-GUIDE.md](./FLUTTER-GUIDE.md) | Flutter를 처음 쓰는 분 | Dart·위젯·화면·API 호출 기본 |

---

## 읽는 순서 (권장)

1. **백엔드부터 볼 때:** Node.js → NestJS → TypeORM → (선택) Postgres 가이드  
2. **DB부터 볼 때:** Postgres 가이드 → TypeORM  
3. **모바일부터 볼 때:** Flutter 가이드 → Firebase 가이드  
4. **실시간 기능:** Socket.io 가이드

필요한 것만 골라서 읽어도 됩니다.
