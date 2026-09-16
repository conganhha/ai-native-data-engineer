# Data Contract

## ID
- Customer: `CUS000001`
- Category: `CAT001`
- Product: `PRD000001`
- Order: `ORD000001`
- Order item: `ITM00000001`
- Payment: `PAY000001`

## Time
ISO 8601, timezone `+07:00` trong dữ liệu API; PostgreSQL lưu `TIMESTAMPTZ`.

## Money
Đơn vị: VND. Dùng `NUMERIC(14,2)` trong PostgreSQL.

## Enumerations
- customer status: `active`, `inactive`
- product status: `active`, `inactive`, `discontinued`
- order status: `pending`, `confirmed`, `shipped`, `completed`, `cancelled`
- payment status: `pending`, `success`, `failed`, `refunded`
- payment method: `cash`, `bank_transfer`, `card`, `e_wallet`
- channel: `web`, `mobile_app`, `social`

## Audit columns
`source_system`, `ingested_at`, `created_at`, `updated_at`.
