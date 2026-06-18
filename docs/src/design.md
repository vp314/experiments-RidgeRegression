# Motivation and Background
Many modern science problems involve regression problems with extremely large numbers of
predictors. 
[Genome-wide association studies (GWAS)](https://doi.org/10.1371/journal.pone.0245376), 
for example, try to identify genetic
variants associated with a disease phenotype using hundreds of thousands or millions of
genomic features. In such settings, traditional least squares methods fail. 
Penalized Least Squares (PLS) extends ordinary least squares (OLS)
regression by adding a penalty term to shrink parameter estimates. Ridge regression, an
approach within PLS, adds a regularization term, producing a regularized estimator. 

Mathematically, ridge regression estimates the regression coefficients by solving the 
penalized least squares problem
```math
\hat{\boldsymbol{\beta}} =
\arg\min_{\boldsymbol{\beta}}
\left(
\| \mathbf{y} - X\boldsymbol{\beta} \|_2^2
+
\lambda \| \boldsymbol{\beta} \|_2^2
\right)
```
where $\lambda > 0$ is a regularization parameter that controls the strength of the penalty.

The purpose of ridge regression is to stabilize regression estimates when the predictors are
highly correlated or the design matrix $X$ is nearly singular. Ridge regression modifies the
least squares objective by adding a penalty on the squared $\ell_2$-norm of the coefficient
vector. The estimator is obtained by minimizing a penalized least squares objective in which
large coefficient values are discouraged through the penalty term $\lambda
\|\boldsymbol{\beta}\|_2^2$. This penalty shrinks the estimated coefficients toward the
origin, which reduces the variance of the estimator and mitigates the effects of
multicollinearity.

There are many numerical algorithms available to compute ridge regression estimates
including direct methods, Krylov subspace methods, gradient-based optimization, coordinate
descent, and stochastic gradient descent. These algorithms differ in their computational
costs and numerical stability. 

The goal of this experiment is to investigate the performance of these algorithms when we
vary the structure and scale of the regression problem. To do this, we consider the linear
model $\mathbf{y} = X\boldsymbol{\beta} + \boldsymbol{\varepsilon}$ where the matrix ${X}$
may be constructed with varying dimensions, sparsity patterns, and conditioning properties.
# Questions
The primary goal of this experiment is to compare numerical algorithms for computing ridge
regression estimates under various conditions. In particular, we aim to address the
following questions:

1. How does the performance of ridge regression algorithms change as the structural 
    and numerical properties of the regression problem vary?

2. Which ridge regression algorithm provides the best balance between numerical 
    stability and computational cost across these problem regimes?

# Experimental Units
An experimental unit is defined by a triplet: a design matrix, $X$; a response vector, $y$;
and a non-negative regularization parameter $\lambda$. 

Datasets will be generated either fully artificially or semi-artificially. In the artifical setting, both the design matrix (X) and the response vector (y) are generated. In the semi-artifical setting, the design matrix is fixed from a real dataset (e.g. GWAS) and the response vector is generated conditional on X. This is done so that we can compute solution error.

Experimental units are selected based on factors we believe will potentially impact 
the performance of a specific algorithm.
These factors, or blocks, correspond to:
- The dimensional regime of $X \in \mathbb{R}^{n \times p}$: 
    $p \ll n$, $p ≈ n$, and $p \gg n$.
- The magnitude of the regularization parameter, $\lambda$, as described below. 

The regularization parameter is often selected using one of the following strategies,
depending on application domain:

- [Generalized Cross Validation](https://doi.org/10.1080/00401706.1979.10489751)
- [The L-Curve Method](https://doi.org/10.1137/1034115)
- [Information Criteria](https://doi.org/10.1002/wics.1607)
- [Morozov's Discrepancy Principle](https://doi.org/10.1088/0266-5611/26/2/025001)

Excluding Morozov's discrepancy principle, the remaining methods require
computing $\hat{\beta}_\lambda = (X^\top X + \lambda I)^{-1}X^\top y$ or 
$\Vert X\hat{\beta}_\lambda - y \Vert_2$ over a grid of values for $\lambda$.
Given our assumption that problem conditioning will impact algorithm behavior,
we will choose this grid to modify the problem's condition number systematically. 

Recall, the ridge estimator's closed form is given by solving
```math 
\min_{\beta} \left\Vert \begin{bmatrix} X \\ \lambda I \end{bmatrix}\beta - 
y \right\Vert_2^2,
```
or (equivalently, from a mathematical perspective) solving
$(X^\top X + \lambda I)\hat{\beta}_\lambda = X^\top y$. 
Let $\sigma_{\max}$ denote the largest singular value 
of $X$, and let $\sigma_{\min}$ denote the smallest singular value of 
$X$ (note, $0$ is allowed). 
Then the condition number for the normal systems approach is 
```math
\kappa(X^\top X+\lambda I)
=
\frac{\sigma_{\max}^2+\lambda}{\sigma_{\min}^2+\lambda}.
```

There are two cases we consider.
- Case 1: $\sigma_{\min}=0$. In this case, the least squares problem is ill-posed. We choose 
    the smallest value of $\lambda$ in the grid to be
    $\sigma_{\max}^2 / (10^{12} - 1)$, which ensures 
    $\kappa(X^\top X + \lambda I) = 10^{12}$.
- Case 2: $\sigma_{\min}>0$. In this case, we choose the smallest value of $\lambda$ in the 
    grid to be $\sigma_{\max}\sigma_{\min}$, which ensures 
    $\kappa(X^\top X + \lambda I) = \sigma_{\max}/\sigma_{\min}$.
    That is, it sets the regularized normal system's condition number to that of the original 
    least squares problem.

In both cases, assuming $\sigma_{\max}^2 > 2 \sigma_{\min}$, we choose the larges value of 
$\lambda$ to be $\sigma_{\max}^2 - 2 \sigma_{\min}$. The condition number for the 
regularized normal equations is $\kappa(X^\top X + \lambda I)=2$.


The total number of block combinations is determined by the product of the number of levels
in each blocking factor, denoted b. For example, if the experiment includes three
dimensional regimes, two sparsity levels, and two regularization strengths, then there are
$3 * 2 * 2 = 12$ block combinations. We will also denote r to be the number of replicated
datasets in each block. Here, we mean the number datasets within a block. The total number
of experimental units is then ${b * r}$.

Matrix sparsity is a factor that can influence algorithm performance. However, we will not consider it in this experiment because none of the algorithms under consideration are implemented in a manner that exploits sparse matrix structure.

| Blocking System | Factor | Blocks |
|:----------------|:-------|:-------|
| Dataset | Dimensional regime | $(p \ll n)$, $(p \approx n)$, $(p \gg n)$|
| Ridge Penalty | Magnitude of ${\lambda}$ relative to the spectral scale of $X^\top X$ | Strong: $\kappa \approx 10$, Moderate: $\kappa \approx 10^3$, Weak: $\kappa \approx 10^6$, with $\lambda$ computed from the corresponding $\epsilon$. |

# Treatments

The treatments are the ridge regression solution methods:

- Gradient-based optimization
- Stochastic gradient descent
- Direct Methods
    - Golub Kahan Bidiagonalization
 
 Since each experimental unit will recieves all t treatments, the total number of algorithm
 runs in the experiment is ${t * b * r}$. For this experiment, ${t=3}$. To ensure fair
 comparison between algorithms, each treatment will be applied under a fixed wall time
 constraint. Each algorithm will be run for a maximum of two hours per experimental unit. 
# Observational Units and Measurements

The observational units are each algorithm-dataset pair. For each combination we will observe the following 

| Column Name | Data Type | Description |
|:---|:---|:---|
| `dataset_id` | Positive Integer | Identifier for the generated dataset (experimental unit). |
| `dimensional_regime` | String | Relationship between predictors and observations: `p << n`, `p ≈ n`, or `p >> n`. |
| `sparsity_level` | String | Density of the matrix `X`: `Sparse`, `Moderate`, or `Dense`. |
| `lambda_level` | String | Relative magnitude of the ridge penalty parameter `λ`: `Weak`, `Moderate`, or  `Strong`. |
| `algorithm` | String | Ridge regression solution method used: `GradientDescent`, `SGD`, or `DirectMethod`. |
| `runtime_seconds` | Positive Floating-point | Time required for the algorithm to compute a solution. |
| `iterations` | Positive Integer | Number of iterations performed by the algorithm (`NA` for direct methods). |
| `step_size` | Positive Floating-point | Step size used in gradient descent or SGD (`NA` for direct methods). |
| `batch_size` | Positive Integer | Number of samples used per SGD update (`NA` for direct methods and gradient descent). |
| `number_of_epochs` | Positive Integer | Number epochs per observation (`NA` for direct methods). |



The collected measurements will be written to a CSV file. Each row in the file corresponds
to a single algorithm–dataset pair, which forms the observational unit of the experiment.
The columns represent the recorded measurements. After the experiment, the resulting CSV
file should contain ${Algorithms∗Datasets}$ number of rows and each row will contain exactly
10 columns.