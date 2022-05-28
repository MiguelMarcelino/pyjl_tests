using Test

using random: random, gauss, shuffle
using decimal: Decimal
using fractions: Fraction
using doctest: DocFileSuite




import decimal


import platform
import random


eps = 1e-05
NAN = float("nan")
INF = float("inf")
NINF = float("-inf")
FLOAT_MAX = sys.float_info.max
abstract type AbstractIntSubclass <: int end
abstract type AbstractMyIndexable <: object end
abstract type AbstractMathTests end
abstract type AbstractFloatCeil <: float end
abstract type AbstractFloatFloor <: float end
abstract type AbstractT <: tuple end
abstract type AbstractIntegerLike <: object end
abstract type AbstractFloatTrunc <: float end
abstract type AbstractIsCloseTests end
FLOAT_MIN = sys.float_info.min
x, y = (1e+16, 2.9999)
HAVE_DOUBLE_ROUNDING = (x + y) == (1e+16 + 4)
if abspath(PROGRAM_FILE) == @__FILE__
file = sys.argv[1]
else
file = __file__
end
test_dir = dirname(file) || os.curdir
math_testcases = joinpath(test_dir, "math_testcases.txt")
test_file = joinpath(test_dir, "cmath_testcases.txt")
function to_ulps(x)
#= Convert a non-NaN float x to an integer, in such a way that
    adjacent floats are converted to adjacent integers.  Then
    abs(ulps(x) - ulps(y)) gives the difference in ulps between two
    floats.

    The results from this function will only make sense on platforms
    where native doubles are represented in IEEE 754 binary64 format.

    Note: 0.0 and -0.0 are converted to 0 and -1, respectively.
     =#
n = unpack("<q", pack("<d", x))[1]
if n < 0
n = ~(n + 2^63)
end
return n
end

function count_set_bits(n)
#= Number of '1' bits in binary expansion of a nonnnegative integer. =#
return n ? (1 + count_set_bits(n & (n - 1))) : (0)
end

function partial_product(start, stop)::Int64
#= Product of integers in range(start, stop, 2), computed recursively.
    start and stop should both be odd, with start <= stop.

     =#
numfactors = (stop - start) >> 1
if !(numfactors) != 0
return 1
elseif numfactors == 1
return start
else
mid = (start + numfactors) | 1
return partial_product(start, mid)*partial_product(mid, stop)
end
end

function py_factorial(n)::Int64
#= Factorial of nonnegative integer n, via "Binary Split Factorial Formula"
    described at http://www.luschny.de/math/factorial/binarysplitfact.html

     =#
inner = 1
outer = 1
for i in reversed(0:bit_length(n) - 1)
inner *= partial_product(((n >> (i + 1)) + 1) | 1, ((n >> i) + 1) | 1)
outer *= inner
end
return outer << (n - count_set_bits(n))
end

function ulp_abs_check(expected, got, ulp_tol, abs_tol)
#= Given finite floats `expected` and `got`, check that they're
    approximately equal to within the given number of ulps or the
    given absolute tolerance, whichever is bigger.

    Returns None on success and an error message on failure.
     =#
ulp_error = abs(to_ulps(expected) - to_ulps(got))
abs_error = abs(expected - got)
if abs_error <= abs_tol || ulp_error <= ulp_tol
return nothing
else
fmt = "error = {:.3g} ({:d} ulps); permitted error = {:.3g} or {:d} ulps"
return fmt
end
end

function parse_mtestfile(fname)
#= Parse a file with test values

    -- starts a comment
    blank lines, or lines containing only a comment, are ignored
    other lines are expected to have the form
      id fn arg -> expected [flag]*

     =#
Channel() do ch_parse_mtestfile 
readline(fname) do fp 
for line in fp
if "--" ∈ line
line = line[begin:index(line, "--")]
end
if !strip(line)
continue;
end
lhs, rhs = split(line, "->")
id, fn, arg = split(lhs)
rhs_pieces = split(rhs)
exp = rhs_pieces[1]
flags = rhs_pieces[2:end]
put!(ch_parse_mtestfile, (id, fn, float(arg), float(exp), flags))
end
end
end
end

function parse_testfile(fname)
#= Parse a file with test values

    Empty lines or lines starting with -- are ignored
    yields id, fn, arg_real, arg_imag, exp_real, exp_imag
     =#
Channel() do ch_parse_testfile 
readline(fname) do fp 
for line in fp
if startswith(line, "--") || !strip(line)
continue;
end
lhs, rhs = split(line, "->")
id, fn, arg_real, arg_imag = split(lhs)
rhs_pieces = split(rhs)
exp_real, exp_imag = (rhs_pieces[1], rhs_pieces[2])
flags = rhs_pieces[3:end]
put!(ch_parse_testfile, (id, fn, float(arg_real), float(arg_imag), float(exp_real), float(exp_imag), flags))
end
end
end
end

function result_check(expected, got, ulp_tol = 5, abs_tol = 0.0)
#= Compare arguments expected and got, as floats, if either
    is a float, using a tolerance expressed in multiples of
    ulp(expected) or absolutely (if given and greater).

    As a convenience, when neither argument is a float, and for
    non-finite floats, exact equality is demanded. Also, nan==nan
    as far as this function is concerned.

    Returns None on success and an error message on failure.
     =#
if got == expected
return nothing
end
failure = "not equal"
if isa(expected, float) && isa(got, int)
got = float(got)
elseif isa(got, float) && isa(expected, int)
expected = float(expected)
end
if isa(expected, float) && isa(got, float)
if isnan(expected) && isnan(got)
failure = nothing
elseif isinf(expected) || isinf(got)
#= pass =#
else
failure = ulp_abs_check(expected, got, ulp_tol, abs_tol)
end
end
if failure !== nothing
fail_fmt = "expected {!r}, got {!r}"
fail_msg = fail_fmt
fail_msg += " ($())"
return fail_msg
else
return nothing
end
end

mutable struct FloatLike <: AbstractFloatLike
value
end
function __float__(self)
return self.value
end

mutable struct IntSubclass <: AbstractIntSubclass

end

mutable struct MyIndexable <: AbstractMyIndexable
value
end
function __index__(self)
return self.value
end

mutable struct MathTests <: AbstractMathTests
converted::Bool
value
end
function ftest(self, name, got, expected, ulp_tol = 5, abs_tol = 0.0)
#= Compare arguments expected and got, as floats, if either
        is a float, using a tolerance expressed in multiples of
        ulp(expected) or absolutely, whichever is greater.

        As a convenience, when neither argument is a float, and for
        non-finite floats, exact equality is demanded. Also, nan==nan
        in this function.
         =#
failure = result_check(expected, got, ulp_tol, abs_tol)
if failure !== nothing
fail(self, "$(): $()")
end
end

function testConstants(self)
ftest(self, "pi", math.pi, 3.141592653589793)
ftest(self, "e", math.e, 2.718281828459045)
@test (math.tau == 2*math.pi)
end

function testAcos(self)
@test_throws TypeError math.acos()
ftest(self, "acos(-1)", acos(-1), math.pi)
ftest(self, "acos(0)", acos(0), math.pi / 2)
ftest(self, "acos(1)", acos(1), 0)
@test_throws ValueError math.acos(INF)
@test_throws ValueError math.acos(NINF)
@test_throws ValueError math.acos(1 + eps)
@test_throws ValueError math.acos(-1 - eps)
@test isnan(acos(NAN))
end

function testAcosh(self)
@test_throws TypeError math.acosh()
ftest(self, "acosh(1)", acosh(1), 0)
ftest(self, "acosh(2)", acosh(2), 1.3169578969248168)
@test_throws ValueError math.acosh(0)
@test_throws ValueError math.acosh(-1)
@test (acosh(INF) == INF)
@test_throws ValueError math.acosh(NINF)
@test isnan(acosh(NAN))
end

function testAsin(self)
@test_throws TypeError math.asin()
ftest(self, "asin(-1)", asin(-1), -(math.pi) / 2)
ftest(self, "asin(0)", asin(0), 0)
ftest(self, "asin(1)", asin(1), math.pi / 2)
@test_throws ValueError math.asin(INF)
@test_throws ValueError math.asin(NINF)
@test_throws ValueError math.asin(1 + eps)
@test_throws ValueError math.asin(-1 - eps)
@test isnan(asin(NAN))
end

function testAsinh(self)
@test_throws TypeError math.asinh()
ftest(self, "asinh(0)", asinh(0), 0)
ftest(self, "asinh(1)", asinh(1), 0.881373587019543)
ftest(self, "asinh(-1)", asinh(-1), -0.881373587019543)
@test (asinh(INF) == INF)
@test (asinh(NINF) == NINF)
@test isnan(asinh(NAN))
end

function testAtan(self)
@test_throws TypeError math.atan()
ftest(self, "atan(-1)", atan(-1), -(math.pi) / 4)
ftest(self, "atan(0)", atan(0), 0)
ftest(self, "atan(1)", atan(1), math.pi / 4)
ftest(self, "atan(inf)", atan(INF), math.pi / 2)
ftest(self, "atan(-inf)", atan(NINF), -(math.pi) / 2)
@test isnan(atan(NAN))
end

function testAtanh(self)
@test_throws TypeError math.atan()
ftest(self, "atanh(0)", atanh(0), 0)
ftest(self, "atanh(0.5)", atanh(0.5), 0.5493061443340549)
ftest(self, "atanh(-0.5)", atanh(-0.5), -0.5493061443340549)
@test_throws ValueError math.atanh(1)
@test_throws ValueError math.atanh(-1)
@test_throws ValueError math.atanh(INF)
@test_throws ValueError math.atanh(NINF)
@test isnan(atanh(NAN))
end

