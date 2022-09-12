# Transpiled with flags: 
# - oop
using ObjectOriented
using Random
using Test

import locale
using _testcapi: FLT_MAX
import fractions








using test.test_grammar: VALID_UNDERSCORE_LITERALS, INVALID_UNDERSCORE_LITERALS

INF = parse(Float64, "inf")
NAN = parse(Float64, "nan")
have_getformat = hasfield(typeof(Float64), :__getformat__)
requires_getformat = unittest.skipUnless(have_getformat, "requires __getformat__")
requires_setformat = unittest.skipUnless(hasfield(typeof(Float64), :__setformat__), "requires __setformat__")
test_dir = os.dirname(@__FILE__)||os.curdir
format_testfile = os.join(test_dir, "formatfloat_testcases.txt")
@oodef mutable struct FloatSubclass <: Float64
                    
                    
                    
                end
                

@oodef mutable struct OtherFloatSubclass <: Float64
                    
                    
                    
                end
                

@oodef mutable struct CustomStr <: String
                    
                    
                    
                end
                

@oodef mutable struct CustomBytes <: Array{UInt8}
                    
                    
                    
                end
                

@oodef mutable struct CustomByteArray <: Vector{UInt8}
                    
                    
                    
                end
                

@oodef mutable struct Foo1 <: object
                    
                    
                    
                end
                function __float__(self::@like(Foo1))::Float64
return 42.0
end


@oodef mutable struct Foo2 <: Float64
                    
                    
                    
                end
                function __float__(self::@like(Foo2))::Float64
return 42.0
end


@oodef mutable struct Foo3 <: Float64
                    
                    
                    
                end
                function __new__(cls::@like(Foo3), value = 0.0)
return __new__(Float64, cls)
end

function __float__(self::@like(Foo3))
return self
end


@oodef mutable struct Foo4 <: Float64
                    
                    
                    
                end
                function __float__(self::@like(Foo4))::Int64
return 42
end


@oodef mutable struct FooStr <: String
                    
                    
                    
                end
                function __float__(self::@like(FooStr))
return parse(Float64, string(self)) + 1
end


@oodef mutable struct Foo5
                    
                    
                    
                end
                function __float__(self::@like(Foo5))::String
return ""
end


@oodef mutable struct F
                    
                    
                    
                end
                function __float__(self::@like(F))::OtherFloatSubclass
return OtherFloatSubclass(42.0)
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


@oodef mutable struct H
                    
                    
                    
                end
                function __hash__(self::@like(H))::Int64
return 42
end


@oodef mutable struct F <: {Float64, H}
                    
                    
                    
                end
                

@oodef mutable struct GeneralFloatCases <: unittest.TestCase
                    
                    
                    
                end
                function test_float(self::@like(GeneralFloatCases))
@test (float(3.14) == 3.14)
@test (float(314) == 314.0)
@test (parse(Float64, "  3.14  ") == 3.14)
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
@test_throws TypeError Float64(Float64, Dict())
            @test match(@r_str("not \'dict\'"), repr(Float64))
@test_throws
@test_throws
@test_throws
@test (parse(Float64, "  ٣.١٤  ") == 3.14)
@test (parse(Float64, " 3.14 ") == 3.14)
float([b"."; repeat(b"1",1000)])
parse(Float64, "." * repeat("1",1000))
@test_throws
end

function test_noargs(self::@like(GeneralFloatCases))
@test (zero(Float64) == 0.0)
end

function test_underscores(self::@like(GeneralFloatCases))
for lit in VALID_UNDERSCORE_LITERALS
if !any((ch ∈ lit for ch in "jJxXoObB"))
@test (float(lit) == py"lit")
@test (float(lit) == float(replace(lit, "_", "")))
end
end
for lit in INVALID_UNDERSCORE_LITERALS
if lit ∈ ("0_7", "09_99")
continue;
end
if !any((ch ∈ lit for ch in "jJxXoObB"))
@test_throws
end
end
@test_throws
@test_throws
@test_throws
@test_throws
@test_throws
@test_throws
end

function test_non_numeric_input_types(self::@like(GeneralFloatCases))
factories = [Array{UInt8}, Vector{UInt8}, (b) -> CustomStr(decode(b)), CustomBytes, CustomByteArray, memoryview]
try
catch exn
if exn isa ImportError
#= pass =#
end
end
for f in factories
x = f(b" 3.14  ")
subTest(self, type_(x)) do 
@test (float(x) == 3.14)
assertRaisesRegex(self, ValueError, "could not convert") do 
float(f(repeat(b"A",16)))
end
end
end
end

function test_float_memoryview(self::@like(GeneralFloatCases))
@test (float(memoryview(b"12.3")[2:4]) == 2.3)
@test (float(memoryview(b"12.3\x00")[2:4]) == 2.3)
@test (float(memoryview(b"12.3 ")[2:4]) == 2.3)
@test (float(memoryview(b"12.3A")[2:4]) == 2.3)
@test (float(memoryview(b"12.34")[2:4]) == 2.3)
end

function test_error_message(self::@like(GeneralFloatCases))
function check(s::@like(GeneralFloatCases))
@test_throws ValueError do cm 
float(s)
end
@test (string(cm.exception) == "could not convert string to float: $(s)")
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

function test_float_with_comma(self::@like(GeneralFloatCases))
if !(locale.localeconv()["decimal_point"] == ",")
skipTest(self, "decimal_point is not \",\"")
end
@test (parse(Float64, "  3.14  ") == 3.14)
@test (parse(Float64, "+3.14  ") == 3.14)
@test (parse(Float64, "-3.14  ") == -3.14)
@test (parse(Float64, ".14  ") == 0.14)
@test (parse(Float64, "3.  ") == 3.0)
@test (parse(Float64, "3.e3  ") == 3000.0)
@test (parse(Float64, "3.2e3  ") == 3200.0)
@test (parse(Float64, "2.5e-1  ") == 0.25)
@test (parse(Float64, "5e-1") == 0.5)
@test_throws
@test_throws
@test_throws
@test_throws
@test_throws
@test_throws
@test (parse(Float64, "  25.e-1  ") == 2.5)
assertAlmostEqual(self, parse(Float64, "  .25e-1  "), 0.025)
end

function test_floatconversion(self::@like(GeneralFloatCases))
@test (float(Foo1()) == 42.0)
@test (float(Foo2()) == 42.0)
assertWarns(self, DeprecationWarning) do 
@test (float(Foo3(21)) == 42.0)
end
@test_throws
@test (float(FooStr("8")) == 9.0)
@test_throws
assertWarns(self, DeprecationWarning) do 
@test (float(F()) == 42.0)
end
assertWarns(self, DeprecationWarning) do 
@test self === type_(float(F()))
end
assertWarns(self, DeprecationWarning) do 
@test (FloatSubclass(F()) == 42.0)
end
assertWarns(self, DeprecationWarning) do 
@test self === type_(FloatSubclass(F()))
end
@test (float(MyIndex(42)) == 42.0)
@test_throws
@test_throws
end

function test_keyword_args(self::@like(GeneralFloatCases))
assertRaisesRegex(self, TypeError, "keyword argument") do 
zero(Float64)
end
end

function test_is_integer(self::@like(GeneralFloatCases))
@test !(is_integer(1.1))
@test is_integer(1.0)
@test !(is_integer(parse(Float64, "nan")))
@test !(is_integer(parse(Float64, "inf")))
end

function test_floatasratio(self::@like(GeneralFloatCases))
for (f, ratio) in [(0.875, (7, 8)), (-0.875, (-7, 8)), (0.0, (0, 1)), (11.5, (23, 2))]
@test (as_integer_ratio(f) == ratio)
end
for i in 0:9999
f = rand()
f *= 10^random.randint(-100, 100)
(n, d) = as_integer_ratio(f)
@test (__truediv__(float(n), d) == f)
end
R = fractions.Fraction
@test (R(0, 1) == R(as_integer_ratio(float(0.0))...))
@test (R(5, 2) == R(as_integer_ratio(float(2.5))...))
@test (R(1, 2) == R(as_integer_ratio(float(0.5))...))
@test (R(4728779608739021, 2251799813685248) == R(as_integer_ratio(float(2.1))...))
@test (R(-4728779608739021, 2251799813685248) == R(as_integer_ratio(float(-2.1))...))
@test (R(-2100, 1) == R(as_integer_ratio(float(-2100.0))...))
@test_throws
@test_throws
@test_throws
end

