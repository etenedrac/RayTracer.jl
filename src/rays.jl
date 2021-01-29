#===============
    STRUCTS
===============#

struct ray
    origin::rt_tuple
    direction::rt_tuple
end

abstract type RTObject end

struct intersection
    t::Float64
    object::RayTracer.RTObject
end

#===============
    FUNCTIONS
===============#

function position(r::ray,t::T)::rt_tuple where{T<:Real}
    return r.origin + t*r.direction
end

function hit(is::Array{intersection,1})
    index = -1
    closest_i = -1
    for (idx,i) in enumerate(is)
        if i.t>0 && (i.t<closest_i || index<0)
            index = idx
            closest_i = i.t
        end
    end
    if index<0
        return nothing
    else
        return is[index]
    end
end

function transform(r::ray,M::Array{T,2})::ray where {T<:Real}
    return ray(M*r.origin,M*r.direction)
end

function set_transform!(o::RayTracer.RTObject,M::Array{T,2}) where {T<:Real}
    o.transform = M*o.transform
end