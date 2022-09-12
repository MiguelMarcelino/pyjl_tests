# Transpiled with flags: 
# - oop
using ObjectOriented
using Test




using test.test_grammar: VALID_UNDERSCORE_LITERALS, INVALID_UNDERSCORE_LITERALS
L = [("0", 0), ("1", 1), ("9", 9), ("10", 10), ("99", 99), ("100", 100), ("314", 314), (" 314", 314), ("314 ", 314), ("  \t\t  314  \t\t  ", 314), (repr(typemax(Int)), typemax(Int)), ("  1x", ValueError), ("  1  ", 1), ("  1  ", ValueError), ("", ValueError), (" ", ValueError), ("  \t\t  ", ValueError), ("Ȁ", ValueError)]
@oodef mutable struct IntSubclass <: Int64
                    
                    
                    
                end
                

@oodef mutable struct MyIndexable <: object
                    
                    value
                    
function new(value)
@mk begin
value = value
end
end

                end
                function __index__(self::@like(MyIndexable))
return self.value
end


@oodef mutable struct CustomStr <: String
                    
                    
                    
                end
                

@oodef mutable struct CustomBytes <: Array{UInt8}
                    
                    
                    
                end
                

@oodef mutable struct CustomByteArray <: Vector{UInt8}
                    
                    
                    
                end
                

@oodef mutable struct ClassicMissingMethods
                    
                    
                    
                end
                

@oodef mutable struct MissingMethods <: object
                    
                    
                    
                end
                

@oodef mutable struct Foo0
                    
                    
                    
                end
                function __int__(self::@like(Foo0))::Int64
return 42
end


@oodef mutable struct Classic
                    
                    
                    
                end
                

@oodef mutable struct MyIndex <: Int64
                    
                    
                    
                end
                function __index__(self::@like(MyIndex))::Int64
return 42
end


@oodef mutable struct BadIndex <: Int64
                    
                    
                    
                end
                function __index__(self::@like(BadIndex))::Float64
return 42.0
end


@oodef mutable struct MyInt <: Int64
                    
                    
                    
                end
                function __int__(self::@like(MyInt))::Int64
return 42
end


@oodef mutable struct BadInt <: Int64
                    
                    
                    
                end
                function __int__(self::@like(BadInt))::Float64
return 42.0
end


@oodef mutable struct BadIndex
                    
                    
                    
                end
                function __index__(self::@like(BadIndex))::Bool
return true
end


@oodef mutable struct BadIndex2 <: Int64
                    
                    
                    
                end
                function __index__(self::@like(BadIndex2))::Bool
return true
end


@oodef mutable struct BadInt
                    
                    
                    
                end
                function __int__(self::@like(BadInt))::Bool
return true
end


@oodef mutable struct BadInt2 <: Int64
                    
                    
                    
                end
                function __int__(self::@like(BadInt2))::Bool
return true
end


@oodef mutable struct TruncReturnsBadIndex
                    
                    
                    
                end
                function __trunc__(self::@like(TruncReturnsBadIndex))::BadIndex
return BadIndex()
end


@oodef mutable struct TruncReturnsBadInt
                    
                    
                    
                end
                function __trunc__(self::@like(TruncReturnsBadInt))::BadInt
return BadInt()
end


@oodef mutable struct TruncReturnsIntSubclass
                    
                    
                    
                end
                function __trunc__(self::@like(TruncReturnsIntSubclass))::Bool
return true
end


@oodef mutable struct IntTestCases <: unittest.TestCase
                    
                    
                    
                end
                function test_basic(self::@like(IntTestCases))
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
for sign_ in ("", "+", "-")
for prefix in ("", " ", "\t", "  \t\t  ")
ss = prefix * sign_ + s
vv = v
if sign_ == "-"&&v !== ValueError
vv = -v
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
s = repr(-1 - typemax(Int))
x = parse(Int, s)
@test (x + 1 == -(typemax(Int)))
@test isa(self, x)
@test (parse(Int, s[2:end]) == typemax(Int) + 1)
x = Int(floor(1e+100))
@test isa(self, x)
x = Int(floor(-1e+100))
@test isa(self, x)
x = -1 - typemax(Int)
@test (x >> 1 == x ÷ 2)
x = parse(Int, repeat("1",600))
@test isa(self, x)
@test_throws
@test (parse(Int, "0o123") == 83)
@test (parse(Int, "0x123") == 291)
@test_throws
@test_throws
@test_throws
@test_throws
@test_throws
@test_throws
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

