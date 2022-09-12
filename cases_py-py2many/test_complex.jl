# Transpiled with flags: 
# - oop
using ObjectOriented
using Random
using Test



using test.test_grammar: VALID_UNDERSCORE_LITERALS, INVALID_UNDERSCORE_LITERALS



INF = parse(Float64, "inf")
NAN = parse(Float64, "nan")
ZERO_DIVISION = ((1 + 1im, 0 + 0im), (1 + 1im, 0.0), (1 + 1im, 0), (1.0, 0 + 0im), (1, 0 + 0im))
@oodef mutable struct OS
                    
                    value
                    
function new(value)
@mk begin
value = value
end
end

                end
                function __complex__(self::@like(OS))
return self.value
end


@oodef mutable struct NS <: object
                    
                    value
                    
function new(value)
@mk begin
value = value
end
end

                end
                function __complex__(self::@like(NS))
return self.value
end


@oodef mutable struct complex2 <: Complex
                    
                    
                    
                end
                

@oodef mutable struct EvilExc <: Exception
                    
                    
                    
                end
                

@oodef mutable struct evilcomplex
                    
                    
                    
                end
                function __complex__(self::@like(evilcomplex))
throw(EvilExc)
end


@oodef mutable struct float2
                    
                    value
                    
function new(value)
@mk begin
value = value
end
end

                end
                function __float__(self::@like(float2))
return self.value
end


@oodef mutable struct MyIndex
                    
                    value
                    
function new(value)
@mk begin
value = value
end
end

                end
                function __index__(self::@like(MyIndex))
return self.value
end


@oodef mutable struct MyInt
                    
                    
                    
                end
                function __int__(self::@like(MyInt))::Int64
return 42
end


@oodef mutable struct complex0 <: Complex
                    #= Test usage of __complex__() when inheriting from 'complex' =#

                    
                    
                end
                function __complex__(self::@like(complex0))::Complex
return 42im
end


@oodef mutable struct complex1 <: Complex
                    #= Test usage of __complex__() with a __new__() method =#

                    
                    
                end
                function __new__(self::@like(complex1), value = 0im)
return __new__(Complex, 2*value)
end

function __complex__(self::@like(complex1))
return self
end


@oodef mutable struct complex2 <: Complex
                    #= Make sure that __complex__() calls fail if anything other than a
            complex is returned =#

                    
                    
                end
                function __complex__(self::@like(complex2))
return nothing
end


@oodef mutable struct complex2 <: Complex
                    
                    
                    
                end
                

@oodef mutable struct ComplexTest <: unittest.TestCase
                    
                    
                    
                end
                function assertAlmostEqual(self::@like(ComplexTest), a, b)
if isa(a, Complex)
if isa(b, Complex)
unittest.assertAlmostEqual(a.real, b.real)
unittest.assertAlmostEqual(a.imag, b.imag)
else
unittest.assertAlmostEqual(a.real, b)
unittest.assertAlmostEqual(a.imag, 0.0)
end
elseif isa(b, Complex)
unittest.assertAlmostEqual(a, b.real)
unittest.assertAlmostEqual(0.0, b.imag)
else
unittest.assertAlmostEqual(a, b)
end
end

function assertCloseAbs(self::@like(ComplexTest), x, y, eps = 1e-09)::Bool
#= Return true iff floats x and y "are close". =#
if abs(x) > abs(y)
(x, y) = (y, x)
end
if y == 0
return abs(x) < eps
end
if x == 0
return abs(y) < eps
end
@test abs((x - y) / y) < eps
end

function assertFloatsAreIdentical(self::@like(ComplexTest), x, y)
#= assert that floats x and y are identical, in the sense that:
        (1) both x and y are nans, or
        (2) both x and y are infinities, with the same sign, or
        (3) both x and y are zeros, with the same sign, or
        (4) x and y are both finite and nonzero, and x == y

         =#
msg = "floats {!r} and {!r} are not identical"
if isnan(x)||isnan(y)
if isnan(x)&&isnan(y)
return
end
elseif x == y
if x != 0.0
return
elseif copysign(1.0, x) == copysign(1.0, y)
return
else
msg += ": zeros have different signs"
end
end
fail(self, msg)
end

function assertClose(self::@like(ComplexTest), x, y, eps = 1e-09)
#= Return true iff complexes x and y "are close". =#
assertCloseAbs(self, x.real, y.real, eps)
assertCloseAbs(self, x.imag, y.imag, eps)
end

function check_div(self::@like(ComplexTest), x, y)
#= Compute complex z=x*y, and check that z/x==y and z/y==x. =#
z = x*y
if x != 0
q = z / x
assertClose(self, q, y)
q = __truediv__(z, x)
assertClose(self, q, y)
end
if y != 0
q = z / y
assertClose(self, q, x)
q = __truediv__(z, y)
assertClose(self, q, x)
end
end

function test_truediv(self::@like(ComplexTest))
simple_real = [float(i) for i in -5:5]
simple_complex = [complex(x, y) for x in simple_real for y in simple_real]
for x in simple_complex
for y in simple_complex
check_div(self, x, y)
end
end
check_div(self, complex(1e+200, 1e+200), 1 + 0im)
check_div(self, complex(1e-200, 1e-200), 1 + 0im)
for i in 0:99
check_div(self, complex(rand(), rand()), complex(rand(), rand()))
end
assertAlmostEqual(self, __truediv__(Complex, 2 + 0im, 1 + 1im), 1 - 1im)
for (denom_real, denom_imag) in [(0, NAN), (NAN, 0), (NAN, NAN)]
z = complex(0, 0) / complex(denom_real, denom_imag)
@test isnan(z.real)
@test isnan(z.imag)
end
end

