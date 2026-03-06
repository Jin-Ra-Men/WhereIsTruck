# WhereIsTruck 프로젝트 구조

이 문서는 **WhereIsTruck(어디야트럭)** 저장소의 디렉터리 구조, 각 폴더 역할, 그리고 개발 시 참고할 규칙을 정리합니다.

---

## 1. 전체 디렉터리 트리

```
WhereIsTruck/
├── README.md                 # 프로젝트 개요, 기능, 기술 스택
├── SETUP.md                  # 환경 설정 및 의존성 설치 가이드
├── .env.example              # 환경 변수 예시 (복사 후 .env 로 사용)
├── install-dependencies.ps1  # NestJS 의존성 설치 스크립트
├── .cursor/
│   └── rules/               # Cursor AI 룰 (한글 답변, 변경이력, 오류 관리)
│       └── whereistruck-project.mdc
│
├── docs/                     # 프로젝트 문서
│   ├── PROJECT_STRUCTURE.md  # 이 문서 — 프로젝트 구조 상세
│   ├── ARCHITECTURE.md       # 시스템 아키텍처 및 데이터 흐름
│   ├── DEVELOPMENT.md       # 로컬 실행, 브랜치, 배포 요약
│   ├── ROADMAP.md            # 개발 로드맵 (순서, 직접 vs Cursor AI)
│   ├── CHANGELOG.md          # 변경 이력 (상세 기록)
│   └── ERRORS.md             # 오류 내역 (별도 관리)
│
├── backend/                  # 백엔드 (NestJS 단일)
│   └── nest/                # NestJS API 서버
│   │   ├── src/
│   │   │   ├── main.ts
│   │   │   ├── app.module.ts
│   │   │   └── modules/
│   │   │       ├── auth/       # 인증 (Firebase 등)
│   │   │       ├── trucks/     # 노점·트럭 CRUD
│   │   │       ├── locations/  # 위치/지도 (PostGIS)
│   │   │       ├── users/      # 사용자·사장님
│   │   │       └── realtime/   # Socket.io 실시간
│   │   ├── package.json
│   │   ├── tsconfig.json
│   │   └── nest-cli.json
│
├── frontend/                # 모바일 앱 (Flutter 단일)
│   └── mobile-flutter/     # Flutter
│       ├── lib/
│       └── pubspec.yaml
│
├── shared/                  # 팀/프로젝트 공유 자원
│   └── api-spec/            # API 경로, 이벤트명, 요청/응답 예시
│
├── docker/                  # 로컬 인프라
│   └── docker-compose.yml   # PostgreSQL + PostGIS
│
└── scripts/                 # (선택) 빌드·배포·DB 스크립트
```

---

## 2. 다른 PC에서 클론 후 작업 시 — 저장소에 넣을 파일 / 제외할 파일

다른 컴퓨터에서 저장소를 클론해 작업할 때 **필요한 파일만** 저장소에 두고, 나머지는 `.gitignore`로 제외합니다.

### 2.1 저장소에 포함하는 파일 (필요한 것만)

| 구분 | 포함 대상 |
|------|-----------|
| **소스·설정** | `backend/nest/`(package.json, tsconfig, src 등), `frontend/mobile-flutter/`, `shared/` |
| **문서** | README.md, SETUP.md, `docs/*.md` |
| **환경** | `.env.example` (템플릿만), `.gitignore` |
| **스크립트·인프라** | install-dependencies.ps1, `docker/docker-compose.yml` |
| **프로젝트 룰** | `.cursor/rules/*.mdc` |

- 의존성 패키지(`node_modules/` 등)는 **저장소에 넣지 않고**, 클론 후 해당 PC에서 `npm install`, `flutter pub get` 등으로 설치합니다.

### 2.2 저장소에서 제외하는 파일 (.gitignore)

- **의존성:** `node_modules/`, `.venv/`, `venv/`
- **환경·비밀:** `.env`, `commit_msg.txt`
- **빌드·캐시:** `dist/`, `__pycache__/`, `*.pyc`, `.pytest_cache/`, `.npm`, `*.log`
- **IDE·OS:** `.idea/`, `.vscode/`, `.DS_Store` 등

상세 목록은 **루트 `.gitignore`**를 참고하면 됩니다. 새로 만든 파일이 위 “제외” 항목에 해당하면 커밋하지 않습니다.

---

## 3. 루트 디렉터리

| 항목 | 설명 |
|------|------|
| **README.md** | 서비스 소개, 타겟, 핵심 기능(사용자/사장님), 기술 스택, 아키텍처 요약, 환경 설정 요구사항 |
| **SETUP.md** | Node.js / Flutter / PostgreSQL 설치, `npm install`·`flutter pub get` 방법, 환경 변수 정리 |
| **.env.example** | Map API Key, `DATABASE_URL`, Firebase 등 필수 환경 변수 템플릿. 복사해 `.env` 로 사용 |
| **install-dependencies.ps1** | PowerShell로 `npm install`(backend/nest) 실행 |

