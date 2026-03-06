/**
 * WhereIsTruck DB 생성 + PostGIS 확장 활성화
 * 사용: POSTGRES_PASSWORD=비밀번호 node scripts/setup-db.js
 *      (또는 PowerShell: $env:POSTGRES_PASSWORD='비밀번호'; node scripts/setup-db.js)
 */
const { Client } = require('pg');

const POSTGRES_PASSWORD = process.env.POSTGRES_PASSWORD ?? '';
const DB_HOST = process.env.PGHOST || 'localhost';
const DB_PORT = parseInt(process.env.PGPORT || '5432', 10);

async function run() {
  const superuserConfig = {
    host: DB_HOST,
    port: DB_PORT,
    user: 'postgres',
    password: POSTGRES_PASSWORD,
    database: 'postgres',
  };

  const client = new Client(superuserConfig);
  try {
    await client.connect();
  } catch (e) {
    console.error('postgres 연결 실패:', e.message);
    process.exit(1);
  }

  try {
    // 1. 역할 생성 (비밀번호: 프로젝트 기본값 WhereIsTrucksOwnerIsJinLee)
    await client.query(`
      DO $$
      BEGIN
        IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'whereistruck') THEN
          CREATE ROLE whereistruck WITH LOGIN PASSWORD 'WhereIsTrucksOwnerIsJinLee';
        ELSE
          ALTER USER whereistruck WITH PASSWORD 'WhereIsTrucksOwnerIsJinLee';
        END IF;
      END $$;
    `);
    console.log('역할 whereistruck 확인/생성 완료');

    // 2. DB 생성 (없을 때만)
    const dbCheck = await client.query(
      "SELECT 1 FROM pg_database WHERE datname = 'whereistruck'"
    );
    if (dbCheck.rows.length === 0) {
      await client.query('CREATE DATABASE whereistruck OWNER whereistruck');
      console.log('DB whereistruck 생성 완료');
    } else {
      console.log('DB whereistruck 이미 존재');
    }
  } finally {
    await client.end();
  }

  // 3. whereistruck DB에 연결해 PostGIS 확장 활성화
  const appDbClient = new Client({
    ...superuserConfig,
    database: 'whereistruck',
  });
  try {
    await appDbClient.connect();
    await appDbClient.query('CREATE EXTENSION IF NOT EXISTS postgis;');
    console.log('PostGIS 확장 활성화 완료');

    await appDbClient.query('GRANT ALL ON SCHEMA public TO whereistruck;');
    await appDbClient.query(
      'ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES TO whereistruck;'
    );
    console.log('권한 부여 완료');
  } catch (e) {
    console.error('PostGIS/권한 설정 실패:', e.message);
    process.exit(1);
  } finally {
    await appDbClient.end();
  }

  console.log("\n설정 완료. .env의 DATABASE_URL=postgresql://whereistruck:WhereIsTrucksOwnerIsJinLee@localhost:5432/whereistruck 로 연결하면 됩니다.");
}

run();
