<<<<<<< HEAD
using Test

import locale
using _testcapi: FLT_MAX
import fractions


import random





using test.test_grammar: VALID_UNDERSCORE_LITERALS, INVALID_UNDERSCORE_LITERALS

INF = float("inf")
abstract type AbstractFloatSubclass <: float end
abstract type AbstractOtherFloatSubclass <: float end
abstract type AbstractGeneralFloatCases end
abstract type AbstractCustomStr <: str end
abstract type AbstractCustomBytes <: bytes end
abstract type AbstractCustomByteArray <: bytearray end
abstract type AbstractFoo1 <: object end
abstract type AbstractFoo2 <: float end
abstract type AbstractFoo3 <: float end
abstract type AbstractFoo4 <: float end
abstract type AbstractFooStr <: str end
abstract type AbstractF <: float end
abstract type AbstractFormatFunctionsTestCase end
abstract type AbstractUnknownFormatTestCase end
abstract type AbstractIEEEFormatTestCase end
abstract type AbstractFormatTestCase end
abstract type AbstractReprTestCase end
abstract type AbstractRoundTestCase end
abstract type AbstractInfNanTest end
abstract type AbstractHexFloatTestCase end
abstract type AbstractF2 <: float end
NAN = float("nan")
have_getformat = hasfield(typeof(float), :__getformat__)
requires_getformat = skipUnless(have_getformat, "requires __getformat__")
requires_setformat = skipUnless(hasfield(typeof(float), :__setformat__), "requires __setformat__")
test_dir = dirname(__file__) || os.curdir
format_testfile = joinpath(test_dir, "formatfloat_testcases.txt")
mutable struct FloatSubclass <: AbstractFloatSubclass

end

mutable struct OtherFloatSubclass <: AbstractOtherFloatSubclass

end

mutable struct GeneralFloatCases <: AbstractGeneralFloatCases
value
end
function test_float(self::GeneralFloatCases)
@test (float(3.14) == 3.14)
@test (float(314) == 314.0)
@test (float("  3.14  ") == 3.14)
@test_throws ValueError float("  0x3.1  ")
@test_throws ValueError float("  -0x3.p-1  ")
@test_throws ValueError float("  +0x3.p-1  ")
@test_throws ValueError float("++3.14")
@test_throws ValueError float("+-3.14")
@test_throws ValueError float("-+3.14")
@test_throws ValueError float("--3.14")
@test_throws ValueError float(".nan")
@test_throws ValueError float("+.inf")
@test_throws ValueError float(".")
@test_throws ValueError float("-.")
@test_throws TypeError float(Dict())
@test_throws TypeError float(float, Dict())
            @test match(@r_str("not \'dict\'"), repr(float))
@test_throws ValueError float("\ud8f0")
@test_throws ValueError float("-1.7d29")
@test_throws ValueError float("3D-14")
@test (float("  ٣.١٤  ") == 3.14)
@test (float(" 3.14 ") == 3.14)
float(append!(b".", repeat(b"1",1000)))
float("." * repeat("1",1000))
@test_throws ValueError float("こんにちは")
end

function test_noargs(self::GeneralFloatCases)
@test (float() == 0.0)
end

function test_underscores(self::GeneralFloatCases)
for lit in VALID_UNDERSCORE_LITERALS
if !any((ch ∈ lit for ch in "jJxXoObB"))
@test (float(lit) == eval(lit))
@test (float(lit) == float(replace(lit, "_", "")))
end
end
for lit in INVALID_UNDERSCORE_LITERALS
if lit ∈ ("0_7", "09_99")
continue;
end
if !any((ch ∈ lit for ch in "jJxXoObB"))
@test_throws ValueError float(lit)
end
end
@test_throws ValueError float("_NaN")
@test_throws ValueError float("Na_N")
@test_throws ValueError float("IN_F")
@test_throws ValueError float("-_INF")
@test_throws ValueError float("-INF_")
@test_throws ValueError float(b"0_.\xff9")
end

function test_non_numeric_input_types(self::CustomByteArray)
mutable struct CustomStr <: AbstractCustomStr

end

mutable struct CustomBytes <: AbstractCustomBytes

end

mutable struct CustomByteArray <: AbstractCustomByteArray

end

factories = [bytes, bytearray, (b) -> CustomStr(decode(b)), CustomBytes, CustomByteArray, memoryview]
try
catch exn
if exn isa ImportError
#= pass =#
end
end
for f in factories
x = f(b" 3.14  ")
subTest(self, type_(x)) do 
assertEqual(self, float(x), 3.14)
assertRaisesRegex(self, ValueError, "could not convert") do 
float(f(repeat(b"A",16)))
end
end
end
end

function test_float_memoryview(self::GeneralFloatCases)
@test (float(memoryview(b"12.3")[2:4]) == 2.3)
@test (float(memoryview(b"12.3\x00")[2:4]) == 2.3)
@test (float(memoryview(b"12.3 ")[2:4]) == 2.3)
@test (float(memoryview(b"12.3A")[2:4]) == 2.3)
@test (float(memoryview(b"12.34")[2:4]) == 2.3)
end

function test_error_message(self::GeneralFloatCases)
function check(s)
@test_throws ValueError "float(%r)" % (s,)() do cm 
float(s)
end
@test (string(cm.exception) == "could not convert string to float: %r" % (s,))
end

check("½")
check("123½")
check("  123 456  ")
check(b"  123 456  ")
check("٣١٤!")
check("123\0")
check("123\0 245")
check("123\0245")
check(b"123\x00")
check(b"123\xa0")
end

function test_float_with_comma(self::GeneralFloatCases)
if !(localeconv()["decimal_point"] == ",")
skipTest(self, "decimal_point is not \",\"")
end
@test (float("  3.14  ") == 3.14)
@test (float("+3.14  ") == 3.14)
@test (float("-3.14  ") == -3.14)
@test (float(".14  ") == 0.14)
@test (float("3.  ") == 3.0)
@test (float("3.e3  ") == 3000.0)
@test (float("3.2e3  ") == 3200.0)
@test (float("2.5e-1  ") == 0.25)
@test (float("5e-1") == 0.5)
@test_throws ValueError float("  3,14  ")
@test_throws ValueError float("  +3,14  ")
@test_throws ValueError float("  -3,14  ")
@test_throws ValueError float("  0x3.1  ")
@test_throws ValueError float("  -0x3.p-1  ")
@test_throws ValueError float("  +0x3.p-1  ")
@test (float("  25.e-1  ") == 2.5)
assertAlmostEqual(self, float("  .25e-1  "), 0.025)
end

function test_floatconversion(self::MyInt)
mutable struct Foo1 <: AbstractFoo1

end
function __float__(self::Foo1)::Float64
return 42.0
end

mutable struct Foo2 <: AbstractFoo2

end
function __float__(self::Foo2)::Float64
return 42.0
end

mutable struct Foo3 <: AbstractFoo3

end
function __new__(cls, value = 0.0)
return __new__(float, cls)
end

function __float__(self::Foo3)
return self
end

mutable struct Foo4 <: AbstractFoo4

end
function __float__(self::Foo4)::Int64
return 42
end

mutable struct FooStr <: AbstractFooStr

end
function __float__(self::FooStr)::Float64
return float(string(self)) + 1
end

assertEqual(self, float(Foo1()), 42.0)
assertEqual(self, float(Foo2()), 42.0)
assertWarns(self, DeprecationWarning) do 
assertEqual(self, float(Foo3(21)), 42.0)
end
assertRaises(self, TypeError, float, Foo4(42))
assertEqual(self, float(FooStr("8")), 9.0)
mutable struct Foo5 <: AbstractFoo5

end
function __float__(self::Foo5)::String
return ""
end

assertRaises(self, TypeError, time.sleep, Foo5())
mutable struct F <: AbstractF

end
function __float__(self::F)::OtherFloatSubclass
return OtherFloatSubclass(42.0)
end

assertWarns(self, DeprecationWarning) do 
assertEqual(self, float(F()), 42.0)
end
assertWarns(self, DeprecationWarning) do 
assertIs(self, type_(float(F())), float)
end
assertWarns(self, DeprecationWarning) do 
assertEqual(self, FloatSubclass(F()), 42.0)
end
assertWarns(self, DeprecationWarning) do 
assertIs(self, type_(FloatSubclass(F())), FloatSubclass)
end
mutable struct MyIndex <: AbstractMyIndex
value
end
function __index__(self::MyIndex)
return self.value
end