function testAtan2(self)
@test_throws TypeError math.atan2()
ftest(self, "atan2(-1, 0)", atan2(-1, 0), -(math.pi) / 2)
ftest(self, "atan2(-1, 1)", atan2(-1, 1), -(math.pi) / 4)
ftest(self, "atan2(0, 1)", atan2(0, 1), 0)
ftest(self, "atan2(1, 1)", atan2(1, 1), math.pi / 4)
ftest(self, "atan2(1, 0)", atan2(1, 0), math.pi / 2)
ftest(self, "atan2(0., -inf)", atan2(0.0, NINF), math.pi)
ftest(self, "atan2(0., -2.3)", atan2(0.0, -2.3), math.pi)
ftest(self, "atan2(0., -0.)", atan2(0.0, -0.0), math.pi)
@test (atan2(0.0, 0.0) == 0.0)
@test (atan2(0.0, 2.3) == 0.0)
@test (atan2(0.0, INF) == 0.0)
@test isnan(atan2(0.0, NAN))
ftest(self, "atan2(-0., -inf)", atan2(-0.0, NINF), -(math.pi))
ftest(self, "atan2(-0., -2.3)", atan2(-0.0, -2.3), -(math.pi))
ftest(self, "atan2(-0., -0.)", atan2(-0.0, -0.0), -(math.pi))
@test (atan2(-0.0, 0.0) == -0.0)
@test (atan2(-0.0, 2.3) == -0.0)
@test (atan2(-0.0, INF) == -0.0)
@test isnan(atan2(-0.0, NAN))
ftest(self, "atan2(inf, -inf)", atan2(INF, NINF), math.pi*3 / 4)
ftest(self, "atan2(inf, -2.3)", atan2(INF, -2.3), math.pi / 2)
ftest(self, "atan2(inf, -0.)", atan2(INF, -0.0), math.pi / 2)
ftest(self, "atan2(inf, 0.)", atan2(INF, 0.0), math.pi / 2)
ftest(self, "atan2(inf, 2.3)", atan2(INF, 2.3), math.pi / 2)
ftest(self, "atan2(inf, inf)", atan2(INF, INF), math.pi / 4)
@test isnan(atan2(INF, NAN))
ftest(self, "atan2(-inf, -inf)", atan2(NINF, NINF), -(math.pi)*3 / 4)
ftest(self, "atan2(-inf, -2.3)", atan2(NINF, -2.3), -(math.pi) / 2)
ftest(self, "atan2(-inf, -0.)", atan2(NINF, -0.0), -(math.pi) / 2)
ftest(self, "atan2(-inf, 0.)", atan2(NINF, 0.0), -(math.pi) / 2)
ftest(self, "atan2(-inf, 2.3)", atan2(NINF, 2.3), -(math.pi) / 2)
ftest(self, "atan2(-inf, inf)", atan2(NINF, INF), -(math.pi) / 4)
@test isnan(atan2(NINF, NAN))
ftest(self, "atan2(2.3, -inf)", atan2(2.3, NINF), math.pi)
ftest(self, "atan2(2.3, -0.)", atan2(2.3, -0.0), math.pi / 2)
ftest(self, "atan2(2.3, 0.)", atan2(2.3, 0.0), math.pi / 2)
@test (atan2(2.3, INF) == 0.0)
@test isnan(atan2(2.3, NAN))
ftest(self, "atan2(-2.3, -inf)", atan2(-2.3, NINF), -(math.pi))
ftest(self, "atan2(-2.3, -0.)", atan2(-2.3, -0.0), -(math.pi) / 2)
ftest(self, "atan2(-2.3, 0.)", atan2(-2.3, 0.0), -(math.pi) / 2)
@test (atan2(-2.3, INF) == -0.0)
@test isnan(atan2(-2.3, NAN))
@test isnan(atan2(NAN, NINF))
@test isnan(atan2(NAN, -2.3))
@test isnan(atan2(NAN, -0.0))
@test isnan(atan2(NAN, 0.0))
@test isnan(atan2(NAN, 2.3))
@test isnan(atan2(NAN, INF))
@test isnan(atan2(NAN, NAN))
end

function testCeil(self)
assertRaises(self, TypeError, math.ceil)
assertEqual(self, int, type_(ceil(0.5)))
assertEqual(self, ceil(0.5), 1)
assertEqual(self, ceil(1.0), 1)
assertEqual(self, ceil(1.5), 2)
assertEqual(self, ceil(-0.5), 0)
assertEqual(self, ceil(-1.0), -1)
assertEqual(self, ceil(-1.5), -1)
assertEqual(self, ceil(0.0), 0)
assertEqual(self, ceil(-0.0), 0)
mutable struct TestCeil <: AbstractTestCeil

end
function __ceil__(self)::Int64
return 42
end

mutable struct FloatCeil <: AbstractFloatCeil

end
function __ceil__(self)::Int64
return 42
end

mutable struct TestNoCeil <: AbstractTestNoCeil

end

assertEqual(self, ceil(TestCeil()), 42)
assertEqual(self, ceil(FloatCeil()), 42)
assertEqual(self, ceil(FloatLike(42.5)), 43)
assertRaises(self, TypeError, math.ceil, TestNoCeil())
t = TestNoCeil()
t.__ceil__ = () -> args
assertRaises(self, TypeError, math.ceil, t)
assertRaises(self, TypeError, math.ceil, t, 0)
end

function testCopysign(self)
@test (copysign(1, 42) == 1.0)
@test (copysign(0.0, 42) == 0.0)
@test (copysign(1.0, -42) == -1.0)
@test (copysign(3, 0.0) == 3.0)
@test (copysign(4.0, -0.0) == -4.0)
@test_throws TypeError math.copysign()
@test (copysign(1.0, 0.0) == 1.0)
@test (copysign(1.0, -0.0) == -1.0)
@test (copysign(INF, 0.0) == INF)
@test (copysign(INF, -0.0) == NINF)
@test (copysign(NINF, 0.0) == INF)
@test (copysign(NINF, -0.0) == NINF)
@test (copysign(1.0, INF) == 1.0)
@test (copysign(1.0, NINF) == -1.0)
@test (copysign(INF, INF) == INF)
@test (copysign(INF, NINF) == NINF)
@test (copysign(NINF, INF) == INF)
@test (copysign(NINF, NINF) == NINF)
@test isnan(copysign(NAN, 1.0))
@test isnan(copysign(NAN, INF))
@test isnan(copysign(NAN, NINF))
@test isnan(copysign(NAN, NAN))
@test isinf(copysign(INF, NAN))
@test (abs(copysign(2.0, NAN)) == 2.0)
end

function testCos(self)
@test_throws TypeError math.cos()
ftest(self, "cos(-pi/2)", cos(-(math.pi) / 2), 0)
ftest(self, "cos(0)", cos(0), 1)
ftest(self, "cos(pi/2)", cos(math.pi / 2), 0)
ftest(self, "cos(pi)", cos(math.pi), -1)
try
@test isnan(cos(INF))
@test isnan(cos(NINF))
catch exn
if exn isa ValueError
@test_throws ValueError math.cos(INF)
@test_throws ValueError math.cos(NINF)
end
end
@test isnan(cos(NAN))
end

function testCosh(self)
@test_throws TypeError math.cosh()
ftest(self, "cosh(0)", cosh(0), 1)
ftest(self, "cosh(2)-2*cosh(1)**2", cosh(2) - 2*cosh(1)^2, -1)
@test (cosh(INF) == INF)
@test (cosh(NINF) == INF)
@test isnan(cosh(NAN))
end

function testDegrees(self)
@test_throws TypeError math.degrees()
ftest(self, "degrees(pi)", degrees(math.pi), 180.0)
ftest(self, "degrees(pi/2)", degrees(math.pi / 2), 90.0)
ftest(self, "degrees(-pi/4)", degrees(-(math.pi) / 4), -45.0)
ftest(self, "degrees(0)", degrees(0), 0)
end

function testExp(self)
@test_throws TypeError math.exp()
ftest(self, "exp(-1)", exp(-1), 1 / math.e)
ftest(self, "exp(0)", exp(0), 1)
ftest(self, "exp(1)", exp(1), math.e)
@test (exp(INF) == INF)
@test (exp(NINF) == 0.0)
@test isnan(exp(NAN))
@test_throws OverflowError math.exp(1000000)
end

function testFabs(self)
@test_throws TypeError math.fabs()
ftest(self, "fabs(-1)", fabs(-1), 1)
ftest(self, "fabs(0)", fabs(0), 0)
ftest(self, "fabs(1)", fabs(1), 1)
end

function testFactorial(self)
@test (factorial(0) == 1)
total = 1
for i in 1:999
total *= i
@test (factorial(i) == total)
@test (factorial(i) == py_factorial(i))
end
@test_throws ValueError math.factorial(-1)
@test_throws ValueError math.factorial(-(10^100))
end

function testFactorialNonIntegers(self)
@test_throws TypeError math.factorial(5.0)
@test_throws TypeError math.factorial(5.2)
@test_throws TypeError math.factorial(-1.0)
@test_throws TypeError math.factorial(-1e+100)
@test_throws TypeError math.factorial(Decimal("5"))
@test_throws TypeError math.factorial(Decimal("5.2"))
@test_throws TypeError math.factorial("5")
end

function testFactorialHugeInputs(self)
@test_throws OverflowError math.factorial(10^100)
@test_throws TypeError math.factorial(1e+100)
end

function testFloor(self)
assertRaises(self, TypeError, math.floor)
assertEqual(self, int, type_(floor(0.5)))
assertEqual(self, floor(0.5), 0)
assertEqual(self, floor(1.0), 1)
assertEqual(self, floor(1.5), 1)
assertEqual(self, floor(-0.5), -1)
assertEqual(self, floor(-1.0), -1)
assertEqual(self, floor(-1.5), -2)
mutable struct TestFloor <: AbstractTestFloor

end
function __floor__(self)::Int64
return 42
end

mutable struct FloatFloor <: AbstractFloatFloor

end
function __floor__(self)::Int64
return 42
end

mutable struct TestNoFloor <: AbstractTestNoFloor

end

assertEqual(self, floor(TestFloor()), 42)
assertEqual(self, floor(FloatFloor()), 42)
assertEqual(self, floor(FloatLike(41.9)), 41)
assertRaises(self, TypeError, math.floor, TestNoFloor())
t = TestNoFloor()
t.__floor__ = () -> args
assertRaises(self, TypeError, math.floor, t)
assertRaises(self, TypeError, math.floor, t, 0)
end

