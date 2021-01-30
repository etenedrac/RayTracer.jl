#===============
    STRUCTS
===============#

mutable struct RTMaterial
    color::RayTracer.rt_color
    ambient::Float64
    diffuse::Float64
    specular::Float64
    shininess::Float64
end


#===============
    FUNCTIONS
===============#

function material(
        color::RayTracer.rt_color,ambient::Float64,
        diffuse::Float64,specular::Float64,shininess::Float64
    )
    return RTMaterial(color,ambient,diffuse,specular,shininess)
end

function material()
    return RTMaterial(RayTracer.color(1,1,1),0.1,0.9,0.9,200)
end

function Base.isapprox(a::RTMaterial,b::RTMaterial,atol::Real=0)
    return (≈(a.color,b.color)) && (≈(a.ambient,b.ambient,atol=atol)) && 
        (≈(a.diffuse,b.diffuse,atol=atol)) && (≈(a.specular,b.specular,atol=atol)) &&
        (≈(a.shininess,b.shininess,atol=atol))
end

function lighting(
        material::RTMaterial,light::RayTracer.RTLight,p::RayTracer.rt_tuple,
        eye_v::RayTracer.rt_tuple,normal_v::RayTracer.rt_tuple
    )
    # Combining light and material color
    effective_color = material.color * light.intensity

    # Direction of light source
    light_v = RayTracer.normalize(light.position - p)

    # Ambient contribution to final color
    ambient = effective_color*material.ambient

    light_normal_component = RayTracer.dot(light_v,normal_v)
    if light_normal_component<0
        diffuse = RayTracer.color(0,0,0)
        specular = RayTracer.color(0,0,0)
    else
        # Diffuse contribution
        diffuse = effective_color*material.diffuse*light_normal_component

        # Specular contribution
        light_v_reflected = RayTracer.reflect(-light_v,normal_v)
        reflection_eye_component = RayTracer.dot(light_v_reflected,eye_v)

        if reflection_eye_component<0
            specular = RayTracer.color(0,0,0)
        else
            factor = reflection_eye_component^material.shininess
            specular = light.intensity*material.specular*factor
        end
    end
    
    return ambient + diffuse + specular
end