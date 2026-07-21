module ApplyHtToBTests

using Test
using ..RidgeRegression

@testset "bidiagonalize_with_H applies Ht to b" begin
    A = [1.0 2.0;
         3.0 4.0]

    L = Matrix{Float64}(I, 2, 2)
    b = [5.0, 6.0]

    B, C, H, K, Ht, bhat = bidiagonalize_with_H(A, L, b)

    @test bhat ≈ Ht * b
    @test bhat ≈ H' * b

    B2, C2, H2, K2, Ht2 = bidiagonalize_A(A, L)

    @test B ≈ B2
    @test C ≈ C2
    @test H ≈ H2
    @test K ≈ K2
    @test Ht ≈ Ht2
end

end