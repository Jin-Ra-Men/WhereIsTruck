# WhereIsTruck DB 스키마 설계안

이 문서는 **RDBMS(MySQL, SQL Server 등)만 사용해 보셨고, PostgreSQL·PostGIS는 처음**이신 분이 읽어도 이해할 수 있도록 상세히 작성했습니다.  
용어 설명과 “다른 DB와 다른 점”은 **docs/guides/POSTGRES-GUIDE.md**에서 다룹니다.

---

## 1. 문서 읽는 순서 (권장)

1. **docs/guides/POSTGRES-GUIDE.md** — PostgreSQL·PostGIS 기초와 용어 (테이블·타입·공간 데이터 개념)
2. **이 문서(DB-SCHEMA.md)** — 테이블별 설계, 컬럼, 관계, 인덱스

---

## 2. 설계 개요

### 2.1 목적

- **User**: 앱 사용자·사장님 (Firebase UID와 1:1 매핑)
- **Truck**: 노점/푸드트럭 정보, “누가 운영하는지”는 User와 연결
- **Location**: 트럭의 **현재 위치** 또는 위치 이력 (위도·경도를 PostGIS 타입으로 저장)
- **Favorite**: 사용자 ↔ 트럭 “찜” 관계 (단골 트럭, 영업 시작 푸시용)
- **Review**: 사용자 → 트럭/사장님에 대한 리뷰 (신뢰도·추천에 사용)

### 2.2 RDBMS 경험자에게 한 줄 요약

- **PostgreSQL** = 표준 SQL + 확장 기능이 많은 관계형 DB (다른 RDBMS와 개념은 비슷함).
- **PostGIS** = PostgreSQL용 “위치(위도·경도)·지도” 확장.  
  “이 좌표에서 반경 2km 안의 트럭” 같은 **공간 쿼리**를 SQL로 할 수 있게 해 줍니다.
- 이 설계에서는 **위치**를 `geography(Point)` 한 컬럼에 넣고, 반경 검색 시 **인덱스**를 써서 빠르게 조회합니다.

### 2.3 ER 관계 (간단 요약)

```
User (1) ----< Truck       : 한 사용자(사장님)가 여러 트럭 운영 가능 (1:N)
Truck (1) ----< Location   : 한 트럭이 여러 시점의 위치 이력 (1:N, “현재”는 최신 1건)
User (N) >----< Truck (Favorite) : 사용자–트럭 찜 (N:M, Favorite 테이블로 연결)
User (1) ----< Review >---- (1) Truck : 사용자가 트럭에 리뷰 작성 (1:N, 리뷰는 트럭에 연결)
```

---

## 3. 공통 규칙 (이 설계안 전체)

- **PK**: 모든 테이블에 `id` (자동 증가 정수, `SERIAL`/`GENERATED ... AS IDENTITY`).
- **타임스탬프**: 생성 시각 `created_at`, 필요 시 수정 시각 `updated_at` (타입: `TIMESTAMPTZ` = UTC 기준 시간대 포함).
- **Soft delete**: “삭제”해도 DB에서 바로 지우지 않고, `deleted_at` 등으로 표시할 수 있음 (필요 시 테이블별로 추가).
- **PostGIS 위치**: “한 점(위도, 경도)”은 **PostGIS 확장**의 `geography(Point)` 또는 `geometry(Point, 4326)` 사용.  
  - **4326** = WGS84 (GPS·지도에서 쓰는 좌표계).  
  - 자세한 설명은 **docs/guides/POSTGRES-GUIDE.md** 참고.

---

## 4. 테이블별 설계

### 4.1 users (사용자)

| 컬럼명 | 타입 | NULL | 설명 |
|--------|------|------|------|
| id | SERIAL (또는 GENERATED ... AS IDENTITY) | NO | PK. 자동 증가 정수. |
| firebase_uid | VARCHAR(128) | NO, UNIQUE | Firebase 인증에서 쓰는 사용자 고유 ID. 로그인 계정과 1:1. |
| role | VARCHAR(20) | NO | 역할: `user`(일반), `owner`(사장님). 기본값 `user`. |
| display_name | VARCHAR(100) | YES | 앱에 보여 줄 이름. |
| email | VARCHAR(255) | YES | 이메일 (선택). |
| profile_image_url | VARCHAR(512) | YES | 프로필 이미지 URL. |
| fcm_token | VARCHAR(512) | YES | 푸시 알림용 FCM 디바이스 토큰. |
| created_at | TIMESTAMPTZ | NO | 레코드 생성 시각 (UTC). |
| updated_at | TIMESTAMPTZ | NO | 마지막 수정 시각 (UTC). |

- **제약**
  - `firebase_uid` UNIQUE: 한 Firebase 계정이 하나의 User 행과만 연결.
  - `role` CHECK: `'user'` 또는 `'owner'` 만 허용 (필요 시 확장).
