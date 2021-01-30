
@testset "default_material" begin
    m = RayTracer.material()
    @test m.color ≈ RayTracer.color(1,1,1)
    @test m.ambient ≈ 0.1
    @test m.diffuse ≈ 0.9
    @test m.specular ≈ 0.9
    @test m.shininess ≈ 200
end

@testset "lighning_tests" begin
    m = RayTracer.material()
    position = RayTracer.point(0,0,0)

    @testset "lighning_with_eye_between_lignt_and_surface" begin
        eyev = RayTracer.vector(0,0,-1)
        normalv = RayTracer.vector(0,0,-1)
        light = RayTracer.point_light(RayTracer.point(0,0,-10),RayTracer.color(1,1,1))
        result = RayTracer.lighting(m,light,position,eyev,normalv)
        @test result ≈ RayTracer.color(1.9,1.9,1.9)
    end

    @testset "lighning_with_eye_between_lignt_and_surface_offset_45_degrees" begin
        eyev = RayTracer.vector(0,√2/2,-√2/2)
        normalv = RayTracer.vector(0,0,-1)
        light = RayTracer.point_light(RayTracer.point(0,0,-10),RayTracer.color(1,1,1))
        result = RayTracer.lighting(m,light,position,eyev,normalv)
        @test result ≈ RayTracer.color(1,1,1)
    end

    @testset "lighning_with_eye_opposite_surface_light_offset_45_degrees" begin
        eyev = RayTracer.vector(0,0,-1)
        normalv = RayTracer.vector(0,0,-1)
        light = RayTracer.point_light(RayTracer.point(0,10,-10),RayTracer.color(1,1,1))
        result = RayTracer.lighting(m,light,position,eyev,normalv)
        @test result ≈ RayTracer.color(0.1+0.9*√2/2,0.1+0.9*√2/2,0.1+0.9*√2/2)
    end

    @testset "lighning_with_eye_path_reflection_vector" begin
        eyev = RayTracer.vector(0,-√2/2,-√2/2)
        normalv = RayTracer.vector(0,0,-1)
        light = RayTracer.point_light(RayTracer.point(0,10,-10),RayTracer.color(1,1,1))
        result = RayTracer.lighting(m,light,position,eyev,normalv)
        @test result ≈ RayTracer.color(0.1+0.9*√2/2+0.9,0.1+0.9*√2/2+0.9,0.1+0.9*√2/2+0.9)
    end

    @testset "lighning_with_light_behind_surface" begin
        eyev = RayTracer.vector(0,0,-1)
        normalv = RayTracer.vector(0,0,-1)
        light = RayTracer.point_light(RayTracer.point(0,0,10),RayTracer.color(1,1,1))
        result = RayTracer.lighting(m,light,position,eyev,normalv)
        @test result ≈ RayTracer.color(0.1,0.1,0.1)
    end

end