function test_truediv_zero_division(self::@like(ComplexTest))
for (a, b) in ZERO_DIVISION
@test_throws ZeroDivisionError do 
a / b
end
end
end

function test_floordiv(self::@like(ComplexTest))
@test_throws TypeError do 
(1 + 1im) ÷ (1 + 0im)
end
@test_throws TypeError do 
(1 + 1im) ÷ 1.0
end
@test_throws TypeError do 
(1 + 1im) ÷ 1
end
@test_throws TypeError do 
1.0 ÷ (1 + 0im)
end
@test_throws TypeError do 
1 ÷ (1 + 0im)
end
end

function test_floordiv_zero_division(self::@like(ComplexTest))
for (a, b) in ZERO_DIVISION
@test_throws TypeError do 
a ÷ b
end
end
end

function test_richcompare(self::@like(ComplexTest))
@test self === __eq__(Complex, 1 + 1im, 1 << 10000)
@test self === __lt__(Complex, 1 + 1im, nothing)
@test self === __eq__(Complex, 1 + 1im, 1 + 1im)
@test self === __eq__(Complex, 1 + 1im, 2 + 2im)
@test self === __ne__(Complex, 1 + 1im, 1 + 1im)
@test self === __ne__(Complex, 1 + 1im, 2 + 2im)
for i in 1:99
f = i / 100.0
@test self === __eq__(Complex, f + 0im, f)
@test self === __ne__(Complex, f + 0im, f)
@test self === __eq__(Complex, complex(f, f), f)
@test self === __ne__(Complex, complex(f, f), f)
end
@test self === __lt__(Complex, 1 + 1im, 2 + 2im)
@test self === __le__(Complex, 1 + 1im, 2 + 2im)
@test self === __gt__(Complex, 1 + 1im, 2 + 2im)
@test self === __ge__(Complex, 1 + 1im, 2 + 2im)
@test_throws
@test_throws
@test_throws
@test_throws
@test self === operator.eq(1 + 1im, 1 + 1im)
@test self === operator.eq(1 + 1im, 2 + 2im)
@test self === operator.ne(1 + 1im, 1 + 1im)
@test self === operator.ne(1 + 1im, 2 + 2im)
end

function test_richcompare_boundaries(self::@like(ComplexTest))
function check(n::@like(ComplexTest), deltas, is_equal, imag = 0.0)
for delta in deltas
i = n + delta
z = complex(i, imag)
@test self === __eq__(Complex, z, i)
@test self === __ne__(Complex, z, i)
end
end

for i in 1:9
pow = 52 + i
mult = 2^i
check(2^pow, 1:100, (delta) -> (delta % mult) == 0)
check(2^pow, 1:100, (delta) -> false, float(i))
end
check(2^53, -100:-1, (delta) -> true)
end

function test_mod(self::@like(ComplexTest))
@test_throws TypeError do 
(1 + 1im) % (1 + 0im)
end
@test_throws TypeError do 
(1 + 1im) % 1.0
end
@test_throws TypeError do 
(1 + 1im) % 1
end
@test_throws TypeError do 
1.0 % (1 + 0im)
end
@test_throws TypeError do 
1 % (1 + 0im)
end
end

function test_mod_zero_division(self::@like(ComplexTest))
for (a, b) in ZERO_DIVISION
@test_throws TypeError do 
a % b
end
end
end

function test_divmod(self::@like(ComplexTest))
@test_throws
@test_throws
@test_throws
@test_throws
@test_throws
end

function test_divmod_zero_division(self::@like(ComplexTest))
for (a, b) in ZERO_DIVISION
@test_throws
end
end

function test_pow(self::@like(ComplexTest))
assertAlmostEqual(self, pow(1 + 1im, 0 + 0im), 1.0)
assertAlmostEqual(self, pow(0 + 0im, 2 + 0im), 0.0)
@test_throws
assertAlmostEqual(self, pow(1im, -1), 1 / 1im)
assertAlmostEqual(self, pow(1im, 200), 1)
@test_throws
@test_throws
a = 3.33 + 4.43im
@test (a^0im == 1)
@test (a^0.0 + 0im == 1)
@test (3im^0im == 1)
@test (3im^0 == 1)
try
0im^a
catch exn
if exn isa ZeroDivisionError
#= pass =#
end
end
try
0im^(3 - 2im)
catch exn
if exn isa ZeroDivisionError
#= pass =#
end
end
@test (a^105 == a^105)
@test (a^-105 == a^-105)
@test (a^-30 == a^-30)
@test (0im^0 == 1)
b = 5.1 + 2.3im
@test_throws
values_ = (typemax(Int), typemax(Int) + 1, typemax(Int) - 1, -(typemax(Int)), -(typemax(Int)) + 1, -(typemax(Int)) + 1)
for real_ in values_
for imag_ in values_
subTest(self, real = real_, imag = imag_) do 
c = complex(real_, imag_)
try
c^real_
catch exn
if exn isa OverflowError
#= pass =#
end
end
try
c^c
catch exn
if exn isa OverflowError
#= pass =#
end
end
end
end
end
end