- **인덱스**
  - `users_firebase_uid_key` (UNIQUE): 로그인·인증 시 조회.
  - `users_role_idx`: 역할별 필터(예: 사장님 목록) 시 사용 가능.

**다른 DB와의 차이 (PostgreSQL)**  
- `SERIAL` = MySQL의 AUTO_INCREMENT와 비슷.  
- `TIMESTAMPTZ` = “시간대를 포함한 날짜/시간” 타입. 다른 DB의 `DATETIMEOFFSET` 등과 유사.

---

### 4.2 trucks (트럭)

| 컬럼명 | 타입 | NULL | 설명 |
|--------|------|------|------|
| id | SERIAL | NO | PK. |
| owner_id | INTEGER | NO | FK → users.id. 이 트럭을 운영하는 사장님(User). |
| name | VARCHAR(100) | NO | 트럭(노점) 이름. |
| description | TEXT | YES | 소개 문구. |
| status | VARCHAR(20) | NO | 영업 상태: `open`, `closed`. 기본값 `closed`. |
| menu_summary | VARCHAR(500) | YES | 메뉴 요약(한 줄). 상세 메뉴는 별도 테이블/JSON 가능. |
| cover_image_url | VARCHAR(512) | YES | 대표 이미지 URL. |
| created_at | TIMESTAMPTZ | NO | 생성 시각. |
| updated_at | TIMESTAMPTZ | NO | 수정 시각. |

- **제약**
  - `owner_id` REFERENCES users(id).
  - `status` CHECK: `'open'`, `'closed'` 등만 허용.
- **인덱스**
  - `trucks_owner_id_idx`: 사장님별 트럭 목록 조회.
  - `trucks_status_idx`: “지금 영업 중인 트럭” 필터.

**참고**  
- “현재 위치”는 **locations** 테이블에 저장하고, 트럭별 “가장 최신 1건”을 “현재 위치”로 사용합니다.  
- 메뉴·사진이 복잡해지면 나중에 `truck_menus`, `truck_photos` 같은 하위 테이블로 분리할 수 있습니다.

---

### 4.3 locations (트럭 위치)

트럭의 **위치 이력**을 저장합니다. “현재 위치”는 **해당 트럭의 가장 최신 행**으로 판단합니다.

| 컬럼명 | 타입 | NULL | 설명 |
|--------|------|------|------|
| id | SERIAL | NO | PK. |
| truck_id | INTEGER | NO | FK → trucks.id. 어떤 트럭의 위치인지. |
| geom | geography(Point) | NO | **PostGIS 타입.** 위도·경도 한 점. 단위는 미터(거리 계산 시). |
| address_text | VARCHAR(255) | YES | 주소 문자열(선택). 지도에 표시용. |
| created_at | TIMESTAMPTZ | NO | 이 위치가 기록된 시각. |

- **제약**
  - `truck_id` REFERENCES trucks(id).
- **인덱스**
  - `locations_truck_id_created_at_idx`: 트럭별로 최신 위치 1건 조회 시 사용.
  - **공간 인덱스** `locations_geom_idx`: PostGIS의 **GIST 인덱스** on `geom`.  
    “이 점에서 반경 N m 안의 점들” 검색 시 필수입니다.  
    - 생성 예: `CREATE INDEX locations_geom_idx ON locations USING GIST (geom);`

**PostGIS 타입 설명 (초보자용)**  
- **geography(Point)**  
  - “지구 위의 한 점(위도, 경도)”을 저장하는 타입.  
  - 거리·반경 계산이 **미터 단위**로 정확하게 나옵니다.  
  - 값 넣을 때는 보통 `ST_SetSRID(ST_MakePoint(경도, 위도), 4326)::geography` 형태로 넣습니다.  
  - **경도(longitude), 위도(latitude)** 순서인 점만 주의하면 됩니다.  
- 자세한 개념은 **docs/guides/POSTGRES-GUIDE.md**의 “공간 데이터·PostGIS” 섹션을 보시면 됩니다.

---

### 4.4 favorites (찜: 사용자–트럭)

사용자가 트럭을 “찜”한 관계입니다. 한 사용자가 여러 트럭을 찜할 수 있고, 한 트럭은 여러 사용자에게 찜될 수 있습니다 (N:M).

| 컬럼명 | 타입 | NULL | 설명 |
|--------|------|------|------|
| id | SERIAL | NO | PK. |
| user_id | INTEGER | NO | FK → users.id. |
| truck_id | INTEGER | NO | FK → trucks.id. |
| created_at | TIMESTAMPTZ | NO | 찜한 시각. |

- **제약**
  - `(user_id, truck_id)` UNIQUE: 같은 사용자가 같은 트럭을 두 번 찜할 수 없음.
  - `user_id` REFERENCES users(id), `truck_id` REFERENCES trucks(id).
