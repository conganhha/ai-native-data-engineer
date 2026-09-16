# Lab 4: Thiết kế Sales Data Mart

**Thời lượng:** 90 phút. **Mục tiêu:** tạo ra artifact có thể tái sử dụng ở buổi sau.

## Chuẩn bị
- Mở Docker Desktop, VS Code, DBeaver.
- `source .venv/bin/activate` từ buổi 5 trở đi.

## Các bước
1. **Xác định process và grain** – thực hiện, ghi lại bằng chứng chạy và commit kết quả.
2. **Thiết kế dimensions/fact** – thực hiện, ghi lại bằng chứng chạy và commit kết quả.
3. **Viết DDL và load** – thực hiện, ghi lại bằng chứng chạy và commit kết quả.
4. **Truy vấn KPI từ mart** – thực hiện, ghi lại bằng chứng chạy và commit kết quả.
5. **Đối soát OLTP ↔ Data Mart** – thực hiện, ghi lại bằng chứng chạy và commit kết quả.

## Checkpoint
- Không có lỗi blocking.
- Kết quả chạy đối soát được.
- Source/config/log được lưu đúng thư mục.

## Material
- `sql/student/04_data_mart.sql`
- `sql/solutions/10_create_sales_data_mart.sql`
- `sql/solutions/12_load_data_mart.sql`

## Nộp bài
Commit theo mẫu: `session-04: <mô tả ngắn>` và nộp repository hoặc file theo LMS.
