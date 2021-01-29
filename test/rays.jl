using RayTracer

@testset "creating_a_ray" begin
    origin = RayTracer.point(1,2,3)
    direction = RayTracer.vector(4,5,6)
    r = RayTracer.ray(origin, direction)
    @test r.origin ≈ origin
    @test r.direction ≈ direction
end

@testset "computing_point_from_distance" begin
    origin = RayTracer.point(2,3,4)
    direction = RayTracer.vector(1,0,0)
    r = RayTracer.ray(origin, direction)
    @test RayTracer.position(r,0) ≈ RayTracer.point(2,3,4)
    @test RayTracer.position(r,1) ≈ RayTracer.point(3,3,4)
    @test RayTracer.position(r,-1) ≈ RayTracer.point(1,3,4)
    @test RayTracer.position(r,2.5) ≈ RayTracer.point(4.5,3,4)
end

@testset "ray_intersecting_two_points_shpere" begin
    origin = RayTracer.point(0,0,-5)
    direction = RayTracer.vector(0,0,1)
    r = RayTracer.ray(origin, direction)
    s = RayTracer.sphere()
    xs = RayTracer.intersect(s,r)
    @test length(xs) == 2
    @test xs[1].t ≈ 4
    @test xs[2].t ≈ 6
end

@testset "ray_intersecting_tangent_point" begin
    origin = RayTracer.point(0,1,-5)
    direction = RayTracer.vector(0,0,1)
    r = RayTracer.ray(origin, direction)
    s = RayTracer.sphere()
    xs = RayTracer.intersect(s,r)
    @test length(xs) == 2
    @test xs[1].t ≈ 5
    @test xs[2].t ≈ 5
end

@testset "ray_missing_intersection_sphere" begin
    origin = RayTracer.point(0,2,-5)
    direction = RayTracer.vector(0,0,1)
    r = RayTracer.ray(origin, direction)
    s = RayTracer.sphere()
    xs = RayTracer.intersect(s,r)
    @test length(xs) == 0
end

@testset "ray_intersecting_center_shpere" begin
    origin = RayTracer.point(0,0,0)
    direction = RayTracer.vector(0,0,1)
    r = RayTracer.ray(origin, direction)
    s = RayTracer.sphere()
    xs = RayTracer.intersect(s,r)
    @test length(xs) == 2
    @test xs[1].t ≈ -1
    @test xs[2].t ≈ 1
end

@testset "ray_intersecting_front_sphere" begin
    origin = RayTracer.point(0,0,5)
    direction = RayTracer.vector(0,0,1)
    r = RayTracer.ray(origin, direction)
    s = RayTracer.sphere()
    xs = RayTracer.intersect(s,r)
    @test length(xs) == 2
    @test xs[1].t ≈ -6
    @test xs[2].t ≈ -4
end

@testset "intersection_creation" begin
    s = RayTracer.sphere()
    i = RayTracer.intersection(3,s)
    @test i.t ≈ 3
    @test i.object === s
end

@testset "aggregating_intersections" begin
    s = RayTracer.sphere()
    i1 = RayTracer.intersection(1,s)
    i2 = RayTracer.intersection(2,s)
    xs = [i1,i2]
    @test length(xs) == 2
    @test xs[1].t ≈ 1
    @test xs[2].t ≈ 2
end

@testset "intersect_has_obhect_on_intersection" begin
    origin = RayTracer.point(0,0,-5)
    direction = RayTracer.vector(0,0,1)
    r = RayTracer.ray(origin, direction)
    s = RayTracer.sphere()
    xs = RayTracer.intersect(s,r)
    @test length(xs) == 2
    @test xs[1].object === s
    @test xs[2].object === s
end

@testset "hit_when_all_t_are_positive" begin
    s = RayTracer.sphere()
    i1 = RayTracer.intersection(1,s)
    i2 = RayTracer.intersection(2,s)
    xs = [i2,i1]
    i = RayTracer.hit(xs)
    @test i === i1
end

@testset "hit_when_one_t_is_positive" begin
    s = RayTracer.sphere()
    i1 = RayTracer.intersection(-1,s)
    i2 = RayTracer.intersection(1,s)
    xs = [i2,i1]
    i = RayTracer.hit(xs)
    @test i === i2
end

@testset "hit_when_all_t_are_negative" begin
    s = RayTracer.sphere()
    i1 = RayTracer.intersection(-2,s)
    i2 = RayTracer.intersection(-1,s)
    xs = [i2,i1]
    i = RayTracer.hit(xs)
    @test i === nothing
end

@testset "hit_lowest_positive_t" begin
    s = RayTracer.sphere()
    i1 = RayTracer.intersection(5,s)
    i2 = RayTracer.intersection(7,s)
    i3 = RayTracer.intersection(-3,s)
    i4 = RayTracer.intersection(2,s)
    xs = [i1,i2,i3,i4]
    i = RayTracer.hit(xs)
    @test i === i4
end

@testset "translating_ray" begin
    origin = RayTracer.point(1,2,3)
    direction = RayTracer.vector(0,1,0)
    r = RayTracer.ray(origin, direction)
    m = RayTracer.translation(3,4,5)
    r2 = RayTracer.transform(r,m)
    @test r2.origin ≈ RayTracer.point(4,6,8)
    @test r2.direction ≈ RayTracer.vector(0,1,0)
end

@testset "scaling_ray" begin
    origin = RayTracer.point(1,2,3)
    direction = RayTracer.vector(0,1,0)
    r = RayTracer.ray(origin, direction)
    m = RayTracer.scaling(2,3,4)
    r2 = RayTracer.transform(r,m)
    @test r2.origin ≈ RayTracer.point(2,6,12)
    @test r2.direction ≈ RayTracer.vector(0,3,0)
end

@testset "sphere_default_transformation" begin
    s = RayTracer.sphere()
    @test s.transform ≈ Matrix(I,4,4)
end

@testset "changing_sphere_transformation" begin
    s = RayTracer.sphere()
    t = RayTracer.translation(2,3,4)
    RayTracer.set_transform!(s,t)
    @test s.transform ≈ t
end

@testset "intersecting_scaled_sphere_with_ray" begin
    origin = RayTracer.point(0,0,-5)
    direction = RayTracer.vector(0,0,1)
    r = RayTracer.ray(origin, direction)
    s = RayTracer.sphere()
    RayTracer.set_transform!(s,RayTracer.scaling(2,2,2))
    xs = RayTracer.intersect(s,r)
    @test length(xs) == 2
    @test xs[1].t ≈ 3
    @test xs[2].t ≈ 7
end

@testset "intersecting_translated_sphere_with_ray" begin
    origin = RayTracer.point(0,0,-5)
    direction = RayTracer.vector(0,0,1)
    r = RayTracer.ray(origin, direction)
    s = RayTracer.sphere()
    RayTracer.set_transform!(s,RayTracer.translation(5,0,0))
    xs = RayTracer.intersect(s,r)
    @test length(xs) == 0
end