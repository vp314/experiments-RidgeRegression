using RidgeRegression
using Test

@testset "RidgeRegression.jl" begin
    include("dataset_tests.jl")
    include("bidiagonalization_tests.jl")
end
