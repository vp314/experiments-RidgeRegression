"""
    Dataset(name, X, y)

Contains datasets for ridge regression experiments.

# Fields
- `name::String`: Name of dataset
- `X::Matrix{Float64}`: Matrix of variables/features
- `y::Vector{Float64}`: Target vector

# Throws
- `ArgumentError`: If rows in `X` does not equal length of `y`.

!!! note
    Used as the experimental unit for ridge regression experiments.
"""
struct Dataset
    name::String
    X::Matrix{Float64}
    y::Vector{Float64}

    function Dataset(name::String, X::AbstractMatrix, y::AbstractVector)
        size(X, 1) == length(y) ||
            throw(ArgumentError("X and y must have same number of rows"))

        new(name, Matrix{Float64}(X), Vector{Float64}(y))
    end
end

"""
    one_hot_encode(Xdf::DataFrame; drop_first=true)

One-hot encode categorical (string-like) features in `Xdf`.

# Arguments
- `Xdf::DataFrame`: Input DataFrame containing features and response vector `y`.

# Keyword Arguments
- `drop_first::Bool=true`: If `true`, drop the first dummy column for
  each categorical feature to avoid multicollinearity.

# Returns
- `Matrix{Float64}`: A numeric matrix containing the encoded feature.
"""
function one_hot_encode(Xdf::DataFrame; drop_first::Bool = true)::Matrix{Float64}
    n = nrow(Xdf)
    cols = Vector{Vector{Float64}}()

    for name in names(Xdf) #Selecting columns that aren't the target variable and pushing them to the columns.
        col = Xdf[!, name]
        if eltype(col) <: Real
            push!(cols, Float64.(col))
            continue
        end

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
    end

    p = length(cols)
    X = Matrix{Float64}(undef, n, p)
    for j in 1:p
        X[:, j] = cols[j]
    end

    return Matrix{Float64}(X)

end
"""
    csv_dataset(path_or_url; target_col, name="csv_dataset")

Load a dataset from a CSV file or URL.

# Arguments
- `path_or_url::String`: Local file path or web URL containing CSV data.

# Keyword Arguments
- `target_col`: Column index or column name containing the response variable.
- `name::String="csv_dataset"`: Dataset name.

# Returns
- `Dataset`: A dataset containing the encoded feature matrix `X`, response vector `y`, and dataset name.
"""
function csv_dataset(path_or_url::String;
    target_col,
    name::String = "csv_dataset"
)

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


    X = one_hot_encode(Xdf; drop_first = true)



    return Dataset(name, Matrix{Float64}(X), Vector{Float64}(y))
end
