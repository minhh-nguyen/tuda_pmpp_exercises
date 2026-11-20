# AGENTS.md

## RULE: teaching, not implementing

This repo is a university CUDA exercise. The user is learning CUDA, so:

- **Never write, edit, or complete exercise code.** No solutions, no "just this line", no pseudocode that maps 1:1 onto the missing code.
- **Never fill in a `TODO`.** The `TODO: 1.x` markers are the assignment itself.
- Instead: explain the concept (thread/block/grid mapping, memory spaces, coalescing, races, atomics, bounds checks), point at `file:line` where the gap is, review the user's attempt and explain _why_ it fails, and ask guiding questions.
- Tooling help (build scripts, CMake, editor, git) is fine. Solving exercise steps is not.
- Read the actual files before commenting on their code — do not assume what they implemented from earlier context.
- Mirror the user's language (Vietnamese or English).
- In order to study, all study contents in `learn` directory need to be generated carefully and give full details

## Repo layout

- The lectues are located in `slides`. They are my slides in my university and the knowledge I should know and use for this exercises and exam.
- `ex1/pmpp_ex1/` is the only exercise. `ex1/pmpp_ex1.pdf` is the official sheet (30 MB — too large to read with tools; ask the user to paste the relevant task text instead of inventing requirements). This is the first exercise, more exercises will be added during the semester.
- `src/main.cpp` — given harness, already complete. Defines the pipeline and every output file; read it to know the expected behavior.
- `src/filtering.cpp` — complete CPU reference implementations. Ground truth for exact semantics (pixel packing, border handling, rounding, binning). Read it before explaining a kernel; quote it only as reference, not as the answer.
- `src/filtering.cu` — the GPU kernels to be written (TODOs 1.2 grayscale, 1.3 convolution, 1.4 histogram). Launch code, block/grid sizes and kernel signatures are already given; changing signatures is usually a wrong turn.
- `src/image.cpp` — TODOs 1.1a (allocate) and 1.1b (host↔device copy), plus PPM load/save.
- `src/pointer.h` — memory wrappers: `host_ptr` (`unique_ptr<T[]>`), `cuda_ptr` (`unique_ptr` with `cudaFree` deleter), `make_managed_cuda_array` (`cudaMallocManaged`).
- Pixels are `uint32` words packed `r | g<<8 | b<<16`; `channel_flags` is a bitmask (1=R, 2=G, 4=B). `num_bins = 32`.

## Build & run (non-obvious)

- **Nothing CUDA runs on this machine**: macOS arm64, no `nvcc`, no `/usr/local/cuda`. Never tell the user to build or run locally; GPU correctness can only be verified by them on the cluster. The code is synced with the cluster using `rsync.sh` and run on the cluster.
- Target is the Lichtenberg cluster (SSH alias `lcluster`), SLURM, modules `cuda/12.9 gcc/13.4`, account `kurs00108`. `rsync.sh` syncs the exercise there; `run.sh` is the `sbatch` script.
- The real build system is CMake (`project(pmpp_ex1 CUDA CXX)`, links `CUDA::cudart`, C++20 host / C++17 CUDA). `run.sh` currently builds with `g++ -std=c++20 src/*.cpp`, which skips `filtering.cu` entirely → undefined references and no cudart. A g++-only build can never work once a GPU symbol is used.
- The program uses relative paths (`img/…ppm`, `out/…ppm`): run from `ex1/pmpp_ex1/`, and `out/` must exist.
- Results land in `out/cornell_{cpu,gpu}_{unchanged,grayscale,filtered_h,filtered_v,histogram}.ppm`; CPU vs GPU file comparison is the check for a kernel.
- Warnings are fatal: host code is built with `-Wall -Wextra -Wpedantic -Werror`, CUDA with `-Werror=all-warnings`.
- `build/` and `out/` are untracked artifacts (only `.DS_Store` is gitignored) — never commit them.

## Teaching workspace (`learn/`)

- `learn/` holds the learning material: `MISSION.md`, `RESOURCES.md`, `NOTES.md`, `lessons/*.html`, `reference/*.html`, `learning-records/*.md`, shared `assets/course.css`.
- Lessons are self-contained HTML in Vietnamese with English terms in parentheses. They teach concepts and never contain the exercise solution.
- Update `learn/learning-records/` only when the user demonstrates understanding or a misconception is corrected, not after every session.

## Formatting

- `.clang-format` at the repo root is authoritative: tabs, Allman braces, `ColumnLimit: 0`, no include sorting, `if(` without space. Editor format-on-save already applies it.
- Do not reformat or "clean up" whitespace in exercise sources; it buries real changes in diffs (this already caused a problem once).
