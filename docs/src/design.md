# Motivation and Background
Many modern science problems involve regression problems with extremely large numbers of predictors. Genome-wide association studies (GWAS), for example, try to identify genetic variants associated with a disease phenotype using hundreds of thousands or millions of genomic features. In such settings, traditional least squares methods fail because noise and ill-conditioning. Penalized Least Squares (PLS) extends ordinary least squares (OLS) regression by adding a penalty term to shrink parameter estimates. Ridge regression, an approach within PLS, adds a regularization term, producing a regularized estimator. 

Mathematically, ridge regression estimates the regression coefficients by solving the penalized least squares problem
$$
\hat{\boldsymbol{\beta}} =
\arg\min_{\boldsymbol{\beta}}
\left(
\| \mathbf{y} - X\boldsymbol{\beta} \|^2
+
\lambda \| \boldsymbol{\beta} \|^2
\right)
$$
where $\lambda > 0$ is a regularization parameter that controls the strength of the penalty.

The purpose of ridge regression is to stabilize regression estimates where the predictors are highly correlated or the design matrix $X$ is almost singular. Ridge regression shrinks the estimated coefficient vector in a way such that the coefficient estimates minimize the sum of squared residuals subject to a constraint on the $\ell_2$ norm of the coefficient vector, $\|\boldsymbol{\beta}\|^2 \leq t$, which shrinks the least squares estimates toward the origin. This reduces the variance of the coefficient estimates and mitigates the effects of multicollinearity.

There are many numerical algorithms available to compute ridge regression estimates including direct methods, Krylov subspace methods, gradient-based optimization, coordinate descent, and stochastic gradient descent. These algorithms differ in their computational costs and numerical stability. 

The goal of this experiment is to investigate the performance of these algorithms when we vary the structure and scale of the regression problem. To do this, we consider the linear model $\mathbf{y} = X\boldsymbol{\beta} + \boldsymbol{\varepsilon}$ where the matrix ${X}$ may be constructed with varying dimensions, sparsity patterns, and conditioning properties.
# Questions
The primary goal of this experiment is to compare numerical algorithms for computing ridge regression estimates under various conditions. In particular, we aim to address the following questions:

1. How does algorithm performance vary across regression problems with different dimensional regimes?

2. How does the sparsity structure of the design matrix $X$ influence computational efficiency and convergence behavior of different algorithms?

3. How does the magnitude of the ridge penalty parameter $\lambda$, which affects the conditioning of $X^\top X + \lambda I$, influence numerical stability and runtime across algorithms?

4. Which algorithm provides the best tradeoff between numerical stability and computational cost across these varying problem regimes?

# Experimental Units
The experimental units are the datasets under fixed penalty weights. For each experimental unit, all treatments will be applied to the dataset. This will be done so that differences in performance can be attributed to the algorithms themselves rather than the data. Each dataset will contain a matrix ${X}$, a response vector $\mathbf{y}$, and a regularization parameter ${\lambda}$ for some specific ${\lambda}$. 

Blocks are defined by combinations of the experimental blocking factors, including dimensional regime, matrix sparsity, and ridge penalty magnitude. Each block represents datasets with similar structural properties. Within each block, multiple datasets will be generated, and each dataset forms an experimental unit. For every experimental unit all treatments are applied.

Datasets will be grouped according to their dimensional regime, characterized as $p \ll n$, p ≈ n, and $p \gg n$. These regimes correspond to fundamentally different geometric properties of the design matrix, including rank behavior, conditioning, and the stability of the normal equations.

In addition to dimensional block, the strength of the ridge penalty will be incorporated as a secondary blocking factor. The ridge estimator is $\hat{\beta_R} = (X^\top X + \lambda I)^{-1}X^\top y$. The matrix conditioning number is defined as $\kappa(A) = \frac{\sigma_{\max}(A)}{\sigma_{\min}(A)}$. In the context of ridge regression, the regularization parameter ${\lambda}$, can impact the conditioning number. Let $X = U\Sigma V^\top$ be the SVD of $X$, with singular values $\sigma_1,\dots,\sigma_p$.

