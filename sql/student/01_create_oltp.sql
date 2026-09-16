-- 01_create_oltp.sql
CREATE SCHEMA IF NOT EXISTS core;
SET search_path TO core, public;

CREATE TABLE IF NOT EXISTS categories (
  category_id VARCHAR(10) PRIMARY KEY,
  category_name VARCHAR(120) NOT NULL,
  parent_category_id VARCHAR(10) REFERENCES categories(category_id),
  created_at TIMESTAMPTZ NOT NULL,
  updated_at TIMESTAMPTZ NOT NULL
);

-- TODO: Hoàn thiện constraints theo Data Contract
CREATE TABLE IF NOT EXISTS customers (
  customer_id VARCHAR(12) PRIMARY KEY,
  full_name VARCHAR(150) NOT NULL,
  email VARCHAR(200) NOT NULL UNIQUE,
  phone VARCHAR(30),
  city VARCHAR(100),
  customer_segment VARCHAR(30) NOT NULL,
  status VARCHAR(20) NOT NULL CHECK (status IN ('active','inactive')),
  source_system VARCHAR(50) NOT NULL DEFAULT 'unknown',
  ingested_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  created_at TIMESTAMPTZ NOT NULL,
  updated_at TIMESTAMPTZ NOT NULL
);

CREATE TABLE IF NOT EXISTS products (
  product_id VARCHAR(12) PRIMARY KEY,
  category_id VARCHAR(10) NOT NULL REFERENCES categories(category_id),
  product_name VARCHAR(200) NOT NULL,
  unit_price NUMERIC(14,2) NOT NULL CHECK (unit_price >= 0),
  cost_price NUMERIC(14,2) NOT NULL CHECK (cost_price >= 0),
  status VARCHAR(20) NOT NULL CHECK (status IN ('active','inactive','discontinued')),
  source_system VARCHAR(50) NOT NULL DEFAULT 'unknown',
  ingested_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  created_at TIMESTAMPTZ NOT NULL,
  updated_at TIMESTAMPTZ NOT NULL
);

CREATE TABLE IF NOT EXISTS orders (
  order_id VARCHAR(12) PRIMARY KEY,
  customer_id VARCHAR(12) NOT NULL REFERENCES customers(customer_id),
  order_date TIMESTAMPTZ NOT NULL,
  status VARCHAR(20) NOT NULL CHECK (status IN ('pending','confirmed','shipped','completed','cancelled')),
  shipping_city VARCHAR(100),
  channel VARCHAR(20) NOT NULL CHECK (channel IN ('web','mobile_app','social')),
  order_total NUMERIC(14,2) NOT NULL CHECK (order_total >= 0),
  source_system VARCHAR(50) NOT NULL DEFAULT 'unknown',
  ingested_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  created_at TIMESTAMPTZ NOT NULL,
  updated_at TIMESTAMPTZ NOT NULL
);

CREATE TABLE IF NOT EXISTS order_items (
  order_item_id VARCHAR(16) PRIMARY KEY,
  order_id VARCHAR(12) NOT NULL REFERENCES orders(order_id) ON DELETE CASCADE,
  product_id VARCHAR(12) NOT NULL REFERENCES products(product_id),
  quantity INTEGER NOT NULL CHECK (quantity > 0),
  unit_price NUMERIC(14,2) NOT NULL CHECK (unit_price >= 0),
  discount_amount NUMERIC(14,2) NOT NULL DEFAULT 0 CHECK (discount_amount >= 0),
  source_system VARCHAR(50) NOT NULL DEFAULT 'unknown',
  ingested_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  created_at TIMESTAMPTZ NOT NULL,
  updated_at TIMESTAMPTZ NOT NULL,
  CHECK (discount_amount <= unit_price * quantity)
);

CREATE TABLE IF NOT EXISTS payments (
  payment_id VARCHAR(12) PRIMARY KEY,
  order_id VARCHAR(12) NOT NULL REFERENCES orders(order_id),
  payment_date TIMESTAMPTZ NOT NULL,
  payment_method VARCHAR(30) NOT NULL CHECK (payment_method IN ('cash','bank_transfer','card','e_wallet')),
  payment_status VARCHAR(20) NOT NULL CHECK (payment_status IN ('pending','success','failed','refunded')),
  amount NUMERIC(14,2) NOT NULL CHECK (amount >= 0),
  source_system VARCHAR(50) NOT NULL DEFAULT 'unknown',
  ingested_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  created_at TIMESTAMPTZ NOT NULL,
  updated_at TIMESTAMPTZ NOT NULL
);

CREATE INDEX IF NOT EXISTS idx_orders_customer ON orders(customer_id);
CREATE INDEX IF NOT EXISTS idx_orders_date ON orders(order_date);
CREATE INDEX IF NOT EXISTS idx_order_items_order ON order_items(order_id);
CREATE INDEX IF NOT EXISTS idx_order_items_product ON order_items(product_id);
CREATE INDEX IF NOT EXISTS idx_payments_order ON payments(order_id);
