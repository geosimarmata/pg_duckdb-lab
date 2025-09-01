-- 1) Aktifkan ekstensi DuckDB
CREATE EXTENSION IF NOT EXISTS pg_duckdb;

-- 2) User untuk koneksi Metabase ke DWH (bukan app DB metadata)
DO $$
BEGIN
  IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'metabase') THEN
    CREATE USER metabase LOGIN PASSWORD 'metabase_pwd';
  END IF;
END$$;

-- 3) Izin connect ke DB aplikasi/warehouse
GRANT CONNECT ON DATABASE appdb TO metabase;

-- 4) Optimisasi OLAP untuk user metabase
ALTER USER metabase SET duckdb.force_execution TO true;

-- 5) Schema analitik opsional
CREATE SCHEMA IF NOT EXISTS analytics AUTHORIZATION metabase;

-- 6) Pastikan role bawaan DuckDB ada & di-grant
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'duckdb.postgres_role') THEN
    CREATE ROLE "duckdb.postgres_role";
  END IF;
END$$;

GRANT "duckdb.postgres_role" TO metabase;
GRANT "duckdb.postgres_role" TO metabase_app;
ALTER USER metabase_app SET duckdb.force_execution TO true;
