using Test




using test.test_grammar: VALID_UNDERSCORE_LITERALS, INVALID_UNDERSCORE_LITERALS
abstract type AbstractIntSubclass <: int end
abstract type AbstractIntTestCases end
abstract type AbstractMyIndexable <: object end
abstract type AbstractCustomStr <: str end
abstract type AbstractCustomBytes <: bytes end
abstract type AbstractCustomByteArray <: bytearray end
abstract type AbstractMissingMethods <: object end
abstract type AbstractIntOverridesTrunc <: base end
abstract type AbstractJustTrunc <: base end
abstract type AbstractExceptionalTrunc <: base end
abstract type AbstractIndex <: trunc_result_base end
abstract type AbstractTruncReturnsNonInt <: base end
abstract type AbstractIntable <: trunc_result_base end
abstract type AbstractTruncReturnsNonIndex <: base end
abstract type AbstractNonIntegral <: trunc_result_base end
abstract type AbstractTruncReturnsNonIntegral <: base end
abstract type AbstractMyIndex <: int end
abstract type AbstractMyInt <: int end
abstract type AbstractBadIndex2 <: int end
abstract type AbstractBadInt2 <: int end
L = [("0", 0), ("1", 1), ("9", 9), ("10", 10), ("99", 99), ("100", 100), ("314", 314), (" 314", 314), ("314 ", 314), ("  \t\t  314  \t\t  ", 314), (repr(sys.maxsize), sys.maxsize), ("  1x", ValueError), ("  1  ", 1), ("  1  ", ValueError), ("", ValueError), (" ", ValueError), ("  \t\t  ", ValueError), ("Ȁ", ValueError)]
mutable struct IntSubclass <: AbstractIntSubclass

end