- **인덱스**
  - `favorites_user_id_idx`: “이 사용자의 찜 목록” 조회.
  - `favorites_truck_id_idx`: “이 트럭을 찜한 사용자”(푸시 발송 대상) 조회.
  - UNIQUE 제약으로 (user_id, truck_id) 인덱스도 생성됩니다.

---

### 4.5 reviews (리뷰 / 추천)

사용자가 트럭(사장님)에 대해 남긴 리뷰입니다. 신뢰도·추천 수 등에 활용합니다.

| 컬럼명 | 타입 | NULL | 설명 |
|--------|------|------|------|
| id | SERIAL | NO | PK. |
| user_id | INTEGER | NO | FK → users.id. 리뷰 작성자. |
| truck_id | INTEGER | NO | FK → trucks.id. 리뷰 대상 트럭. |
| rating | SMALLINT | NO | 평점 (예: 1~5). |
| body | TEXT | YES | 리뷰 내용. |
| created_at | TIMESTAMPTZ | NO | 작성 시각. |
| updated_at | TIMESTAMPTZ | NO | 수정 시각. |

- **제약**
  - `rating` CHECK: 예) 1 이상 5 이하.
  - `user_id`, `truck_id` REFERENCES.
- **인덱스**
  - `reviews_truck_id_idx`: 트럭별 리뷰 목록·평균 평점 계산.
  - `reviews_user_id_idx`: 사용자별 작성 리뷰 조회.
  - (선택) 한 사용자가 한 트럭에 리뷰 1개만 허용하려면 `(user_id, truck_id)` UNIQUE 추가 가능.

---

## 5. “현재 위치”만 쓰는 경우 (단순화)

위치 **이력**이 필요 없고 “현재 위치만” 있으면 될 때는:

- **trucks** 테이블에 `current_geom geography(Point)` 컬럼을 하나 추가하고,  
  영업 시작/위치 업데이트 시 이 컬럼만 갱신하는 방식으로 단순화할 수 있습니다.
- 반경 검색은 그때도 `trucks.current_geom`에 GIST 인덱스를 걸어서 동일하게 처리합니다.

현재 설계는 **이력 보관**을 전제로 한 **locations** 테이블 기준입니다.  
나중에 “현재 위치만”으로 바꾸고 싶으면 **trucks**에 `current_geom`을 추가하고, **locations**는 선택적으로만 쓰도록 조정하면 됩니다.

---

## 6. 인덱스 요약

| 테이블 | 인덱스 | 용도 |
|--------|--------|------|
| users | UNIQUE(firebase_uid) | 로그인·인증 시 사용자 조회 |
| users | (role) | 역할별 필터 |
| trucks | (owner_id) | 사장님별 트럭 목록 |
| trucks | (status) | 영업 중인 트럭 필터 |
| locations | (truck_id, created_at) | 트럭별 최신 위치 1건 |
| locations | **GIST(geom)** | 반경 N m 내 위치 검색 (공간 쿼리) |
| favorites | (user_id), (truck_id), UNIQUE(user_id, truck_id) | 찜 목록·푸시 대상 |
| reviews | (truck_id), (user_id) | 트럭별/사용자별 리뷰 |

---

## 7. 반경 검색 쿼리 예시 (참고)

“위도 37.5, 경도 127.0에서 반경 2km 안의 **현재 영업 중**인 트럭”을 찾는 개념입니다.  
(실제 구현 시에는 **locations**에서 트럭별 최신 1건만 조인하는 조건이 추가됩니다.)

```sql
-- 사용자 위치: 경도 127.0, 위도 37.5, 반경 2000m
SELECT t.id, t.name, t.status,
       ST_Distance(l.geom::geography, ST_SetSRID(ST_MakePoint(127.0, 37.5), 4326)::geography) AS distance_m
FROM trucks t
JOIN LATERAL (
  SELECT geom FROM locations
  WHERE truck_id = t.id
  ORDER BY created_at DESC
  LIMIT 1
) l ON true
WHERE t.status = 'open'
  AND ST_DWithin(
    l.geom::geography,
    ST_SetSRID(ST_MakePoint(127.0, 37.5), 4326)::geography,
    2000
  )
ORDER BY distance_m;
```

- `ST_MakePoint(경도, 위도)`: 점 생성.  
- `ST_SetSRID(..., 4326)`: WGS84 좌표계 지정.  
- `ST_DWithin(..., 2000)`: 2000m 이내인지 판단 (geography 사용 시 단위는 미터).  
- `ST_Distance`: 거리(미터) 계산.  
자세한 함수 설명은 **docs/guides/POSTGRES-GUIDE.md**를 참고하세요.

---

## 8. 다음 단계

- **1-2**: 이 설계안을 검토한 뒤, 수정 요청 또는 확정.
- **1-3**: 확정된 스키마로 마이그레이션/초기 스키마 적용 (TypeORM 엔티티 또는 SQL).

용어·타입이 더 필요하면 **docs/guides/POSTGRES-GUIDE.md**를 함께 보시면 됩니다.
