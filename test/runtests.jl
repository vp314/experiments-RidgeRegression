using RidgeRegression
using Test
using LinearAlgebra

@testset "RidgeRegression.jl" begin
    @testset "Compute Givens Rotations Tests" begin
        include("compute_givens_test.jl")
    end

    @testset "Rotate Columns Tests" begin
        include("rotate_cols_test.jl")
    end

    @testset "Rotate Rows Tests" begin
        include("rotate_rows_test.jl")
    end

    @testset "Bidiagonalization Tests" begin
        include("bidiagonalize_with_H_tests.jl")
    end

    @testset "Applying Ht to b Tests" begin
        include("apply_Ht_to_b_test.jl")
    end
end
