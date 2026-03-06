# 변경 이력 (Changelog)

WhereIsTruck 프로젝트의 변경 사항을 상세히 기록합니다.

형식: **날짜(YYYY-MM-DD)** | **변경 범위(파일/디렉터리)** | **변경 내용 요약**

---

## [Unreleased]

### Added
- 2025-03-06 `.cursor/rules/whereistruck-project.mdc` — Cursor 룰 추가 (답변 한글, 변경이력 상세 기록, 오류 내역 별도 관리)
- 2025-03-06 `docs/ROADMAP.md` — 개발 로드맵 (순서, [직접] vs [Cursor AI] 표기)
- 2025-03-06 `.env` — 이번 한 번만 커밋 (초기 템플릿, 이후 변경분 미커밋)
- 2025-03-06 `docs/CHANGELOG.md` — 변경 이력 문서 생성 및 형식 정의
- 2025-03-06 `docs/ERRORS.md` — 오류 내역 문서 생성 및 기록 형식 정의

### Changed
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
