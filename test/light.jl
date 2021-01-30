
@testset "point_light_attributes" begin
    intensity = RayTracer.color(1,1,1)
    position = RayTracer.point(0,0,0)
    light = RayTracer.point_light(position, intensity)
    @test light.position ≈ position
    @test light.intensity ≈ intensity
end