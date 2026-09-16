# Lab 7: Data Cleaning & Data Quality

**Thời lượng:** 90 phút. **Mục tiêu:** quarantine dữ liệu lỗi bằng row rules + cross-table integrity.

## Chuẩn bị
1. Database phải có seed và clean batch `day_2026-07-01` từ các buổi trước.
2. Chỉ phát `data/dirty/day_2026-07-02/`; **không phát Dirty Data Manifest trước challenge**.
3. `source .venv/bin/activate`.

## Các bước
1. **Blind profiling challenge (15')** – tìm missing, duplicate, type/date bất thường mà chưa biết đáp án.
2. **Schema validation** – hoàn thiện `src/validators/schema_validator.py`.
3. **Business rules** – email, enum, money >= 0, quantity > 0, discount hợp lệ, required dates.
4. **Cross-table integrity** – hoàn thiện `integrity_validator.py`:
   - product → category;
   - order → customer;
   - order_item → order/product;
   - payment → order;
   - `payment_date >= order_date`.
5. **Duplicate PK** – không tự ý chọn một trong hai record mâu thuẫn; quarantine record ambiguous.
6. **Valid/reject split** – lưu `data/reject/<run_id>/` và giữ RAW nguyên trạng.
7. **DQ report** – dataset-level counts và invariant `Input = Valid + Rejected`.
8. **Pytest** – chạy public tests; giảng viên chấm thêm hidden tests.

## Checkpoint tối thiểu
- Dirty row không làm pipeline crash toàn batch.
- Reject có `error_code` đọc được.
- Referential integrity và payment chronology được kiểm tra.
- `pytest -q tests/test_validators_public.py` pass sau khi hoàn thiện.

## Material học viên
- `data/dirty/day_2026-07-02/`
- `src/validators/`
- `src/quality_report.py`
- `tests/test_validators_public.py`

## Nộp bài
Commit: `session-07: dq validation quarantine report tests`.