function test_float_containment(self::@like(GeneralFloatCases))
floats = (INF, -INF, 0.0, 1.0, NAN)
for f in floats
assertIn(self, f, [f])
assertIn(self, f, (f,))
assertIn(self, f, Set([f]))
assertIn(self, f, Dict{float, Any}(f => nothing))
@test (count(isequal(f), [f]) == 1)
assertIn(self, f, floats)
end
for f in floats
@test [f] == [f]
@test (f,) == (f,)
@test Set([f]) == Set([f])
@test Dict{float, Any}(f => nothing) == Dict{float, Any}(f => nothing)
(l, t, s, d) = ([f], (f,), Set([f]), Dict{float, Any}(f => nothing))
@test l == l
@test t == t
@test s == s
@test d == d
end
end

function assertEqualAndEqualSign(self::@like(GeneralFloatCases), a, b)
@test ((a, copysign(1.0, a)) == (b, copysign(1.0, b)))
end

function test_float_floor(self::@like(GeneralFloatCases))
@test isa(self, __floor__(float(0.5)))
@test (__floor__(float(0.5)) == 0)
@test (__floor__(float(1.0)) == 1)
@test (__floor__(float(1.5)) == 1)
@test (__floor__(float(-0.5)) == -1)
@test (__floor__(float(-1.0)) == -1)
@test (__floor__(float(-1.5)) == -2)
@test (__floor__(float(1.23e+167)) == 1.23e+167)
@test (__floor__(float(-1.23e+167)) == -1.23e+167)
@test_throws
@test_throws
@test_throws
end

function test_float_ceil(self::@like(GeneralFloatCases))
@test isa(self, __ceil__(float(0.5)))
@test (__ceil__(float(0.5)) == 1)
@test (__ceil__(float(1.0)) == 1)
@test (__ceil__(float(1.5)) == 2)
@test (__ceil__(float(-0.5)) == 0)
@test (__ceil__(float(-1.0)) == -1)
@test (__ceil__(float(-1.5)) == -1)
@test (__ceil__(float(1.23e+167)) == 1.23e+167)
@test (__ceil__(float(-1.23e+167)) == -1.23e+167)
@test_throws
@test_throws
@test_throws
end

function test_float_mod(self::@like(GeneralFloatCases))
mod_ = mod
assertEqualAndEqualSign(self, mod_(-1.0, 1.0), 0.0)
assertEqualAndEqualSign(self, mod_(-1e-100, 1.0), 1.0)
assertEqualAndEqualSign(self, mod_(-0.0, 1.0), 0.0)
assertEqualAndEqualSign(self, mod_(0.0, 1.0), 0.0)
assertEqualAndEqualSign(self, mod_(1e-100, 1.0), 1e-100)
assertEqualAndEqualSign(self, mod_(1.0, 1.0), 0.0)
assertEqualAndEqualSign(self, mod_(-1.0, -1.0), -0.0)
assertEqualAndEqualSign(self, mod_(-1e-100, -1.0), -1e-100)
assertEqualAndEqualSign(self, mod_(-0.0, -1.0), -0.0)
assertEqualAndEqualSign(self, mod_(0.0, -1.0), -0.0)
assertEqualAndEqualSign(self, mod_(1e-100, -1.0), -1.0)
assertEqualAndEqualSign(self, mod_(1.0, -1.0), -0.0)
end

function test_float_pow(self::@like(GeneralFloatCases))
for pow_op in (pow, operator.pow)
@test isnan(pow_op(-INF, NAN))
@test isnan(pow_op(-2.0, NAN))
@test isnan(pow_op(-1.0, NAN))
@test isnan(pow_op(-0.5, NAN))
@test isnan(pow_op(-0.0, NAN))
@test isnan(pow_op(0.0, NAN))
@test isnan(pow_op(0.5, NAN))
@test isnan(pow_op(2.0, NAN))
@test isnan(pow_op(INF, NAN))
@test isnan(pow_op(NAN, NAN))
@test isnan(pow_op(NAN, -INF))
@test isnan(pow_op(NAN, -2.0))
@test isnan(pow_op(NAN, -1.0))
@test isnan(pow_op(NAN, -0.5))
@test isnan(pow_op(NAN, 0.5))
@test isnan(pow_op(NAN, 1.0))
@test isnan(pow_op(NAN, 2.0))
@test isnan(pow_op(NAN, INF))
@test_throws
@test_throws
@test_throws
@test_throws
@test_throws
@test_throws
assertEqualAndEqualSign(self, pow_op(-0.0, 1.0), -0.0)
assertEqualAndEqualSign(self, pow_op(0.0, 1.0), 0.0)
assertEqualAndEqualSign(self, pow_op(-0.0, 0.5), 0.0)
assertEqualAndEqualSign(self, pow_op(-0.0, 2.0), 0.0)
assertEqualAndEqualSign(self, pow_op(0.0, 0.5), 0.0)
assertEqualAndEqualSign(self, pow_op(0.0, 2.0), 0.0)
assertEqualAndEqualSign(self, pow_op(-1.0, -INF), 1.0)
assertEqualAndEqualSign(self, pow_op(-1.0, INF), 1.0)
assertEqualAndEqualSign(self, pow_op(1.0, -INF), 1.0)
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
assertEqualAndEqualSign(self, pow_op(-INF, 0.0), 1.0)
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
assertEqualAndEqualSign(self, pow_op(-INF, -0.0), 1.0)
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
@test (type_(pow_op(-2.0, -0.5)) == Complex)
@test (type_(pow_op(-2.0, 0.5)) == Complex)
@test (type_(pow_op(-1.0, -0.5)) == Complex)
@test (type_(pow_op(-1.0, 0.5)) == Complex)
@test (type_(pow_op(-0.5, -0.5)) == Complex)
@test (type_(pow_op(-0.5, 0.5)) == Complex)
assertEqualAndEqualSign(self, pow_op(-0.5, -INF), INF)
assertEqualAndEqualSign(self, pow_op(-0.0, -INF), INF)
assertEqualAndEqualSign(self, pow_op(0.0, -INF), INF)
assertEqualAndEqualSign(self, pow_op(0.5, -INF), INF)
assertEqualAndEqualSign(self, pow_op(-INF, -INF), 0.0)
assertEqualAndEqualSign(self, pow_op(-2.0, -INF), 0.0)
assertEqualAndEqualSign(self, pow_op(2.0, -INF), 0.0)
assertEqualAndEqualSign(self, pow_op(INF, -INF), 0.0)
assertEqualAndEqualSign(self, pow_op(-0.5, INF), 0.0)
assertEqualAndEqualSign(self, pow_op(-0.0, INF), 0.0)
assertEqualAndEqualSign(self, pow_op(0.0, INF), 0.0)
assertEqualAndEqualSign(self, pow_op(0.5, INF), 0.0)
assertEqualAndEqualSign(self, pow_op(-INF, INF), INF)
assertEqualAndEqualSign(self, pow_op(-2.0, INF), INF)
assertEqualAndEqualSign(self, pow_op(2.0, INF), INF)
assertEqualAndEqualSign(self, pow_op(INF, INF), INF)
assertEqualAndEqualSign(self, pow_op(-INF, -1.0), -0.0)
assertEqualAndEqualSign(self, pow_op(-INF, -0.5), 0.0)
assertEqualAndEqualSign(self, pow_op(-INF, -2.0), 0.0)
assertEqualAndEqualSign(self, pow_op(-INF, 1.0), -INF)
assertEqualAndEqualSign(self, pow_op(-INF, 0.5), INF)
assertEqualAndEqualSign(self, pow_op(-INF, 2.0), INF)
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
@test (type_(pow_op(-2.0, -2000.5)) == Complex)
assertEqualAndEqualSign(self, pow_op(-2.0, -2001.0), -0.0)
assertEqualAndEqualSign(self, pow_op(2.0, -2000.0), 0.0)
assertEqualAndEqualSign(self, pow_op(2.0, -2000.5), 0.0)
assertEqualAndEqualSign(self, pow_op(2.0, -2001.0), 0.0)
assertEqualAndEqualSign(self, pow_op(-0.5, 2000.0), 0.0)
@test (type_(pow_op(-0.5, 2000.5)) == Complex)
assertEqualAndEqualSign(self, pow_op(-0.5, 2001.0), -0.0)
assertEqualAndEqualSign(self, pow_op(0.5, 2000.0), 0.0)
assertEqualAndEqualSign(self, pow_op(0.5, 2000.5), 0.0)
assertEqualAndEqualSign(self, pow_op(0.5, 2001.0), 0.0)
end
end