assertEqual(self, float(MyIndex(42)), 42.0)
assertRaises(self, OverflowError, float, MyIndex(2^2000))
mutable struct MyInt <: AbstractMyInt

end
function __int__(self::MyInt)::Int64
return 42
end

assertRaises(self, TypeError, float, MyInt())
end

function test_keyword_args(self::GeneralFloatCases)
assertRaisesRegex(self, TypeError, "keyword argument") do 
float("3.14")
end
end

function test_is_integer(self::GeneralFloatCases)
@test !(is_integer(1.1))
@test is_integer(1.0)
@test !(is_integer(float("nan")))
@test !(is_integer(float("inf")))
end

function test_floatasratio(self::GeneralFloatCases)
for (f, ratio) in [(0.875, (7, 8)), (-0.875, (-7, 8)), (0.0, (0, 1)), (11.5, (23, 2))]
@test (as_integer_ratio(f) == ratio)
end
for i in 0:9999
f = random()
f = __mul__(f, 10^randint(-100, 100))
n, d = as_integer_ratio(f)
@test (__truediv__(float(n), d) == f)
end
R = fractions.Fraction
@test (R(0, 1) == R(as_integer_ratio(float(0.0))...))
@test (R(5, 2) == R(as_integer_ratio(float(2.5))...))
@test (R(1, 2) == R(as_integer_ratio(float(0.5))...))
@test (R(4728779608739021, 2251799813685248) == R(as_integer_ratio(float(2.1))...))
@test (R(-4728779608739021, 2251799813685248) == R(as_integer_ratio(float(-2.1))...))
@test (R(-2100, 1) == R(as_integer_ratio(float(-2100.0))...))
@test_throws OverflowError float("inf").as_integer_ratio()
@test_throws OverflowError float("-inf").as_integer_ratio()
@test_throws ValueError float("nan").as_integer_ratio()
end

function test_float_containment(self::GeneralFloatCases)
floats = (INF, -(INF), 0.0, 1.0, NAN)
for f in floats
assertIn(self, f, [f])
assertIn(self, f, (f,))
assertIn(self, f, Set([f]))
assertIn(self, f, Dict(f => nothing))
@test (count(isequal(f), [f]) == 1)
assertIn(self, f, floats)
end
for f in floats
@test [f] == [f]
@test (f,) == (f,)
@test Set([f]) == Set([f])
@test Dict(f => nothing) == Dict(f => nothing)
l, t, s, d = ([f], (f,), Set([f]), Dict(f => nothing))
@test l === l
@test t === t
@test s === s
@test d === d
end
end

function assertEqualAndEqualSign(self::GeneralFloatCases, a, b)
@test ((a, copysign(1.0, a)) == (b, copysign(1.0, b)))
end

function test_float_floor(self::GeneralFloatCases)
@test isa(self, __floor__(float(0.5)))
@test (__floor__(float(0.5)) == 0)
@test (__floor__(float(1.0)) == 1)
@test (__floor__(float(1.5)) == 1)
@test (__floor__(float(-0.5)) == -1)
@test (__floor__(float(-1.0)) == -1)
@test (__floor__(float(-1.5)) == -2)
@test (__floor__(float(1.23e+167)) == 1.23e+167)
@test (__floor__(float(-1.23e+167)) == -1.23e+167)
@test_throws ValueError float("nan").__floor__()
@test_throws OverflowError float("inf").__floor__()
@test_throws OverflowError float("-inf").__floor__()
end

function test_float_ceil(self::GeneralFloatCases)
@test isa(self, __ceil__(float(0.5)))
@test (__ceil__(float(0.5)) == 1)
@test (__ceil__(float(1.0)) == 1)
@test (__ceil__(float(1.5)) == 2)
@test (__ceil__(float(-0.5)) == 0)
@test (__ceil__(float(-1.0)) == -1)
@test (__ceil__(float(-1.5)) == -1)
@test (__ceil__(float(1.23e+167)) == 1.23e+167)
@test (__ceil__(float(-1.23e+167)) == -1.23e+167)
@test_throws ValueError float("nan").__ceil__()
@test_throws OverflowError float("inf").__ceil__()
@test_throws OverflowError float("-inf").__ceil__()
end

function test_float_mod(self::GeneralFloatCases)
mod = operator.mod
assertEqualAndEqualSign(self, mod(-1.0, 1.0), 0.0)
assertEqualAndEqualSign(self, mod(-1e-100, 1.0), 1.0)
assertEqualAndEqualSign(self, mod(-0.0, 1.0), 0.0)
assertEqualAndEqualSign(self, mod(0.0, 1.0), 0.0)
assertEqualAndEqualSign(self, mod(1e-100, 1.0), 1e-100)
assertEqualAndEqualSign(self, mod(1.0, 1.0), 0.0)
assertEqualAndEqualSign(self, mod(-1.0, -1.0), -0.0)
assertEqualAndEqualSign(self, mod(-1e-100, -1.0), -1e-100)
assertEqualAndEqualSign(self, mod(-0.0, -1.0), -0.0)
assertEqualAndEqualSign(self, mod(0.0, -1.0), -0.0)
assertEqualAndEqualSign(self, mod(1e-100, -1.0), -1.0)
assertEqualAndEqualSign(self, mod(1.0, -1.0), -0.0)
end

