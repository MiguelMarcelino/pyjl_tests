using Test



using test.test_grammar: VALID_UNDERSCORE_LITERALS, INVALID_UNDERSCORE_LITERALS
using random: random


abstract type AbstractComplexTest end
abstract type AbstractNS <: object end
abstract type Abstractcomplex2 <: complex end
abstract type AbstractEvilExc <: Exception end
abstract type Abstractcomplex0 <: complex end
abstract type Abstractcomplex1 <: complex end
INF = float("inf")
NAN = float("nan")
ZERO_DIVISION = ((1 + 1im, 0 + 0im), (1 + 1im, 0.0), (1 + 1im, 0), (1.0, 0 + 0im), (1, 0 + 0im))
mutable struct ComplexTest <: AbstractComplexTest
value
assertEqual
end
function assertAlmostEqual(self, a, b)
if isa(a, complex)
if isa(b, complex)
assertAlmostEqual(unittest.TestCase, self, a.real)
assertAlmostEqual(unittest.TestCase, self, a.imag)
else
assertAlmostEqual(unittest.TestCase, self, a.real)
assertAlmostEqual(unittest.TestCase, self, a.imag)
end
elseif isa(b, complex)
assertAlmostEqual(unittest.TestCase, self, a)
assertAlmostEqual(unittest.TestCase, self, 0.0)
else
assertAlmostEqual(unittest.TestCase, self, a)
end
end

function assertCloseAbs(self, x, y, eps = 1e-09)::Bool
#= Return true iff floats x and y "are close". =#
if abs(x) > abs(y)
x, y = (y, x)
end
if y === 0
return abs(x) < eps
end
if x === 0
return abs(y) < eps
end
@test abs((x - y) / y) < eps
end

function assertFloatsAreIdentical(self, x, y)
#= assert that floats x and y are identical, in the sense that:
        (1) both x and y are nans, or
        (2) both x and y are infinities, with the same sign, or
        (3) both x and y are zeros, with the same sign, or
        (4) x and y are both finite and nonzero, and x == y

         =#
msg = "floats {!r} and {!r} are not identical"
if isnan(x) || isnan(y)
if isnan(x) && isnan(y)
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

function assertClose(self, x, y, eps = 1e-09)
#= Return true iff complexes x and y "are close". =#
assertCloseAbs(self, x.real, y.real, eps)
assertCloseAbs(self, x.imag, y.imag, eps)
end

function check_div(self, x, y)
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

function test_truediv(self)
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
check_div(self, complex(pylib::random::random(), pylib::random::random()), complex(pylib::random::random(), pylib::random::random()))
end
assertAlmostEqual(self, __truediv__(complex, 2 + 0im, 1 + 1im), 1 - 1im)
for (denom_real, denom_imag) in [(0, NAN), (NAN, 0), (NAN, NAN)]
z = complex(0, 0) / complex(denom_real, denom_imag)
@test isnan(z.real)
@test isnan(z.imag)
end
end

function test_truediv_zero_division(self)
for (a, b) in ZERO_DIVISION
assertRaises(self, ZeroDivisionError) do 
a / b
end
end
end

function test_floordiv(self)
assertRaises(self, TypeError) do 
(1 + 1im) ÷ (1 + 0im)
end
assertRaises(self, TypeError) do 
(1 + 1im) ÷ 1.0
end
assertRaises(self, TypeError) do 
(1 + 1im) ÷ 1
end
assertRaises(self, TypeError) do 
1.0 ÷ (1 + 0im)
end
assertRaises(self, TypeError) do 
1 ÷ (1 + 0im)
end
end

function test_floordiv_zero_division(self)
for (a, b) in ZERO_DIVISION
assertRaises(self, TypeError) do 
a ÷ b
end
end
end

