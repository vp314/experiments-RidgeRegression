# RidgeRegression

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://vp314.github.io/RidgeRegression.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://vp314.github.io/RidgeRegression.jl/dev/)
[![Build Status](https://github.com/vp314/RidgeRegression.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/vp314/RidgeRegression.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/vp314/RidgeRegression.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/vp314/RidgeRegression.jl)
[![Code Style: Blue](https://img.shields.io/badge/code%20style-blue-4495d1.svg)](https://github.com/invenia/BlueStyle)

## Project Overview

This project investigates the performance of numerical algorithms for solving the ridge regression problem under varying dimension regimes and conditioning levels. The algorithms under consideration are direct methods, gradient-based methods, and stochastic gradient descent.

## Roadmap

The source-code layout will be structured as such:
```text
src/
  RidgeRegression.jl

algorithms/
  bidiagonalization.jl
  closed_form.jl
  gradient_descent.jl
  stochastic_gradient_descent.jl
    
datasets.jl
design.jl

test/
  runtests.jl

  dataset_tests.jl
  design_tests.jl
  bidiagonalization_tests.jl
  closed_form_tests.jl
  gradient_descent_tests.jl
  stochastic_gradient_descent_tests.jl

docs/
  src/
    index.md
    design.md
    api.md
```

## PR Schedule

| PR Title| Planned Content | Expected Date 
|-----|----------------|
| PR Schedule and Roadmap| Repository organization, documentation infrastructure, README roadmap, GitHub workflow setup. | June 2026
| Experimental Design | Experimental Design, blocking framework, bechmark metrics, documentation of design choices. | June 2026
| Dataset.jl and Corresponding Tests | Dataset generation and preprocessing framework with tests | June 2026
| Golub Kahan Bidiagonalization and Corresponding Tests 
 | Implementation of Bidiagonalization and application to the constant vector. | June 2026
| Other Linear Algebric Approaches and Corresponding Tests | Implementation of hybrid projection methods and Krylov methods | July-August 2026
| Gradient-Based Optimization and Corresponding Tests | Implementation of gradient-based optimization algorithms and iterative shrinkage thresholding algorithms, | August 2026
| Stochastic Optimization and Corresponding Tests | Implementation of stochastic optimization algorithms (SGD) and corresponding tests| August 2026