function test_float_pow(self::GeneralFloatCases)
for pow_op in (pow, operator.pow)
@test isnan(pow_op(-(INF), NAN))
@test isnan(pow_op(-2.0, NAN))
@test isnan(pow_op(-1.0, NAN))
@test isnan(pow_op(-0.5, NAN))
@test isnan(pow_op(-0.0, NAN))
@test isnan(pow_op(0.0, NAN))
@test isnan(pow_op(0.5, NAN))
@test isnan(pow_op(2.0, NAN))
@test isnan(pow_op(INF, NAN))
@test isnan(pow_op(NAN, NAN))
@test isnan(pow_op(NAN, -(INF)))
@test isnan(pow_op(NAN, -2.0))
@test isnan(pow_op(NAN, -1.0))
@test isnan(pow_op(NAN, -0.5))
@test isnan(pow_op(NAN, 0.5))
@test isnan(pow_op(NAN, 1.0))
@test isnan(pow_op(NAN, 2.0))
@test isnan(pow_op(NAN, INF))
@test_throws ZeroDivisionError pow_op(-0.0, -1.0)
@test_throws ZeroDivisionError pow_op(0.0, -1.0)
@test_throws ZeroDivisionError pow_op(-0.0, -2.0)
@test_throws ZeroDivisionError pow_op(-0.0, -0.5)
@test_throws ZeroDivisionError pow_op(0.0, -2.0)
@test_throws ZeroDivisionError pow_op(0.0, -0.5)
assertEqualAndEqualSign(self, pow_op(-0.0, 1.0), -0.0)
assertEqualAndEqualSign(self, pow_op(0.0, 1.0), 0.0)
assertEqualAndEqualSign(self, pow_op(-0.0, 0.5), 0.0)
assertEqualAndEqualSign(self, pow_op(-0.0, 2.0), 0.0)
assertEqualAndEqualSign(self, pow_op(0.0, 0.5), 0.0)
assertEqualAndEqualSign(self, pow_op(0.0, 2.0), 0.0)
assertEqualAndEqualSign(self, pow_op(-1.0, -(INF)), 1.0)
assertEqualAndEqualSign(self, pow_op(-1.0, INF), 1.0)
assertEqualAndEqualSign(self, pow_op(1.0, -(INF)), 1.0)
assertEqualAndEqualSign(self, pow_op(1.0, -2.0), 1.0)
assertEqualAndEqualSign(self, pow_op(1.0, -1.0), 1.0)
assertEqualAndEqualSign(self, pow_op(1.0, -0.5), 1.0)
assertEqualAndEqualSign(self, pow_op(1.0, -0.0), 1.0)
assertEqualAndEqualSign(self, pow_op(1.0, 0.0), 1.0)
assertEqualAndEqualSign(self, pow_op(1.0, 0.5), 1.0)
assertEqualAndEqualSign(self, pow_op(1.0, 1.0), 1.0)
assertEqualAndEqualSign(self, pow_op(1.0, 2.0), 1.0)
assertEqualAndEqualSign(self, pow_op(1.0, INF), 1.0)
assertEqualAndEqualSign(self, pow_op(1.0, NAN), 1.0)
assertEqualAndEqualSign(self, pow_op(-(INF), 0.0), 1.0)
assertEqualAndEqualSign(self, pow_op(-2.0, 0.0), 1.0)
assertEqualAndEqualSign(self, pow_op(-1.0, 0.0), 1.0)
assertEqualAndEqualSign(self, pow_op(-0.5, 0.0), 1.0)
assertEqualAndEqualSign(self, pow_op(-0.0, 0.0), 1.0)
assertEqualAndEqualSign(self, pow_op(0.0, 0.0), 1.0)
assertEqualAndEqualSign(self, pow_op(0.5, 0.0), 1.0)
assertEqualAndEqualSign(self, pow_op(1.0, 0.0), 1.0)
assertEqualAndEqualSign(self, pow_op(2.0, 0.0), 1.0)
assertEqualAndEqualSign(self, pow_op(INF, 0.0), 1.0)
assertEqualAndEqualSign(self, pow_op(NAN, 0.0), 1.0)
assertEqualAndEqualSign(self, pow_op(-(INF), -0.0), 1.0)
assertEqualAndEqualSign(self, pow_op(-2.0, -0.0), 1.0)
assertEqualAndEqualSign(self, pow_op(-1.0, -0.0), 1.0)
assertEqualAndEqualSign(self, pow_op(-0.5, -0.0), 1.0)
assertEqualAndEqualSign(self, pow_op(-0.0, -0.0), 1.0)
assertEqualAndEqualSign(self, pow_op(0.0, -0.0), 1.0)
assertEqualAndEqualSign(self, pow_op(0.5, -0.0), 1.0)
assertEqualAndEqualSign(self, pow_op(1.0, -0.0), 1.0)
assertEqualAndEqualSign(self, pow_op(2.0, -0.0), 1.0)
assertEqualAndEqualSign(self, pow_op(INF, -0.0), 1.0)
assertEqualAndEqualSign(self, pow_op(NAN, -0.0), 1.0)
@test (type_(pow_op(-2.0, -0.5)) == complex)
@test (type_(pow_op(-2.0, 0.5)) == complex)
@test (type_(pow_op(-1.0, -0.5)) == complex)
@test (type_(pow_op(-1.0, 0.5)) == complex)
@test (type_(pow_op(-0.5, -0.5)) == complex)
@test (type_(pow_op(-0.5, 0.5)) == complex)
assertEqualAndEqualSign(self, pow_op(-0.5, -(INF)), INF)
assertEqualAndEqualSign(self, pow_op(-0.0, -(INF)), INF)
assertEqualAndEqualSign(self, pow_op(0.0, -(INF)), INF)
assertEqualAndEqualSign(self, pow_op(0.5, -(INF)), INF)
assertEqualAndEqualSign(self, pow_op(-(INF), -(INF)), 0.0)
assertEqualAndEqualSign(self, pow_op(-2.0, -(INF)), 0.0)
assertEqualAndEqualSign(self, pow_op(2.0, -(INF)), 0.0)
assertEqualAndEqualSign(self, pow_op(INF, -(INF)), 0.0)
assertEqualAndEqualSign(self, pow_op(-0.5, INF), 0.0)
assertEqualAndEqualSign(self, pow_op(-0.0, INF), 0.0)
assertEqualAndEqualSign(self, pow_op(0.0, INF), 0.0)
assertEqualAndEqualSign(self, pow_op(0.5, INF), 0.0)
assertEqualAndEqualSign(self, pow_op(-(INF), INF), INF)
assertEqualAndEqualSign(self, pow_op(-2.0, INF), INF)
assertEqualAndEqualSign(self, pow_op(2.0, INF), INF)
assertEqualAndEqualSign(self, pow_op(INF, INF), INF)
assertEqualAndEqualSign(self, pow_op(-(INF), -1.0), -0.0)
assertEqualAndEqualSign(self, pow_op(-(INF), -0.5), 0.0)
assertEqualAndEqualSign(self, pow_op(-(INF), -2.0), 0.0)
assertEqualAndEqualSign(self, pow_op(-(INF), 1.0), -(INF))
assertEqualAndEqualSign(self, pow_op(-(INF), 0.5), INF)
assertEqualAndEqualSign(self, pow_op(-(INF), 2.0), INF)
assertEqualAndEqualSign(self, pow_op(INF, 0.5), INF)
assertEqualAndEqualSign(self, pow_op(INF, 1.0), INF)
assertEqualAndEqualSign(self, pow_op(INF, 2.0), INF)
assertEqualAndEqualSign(self, pow_op(INF, -2.0), 0.0)
assertEqualAndEqualSign(self, pow_op(INF, -1.0), 0.0)
assertEqualAndEqualSign(self, pow_op(INF, -0.5), 0.0)
assertEqualAndEqualSign(self, pow_op(-2.0, -2.0), 0.25)
assertEqualAndEqualSign(self, pow_op(-2.0, -1.0), -0.5)
assertEqualAndEqualSign(self, pow_op(-2.0, -0.0), 1.0)
assertEqualAndEqualSign(self, pow_op(-2.0, 0.0), 1.0)
assertEqualAndEqualSign(self, pow_op(-2.0, 1.0), -2.0)
assertEqualAndEqualSign(self, pow_op(-2.0, 2.0), 4.0)
assertEqualAndEqualSign(self, pow_op(-1.0, -2.0), 1.0)
assertEqualAndEqualSign(self, pow_op(-1.0, -1.0), -1.0)
assertEqualAndEqualSign(self, pow_op(-1.0, -0.0), 1.0)
assertEqualAndEqualSign(self, pow_op(-1.0, 0.0), 1.0)
assertEqualAndEqualSign(self, pow_op(-1.0, 1.0), -1.0)
assertEqualAndEqualSign(self, pow_op(-1.0, 2.0), 1.0)
assertEqualAndEqualSign(self, pow_op(2.0, -2.0), 0.25)
assertEqualAndEqualSign(self, pow_op(2.0, -1.0), 0.5)
assertEqualAndEqualSign(self, pow_op(2.0, -0.0), 1.0)
assertEqualAndEqualSign(self, pow_op(2.0, 0.0), 1.0)
assertEqualAndEqualSign(self, pow_op(2.0, 1.0), 2.0)
assertEqualAndEqualSign(self, pow_op(2.0, 2.0), 4.0)
assertEqualAndEqualSign(self, pow_op(1.0, -1e+100), 1.0)
assertEqualAndEqualSign(self, pow_op(1.0, 1e+100), 1.0)
assertEqualAndEqualSign(self, pow_op(-1.0, -1e+100), 1.0)
assertEqualAndEqualSign(self, pow_op(-1.0, 1e+100), 1.0)
assertEqualAndEqualSign(self, pow_op(-2.0, -2000.0), 0.0)
@test (type_(pow_op(-2.0, -2000.5)) == complex)
assertEqualAndEqualSign(self, pow_op(-2.0, -2001.0), -0.0)
assertEqualAndEqualSign(self, pow_op(2.0, -2000.0), 0.0)
assertEqualAndEqualSign(self, pow_op(2.0, -2000.5), 0.0)
assertEqualAndEqualSign(self, pow_op(2.0, -2001.0), 0.0)
assertEqualAndEqualSign(self, pow_op(-0.5, 2000.0), 0.0)
@test (type_(pow_op(-0.5, 2000.5)) == complex)
assertEqualAndEqualSign(self, pow_op(-0.5, 2001.0), -0.0)
assertEqualAndEqualSign(self, pow_op(0.5, 2000.0), 0.0)
assertEqualAndEqualSign(self, pow_op(0.5, 2000.5), 0.0)
assertEqualAndEqualSign(self, pow_op(0.5, 2001.0), 0.0)
end
end

function test_hash(self::GeneralFloatCases)
for x in -30:29
@test (hash(float(x)) == hash(x))
end
@test (hash(float(sys.float_info.max)) == hash(parse(Int, sys.float_info.max)))
@test (hash(float("inf")) == sys.hash_info.inf)
@test (hash(float("-inf")) == -(sys.hash_info.inf))
end

function test_hash_nan(self::F)
value = float("nan")
assertEqual(self, hash(value), __hash__(object, value))
mutable struct H <: AbstractH

end
function __hash__(self::H)::Int64
return 42
end

mutable struct F <: float

end

value = F("nan")
assertEqual(self, hash(value), __hash__(object, value))
end

mutable struct FormatFunctionsTestCase <: AbstractFormatFunctionsTestCase
save_formats::Dict{String, Any}
end
function setUp(self::FormatFunctionsTestCase)
self.save_formats = Dict("double" => __getformat__(float, "double"), "float" => __getformat__(float, "float"))
end

