# WhereIsTruck API 수동 검증 가이드

Phase 2에서 구현한 인증/트럭/위치/사용자·찜 API를 빠르게 확인하는 체크리스트입니다.

---

## 1) 사전 준비

- 백엔드 실행: `cd backend/nest && npm run start:dev`
- DB 마이그레이션 적용:
  - `scripts/migrations/001_initial_schema.sql`
  - `scripts/migrations/002_owner_access_requests.sql`
- 테스트용 Firebase ID 토큰 준비
- 관리자 승인 API 테스트 시 `ADMIN_API_KEY` 환경 변수 설정

---

## 2) 인증/권한 API

- [ ] `GET /auth/me` — 토큰으로 사용자 조회/자동 생성
- [ ] `POST /auth/owner/requests/recommendation` — 추천 기반 요청 생성
- [ ] `POST /auth/owner/requests/payment` — 유료 권한 요청 생성
- [ ] `POST /auth/owner/approve-payment` — 관리자 토큰으로 결제 승인 및 owner 승격

```bash
curl -H "Authorization: Bearer <ID_TOKEN>" http://localhost:3000/auth/me
```

---

## 3) 트럭 CRUD

- [ ] `GET /trucks` 목록 조회
- [ ] `GET /trucks/:id` 상세 조회
- [ ] `POST /trucks` (owner만 가능)
- [ ] `PATCH /trucks/:id` (본인 트럭만 가능)
- [ ] `DELETE /trucks/:id` (본인 트럭만 가능)

---

## 4) 위치 API

- [ ] `POST /locations` (owner, 본인 트럭 위치 등록)
- [ ] `GET /locations/nearby` (lat/lng/radius_km로 반경 검색)

```bash
curl "http://localhost:3000/locations/nearby?lat=37.5&lng=127.0&radius_km=2"
```

---

## 5) 사용자/찜 API

- [ ] `GET /users/me` 조회
- [ ] `PATCH /users/me` 수정
- [ ] `POST /favorites` 찜 추가
- [ ] `GET /favorites` 찜 목록
- [ ] `DELETE /favorites/:truckId` 찜 해제

---

## 6) 권한/에러 확인 포인트

- [ ] 토큰 없이 보호 API 접근 시 `401`
- [ ] owner 전용 API를 일반 user로 호출 시 `403`
- [ ] 본인 소유가 아닌 트럭 수정/삭제 시 `403`
- [ ] 없는 리소스 조회/삭제 시 `404`

---

이 문서는 수동 검증용입니다. 자동 테스트 코드는 추후 e2e 테스트 단계에서 추가합니다.
