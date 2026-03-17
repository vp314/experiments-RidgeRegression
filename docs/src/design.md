# Motivation and Background
Many modern science problems involve regression problems with extremely large numbers of predictors. Genome-wide association studies (GWAS), for example, try to identify genetic variants associated with a disease phenotype using hundreds of thousands or millions of genomic features. In such settings, traditional least squares methods fail because noise and ill-conditioning. Penalized Least Squares (PLS) extends ordinary least squares (OLS) regression by adding a penalty term to shrink parameter estimates. Ridge regression, an approach within PLS, adds a regularization term, producing a regularized estimator that helps to stabalize the solution. 

There are many numerical algorithms available to compute ridge regression estimates including direct methods, Krylov subspace methods, gradient-based optimization, coordinate descent, and stochastic gradient descent. These algorithms differ in their computational cost, memory requirements, and numerical stability. 

The goal of this experiment is to investigate the performance of these algorithms when we vary the structure and scale of the regression problem. To do this, we consider the linear model $\mathbf{y} = X\boldsymbol{\beta} + \boldsymbol{\varepsilon}$ where the matrix ${X}$ will be constructed with varying dimensions, sparsity patterns, and conditioning properties.
# Questions
Key Questions:
Which ridge regression algorithm is provides the best balance between:

- Numerical stability
- Computational aspects (GPU/CPU, runtime, etc)
# Experimental Units
The experimental units are the datasets under fixed penalty weights. Each dataset will contain a matrix ${X}$, a response vector $\mathbf{y}$, and a regularization parameter ${\lambda}$. Because the statistical behavior of ridge regression algorithms depends strongly on the dimensional structure of the problem, a blocking system will be used. Datasets will be grouped according to their dimensional regime, characterized as $p \ll n$, p ≈ n, and $p \gg n$. These regimes correspond to fundamentally different geometric properties of the design matrix, including rank behavior, conditioning, and the stability of the normal equations.

In addition to dimensional block, the strength of the ridge penalty will be incorporated as a secondary blocking factor. The ridge estimator is $\hat{\beta_R} = (X^\top X + \lambda I)^{-1}X^\top y$. The matrix conditioning number is defined as $\kappa(A) = \frac{\sigma_{\max}(A)}{\sigma_{\min}(A)}$. In the context of ridge regression, the regularization parameter ${\lambda}$, can impact the conditioning number. Let $X = U\Sigma V^\top$ be the SVD of $X$, with singular values $\sigma_1,\dots,\sigma_p$.

Then

$$
X^\top X = V \Sigma^\top \Sigma V^\top
= V \,\mathrm{diag}(\sigma_1^2,\dots,\sigma_p^2)\, V^\top .
$$

Adding the ridge term gives

$$
X^\top X + \lambda I
=
V \,\mathrm{diag}(\sigma_1^2+\lambda,\dots,\sigma_p^2+\lambda)\, V^\top .
$$
$$
\kappa_2(X^\top X+\lambda I)
=
\frac{\sigma_{\max}^2+\lambda}{\sigma_{\min}^2+\lambda}.
$$

When ${\lambda}$ is small and the singular values are large, we aren't changing the conditioning number much. As such, the ridge penalty won't really affect the condition number. Conversely, if $\sigma_{\min}$ is close to 0, we have an ill-posed problem (Existence, uniqueness, stability not satisfied). However if a large ${\lambda}$ is chosen, the condition number is reduced and the problem becomes more stable. This behavior motivates blocking experiments according to the effective conditioning induced by the ridge penalty, allowing algorithm performance to be compared across well-posed and ill-posed regression settings.

Another blocking factor that will be considered is how sparse or dense the matrix X is. Many algorithms behave differently depending on whether the matrix is sparse or dense. In ridge regression, there are many operations involving X including matrix-matrix products and matrix-vector products. A dense matrix leads to high computational cost whereas a sparse matrix we can significantly reduce the cost. As such, different algorithms may perform better depending on the sparsity structure of X, making matrix sparsity a relevant blocking factor when comparing algorithm behavior and computational efficiency.

| Blocking System | Factor | Blocks |
|:----------------|:-------|:-------|
| Dataset | Dimensional regime (\(p/n\)) | $(p \ll n)$, $(p \approx n)$, $(p \gg n)$|
| Ridge Penalty| Value of ${\lambda}$ relative to the singular values | Small, Large (Frobenius Norm range of values, Calculate Singular Values)|
| Matrix Sparsity| Density of non-zero values in X | Sparse, Moderate, Dense (Need to ask about how to quantify this)|
# Treatments
(How many treatments should we expect)
(What treatments correspond to which blocking system)

The treatments are the ridge regression solution methods:

- Gradient-based optimization
- Stochastic gradient descent
- Direct Methods

For each experimental unit, all treatments will be applied to the dataset. This will be done so that differences in performance can be attributed to the algorithms themselves rather than the data. The order of treatment application will be completely randomized to avoid any systemic bias. If there are b possible combinations of the levels of each blocking factor 

The total number of block combinations is determined by the product of the number of levels in each blocking factor. For example, if the experiment includes three dimensional regimes, two sparsity levels, and two regularization strengths, then there are $3 * 2 * 2 = 12$ block combinations.
# Observational Units and Measurements
Explanation needed
(How many rows/columns to expect)
(Explain measurements: Floating point, real, etc. Meaning of values, what values it can take.)
The observational units are each algorithm-dataset pair. For each combination we will observe the following 
| Measurement System        | Factor                    | Measurements |
|:--------------------------|:--------------------------|:-------------|
| Computational Performance | Efficiency                | Runtime (seconds), Iterations to convergence |
| Numerical Stability       | Solution accuracy         | Perturbation sensitivity |