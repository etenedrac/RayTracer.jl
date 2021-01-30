using RayTracer
using Test

@testset "Tuples" begin
    include("tuples.jl")
end

@testset "Canvas" begin
    include("canvas.jl")
end

@testset "Transformations" begin
    include("transformations.jl")
end

@testset "Rays" begin
    include("rays.jl")
end

@testset "Sphere" begin
    include("sphere.jl")
end

@testset "Light" begin
    include("light.jl")
end

@testset "Materials" begin
    include("material.jl")
end