function tearDown(self::FormatFunctionsTestCase)
__setformat__(float, "double", self.save_formats["double"])
__setformat__(float, "float", self.save_formats["float"])
end

function test_getformat(self::FormatFunctionsTestCase)
assertIn(self, __getformat__(float, "double"), ["unknown", "IEEE, big-endian", "IEEE, little-endian"])
assertIn(self, __getformat__(float, "float"), ["unknown", "IEEE, big-endian", "IEEE, little-endian"])
@test_throws ValueError float.__getformat__("chicken")
@test_throws TypeError float.__getformat__(1)
end

function test_setformat(self::FormatFunctionsTestCase)
for t in ("double", "float")
__setformat__(float, t, "unknown")
if self.save_formats[t + 1] == "IEEE, big-endian"
@test_throws ValueError float.__setformat__(t, "IEEE, little-endian")
elseif self.save_formats[t + 1] == "IEEE, little-endian"
@test_throws ValueError float.__setformat__(t, "IEEE, big-endian")
else
@test_throws ValueError float.__setformat__(t, "IEEE, big-endian")
@test_throws ValueError float.__setformat__(t, "IEEE, little-endian")
end
@test_throws ValueError float.__setformat__(t, "chicken")
end
@test_throws ValueError float.__setformat__("chicken", "unknown")
end

BE_DOUBLE_INF = b"\x7f\xf0\x00\x00\x00\x00\x00\x00"
LE_DOUBLE_INF = bytes(reversed(BE_DOUBLE_INF))
BE_DOUBLE_NAN = b"\x7f\xf8\x00\x00\x00\x00\x00\x00"
LE_DOUBLE_NAN = bytes(reversed(BE_DOUBLE_NAN))
BE_FLOAT_INF = b"\x7f\x80\x00\x00"
LE_FLOAT_INF = bytes(reversed(BE_FLOAT_INF))
BE_FLOAT_NAN = b"\x7f\xc0\x00\x00"
LE_FLOAT_NAN = bytes(reversed(BE_FLOAT_NAN))
mutable struct UnknownFormatTestCase <: AbstractUnknownFormatTestCase
save_formats::Dict{String, Any}
end
function setUp(self::UnknownFormatTestCase)
self.save_formats = Dict("double" => __getformat__(float, "double"), "float" => __getformat__(float, "float"))
__setformat__(float, "double", "unknown")
__setformat__(float, "float", "unknown")
end

function tearDown(self::UnknownFormatTestCase)
__setformat__(float, "double", self.save_formats["double"])
__setformat__(float, "float", self.save_formats["float"])
end

function test_double_specials_dont_unpack(self::UnknownFormatTestCase)
for (fmt, data) in [(">d", BE_DOUBLE_INF), (">d", BE_DOUBLE_NAN), ("<d", LE_DOUBLE_INF), ("<d", LE_DOUBLE_NAN)]
@test_throws ValueError struct_.unpack(fmt, data)
end
end

function test_float_specials_dont_unpack(self::UnknownFormatTestCase)
for (fmt, data) in [(">f", BE_FLOAT_INF), (">f", BE_FLOAT_NAN), ("<f", LE_FLOAT_INF), ("<f", LE_FLOAT_NAN)]
@test_throws ValueError struct_.unpack(fmt, data)
end
end

mutable struct IEEEFormatTestCase <: AbstractIEEEFormatTestCase

end
function test_double_specials_do_unpack(self::IEEEFormatTestCase)
for (fmt, data) in [(">d", BE_DOUBLE_INF), (">d", BE_DOUBLE_NAN), ("<d", LE_DOUBLE_INF), ("<d", LE_DOUBLE_NAN)]
unpack(fmt, data)
end
end

function test_float_specials_do_unpack(self::IEEEFormatTestCase)
for (fmt, data) in [(">f", BE_FLOAT_INF), (">f", BE_FLOAT_NAN), ("<f", LE_FLOAT_INF), ("<f", LE_FLOAT_NAN)]
unpack(fmt, data)
end
end

function test_serialized_float_rounding(self::IEEEFormatTestCase)
@test (pack("<f", 3.40282356e+38) == pack("<f", FLT_MAX))
@test (pack("<f", -3.40282356e+38) == pack("<f", -(FLT_MAX)))
end

mutable struct FormatTestCase <: AbstractFormatTestCase

end
function test_format(self::FormatTestCase)
@test (0.0 == "0.000000")
@test (0.0 == "0.0")
@test (0.01 == "0.01")
@test (0.01 == "0.01")
x = 100 / 7.0
@test (x == string(x))
@test (x == string(x))
@test (x == string(x))
@test (x == string(x))
@test (1.0 == "1.000000")
@test (-1.0 == "-1.000000")
@test (1.0 == " 1.000000")
@test (-1.0 == "-1.000000")
@test (1.0 == "+1.000000")
@test (-1.0 == "-1.000000")
@test (-1.0 == "-100.000000%")
@test_throws ValueError format(3.0, "s")
for format_spec in [Char(x) for x in Int(codepoint('a')):Int(codepoint('z'))] + [Char(x) for x in Int(codepoint('A')):Int(codepoint('Z'))]
if !(format_spec ∈ "eEfFgGn%")
@test_throws ValueError format(0.0, format_spec)
@test_throws ValueError format(1.0, format_spec)
@test_throws ValueError format(-1.0, format_spec)
@test_throws ValueError format(1e+100, format_spec)
@test_throws ValueError format(-1e+100, format_spec)
@test_throws ValueError format(1e-100, format_spec)
@test_throws ValueError format(-1e-100, format_spec)
end
end
@test (NAN == "nan")
@test (NAN == "NAN")
@test (INF == "inf")
@test (INF == "INF")
end

function test_format_testfile(self::FormatTestCase)
readline(format_testfile) do testfile 
for line in testfile
if startswith(line, "--")
continue;
end
line = strip(line)
if !(line)
continue;
end
lhs, rhs = map(str.strip, split(line, "->"))
fmt, arg = split(lhs)
@test (fmt % float(arg) == rhs)
@test (fmt % -float(arg) == "-" + rhs)
end
end
end

function test_issue5864(self::FormatTestCase)
@test (123.456 == "123.5")
@test (1234.56 == "1.235e+03")
@test (12345.6 == "1.235e+04")
end

function test_issue35560(self::FormatTestCase)
@test (123.0 == "123.0")
@test (123.34 == "123.340000")
@test (123.34 == "1.233400e+02")
@test (123.34 == "123.34")
@test (123.34 == "123.3400000000")
@test (123.34 == "1.2334000000e+02")
@test (123.34 == "123.34")
@test (123.34 == "123.340000")
@test (-123.0 == "-123.0")
@test (-123.34 == "-123.340000")
@test (-123.34 == "-1.233400e+02")
@test (-123.34 == "-123.34")
@test (-123.34 == "-123.3400000000")
@test (-123.34 == "-123.3400000000")
@test (-123.34 == "-1.2334000000e+02")
@test (-123.34 == "-123.34")
end

mutable struct ReprTestCase <: AbstractReprTestCase

end
function test_repr(self::ReprTestCase)
readline(joinpath(splitdir(__file__)[1], "floating_points.txt")) do floats_file 
for line in floats_file
line = strip(line)
if !(line) || startswith(line, "#")
continue;
end
v = eval(line)
@test (v == eval(repr(v)))
end
end
end

function test_short_repr(self::ReprTestCase)
test_strings = ["0.0", "1.0", "0.01", "0.02", "0.03", "0.04", "0.05", "1.23456789", "10.0", "100.0", "1000000000000000.0", "9999999999999990.0", "1e+16", "1e+17", "0.001", "0.001001", "0.00010000000000001", "0.0001", "9.999999999999e-05", "1e-05", "8.72293771110361e+25", "7.47005307342313e+26", "2.86438000439698e+28", "8.89142905246179e+28", "3.08578087079232e+35"]
for s in test_strings
negs = "-" * s
@test (s == repr(float(s)))
@test (negs == repr(float(negs)))
@test (repr(float(s)) == string(float(s)))
@test (repr(float(negs)) == string(float(negs)))
end
end

mutable struct RoundTestCase <: AbstractRoundTestCase

end
function test_inf_nan(self::RoundTestCase)
@test_throws OverflowError round(INF)
@test_throws OverflowError round(-(INF))
@test_throws ValueError round(NAN)
@test_throws TypeError round(INF, 0.0)
@test_throws TypeError round(-(INF), 1.0)
@test_throws TypeError round(NAN, "ceci n\'est pas un integer")
@test_throws TypeError round(-0.0, 1im)
end

