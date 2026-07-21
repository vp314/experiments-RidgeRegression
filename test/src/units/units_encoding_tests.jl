module EncodingTests

using Test
using DataFrames
using ..RidgeRegression

@testset "one_hot_encode encodes specified categorical columns and keeps numeric columns" begin
    df = DataFrame(
        A = ["red", "blue", "red", "green"],
        B = [1, 2, 3, 4],
        C = ["small", "large", "medium", "small"]
    )

    X = one_hot_encode(df; cols_to_encode=[:A, :C], drop_first=true)

    @test (4, 6) == size(X)
    @test all(X[:, 1] .== 1.0)
    @test [1.0, 2.0, 3.0, 4.0] == X[:, 4]
    @test all(x -> x == 0.0 || x == 1.0, X[:, [2, 3, 5, 6]])
    @test all(vec(sum(X[:, 2:3]; dims=2)) .<= 1)
    @test all(vec(sum(X[:, 5:6]; dims=2)) .<= 1)
end

@testset "one_hot_encode throws error for invalid column specifications" begin
    df = DataFrame(
        A = ["red", "blue", "red", "green"],
        B = [1, 2, 3, 4],
        C = ["small", "large", "medium", "small"]
    )

    @test_throws ArgumentError one_hot_encode(df; cols_to_encode=[:A], drop_first=true)
end

@testset "one_hot_encode supports integer-coded categorical columns when specified" begin
    df = DataFrame(
        group = [1, 2, 1, 3],
        x = [10.0, 20.0, 30.0, 40.0]
    )

    X = one_hot_encode(df; cols_to_encode=[:group], drop_first=true)

    @test (4, 4) == size(X)
    @test all(X[:, 1] .== 1.0)
    @test [10.0, 20.0, 30.0, 40.0] == X[:, 4]
    @test all(x -> x == 0.0 || x == 1.0, X[:, 2:3])
end

end