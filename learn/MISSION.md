# Mission: CUDA cho môn PMPP (TU Darmstadt)

## Why

Đạt điểm cao trong môn *Programming Massively Parallel Processors*: hiểu đủ sâu để tự làm mọi bài tập CUDA và trả lời được câu hỏi "tại sao" trong bài thi — không phải chỉnh code cho tới khi nó chạy.

## Success looks like

- Tự viết được kernel cho một bài toán mới (map, convolution, histogram/reduction) và giải thích được vì sao nó đúng.
- Đọc một đoạn CUDA lạ và nói được: thread nào làm gì, truy cập vùng nhớ nào, có race hay không, có cần sync không.
- Trả lời được câu hỏi khái niệm trong bài thi: coalescing, occupancy, shared memory, atomic, memory model.
- Debug được lỗi "im lặng" (chạy không crash nhưng kết quả sai), không chỉ lỗi crash.

## Constraints

- Chỉ có GPU qua cluster Lichtenberg (SLURM); máy local là macOS arm64, không có CUDA.
- Bài tập nằm trong repo này; agent **không** viết code bài tập, chỉ giải thích và gợi ý (xem `AGENTS.md`).
- Song ngữ: giải thích tiếng Việt, thuật ngữ giữ tiếng Anh trong ngoặc.
- Thời gian bị chặn bởi tiến độ môn học (bài tập hàng tuần + thi cuối kỳ).

## Out of scope

- Tối ưu cực đoan (Tensor Core, multi-GPU, CUDA Graphs) trừ khi môn yêu cầu.
- Các framework song song khác (OpenCL, SYCL, HIP).
