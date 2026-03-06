# WhereIsTruck REST API 스펙

공통 규칙·에러 형식과 도메인별 경로·요청/응답 예시를 정리합니다.  
구현 시 `shared/api-spec` 및 **docs/DB-SCHEMA.md**를 참고하세요.

---

## 1. 공통 규칙

- **Base URL:** `http://localhost:3000` (개발) / 배포 시 환경에 맞게 변경
- **Content-Type:** `application/json`
- **인증:** 사장님 전용·사용자 개인 API는 `Authorization: Bearer <Firebase_ID_TOKEN>` 헤더로 토큰 전달. 백엔드에서 Firebase Admin SDK로 검증 후 `uid`·역할 사용

---

## 2. 공통 응답·에러 형식

### 2.1 성공 (단일 리소스)

```json
{
  "id": 1,
  "name": "맛있는 떡볶이",
  "status": "open"
}
```

### 2.2 성공 (목록)

```json
{
  "data": [
    { "id": 1, "name": "맛있는 떡볶이", "status": "open" },
    { "id": 2, "name": "고소한 순대", "status": "closed" }
  ],
  "total": 2
}
```

### 2.3 에러 (4xx/5xx)

```json
{
  "statusCode": 401,
  "message": "Unauthorized",
  "error": "Unauthorized"
}
```

---

## 3. 인증 (Auth)

Firebase 로그인은 클라이언트에서 수행하고, 백엔드는 **ID 토큰**만 검증합니다.

| 메서드 | 경로 | 설명 | 인증 |
|--------|------|------|------|
| (클라이언트) | — | 로그인/회원가입은 Firebase Auth SDK 사용 | — |
| GET | `/auth/me` | 현재 토큰의 사용자 정보 반환 (DB의 users 행) | Bearer 토큰 |

### GET /auth/me

**요청:** 헤더 `Authorization: Bearer <ID_TOKEN>`

**응답 (200):**

```json
{
  "id": 1,
  "firebase_uid": "abc123...",
  "role": "user",
  "display_name": "홍길동",
  "email": "user@example.com"
}
```

---

## 4. 사용자 (Users)

| 메서드 | 경로 | 설명 | 인증 |
|--------|------|------|------|
| GET | `/users/me` | 내 프로필 조회 | Bearer |
| PATCH | `/users/me` | 내 프로필 수정 (display_name, profile_image_url, fcm_token 등) | Bearer |

### PATCH /users/me

**요청 body 예시:**

```json
{
  "display_name": "길동이",
  "fcm_token": "fcm_device_token_..."
}
```

**응답 (200):** 수정된 사용자 객체

---

## 5. 트럭 (Trucks)

| 메서드 | 경로 | 설명 | 인증 |
|--------|------|------|------|
| GET | `/trucks` | 트럭 목록 (쿼리: status, owner_id 등) | 선택 |
| GET | `/trucks/:id` | 트럭 상세 조회 | 선택 |
| POST | `/trucks` | 트럭 등록 (사장님 전용) | Bearer (owner) |
| PATCH | `/trucks/:id` | 트럭 수정 (본인 트럭만) | Bearer (owner) |
| DELETE | `/trucks/:id` | 트럭 삭제 (본인 트럭만) | Bearer (owner) |

### POST /trucks

**요청 body 예시:**

```json
{
  "name": "맛있는 떡볶이",
  "description": "매일 아침 7시 출발합니다.",
  "menu_summary": "떡볶이, 순대, 튀김",
  "cover_image_url": "https://..."
}
```

**응답 (201):** 생성된 트럭 객체 (id, created_at 포함)

### GET /trucks/:id

**응답 (200) 예시:**

```json
{
  "id": 1,
  "owner_id": 1,
  "name": "맛있는 떡볶이",
  "description": "매일 아침 7시 출발합니다.",
  "status": "open",
  "menu_summary": "떡볶이, 순대, 튀김",
  "cover_image_url": "https://...",
  "created_at": "2025-03-07T00:00:00.000Z",
  "updated_at": "2025-03-07T00:00:00.000Z"
}
```

---

## 6. 위치 (Locations) — 반경 내 트럭 조회

| 메서드 | 경로 | 설명 | 인증 |
|--------|------|------|------|
| GET | `/locations/nearby` | 반경 n km 내 (현재 영업 중) 트럭 목록 | 선택 |
| POST | `/locations` | 트럭 현재 위치 등록/갱신 (사장님 전용) | Bearer (owner) |

### GET /locations/nearby

**쿼리 파라미터:**

| 이름 | 타입 | 필수 | 설명 |
|------|------|------|------|
| lat | number | O | 사용자 위도 |
| lng | number | O | 사용자 경도 |
| radius_km | number | (기본 2) | 반경(km) |
| limit | number | (기본 20) | 최대 개수 |

**예시:** `GET /locations/nearby?lat=37.5&lng=127.0&radius_km=2`

**응답 (200) 예시:**

```json
{
  "data": [
    {
      "truck_id": 1,
      "truck_name": "맛있는 떡볶이",
      "status": "open",
      "distance_m": 850,
      "address_text": "서울시 강남구 ...",
      "lat": 37.501,
      "lng": 127.002
    }
  ],
  "total": 1
}
```

### POST /locations

**요청 body (사장님 전용, 본인 트럭):**

```json
{
  "truck_id": 1,
  "lat": 37.501,
  "lng": 127.002,
  "address_text": "서울시 강남구 역삼동 123"
}
```

**응답 (201):** 생성된 location 객체 (id, created_at 포함)

---

## 7. 찜 (Favorites)

| 메서드 | 경로 | 설명 | 인증 |
|--------|------|------|------|
| GET | `/favorites` | 내 찜 목록 | Bearer |
| POST | `/favorites` | 찜 추가 | Bearer |
| DELETE | `/favorites/:truckId` | 찜 해제 | Bearer |

### POST /favorites

**요청 body:**

```json
{
  "truck_id": 1
}
```

**응답 (201):** `{ "id": 1, "user_id": 1, "truck_id": 1, "created_at": "..." }`

### GET /favorites

**응답 (200):** 찜한 트럭 목록 (트럭 정보 포함)

```json
{
  "data": [
    {
      "id": 1,
      "truck_id": 1,
      "truck": { "id": 1, "name": "맛있는 떡볶이", "status": "open" },
      "created_at": "2025-03-07T00:00:00.000Z"
    }
  ],
  "total": 1
}
```

---

## 8. 리뷰 (Reviews)

| 메서드 | 경로 | 설명 | 인증 |
|--------|------|------|------|
| GET | `/trucks/:id/reviews` | 해당 트럭 리뷰 목록 | 선택 |
| POST | `/trucks/:id/reviews` | 리뷰 작성 | Bearer |
| PATCH | `/reviews/:id` | 내 리뷰 수정 | Bearer |
| DELETE | `/reviews/:id` | 내 리뷰 삭제 | Bearer |

### POST /trucks/:id/reviews

**요청 body:**

```json
{
  "rating": 5,
  "body": "맛있어요!"
}
```

**응답 (201):** 생성된 review 객체 (rating 1~5)

---

## 9. 다음 단계

- Phase 2에서 위 스펙을 기준으로 NestJS 컨트롤러·서비스·가드 구현
- WebSocket(실시간) 이벤트는 **shared/api-spec/realtime-events.md** 에 정리 예정
