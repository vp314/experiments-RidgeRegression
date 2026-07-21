using RidgeRegression
using Test
using LinearAlgebra

@testset "RidgeRegression.jl" begin
    @testset "Compute Givens Rotations Tests" begin
        include("compute_givens_tests.jl")
    end

    @testset "Rotate Columns Tests" begin
        include("rotate_cols_tests.jl")
    end

    @testset "Rotate Rows Tests" begin
        include("rotate_rows_tests.jl")
    end

    @testset "Bidiagonalization with A Tests" begin
        include("bidiagonalize_A_tests.jl")
    end

    @testset "Applying Ht to b Tests" begin
        include("apply_Ht_to_b_tests.jl")
    end

    @testset "Bidiagonalization with H Tests" begin
        include("bidiagonalize_with_H_tests.jl")
    end
end
