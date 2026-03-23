# DB 마이그레이션

초기 스키마는 SQL 파일로 제공됩니다. TypeORM `synchronize`는 사용하지 않으며, 스키마 변경 시 이 폴더에 SQL을 추가해 적용합니다.

## 실행 방법

프로젝트 루트에서:

```powershell
$env:PGPASSWORD = 'WhereIsTrucksOwnerIsJinLee'
& "C:\Program Files\PostgreSQL\17\bin\psql.exe" -U whereistruck -h localhost -p 5432 -d whereistruck -f scripts/migrations/001_initial_schema.sql
```

또는 `scripts/migrations/` 로 이동한 뒤:

```powershell
psql -U whereistruck -h localhost -d whereistruck -f 001_initial_schema.sql
```

(비밀번호는 프롬프트에 입력하거나 `PGPASSWORD` 환경 변수로 설정)

## 파일

- **001_initial_schema.sql** — users, trucks, locations, favorites, reviews 테이블 및 인덱스·트리거 생성. PostGIS 확장 사용.
- **002_owner_access_requests.sql** — 사장님 권한 2트랙(추천 요청, 유료 즉시 권한 결제 요청) 테이블 및 인덱스·트리거 생성.
- **003_admin_rbac_and_audit_logs.sql** — 관리자 RBAC를 위해 `users.role`에 `admin` 추가, 운영 감사 로그(`audit_logs`) 테이블 및 인덱스 생성.
