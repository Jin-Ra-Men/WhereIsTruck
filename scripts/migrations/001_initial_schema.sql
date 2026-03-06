-- WhereIsTruck 초기 스키마 (PostgreSQL + PostGIS)
-- 실행: psql -U whereistruck -d whereistruck -f 001_initial_schema.sql
-- 또는: backend/nest에서 npm run typeorm migration:run (TypeORM CLI 사용 시)

-- PostGIS 확장 (이미 있으면 무시)
CREATE EXTENSION IF NOT EXISTS postgis;

-- ----------------------------------------
-- 1. users
-- ----------------------------------------
CREATE TABLE IF NOT EXISTS users (
  id SERIAL PRIMARY KEY,
  firebase_uid VARCHAR(128) NOT NULL,
  role VARCHAR(20) NOT NULL DEFAULT 'user' CHECK (role IN ('user', 'owner')),
  display_name VARCHAR(100),
  email VARCHAR(255),
  profile_image_url VARCHAR(512),
  fcm_token VARCHAR(512),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE UNIQUE INDEX IF NOT EXISTS users_firebase_uid_key ON users (firebase_uid);
CREATE INDEX IF NOT EXISTS users_role_idx ON users (role);

-- ----------------------------------------
-- 2. trucks
-- ----------------------------------------
CREATE TABLE IF NOT EXISTS trucks (
  id SERIAL PRIMARY KEY,
  owner_id INTEGER NOT NULL REFERENCES users(id),
  name VARCHAR(100) NOT NULL,
  description TEXT,
  status VARCHAR(20) NOT NULL DEFAULT 'closed' CHECK (status IN ('open', 'closed')),
  menu_summary VARCHAR(500),
  cover_image_url VARCHAR(512),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS trucks_owner_id_idx ON trucks (owner_id);
CREATE INDEX IF NOT EXISTS trucks_status_idx ON trucks (status);

-- ----------------------------------------
-- 3. locations (PostGIS geography)
-- ----------------------------------------
CREATE TABLE IF NOT EXISTS locations (
  id SERIAL PRIMARY KEY,
  truck_id INTEGER NOT NULL REFERENCES trucks(id),
  geom geography(Point) NOT NULL,
  address_text VARCHAR(255),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS locations_truck_id_created_at_idx ON locations (truck_id, created_at DESC);
CREATE INDEX IF NOT EXISTS locations_geom_idx ON locations USING GIST (geom);

-- ----------------------------------------
-- 4. favorites
-- ----------------------------------------
CREATE TABLE IF NOT EXISTS favorites (
  id SERIAL PRIMARY KEY,
  user_id INTEGER NOT NULL REFERENCES users(id),
  truck_id INTEGER NOT NULL REFERENCES trucks(id),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE (user_id, truck_id)
);

CREATE INDEX IF NOT EXISTS favorites_user_id_idx ON favorites (user_id);
CREATE INDEX IF NOT EXISTS favorites_truck_id_idx ON favorites (truck_id);

-- ----------------------------------------
-- 5. reviews
-- ----------------------------------------
CREATE TABLE IF NOT EXISTS reviews (
  id SERIAL PRIMARY KEY,
  user_id INTEGER NOT NULL REFERENCES users(id),
  truck_id INTEGER NOT NULL REFERENCES trucks(id),
  rating SMALLINT NOT NULL CHECK (rating >= 1 AND rating <= 5),
  body TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS reviews_truck_id_idx ON reviews (truck_id);
CREATE INDEX IF NOT EXISTS reviews_user_id_idx ON reviews (user_id);

-- ----------------------------------------
-- updated_at 자동 갱신 (선택)
-- ----------------------------------------
CREATE OR REPLACE FUNCTION set_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS users_updated_at ON users;
CREATE TRIGGER users_updated_at
  BEFORE UPDATE ON users
  FOR EACH ROW EXECUTE PROCEDURE set_updated_at();

DROP TRIGGER IF EXISTS trucks_updated_at ON trucks;
CREATE TRIGGER trucks_updated_at
  BEFORE UPDATE ON trucks
  FOR EACH ROW EXECUTE PROCEDURE set_updated_at();

DROP TRIGGER IF EXISTS reviews_updated_at ON reviews;
CREATE TRIGGER reviews_updated_at
  BEFORE UPDATE ON reviews
  FOR EACH ROW EXECUTE PROCEDURE set_updated_at();
