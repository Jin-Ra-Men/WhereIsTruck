# 실시간 연동 가이드 (Socket.io 클라이언트)

모바일(Flutter)에서 백엔드 Socket.io 서버와 연동하는 최소 가이드입니다.

---

## 1. 연결

- 서버 URL: `http://localhost:3000`
- 권장: Firebase ID 토큰을 `auth.token`으로 전달

예시(개념):

```text
io('http://localhost:3000', {
  auth: { token: '<FIREBASE_ID_TOKEN>' }
})
```

---

## 2. 서버로 보내는 이벤트 (사장님)

- `truck:open` — `{ truck_id }`
- `truck:close` — `{ truck_id }`
- `truck:location` — `{ truck_id, lat, lng }`
- `truck:stock_update` — `{ truck_id, message }`

owner 권한 사용자 + 본인 트럭 조건을 만족해야 처리됩니다.

---

## 3. 서버에서 받는 이벤트 (사용자/사장님 공통)

- `truck:opened` — 영업 시작
- `truck:closed` — 영업 종료
- `truck:location_updated` — 위치 갱신
- `truck:stock_announce` — 재고 공지

클라이언트는 이 이벤트를 구독해 지도 마커, 상태 배지, 공지 영역을 즉시 갱신합니다.

---

## 4. 구현 참고

- 상세 이벤트 스펙: `shared/api-spec/realtime-events.md`
- 서버 구현: `backend/nest/src/modules/realtime/realtime.gateway.ts`

