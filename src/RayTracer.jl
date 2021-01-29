module RayTracer
    import Base
    using LinearAlgebra
    using UUIDs

    include("tuples.jl")
    include("canvas.jl")
    include("transformations.jl")
    include("rays.jl")

    include("sphere.jl")

end
