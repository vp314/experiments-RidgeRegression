# RidgeRegression

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://vp314.github.io/RidgeRegression.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://vp314.github.io/RidgeRegression.jl/dev/)
[![Build Status](https://github.com/vp314/RidgeRegression.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/vp314/RidgeRegression.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/vp314/RidgeRegression.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/vp314/RidgeRegression.jl)
[![Code Style: Blue](https://img.shields.io/badge/code%20style-blue-4495d1.svg)](https://github.com/invenia/BlueStyle)

# Project Overview

This project investigates the performance of numerical algorithms for solving the ridge regression problem under varying dimension regimes and conditioning levels. The algorithms under consideration are direct methods, gradient-based methods, and stochastic gradient descent.

# Directory Structure

The source-code layout will be structured as such:
```text
.
├── Project.toml
│
├── src
│   ├── RidgeRegression.jl
│   ├── units.jl
│   ├── closed_form.jl
│   ├── gradient_descent.jl
│   ├── stochastic_gradient_descent.jl
│   └── bidiagonalization.jl
│
├── test
│   ├── Project.toml
│   ├── runtests.jl
│   ├── dataset_tests.jl
│   ├── encoding_tests.jl
│   ├── load_csv_dataset_tests.jl
│   ├── closed_form_tests.jl
│   ├── gradient_descent_tests.jl
│   ├── stochastic_gradient_descent_tests.jl
│   ├── compute_givens_test.jl
│   ├── rotate_rows_test.jl
│   ├── rotate_cols_test.jl
│   ├── apply_Ht_to_b_test.jl
│   └── bidiagonalize_with_H_test.jl
│
└── docs
    ├── make.jl
    └── src
        ├── design.md
        └── index.md
```
# PR Schedule and Roadmap

## PR 1: Experimental Design
**Expected Date:** June 19, 2026

### [WHY]
A rigorous experimental framework ensures that the ridge regression algorithms are evaluated under identical conditions, enabling fair and reproducible comparisons across methods.

### [WHAT]
This PR introduces the experimental design. The experimental design introduces the motivation and purpose of our experiment, defines experimental units and relevant blocking factors, specifies treatments to be applied and measurements to be collected, and documents all design choices and assumptions.

### [HOW]
This PR accomplishes the experimental design by creating a formal design document in `docs/src/design.md`.

### [SO WHAT]
This PR establishes the foundation for all algorithm comparisons and ensures that experimental results are reproducible and meaningful.

## PR 2: Units.jl and Corresponding Tests
**Expected Date:** June 30, 2026

### [WHY]
This project requires our experimental units to be defined in accordance with the experimental design. The experimental units need to have certain properties and be consistent and reproducible throughout the experiment. 

### [WHAT]
This PR introduces `units.jl` and the corresponding tests. The module will provide a framework for generating and managing experimental units that conform to the specifications established in the experimental design, including factors such as problem dimension, conditioning, among others. It will also ensure that all generated units are reproducible, consistent across experimental conditions, and validated through unit testing.

### [HOW]
This PR ensures that `units.jl` and the corresponding tests satisfy the experimental design requirements through a combination of testing, code coverage, and end-to-end pipeline validation. Unit tests will verify that the generated experimental units possess certain properties specified in the design. Code coverage will be run to ensure sufficient coverage and appropriate handling of edge cases. In addition, end-to-end pipeline checks will be performed to verify that the experimental units are compatible with future algorithms and measurements/observations needed.

### [SO WHAT]
This PR ensures that we have generated experimental units consistent with our design and it allows us to apply treatments (Ridge Regression Algorithms) so that we can collect measurements and observations to analyze and compare the performance of these algorithms.

### [FILES and Functions]
| File | Structure / Function | Purpose |
|------|----------------------|---------|
| `src/units.jl` | `Dataset{TX<:AbstractMatrix, TY<:AbstractVector}` | Defines a dataset as an experimental unit for ridge regression experiments. Stores the design matrix `X`, response vector `y`, and dataset `name` while allowing dense or sparse matrix types. |
| `src/units.jl` | `Dataset(name::String, X::AbstractMatrix, y::AbstractVector)` | Constructs a `Dataset` object and validates that the number of rows in `X` matches the length of `y`. |
| `src/units.jl` | `one_hot_encode(Xdf::DataFrame; cols_to_encode, drop_first=true)` | Converts selected categorical columns in a feature `DataFrame` into numeric dummy variables while leaving numeric columns unchanged. |
| `src/units.jl` | `load_csv_dataset(path_or_url::String; target_col, cols_to_encode=Symbol[], name="csv_dataset")` | Loads a dataset from a local CSV file or URL, removes missing observations, separates features from the target column, applies one-hot encoding, and returns a `Dataset` object. |
| `test/dataset_tests.jl` | `Dataset` constructor tests | Verify that valid matrices and response vectors produce a `Dataset`, and that mismatched dimensions throw an `ArgumentError`. |
| `test/encoding_tests.jl` | Encoding tests | Verify that categorical variables are correctly one-hot encoded, that numeric columns are preserved, and that invalid nonnumeric columns trigger appropriate errors. |
| `test/load_csv_dataset_tests.jl` | CSV-loading tests | Verify that CSV data can be loaded, cleaned, encoded, and converted into a valid `Dataset` object. |
| `test/end_to_end_tests.jl` | End-to-end dataset pipeline tests | Verify that raw tabular data can move through the full pipeline: CSV loading, preprocessing, encoding, dataset construction, and compatibility with downstream ridge regression routines. |

## PR 3: Golub Kahan Bidiagonalization and Corresponding Tests
**Expected Date:** June 30, 2026

### [WHY]
This project requires efficient and stable methods for solving ridge regression problems. Direct methods are an important baseline against which iterative and stochastic approaches can be compared. Golub-Kahan bidiagonalization is a direct method that transforms the data matrix into a bidiagonal form through a series of orthogonal transformations, yielding a simpler problem that can be solved more efficiently.
### [WHAT]
This PR introduces `bidiagonalization.jl` and the corresponding tests. The module implements Golub-Kahan bidiagonalization using a sequence of Givens rotations to get the matrix into upper bidiagonal form. 

### [HOW]
This PR ensures that `units.jl` and the corresponding tests satisfy the experimental design requirements through a combination of testing, code coverage, and end-to-end pipeline validation. Unit tests will verify that the generated experimental units possess certain properties specified in the design. Code coverage will be run to ensure sufficient coverage and appropriate handling of edge cases. In addition, end-to-end pipeline checks will be performed to verify that the experimental units are compatible with future algorithms and measurements/observations needed.

### [SO WHAT]
This PR ensures that we have generated experimental units consistent with our design and it allows us to apply treatments (Ridge Regression Algorithms) so that we can collect measurements and observations to analyze and compare the performance of these algorithms.