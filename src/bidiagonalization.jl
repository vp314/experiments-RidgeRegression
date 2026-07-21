"""
    compute_givens(a, b)

Compute Givens rotation coefficients for scalars `a` and `b`.

# Arguments
- `a::Number`: First scalar
- `b::Number`: Second scalar

# Returns
- `c::Number`: Cosine coefficient of the Givens rotation
- `s::Number`: Sine coefficient of the Givens rotation

"""
function compute_givens(a::Number, b::Number) # Compute Givens rotation coefficients for scalars a and b
    if b == 0
        return one(a), zero(a)
    elseif a == 0
        throw(ArgumentError("a is zero, cannot compute Givens rotation"))
    else
        r = hypot(a, b)
        c = a / r
        s = b / r
        return c, s
    end
end

"""
    rotate_rows!(M::AbstractMatrix,i::Int,j::Int,c::Number,s::Number)

Apply a Givens rotation to rows `i` and `j` of matrix `M`.

# Arguments
- `M::AbstractMatrix`: The matrix to be rotated
- `i::Int`: First row index
- `j::Int`: Second row index
- `c::Number`: Cosine coefficient of the Givens rotation
- `s::Number`: Sine coefficient of the Givens rotation

# Returns
- `M::AbstractMatrix`: The rotated matrix

"""
function rotate_rows!(M::AbstractMatrix,i::Int,j::Int,c::Number,s::Number)
    for k in 1:size(M,2) # Loop over columns
        temp = M[i,k] # Store the original value of M[i,k] before modification
        M[i,k] = c*temp + s*M[j,k]
        M[j,k] = -conj(s)*temp + c*M[j,k] #Apply the Givens rotation to the elements in rows i and j
    end
    return M
end


"""
    rotate_cols!(M::AbstractMatrix,i::Int,j::Int,c::Number,s::Number)

Apply a Givens rotation to columns `i` and `j` of matrix `M`.

# Arguments
- `M::AbstractMatrix`: The matrix to be rotated
- `i::Int`: First column index
- `j::Int`: Second column index
- `c::Number`: Cosine coefficient of the Givens rotation
- `s::Number`: Sine coefficient of the Givens rotation

# Returns
- `M::AbstractMatrix`: The rotated matrix

"""
function rotate_cols!(M::AbstractMatrix,i::Int,j::Int,c::Number,s::Number)
    for k in 1:size(M,1) # Loop over rows
        temp = M[k,i] # Store the original value of M[k,i] before modification
        M[k,i] = c*temp + s*M[k,j]
        M[k,j] = -conj(s)*temp + c*M[k,j] # Apply the Givens rotation to the elements in columns i and j
    end
    return M
end
"""
    bidiagonalize_A(A::AbstractMatrix, L::AbstractMatrix, b::AbstractVector)

Performs bidiagonalization of a matrix A using a sequence of Givens transformations while explicitly accumulating
the orthogonal left factor `H` and right factor `K` such that

    H' * A * K = B.

# Arguments
- `A::AbstractMatrix`: The matrix to be bidiagonalized
- `L::AbstractMatrix`: The banded matrix to be updated in-place

# Returns
- `B::AbstractMatrix`: The bidiagonalized form of the input matrix A with dimension (n,n)
- `C::AbstractMatrix`: The matrix resulting from the sequence of Givens transformations
- `H::AbstractMatrix`: The orthogonal left factor
- `K::AbstractMatrix`: The orthogonal right factor
- `Ht::AbstractMatrix`: The transpose of the orthogonal left factor

"""

function bidiagonalize_A(A::AbstractMatrix, L::AbstractMatrix)
    m, n = size(A)

    B = copy(A) #Will be transformed into bidiagonal form
    C = copy(L)

    Ht = Matrix{eltype(A)}(I, m, m) #Ht will accumulate the left transformations, initialized as identity
    K  = Matrix{eltype(A)}(I, n, n) #K will accumulate the right transformations, initialized as identity

    imax = min(m, n)

    for i in 1:imax
        # Left Givens rotations: zero below diagonal in column i
        for j in m:-1:(i + 1)
            if B[j, i] != 0
                c, s = compute_givens(B[i, i], B[j, i]) #Build Givens rotation to zero B[j, i]
                rotate_rows!(B, i, j, c, s) #Apply the Givens rotation to rows i and j of B
                rotate_rows!(Ht, i, j, c, s) #Accumulate the left transformations in Ht
                B[j, i] = zero(eltype(B))
            end
        end

        # Right Givens rotations: zero entries right of superdiagonal
        if i <= n - 2
            for k in n:-1:(i + 2)
                if B[i, k] != 0
                    c, s = compute_givens(B[i, i + 1], B[i, k]) #Build Givens rotation to zero B[i, k]
                    #s = -s
                    rotate_cols!(B, i + 1, k, c, s) #Apply the Givens rotation to columns i+1 and k of B
                    rotate_cols!(C, i + 1, k, c, s) #Apply the same right rotation to C, since C is updated by the right transformations
                    rotate_cols!(K, i + 1, k, c, s) #Accumulate the right transformations in K
                    B[i, k] = zero(eltype(B))
                end
            end
        end
    end

    H = adjoint(Ht)
    return B, C, H, K, Ht
end

"""
    apply_Ht_to_b(Ht::AbstractMatrix, b::AbstractVector)

Apply the accumulated left orthogonal transformation `H'` (stored as `Ht`)
to the constant vector `b`.

# Arguments
- `Ht::AbstractMatrix`: The transpose of the orthogonal left factor `H`.
- `b::AbstractVector`: The vector to be transformed.

# Returns
- `bhat::AbstractVector`: The transformed vector satisfying `bhat = Ht * b`.

# Throws
- `DimensionMismatch`: If the number of columns of `Ht` does not match the length of `b`.
"""
function apply_Ht_to_b(Ht::AbstractMatrix, b::AbstractVector)
    size(Ht, 2) == length(b) || throw(DimensionMismatch(
        "Ht has $(size(Ht, 2)) columns but b has length $(length(b))"
    ))
    return Ht * b
end

"""
    bidiagonalize_with_H(A, L, b)

Bidiagonalize `A` and apply the accumulated left transformation to `b`.

# Arguments
- `A::AbstractMatrix`: The matrix to be bidiagonalized.
- `L::AbstractMatrix`: The matrix updated using the accumulated right transformations.
- `b::AbstractVector`: The vector to be transformed by the accumulated left transformation.

# Returns
- `B::AbstractMatrix`: The bidiagonalized form of `A`.
- `C::AbstractMatrix`: The transformed form of `L`.
- `H::AbstractMatrix`: The left orthogonal factor.
- `K::AbstractMatrix`: The right orthogonal factor.
- `Ht::AbstractMatrix`: The transpose of `H`, representing the accumulated left transformations.
- `bhat::AbstractVector`: The transformed vector satisfying `bhat = Ht * b`.

# Throws
- `DimensionMismatch`: If the number of columns of `Ht` does not equal the length of `b`.
"""
function bidiagonalize_with_H(A::AbstractMatrix, L::AbstractMatrix, b::AbstractVector,)
    B, C, H, K, Ht = bidiagonalize_A(A, L)
    bhat = Ht * b

    return B, C, H, K, Ht, bhat
end