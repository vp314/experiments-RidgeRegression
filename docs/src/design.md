# Motivation and Background
Many modern science problems involve regression problems with extremely large numbers of predictors. Genome-wide association studies (GWAS), for example, try to identify genetic variants associated with a disease phenotype using hundreds of thousands or millions of genomic features. In such settings, traditional least squares methods fail because noise and ill-conditioning. Penalized Least Squares (PLS) extends ordinary least squares (OLS) regression by adding a penalty term to shrink parameter estimates. Ridge regression, an approach within PLS, adds a regularization term, producing a regularized estimator that helps to stabilize the solution. 

There are many numerical algorithms available to compute ridge regression estimates including direct methods, Krylov subspace methods, gradient-based optimization, coordinate descent, and stochastic gradient descent. These algorithms differ in their computational costs and numerical stability. 

The goal of this experiment is to investigate the performance of these algorithms when we vary the structure and scale of the regression problem. To do this, we consider the linear model $\mathbf{y} = X\boldsymbol{\beta} + \boldsymbol{\varepsilon}$ where the matrix ${X}$ will be constructed with varying dimensions, sparsity patterns, and conditioning properties.
# Questions
Key Questions:
(adding the above)
Which ridge regression algorithm is provides the best balance between:

- Numerical stability
- Computational costs
- 
# Experimental Units
The experimental units are the datasets under fixed penalty weights. For each experimental unit, all treatments will be applied to the dataset. This will be done so that differences in performance can be attributed to the algorithms themselves rather than the data. Each dataset will contain a matrix ${X}$, a response vector $\mathbf{y}$, and a regularization parameter ${\lambda}$ for some specific ${\lambda}$. Owing to the statistical behavior of ridge regression algorithms depends strongly on the dimensional structure of the problem, a blocking system will be used. 

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

When ${\lambda}$ is small and the singular values are large, we aren't changing the conditioning number much. As such, the ridge penalty won't really affect the condition number. Conversely, if $\sigma_{\min}$ is close to 0, we have an ill-posed problem (Existence, uniqueness, stability not satisfied). However if a large ${\lambda}$ is chosen, the condition number is reduced and the problem becomes more stable. This behavior motivates blocking experiments according to the effective conditioning induced by the ridge penalty, allowing algorithm performance to be compared across well-posed and ill-posed regression settings.

Another blocking factor that will be considered is how sparse or dense the matrix X is. Many algorithms behave differently depending on whether the matrix is sparse or dense. In ridge regression, there are many operations involving X including matrix-matrix products and matrix-vector products. A dense matrix leads to high computational cost whereas a sparse matrix we can significantly reduce the cost. As such, different algorithms may perform better depending on the sparsity structure of X, making matrix sparsity a relevant blocking factor when comparing algorithm behavior and computational efficiency.

The total number of block combinations is determined by the product of the number of levels in each blocking factor, denoted b. For example, if the experiment includes three dimensional regimes, two sparsity levels, and two regularization strengths, then there are $3 * 2 * 2 = 12$ block combinations. We will also denote r to be the number of replicated datasets in each block. Here, we mean the number datasets within a block. The total number of experimental units is then ${b * r}$.

| Blocking System | Factor | Blocks |
|:----------------|:-------|:-------|
| Dataset | Dimensional regime (`(p/n)`) | $(p \ll n)$, $(p \approx n)$, $(p \gg n)$|
| Ridge Penalty| Value of ${\lambda}$ relative to the singular values | Small, Large (determined by comparing 𝜆 to the magnitude of the singular values of $$X^\top X$$ estimated via the Frobenius norm and SVD)|
| Matrix Sparsity| Density of non-zero values in X | Sparse (< 10% non-zero), Moderate (10%-50% non-zero), Dense (> 50% non-zero)|
# Treatments

The treatments are the ridge regression solution methods:

- Gradient-based optimization
- Stochastic gradient descent
- Direct Methods
    - Bidiagonalization
 
 Since each experimental unit will recieves all t treatments, the total number of algorithm runs in the experiment is ${t * b * r}$. For this experiment, ${t=3}$. To ensure fair comparison between algorithms, each treatment will be applied under a fixed time constraint. Each algorithm will be run for a maximum of two hours per experimental unit. 
# Observational Units and Measurements

The observational units are each algorithm-dataset pair. For each combination we will observe the following 

| Column Name | Data Type | Description |
|:---|:---|:---|
| `dataset_id` | Integer | Identifier for the generated dataset (experimental unit). |
| `dimensional_regime` | String | Relationship between predictors and observations: `p << n`, `p ≈ n`, or `p >> n`. |
| `sparsity_level` | String | Density of the matrix `X`: `Sparse`, `Moderate`, or `Dense`. |
| `lambda_level` | String | Relative magnitude of the ridge penalty parameter `λ`: `Small` or `Large`. |
| `algorithm` | String | Ridge regression solution method used: `GradientDescent`, `SGD`, or `DirectMethod`. |
| `runtime_seconds` | Positive Floating-point | Time required for the algorithm to compute a solution. |
| `iterations` | Positive Integer | Number of iterations performed by the algorithm (`NA` for direct methods). |
| `residual_norm` | Positive Floating-point | Norm, measuring how well the solution fits the regression problem. |

The collected measurements will be written to a CSV file. Each row in the file corresponds to a single algorithm–dataset pair, which forms the observational unit of the experiment. The columns represent the recorded measurements. After the experiment, the resulting CSV file should contain ${Algorithms * Datasets}$ number of rows and each row will contain exactly eight columns.

We also plan to observe the residual norm and the 