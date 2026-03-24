@testset "Testset 1" begin
    Ht = Matrix{Float64}(I, 3, 3)
    b  = [1.0, 2.0, 3.0]

    @test apply_Ht_to_b(Ht, b) == b
end

@testset "Testset 2" begin
    Ht = [
        1.0  0.0  0.0;
        0.0  0.0  1.0;
        0.0  1.0  0.0
    ]
    b = [4.0, 5.0, 6.0]

    @test apply_Ht_to_b(Ht, b) == [4.0, 6.0, 5.0]
end

@testset "Testset 3" begin
    c, s = 3/5, 4/5

    Ht = [
         c   s;
        -s   c
    ]
    b = [5.0, 0.0]

    @test apply_Ht_to_b(Ht, b) ≈ [3.0, -4.0]
end

@testset "Testset 4" begin
    Ht = Matrix{Float64}(I, 3, 3)
    b  = [1.0, 2.0]

    @test_throws DimensionMismatch apply_Ht_to_b(Ht, b)
end
