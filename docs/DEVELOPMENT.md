# WhereIsTruck 개발 가이드

로컬에서 프로젝트를 실행하고, 브랜치·배포 정책을 적용할 때 참고하는 문서입니다.

---

## 1. 사전 요구사항

- **Node.js** (LTS) — `backend/nest` 실행
- **Flutter** — `frontend/mobile-flutter` 실행
- **PostgreSQL + PostGIS** — 위치 쿼리 개발 (로컬 설치 또는 Docker)
- **선택:** Map API 키(Google/Kakao), Firebase 프로젝트(인증·푸시)

자세한 설치 방법은 루트의 **SETUP.md**를 참고하세요.

---

## 2. 환경 변수

1. 루트에 `.env.example`을 복사해 `.env` 생성  
2. 아래 항목을 실제 값으로 채웁니다.

| 변수 | 설명 |
|------|------|
| `MAP_API_KEY` | Google Maps 또는 Kakao Map API Key (기본 폴백) |
| `MAP_PROVIDER` | `google` 또는 `kakao` |
| `KAKAO_JS_API_KEY` | Kakao Map JavaScript 키 (웹에서 사용) |
| `KAKAO_NATIVE_APP_KEY` | Kakao Map native app 키 (Android/iOS에서 사용) |
| `KAKAO_REST_API_KEY` | Kakao Map REST 키 (서버/대행 로직에서 사용 가능) |
| `DATABASE_URL` | PostgreSQL 연결 문자열 (PostGIS 사용 DB) |
| `FIREBASE_*` 또는 `GOOGLE_APPLICATION_CREDENTIALS` | Firebase Admin 인증 |
| `PORT` | NestJS 서버 포트 (기본 3000) |

백엔드별로 `.env`를 각각 두거나, 루트 `.env`를 각 앱에서 로드하도록 구성할 수 있습니다.

참고: Kakao 지도 Web API는 `JavaScript Key`가 필요하고, `JavaScript SDK 도메인` 등록이 필요합니다.
가이드는 `https://apis.map.kakao.com/web/guide/` 를 참고하세요.

---

## 3. 로컬 실행 순서

### 3.1 데이터베이스 (PostgreSQL + PostGIS)

**Docker 사용 시:**

```bash
cd docker
docker-compose up -d
```

DB 생성 후 PostGIS 확장 활성화:

```sql
CREATE EXTENSION IF NOT EXISTS postgis;
```

로컬에 PostgreSQL을 직접 설치했다면, 해당 DB에 접속해 동일하게 `postgis` 확장을 넣습니다.

### 3.2 백엔드 — NestJS

```bash
cd backend/nest
npm install
npm run start:dev
```

- 기본: `http://localhost:3000`

### 3.3 프론트엔드 (모바일) — Flutter

```bash
cd frontend/mobile-flutter
flutter pub get
flutter run
```

각 앱에서 사용할 API Base URL을 `.env` 또는 설정 파일에서 `localhost`(에뮬레이터용) 또는 실제 기기 IP로 지정합니다.

---

## 4. 의존성 일괄 설치

Windows PowerShell에서 루트의 스크립트로 NestJS 의존성을 설치할 수 있습니다.

```powershell
.\install-dependencies.ps1
```

이 스크립트는 루트 기준으로 동작합니다. Flutter 의존성(`flutter pub get`)은 Flutter SDK 설치 후 `frontend/mobile-flutter`에서 실행합니다.

---

## 5. 브랜치 및 배포 (권장)

- **main (또는 master):** 배포 가능한 안정 버전
- **develop:** 통합 개발 브랜치
- **feature/xxx, fix/xxx:** 기능/버그 수정용 브랜치에서 작업 후 develop/main으로 병합

배포는 AWS/GCP 등에서 백엔드 빌드·실행, DB 마이그레이션, 환경 변수 설정 순으로 진행합니다. CI/CD 파이프라인은 저장소에 맞게 별도 구성합니다.

---

## 6. 운영 관리자 프로그램 (개발 원칙)

- **형태:** Flutter Web 관리자 콘솔
- **기술 정책:** 새로운 프레임워크 도입 없이 기존 기술(Flutter + NestJS) 재사용
- **백엔드:** 기존 NestJS에 관리자용 API를 추가 (`/admin/*`)
- **목표:** 구현 속도·유지보수 효율을 높이고 추가 운영 비용 최소화

---

## 7. 문서 및 구조

- **프로젝트 구조:** `docs/PROJECT_STRUCTURE.md`
- **아키텍처·로직:** `docs/ARCHITECTURE.md`
- **API 규약:** `shared/api-spec/` 에 경로·이벤트·요청/응답 예시 정리

폴더나 모듈을 추가·변경할 때는 위 문서를 함께 갱신하는 것을 권장합니다.
