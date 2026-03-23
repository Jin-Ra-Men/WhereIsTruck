-- WhereIsTruck owner 권한 요청/결제 요청 테이블
-- 실행: psql -U whereistruck -d whereistruck -f 002_owner_access_requests.sql

-- 추천 기반 사장님 권한 요청
CREATE TABLE IF NOT EXISTS owner_recommendation_requests (
  id SERIAL PRIMARY KEY,
  user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  business_name VARCHAR(120) NOT NULL,
  description TEXT,
  status VARCHAR(20) NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'approved', 'rejected')),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS owner_recommendation_requests_user_id_idx
  ON owner_recommendation_requests (user_id);
CREATE INDEX IF NOT EXISTS owner_recommendation_requests_status_idx
  ON owner_recommendation_requests (status);

-- 유료 즉시 권한 요청/결제 상태
CREATE TABLE IF NOT EXISTS owner_payment_requests (
  id SERIAL PRIMARY KEY,
  user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  plan VARCHAR(50) NOT NULL,
  amount INTEGER NOT NULL CHECK (amount > 0),
  currency VARCHAR(10) NOT NULL DEFAULT 'KRW',
  status VARCHAR(30) NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'paid', 'cancelled')),
  payment_request_id VARCHAR(80) NOT NULL UNIQUE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS owner_payment_requests_user_id_idx
  ON owner_payment_requests (user_id);
CREATE INDEX IF NOT EXISTS owner_payment_requests_status_idx
  ON owner_payment_requests (status);

DROP TRIGGER IF EXISTS owner_recommendation_requests_updated_at ON owner_recommendation_requests;
CREATE TRIGGER owner_recommendation_requests_updated_at
  BEFORE UPDATE ON owner_recommendation_requests
  FOR EACH ROW EXECUTE PROCEDURE set_updated_at();

DROP TRIGGER IF EXISTS owner_payment_requests_updated_at ON owner_payment_requests;
CREATE TRIGGER owner_payment_requests_updated_at
  BEFORE UPDATE ON owner_payment_requests
  FOR EACH ROW EXECUTE PROCEDURE set_updated_at();
