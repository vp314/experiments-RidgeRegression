@testset "bidiagonalize_with_H preserves orthogonality and factorization identities" begin
    A = [1.0 2.0 3.0;
         4.0 5.0 6.0;
         7.0 8.0 10.0]

    L = Matrix{Float64}(I, 3, 3)
    b = [1.0, 2.0, 3.0]

    B, C, H, K, Ht, bhat = bidiagonalize_with_H(A, L, b)

    # Ht should be the transpose of H
    @test Ht ≈ H'

    # Orthogonality of H and K
    @test H' * H ≈ Matrix{Float64}(I, 3, 3)
    @test H * H' ≈ Matrix{Float64}(I, 3, 3)
    @test K' * K ≈ Matrix{Float64}(I, 3, 3)
    @test K * K' ≈ Matrix{Float64}(I, 3, 3)

    # Main factorization identity
    @test H' * A * K ≈ B

    @test H' * b ≈ bhat

    # Applies right transforms to L, implicitly assuming J = I
    @test L * K ≈ C
end

@testset "bidiagonalize_with_H produces upper bidiagonal matrix" begin
    A = [2.0 1.0 3.0;
         4.0 5.0 6.0;
         7.0 8.0 9.0]

    L = Matrix{Float64}(I, 3, 3)
    b = [1.0, -1.0, 2.0]

    B, C, H, K, Ht, bhat = bidiagonalize_with_H(A, L, b)

    m, n = size(B)

    for i in 1:m
        for j in 1:n
            # In an upper bidiagonal matrix, only diagonal and superdiagonal may be nonzero
            if !(j == i || j == i + 1)
                @test isapprox(B[i, j], 0.0; atol=1e-10, rtol=0)
            end
        end
    end
end

@testset "bidiagonalize_with_H handles rectangular matrices" begin
    A = [1.0 2.0 3.0;
         4.0 5.0 6.0;
         7.0 8.0 9.0;
         1.0 0.0 1.0]

    L = Matrix{Float64}(I, 3, 3)
    b = [1.0, 2.0, 3.0, 4.0]

    B, C, H, K, Ht, bhat = bidiagonalize_with_H(A, L, b)

    m, n = size(A)

    @test size(B) == (m, n)
    @test size(C) == size(L)
    @test size(H) == (m, m)
    @test size(K) == (n, n)
    @test size(Ht) == (m, m)
    @test length(bhat) == length(b)

    @test H' * H ≈ Matrix{Float64}(I, m, m)
    @test K' * K ≈ Matrix{Float64}(I, n, n)

    @test H' * A * K ≈ B
    @test H' * b ≈ bhat
    @test L * K ≈ C

    for i in 1:m
        for j in 1:n
            if !(j == i || j == i + 1)
                @test isapprox(B[i, j], 0.0; atol=1e-10, rtol=0)
            end
        end
    end
end

@testset "bidiagonalize_with_H correctly zeroes subdiagonal entry in small matrix" begin
    A = [3.0 0.0;
         4.0 5.0]

    L = Matrix{Float64}(I, 2, 2)
    b = [1.0, 2.0]

    B, C, H, K, Ht, bhat = bidiagonalize_with_H(A, L, b)

    @test H' * A * K ≈ B
    @test H' * b ≈ bhat
    @test L * K ≈ C

    @test isapprox(B[2,1], 0.0; atol=1e-12, rtol=0)
end
