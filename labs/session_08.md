# Lab 8: Tự động hóa Daily Pipeline và End-to-End

**Thời lượng:** 90 phút. **Mục tiêu:** nối các artifact Buổi 5–7 thành daily pipeline có checkpoint và rerun-safe.

## Kiến trúc phải đạt
`FILE/API -> RAW -> NORMALIZE -> VALIDATE -> REJECT/VALID -> UPSERT CORE -> DQ REPORT -> CHECKPOINT -> REFRESH MART`

## Các bước
1. **Orchestration** – hoàn thiện `src/pipeline.py`, xử lý theo dependency order.
2. **Multi-source** – hỗ trợ `file`, `api`, và `both` (gợi ý: customer/product từ file; transaction từ API).
3. **Retry + RAW + secrets** – tái sử dụng code Buổi 6; secret chỉ lấy từ `.env`.
4. **Checkpoint/watermark** – chỉ cập nhật sau successful run; API dùng `updated_after`.
5. **Idempotency** – chạy pipeline 2 lần; PK counts không nhân đôi.
6. **Data Quality** – reject + DQ report vẫn được sinh khi có dirty rows.
7. **Refresh Data Mart** – dùng SQL nhóm đã xây dựng ở Buổi 4; đo KPI trước/sau.
8. **Automation** – tạo `scripts/run_daily.sh`; xem `scripts/cron_example.txt` và giải thích scheduling.
9. **Demo mini project** – 5–7 phút: architecture, một lỗi thật, recovery/rerun, KPI change.

## Lệnh mục tiêu sau khi hoàn thiện
```bash
python -m src.pipeline --source file --input-dir data/incremental/day_2026-07-01
python -m src.pipeline --source both --input-dir data/incremental/day_2026-07-01 --refresh-mart
# chạy lại để chứng minh rerun-safe
python -m src.pipeline --source both --input-dir data/incremental/day_2026-07-01 --refresh-mart
```

## Checkpoint tối thiểu
- Có `logs/pipeline.log`, `reports/data_quality_report.csv`, `metadata/pipeline_state.json`.
- Có RAW API snapshot trong `data/raw/<run_id>/`.
- Có reject files nếu chạy dirty batch.
- Rerun không tạo duplicate PK.
- Data Mart refresh được và KPI đối soát được với CORE.

## Material học viên
- `src/pipeline.py`, `src/refresh_mart.py`
- `.env.example`, `scripts/run_daily.sh`, `scripts/cron_example.txt`
- `assignments/mini_project.md`

## Nộp bài
Commit: `session-08: end-to-end daily pipeline`.
