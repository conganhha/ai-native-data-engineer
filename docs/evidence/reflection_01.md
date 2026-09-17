# Khó khăn khi cài Docker/DBeaver:
## Docker:
Đối với Docker, em không gặp khó khăn gì vì đã từng sử dụng từ trước.
## DBeaver:
Em gặp 1 chút khó khăn khi connect tới PostgreSQL. Lỗi cụ thể là `FATAL: role "de_user" does not exist`. Sau khi tìm hiểu nguyên nhân, em phát hiện máy đang chạy một Postgres (của HomeBrew) khác dẫn đến xung đột và em đã tự khắc phục được.
# Lý do chọn data types cho tiền tệ/thời gian/ID:
## Tiền tệ
- Data type: `numeric(14,2)`
- Lý do:
    + Tiền tệ có thể là số thực. Ví dụ `$1.5`.
    + Lý do em không dùng `float` vì sai số tính toán của nó. Ví dụ: `0.001 + 0.002 = 0.00300004...`.
## Thời gian
- Data type: `timestampz`
- Lý do: Em không sử dụng `varchar` cho thời gian vì không thể validate cũng như không thể sort hoặc filter được.
## ID
- Data type: `serial`
- Lý do: Số tự tăng, ID có kích thước nhỏ.
# Hiểu thế nào về quan hệ 1:N giữa customers và orders? Vẽ/kể ví dụ 1 customer có N orders.
- Mỗi 1 khách hàng có thể có nhiều đơn hàng và mỗi đơn hàng chỉ thuộc về đúng 1 khách hàng.
- VD: Tài khoản shopee của em đang có rất nhiều đơn hàng và những đơn hàng này chỉ thuộc về em.
# Nếu schema cần sửa sau này (thêm cột, đổi FK), bạn sẽ xử lý thế nào (ALTER vs tạo lại)?
- Nếu schema cần sửa sau này, em sẽ ưu tiên dùng migration với ALTER TABLE thay vì tạo lại toàn bộ bảng, vì dữ liệu production cần được bảo toàn.