function test_large_n(self::RoundTestCase)
for n in [324, 325, 400, 2^31 - 1, 2^31, 2^32, 2^100]
@test (round(123.456, digits = n) == 123.456)
@test (round(-123.456, digits = n) == -123.456)
@test (round(1e+300, digits = n) == 1e+300)
@test (round(1e-320, digits = n) == 1e-320)
end
@test (round(1e+150, digits = 300) == 1e+150)
@test (round(1e+300, digits = 307) == 1e+300)
@test (round(-3.1415, digits = 308) == -3.1415)
@test (round(1e+150, digits = 309) == 1e+150)
@test (round(1.4e-315, digits = 315) == 1e-315)
end

function test_small_n(self::RoundTestCase)
for n in [-308, -309, -400, 1 - 2^31, -(2^31), -(2^31) - 1, -(2^100)]
@test (round(123.456, digits = n) == 0.0)
@test (round(-123.456, digits = n) == -0.0)
@test (round(1e+300, digits = n) == 0.0)
@test (round(1e-320, digits = n) == 0.0)
end
end

function test_overflow(self::RoundTestCase)
@test_throws OverflowError round(1.6e+308, -308)
@test_throws OverflowError round(-1.7e+308, -308)
end

function test_previous_round_bugs(self::RoundTestCase)
@test (round(562949953421312.5, digits = 1) == 562949953421312.5)
@test (round(56294995342131.5, digits = 3) == 56294995342131.5)
@test (round(25.0, digits = -1) == 20.0)
@test (round(35.0, digits = -1) == 40.0)
@test (round(45.0, digits = -1) == 40.0)
@test (round(55.0, digits = -1) == 60.0)
@test (round(65.0, digits = -1) == 60.0)
@test (round(75.0, digits = -1) == 80.0)
@test (round(85.0, digits = -1) == 80.0)
@test (round(95.0, digits = -1) == 100.0)
end

function test_matches_float_format(self::RoundTestCase)
for i in 0:499
x = i / 1000.0
@test (float(x) == round(x, digits = 0))
@test (float(x) == round(x, digits = 1))
@test (float(x) == round(x, digits = 2))
@test (float(x) == round(x, digits = 3))
end
for i in 5:10:4999
x = i / 1000.0
@test (float(x) == round(x, digits = 0))
@test (float(x) == round(x, digits = 1))
@test (float(x) == round(x, digits = 2))
@test (float(x) == round(x, digits = 3))
end
for i in 0:499
x = random()
@test (float(x) == round(x, digits = 0))
@test (float(x) == round(x, digits = 1))
@test (float(x) == round(x, digits = 2))
@test (float(x) == round(x, digits = 3))
end
end

function test_format_specials(self::RoundTestCase)
function test(fmt, value, expected)
@test (fmt % value == expected)
fmt = fmt[2:end]
@test (value == expected)
end

for fmt in ["%e", "%f", "%g", "%.0e", "%.6f", "%.20g", "%#e", "%#f", "%#g", "%#.20e", "%#.15f", "%#.3g"]
pfmt = "%+" * fmt[2:end]
sfmt = "% " * fmt[2:end]
test(fmt, INF, "inf")
test(fmt, -(INF), "-inf")
test(fmt, NAN, "nan")
test(fmt, -(NAN), "nan")
test(pfmt, INF, "+inf")
test(pfmt, -(INF), "-inf")
test(pfmt, NAN, "+nan")
test(pfmt, -(NAN), "+nan")
test(sfmt, INF, " inf")
test(sfmt, -(INF), "-inf")
test(sfmt, NAN, " nan")
test(sfmt, -(NAN), " nan")
end
end

function test_None_ndigits(self::RoundTestCase)
for x in (round(1.23), round(1.23, digits = nothing), round(1.23, digits = nothing))
@test (x == 1)
@test isa(self, x)
end
for x in (round(1.78), round(1.78, digits = nothing), round(1.78, digits = nothing))
@test (x == 2)
@test isa(self, x)
end
end

mutable struct InfNanTest <: AbstractInfNanTest

end
function test_inf_from_str(self::InfNanTest)
@test isinf(float("inf"))
@test isinf(float("+inf"))
@test isinf(float("-inf"))
@test isinf(float("infinity"))
@test isinf(float("+infinity"))
@test isinf(float("-infinity"))
@test (repr(float("inf")) == "inf")
@test (repr(float("+inf")) == "inf")
@test (repr(float("-inf")) == "-inf")
@test (repr(float("infinity")) == "inf")
@test (repr(float("+infinity")) == "inf")
@test (repr(float("-infinity")) == "-inf")
@test (repr(float("INF")) == "inf")
@test (repr(float("+Inf")) == "inf")
@test (repr(float("-iNF")) == "-inf")
@test (repr(float("Infinity")) == "inf")
@test (repr(float("+iNfInItY")) == "inf")
@test (repr(float("-INFINITY")) == "-inf")
@test (string(float("inf")) == "inf")
@test (string(float("+inf")) == "inf")
@test (string(float("-inf")) == "-inf")
@test (string(float("infinity")) == "inf")
@test (string(float("+infinity")) == "inf")
@test (string(float("-infinity")) == "-inf")
@test_throws ValueError float("info")
@test_throws ValueError float("+info")
@test_throws ValueError float("-info")
@test_throws ValueError float("in")
@test_throws ValueError float("+in")
@test_throws ValueError float("-in")
@test_throws ValueError float("infinit")
@test_throws ValueError float("+Infin")
@test_throws ValueError float("-INFI")
@test_throws ValueError float("infinitys")
@test_throws ValueError float("++Inf")
@test_throws ValueError float("-+inf")
@test_throws ValueError float("+-infinity")
@test_throws ValueError float("--Infinity")
end

function test_inf_as_str(self::InfNanTest)
@test (repr(1e+300*1e+300) == "inf")
@test (repr(-1e+300*1e+300) == "-inf")
@test (string(1e+300*1e+300) == "inf")
@test (string(-1e+300*1e+300) == "-inf")
end

function test_nan_from_str(self::InfNanTest)
@test isnan(float("nan"))
@test isnan(float("+nan"))
@test isnan(float("-nan"))
@test (repr(float("nan")) == "nan")
@test (repr(float("+nan")) == "nan")
@test (repr(float("-nan")) == "nan")
@test (repr(float("NAN")) == "nan")
@test (repr(float("+NAn")) == "nan")
@test (repr(float("-NaN")) == "nan")
@test (string(float("nan")) == "nan")
@test (string(float("+nan")) == "nan")
@test (string(float("-nan")) == "nan")
@test_throws ValueError float("nana")
@test_throws ValueError float("+nana")
@test_throws ValueError float("-nana")
@test_throws ValueError float("na")
@test_throws ValueError float("+na")
@test_throws ValueError float("-na")
@test_throws ValueError float("++nan")
@test_throws ValueError float("-+NAN")
@test_throws ValueError float("+-NaN")
@test_throws ValueError float("--nAn")
end

function test_nan_as_str(self::InfNanTest)
@test (repr(1e+300*1e+300*0) == "nan")
@test (repr(-1e+300*1e+300*0) == "nan")
@test (string(1e+300*1e+300*0) == "nan")
@test (string(-1e+300*1e+300*0) == "nan")
end

function test_inf_signs(self::InfNanTest)
@test (copysign(1.0, float("inf")) == 1.0)
@test (copysign(1.0, float("-inf")) == -1.0)
end

function test_nan_signs(self::InfNanTest)
@test (copysign(1.0, float("nan")) == 1.0)
@test (copysign(1.0, float("-nan")) == -1.0)
end

fromHex = float.fromhex
toHex = float.hex
mutable struct HexFloatTestCase <: AbstractHexFloatTestCase
foo::String
EPS
MAX
MIN
TINY

                    HexFloatTestCase(foo::String, EPS = fromHex("0x0.0000000000001p0"), MAX = fromHex("0x.fffffffffffff8p+1024"), MIN = fromHex("0x1p-1022"), TINY = fromHex("0x0.0000000000001p-1022")) =
                        new(foo, EPS, MAX, MIN, TINY)
end
function identical(self::HexFloatTestCase, x, y)
if isnan(x) || isnan(y)
if isnan(x) == isnan(y)
return
end
elseif x == y && x != 0.0 || copysign(1.0, x) == copysign(1.0, y)
return
end
fail(self, "%r not identical to %r" % (x, y))
end

