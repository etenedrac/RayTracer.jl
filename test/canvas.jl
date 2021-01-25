using RayTracer
using Test

@testset "creating_a_canvas" begin
    c = RayTracer.canvas(10,20)
    @test c.width == 10
    @test c.height == 20
    for x=1:c.width, y=1:c.height
        @test c.grid[x,y] ≈ RayTracer.color(0,0,0)
    end
end

@testset "writing_pixels_to_canvas" begin
    c = RayTracer.canvas(10,20)
    red = RayTracer.color(1,0,0)
    RayTracer.write_pixel!(c,2,3,red)
    @test RayTracer.pixel_at(c,2,3) ≈ red
end

@testset "constructing_ppm_header" begin
    c = RayTracer.canvas(5,3)
    ppm = RayTracer.canvas_to_ppm(c)
    f = open(ppm, "r")
    header = readlines(f)[1:3]
    close(f)
    @test header == ["P3","5 3","255"]
end

@testset "constructing_ppm_pixel_data" begin
    c = RayTracer.canvas(5,3)
    c1 = RayTracer.color(1.5,0,0)
    c2 = RayTracer.color(0,0.5,0)
    c3 = RayTracer.color(-0.5,0,1)
    RayTracer.write_pixel!(c,1,1,c1)
    RayTracer.write_pixel!(c,3,2,c2)
    RayTracer.write_pixel!(c,5,3,c3)
    ppm = RayTracer.canvas_to_ppm(c)
    f = open(ppm, "r")
    body = readlines(f)[4:6]
    @test body == [
        "255 0 0 0 0 0 0 0 0 0 0 0 0 0 0",
        "0 0 0 0 0 0 0 128 0 0 0 0 0 0 0",
        "0 0 0 0 0 0 0 0 0 0 0 0 0 0 255"
    ]
end

@testset "constructing_ppm_pixel_data_large" begin
    c = RayTracer.canvas(10,2)
    c1 = RayTracer.color(1,0.8,0.6)
    for height in 1:c.height
        for width in 1:c.width
            RayTracer.write_pixel!(c,width,height,c1)
        end
    end
    ppm = RayTracer.canvas_to_ppm(c)
    f = open(ppm, "r")
    body = readlines(f)[4:7]
    @test body == [
        "255 204 153 255 204 153 255 204 153 255 204 153 255 204 153 255 204",
        "153 255 204 153 255 204 153 255 204 153 255 204 153",
        "255 204 153 255 204 153 255 204 153 255 204 153 255 204 153 255 204",
        "153 255 204 153 255 204 153 255 204 153 255 204 153"
    ]
end

@testset "ppm_files_ending_newline" begin
    c = RayTracer.canvas(5,3)
    ppm = RayTracer.canvas_to_ppm(c)
    f = open(ppm, "r")
    endchar = read(f, String)[end]
    @test endchar == '\n'
end