# Computational Investigation of the 3x+1 (Collatz) Problem

Supporting code and data for the MSc thesis *"Computational Investigation
of the 3x+1 Problem"*, Technological University Dublin, 2026.

Author: Sai Vidya Chaitanya Penta (A00047206)
Supervisor: Dr Kevin Berwick

## What this repository contains

This repository holds the benchmark scripts and raw result data used in
Chapter 8 (Cloud Deployment and GPU Acceleration) of the thesis. Each
sub-folder corresponds to one cloud platform tested.

```
matlab-core-thesis/
├── 01_core_visualisation/    Chapter 3 — trajectory generation & plotting
├── 02_precision_analysis/    Chapter 4 — single/double/SMT precision
├── 03_serial_benchmark/      Chapter 6 — serial execution timing
├── 04_parallel_parfor/       Chapter 6 — parfor parallel benchmarks
├── 05_batch_jobs/            Chapter 6 — cluster batch job scheduling
└── 06_worker_scalability/    Chapter 6 — 1-8 worker scaling sweep

cloud-benchmarks/
├── aws/            AWS EC2 t3.micro CPU benchmark (Python)
├── colab-gpu/       Google Colab CPU vs GPU benchmark (Python + PyTorch)
└── matlab-online/  MATLAB Online serial/parallel benchmark (MATLAB + data)

machine-learning/
└── regression_prediction.py   Predicting trajectory behaviour from seed
                                properties (Chapter 7, Figure 26)
```

## matlab-core-thesis/

The original MATLAB scripts behind Chapters 3, 4, and 6 — visualisation,
numerical precision analysis, and benchmark testing. See
[`matlab-core-thesis/README.md`](matlab-core-thesis/README.md) for a
full breakdown of every script and which thesis figure it produces.

### aws/
- `aws_benchmark.py` — computes the Collatz stopping time for seeds
  1 to N (N = 100,000 / 1,000,000 / 10,000,000) on an AWS EC2 t3.micro
  instance, verifying correctness against published reference values.
- `aws_benchmark.csv` — measured results: execution time and maximum
  stopping time for each problem size.

### colab-gpu/
- `collatz_gpu_benchmark.py` — the same benchmark, run once on an
  ordinary CPU and once on an NVIDIA Tesla T4 GPU (via Google Colab's
  free tier), using PyTorch tensor operations to process many seeds
  in parallel.
- `collatz_gpu_benchmark.csv` — measured CPU and GPU execution times
  and the resulting speedup at each problem size.

### matlab-online/
- `matlab_cloud_benchmark.m` — the actual MATLAB script run on
  MATLAB Online. Explicitly requests a process-based parallel pool
  first; when the free tier refuses this (with the exact message
  `'Local' clusters are not supported in MATLAB Online`), it falls
  back to a thread pool automatically and reports which one was
  used.
- `matlab_cloud_benchmark.csv` — five repeated runs of the same
  benchmark on MATLAB Online, comparing serial execution against an
  8-thread parallel pool.

## machine-learning/

### regression_prediction.py
Builds a 2,000,000-seed dataset (seed, four cheap seed-derived
features, and three trajectory outcomes) and trains three regression
models — Linear Regression, Decision Tree, and Random Forest — to
test whether a seed's own properties can predict its stopping time,
steps to peak, or peak value. This is the script behind Figure 26 in
the thesis. Run it directly; it builds its own dataset first.

## Correctness

Every script verifies its output against known reference values before
reporting a timing result:

| Seeds (N)   | Expected max stopping time |
|-------------|-----------------------------|
| 100,000     | 350                          |
| 1,000,000   | 524                          |
| 10,000,000  | 685                          |

These match published values in the On-Line Encyclopedia of Integer
Sequences (OEIS A006577).

## Running the scripts

```bash
pip install -r requirements.txt
python cloud-benchmarks/aws/aws_benchmark.py
python cloud-benchmarks/colab-gpu/collatz_gpu_benchmark.py   # requires a CUDA GPU
python machine-learning/regression_prediction.py             # takes a few minutes
```

The GPU script requires an environment with a CUDA-capable GPU, such as
a Google Colab notebook with the GPU runtime enabled
(**Runtime → Change runtime type → T4 GPU**).

The MATLAB script (`cloud-benchmarks/matlab-online/matlab_cloud_benchmark.m`)
is written to be pasted directly into a MATLAB Online script and run —
no local MATLAB installation is required.

## Full thesis

The complete thesis, including the machine learning and precision-tools
chapters not covered by this repository, is available on request from
the author or TU Dublin's thesis repository.

## Licence

Code in this repository is provided for academic reference alongside
the thesis. Please cite the thesis if you use or adapt this work.
