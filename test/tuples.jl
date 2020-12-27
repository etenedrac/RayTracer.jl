using RayTracer
using Test


@testset "tuple_creation" begin
    @testset "w_1_is_point" begin
        a = RayTracer.tuple(4.3,-4.2,3.1,1)
        @test a.x ≈ 4.3
        @test a.y ≈ -4.2
        @test a.z ≈ 3.1
        @test a.w == 1
        @test RayTracer.is_point(a) == true
        @test RayTracer.is_vector(a) == false
    end

    @testset "w_0_is_vector" begin
        a = RayTracer.tuple(4.3,-4.2,3.1,0)
        @test a.x ≈ 4.3
        @test a.y ≈ -4.2
        @test a.z ≈ 3.1
        @test a.w == 0
        @test RayTracer.is_point(a) == false
        @test RayTracer.is_vector(a) == true
    end

    @testset "point_creates_tuple" begin
        p = RayTracer.point(4,-4,3)
        @test p == RayTracer.tuple(4,-4,3,1)
    end

    @testset "vector_creates_tuple" begin
        v = RayTracer.vector(4,-4,3)
        @test v == RayTracer.tuple(4,-4,3,0)
    end
end

@testset "tuple_operations" begin
    @testset "adding_tuples" begin
        a1 = RayTracer.tuple(3,-2,5,1)
        a2 = RayTracer.tuple(-2,3,1,0)
        @test a1 + a2 == RayTracer.tuple(1,1,6,1)
    end

    @testset "subtracting_two_points" begin
        p1 = RayTracer.point(3,2,1)
        p2 = RayTracer.point(5,6,7)
        @test p1 - p2 == RayTracer.vector(-2,-4,-6)
    end

    @testset "subtracting_vector_from_point" begin
        p = RayTracer.point(3,2,1)
        v = RayTracer.vector(5,6,7)
        @test p - v == RayTracer.point(-2,-4,-6)
    end

    @testset "subtracting_two_vectors" begin
        v1 = RayTracer.vector(3,2,1)
        v2 = RayTracer.vector(5,6,7)
        @test v1 - v2 == RayTracer.vector(-2,-4,-6)
    end

    @testset "subtracting_vector_from_zero_vector" begin
        zero = RayTracer.vector(0,0,0)
        v = RayTracer.vector(1,-2,3)
        @test zero - v == RayTracer.vector(-1,2,-3)
    end

    @testset "negating_tuple" begin
        a = RayTracer.tuple(1,-2,3,-4)
        @test -a == RayTracer.tuple(-1,2,-3,4)
    end

    @testset "multiplying_tuple_by_scalar" begin
        a = RayTracer.tuple(1,-2,3,-4)
        @test a * 3.5 ≈ RayTracer.tuple(3.5,-7,10.5,-4)
        @test a * 0.5 ≈ RayTracer.tuple(0.5,-1,1.5,-4)
    end

    @testset "dividing_tuple_by_scalar" begin
        a = RayTracer.tuple(1,-2,3,-4)
        @test a / 2 ≈ RayTracer.tuple(0.5,-1,1.5,-4)
    end

    @testset "modulus_unit_vectors" begin
        v1 = RayTracer.vector(1,0,0)
        v2 = RayTracer.vector(0,1,0)
        v3 = RayTracer.vector(0,0,1)
        v4 = RayTracer.vector(1,2,3)
        v5 = RayTracer.vector(-1,-2,-3)
        @test RayTracer.modulus(v1) ≈ 1
        @test RayTracer.modulus(v2) ≈ 1
        @test RayTracer.modulus(v3) ≈ 1
        @test RayTracer.modulus(v4) ≈ √14
        @test RayTracer.modulus(v5) ≈ √14
    end

    @testset "normalization_vectors" begin
        v1 = RayTracer.vector(4,0,0)
        v2 = RayTracer.vector(1,2,3)
        @test RayTracer.normalize(v1) ≈ RayTracer.vector(1,0,0)
        @test RayTracer.normalize(v2) ≈ RayTracer.vector(1/√14,2/√14,3/√14)
    end

    @testset "modulus_normalized_vector" begin
        v = RayTracer.vector(1,2,3)
        norm = RayTracer.normalize(v)
        @test RayTracer.modulus(norm) ≈ 1
    end

    @testset "dot_product" begin
        a = RayTracer.vector(1,2,3)
        b = RayTracer.vector(2,3,4)
        @test RayTracer.dot(a,b) ≈ 20
    end

    @testset "cross_product" begin
        a = RayTracer.vector(1,2,3)
        b = RayTracer.vector(2,3,4)
        @test RayTracer.cross(a,b) ≈ RayTracer.vector(-1,2,-1)
        @test RayTracer.cross(b,a) ≈ RayTracer.vector(1,-2,1)
    end
end