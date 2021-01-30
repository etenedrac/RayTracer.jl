#===============
    STRUCTS
===============#

mutable struct sphere <: RayTracer.RTObject
    id::UUID
    radius::Float64
    position::rt_tuple
    transform::Array{Float64,2}
    material::RayTracer.RTMaterial
    function sphere()
        return new(uuid4(),1.0,RayTracer.point(0.,0.,0.),Matrix(I,4,4),RayTracer.material())
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

function normal_at(s::sphere,p::RayTracer.rt_tuple)::RayTracer.rt_tuple
    object_normal = inv(s.transform)*p - s.position
    return_transform = zeros(4,4)
    return_transform[1:3,1:3] = inv(RayTracer.submatrix(s.transform,4,4))'
    return_transform[4,4] = 1
    return RayTracer.normalize(return_transform*object_normal)
end