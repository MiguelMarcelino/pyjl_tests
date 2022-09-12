# Transpiled with flags: 
# - oop
using ObjectOriented
using Test

import marshal




@oodef mutable struct Foo <: object
                    
                    
                    
                end
                function __bool__(self::@like(Foo))
return self
end


@oodef mutable struct Bar <: object
                    
                    
                    
                end
                function __bool__(self::@like(Bar))::String
return "Yes"
end


@oodef mutable struct Baz <: Int64
                    
                    
                    
                end
                function __bool__(self::@like(Baz))
return self
end


@oodef mutable struct Spam <: Int64
                    
                    
                    
                end
                function __bool__(self::@like(Spam))::Int64
return 1
end


@oodef mutable struct Eggs
                    
                    
                    
                end
                function __len__(self::@like(Eggs))::Int64
return -1
end


@oodef mutable struct A
                    
                    __bool__
                    
function new(__bool__ = nothing)
__bool__ = __bool__
new(__bool__)
end

                end
                

@oodef mutable struct B
                    
                    __bool__
                    
function new(__bool__ = nothing)
__bool__ = __bool__
new(__bool__)
end

                end
                function __len__(self::@like(B))::Int64
return 10
end


@oodef mutable struct X
                    
                    count::Int64
                    
function new(count::Int64 = 0)
@mk begin
count = count
end
end

                end
                function __bool__(self::@like(X))::Bool
self.count_ += 1
return true
end


@oodef mutable struct BoolTest <: unittest.TestCase
                    
                    
                    
                end
                function test_repr(self::@like(BoolTest))
@test (repr(false) == "False")
@test (repr(true) == "True")
@test self === py"repr(false)"
@test self === py"repr(true)"
end

function test_str(self::@like(BoolTest))
@test (string(false) == "False")
@test (string(true) == "True")
end

function test_int(self::@like(BoolTest))
@test (parse(Int, false) == 0)
assertIsNot(self, parse(Int, false), false)
@test (parse(Int, true) == 1)
assertIsNot(self, parse(Int, true), true)
end

function test_float(self::@like(BoolTest))
@test (float(false) == 0.0)
assertIsNot(self, float(false), false)
@test (float(true) == 1.0)
assertIsNot(self, float(true), true)
end

