using Test

import marshal




mutable struct BoolTest <: AbstractBoolTest
count::Int64
__bool__

                    BoolTest(count::Int64, __bool__ = nothing) =
                        new(count, __bool__)
end
function test_subclass(self)
try
mutable struct C <: AbstractC

end

catch exn
if exn isa TypeError
#= pass =#
end
end
assertRaises(self, TypeError, int.__new__, bool, 0)
end

function test_repr(self)
@test (repr(false) == "False")
@test (repr(true) == "True")
assertIs(self, eval(repr(false)), false)
assertIs(self, eval(repr(true)), true)
end

function test_str(self)
@test (string(false) == "False")
@test (string(true) == "True")
end

function test_int(self)
@test (parse(Int, false) == 0)
assertIsNot(self, parse(Int, false), false)
@test (parse(Int, true) == 1)
assertIsNot(self, parse(Int, true), true)
end

function test_float(self)
@test (float(false) == 0.0)
assertIsNot(self, float(false), false)
@test (float(true) == 1.0)
assertIsNot(self, float(true), true)
end

function test_math(self)
@test (+(false) == 0)
assertIsNot(self, +(false), false)
@test (-(false) == 0)
assertIsNot(self, -(false), false)
@test (abs(false) == 0)
assertIsNot(self, abs(false), false)
@test (+(true) == 1)
assertIsNot(self, +(true), true)
@test (-(true) == -1)
@test (abs(true) == 1)
assertIsNot(self, abs(true), true)
@test (~(false) == -1)
@test (~(true) == -2)
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
assertIs(self, a & b, Bool(parse(Int, a) & parse(Int, b)))
assertIs(self, a | b, Bool(parse(Int, a) | parse(Int, b)))
assertIs(self, a  ⊻  b, Bool(parse(Int, a)  ⊻  parse(Int, b)))
@test (a & parse(Int, b) == parse(Int, a) & parse(Int, b))
assertIsNot(self, a & parse(Int, b), Bool(parse(Int, a) & parse(Int, b)))
@test (a | parse(Int, b) == parse(Int, a) | parse(Int, b))
assertIsNot(self, a | parse(Int, b), Bool(parse(Int, a) | parse(Int, b)))
@test (a  ⊻  parse(Int, b) == parse(Int, a)  ⊻  parse(Int, b))
assertIsNot(self, a  ⊻  parse(Int, b), Bool(parse(Int, a)  ⊻  parse(Int, b)))
@test (parse(Int, a) & b == parse(Int, a) & parse(Int, b))
assertIsNot(self, parse(Int, a) & b, Bool(parse(Int, a) & parse(Int, b)))
@test (parse(Int, a) | b == parse(Int, a) | parse(Int, b))
assertIsNot(self, parse(Int, a) | b, Bool(parse(Int, a) | parse(Int, b)))
@test (parse(Int, a)  ⊻  b == parse(Int, a)  ⊻  parse(Int, b))
assertIsNot(self, parse(Int, a)  ⊻  b, Bool(parse(Int, a)  ⊻  parse(Int, b)))
end
end
assertIs(self, 1 == 1, true)
assertIs(self, 1 == 0, false)
assertIs(self, 0 < 1, true)
assertIs(self, 1 < 0, false)
assertIs(self, 0 <= 0, true)
assertIs(self, 1 <= 0, false)
assertIs(self, 1 > 0, true)
assertIs(self, 1 > 1, false)
assertIs(self, 1 >= 1, true)
assertIs(self, 0 >= 1, false)
assertIs(self, 0 != 1, true)
assertIs(self, 0 != 0, false)
x = [1]
assertIs(self, x === x, true)
assertIs(self, x !== x, false)
assertIs(self, 1 ∈ x, true)
assertIs(self, 0 ∈ x, false)
assertIs(self, 1 ∉ x, false)
assertIs(self, 0 ∉ x, true)
x = Dict(1 => 2)
assertIs(self, x === x, true)
assertIs(self, x !== x, false)
assertIs(self, 1 ∈ x, true)
assertIs(self, 0 ∈ x, false)
assertIs(self, 1 ∉ x, false)
assertIs(self, 0 ∉ x, true)
assertIs(self, !(true), false)
assertIs(self, !(false), true)
end

