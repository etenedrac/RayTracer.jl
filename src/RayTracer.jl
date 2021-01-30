module RayTracer
    import Base
    using LinearAlgebra
    using UUIDs

    include("tuples.jl")
    include("canvas.jl")
    include("transformations.jl")
    include("rays.jl")

    include("light.jl")
    include("material.jl")

    include("sphere.jl")

end