function testFmod(self)
@test_throws TypeError math.fmod()
ftest(self, "fmod(10, 1)", fmod(10, 1), 0.0)
ftest(self, "fmod(10, 0.5)", fmod(10, 0.5), 0.0)
ftest(self, "fmod(10, 1.5)", fmod(10, 1.5), 1.0)
ftest(self, "fmod(-10, 1)", fmod(-10, 1), -0.0)
ftest(self, "fmod(-10, 0.5)", fmod(-10, 0.5), -0.0)
ftest(self, "fmod(-10, 1.5)", fmod(-10, 1.5), -1.0)
@test isnan(fmod(NAN, 1.0))
@test isnan(fmod(1.0, NAN))
@test isnan(fmod(NAN, NAN))
@test_throws ValueError math.fmod(1.0, 0.0)
@test_throws ValueError math.fmod(INF, 1.0)
@test_throws ValueError math.fmod(NINF, 1.0)
@test_throws ValueError math.fmod(INF, 0.0)
@test (fmod(3.0, INF) == 3.0)
@test (fmod(-3.0, INF) == -3.0)
@test (fmod(3.0, NINF) == 3.0)
@test (fmod(-3.0, NINF) == -3.0)
@test (fmod(0.0, 3.0) == 0.0)
@test (fmod(0.0, NINF) == 0.0)
end

function testFrexp(self)
@test_throws TypeError math.frexp()
function testfrexp(name, result, expected)
(mant, exp), (emant, eexp) = (result, expected)
if abs(mant - emant) > eps || exp !== eexp
fail(self, "%s returned %r, expected %r" % (name, result, expected))
end
end

testfrexp("frexp(-1)", frexp(-1), (-0.5, 1))
testfrexp("frexp(0)", frexp(0), (0, 0))
testfrexp("frexp(1)", frexp(1), (0.5, 1))
testfrexp("frexp(2)", frexp(2), (0.5, 2))
@test (frexp(INF)[1] == INF)
@test (frexp(NINF)[1] == NINF)
@test isnan(frexp(NAN)[1])
end

function testFsum(self)
mant_dig = float_info.mant_dig
etiny = float_info.min_exp - mant_dig
function msum(iterable)
#= Full precision summation.  Compute sum(iterable) without any
            intermediate accumulation of error.  Based on the 'lsum' function
            at http://code.activestate.com/recipes/393090/

             =#
tmant, texp = (0, 0)
for x in iterable
mant, exp = frexp(x)
mant, exp = (parse(Int, ldexp(mant, mant_dig)), exp - mant_dig)
if texp > exp
tmant <<= texp - exp
texp = exp
else
mant <<= exp - texp
end
tmant += mant
end
tail = max((length(bin(abs(tmant))) - 2) - mant_dig, etiny - texp)
if tail > 0
h = 1 << (tail - 1)
tmant = (tmant ÷ 2*h) + Bool(tmant & h && tmant & (3*h - 1))
texp += tail
end
return ldexp(tmant, texp)
end

test_values = [([], 0.0), ([0.0], 0.0), ([1e+100, 1.0, -1e+100, 1e-100, 1e+50, -1.0, -1e+50], 1e-100), ([2.0^53, -0.5, -(2.0^-54)], 2.0^53 - 1.0), ([2.0^53, 1.0, 2.0^-100], 2.0^53 + 2.0), ([2.0^53 + 10.0, 1.0, 2.0^-100], 2.0^53 + 12.0), ([2.0^53 - 4.0, 0.5, 2.0^-54], 2.0^53 - 3.0), ([1.0 / n for n in 1:1000], fromhex(float, "0x1.df11f45f4e61ap+2")), ([-1.0^n / n for n in 1:1000], fromhex(float, "-0x1.62a2af1bd3624p-1")), ([1e+16, 1.0, 1e-16], 1.0000000000000002e+16), ([1e+16 - 2.0, 1.0 - 2.0^-53, -(1e+16 - 2.0), -(1.0 - 2.0^-53)], 0.0), ([(2.0^n - 2.0^(n + 50)) + 2.0^(n + 52) for n in -1074:2:971] + [-(2.0^1022)], fromhex(float, "0x1.5555555555555p+970"))]
terms = [1.7^i for i in 0:1000]
append(test_values, ([terms[i + 2] - terms[i + 1] for i in 0:999] + [-(terms[1001])], -(terms[1])))
for (i, (vals, expected)) in enumerate(test_values)
try
actual = fsum(vals)
catch exn
if exn isa OverflowError
fail(self, "test %d failed: got OverflowError, expected %r for math.fsum(%.100r)" % (i, expected, vals))
end
if exn isa ValueError
fail(self, "test %d failed: got ValueError, expected %r for math.fsum(%.100r)" % (i, expected, vals))
end
end
@test (actual == expected)
end
for j in 0:999
vals = repeat([7, 1e+100, -7, -1e+100, -9e-20, 8e-20],10)
s = 0
for i in 0:199
v = gauss(0, random())^7 - s
s += v
push!(vals, v)
end
shuffle(vals)
s = msum(vals)
@test (msum(vals) == fsum(vals))
end
end

function testGcd(self)
gcd = math.gcd
@test (gcd(0, 0) == 0)
@test (gcd(1, 0) == 1)
@test (gcd(-1, 0) == 1)
@test (gcd(0, 1) == 1)
@test (gcd(0, -1) == 1)
@test (gcd(7, 1) == 1)
@test (gcd(7, -1) == 1)
@test (gcd(-23, 15) == 1)
@test (gcd(120, 84) == 12)
@test (gcd(84, -120) == 12)
@test (gcd(1216342683557601535506311712, 436522681849110124616458784) == 32)
x = 434610456570399902378880679233098819019853229470286994367836600566
y = 1064502245825115327754847244914921553977
for c in (652560, 576559230871654959816130551884856912003141446781646602790216406874)
a = x*c
b = y*c
@test (gcd(a, b) == c)
@test (gcd(b, a) == c)
@test (gcd(-(a), b) == c)
@test (gcd(b, -(a)) == c)
@test (gcd(a, -(b)) == c)
@test (gcd(-(b), a) == c)
@test (gcd(-(a), -(b)) == c)
@test (gcd(-(b), -(a)) == c)
end
@test (gcd() == 0)
@test (gcd(120) == 120)
@test (gcd(-120) == 120)
@test (gcd(120, 84, 102) == 6)
@test (gcd(120, 1, 84) == 1)
@test_throws TypeError gcd(120.0)
@test_throws TypeError gcd(120.0, 84)
@test_throws TypeError gcd(120, 84.0)
@test_throws TypeError gcd(120, 1, 84.0)
@test (gcd(MyIndexable(120), MyIndexable(84)) == 12)
end

function testHypot(self)
hypot = math.hypot
args = (math.e, math.pi, sqrt(2.0), gamma(3.5), sin(2.1))
for i in 0:length(args)
assertAlmostEqual(self, hypot(args[begin:i]...), sqrt(sum((s^2 for s in args[begin:i]))))
end
@test (hypot(12.0, 5.0) == 13.0)
@test (hypot(12, 5) == 13)
@test (hypot(Decimal(12), Decimal(5)) == 13)
@test (hypot(Fraction(12, 32), Fraction(5, 32)) == Fraction(13, 32))
@test (hypot(Bool(1), Bool(0), Bool(1), Bool(1)) == sqrt(3))
@test (hypot(0.0, 0.0) == 0.0)
@test (hypot(-10.5) == 10.5)
@test (hypot() == 0.0)
@test (1.0 == copysign(1.0, hypot(-0.0)))
@test (hypot(1.5, 1.5, 0.5) == hypot(1.5, 0.5, 1.5))
assertRaises(self, TypeError) do 
hypot(x = 1)
end
assertRaises(self, TypeError) do 
hypot(1.1, "string", 2.2)
end
int_too_big_for_float = 10^(sys.float_info.max_10_exp + 5)
assertRaises(self, (ValueError, OverflowError)) do 
hypot(1, int_too_big_for_float)
end
@test (hypot(INF) == INF)
@test (hypot(0, INF) == INF)
@test (hypot(10, INF) == INF)
@test (hypot(-10, INF) == INF)
@test (hypot(NAN, INF) == INF)
@test (hypot(INF, NAN) == INF)
@test (hypot(NINF, NAN) == INF)
@test (hypot(NAN, NINF) == INF)
@test (hypot(-(INF), INF) == INF)
@test (hypot(-(INF), -(INF)) == INF)
@test (hypot(10, -(INF)) == INF)
@test isnan(hypot(NAN))
@test isnan(hypot(0, NAN))
@test isnan(hypot(NAN, 10))
@test isnan(hypot(10, NAN))
@test isnan(hypot(NAN, NAN))
@test isnan(hypot(NAN))
fourthmax = FLOAT_MAX / 4.0
for n in 0:31
@test isclose(hypot([fourthmax]*n...), fourthmax*sqrt(n))
end
for exp in 0:31
scale = FLOAT_MIN / 2.0^exp
@test (hypot(4*scale, 3*scale) == 5*scale)
end
end

