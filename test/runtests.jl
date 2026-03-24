using RidgeRegression
using Test

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
end