function test_pow_with_small_integer_exponents(self::@like(ComplexTest))
values_ = [complex(5.0, 12.0), complex(5e+100, 1.2e+101), complex(-4.0, INF), complex(INF, 0.0)]
exponents = [-19, -5, -3, -2, -1, 0, 1, 2, 3, 5, 19]
for value in values_
for exponent_ in exponents
subTest(self, value = value, exponent = exponent_) do 
try
int_pow = value^exponent_
catch exn
if exn isa OverflowError
int_pow = "overflow"
end
end
try
float_pow = value^float(exponent_)
catch exn
if exn isa OverflowError
float_pow = "overflow"
end
end
try
complex_pow = value^complex(exponent_)
catch exn
if exn isa OverflowError
complex_pow = "overflow"
end
end
@test (string(float_pow) == string(int_pow))
@test (string(complex_pow) == string(int_pow))
end
end
end
end

function test_boolcontext(self::@like(ComplexTest))
for i in 0:99
@test complex(rand() + 1e-06, rand() + 1e-06)
end
@test !complex(0.0, 0.0)
end

function test_conjugate(self::@like(ComplexTest))
assertClose(self, conjugate(complex(5.3, 9.8)), 5.3 - 9.8im)
end

function test_constructor(self::@like(ComplexTest))
@test (complex(OS(1 + 10im)) == 1 + 10im)
@test (complex(NS(1 + 10im)) == 1 + 10im)
@test_throws
@test_throws
@test_throws
@test_throws
@test_throws
assertAlmostEqual(self, complex("1+10j"), 1 + 10im)
assertAlmostEqual(self, complex(10), 10 + 0im)
assertAlmostEqual(self, complex(10.0), 10 + 0im)
assertAlmostEqual(self, complex(10), 10 + 0im)
assertAlmostEqual(self, complex(10 + 0im), 10 + 0im)
assertAlmostEqual(self, complex(1, 10), 1 + 10im)
assertAlmostEqual(self, complex(1, 10), 1 + 10im)
assertAlmostEqual(self, complex(1, 10.0), 1 + 10im)
assertAlmostEqual(self, complex(1, 10), 1 + 10im)
assertAlmostEqual(self, complex(1, 10), 1 + 10im)
assertAlmostEqual(self, complex(1, 10.0), 1 + 10im)
assertAlmostEqual(self, complex(1.0, 10), 1 + 10im)
assertAlmostEqual(self, complex(1.0, 10), 1 + 10im)
assertAlmostEqual(self, complex(1.0, 10.0), 1 + 10im)
assertAlmostEqual(self, complex(3.14 + 0im), 3.14 + 0im)
assertAlmostEqual(self, complex(3.14), 3.14 + 0im)
assertAlmostEqual(self, complex(314), 314.0 + 0im)
assertAlmostEqual(self, complex(314), 314.0 + 0im)
assertAlmostEqual(self, complex(3.14 + 0im, 0im), 3.14 + 0im)
assertAlmostEqual(self, complex(3.14, 0.0), 3.14 + 0im)
assertAlmostEqual(self, complex(314, 0), 314.0 + 0im)
assertAlmostEqual(self, complex(314, 0), 314.0 + 0im)
assertAlmostEqual(self, complex(0im, 3.14im), -3.14 + 0im)
assertAlmostEqual(self, complex(0.0, 3.14im), -3.14 + 0im)
assertAlmostEqual(self, complex(0im, 3.14), 3.14im)
assertAlmostEqual(self, complex(0.0, 3.14), 3.14im)
assertAlmostEqual(self, complex("1"), 1 + 0im)
assertAlmostEqual(self, complex("1j"), 1im)
assertAlmostEqual(self, complex(), 0)
assertAlmostEqual(self, complex("-1"), -1)
assertAlmostEqual(self, complex("+1"), +1)
assertAlmostEqual(self, complex("(1+2j)"), 1 + 2im)
assertAlmostEqual(self, complex("(1.3+2.2j)"), 1.3 + 2.2im)
assertAlmostEqual(self, complex("3.14+1J"), 3.14 + 1im)
assertAlmostEqual(self, complex(" ( +3.14-6J )"), 3.14 - 6im)
assertAlmostEqual(self, complex(" ( +3.14-J )"), 3.14 - 1im)
assertAlmostEqual(self, complex(" ( +3.14+j )"), 3.14 + 1im)
assertAlmostEqual(self, complex("J"), 1im)
assertAlmostEqual(self, complex("( j )"), 1im)
assertAlmostEqual(self, complex("+J"), 1im)
assertAlmostEqual(self, complex("( -j)"), -1im)
assertAlmostEqual(self, complex("1e-500"), 0.0 + 0im)
assertAlmostEqual(self, complex("-1e-500j"), 0.0 - 0im)
assertAlmostEqual(self, complex("-1e-500+1e-500j"), -0.0 + 0im)
assertAlmostEqual(self, complex(complex2(1 + 1im)), 1 + 1im)
assertAlmostEqual(self, complex(real = 17, imag = 23), 17 + 23im)
assertAlmostEqual(self, complex(real = 17 + 23im), 17 + 23im)
assertAlmostEqual(self, complex(real = 17 + 23im, imag = 23), 17 + 46im)
assertAlmostEqual(self, complex(real = 1 + 2im, imag = 3 + 4im), -3 + 5im)
function split_zeros(x::@like(ComplexTest))
#= Function that produces different results for 0. and -0. =#
return atan2(x, -1.0)
end