function testHypotAccuracy(self)
hypot = math.hypot
Decimal = decimal.Decimal
high_precision = Context(prec = 500)
for (hx, hy) in [("0x1.10e89518dca48p+29", "0x1.1970f7565b7efp+30"), ("0x1.10106eb4b44a2p+29", "0x1.ef0596cdc97f8p+29"), ("0x1.459c058e20bb7p+30", "0x1.993ca009b9178p+29"), ("0x1.378371ae67c0cp+30", "0x1.fbe6619854b4cp+29"), ("0x1.f4cd0574fb97ap+29", "0x1.50fe31669340ep+30"), ("0x1.494b2cdd3d446p+29", "0x1.212a5367b4c7cp+29"), ("0x1.f84e649f1e46dp+29", "0x1.1fa56bef8eec4p+30"), ("0x1.2e817edd3d6fap+30", "0x1.eb0814f1e9602p+29"), ("0x1.0d3a6e3d04245p+29", "0x1.32a62fea52352p+30"), ("0x1.888e19611bfc5p+29", "0x1.52b8e70b24353p+29"), ("0x1.538816d48a13fp+29", "0x1.7967c5ca43e16p+29"), ("0x1.57b47b7234530p+29", "0x1.74e2c7040e772p+29"), ("0x1.821b685e9b168p+30", "0x1.677dc1c1e3dc6p+29"), ("0x1.9e8247f67097bp+29", "0x1.24bd2dc4f4baep+29"), ("0x1.b73b59e0cb5f9p+29", "0x1.da899ab784a97p+28"), ("0x1.94a8d2842a7cfp+30", "0x1.326a51d4d8d8ap+30"), ("0x1.e930b9cd99035p+29", "0x1.5a1030e18dff9p+30"), ("0x1.1592bbb0e4690p+29", "0x1.a9c337b33fb9ap+29"), ("0x1.1243a50751fd4p+29", "0x1.a5a10175622d9p+29"), ("0x1.57a8596e74722p+30", "0x1.42d1af9d04da9p+30"), ("0x1.ee7dbd9565899p+29", "0x1.7ab4d6fc6e4b4p+29"), ("0x1.5c6bfbec5c4dcp+30", "0x1.02511184b4970p+30"), ("0x1.59dcebba995cap+30", "0x1.50ca7e7c38854p+29"), ("0x1.768cdd94cf5aap+29", "0x1.9cfdc5571d38ep+29"), ("0x1.dcf137d60262ep+29", "0x1.1101621990b3ep+30"), ("0x1.3a2d006e288b0p+30", "0x1.e9a240914326cp+29"), ("0x1.62a32f7f53c61p+29", "0x1.47eb6cd72684fp+29"), ("0x1.d3bcb60748ef2p+29", "0x1.3f13c4056312cp+30"), ("0x1.282bdb82f17f3p+30", "0x1.640ba4c4eed3ap+30"), ("0x1.89d8c423ea0c6p+29", "0x1.d35dcfe902bc3p+29")]
x = fromhex(float, hx)
y = fromhex(float, hy)
subTest(self, hx = hx, hy = hy, x = x, y = y) do 
localcontext(high_precision) do 
z = float(sqrt(Decimal(x)^2 + Decimal(y)^2))
end
@test (hypot(x, y) == z)
end
end
end

function testDist(self)
dist = math.dist
sqrt = math.sqrt
assertEqual(self, dist((1.0, 2.0, 3.0), (4.0, 2.0, -1.0)), 5.0)
assertEqual(self, dist((1, 2, 3), (4, 2, -1)), 5.0)
for i in 0:8
for j in 0:4
p = tuple((uniform(-5, 5) for k in 0:i - 1)...)
q = tuple((uniform(-5, 5) for k in 0:i - 1)...)
assertAlmostEqual(self, dist(p, q), sqrt(sum(((px - qx)^2.0 for (px, qx) in zip(p, q)))))
end
end
assertEqual(self, dist([1.0, 2.0, 3.0], [4.0, 2.0, -1.0]), 5.0)
assertEqual(self, dist((x for x in [1.0, 2.0, 3.0]), (x for x in [4.0, 2.0, -1.0])), 5.0)
assertEqual(self, dist((14.0, 1.0), (2.0, -4.0)), 13.0)
assertEqual(self, dist((14, 1), (2, -4)), 13)
assertEqual(self, dist((D(14), D(1)), (D(2), D(-4))), D(13))
assertEqual(self, dist((F(14, 32), F(1, 32)), (F(2, 32), F(-4, 32))), F(13, 32))
assertEqual(self, dist((true, true, false, true, false), (true, false, true, true, false)), sqrt(2.0))
assertEqual(self, dist((13.25, 12.5, -3.25), (13.25, 12.5, -3.25)), 0.0)
assertEqual(self, dist((), ()), 0.0)
assertEqual(self, 1.0, copysign(1.0, dist((-0.0,), (0.0,))))
assertEqual(self, 1.0, copysign(1.0, dist((0.0,), (-0.0,))))
assertEqual(self, dist((1.5, 1.5, 0.5), (0, 0, 0)), dist((1.5, 0.5, 1.5), (0, 0, 0)))
mutable struct T <: AbstractT

end

assertEqual(self, dist(T((1, 2, 3)), (4, 2, -1)), 5.0)
assertRaises(self, TypeError) do 
dist(p = (1, 2, 3), q = (4, 5, 6))
end
assertRaises(self, TypeError) do 
dist((1, 2, 3))
end
assertRaises(self, TypeError) do 
dist((1, 2, 3), (4, 5, 6), (7, 8, 9))
end
assertRaises(self, TypeError) do 
dist(1, 2)
end
assertRaises(self, TypeError) do 
dist((1.1, "string", 2.2), (1, 2, 3))
end
assertRaises(self, ValueError) do 
dist((1, 2, 3, 4), (5, 6, 7))
end
assertRaises(self, ValueError) do 
dist((1, 2, 3), (4, 5, 6, 7))
end
assertRaises(self, TypeError) do 
dist("abc", "xyz")
end
int_too_big_for_float = 10^(sys.float_info.max_10_exp + 5)
assertRaises(self, (ValueError, OverflowError)) do 
dist((1, int_too_big_for_float), (2, 3))
end
assertRaises(self, (ValueError, OverflowError)) do 
dist((2, 3), (1, int_too_big_for_float))
end
for i in 0:19
p, q = (random(), random())
assertEqual(self, dist((p,), (q,)), abs(p - q))
end
values = [NINF, -10.5, -0.0, 0.0, 10.5, INF, NAN]
for p in product(values, repeat = 3)
for q in product(values, repeat = 3)
diffs = [px - qx for (px, qx) in zip(p, q)]
if any(map(math.isinf, diffs))
assertEqual(self, dist(p, q), INF)
elseif any(map(math.isnan, diffs))
assertTrue(self, isnan(dist(p, q)))
end
end
end
fourthmax = FLOAT_MAX / 4.0
for n in 0:31
p = (fourthmax,)*n
q = (0.0,)*n
assertTrue(self, isclose(dist(p, q), fourthmax*sqrt(n)))
assertTrue(self, isclose(dist(q, p), fourthmax*sqrt(n)))
end
for exp in 0:31
scale = FLOAT_MIN / 2.0^exp
p = (4*scale, 3*scale)
q = (0.0, 0.0)
assertEqual(self, dist(p, q), 5*scale)
assertEqual(self, dist(q, p), 5*scale)
end
end

function testIsqrt(self)
test_values = append!((append!(collect(0:999), collect(10^6:10^6)) + [2^e + i for e in 60:199 for i in -40:39]), [3^9999, 10^5001])
for value in test_values
subTest(self, value = value) do 
s = isqrt(value)
assertIs(self, type_(s), int)
assertLessEqual(self, s*s, value)
assertLess(self, value, (s + 1)*(s + 1))
end
end
assertRaises(self, ValueError) do 
isqrt(-1)
end
s = isqrt(true)
assertIs(self, type_(s), int)
assertEqual(self, s, 1)
s = isqrt(false)
assertIs(self, type_(s), int)
assertEqual(self, s, 0)
mutable struct IntegerLike <: AbstractIntegerLike
value
end
function __index__(self)
return self.value
end

s = isqrt(IntegerLike(1729))
assertIs(self, type_(s), int)
assertEqual(self, s, 41)
assertRaises(self, ValueError) do 
isqrt(IntegerLike(-3))
end
bad_values = [3.5, "a string", Decimal("3.5"), 3.5im, 100.0, -4.0]
for value in bad_values
subTest(self, value = value) do 
assertRaises(self, TypeError) do 
isqrt(value)
end
end
end
end

function test_lcm(self)
lcm = math.lcm
@test (lcm(0, 0) == 0)
@test (lcm(1, 0) == 0)
@test (lcm(-1, 0) == 0)
@test (lcm(0, 1) == 0)
@test (lcm(0, -1) == 0)
@test (lcm(7, 1) == 7)
@test (lcm(7, -1) == 7)
@test (lcm(-23, 15) == 345)
@test (lcm(120, 84) == 840)
@test (lcm(84, -120) == 840)
@test (lcm(1216342683557601535506311712, 436522681849110124616458784) == 16592536571065866494401400422922201534178938447014944)
x = 43461045657039990237
y = 10645022458251153277
for c in (652560, 57655923087165495981)
a = x*c
b = y*c
d = x*y*c
@test (lcm(a, b) == d)
@test (lcm(b, a) == d)
@test (lcm(-(a), b) == d)
@test (lcm(b, -(a)) == d)
@test (lcm(a, -(b)) == d)
@test (lcm(-(b), a) == d)
@test (lcm(-(a), -(b)) == d)
@test (lcm(-(b), -(a)) == d)
end
@test (lcm() == 1)
@test (lcm(120) == 120)
@test (lcm(-120) == 120)
@test (lcm(120, 84, 102) == 14280)
@test (lcm(120, 0, 84) == 0)
@test_throws TypeError lcm(120.0)
@test_throws TypeError lcm(120.0, 84)
@test_throws TypeError lcm(120, 84.0)
@test_throws TypeError lcm(120, 0, 84.0)
@test (lcm(MyIndexable(120), MyIndexable(84)) == 840)
end

function testLdexp(self)
@test_throws TypeError math.ldexp()
ftest(self, "ldexp(0,1)", ldexp(0, 1), 0)
ftest(self, "ldexp(1,1)", ldexp(1, 1), 2)
ftest(self, "ldexp(1,-1)", ldexp(1, -1), 0.5)
ftest(self, "ldexp(-1,1)", ldexp(-1, 1), -2)
@test_throws OverflowError math.ldexp(1.0, 1000000)
@test_throws OverflowError math.ldexp(-1.0, 1000000)
@test (ldexp(1.0, -1000000) == 0.0)
@test (ldexp(-1.0, -1000000) == -0.0)
@test (ldexp(INF, 30) == INF)
@test (ldexp(NINF, -213) == NINF)
@test isnan(ldexp(NAN, 0))
for n in [10^5, 10^10, 10^20, 10^40]
@test (ldexp(INF, -(n)) == INF)
@test (ldexp(NINF, -(n)) == NINF)
@test (ldexp(1.0, -(n)) == 0.0)
@test (ldexp(-1.0, -(n)) == -0.0)
@test (ldexp(0.0, -(n)) == 0.0)
@test (ldexp(-0.0, -(n)) == -0.0)
@test isnan(ldexp(NAN, -(n)))
@test_throws OverflowError math.ldexp(1.0, n)
@test_throws OverflowError math.ldexp(-1.0, n)
@test (ldexp(0.0, n) == 0.0)
@test (ldexp(-0.0, n) == -0.0)
@test (ldexp(INF, n) == INF)
@test (ldexp(NINF, n) == NINF)
@test isnan(ldexp(NAN, n))
end
end

