# Business Requirements – E-commerce Data Platform

## Bối cảnh
Doanh nghiệp vận hành một nền tảng E-commerce đa danh mục. Dữ liệu phát sinh từ hệ thống khách hàng, catalog sản phẩm, đơn hàng và thanh toán. Nhóm Data Engineering phải xây dựng nền tảng dữ liệu có thể phục vụ báo cáo kinh doanh hằng ngày và tiếp nhận dữ liệu mới tự động.

## Nghiệp vụ chính
1. Mỗi khách hàng có một `customer_id` duy nhất; email hợp lệ và không trùng trong tập dữ liệu chuẩn.
2. Mỗi sản phẩm thuộc một category; giá bán và giá vốn không âm.
3. Một order thuộc đúng một customer và có một hoặc nhiều order item.
4. Quantity phải lớn hơn 0; discount không âm và không vượt gross amount.
5. Trạng thái order: `pending`, `confirmed`, `shipped`, `completed`, `cancelled`.
6. Trạng thái payment: `pending`, `success`, `failed`, `refunded`.
7. Payment phải tham chiếu order tồn tại và `payment_date >= order_date`.
8. Dữ liệu mới được nạp theo `updated_at`; rerun cùng batch không được tạo duplicate.

## KPI cần hỗ trợ
- Total Revenue (doanh thu net của order completed)
- Total Orders
- Average Order Value (AOV)
- Active Customers
- New Customers
- Payment Success Rate
- Revenue by category/product/customer segment/channel
- Top customers / products
- Daily and monthly running revenue
- Cohort theo tháng phát sinh đơn đầu tiên

## Yêu cầu nền tảng
- RAW giữ nguyên dữ liệu nguồn.
- STAGING chuẩn hóa định dạng và kiểm tra dữ liệu.
- CORE PostgreSQL chứa OLTP normalized.
- SALES DATA MART dùng Star Schema cho analytics.
- Mỗi pipeline run có audit: `run_id`, thời gian, trạng thái, input/valid/rejected/inserted/updated.
