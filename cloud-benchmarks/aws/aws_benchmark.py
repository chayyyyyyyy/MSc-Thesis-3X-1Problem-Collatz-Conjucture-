"""
────────────────────────────────────────────────────────────────
 AWS EC2 t3.micro — Collatz benchmark
────────────────────────────────────────────────────────────────
 Purpose:
   Measure the wall-time to compute the Collatz stopping time
   for seeds 1..N on an AWS Free Tier t3.micro instance, at the
   same three problem sizes used for Colab and MATLAB Online.

 Hardware (as tested, 20 July 2026):
   Instance:     AWS EC2 t3.micro (Ireland region, eu-west-1)
   CPU:          Intel Xeon Platinum 8259CL @ 2.50 GHz
   vCPUs:        2  (1 physical core, 2 threads via SMT)
   Memory:       912 MiB
   OS:           Amazon Linux 2023, kernel 6.18.36
   Python:       3.9.25

 Results (measured 20 July 2026):
   N=   100,000   time =   1.42 s   max_stopping_time = 350
   N= 1,000,000   time =  19.84 s   max_stopping_time = 524
   N=10,000,000   time = 222.68 s   max_stopping_time = 685

 Notes:
   - Uses a running-max approach rather than storing every
     stopping time, to keep memory well under the 912 MiB limit.
   - Sanity-checked against three published Collatz reference
     values (seeds 6, 25, 27) before the benchmark begins.
   - Serial execution only. t3.micro's single physical core
     (with 2 SMT threads) does not permit meaningful parallelism
     for this workload, so no parallel variant is included.

 Usage:
   python3 aws_benchmark.py

 Output:
   aws_benchmark.csv — the three (N, time, max_stopping_time) rows

 Author: Sai Vidya Chaitanya Penta — MSc Thesis, TU Dublin, 2026
────────────────────────────────────────────────────────────────
"""

import time
import csv
import platform


def collatz_stopping_time(n: int) -> int:
    """Return the stopping time (steps to reach 1) for seed n."""
    steps = 0
    while n != 1:
        n = n // 2 if n % 2 == 0 else 3 * n + 1
        steps += 1
    return steps


def verify() -> None:
    """Sanity-check the function against three published reference values."""
    assert collatz_stopping_time(6) == 8,   "verification failed at seed 6"
    assert collatz_stopping_time(25) == 23, "verification failed at seed 25"
    assert collatz_stopping_time(27) == 111, "verification failed at seed 27"
    print("Verification passed.\n")


def benchmark(N: int) -> tuple[float, int]:
    """
    Run the Collatz iteration for seeds 1..N, tracking the running
    maximum stopping time (not the full list) to keep memory small.
    Returns (elapsed_seconds, max_stopping_time).
    """
    t0 = time.time()
    max_steps = 0
    for n in range(1, N + 1):
        s = collatz_stopping_time(n)
        if s > max_steps:
            max_steps = s
    return time.time() - t0, max_steps


def main() -> None:
    print("=" * 60)
    print("Platform:  AWS EC2 t3.micro (Ireland)")
    print("CPU:       Intel Xeon Platinum 8259CL @ 2.50 GHz")
    print("Cores:     2 vCPU (1 physical, 2 threads)")
    print(f"Python:    {platform.python_version()}")
    print("=" * 60)
    print()

    verify()

    sizes = [100_000, 1_000_000, 10_000_000]
    records = []

    for N in sizes:
        print(f"Running N = {N:,} seeds ...", flush=True)
        elapsed, max_steps = benchmark(N)
        print(f"  time: {elapsed:.2f} s")
        print(f"  max stopping time: {max_steps}")
        records.append({
            "N":                 N,
            "time_s":            round(elapsed, 3),
            "max_stopping_time": max_steps,
        })
        print()

    with open("aws_benchmark.csv", "w", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=records[0].keys())
        writer.writeheader()
        writer.writerows(records)

    print("=" * 60)
    print("SUMMARY")
    print("=" * 60)
    for r in records:
        print(f"  N={r['N']:>10,}   "
              f"time={r['time_s']:>7.2f}s   "
              f"max_steps={r['max_stopping_time']}")
    print()
    print("Saved: aws_benchmark.csv")


if __name__ == "__main__":
    main()
