# CUDA / PMPP Resources

## Knowledge

- [Slides 02 — Programming Model](../slides/02-Programming_Massively_Parallel_Processors-Programming_Model.pdf)
  Nguồn chính cho mô hình grid/block/thread và cách suy ra chỉ số. Đọc lại trước mỗi bài viết kernel.
- [Slides 03 — Memory Spaces and Synchronization](../slides/03-Programming_Massively_Parallel_Processors-Memory_Spaces_and_Synchronization.pdf)
  Dùng khi gặp: global/shared/constant memory, `__syncthreads()`, race condition, managed memory.
- [Slides 04 — Synchronization across Blocks](../slides/04-Programming_Massively_Parallel_Processors-Synchronization_across_Blocks.pdf)
  Dùng cho reduction/histogram nhiều block, atomic, và vì sao `__syncthreads()` không đủ giữa các block.
- [CUDA C++ Programming Guide (NVIDIA)](https://docs.nvidia.com/cuda/cuda-c-programming-guide/)
  Tài liệu chuẩn, cập nhật theo từng version toolkit. Tra cứu chính xác API và ngữ nghĩa (memory model, atomics).
- [CUDA C++ Best Practices Guide (NVIDIA)](https://docs.nvidia.com/cuda/cuda-c-best-practices-guide/)
  Dùng khi hỏi "tại sao chậm": coalescing, occupancy, bank conflict.
- [Programming Massively Parallel Processors, 4th ed. — Kirk & Hwu](https://www.elsevier.com/books/programming-massively-parallel-processors/hwu/978-0-323-91231-0)
  Sách gốc của môn. Chương 2–3 cho indexing và memory; chương sau cho pattern (convolution, histogram, scan).

## Wisdom (Communities)

- [NVIDIA Developer Forums — CUDA](https://forums.developer.nvidia.com/c/accelerated-computing/cuda/12)
  Nơi kỹ sư NVIDIA trả lời; tốt cho câu hỏi về hành vi driver/toolkit.
- [Stack Overflow — tag `cuda`](https://stackoverflow.com/questions/tagged/cuda)
  Tốt cho lỗi compile/runtime cụ thể; đọc câu trả lời có vote cao và kiểm tra version.
- [r/CUDA](https://www.reddit.com/r/CUDA/)
  Thảo luận thực dụng, chất lượng không đồng đều — dùng để xin ý kiến thiết kế, không để tra API.

## Gaps

- Chưa có link forum/tutor chính thức của môn (kurs00108) — cần hỏi user.
- Chưa có đề thi mẫu hoặc bài tập các năm trước.