function test_underscores(self::@like(IntTestCases))
for lit in VALID_UNDERSCORE_LITERALS
if any((ch ∈ lit for ch in ".eEjJ"))
continue;
end
@test (parse(Int, lit) == py"lit")
@test (parse(Int, lit) == parse(Int, replace(lit, "_", "")))
end
for lit in INVALID_UNDERSCORE_LITERALS
if any((ch ∈ lit for ch in ".eEjJ"))
continue;
end
@test_throws
end
@test (parse(Int, "1_00") == 9)
@test (parse(Int, "0_100") == 100)
@test (parse(Int, b"1_00") == 100)
@test_throws
@test_throws
@test_throws
@test_throws
end

function test_small_ints(self::@like(IntTestCases))
@test self === parse(Int, "10")
@test self === parse(Int, "-1")
@test self === parse(Int, b"10")
@test self === parse(Int, b"-1")
end

function test_no_args(self::@like(IntTestCases))
@test (zero(Int) == 0)
end

function test_keyword_args(self::@like(IntTestCases))
@test (parse(Int, "100") == 4)
assertRaisesRegex(self, TypeError, "keyword argument") do 
zero(Int)
end
assertRaisesRegex(self, TypeError, "keyword argument") do 
zero(Int)
end
@test_throws
@test_throws
end

function test_int_base_limits(self::@like(IntTestCases))
#= Testing the supported limits of the int() base parameter. =#
@test (parse(Int, "0") == 0)
@test_throws ValueError do 
parse(Int, "0")
end
@test_throws ValueError do 
parse(Int, "0")
end
@test_throws ValueError do 
parse(Int, "0")
end
@test_throws ValueError do 
parse(Int, "0")
end
@test_throws ValueError do 
parse(Int, "0")
end
for base in 2:36
@test (parse(Int, "0") == 0)
end
end

function test_int_base_bad_types(self::@like(IntTestCases))
#= Not integer types are not valid bases; issue16772. =#
@test_throws TypeError do 
parse(Int, "0")
end
@test_throws TypeError do 
parse(Int, "0")
end
end

function test_int_base_indexable(self::@like(IntTestCases))
for base in (2^100, -(2^100), 1, 37)
@test_throws ValueError do 
parse(Int, "43")
end
end
@test (parse(Int, "101") == 5)
@test (parse(Int, "101") == 101)
@test (parse(Int, "101") == 1 + 36^2)
end

function test_non_numeric_input_types(self::@like(IntTestCases))
factories = [Array{UInt8}, Vector{UInt8}, (b) -> CustomStr(decode(b)), CustomBytes, CustomByteArray, memoryview]
try
catch exn
if exn isa ImportError
#= pass =#
end
end
for f in factories
x = f(b"100")
subTest(self, type_(x)) do 
@test (parse(Int, x) == 100)
if isa(x, (String, Array{UInt8}, Vector{UInt8}))
@test (parse(Int, x) == 4)
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

function test_int_memoryview(self::@like(IntTestCases))
@test (parse(Int, memoryview(b"123")[2:3]) == 23)
@test (parse(Int, memoryview(b"123\x00")[2:3]) == 23)
@test (parse(Int, memoryview(b"123 ")[2:3]) == 23)
@test (parse(Int, memoryview(b"123A")[2:3]) == 23)
@test (parse(Int, memoryview(b"1234")[2:3]) == 23)
end

function test_string_float(self::@like(IntTestCases))
@test_throws
end

function test_intconversion(self::IntTestCases)
@test_throws
@test_throws
@test (parse(Int, Foo0()) == 42)
for base in (object, Classic)
@oodef mutable struct IntOverridesTrunc <: base
                    
                    
                    
                end
                function __int__(self::@like(IntOverridesTrunc))::Int64
return 42
end

function __trunc__(self::@like(IntOverridesTrunc))::Int64
return -12
end


@test (Int(IntOverridesTrunc()) == 42)
@oodef mutable struct JustTrunc <: base
                    
                    
                    
                end
                function __trunc__(self::@like(JustTrunc))::Int64
return 42
end


@test (parse(Int, JustTrunc()) == 42)
@oodef mutable struct ExceptionalTrunc <: base
                    
                    
                    
                end
                function __trunc__(self::@like(ExceptionalTrunc))
1 / 0
end


@test_throws ZeroDivisionError do 
parse(Int, ExceptionalTrunc())
end
for trunc_result_base in (object, Classic)
@oodef mutable struct Index <: trunc_result_base
                    
                    
                    
                end
                function __index__(self::@like(Index))::Int64
return 42
end


@oodef mutable struct TruncReturnsNonInt <: base
                    
                    
                    
                end
                function __trunc__(self::@like(TruncReturnsNonInt))::Index
return Index()
end


@test (parse(Int, TruncReturnsNonInt()) == 42)
@oodef mutable struct Intable <: trunc_result_base
                    
                    
                    
                end
                function __int__(self::@like(Intable))::Int64
return 42
end


@oodef mutable struct TruncReturnsNonIndex <: base
                    
                    
                    
                end
                function __trunc__(self::@like(TruncReturnsNonIndex))::Intable