function testLog(self)
@test_throws TypeError math.log()
ftest(self, "log(1/e)", log(1 / math.e), -1)
ftest(self, "log(1)", log(1), 0)
ftest(self, "log(e)", log(math.e), 1)
ftest(self, "log(32,2)", log(32, 2), 5)
ftest(self, "log(10**40, 10)", log(10^40, 10), 40)
ftest(self, "log(10**40, 10**20)", log(10^40, 10^20), 2)
ftest(self, "log(10**1000)", log(10^1000), 2302.5850929940457)
@test_throws ValueError math.log(-1.5)
@test_throws ValueError math.log(-(10^1000))
@test_throws ValueError math.log(NINF)
@test (log(INF) == INF)
@test isnan(log(NAN))
end

function testLog1p(self)
@test_throws TypeError math.log1p()
for n in [2, 2^90, 2^300]
assertAlmostEqual(self, log1p(n), log1p(float(n)))
end
@test_throws ValueError math.log1p(-1)
@test (log1p(INF) == INF)
end

function testLog2(self)
@test_throws TypeError math.log2()
@test (log2(1) == 0.0)
@test (log2(2) == 1.0)
@test (log2(4) == 2.0)
@test (log2(2^1023) == 1023.0)
@test (log2(2^1024) == 1024.0)
@test (log2(2^2000) == 2000.0)
@test_throws ValueError math.log2(-1.5)
@test_throws ValueError math.log2(NINF)
@test isnan(log2(NAN))
end

function testLog2Exact(self)
actual = [log2(ldexp(1.0, n)) for n in -1074:1023]
expected = [float(n) for n in -1074:1023]
@test (actual == expected)
end

function testLog10(self)
@test_throws TypeError math.log10()
ftest(self, "log10(0.1)", log10(0.1), -1)
ftest(self, "log10(1)", log10(1), 0)
ftest(self, "log10(10)", log10(10), 1)
ftest(self, "log10(10**1000)", log10(10^1000), 1000.0)
@test_throws ValueError math.log10(-1.5)
@test_throws ValueError math.log10(-(10^1000))
@test_throws ValueError math.log10(NINF)
@test (log(INF) == INF)
@test isnan(log10(NAN))
end

function testModf(self)
@test_throws TypeError math.modf()
function testmodf(name, result, expected)
(v1, v2), (e1, e2) = (result, expected)
if abs(v1 - e1) > eps || abs(v2 - e2)
fail(self, "%s returned %r, expected %r" % (name, result, expected))
end
end

testmodf("modf(1.5)", modf(1.5), (0.5, 1.0))
testmodf("modf(-1.5)", modf(-1.5), (-0.5, -1.0))
@test (modf(INF) == (0.0, INF))
@test (modf(NINF) == (-0.0, NINF))
modf_nan = modf(NAN)
@test isnan(modf_nan[1])
@test isnan(modf_nan[2])
end

function testPow(self)
@test_throws TypeError math.pow()
ftest(self, "pow(0,1)", pow(0, 1), 0)
ftest(self, "pow(1,0)", pow(1, 0), 1)
ftest(self, "pow(2,1)", pow(2, 1), 2)
ftest(self, "pow(2,-1)", pow(2, -1), 0.5)
@test (pow(INF, 1) == INF)
@test (pow(NINF, 1) == NINF)
@test (pow(1, INF) == 1.0)
@test (pow(1, NINF) == 1.0)
@test isnan(pow(NAN, 1))
@test isnan(pow(2, NAN))
@test isnan(pow(0, NAN))
@test (pow(1, NAN) == 1)
@test (pow(0.0, INF) == 0.0)
@test (pow(0.0, 3.0) == 0.0)
@test (pow(0.0, 2.3) == 0.0)
@test (pow(0.0, 2.0) == 0.0)
@test (pow(0.0, 0.0) == 1.0)
@test (pow(0.0, -0.0) == 1.0)
@test_throws ValueError math.pow(0.0, -2.0)
@test_throws ValueError math.pow(0.0, -2.3)
@test_throws ValueError math.pow(0.0, -3.0)
@test_throws ValueError math.pow(0.0, NINF)
@test isnan(pow(0.0, NAN))
@test (pow(INF, INF) == INF)
@test (pow(INF, 3.0) == INF)
@test (pow(INF, 2.3) == INF)
@test (pow(INF, 2.0) == INF)
@test (pow(INF, 0.0) == 1.0)
@test (pow(INF, -0.0) == 1.0)
@test (pow(INF, -2.0) == 0.0)
@test (pow(INF, -2.3) == 0.0)
@test (pow(INF, -3.0) == 0.0)
@test (pow(INF, NINF) == 0.0)
@test isnan(pow(INF, NAN))
@test (pow(-0.0, INF) == 0.0)
@test (pow(-0.0, 3.0) == -0.0)
@test (pow(-0.0, 2.3) == 0.0)
@test (pow(-0.0, 2.0) == 0.0)
@test (pow(-0.0, 0.0) == 1.0)
@test (pow(-0.0, -0.0) == 1.0)
@test_throws ValueError math.pow(-0.0, -2.0)
@test_throws ValueError math.pow(-0.0, -2.3)
@test_throws ValueError math.pow(-0.0, -3.0)
@test_throws ValueError math.pow(-0.0, NINF)
@test isnan(pow(-0.0, NAN))
@test (pow(NINF, INF) == INF)
@test (pow(NINF, 3.0) == NINF)
@test (pow(NINF, 2.3) == INF)
@test (pow(NINF, 2.0) == INF)
@test (pow(NINF, 0.0) == 1.0)
@test (pow(NINF, -0.0) == 1.0)
@test (pow(NINF, -2.0) == 0.0)
@test (pow(NINF, -2.3) == 0.0)
@test (pow(NINF, -3.0) == -0.0)
@test (pow(NINF, NINF) == 0.0)
@test isnan(pow(NINF, NAN))
@test (pow(-1.0, INF) == 1.0)
@test (pow(-1.0, 3.0) == -1.0)
@test_throws ValueError math.pow(-1.0, 2.3)
@test (pow(-1.0, 2.0) == 1.0)
@test (pow(-1.0, 0.0) == 1.0)
@test (pow(-1.0, -0.0) == 1.0)
@test (pow(-1.0, -2.0) == 1.0)
@test_throws ValueError math.pow(-1.0, -2.3)
@test (pow(-1.0, -3.0) == -1.0)
@test (pow(-1.0, NINF) == 1.0)
@test isnan(pow(-1.0, NAN))
@test (pow(1.0, INF) == 1.0)
@test (pow(1.0, 3.0) == 1.0)
@test (pow(1.0, 2.3) == 1.0)
@test (pow(1.0, 2.0) == 1.0)
@test (pow(1.0, 0.0) == 1.0)
@test (pow(1.0, -0.0) == 1.0)
@test (pow(1.0, -2.0) == 1.0)
@test (pow(1.0, -2.3) == 1.0)
@test (pow(1.0, -3.0) == 1.0)
@test (pow(1.0, NINF) == 1.0)
@test (pow(1.0, NAN) == 1.0)
@test (pow(2.3, 0.0) == 1.0)
@test (pow(-2.3, 0.0) == 1.0)
@test (pow(NAN, 0.0) == 1.0)
@test (pow(2.3, -0.0) == 1.0)
@test (pow(-2.3, -0.0) == 1.0)
@test (pow(NAN, -0.0) == 1.0)
@test_throws ValueError math.pow(-1.0, 2.3)
@test_throws ValueError math.pow(-15.0, -3.1)
@test (pow(1.9, NINF) == 0.0)
@test (pow(1.1, NINF) == 0.0)
@test (pow(0.9, NINF) == INF)
@test (pow(0.1, NINF) == INF)
@test (pow(-0.1, NINF) == INF)
@test (pow(-0.9, NINF) == INF)
@test (pow(-1.1, NINF) == 0.0)
@test (pow(-1.9, NINF) == 0.0)
@test (pow(1.9, INF) == INF)
@test (pow(1.1, INF) == INF)
@test (pow(0.9, INF) == 0.0)
@test (pow(0.1, INF) == 0.0)
@test (pow(-0.1, INF) == 0.0)
@test (pow(-0.9, INF) == 0.0)
@test (pow(-1.1, INF) == INF)
@test (pow(-1.9, INF) == INF)
ftest(self, "(-2.)**3.", pow(-2.0, 3.0), -8.0)
ftest(self, "(-2.)**2.", pow(-2.0, 2.0), 4.0)
ftest(self, "(-2.)**1.", pow(-2.0, 1.0), -2.0)
ftest(self, "(-2.)**0.", pow(-2.0, 0.0), 1.0)
ftest(self, "(-2.)**-0.", pow(-2.0, -0.0), 1.0)
ftest(self, "(-2.)**-1.", pow(-2.0, -1.0), -0.5)
ftest(self, "(-2.)**-2.", pow(-2.0, -2.0), 0.25)
ftest(self, "(-2.)**-3.", pow(-2.0, -3.0), -0.125)
@test_throws ValueError math.pow(-2.0, -0.5)
@test_throws ValueError math.pow(-2.0, 0.5)
end

function testRadians(self)
@test_throws TypeError math.radians()
ftest(self, "radians(180)", radians(180), math.pi)
ftest(self, "radians(90)", radians(90), math.pi / 2)
ftest(self, "radians(-45)", radians(-45), -(math.pi) / 4)
ftest(self, "radians(0)", radians(0), 0)
end

function testRemainder(self)
function validate_spec(x, y, r)
#= 
            Check that r matches remainder(x, y) according to the IEEE 754
            specification. Assumes that x, y and r are finite and y is nonzero.
             =#
fx, fy, fr = (Fraction(x), Fraction(y), Fraction(r))
assertLessEqual(self, abs(fr), abs(fy / 2))
n = (fx - fr) / fy
@test (n == parse(Int, n))
if abs(fr) == abs(fy / 2)
@test (n / 2 == parse(Int, n / 2))
end
end