function test_math(self::@like(BoolTest))
@test (+false == 0)
assertIsNot(self, +false, false)
@test (-false == 0)
assertIsNot(self, -false, false)
@test (abs(false) == 0)
assertIsNot(self, abs(false), false)
@test (+true == 1)
assertIsNot(self, +true, true)
@test (-true == -1)
@test (abs(true) == 1)
assertIsNot(self, abs(true), true)
@test (~false == -1)
@test (~true == -2)
@test (false + 2 == 2)
@test (true + 2 == 3)
@test (2 + false == 2)
@test (2 + true == 3)
@test (false + false == 0)
assertIsNot(self, false + false, false)
@test (false + true == 1)
assertIsNot(self, false + true, true)
@test (true + false == 1)
assertIsNot(self, true + false, true)
@test (true + true == 2)
@test (true - true == 0)
assertIsNot(self, true - true, false)
@test (false - false == 0)
assertIsNot(self, false - false, false)
@test (true - false == 1)
assertIsNot(self, true - false, true)
@test (false - true == -1)
@test (true*1 == 1)
@test (false*1 == 0)
assertIsNot(self, false*1, false)
@test (true / 1 == 1)
assertIsNot(self, true / 1, true)
@test (false / 1 == 0)
assertIsNot(self, false / 1, false)
@test (true % 1 == 0)
assertIsNot(self, true % 1, false)
@test (true % 2 == 1)
assertIsNot(self, true % 2, true)
@test (false % 1 == 0)
assertIsNot(self, false % 1, false)
for b in (false, true)
for i in (0, 1, 2)
@test (b^i == parse(Int, b)^i)
assertIsNot(self, b^i, Bool(parse(Int, b)^i))
end
end
for a in (false, true)
for b in (false, true)
@test self === a & b
@test self === a | b
@test self === a ⊻ b
@test (a & parse(Int, b) == parse(Int, a) & parse(Int, b))
assertIsNot(self, a & parse(Int, b), Bool(parse(Int, a) & parse(Int, b)))
@test (a | parse(Int, b) == parse(Int, a) | parse(Int, b))
assertIsNot(self, a | parse(Int, b), Bool(parse(Int, a) | parse(Int, b)))
@test (a ⊻ parse(Int, b) == parse(Int, a) ⊻ parse(Int, b))
assertIsNot(self, a ⊻ parse(Int, b), Bool(parse(Int, a) ⊻ parse(Int, b)))
@test (parse(Int, a) & b == parse(Int, a) & parse(Int, b))
assertIsNot(self, parse(Int, a) & b, Bool(parse(Int, a) & parse(Int, b)))
@test (parse(Int, a) | b == parse(Int, a) | parse(Int, b))
assertIsNot(self, parse(Int, a) | b, Bool(parse(Int, a) | parse(Int, b)))
@test (parse(Int, a) ⊻ b == parse(Int, a) ⊻ parse(Int, b))
assertIsNot(self, parse(Int, a) ⊻ b, Bool(parse(Int, a) ⊻ parse(Int, b)))
end
end
@test self === 1 == 1
@test self === 1 == 0
@test self === 0 < 1
@test self === 1 < 0
@test self === 0 <= 0
@test self === 1 <= 0
@test self === 1 > 0
@test self === 1 > 1
@test self === 1 >= 1
@test self === 0 >= 1
@test self === 0 != 1
@test self === 0 != 0
x = [1]
@test self === x === x
@test self === x !== x
@test self === 1 ∈ x
@test self === 0 ∈ x
@test self === 1 ∉ x
@test self === 0 ∉ x
x = Dict{Int64, Int64}(1 => 2)
@test self === x === x
@test self === x !== x
@test self === 1 ∈ x
@test self === 0 ∈ x
@test self === 1 ∉ x
@test self === 0 ∉ x
@test self === !true
@test self === !false
end

function test_convert(self::@like(BoolTest))
@test_throws
@test self === Bool(10)
@test self === Bool(1)
@test self === Bool(-1)
@test self === Bool(0)
@test self === Bool("hello")
@test self === Bool("")
@test self === false
end

function test_keyword_args(self::@like(BoolTest))
assertRaisesRegex(self, TypeError, "keyword argument") do 
false
end
end

function test_format(self::@like(BoolTest))
@test ("false" == "0")
@test ("true" == "1")
@test ("false" == "0")
@test ("true" == "1")
end

function test_hasattr(self::@like(BoolTest))
@test self === hasfield(typeof([]), :append)
@test self === hasfield(typeof([]), :wobble)
end

function test_callable(self::@like(BoolTest))
@test self === callable(len)
@test self === callable(1)
end

function test_isinstance(self::@like(BoolTest))
@test self === isa(true, Bool)
@test self === isa(false, Bool)
@test self === isa(true, Int64)
@test self === isa(false, Int64)
@test self === isa(1, Bool)
@test self === isa(0, Bool)
end

function test_issubclass(self::@like(BoolTest))
@test self === Bool <: Int64
@test self === Int64 <: Bool
end

function test_contains(self::@like(BoolTest))
@test self === 1 ∈ Dict()
@test self === 1 ∈ keys(Dict{int, int}(1 => 1))
end

function test_string(self::@like(BoolTest))
@test self === endswith("xyz", "z")
@test self === endswith("xyz", "x")
@test self === isalnum("xyz0123")
@test self === isalnum("@#\$%")
@test self === isalpha("xyz")
@test self === isalpha("@#\$%")
@test self === isdigit("0123")
@test self === isdigit("xyz")
@test self === islower("xyz")
@test self === islower("XYZ")
@test self === isdecimal("0123")
@test self === isdecimal("xyz")
@test self === isnumeric("0123")
@test self === isnumeric("xyz")
@test self === isspace(" ")
@test self === isspace(" ")
@test self === isspace("　")
@test self === isspace("XYZ")
@test self === istitle("X")
@test self === istitle("x")
@test self === isupper("XYZ")
@test self === isupper("xyz")
@test self === startswith("xyz", "x")
@test self === startswith("xyz", "z")
end

