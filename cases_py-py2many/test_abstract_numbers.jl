# Transpiled with flags: 
# - oop
#= Unit tests for numbers.py. =#
using ObjectOriented
using Test

@oodef mutable struct TestNumbers

end

function test_int(self::@like(TestNumbers))
    @test Int64 <: Integer
    @test (7 == real(Int(7)))
    @test (0 == imag(Int(7)))
    @test (7 == conj(Int(7)))
    @test (-7 == conj(Int(-7)))
    @test (7 == numerator(Int(7)))
    @test (1 == denominator(Int(7)))
end

function test_float(self::@like(TestNumbers))
    @test !(Float64 <: Rational)
    @test Float64 <: Real
    @test (7.3 == real(float(7.3)))
    @test (0 == imag(float(7.3)))
    @test (7.3 == conj(float(7.3)))
    @test (-7.3 == conj(float(-7.3)))
end

function test_complex(self::@like(TestNumbers))
    @test !(Complex <: Real)
    @test Complex <: Complex
    (c1, c2) = (complex(3, 2), complex(4, 1))
end


if abspath(PROGRAM_FILE) == @__FILE__
    test_numbers = TestNumbers()
    test_int(test_numbers)
    test_float(test_numbers)
    test_complex(test_numbers)
end