@test (split_zeros(complex(1.0, 0.0).imag) == split_zeros(0.0))
@test (split_zeros(complex(1.0, -0.0).imag) == split_zeros(-0.0))
@test (split_zeros(complex(0.0, 1.0).real) == split_zeros(0.0))
@test (split_zeros(complex(-0.0, 1.0).real) == split_zeros(-0.0))
c = 3.14 + 1im
@test complex(c) === c
# Delete Unsupported
# del(c)
@test_throws
@test_throws
@test_throws
@test_throws
@test_throws
@test_throws
@test_throws
@test_throws
@test_throws TypeError Complex(Complex, nothing)
            @test match(@r_str("not \'NoneType\'"), repr(Complex))
@test_throws
@test_throws
@test_throws
@test_throws
@test_throws
@test_throws
@test_throws
@test_throws
@test_throws
@test_throws
@test_throws
@test_throws
@test_throws
@test_throws
@test_throws
@test_throws
@test_throws
@test_throws TypeError Complex(Complex, Dict{int, int}(1 => 2), 1)
            @test match(@r_str("first argument must be a string or a number, not \'dict\'"), repr(Complex))
@test_throws TypeError Complex(Complex, 1, Dict{int, int}(1 => 2))
            @test match(@r_str("second argument must be a number, not \'dict\'"), repr(Complex))
@test_throws
@test_throws
@test_throws
@test (type_(complex(repeat("1",500))) == Complex)
@test (complex(" ( 1+1j ) ") == 1 + 1im)
@test_throws
@test_throws
assertAlmostEqual(self, complex(float2(42.0)), 42)
assertAlmostEqual(self, complex(real = float2(17.0), imag = float2(23.0)), 17 + 23im)
@test_throws
assertAlmostEqual(self, complex(MyIndex(42)), 42.0 + 0im)
assertAlmostEqual(self, complex(123, MyIndex(42)), 123.0 + 42im)
@test_throws
@test_throws
@test_throws
@test_throws
@test (complex(complex0(1im)) == 42im)
assertWarns(self, DeprecationWarning) do 
@test (complex(complex1(1im)) == 2im)
end
@test_throws
end

function test_constructor_special_numbers(self::@like(ComplexTest))
for x in (0.0, -0.0, INF, -INF, NAN)
for y in (0.0, -0.0, INF, -INF, NAN)
subTest(self, x = x, y = y) do 
z = complex(x, y)
assertFloatsAreIdentical(self, z.real, x)
assertFloatsAreIdentical(self, z.imag, y)
z = complex2(x, y)
@test self === type_(z)
assertFloatsAreIdentical(self, z.real, x)
assertFloatsAreIdentical(self, z.imag, y)
z = complex(complex2(x, y))
@test self === type_(z)
assertFloatsAreIdentical(self, z.real, x)
assertFloatsAreIdentical(self, z.imag, y)
z = complex2(complex(x, y))
@test self === type_(z)
assertFloatsAreIdentical(self, z.real, x)
assertFloatsAreIdentical(self, z.imag, y)
end
end
end
end

function test_underscores(self::@like(ComplexTest))
for lit in VALID_UNDERSCORE_LITERALS
if !any((ch ∈ lit for ch in "xXoObB"))
@test (complex(lit) == py"lit")
@test (complex(lit) == complex(replace(lit, "_", "")))
end
end
for lit in INVALID_UNDERSCORE_LITERALS
if lit ∈ ("0_7", "09_99")
continue;
end
if !any((ch ∈ lit for ch in "xXoObB"))
@test_throws
end
end
end

function test_hash(self::@like(ComplexTest))
for x in -30:29
@test (hash(x) == hash(complex(x, 0)))
x /= 3.0
@test (hash(x) == hash(complex(x, 0.0)))
end
end

function test_abs(self::@like(ComplexTest))
nums = [complex(x / 3.0, y / 7.0) for x in -9:8 for y in -9:8]
for num in nums
assertAlmostEqual(self, (num.real^2 + num.imag^2)^0.5, abs(num))
end
end

function test_repr_str(self::@like(ComplexTest))
function test(v::@like(ComplexTest), expected, test_fn = self.assertEqual)
test_fn(repr(v), expected)
test_fn(string(v), expected)
end

test(1 + 6im, "(1+6j)")
test(1 - 6im, "(1-6j)")
test(-(1 + 0im), "(-1+-0j)", test_fn = self.assertNotEqual)
test(complex(1.0, INF), "(1+infj)")
test(complex(1.0, -INF), "(1-infj)")
test(complex(INF, 1), "(inf+1j)")
test(complex(-INF, INF), "(-inf+infj)")
test(complex(NAN, 1), "(nan+1j)")
test(complex(1, NAN), "(1+nanj)")
test(complex(NAN, NAN), "(nan+nanj)")
test(complex(0, INF), "infj")
test(complex(0, -INF), "-infj")
test(complex(0, NAN), "nanj")
@test (1 - 6im == complex(repr(1 - 6im)))
@test (1 + 6im == complex(repr(1 + 6im)))
@test (-6im == complex(repr(-6im)))
@test (6im == complex(repr(6im)))
end

function test_negative_zero_repr_str(self::@like(ComplexTest))
function test(v::@like(ComplexTest), expected, test_fn = self.assertEqual)
test_fn(repr(v), expected)
test_fn(string(v), expected)
end

test(complex(0.0, 1.0), "1j")
test(complex(-0.0, 1.0), "(-0+1j)")
test(complex(0.0, -1.0), "-1j")
test(complex(-0.0, -1.0), "(-0-1j)")
test(complex(0.0, 0.0), "0j")
test(complex(0.0, -0.0), "-0j")
test(complex(-0.0, 0.0), "(-0+0j)")
test(complex(-0.0, -0.0), "(-0-0j)")
end

