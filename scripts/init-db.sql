-- WhereIsTruck: DB 사용자·DB 생성 및 PostGIS 확장 활성화
-- 실행: psql -U postgres -f init-db.sql (또는 setup-db.ps1)

-- 1. 사용자 생성 (이미 있으면 무시)
DO $$
BEGIN
  IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'whereistruck') THEN
    CREATE ROLE whereistruck WITH LOGIN PASSWORD 'WhereIsTrucksOwnerIsJinLee';
  END IF;
END
$$;

-- 2. DB 생성 (이미 있으면 건너뜀)
SELECT 'CREATE DATABASE whereistruck OWNER whereistruck'
WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = 'whereistruck')\gexec

-- 3. whereistruck DB에 연결해서 실행할 부분은 별도 세션에서 수행
--    아래는 postgres로 DB 생성 후, 해당 DB에서 extension 활성화용

\c whereistruck

-- 4. PostGIS 확장 활성화 (PostGIS 설치 후에만 성공)
CREATE EXTENSION IF NOT EXISTS postgis;

-- 5. 권한 부여
GRANT ALL ON SCHEMA public TO whereistruck;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES TO whereistruck;