return Intable()
end


@test (parse(Int, TruncReturnsNonInt()) == 42)
@oodef mutable struct NonIntegral <: trunc_result_base
                    
                    
                    
                end
                function __trunc__(self::@like(NonIntegral))::NonIntegral
return NonIntegral()
end


@oodef mutable struct TruncReturnsNonIntegral <: base
                    
                    
                    
                end
                function __trunc__(self::@like(TruncReturnsNonIntegral))::NonIntegral
return NonIntegral()
end


try
parse(Int, TruncReturnsNonIntegral())
catch exn
 let e = exn
if e isa TypeError
@test (string(e) == "__trunc__ returned non-Integral (type NonIntegral)")
end
end
end
@oodef mutable struct BadInt <: trunc_result_base
                    
                    
                    
                end
                function __int__(self::@like(BadInt))::Float64
return 42.0
end


@oodef mutable struct TruncReturnsBadInt <: base
                    
                    
                    
                end
                function __trunc__(self::@like(TruncReturnsBadInt))::BadInt
return BadInt()
end


@test_throws TypeError do 
parse(Int, TruncReturnsBadInt())
end
end
end
end

function test_int_subclass_with_index(self::IntTestCases)
my_int = MyIndex(7)
@test (my_int == 7)
@test (parse(Int, my_int) == 7)
@test (parse(Int, BadIndex()) == 0)
end

function test_int_subclass_with_int(self::IntTestCases)
my_int = MyInt(7)
@test (my_int == 7)
@test (parse(Int, my_int) == 42)
my_int = BadInt(7)
@test (my_int == 7)
@test_throws
end

function test_int_returns_int_subclass(self::IntTestCases)
bad_int = BadIndex()
assertWarns(self, DeprecationWarning) do 
n = parse(Int, bad_int)
end
@test (n == 1)
@test self === type_(n)
bad_int = BadIndex2()
n = parse(Int, bad_int)
@test (n == 0)
@test self === type_(n)
bad_int = BadInt()
assertWarns(self, DeprecationWarning) do 
n = parse(Int, bad_int)
end
@test (n == 1)
@test self === type_(n)
bad_int = BadInt2()
assertWarns(self, DeprecationWarning) do 
n = parse(Int, bad_int)
end
@test (n == 1)
@test self === type_(n)
bad_int = TruncReturnsBadIndex()
assertWarns(self, DeprecationWarning) do 
n = parse(Int, bad_int)
end
@test (n == 1)
@test self === type_(n)
bad_int = TruncReturnsBadInt()
@test_throws
good_int = TruncReturnsIntSubclass()
n = parse(Int, good_int)
@test (n == 1)
@test self === type_(n)
n = IntSubclass(good_int)
@test (n == 1)
@test self === type_(n)
end

