@testset "Testset 1" begin
    M = [3.0 4.0;
         1.0 2.0]

    c, s = compute_givens(3.0, 4.0)
    rotate_cols!(M, 1, 2, c, s)

    @test isapprox(M[1, 2], 0.0; atol=1e-12, rtol=0)
end