function test_convert(self)
@test_throws TypeError bool(42, 42)
assertIs(self, Bool(10), true)
assertIs(self, Bool(1), true)
assertIs(self, Bool(-1), true)
assertIs(self, Bool(0), false)
assertIs(self, Bool("hello"), true)
assertIs(self, Bool(""), false)
assertIs(self, false, false)
end

function test_keyword_args(self)
assertRaisesRegex(self, TypeError, "keyword argument") do 
Bool(x = 10)
end
end

function test_format(self)
@test ("%d" % false == "0")
@test ("%d" % true == "1")
@test ("%x" % false == "0")
@test ("%x" % true == "1")
end

function test_hasattr(self)
assertIs(self, hasfield(typeof([]), :append), true)
assertIs(self, hasfield(typeof([]), :wobble), false)
end

function test_callable(self)
assertIs(self, callable(len), true)
assertIs(self, callable(1), false)
end

function test_isinstance(self)
assertIs(self, isa(true, bool), true)
assertIs(self, isa(false, bool), true)
assertIs(self, isa(true, int), true)
assertIs(self, isa(false, int), true)
assertIs(self, isa(1, bool), false)
assertIs(self, isa(0, bool), false)
end

function test_issubclass(self)
assertIs(self, Bool <: Int64, true)
assertIs(self, Int64 <: Bool, false)
end

function test_contains(self)
assertIs(self, 1 ∈ Dict(), false)
assertIs(self, 1 ∈ keys(Dict(1 => 1)), true)
end

function test_string(self)
assertIs(self, endswith("xyz", "z"), true)
assertIs(self, endswith("xyz", "x"), false)
assertIs(self, isalnum("xyz0123"), true)
assertIs(self, isalnum("@#\$%"), false)
assertIs(self, isalpha("xyz"), true)
assertIs(self, isalpha("@#\$%"), false)
assertIs(self, isdigit("0123"), true)
assertIs(self, isdigit("xyz"), false)
assertIs(self, islower("xyz"), true)
assertIs(self, islower("XYZ"), false)
assertIs(self, isdecimal("0123"), true)
assertIs(self, isdecimal("xyz"), false)
assertIs(self, isnumeric("0123"), true)
assertIs(self, isnumeric("xyz"), false)
assertIs(self, isspace(" "), true)
assertIs(self, isspace(" "), true)
assertIs(self, isspace("　"), true)
assertIs(self, isspace("XYZ"), false)
assertIs(self, istitle("X"), true)
assertIs(self, istitle("x"), false)
assertIs(self, isupper("XYZ"), true)
assertIs(self, isupper("xyz"), false)
assertIs(self, startswith("xyz", "x"), true)
assertIs(self, startswith("xyz", "z"), false)
end

function test_boolean(self)
@test (true & 1 == 1)
assertNotIsInstance(self, true & 1, bool)
assertIs(self, true & true, true)
@test (true | 1 == 1)
assertNotIsInstance(self, true | 1, bool)
assertIs(self, true | true, true)
@test (true  ⊻  1 == 0)
assertNotIsInstance(self, true  ⊻  1, bool)
assertIs(self, true  ⊻  true, false)
end

function test_fileclosed(self)
try
readline(os_helper.TESTFN) do f 
assertIs(self, f.closed, false)
end
assertIs(self, f.closed, true)
finally
remove(os_helper.TESTFN)
end
end

function test_types(self)
for t in [bool, complex, dict, float, int, list, object, set, str, tuple, type_]
assertIs(self, Bool(t), true)
end
end