function test_error_message(self::IntTestCases)
function check(s::IntTestCases, base = nothing)
@test_throws ValueError do cm 
if base === nothing
parse(Int, s)
else
parse(Int, s)
end
end
@test (cm.exception.args[1] == "invalid literal for int() with base $(base === nothing ? (10) : (base)): $(s)")
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
format_test = FormatTest()
test_common_format(format_test)
test_str_format(format_test)
test_bytes_and_bytearray_format(format_test)
test_nul(format_test)
test_non_ascii(format_test)
test_locale(format_test)
test_optimisations(format_test)
test_precision(format_test)
test_precision_c_limits(format_test)
test_g_format_has_no_trailing_zeros(format_test)
test_with_two_commas_in_format_specifier(format_test)
test_with_two_underscore_in_format_specifier(format_test)
test_with_a_commas_and_an_underscore_in_format_specifier(format_test)
test_with_an_underscore_and_a_comma_in_format_specifier(format_test)
fraction_test = FractionTest()
testInit(fraction_test)
testInitFromFloat(fraction_test)
testInitFromDecimal(fraction_test)
testFromString(fraction_test)
testImmutable(fraction_test)
testFromFloat(fraction_test)
testFromDecimal(fraction_test)
test_as_integer_ratio(fraction_test)
testLimitDenominator(fraction_test)
testConversions(fraction_test)
testBoolGuarateesBoolReturn(fraction_test)
testRound(fraction_test)
testArithmetic(fraction_test)
testLargeArithmetic(fraction_test)
testMixedArithmetic(fraction_test)
testMixingWithDecimal(fraction_test)
testComparisons(fraction_test)
testComparisonsDummyRational(fraction_test)
testComparisonsDummyFloat(fraction_test)
testMixedLess(fraction_test)
testMixedLessEqual(fraction_test)
testBigFloatComparisons(fraction_test)
testBigComplexComparisons(fraction_test)
testMixedEqual(fraction_test)
testStringification(fraction_test)
testHash(fraction_test)
testApproximatePi(fraction_test)
testApproximateCos1(fraction_test)
test_copy_deepcopy_pickle(fraction_test)
test_slots(fraction_test)
test_int_subclass(fraction_test)
test_frozen = TestFrozen()
test_frozen(test_frozen)
test_case = TestCase()
test__format__lookup(test_case)
test_ast(test_case)
test_ast_line_numbers(test_case)
test_ast_line_numbers_multiple_formattedvalues(test_case)
test_ast_line_numbers_nested(test_case)
test_ast_line_numbers_duplicate_expression(test_case)
test_ast_numbers_fstring_with_formatting(test_case)
test_ast_line_numbers_multiline_fstring(test_case)
test_ast_line_numbers_with_parentheses(test_case)
test_docstring(test_case)
test_literal_eval(test_case)
test_ast_compile_time_concat(test_case)
test_compile_time_concat_errors(test_case)
test_literal(test_case)
test_unterminated_string(test_case)
test_mismatched_parens(test_case)
test_double_braces(test_case)
test_compile_time_concat(test_case)
test_comments(test_case)
test_many_expressions(test_case)
test_format_specifier_expressions(test_case)
test_side_effect_order(test_case)
test_missing_expression(test_case)
test_parens_in_expressions(test_case)
test_newlines_before_syntax_error(test_case)
test_backslashes_in_string_part(test_case)
test_misformed_unicode_character_name(test_case)
test_no_backslashes_in_expression_part(test_case)
test_no_escapes_for_braces(test_case)
test_newlines_in_expressions(test_case)
test_lambda(test_case)
test_yield(test_case)
test_yield_send(test_case)
test_expressions_with_triple_quoted_strings(test_case)
test_multiple_vars(test_case)
test_closure(test_case)
test_arguments(test_case)
test_locals(test_case)
test_missing_variable(test_case)
test_missing_format_spec(test_case)
test_global(test_case)
test_shadowed_global(test_case)
test_call(test_case)
test_nested_fstrings(test_case)
test_invalid_string_prefixes(test_case)
test_leading_trailing_spaces(test_case)
test_not_equal(test_case)
test_equal_equal(test_case)
test_conversions(test_case)
test_assignment(test_case)
test_del(test_case)
test_mismatched_braces(test_case)
test_if_conditional(test_case)
test_empty_format_specifier(test_case)
test_str_format_differences(test_case)
test_errors(test_case)
test_filename_in_syntaxerror(test_case)
test_loop(test_case)
test_dict(test_case)
test_backslash_char(test_case)
test_debug_conversion(test_case)
test_walrus(test_case)
test_invalid_syntax_error_message(test_case)
test_with_two_commas_in_format_specifier(test_case)
test_with_two_underscore_in_format_specifier(test_case)
test_with_a_commas_and_an_underscore_in_format_specifier(test_case)
test_with_an_underscore_and_a_comma_in_format_specifier(test_case)
test_syntax_error_for_starred_expressions(test_case)
test_p_e_p479 = TestPEP479()
test_stopiteration_wrapping(test_p_e_p479)
test_stopiteration_wrapping_context(test_p_e_p479)
signal_and_yield_from_test = SignalAndYieldFromTest()
test_raise_and_yield_from(signal_and_yield_from_test)
finalization_test = FinalizationTest()
test_frame_resurrect(finalization_test)
test_refcycle(finalization_test)
test_lambda_generator(finalization_test)
generator_test = GeneratorTest()
test_name(generator_test)
test_copy(generator_test)
test_pickle(generator_test)
test_send_non_none_to_new_gen(generator_test)
exception_test = ExceptionTest()
test_except_throw(exception_test)
test_except_next(exception_test)
test_except_gen_except(exception_test)
test_except_throw_exception_context(exception_test)
test_except_throw_bad_exception(exception_test)
test_stopiteration_error(exception_test)
test_tutorial_stopiteration(exception_test)
test_return_tuple(exception_test)
test_return_stopiteration(exception_test)
generator_throw_test = GeneratorThrowTest()
test_exception_context_with_yield(generator_throw_test)
test_exception_context_with_yield_inside_generator(generator_throw_test)
test_exception_context_with_yield_from(generator_throw_test)
test_exception_context_with_yield_from_with_context_cycle(generator_throw_test)
test_throw_after_none_exc_type(generator_throw_test)
generator_stack_trace_test = GeneratorStackTraceTest()
test_send_with_yield_from(generator_stack_trace_test)
test_throw_with_yield_from(generator_stack_trace_test)
yield_from_tests = YieldFromTests()
test_generator_gi_yieldfrom(yield_from_tests)
global_tests = GlobalTests()
setUp(global_tests)
test1(global_tests)
test2(global_tests)
test3(global_tests)
test4(global_tests)
tearDown(global_tests)
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