mutable struct IntTestCases <: AbstractIntTestCases
value
end
function test_basic(self::IntTestCases)
@test (Int(314) == 314)
@test (Int(floor(3.14)) == 3)
@test (Int(floor(-3.14)) == -3)
@test (Int(floor(3.9)) == 3)
@test (Int(floor(-3.9)) == -3)
@test (Int(floor(3.5)) == 3)
@test (Int(floor(-3.5)) == -3)
@test (parse(Int, "-3") == -3)
@test (parse(Int, " -3 ") == -3)
@test (parse(Int, " -3 ") == -3)
@test (parse(Int, "10") == 16)
for (s, v) in L
for sign in ("", "+", "-")
for prefix in ("", " ", "\t", "  \t\t  ")
ss = prefix * sign + s
vv = v
if sign == "-" && v !== ValueError
vv = -(v)
end
try
@test (parse(Int, ss) == vv)
catch exn
if exn isa ValueError
#= pass =#
end
end
end
end
end
s = repr(-1 - sys.maxsize)
x = parse(Int, s)
@test (x + 1 == -(sys.maxsize))
@test isa(self, x)
@test (parse(Int, s[2:end]) == sys.maxsize + 1)
x = Int(floor(1e+100))
@test isa(self, x)
x = Int(floor(-1e+100))
@test isa(self, x)
x = -1 - sys.maxsize
@test (x >> 1 == x ÷ 2)
x = parse(Int, repeat("1",600))
@test isa(self, x)
@test_throws TypeError int(1, 12)
@test (parse(Int, "0o123") == 83)
@test (parse(Int, "0x123") == 291)
@test_throws ValueError int("0x", 16)
@test_throws ValueError int("0x", 0)
@test_throws ValueError int("0o", 8)
@test_throws ValueError int("0o", 0)
@test_throws ValueError int("0b", 2)
@test_throws ValueError int("0b", 0)
@test (parse(Int, "100000000000000000000000000000000") == 4294967296)
@test (parse(Int, "102002022201221111211") == 4294967296)
@test (parse(Int, "10000000000000000") == 4294967296)
@test (parse(Int, "32244002423141") == 4294967296)
@test (parse(Int, "1550104015504") == 4294967296)
@test (parse(Int, "211301422354") == 4294967296)
@test (parse(Int, "40000000000") == 4294967296)
@test (parse(Int, "12068657454") == 4294967296)
@test (parse(Int, "4294967296") == 4294967296)
@test (parse(Int, "1904440554") == 4294967296)
@test (parse(Int, "9ba461594") == 4294967296)
@test (parse(Int, "535a79889") == 4294967296)
@test (parse(Int, "2ca5b7464") == 4294967296)
@test (parse(Int, "1a20dcd81") == 4294967296)
@test (parse(Int, "100000000") == 4294967296)
@test (parse(Int, "a7ffda91") == 4294967296)
@test (parse(Int, "704he7g4") == 4294967296)
@test (parse(Int, "4f5aff66") == 4294967296)
@test (parse(Int, "3723ai4g") == 4294967296)
@test (parse(Int, "281d55i4") == 4294967296)
@test (parse(Int, "1fj8b184") == 4294967296)
@test (parse(Int, "1606k7ic") == 4294967296)
@test (parse(Int, "mb994ag") == 4294967296)
@test (parse(Int, "hek2mgl") == 4294967296)
@test (parse(Int, "dnchbnm") == 4294967296)
@test (parse(Int, "b28jpdm") == 4294967296)
@test (parse(Int, "8pfgih4") == 4294967296)
@test (parse(Int, "76beigg") == 4294967296)
@test (parse(Int, "5qmcpqg") == 4294967296)
@test (parse(Int, "4q0jto4") == 4294967296)
@test (parse(Int, "4000000") == 4294967296)
@test (parse(Int, "3aokq94") == 4294967296)
@test (parse(Int, "2qhxjli") == 4294967296)
@test (parse(Int, "2br45qb") == 4294967296)
@test (parse(Int, "1z141z4") == 4294967296)
@test (parse(Int, " 0o123  ") == 83)
@test (parse(Int, " 0o123  ") == 83)
@test (parse(Int, "000") == 0)
@test (parse(Int, "0o123") == 83)
@test (parse(Int, "0x123") == 291)
@test (parse(Int, "0b100") == 4)
@test (parse(Int, " 0O123   ") == 83)
@test (parse(Int, " 0X123  ") == 291)
@test (parse(Int, " 0B100 ") == 4)
@test (parse(Int, "0123") == 123)
@test (parse(Int, "0123") == 123)
@test (parse(Int, "0x123") == 291)
@test (parse(Int, "0o123") == 83)
@test (parse(Int, "0b100") == 4)
@test (parse(Int, "0X123") == 291)
@test (parse(Int, "0O123") == 83)
@test (parse(Int, "0B100") == 4)
@test_throws ValueError int("0b2", 2)
@test_throws ValueError int("0b02", 2)
@test_throws ValueError int("0B2", 2)
@test_throws ValueError int("0B02", 2)
@test_throws ValueError int("0o8", 8)
@test_throws ValueError int("0o08", 8)
@test_throws ValueError int("0O8", 8)
@test_throws ValueError int("0O08", 8)
@test_throws ValueError int("0xg", 16)
@test_throws ValueError int("0x0g", 16)
@test_throws ValueError int("0Xg", 16)
@test_throws ValueError int("0X0g", 16)
@test (parse(Int, "100000000000000000000000000000001") == 4294967297)
@test (parse(Int, "102002022201221111212") == 4294967297)
@test (parse(Int, "10000000000000001") == 4294967297)
@test (parse(Int, "32244002423142") == 4294967297)
@test (parse(Int, "1550104015505") == 4294967297)
@test (parse(Int, "211301422355") == 4294967297)
@test (parse(Int, "40000000001") == 4294967297)
@test (parse(Int, "12068657455") == 4294967297)
@test (parse(Int, "4294967297") == 4294967297)
@test (parse(Int, "1904440555") == 4294967297)
@test (parse(Int, "9ba461595") == 4294967297)
@test (parse(Int, "535a7988a") == 4294967297)
@test (parse(Int, "2ca5b7465") == 4294967297)
@test (parse(Int, "1a20dcd82") == 4294967297)
@test (parse(Int, "100000001") == 4294967297)
@test (parse(Int, "a7ffda92") == 4294967297)
@test (parse(Int, "704he7g5") == 4294967297)
@test (parse(Int, "4f5aff67") == 4294967297)
@test (parse(Int, "3723ai4h") == 4294967297)
@test (parse(Int, "281d55i5") == 4294967297)
@test (parse(Int, "1fj8b185") == 4294967297)
@test (parse(Int, "1606k7id") == 4294967297)
@test (parse(Int, "mb994ah") == 4294967297)
@test (parse(Int, "hek2mgm") == 4294967297)
@test (parse(Int, "dnchbnn") == 4294967297)
@test (parse(Int, "b28jpdn") == 4294967297)
@test (parse(Int, "8pfgih5") == 4294967297)
@test (parse(Int, "76beigh") == 4294967297)
@test (parse(Int, "5qmcpqh") == 4294967297)
@test (parse(Int, "4q0jto5") == 4294967297)
@test (parse(Int, "4000001") == 4294967297)
@test (parse(Int, "3aokq95") == 4294967297)
@test (parse(Int, "2qhxjlj") == 4294967297)
@test (parse(Int, "2br45qc") == 4294967297)
@test (parse(Int, "1z141z5") == 4294967297)
end

