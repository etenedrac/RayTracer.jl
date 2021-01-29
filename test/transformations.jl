using RayTracer
using LinearAlgebra
using Test

@testset "creating_4_x_4_matrix" begin
    m = [1 2 3 4; 5.5 6.5 7.5 8.5; 9 10 11 12; 13.5 14.5 15.5 16.5]
    @test m[1,1] ≈ 1
    @test m[1,4] ≈ 4
    @test m[2,1] ≈ 5.5
    @test m[2,3] ≈ 7.5
    @test m[3,3] ≈ 11
    @test m[4,1] ≈ 13.5
    @test m[4,3] ≈ 15.5
end

@testset "equal_matrices" begin
    m = [1 2 3 4; 5.5 6.5 7.5 8.5; 9 10 11 12; 13.5 14.5 15.5 16.5]
    n = [1 2 3 4; 5.5 6.5 7.5 8.5; 9 10 11 12; 13.5 14.5 15.5 16.5]
    @test m ≈ n
end

@testset "different_matrices" begin
    m = [1 2 3 4; 5 6 7 8; 9 10 11 12; 13 14 15 16]
    n = [2 3 4 5; 6 7 8 9; 10 11 12 13; 14 15 16 1]
    @test m ≠ n
end

@testset "matrix_tuple_multiplication" begin
    a = [1 2 3 4; 2 4 4 2; 8 6 4 1; 0 0 0 1]
    b = RayTracer.tuple(1, 2, 3, 1)
    @test a*b ≈ RayTracer.tuple(18,24,33,1)
end

@testset "creating_submatix" begin
    a = [1 5 0; -3 2 7; 0 6 -3]
    b = RayTracer.submatrix(a,1,3)
    @test b ≈ [-3 2; 0 6]
end

@testset "computing minor" begin
    a = [3 5 0; 2 -1 -7; 6 -1 5]
    b = RayTracer.submatrix(a,2,1)
    @test det(b) ≈ 25
    @test RayTracer.minor(a,2,1) ≈ 25
end

@testset "computing_cofactor" begin
    a = [3 5 0; 2 -1 -7; 6 -1 5]
    @test RayTracer.minor(a,1,1) ≈ -12
    @test RayTracer.cofactor(a,1,1) ≈ -12
    @test RayTracer.minor(a,2,1) ≈ 25
    @test RayTracer.cofactor(a,2,1) ≈ -25
end

@testset "multiplying_by_translation_matrix" begin
    transform = RayTracer.translation(5,-3,2)
    p = RayTracer.point(-3,4,5)
    @test transform * p ≈ RayTracer.point(2,1,7)
end

@testset "multiplying_by_inverse_translation" begin
    transform = RayTracer.translation(5,-3,2)
    inv_transform = inv(transform)
    p = RayTracer.point(-3,4,5)
    @test inv_transform * p ≈ RayTracer.point(-8,7,3)
end

@testset "translation_does_not_affect_vectors" begin
    transform = RayTracer.translation(5,-3,2)
    v = RayTracer.vector(-3,4,5)
    @test transform*v ≈ v
end

@testset "scaling_applied_to_point" begin
    transform = RayTracer.scaling(2,3,4)
    p = RayTracer.point(-4,6,8)
    @test transform*p ≈ RayTracer.point(-8,18,32)
end

@testset "scaling_applied_to_vector" begin
    transform = RayTracer.scaling(2,3,4)
    v = RayTracer.vector(-4,6,8)
    @test transform*v ≈ RayTracer.vector(-8,18,32)
end

@testset "multiplying_inverse_scaling" begin
    transform = RayTracer.scaling(2,3,4)
    inv_transform = inv(transform)
    v = RayTracer.vector(-4,6,8)
    @test inv_transform*v ≈ RayTracer.vector(-2,2,2)
end

