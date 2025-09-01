#!/usr/bin/env bash
set -euo pipefail

# ambil password dari env (lihat .env)
MB_APP_PWD="${METABASE_APP_PASSWORD:-supersecret_change_me}"

# 1) buat user kalau belum ada (BOLEH di dalam DO)
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" \
  -c "DO \$\$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'metabase_app') THEN
    EXECUTE format('CREATE USER metabase_app LOGIN PASSWORD %L', '${MB_APP_PWD}');
  END IF;
END
\$\$;"

# 2) buat database DI LUAR DO/TRANSACTION
if ! psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" \
     -tAc "SELECT 1 FROM pg_database WHERE datname='metabase_db'" | grep -q 1; then
  psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" \
    -c "CREATE DATABASE metabase_db OWNER metabase_app";
fi

# 3) default privileges di DB metadata Metabase
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "metabase_db" <<'EOSQL'
GRANT CREATE, USAGE ON SCHEMA public TO metabase_app;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES    TO metabase_app;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON SEQUENCES TO metabase_app;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON FUNCTIONS TO metabase_app;
EOSQL
