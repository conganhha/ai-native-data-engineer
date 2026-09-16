# Lab 6: Data Ingestion từ REST API

**Thời lượng:** 90 phút. **Mục tiêu:** ingest API có pagination, retry, RAW capture và upsert.

## Chuẩn bị
```bash
source .venv/bin/activate
docker compose up -d mock-api
curl -H "X-API-Key: training-key" "http://localhost:8000/orders?page=1&page_size=5"
```

## Các bước
1. **Khám phá API** – `/health`, API key, `page`, `page_size`, `updated_after`.
2. **HTTP client** – hoàn thiện `src/api_client.py`: timeout, `raise_for_status`, bounded retry.
3. **Pagination** – fetch đến khi `has_next=false`.
4. **RAW first** – lưu response vào `data/raw/<run_id>/` trước normalize.
5. **Upsert** – hoàn thiện `src/load_postgres.py` bằng `ON CONFLICT ... DO UPDATE`.
6. **Idempotency** – chạy cùng payload 2 lần, row count CORE không tăng do duplicate PK.
7. **Checkpoint concept** – thiết kế watermark `updated_at` trong `metadata/pipeline_state.json` (orchestration hoàn thiện ở Buổi 8).

## Checkpoint tối thiểu
- API sai key trả lỗi; code xử lý exception rõ ràng.
- Pagination lấy đủ records.
- Có RAW JSON artifact.
- Rerun không tạo duplicate PK trong PostgreSQL.

## Material học viên
- `mock_api/`
- `src/api_client.py`, `src/load_postgres.py`
- `metadata/`, `data/raw/`

## Nộp bài
Commit: `session-06: api pagination retry raw upsert`.