function test_neg(self::@like(ComplexTest))
@test (-(1 + 6im) == -1 - 6im)
end

function test_getnewargs(self::@like(ComplexTest))
@test (__getnewargs__(1 + 2im) == (1.0, 2.0))
@test (__getnewargs__(1 - 2im) == (1.0, -2.0))
@test (__getnewargs__(2im) == (0.0, 2.0))
@test (__getnewargs__(-0im) == (0.0, -0.0))
@test (__getnewargs__(complex(0, INF)) == (0.0, INF))
@test (__getnewargs__(complex(INF, 0)) == (INF, 0.0))
end

function test_plus_minus_0j(self::@like(ComplexTest))
(z1, z2) = (0im, -0im)
@test (atan2(z1.imag, -1.0) == atan2(0.0, -1.0))
@test (atan2(z2.imag, -1.0) == atan2(-0.0, -1.0))
end

function test_negated_imaginary_literal(self::@like(ComplexTest))
z0 = -0im
z1 = -7im
z2 = -infim
assertFloatsAreIdentical(self, z0.real, -0.0)
assertFloatsAreIdentical(self, z0.imag, -0.0)
assertFloatsAreIdentical(self, z1.real, -0.0)
assertFloatsAreIdentical(self, z1.imag, -7.0)
assertFloatsAreIdentical(self, z2.real, -0.0)
assertFloatsAreIdentical(self, z2.imag, -INF)
end

function test_overflow(self::@like(ComplexTest))
@test (complex("1e500") == complex(INF, 0.0))
@test (complex("-1e500j") == complex(0.0, -INF))
@test (complex("-1e500+1.8e308j") == complex(-INF, INF))
end

function test_repr_roundtrip(self::@like(ComplexTest))
vals = [0.0, 0.0, 1e-315, 1e-200, 0.0123, 3.1415, 1e+50, INF, NAN]
append!(vals, [-v for v in vals])
for x in vals
for y in vals
z = complex(x, y)
roundtrip = complex(repr(z))
assertFloatsAreIdentical(self, z.real, roundtrip.real)
assertFloatsAreIdentical(self, z.imag, roundtrip.imag)
end
end
(inf, nan) = (parse(Float64, "inf"), parse(Float64, "nan"))
(infj, nanj) = (complex(0.0, inf), complex(0.0, nan))
for x in vals
for y in vals
z = complex(x, y)
roundtrip = py"repr(z)"
assertFloatsAreIdentical(self, 0.0 + z.real, 0.0 + roundtrip.real)
assertFloatsAreIdentical(self, 0.0 + z.imag, 0.0 + roundtrip.imag)
end
end
end

function test_format(self::@like(ComplexTest))
@test (1 + 3im == string(1 + 3im))
@test (1.5 + 3.5im == string(1.5 + 3.5im))
@test (3im == string(3im))
@test (3.2im == string(3.2im))
@test (3 + 0im == string(3 + 0im))
@test (3.2 + 0im == string(3.2 + 0im))
@test (3.2 + 0im == string(3.2 + 0im))
@test (3.2 + 0im == string(3.2 + 0im))
z = (4 / 7.0) - (100im / 7.0)
@test (z == string(z))
@test (z == string(z))
@test (z == string(z))
@test (z == string(z))
z = complex(0.0, 3.0)
@test (z == string(z))
@test (z == string(z))
@test (z == string(z))
@test (z == string(z))
z = complex(-0.0, 2.0)
@test (z == string(z))
@test (z == string(z))
@test (z == string(z))
@test (z == string(z))
@test (1 + 3im == "1+3j")
@test (3im == "0+3j")
@test (1.5 + 3.5im == "1.5+3.5j")
@test (1.5 + 3.5im == "+1.5+3.5j")
@test (1.5 - 3.5im == "+1.5-3.5j")
@test (1.5 - 3.5im == "1.5-3.5j")
@test (1.5 + 3.5im == " 1.5+3.5j")
@test (1.5 - 3.5im == " 1.5-3.5j")
@test (-1.5 + 3.5im == "-1.5+3.5j")
@test (-1.5 - 3.5im == "-1.5-3.5j")
@test (-1.5 - 3.5e-20im == "-1.5-3.5e-20j")
@test (-1.5 - 3.5im == "-1.500000-3.500000j")
@test (-1.5 - 3.5im == "-1.500000-3.500000j")
@test (-1.5 - 3.5im == "-1.500000e+00-3.500000e+00j")
@test (-1.5 - 3.5im == "-1.50e+00-3.50e+00j")
@test (-1.5 - 3.5im == "-1.50E+00-3.50E+00j")
@test (-15000000000.0 - 350000im == "-1.5E+10-3.5E+05j")
@test (1.5 + 3im == "1.5+3j              ")
@test (1.5 + 3im == "1.5+3j**************")
@test (1.5 + 3im == "              1.5+3j")
@test (1.5 + 3im == "       1.5+3j       ")
@test (1.5 + 3im == "(1.5+3j)            ")
@test (1.5 + 3im == "            (1.5+3j)")
@test (1.5 + 3im == "      (1.5+3j)      ")
@test (1.123 - 3.123im == "     (1.1-3.1j)     ")
@test (1.5 + 3im == "          1.50+3.00j")
@test (1.5 + 3im == "          1.50+3.00j")
@test (1.5 + 3im == "1.50+3.00j          ")
@test (1.5e+20 + 3im == "150000000000000000000.00+3.00j")
@test (1.5e+20 + 3im == "          150000000000000000000.00+3.00j")
@test (1.5e+20 + 3im == "  150,000,000,000,000,000,000.00+3.00j  ")
@test (1.5e+21 + 3im == " 1,500,000,000,000,000,000,000.00+3.00j ")
@test (1.5e+21 + 3000im == "1,500,000,000,000,000,000,000.00+3,000.00j")
@test (1 + 1im == "1e+00+1e+00j")
@test (1 + 1im == "1.e+00+1.e+00j")
@test (1 + 1im == "1+1j")
@test (1 + 1im == "1.+1.j")
@test (1.1 + 1.1im == "1.1+1.1j")
@test (1.1 + 1.1im == "1.10000+1.10000j")
@test (1 + 1im == "1.0e+00+1.0e+00j")
@test (1 + 1im == "1.0e+00+1.0e+00j")
@test (1 + 1im == "1.0+1.0j")
@test (1 + 1im == "1.0+1.0j")
@test (-1.5 + 0.5im == "-1.500000+0.500000j")
@test (-1.5 + 0.5im == "-2.+0.j")
@test (-1.5 + 0.5im == "-1.500000e+00+5.000000e-01j")
@test (-1.5 + 0.5im == "-2.e+00+5.e-01j")
@test (-1.5 + 0.5im == "-1.50000+0.500000j")
@test (-1.5 + 0.5im == "-2+0.5j")
@test (-1.5 + 0.5im == "-2.+0.5j")
@test_throws
@test_throws
for t in "bcdoxX"
@test_throws
end
@test ("*0:.3f*" == "*3.142+2.718j*")
@test (complex(NAN, NAN) == "nan+nanj")
@test (complex(1, NAN) == "1.000000+nanj")
@test (complex(NAN, 1) == "nan+1.000000j")
@test (complex(NAN, -1) == "nan-1.000000j")
@test (complex(NAN, NAN) == "NAN+NANj")
@test (complex(1, NAN) == "1.000000+NANj")
@test (complex(NAN, 1) == "NAN+1.000000j")
@test (complex(NAN, -1) == "NAN-1.000000j")
@test (complex(INF, INF) == "inf+infj")
@test (complex(1, INF) == "1.000000+infj")
@test (complex(INF, 1) == "inf+1.000000j")
@test (complex(INF, -1) == "inf-1.000000j")
@test (complex(INF, INF) == "INF+INFj")
@test (complex(1, INF) == "1.000000+INFj")
@test (complex(INF, 1) == "INF+1.000000j")
@test (complex(INF, -1) == "INF-1.000000j")
end


