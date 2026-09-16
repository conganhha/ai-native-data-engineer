CREATE TABLE IF NOT EXISTS customers (
    customer_id SERIAL PRIMARY KEY,
    email VARCHAR(255) NOT NULL UNIQUE,
    full_name VARCHAR(100),
    city VARCHAR(100),
    phone VARCHAR(30),
    status VARCHAR(20) NOT NULL DEFAULT 'active',

    source_system VARCHAR(50),
    ingested_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL,
    updated_at TIMESTAMPTZ NOT NULL
);

CREATE TABLE IF NOT EXISTS categories (
    category_id SERIAL PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL UNIQUE,
    status VARCHAR(20) NOT NULL DEFAULT 'active',

    source_system VARCHAR(50),
    ingested_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL,
    updated_at TIMESTAMPTZ NOT NULL
);

CREATE TABLE IF NOT EXISTS products (
    product_id SERIAL PRIMARY KEY,
    category_id INTEGER NOT NULL,
    product_name VARCHAR(255) NOT NULL,
    unit_price NUMERIC(14, 2) NOT NULL,
    cost_price NUMERIC(14, 2) NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'active',

    source_system VARCHAR(50),
    ingested_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL,
    updated_at TIMESTAMPTZ NOT NULL,

    CONSTRAINT fk_products_category
        FOREIGN KEY (category_id)
        REFERENCES categories(category_id),

    CONSTRAINT chk_products_unit_price
        CHECK (unit_price >= 0),

    CONSTRAINT chk_products_cost_price
        CHECK (cost_price >= 0)
);

CREATE TABLE IF NOT EXISTS order_status (
    status_id SERIAL PRIMARY KEY,
    status_code VARCHAR(20) NOT NULL UNIQUE,
    status_name VARCHAR(50) NOT NULL
);

CREATE TABLE IF NOT EXISTS orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INTEGER NOT NULL,
    status_id INTEGER NOT NULL,

    order_date TIMESTAMPTZ NOT NULL,
    channel VARCHAR(50) NOT NULL,
    shipping_city VARCHAR(100),

    gross_amount NUMERIC(14, 2) NOT NULL,
    discount_amount NUMERIC(14, 2) NOT NULL DEFAULT 0,

    source_system VARCHAR(50),
    ingested_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL,
    updated_at TIMESTAMPTZ NOT NULL,

    CONSTRAINT fk_orders_customer
        FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id),

    CONSTRAINT fk_orders_status
        FOREIGN KEY (status_id)
        REFERENCES order_status(status_id),

    CONSTRAINT chk_orders_gross_amount
        CHECK (gross_amount >= 0),

    CONSTRAINT chk_orders_discount_amount
        CHECK (discount_amount >= 0),

    CONSTRAINT chk_orders_discount_limit
        CHECK (discount_amount <= gross_amount)
);

CREATE TABLE IF NOT EXISTS order_items (
    order_item_id SERIAL PRIMARY KEY,
    order_id INTEGER NOT NULL,
    product_id INTEGER NOT NULL,

    unit_price NUMERIC(14, 2) NOT NULL,
    quantity INTEGER NOT NULL,
    discount_amount NUMERIC(14, 2) NOT NULL DEFAULT 0,

    source_system VARCHAR(50),
    ingested_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL,
    updated_at TIMESTAMPTZ NOT NULL,

    CONSTRAINT fk_order_items_order
        FOREIGN KEY (order_id)
        REFERENCES orders(order_id),

    CONSTRAINT fk_order_items_product
        FOREIGN KEY (product_id)
        REFERENCES products(product_id),

    CONSTRAINT chk_order_items_quantity
        CHECK (quantity > 0),

    CONSTRAINT chk_order_items_unit_price
        CHECK (unit_price >= 0),

    CONSTRAINT chk_order_items_discount
        CHECK (
            discount_amount >= 0
            AND discount_amount <= unit_price * quantity
        )
);

CREATE TABLE IF NOT EXISTS payments (
    payment_id SERIAL PRIMARY KEY,
    order_id INTEGER NOT NULL,

    payment_method VARCHAR(30) NOT NULL,
    payment_status VARCHAR(20) NOT NULL,
    payment_date TIMESTAMPTZ NOT NULL,
    amount NUMERIC(14, 2) NOT NULL,

    source_system VARCHAR(50),
    ingested_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL,
    updated_at TIMESTAMPTZ NOT NULL,

    CONSTRAINT fk_payments_order
        FOREIGN KEY (order_id)
        REFERENCES orders(order_id),

    CONSTRAINT chk_payments_amount
        CHECK (amount >= 0)
);

CREATE INDEX IF NOT EXISTS idx_products_category_id
    ON products(category_id);

CREATE INDEX IF NOT EXISTS idx_products_updated_at
    ON products(updated_at);

CREATE INDEX IF NOT EXISTS idx_orders_customer_id
    ON orders(customer_id);

CREATE INDEX IF NOT EXISTS idx_orders_status_id
    ON orders(status_id);

CREATE INDEX IF NOT EXISTS idx_orders_order_date
    ON orders(order_date);

CREATE INDEX IF NOT EXISTS idx_orders_updated_at
    ON orders(updated_at);

CREATE INDEX IF NOT EXISTS idx_order_items_order_id
    ON order_items(order_id);

CREATE INDEX IF NOT EXISTS idx_order_items_product_id
    ON order_items(product_id);

CREATE INDEX IF NOT EXISTS idx_order_items_updated_at
    ON order_items(updated_at);

CREATE INDEX IF NOT EXISTS idx_payments_order_id
    ON payments(order_id);

CREATE INDEX IF NOT EXISTS idx_payments_payment_status
    ON payments(payment_status);

CREATE INDEX IF NOT EXISTS idx_payments_payment_date
    ON payments(payment_date);

CREATE INDEX IF NOT EXISTS idx_payments_updated_at
    ON payments(updated_at);