---

## 4. docs/ — 프로젝트 문서

| 파일 | 용도 |
|------|------|
| **PROJECT_STRUCTURE.md** | 저장소 폴더 구조, 각 디렉터리 역할, 규칙 (현재 문서) |
| **ARCHITECTURE.md** | 서비스 아키텍처, 위치 서비스·인증·실시간·DB(PostGIS) 흐름, 비즈니스 로직 개요 |
| **DEVELOPMENT.md** | 로컬 실행 순서, DB/백엔드/프론트 실행 방법, 브랜치/배포 정책 요약 |
| **ROADMAP.md** | 개발 로드맵 — 순서, 직접 할 일 vs Cursor AI 맡길 일 |
| **CHANGELOG.md** | 변경 이력 — 날짜·범위·내용을 상세히 기록 (Cursor 룰 준수) |
| **ERRORS.md** | 오류 내역 — 증상·원인·해결을 별도 관리 (Cursor 룰 준수) |

### Cursor 룰 (.cursor/rules/)

- **whereistruck-project.mdc** (alwaysApply: true)  
  - 답변은 **항상 한글**로 작성.  
  - 코드/설정/문서 변경 시 **docs/CHANGELOG.md**에 상세 기록.  
  - 오류·실패·해결 내용은 **docs/ERRORS.md**에 별도 기록.  
  - **커밋:** 메시지는 한글·요약형으로 작성, 한글 깨짐 방지. 커밋 전 사용자에게 master/새 브랜치/기존 브랜치 중 선택을 묻고, 선택한 브랜치에만 커밋.

---

## 5. backend/ — 백엔드

백엔드는 **NestJS 단일**로 운영합니다. REST API와 Socket.io 실시간을 한 서비스에서 제공합니다.

### 5.1 backend/nest/ (NestJS)

- **역할:** REST API + Socket.io 실시간, PostgreSQL(TypeORM) 연동
- **실행:** `cd backend/nest && npm install && npm run start:dev` (기본 포트 3000)
- **주요 모듈:**
  - **auth** — Firebase 등 인증, 사장님 권한 검증
  - **trucks** — 노점(트럭) 등록/수정/조회, 메뉴·사진
  - **locations** — 사용자/트럭 위치, 반경 n km 내 트럭 조회 (PostGIS 연동)
  - **users** — 일반 사용자·사장님 프로필, 찜, 추천
  - **realtime** — Socket.io로 영업 시작/종료, 재고 상태, 위치 업데이트 브로드캐스트

---

## 6. frontend/ — 모바일 앱 (Flutter)

**Flutter 단일**로 앱을 개발합니다. 지도(Map API), 실시간 소켓, 푸시(FCM)를 중심으로 구성합니다.

실제 앱 코드는 `flutter create` 로 프로젝트를 생성한 뒤, `frontend/mobile-flutter` 폴더에 맞춰 구성합니다. 자세한 실행 방법은 **DEVELOPMENT.md**를 참고합니다.

---

## 7. shared/ — 공유 자원

- **api-spec/** — REST 경로, 쿼리 파라미터, WebSocket 이벤트명, 요청/응답 예시를 문서화. NestJS API가 이 규약을 따르도록 유지합니다.

---

## 8. docker/ — 로컬 인프라

- **docker-compose.yml** — PostgreSQL + PostGIS 이미지로 DB 서버 실행. 로컬에서 위치 쿼리 개발·테스트 시 사용합니다.  
- 사용: `cd docker && docker-compose up -d`  
- DB 생성 후 `CREATE EXTENSION postgis;` 로 PostGIS 확장 활성화.

---

## 9. 규칙 및 권장 사항

- **환경 변수:** 비밀값·API 키는 `.env`에만 두고, `.env`는 Git에 올리지 않습니다. `.env.example`만 커밋합니다.
- **API 일관성:** NestJS API 경로·스키마는 **shared/api-spec**에 맞춥니다.
- **위치 데이터:** 위경도·반경 검색은 PostgreSQL + PostGIS로 처리하고, 인덱스를 권장합니다.
- **문서 갱신:** 폴더/모듈을 추가·변경할 때는 이 문서(PROJECT_STRUCTURE.md)와 **ARCHITECTURE.md**를 함께 수정합니다.

---

이 문서는 프로젝트 구조 설계 시점의 스냅샷입니다. 실제 저장소와 차이가 있으면 최신 구조에 맞게 수정해 사용하시면 됩니다.
