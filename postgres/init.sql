-- schema
CREATE SCHEMA IF NOT EXISTS oltp;
CREATE SCHEMA IF NOT EXISTS analytics;

-- aktifkan extension (kalau build sukses, ini OK)
CREATE EXTENSION IF NOT EXISTS pg_duckdb;

-- tabel transaksi sederhana
CREATE TABLE IF NOT EXISTS oltp.orders (
  id BIGSERIAL PRIMARY KEY,
  created_at timestamptz DEFAULT now(),
  region text,
  customer_id bigint,
  total_amount numeric
);

CREATE TABLE IF NOT EXISTS oltp.order_items (
  id BIGSERIAL PRIMARY KEY,
  order_id bigint REFERENCES oltp.orders(id),
  sku text,
  qty int,
  price numeric
);

-- data dummy: 50k orders, 150k items (cukup enteng utk Codespaces)
INSERT INTO oltp.orders (created_at, region, customer_id, total_amount)
SELECT
  now() - (g * interval '1 minute'),
  (ARRAY['EAST','WEST','NORTH','SOUTH'])[1 + (random()*3)::int],
  (random()*10000)::int,
  round((random()*1000)::numeric,2)
FROM generate_series(1,50000) AS g;

INSERT INTO oltp.order_items (order_id, sku, qty, price)
SELECT
  (random()*49999 + 1)::bigint,
  'SKU-' || (1000 + (random()*2000)::int),
  1 + (random()*5)::int,
  round((10 + random()*90)::numeric,2)
FROM generate_series(1,150000);

-- materialized view analitik contoh
CREATE MATERIALIZED VIEW IF NOT EXISTS analytics.sales_daily AS
SELECT
  date_trunc('day', o.created_at) AS sales_date,
  o.region,
  SUM(oi.qty) AS qty,
  SUM(oi.qty * oi.price) AS amount
FROM oltp.orders o
JOIN oltp.order_items oi ON oi.order_id = o.id
GROUP BY 1,2;

-- index buat filtering cepat (optional)
CREATE INDEX IF NOT EXISTS idx_sales_daily_date ON analytics.sales_daily (sales_date);
