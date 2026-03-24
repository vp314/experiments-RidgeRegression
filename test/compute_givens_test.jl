@testset "Testset 1" begin
    c, s = compute_givens(3.0, 0.0)
    @test c == 1.0
    @test s == 0.0
    a = 3.0
    b = 4.0
    c, s = compute_givens(a, b)
    v1 = c*a + s*b
    v2 = -s*a + c*b
    @test isapprox(v2, 0.0; atol=1e-12, rtol=0)
    @test isapprox(abs(v1), hypot(a, b); atol=1e-12, rtol=0)
    @test_throws ArgumentError compute_givens(0.0, 2.0)
end
