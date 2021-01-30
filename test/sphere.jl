@testset "normal_sphere_x_axis" begin
    s = RayTracer.sphere()
    n = RayTracer.normal_at(s, RayTracer.point(1,0,0))
    @test n ≈ RayTracer.vector(1,0,0)
end

@testset "normal_sphere_y_axis" begin
    s = RayTracer.sphere()
    n = RayTracer.normal_at(s, RayTracer.point(0,1,0))
    @test n ≈ RayTracer.vector(0,1,0)
end

@testset "normal_sphere_z_axis" begin
    s = RayTracer.sphere()
    n = RayTracer.normal_at(s, RayTracer.point(0,0,1))
    @test n ≈ RayTracer.vector(0,0,1)
end

@testset "normal_sphere_random_point" begin
    s = RayTracer.sphere()
    n = RayTracer.normal_at(s, RayTracer.point(√3/3,√3/3,√3/3))
    @test n ≈ RayTracer.vector(√3/3,√3/3,√3/3)
end

@testset "normal_is_normalized" begin
    s = RayTracer.sphere()
    n = RayTracer.normal_at(s, RayTracer.point(√3/3,√3/3,√3/3))
    @test n ≈ RayTracer.normalize(n)
end

@testset "normal_translated_sphere" begin
    s = RayTracer.sphere()
    RayTracer.set_transform!(s, RayTracer.translation(0,1,0))
    n = RayTracer.normal_at(s,RayTracer.point(0,1+√2/2,-√2/2))
    @test n ≈ RayTracer.vector(0,√2/2,-√2/2)
end

@testset "normal_transformed_sphere" begin
    s = RayTracer.sphere()
    m = RayTracer.scaling(1,0.5,1)*RayTracer.rotation_z(π/5)
    RayTracer.set_transform!(s, m)
    n = RayTracer.normal_at(s,RayTracer.point(0,√2/2,-√2/2))
    @test ≈(n,RayTracer.vector(0,0.97014,-0.24254),1e-4)
end

@testset "default_material_sphere" begin
    s = RayTracer.sphere()
    m = s.material
    @test m ≈ RayTracer.material()
end

@testset "assigning_material_to_sphere" begin
    s = RayTracer.sphere()
    m = RayTracer.material()
    m.ambient = 1
    s.material = m
    @test s.material ≈ m
end