function test_hash(self::@like(GeneralFloatCases))
for x in -30:29
@test (hash(float(x)) == hash(x))
end
@test (hash(float(sys.float_info.max)) == hash(parse(Int, sys.float_info.max)))
@test (hash(parse(Float64, "inf")) == sys.hash_info.inf)
@test (hash(parse(Float64, "-inf")) == -(sys.hash_info.inf))
end

function test_hash_nan(self::@like(GeneralFloatCases))
value = parse(Float64, "nan")
@test (hash(value) == __hash__(object, value))
value = F("nan")
@test (hash(value) == __hash__(object, value))
end


@oodef mutable struct FormatFunctionsTestCase <: unittest.TestCase
                    
                    save_formats::Dict{String, Any}
                    
function new(save_formats::Dict{String, Any} = Dict{String, Any}("double" => __getformat__(Float64, "double"), "float" => __getformat__(Float64, "float")))
save_formats = save_formats
new(save_formats)
end

                end
                function setUp(self::@like(FormatFunctionsTestCase))
self.save_formats = Dict{String, Any}("double" => __getformat__(Float64, "double"), "float" => __getformat__(Float64, "float"))
end

function tearDown(self::@like(FormatFunctionsTestCase))
__setformat__(Float64, "double", self.save_formats["double"])
__setformat__(Float64, "float", self.save_formats["float"])
end

function test_getformat(self::@like(FormatFunctionsTestCase))
assertIn(self, __getformat__(Float64, "double"), ["unknown", "IEEE, big-endian", "IEEE, little-endian"])
assertIn(self, __getformat__(Float64, "float"), ["unknown", "IEEE, big-endian", "IEEE, little-endian"])
@test_throws
@test_throws
end

function test_setformat(self::@like(FormatFunctionsTestCase))
for t in ("double", "float")
__setformat__(Float64, t, "unknown")
if self.save_formats[t] == "IEEE, big-endian"
@test_throws
elseif self.save_formats[t] == "IEEE, little-endian"
@test_throws
else
@test_throws
@test_throws
end
@test_throws
end
@test_throws
end


BE_DOUBLE_INF = b"\x7f\xf0\x00\x00\x00\x00\x00\x00"
LE_DOUBLE_INF = bytes(reversed(BE_DOUBLE_INF))
BE_DOUBLE_NAN = b"\x7f\xf8\x00\x00\x00\x00\x00\x00"
LE_DOUBLE_NAN = bytes(reversed(BE_DOUBLE_NAN))
BE_FLOAT_INF = b"\x7f\x80\x00\x00"
LE_FLOAT_INF = bytes(reversed(BE_FLOAT_INF))
BE_FLOAT_NAN = b"\x7f\xc0\x00\x00"
LE_FLOAT_NAN = bytes(reversed(BE_FLOAT_NAN))
@oodef mutable struct UnknownFormatTestCase <: unittest.TestCase
                    
                    save_formats::Dict{String, Any}
                    
function new(save_formats::Dict{String, Any} = Dict{String, Any}("double" => __getformat__(Float64, "double"), "float" => __getformat__(Float64, "float")))
save_formats = save_formats
new(save_formats)
end

                end
                function setUp(self::@like(UnknownFormatTestCase))
self.save_formats = Dict{String, Any}("double" => __getformat__(Float64, "double"), "float" => __getformat__(Float64, "float"))
__setformat__(Float64, "double", "unknown")
__setformat__(Float64, "float", "unknown")
end

function tearDown(self::@like(UnknownFormatTestCase))
__setformat__(Float64, "double", self.save_formats["double"])
__setformat__(Float64, "float", self.save_formats["float"])
end

function test_double_specials_dont_unpack(self::@like(UnknownFormatTestCase))
for (fmt, data) in [(">d", BE_DOUBLE_INF), (">d", BE_DOUBLE_NAN), ("<d", LE_DOUBLE_INF), ("<d", LE_DOUBLE_NAN)]
@test_throws
end
end

function test_float_specials_dont_unpack(self::@like(UnknownFormatTestCase))
for (fmt, data) in [(">f", BE_FLOAT_INF), (">f", BE_FLOAT_NAN), ("<f", LE_FLOAT_INF), ("<f", LE_FLOAT_NAN)]
@test_throws
end
end


@oodef mutable struct IEEEFormatTestCase <: unittest.TestCase
                    
                    
                    
                end
                function test_double_specials_do_unpack(self::@like(IEEEFormatTestCase))
for (fmt, data) in [(">d", BE_DOUBLE_INF), (">d", BE_DOUBLE_NAN), ("<d", LE_DOUBLE_INF), ("<d", LE_DOUBLE_NAN)]
struct_.unpack(fmt, data)
end
end

function test_float_specials_do_unpack(self::@like(IEEEFormatTestCase))
for (fmt, data) in [(">f", BE_FLOAT_INF), (">f", BE_FLOAT_NAN), ("<f", LE_FLOAT_INF), ("<f", LE_FLOAT_NAN)]
struct_.unpack(fmt, data)
end
end

function test_serialized_float_rounding(self::@like(IEEEFormatTestCase))
@test (struct_.pack("<f", 3.40282356e+38) == struct_.pack("<f", FLT_MAX))
@test (struct_.pack("<f", -3.40282356e+38) == struct_.pack("<f", -FLT_MAX))
end


@oodef mutable struct FormatTestCase <: unittest.TestCase
                    
                    
                    
                end
                function test_format(self::@like(FormatTestCase))
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
@test_throws
for format_spec in [Char(x) for x in Int(codepoint('a')):Int(codepoint('z'))] + [Char(x) for x in Int(codepoint('A')):Int(codepoint('Z'))]
if !(format_spec ∈ "eEfFgGn%")
@test_throws
@test_throws
@test_throws
@test_throws
@test_throws
@test_throws
@test_throws
end
end
@test (NAN == "nan")
@test (NAN == "NAN")
@test (INF == "inf")
@test (INF == "INF")
end

function test_format_testfile(self::@like(FormatTestCase))
readline(format_testfile) do testfile 
for line in testfile
if startswith(line, "--")
continue;
end
line = strip(line)
if !line
continue;
end
(lhs, rhs) = map(String.strip, split(line, "->"))
(fmt, arg) = split(lhs)
@test (fmt % float(arg) == rhs)
@test (fmt % -float(arg) == "-" + rhs)
end
end
end

function test_issue5864(self::@like(FormatTestCase))
@test (123.456 == "123.5")
@test (1234.56 == "1.235e+03")
@test (12345.6 == "1.235e+04")
end

function test_issue35560(self::@like(FormatTestCase))
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


@oodef mutable struct ReprTestCase <: unittest.TestCase
                    
                    
                    
                end
                function test_repr(self::@like(ReprTestCase))
readline(os.join(os.split(@__FILE__)[1], "floating_points.txt")) do floats_file 
for line in floats_file
line = strip(line)
if !line||startswith(line, "#")
continue;
end
v = py"line"
@test (v == py"repr(v)")
end
end
end

function test_short_repr(self::@like(ReprTestCase))
test_strings = ["0.0", "1.0", "0.01", "0.02", "0.03", "0.04", "0.05", "1.23456789", "10.0", "100.0", "1000000000000000.0", "9999999999999990.0", "1e+16", "1e+17", "0.001", "0.001001", "0.00010000000000001", "0.0001", "9.999999999999e-05", "1e-05", "8.72293771110361e+25", "7.47005307342313e+26", "2.86438000439698e+28", "8.89142905246179e+28", "3.08578087079232e+35"]
for s in test_strings
negs = "-" * s
@test (s == repr(parse(Float64, s)))
@test (negs == repr(parse(Float64, negs)))
@test (repr(parse(Float64, s)) == string(parse(Float64, s)))
@test (repr(parse(Float64, negs)) == string(parse(Float64, negs)))
end
end


@oodef mutable struct RoundTestCase <: unittest.TestCase
                    
                    
                    
                end
                function test_inf_nan(self::@like(RoundTestCase))
@test_throws
@test_throws
@test_throws
@test_throws
@test_throws
@test_throws
@test_throws
end

function test_large_n(self::@like(RoundTestCase))
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

function test_small_n(self::@like(RoundTestCase))
for n in [-308, -309, -400, 1 - 2^31, -(2^31), -(2^31) - 1, -(2^100)]
@test (round(123.456, digits = n) == 0.0)
@test (round(-123.456, digits = n) == -0.0)
@test (round(1e+300, digits = n) == 0.0)
@test (round(1e-320, digits = n) == 0.0)
end
end

function test_overflow(self::@like(RoundTestCase))
@test_throws
@test_throws
end

