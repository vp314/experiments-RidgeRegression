module RidgeRegression

using CSV
using DataFrames
using Downloads
using LinearAlgebra

include("dataset.jl")

export Dataset, load_csv_dataset, one_hot_encode

end
