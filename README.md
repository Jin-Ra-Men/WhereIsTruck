# 🚚 WhereIsTruck (어디야트럭)

> **"실시간 위치 기반 노점상 및 푸드트럭 위치 공유 플랫폼"** > 사업자 등록이 어려운 노점 사장님들과 맛있는 길거리 음식을 찾는 사용자를 신뢰 기반으로 연결합니다.

---

## 📌 프로젝트 개요
* **서비스명:** WhereIsTruck
* **핵심 타겟:** 불확실한 노점 영업 정보 때문에 헛걸음하기 싫은 **사용자** & 홍보 수단이 필요한 **노점 사장님**
* **주요 가치:** **실시간성**, **신뢰 기반 검증**, **지역 커뮤니티 활성화**

---

## ✨ 핵심 기능 (Key Features)

### 👤 일반 사용자 (User)
* **내 주변 트럭 찾기:** 지도 API를 활용해 현재 내 위치 주변의 **활성화된 노점** 실시간 확인.
* **단골 트럭 알림:** '찜'한 트럭이 영업을 시작하면 **즉시 푸시 알림** 수신.
* **실시간 정보 기여:** "지금 영업 중이에요" 버튼을 통해 다른 사용자에게 **최신 정보** 제공.
* **메뉴 미리보기:** 방문 전 사장님이 등록한 **메뉴판과 실물 사진** 확인.

### 👨‍🍳 사장님 (Owner)
* **원클릭 영업 시작:** 현재 위치를 기반으로 지도에 **즉시 노출** 시작.
* **신뢰 기반 계정 인증:** 현장 사진 등록 및 사용자 추천 시스템을 통한 **사장님 권한** 획득.
* **실시간 상태 공지:** "재료 10개 남았습니다!" 등 **실시간 재고 상태** 업데이트 및 소통.
* **데이터 분석:** 요일별/시간별 **방문자 수 및 찜 수치** 통계 확인.

---

## 🛠 기술 스택 (Tech Stack)
* **Frontend:** `Flutter` (모바일 중심 환경, 지도 중심 UX)
* **Backend:** `Node.js (NestJS)`
* **Database:** `PostgreSQL` (**PostGIS** 활용 위치 쿼리 최적화)
* **Real-time:** `Socket.io` (실시간 위치 및 상태 업데이트)
* **Infrastructure:** `AWS` / `Google Cloud Platform`

---

## 🗺️ 시스템 아키텍처 및 로직
1. **위치 서비스:** 사용자의 위경도 좌표를 기반으로 반경 n km 내의 트럭을 **공간 쿼리**로 필터링.
2. **인증 시스템:** 사진 메타데이터(EXIF) 검증 및 **사용자 집단지성**을 활용한 노점상 신뢰도 검증.
3. **비즈니스 모델:** 프리미엄 노출 권한 부여 및 **타겟팅 푸시 알림** 서비스 모델 구축.

---

## 📁 프로젝트 구조 및 문서
* **로드맵:** [docs/ROADMAP.md](docs/ROADMAP.md) — 개발 순서, 직접 할 일 vs Cursor AI 맡길 일
* **폴더 구조:** [docs/PROJECT_STRUCTURE.md](docs/PROJECT_STRUCTURE.md) — 디렉터리 설명, 백엔드/프론트/공유 자원
* **아키텍처:** [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) — 시스템 구성, 위치·인증·실시간 로직
* **개발 가이드:** [docs/DEVELOPMENT.md](docs/DEVELOPMENT.md) — 로컬 실행, 환경 변수, 브랜치·배포 요약
* **환경 설정:** [SETUP.md](SETUP.md) — Node.js / Flutter / PostgreSQL 설치 및 의존성 설치

---

## ⚙️ 설정 (Environment)
이 프로젝트를 실행하기 위해서는 아래와 같은 환경 설정이 필요합니다.
* **Map API:** Google Maps API Key 또는 Kakao Map Key
* **Database:** PostgreSQL (PostGIS extension 설치 필수)
* **Auth:** Firebase Admin SDK Key