function test_previous_round_bugs(self::@like(RoundTestCase))
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

function test_matches_float_format(self::@like(RoundTestCase))
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
x = rand()
@test (float(x) == round(x, digits = 0))
@test (float(x) == round(x, digits = 1))
@test (float(x) == round(x, digits = 2))
@test (float(x) == round(x, digits = 3))
end
end

function test_format_specials(self::@like(RoundTestCase))
function test(fmt::@like(RoundTestCase), value, expected)
@test (fmt % value == expected)
fmt = fmt[2:end]
@test (value == expected)
end

for fmt in ["%e", "%f", "%g", "%.0e", "%.6f", "%.20g", "%#e", "%#f", "%#g", "%#.20e", "%#.15f", "%#.3g"]
pfmt = "%+" * fmt[2:end]
sfmt = "% " * fmt[2:end]
test(fmt, INF, "inf")
test(fmt, -INF, "-inf")
test(fmt, NAN, "nan")
test(fmt, -NAN, "nan")
test(pfmt, INF, "+inf")
test(pfmt, -INF, "-inf")
test(pfmt, NAN, "+nan")
test(pfmt, -NAN, "+nan")
test(sfmt, INF, " inf")
test(sfmt, -INF, "-inf")
test(sfmt, NAN, " nan")
test(sfmt, -NAN, " nan")
end
end

function test_None_ndigits(self::@like(RoundTestCase))
for x in (round(1.23), round(1.23, digits = nothing), round(1.23, ndigits = nothing))
@test (x == 1)
@test isa(self, x)
end
for x in (round(1.78), round(1.78, digits = nothing), round(1.78, ndigits = nothing))
@test (x == 2)
@test isa(self, x)
end
end


@oodef mutable struct InfNanTest <: unittest.TestCase
                    
                    
                    
                end
                function test_inf_from_str(self::@like(InfNanTest))
@test isinf(parse(Float64, "inf"))
@test isinf(parse(Float64, "+inf"))
@test isinf(parse(Float64, "-inf"))
@test isinf(parse(Float64, "infinity"))
@test isinf(parse(Float64, "+infinity"))
@test isinf(parse(Float64, "-infinity"))
@test (repr(parse(Float64, "inf")) == "inf")
@test (repr(parse(Float64, "+inf")) == "inf")
@test (repr(parse(Float64, "-inf")) == "-inf")
@test (repr(parse(Float64, "infinity")) == "inf")
@test (repr(parse(Float64, "+infinity")) == "inf")
@test (repr(parse(Float64, "-infinity")) == "-inf")
@test (repr(parse(Float64, "INF")) == "inf")
@test (repr(parse(Float64, "+Inf")) == "inf")
@test (repr(parse(Float64, "-iNF")) == "-inf")
@test (repr(parse(Float64, "Infinity")) == "inf")
@test (repr(parse(Float64, "+iNfInItY")) == "inf")
@test (repr(parse(Float64, "-INFINITY")) == "-inf")
@test (string(parse(Float64, "inf")) == "inf")
@test (string(parse(Float64, "+inf")) == "inf")
@test (string(parse(Float64, "-inf")) == "-inf")
@test (string(parse(Float64, "infinity")) == "inf")
@test (string(parse(Float64, "+infinity")) == "inf")
@test (string(parse(Float64, "-infinity")) == "-inf")
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
end

function test_inf_as_str(self::@like(InfNanTest))
@test (repr(1e+300*1e+300) == "inf")
@test (repr(-1e+300*1e+300) == "-inf")
@test (string(1e+300*1e+300) == "inf")
@test (string(-1e+300*1e+300) == "-inf")
end

function test_nan_from_str(self::@like(InfNanTest))
@test isnan(parse(Float64, "nan"))
@test isnan(parse(Float64, "+nan"))
@test isnan(parse(Float64, "-nan"))
@test (repr(parse(Float64, "nan")) == "nan")
@test (repr(parse(Float64, "+nan")) == "nan")
@test (repr(parse(Float64, "-nan")) == "nan")
@test (repr(parse(Float64, "NAN")) == "nan")
@test (repr(parse(Float64, "+NAn")) == "nan")
@test (repr(parse(Float64, "-NaN")) == "nan")
@test (string(parse(Float64, "nan")) == "nan")
@test (string(parse(Float64, "+nan")) == "nan")
@test (string(parse(Float64, "-nan")) == "nan")
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
end

function test_nan_as_str(self::@like(InfNanTest))
@test (repr(1e+300*1e+300*0) == "nan")
@test (repr(-1e+300*1e+300*0) == "nan")
@test (string(1e+300*1e+300*0) == "nan")
@test (string(-1e+300*1e+300*0) == "nan")
end

function test_inf_signs(self::@like(InfNanTest))
@test (copysign(1.0, parse(Float64, "inf")) == 1.0)
@test (copysign(1.0, parse(Float64, "-inf")) == -1.0)
end

function test_nan_signs(self::@like(InfNanTest))
@test (copysign(1.0, parse(Float64, "nan")) == 1.0)
@test (copysign(1.0, parse(Float64, "-nan")) == -1.0)
end


fromHex = Float64.fromhex
toHex = Float64.hex
@oodef mutable struct F <: Float64
                    
                    
                    
                end
                function __new__(cls::@like(F), value)
return __new__(Float64, cls)
end


@oodef mutable struct F2 <: Float64
                    
                    foo::String
                    
function new(value, foo::String = "bar")
@mk begin
foo = foo
end
end

                end
                

@oodef mutable struct HexFloatTestCase <: unittest.TestCase
                    
                    EPS
MAX
MIN
TINY
                    
function new(EPS = fromHex("0x0.0000000000001p0"), MAX = fromHex("0x.fffffffffffff8p+1024"), MIN = fromHex("0x1p-1022"), TINY = fromHex("0x0.0000000000001p-1022"))
EPS = EPS
MAX = MAX
MIN = MIN
TINY = TINY
new(EPS, MAX, MIN, TINY)
end

                end
                function identical(self::@like(HexFloatTestCase), x, y)
if isnan(x)||isnan(y)
if isnan(x) == isnan(y)
return
end
elseif x == y&&x != 0.0||copysign(1.0, x) == copysign(1.0, y)
return
end
fail(self, "$(x) not identical to $(y)")
end

function test_ends(self::@like(HexFloatTestCase))
identical(self, self.MIN, ldexp(1.0, -1022))
identical(self, self.TINY, ldexp(1.0, -1074))
identical(self, self.EPS, ldexp(1.0, -52))
identical(self, self.MAX, 2.0*(ldexp(1.0, 1023) - ldexp(1.0, 970)))
end

function test_invalid_inputs(self::@like(HexFloatTestCase))
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

function test_whitespace(self::@like(HexFloatTestCase))
value_pairs = [("inf", INF), ("-Infinity", -INF), ("nan", NAN), ("1.0", 1.0), ("-0x.2", -0.125), ("-0.0", -0.0)]
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

function test_from_hex(self::@like(HexFloatTestCase))
MIN = self.MIN
MAX = self.MAX
TINY = self.TINY
EPS = self.EPS
identical(self, fromHex("inf"), INF)
identical(self, fromHex("+Inf"), INF)
identical(self, fromHex("-INF"), -INF)
identical(self, fromHex("iNf"), INF)
identical(self, fromHex("Infinity"), INF)
identical(self, fromHex("+INFINITY"), INF)
identical(self, fromHex("-infinity"), -INF)
identical(self, fromHex("-iNFiNitY"), -INF)
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
@test_throws
@test_throws
identical(self, fromHex("+0x1.fffffffffffffp+1023"), MAX)
identical(self, fromHex("-0X1.fffffffffffff7p1023"), -MAX)
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
identical(self, fromHex("-0x1.1p-1075"), -TINY)
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
identical(self, fromHex("-0x3p-1076"), -TINY)
identical(self, fromHex("-0X4p-1076"), -TINY)
identical(self, fromHex("-0x5p-1076"), -TINY)
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

function test_roundtrip(self::@like(HexFloatTestCase))
function roundtrip(x::@like(HexFloatTestCase))
return fromHex(toHex(x))
end

for x in [NAN, INF, self.MAX, self.MIN, self.MIN - self.TINY, self.TINY, 0.0]
identical(self, x, roundtrip(x))
identical(self, -x, roundtrip(-x))
end
for i in 0:9999
e = random.randrange(-1200, 1200)
m = rand()
s = random.choice([1.0, -1.0])
try
x = s*ldexp(m, e)
catch exn
if exn isa OverflowError
#= pass =#
end
end
end
end

