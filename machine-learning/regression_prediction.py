"""
────────────────────────────────────────────────────────────────
 Machine Learning Prediction of Collatz Sequence Behaviour
 Regression: can a seed's own properties predict its trajectory?
────────────────────────────────────────────────────────────────
 Purpose:
   This script tests whether three simple machine learning models
   can predict a Collatz sequence's behaviour purely from
   properties of its starting seed -- without ever running the
   sequence itself.

   Three things are predicted, one model at a time:
     1. stopping_time  -- how many steps until the sequence reaches 1
     2. steps_to_peak   -- how many steps until the sequence's
                            highest point
     3. log10_peak       -- the size of that highest point, on a
                            log scale (raw peak values can be
                            astronomically large)

 Why these four input features:
   Nothing about a seed is known in advance except the seed
   itself, so only cheap, instantly-computable properties are
   used as inputs:
     - log10(seed)          -- roughly how many digits it has
     - number of binary digits -- its size in binary
     - popcount              -- how many 1-bits it has in binary
     - is_odd                -- whether the seed is even or odd

 The headline result (see the thesis, Chapter 7, Figure 26):
   R^2 on the held-out test set is close to zero for stopping_time
   and steps_to_peak (below 0.07), meaning these are essentially
   unpredictable from the seed alone. log10_peak is moderately
   predictable (R^2 around 0.63), but not precisely enough to be
   useful for any single seed.

 Usage:
   python regression_prediction.py
   (takes a few minutes -- building the 2,000,000-seed dataset is
   the slow part; training the three models is fast)

 Requirements:
   pip install pandas scikit-learn
────────────────────────────────────────────────────────────────
"""

import math
import time
import csv

import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.linear_model import LinearRegression
from sklearn.tree import DecisionTreeRegressor
from sklearn.ensemble import RandomForestRegressor
from sklearn.metrics import r2_score


# ══════════════════════════════════════════════════════════════
# Step 1 -- Build the dataset
# ══════════════════════════════════════════════════════════════
def collatz_features(n: int) -> tuple[int, int, int]:
    """
    Run the Collatz sequence for seed n and return three things
    about its trajectory:
      - peak            the highest value the sequence reaches
      - steps_to_peak    how many steps it took to get there
      - steps_to_one     the total stopping time (steps to reach 1)
    """
    peak = n
    steps_to_peak = 0
    steps = 0
    while n != 1:
        n = n // 2 if n % 2 == 0 else 3 * n + 1
        steps += 1
        if n > peak:
            peak = n
            steps_to_peak = steps
    return peak, steps_to_peak, steps


def build_dataset(n_seeds: int, out_path: str) -> None:
    """Compute features and targets for every seed from 1 to n_seeds,
    and write them to a CSV file."""

    # Sanity-check the function against a well-known reference value
    # before generating two million rows of data.
    peak, steps_to_peak, steps_to_one = collatz_features(27)
    assert (peak, steps_to_peak, steps_to_one) == (9232, 77, 111), \
        "collatz_features() failed the seed-27 reference check"

    print(f"Building dataset for {n_seeds:,} seeds...")
    t0 = time.time()

    with open(out_path, "w", newline="") as f:
        writer = csv.writer(f)
        writer.writerow([
            "seed", "log10_seed", "num_binary_digits", "popcount", "is_odd",
            "peak_value", "log10_peak", "steps_to_peak", "steps_to_one",
        ])
        for seed in range(1, n_seeds + 1):
            peak, steps_to_peak, steps_to_one = collatz_features(seed)
            writer.writerow([
                seed,
                round(math.log10(seed), 6),
                seed.bit_length(),
                bin(seed).count("1"),
                seed % 2,
                peak,
                round(math.log10(peak), 6),
                steps_to_peak,
                steps_to_one,
            ])

    print(f"  done in {time.time() - t0:.1f} s -> {out_path}")


# ══════════════════════════════════════════════════════════════
# Step 2 -- Train and evaluate three regression models
# ══════════════════════════════════════════════════════════════
FEATURES = ["log10_seed", "num_binary_digits", "popcount", "is_odd"]
TARGETS = ["steps_to_one", "steps_to_peak", "log10_peak"]

MODELS = {
    "Linear Regression": LinearRegression(),
    "Decision Tree":     DecisionTreeRegressor(max_depth=10, random_state=42),
    "Random Forest":     RandomForestRegressor(
        n_estimators=50, max_depth=12, random_state=42, n_jobs=-1
    ),
}


def train_and_evaluate(dataset_path: str) -> None:
    """Load the dataset, split it 70/30, train each model on each
    target, and report R^2 on the held-out 30% test set."""

    df = pd.read_csv(dataset_path)
    print(f"\nLoaded {len(df):,} rows from {dataset_path}")

    # A fixed random_state makes this split reproducible -- anyone
    # running this script gets the exact same train/test rows.
    train, test = train_test_split(df, test_size=0.30, random_state=42)
    print(f"Train: {len(train):,} rows   Test: {len(test):,} rows\n")

    print(f"{'Target':<15} {'Model':<20} {'R^2':>8}   {'Train time':>10}")
    print("-" * 60)

    for target in TARGETS:
        X_train, y_train = train[FEATURES], train[target]
        X_test, y_test = test[FEATURES], test[target]

        for model_name, model in MODELS.items():
            t0 = time.time()
            model.fit(X_train, y_train)
            train_time = time.time() - t0

            predictions = model.predict(X_test)
            r2 = r2_score(y_test, predictions)

            print(f"{target:<15} {model_name:<20} {r2:>8.3f}   {train_time:>9.1f}s")


# ══════════════════════════════════════════════════════════════
# Entry point
# ══════════════════════════════════════════════════════════════
if __name__ == "__main__":
    DATASET_PATH = "collatz_dataset_2M.csv"

    build_dataset(n_seeds=2_000_000, out_path=DATASET_PATH)
    train_and_evaluate(DATASET_PATH)