function test_underscores(self::IntTestCases)
for lit in VALID_UNDERSCORE_LITERALS
if any((ch ∈ lit for ch in ".eEjJ"))
continue;
end
@test (parse(Int, lit) == eval(lit))
@test (parse(Int, lit) == parse(Int, replace(lit, "_", "")))
end
for lit in INVALID_UNDERSCORE_LITERALS
if any((ch ∈ lit for ch in ".eEjJ"))
continue;
end
@test_throws ValueError int(lit, 0)
end
@test (parse(Int, "1_00") == 9)
@test (parse(Int, "0_100") == 100)
@test (parse(Int, b"1_00") == 100)
@test_throws ValueError int("_100")
@test_throws ValueError int("+_100")
@test_throws ValueError int("1__00")
@test_throws ValueError int("100_")
end

function test_small_ints(self::IntTestCases)
assertIs(self, parse(Int, "10"), 10)
assertIs(self, parse(Int, "-1"), -1)
assertIs(self, parse(Int, b"10"), 10)
assertIs(self, parse(Int, b"-1"), -1)
end

function test_no_args(self::IntTestCases)
@test (zero(Int) == 0)
end

function test_keyword_args(self::IntTestCases)
@test (parse(Int, "100") == 4)
assertRaisesRegex(self, TypeError, "keyword argument") do 
zero(Int)
end
assertRaisesRegex(self, TypeError, "keyword argument") do 
zero(Int)
end
@test_throws TypeError int(10)
@test_throws TypeError int(0)
end

function test_int_base_limits(self::IntTestCases)
#= Testing the supported limits of the int() base parameter. =#
@test (parse(Int, "0") == 0)
assertRaises(self, ValueError) do 
parse(Int, "0")
end
assertRaises(self, ValueError) do 
parse(Int, "0")
end
assertRaises(self, ValueError) do 
parse(Int, "0")
end
assertRaises(self, ValueError) do 
parse(Int, "0")
end
assertRaises(self, ValueError) do 
parse(Int, "0")
end
for base in 2:36
@test (parse(Int, "0") == 0)
end
end

function test_int_base_bad_types(self::IntTestCases)
#= Not integer types are not valid bases; issue16772. =#
assertRaises(self, TypeError) do 
parse(Int, "0")
end
assertRaises(self, TypeError) do 
parse(Int, "0")
end
end

function test_int_base_indexable(self::MyIndexable)
mutable struct MyIndexable <: AbstractMyIndexable
value
end
function __index__(self::MyIndexable)
return self.value
end

for base in (2^100, -(2^100), 1, 37)
assertRaises(self, ValueError) do 
parse(Int, "43")
end
end
assertEqual(self, parse(Int, "101"), 5)
assertEqual(self, parse(Int, "101"), 101)
assertEqual(self, parse(Int, "101"), 1 + 36^2)
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
x = f(b"100")
subTest(self, type_(x)) do 
assertEqual(self, parse(Int, x), 100)
if isa(x, (str, bytes, bytearray))
assertEqual(self, parse(Int, x), 4)
else
msg = "can\'t convert non-string"
assertRaisesRegex(self, TypeError, msg) do 
parse(Int, x)
end
end
assertRaisesRegex(self, ValueError, "invalid literal") do 
parse(Int, f(repeat(b"A",16)))
end
end
end
end

function test_int_memoryview(self::IntTestCases)
@test (parse(Int, memoryview(b"123")[2:3]) == 23)
@test (parse(Int, memoryview(b"123\x00")[2:3]) == 23)
@test (parse(Int, memoryview(b"123 ")[2:3]) == 23)
@test (parse(Int, memoryview(b"123A")[2:3]) == 23)
@test (parse(Int, memoryview(b"1234")[2:3]) == 23)
end

