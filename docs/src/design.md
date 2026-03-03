# Motivation and Background
Many modern applications, such as genome-wide association studies (GWAS) involve regression problems with a large number of predictors. Traditional least squares methods fail due to noise and ill-conditioning. Penalized Least Squares (PLS) extends ordinary least squares (OLS) regression by adding a penalty term to shrink parameter estimates. The goal is to select the best possible model, "best" in the sense that we find the best tradeoff between goodness of fit and model complexity. Ridge regression, an approach within PLS, adds a regularization term. 

# Questions
Key Questions:
Which ridge regression algorithm is provides the best balance between:
-Numerical stability
-Computational aspects (GPU/CPU, runtime, etc)
-Predicative accuracy
# Experimental Units
The experimental units are the datasets under fixed penalty weights. Due to the statistical behavior of ridge regression algorithms depends strongly on the dimensional structure of the problem, a blocking procedure will be used. Datasets will be grouped according to their dimensional regime, characterized as p >> n, p ≈ n, and p << n. These regimes correspond to fundamentally different geometric properties of the design matrix, including rank behavior, conditioning, and the stability of the normal equations.

In addition to dimensional regime, matrix conditioning will be incorporated as a secondary blocking factor. The condition number of the design matrix quantifies the sensitivity of the regression problem to perturbations in the data and directly affects numerical stability and convergence behavior of ridge solution methods. Ill-conditioned matrices have slow convergence and are sensitive to errors, while well-conditioned matrices tend to produce stable and rapidly convergent behavior.

| Blocking System | Factor | Blocks |
|:----------------|:-------|:-------|
| Dataset | Dimensional regime (\(p/n\)) | \( p \ll n \), \( p = n \), \( p \gg n \) |
| Matrix conditioning | Condition number of \( X \) or \( X^T X \) | Low, Medium, High |
# Treatments
The treatments are the ridge regression solution methods:
-Gradient descent
-Stochastic gradient descent
-Closed-form solutions
# Observational Units and Measurements
The observational units are each algorithm-dataset pair. For each combination we will observe the following 
| Measurement System        | Factor                    | Measurements |
|:--------------------------|:--------------------------|:-------------|
| Predictive Performance    | Prediction error          | Training MSE, Test MSE, RMSE, R² |
| Estimation Accuracy       | Parameter recovery        | ‖β̂ − β_true‖₂² | (if known)
| Computational Performance | Efficiency                | Runtime (seconds), Iterations to convergence |
| Numerical Stability       | Solution accuracy         | Perturbation sensitivity |
| Model Complexity          | Coefficient magnitude     | ‖β̂‖₂ |