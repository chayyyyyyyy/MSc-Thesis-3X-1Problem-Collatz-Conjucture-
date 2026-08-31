# Computational Investigation of the 3x+1 (Collatz) Problem

Supporting code and data for the MSc thesis *"Computational Investigation
of the 3x+1 Problem"*, Technological University Dublin, 2026.

Author: Sai Vidya Chaitanya Penta (A00047206)
Supervisor: Dr Kevin Berwick

## What this repository contains

This repository holds the benchmark scripts and raw result data used in
Chapter 8 (Cloud Deployment and GPU Acceleration) of the thesis. Each
sub-folder corresponds to one cloud platform tested.
matlab-core-thesis/
├── 01_core_visualisation/ Chapter 3 — trajectory generation & plotting
├── 02_precision_analysis/ Chapter 4 — single/double/SMT precision
├── 03_serial_benchmark/ Chapter 6 — serial execution timing
├── 04_parallel_parfor/ Chapter 6 — parfor parallel benchmarks
├── 05_batch_jobs/ Chapter 6 — cluster batch job scheduling
└── 06_worker_scalability/ Chapter 6 — 1-8 worker scaling sweep

cloud-benchmarks/
├── aws/ AWS EC2 t3.micro CPU benchmark (Python script + results)
└── colab-gpu/ Google Colab CPU vs GPU results (measured data)

machine-learning/
└── regression_prediction.py Predicting trajectory behaviour from seed
properties (Chapter 7)


## matlab-core-thesis/

The original MATLAB scripts behind Chapters 3, 4, and 6 — visualisation,
numerical precision analysis, and benchmark testing. See
[`matlab-core-thesis/README.md`](matlab-core-thesis/README.md) for a
full breakdown of every script and which thesis figure it produces.

## cloud-benchmarks/

### aws/
- `aws_benchmark.py` — computes the Collatz stopping time for seeds
  1 to N (N = 100,000 / 1,000,000 / 10,000,000) on an AWS EC2 t3.micro
  instance, verifying correctness against published reference values.
- `aws_benchmark.csv` — measured results: execution time and maximum
  stopping time for each problem size.

### colab-gpu/
- `collatz_gpu_benchmark.csv` — measured CPU and GPU execution times
  and the resulting speedup at each problem size (Chapter 8), comparing
  an ordinary CPU against an NVIDIA Tesla T4 GPU on Google Colab's
  free tier.

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
python machine-learning/regression_prediction.py             # takes a few minutes
```

The MATLAB scripts in `matlab-core-thesis/` require MATLAB R2024a or
later, with the Parallel Computing Toolbox (Chapters 4-6) and the
Symbolic Math Toolbox (`triple_comparison_SMT.m` only).

## Full thesis

The complete thesis, including the machine learning and precision-tools
chapters not covered in full by this repository, is available on request
from the author or TU Dublin's thesis repository.

## Licence

Code in this repository is provided for academic reference alongside
the thesis. Please cite the thesis if you use or adapt this work.
the author or TU Dublin's thesis repository.

## Licence

Code in this repository is provided for academic reference alongside
the thesis. Please cite the thesis if you use or adapt this work.
