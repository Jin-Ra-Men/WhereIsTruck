# WhereIsTruck 환경 설정 가이드

README.md에 명시된 기술 스택을 로컬에서 사용하기 위한 설치 및 다운로드 안내입니다.

---

## 1. 필수 런타임 설치 (다운로드)

### Node.js (NestJS, Socket.io)
- **다운로드:** https://nodejs.org/
- LTS 버전 설치 후 터미널에서 `node -v`, `npm -v` 확인

### Flutter (모바일 앱)
- **다운로드:** https://docs.flutter.dev/get-started/install
- 설치 후 `flutter --version` 확인
- Android Studio(또는 Android SDK), Xcode(macOS) 등 플랫폼별 요구사항은 Flutter 공식 가이드를 따릅니다.

### PostgreSQL + PostGIS (Database)
- **다운로드:** https://www.postgresql.org/download/windows/
- 또는 **PostGIS 포함 배포판:** https://postgis.net/windows_downloads/
- 설치 후 DB 생성 시 **PostGIS extension** 활성화:
  ```sql
  CREATE EXTENSION IF NOT EXISTS postgis;
  ```
- **DB 비밀번호:** 앱 접속용 계정 `whereistruck` 및 postgres 슈퍼유저는 프로젝트 기본 비밀번호 `WhereIsTrucksOwnerIsJinLee` 사용. postgres 비밀번호를 맞추려면 (설치 시 다른 비밀번호를 썼을 경우) 관리자 권한 터미널에서:
  ```powershell
  & "C:\Program Files\PostgreSQL\17\bin\psql.exe" -U postgres -c "ALTER USER postgres PASSWORD 'WhereIsTrucksOwnerIsJinLee';"
  ```
  (비밀번호 입력 프롬프트에 기존 postgres 비밀번호 입력)

---

## 2. 프로젝트 의존성 다운로드 (설치)

아래 중 한 가지 방법으로 실행하세요.

### 방법 A: PowerShell 스크립트 (권장)
```powershell
cd d:\WhereIsTruck\WhereIsTruck
.\install-dependencies.ps1
```

### 방법 B: 수동 실행
```powershell
cd d:\WhereIsTruck\WhereIsTruck

# NestJS (backend/nest)
cd backend\nest
npm install
cd ..\..

# Flutter (frontend/mobile-flutter)
# ※ 실제 Flutter 프로젝트를 생성/구성한 뒤 실행하세요.
cd frontend\mobile-flutter
flutter pub get
cd ..\..
```

---

## 3. 환경 변수 (README ⚙️ 설정 참고)

| 항목 | 설명 |
|------|------|
| **Map API** | Google Maps API Key 또는 Kakao Map Key |
| **Database** | PostgreSQL 연결 문자열 (PostGIS 사용 DB) |
| **Auth** | Firebase Admin SDK Key |

`.env` 파일을 프로젝트 루트에 만들고 위 값을 설정한 뒤 앱에서 로드하세요.

---

## 4. 정리

| 기술 스택 | 다운로드/설치 |
|-----------|----------------|
| Frontend (Flutter) | `frontend/mobile-flutter` — Flutter SDK 설치 후 `flutter pub get` |
| Backend Node (NestJS) | `backend/nest/package.json` → `cd backend/nest && npm install` |
| Database (PostgreSQL/PostGIS) | 위 1번에서 설치 또는 `docker/docker-compose.yml` 사용 |
| Real-time (Socket.io) | Nest 패키지에 포함 |
| Infrastructure (AWS/GCP) | 콘솔에서 계정·리소스 생성 |

프로젝트 구조 상세는 **docs/PROJECT_STRUCTURE.md**를 참고하세요.

이 문서와 `install-dependencies.ps1` 실행으로 README에 필요한 사용 기술들을 다운로드·설정할 수 있습니다.
