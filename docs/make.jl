using RidgeRegression
using Documenter

DocMeta.setdocmeta!(RidgeRegression, :DocTestSetup, :(using RidgeRegression); recursive=true)

makedocs(;
    modules=[RidgeRegression],
    authors="Vivak Patel <vp314@users.noreply.github.com>",
    sitename="RidgeRegression.jl",
    format=Documenter.HTML(;
        canonical="https://vp314.github.io/RidgeRegression.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/vp314/RidgeRegression.jl",
    devbranch="main",
)
