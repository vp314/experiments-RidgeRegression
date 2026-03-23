using RidgeRegression
using Test
using DataFrames
using CSV

@testset "RidgeRegression.jl" begin
    @testset "Dataset tests" begin
        include("dataset_tests.jl")
    end

    @testset "Encoding tests" begin
        include("encoding_tests.jl")
    end

    @testset "Load CSV dataset tests" begin
        include("load_csv_dataset_tests.jl")
    end
end