Then
```math
X^\top X = V \Sigma^\top \Sigma V^\top
= V \,\mathrm{diag}(\sigma_1^2,\dots,\sigma_p^2)\, V^\top .
```

Adding the ridge term gives

```math
X^\top X + \lambda I
=
V \,\mathrm{diag}(\sigma_1^2+\lambda,\dots,\sigma_p^2+\lambda)\, V^\top .
```

```math
\kappa_2(X^\top X+\lambda I)
=
\frac{\sigma_{\max}^2+\lambda}{\sigma_{\min}^2+\lambda}.
```

Because the performance of numerical algorithms is strongly influenced by the conditioning of the system they solve, the ridge penalty effectively creates regression problems with different numerical difficulty. This provides a way to assess how algorithm performance, convergence behavior, and computational cost depend on the numerical stability of the problem. In this experiment, the magnitude of $\lambda$ is selected relative to the smallest and largest singular values of $X$. A weak regularization regime corresponds to $\lambda \approx \sigma_{\min}^2$, where the ridge penalty begins to influence the smallest singular directions but the system remains moderately ill-conditioned. A moderate regularization regime corresponds to $\lambda \approx \sigma_{\min}\sigma_{\max}$, which substantially improves the conditioning of the problem by increasing the smallest eigenvalues of $X^\top X + \lambda I$. Finally, a strong regularization regime corresponds to $\lambda \approx \sigma_{\max}^2$, where the ridge penalty dominates the spectral scale of the problem and produces a well-conditioned system.

Another blocking factor that will be considered is how sparse or dense the matrix X is. Many algorithms behave differently depending on whether the matrix is sparse or dense. In ridge regression, there are many operations involving X including matrix-matrix products and matrix-vector products. A dense matrix leads to high computational cost whereas a sparse matrix we can significantly reduce the cost. As such, different algorithms may perform better depending on the sparsity structure of X, making matrix sparsity a relevant blocking factor when comparing algorithm behavior and computational efficiency.

The total number of block combinations is determined by the product of the number of levels in each blocking factor, denoted b. For example, if the experiment includes three dimensional regimes, two sparsity levels, and two regularization strengths, then there are $3 * 2 * 2 = 12$ block combinations. We will also denote r to be the number of replicated datasets in each block. Here, we mean the number datasets within a block. The total number of experimental units is then ${b * r}$.

| Blocking System | Factor | Blocks |
|:----------------|:-------|:-------|
| Dataset | Dimensional regime | $(p \ll n)$, $(p \approx n)$, $(p \gg n)$|
| Ridge Penalty | Magnitude of ${\lambda}$ relative to the spectral scale of $X^\top X$ | Weak ($\lambda \approx \sigma_{\min}^2$), Moderate ($\lambda \approx \sigma_{\min}\sigma_{\max}$), Strong ($\lambda \approx \sigma_{\max}^2$), where $\sigma_{\min}$ and $\sigma_{\max}$ denote the smallest and largest singular values of $X$. |
| Matrix Sparsity| Density of non-zero values in $X$ | Sparse (< 10% non-zero), Moderate (10%-50% non-zero), Dense (> 50% non-zero)|
# Treatments

The treatments are the ridge regression solution methods:

- Gradient-based optimization
- Stochastic gradient descent
- Direct Methods
    - Golub Kahan Bidiagonalization
 
 Since each experimental unit will recieves all t treatments, the total number of algorithm runs in the experiment is ${t * b * r}$. For this experiment, ${t=3}$. To ensure fair comparison between algorithms, each treatment will be applied under a fixed time constraint. Each algorithm will be run for a maximum of two hours per experimental unit. 
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


The collected measurements will be written to a CSV file. Each row in the file corresponds to a single algorithm–dataset pair, which forms the observational unit of the experiment. The columns represent the recorded measurements. After the experiment, the resulting CSV file should contain ${Algorithms∗Datasets}$ number of rows and each row will contain exactly seven columns.