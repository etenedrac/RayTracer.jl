#===============
    STRUCTS
===============#

mutable struct sphere <: RayTracer.RTObject
    id::UUID
    radius::Float64
    position::rt_tuple
    transform::Array{Float64,2}
    function sphere()
        return new(uuid4(),1.0,RayTracer.point(0.,0.,0.),Matrix(I,4,4))
    end
end


#===============
    FUNCTIONS
===============#


function intersect(s::sphere,r::ray)::Array{intersection,1}
    r2 = transform(r,inv(s.transform))
    x0 =  r2.origin - s.position
    a = RayTracer.dot(r2.direction,r2.direction)
    b = 2*RayTracer.dot(r2.direction,x0)
    c = RayTracer.dot(x0,x0) - s.radius^2

    discriminant = b^2 - 4*a*c
    if discriminant<0
        return []
    end
    t1 = -(b+sqrt(discriminant))/(2*a)
    t2 = -(b-sqrt(discriminant))/(2*a)
    return [intersection(t1,s),intersection(t2,s)]
end