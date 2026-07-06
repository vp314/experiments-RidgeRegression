@testset "Unit constructor stores fields correctly" begin
    X = [1 2; 3 4]
    y = [10, 20]
    λ = 0.1
    d = Unit("toy", X, y, λ)

    @test "toy" == d.name
    @test X == d.X
    @test y == d.y
    @test λ == d.λ
    @test 2 == d.n
    @test 2 == d.p
    @test (2, 2) == size(d.X)
    @test 2 == length(d.y)
    @test 1.0 == d.X[1, 1]
    @test 20.0 == d.y[2]
end

@testset "Unit constructor throws error for mismatched dimensions" begin
    X = [1 2; 3 4]
    λ = 0.1
    @test_throws ArgumentError Unit("bad", X, [1, 2, 3], λ)
end