function test_richcompare(self)
assertIs(self, __eq__(complex, 1 + 1im, 1 << 10000), false)
assertIs(self, __lt__(complex, 1 + 1im, nothing), NotImplemented)
assertIs(self, __eq__(complex, 1 + 1im, 1 + 1im), true)
assertIs(self, __eq__(complex, 1 + 1im, 2 + 2im), false)
assertIs(self, __ne__(complex, 1 + 1im, 1 + 1im), false)
assertIs(self, __ne__(complex, 1 + 1im, 2 + 2im), true)
for i in 1:99
f = i / 100.0
assertIs(self, __eq__(complex, f + 0im, f), true)
assertIs(self, __ne__(complex, f + 0im, f), false)
assertIs(self, __eq__(complex, complex(f, f), f), false)
assertIs(self, __ne__(complex, complex(f, f), f), true)
end
assertIs(self, __lt__(complex, 1 + 1im, 2 + 2im), NotImplemented)
assertIs(self, __le__(complex, 1 + 1im, 2 + 2im), NotImplemented)
assertIs(self, __gt__(complex, 1 + 1im, 2 + 2im), NotImplemented)
assertIs(self, __ge__(complex, 1 + 1im, 2 + 2im), NotImplemented)
@test_throws TypeError operator.lt(1 + 1im, 2 + 2im)
@test_throws TypeError operator.le(1 + 1im, 2 + 2im)
@test_throws TypeError operator.gt(1 + 1im, 2 + 2im)
@test_throws TypeError operator.ge(1 + 1im, 2 + 2im)
assertIs(self, eq(1 + 1im, 1 + 1im), true)
assertIs(self, eq(1 + 1im, 2 + 2im), false)
assertIs(self, ne(1 + 1im, 1 + 1im), false)
assertIs(self, ne(1 + 1im, 2 + 2im), true)
end

function test_richcompare_boundaries(self)
function check(n, deltas, is_equal, imag = 0.0)
for delta in deltas
i = n + delta
z = complex(i, imag)
assertIs(self, __eq__(complex, z, i), is_equal(delta))
assertIs(self, __ne__(complex, z, i), !is_equal(delta))
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

function test_mod(self)
assertRaises(self, TypeError) do 
(1 + 1im) % (1 + 0im)
end
assertRaises(self, TypeError) do 
(1 + 1im) % 1.0
end
assertRaises(self, TypeError) do 
(1 + 1im) % 1
end
assertRaises(self, TypeError) do 
1.0 % (1 + 0im)
end
assertRaises(self, TypeError) do 
1 % (1 + 0im)
end
end

function test_mod_zero_division(self)
for (a, b) in ZERO_DIVISION
assertRaises(self, TypeError) do 
a % b
end
end
end

function test_divmod(self)
@test_throws TypeError divmod(1 + 1im, 1 + 0im)
@test_throws TypeError divmod(1 + 1im, 1.0)
@test_throws TypeError divmod(1 + 1im, 1)
@test_throws TypeError divmod(1.0, 1 + 0im)
@test_throws TypeError divmod(1, 1 + 0im)
end

function test_divmod_zero_division(self)
for (a, b) in ZERO_DIVISION
@test_throws TypeError divmod(a, b)
end
end

function test_pow(self)
assertAlmostEqual(self, pow(1 + 1im, 0 + 0im), 1.0)
assertAlmostEqual(self, pow(0 + 0im, 2 + 0im), 0.0)
@test_throws ZeroDivisionError pow(0 + 0im, 1im)
assertAlmostEqual(self, pow(1im, -1), 1 / 1im)
assertAlmostEqual(self, pow(1im, 200), 1)
@test_throws ValueError pow(1 + 1im, 1 + 1im, 1 + 1im)
@test_throws OverflowError pow(1e+200 + 1im, 1e+200 + 1im)
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
@test_throws ValueError pow(a, b, 0)
values = (sys.maxsize, sys.maxsize + 1, sys.maxsize - 1, -(sys.maxsize), -(sys.maxsize) + 1, -(sys.maxsize) + 1)
for real in values
for imag in values
subTest(self, real = real, imag = imag) do 
c = complex(real, imag)
try
c^real
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

function test_pow_with_small_integer_exponents(self)
values = [complex(5.0, 12.0), complex(5e+100, 1.2e+101), complex(-4.0, INF), complex(INF, 0.0)]
exponents = [-19, -5, -3, -2, -1, 0, 1, 2, 3, 5, 19]
for value in values
for exponent in exponents
subTest(self, value = value, exponent = exponent) do 
try
int_pow = value^exponent
catch exn
if exn isa OverflowError
int_pow = "overflow"
end
end
try
float_pow = value^float(exponent)
catch exn
if exn isa OverflowError
float_pow = "overflow"
end
end
try
complex_pow = value^complex(exponent)
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