function test_string_float(self::IntTestCases)
@test_throws ValueError int("1.2")
end

function test_intconversion(self::TruncReturnsBadInt)
mutable struct ClassicMissingMethods <: AbstractClassicMissingMethods

end

assertRaises(self, TypeError, int, ClassicMissingMethods())
mutable struct MissingMethods <: AbstractMissingMethods

end

assertRaises(self, TypeError, int, MissingMethods())
mutable struct Foo0 <: AbstractFoo0

end
function __int__(self::Foo0)::Int64
return 42
end

assertEqual(self, parse(Int, Foo0()), 42)
mutable struct Classic <: AbstractClassic

end

for base in (object, Classic)
mutable struct IntOverridesTrunc <: AbstractIntOverridesTrunc

end
function __int__(self::IntOverridesTrunc)::Int64
return 42
end

function __trunc__(self::IntOverridesTrunc)::Int64
return -12
end

assertEqual(self, Int(IntOverridesTrunc()), 42)
mutable struct JustTrunc <: AbstractJustTrunc

end
function __trunc__(self::JustTrunc)::Int64
return 42
end

assertEqual(self, parse(Int, JustTrunc()), 42)
mutable struct ExceptionalTrunc <: AbstractExceptionalTrunc

end
function __trunc__(self::ExceptionalTrunc)
1 / 0
end

assertRaises(self, ZeroDivisionError) do 
parse(Int, ExceptionalTrunc())
end
for trunc_result_base in (object, Classic)
mutable struct Index <: AbstractIndex

end
function __index__(self::Index)::Int64
return 42
end

mutable struct TruncReturnsNonInt <: AbstractTruncReturnsNonInt

end
function __trunc__(self::TruncReturnsNonInt)::Index
return Index()
end

assertEqual(self, parse(Int, TruncReturnsNonInt()), 42)
mutable struct Intable <: AbstractIntable

end
function __int__(self::Intable)::Int64
return 42
end

mutable struct TruncReturnsNonIndex <: AbstractTruncReturnsNonIndex

end
function __trunc__(self::TruncReturnsNonIndex)::Intable
return Intable()
end

assertEqual(self, parse(Int, TruncReturnsNonInt()), 42)
mutable struct NonIntegral <: AbstractNonIntegral

end
function __trunc__(self::NonIntegral)::NonIntegral
return NonIntegral()
end

mutable struct TruncReturnsNonIntegral <: AbstractTruncReturnsNonIntegral

end
function __trunc__(self::TruncReturnsNonIntegral)::NonIntegral
return NonIntegral()
end

try
parse(Int, TruncReturnsNonIntegral())
catch exn
 let e = exn
if e isa TypeError
assertEqual(self, string(e), "__trunc__ returned non-Integral (type NonIntegral)")
end
end
end
mutable struct BadInt <: AbstractBadInt

end
function __int__(self::BadInt)::Float64
return 42.0
end

mutable struct TruncReturnsBadInt <: AbstractTruncReturnsBadInt

end
function __trunc__(self::TruncReturnsBadInt)::BadInt
return BadInt()
end

assertRaises(self, TypeError) do 
parse(Int, TruncReturnsBadInt())
end
end
end
end

function test_int_subclass_with_index(self::BadIndex)
mutable struct MyIndex <: AbstractMyIndex

end
function __index__(self::MyIndex)::Int64
return 42
end

mutable struct BadIndex <: AbstractBadIndex

end
function __index__(self::BadIndex)::Float64
return 42.0
end

my_int = MyIndex(7)
assertEqual(self, my_int, 7)
assertEqual(self, parse(Int, my_int), 7)
assertEqual(self, parse(Int, BadIndex()), 0)
end

function test_int_subclass_with_int(self::BadInt)
mutable struct MyInt <: AbstractMyInt

end
function __int__(self::MyInt)::Int64
return 42
end

mutable struct BadInt <: AbstractBadInt

end
function __int__(self::BadInt)::Float64
return 42.0
end

my_int = MyInt(7)
assertEqual(self, my_int, 7)
assertEqual(self, parse(Int, my_int), 42)
my_int = BadInt(7)
assertEqual(self, my_int, 7)
assertRaises(self, TypeError, int, my_int)
end

function test_int_returns_int_subclass(self::TruncReturnsIntSubclass)
mutable struct BadIndex <: AbstractBadIndex

