# 변경 이력 (Changelog)

WhereIsTruck 프로젝트의 변경 사항을 상세히 기록합니다.

형식: **날짜(YYYY-MM-DD)** | **변경 범위(파일/디렉터리)** | **변경 내용 요약**

---

## [Unreleased]

### Added
- 2026-03-07 `frontend/mobile-flutter/lib/main.dart`, `frontend/mobile-flutter/lib/features/admin/` — Flutter Web 관리자 UI 기본 화면/모델/API 클라이언트 구현 (계정·트럭 관리, 감사로그 조회)
- 2026-03-23 `frontend/mobile-flutter/lib/core/config/api_base_url.dart` — REST API Base URL 주입 헬퍼 추가
- 2026-03-23 `frontend/mobile-flutter/lib/features/nearby_trucks/` — `GET /locations/nearby` 기반 주변 트럭 조회 API 클라이언트/모델/UI 추가(지도 마커 연동은 다음 단계 보류)
- 2026-03-23 `frontend/mobile-flutter/lib/features/trucks/models/truck_models.dart` — 트럭 상세 응답 모델 추가
- 2026-03-23 `frontend/mobile-flutter/lib/features/trucks/data/trucks_api_client.dart` — `GET /trucks/:id` 트럭 상세 API 클라이언트 추가
- 2026-03-23 `frontend/mobile-flutter/lib/features/trucks/ui/truck_detail_page.dart` — 트럭 상세/메뉴/사진 화면(cover_image_url, menu_summary) 추가
- 2026-03-23 `frontend/mobile-flutter/lib/core/firebase/fcm_registration_service.dart` — Android FCM 토큰 발급/갱신 및 백엔드(`/users/me`) 등록 서비스 추가
- 2026-03-07 `backend/nest/src/modules/admin/` — 관리자 API 모듈 추가 (`/admin/users`, `/admin/owners`, `/admin/trucks`, `/admin/audit-logs`)
- 2026-03-07 `backend/nest/src/common/guards/admin-role.guard.ts` — admin role 전용 접근 제어 가드 추가
- 2026-03-07 `backend/nest/src/entities/audit-log.entity.ts` — 운영 감사 로그 엔티티 추가
- 2026-03-07 `scripts/migrations/003_admin_rbac_and_audit_logs.sql` — 관리자 RBAC(`users.role`에 `admin`) 및 `audit_logs` 테이블 생성 마이그레이션 추가
- 2026-03-07 `backend/nest/src/modules/realtime/realtime.gateway.ts` — Socket.io 실시간 서버 구현 (`truck:open/close/location/stock_update`, 브로드캐스트 이벤트)
- 2026-03-07 `docs/REALTIME-CLIENT-GUIDE.md` — 모바일 클라이언트 실시간 연동 가이드 추가
- 2026-03-07 `backend/nest/src/modules/users/` — 사용자 프로필/찜 API 구현 (`/users/me`, `/favorites`)
- 2026-03-07 `backend/nest/src/modules/trucks/` — 트럭 CRUD API 구현 (TrucksController/Service, DTO, owner 권한 및 본인 트럭 수정/삭제 검증)
- 2026-03-07 `backend/nest/src/modules/locations/` — 위치 API 구현 (`GET /locations/nearby`, `POST /locations`, PostGIS 반경 조회/최근 위치 조회 쿼리)
- 2026-03-07 `backend/nest/src/modules/auth/` — Firebase 인증 모듈 구현 (AuthController/AuthService/FirebaseAuthGuard/FirebaseAdminProvider, 권한 2트랙 API 포함)
- 2026-03-07 `docs/API-TEST-GUIDE.md` — Phase 2 수동 검증 체크리스트(curl 예시, 권한/에러 케이스) 추가
- 2026-03-07 `backend/nest/src/common/decorators/current-user.decorator.ts`, `backend/nest/src/common/interfaces/request-user.interface.ts` — 인증 사용자 주입/타입 정의 추가
- 2026-03-07 `backend/nest/src/entities/owner_recommendation_request.entity.ts`, `backend/nest/src/entities/owner_payment_request.entity.ts` — 사장님 권한 요청 엔티티 추가
- 2026-03-07 `scripts/migrations/002_owner_access_requests.sql` — 추천 기반 요청·유료 권한 요청 테이블/인덱스/트리거 추가
- 2025-03-07 `shared/api-spec/rest-api.md` — REST API 스펙 (인증, 사용자, 트럭, 위치, 찜, 리뷰)
- 2025-03-07 `shared/api-spec/realtime-events.md` — Socket.io 이벤트 스펙
- 2025-03-07 `docs/guides/` — 기술별 초보자 가이드: README(목차), NODEJS-GUIDE, NESTJS-GUIDE, TYPEORM-GUIDE, SOCKETIO-GUIDE, FIREBASE-GUIDE, FLUTTER-GUIDE (PostgreSQL·PostGIS는 docs/POSTGRES-GUIDE.md 참조)
- 2025-03-07 `scripts/migrations/001_initial_schema.sql` — 초기 스키마 (users, trucks, locations, favorites, reviews, PostGIS, 인덱스·트리거)
- 2025-03-07 `scripts/migrations/README.md` — 마이그레이션 실행 방법
- 2025-03-07 `backend/nest/src/entities/` — TypeORM 엔티티 (User, Truck, Location, Favorite, Review)
- 2025-03-07 `backend/nest` — dotenv 의존성 추가, main.ts에서 프로젝트 루트 .env 로드
- 2025-03-07 `docs/DB-SCHEMA.md` — DB 스키마 설계안 (users, trucks, locations, favorites, reviews, PostGIS 타입·인덱스·반경 검색 예시), RDBMS만 경험한 독자용 상세 설명
- 2025-03-07 `docs/POSTGRES-GUIDE.md` — PostgreSQL·PostGIS 초보자 가이드 (개념, 타입, 공간 데이터, SRID 4326, geography/geometry, 접속·용어 사전)
- 2025-03-06 `.cursor/rules/whereistruck-project.mdc` — Cursor 룰 추가 (답변 한글, 변경이력 상세 기록, 오류 내역 별도 관리)
- 2025-03-06 `docs/ROADMAP.md` — 개발 로드맵 (순서, [직접] vs [Cursor AI] 표기)
- 2025-03-06 `.env` — 이번 한 번만 커밋 (초기 템플릿, 이후 변경분 미커밋)
- 2025-03-06 `docs/CHANGELOG.md` — 변경 이력 문서 생성 및 형식 정의
- 2025-03-06 `docs/ERRORS.md` — 오류 내역 문서 생성 및 기록 형식 정의

