#===============
    STRUCTS
===============#

abstract type RTLight end

struct point_light <: RTLight
    position::RayTracer.rt_tuple
    intensity::RayTracer.rt_color
end


#===============
    FUNCTIONS
===============#