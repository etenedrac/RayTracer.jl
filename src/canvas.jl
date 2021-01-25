
mutable struct canvas
    width::Int
    height::Int
    grid::Array{RayTracer.rt_color{Float64},2}
end

Base.convert(::Type{RayTracer.rt_color{Float64}}, x::RayTracer.rt_color) = RayTracer.color(
    float(x.red), float(x.green), float(x.blue)
)

Base.promote_rule(::Type{RayTracer.rt_color{Float64}}, ::Type{RayTracer.rt_color{Integer}}) = RayTracer.rt_color{Float64}

function canvas(width::Int,height::Int)::canvas
    return canvas(width,height,fill(color(0.,0.,0.),(width,height)))
end

function write_pixel!(canv::canvas,x::Int,y::Int,c::RayTracer.rt_color)
    if x<=0 || x>canv.width
        println("Warning: not painting in x:$x, y:$y.")
        return nothing
    elseif y<=0 || y>canv.height
        println("Warning: not painting in x:$x, y:$y.")
        return nothing
    else
        canv.grid[x,y] = c
    end
end

function pixel_at(c::canvas, x::Int, y::Int)::RayTracer.rt_color
    return c.grid[x,y]
end

function canvas_to_ppm(c::canvas,filename::String="canvas.txt")::String
    payload = ""
    payload *= "P3\n"
    payload *= "$(c.width) $(c.height)\n"
    payload *= "255\n"
    for height in 1:c.height
        new_line = ""
        for width in 1:c.width
            px = pixel_at(c,width,height)
            for color in [px.red,px.green,px.blue]
                cl = min(max(convert(Int, round(color*255, digits=0)),0),255)
                if length(new_line*" "*string(cl))<71
                    new_line *= string(cl)*" "
                else
                    payload *= new_line[1:end-1]*"\n"
                    new_line = string(cl)*" "
                end
            end
        end
        payload *= new_line[1:end-1]*"\n"
    end
    open(filename, "w") do io
        write(io, payload)
    end
    return filename
end