function test_boolcontext(self)
for i in 0:99
@test complex(pylib::random::random() + 1e-06, pylib::random::random() + 1e-06)
end
@test !complex(0.0, 0.0)
end

function test_conjugate(self)
assertClose(self, conjugate(complex(5.3, 9.8)), 5.3 - 9.8im)
end

function test_constructor(self)
mutable struct OS <: AbstractOS
value
end
function __complex__(self)
return self.value
end

mutable struct NS <: AbstractNS
value
end
function __complex__(self)
return self.value
end

assertEqual(self, complex(OS(1 + 10im)), 1 + 10im)
assertEqual(self, complex(NS(1 + 10im)), 1 + 10im)
assertRaises(self, TypeError, complex, OS(nothing))
assertRaises(self, TypeError, complex, NS(nothing))
assertRaises(self, TypeError, complex, Dict())
assertRaises(self, TypeError, complex, NS(1.5))
assertRaises(self, TypeError, complex, NS(1))
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
mutable struct complex2 <: Abstractcomplex2

end

assertAlmostEqual(self, complex(complex2(1 + 1im)), 1 + 1im)
assertAlmostEqual(self, complex(real = 17, imag = 23), 17 + 23im)
assertAlmostEqual(self, complex(real = 17 + 23im), 17 + 23im)
assertAlmostEqual(self, complex(real = 17 + 23im, imag = 23), 17 + 46im)
assertAlmostEqual(self, complex(real = 1 + 2im, imag = 3 + 4im), -3 + 5im)
function split_zeros(x)
#= Function that produces different results for 0. and -0. =#
return atan2(x, -1.0)
end

assertEqual(self, split_zeros(complex(1.0, 0.0).imag), split_zeros(0.0))
assertEqual(self, split_zeros(complex(1.0, -0.0).imag), split_zeros(-0.0))
assertEqual(self, split_zeros(complex(0.0, 1.0).real), split_zeros(0.0))
assertEqual(self, split_zeros(complex(-0.0, 1.0).real), split_zeros(-0.0))
c = 3.14 + 1im
assertTrue(self, complex(c) === c)
#Delete Unsupported
del(c)
assertRaises(self, TypeError, complex, "1", "1")
assertRaises(self, TypeError, complex, 1, "1")
assertRaises(self, ValueError, complex, "1+1j\0j")
assertRaises(self, TypeError, int, 5 + 3im)
assertRaises(self, TypeError, int, 5 + 3im)
assertRaises(self, TypeError, float, 5 + 3im)
assertRaises(self, ValueError, complex, "")
assertRaises(self, TypeError, complex, nothing)
assertRaisesRegex(self, TypeError, "not \'NoneType\'", complex, nothing)
assertRaises(self, ValueError, complex, "\0")
assertRaises(self, ValueError, complex, "3\09")
assertRaises(self, TypeError, complex, "1", "2")
assertRaises(self, TypeError, complex, "1", 42)
assertRaises(self, TypeError, complex, 1, "2")
assertRaises(self, ValueError, complex, "1+")
assertRaises(self, ValueError, complex, "1+1j+1j")
assertRaises(self, ValueError, complex, "--")
assertRaises(self, ValueError, complex, "(1+2j")
assertRaises(self, ValueError, complex, "1+2j)")
assertRaises(self, ValueError, complex, "1+(2j)")
assertRaises(self, ValueError, complex, "(1+2j)123")
assertRaises(self, ValueError, complex, "x")
assertRaises(self, ValueError, complex, "1j+2")
assertRaises(self, ValueError, complex, "1e1ej")
assertRaises(self, ValueError, complex, "1e++1ej")
assertRaises(self, ValueError, complex, ")1+2j(")
assertRaisesRegex(self, TypeError, "first argument must be a string or a number, not \'dict\'", complex, Dict(1 => 2), 1)
assertRaisesRegex(self, TypeError, "second argument must be a number, not \'dict\'", complex, 1, Dict(1 => 2))
assertRaises(self, ValueError, complex, "1..1j")
assertRaises(self, ValueError, complex, "1.11.1j")
assertRaises(self, ValueError, complex, "1e1.1j")
assertEqual(self, type_(complex(repeat("1",500))), complex)
assertEqual(self, complex(" ( 1+1j ) "), 1 + 1im)
assertRaises(self, ValueError, complex, "こんにちは")
mutable struct EvilExc <: AbstractEvilExc

