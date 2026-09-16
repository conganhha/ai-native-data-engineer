#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"
[ -f .env ] || cp .env.example .env
source .env

echo "[1/4] Starting PostgreSQL..."
docker compose up -d postgres
until docker exec ecommerce-postgres pg_isready -U "$POSTGRES_USER" -d "$POSTGRES_DB" >/dev/null 2>&1; do sleep 1; done

echo "[2/4] Resetting CORE/MART..."
docker exec -i ecommerce-postgres psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" -v ON_ERROR_STOP=1 <<'SQL'
DROP SCHEMA IF EXISTS mart CASCADE;
DROP SCHEMA IF EXISTS core CASCADE;
SQL

echo "[3/4] Creating OLTP from YOUR student SQL..."
docker exec -i ecommerce-postgres psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" -v ON_ERROR_STOP=1 < sql/student/01_create_oltp.sql

echo "[4/4] Loading seed data..."
for f in categories customers products orders order_items payments; do
  docker cp "data/seed/${f}.csv" "ecommerce-postgres:/tmp/${f}.csv"
done

docker exec -i ecommerce-postgres psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" -v ON_ERROR_STOP=1 <<'SQL'
\copy core.categories(category_id,category_name,parent_category_id,created_at,updated_at) FROM '/tmp/categories.csv' CSV HEADER NULL '';
\copy core.customers(customer_id,full_name,email,phone,city,customer_segment,status,source_system,created_at,updated_at) FROM '/tmp/customers.csv' CSV HEADER;
\copy core.products(product_id,category_id,product_name,unit_price,cost_price,status,source_system,created_at,updated_at) FROM '/tmp/products.csv' CSV HEADER;
\copy core.orders(order_id,customer_id,order_date,status,shipping_city,channel,order_total,source_system,created_at,updated_at) FROM '/tmp/orders.csv' CSV HEADER;
\copy core.order_items(order_item_id,order_id,product_id,quantity,unit_price,discount_amount,source_system,created_at,updated_at) FROM '/tmp/order_items.csv' CSV HEADER;
\copy core.payments(payment_id,order_id,payment_date,payment_method,payment_status,amount,source_system,created_at,updated_at) FROM '/tmp/payments.csv' CSV HEADER;
SQL

echo "STUDENT CORE READY. If this fails, fix sql/student/01_create_oltp.sql first."
