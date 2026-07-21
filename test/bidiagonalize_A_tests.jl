module BidiagonalizeATests

using Test
using ..RidgeRegression

@testset "bidiagonalize_A preserves orthogonality and factorization identities" begin
    A = [1.0 2.0 3.0;
         4.0 5.0 6.0;
         7.0 8.0 10.0]

    L = Matrix{Float64}(I, 3, 3)

    B, C, H, K, Ht = bidiagonalize_A(A, L)

    @test Ht ≈ H'

    @test H' * H ≈ Matrix{Float64}(I, 3, 3)
    @test H * H' ≈ Matrix{Float64}(I, 3, 3)
    @test K' * K ≈ Matrix{Float64}(I, 3, 3)
    @test K * K' ≈ Matrix{Float64}(I, 3, 3)

    @test H' * A * K ≈ B
    @test L * K ≈ C
end

@testset "bidiagonalize_A produces upper bidiagonal matrix" begin
    A = [2.0 1.0 3.0;
         4.0 5.0 6.0;
         7.0 8.0 9.0]

    L = Matrix{Float64}(I, 3, 3)

    B, C, H, K, Ht = bidiagonalize_A(A, L)

    m, n = size(B)

    for i in 1:m
        for j in 1:n
            if !(j == i || j == i + 1)
                @test isapprox(B[i, j], 0.0; atol=1e-10, rtol=0)
            end
        end
    end
end

@testset "bidiagonalize_A handles rectangular matrices" begin
    A = [1.0 2.0 3.0;
         4.0 5.0 6.0;
         7.0 8.0 9.0;
         1.0 0.0 1.0]

    L = Matrix{Float64}(I, 3, 3)

    B, C, H, K, Ht = bidiagonalize_A(A, L)

    m, n = size(A)

    @test size(B) == (m, n)
    @test size(C) == size(L)
    @test size(H) == (m, m)
    @test size(K) == (n, n)
    @test size(Ht) == (m, m)

    @test H' * H ≈ Matrix{Float64}(I, m, m)
    @test K' * K ≈ Matrix{Float64}(I, n, n)

    @test H' * A * K ≈ B
    @test L * K ≈ C

    for i in 1:m
        for j in 1:n
            if !(j == i || j == i + 1)
                @test isapprox(B[i, j], 0.0; atol=1e-10, rtol=0)
            end
        end
    end
end

@testset "bidiagonalize_A correctly zeroes subdiagonal entry in small matrix" begin
    A = [3.0 0.0;
         4.0 5.0]

    L = Matrix{Float64}(I, 2, 2)

    B, C, H, K, Ht = bidiagonalize_A(A, L)

    @test H' * A * K ≈ B
    @test L * K ≈ C
    @test isapprox(B[2, 1], 0.0; atol=1e-12, rtol=0)
end

end