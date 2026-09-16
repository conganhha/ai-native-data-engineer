# Lab 5: Python cơ bản cho Data Pipeline

**Thời lượng:** 90 phút. **Mục tiêu:** tạo skeleton Python có thể tái sử dụng ở Buổi 6–8.

## Chuẩn bị
```bash
python3.11 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
# Chỉ chạy một lần khi bắt đầu phần Python:
[ -d src ] || cp -R starter/src src
```

## Các bước
1. **Đọc CSV/JSON** – hoàn thiện `src/extract_files.py`.
2. **Profiling** – rows/columns/missing/duplicate; chạy trên `data/incremental/day_2026-07-01`.
3. **Normalize** – hoàn thiện `src/transform.py`: text, email/enums, numeric, datetime.
4. **Config** – đọc `.env`, không hard-code secret; kiểm tra `src/config.py`.
5. **Logging & exception** – hoàn thiện `src/logger.py`; ghi log vào `logs/`.
6. **Evidence** – lưu output/profile/log và commit.

## Checkpoint tối thiểu
- Đọc được 5 dataset: customers, products, orders, order_items, payments.
- Profile row counts đúng với batch sạch.
- `normalize()` không sửa file RAW/source.
- Log có timestamp, level và message.

## Material học viên
- `starter/src/` (copy sang `src/` rồi hoàn thiện)
- `data/incremental/day_2026-07-01/`
- `.env.example`, `requirements.txt`

## Không dùng khi đang làm bài
- `src/` trong Instructor Pack là reference solution; học viên không được nhận.

## Nộp bài
Commit: `session-05: file ingestion + normalize + logging`.
