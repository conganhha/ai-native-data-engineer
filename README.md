# AI-Native Data Engineering – Module 1 – STUDENT PACK v2

Đây là **bản không chứa đáp án**. Học viên có thể dùng trong 8 buổi; giảng viên nên phát material theo lịch từng buổi nếu muốn giữ nhịp challenge/quiz.

## Folder dùng để làm gì?
- `slides/`: slide học; thường phát sau phần lecture/reveal của buổi.
- `docs/`: requirement, data contract, data dictionary và Student Lab Manual.
- `labs/`: hướng dẫn thực hành từng buổi.
- `assignments/`: bài tập sau buổi + mini project.
- `data/seed/`: baseline database cho Buổi 2–4.
- `data/incremental/day_2026-07-01/`: daily batch sạch cho Buổi 5–6–8.
- `data/dirty/day_2026-07-02/`: dirty challenge cho Buổi 7; không sửa RAW trực tiếp.
- `sql/student/`: nơi viết SQL Buổi 1–4.
- `starter/src/`: Python skeleton. Đầu Buổi 5 chạy `[ -d src ] || cp -R starter/src src`, sau đó chỉ sửa `src/` của nhóm.
- `mock_api/`: REST API giả lập cho Buổi 6–8.
- `tests/test_validators_public.py`: public Data Quality tests; giảng viên có hidden tests riêng.
- `metadata/`, `reports/`, `logs/`, `data/raw/`, `data/reject/`: **output/runtime artifacts**, không phải lời giải hay dataset gốc.
- `scripts/`: setup/reset và ví dụ scheduling.

## Không có trong pack này
Không có `sql/solutions/`, reference `src/`, canonical ERD, Dirty Data Manifest, quiz answer, hidden tests, Instructor Guide hay source references.

## Quick start
```bash
cp .env.example .env
docker compose up -d postgres
# Sau khi hoàn thiện SQL Buổi 1:
./scripts/bootstrap.sh
python3.11 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

Từ Buổi 6:
```bash
docker compose up -d mock-api
```
