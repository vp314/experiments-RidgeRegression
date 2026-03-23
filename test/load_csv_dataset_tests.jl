@testset "Testset 1" begin
    tmp = tempname() * ".csv"

    df = DataFrame(
        a = [1.0, 2.0, missing, 4.0],
        b = ["x", "y", "y", "x"],
        y = [10.0, 20.0, 30.0, 40.0]
    )

    CSV.write(tmp, df)

    d = load_csv_dataset(tmp; target_col=:y, cols_to_encode=[:b], name="tmp")

    @test "tmp" == d.name
    @test 3 == length(d.y)
    @test 3 == size(d.X, 1)
    @test [10.0, 20.0, 40.0] == d.y
    @test (3, 2) == size(d.X)
end

@testset "Testset 2" begin
    tmp = tempname() * ".csv"

    df = DataFrame(
        a = [1.0, 2.0, missing, 4.0],
        b = ["x", "y", "y", "x"],
        y = [10.0, 20.0, 30.0, 40.0]
    )

    CSV.write(tmp, df)

    d = load_csv_dataset(tmp; target_col=3, cols_to_encode=[:b], name="tmp2")

    @test "tmp2" == d.name
    @test [10.0, 20.0, 40.0] == d.y
    @test 3 == size(d.X, 1)
    @test (3, 2) == size(d.X)
end