testcases = ["-4.0 1 -0.0", "-3.8 1  0.8", "-3.0 1 -0.0", "-2.8 1 -0.8", "-2.0 1 -0.0", "-1.8 1  0.8", "-1.0 1 -0.0", "-0.8 1 -0.8", "-0.0 1 -0.0", " 0.0 1  0.0", " 0.8 1  0.8", " 1.0 1  0.0", " 1.8 1 -0.8", " 2.0 1  0.0", " 2.8 1  0.8", " 3.0 1  0.0", " 3.8 1 -0.8", " 4.0 1  0.0", "0x0.0p+0 0x1.921fb54442d18p+2 0x0.0p+0", "0x1.921fb54442d18p+0 0x1.921fb54442d18p+2  0x1.921fb54442d18p+0", "0x1.921fb54442d17p+1 0x1.921fb54442d18p+2  0x1.921fb54442d17p+1", "0x1.921fb54442d18p+1 0x1.921fb54442d18p+2  0x1.921fb54442d18p+1", "0x1.921fb54442d19p+1 0x1.921fb54442d18p+2 -0x1.921fb54442d17p+1", "0x1.921fb54442d17p+2 0x1.921fb54442d18p+2 -0x0.0000000000001p+2", "0x1.921fb54442d18p+2 0x1.921fb54442d18p+2  0x0p0", "0x1.921fb54442d19p+2 0x1.921fb54442d18p+2  0x0.0000000000001p+2", "0x1.2d97c7f3321d1p+3 0x1.921fb54442d18p+2  0x1.921fb54442d14p+1", "0x1.2d97c7f3321d2p+3 0x1.921fb54442d18p+2 -0x1.921fb54442d18p+1", "0x1.2d97c7f3321d3p+3 0x1.921fb54442d18p+2 -0x1.921fb54442d14p+1", "0x1.921fb54442d17p+3 0x1.921fb54442d18p+2 -0x0.0000000000001p+3", "0x1.921fb54442d18p+3 0x1.921fb54442d18p+2  0x0p0", "0x1.921fb54442d19p+3 0x1.921fb54442d18p+2  0x0.0000000000001p+3", "0x1.f6a7a2955385dp+3 0x1.921fb54442d18p+2  0x1.921fb54442d14p+1", "0x1.f6a7a2955385ep+3 0x1.921fb54442d18p+2  0x1.921fb54442d18p+1", "0x1.f6a7a2955385fp+3 0x1.921fb54442d18p+2 -0x1.921fb54442d14p+1", "0x1.1475cc9eedf00p+5 0x1.921fb54442d18p+2  0x1.921fb54442d10p+1", "0x1.1475cc9eedf01p+5 0x1.921fb54442d18p+2 -0x1.921fb54442d10p+1", " 1  0.c  0.4", "-1  0.c -0.4", " 1 -0.c  0.4", "-1 -0.c -0.4", " 1.4  0.c -0.4", "-1.4  0.c  0.4", " 1.4 -0.c -0.4", "-1.4 -0.c  0.4", "0x1.dp+1023 0x1.4p+1023  0x0.9p+1023", "0x1.ep+1023 0x1.4p+1023 -0x0.ap+1023", "0x1.fp+1023 0x1.4p+1023 -0x0.9p+1023"]
for case in testcases
subTest(self, case = case) do 
x_hex, y_hex, expected_hex = split(case)
x = fromhex(float, x_hex)
y = fromhex(float, y_hex)
expected = fromhex(float, expected_hex)
validate_spec(x, y, expected)
actual = remainder(x, y)
@test (hex(actual) == hex(expected))
end
end
tiny = fromhex(float, "1p-1074")
for n in -25:24
if n == 0
continue;
end
y = n*tiny
for m in 0:99
x = m*tiny
actual = remainder(x, y)
validate_spec(x, y, actual)
actual = remainder(-(x), y)
validate_spec(-(x), y, actual)
end
end
for value in [NAN, 0.0, -0.0, 2.0, -2.3, NINF, INF]
assertIsNaN(self, remainder(NAN, value))
assertIsNaN(self, remainder(value, NAN))
end
for value in [-2.3, -0.0, 0.0, 2.3]
@test (remainder(value, INF) == value)
@test (remainder(value, NINF) == value)
end
for value in [NINF, -2.3, -0.0, 0.0, 2.3, INF]
assertRaises(self, ValueError) do 
remainder(INF, value)
end
assertRaises(self, ValueError) do 
remainder(NINF, value)
end
assertRaises(self, ValueError) do 
remainder(value, 0.0)
end
assertRaises(self, ValueError) do 
remainder(value, -0.0)
end
end
end

function testSin(self)
@test_throws TypeError math.sin()
ftest(self, "sin(0)", sin(0), 0)
ftest(self, "sin(pi/2)", sin(math.pi / 2), 1)
ftest(self, "sin(-pi/2)", sin(-(math.pi) / 2), -1)
try
@test isnan(sin(INF))
@test isnan(sin(NINF))
catch exn
if exn isa ValueError
@test_throws ValueError math.sin(INF)
@test_throws ValueError math.sin(NINF)
end
end
@test isnan(sin(NAN))
end

function testSinh(self)
@test_throws TypeError math.sinh()
ftest(self, "sinh(0)", sinh(0), 0)
ftest(self, "sinh(1)**2-cosh(1)**2", sinh(1)^2 - cosh(1)^2, -1)
ftest(self, "sinh(1)+sinh(-1)", sinh(1) + sinh(-1), 0)
@test (sinh(INF) == INF)
@test (sinh(NINF) == NINF)
@test isnan(sinh(NAN))
end

function testSqrt(self)
@test_throws TypeError math.sqrt()
ftest(self, "sqrt(0)", sqrt(0), 0)
ftest(self, "sqrt(1)", sqrt(1), 1)
ftest(self, "sqrt(4)", sqrt(4), 2)
@test (sqrt(INF) == INF)
@test_throws ValueError math.sqrt(-1)
@test_throws ValueError math.sqrt(NINF)
@test isnan(sqrt(NAN))
end

function testTan(self)
@test_throws TypeError math.tan()
ftest(self, "tan(0)", tan(0), 0)
ftest(self, "tan(pi/4)", tan(math.pi / 4), 1)
ftest(self, "tan(-pi/4)", tan(-(math.pi) / 4), -1)
try
@test isnan(tan(INF))
@test isnan(tan(NINF))
catch exn
@test_throws ValueError math.tan(INF)
@test_throws ValueError math.tan(NINF)
end
@test isnan(tan(NAN))
end

function testTanh(self)
@test_throws TypeError math.tanh()
ftest(self, "tanh(0)", tanh(0), 0)
ftest(self, "tanh(1)+tanh(-1)", tanh(1) + tanh(-1), 0)
ftest(self, "tanh(inf)", tanh(INF), 1)
ftest(self, "tanh(-inf)", tanh(NINF), -1)
@test isnan(tanh(NAN))
end

function testTanhSign(self)
@test (tanh(-0.0) == -0.0)
@test (copysign(1.0, tanh(-0.0)) == copysign(1.0, -0.0))
end

function test_trunc(self)
assertEqual(self, trunc(1), 1)
assertEqual(self, trunc(-1), -1)
assertEqual(self, type_(trunc(1)), int)
assertEqual(self, type_(trunc(1.5)), int)
assertEqual(self, trunc(1.5), 1)
assertEqual(self, trunc(-1.5), -1)
assertEqual(self, trunc(1.999999), 1)
assertEqual(self, trunc(-1.999999), -1)
assertEqual(self, trunc(-0.999999), -0)
assertEqual(self, trunc(-100.999), -100)
mutable struct TestTrunc <: AbstractTestTrunc

end
function __trunc__(self)::Int64
return 23
end

mutable struct FloatTrunc <: AbstractFloatTrunc

end
function __trunc__(self)::Int64
return 23
end

mutable struct TestNoTrunc <: AbstractTestNoTrunc

end

assertEqual(self, trunc(TestTrunc()), 23)
assertEqual(self, trunc(FloatTrunc()), 23)
assertRaises(self, TypeError, math.trunc)
assertRaises(self, TypeError, math.trunc, 1, 2)
assertRaises(self, TypeError, math.trunc, FloatLike(23.5))
assertRaises(self, TypeError, math.trunc, TestNoTrunc())
end

function testIsfinite(self)
@test isfinite(0.0)
@test isfinite(-0.0)
@test isfinite(1.0)
@test isfinite(-1.0)
@test !(isfinite(float("nan")))
@test !(isfinite(float("inf")))
@test !(isfinite(float("-inf")))
end

function testIsnan(self)
@test isnan(float("nan"))
@test isnan(float("-nan"))
@test isnan(float("inf")*0.0)
@test !(isnan(float("inf")))
@test !(isnan(0.0))
@test !(isnan(1.0))
end

function testIsinf(self)
@test isinf(float("inf"))
@test isinf(float("-inf"))
@test isinf(inf)
@test isinf(-inf)
@test !(isinf(float("nan")))
@test !(isinf(0.0))
@test !(isinf(1.0))
end

function test_nan_constant(self)
@test isnan(math.nan)
end

function test_inf_constant(self)
@test isinf(math.inf)
assertGreater(self, math.inf, 0.0)
@test (math.inf == float("inf"))
@test (-(math.inf) == float("-inf"))
end

function test_exceptions(self)
try
x = exp(-1000000000)
catch exn
fail(self, "underflowing exp() should not have raised an exception")
end
if x !== 0
fail(self, "underflowing exp() should have returned 0")
end
try
x = exp(1000000000)
catch exn
if exn isa OverflowError
#= pass =#
end
end
try
x = sqrt(-1.0)
catch exn
if exn isa ValueError
#= pass =#
end
end
end

