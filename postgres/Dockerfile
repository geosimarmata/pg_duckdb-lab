FROM postgres:15

# alat build & header postgres
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential ca-certificates curl git make cmake ninja-build pkg-config \
    libssl-dev zlib1g-dev postgresql-server-dev-all \
 && rm -rf /var/lib/apt/lists/*

# ambil & build pg_duckdb
RUN git clone --depth 1 https://github.com/duckdb/pg_duckdb.git /tmp/pg_duckdb \
 && cd /tmp/pg_duckdb \
 && make \
 && make install \
 && rm -rf /tmp/pg_duckdb

# aktifkan extension + bikin schema & contoh data saat init
RUN mkdir -p /docker-entrypoint-initdb.d
COPY init.sql /docker-entrypoint-initdb.d/00-init.sql
