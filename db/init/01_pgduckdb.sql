-- 1) aktifkan ekstensi
CREATE EXTENSION IF NOT EXISTS pg_duckdb;

-- 2) user khusus Metabase
DO $$
BEGIN
  IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'metabase') THEN
    CREATE USER metabase LOGIN PASSWORD 'metabase_pwd';
  END IF;
END$$;

-- 3) izin dasar & connect
GRANT CONNECT ON DATABASE appdb TO metabase;

-- 4) percepat OLAP untuk koneksi Metabase (opt-in sesuai README)
ALTER USER metabase SET duckdb.force_execution TO true;

-- (opsional) skema khusus analitik
CREATE SCHEMA IF NOT EXISTS analytics AUTHORIZATION metabase;