end
function __index__(self::BadIndex)::Bool
return true
end

mutable struct BadIndex2 <: AbstractBadIndex2

end
function __index__(self::BadIndex2)::Bool
return true
end

mutable struct BadInt <: AbstractBadInt

end
function __int__(self::BadInt)::Bool
return true
end

mutable struct BadInt2 <: AbstractBadInt2

end
function __int__(self::BadInt2)::Bool
return true
end

mutable struct TruncReturnsBadIndex <: AbstractTruncReturnsBadIndex

end
function __trunc__(self::TruncReturnsBadIndex)::BadIndex
return BadIndex()
end

mutable struct TruncReturnsBadInt <: AbstractTruncReturnsBadInt

end
function __trunc__(self::TruncReturnsBadInt)::BadInt
return BadInt()
end

mutable struct TruncReturnsIntSubclass <: AbstractTruncReturnsIntSubclass

end
function __trunc__(self::TruncReturnsIntSubclass)::Bool
return true
end

bad_int = BadIndex()
assertWarns(self, DeprecationWarning) do 
n = parse(Int, bad_int)
end
assertEqual(self, n, 1)
assertIs(self, type_(n), int)
bad_int = BadIndex2()
n = parse(Int, bad_int)
assertEqual(self, n, 0)
assertIs(self, type_(n), int)
bad_int = BadInt()
assertWarns(self, DeprecationWarning) do 
n = parse(Int, bad_int)
end
assertEqual(self, n, 1)
assertIs(self, type_(n), int)
bad_int = BadInt2()
assertWarns(self, DeprecationWarning) do 
n = parse(Int, bad_int)
end
assertEqual(self, n, 1)
assertIs(self, type_(n), int)
bad_int = TruncReturnsBadIndex()
assertWarns(self, DeprecationWarning) do 
n = parse(Int, bad_int)
end
assertEqual(self, n, 1)
assertIs(self, type_(n), int)
bad_int = TruncReturnsBadInt()
assertRaises(self, TypeError, int, bad_int)
good_int = TruncReturnsIntSubclass()
n = parse(Int, good_int)
assertEqual(self, n, 1)
assertIs(self, type_(n), int)
n = IntSubclass(good_int)
assertEqual(self, n, 1)
assertIs(self, type_(n), IntSubclass)
end

function test_error_message(self::IntTestCases)
function check(s, base = nothing)
@test_throws ValueError "int(%r, %r)" % (s, base)() do cm 
if base === nothing
parse(Int, s)
else
parse(Int, s)
end
end
@test (cm.exception.args[1] == "invalid literal for int() with base %d: %r" % (base === nothing ? (10) : (base), s))
end

check("½")
check("123½")
check("  123 456  ")
check("123\0")
check("123\0", 10)
check("123\0 245", 20)
check("123\0 245", 16)
check("123\0245", 20)
check("123\0245", 16)
check(b"123\x00")
check(b"123\x00", 10)
check(b"123\xbd")
check(b"123\xbd", 10)
check("123\ud800")
check("123\ud800", 10)
end

function test_issue31619(self::IntTestCases)
@test (parse(Int, "1_0_1_0_1_0_1_0_1_0_1_0_1_0_1_0_1_0_1_0_1_0_1_0_1_0_1_0_1_0_1") == 1431655765)
@test (parse(Int, "1_2_3_4_5_6_7_0_1_2_3") == 1402433619)
@test (parse(Int, "1_2_3_4_5_6_7_8_9") == 4886718345)
@test (parse(Int, "1_2_3_4_5_6_7") == 1144132807)
end

if abspath(PROGRAM_FILE) == @__FILE__
int_test_cases = IntTestCases()
test_basic(int_test_cases)
test_underscores(int_test_cases)
test_small_ints(int_test_cases)
test_no_args(int_test_cases)
test_keyword_args(int_test_cases)
test_int_base_limits(int_test_cases)
test_int_base_bad_types(int_test_cases)
test_int_base_indexable(int_test_cases)
test_non_numeric_input_types(int_test_cases)
test_int_memoryview(int_test_cases)
test_string_float(int_test_cases)
test_intconversion(int_test_cases)
test_int_subclass_with_index(int_test_cases)
test_int_subclass_with_int(int_test_cases)
test_int_returns_int_subclass(int_test_cases)
test_error_message(int_test_cases)
test_issue31619(int_test_cases)
end