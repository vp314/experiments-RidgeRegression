module RidgeRegression

using CSV
using DataFrames
using Downloads

include("dataset.jl")

export Dataset, load_csv_dataset, one_hot_encode

end
