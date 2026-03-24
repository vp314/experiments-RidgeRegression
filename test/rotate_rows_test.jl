@testset "rotate_rows!" begin
    M = [1.0 2.0;
         3.0 4.0]

    c, s = compute_givens(1.0, 3.0)
    rotate_rows!(M, 1, 2, c, s)

    @test isapprox(M[2, 1], 0.0; atol=1e-12, rtol=0)
end
