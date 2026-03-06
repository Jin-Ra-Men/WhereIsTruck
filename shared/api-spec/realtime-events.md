# WhereIsTruck 실시간 이벤트 (Socket.io) 스펙

실시간 알림·위치 갱신을 위한 이벤트명과 페이로드 형식입니다.  
NestJS에서 Socket.io 게이트웨이로 구현하며, 클라이언트(Flutter 등)는 동일 이벤트명으로 구독/발행합니다.

---

## 1. 연결

- **URL:** `http://localhost:3000` (개발 시 백엔드와 동일 호스트)
- **네임스페이스:** 기본 `/` 또는 프로젝트에서 정의한 네임스페이스
- **인증:** 연결 시 쿼리/헤더에 Firebase ID 토큰 전달 후, 서버에서 검증해 소켓과 user_id 매핑

---

## 2. 사장님 → 서버 (클라이언트 발송)

| 이벤트명 | 설명 | 페이로드 예시 |
|----------|------|----------------|
| `truck:open` | 영업 시작 | `{ "truck_id": 1 }` |
| `truck:close` | 영업 종료 | `{ "truck_id": 1 }` |
| `truck:location` | 현재 위치 갱신 | `{ "truck_id": 1, "lat": 37.5, "lng": 127.0 }` |
| `truck:stock_update` | 재고/공지 메시지 | `{ "truck_id": 1, "message": "떡볶이 마감 30분 전" }` |

---

## 3. 서버 → 클라이언트 (브로드캐스트/개인 전달)

| 이벤트명 | 설명 | 페이로드 예시 |
|----------|------|----------------|
| `truck:opened` | 특정 트럭 영업 시작 알림 (찜한 사용자 등에게) | `{ "truck_id": 1, "truck_name": "맛있는 떡볶이" }` |
| `truck:closed` | 특정 트럭 영업 종료 | `{ "truck_id": 1 }` |
| `truck:location_updated` | 트럭 위치 갱신 (지도 마커 갱신용) | `{ "truck_id": 1, "lat": 37.5, "lng": 127.0 }` |
| `truck:stock_announce` | 재고/공지 브로드캐스트 | `{ "truck_id": 1, "message": "..." }` |

---

## 4. 구현 시 참고

- 사장님이 `truck:open` 보내면 서버에서 DB 트럭 상태를 `open`으로 변경하고, 해당 트럭을 찜한 사용자에게 `truck:opened` 푸시 또는 소켓 전송
- `truck:location` 수신 시 서버에서 locations 테이블에 삽입 후, 구독 중인 클라이언트에게 `truck:location_updated` 브로드캐스트
- 클라이언트 연동 방법은 Phase 3-3에서 문서화 예정