end

mutable struct evilcomplex <: Abstractevilcomplex

end
function __complex__(self)
throw(EvilExc)
end

assertRaises(self, EvilExc, complex, evilcomplex())
mutable struct float2 <: Abstractfloat2
value
end
function __float__(self)
return self.value
end

assertAlmostEqual(self, complex(float2(42.0)), 42)
assertAlmostEqual(self, complex(real = float2(17.0), imag = float2(23.0)), 17 + 23im)
assertRaises(self, TypeError, complex, float2(nothing))
mutable struct MyIndex <: AbstractMyIndex
value
end
function __index__(self)
return self.value
end

assertAlmostEqual(self, complex(MyIndex(42)), 42.0 + 0im)
assertAlmostEqual(self, complex(123, MyIndex(42)), 123.0 + 42im)
assertRaises(self, OverflowError, complex, MyIndex(2^2000))
assertRaises(self, OverflowError, complex, 123, MyIndex(2^2000))
mutable struct MyInt <: AbstractMyInt

end
function __int__(self)::Int64
return 42
end

assertRaises(self, TypeError, complex, MyInt())
assertRaises(self, TypeError, complex, 123, MyInt())
mutable struct complex0 <: Abstractcomplex0
#= Test usage of __complex__() when inheriting from 'complex' =#

end
function __complex__(self)::Complex
return 42im
end

mutable struct complex1 <: Abstractcomplex1
#= Test usage of __complex__() with a __new__() method =#

end
function __new__(self, value = 0im)
return __new__(complex, self)
end

function __complex__(self)
return self
end

mutable struct complex2 <: Abstractcomplex2
#= Make sure that __complex__() calls fail if anything other than a
            complex is returned =#

end
function __complex__(self)
return nothing
end

assertEqual(self, complex(complex0(1im)), 42im)
assertWarns(self, DeprecationWarning) do 
assertEqual(self, complex(complex1(1im)), 2im)
end
assertRaises(self, TypeError, complex, complex2(1im))
end

function test_constructor_special_numbers(self)
mutable struct complex2 <: Abstractcomplex2

end

for x in (0.0, -0.0, INF, -(INF), NAN)
for y in (0.0, -0.0, INF, -(INF), NAN)
subTest(self, x = x, y = y) do 
z = complex(x, y)
assertFloatsAreIdentical(self, z.real, x)
assertFloatsAreIdentical(self, z.imag, y)
z = complex2(x, y)
assertIs(self, type_(z), complex2)
assertFloatsAreIdentical(self, z.real, x)
assertFloatsAreIdentical(self, z.imag, y)
z = complex(complex2(x, y))
assertIs(self, type_(z), complex)
assertFloatsAreIdentical(self, z.real, x)
assertFloatsAreIdentical(self, z.imag, y)
z = complex2(complex(x, y))
assertIs(self, type_(z), complex2)
assertFloatsAreIdentical(self, z.real, x)
assertFloatsAreIdentical(self, z.imag, y)
end
end
end
end

function test_underscores(self)
for lit in VALID_UNDERSCORE_LITERALS
if !any((ch ∈ lit for ch in "xXoObB"))
@test (complex(lit) == eval(lit))
@test (complex(lit) == complex(replace(lit, "_", "")))
end
end
for lit in INVALID_UNDERSCORE_LITERALS
if lit ∈ ("0_7", "09_99")
continue;
end
if !any((ch ∈ lit for ch in "xXoObB"))
@test_throws ValueError complex(lit)
end
end
end

function test_hash(self)
for x in -30:29
@test (hash(x) == hash(complex(x, 0)))
x /= 3.0
@test (hash(x) == hash(complex(x, 0.0)))
end
end

function test_abs(self)
nums = [complex(x / 3.0, y / 7.0) for x in -9:8 for y in -9:8]
for num in nums
assertAlmostEqual(self, (num.real^2 + num.imag^2)^0.5, abs(num))
end
end

