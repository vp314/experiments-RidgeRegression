using RidgeRegression
using Test
using DataFrames
using LinearAlgebra
using CSV

@testset "RidgeRegression.jl" begin
    @testset "Dataset Tests" begin
        include("src/units/units_dataset_tests.jl")
    end

    @testset "One-Hot Encoding Tests" begin
        include("src/units/units_encoding_tests.jl")
    end

    @testset "Load CSV Dataset Tests" begin
        include("src/units/units_load_csv_dataset_tests.jl")
    end

end