@testset "reflection_is_scaling_negative" begin
    transform = RayTracer.scaling(-1,1,1)
    p = RayTracer.point(2,3,4)
    @test transform*p ≈ RayTracer.point(-2,3,4)
end

@testset "rotation_around_x_axis" begin
    p = RayTracer.point(0,1,0)
    eith_turn = RayTracer.rotation_x(π/4)
    quarter_turn = RayTracer.rotation_x(π/2)
    @test eith_turn*p ≈ RayTracer.point(0,√2/2,√2/2)
    @test ≈(quarter_turn*p,RayTracer.point(0,0,1),1e-10)
end

@testset "inverse_rotation_x_axis" begin
    p = RayTracer.point(0,1,0)
    eith_turn = RayTracer.rotation_x(π/4)
    inv_transform = inv(eith_turn)
    @test inv_transform*p ≈ RayTracer.point(0,√2/2,-√2/2)
end

@testset "rotation_around_y_axis" begin
    p = RayTracer.point(0,0,1)
    eith_turn = RayTracer.rotation_y(π/4)
    quarter_turn = RayTracer.rotation_y(π/2)
    @test eith_turn*p ≈ RayTracer.point(√2/2,0,√2/2)
    @test ≈(quarter_turn*p,RayTracer.point(1,0,0),1e-10)
end

@testset "rotation_around_z_axis" begin
    p = RayTracer.point(0,1,0)
    eith_turn = RayTracer.rotation_z(π/4)
    quarter_turn = RayTracer.rotation_z(π/2)
    @test eith_turn*p ≈ RayTracer.point(-√2/2,√2/2,0)
    @test ≈(quarter_turn*p,RayTracer.point(-1,0,0),1e-10)
end

@testset "shearing_x_wrt_y" begin
    transform = RayTracer.shearing(1,0,0,0,0,0)
    p = RayTracer.point(2,3,4)
    @test transform*p ≈ RayTracer.point(5,3,4)
end

@testset "shearing_x_wrt_z" begin
    transform = RayTracer.shearing(0,1,0,0,0,0)
    p = RayTracer.point(2,3,4)
    @test transform*p ≈ RayTracer.point(6,3,4)
end

@testset "shearing_y_wrt_x" begin
    transform = RayTracer.shearing(0,0,1,0,0,0)
    p = RayTracer.point(2,3,4)
    @test transform*p ≈ RayTracer.point(2,5,4)
end

@testset "shearing_y_wrt_z" begin
    transform = RayTracer.shearing(0,0,0,1,0,0)
    p = RayTracer.point(2,3,4)
    @test transform*p ≈ RayTracer.point(2,7,4)
end

@testset "shearing_z_wrt_x" begin
    transform = RayTracer.shearing(0,0,0,0,1,0)
    p = RayTracer.point(2,3,4)
    @test transform*p ≈ RayTracer.point(2,3,6)
end

@testset "shearing_z_wrt_y" begin
    transform = RayTracer.shearing(0,0,0,0,0,1)
    p = RayTracer.point(2,3,4)
    @test transform*p ≈ RayTracer.point(2,3,7)
end

@testset "individual_transformations_sequential" begin
    p = RayTracer.point(1,0,1)
    A = RayTracer.rotation_x(π/2)
    B = RayTracer.scaling(5,5,5)
    C = RayTracer.translation(10,5,7)
    p2 = A*p
    @test ≈(p2,RayTracer.point(1,-1,0),1e-10)
    p3 = B*p2
    @test ≈(p3,RayTracer.point(5,-5,0),1e-10)
    p4 = C*p3
    @test ≈(p4,RayTracer.point(15,0,7),1e-10)
end

@testset "chained_transformations" begin
    p = RayTracer.point(1,0,1)
    A = RayTracer.rotation_x(π/2)
    B = RayTracer.scaling(5,5,5)
    C = RayTracer.translation(10,5,7)
    D = C*B*A
    @test ≈(D*p,RayTracer.point(15,0,7),1e-10)
end