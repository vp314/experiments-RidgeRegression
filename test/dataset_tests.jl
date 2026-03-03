using Test
using DataFrames
using CSV

include("../src/dataset.jl")
@testset "Dataset" begin
    X = [1 2; 3 4]
    y = [10, 20]
    d = Dataset("toy", X, y)

    @test d.name == "toy"
    @test d.X isa Matrix{Float64}
    @test d.y isa Vector{Float64}
    @test size(d.X) == (2, 2)
    @test length(d.y) == 2
    @test d.X[1, 1] == 1.0
    @test d.y[2] == 20.0

    @test_throws ArgumentError Dataset("bad", X, [1, 2, 3])
end

@testset "one_hot_encode" begin
    df = DataFrame(
        A = ["red", "blue", "red", "green"],
        B = [1, 2, 3, 4],
        C = ["small", "large", "medium", "small"]
    )

    X = redirect_stdout(devnull) do
        one_hot_encode(df; drop_first = true)
    end

    @test size(X) == (4, 5)
    @test X[:, 3] == [1.0, 2.0, 3.0, 4.0]
    @test all(x -> x == 0.0 || x == 1.0, X[:, [1,2,4,5]])
    @test all(vec(sum(X[:, 1:2]; dims=2)) .<= 1)
    @test all(vec(sum(X[:, 4:5]; dims=2)) .<= 1)
end

@testset "csv_dataset" begin
    tmp = tempname() * ".csv"
    df = DataFrame(
        a = [1.0, 2.0, missing, 4.0],
        b = ["x", "y", "y", "x"],
        y = [10.0, 20.0, 30.0, 40.0]
    )
    CSV.write(tmp, df)

    d = redirect_stdout(devnull) do
        csv_dataset(tmp; target_col=:y, name="tmp")
    end

    @test d.name == "tmp"
    @test d.X isa Matrix{Float64}
    @test d.y isa Vector{Float64}

    @test length(d.y) == 3
    @test size(d.X, 1) == 3
    @test d.y == [10.0, 20.0, 40.0]

    d2 = redirect_stdout(devnull) do
        csv_dataset(tmp; target_col=3, name="tmp2")
    end
    @test d2.y == [10.0, 20.0, 40.0]
    @test size(d2.X, 1) == 3
end
