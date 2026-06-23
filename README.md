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
│   └── algorithms
│       ├── closed_form.jl
│       ├── gradient_descent.jl
│       ├── stochastic_gradient_descent.jl
│       └── bidiagonalization.jl
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
This PR introduces the experimental design. The primary deliverable is a design document that specifies the structure of the study, including the experimental units, treatments, blocking factors, measurements, and observations that will be used to evaluate ridge regression algorithms.

### [HOW]
This PR accomplishes the experimental design by creating a formal design document in `docs/src/design.md`. The document will define the experimental units, treatments, blocking factors, measurements, and observations used throughout the project. It will specify the problem dimensions, conditioning regimes, noise levels, regularization parameters, and benchmark metrics that will be used to evaluate ridge regression algorithms.

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
This PR introduces `bidiagonalization.jl` and the corresponding tests. The module implements Golub-Kahan bidiagonalization using a sequence of Givens rotations to get the matrix into upper bidiagonal form. The implementation includes routines for computing Givens rotation coefficients, applying orthogonal transformations to matrix rows and columns, accumulating the orthogonal matrices (H and K), and applying the resulting transformations to the constant vector. The module serves as the project's first direct method for solving ridge regression problems.

### [HOW]
This PR ensures correctness and  reliability through a combination of unit testing, code coverage analysis, structural validation, and end-to-end pipeline checks. Unit tests will verify the correctness of Givens rotation coefficients, row and column transformations, and bidiagonalization procedures on square and rectangular matrices. Structural tests will confirm that the computed matrices satisfy the expected properties, including orthogonality of H and K, preservation of matrix dimensions, and the relation (H^T A K = B), where B is upper bidiagonal. Code coverage analysis will be used to ensure that core computational paths and edge cases are exercised, while end-to-end tests will verify compatibility with downstream ridge regression solvers and benchmarking routines.

### [SO WHAT]
This PR is the first algorithm (treatment) in the project and establishes a direct method baseline for comparison with future gradient-based and stochastic approaches.

### [FILES and Functions]
| File | Structure / Function | Purpose |
|------|----------------------|---------|
| `src/bidiagonalization.jl` | `compute_givens(...)` | Computes the cosine and sine coefficients defining a Givens rotation used to eliminate selected matrix entries. |
| `src/bidiagonalization.jl` | `rotate_rows!(...)` | Applies a Givens rotation to two rows of a matrix during the left-transformation stage of the bidiagonalization procedure. |
| `src/bidiagonalization.jl` | `rotate_cols!(...)` | Applies a Givens rotation to two columns of a matrix during the right-transformation stage of the bidiagonalization procedure. |
| `src/bidiagonalization.jl` | `apply_Ht_to_b(...)` | Applies the accumulated left orthogonal transformations to the constant vector, producing the transformed right-hand side of the reduced problem. |
| `src/bidiagonalization.jl` | `bidiagonalize_with_H(...)` | Performs Golub–Kahan Bidiagonalization using Givens rotations and accumulates the orthogonal transformations required to reduce a matrix to upper bidiagonal form. |
| `test/compute_givens_test.jl` | Givens rotation tests | Verify that the computed rotation coefficients satisfy the expected numerical and trigonometric properties. |
| `test/rotate_rows_test.jl` | Row rotation tests | Verify that row rotations correctly eliminate targeted entries while preserving orthogonality. |
| `test/rotate_cols_test.jl` | Column rotation tests | Verify that column rotations correctly eliminate targeted entries while preserving orthogonality. |
| `test/apply_Ht_to_b_test.jl` | Transformation tests | Verify that accumulated orthogonal transformations are correctly applied to the constant vector. |
| `test/bidiagonalize_with_H_test.jl` | Bidiagonalization tests | Verify that the resulting matrix is upper bidiagonal and that the accumulated orthogonal matrices satisfy the expected structural properties. |


## PR 4: Gradient Based Optimization and Corresponding Tests
**Expected Date:** July 6, 2026

### [WHY]
This project requires efficient and stable methods for solving ridge regression problems. Iterative optimization methods such as gradient descent provide an alternative approach to direct methods, which may become prohibitive or too costly. 
### [WHAT]
This PR introduces `gradient_descent.jl` and the corresponding tests. The module will implement gradient-based optimization methods for solving ridge regression problems, including routines for evaluating objective functions, computing gradients, and performing iterative updates.

### [HOW]
This PR ensures correctness and reliability through a combination of unit testing, code coverage analysis, convergence validation, and end-to-end pipeline checks. 

### [SO WHAT]
This PR establishes the project's first iterative optimization baseline and provides a foundation for comparing direct and optimization-based approaches to ridge regression. The resulting implementation will enable experiments evaluating convergence behavior, computational efficiency, solution accuracy, and robustness across a variety of problem settings.

### [FILES AND FUNCTIONS]
The exact function names may evolve, but this PR is expected to include the following core components:
| File | Structure / Function | Purpose |
|------|----------------------|---------|
| `src/algorithms/gradient_descent.jl` | `ridge_objective_evaluation(...)` | Evaluate the ridge regression objective for a given coefficient vector. |
| `src/algorithms/gradient_descent.jl` | `ridge_gradient_calculation(...)` | Compute the gradient of the ridge regression objective. |
| `src/algorithms/gradient_descent.jl` | `gradient_descent(...)` | Implement the main iterative update procedure for solving ridge regression problems. |
| `src/algorithms/gradient_descent.jl` | `stopping_criterion(...)` | Determine when the iterative method should terminate based on tolerance, maximum iterations, or convergence behavior. |
| `src/algorithms/gradient_descent.jl` | `gradient_descent_results(...)` | Store or return solution information such as coefficients, objective values, iteration count, and convergence status. |
| `test/gradient_descent_tests.jl` | Objective and gradient tests | Verify that objective values and gradients are computed correctly. |
| `test/gradient_descent_tests.jl` | Update rule tests | Verify that gradient descent updates move in the expected direction and reduce the objective under appropriate conditions. |
| `test/gradient_descent_tests.jl` | Convergence tests | Verify that the method approaches known ridge regression solutions on small benchmark problems. |
| `test/gradient_descent_tests.jl` | End-to-end pipeline tests | Verify compatibility with experimental units, benchmarking routines, and downstream measurement collection. |

## PR 5: Stochastic Optimization and Corresponding Tests
**Expected Date:** July 30, 2026

### [WHY]
This project requires solving the ridge regression problem in settings where traditional methods may become infeasible. In large-scale settings, stochastic optimization methods provide an alternative by approximating the optimization problem using random samples rather than processing the entire dataset at every iteration. These methods are particularly when the dimensions of the problem become too large.

### [WHAT]
This PR introduces stochastic optimization methods and the corresponding tests. The module will implement stochastic optimization methods for solving ridge regression problems, including stochastic gradient descent and related variants.

### [HOW]
This PR ensures correctness and reliability through a combination of unit testing, code coverage analysis, convergence validation, and end-to-end pipeline checks.

### [SO WHAT]
This PR extends the project's ability to solve ridge regression problems beyond the regimes where direct and traditional iterative methods are practical. By introducing stochastic optimization methods, we can apply treatments to larger experimental units and collect the measurements and observations necessary to compare algorithm performance across a broader range of problem dimensions and computational settings.