function test_ends(self::HexFloatTestCase)
identical(self, self.MIN, ldexp(1.0, -1022))
identical(self, self.TINY, ldexp(1.0, -1074))
identical(self, self.EPS, ldexp(1.0, -52))
identical(self, self.MAX, 2.0*(ldexp(1.0, 1023) - ldexp(1.0, 970)))
end

function test_invalid_inputs(self::HexFloatTestCase)
invalid_inputs = ["infi", "-Infinit", "++inf", "-+Inf", "--nan", "+-NaN", "snan", "NaNs", "nna", "an", "nf", "nfinity", "inity", "iinity", "0xnan", "", " ", "x1.0p0", "0xX1.0p0", "+ 0x1.0p0", "- 0x1.0p0", "0 x1.0p0", "0x 1.0p0", "0x1 2.0p0", "+0x1 .0p0", "0x1. 0p0", "-0x1.0 1p0", "-0x1.0 p0", "+0x1.0p +0", "0x1.0p -0", "0x1.0p 0", "+0x1.0p+ 0", "-0x1.0p- 0", "++0x1.0p-0", "--0x1.0p0", "+-0x1.0p+0", "-+0x1.0p0", "0x1.0p++0", "+0x1.0p+-0", "-0x1.0p-+0", "0x1.0p--0", "0x1.0.p0", "0x.p0", "0x1,p0", "0x1pa", "0x1p０", "０x1p0", "0x１p0", "0x1.０p0", "0x1p0 \n 0x2p0", "0x1p0\0 0x1p0"]
for x in invalid_inputs
try
result = fromHex(x)
catch exn
if exn isa ValueError
#= pass =#
end
end
end
end

function test_whitespace(self::HexFloatTestCase)
value_pairs = [("inf", INF), ("-Infinity", -(INF)), ("nan", NAN), ("1.0", 1.0), ("-0x.2", -0.125), ("-0.0", -0.0)]
whitespace = ["", " ", "\t", "\n", "\n \t", "\f", "\v", "\r"]
for (inp, expected) in value_pairs
for lead in whitespace
for trail in whitespace
got = fromHex((lead + inp) + trail)
identical(self, got, expected)
end
end
end
end

