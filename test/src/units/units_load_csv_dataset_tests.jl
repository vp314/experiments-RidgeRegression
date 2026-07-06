@testset "load_csv_dataset drops missing rows and uses target column" begin
    tmp = tempname() * ".csv"

    df = DataFrame(
        a = [1.0, 2.0, missing, 4.0],
        b = ["x", "y", "y", "x"],
        y = [10.0, 20.0, 30.0, 40.0]
    )

    CSV.write(tmp, df)

    λ = 0.1
    d = load_csv_dataset(tmp; target_col=:y, cols_to_encode=[:b], name="tmp", λ=λ)

    @test "tmp" == d.name
    @test λ == d.λ
    @test 3 == d.n
    @test 3 == d.p
    @test 3 == length(d.y)
    @test 3 == size(d.X, 1)
    @test all(d.X[:, 1] .== 1.0)
    @test [10.0, 20.0, 40.0] == d.y
    @test (3, 3) == size(d.X)
end

@testset "load_csv_dataset drops missing rows and uses target column by index" begin
    tmp = tempname() * ".csv"

    df = DataFrame(
        a = [1.0, 2.0, missing, 4.0],
        b = ["x", "y", "y", "x"],
        y = [10.0, 20.0, 30.0, 40.0]
    )

    CSV.write(tmp, df)

    λ = 0.5
    d = load_csv_dataset(tmp; target_col=3, cols_to_encode=[:b], name="tmp2", λ=λ)

    @test "tmp2" == d.name
    @test λ == d.λ
    @test 3 == d.n
    @test 3 == d.p
    @test all(d.X[:, 1] .== 1.0)
    @test [10.0, 20.0, 40.0] == d.y
    @test 3 == size(d.X, 1)
    @test (3, 3) == size(d.X)
end