function test_subclass(self::@like(HexFloatTestCase))
f = F.fromhex(hex(1.5))
@test self === type_(f)
@test (f == 2.5)
f = F2.fromhex(hex(1.5))
@test self === type_(f)
@test (f == 1.5)
@test ((hasfield(typeof(f), :foo) ? 
                getfield(f, :foo) : "none") == "bar")
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
test_contains = TestContains()
test_common_tests(test_contains)
test_builtin_sequence_types(test_contains)
test_nonreflexive(test_contains)
test_block_fallback(test_contains)
test_abstract_context_manager = TestAbstractContextManager()
test_enter(test_abstract_context_manager)
test_exit_is_abstract(test_abstract_context_manager)
test_structural_subclassing(test_abstract_context_manager)
context_manager_test_case = ContextManagerTestCase()
test_contextmanager_plain(context_manager_test_case)
test_contextmanager_finally(context_manager_test_case)
test_contextmanager_no_reraise(context_manager_test_case)
test_contextmanager_trap_yield_after_throw(context_manager_test_case)
test_contextmanager_except(context_manager_test_case)
test_contextmanager_except_stopiter(context_manager_test_case)
test_contextmanager_except_pep479(context_manager_test_case)
test_contextmanager_do_not_unchain_non_stopiteration_exceptions(context_manager_test_case)
test_contextmanager_attribs(context_manager_test_case)
test_contextmanager_doc_attrib(context_manager_test_case)
test_instance_docstring_given_cm_docstring(context_manager_test_case)
test_keywords(context_manager_test_case)
test_nokeepref(context_manager_test_case)
test_param_errors(context_manager_test_case)
test_recursive(context_manager_test_case)
closing_test_case = ClosingTestCase()
test_instance_docs(closing_test_case)
test_closing(closing_test_case)
test_closing_error(closing_test_case)
nullcontext_test_case = NullcontextTestCase()
test_nullcontext(nullcontext_test_case)
file_context_test_case = FileContextTestCase()
testWithOpen(file_context_test_case)
lock_context_test_case = LockContextTestCase()
testWithLock(lock_context_test_case)
testWithRLock(lock_context_test_case)
testWithCondition(lock_context_test_case)
testWithSemaphore(lock_context_test_case)
testWithBoundedSemaphore(lock_context_test_case)
test_context_decorator = TestContextDecorator()
test_instance_docs(test_context_decorator)
test_contextdecorator(test_context_decorator)
test_contextdecorator_with_exception(test_context_decorator)
test_decorator(test_context_decorator)
test_decorator_with_exception(test_context_decorator)
test_decorating_method(test_context_decorator)
test_typo_enter(test_context_decorator)
test_typo_exit(test_context_decorator)
test_contextdecorator_as_mixin(test_context_decorator)
test_contextmanager_as_decorator(test_context_decorator)
test_exit_stack = TestExitStack()
test_redirect_stdout = TestRedirectStdout()
test_redirect_stderr = TestRedirectStderr()
test_suppress = TestSuppress()
test_instance_docs(test_suppress)
test_no_result_from_enter(test_suppress)
test_no_exception(test_suppress)
test_exact_exception(test_suppress)
test_exception_hierarchy(test_suppress)
test_other_exception(test_suppress)
test_no_args(test_suppress)
test_multiple_exception_args(test_suppress)
test_cm_is_reentrant(test_suppress)
test_abstract_async_context_manager = TestAbstractAsyncContextManager()
test_exit_is_abstract(test_abstract_async_context_manager)
test_structural_subclassing(test_abstract_async_context_manager)
async_context_manager_test_case = AsyncContextManagerTestCase()
test_contextmanager_attribs(async_context_manager_test_case)
test_contextmanager_doc_attrib(async_context_manager_test_case)
aclosing_test_case = AclosingTestCase()
test_instance_docs(aclosing_test_case)
test_async_exit_stack = TestAsyncExitStack()
setUp(test_async_exit_stack)
test_async_nullcontext = TestAsyncNullcontext()
test_case = TestCase()
test_no_fields(test_case)
test_no_fields_but_member_variable(test_case)
test_one_field_no_default(test_case)
test_field_default_default_factory_error(test_case)
test_field_repr(test_case)
test_named_init_params(test_case)
test_two_fields_one_default(test_case)
test_overwrite_hash(test_case)
test_overwrite_fields_in_derived_class(test_case)
test_field_named_self(test_case)
test_field_named_object(test_case)
test_field_named_object_frozen(test_case)
test_field_named_like_builtin(test_case)
test_field_named_like_builtin_frozen(test_case)
test_0_field_compare(test_case)
test_1_field_compare(test_case)
test_simple_compare(test_case)
test_compare_subclasses(test_case)
test_eq_order(test_case)
test_field_no_default(test_case)
test_field_default(test_case)
test_not_in_repr(test_case)
test_not_in_compare(test_case)
test_hash_field_rules(test_case)
test_init_false_no_default(test_case)
test_class_marker(test_case)
test_field_order(test_case)
test_class_attrs(test_case)
test_disallowed_mutable_defaults(test_case)
test_deliberately_mutable_defaults(test_case)
test_no_options(test_case)
test_not_tuple(test_case)
test_not_other_dataclass(test_case)
test_function_annotations(test_case)
test_missing_default(test_case)
test_missing_default_factory(test_case)
test_missing_repr(test_case)
test_dont_include_other_annotations(test_case)
test_post_init(test_case)
test_post_init_super(test_case)
test_post_init_staticmethod(test_case)
test_post_init_classmethod(test_case)
test_class_var(test_case)
test_class_var_no_default(test_case)
test_class_var_default_factory(test_case)
test_class_var_with_default(test_case)
test_class_var_frozen(test_case)
test_init_var_no_default(test_case)
test_init_var_default_factory(test_case)
test_init_var_with_default(test_case)
test_init_var(test_case)
test_init_var_preserve_type(test_case)
test_init_var_inheritance(test_case)
test_default_factory(test_case)
test_default_factory_with_no_init(test_case)
test_default_factory_not_called_if_value_given(test_case)
test_default_factory_derived(test_case)
test_intermediate_non_dataclass(test_case)
test_classvar_default_factory(test_case)
test_is_dataclass(test_case)
test_is_dataclass_when_getattr_always_returns(test_case)
test_is_dataclass_genericalias(test_case)
test_helper_fields_with_class_instance(test_case)
test_helper_fields_exception(test_case)
test_helper_asdict(test_case)
test_helper_asdict_raises_on_classes(test_case)
test_helper_asdict_copy_values(test_case)
test_helper_asdict_nested(test_case)
test_helper_asdict_builtin_containers(test_case)
test_helper_asdict_builtin_object_containers(test_case)
test_helper_asdict_factory(test_case)
test_helper_asdict_namedtuple(test_case)
test_helper_asdict_namedtuple_key(test_case)
test_helper_asdict_namedtuple_derived(test_case)
test_helper_astuple(test_case)
test_helper_astuple_raises_on_classes(test_case)
test_helper_astuple_copy_values(test_case)
test_helper_astuple_nested(test_case)
test_helper_astuple_builtin_containers(test_case)
test_helper_astuple_builtin_object_containers(test_case)
test_helper_astuple_factory(test_case)
test_helper_astuple_namedtuple(test_case)
test_dynamic_class_creation(test_case)
test_dynamic_class_creation_using_field(test_case)
test_init_in_order(test_case)
test_items_in_dicts(test_case)
test_alternate_classmethod_constructor(test_case)
test_field_metadata_default(test_case)
test_field_metadata_mapping(test_case)
test_field_metadata_custom_mapping(test_case)
test_generic_dataclasses(test_case)
test_generic_extending(test_case)
test_generic_dynamic(test_case)
test_dataclasses_pickleable(test_case)
test_dataclasses_qualnames(test_case)
test_field_no_annotation = TestFieldNoAnnotation()
test_field_without_annotation(test_field_no_annotation)
test_field_without_annotation_but_annotation_in_base(test_field_no_annotation)
test_field_without_annotation_but_annotation_in_base_not_dataclass(test_field_no_annotation)
test_doc_string = TestDocString()
test_existing_docstring_not_overridden(test_doc_string)
test_docstring_no_fields(test_doc_string)
test_docstring_one_field(test_doc_string)
test_docstring_two_fields(test_doc_string)
test_docstring_three_fields(test_doc_string)
test_docstring_one_field_with_default(test_doc_string)
test_docstring_one_field_with_default_none(test_doc_string)
test_docstring_list_field(test_doc_string)
test_docstring_list_field_with_default_factory(test_doc_string)
test_docstring_deque_field(test_doc_string)
test_docstring_deque_field_with_default_factory(test_doc_string)
test_init = TestInit()
test_base_has_init(test_init)
test_no_init(test_init)
test_overwriting_init(test_init)
test_inherit_from_protocol(test_init)
test_repr = TestRepr()
test_repr(test_repr)
test_no_repr(test_repr)
test_overwriting_repr(test_repr)
test_eq = TestEq()
test_no_eq(test_eq)
test_overwriting_eq(test_eq)
test_ordering = TestOrdering()
test_functools_total_ordering(test_ordering)
test_no_order(test_ordering)
test_overwriting_order(test_ordering)
test_hash = TestHash()
test_unsafe_hash(test_hash)
test_hash_rules(test_hash)
test_eq_only(test_hash)
test_0_field_hash(test_hash)
test_1_field_hash(test_hash)
test_hash_no_args(test_hash)
test_frozen = TestFrozen()
test_frozen(test_frozen)
test_inherit(test_frozen)
test_inherit_nonfrozen_from_empty_frozen(test_frozen)
test_inherit_nonfrozen_from_empty(test_frozen)
test_inherit_nonfrozen_from_frozen(test_frozen)
test_inherit_frozen_from_nonfrozen(test_frozen)
test_inherit_from_normal_class(test_frozen)
test_non_frozen_normal_derived(test_frozen)
test_overwriting_frozen(test_frozen)
test_frozen_hash(test_frozen)
test_slots = TestSlots()
test_simple(test_slots)
test_derived_added_field(test_slots)
test_generated_slots(test_slots)
test_add_slots_when_slots_exists(test_slots)
test_generated_slots_value(test_slots)
test_returns_new_class(test_slots)
test_frozen_pickle(test_slots)
test_slots_with_default_no_init(test_slots)
test_slots_with_default_factory_no_init(test_slots)
test_descriptors = TestDescriptors()
test_set_name(test_descriptors)
test_non_descriptor(test_descriptors)
test_lookup_on_instance(test_descriptors)
test_lookup_on_class(test_descriptors)
test_string_annotations = TestStringAnnotations()
test_classvar(test_string_annotations)
test_isnt_classvar(test_string_annotations)
test_initvar(test_string_annotations)
test_isnt_initvar(test_string_annotations)
test_classvar_module_level_import(test_string_annotations)
test_text_annotations(test_string_annotations)
test_make_dataclass = TestMakeDataclass()
test_simple(test_make_dataclass)
test_no_mutate_namespace(test_make_dataclass)
test_base(test_make_dataclass)
test_base_dataclass(test_make_dataclass)
test_init_var(test_make_dataclass)
test_class_var(test_make_dataclass)
test_other_params(test_make_dataclass)
test_no_types(test_make_dataclass)
test_invalid_type_specification(test_make_dataclass)
test_duplicate_field_names(test_make_dataclass)
test_keyword_field_names(test_make_dataclass)
test_non_identifier_field_names(test_make_dataclass)
test_underscore_field_names(test_make_dataclass)
test_funny_class_names_names(test_make_dataclass)
test_replace = TestReplace()
test(test_replace)
test_frozen(test_replace)
test_invalid_field_name(test_replace)
test_invalid_object(test_replace)
test_no_init(test_replace)
test_classvar(test_replace)
test_initvar_is_specified(test_replace)
test_initvar_with_default_value(test_replace)
test_recursive_repr(test_replace)
test_recursive_repr_two_attrs(test_replace)
test_recursive_repr_indirection(test_replace)
test_recursive_repr_indirection_two(test_replace)
test_recursive_repr_misc_attrs(test_replace)
test_abstract = TestAbstract()
test_abc_implementation(test_abstract)
test_maintain_abc(test_abstract)
test_match_args = TestMatchArgs()
test_match_args(test_match_args)
test_explicit_match_args(test_match_args)
test_bpo_43764(test_match_args)
test_match_args_argument(test_match_args)
test_make_dataclasses(test_match_args)
test_keyword_args = TestKeywordArgs()
test_no_classvar_kwarg(test_keyword_args)
test_field_marked_as_kwonly(test_keyword_args)
test_match_args(test_keyword_args)
test_KW_ONLY(test_keyword_args)
test_KW_ONLY_as_string(test_keyword_args)
test_KW_ONLY_twice(test_keyword_args)
test_post_init(test_keyword_args)
test_defaults(test_keyword_args)
test_make_dataclass(test_keyword_args)
i_b_m_test_cases = IBMTestCases()
setUp(i_b_m_test_cases)
explicit_construction_test = ExplicitConstructionTest()
test_explicit_empty(explicit_construction_test)
test_explicit_from_None(explicit_construction_test)
test_explicit_from_int(explicit_construction_test)
test_explicit_from_string(explicit_construction_test)
test_from_legacy_strings(explicit_construction_test)
test_explicit_from_tuples(explicit_construction_test)
test_explicit_from_list(explicit_construction_test)
test_explicit_from_bool(explicit_construction_test)
test_explicit_from_Decimal(explicit_construction_test)
test_explicit_from_float(explicit_construction_test)
test_explicit_context_create_decimal(explicit_construction_test)
test_explicit_context_create_from_float(explicit_construction_test)
test_unicode_digits(explicit_construction_test)
implicit_construction_test = ImplicitConstructionTest()
test_implicit_from_None(implicit_construction_test)
test_implicit_from_int(implicit_construction_test)
test_implicit_from_string(implicit_construction_test)
test_implicit_from_float(implicit_construction_test)
test_implicit_from_Decimal(implicit_construction_test)
test_rop(implicit_construction_test)
format_test = FormatTest()
test_formatting(format_test)
test_n_format(format_test)
test_wide_char_separator_decimal_point(format_test)
test_decimal_from_float_argument_type(format_test)
arithmetic_operators_test = ArithmeticOperatorsTest()
test_addition(arithmetic_operators_test)
test_subtraction(arithmetic_operators_test)
test_multiplication(arithmetic_operators_test)
test_division(arithmetic_operators_test)
test_floor_division(arithmetic_operators_test)
test_powering(arithmetic_operators_test)
test_module(arithmetic_operators_test)
test_floor_div_module(arithmetic_operators_test)
test_unary_operators(arithmetic_operators_test)
test_nan_comparisons(arithmetic_operators_test)
test_copy_sign(arithmetic_operators_test)
threading_test = ThreadingTest()
test_threading(threading_test)
usability_test = UsabilityTest()
test_comparison_operators(usability_test)
test_decimal_float_comparison(usability_test)
test_decimal_complex_comparison(usability_test)
test_decimal_fraction_comparison(usability_test)
test_copy_and_deepcopy_methods(usability_test)
test_hash_method(usability_test)
test_hash_method_nan(usability_test)
test_min_and_max_methods(usability_test)
test_as_nonzero(usability_test)
test_tostring_methods(usability_test)
test_tonum_methods(usability_test)
test_nan_to_float(usability_test)
test_snan_to_float(usability_test)
test_eval_round_trip(usability_test)
test_as_tuple(usability_test)
test_as_integer_ratio(usability_test)
test_subclassing(usability_test)
test_implicit_context(usability_test)
test_none_args(usability_test)
test_conversions_from_int(usability_test)
python_a_p_itests = PythonAPItests()
test_abc(python_a_p_itests)
test_pickle(python_a_p_itests)
test_int(python_a_p_itests)
test_trunc(python_a_p_itests)
test_from_float(python_a_p_itests)
test_create_decimal_from_float(python_a_p_itests)
test_quantize(python_a_p_itests)
test_complex(python_a_p_itests)
test_named_parameters(python_a_p_itests)
test_exception_hierarchy(python_a_p_itests)
context_a_p_itests = ContextAPItests()
test_none_args(context_a_p_itests)
test_from_legacy_strings(context_a_p_itests)
test_pickle(context_a_p_itests)
test_equality_with_other_types(context_a_p_itests)
test_copy(context_a_p_itests)
test__clamp(context_a_p_itests)
test_abs(context_a_p_itests)
test_add(context_a_p_itests)
test_compare(context_a_p_itests)
test_compare_signal(context_a_p_itests)
test_compare_total(context_a_p_itests)
test_compare_total_mag(context_a_p_itests)
test_copy_abs(context_a_p_itests)
test_copy_decimal(context_a_p_itests)
test_copy_negate(context_a_p_itests)
test_copy_sign(context_a_p_itests)
test_divide(context_a_p_itests)
test_divide_int(context_a_p_itests)
test_divmod(context_a_p_itests)
test_exp(context_a_p_itests)
test_fma(context_a_p_itests)
test_is_finite(context_a_p_itests)
test_is_infinite(context_a_p_itests)
test_is_nan(context_a_p_itests)
test_is_normal(context_a_p_itests)
test_is_qnan(context_a_p_itests)
test_is_signed(context_a_p_itests)
test_is_snan(context_a_p_itests)
test_is_subnormal(context_a_p_itests)
test_is_zero(context_a_p_itests)
test_ln(context_a_p_itests)
test_log10(context_a_p_itests)
test_logb(context_a_p_itests)
test_logical_and(context_a_p_itests)
test_logical_invert(context_a_p_itests)
test_logical_or(context_a_p_itests)
test_logical_xor(context_a_p_itests)
test_max(context_a_p_itests)
test_max_mag(context_a_p_itests)
test_min(context_a_p_itests)
test_min_mag(context_a_p_itests)
test_minus(context_a_p_itests)
test_multiply(context_a_p_itests)
test_next_minus(context_a_p_itests)
test_next_plus(context_a_p_itests)
test_next_toward(context_a_p_itests)
test_normalize(context_a_p_itests)
test_number_class(context_a_p_itests)
test_plus(context_a_p_itests)
test_power(context_a_p_itests)
test_quantize(context_a_p_itests)
test_remainder(context_a_p_itests)
test_remainder_near(context_a_p_itests)
test_rotate(context_a_p_itests)
test_sqrt(context_a_p_itests)
test_same_quantum(context_a_p_itests)
test_scaleb(context_a_p_itests)
test_shift(context_a_p_itests)
test_subtract(context_a_p_itests)
test_to_eng_string(context_a_p_itests)
test_to_sci_string(context_a_p_itests)
test_to_integral_exact(context_a_p_itests)
test_to_integral_value(context_a_p_itests)
context_with_statement = ContextWithStatement()
test_localcontext(context_with_statement)
test_localcontextarg(context_with_statement)
test_nested_with_statements(context_with_statement)
test_with_statements_gc1(context_with_statement)
test_with_statements_gc2(context_with_statement)
test_with_statements_gc3(context_with_statement)
context_flags = ContextFlags()
test_flags_irrelevant(context_flags)
test_flag_comparisons(context_flags)
test_float_operation(context_flags)
test_float_comparison(context_flags)
test_float_operation_default(context_flags)
special_contexts = SpecialContexts()
test_context_templates(special_contexts)
test_default_context(special_contexts)
context_input_validation = ContextInputValidation()
test_invalid_context(context_input_validation)
context_subclassing = ContextSubclassing()
test_context_subclassing(context_subclassing)
check_attributes = CheckAttributes()
test_module_attributes(check_attributes)
test_context_attributes(check_attributes)
test_decimal_attributes(check_attributes)
coverage = Coverage()
test_adjusted(coverage)
test_canonical(coverage)
test_context_repr(coverage)
test_implicit_context(coverage)
test_divmod(coverage)
test_power(coverage)
test_quantize(coverage)
test_radix(coverage)
test_rop(coverage)
test_round(coverage)
test_create_decimal(coverage)
test_int(coverage)
test_copy(coverage)
py_functionality = PyFunctionality()
test_py_alternate_formatting(py_functionality)
py_whitebox = PyWhitebox()
test_py_exact_power(py_whitebox)
test_py_immutability_operations(py_whitebox)
test_py_decimal_id(py_whitebox)
test_py_rescale(py_whitebox)
test_py__round(py_whitebox)
c_functionality = CFunctionality()
test_c_ieee_context(c_functionality)
test_c_context(c_functionality)
test_constants(c_functionality)
c_whitebox = CWhitebox()
test_bignum(c_whitebox)
test_invalid_construction(c_whitebox)
test_c_input_restriction(c_whitebox)
test_c_context_repr(c_whitebox)
test_c_context_errors(c_whitebox)
test_rounding_strings_interned(c_whitebox)
test_c_context_errors_extra(c_whitebox)
test_c_valid_context(c_whitebox)
test_c_valid_context_extra(c_whitebox)
test_c_round(c_whitebox)
test_c_format(c_whitebox)
test_c_integral(c_whitebox)
test_c_funcs(c_whitebox)
test_va_args_exceptions(c_whitebox)
test_c_context_templates(c_whitebox)
test_c_signal_dict(c_whitebox)
test_invalid_override(c_whitebox)
test_exact_conversion(c_whitebox)
test_from_tuple(c_whitebox)
test_sizeof(c_whitebox)
test_internal_use_of_overridden_methods(c_whitebox)
test_maxcontext_exact_arith(c_whitebox)
signature_test = SignatureTest()
test_inspect_module(signature_test)
test_inspect_types(signature_test)
dict_test = DictTest()
test_invalid_keyword_arguments(dict_test)
test_constructor(dict_test)
test_literal_constructor(dict_test)
test_merge_operator(dict_test)
test_bool(dict_test)
test_keys(dict_test)
test_values(dict_test)
test_items(dict_test)
test_views_mapping(dict_test)
test_contains(dict_test)
test_len(dict_test)
test_getitem(dict_test)
test_clear(dict_test)
test_update(dict_test)
test_fromkeys(dict_test)
test_copy(dict_test)
test_copy_fuzz(dict_test)
test_copy_maintains_tracking(dict_test)
test_copy_noncompact(dict_test)
test_get(dict_test)
test_setdefault(dict_test)
test_setdefault_atomic(dict_test)
test_setitem_atomic_at_resize(dict_test)
test_popitem(dict_test)
test_pop(dict_test)
test_mutating_iteration(dict_test)
test_mutating_iteration_delete(dict_test)
test_mutating_iteration_delete_over_values(dict_test)
test_mutating_iteration_delete_over_items(dict_test)
test_mutating_lookup(dict_test)
test_repr(dict_test)
test_repr_deep(dict_test)
test_eq(dict_test)
test_keys_contained(dict_test)
test_errors_in_view_containment_check(dict_test)
test_dictview_set_operations_on_keys(dict_test)
test_dictview_set_operations_on_items(dict_test)
test_items_symmetric_difference(dict_test)
test_dictview_mixed_set_operations(dict_test)
test_missing(dict_test)
test_tuple_keyerror(dict_test)
test_bad_key(dict_test)
test_resize1(dict_test)
test_resize2(dict_test)
test_empty_presized_dict_in_freelist(dict_test)
test_container_iterator(dict_test)
test_track_literals(dict_test)
test_track_dynamic(dict_test)
test_track_subtypes(dict_test)
test_splittable_setdefault(dict_test)
test_splittable_del(dict_test)
test_splittable_pop(dict_test)
test_splittable_pop_pending(dict_test)
test_splittable_popitem(dict_test)
test_splittable_setattr_after_pop(dict_test)
test_iterator_pickling(dict_test)
test_itemiterator_pickling(dict_test)
test_valuesiterator_pickling(dict_test)
test_reverseiterator_pickling(dict_test)
test_reverseitemiterator_pickling(dict_test)
test_reversevaluesiterator_pickling(dict_test)
test_instance_dict_getattr_str_subclass(dict_test)
test_object_set_item_single_instance_non_str_key(dict_test)
test_reentrant_insertion(dict_test)
test_merge_and_mutate(dict_test)
test_free_after_iterating(dict_test)
test_equal_operator_modifying_operand(dict_test)
test_fromkeys_operator_modifying_dict_operand(dict_test)
test_fromkeys_operator_modifying_set_operand(dict_test)
test_dictitems_contains_use_after_free(dict_test)
test_dict_contain_use_after_free(dict_test)
test_init_use_after_free(dict_test)
test_oob_indexing_dictiter_iternextitem(dict_test)
test_reversed(dict_test)
test_reverse_iterator_for_empty_dict(dict_test)
test_reverse_iterator_for_shared_shared_dicts(dict_test)
test_dict_copy_order(dict_test)
test_dict_items_result_gc(dict_test)
test_dict_items_result_gc_reversed(dict_test)
test_str_nonstr(dict_test)
c_a_p_i_test = CAPITest()
test_getitem_knownhash(c_a_p_i_test)
dict_version_tests = DictVersionTests()
setUp(dict_version_tests)
test_constructor(dict_version_tests)
test_copy(dict_version_tests)
test_setitem(dict_version_tests)
test_setitem_same_value(dict_version_tests)
test_setitem_equal(dict_version_tests)
test_setdefault(dict_version_tests)
test_delitem(dict_version_tests)
test_pop(dict_version_tests)
test_popitem(dict_version_tests)
test_update(dict_version_tests)
test_clear(dict_version_tests)
dict_comprehension_test = DictComprehensionTest()
test_basics(dict_comprehension_test)
test_scope_isolation(dict_comprehension_test)
test_scope_isolation_from_global(dict_comprehension_test)
test_global_visibility(dict_comprehension_test)
test_local_visibility(dict_comprehension_test)
test_illegal_assignment(dict_comprehension_test)
test_evaluation_order(dict_comprehension_test)
test_assignment_idiom_in_comprehensions(dict_comprehension_test)
test_star_expression(dict_comprehension_test)
dict_set_test = DictSetTest()
test_constructors_not_callable(dict_set_test)
test_dict_keys(dict_set_test)
test_dict_items(dict_set_test)
test_dict_mixed_keys_items(dict_set_test)
test_dict_values(dict_set_test)
test_dict_repr(dict_set_test)
test_keys_set_operations(dict_set_test)
test_items_set_operations(dict_set_test)
test_set_operations_with_iterator(dict_set_test)
test_set_operations_with_noniterable(dict_set_test)
test_recursive_repr(dict_set_test)
test_deeply_nested_repr(dict_set_test)
test_copy(dict_set_test)
test_compare_error(dict_set_test)
test_pickle(dict_set_test)
test_abc_registry(dict_set_test)
e_o_f_test_case = EOFTestCase()
test_EOF_single_quote(e_o_f_test_case)
test_EOFS(e_o_f_test_case)
test_EOFS_with_file(e_o_f_test_case)
test_eof_with_line_continuation(e_o_f_test_case)
test_line_continuation_EOF(e_o_f_test_case)
test_line_continuation_EOF_from_file_bpo2180(e_o_f_test_case)
exception_tests = ExceptionTests()
testRaising(exception_tests)
testSyntaxErrorMessage(exception_tests)
testSyntaxErrorMissingParens(exception_tests)
test_error_offset_continuation_characters(exception_tests)
testSyntaxErrorOffset(exception_tests)
testSettingException(exception_tests)
test_WindowsError(exception_tests)
test_windows_message(exception_tests)
testAttributes(exception_tests)
testWithTraceback(exception_tests)
testInvalidTraceback(exception_tests)
testInvalidAttrs(exception_tests)
testNoneClearsTracebackAttr(exception_tests)
testChainingAttrs(exception_tests)
testChainingDescriptors(exception_tests)
testKeywordArgs(exception_tests)
testInfiniteRecursion(exception_tests)
test_str(exception_tests)
test_exception_cleanup_names(exception_tests)
test_exception_cleanup_names2(exception_tests)
testExceptionCleanupState(exception_tests)
test_exception_target_in_nested_scope(exception_tests)
test_generator_leaking(exception_tests)
test_generator_leaking2(exception_tests)
test_generator_leaking3(exception_tests)
test_generator_leaking4(exception_tests)
test_generator_doesnt_retain_old_exc(exception_tests)
test_generator_finalizing_and_exc_info(exception_tests)
test_generator_throw_cleanup_exc_state(exception_tests)
test_generator_close_cleanup_exc_state(exception_tests)
test_generator_del_cleanup_exc_state(exception_tests)
test_generator_next_cleanup_exc_state(exception_tests)
test_generator_send_cleanup_exc_state(exception_tests)
test_3114(exception_tests)
test_raise_does_not_create_context_chain_cycle(exception_tests)
test_no_hang_on_context_chain_cycle1(exception_tests)
test_no_hang_on_context_chain_cycle2(exception_tests)
test_no_hang_on_context_chain_cycle3(exception_tests)
test_unicode_change_attributes(exception_tests)
test_unicode_errors_no_object(exception_tests)
test_badisinstance(exception_tests)
test_trashcan_recursion(exception_tests)
test_recursion_normalizing_exception(exception_tests)
test_recursion_normalizing_infinite_exception(exception_tests)
test_recursion_in_except_handler(exception_tests)
test_recursion_normalizing_with_no_memory(exception_tests)
test_MemoryError(exception_tests)
test_exception_with_doc(exception_tests)
test_memory_error_cleanup(exception_tests)
test_recursion_error_cleanup(exception_tests)
test_errno_ENOTDIR(exception_tests)
test_unraisable(exception_tests)
test_unhandled(exception_tests)
test_memory_error_in_PyErr_PrintEx(exception_tests)
test_yield_in_nested_try_excepts(exception_tests)
test_generator_doesnt_retain_old_exc2(exception_tests)
test_raise_in_generator(exception_tests)
test_assert_shadowing(exception_tests)
test_memory_error_subclasses(exception_tests)
name_error_tests = NameErrorTests()
test_name_error_has_name(name_error_tests)
test_name_error_suggestions(name_error_tests)
test_name_error_suggestions_from_globals(name_error_tests)
test_name_error_suggestions_from_builtins(name_error_tests)
test_name_error_suggestions_do_not_trigger_for_long_names(name_error_tests)
test_name_error_bad_suggestions_do_not_trigger_for_small_names(name_error_tests)
test_name_error_suggestions_do_not_trigger_for_too_many_locals(name_error_tests)
test_name_error_with_custom_exceptions(name_error_tests)
test_unbound_local_error_doesn_not_match(name_error_tests)
test_issue45826(name_error_tests)
test_issue45826_focused(name_error_tests)
attribute_error_tests = AttributeErrorTests()
test_attributes(attribute_error_tests)
test_getattr_has_name_and_obj(attribute_error_tests)
test_getattr_has_name_and_obj_for_method(attribute_error_tests)
test_getattr_suggestions(attribute_error_tests)
test_getattr_suggestions_do_not_trigger_for_long_attributes(attribute_error_tests)
test_getattr_error_bad_suggestions_do_not_trigger_for_small_names(attribute_error_tests)
test_getattr_suggestions_do_not_trigger_for_big_dicts(attribute_error_tests)
test_getattr_suggestions_no_args(attribute_error_tests)
test_getattr_suggestions_invalid_args(attribute_error_tests)
test_getattr_suggestions_for_same_name(attribute_error_tests)
test_attribute_error_with_failing_dict(attribute_error_tests)
test_attribute_error_with_bad_name(attribute_error_tests)
test_attribute_error_inside_nested_getattr(attribute_error_tests)
import_error_tests = ImportErrorTests()
test_attributes(import_error_tests)
test_reset_attributes(import_error_tests)
test_non_str_argument(import_error_tests)
test_copy_pickle(import_error_tests)
syntax_error_tests = SyntaxErrorTests()
test_range_of_offsets(syntax_error_tests)
test_encodings(syntax_error_tests)
test_non_utf8(syntax_error_tests)
test_attributes_new_constructor(syntax_error_tests)
test_attributes_old_constructor(syntax_error_tests)
test_incorrect_constructor(syntax_error_tests)
p_e_p626_tests = PEP626Tests()
test_lineno_after_raise_simple(p_e_p626_tests)
test_lineno_after_raise_in_except(p_e_p626_tests)
test_lineno_after_other_except(p_e_p626_tests)
test_lineno_in_named_except(p_e_p626_tests)
test_lineno_in_try(p_e_p626_tests)
test_lineno_in_finally_normal(p_e_p626_tests)
test_lineno_in_finally_except(p_e_p626_tests)
test_lineno_after_with(p_e_p626_tests)
test_missing_lineno_shows_as_none(p_e_p626_tests)
test_lineno_after_raise_in_with_exit(p_e_p626_tests)
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
test_float_floor(general_float_cases)
test_float_ceil(general_float_cases)
test_float_mod(general_float_cases)
test_float_pow(general_float_cases)
test_hash(general_float_cases)
test_hash_nan(general_float_cases)
format_functions_test_case = FormatFunctionsTestCase()
setUp(format_functions_test_case)
test_getformat(format_functions_test_case)
test_setformat(format_functions_test_case)
tearDown(format_functions_test_case)
unknown_format_test_case = UnknownFormatTestCase()
setUp(unknown_format_test_case)
test_double_specials_dont_unpack(unknown_format_test_case)
test_float_specials_dont_unpack(unknown_format_test_case)
tearDown(unknown_format_test_case)
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
test_ends(hex_float_test_case)
test_invalid_inputs(hex_float_test_case)
test_whitespace(hex_float_test_case)
test_from_hex(hex_float_test_case)
test_roundtrip(hex_float_test_case)
test_subclass(hex_float_test_case)
end