function test_from_hex(self::HexFloatTestCase)
MIN = self.MIN
MAX = self.MAX
TINY = self.TINY
EPS = self.EPS
identical(self, fromHex("inf"), INF)
identical(self, fromHex("+Inf"), INF)
identical(self, fromHex("-INF"), -(INF))
identical(self, fromHex("iNf"), INF)
identical(self, fromHex("Infinity"), INF)
identical(self, fromHex("+INFINITY"), INF)
identical(self, fromHex("-infinity"), -(INF))
identical(self, fromHex("-iNFiNitY"), -(INF))
identical(self, fromHex("nan"), NAN)
identical(self, fromHex("+NaN"), NAN)
identical(self, fromHex("-NaN"), NAN)
identical(self, fromHex("-nAN"), NAN)
identical(self, fromHex("1"), 1.0)
identical(self, fromHex("+1"), 1.0)
identical(self, fromHex("1."), 1.0)
identical(self, fromHex("1.0"), 1.0)
identical(self, fromHex("1.0p0"), 1.0)
identical(self, fromHex("01"), 1.0)
identical(self, fromHex("01."), 1.0)
identical(self, fromHex("0x1"), 1.0)
identical(self, fromHex("0x1."), 1.0)
identical(self, fromHex("0x1.0"), 1.0)
identical(self, fromHex("+0x1.0"), 1.0)
identical(self, fromHex("0x1p0"), 1.0)
identical(self, fromHex("0X1p0"), 1.0)
identical(self, fromHex("0X1P0"), 1.0)
identical(self, fromHex("0x1P0"), 1.0)
identical(self, fromHex("0x1.p0"), 1.0)
identical(self, fromHex("0x1.0p0"), 1.0)
identical(self, fromHex("0x.1p4"), 1.0)
identical(self, fromHex("0x.1p04"), 1.0)
identical(self, fromHex("0x.1p004"), 1.0)
identical(self, fromHex("0x1p+0"), 1.0)
identical(self, fromHex("0x1P-0"), 1.0)
identical(self, fromHex("+0x1p0"), 1.0)
identical(self, fromHex("0x01p0"), 1.0)
identical(self, fromHex("0x1p00"), 1.0)
identical(self, fromHex(" 0x1p0 "), 1.0)
identical(self, fromHex("\n 0x1p0"), 1.0)
identical(self, fromHex("0x1p0 \t"), 1.0)
identical(self, fromHex("0xap0"), 10.0)
identical(self, fromHex("0xAp0"), 10.0)
identical(self, fromHex("0xaP0"), 10.0)
identical(self, fromHex("0xAP0"), 10.0)
identical(self, fromHex("0xbep0"), 190.0)
identical(self, fromHex("0xBep0"), 190.0)
identical(self, fromHex("0xbEp0"), 190.0)
identical(self, fromHex("0XBE0P-4"), 190.0)
identical(self, fromHex("0xBEp0"), 190.0)
identical(self, fromHex("0xB.Ep4"), 190.0)
identical(self, fromHex("0x.BEp8"), 190.0)
identical(self, fromHex("0x.0BEp12"), 190.0)
pi = fromHex("0x1.921fb54442d18p1")
identical(self, fromHex("0x.006487ed5110b46p11"), pi)
identical(self, fromHex("0x.00c90fdaa22168cp10"), pi)
identical(self, fromHex("0x.01921fb54442d18p9"), pi)
identical(self, fromHex("0x.03243f6a8885a3p8"), pi)
identical(self, fromHex("0x.06487ed5110b46p7"), pi)
identical(self, fromHex("0x.0c90fdaa22168cp6"), pi)
identical(self, fromHex("0x.1921fb54442d18p5"), pi)
identical(self, fromHex("0x.3243f6a8885a3p4"), pi)
identical(self, fromHex("0x.6487ed5110b46p3"), pi)
identical(self, fromHex("0x.c90fdaa22168cp2"), pi)
identical(self, fromHex("0x1.921fb54442d18p1"), pi)
identical(self, fromHex("0x3.243f6a8885a3p0"), pi)
identical(self, fromHex("0x6.487ed5110b46p-1"), pi)
identical(self, fromHex("0xc.90fdaa22168cp-2"), pi)
identical(self, fromHex("0x19.21fb54442d18p-3"), pi)
identical(self, fromHex("0x32.43f6a8885a3p-4"), pi)
identical(self, fromHex("0x64.87ed5110b46p-5"), pi)
identical(self, fromHex("0xc9.0fdaa22168cp-6"), pi)
identical(self, fromHex("0x192.1fb54442d18p-7"), pi)
identical(self, fromHex("0x324.3f6a8885a3p-8"), pi)
identical(self, fromHex("0x648.7ed5110b46p-9"), pi)
identical(self, fromHex("0xc90.fdaa22168cp-10"), pi)
identical(self, fromHex("0x1921.fb54442d18p-11"), pi)
identical(self, fromHex("0x1921fb54442d1.8p-47"), pi)
identical(self, fromHex("0x3243f6a8885a3p-48"), pi)
identical(self, fromHex("0x6487ed5110b46p-49"), pi)
identical(self, fromHex("0xc90fdaa22168cp-50"), pi)
identical(self, fromHex("0x1921fb54442d18p-51"), pi)
identical(self, fromHex("0x3243f6a8885a30p-52"), pi)
identical(self, fromHex("0x6487ed5110b460p-53"), pi)
identical(self, fromHex("0xc90fdaa22168c0p-54"), pi)
identical(self, fromHex("0x1921fb54442d180p-55"), pi)
@test_throws OverflowError fromHex("-0x1p1024")
@test_throws OverflowError fromHex("0x1p+1025")
@test_throws OverflowError fromHex("+0X1p1030")
@test_throws OverflowError fromHex("-0x1p+1100")
@test_throws OverflowError fromHex("0X1p123456789123456789")
@test_throws OverflowError fromHex("+0X.8p+1025")
@test_throws OverflowError fromHex("+0x0.8p1025")
@test_throws OverflowError fromHex("-0x0.4p1026")
@test_throws OverflowError fromHex("0X2p+1023")
@test_throws OverflowError fromHex("0x2.p1023")
@test_throws OverflowError fromHex("-0x2.0p+1023")
@test_throws OverflowError fromHex("+0X4p+1022")
@test_throws OverflowError fromHex("0x1.ffffffffffffffp+1023")
@test_throws OverflowError fromHex("-0X1.fffffffffffff9p1023")
@test_throws OverflowError fromHex("0X1.fffffffffffff8p1023")
@test_throws OverflowError fromHex("+0x3.fffffffffffffp1022")
@test_throws OverflowError fromHex("0x3fffffffffffffp+970")
@test_throws OverflowError fromHex("0x10000000000000000p960")
@test_throws OverflowError fromHex("-0Xffffffffffffffffp960")
identical(self, fromHex("+0x1.fffffffffffffp+1023"), MAX)
identical(self, fromHex("-0X1.fffffffffffff7p1023"), -(MAX))
identical(self, fromHex("0X1.fffffffffffff7fffffffffffffp1023"), MAX)
identical(self, fromHex("0x0p0"), 0.0)
identical(self, fromHex("0x0p1000"), 0.0)
identical(self, fromHex("-0x0p1023"), -0.0)
identical(self, fromHex("0X0p1024"), 0.0)
identical(self, fromHex("-0x0p1025"), -0.0)
identical(self, fromHex("0X0p2000"), 0.0)
identical(self, fromHex("0x0p123456789123456789"), 0.0)
identical(self, fromHex("-0X0p-0"), -0.0)
identical(self, fromHex("-0X0p-1000"), -0.0)
identical(self, fromHex("0x0p-1023"), 0.0)
identical(self, fromHex("-0X0p-1024"), -0.0)
identical(self, fromHex("-0x0p-1025"), -0.0)
identical(self, fromHex("-0x0p-1072"), -0.0)
identical(self, fromHex("0X0p-1073"), 0.0)
identical(self, fromHex("-0x0p-1074"), -0.0)
identical(self, fromHex("0x0p-1075"), 0.0)
identical(self, fromHex("0X0p-1076"), 0.0)
identical(self, fromHex("-0X0p-2000"), -0.0)
identical(self, fromHex("-0x0p-123456789123456789"), -0.0)
identical(self, fromHex("0X1p-1075"), 0.0)
identical(self, fromHex("-0X1p-1075"), -0.0)
identical(self, fromHex("-0x1p-123456789123456789"), -0.0)
identical(self, fromHex("0x1.00000000000000001p-1075"), TINY)
identical(self, fromHex("-0x1.1p-1075"), -(TINY))
identical(self, fromHex("0x1.fffffffffffffffffp-1075"), TINY)
identical(self, fromHex("0x1p-1076"), 0.0)
identical(self, fromHex("0X2p-1076"), 0.0)
identical(self, fromHex("0X3p-1076"), TINY)
identical(self, fromHex("0x4p-1076"), TINY)
identical(self, fromHex("0X5p-1076"), TINY)
identical(self, fromHex("0X6p-1076"), 2*TINY)
identical(self, fromHex("0x7p-1076"), 2*TINY)
identical(self, fromHex("0X8p-1076"), 2*TINY)
identical(self, fromHex("0X9p-1076"), 2*TINY)
identical(self, fromHex("0xap-1076"), 2*TINY)
identical(self, fromHex("0Xbp-1076"), 3*TINY)
identical(self, fromHex("0xcp-1076"), 3*TINY)
identical(self, fromHex("0Xdp-1076"), 3*TINY)
identical(self, fromHex("0Xep-1076"), 4*TINY)
identical(self, fromHex("0xfp-1076"), 4*TINY)
identical(self, fromHex("0x10p-1076"), 4*TINY)
identical(self, fromHex("-0x1p-1076"), -0.0)
identical(self, fromHex("-0X2p-1076"), -0.0)
identical(self, fromHex("-0x3p-1076"), -(TINY))
identical(self, fromHex("-0X4p-1076"), -(TINY))
identical(self, fromHex("-0x5p-1076"), -(TINY))
identical(self, fromHex("-0x6p-1076"), -2*TINY)
identical(self, fromHex("-0X7p-1076"), -2*TINY)
identical(self, fromHex("-0X8p-1076"), -2*TINY)
identical(self, fromHex("-0X9p-1076"), -2*TINY)
identical(self, fromHex("-0Xap-1076"), -2*TINY)
identical(self, fromHex("-0xbp-1076"), -3*TINY)
identical(self, fromHex("-0xcp-1076"), -3*TINY)
identical(self, fromHex("-0Xdp-1076"), -3*TINY)
identical(self, fromHex("-0xep-1076"), -4*TINY)
identical(self, fromHex("-0Xfp-1076"), -4*TINY)
identical(self, fromHex("-0X10p-1076"), -4*TINY)
identical(self, fromHex("0x0.ffffffffffffd6p-1022"), MIN - 3*TINY)
identical(self, fromHex("0x0.ffffffffffffd8p-1022"), MIN - 2*TINY)
identical(self, fromHex("0x0.ffffffffffffdap-1022"), MIN - 2*TINY)
identical(self, fromHex("0x0.ffffffffffffdcp-1022"), MIN - 2*TINY)
identical(self, fromHex("0x0.ffffffffffffdep-1022"), MIN - 2*TINY)
identical(self, fromHex("0x0.ffffffffffffe0p-1022"), MIN - 2*TINY)
identical(self, fromHex("0x0.ffffffffffffe2p-1022"), MIN - 2*TINY)
identical(self, fromHex("0x0.ffffffffffffe4p-1022"), MIN - 2*TINY)
identical(self, fromHex("0x0.ffffffffffffe6p-1022"), MIN - 2*TINY)
identical(self, fromHex("0x0.ffffffffffffe8p-1022"), MIN - 2*TINY)
identical(self, fromHex("0x0.ffffffffffffeap-1022"), MIN - TINY)
identical(self, fromHex("0x0.ffffffffffffecp-1022"), MIN - TINY)
identical(self, fromHex("0x0.ffffffffffffeep-1022"), MIN - TINY)
identical(self, fromHex("0x0.fffffffffffff0p-1022"), MIN - TINY)
identical(self, fromHex("0x0.fffffffffffff2p-1022"), MIN - TINY)
identical(self, fromHex("0x0.fffffffffffff4p-1022"), MIN - TINY)
identical(self, fromHex("0x0.fffffffffffff6p-1022"), MIN - TINY)
identical(self, fromHex("0x0.fffffffffffff8p-1022"), MIN)
identical(self, fromHex("0x0.fffffffffffffap-1022"), MIN)
identical(self, fromHex("0x0.fffffffffffffcp-1022"), MIN)
identical(self, fromHex("0x0.fffffffffffffep-1022"), MIN)
identical(self, fromHex("0x1.00000000000000p-1022"), MIN)
identical(self, fromHex("0x1.00000000000002p-1022"), MIN)
identical(self, fromHex("0x1.00000000000004p-1022"), MIN)
identical(self, fromHex("0x1.00000000000006p-1022"), MIN)
identical(self, fromHex("0x1.00000000000008p-1022"), MIN)
identical(self, fromHex("0x1.0000000000000ap-1022"), MIN + TINY)
identical(self, fromHex("0x1.0000000000000cp-1022"), MIN + TINY)
identical(self, fromHex("0x1.0000000000000ep-1022"), MIN + TINY)
identical(self, fromHex("0x1.00000000000010p-1022"), MIN + TINY)
identical(self, fromHex("0x1.00000000000012p-1022"), MIN + TINY)
identical(self, fromHex("0x1.00000000000014p-1022"), MIN + TINY)
identical(self, fromHex("0x1.00000000000016p-1022"), MIN + TINY)
identical(self, fromHex("0x1.00000000000018p-1022"), MIN + 2*TINY)
identical(self, fromHex("0x0.fffffffffffff0p0"), 1.0 - EPS)
identical(self, fromHex("0x0.fffffffffffff1p0"), 1.0 - EPS)
identical(self, fromHex("0X0.fffffffffffff2p0"), 1.0 - EPS)
identical(self, fromHex("0x0.fffffffffffff3p0"), 1.0 - EPS)
identical(self, fromHex("0X0.fffffffffffff4p0"), 1.0 - EPS)
identical(self, fromHex("0X0.fffffffffffff5p0"), 1.0 - (EPS / 2))
identical(self, fromHex("0X0.fffffffffffff6p0"), 1.0 - (EPS / 2))
identical(self, fromHex("0x0.fffffffffffff7p0"), 1.0 - (EPS / 2))
identical(self, fromHex("0x0.fffffffffffff8p0"), 1.0 - (EPS / 2))
identical(self, fromHex("0X0.fffffffffffff9p0"), 1.0 - (EPS / 2))
identical(self, fromHex("0X0.fffffffffffffap0"), 1.0 - (EPS / 2))
identical(self, fromHex("0x0.fffffffffffffbp0"), 1.0 - (EPS / 2))
identical(self, fromHex("0X0.fffffffffffffcp0"), 1.0)
identical(self, fromHex("0x0.fffffffffffffdp0"), 1.0)
identical(self, fromHex("0X0.fffffffffffffep0"), 1.0)
identical(self, fromHex("0x0.ffffffffffffffp0"), 1.0)
identical(self, fromHex("0X1.00000000000000p0"), 1.0)
identical(self, fromHex("0X1.00000000000001p0"), 1.0)
identical(self, fromHex("0x1.00000000000002p0"), 1.0)
identical(self, fromHex("0X1.00000000000003p0"), 1.0)
identical(self, fromHex("0x1.00000000000004p0"), 1.0)
identical(self, fromHex("0X1.00000000000005p0"), 1.0)
identical(self, fromHex("0X1.00000000000006p0"), 1.0)
identical(self, fromHex("0X1.00000000000007p0"), 1.0)
identical(self, fromHex("0x1.00000000000007ffffffffffffffffffffp0"), 1.0)
identical(self, fromHex("0x1.00000000000008p0"), 1.0)
identical(self, fromHex("0x1.00000000000008000000000000000001p0"), 1 + EPS)
identical(self, fromHex("0X1.00000000000009p0"), 1.0 + EPS)
identical(self, fromHex("0x1.0000000000000ap0"), 1.0 + EPS)
identical(self, fromHex("0x1.0000000000000bp0"), 1.0 + EPS)
identical(self, fromHex("0X1.0000000000000cp0"), 1.0 + EPS)
identical(self, fromHex("0x1.0000000000000dp0"), 1.0 + EPS)
identical(self, fromHex("0x1.0000000000000ep0"), 1.0 + EPS)
identical(self, fromHex("0X1.0000000000000fp0"), 1.0 + EPS)
identical(self, fromHex("0x1.00000000000010p0"), 1.0 + EPS)
identical(self, fromHex("0X1.00000000000011p0"), 1.0 + EPS)
identical(self, fromHex("0x1.00000000000012p0"), 1.0 + EPS)
identical(self, fromHex("0X1.00000000000013p0"), 1.0 + EPS)
identical(self, fromHex("0X1.00000000000014p0"), 1.0 + EPS)
identical(self, fromHex("0x1.00000000000015p0"), 1.0 + EPS)
identical(self, fromHex("0x1.00000000000016p0"), 1.0 + EPS)
identical(self, fromHex("0X1.00000000000017p0"), 1.0 + EPS)
identical(self, fromHex("0x1.00000000000017ffffffffffffffffffffp0"), 1.0 + EPS)
identical(self, fromHex("0x1.00000000000018p0"), 1.0 + 2*EPS)
identical(self, fromHex("0X1.00000000000018000000000000000001p0"), 1.0 + 2*EPS)
identical(self, fromHex("0x1.00000000000019p0"), 1.0 + 2*EPS)
identical(self, fromHex("0X1.0000000000001ap0"), 1.0 + 2*EPS)
identical(self, fromHex("0X1.0000000000001bp0"), 1.0 + 2*EPS)
identical(self, fromHex("0x1.0000000000001cp0"), 1.0 + 2*EPS)
identical(self, fromHex("0x1.0000000000001dp0"), 1.0 + 2*EPS)
identical(self, fromHex("0x1.0000000000001ep0"), 1.0 + 2*EPS)
identical(self, fromHex("0X1.0000000000001fp0"), 1.0 + 2*EPS)
identical(self, fromHex("0x1.00000000000020p0"), 1.0 + 2*EPS)
identical(self, fromHex("0x.8p-1074"), 0.0)
identical(self, fromHex("0x.80p-1074"), 0.0)
identical(self, fromHex("0x.81p-1074"), TINY)
identical(self, fromHex("0x8p-1078"), 0.0)
identical(self, fromHex("0x8.0p-1078"), 0.0)
identical(self, fromHex("0x8.1p-1078"), TINY)
identical(self, fromHex("0x80p-1082"), 0.0)
identical(self, fromHex("0x81p-1082"), TINY)
identical(self, fromHex(".8p-1074"), 0.0)
identical(self, fromHex("8p-1078"), 0.0)
identical(self, fromHex("-.8p-1074"), -0.0)
identical(self, fromHex("+8p-1078"), 0.0)
end

