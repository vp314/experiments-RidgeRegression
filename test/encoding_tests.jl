@testset "one_hot_encode encodes specified categorical columns and keeps numeric columns" begin
    df = DataFrame(
        A = ["red", "blue", "red", "green"],
        B = [1, 2, 3, 4],
        C = ["small", "large", "medium", "small"]
    )

    X = one_hot_encode(df; cols_to_encode=[:A, :C], drop_first=true)

    @test (4, 5) == size(X)
    @test [1.0, 2.0, 3.0, 4.0] == X[:, 3]
    @test all(x -> x == 0.0 || x == 1.0, X[:, [1, 2, 4, 5]])
    @test all(vec(sum(X[:, 1:2]; dims=2)) .<= 1)
    @test all(vec(sum(X[:, 4:5]; dims=2)) .<= 1)
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

    @test (4, 3) == size(X)
    @test [10.0, 20.0, 30.0, 40.0] == X[:, 3]
    @test all(x -> x == 0.0 || x == 1.0, X[:, 1:2])
end
