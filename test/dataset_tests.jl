@testset "Testset 1" begin
    X = [1 2; 3 4]
    y = [10, 20]
    d = Dataset("toy", X, y)

    @test "toy" == d.name
    @test X == d.X
    @test y == d.y
    @test (2, 2) == size(d.X)
    @test 2 == length(d.y)
    @test 1.0 == d.X[1, 1]
    @test 20.0 == d.y[2]
end

@testset "Testset 2" begin
    X = [1 2; 3 4]

    @test_throws ArgumentError Dataset("bad", X, [1, 2, 3])
end
