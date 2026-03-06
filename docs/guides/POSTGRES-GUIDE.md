# PostgreSQL·PostGIS 초보자 가이드

**대상:** RDBMS(MySQL, SQL Server, Oracle 등)는 사용해 봤지만, **PostgreSQL**이나 **PostGIS**는 처음인 분.

이 문서를 읽으면 WhereIsTruck 프로젝트의 **DB-SCHEMA.md**와 백엔드 코드에서 나오는 Postgres/PostGIS 용어를 부담 없이 이해할 수 있습니다.

---

## 1. PostgreSQL이란?

- **관계형 DB(RDBMS)** 로, MySQL·SQL Server와 같은 "테이블·행·열·SQL" 구조입니다.
- 표준 SQL을 잘 지원하고, **확장(Extension)** 으로 기능을 붙일 수 있습니다.
- 우리 프로젝트에서는 **PostGIS** 확장을 켜서 "위도·경도·반경 검색"을 DB 안에서 처리합니다.

**다른 DB와 비슷한 점**
- 테이블, 컬럼, PK, FK, 인덱스, 트랜잭션, JOIN 등 개념이 동일합니다.
- `SELECT`, `INSERT`, `UPDATE`, `DELETE` 문법도 거의 같습니다.

**조금 다른 점**
- 데이터 타입 이름이 다를 수 있음 (예: `SERIAL`, `TIMESTAMPTZ`, `TEXT`).
- "스키마(schema)" 개념을 더 분리해서 씀.
- **확장**으로 PostGIS 같은 "공간 데이터" 기능을 추가함.

---

## 2. 기본 개념 정리

### 2.1 데이터베이스 (Database)

- **한 프로젝트용 데이터를 담는 최상위 단위**라고 보면 됩니다.
- 우리는 `whereistruck` 라는 이름의 DB를 사용합니다.
- MySQL의 "데이터베이스"와 같은 개념입니다.

### 2.2 스키마 (Schema)

- **데이터베이스 안의 이름 공간**입니다. 테이블들을 그룹으로 묶을 때 씁니다.
- 기본 스키마 이름은 `public`입니다.  
  `CREATE TABLE users (...)` 하면 실제로는 `public.users` 가 만들어집니다.
- 다른 DB에서 "스키마"를 잘 안 썼다면, "테이블이 들어가는 폴더 이름"이라고 생각하면 됩니다.

### 2.3 테이블 (Table)

- 행(row)·열(column)로 된 데이터 저장 단위. 다른 RDBMS와 동일합니다.
- PostgreSQL에서는 대소문자를 구분하지 않을 때는 소문자로 만들고,  
  큰따옴표로 감싼 식별자만 대소문자를 구분합니다.  
  보통은 **소문자 + 언더스코어** 로 테이블·컬럼 이름을 짓습니다 (예: `users`, `created_at`).

---

## 3. 자주 쓰는 데이터 타입 (다른 DB와 비교)

| PostgreSQL 타입 | 설명 | 비슷한 타입 (다른 DB) |
|-----------------|------|------------------------|
| **SERIAL** | 1부터 자동 증가하는 정수 (PK용). | MySQL `AUTO_INCREMENT` 정수 |
| **INTEGER** | 4바이트 정수. | INT |
| **SMALLINT** | 2바이트 정수 (작은 숫자용). | SMALLINT |
| **VARCHAR(n)** | 최대 n자 문자열. | VARCHAR(n) |
| **TEXT** | 길이 제한 없는 문자열. | TEXT, CLOB |
| **BOOLEAN** | true / false. | BIT(1), TINYINT(1) |
| **TIMESTAMPTZ** | 날짜+시간+시간대(UTC 등). **권장.** | DATETIMEOFFSET, TIMESTAMP WITH TIME ZONE |
| **TIMESTAMP** (without time zone) | 날짜+시간만 (시간대 없음). | DATETIME |

**TIMESTAMPTZ를 쓰는 이유**  
- 서버가 어느 나라에 있든 "UTC 기준"으로 저장해 두면,  
  앱에서 사용자 시간대로 바꿔서 보여 주기 쉽고, "여름/겨울 시간" 문제도 줄어듭니다.

---

## 4. PostGIS와 공간 데이터란?

### 4.1 PostGIS가 필요한 이유

- "**이 위도·경도에서 반경 2km 안에 있는 트럭**"을 찾는 식의 **공간 쿼리**를 하고 싶습니다.
- 일반 RDBMS에는 "점(위도, 경도)" 타입이 없고,  
  위도·경도를 두 컬럼으로 넣어도 "거리 계산""반경 안/밖"을 SQL만으로 하기 어렵습니다.
- **PostGIS**는 PostgreSQL에 "위치(점, 선, 영역)"를 저장하고,  
  **거리 계산**, **반경 검색**, **영역 포함 여부** 등을 SQL 함수로 제공합니다.

### 4.2 확장(Extension)이란?

- PostgreSQL은 **Extension**으로 기능을 추가합니다.
- 우리는 `CREATE EXTENSION postgis;` 로 PostGIS를 켜 둡니다.  
  한 번만 실행하면 되고, DB를 만들 때 이미 적용해 두었습니다.

### 4.3 좌표계와 SRID 4326