function test_boolean(self::@like(BoolTest))
@test (true & 1 == 1)
assertNotIsInstance(self, true & 1, Bool)
@test self === true & true
@test (true | 1 == 1)
assertNotIsInstance(self, true | 1, Bool)
@test self === true | true
@test (true ⊻ 1 == 0)
assertNotIsInstance(self, true ⊻ 1, Bool)
@test self === true ⊻ true
end

function test_fileclosed(self::@like(BoolTest))
try
readline(os_helper.TESTFN) do f 
@test self === f.closed
end
@test self === f.closed
finally
rm(os_helper.TESTFN)
end
end

function test_types(self::@like(BoolTest))
for t in [Bool, Complex, dict, Float64, Int64, Vector, object, set, String, Tuple, type_]
@test self === Bool(t)
end
end

function test_operator(self::@like(BoolTest))
@test self === operator.truth(0)
@test self === operator.truth(1)
@test self === operator.not_(1)
@test self === operator.not_(0)
@test self === operator.contains([], 1)
@test self === operator.contains([1], 1)
@test self === operator.lt(0, 0)
@test self === operator.lt(0, 1)
@test self === operator.is_(true, true)
@test self === operator.is_(true, false)
@test self === operator.is_not(true, true)
@test self === operator.is_not(true, false)
end

function test_marshal(self::@like(BoolTest))
@test self === marshal.loads(marshal.dumps(true))
@test self === marshal.loads(marshal.dumps(false))
end

function test_pickle(self::@like(BoolTest))
for proto in 0:pickle.HIGHEST_PROTOCOL
@test self === pickle.loads(pickle.dumps(true, proto))
@test self === pickle.loads(pickle.dumps(false, proto))
end
end

function test_picklevalues(self::@like(BoolTest))
@test (pickle.dumps(true, protocol = 0) == b"I01\n.")
@test (pickle.dumps(false, protocol = 0) == b"I00\n.")
@test (pickle.dumps(true, protocol = 1) == b"I01\n.")
@test (pickle.dumps(false, protocol = 1) == b"I00\n.")
@test (pickle.dumps(true, protocol = 2) == b"\x80\x02\x88.")
@test (pickle.dumps(false, protocol = 2) == b"\x80\x02\x89.")
end

function test_convert_to_bool(self::@like(BoolTest))
check = (o) -> @test_throws
check(Foo())
check(Bar())
check(Baz())
check(Spam())
@test_throws
end

function test_from_bytes(self::@like(BoolTest))
@test self === from_bytes(Bool, repeat(b"\x00",8), "big")
@test self === from_bytes(Bool, b"abcd", "little")
end

function test_sane_len(self::BoolTest)
for badval in ["illegal", -1, 1 << 32]
@oodef mutable struct A
                    
                    
                    
                end
                function __len__(self::@like(A))
return badval
end


try
Bool(A())
catch exn
 let e_bool = exn
if e_bool isa Exception
try
length(A())
catch exn
 let e_len = exn
if e_len isa Exception
@test (string(e_bool) == string(e_len))
end
end
end
end
end
end
end
end

function test_blocked(self::BoolTest)
@test_throws
@test_throws
end

function test_real_and_imag(self::BoolTest)
@test (true.real == 1)
@test (true.imag == 0)
@test self === type_(true.real)
@test self === type_(true.imag)
@test (false.real == 0)
@test (false.imag == 0)
@test self === type_(false.real)
@test self === type_(false.imag)
end

function test_bool_called_at_least_once(self::BoolTest)
function f(x::BoolTest)
if x||true
#= pass =#
end
end

x = X()
f(x)
assertGreaterEqual(self, x.count, 1)
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
end