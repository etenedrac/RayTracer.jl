struct rt_tuple
    x::Float64
    y::Float64
    z::Float64
    w::Int
end

struct rt_color
    red::Float64
    green::Float64
    blue::Float64
end

function color(r::Real,g::Real,b::Real)
    return rt_color(promote(r,g,b)...)
end


function tuple(x::Real,y::Real,z::Real,w::Int)
    return rt_tuple(promote(x,y,z)...,w)
end

"""
    vector(x,y,z)

Create an `rt_tuple` which represents a vector, where `w=0`.

#Examples
```julia-repl
julia> a = RayTracer.vector(1,2,3)
RayTracer.rt_tuple{Int64}(1, 2, 3, 0)
```
"""
function vector(x,y,z)
    return tuple(x,y,z,0)
end

"""
    point(x,y,z)

Create an `rt_tuple` which represents a point, where `w=1`.

#Examples
```julia-repl
julia> a = RayTracer.point(1,2,3)
RayTracer.rt_tuple{Int64}(1, 2, 3, 1)
```
"""
function point(x,y,z)
    return tuple(x,y,z,1)
end

"Check whether rt_tuple{T} is a vector (w=0) or not."
function is_vector(a::rt_tuple)
    if a.w == 0
        return true
    else
        return false
    end
end

"Check whether rt_tuple{T} is a point (w=1) or not."
function is_point(a::rt_tuple)
    if a.w == 1
        return true
    else
        return false
    end
end

# Tuple Operations

function Base.isapprox(a::rt_tuple,b::rt_tuple,atol::Real=0)
    return (≈(a.x,b.x,atol=atol)) && (≈(a.y,b.y,atol=atol)) && (≈(a.z,b.z,atol=atol)) && (a.w≈b.w)
end

function Base.:+(a::rt_tuple,b::rt_tuple)::rt_tuple
    return tuple(a.x+b.x,a.y+b.y,a.z+b.z,a.w+b.w)
end

function Base.:-(a::rt_tuple,b::rt_tuple)::rt_tuple
    return tuple(a.x-b.x,a.y-b.y,a.z-b.z,a.w-b.w)
end

function Base.:-(a::rt_tuple)::rt_tuple
    return tuple(-a.x,-a.y,-a.z,-a.w)
end

function Base.:*(a::rt_tuple,b::Real)::rt_tuple
    return tuple(b*a.x,b*a.y,b*a.z,a.w)
end

function Base.:*(b::Real,a::rt_tuple)::rt_tuple
    return tuple(b*a.x,b*a.y,b*a.z,a.w)
end

function Base.:/(a::rt_tuple,b::Real)::rt_tuple
    return tuple(a.x/b,a.y/b,a.z/b,a.w)
end

function Base.:*(b::Array{T,2},a::rt_tuple)::rt_tuple where {T<:Real}
    v = [a.x;a.y;a.z;a.w]
    r = b*v
    return tuple(r[1],r[2],r[3],convert(Int, round(r[4], digits=0)))
end

# Tuple Methods

"""
    modulus(v::rt_tuple{T<:Real})

Compute the modulus (also known as magnitude) of the vector `v`.

# Examples
```julia-repl
julia> a = RayTracer.vector(1,2,3); modulus(a)
√14
```
"""
function modulus(v::rt_tuple)
    return sqrt(v.x^2 + v.y^2 + v.z^2)
end

"""
    normalize(v::rt_tuple{T<:Real})
    
Compute unit vector pointing in the same direction as `v`.

# Examples
```julia-repl
julia> a = RayTracer.vector(1,2,3); normalize(a)
RayTracer.rt_tuple{Float64}(1/√14, 2/√14, 3/√14, 0)
```
"""
function normalize(v::rt_tuple)
    return v/modulus(v)
end

"""
    dot(a::rt_tuple,b::rt_tuple)
    
Compute dot product between two vectors.

# Examples
```julia-repl
julia> a = RayTracer.vector(1,2,3);
julia> b = RayTracer.vector(2,3,4);
julia> dot(a,b)
20
```
"""
function dot(a::rt_tuple,b::rt_tuple)
    return a.x*b.x + a.y*b.y + a.z*b.z
end

"""
    cross(a::rt_tuple,b::rt_tuple)
    
Compute cross product between two vectors.

# Examples
```julia-repl
julia> a = RayTracer.vector(1,2,3);
julia> b = RayTracer.vector(2,3,4);
julia> dot(a,b)
20
```
"""
function cross(a::rt_tuple,b::rt_tuple)
    return vector(a.y*b.z-a.z*b.y,a.z*b.x-a.x*b.z,a.x*b.y-a.y*b.x)
end

"""
    reflect(v::rt_tuple,n::rt_tuple)

Reflect a vector 'v' on a surface with a normal vector 'n'.
"""
function reflect(v::rt_tuple,n::rt_tuple)::rt_tuple
    return v - 2*dot(v,n)*n
end

# Color Operations

function Base.isapprox(a::rt_color,b::rt_color,atol::Real=0)
    return (≈(a.red,b.red,atol=atol)) && (≈(a.green,b.green,atol=atol)) && (≈(a.blue,b.blue,atol=atol))
end

function Base.:+(a::rt_color,b::rt_color)::rt_color
    return color(a.red+b.red,a.green+b.green,a.blue+b.blue)
end

function Base.:-(a::rt_color,b::rt_color)::rt_color
    return color(a.red-b.red,a.green-b.green,a.blue-b.blue)
end

function Base.:*(a::rt_color,b::Real)::rt_color
    return color(b*a.red,b*a.green,b*a.blue)
end

function Base.:*(b::Real,a::rt_color)::rt_color
    return color(b*a.red,b*a.green,b*a.blue)
end

function Base.:*(a::rt_color,b::rt_color)::rt_color
    return color(b.red*a.red,b.green*a.green,b.blue*a.blue)
end


# Matrix Operations

function submatrix(a::Array{T,2},r::Int,c::Int)::Array{T,2} where {T<:Real}
    return a[1:end .!= r,1:end .!=c]
end

function minor(a::Array{T,2},r::Int,c::Int)::T where {T<:Real}
    return det(submatrix(a,r,c))
end

function cofactor(a::Array{T,2},r::Int,c::Int)::T where {T<:Real}
    return (1*((r+c)%2==0) - 1*((r+c)%2==1))*minor(a,r,c)
end