function test_roundtrip(self::HexFloatTestCase)
function roundtrip(x)
return fromHex(toHex(x))
end

for x in [NAN, INF, self.MAX, self.MIN, self.MIN - self.TINY, self.TINY, 0.0]
identical(self, x, roundtrip(x))
identical(self, -(x), roundtrip(-(x)))
end
for i in 0:9999
e = randrange(-1200, 1200)
m = random()
s = choice([1.0, -1.0])
try
x = s*ldexp(m, e)
catch exn
if exn isa OverflowError
#= pass =#
end
end
end
end

function test_subclass(self::F2)
mutable struct F <: AbstractF

end
function __new__(cls, value)
return __new__(float, cls)
end

f = F.fromhex(hex(1.5))
assertIs(self, type_(f), F)
assertEqual(self, f, 2.5)
mutable struct F2 <: AbstractF2
foo::String
end

f = F2.fromhex(hex(1.5))
assertIs(self, type_(f), F2)
assertEqual(self, f, 1.5)
assertEqual(self, (hasfield(typeof(f), :foo) ? 
                getfield(f, :foo) : "none"), "bar")
end

if abspath(PROGRAM_FILE) == @__FILE__
general_float_cases = GeneralFloatCases()
test_float(general_float_cases)
test_noargs(general_float_cases)
test_underscores(general_float_cases)
test_non_numeric_input_types(general_float_cases)
test_float_memoryview(general_float_cases)
test_error_message(general_float_cases)
test_float_with_comma(general_float_cases)
test_floatconversion(general_float_cases)
test_keyword_args(general_float_cases)
test_is_integer(general_float_cases)
test_floatasratio(general_float_cases)
test_float_containment(general_float_cases)
assertEqualAndEqualSign(general_float_cases)
test_float_floor(general_float_cases)
test_float_ceil(general_float_cases)
test_float_mod(general_float_cases)
test_float_pow(general_float_cases)
test_hash(general_float_cases)
test_hash_nan(general_float_cases)
format_functions_test_case = FormatFunctionsTestCase()
setUp(format_functions_test_case)
tearDown(format_functions_test_case)
test_getformat(format_functions_test_case)
test_setformat(format_functions_test_case)
unknown_format_test_case = UnknownFormatTestCase()
setUp(unknown_format_test_case)
tearDown(unknown_format_test_case)
test_double_specials_dont_unpack(unknown_format_test_case)
test_float_specials_dont_unpack(unknown_format_test_case)
i_e_e_e_format_test_case = IEEEFormatTestCase()
test_double_specials_do_unpack(i_e_e_e_format_test_case)
test_float_specials_do_unpack(i_e_e_e_format_test_case)
test_serialized_float_rounding(i_e_e_e_format_test_case)
format_test_case = FormatTestCase()
test_format(format_test_case)
test_format_testfile(format_test_case)
test_issue5864(format_test_case)
test_issue35560(format_test_case)
repr_test_case = ReprTestCase()
test_repr(repr_test_case)
test_short_repr(repr_test_case)
round_test_case = RoundTestCase()
test_inf_nan(round_test_case)
test_large_n(round_test_case)
test_small_n(round_test_case)
test_overflow(round_test_case)
test_previous_round_bugs(round_test_case)
test_matches_float_format(round_test_case)
test_format_specials(round_test_case)
test_None_ndigits(round_test_case)
inf_nan_test = InfNanTest()
test_inf_from_str(inf_nan_test)
test_inf_as_str(inf_nan_test)
test_nan_from_str(inf_nan_test)
test_nan_as_str(inf_nan_test)
test_inf_signs(inf_nan_test)
test_nan_signs(inf_nan_test)
hex_float_test_case = HexFloatTestCase()
identical(hex_float_test_case)
test_ends(hex_float_test_case)
test_invalid_inputs(hex_float_test_case)
test_whitespace(hex_float_test_case)
test_from_hex(hex_float_test_case)
test_roundtrip(hex_float_test_case)
test_subclass(hex_float_test_case)
end
=======
>>>>>>> f214ca7f5ced7424e7132e581746e8672e842fb6