### Changed
- 2026-03-23 `.gitignore` — Firebase 클라이언트 설정 파일(`google-services.json`, `GoogleService-Info.plist`) 커밋 제외 규칙 추가
- 2026-03-23 `frontend/mobile-flutter/lib/main.dart` — 주변 트럭/관리자 탭 네비게이션 추가
- 2026-03-23 `frontend/mobile-flutter/lib/main.dart` — Android 시작 시 Firebase 익명 로그인 + FCM 토큰 등록 초기화 추가
- 2026-03-23 `frontend/mobile-flutter/lib/features/nearby_trucks/ui/` — Kakao 지도 뷰를 web/stub로 분리(`kakao_map_view_web.dart`, `kakao_map_view_stub.dart`)해 Android 빌드에서 `dart:html` 제외
- 2026-03-23 `frontend/mobile-flutter/lib/features/nearby_trucks/ui/nearby_trucks_page.dart` — 트럭 목록 클릭 시 트럭 상세 화면(4-3)으로 이동하도록 연결
- 2026-03-23 `frontend/mobile-flutter/android/`, `frontend/mobile-flutter/ios/` — Android/iOS 플랫폼 생성 및 Gradle Groovy 전환, Android/iOS 앱 식별자(`com.whereistruck.mobile`) 통일
- 2026-03-23 `frontend/mobile-flutter/android/app/build.gradle` — Groovy 설정에서 Kotlin `jvmTarget` 대입 문법을 호환형(`jvmTarget = ...`)으로 수정
- 2026-03-23 `frontend/mobile-flutter/android/app/src/main/AndroidManifest.xml` — FCM 동작을 위한 `INTERNET`, `POST_NOTIFICATIONS` 권한 추가
- 2026-03-23 `frontend/mobile-flutter/pubspec.yaml` — Firebase 패키지(`firebase_core`, `firebase_auth`, `firebase_messaging`) 의존성 추가
- 2026-03-23 `frontend/mobile-flutter/lib/core/config/api_base_url.dart` — Android 기본 API URL을 에뮬레이터 경로(`10.0.2.2:3000`)로 자동 분기
- 2026-03-23 `docs/ROADMAP.md` — Phase 0-2(카카오/구글 Map API 키 발급) 완료 취소선 처리
- 2026-03-23 `docs/ROADMAP.md` — Phase 0-4(Flutter SDK 설치/빌드 환경) 완료 취소선 처리
- 2026-03-23 `.env` — Firebase Admin SDK용 `GOOGLE_APPLICATION_CREDENTIALS` 경로 설정
- 2026-03-23 `.gitignore` — Firebase Admin SDK 서비스계정 JSON(`firebase-adminsdk-*`) 커밋 방지 규칙 추가
- 2026-03-23 `docs/ROADMAP.md` — Phase 0-3(Firebase Admin SDK 키 준비) 완료 취소선 처리
- 2026-03-07 `.env` — `MAP_API_KEY`를 Kakao Map JS Key로 설정
- 2026-03-07 `.env` — 카카오 키 분리(`MAP_PROVIDER=kakao`, `KAKAO_JS_API_KEY`/`KAKAO_NATIVE_APP_KEY`/`KAKAO_REST_API_KEY` 추가)
- 2026-03-07 `.env.example` — Kakao Map 플랫폼별 키 변수 추가
- 2026-03-07 `docs/DEVELOPMENT.md` — Kakao Map 키 변수(`MAP_PROVIDER`, `KAKAO_*`) 문서화
- 2026-03-07 `frontend/mobile-flutter/lib/core/config/map_api_keys.dart` — 웹은 JS 키, 모바일은 native 키 선택 헬퍼 추가
- 2026-03-07 `frontend/mobile-flutter/pubspec.yaml`, `frontend/mobile-flutter/README.md` — Flutter 의존성(http) 및 관리자 UI 실행 안내 추가
- 2026-03-07 `docs/ROADMAP.md` — Phase 4-10(관리자 웹 UI 구현) 완료 취소선 처리
- 2026-03-07 `backend/nest/src/app.module.ts`, `backend/nest/src/entities/index.ts`, `backend/nest/src/entities/user.entity.ts` — AdminModule/AuditLog 엔티티 등록 및 사용자 role 범위를 `admin`까지 확장
- 2026-03-07 `scripts/migrations/README.md` — 003 관리자 RBAC/감사 로그 마이그레이션 안내 추가
- 2026-03-07 `shared/api-spec/rest-api.md` — 관리자 API 스펙(`/admin/*`) 및 감사 로그 응답 예시 추가
- 2026-03-07 `docs/ROADMAP.md` — Phase 4.5 중 4-8/4-9/4-11/4-12 완료 취소선 처리
- 2026-03-07 `.cursor/rules/whereistruck-project.mdc` — §4.5 기능 단위 커밋 규칙 추가 (인증/실시간/문서 등 변경을 목적별 커밋으로 분리)
- 2026-03-07 `docs/ROADMAP.md` — Phase 3-1(실시간 이벤트 스펙), 3-2(Socket.io 서버), 3-3(클라이언트 연동 문서화) 완료 취소선 처리
- 2026-03-07 `docs/ROADMAP.md` — Phase 2-4(사용자·찜 API), 2-5(API 수동 검증 가이드) 완료 취소선 처리
- 2026-03-07 `docs/ROADMAP.md` — Phase 2-2(트럭 CRUD), 2-3(위치 API) 완료 취소선 처리
- 2026-03-07 `backend/nest/src/modules/auth/auth.module.ts`, `backend/nest/src/app.module.ts`, `backend/nest/package.json` — firebase-admin 연동 및 신규 엔티티/모듈 등록
- 2026-03-07 `docs/ROADMAP.md` — Phase 2-1, 2-1a 완료 취소선 처리
- 2026-03-07 `shared/api-spec/rest-api.md` — `/auth/owner/approve-payment` 헤더/요청/응답 예시 추가
- 2026-03-07 `docs/guides/NESTJS-GUIDE.md`, `docs/guides/FIREBASE-GUIDE.md` — 인증 가이드에 현재 구현 방식 반영
- 2026-03-07 `README.md`, `docs/ROADMAP.md`, `docs/ARCHITECTURE.md`, `docs/DEVELOPMENT.md`, `docs/guides/FLUTTER-GUIDE.md` — 운영 관리자 프로그램을 Flutter Web + 기존 NestJS 조합으로 확정(신규 기술 도입 없이 구현), 관련 운영 원칙/로드맵 반영
- 2026-03-07 `README.md`, `docs/ARCHITECTURE.md`, `docs/ROADMAP.md`, `shared/api-spec/rest-api.md` — 사장님 권한 획득 정책을 2트랙(사용자 추천 기반 + 유료 즉시 부여)으로 반영, 로드맵/인증 API 스펙 업데이트
- 2025-03-07 `.cursor/rules/whereistruck-project.mdc` — §4.1 커밋 메시지에 Made-with:cursor 등 브랜딩·태그 금지 규칙 추가 (영구)
- 2025-03-07 `docs/POSTGRES-GUIDE.md` → `docs/guides/POSTGRES-GUIDE.md` 로 이동. docs/guides/README.md, docs/DB-SCHEMA.md, docs/guides/TYPEORM-GUIDE.md, .cursor/rules 참조 경로 수정
- 2025-03-07 `.cursor/rules/whereistruck-project.mdc` — §6 기술 가이드 지속 반영 규칙 추가 (추가·수정되는 언어·기술은 해당 가이드 MD에 지속 반영)
- 2025-03-07 `shared/api-spec/README.md` — rest-api.md, realtime-events.md 링크 추가
- 2025-03-07 `docs/ROADMAP.md` — Phase 1-4 REST API 스펙 정리 완료 취소선 처리
- 2025-03-07 `backend/nest/src/app.module.ts` — TypeOrmModule.forRoot 추가 (DATABASE_URL, entities, synchronize: false)
- 2025-03-07 `docs/ROADMAP.md` — Phase 1-3 마이그레이션/초기 스키마 완료 취소선, Phase 1-1 DB 스키마 설계 완료 취소선 처리
- 2025-03-07 `.cursor/rules/whereistruck-project.mdc` — §5 로드맵 완료 표시 규칙 추가 (완료된 스텝은 docs/ROADMAP.md에서 취소선 처리)
- 2025-03-07 `docs/CHANGELOG.md`, `docs/ERRORS.md` — 의존성 설치 관련 변경이력·오류 기록 항목 삭제
- 2025-03-06 `.cursor/rules/whereistruck-project.mdc` — 커밋 규칙 추가 (한글 메시지·요약형, 커밋 전 브랜치 선택 질의 후 해당 브랜치에만 커밋)
- 2025-03-06 `.gitignore` — 클론 후 작업에 불필요한 항목 정리 (빌드·캐시·로그·임시 등), 상단 설명 추가
- 2025-03-06 `docs/PROJECT_STRUCTURE.md` — §2 추가: 다른 PC 클론 시 저장소 포함/제외 기준 정리, 섹션 번호 3~9로 조정
- 2025-03-06 `.gitignore` — .env 다시 목록에 추가 (이후 .env 변경분 미커밋)
- 2025-03-06 `.cursor/rules/whereistruck-project.mdc` — §4.3 .env는 한 번만 커밋, 이후 미커밋 규칙 추가
- 2025-03-06 문서·구성 정리 — 백엔드 NestJS 단일, 프론트 Flutter 단일로 재설계

### Fixed
- (버그 수정 항목을 위 형식으로 여기에 기록)

### Removed
- 2025-03-06 `backend/fastapi/` — FastAPI 백엔드 제거 (NestJS 단일로 전환)
- 2025-03-06 `frontend/mobile-react/` — React Native 앱 제거 (Flutter 단일로 전환)
- 2025-03-06 루트 `package.json`, `package-lock.json`, `requirements.txt` — 혼동 방지를 위해 제거 (실제 엔트리는 `backend/nest`, `frontend/mobile-flutter`)

---

## [1.0.0] — 프로젝트 구조 및 문서 초기 구성

### Added
- 2025-03-06 `docs/CHANGELOG.md` — 변경 이력 파일 생성
- 2025-03-06 `docs/ERRORS.md` — 오류 내역 파일 생성
- 2025-03-06 `.cursor/rules/whereistruck-project.mdc` — Cursor 룰(한글 답변, 변경이력, 오류 관리) 추가