function test_testfile(self)
SKIP_ON_TIGER = Set(["tan0064"])
osx_version = nothing
if sys.platform == "darwin"
version_txt = mac_ver()[1]
try
osx_version = tuple(map(int, split(version_txt, ".")))
catch exn
if exn isa ValueError
#= pass =#
end
end
end
fail_fmt = "{}: {}({!r}): {}"
failures = []
for (id, fn, ar, ai, er, ei, flags) in parse_testfile(test_file)
if ai != 0.0 || ei != 0.0
continue;
end
if fn ∈ ["rect", "polar"]
continue;
end
if osx_version !== nothing && osx_version < (10, 5)
if id ∈ SKIP_ON_TIGER
continue;
end
end
func = getfield(math, :fn)
if "invalid" ∈ flags || "divide-by-zero" ∈ flags
er = "ValueError"
elseif "overflow" ∈ flags
er = "OverflowError"
end
try
result = func(ar)
catch exn
if exn isa ValueError
result = "ValueError"
end
if exn isa OverflowError
result = "OverflowError"
end
end
ulp_tol, abs_tol = (5, 0.0)
failure = result_check(er, result, ulp_tol, abs_tol)
if failure === nothing
continue;
end
msg = fail_fmt
push!(failures, msg)
end
if failures
fail(self, "Failures in test_testfile:\n  " + join(failures, "\n  "))
end
end

function test_mtestfile(self)
fail_fmt = "{}: {}({!r}): {}"
failures = []
for (id, fn, arg, expected, flags) in parse_mtestfile(math_testcases)
func = getfield(math, :fn)
if "invalid" ∈ flags || "divide-by-zero" ∈ flags
expected = "ValueError"
elseif "overflow" ∈ flags
expected = "OverflowError"
end
try
got = func(arg)
catch exn
if exn isa ValueError
got = "ValueError"
end
if exn isa OverflowError
got = "OverflowError"
end
end
ulp_tol, abs_tol = (5, 0.0)
if fn == "gamma"
ulp_tol = 20
elseif fn == "lgamma"
abs_tol = 1e-15
elseif fn == "erfc" && arg >= 0.0
if arg < 1.0
ulp_tol = 10
elseif arg < 10.0
ulp_tol = 100
else
ulp_tol = 1000
end
end
failure = result_check(expected, got, ulp_tol, abs_tol)
if failure === nothing
continue;
end
msg = fail_fmt
push!(failures, msg)
end
if failures
fail(self, "Failures in test_mtestfile:\n  " + join(failures, "\n  "))
end
end

function test_prod(self)
prod = math.prod
@test (prod([]) == 1)
@test (prod([], start = 5) == 5)
@test (prod(collect(2:7)) == 5040)
@test (prod((x for x in collect(2:7))) == 5040)
@test (prod(1:9, start = 10) == 3628800)
@test (prod([1, 2, 3, 4, 5]) == 120)
@test (prod([1.0, 2.0, 3.0, 4.0, 5.0]) == 120.0)
@test (prod([1, 2, 3, 4.0, 5.0]) == 120.0)
@test (prod([1.0, 2.0, 3.0, 4, 5]) == 120.0)
@test (prod([1, 1, 2^32, 1, 1]) == 2^32)
@test (prod([1.0, 1.0, 2^32, 1, 1]) == float(2^32))
@test_throws TypeError prod()
@test_throws TypeError prod(42)
@test_throws TypeError prod(["a", "b", "c"])
@test_throws TypeError prod(["a", "b", "c"], start = "")
@test_throws TypeError prod([b"a", b"c"], start = b"")
values = [Vector{UInt8}(b"a"), Vector{UInt8}(b"b")]
@test_throws TypeError prod(values, start = Vector{UInt8}(b""))
@test_throws TypeError prod([[1], [2], [3]])
@test_throws TypeError prod([Dict(2 => 3)])
@test_throws TypeError prod(repeat([Dict(2 => 3)],2), start = Dict(2 => 3))
@test_throws TypeError prod([[1], [2], [3]], start = [])
@test (prod([2, 3], start = "ab") == "abababababab")
@test (prod([2, 3], start = [1, 2]) == [1, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2])
@test (prod([], start = Dict(2 => 3)) == Dict(2 => 3))
assertRaises(self, TypeError) do 
prod([10, 20], 1)
end
@test (prod([0, 1, 2, 3]) == 0)
@test (prod([1, 0, 2, 3]) == 0)
@test (prod([1, 2, 3, 0]) == 0)
function _naive_prod(iterable, start = 1)
for elem in iterable
start *= elem
end
return start
end

iterable = 1:9999
@test (prod(iterable) == _naive_prod(iterable))
iterable = -10000:0
@test (prod(iterable) == _naive_prod(iterable))
iterable = -1000:999
@test (prod(iterable) == 0)
iterable = [float(x) for x in 1:999]
@test (prod(iterable) == _naive_prod(iterable))
iterable = [float(x) for x in -1000:0]
@test (prod(iterable) == _naive_prod(iterable))
iterable = [float(x) for x in -1000:999]
assertIsNaN(self, prod(iterable))
assertIsNaN(self, prod([1, 2, 3, float("nan"), 2, 3]))
assertIsNaN(self, prod([1, 0, float("nan"), 2, 3]))
assertIsNaN(self, prod([1, float("nan"), 0, 3]))
assertIsNaN(self, prod([1, float("inf"), float("nan"), 3]))
assertIsNaN(self, prod([1, float("-inf"), float("nan"), 3]))
assertIsNaN(self, prod([1, float("nan"), float("inf"), 3]))
assertIsNaN(self, prod([1, float("nan"), float("-inf"), 3]))
@test (prod([1, 2, 3, float("inf"), -3, 4]) == float("-inf"))
@test (prod([1, 2, 3, float("-inf"), -3, 4]) == float("inf"))
assertIsNaN(self, prod([1, 2, 0, float("inf"), -3, 4]))
assertIsNaN(self, prod([1, 2, 0, float("-inf"), -3, 4]))
assertIsNaN(self, prod([1, 2, 3, float("inf"), -3, 0, 3]))
assertIsNaN(self, prod([1, 2, 3, float("-inf"), -3, 0, 2]))
@test (type_(prod([1, 2, 3, 4, 5, 6])) == int)
@test (type_(prod([1, 2.0, 3, 4, 5, 6])) == float)
@test (type_(prod(1:9999)) == int)
@test (type_(prod(1:9999, start = 1.0)) == float)
@test (type_(prod([1, Decimal(2.0), 3, 4, 5, 6])) == decimal.Decimal)
end

function testPerm(self)
perm = math.perm
factorial = math.factorial
for n in 0:99
for k in 0:n
@test (perm(n, k) == factorial(n) ÷ factorial(n - k))
end
end
for n in 1:99
for k in 1:n - 1
@test (perm(n, k) == perm(n - 1, k - 1)*k + perm(n - 1, k))
end
end
for n in 1:99
@test (perm(n, 0) == 1)
@test (perm(n, 1) == n)
@test (perm(n, n) == factorial(n))
end
for n in 0:19
@test (perm(n) == factorial(n))
@test (perm(n, nothing) == factorial(n))
end
@test_throws TypeError perm(10, 1.0)
@test_throws TypeError perm(10, Decimal(1.0))
@test_throws TypeError perm(10, "1")
@test_throws TypeError perm(10.0, 1)
@test_throws TypeError perm(Decimal(10.0), 1)
@test_throws TypeError perm("10", 1)
@test_throws TypeError perm()
@test_throws TypeError perm(10, 1, 3)
@test_throws TypeError perm()
@test_throws ValueError perm(-1, 1)
@test_throws ValueError perm(-(2^1000), 1)
@test_throws ValueError perm(1, -1)
@test_throws ValueError perm(1, -(2^1000))
@test (perm(1, 2) == 0)
@test (perm(1, 2^1000) == 0)
n = 2^1000
@test (perm(n, 0) == 1)
@test (perm(n, 1) == n)
@test (perm(n, 2) == n*(n - 1))
if check_impl_detail(cpython = true)
@test_throws OverflowError perm(n, n)
end
for (n, k) in ((true, true), (true, false), (false, false))
@test (perm(n, k) == 1)
assertIs(self, type_(perm(n, k)), int)
end
@test (perm(IntSubclass(5), IntSubclass(2)) == 20)
@test (perm(MyIndexable(5), MyIndexable(2)) == 20)
for k in 0:2
assertIs(self, type_(perm(IntSubclass(5), IntSubclass(k))), int)
assertIs(self, type_(perm(MyIndexable(5), MyIndexable(k))), int)
end
end

function testComb(self)
comb = math.comb
factorial = math.factorial
for n in 0:99
for k in 0:n
@test (comb(n, k) == factorial(n) ÷ factorial(k)*factorial(n - k))
end
end
for n in 1:99
for k in 1:n - 1
@test (comb(n, k) == comb(n - 1, k - 1) + comb(n - 1, k))
end
end
for n in 0:99
@test (comb(n, 0) == 1)
@test (comb(n, n) == 1)
end
for n in 1:99
@test (comb(n, 1) == n)
@test (comb(n, n - 1) == n)
end
for n in 0:99
for k in 0:n ÷ 2
@test (comb(n, k) == comb(n, n - k))
end
end
@test_throws TypeError comb(10, 1.0)
@test_throws TypeError comb(10, Decimal(1.0))
@test_throws TypeError comb(10, "1")
@test_throws TypeError comb(10.0, 1)
@test_throws TypeError comb(Decimal(10.0), 1)
@test_throws TypeError comb("10", 1)
@test_throws TypeError comb(10)
@test_throws TypeError comb(10, 1, 3)
@test_throws TypeError comb()
@test_throws ValueError comb(-1, 1)
@test_throws ValueError comb(-(2^1000), 1)
@test_throws ValueError comb(1, -1)
@test_throws ValueError comb(1, -(2^1000))
@test (comb(1, 2) == 0)
@test (comb(1, 2^1000) == 0)
n = 2^1000
@test (comb(n, 0) == 1)
@test (comb(n, 1) == n)
@test (comb(n, 2) == n*(n - 1) ÷ 2)
@test (comb(n, n) == 1)
@test (comb(n, n - 1) == n)
@test (comb(n, n - 2) == n*(n - 1) ÷ 2)
if check_impl_detail(cpython = true)
@test_throws OverflowError comb(n, n ÷ 2)
end
for (n, k) in ((true, true), (true, false), (false, false))
@test (comb(n, k) == 1)
assertIs(self, type_(comb(n, k)), int)
end
@test (comb(IntSubclass(5), IntSubclass(2)) == 10)
@test (comb(MyIndexable(5), MyIndexable(2)) == 10)
for k in 0:2
assertIs(self, type_(comb(IntSubclass(5), IntSubclass(k))), int)
assertIs(self, type_(comb(MyIndexable(5), MyIndexable(k))), int)
end
end