if abspath(PROGRAM_FILE) == @__FILE__
test_numbers = TestNumbers()
test_int(test_numbers)
test_float(test_numbers)
test_complex(test_numbers)
aug_assign_test = AugAssignTest()
testBasic(aug_assign_test)
testInList(aug_assign_test)
testInDict(aug_assign_test)
testSequences(aug_assign_test)
testCustomMethods1(aug_assign_test)
testCustomMethods2(aug_assign_test)
legacy_base64_test_case = LegacyBase64TestCase()
test_encodebytes(legacy_base64_test_case)
test_decodebytes(legacy_base64_test_case)
test_encode(legacy_base64_test_case)
test_decode(legacy_base64_test_case)
base_x_y_test_case = BaseXYTestCase()
test_b64encode(base_x_y_test_case)
test_b64decode(base_x_y_test_case)
test_b64decode_padding_error(base_x_y_test_case)
test_b64decode_invalid_chars(base_x_y_test_case)
test_b32encode(base_x_y_test_case)
test_b32decode(base_x_y_test_case)
test_b32decode_casefold(base_x_y_test_case)
test_b32decode_error(base_x_y_test_case)
test_b32hexencode(base_x_y_test_case)
test_b32hexencode_other_types(base_x_y_test_case)
test_b32hexdecode(base_x_y_test_case)
test_b32hexdecode_other_types(base_x_y_test_case)
test_b32hexdecode_error(base_x_y_test_case)
test_b16encode(base_x_y_test_case)
test_b16decode(base_x_y_test_case)
test_a85encode(base_x_y_test_case)
test_b85encode(base_x_y_test_case)
test_a85decode(base_x_y_test_case)
test_b85decode(base_x_y_test_case)
test_a85_padding(base_x_y_test_case)
test_b85_padding(base_x_y_test_case)
test_a85decode_errors(base_x_y_test_case)
test_b85decode_errors(base_x_y_test_case)
test_decode_nonascii_str(base_x_y_test_case)
test_ErrorHeritage(base_x_y_test_case)
test_RFC4648_test_cases(base_x_y_test_case)
test_main = TestMain()
test_encode_decode(test_main)
test_encode_file(test_main)
test_encode_from_stdin(test_main)
test_decode(test_main)
tearDown(test_main)
rat_test_case = RatTestCase()
test_gcd(rat_test_case)
test_constructor(rat_test_case)
test_add(rat_test_case)
test_sub(rat_test_case)
test_mul(rat_test_case)
test_div(rat_test_case)
test_floordiv(rat_test_case)
test_eq(rat_test_case)
test_true_div(rat_test_case)
operation_order_tests = OperationOrderTests()
test_comparison_orders(operation_order_tests)
fallback_blocking_tests = FallbackBlockingTests()
test_fallback_rmethod_blocking(fallback_blocking_tests)
test_fallback_ne_blocking(fallback_blocking_tests)
bool_test = BoolTest()
test_repr(bool_test)
test_str(bool_test)
test_int(bool_test)
test_float(bool_test)
test_math(bool_test)
test_convert(bool_test)
test_keyword_args(bool_test)
test_format(bool_test)
test_hasattr(bool_test)
test_callable(bool_test)
test_isinstance(bool_test)
test_issubclass(bool_test)
test_contains(bool_test)
test_string(bool_test)
test_boolean(bool_test)
test_fileclosed(bool_test)
test_types(bool_test)
test_operator(bool_test)
test_marshal(bool_test)
test_pickle(bool_test)
test_picklevalues(bool_test)
test_convert_to_bool(bool_test)
test_from_bytes(bool_test)
test_sane_len(bool_test)
test_blocked(bool_test)
test_real_and_imag(bool_test)
test_bool_called_at_least_once(bool_test)
builtin_test = BuiltinTest()
test_import(builtin_test)
test_abs(builtin_test)
test_all(builtin_test)
test_any(builtin_test)
test_ascii(builtin_test)
test_neg(builtin_test)
test_callable(builtin_test)
test_chr(builtin_test)
test_cmp(builtin_test)
test_compile(builtin_test)
test_compile_top_level_await_no_coro(builtin_test)
test_compile_top_level_await(builtin_test)
test_compile_top_level_await_invalid_cases(builtin_test)
test_compile_async_generator(builtin_test)
test_delattr(builtin_test)
test_dir(builtin_test)
test_divmod(builtin_test)
test_eval(builtin_test)
test_general_eval(builtin_test)
test_exec(builtin_test)
test_exec_globals(builtin_test)
test_exec_redirected(builtin_test)
test_filter(builtin_test)
test_filter_pickle(builtin_test)
test_getattr(builtin_test)
test_hasattr(builtin_test)
test_hash(builtin_test)
test_hex(builtin_test)
test_id(builtin_test)
test_iter(builtin_test)
test_isinstance(builtin_test)
test_issubclass(builtin_test)
test_len(builtin_test)
test_map(builtin_test)
test_map_pickle(builtin_test)
test_max(builtin_test)
test_min(builtin_test)
test_next(builtin_test)
test_oct(builtin_test)
test_open(builtin_test)
test_open_default_encoding(builtin_test)
test_open_non_inheritable(builtin_test)
test_ord(builtin_test)
test_pow(builtin_test)
test_input(builtin_test)
test_repr(builtin_test)
test_round(builtin_test)
test_round_large(builtin_test)
test_bug_27936(builtin_test)
test_setattr(builtin_test)
test_sum(builtin_test)
test_type(builtin_test)
test_vars(builtin_test)
test_zip(builtin_test)
test_zip_pickle(builtin_test)
test_zip_pickle_strict(builtin_test)
test_zip_pickle_strict_fail(builtin_test)
test_zip_bad_iterable(builtin_test)
test_zip_strict(builtin_test)
test_zip_strict_iterators(builtin_test)
test_zip_strict_error_handling(builtin_test)
test_zip_strict_error_handling_stopiteration(builtin_test)
test_zip_result_gc(builtin_test)
test_format(builtin_test)
test_bin(builtin_test)
test_bytearray_translate(builtin_test)
test_bytearray_extend_error(builtin_test)
test_construct_singletons(builtin_test)
test_warning_notimplemented(builtin_test)
test_breakpoint = TestBreakpoint()
setUp(test_breakpoint)
test_breakpoint(test_breakpoint)
test_breakpoint_with_breakpointhook_set(test_breakpoint)
test_breakpoint_with_breakpointhook_reset(test_breakpoint)
test_breakpoint_with_args_and_keywords(test_breakpoint)
test_breakpoint_with_passthru_error(test_breakpoint)
test_envar_good_path_builtin(test_breakpoint)
test_envar_good_path_other(test_breakpoint)
test_envar_good_path_noop_0(test_breakpoint)
test_envar_good_path_empty_string(test_breakpoint)
test_envar_unimportable(test_breakpoint)
test_envar_ignored_when_hook_is_set(test_breakpoint)
pty_tests = PtyTests()
test_input_tty(pty_tests)
test_input_tty_non_ascii(pty_tests)
test_input_tty_non_ascii_unicode_errors(pty_tests)
test_input_no_stdout_fileno(pty_tests)
test_sorted = TestSorted()
test_basic(test_sorted)
test_bad_arguments(test_sorted)
test_inputtypes(test_sorted)
test_baddecorator(test_sorted)
shutdown_test = ShutdownTest()
test_cleanup(shutdown_test)
test_type = TestType()
test_new_type(test_type)
test_type_nokwargs(test_type)
test_type_name(test_type)
test_type_qualname(test_type)
test_type_doc(test_type)
test_bad_args(test_type)
test_bad_slots(test_type)
test_namespace_order(test_type)
bytes_test = BytesTest()
test_getitem_error(bytes_test)
test_buffer_is_readonly(bytes_test)
test_bytes_blocking(bytes_test)
test_repeat_id_preserving(bytes_test)
byte_array_test = ByteArrayTest()
test_getitem_error(byte_array_test)
test_setitem_error(byte_array_test)
test_nohash(byte_array_test)
test_bytearray_api(byte_array_test)
test_reverse(byte_array_test)
test_clear(byte_array_test)
test_copy(byte_array_test)
test_regexps(byte_array_test)
test_setitem(byte_array_test)
test_delitem(byte_array_test)
test_setslice(byte_array_test)
test_setslice_extend(byte_array_test)
test_fifo_overrun(byte_array_test)
test_del_expand(byte_array_test)
test_extended_set_del_slice(byte_array_test)
test_setslice_trap(byte_array_test)
test_iconcat(byte_array_test)
test_irepeat(byte_array_test)
test_irepeat_1char(byte_array_test)
test_alloc(byte_array_test)
test_init_alloc(byte_array_test)
test_extend(byte_array_test)
test_remove(byte_array_test)
test_pop(byte_array_test)
test_nosort(byte_array_test)
test_append(byte_array_test)
test_insert(byte_array_test)
test_copied(byte_array_test)
test_partition_bytearray_doesnt_share_nullstring(byte_array_test)
test_resize_forbidden(byte_array_test)
test_obsolete_write_lock(byte_array_test)
test_iterator_pickling2(byte_array_test)
test_iterator_length_hint(byte_array_test)
test_repeat_after_setslice(byte_array_test)
assorted_bytes_test = AssortedBytesTest()
test_repr_str(assorted_bytes_test)
test_format(assorted_bytes_test)
test_compare_bytes_to_bytearray(assorted_bytes_test)
test_doc(assorted_bytes_test)
test_from_bytearray(assorted_bytes_test)
test_to_str(assorted_bytes_test)
test_literal(assorted_bytes_test)
test_split_bytearray(assorted_bytes_test)
test_rsplit_bytearray(assorted_bytes_test)
test_return_self(assorted_bytes_test)
test_compare(assorted_bytes_test)
bytearray_p_e_p3137_test = BytearrayPEP3137Test()
test_returns_new_copy(bytearray_p_e_p3137_test)
byte_array_as_string_test = ByteArrayAsStringTest()
bytes_as_string_test = BytesAsStringTest()
byte_array_subclass_test = ByteArraySubclassTest()
test_init_override(byte_array_subclass_test)
bytes_subclass_test = BytesSubclassTest()
test_user_objects = TestUserObjects()
test_str_protocol(test_user_objects)
test_list_protocol(test_user_objects)
test_dict_protocol(test_user_objects)
test_list_copy(test_user_objects)
test_dict_copy(test_user_objects)
test_chain_map = TestChainMap()
test_basics(test_chain_map)
test_ordering(test_chain_map)
test_constructor(test_chain_map)
test_bool(test_chain_map)
test_missing(test_chain_map)
test_order_preservation(test_chain_map)
test_iter_not_calling_getitem_on_maps(test_chain_map)
test_dict_coercion(test_chain_map)
test_new_child(test_chain_map)
test_union_operators(test_chain_map)
test_named_tuple = TestNamedTuple()
test_factory(test_named_tuple)
test_defaults(test_named_tuple)
test_readonly(test_named_tuple)
test_factory_doc_attr(test_named_tuple)
test_field_doc(test_named_tuple)
test_field_doc_reuse(test_named_tuple)
test_field_repr(test_named_tuple)
test_name_fixer(test_named_tuple)
test_module_parameter(test_named_tuple)
test_instance(test_named_tuple)
test_tupleness(test_named_tuple)
test_odd_sizes(test_named_tuple)
test_pickle(test_named_tuple)
test_copy(test_named_tuple)
test_name_conflicts(test_named_tuple)
test_repr(test_named_tuple)
test_keyword_only_arguments(test_named_tuple)
test_namedtuple_subclass_issue_24931(test_named_tuple)
test_field_descriptor(test_named_tuple)
test_new_builtins_issue_43102(test_named_tuple)
test_match_args(test_named_tuple)
a_b_c_test_case = ABCTestCase()
test_counter = TestCounter()
test_basics(test_counter)
test_init(test_counter)
test_total(test_counter)
test_order_preservation(test_counter)
test_update(test_counter)
test_copying(test_counter)
test_copy_subclass(test_counter)
test_conversions(test_counter)
test_invariant_for_the_in_operator(test_counter)
test_multiset_operations(test_counter)
test_inplace_operations(test_counter)
test_subtract(test_counter)
test_unary(test_counter)
test_repr_nonsortable(test_counter)
test_helper_function(test_counter)
test_multiset_operations_equivalent_to_set_operations(test_counter)
test_eq(test_counter)
test_le(test_counter)
test_lt(test_counter)
test_ge(test_counter)
test_gt(test_counter)
comparison_test = ComparisonTest()
test_comparisons(comparison_test)
test_id_comparisons(comparison_test)
test_ne_defaults_to_not_eq(comparison_test)
test_ne_high_priority(comparison_test)
test_ne_low_priority(comparison_test)
test_other_delegation(comparison_test)
test_issue_1393(comparison_test)
complex_test = ComplexTest()
test_truediv(complex_test)
test_truediv_zero_division(complex_test)
test_floordiv(complex_test)
test_floordiv_zero_division(complex_test)
test_richcompare(complex_test)
test_richcompare_boundaries(complex_test)
test_mod(complex_test)
test_mod_zero_division(complex_test)
test_divmod(complex_test)
test_divmod_zero_division(complex_test)
test_pow(complex_test)
test_pow_with_small_integer_exponents(complex_test)
test_boolcontext(complex_test)
test_conjugate(complex_test)
test_constructor(complex_test)
test_constructor_special_numbers(complex_test)
test_underscores(complex_test)
test_hash(complex_test)
test_abs(complex_test)
test_repr_str(complex_test)
test_negative_zero_repr_str(complex_test)
test_neg(complex_test)
test_getnewargs(complex_test)
test_plus_minus_0j(complex_test)
test_negated_imaginary_literal(complex_test)
test_overflow(complex_test)
test_repr_roundtrip(complex_test)
test_format(complex_test)
end