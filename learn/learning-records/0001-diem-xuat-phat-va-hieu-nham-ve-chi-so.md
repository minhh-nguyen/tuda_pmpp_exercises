# Điểm xuất phát: 1.1 xong, 1.2 đang mắc ở mô hình chỉ số

Đã hoàn thành 1.1a/1.1b (cấp phát + copy host↔device) và bắt đầu viết 1.2. Khi làm 1.2 lộ ra hiểu nhầm: tưởng kernel phải "extract" `numRows`/`numCols` từ ảnh, và viết `pos_x >= src_data` (so sánh chỉ số với con trỏ). Điều này cho thấy cần dạy chắc mô hình thread → global index và ranh giới host/device trước khi sang 1.3/1.4, thay vì chỉ sửa lỗi cú pháp.

**Status:** active

**Evidence:** diff `ex1/pmpp_ex1/src/filtering.cu` ngày 2026-11-20 — `numCols`/`numRows` không tồn tại, `pos_x >= src_data` là lỗi kiểu.

**Implications:** lesson đầu tiên là indexing + bounds check; memory model (managed vs device) để lesson sau, gắn với 1.1b và 1.3.
