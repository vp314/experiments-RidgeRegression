"""
    Unit{TX<:AbstractMatrix, TY<:AbstractVector, Tλ<:Real}

An experimental unit for ridge regression experiments.

# Description

A `Unit` object stores the design matrix `X`, response vector `y`,
regularization parameter `λ`, and dimensions `n` and `p`
for a ridge regression problem.

# Fields
- `name::String`: Name of the unit
- `X::TX`: Matrix of variables/features
- `y::TY`: Target vector
- `λ::Tλ`: Regularization parameter for ridge regression
- `n::Int`: Number of rows
- `p::Int`: Number of columns

# Constructor

    Unit(name::String, X::AbstractMatrix, y::AbstractVector, λ::Real)

## Arguments
- `name::String`: Name of the unit
- `X::AbstractMatrix`: Matrix of variables/features
- `y::AbstractVector`: Target vector
- `λ::Real`: Regularization parameter for ridge regression

## Returns
- A `Unit` object containing the design matrix, response vector, regularization parameter, and dimensions.

## Throws
- `ArgumentError`: If rows in `X` do not equal length of `y`.
"""
struct Unit{TX<:AbstractMatrix, TY<:AbstractVector, Tλ<:Real}
    name::String
    X::TX
    y::TY
    λ::Tλ
    n::Int
    p::Int

    function Unit(name::String, X::TX, y::TY, λ::Tλ) where {
        TX<:AbstractMatrix,
        TY<:AbstractVector,
        Tλ<:Real
    }
        size(X, 1) == length(y) ||
            throw(ArgumentError("X and y must have same number of rows"))

        n, p = size(X)

        new{TX, TY, Tλ}(name, X, y, λ, n, p)
    end
end

"""
    one_hot_encode(Xdf::DataFrame; drop_first=true)

One-hot encode categorical (string-like) features in `Xdf`.

# Arguments
- `Xdf::DataFrame`: Input DataFrame containing features and response vector `y`.

# Keyword Arguments
- `cols_to_encode`: A collection of column names or indices to one-hot encode.
- `drop_first::Bool=true`: If `true`, drop the first dummy column for
  each categorical feature to avoid multicollinearity.

# Returns
- `::Matrix{Float64}`: A numeric matrix containing the encoded feature.

# Throws
- `ArgumentError`: If a column in `Xdf` is not numeric and not listed in `cols_to_encode`.
"""
function one_hot_encode(Xdf::DataFrame; cols_to_encode, drop_first::Bool = true)::Matrix{Float64}
    n = nrow(Xdf)
    cols = Vector{Vector{Float64}}()
    push!(cols, ones(Float64, n)) #Add a column of ones for the intercept term in the design matrix.
    encode_names = Set(c isa Int ? Symbol(names(Xdf)[c]) : Symbol(c) for c in cols_to_encode)


    for name in names(Xdf) #Selecting columns that aren't the target variable and pushing them to the columns.
        col = Xdf[!, name]
        name_sym = Symbol(name)
        if name_sym in encode_names
            scol = string.(col) # Convert to string for categorical processing.
            lv = unique(scol) #Get unique category levels.
            ind = scol .== permutedims(lv) #Create indicator matrix for each level of the categorical variable.
            #Permutedims is used to align the dimensions for broadcasting.
            #Broadcasting compares each element of `scol` with each level in `lv`, resulting in a matrix where each column corresponds to a level and contains `true` for rows that match that level and `false` otherwise.

        if drop_first && size(ind, 2) > 1 #Drop the first column of the indicator matrix to avoid multicollinearity if drop_first is true and there are multiple levels.
            ind = ind[:, 2:end]
        end

        for j in 1:size(ind, 2)
            push!(cols, Float64.(ind[:, j])) #Convert the boolean indicator columns to Float64 and add them to the list of columns.
        end
    else
            eltype(col) <: Real ||
                throw(ArgumentError("Column $name must be numeric unless it is listed in cols_to_encode"))

            push!(cols, Float64.(col))
        end
    end

    p = length(cols)
    X = Matrix{Float64}(undef, n, p)
    for j in 1:p
        X[:, j] = cols[j]
    end

    return Matrix{Float64}(X)

end
"""
    load_csv_dataset(path_or_url; target_col, name="csv_dataset")

Load a dataset from a CSV file or URL and removes rows with missing values.

# Arguments
- `path_or_url::String`: Local file path or web URL containing CSV data.

# Keyword Arguments
- `cols_to_encode=Symbol[]`: Column names or indices in the feature data to one-hot encode.
- `target_col`: Column index or column name containing the response variable.
- `name::String="csv_dataset"`: Dataset name.

# Returns
- `Dataset`: A dataset containing the encoded feature matrix `X`, response vector `y`, and dataset name.
"""
function load_csv_dataset(path_or_url::String;  cols_to_encode=Symbol[], target_col, name::String = "csv_dataset")

    filepath =
        startswith(path_or_url, "http") ?
        Downloads.download(path_or_url) :
        path_or_url

    df = DataFrame(CSV.File(filepath)) #Read CSV file into a DataFrame.
    df = dropmissing(df) #Remove rows with missing values.
    Xdf = select(df, DataFrames.Not(target_col)) #Select all columns except the target column for features.

    y = target_col isa Int ?
        df[:, target_col] : #If target_col is an integer, use it as a column index to extract the target variable from the DataFrame.
        df[:, Symbol(target_col)] #Extract the target variable based on whether target_col is an index or a name.


    feature_names = names(Xdf)
    encode_cols = [c isa Int ? Symbol(names(Xdf)[c]) : Symbol(c) for c in cols_to_encode]
    X = one_hot_encode(Xdf; cols_to_encode=encode_cols, drop_first = true)


    return Dataset(name, X, collect(Float64, y))
end