function test_operator(self)
assertIs(self, truth(0), false)
assertIs(self, truth(1), true)
assertIs(self, not_(1), false)
assertIs(self, not_(0), true)
assertIs(self, contains([], 1), false)
assertIs(self, contains([1], 1), true)
assertIs(self, lt(0, 0), false)
assertIs(self, lt(0, 1), true)
assertIs(self, is_(true, true), true)
assertIs(self, is_(true, false), false)
assertIs(self, is_not(true, true), false)
assertIs(self, is_not(true, false), true)
end

function test_marshal(self)
assertIs(self, loads(dumps(true)), true)
assertIs(self, loads(dumps(false)), false)
end

function test_pickle(self)
for proto in 0:pickle.HIGHEST_PROTOCOL
assertIs(self, loads(dumps(true, proto)), true)
assertIs(self, loads(dumps(false, proto)), false)
end
end

function test_picklevalues(self)
@test (dumps(true, protocol = 0) == b"I01\n.")
@test (dumps(false, protocol = 0) == b"I00\n.")
@test (dumps(true, protocol = 1) == b"I01\n.")
@test (dumps(false, protocol = 1) == b"I00\n.")
@test (dumps(true, protocol = 2) == b"\x80\x02\x88.")
@test (dumps(false, protocol = 2) == b"\x80\x02\x89.")
end

function test_convert_to_bool(self)
check = (o) -> assertRaises(self, TypeError, bool, o)
mutable struct Foo <: AbstractFoo

end
function __bool__(self)
return self
end

check(Foo())
mutable struct Bar <: AbstractBar

end
function __bool__(self)::String
return "Yes"
end

check(Bar())
mutable struct Baz <: AbstractBaz

end
function __bool__(self)
return self
end

check(Baz())
mutable struct Spam <: AbstractSpam

end
function __bool__(self)::Int64
return 1
end

check(Spam())
mutable struct Eggs <: AbstractEggs

end
function __len__(self)::Int64
return -1
end

assertRaises(self, ValueError, bool, Eggs())
end

function test_from_bytes(self)
assertIs(self, from_bytes(bool, repeat(b"\x00",8), "big"), false)
assertIs(self, from_bytes(bool, b"abcd", "little"), true)
end

function test_sane_len(self)
for badval in ["illegal", -1, 1 << 32]
mutable struct A <: AbstractA

end
function __len__(self)
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
assertEqual(self, string(e_bool), string(e_len))
end
end
end
end
end
end
end
end

function test_blocked(self)
mutable struct A <: AbstractA
__bool__

                    A(__bool__ = nothing) =
                        new(__bool__)
end

assertRaises(self, TypeError, bool, A())
mutable struct B <: AbstractB
__bool__

                    B(__bool__ = nothing) =
                        new(__bool__)
end
function __len__(self)::Int64
return 10
end

assertRaises(self, TypeError, bool, B())
end

function test_real_and_imag(self)
@test (true.real == 1)
@test (true.imag == 0)
assertIs(self, type_(true.real), int)
assertIs(self, type_(true.imag), int)
@test (false.real == 0)
@test (false.imag == 0)
assertIs(self, type_(false.real), int)
assertIs(self, type_(false.imag), int)
end

function test_bool_called_at_least_once(self)
mutable struct X <: AbstractX
count::Int64
end
function __bool__(self)::Bool
self.count += 1
return true
end

function f(x)
if x || true
#= pass =#
end
end

x = X()
f(x)
assertGreaterEqual(self, x.count, 1)
end

abstract type AbstractBoolTest end
abstract type AbstractC <: bool end
abstract type AbstractFoo <: object end
abstract type AbstractBar <: object end
abstract type AbstractBaz <: int end
abstract type AbstractSpam <: int end
if abspath(PROGRAM_FILE) == @__FILE__
bool_test = BoolTest()
test_subclass(bool_test)
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