- 지도·GPS에서 쓰는 "위도·경도"는 보통 **WGS84** 라는 좌표계입니다.
- PostGIS에서는 이걸 **SRID(Spatial Reference ID) 4326** 으로 나타냅니다.
- **4326 = WGS84** 라고 외우면 됩니다.  
  점을 만들 때 `ST_SetSRID(ST_MakePoint(경도, 위도), 4326)` 처럼 4326을 붙여 주면 됩니다.

### 4.4 geometry vs geography

| 타입 | 설명 | 단위 | 쓰는 경우 |
|------|------|------|-----------|
| **geometry** | 평면 좌표로 취급. | 도(°), 미터 등 (좌표계에 따름) | 지도 타일·좌표 변환 등 |
| **geography** | "지구를 구로 본" 좌표. | 거리는 **미터** | **거리·반경 검색** (우리처럼 "N km 안") |

- **반경 N km 검색**처럼 "실제 거리(미터)"가 중요하면 **geography** 를 쓰는 것이 좋습니다.
- 우리 스키마에서는 **locations.geom** 을 `geography(Point)` 로 설계했습니다.

### 4.5 Point(점) 만들기

- **위도(latitude), 경도(longitude)** 순서가 아니라,  
  PostGIS에서는 **경도(longitude), 위도(latitude)** 순서입니다. (많은 지도 API도 그렇습니다.)
- 예: 서울 근처 (위도 37.5, 경도 127.0)  
  `ST_SetSRID(ST_MakePoint(127.0, 37.5), 4326)::geography`  
  - `ST_MakePoint(경도, 위도)`  
  - `ST_SetSRID(..., 4326)` → WGS84 지정  
  - `::geography` → geography 타입으로 쓰겠다고 변환

---

## 5. 자주 쓰는 PostGIS 함수 (우리 프로젝트 기준)

| 함수 | 설명 |
|------|------|
| **ST_MakePoint(lng, lat)** | 경도, 위도로 점 생성. |
| **ST_SetSRID(geom, 4326)** | 좌표계를 WGS84(4326)로 지정. |
| **ST_DWithin(A, B, 거리_미터)** | A와 B가 "거리_미터" 이내면 true. 반경 검색에 사용. |
| **ST_Distance(A, B)** | A와 B 사이 거리 (geography면 미터). |
| **GIST 인덱스** | `CREATE INDEX ... ON 테이블 USING GIST (geom);`  
  공간 컬럼에 꼭 걸어 두면 반경 검색이 빨라집니다. |

---

## 6. DB에 접속하고 쿼리 실행하기

### 6.1 연결 정보 (우리 프로젝트)

- **호스트:** localhost  
- **포트:** 5432  
- **DB 이름:** whereistruck  
- **사용자:** whereistruck  
- **비밀번호:** SETUP.md에 적힌 값 사용  

연결 문자열 예:  
`postgresql://whereistruck:비밀번호@localhost:5432/whereistruck`

### 6.2 psql (명령줄 클라이언트)

- PostgreSQL 설치 시 함께 들어 있는 **psql** 로 접속할 수 있습니다.
- Windows 예 (PowerShell, 비밀번호는 대화형으로 입력):

```powershell
& "C:\Program Files\PostgreSQL\17\bin\psql.exe" -U whereistruck -h localhost -p 5432 -d whereistruck
```

- 접속 후 예시:
  - `\dt` → 테이블 목록  
  - `\d 테이블이름` → 해당 테이블 컬럼·타입  
  - `SELECT * FROM users LIMIT 5;` → SQL 실행 (끝에 세미콜론 필수)

### 6.3 GUI 도구

- **pgAdmin** (PostgreSQL 공식), **DBeaver**, **TablePlus** 등으로 같은 연결 정보를 넣어 접속할 수 있습니다.
- "호스트=localhost, 포트=5432, DB=whereistruck, 사용자=whereistruck, 비밀번호=…" 로 설정하면 됩니다.

---

## 7. 용어 사전 (글래스터리)

| 용어 | 설명 |
|------|------|
| **Extension** | PostgreSQL에 기능을 붙이는 모듈. PostGIS가 대표적. |
| **GIST** | PostgreSQL의 "일반화된 검색 트리" 인덱스. 공간 인덱스는 보통 GIST 사용. |
| **geography** | PostGIS 타입. 지구를 구로 가정하고, 거리 단위는 미터. |
| **geometry** | PostGIS 타입. 평면 좌표. 도·미터 등은 좌표계에 따름. |
| **Point** | "한 점" (위도·경도 한 쌍). |
| **SRID** | Spatial Reference ID. 4326 = WGS84(위도·경도). |
| **ST_...** | PostGIS의 "공간(Spatial)" 함수들. ST_DWithin, ST_Distance 등. |
| **TIMESTAMPTZ** | 시간대를 포함한 타임스탬프 (권장: UTC로 저장). |
| **SERIAL** | 자동 증가 정수 컬럼 (PK용). |

---

## 8. 다음에 읽을 문서

- **docs/DB-SCHEMA.md** — 테이블별 컬럼, 관계, 인덱스, 반경 검색 예시.
- **SETUP.md** — DB 비밀번호, 연결 방법 요약.

궁금한 용어가 나오면 이 가이드의 **§7 용어 사전**과 **§4 PostGIS** 섹션을 먼저 찾아 보시면 됩니다.