function test_nextafter(self)
@test (nextafter(4503599627370496.0, -(INF)) == 4503599627370495.5)
@test (nextafter(4503599627370496.0, INF) == 4503599627370497.0)
@test (nextafter(9.223372036854776e+18, 0.0) == 9.223372036854775e+18)
@test (nextafter(-9.223372036854776e+18, 0.0) == -9.223372036854775e+18)
@test (nextafter(1.0, -(INF)) == fromhex(float, "0x1.fffffffffffffp-1"))
@test (nextafter(1.0, INF) == fromhex(float, "0x1.0000000000001p+0"))
@test (nextafter(2.0, 2.0) == 2.0)
assertEqualSign(self, nextafter(-0.0, +0.0), +0.0)
assertEqualSign(self, nextafter(+0.0, -0.0), -0.0)
smallest_subnormal = sys.float_info.min*sys.float_info.epsilon
@test (nextafter(+0.0, INF) == smallest_subnormal)
@test (nextafter(-0.0, INF) == smallest_subnormal)
@test (nextafter(+0.0, -(INF)) == -(smallest_subnormal))
@test (nextafter(-0.0, -(INF)) == -(smallest_subnormal))
assertEqualSign(self, nextafter(smallest_subnormal, +0.0), +0.0)
assertEqualSign(self, nextafter(-(smallest_subnormal), +0.0), -0.0)
assertEqualSign(self, nextafter(smallest_subnormal, -0.0), +0.0)
assertEqualSign(self, nextafter(-(smallest_subnormal), -0.0), -0.0)
largest_normal = sys.float_info.max
@test (nextafter(INF, 0.0) == largest_normal)
@test (nextafter(-(INF), 0.0) == -(largest_normal))
@test (nextafter(largest_normal, INF) == INF)
@test (nextafter(-(largest_normal), -(INF)) == -(INF))
assertIsNaN(self, nextafter(NAN, 1.0))
assertIsNaN(self, nextafter(1.0, NAN))
assertIsNaN(self, nextafter(NAN, NAN))
end

function test_ulp(self)
@test (ulp(1.0) == sys.float_info.epsilon)
@test (ulp(2^52) == 1.0)
@test (ulp(2^53) == 2.0)
@test (ulp(2^64) == 4096.0)
@test (ulp(0.0) == sys.float_info.min*sys.float_info.epsilon)
@test (ulp(FLOAT_MAX) == FLOAT_MAX - nextafter(FLOAT_MAX, -(INF)))
@test (ulp(INF) == INF)
assertIsNaN(self, ulp(math.nan))
for x in (0.0, 1.0, 2^52, 2^64, INF)
subTest(self, x = x) do 
@test (ulp(-(x)) == ulp(x))
end
end
end

function test_issue39871(self)
mutable struct F <: AbstractF
converted::Bool
end
function __float__(self)
self.converted = true
1 / 0
end

for func in (math.atan2, math.copysign, math.remainder)
y = F()
assertRaises(self, TypeError) do 
func("not a number", y)
end
assertFalse(self, (hasfield(typeof(y), :converted) ? 
                getfield(y, :converted) : false))
end
end

function assertIsNaN(self, value)
if !isnan(value)
fail(self, "Expected a NaN, got $(!r).")
end
end

function assertEqualSign(self, x, y)
#= Similar to assertEqual(), but compare also the sign with copysign().

        Function useful to compare signed zeros.
         =#
@test (x == y)
@test (copysign(1.0, x) == copysign(1.0, y))
end

mutable struct IsCloseTests <: AbstractIsCloseTests
isclose

                    IsCloseTests(isclose = math.isclose) =
                        new(isclose)
end
function assertIsClose(self, a, b)
@test isclose(self, a, b, args..., None = kwargs)
end

function assertIsNotClose(self, a, b)
@test !(isclose(self, a, b, args..., None = kwargs))
end

function assertAllClose(self, examples)
for (a, b) in examples
assertIsClose(self, a, b)
end
end

function assertAllNotClose(self, examples)
for (a, b) in examples
assertIsNotClose(self, a, b)
end
end

function test_negative_tolerances(self)
assertRaises(self, ValueError) do 
assertIsClose(self, 1, 1)
end
assertRaises(self, ValueError) do 
assertIsClose(self, 1, 1)
end
end

function test_identical(self)
identical_examples = [(2.0, 2.0), (1e+199, 1e+199), (1.123e-300, 1.123e-300), (12345, 12345.0), (0.0, -0.0), (345678, 345678)]
assertAllClose(self, identical_examples)
end

function test_eight_decimal_places(self)
eight_decimal_places_examples = [(100000000.0, 100000000.0 + 1), (-1e-08, -1.000000009e-08), (1.12345678, 1.12345679)]
assertAllClose(self, eight_decimal_places_examples)
assertAllNotClose(self, eight_decimal_places_examples)
end

function test_near_zero(self)
near_zero_examples = [(1e-09, 0.0), (-1e-09, 0.0), (-1e-150, 0.0)]
assertAllNotClose(self, near_zero_examples)
assertAllClose(self, near_zero_examples)
end

function test_identical_infinite(self)
assertIsClose(self, INF, INF)
assertIsClose(self, INF, INF)
assertIsClose(self, NINF, NINF)
assertIsClose(self, NINF, NINF)
end

function test_inf_ninf_nan(self)
not_close_examples = [(NAN, NAN), (NAN, 1e-100), (1e-100, NAN), (INF, NAN), (NAN, INF), (INF, NINF), (INF, 1.0), (1.0, INF), (INF, 1e+308), (1e+308, INF)]
assertAllNotClose(self, not_close_examples)
end

function test_zero_tolerance(self)
zero_tolerance_close_examples = [(1.0, 1.0), (-3.4, -3.4), (-1e-300, -1e-300)]
assertAllClose(self, zero_tolerance_close_examples)
zero_tolerance_not_close_examples = [(1.0, 1.000000000000001), (0.99999999999999, 1.0), (1e+200, 9.99999999999999e+199)]
assertAllNotClose(self, zero_tolerance_not_close_examples)
end

function test_asymmetry(self)
assertAllClose(self, [(9, 10), (10, 9)])
end

function test_integers(self)
integer_examples = [(100000001, 100000000), (123456789, 123456788)]
assertAllClose(self, integer_examples)
assertAllNotClose(self, integer_examples)
end

function test_decimals(self)
decimal_examples = [(Decimal("1.00000001"), Decimal("1.0")), (Decimal("1.00000001e-20"), Decimal("1.0e-20")), (Decimal("1.00000001e-100"), Decimal("1.0e-100")), (Decimal("1.00000001e20"), Decimal("1.0e20"))]
assertAllClose(self, decimal_examples)
assertAllNotClose(self, decimal_examples)
end

function test_fractions(self)
fraction_examples = [(Fraction(1, 100000000) + 1, Fraction(1)), (Fraction(100000001), Fraction(100000000)), (Fraction(10^8 + 1, 10^28), Fraction(1, 10^20))]
assertAllClose(self, fraction_examples)
assertAllNotClose(self, fraction_examples)
end

function test_main()
suite = TestSuite()
addTest(suite, makeSuite(MathTests))
addTest(suite, makeSuite(IsCloseTests))
addTest(suite, DocFileSuite("ieee754.txt"))
run_unittest(suite)
end

if abspath(PROGRAM_FILE) == @__FILE__
test_main()
math_tests = MathTests()
ftest(math_tests)
testConstants(math_tests)
testAcos(math_tests)
testAcosh(math_tests)
testAsin(math_tests)
testAsinh(math_tests)
testAtan(math_tests)
testAtanh(math_tests)
testAtan2(math_tests)
testCeil(math_tests)
testCopysign(math_tests)
testCos(math_tests)
testCosh(math_tests)
testDegrees(math_tests)
testExp(math_tests)
testFabs(math_tests)
testFactorial(math_tests)
testFactorialNonIntegers(math_tests)
testFactorialHugeInputs(math_tests)
testFloor(math_tests)
testFmod(math_tests)
testFrexp(math_tests)
testFsum(math_tests)
testGcd(math_tests)
testHypot(math_tests)
testHypotAccuracy(math_tests)
testDist(math_tests)
testIsqrt(math_tests)
test_lcm(math_tests)
testLdexp(math_tests)
testLog(math_tests)
testLog1p(math_tests)
testLog2(math_tests)
testLog2Exact(math_tests)
testLog10(math_tests)
testModf(math_tests)
testPow(math_tests)
testRadians(math_tests)
testRemainder(math_tests)
testSin(math_tests)
testSinh(math_tests)
testSqrt(math_tests)
testTan(math_tests)
testTanh(math_tests)
testTanhSign(math_tests)
test_trunc(math_tests)
testIsfinite(math_tests)
testIsnan(math_tests)
testIsinf(math_tests)
test_nan_constant(math_tests)
test_inf_constant(math_tests)
test_exceptions(math_tests)
test_testfile(math_tests)
test_mtestfile(math_tests)
test_prod(math_tests)
testPerm(math_tests)
testComb(math_tests)
test_nextafter(math_tests)
test_ulp(math_tests)
test_issue39871(math_tests)
assertIsNaN(math_tests)
assertEqualSign(math_tests)
is_close_tests = IsCloseTests()
assertIsClose(is_close_tests)
assertIsNotClose(is_close_tests)
assertAllClose(is_close_tests)
assertAllNotClose(is_close_tests)
test_negative_tolerances(is_close_tests)
test_identical(is_close_tests)
test_eight_decimal_places(is_close_tests)
test_near_zero(is_close_tests)
test_identical_infinite(is_close_tests)
test_inf_ninf_nan(is_close_tests)
test_zero_tolerance(is_close_tests)
test_asymmetry(is_close_tests)
test_integers(is_close_tests)
test_decimals(is_close_tests)
test_fractions(is_close_tests)
end