function test_repr_str(self)
function test(v, expected, test_fn = self.assertEqual)
test_fn(repr(v), expected)
test_fn(string(v), expected)
end

test(1 + 6im, "(1+6j)")
test(1 - 6im, "(1-6j)")
test(-(1 + 0im), "(-1+-0j)")
test(complex(1.0, INF), "(1+infj)")
test(complex(1.0, -(INF)), "(1-infj)")
test(complex(INF, 1), "(inf+1j)")
test(complex(-(INF), INF), "(-inf+infj)")
test(complex(NAN, 1), "(nan+1j)")
test(complex(1, NAN), "(1+nanj)")
test(complex(NAN, NAN), "(nan+nanj)")
test(complex(0, INF), "infj")
test(complex(0, -(INF)), "-infj")
test(complex(0, NAN), "nanj")
@test (1 - 6im == complex(repr(1 - 6im)))
@test (1 + 6im == complex(repr(1 + 6im)))
@test (-6im == complex(repr(-6im)))
@test (6im == complex(repr(6im)))
end

function test_negative_zero_repr_str(self)
function test(v, expected, test_fn = self.assertEqual)
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

function test_neg(self)
@test (-(1 + 6im) == -1 - 6im)
end

function test_getnewargs(self)
@test (__getnewargs__(1 + 2im) == (1.0, 2.0))
@test (__getnewargs__(1 - 2im) == (1.0, -2.0))
@test (__getnewargs__(2im) == (0.0, 2.0))
@test (__getnewargs__(-0im) == (0.0, -0.0))
@test (__getnewargs__(complex(0, INF)) == (0.0, INF))
@test (__getnewargs__(complex(INF, 0)) == (INF, 0.0))
end

function test_plus_minus_0j(self)
z1, z2 = (0im, -0im)
@test (atan2(z1.imag, -1.0) == atan2(0.0, -1.0))
@test (atan2(z2.imag, -1.0) == atan2(-0.0, -1.0))
end

function test_negated_imaginary_literal(self)
z0 = -0im
z1 = -7im
z2 = -infim
assertFloatsAreIdentical(self, z0.real, -0.0)
assertFloatsAreIdentical(self, z0.imag, -0.0)
assertFloatsAreIdentical(self, z1.real, -0.0)
assertFloatsAreIdentical(self, z1.imag, -7.0)
assertFloatsAreIdentical(self, z2.real, -0.0)
assertFloatsAreIdentical(self, z2.imag, -(INF))
end

function test_overflow(self)
@test (complex("1e500") == complex(INF, 0.0))
@test (complex("-1e500j") == complex(0.0, -(INF)))
@test (complex("-1e500+1.8e308j") == complex(-(INF), INF))
end

function test_repr_roundtrip(self)
vals = [0.0, 0.0, 1e-315, 1e-200, 0.0123, 3.1415, 1e+50, INF, NAN]
vals = vals + [-(v) for v in vals]
for x in vals
for y in vals
z = complex(x, y)
roundtrip = complex(repr(z))
assertFloatsAreIdentical(self, z.real, roundtrip.real)
assertFloatsAreIdentical(self, z.imag, roundtrip.imag)
end
end
inf, nan = (float("inf"), float("nan"))
infj, nanj = (complex(0.0, inf), complex(0.0, nan))
for x in vals
for y in vals
z = complex(x, y)
roundtrip = eval(repr(z))
assertFloatsAreIdentical(self, 0.0 + z.real, 0.0 + roundtrip.real)
assertFloatsAreIdentical(self, 0.0 + z.imag, 0.0 + roundtrip.imag)
end
end
end

function test_format(self)
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
@test_throws ValueError 1.5 + 0.5im.__format__("010f")
@test_throws ValueError 1.5 + 3im.__format__("=20")
for t in "bcdoxX"
@test_throws ValueError 1.5 + 0.5im.__format__(t)
end
@test ("*$(3.14159 + 2.71828im:.3f)*" == "*3.142+2.718j*")
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
complex_test = ComplexTest()
assertAlmostEqual(complex_test)
assertCloseAbs(complex_test)
assertFloatsAreIdentical(complex_test)
assertClose(complex_test)
check_div(complex_test)
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