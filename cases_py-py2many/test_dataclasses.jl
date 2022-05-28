using Test






import abc

import inspect
import builtins


using unittest.mock: Mock



using functools: total_ordering


abstract type AbstractCustomError <: Exception end
abstract type AbstractTestCase end
abstract type AbstractSubclass <: typ end
abstract type AbstractDate <: AbstractA end
abstract type AbstractBar <: AbstractFoo end
abstract type AbstractBaz <: AbstractFoo end
abstract type AbstractParent <: None end
abstract type AbstractT <: None end
abstract type AbstractLabeledBox <: None end
abstract type AbstractDataDerived <: None end
abstract type AbstractNonDataDerived <: None end
abstract type AbstractP <: Protocol end
abstract type AbstractTestFieldNoAnnotation end
abstract type AbstractTestDocString end
abstract type AbstractTestInit end
abstract type AbstractTestRepr end
abstract type AbstractTestEq end
abstract type AbstractTestOrdering end
abstract type AbstractTestHash end
abstract type AbstractTestFrozen end
abstract type AbstractI <: AbstractC end
abstract type AbstractS <: AbstractD end
abstract type AbstractTestSlots end
abstract type AbstractDerived <: AbstractBase end
abstract type AbstractDelivered <: AbstractBase end
abstract type AbstractAnotherDelivered <: AbstractBase end
abstract type AbstractTestDescriptors end
abstract type AbstractTestStringAnnotations end
abstract type AbstractTestMakeDataclass end
abstract type AbstractTestReplace end
abstract type AbstractTestAbstract end
abstract type AbstractOrdered <: abc.ABC end
abstract type AbstractTestMatchArgs end
abstract type AbstractZ <: AbstractY end
abstract type AbstractTestKeywordArgs end
mutable struct CustomError <: AbstractCustomError

end

mutable struct TestCase <: AbstractTestCase
args::type
child::Child
content::T
day::Int64
e::Int64
f::dict
group::Int64
i::Int64
id::UserId
init_base::InitVar{Int64}
init_derived::InitVar{Int64}
j::String
l::Vector
month::Int64
name::String
new_field::String
object::String
origin::type
self::String
selfx::String
token::Int64
users::Vector{User}
x::Int64
year::Int64
a::String
b::String
c::String
d::String
init_param::InitVar{Int64}
k::F
label::String
s::AbstractClassVar
t::Int64
w::ClassVar{Int64}
y::Int64
z::Int64

                    TestCase(args::type, child::Child, content::T, day::Int64, e::Int64, f::dict, group::Int64, i::Int64, id::UserId, init_base::InitVar{Int64}, init_derived::InitVar{Int64}, j::String, l::Vector, month::Int64, name::String, new_field::String, object::String, origin::type, self::String, selfx::String, token::Int64, users::Vector{User}, x::Int64, year::Int64, a::String = "B:a", b::String = "B:b", c::String = "B:c", d::String = "E:d", init_param::InitVar{Int64} = nothing, k::F = f, label::String = "<unknown>", s::AbstractClassVar = 4000, t::Int64 = 10, w::ClassVar{Int64} = 2000, y::Int64 = 0, z::Int64 = 10) =
                        new(args, child, content, day, e, f, group, i, id, init_base, init_derived, j, l, month, name, new_field, object, origin, self, selfx, token, users, x, year, a, b, c, d, init_param, k, label, s, t, w, y, z)
end
function test_no_fields(self)
mutable struct C <: AbstractC

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                
o = C()
assertEqual(self, length(fields(C)), 0)
end

function test_no_fields_but_member_variable(self)
mutable struct C <: AbstractC

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                
o = C()
assertEqual(self, length(fields(C)), 0)
end

function test_one_field_no_default(self)
mutable struct C <: AbstractC

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                
o = C(42)
assertEqual(self, o.x, 42)
end

function test_field_default_default_factory_error(self)
msg = "cannot specify both default and default_factory"
assertRaisesRegex(self, ValueError, msg) do 
mutable struct C <: AbstractC

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                
end
end

function test_field_repr(self)
int_field = field(default = 1, init = true, repr = false)
int_field.name = "id"
repr_output = repr(int_field)
expected_output = "Field(name=\'id\',type=None,default=1,default_factory=$('MISSING'),init=True,repr=False,hash=None,compare=True,metadata=mappingproxy({}),kw_only=$('MISSING'),_field_type=None)"
@test (repr_output == expected_output)
end

function test_named_init_params(self)
mutable struct C <: AbstractC

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                
o = C(32)
assertEqual(self, o.x, 32)
end

function test_two_fields_one_default(self)
mutable struct C <: AbstractC

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                
o = C(3)
assertEqual(self, (o.x, o.y), (3, 0))
assertRaisesRegex(self, TypeError, "non-default argument \'y\' follows default argument") do 
mutable struct C <: AbstractC

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                
end
assertRaisesRegex(self, TypeError, "non-default argument \'y\' follows default argument") do 
mutable struct B <: AbstractB

end

                function __repr__(self::AbstractB)::String 
                    return AbstractB() 
                end
            

                function __eq__(self::AbstractB, other::AbstractB)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractB)
                    ()
                end
                
mutable struct C <: AbstractC

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                
end
assertRaisesRegex(self, TypeError, "non-default argument \'y\' follows default argument") do 
mutable struct B <: AbstractB

end

                function __repr__(self::AbstractB)::String 
                    return AbstractB() 
                end
            

                function __eq__(self::AbstractB, other::AbstractB)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractB)
                    ()
                end
                
mutable struct C <: AbstractC

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                
end
end

function test_overwrite_hash(self)
mutable struct C <: AbstractC
x::Int64
end
function __hash__(self)::Int64
return 301
end


                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.x) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.x)
                end
                
assertEqual(self, hash(C(100)), 301)
mutable struct C <: AbstractC
x::Int64
end
function __eq__(self, other)::Bool
return false
end


                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.x) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.x)
                end
                
assertEqual(self, hash(C(100)), hash((100,)))
assertRaisesRegex(self, TypeError, "Cannot overwrite attribute __hash__") do 
mutable struct C <: AbstractC

end
function __hash__(self)
#= pass =#
end


                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __hash__(self::AbstractC)
                    return __key(self)
                end
                

                function __key(self::AbstractC)
                    ()
                end
                
end
mutable struct C <: AbstractC
x::Int64
end
function __eq__(self)
#= pass =#
end


                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.x) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __hash__(self::AbstractC)
                    return __key(self)
                end
                

                function __key(self::AbstractC)
                    (self.x)
                end
                
assertEqual(self, hash(C(10)), hash((10,)))
assertRaisesRegex(self, TypeError, "Cannot overwrite attribute __hash__") do 
mutable struct C <: AbstractC
x::Int64
end
function __eq__(self)
#= pass =#
end

function __hash__(self)
#= pass =#
end


                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.x) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __hash__(self::AbstractC)
                    return __key(self)
                end
                

                function __key(self::AbstractC)
                    (self.x)
                end
                
end
end

function test_overwrite_fields_in_derived_class(self)
mutable struct Base <: AbstractBase

end

                function __repr__(self::AbstractBase)::String 
                    return AbstractBase() 
                end
            

                function __eq__(self::AbstractBase, other::AbstractBase)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractBase)
                    ()
                end
                
mutable struct C1 <: AbstractC1

end

                function __repr__(self::AbstractC1)::String 
                    return AbstractC1() 
                end
            

                function __eq__(self::AbstractC1, other::AbstractC1)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC1)
                    ()
                end
                
o = Base()
assertEqual(self, repr(o), "TestCase.test_overwrite_fields_in_derived_class.<locals>.Base(x=15.0, y=0)")
o = C1()
assertEqual(self, repr(o), "TestCase.test_overwrite_fields_in_derived_class.<locals>.C1(x=15, y=0, z=10)")
o = C1(5)
assertEqual(self, repr(o), "TestCase.test_overwrite_fields_in_derived_class.<locals>.C1(x=5, y=0, z=10)")
end

function test_field_named_self(self)
mutable struct C <: AbstractC

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                
c = C("foo")
assertEqual(self, c.self, "foo")
sig = signature(C.__init__)
first = next((x for x in sig.parameters))
assertNotEqual(self, "self", first)
mutable struct C <: AbstractC

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                
sig = signature(C.__init__)
first = next((x for x in sig.parameters))
assertEqual(self, "self", first)
end

function test_field_named_object(self)
mutable struct C <: AbstractC

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                
c = C("foo")
assertEqual(self, c.object, "foo")
end

function test_field_named_object_frozen(self)
mutable struct C <: AbstractC
object::String
end

                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.object) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.object)
                end
                
c = C("foo")
assertEqual(self, c.object, "foo")
end

function test_field_named_like_builtin(self)
exclusions = Set(["None", "True", "False"])
builtins_names = sorted((b for b in keys(builtins.__dict__) if !startswith(b, "__") && b ∉ exclusions ))
attributes = [(name, str) for name in builtins_names]
C = make_dataclass("C", attributes)
c = C([name for name in builtins_names]...)
for name in builtins_names
@test (getfield(c, :name) == name)
end
end

function test_field_named_like_builtin_frozen(self)
exclusions = Set(["None", "True", "False"])
builtins_names = sorted((b for b in keys(builtins.__dict__) if !startswith(b, "__") && b ∉ exclusions ))
attributes = [(name, str) for name in builtins_names]
C = make_dataclass("C", attributes, frozen = true)
c = C([name for name in builtins_names]...)
for name in builtins_names
@test (getfield(c, :name) == name)
end
end

function test_0_field_compare(self)
mutable struct C0 <: AbstractC0

end

                function __repr__(self::AbstractC0)::String 
                    return AbstractC0() 
                end
            

                function __eq__(self::AbstractC0, other::AbstractC0)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC0)
                    ()
                end
                
mutable struct C1 <: AbstractC1

end

                function __repr__(self::AbstractC1)::String 
                    return AbstractC1() 
                end
            

                function __eq__(self::AbstractC1, other::AbstractC1)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC1)
                    ()
                end
                
for cls in [C0, C1]
subTest(self, cls = cls) do 
assertEqual(self, cls(), cls())
for (idx, fn) in enumerate([(a, b) -> a < b, (a, b) -> a <= b, (a, b) -> a > b, (a, b) -> a >= b])
subTest(self, idx = idx) do 
assertRaisesRegex(self, TypeError, "not supported between instances of \'$(cls.__name__)\' and \'$(cls.__name__)\'") do 
fn(cls(), cls())
end
end
end
end
end
mutable struct C <: AbstractC

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __lt__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) < __key(other)
                end

                function __le__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) <= __key(other)
                end

                function __gt__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) > __key(other)
                end

                function __ge__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) >= __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                
assertLessEqual(self, C(), C())
assertGreaterEqual(self, C(), C())
end

function test_1_field_compare(self)
mutable struct C0 <: AbstractC0

end

                function __repr__(self::AbstractC0)::String 
                    return AbstractC0() 
                end
            

                function __eq__(self::AbstractC0, other::AbstractC0)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC0)
                    ()
                end
                
mutable struct C1 <: AbstractC1
x::Int64
end

                function __repr__(self::AbstractC1)::String 
                    return AbstractC1(self.x) 
                end
            

                function __eq__(self::AbstractC1, other::AbstractC1)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC1)
                    (self.x)
                end
                
for cls in [C0, C1]
subTest(self, cls = cls) do 
assertEqual(self, cls(1), cls(1))
assertNotEqual(self, cls(0), cls(1))
for (idx, fn) in enumerate([(a, b) -> a < b, (a, b) -> a <= b, (a, b) -> a > b, (a, b) -> a >= b])
subTest(self, idx = idx) do 
assertRaisesRegex(self, TypeError, "not supported between instances of \'$(cls.__name__)\' and \'$(cls.__name__)\'") do 
fn(cls(0), cls(0))
end
end
end
end
end
mutable struct C <: AbstractC
x::Int64
end

                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.x) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __lt__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) < __key(other)
                end

                function __le__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) <= __key(other)
                end

                function __gt__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) > __key(other)
                end

                function __ge__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) >= __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.x)
                end
                
assertLess(self, C(0), C(1))
assertLessEqual(self, C(0), C(1))
assertLessEqual(self, C(1), C(1))
assertGreater(self, C(1), C(0))
assertGreaterEqual(self, C(1), C(0))
assertGreaterEqual(self, C(1), C(1))
end

function test_simple_compare(self)
mutable struct C0 <: AbstractC0

end

                function __repr__(self::AbstractC0)::String 
                    return AbstractC0() 
                end
            

                function __eq__(self::AbstractC0, other::AbstractC0)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC0)
                    ()
                end
                
mutable struct C1 <: AbstractC1
x::Int64
y::Int64
end

                function __repr__(self::AbstractC1)::String 
                    return AbstractC1(self.x, self.y) 
                end
            

                function __eq__(self::AbstractC1, other::AbstractC1)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC1)
                    (self.x, self.y)
                end
                
for cls in [C0, C1]
subTest(self, cls = cls) do 
assertEqual(self, cls(0, 0), cls(0, 0))
assertEqual(self, cls(1, 2), cls(1, 2))
assertNotEqual(self, cls(1, 0), cls(0, 0))
assertNotEqual(self, cls(1, 0), cls(1, 1))
for (idx, fn) in enumerate([(a, b) -> a < b, (a, b) -> a <= b, (a, b) -> a > b, (a, b) -> a >= b])
subTest(self, idx = idx) do 
assertRaisesRegex(self, TypeError, "not supported between instances of \'$(cls.__name__)\' and \'$(cls.__name__)\'") do 
fn(cls(0, 0), cls(0, 0))
end
end
end
end
end
mutable struct C <: AbstractC
x::Int64
y::Int64
end

                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.x, self.y) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __lt__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) < __key(other)
                end

                function __le__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) <= __key(other)
                end

                function __gt__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) > __key(other)
                end

                function __ge__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) >= __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.x, self.y)
                end
                
for (idx, fn) in enumerate([(a, b) -> a == b, (a, b) -> a <= b, (a, b) -> a >= b])
subTest(self, idx = idx) do 
assertTrue(self, fn(C(0, 0), C(0, 0)))
end
end
for (idx, fn) in enumerate([(a, b) -> a < b, (a, b) -> a <= b, (a, b) -> a != b])
subTest(self, idx = idx) do 
assertTrue(self, fn(C(0, 0), C(0, 1)))
assertTrue(self, fn(C(0, 1), C(1, 0)))
assertTrue(self, fn(C(1, 0), C(1, 1)))
end
end
for (idx, fn) in enumerate([(a, b) -> a > b, (a, b) -> a >= b, (a, b) -> a != b])
subTest(self, idx = idx) do 
assertTrue(self, fn(C(0, 1), C(0, 0)))
assertTrue(self, fn(C(1, 0), C(0, 1)))
assertTrue(self, fn(C(1, 1), C(1, 0)))
end
end
end

function test_compare_subclasses(self)
mutable struct B <: AbstractB

end

                function __repr__(self::AbstractB)::String 
                    return AbstractB() 
                end
            

                function __eq__(self::AbstractB, other::AbstractB)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractB)
                    ()
                end
                
mutable struct C <: AbstractC

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                
for (idx, (fn, expected)) in enumerate([((a, b) -> a == b, false), ((a, b) -> a != b, true)])
subTest(self, idx = idx) do 
assertEqual(self, fn(B(0), C(0)), expected)
end
end
for (idx, fn) in enumerate([(a, b) -> a < b, (a, b) -> a <= b, (a, b) -> a > b, (a, b) -> a >= b])
subTest(self, idx = idx) do 
assertRaisesRegex(self, TypeError, "not supported between instances of \'B\' and \'C\'") do 
fn(B(0), C(0))
end
end
end
end

function test_eq_order(self)
for (eq, order, result) in [(false, false, "neither"), (false, true, "exception"), (true, false, "eq_only"), (true, true, "both")]
subTest(self, eq = eq, order = order) do 
if result == "exception"
assertRaisesRegex(self, ValueError, "eq must be true if order is true") do 
mutable struct C <: AbstractC

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __lt__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) < __key(other)
                end

                function __le__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) <= __key(other)
                end

                function __gt__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) > __key(other)
                end

                function __ge__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) >= __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                
end
else
mutable struct C <: AbstractC

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __lt__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) < __key(other)
                end

                function __le__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) <= __key(other)
                end

                function __gt__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) > __key(other)
                end

                function __ge__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) >= __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                
if result == "neither"
assertNotIn(self, "__eq__", C.__dict__)
assertNotIn(self, "__lt__", C.__dict__)
assertNotIn(self, "__le__", C.__dict__)
assertNotIn(self, "__gt__", C.__dict__)
assertNotIn(self, "__ge__", C.__dict__)
elseif result == "both"
assertIn(self, "__eq__", C.__dict__)
assertIn(self, "__lt__", C.__dict__)
assertIn(self, "__le__", C.__dict__)
assertIn(self, "__gt__", C.__dict__)
assertIn(self, "__ge__", C.__dict__)
elseif result == "eq_only"
assertIn(self, "__eq__", C.__dict__)
assertNotIn(self, "__lt__", C.__dict__)
assertNotIn(self, "__le__", C.__dict__)
assertNotIn(self, "__gt__", C.__dict__)
assertNotIn(self, "__ge__", C.__dict__)
else
@assert(false)
end
end
end
end
end

function test_field_no_default(self)
mutable struct C <: AbstractC

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                
assertEqual(self, C(5).x, 5)
assertRaisesRegex(self, TypeError, "__init__\\(\\) missing 1 required positional argument: \'x\'") do 
C()
end
end

function test_field_default(self)
default = object()
mutable struct C <: AbstractC

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                
assertIs(self, C.x, default)
c = C(10)
assertEqual(self, c.x, 10)
#Delete Unsupported
del(c.x)
assertIs(self, c.x, default)
assertIs(self, C().x, default)
end

function test_not_in_repr(self)
mutable struct C <: AbstractC

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                
assertRaises(self, TypeError) do 
C()
end
c = C(10)
assertEqual(self, repr(c), "TestCase.test_not_in_repr.<locals>.C()")
mutable struct C <: AbstractC

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                
c = C(10, 20)
assertEqual(self, repr(c), "TestCase.test_not_in_repr.<locals>.C(y=20)")
end

function test_not_in_compare(self)
mutable struct C <: AbstractC

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                
assertEqual(self, C(), C(0, 20))
assertEqual(self, C(1, 10), C(1, 20))
assertNotEqual(self, C(3), C(4, 10))
assertNotEqual(self, C(3, 10), C(4, 10))
end

function test_hash_field_rules(self)
for (hash_, compare, result) in [(true, false, "field"), (true, true, "field"), (false, false, "absent"), (false, true, "absent"), (nothing, false, "absent"), (nothing, true, "field")]
subTest(self, hash = hash_, compare = compare) do 
mutable struct C <: AbstractC
x::Int64

                    C(x::Int64 = field(compare = compare, hash = hash_, default = 5)) =
                        new(x)
end

                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.x) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __hash__(self::AbstractC)
                    return __key(self)
                end
                

                function __key(self::AbstractC)
                    (self.x)
                end
                
if result == "field"
assertEqual(self, hash(C(5)), hash((5,)))
elseif result == "absent"
assertEqual(self, hash(C(5)), hash(()))
else
@assert(false)
end
end
end
end

function test_init_false_no_default(self)
mutable struct C <: AbstractC

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                
assertNotIn(self, "x", C().__dict__)
mutable struct C <: AbstractC

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                
assertNotIn(self, "z", C(0).__dict__)
assertEqual(self, vars(C(5)), Dict("t" => 10, "x" => 5, "y" => 0))
end

function test_class_marker(self)
mutable struct C <: AbstractC

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                
the_fields = fields(C)
assertIsInstance(self, the_fields, tuple)
for f in the_fields
assertIs(self, type_(f), Field)
assertIn(self, f.name, C.__annotations__)
end
assertEqual(self, length(the_fields), 3)
assertEqual(self, the_fields[1].name, "x")
assertEqual(self, the_fields[1].type, int)
assertFalse(self, hasfield(typeof(C), :x))
assertTrue(self, the_fields[1].init)
assertTrue(self, the_fields[1].repr)
assertEqual(self, the_fields[2].name, "y")
assertEqual(self, the_fields[2].type, str)
assertIsNone(self, getfield(C, :y))
assertFalse(self, the_fields[2].init)
assertTrue(self, the_fields[2].repr)
assertEqual(self, the_fields[3].name, "z")
assertEqual(self, the_fields[3].type, str)
assertFalse(self, hasfield(typeof(C), :z))
assertTrue(self, the_fields[3].init)
assertFalse(self, the_fields[3].repr)
end

function test_field_order(self)
mutable struct B <: AbstractB

end

                function __repr__(self::AbstractB)::String 
                    return AbstractB() 
                end
            

                function __eq__(self::AbstractB, other::AbstractB)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractB)
                    ()
                end
                
mutable struct C <: AbstractC

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                
assertEqual(self, [(f.name, f.default) for f in fields(C)], [("a", "B:a"), ("b", "C:b"), ("c", "B:c")])
mutable struct D <: AbstractD

end

                function __repr__(self::AbstractD)::String 
                    return AbstractD() 
                end
            

                function __eq__(self::AbstractD, other::AbstractD)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractD)
                    ()
                end
                
assertEqual(self, [(f.name, f.default) for f in fields(D)], [("a", "B:a"), ("b", "B:b"), ("c", "D:c")])
mutable struct E <: AbstractE

end

                function __repr__(self::AbstractE)::String 
                    return AbstractE() 
                end
            

                function __eq__(self::AbstractE, other::AbstractE)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractE)
                    ()
                end
                
assertEqual(self, [(f.name, f.default) for f in fields(E)], [("a", "E:a"), ("b", "B:b"), ("c", "D:c"), ("d", "E:d")])
end

function test_class_attrs(self)
default = object()
mutable struct C <: AbstractC

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                
assertFalse(self, hasfield(typeof(C), :x))
assertFalse(self, hasfield(typeof(C), :y))
assertIs(self, C.z, default)
assertEqual(self, C.t, 100)
end

function test_disallowed_mutable_defaults(self)
for (typ, empty, non_empty) in [(list, [], [1]), (dict, Dict(), Dict(0 => 1)), (set, set(), set([1]))]
subTest(self, typ = typ) do 
assertRaisesRegex(self, ValueError, "mutable default $(typ) for field x is not allowed") do 
mutable struct Point <: AbstractPoint

end

                function __repr__(self::AbstractPoint)::String 
                    return AbstractPoint() 
                end
            

                function __eq__(self::AbstractPoint, other::AbstractPoint)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractPoint)
                    ()
                end
                
end
assertRaisesRegex(self, ValueError, "mutable default $(typ) for field y is not allowed") do 
mutable struct Point <: AbstractPoint

end

                function __repr__(self::AbstractPoint)::String 
                    return AbstractPoint() 
                end
            

                function __eq__(self::AbstractPoint, other::AbstractPoint)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractPoint)
                    ()
                end
                
end
mutable struct Subclass <: AbstractSubclass

end

assertRaisesRegex(self, ValueError, "mutable default .*Subclass\'> for field z is not allowed") do 
mutable struct Point <: AbstractPoint

end

                function __repr__(self::AbstractPoint)::String 
                    return AbstractPoint() 
                end
            

                function __eq__(self::AbstractPoint, other::AbstractPoint)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractPoint)
                    ()
                end
                
end
mutable struct C <: AbstractC

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                
mutable struct C <: AbstractC

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                
end
end
end

function test_deliberately_mutable_defaults(self)
mutable struct Mutable <: AbstractMutable
l::Vector
end

mutable struct C <: AbstractC

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                
lst = Mutable()
o1 = C(lst)
o2 = C(lst)
assertEqual(self, o1, o2)
extend(o1.x.l, [1, 2])
assertEqual(self, o1, o2)
assertEqual(self, o1.x.l, [1, 2])
assertIs(self, o1.x, o2.x)
end

function test_no_options(self)
mutable struct C <: AbstractC
x::Int64
end

                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.x) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.x)
                end
                
assertEqual(self, C(42).x, 42)
end

function test_not_tuple(self)
mutable struct Point <: AbstractPoint

end

                function __repr__(self::AbstractPoint)::String 
                    return AbstractPoint() 
                end
            

                function __eq__(self::AbstractPoint, other::AbstractPoint)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractPoint)
                    ()
                end
                
assertNotEqual(self, Point(1, 2), (1, 2))
mutable struct C <: AbstractC

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                
assertNotEqual(self, Point(1, 3), C(1, 3))
end

function test_not_other_dataclass(self)
mutable struct Point3D <: AbstractPoint3D

end

                function __repr__(self::AbstractPoint3D)::String 
                    return AbstractPoint3D() 
                end
            

                function __eq__(self::AbstractPoint3D, other::AbstractPoint3D)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractPoint3D)
                    ()
                end
                
mutable struct Date <: AbstractDate

end

                function __repr__(self::AbstractDate)::String 
                    return AbstractDate() 
                end
            

                function __eq__(self::AbstractDate, other::AbstractDate)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractDate)
                    ()
                end
                
assertNotEqual(self, Point3D(2017, 6, 3), Date(2017, 6, 3))
assertNotEqual(self, Point3D(1, 2, 3), (1, 2, 3))
assertRaisesRegex(self, TypeError, "unpack") do 
x, y, z = Point3D(4, 5, 6)
end
mutable struct Point3Dv1 <: AbstractPoint3Dv1

end

                function __repr__(self::AbstractPoint3Dv1)::String 
                    return AbstractPoint3Dv1() 
                end
            

                function __eq__(self::AbstractPoint3Dv1, other::AbstractPoint3Dv1)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractPoint3Dv1)
                    ()
                end
                
assertNotEqual(self, Point3D(0, 0, 0), Point3Dv1())
end

function test_function_annotations(self)
mutable struct F <: AbstractF

end

f = F()
function validate_class(cls)
assertEqual(self, cls.__annotations__["i"], int)
assertEqual(self, cls.__annotations__["j"], str)
assertEqual(self, cls.__annotations__["k"], F)
assertEqual(self, cls.__annotations__["l"], float)
assertEqual(self, cls.__annotations__["z"], complex)
signature = signature(cls.__init__)
assertIs(self, signature.return_annotation, nothing)
params = (x for x in values(signature.parameters))
param = next(params)
assertEqual(self, param.name, "self")
param = next(params)
assertEqual(self, param.name, "i")
assertIs(self, param.annotation, int)
assertEqual(self, param.default, inspect.Parameter.empty)
assertEqual(self, param.kind, inspect.Parameter.POSITIONAL_OR_KEYWORD)
param = next(params)
assertEqual(self, param.name, "j")
assertIs(self, param.annotation, str)
assertEqual(self, param.default, inspect.Parameter.empty)
assertEqual(self, param.kind, inspect.Parameter.POSITIONAL_OR_KEYWORD)
param = next(params)
assertEqual(self, param.name, "k")
assertIs(self, param.annotation, F)
assertEqual(self, param.kind, inspect.Parameter.POSITIONAL_OR_KEYWORD)
param = next(params)
assertEqual(self, param.name, "l")
assertIs(self, param.annotation, float)
assertEqual(self, param.kind, inspect.Parameter.POSITIONAL_OR_KEYWORD)
assertRaises(self, StopIteration, next, params)
end

mutable struct C <: AbstractC

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                
validate_class(C)
mutable struct C <: AbstractC
i::Int64
j::String
k::AbstractF
l::Float64
z::Complex

                    C(i::Int64, j::String, k::AbstractF = f, l::Float64 = field(default = nothing), z::Complex = field(default = 3 + 4im, init = false)) =
                        new(i, j, k, l, z)
end

                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.i, self.j, self.k, self.l, self.z) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __hash__(self::AbstractC)
                    return __key(self)
                end
                

                function __key(self::AbstractC)
                    (self.i, self.j, __key(self.k), self.l, self.z)
                end
                
validate_class(C)
end

function test_missing_default(self)
mutable struct C <: AbstractC

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                
assertRaisesRegex(self, TypeError, "__init__\\(\\) missing 1 required positional argument") do 
C()
end
assertNotIn(self, "x", C.__dict__)
mutable struct D <: AbstractD

end

                function __repr__(self::AbstractD)::String 
                    return AbstractD() 
                end
            

                function __eq__(self::AbstractD, other::AbstractD)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractD)
                    ()
                end
                
assertRaisesRegex(self, TypeError, "__init__\\(\\) missing 1 required positional argument") do 
D()
end
assertNotIn(self, "x", D.__dict__)
end

function test_missing_default_factory(self)
mutable struct C <: AbstractC

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                
assertRaisesRegex(self, TypeError, "__init__\\(\\) missing 1 required positional argument") do 
C()
end
assertNotIn(self, "x", C.__dict__)
mutable struct D <: AbstractD

end

                function __repr__(self::AbstractD)::String 
                    return AbstractD() 
                end
            

                function __eq__(self::AbstractD, other::AbstractD)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractD)
                    ()
                end
                
assertRaisesRegex(self, TypeError, "__init__\\(\\) missing 1 required positional argument") do 
D()
end
assertNotIn(self, "x", D.__dict__)
end

function test_missing_repr(self)
assertIn(self, "MISSING_TYPE object", repr(MISSING))
end

function test_dont_include_other_annotations(self)
mutable struct C <: AbstractC

end
function foo(self)::Int64
return 4
end

function bar(self)::Int64
return 5
end


                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                
assertEqual(self, collect(C.__annotations__), ["i"])
assertEqual(self, foo(C(10)), 4)
assertEqual(self, C(10).bar, 5)
assertEqual(self, C(10).i, 10)
end

function test_post_init(self)
mutable struct C <: AbstractC

end
function __post_init__(self)
throw(CustomError())
end


                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                
assertRaises(self, CustomError) do 
C()
end
mutable struct C <: AbstractC

end
function __post_init__(self)
if self.i == 10
throw(CustomError())
end
end


                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                
assertRaises(self, CustomError) do 
C()
end
C(5)
mutable struct C <: AbstractC

end
function __post_init__(self)
throw(CustomError())
end


                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                
C()
mutable struct C <: AbstractC

end
function __post_init__(self)
self.x *= 2
end


                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                
assertEqual(self, C().x, 0)
assertEqual(self, C(2).x, 4)
mutable struct C <: AbstractC
x::Int64

                    C(x::Int64 = 0) =
                        new(x)
end
function __post_init__(self)
self.x *= 2
end


                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.x) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.x)
                end
                
assertRaises(self, FrozenInstanceError) do 
C()
end
end

function test_post_init_super(self)
mutable struct B <: AbstractB

end
function __post_init__(self)
throw(CustomError())
end

mutable struct C <: AbstractC

end
function __post_init__(self)
self.x = 5
end


                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                
assertEqual(self, C().x, 5)
mutable struct C <: AbstractC

end
function __post_init__(self)
__post_init__(super())
end


                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                
assertRaises(self, CustomError) do 
C()
end
mutable struct C <: AbstractC

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                
assertRaises(self, CustomError) do 
C()
end
end

function test_post_init_staticmethod(self)
flag = false
mutable struct C <: AbstractC

end
function __post_init__()
# Not Supported
# nonlocal flag
flag = true
end


                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                
assertFalse(self, flag)
c = C(3, 4)
assertEqual(self, (c.x, c.y), (3, 4))
assertTrue(self, flag)
end

function test_post_init_classmethod(self)
mutable struct C <: AbstractC

end
function __post_init__(cls)
cls.flag = true
end


                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                
assertFalse(self, C.flag)
c = C(3, 4)
assertEqual(self, (c.x, c.y), (3, 4))
assertTrue(self, C.flag)
end

function test_class_var(self)
mutable struct C <: AbstractC

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                
c = C(5)
assertEqual(self, repr(c), "TestCase.test_class_var.<locals>.C(x=5, y=10)")
assertEqual(self, length(fields(C)), 2)
assertEqual(self, length(C.__annotations__), 6)
assertEqual(self, c.z, 1000)
assertEqual(self, c.w, 2000)
assertEqual(self, c.t, 3000)
assertEqual(self, c.s, 4000)
C.z += 1
assertEqual(self, c.z, 1001)
c = C(20)
assertEqual(self, (c.x, c.y), (20, 10))
assertEqual(self, c.z, 1001)
assertEqual(self, c.w, 2000)
assertEqual(self, c.t, 3000)
assertEqual(self, c.s, 4000)
end

function test_class_var_no_default(self)
mutable struct C <: AbstractC

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                
assertNotIn(self, "x", C.__dict__)
end

function test_class_var_default_factory(self)
assertRaisesRegex(self, TypeError, "cannot have a default factory") do 
mutable struct C <: AbstractC

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                
assertNotIn(self, "x", C.__dict__)
end
end

function test_class_var_with_default(self)
mutable struct C <: AbstractC

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                
assertEqual(self, C.x, 10)
mutable struct C <: AbstractC

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                
assertEqual(self, C.x, 10)
end

function test_class_var_frozen(self)
mutable struct C <: AbstractC
x::Int64
t::ClassVar{Int64}
w::ClassVar{Int64}
y::Int64
z::ClassVar{Int64}

                    C(x::Int64, t::ClassVar{Int64} = 3000, w::ClassVar{Int64} = 2000, y::Int64 = 10, z::ClassVar{Int64} = 1000) =
                        new(x, t, w, y, z)
end

                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.x, self.t, self.w, self.y, self.z) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.x, self.t, self.w, self.y, self.z)
                end
                
c = C(5)
assertEqual(self, repr(C(5)), "TestCase.test_class_var_frozen.<locals>.C(x=5, y=10)")
assertEqual(self, length(fields(C)), 2)
assertEqual(self, length(C.__annotations__), 5)
assertEqual(self, c.z, 1000)
assertEqual(self, c.w, 2000)
assertEqual(self, c.t, 3000)
C.z += 1
assertEqual(self, c.z, 1001)
c = C(20)
assertEqual(self, (c.x, c.y), (20, 10))
assertEqual(self, c.z, 1001)
assertEqual(self, c.w, 2000)
assertEqual(self, c.t, 3000)
end

function test_init_var_no_default(self)
mutable struct C <: AbstractC

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                
assertNotIn(self, "x", C.__dict__)
end

function test_init_var_default_factory(self)
assertRaisesRegex(self, TypeError, "cannot have a default factory") do 
mutable struct C <: AbstractC

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                
assertNotIn(self, "x", C.__dict__)
end
end

function test_init_var_with_default(self)
mutable struct C <: AbstractC

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                
assertEqual(self, C.x, 10)
mutable struct C <: AbstractC

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                
assertEqual(self, C.x, 10)
end

function test_init_var(self)
mutable struct C <: AbstractC

end
function __post_init__(self, init_param)
if self.x === nothing
self.x = init_param*2
end
end


                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                
c = C(10)
assertEqual(self, c.x, 20)
end

function test_init_var_preserve_type(self)
@test (InitVar[int + 1].type == int)
@test (repr(InitVar[int + 1]) == "dataclasses.InitVar[int]")
@test (repr(InitVar[List[int + 1] + 1]) == "dataclasses.InitVar[typing.List[int]]")
@test (repr(InitVar[list[int + 1] + 1]) == "dataclasses.InitVar[list[int]]")
@test (repr(InitVar[int | str + 1]) == "dataclasses.InitVar[int | str]")
end

function test_init_var_inheritance(self)
mutable struct Base <: AbstractBase

end

                function __repr__(self::AbstractBase)::String 
                    return AbstractBase() 
                end
            

                function __eq__(self::AbstractBase, other::AbstractBase)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractBase)
                    ()
                end
                
b = Base(0, 10)
assertEqual(self, vars(b), Dict("x" => 0))
mutable struct C <: AbstractC

end
function __post_init__(self, init_base, init_derived)
self.x = self.x + init_base
self.y = self.y + init_derived
end


                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                
c = C(10, 11, 50, 51)
assertEqual(self, vars(c), Dict("x" => 21, "y" => 101))
end

function test_default_factory(self)
mutable struct C <: AbstractC

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                
c0 = C(3)
c1 = C(3)
assertEqual(self, c0.x, 3)
assertEqual(self, c0.y, [])
assertEqual(self, c0, c1)
assertIsNot(self, c0.y, c1.y)
assertEqual(self, astuple(C(5, [1])), (5, [1]))
l = []
mutable struct C <: AbstractC

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                
c0 = C(3)
c1 = C(3)
assertEqual(self, c0.x, 3)
assertEqual(self, c0.y, [])
assertEqual(self, c0, c1)
assertIs(self, c0.y, c1.y)
assertEqual(self, astuple(C(5, [1])), (5, [1]))
mutable struct C <: AbstractC

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                
assertEqual(self, repr(C()), "TestCase.test_default_factory.<locals>.C()")
assertEqual(self, C().x, [])
mutable struct C <: AbstractC
x::Vector

                    C(x::Vector = field(default_factory = list, hash = false)) =
                        new(x)
end

                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.x) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __hash__(self::AbstractC)
                    return __key(self)
                end
                

                function __key(self::AbstractC)
                    (self.x)
                end
                
assertEqual(self, astuple(C()), ([],))
assertEqual(self, hash(C()), hash(()))
mutable struct C <: AbstractC

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                
assertEqual(self, astuple(C()), ([],))
mutable struct C <: AbstractC

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                
assertEqual(self, C(), C([1]))
end

function test_default_factory_with_no_init(self)
factory = Mock()
mutable struct C <: AbstractC

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                
C().x
assertEqual(self, factory.call_count, 1)
C().x
assertEqual(self, factory.call_count, 2)
end

function test_default_factory_not_called_if_value_given(self)
factory = Mock()
mutable struct C <: AbstractC

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                
C().x
assertEqual(self, factory.call_count, 1)
assertEqual(self, C(10).x, 10)
assertEqual(self, factory.call_count, 1)
C().x
assertEqual(self, factory.call_count, 2)
end

function test_default_factory_derived(self)
mutable struct Foo <: AbstractFoo

end

                function __repr__(self::AbstractFoo)::String 
                    return AbstractFoo() 
                end
            

                function __eq__(self::AbstractFoo, other::AbstractFoo)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractFoo)
                    ()
                end
                
mutable struct Bar <: AbstractBar

end

                function __repr__(self::AbstractBar)::String 
                    return AbstractBar() 
                end
            

                function __eq__(self::AbstractBar, other::AbstractBar)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractBar)
                    ()
                end
                
assertEqual(self, Foo().x, Dict())
assertEqual(self, Bar().x, Dict())
assertEqual(self, Bar().y, 1)
mutable struct Baz <: AbstractBaz

end

                function __repr__(self::AbstractBaz)::String 
                    return AbstractBaz() 
                end
            

                function __eq__(self::AbstractBaz, other::AbstractBaz)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractBaz)
                    ()
                end
                
assertEqual(self, Baz().x, Dict())
end

function test_intermediate_non_dataclass(self)
mutable struct A <: AbstractA

end

                function __repr__(self::AbstractA)::String 
                    return AbstractA() 
                end
            

                function __eq__(self::AbstractA, other::AbstractA)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractA)
                    ()
                end
                
mutable struct B <: AbstractB
y::Int64
end

mutable struct C <: AbstractC

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                
c = C(1, 3)
assertEqual(self, (c.x, c.z), (1, 3))
assertRaisesRegex(self, AttributeError, "object has no attribute") do 
c.y
end
mutable struct D <: AbstractD
t::Int64
end

d = D(4, 5)
assertEqual(self, (d.x, d.z), (4, 5))
end

function test_classvar_default_factory(self)
assertRaisesRegex(self, TypeError, "cannot have a default factory") do 
mutable struct C <: AbstractC

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                
end
end

function test_is_dataclass(self)
mutable struct NotDataClass <: AbstractNotDataClass

end

assertFalse(self, is_dataclass(0))
assertFalse(self, is_dataclass(int))
assertFalse(self, is_dataclass(NotDataClass))
assertFalse(self, is_dataclass(NotDataClass()))
mutable struct C <: AbstractC

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                
mutable struct D <: AbstractD

end

                function __repr__(self::AbstractD)::String 
                    return AbstractD() 
                end
            

                function __eq__(self::AbstractD, other::AbstractD)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractD)
                    ()
                end
                
c = C(10)
d = D(c, 4)
assertTrue(self, is_dataclass(C))
assertTrue(self, is_dataclass(c))
assertFalse(self, is_dataclass(c.x))
assertTrue(self, is_dataclass(d.d))
assertFalse(self, is_dataclass(d.e))
end

function test_is_dataclass_when_getattr_always_returns(self)
mutable struct A <: AbstractA

end
function __getattr__(self, key)::Int64
return 0
end

assertFalse(self, is_dataclass(A))
a = A()
mutable struct B <: AbstractB

end

b = B()
b.__dataclass_fields__ = []
for obj in (a, b)
subTest(self, obj = obj) do 
assertFalse(self, is_dataclass(obj))
assertRaisesRegex(self, TypeError, "should be called on dataclass instances") do 
asdict(obj)
end
assertRaisesRegex(self, TypeError, "should be called on dataclass instances") do 
astuple(obj)
end
assertRaisesRegex(self, TypeError, "should be called on dataclass instances") do 
replace(obj, x = 0)
end
end
end
end

function test_is_dataclass_genericalias(self)
mutable struct A <: AbstractA

end

                function __repr__(self::AbstractA)::String 
                    return AbstractA() 
                end
            

                function __eq__(self::AbstractA, other::AbstractA)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractA)
                    ()
                end
                
assertTrue(self, is_dataclass(A))
a = A(list, int)
assertTrue(self, is_dataclass(type_(a)))
assertTrue(self, is_dataclass(a))
end

function test_helper_fields_with_class_instance(self)
mutable struct C <: AbstractC

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                
assertEqual(self, fields(C), fields(C(0, 0.0)))
end

function test_helper_fields_exception(self)
assertRaisesRegex(self, TypeError, "dataclass type or instance") do 
fields(0)
end
mutable struct C <: AbstractC

end

assertRaisesRegex(self, TypeError, "dataclass type or instance") do 
fields(C)
end
assertRaisesRegex(self, TypeError, "dataclass type or instance") do 
fields(C())
end
end

function test_helper_asdict(self)
mutable struct C <: AbstractC

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                
c = C(1, 2)
assertEqual(self, asdict(c), Dict("x" => 1, "y" => 2))
assertEqual(self, asdict(c), asdict(c))
assertIsNot(self, asdict(c), asdict(c))
c.x = 42
assertEqual(self, asdict(c), Dict("x" => 42, "y" => 2))
assertIs(self, type_(asdict(c)), dict)
end

function test_helper_asdict_raises_on_classes(self)
mutable struct C <: AbstractC

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                
assertRaisesRegex(self, TypeError, "dataclass instance") do 
asdict(C)
end
assertRaisesRegex(self, TypeError, "dataclass instance") do 
asdict(int)
end
end

function test_helper_asdict_copy_values(self)
mutable struct C <: AbstractC

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                
initial = []
c = C(1, initial)
d = asdict(c)
assertEqual(self, d["y"], initial)
assertIsNot(self, d["y"], initial)
c = C(1)
d = asdict(c)
append(d["y"], 1)
assertEqual(self, c.y, [])
end

function test_helper_asdict_nested(self)
mutable struct UserId <: AbstractUserId

end

                function __repr__(self::AbstractUserId)::String 
                    return AbstractUserId() 
                end
            

                function __eq__(self::AbstractUserId, other::AbstractUserId)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractUserId)
                    ()
                end
                
mutable struct User <: AbstractUser

end

                function __repr__(self::AbstractUser)::String 
                    return AbstractUser() 
                end
            

                function __eq__(self::AbstractUser, other::AbstractUser)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractUser)
                    ()
                end
                
u = User("Joe", UserId(123, 1))
d = asdict(u)
assertEqual(self, d, Dict("name" => "Joe", "id" => Dict("token" => 123, "group" => 1)))
assertIsNot(self, asdict(u), asdict(u))
u.id.group = 2
assertEqual(self, asdict(u), Dict("name" => "Joe", "id" => Dict("token" => 123, "group" => 2)))
end

function test_helper_asdict_builtin_containers(self)
mutable struct User <: AbstractUser

end

                function __repr__(self::AbstractUser)::String 
                    return AbstractUser() 
                end
            

                function __eq__(self::AbstractUser, other::AbstractUser)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractUser)
                    ()
                end
                
mutable struct GroupList <: AbstractGroupList

end

                function __repr__(self::AbstractGroupList)::String 
                    return AbstractGroupList() 
                end
            

                function __eq__(self::AbstractGroupList, other::AbstractGroupList)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractGroupList)
                    ()
                end
                
mutable struct GroupTuple <: AbstractGroupTuple

end

                function __repr__(self::AbstractGroupTuple)::String 
                    return AbstractGroupTuple() 
                end
            

                function __eq__(self::AbstractGroupTuple, other::AbstractGroupTuple)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractGroupTuple)
                    ()
                end
                
mutable struct GroupDict <: AbstractGroupDict

end

                function __repr__(self::AbstractGroupDict)::String 
                    return AbstractGroupDict() 
                end
            

                function __eq__(self::AbstractGroupDict, other::AbstractGroupDict)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractGroupDict)
                    ()
                end
                
a = User("Alice", 1)
b = User("Bob", 2)
gl = GroupList(0, [a, b])
gt = GroupTuple(0, (a, b))
gd = GroupDict(0, Dict("first" => a, "second" => b))
assertEqual(self, asdict(gl), Dict("id" => 0, "users" => [Dict("name" => "Alice", "id" => 1), Dict("name" => "Bob", "id" => 2)]))
assertEqual(self, asdict(gt), Dict("id" => 0, "users" => (Dict("name" => "Alice", "id" => 1), Dict("name" => "Bob", "id" => 2))))
assertEqual(self, asdict(gd), Dict("id" => 0, "users" => Dict("first" => Dict("name" => "Alice", "id" => 1), "second" => Dict("name" => "Bob", "id" => 2))))
end

function test_helper_asdict_builtin_object_containers(self)
mutable struct Child <: AbstractChild

end

                function __repr__(self::AbstractChild)::String 
                    return AbstractChild() 
                end
            

                function __eq__(self::AbstractChild, other::AbstractChild)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractChild)
                    ()
                end
                
mutable struct Parent <: AbstractParent

end

                function __repr__(self::AbstractParent)::String 
                    return AbstractParent() 
                end
            

                function __eq__(self::AbstractParent, other::AbstractParent)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractParent)
                    ()
                end
                
assertEqual(self, asdict(Parent(Child([1]))), Dict("child" => Dict("d" => [1])))
assertEqual(self, asdict(Parent(Child(Dict(1 => 2)))), Dict("child" => Dict("d" => Dict(1 => 2))))
end

function test_helper_asdict_factory(self)
mutable struct C <: AbstractC

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                
c = C(1, 2)
d = asdict(c, dict_factory = OrderedDict)
assertEqual(self, d, OrderedDict([("x", 1), ("y", 2)]))
assertIsNot(self, d, asdict(c, dict_factory = OrderedDict))
c.x = 42
d = asdict(c, dict_factory = OrderedDict)
assertEqual(self, d, OrderedDict([("x", 42), ("y", 2)]))
assertIs(self, type_(d), OrderedDict)
end

function test_helper_asdict_namedtuple(self)
T = namedtuple("T", "a b c")
mutable struct C <: AbstractC

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                
c = C("outer", T(1, C("inner", T(11, 12, 13)), 2))
d = asdict(c)
assertEqual(self, d, Dict("x" => "outer", "y" => T(1, Dict("x" => "inner", "y" => T(11, 12, 13)), 2)))
d = asdict(c, dict_factory = OrderedDict)
assertEqual(self, d, Dict("x" => "outer", "y" => T(1, Dict("x" => "inner", "y" => T(11, 12, 13)), 2)))
assertIs(self, type_(d), OrderedDict)
assertIs(self, type_(d["y"][2]), OrderedDict)
end

function test_helper_asdict_namedtuple_key(self)
mutable struct C <: AbstractC

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                
T = namedtuple("T", "a")
c = C(Dict(T("an a") => 0))
assertEqual(self, asdict(c), Dict("f" => Dict(T("an a") => 0)))
end

function test_helper_asdict_namedtuple_derived(self)
mutable struct T <: AbstractT
a::AbstractAny
end
function my_a(self)
return self.a
end

mutable struct C <: AbstractC

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                
t = T(6)
c = C(t)
d = asdict(c)
assertEqual(self, d, Dict("f" => T(6)))
assertIsNot(self, d["f"], t)
assertEqual(self, my_a(d["f"]), 6)
end

function test_helper_astuple(self)
mutable struct C <: AbstractC

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                
c = C(1)
assertEqual(self, astuple(c), (1, 0))
assertEqual(self, astuple(c), astuple(c))
assertIsNot(self, astuple(c), astuple(c))
c.y = 42
assertEqual(self, astuple(c), (1, 42))
assertIs(self, type_(astuple(c)), tuple)
end

function test_helper_astuple_raises_on_classes(self)
mutable struct C <: AbstractC

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                
assertRaisesRegex(self, TypeError, "dataclass instance") do 
astuple(C)
end
assertRaisesRegex(self, TypeError, "dataclass instance") do 
astuple(int)
end
end

function test_helper_astuple_copy_values(self)
mutable struct C <: AbstractC

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                
initial = []
c = C(1, initial)
t = astuple(c)
assertEqual(self, t[2], initial)
assertIsNot(self, t[2], initial)
c = C(1)
t = astuple(c)
append(t[2], 1)
assertEqual(self, c.y, [])
end

function test_helper_astuple_nested(self)
mutable struct UserId <: AbstractUserId

end

                function __repr__(self::AbstractUserId)::String 
                    return AbstractUserId() 
                end
            

                function __eq__(self::AbstractUserId, other::AbstractUserId)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractUserId)
                    ()
                end
                
mutable struct User <: AbstractUser

end

                function __repr__(self::AbstractUser)::String 
                    return AbstractUser() 
                end
            

                function __eq__(self::AbstractUser, other::AbstractUser)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractUser)
                    ()
                end
                
u = User("Joe", UserId(123, 1))
t = astuple(u)
assertEqual(self, t, ("Joe", (123, 1)))
assertIsNot(self, astuple(u), astuple(u))
u.id.group = 2
assertEqual(self, astuple(u), ("Joe", (123, 2)))
end

function test_helper_astuple_builtin_containers(self)
mutable struct User <: AbstractUser

end

                function __repr__(self::AbstractUser)::String 
                    return AbstractUser() 
                end
            

                function __eq__(self::AbstractUser, other::AbstractUser)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractUser)
                    ()
                end
                
mutable struct GroupList <: AbstractGroupList

end

                function __repr__(self::AbstractGroupList)::String 
                    return AbstractGroupList() 
                end
            

                function __eq__(self::AbstractGroupList, other::AbstractGroupList)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractGroupList)
                    ()
                end
                
mutable struct GroupTuple <: AbstractGroupTuple

end

                function __repr__(self::AbstractGroupTuple)::String 
                    return AbstractGroupTuple() 
                end
            

                function __eq__(self::AbstractGroupTuple, other::AbstractGroupTuple)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractGroupTuple)
                    ()
                end
                
mutable struct GroupDict <: AbstractGroupDict

end

                function __repr__(self::AbstractGroupDict)::String 
                    return AbstractGroupDict() 
                end
            

                function __eq__(self::AbstractGroupDict, other::AbstractGroupDict)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractGroupDict)
                    ()
                end
                
a = User("Alice", 1)
b = User("Bob", 2)
gl = GroupList(0, [a, b])
gt = GroupTuple(0, (a, b))
gd = GroupDict(0, Dict("first" => a, "second" => b))
assertEqual(self, astuple(gl), (0, [("Alice", 1), ("Bob", 2)]))
assertEqual(self, astuple(gt), (0, (("Alice", 1), ("Bob", 2))))
assertEqual(self, astuple(gd), (0, Dict("first" => ("Alice", 1), "second" => ("Bob", 2))))
end

function test_helper_astuple_builtin_object_containers(self)
mutable struct Child <: AbstractChild

end

                function __repr__(self::AbstractChild)::String 
                    return AbstractChild() 
                end
            

                function __eq__(self::AbstractChild, other::AbstractChild)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractChild)
                    ()
                end
                
mutable struct Parent <: AbstractParent

end

                function __repr__(self::AbstractParent)::String 
                    return AbstractParent() 
                end
            

                function __eq__(self::AbstractParent, other::AbstractParent)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractParent)
                    ()
                end
                
assertEqual(self, astuple(Parent(Child([1]))), (([1],),))
assertEqual(self, astuple(Parent(Child(Dict(1 => 2)))), ((Dict(1 => 2),),))
end

function test_helper_astuple_factory(self)
mutable struct C <: AbstractC

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                
NT = namedtuple("NT", "x y")
function nt(lst)
return NT(lst...)
end

c = C(1, 2)
t = astuple(c, tuple_factory = nt)
assertEqual(self, t, NT(1, 2))
assertIsNot(self, t, astuple(c, tuple_factory = nt))
c.x = 42
t = astuple(c, tuple_factory = nt)
assertEqual(self, t, NT(42, 2))
assertIs(self, type_(t), NT)
end

function test_helper_astuple_namedtuple(self)
T = namedtuple("T", "a b c")
mutable struct C <: AbstractC

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                
c = C("outer", T(1, C("inner", T(11, 12, 13)), 2))
t = astuple(c)
assertEqual(self, t, ("outer", T(1, ("inner", (11, 12, 13)), 2)))
t = astuple(c, tuple_factory = list)
assertEqual(self, t, ["outer", T(1, ["inner", T(11, 12, 13)], 2)])
end

function test_dynamic_class_creation(self)
cls_dict = Dict("__annotations__" => Dict("x" => int, "y" => int))
cls = type_("C", (), cls_dict)
cls1 = dataclass(cls)
@test (cls1 == cls)
@test (asdict(cls(1, 2)) == Dict("x" => 1, "y" => 2))
end

function test_dynamic_class_creation_using_field(self)
cls_dict = Dict("__annotations__" => Dict("x" => int, "y" => int), "y" => field(default = 5))
cls = type_("C", (), cls_dict)
cls1 = dataclass(cls)
@test (cls1 == cls)
@test (asdict(cls1(1)) == Dict("x" => 1, "y" => 5))
end

function test_init_in_order(self)
mutable struct C <: AbstractC

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                
calls = []
function setattr(self, name, value)
push!(calls, (name, value))
end

C.__setattr__ = setattr
c = C(0, 1)
assertEqual(self, ("a", 0), calls[1])
assertEqual(self, ("b", 1), calls[2])
assertEqual(self, ("c", []), calls[3])
assertEqual(self, ("d", []), calls[4])
assertNotIn(self, ("e", 4), calls)
assertEqual(self, ("f", 4), calls[5])
end

function test_items_in_dicts(self)
mutable struct C <: AbstractC

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                
c = C(0)
assertNotIn(self, "a", C.__dict__)
assertNotIn(self, "b", C.__dict__)
assertNotIn(self, "c", C.__dict__)
assertIn(self, "d", C.__dict__)
assertEqual(self, C.d, 4)
assertIn(self, "e", C.__dict__)
assertEqual(self, C.e, 0)
assertIn(self, "a", c.__dict__)
assertEqual(self, c.a, 0)
assertIn(self, "b", c.__dict__)
assertEqual(self, c.b, [])
assertIn(self, "c", c.__dict__)
assertEqual(self, c.c, [])
assertNotIn(self, "d", c.__dict__)
assertIn(self, "e", c.__dict__)
assertEqual(self, c.e, 0)
end

function test_alternate_classmethod_constructor(self)
mutable struct C <: AbstractC

end
function from_file(cls, filename)
value_in_file = 20
return cls(value_in_file)
end


                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                
assertEqual(self, C.from_file("filename").x, 20)
end

function test_field_metadata_default(self)
mutable struct C <: AbstractC

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                
assertFalse(self, fields(C)[1].metadata)
assertEqual(self, length(fields(C)[1].metadata), 0)
assertRaisesRegex(self, TypeError, "does not support item assignment") do 
fields(C)[1].metadata["test"] = 3
end
end

function test_field_metadata_mapping(self)
assertRaises(self, TypeError) do 
mutable struct C <: AbstractC

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                
end
d = Dict()
mutable struct C <: AbstractC

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                
assertFalse(self, fields(C)[1].metadata)
assertEqual(self, length(fields(C)[1].metadata), 0)
d["foo"] = 1
assertEqual(self, length(fields(C)[1].metadata), 1)
assertEqual(self, fields(C)[1].metadata["foo"], 1)
assertRaisesRegex(self, TypeError, "does not support item assignment") do 
fields(C)[1].metadata["test"] = 3
end
d = Dict("test" => 10, "bar" => "42", 3 => "three")
mutable struct C <: AbstractC

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                
assertEqual(self, length(fields(C)[1].metadata), 3)
assertEqual(self, fields(C)[1].metadata["test"], 10)
assertEqual(self, fields(C)[1].metadata["bar"], "42")
assertEqual(self, fields(C)[1].metadata[4], "three")
d["foo"] = 1
assertEqual(self, length(fields(C)[1].metadata), 4)
assertEqual(self, fields(C)[1].metadata["foo"], 1)
assertRaises(self, KeyError) do 
fields(C)[1].metadata["baz"]
end
assertRaisesRegex(self, TypeError, "does not support item assignment") do 
fields(C)[1].metadata["test"] = 3
end
end

function test_field_metadata_custom_mapping(self)
mutable struct SimpleNameSpace <: AbstractSimpleNameSpace


            SimpleNameSpace() = begin
                __dict__.update(kw)
                new()
            end
end
function __getitem__(self, item)::String
if item == "xyzzy"
return "plugh"
end
return getfield(self, :item)
end

function __len__(self)
return __len__(self.__dict__)
end

mutable struct C <: AbstractC

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                
assertEqual(self, length(fields(C)[1].metadata), 1)
assertEqual(self, fields(C)[1].metadata["a"], 10)
assertRaises(self, AttributeError) do 
fields(C)[1].metadata["b"]
end
assertEqual(self, fields(C)[1].metadata["xyzzy"], "plugh")
end

function test_generic_dataclasses(self)
T = TypeVar("T")
mutable struct LabeledBox <: AbstractLabeledBox

end

                function __repr__(self::AbstractLabeledBox)::String 
                    return AbstractLabeledBox() 
                end
            

                function __eq__(self::AbstractLabeledBox, other::AbstractLabeledBox)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractLabeledBox)
                    ()
                end
                
box = LabeledBox(42)
assertEqual(self, box.content, 42)
assertEqual(self, box.label, "<unknown>")
Alias = List[LabeledBox[int + 1] + 1]
end

function test_generic_extending(self)
S = TypeVar("S")
T = TypeVar("T")
mutable struct Base <: AbstractBase

end

                function __repr__(self::AbstractBase)::String 
                    return AbstractBase() 
                end
            

                function __eq__(self::AbstractBase, other::AbstractBase)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractBase)
                    ()
                end
                
mutable struct DataDerived <: AbstractDataDerived

end

                function __repr__(self::AbstractDataDerived)::String 
                    return AbstractDataDerived() 
                end
            

                function __eq__(self::AbstractDataDerived, other::AbstractDataDerived)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractDataDerived)
                    ()
                end
                
Alias = DataDerived[str + 1]
c = Alias(0, "test1", "test2")
assertEqual(self, astuple(c), (0, "test1", "test2"))
mutable struct NonDataDerived <: AbstractNonDataDerived
y::AbstractAny
end
function new_method(self)
return self.y
end

Alias = NonDataDerived[float + 1]
c = Alias(10, 1.0)
assertEqual(self, new_method(c), 1.0)
end

function test_generic_dynamic(self)
T = TypeVar("T")
mutable struct Parent <: AbstractParent

end

                function __repr__(self::AbstractParent)::String 
                    return AbstractParent() 
                end
            

                function __eq__(self::AbstractParent, other::AbstractParent)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractParent)
                    ()
                end
                
Child = make_dataclass("Child", [("y", T), ("z", Optional[__add__(T, 1)], nothing)], bases = (Parent[int + 1], Generic[__add__(T, 1)]), namespace = Dict("other" => 42))
assertIs(self, Child[int + 1](1, 2).z, nothing)
assertEqual(self, Child[int + 1](1, 2, 3).z, 3)
assertEqual(self, Child[int + 1](1, 2, 3).other, 42)
Alias = Child[__add__(T, 1)]
assertEqual(self, Alias[int + 1](1, 2).x, 1)
assertEqual(self, Child.__mro__, (Child, Parent, Generic, object))
end

function test_dataclasses_pickleable(self)
global P, Q, R
mutable struct P <: AbstractP

end

                function __repr__(self::AbstractP)::String 
                    return AbstractP() 
                end
            

                function __eq__(self::AbstractP, other::AbstractP)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractP)
                    ()
                end
                
mutable struct Q <: AbstractQ

end

                function __repr__(self::AbstractQ)::String 
                    return AbstractQ() 
                end
            

                function __eq__(self::AbstractQ, other::AbstractQ)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractQ)
                    ()
                end
                
mutable struct R <: AbstractR

end

                function __repr__(self::AbstractR)::String 
                    return AbstractR() 
                end
            

                function __eq__(self::AbstractR, other::AbstractR)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractR)
                    ()
                end
                
q = Q(1)
q.y = 2
samples = [P(1), P(1, 2), Q(1), q, R(1), R(1, [2, 3, 4])]
for sample in samples
for proto in 0:pickle.HIGHEST_PROTOCOL
subTest(self, sample = sample, proto = proto) do 
new_sample = loads(dumps(sample, proto))
assertEqual(self, sample.x, new_sample.x)
assertEqual(self, sample.y, new_sample.y)
assertIsNot(self, sample, new_sample)
new_sample.x = 42
another_new_sample = loads(dumps(new_sample, proto))
assertEqual(self, new_sample.x, another_new_sample.x)
assertEqual(self, sample.y, another_new_sample.y)
end
end
end
end

function test_dataclasses_qualnames(self)
mutable struct A <: AbstractA
x::Int64
y::Int64
end

                function __repr__(self::AbstractA)::String 
                    return AbstractA(self.x, self.y) 
                end
            

                function __eq__(self::AbstractA, other::AbstractA)::Bool
                    return __key(self) == __key(other)
                end
            

                function __lt__(self::AbstractA, other::AbstractA)::Bool
                    return __key(self) < __key(other)
                end

                function __le__(self::AbstractA, other::AbstractA)::Bool
                    return __key(self) <= __key(other)
                end

                function __gt__(self::AbstractA, other::AbstractA)::Bool
                    return __key(self) > __key(other)
                end

                function __ge__(self::AbstractA, other::AbstractA)::Bool
                    return __key(self) >= __key(other)
                end
            

                function __hash__(self::AbstractA)
                    return __key(self)
                end
                

                function __key(self::AbstractA)
                    (self.x, self.y)
                end
                
assertEqual(self, A.__init__.__name__, "__init__")
for function_ in ("__eq__", "__lt__", "__le__", "__gt__", "__ge__", "__hash__", "__init__", "__repr__", "__setattr__", "__delattr__")
assertEqual(self, getfield(A, :function_).__qualname__, "TestCase.test_dataclasses_qualnames.<locals>.A.$(function_)")
end
assertRaisesRegex(self, TypeError, "A\\.__init__\\(\\) missing") do 
A()
end
end

mutable struct TestFieldNoAnnotation <: AbstractTestFieldNoAnnotation
f::Int64
end
function test_field_without_annotation(self)
assertRaisesRegex(self, TypeError, "\'f\' is a field but has no type annotation") do 
mutable struct C <: AbstractC

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                
end
end

function test_field_without_annotation_but_annotation_in_base(self)
mutable struct B <: AbstractB

end

                function __repr__(self::AbstractB)::String 
                    return AbstractB() 
                end
            

                function __eq__(self::AbstractB, other::AbstractB)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractB)
                    ()
                end
                
assertRaisesRegex(self, TypeError, "\'f\' is a field but has no type annotation") do 
mutable struct C <: AbstractC

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                
end
end

function test_field_without_annotation_but_annotation_in_base_not_dataclass(self)
mutable struct B <: AbstractB
f::Int64
end

assertRaisesRegex(self, TypeError, "\'f\' is a field but has no type annotation") do 
mutable struct C <: AbstractC

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                
end
end

mutable struct TestDocString <: AbstractTestDocString
x::Int64
y::Int64
z::String
end
function assertDocStrEqual(self, a, b)
@test (replace(a, " ", "") == replace(b, " ", ""))
end

function test_existing_docstring_not_overridden(self)
mutable struct C <: AbstractC

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                
assertEqual(self, C.__doc__, "Lorem ipsum")
end

function test_docstring_no_fields(self)
mutable struct C <: AbstractC

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                
assertDocStrEqual(self, C.__doc__, "C()")
end

function test_docstring_one_field(self)
mutable struct C <: AbstractC

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                
assertDocStrEqual(self, C.__doc__, "C(x:int)")
end

function test_docstring_two_fields(self)
mutable struct C <: AbstractC

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                
assertDocStrEqual(self, C.__doc__, "C(x:int, y:int)")
end

function test_docstring_three_fields(self)
mutable struct C <: AbstractC

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                
assertDocStrEqual(self, C.__doc__, "C(x:int, y:int, z:str)")
end

function test_docstring_one_field_with_default(self)
mutable struct C <: AbstractC

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                
assertDocStrEqual(self, C.__doc__, "C(x:int=3)")
end

function test_docstring_one_field_with_default_none(self)
mutable struct C <: AbstractC

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                
assertDocStrEqual(self, C.__doc__, "C(x:Optional[int]=None)")
end

function test_docstring_list_field(self)
mutable struct C <: AbstractC

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                
assertDocStrEqual(self, C.__doc__, "C(x:List[int])")
end

function test_docstring_list_field_with_default_factory(self)
mutable struct C <: AbstractC

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                
assertDocStrEqual(self, C.__doc__, "C(x:List[int]=<factory>)")
end

function test_docstring_deque_field(self)
mutable struct C <: AbstractC

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                
assertDocStrEqual(self, C.__doc__, "C(x:collections.deque)")
end

function test_docstring_deque_field_with_default_factory(self)
mutable struct C <: AbstractC

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                
assertDocStrEqual(self, C.__doc__, "C(x:collections.deque=<factory>)")
end

mutable struct TestInit <: AbstractTestInit
a::Int64
z::Int64
i::Int64
x::Int64

                    TestInit(a::Int64, z::Int64, i::Int64 = 0, x::Int64 = 0) =
                        new(a, z, i, x)
end
function test_base_has_init(self)
mutable struct B <: AbstractB
z::Int64

            B() = begin
                #= pass =#
                new()
            end
end

mutable struct C <: AbstractC

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                
c = C(10)
assertEqual(self, c.x, 10)
assertNotIn(self, "z", vars(c))
mutable struct C <: AbstractC
x::Int64

                    C(x::Int64 = 10) =
                        new(x)
end

                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.x) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.x)
                end
                
c = C()
assertEqual(self, c.x, 10)
assertEqual(self, c.z, 100)
end

function test_no_init(self)
dataclass(init = false)
mutable struct C <: AbstractC
i::Int64

                    C(i::Int64 = 0) =
                        new(i)
end

assertEqual(self, C().i, 0)
dataclass(init = false)
mutable struct C <: AbstractC
i::Int64
end

assertEqual(self, C().i, 3)
end

function test_overwriting_init(self)
mutable struct C <: AbstractC

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                
assertEqual(self, C(3).x, 6)
mutable struct C <: AbstractC
x::AbstractAny
end

                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.x) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (__key(self.x))
                end
                
assertEqual(self, C(4).x, 8)
mutable struct C <: AbstractC
x::AbstractAny
end

                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.x) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (__key(self.x))
                end
                
assertEqual(self, C(5).x, 10)
end

function test_inherit_from_protocol(self)
mutable struct P <: AbstractP
a::Int64
end

mutable struct C <: AbstractC

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                
assertEqual(self, C(5).a, 5)
mutable struct D <: AbstractD

end

                function __repr__(self::AbstractD)::String 
                    return AbstractD() 
                end
            

                function __eq__(self::AbstractD, other::AbstractD)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractD)
                    ()
                end
                
assertEqual(self, D(5).a, 10)
end

mutable struct TestRepr <: AbstractTestRepr
x::Int64
y::Int64

                    TestRepr(x::Int64, y::Int64 = 10) =
                        new(x, y)
end
function test_repr(self)
mutable struct B <: AbstractB

end

                function __repr__(self::AbstractB)::String 
                    return AbstractB() 
                end
            

                function __eq__(self::AbstractB, other::AbstractB)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractB)
                    ()
                end
                
mutable struct C <: AbstractC

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                
o = C(4)
assertEqual(self, repr(o), "TestRepr.test_repr.<locals>.C(x=4, y=10)")
mutable struct D <: AbstractD

end

                function __repr__(self::AbstractD)::String 
                    return AbstractD() 
                end
            

                function __eq__(self::AbstractD, other::AbstractD)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractD)
                    ()
                end
                
assertEqual(self, repr(D()), "TestRepr.test_repr.<locals>.D(x=20, y=10)")
mutable struct C <: AbstractC

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                
assertEqual(self, repr(C.D(0)), "TestRepr.test_repr.<locals>.C.D(i=0)")
assertEqual(self, repr(C.E()), "TestRepr.test_repr.<locals>.C.E()")
end

function test_no_repr(self)
mutable struct C <: AbstractC
x::Int64
end

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.x)
                end
                
assertIn(self, "$(__name__).TestRepr.test_no_repr.<locals>.C object at", repr(C(3)))
mutable struct C <: AbstractC
x::Int64
end
function __repr__(self)::String
return "C-class"
end


                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.x)
                end
                
assertEqual(self, repr(C(3)), "C-class")
end

function test_overwriting_repr(self)
mutable struct C <: AbstractC

end
function __repr__(self)::String
return "x"
end


                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                
assertEqual(self, repr(C(0)), "x")
mutable struct C <: AbstractC
x::Int64
end
function __repr__(self)::String
return "x"
end


                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.x) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.x)
                end
                
assertEqual(self, repr(C(0)), "x")
mutable struct C <: AbstractC
x::Int64
end
function __repr__(self)::String
return "x"
end


                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.x)
                end
                
assertEqual(self, repr(C(0)), "x")
end

mutable struct TestEq <: AbstractTestEq
x::Int64
end
function test_no_eq(self)
mutable struct C <: AbstractC
x::Int64
end

                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.x) 
                end
            

                function __key(self::AbstractC)
                    (self.x)
                end
                
assertNotEqual(self, C(0), C(0))
c = C(3)
assertEqual(self, c, c)
mutable struct C <: AbstractC
x::Int64
end
function __eq__(self, other)::Bool
return other == 10
end


                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.x) 
                end
            

                function __key(self::AbstractC)
                    (self.x)
                end
                
assertEqual(self, C(3), 10)
end

function test_overwriting_eq(self)
mutable struct C <: AbstractC

end
function __eq__(self, other)::Bool
return other == 3
end


                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                
assertEqual(self, C(1), 3)
assertNotEqual(self, C(1), 1)
mutable struct C <: AbstractC
x::Int64
end
function __eq__(self, other)::Bool
return other == 4
end


                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.x) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.x)
                end
                
assertEqual(self, C(1), 4)
assertNotEqual(self, C(1), 1)
mutable struct C <: AbstractC
x::Int64
end
function __eq__(self, other)::Bool
return other == 5
end


                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.x) 
                end
            

                function __key(self::AbstractC)
                    (self.x)
                end
                
assertEqual(self, C(1), 5)
assertNotEqual(self, C(1), 1)
end

mutable struct TestOrdering <: AbstractTestOrdering
x::Int64
end
function test_functools_total_ordering(self)
mutable struct C <: AbstractC

end
function __lt__(self, other)::Bool
return self.x >= other
end


                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                
assertLess(self, C(0), -1)
assertLessEqual(self, C(0), -1)
assertGreater(self, C(0), 1)
assertGreaterEqual(self, C(0), 1)
end

function test_no_order(self)
mutable struct C <: AbstractC
x::Int64
end

                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.x) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.x)
                end
                
assertNotIn(self, "__le__", C.__dict__)
assertNotIn(self, "__lt__", C.__dict__)
assertNotIn(self, "__ge__", C.__dict__)
assertNotIn(self, "__gt__", C.__dict__)
mutable struct C <: AbstractC
x::Int64
end
function __lt__(self, other)::Bool
return false
end


                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.x) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.x)
                end
                
assertNotIn(self, "__le__", C.__dict__)
assertNotIn(self, "__ge__", C.__dict__)
assertNotIn(self, "__gt__", C.__dict__)
end

function test_overwriting_order(self)
assertRaisesRegex(self, TypeError, "Cannot overwrite attribute __lt__.*using functools.total_ordering") do 
mutable struct C <: AbstractC
x::Int64
end
function __lt__(self)
#= pass =#
end


                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.x) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __lt__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) < __key(other)
                end

                function __le__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) <= __key(other)
                end

                function __gt__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) > __key(other)
                end

                function __ge__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) >= __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.x)
                end
                
end
assertRaisesRegex(self, TypeError, "Cannot overwrite attribute __le__.*using functools.total_ordering") do 
mutable struct C <: AbstractC
x::Int64
end
function __le__(self)
#= pass =#
end


                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.x) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __lt__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) < __key(other)
                end

                function __le__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) <= __key(other)
                end

                function __gt__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) > __key(other)
                end

                function __ge__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) >= __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.x)
                end
                
end
assertRaisesRegex(self, TypeError, "Cannot overwrite attribute __gt__.*using functools.total_ordering") do 
mutable struct C <: AbstractC
x::Int64
end
function __gt__(self)
#= pass =#
end


                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.x) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __lt__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) < __key(other)
                end

                function __le__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) <= __key(other)
                end

                function __gt__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) > __key(other)
                end

                function __ge__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) >= __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.x)
                end
                
end
assertRaisesRegex(self, TypeError, "Cannot overwrite attribute __ge__.*using functools.total_ordering") do 
mutable struct C <: AbstractC
x::Int64
end
function __ge__(self)
#= pass =#
end


                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.x) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __lt__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) < __key(other)
                end

                function __le__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) <= __key(other)
                end

                function __gt__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) > __key(other)
                end

                function __ge__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) >= __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.x)
                end
                
end
end

mutable struct TestHash <: AbstractTestHash
x::Int64
y::String
i::Int64
end
function test_unsafe_hash(self)
mutable struct C <: AbstractC
x::Int64
y::String
end

                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.x, self.y) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __hash__(self::AbstractC)
                    return __key(self)
                end
                

                function __key(self::AbstractC)
                    (self.x, self.y)
                end
                
assertEqual(self, hash(C(1, "foo")), hash((1, "foo")))
end

function test_hash_rules(self)
function non_bool(value)::Int64
if value === nothing
return nothing
end
if value
return (3,)
end
return 0
end

function test(case, unsafe_hash, eq, frozen, with_hash, result)
subTest(self, case = case, unsafe_hash = unsafe_hash, eq = eq, frozen = frozen) do 
if result != "exception"
if with_hash
mutable struct C <: AbstractC

end
function __hash__(self)::Int64
return 0
end


                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __hash__(self::AbstractC)
                    return __key(self)
                end
                

                function __key(self::AbstractC)
                    ()
                end
                
else
mutable struct C <: AbstractC

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __hash__(self::AbstractC)
                    return __key(self)
                end
                

                function __key(self::AbstractC)
                    ()
                end
                
end
end
if result == "fn"
assertIn(self, "__hash__", C.__dict__)
assertIsNotNone(self, C.__dict__["__hash__"])
elseif result == ""
if !(with_hash)
assertNotIn(self, "__hash__", C.__dict__)
end
elseif result == "none"
assertIn(self, "__hash__", C.__dict__)
assertIsNone(self, C.__dict__["__hash__"])
elseif result == "exception"
@assert(with_hash)
assertRaisesRegex(self, TypeError, "Cannot overwrite attribute __hash__") do 
mutable struct C <: AbstractC

end
function __hash__(self)::Int64
return 0
end


                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __hash__(self::AbstractC)
                    return __key(self)
                end
                

                function __key(self::AbstractC)
                    ()
                end
                
end
else
@assert(false)
end
end
end

for (case, (unsafe_hash, eq, frozen, res_no_defined_hash, res_defined_hash)) in enumerate([(false, false, false, "", ""), (false, false, true, "", ""), (false, true, false, "none", ""), (false, true, true, "fn", ""), (true, false, false, "fn", "exception"), (true, false, true, "fn", "exception"), (true, true, false, "fn", "exception"), (true, true, true, "fn", "exception")])
test(case, unsafe_hash, eq, frozen, false, res_no_defined_hash)
test(case, unsafe_hash, eq, frozen, true, res_defined_hash)
test(case, non_bool(unsafe_hash), non_bool(eq), non_bool(frozen), false, res_no_defined_hash)
test(case, non_bool(unsafe_hash), non_bool(eq), non_bool(frozen), true, res_defined_hash)
end
end

function test_eq_only(self)
mutable struct C <: AbstractC

end
function __eq__(self, other)::Bool
return self.i == other.i
end


                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                
assertEqual(self, C(1), C(1))
assertNotEqual(self, C(1), C(4))
mutable struct C <: AbstractC
i::Int64
end
function __eq__(self, other)::Bool
return self.i == other.i
end


                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.i) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __hash__(self::AbstractC)
                    return __key(self)
                end
                

                function __key(self::AbstractC)
                    (self.i)
                end
                
assertEqual(self, C(1), C(1.0))
assertEqual(self, hash(C(1)), hash(C(1.0)))
mutable struct C <: AbstractC
i::Int64
end
function __eq__(self, other)
return self.i == 3 && self.i == other.i
end


                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.i) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __hash__(self::AbstractC)
                    return __key(self)
                end
                

                function __key(self::AbstractC)
                    (self.i)
                end
                
assertEqual(self, C(3), C(3))
assertNotEqual(self, C(1), C(1))
assertEqual(self, hash(C(1)), hash(C(1.0)))
end

function test_0_field_hash(self)
mutable struct C <: AbstractC

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                
assertEqual(self, hash(C()), hash(()))
mutable struct C <: AbstractC

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __hash__(self::AbstractC)
                    return __key(self)
                end
                

                function __key(self::AbstractC)
                    ()
                end
                
assertEqual(self, hash(C()), hash(()))
end

function test_1_field_hash(self)
mutable struct C <: AbstractC
x::Int64
end

                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.x) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.x)
                end
                
assertEqual(self, hash(C(4)), hash((4,)))
assertEqual(self, hash(C(42)), hash((42,)))
mutable struct C <: AbstractC
x::Int64
end

                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.x) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __hash__(self::AbstractC)
                    return __key(self)
                end
                

                function __key(self::AbstractC)
                    (self.x)
                end
                
assertEqual(self, hash(C(4)), hash((4,)))
assertEqual(self, hash(C(42)), hash((42,)))
end

function test_hash_no_args(self)
mutable struct Base <: AbstractBase

end
function __hash__(self)::Int64
return 301
end

for (frozen, eq, base, expected) in [(nothing, nothing, object, "unhashable"), (nothing, nothing, Base, "unhashable"), (nothing, false, object, "object"), (nothing, false, Base, "base"), (nothing, true, object, "unhashable"), (nothing, true, Base, "unhashable"), (false, nothing, object, "unhashable"), (false, nothing, Base, "unhashable"), (false, false, object, "object"), (false, false, Base, "base"), (false, true, object, "unhashable"), (false, true, Base, "unhashable"), (true, nothing, object, "tuple"), (true, nothing, Base, "tuple"), (true, false, object, "object"), (true, false, Base, "base"), (true, true, object, "tuple"), (true, true, Base, "tuple")]
subTest(self, frozen = frozen, eq = eq, base = base, expected = expected) do 
if frozen === nothing && eq === nothing
mutable struct C <: AbstractC

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                
elseif frozen === nothing
mutable struct C <: AbstractC
i::Int64
end

                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.i) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.i)
                end
                
elseif eq === nothing
mutable struct C <: AbstractC
i::Int64
end

                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.i) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.i)
                end
                
else
mutable struct C <: AbstractC
i::Int64
end

                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.i) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.i)
                end
                
end
if expected == "unhashable"
c = C(10)
assertRaisesRegex(self, TypeError, "unhashable type") do 
hash(c)
end
elseif expected == "base"
assertEqual(self, hash(C(10)), 301)
elseif expected == "object"
assertIs(self, C.__hash__, object.__hash__)
elseif expected == "tuple"
assertEqual(self, hash(C(42)), hash((42,)))
else
@assert(false)
end
end
end
end

mutable struct TestFrozen <: AbstractTestFrozen
i::Int64
j::Int64
x::Int64
y::Int64

                    TestFrozen(i::Int64, j::Int64, x::Int64, y::Int64 = 10) =
                        new(i, j, x, y)
end
function test_frozen(self)
mutable struct C <: AbstractC
i::Int64
end

                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.i) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.i)
                end
                
c = C(10)
assertEqual(self, c.i, 10)
assertRaises(self, FrozenInstanceError) do 
c.i = 5
end
assertEqual(self, c.i, 10)
end

function test_inherit(self)
mutable struct C <: AbstractC
i::Int64
end

                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.i) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.i)
                end
                
mutable struct D <: AbstractD
j::Int64
end

                function __repr__(self::AbstractD)::String 
                    return AbstractD(self.j) 
                end
            

                function __eq__(self::AbstractD, other::AbstractD)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractD)
                    (self.j)
                end
                
d = D(0, 10)
assertRaises(self, FrozenInstanceError) do 
d.i = 5
end
assertRaises(self, FrozenInstanceError) do 
d.j = 6
end
assertEqual(self, d.i, 0)
assertEqual(self, d.j, 10)
end

function test_inherit_nonfrozen_from_empty_frozen(self)
mutable struct C <: AbstractC

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                
assertRaisesRegex(self, TypeError, "cannot inherit non-frozen dataclass from a frozen one") do 
mutable struct D <: AbstractD

end

                function __repr__(self::AbstractD)::String 
                    return AbstractD() 
                end
            

                function __eq__(self::AbstractD, other::AbstractD)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractD)
                    ()
                end
                
end
end

function test_inherit_nonfrozen_from_empty(self)
mutable struct C <: AbstractC

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                
mutable struct D <: AbstractD

end

                function __repr__(self::AbstractD)::String 
                    return AbstractD() 
                end
            

                function __eq__(self::AbstractD, other::AbstractD)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractD)
                    ()
                end
                
d = D(3)
assertEqual(self, d.j, 3)
assertIsInstance(self, d, C)
end

function test_inherit_nonfrozen_from_frozen(self)
for intermediate_class in [true, false]
subTest(self, intermediate_class = intermediate_class) do 
mutable struct C <: AbstractC
i::Int64
end

                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.i) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.i)
                end
                
if intermediate_class
mutable struct I <: AbstractI

end

else
I = C
end
assertRaisesRegex(self, TypeError, "cannot inherit non-frozen dataclass from a frozen one") do 
mutable struct D <: AbstractD

end

                function __repr__(self::AbstractD)::String 
                    return AbstractD() 
                end
            

                function __eq__(self::AbstractD, other::AbstractD)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractD)
                    ()
                end
                
end
end
end
end

function test_inherit_frozen_from_nonfrozen(self)
for intermediate_class in [true, false]
subTest(self, intermediate_class = intermediate_class) do 
mutable struct C <: AbstractC

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                
if intermediate_class
mutable struct I <: AbstractI

end

else
I = C
end
assertRaisesRegex(self, TypeError, "cannot inherit frozen dataclass from a non-frozen one") do 
mutable struct D <: AbstractD

end

                function __repr__(self::AbstractD)::String 
                    return AbstractD() 
                end
            

                function __eq__(self::AbstractD, other::AbstractD)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractD)
                    ()
                end
                
end
end
end
end

function test_inherit_from_normal_class(self)
for intermediate_class in [true, false]
subTest(self, intermediate_class = intermediate_class) do 
mutable struct C <: AbstractC

end

if intermediate_class
mutable struct I <: AbstractI

end

else
I = C
end
mutable struct D <: AbstractD
i::Int64
end

                function __repr__(self::AbstractD)::String 
                    return AbstractD(self.i) 
                end
            

                function __eq__(self::AbstractD, other::AbstractD)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractD)
                    (self.i)
                end
                
end
d = D(10)
assertRaises(self, FrozenInstanceError) do 
d.i = 5
end
end
end

function test_non_frozen_normal_derived(self)
mutable struct D <: AbstractD
x::Int64
y::Int64

                    D(x::Int64, y::Int64 = 10) =
                        new(x, y)
end

                function __repr__(self::AbstractD)::String 
                    return AbstractD(self.x, self.y) 
                end
            

                function __eq__(self::AbstractD, other::AbstractD)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractD)
                    (self.x, self.y)
                end
                
mutable struct S <: AbstractS

end

s = S(3)
assertEqual(self, s.x, 3)
assertEqual(self, s.y, 10)
s.cached = true
assertRaises(self, FrozenInstanceError) do 
s.x = 5
end
assertRaises(self, FrozenInstanceError) do 
s.y = 5
end
assertEqual(self, s.x, 3)
assertEqual(self, s.y, 10)
assertEqual(self, s.cached, true)
end

function test_overwriting_frozen(self)
assertRaisesRegex(self, TypeError, "Cannot overwrite attribute __setattr__") do 
mutable struct C <: AbstractC
x::Int64
end
function __setattr__(self)
#= pass =#
end


                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.x) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.x)
                end
                
end
assertRaisesRegex(self, TypeError, "Cannot overwrite attribute __delattr__") do 
mutable struct C <: AbstractC
x::Int64
end
function __delattr__(self)
#= pass =#
end


                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.x) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.x)
                end
                
end
mutable struct C <: AbstractC
x::Int64
end
function __setattr__(self, name, value)
self.__dict__["x"] = value*2
end


                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.x) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.x)
                end
                
assertEqual(self, C(10).x, 20)
end

function test_frozen_hash(self)
mutable struct C <: AbstractC
x::AbstractAny
end

                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.x) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (__key(self.x))
                end
                
hash(C(3))
assertRaisesRegex(self, TypeError, "unhashable type") do 
hash(C(Dict()))
end
end

mutable struct TestSlots <: AbstractTestSlots
FrozenSlotsClass::AbstractAny
a::String
bar::Int64
foo::String
x::AbstractAny
y::Int64
z::Int64
__slots__::Tuple{String}
b::String

                    TestSlots(FrozenSlotsClass::AbstractAny, a::String, bar::Int64, foo::String, x::AbstractAny, y::Int64, z::Int64, __slots__::Tuple{String} = ("x",), b::String = field(default = "b", init = false)) =
                        new(FrozenSlotsClass, a, bar, foo, x, y, z, __slots__, b)
end
function test_simple(self)
mutable struct C <: AbstractC

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                
assertRaisesRegex(self, TypeError, "__init__\\(\\) missing 1 required positional argument: \'x\'") do 
C()
end
c = C(10)
assertEqual(self, c.x, 10)
c.x = 5
assertEqual(self, c.x, 5)
assertRaisesRegex(self, AttributeError, "\'C\' object has no attribute \'y\'") do 
c.y = 5
end
end

function test_derived_added_field(self)
mutable struct Base <: AbstractBase

end

                function __repr__(self::AbstractBase)::String 
                    return AbstractBase() 
                end
            

                function __eq__(self::AbstractBase, other::AbstractBase)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractBase)
                    ()
                end
                
mutable struct Derived <: AbstractDerived

end

                function __repr__(self::AbstractDerived)::String 
                    return AbstractDerived() 
                end
            

                function __eq__(self::AbstractDerived, other::AbstractDerived)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractDerived)
                    ()
                end
                
d = Derived(1, 2)
assertEqual(self, (d.x, d.y), (1, 2))
d.z = 10
end

function test_generated_slots(self)
mutable struct C <: AbstractC
x::Int64
y::Int64
end

                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.x, self.y) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.x, self.y)
                end
                
c = C(1, 2)
assertEqual(self, (c.x, c.y), (1, 2))
c.x = 3
c.y = 4
assertEqual(self, (c.x, c.y), (3, 4))
assertRaisesRegex(self, AttributeError, "\'C\' object has no attribute \'z\'") do 
c.z = 5
end
end

function test_add_slots_when_slots_exists(self)
assertRaisesRegex(self, TypeError, "^C already specifies __slots__\$") do 
mutable struct C <: AbstractC
x::Int64
__slots__::Tuple{String}

                    C(x::Int64, __slots__::Tuple{String} = ("x",)) =
                        new(x, __slots__)
end

                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.x, self.__slots__) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.x, self.__slots__)
                end
                
end
end

function test_generated_slots_value(self)
mutable struct Base <: AbstractBase
x::Int64
end

                function __repr__(self::AbstractBase)::String 
                    return AbstractBase(self.x) 
                end
            

                function __eq__(self::AbstractBase, other::AbstractBase)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractBase)
                    (self.x)
                end
                
assertEqual(self, Base.__slots__, ("x",))
mutable struct Delivered <: AbstractDelivered
y::Int64
end

                function __repr__(self::AbstractDelivered)::String 
                    return AbstractDelivered(self.y) 
                end
            

                function __eq__(self::AbstractDelivered, other::AbstractDelivered)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractDelivered)
                    (self.y)
                end
                
assertEqual(self, Delivered.__slots__, ("x", "y"))
mutable struct AnotherDelivered <: AbstractAnotherDelivered

end

                function __repr__(self::AbstractAnotherDelivered)::String 
                    return AbstractAnotherDelivered() 
                end
            

                function __eq__(self::AbstractAnotherDelivered, other::AbstractAnotherDelivered)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractAnotherDelivered)
                    ()
                end
                
assertTrue(self, "__slots__" ∉ AnotherDelivered.__dict__)
end

function test_returns_new_class(self)
mutable struct A <: AbstractA
x::Int64
end

B = dataclass(A, slots = true)
assertIsNot(self, A, B)
assertFalse(self, hasfield(typeof(A), :__slots__))
assertTrue(self, hasfield(typeof(B), :__slots__))
end

function test_frozen_pickle(self)
@test (self.FrozenSlotsClass.__slots__ == ("foo", "bar"))
for proto in 0:pickle.HIGHEST_PROTOCOL
subTest(self, proto = proto) do 
obj = FrozenSlotsClass(self, "a", 1)
p = loads(dumps(obj, protocol = proto))
assertIsNot(self, obj, p)
@test (obj == p)
obj = FrozenWithoutSlotsClass(self, "a", 1)
p = loads(dumps(obj, protocol = proto))
assertIsNot(self, obj, p)
@test (obj == p)
end
end
end

function test_slots_with_default_no_init(self)
mutable struct A <: AbstractA
a::String
b::String

                    A(a::String, b::String = field(default = "b", init = false)) =
                        new(a, b)
end

                function __repr__(self::AbstractA)::String 
                    return AbstractA(self.a, self.b) 
                end
            

                function __eq__(self::AbstractA, other::AbstractA)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractA)
                    (self.a, self.b)
                end
                
obj = A("a")
assertEqual(self, obj.a, "a")
assertEqual(self, obj.b, "b")
end

function test_slots_with_default_factory_no_init(self)
mutable struct A <: AbstractA
a::String
b::String

                    A(a::String, b::String = field(default_factory = () -> "b", init = false)) =
                        new(a, b)
end

                function __repr__(self::AbstractA)::String 
                    return AbstractA(self.a, self.b) 
                end
            

                function __eq__(self::AbstractA, other::AbstractA)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractA)
                    (self.a, self.b)
                end
                
obj = A("a")
assertEqual(self, obj.a, "a")
assertEqual(self, obj.b, "b")
end

mutable struct TestDescriptors <: AbstractTestDescriptors
name::AbstractAny
c::Int64
i::Int64

                    TestDescriptors(name::AbstractAny, c::Int64 = D(), i::Int64 = field(default = d, init = false)) =
                        new(name, c, i)
end
function test_set_name(self)
mutable struct D <: AbstractD
name::AbstractAny
end
function __set_name__(self, owner, name)
self.name = name + "x"
end

function __get__(self, instance, owner)::Int64
if instance !== nothing
return 1
end
return self
end

mutable struct C <: AbstractC

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                
assertEqual(self, C.c.name, "cx")
mutable struct C <: AbstractC

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                
assertEqual(self, C.c.name, "cx")
assertEqual(self, C().c, 1)
end

function test_non_descriptor(self)
mutable struct D <: AbstractD
name::AbstractAny
end
function __set_name__(self, owner, name)
self.name = name + "x"
end

mutable struct C <: AbstractC

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                
assertEqual(self, C.c.name, "cx")
end

function test_lookup_on_instance(self)
mutable struct D <: AbstractD

end

d = D()
d.__set_name__ = Mock()
mutable struct C <: AbstractC

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                
assertEqual(self, d.__set_name__.call_count, 0)
end

function test_lookup_on_class(self)
mutable struct D <: AbstractD

end

D.__set_name__ = Mock()
mutable struct C <: AbstractC

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                
assertEqual(self, D.__set_name__.call_count, 1)
end

mutable struct TestStringAnnotations <: AbstractTestStringAnnotations
x::typestr
end
function test_classvar(self)
for typestr in ("ClassVar[int]", "ClassVar [int]", " ClassVar [int]", "ClassVar", " ClassVar ", "typing.ClassVar[int]", "typing.ClassVar[str]", " typing.ClassVar[str]", "typing .ClassVar[str]", "typing. ClassVar[str]", "typing.ClassVar [str]", "typing.ClassVar [ str]", "typing.ClassVar.[int]", "typing.ClassVar+")
subTest(self, typestr = typestr) do 
mutable struct C <: AbstractC

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                
C()
assertNotIn(self, "x", C.__dict__)
end
end
end

function test_isnt_classvar(self)
for typestr in ("CV", "t.ClassVar", "t.ClassVar[int]", "typing..ClassVar[int]", "Classvar", "Classvar[int]", "typing.ClassVarx[int]", "typong.ClassVar[int]", "dataclasses.ClassVar[int]", "typingxClassVar[str]")
subTest(self, typestr = typestr) do 
mutable struct C <: AbstractC

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                
assertEqual(self, C(10).x, 10)
end
end
end

function test_initvar(self)
for typestr in ("InitVar[int]", "InitVar [int] InitVar [int]", "InitVar", " InitVar ", "dataclasses.InitVar[int]", "dataclasses.InitVar[str]", " dataclasses.InitVar[str]", "dataclasses .InitVar[str]", "dataclasses. InitVar[str]", "dataclasses.InitVar [str]", "dataclasses.InitVar [ str]", "dataclasses.InitVar.[int]", "dataclasses.InitVar+")
subTest(self, typestr = typestr) do 
mutable struct C <: AbstractC

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                
assertRaisesRegex(self, AttributeError, "object has no attribute \'x\'") do 
C(1).x
end
end
end
end

function test_isnt_initvar(self)
for typestr in ("IV", "dc.InitVar", "xdataclasses.xInitVar", "typing.xInitVar[int]")
subTest(self, typestr = typestr) do 
mutable struct C <: AbstractC

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                
assertEqual(self, C(10).x, 10)
end
end
end

function test_classvar_module_level_import(self)
for m in (dataclass_module_1, dataclass_module_1_str, dataclass_module_2, dataclass_module_2_str)
subTest(self, m = m) do 
if m.USING_STRINGS
c = CV(m, 10)
else
c = CV(m)
end
@test (c.cv0 == 20)
c = IV(m, 0, 1, 2, 3, 4)
for field_name in ("iv0", "iv1", "iv2", "iv3")
subTest(self, field_name = field_name) do 
assertRaisesRegex(self, AttributeError, "object has no attribute \'$(field_name)\'") do 
getfield(c, :field_name)
end
end
end
if m.USING_STRINGS
assertIn(self, "not_iv4", c.__dict__)
@test (c.not_iv4 == 4)
else
assertNotIn(self, "not_iv4", c.__dict__)
end
end
end
end

function test_text_annotations(self)
@test (get_type_hints(dataclass_textanno.Bar) == Dict("foo" => dataclass_textanno.Foo))
@test (get_type_hints(dataclass_textanno.Bar.__init__) == Dict("foo" => dataclass_textanno.Foo, "return" => type_(nothing)))
end

mutable struct TestMakeDataclass <: AbstractTestMakeDataclass
x::Int64
end
function test_simple(self)
C = make_dataclass("C", [("x", int), ("y", int, field(default = 5))], namespace = Dict("add_one" => (self) -> self.x + 1))
c = C(10)
@test ((c.x, c.y) == (10, 5))
@test (add_one(c) == 11)
end

function test_no_mutate_namespace(self)
ns = Dict()
C = make_dataclass("C", [("x", int), ("y", int, field(default = 5))], namespace = ns)
@test (ns == Dict())
end

function test_base(self)
mutable struct Base1 <: AbstractBase1

end

mutable struct Base2 <: AbstractBase2

end

C = make_dataclass("C", [("x", int)], bases = (Base1, Base2))
c = C(2)
assertIsInstance(self, c, C)
assertIsInstance(self, c, Base1)
assertIsInstance(self, c, Base2)
end

function test_base_dataclass(self)
mutable struct Base1 <: AbstractBase1

end

                function __repr__(self::AbstractBase1)::String 
                    return AbstractBase1() 
                end
            

                function __eq__(self::AbstractBase1, other::AbstractBase1)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractBase1)
                    ()
                end
                
mutable struct Base2 <: AbstractBase2

end

C = make_dataclass("C", [("y", int)], bases = (Base1, Base2))
assertRaisesRegex(self, TypeError, "required positional") do 
c = C(2)
end
c = C(1, 2)
assertIsInstance(self, c, C)
assertIsInstance(self, c, Base1)
assertIsInstance(self, c, Base2)
assertEqual(self, (c.x, c.y), (1, 2))
end

function test_init_var(self)
function post_init(self, y)
self.x *= y
end

C = make_dataclass("C", [("x", int), ("y", InitVar[int + 1])], namespace = Dict("__post_init__" => post_init))
c = C(2, 3)
@test (vars(c) == Dict("x" => 6))
@test (length(fields(c)) == 1)
end

function test_class_var(self)
C = make_dataclass("C", [("x", int), ("y", ClassVar[int + 1], 10), ("z", ClassVar[int + 1], field(default = 20))])
c = C(1)
@test (vars(c) == Dict("x" => 1))
@test (length(fields(c)) == 1)
@test (C.y == 10)
@test (C.z == 20)
end

function test_other_params(self)
C = make_dataclass("C", [("x", int), ("y", ClassVar[int + 1], 10), ("z", ClassVar[int + 1], field(default = 20))], init = false)
assertNotIn(self, "__init__", vars(C))
assertIn(self, "__repr__", vars(C))
assertRaisesRegex(self, TypeError, "unexpected keyword argument") do 
C = make_dataclass("C", [], xxinit = false)
end
end

function test_no_types(self)
C = make_dataclass("Point", ["x", "y", "z"])
c = C(1, 2, 3)
@test (vars(c) == Dict("x" => 1, "y" => 2, "z" => 3))
@test (C.__annotations__ == Dict("x" => "typing.Any", "y" => "typing.Any", "z" => "typing.Any"))
C = make_dataclass("Point", ["x", ("y", int), "z"])
c = C(1, 2, 3)
@test (vars(c) == Dict("x" => 1, "y" => 2, "z" => 3))
@test (C.__annotations__ == Dict("x" => "typing.Any", "y" => int, "z" => "typing.Any"))
end

function test_invalid_type_specification(self)
for bad_field in [(), (1, 2, 3, 4)]
subTest(self, bad_field = bad_field) do 
assertRaisesRegex(self, TypeError, "Invalid field: ") do 
make_dataclass("C", ["a", bad_field])
end
end
end
for bad_field in [float, (x) -> x]
subTest(self, bad_field = bad_field) do 
assertRaisesRegex(self, TypeError, "has no len\\(\\)") do 
make_dataclass("C", ["a", bad_field])
end
end
end
end

function test_duplicate_field_names(self)
for field in ["a", "ab"]
subTest(self, field = field) do 
assertRaisesRegex(self, TypeError, "Field name duplicated") do 
make_dataclass("C", [field, "a", field])
end
end
end
end

function test_keyword_field_names(self)
for field in ["for", "async", "await", "as"]
subTest(self, field = field) do 
assertRaisesRegex(self, TypeError, "must not be keywords") do 
make_dataclass("C", ["a", field])
end
assertRaisesRegex(self, TypeError, "must not be keywords") do 
make_dataclass("C", [field])
end
assertRaisesRegex(self, TypeError, "must not be keywords") do 
make_dataclass("C", [field, "a"])
end
end
end
end

function test_non_identifier_field_names(self)
for field in ["()", "x,y", "*", "2@3", "", "little johnny tables"]
subTest(self, field = field) do 
assertRaisesRegex(self, TypeError, "must be valid identifiers") do 
make_dataclass("C", ["a", field])
end
assertRaisesRegex(self, TypeError, "must be valid identifiers") do 
make_dataclass("C", [field])
end
assertRaisesRegex(self, TypeError, "must be valid identifiers") do 
make_dataclass("C", [field, "a"])
end
end
end
end

function test_underscore_field_names(self)
make_dataclass("C", ["_", "_a", "a_a", "a_"])
end

function test_funny_class_names_names(self)
for classname in ["()", "x,y", "*", "2@3", ""]
subTest(self, classname = classname) do 
C = make_dataclass(classname, ["a", "b"])
@test (C.__name__ == classname)
end
end
end

mutable struct TestReplace <: AbstractTestReplace
f::C
g::C
x::Int64
y::Int64
t::Int64
z::Int64

                    TestReplace(f::C, g::C, x::Int64, y::Int64, t::Int64 = field(init = false, default = 100), z::Int64 = field(init = false, default = 10)) =
                        new(f, g, x, y, t, z)
end
function test(self)
mutable struct C <: AbstractC
x::Int64
y::Int64
end

                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.x, self.y) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.x, self.y)
                end
                
c = C(1, 2)
c1 = replace(c, x = 3)
assertEqual(self, c1.x, 3)
assertEqual(self, c1.y, 2)
end

function test_frozen(self)
mutable struct C <: AbstractC
x::Int64
y::Int64
t::Int64
z::Int64

                    C(x::Int64, y::Int64, t::Int64 = field(init = false, default = 100), z::Int64 = field(init = false, default = 10)) =
                        new(x, y, t, z)
end

                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.x, self.y, self.t, self.z) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.x, self.y, self.t, self.z)
                end
                
c = C(1, 2)
c1 = replace(c, x = 3)
assertEqual(self, (c.x, c.y, c.z, c.t), (1, 2, 10, 100))
assertEqual(self, (c1.x, c1.y, c1.z, c1.t), (3, 2, 10, 100))
assertRaisesRegex(self, ValueError, "init=False") do 
replace(c, x = 3, z = 20, t = 50)
end
assertRaisesRegex(self, ValueError, "init=False") do 
replace(c, z = 20)
replace(c, x = 3, z = 20, t = 50)
end
assertRaisesRegex(self, FrozenInstanceError, "cannot assign to field \'x\'") do 
c1.x = 3
end
assertRaisesRegex(self, TypeError, "__init__\\(\\) got an unexpected keyword argument \'a\'") do 
c1 = replace(c, x = 20, a = 5)
end
end

function test_invalid_field_name(self)
mutable struct C <: AbstractC
x::Int64
y::Int64
end

                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.x, self.y) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.x, self.y)
                end
                
c = C(1, 2)
assertRaisesRegex(self, TypeError, "__init__\\(\\) got an unexpected keyword argument \'z\'") do 
c1 = replace(c, z = 3)
end
end

function test_invalid_object(self)
mutable struct C <: AbstractC
x::Int64
y::Int64
end

                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.x, self.y) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.x, self.y)
                end
                
assertRaisesRegex(self, TypeError, "dataclass instance") do 
replace(C, x = 3)
end
assertRaisesRegex(self, TypeError, "dataclass instance") do 
replace(0, x = 3)
end
end

function test_no_init(self)
mutable struct C <: AbstractC

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                
c = C(1)
c.y = 20
c1 = replace(c, x = 5)
assertEqual(self, (c1.x, c1.y), (5, 10))
assertRaisesRegex(self, ValueError, "init=False") do 
replace(c, x = 2, y = 30)
end
assertRaisesRegex(self, ValueError, "init=False") do 
replace(c, y = 30)
end
end

function test_classvar(self)
mutable struct C <: AbstractC

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                
c = C(1)
d = C(2)
assertIs(self, c.y, d.y)
assertEqual(self, c.y, 1000)
assertRaisesRegex(self, TypeError, "__init__\\(\\) got an unexpected keyword argument \'y\'") do 
replace(c, y = 30)
end
replace(c, x = 5)
end

function test_initvar_is_specified(self)
mutable struct C <: AbstractC

end
function __post_init__(self, y)
self.x *= y
end


                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                
c = C(1, 10)
assertEqual(self, c.x, 10)
assertRaisesRegex(self, ValueError, "InitVar \'y\' must be specified with replace()") do 
replace(c, x = 3)
end
c = replace(c, x = 3, y = 5)
assertEqual(self, c.x, 15)
end

function test_initvar_with_default_value(self)
mutable struct C <: AbstractC

end
function __post_init__(self, y, z)
if y !== nothing
self.x += y
end
if z !== nothing
self.x += z
end
end


                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                
c = C(1, 10, 1)
assertEqual(self, replace(c), C(12))
assertEqual(self, replace(c, y = 4), C(12, 4, 42))
assertEqual(self, replace(c, y = 4, z = 1), C(12, 4, 1))
end

function test_recursive_repr(self)
mutable struct C <: AbstractC

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                
c = C(nothing)
c.f = c
assertEqual(self, repr(c), "TestReplace.test_recursive_repr.<locals>.C(f=...)")
end

function test_recursive_repr_two_attrs(self)
mutable struct C <: AbstractC

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                
c = C(nothing, nothing)
c.f = c
c.g = c
assertEqual(self, repr(c), "TestReplace.test_recursive_repr_two_attrs.<locals>.C(f=..., g=...)")
end

function test_recursive_repr_indirection(self)
mutable struct C <: AbstractC

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                
mutable struct D <: AbstractD

end

                function __repr__(self::AbstractD)::String 
                    return AbstractD() 
                end
            

                function __eq__(self::AbstractD, other::AbstractD)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractD)
                    ()
                end
                
c = C(nothing)
d = D(nothing)
c.f = d
d.f = c
assertEqual(self, repr(c), "TestReplace.test_recursive_repr_indirection.<locals>.C(f=TestReplace.test_recursive_repr_indirection.<locals>.D(f=...))")
end

function test_recursive_repr_indirection_two(self)
mutable struct C <: AbstractC

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                
mutable struct D <: AbstractD

end

                function __repr__(self::AbstractD)::String 
                    return AbstractD() 
                end
            

                function __eq__(self::AbstractD, other::AbstractD)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractD)
                    ()
                end
                
mutable struct E <: AbstractE

end

                function __repr__(self::AbstractE)::String 
                    return AbstractE() 
                end
            

                function __eq__(self::AbstractE, other::AbstractE)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractE)
                    ()
                end
                
c = C(nothing)
d = D(nothing)
e = E(nothing)
c.f = d
d.f = e
e.f = c
assertEqual(self, repr(c), "TestReplace.test_recursive_repr_indirection_two.<locals>.C(f=TestReplace.test_recursive_repr_indirection_two.<locals>.D(f=TestReplace.test_recursive_repr_indirection_two.<locals>.E(f=...)))")
end

function test_recursive_repr_misc_attrs(self)
mutable struct C <: AbstractC

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                
c = C(nothing, 1)
c.f = c
assertEqual(self, repr(c), "TestReplace.test_recursive_repr_misc_attrs.<locals>.C(f=..., g=1)")
end

mutable struct TestAbstract <: AbstractTestAbstract
year::Int64
month::Month
day::int
end
function test_abc_implementation(self)
mutable struct Ordered <: AbstractOrdered

end
function __lt__(self, other)
#= pass =#
end

function __le__(self, other)
#= pass =#
end

mutable struct Date <: AbstractDate
year::Int64
month::Month
day::int
end

                function __repr__(self::AbstractDate)::String 
                    return AbstractDate(self.year, self.month, self.day) 
                end
            

                function __eq__(self::AbstractDate, other::AbstractDate)::Bool
                    return __key(self) == __key(other)
                end
            

                function __lt__(self::AbstractDate, other::AbstractDate)::Bool
                    return __key(self) < __key(other)
                end

                function __le__(self::AbstractDate, other::AbstractDate)::Bool
                    return __key(self) <= __key(other)
                end

                function __gt__(self::AbstractDate, other::AbstractDate)::Bool
                    return __key(self) > __key(other)
                end

                function __ge__(self::AbstractDate, other::AbstractDate)::Bool
                    return __key(self) >= __key(other)
                end
            

                function __key(self::AbstractDate)
                    (self.year, self.month, self.day)
                end
                
assertFalse(self, isabstract(Date))
assertGreater(self, Date(2020, 12, 25), Date(2020, 8, 31))
end

function test_maintain_abc(self)
mutable struct A <: AbstractA

end
function foo(self)
#= pass =#
end

mutable struct Date <: AbstractDate

end

                function __repr__(self::AbstractDate)::String 
                    return AbstractDate() 
                end
            

                function __eq__(self::AbstractDate, other::AbstractDate)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractDate)
                    ()
                end
                
assertTrue(self, isabstract(Date))
msg = "class Date with abstract method foo"
assertRaisesRegex(self, TypeError, msg, Date)
end

mutable struct TestMatchArgs <: AbstractTestMatchArgs
a::Int64
b::Int64
c::Int64
z::Int64
__match_args__::Tuple{String}

                    TestMatchArgs(a::Int64, b::Int64, c::Int64, z::Int64, __match_args__::Tuple{String} = ("b",)) =
                        new(a, b, c, z, __match_args__)
end
function test_match_args(self)
mutable struct C <: AbstractC

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                
assertEqual(self, C(42).__match_args__, ("a",))
end

function test_explicit_match_args(self)
ma = ()
mutable struct C <: AbstractC

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                
assertIs(self, C(42).__match_args__, ma)
end

function test_bpo_43764(self)
mutable struct X <: AbstractX
a::Int64
b::Int64
c::Int64
end

                function __key(self::AbstractX)
                    (self.a, self.b, self.c)
                end
                
assertEqual(self, X.__match_args__, ("a", "b", "c"))
end

function test_match_args_argument(self)
mutable struct X <: AbstractX
a::Int64
end

                function __repr__(self::AbstractX)::String 
                    return AbstractX(self.a) 
                end
            

                function __eq__(self::AbstractX, other::AbstractX)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractX)
                    (self.a)
                end
                
assertNotIn(self, "__match_args__", X.__dict__)
mutable struct Y <: AbstractY
a::Int64
__match_args__::Tuple{String}

                    Y(a::Int64, __match_args__::Tuple{String} = ("b",)) =
                        new(a, __match_args__)
end

                function __repr__(self::AbstractY)::String 
                    return AbstractY(self.a, self.__match_args__) 
                end
            

                function __eq__(self::AbstractY, other::AbstractY)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractY)
                    (self.a, self.__match_args__)
                end
                
assertEqual(self, Y.__match_args__, ("b",))
mutable struct Z <: AbstractZ
z::Int64
end

                function __repr__(self::AbstractZ)::String 
                    return AbstractZ(self.z) 
                end
            

                function __eq__(self::AbstractZ, other::AbstractZ)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractZ)
                    (self.z)
                end
                
assertEqual(self, Z.__match_args__, ("b",))
mutable struct A <: AbstractA

end

                function __repr__(self::AbstractA)::String 
                    return AbstractA() 
                end
            

                function __eq__(self::AbstractA, other::AbstractA)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractA)
                    ()
                end
                
mutable struct B <: AbstractB
b::Int64
end

                function __repr__(self::AbstractB)::String 
                    return AbstractB(self.b) 
                end
            

                function __eq__(self::AbstractB, other::AbstractB)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractB)
                    (self.b)
                end
                
assertEqual(self, B.__match_args__, ("a", "z"))
end

function test_make_dataclasses(self)
C = make_dataclass("C", [("x", int), ("y", int)])
@test (C.__match_args__ == ("x", "y"))
C = make_dataclass("C", [("x", int), ("y", int)], match_args = true)
@test (C.__match_args__ == ("x", "y"))
C = make_dataclass("C", [("x", int), ("y", int)], match_args = false)
assertNotIn(self, "__match__args__", C.__dict__)
C = make_dataclass("C", [("x", int), ("y", int)], namespace = Dict("__match_args__" => ("z",)))
@test (C.__match_args__ == ("z",))
end

mutable struct TestKeywordArgs <: AbstractTestKeywordArgs
X::KW_ONLY
Y::KW_ONLY
_::KW_ONLY
c::Int64
d::Int64
z::Int64
a::ClassVar{Int64}
b::Int64

                    TestKeywordArgs(X::KW_ONLY, Y::KW_ONLY, _::KW_ONLY, c::Int64, d::Int64, z::Int64, a::ClassVar{Int64} = field(kw_only = true), b::Int64 = field(kw_only = true)) =
                        new(X, Y, _, c, d, z, a, b)
end
function test_no_classvar_kwarg(self)
msg = "field a is a ClassVar but specifies kw_only"
assertRaisesRegex(self, TypeError, msg) do 
mutable struct A <: AbstractA

end

                function __repr__(self::AbstractA)::String 
                    return AbstractA() 
                end
            

                function __eq__(self::AbstractA, other::AbstractA)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractA)
                    ()
                end
                
end
assertRaisesRegex(self, TypeError, msg) do 
mutable struct A <: AbstractA

end

                function __repr__(self::AbstractA)::String 
                    return AbstractA() 
                end
            

                function __eq__(self::AbstractA, other::AbstractA)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractA)
                    ()
                end
                
end
assertRaisesRegex(self, TypeError, msg) do 
mutable struct A <: AbstractA
a::ClassVar{Int64}

                    A(a::ClassVar{Int64} = field(kw_only = false)) =
                        new(a)
end

                function __repr__(self::AbstractA)::String 
                    return AbstractA(self.a) 
                end
            

                function __eq__(self::AbstractA, other::AbstractA)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractA)
                    (self.a)
                end
                
end
end

function test_field_marked_as_kwonly(self)
mutable struct A <: AbstractA
a::Int64
end

                function __repr__(self::AbstractA)::String 
                    return AbstractA(self.a) 
                end
            

                function __eq__(self::AbstractA, other::AbstractA)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractA)
                    (self.a)
                end
                
assertTrue(self, fields(A)[1].kw_only)
mutable struct A <: AbstractA
a::Int64

                    A(a::Int64 = field(kw_only = true)) =
                        new(a)
end

                function __repr__(self::AbstractA)::String 
                    return AbstractA(self.a) 
                end
            

                function __eq__(self::AbstractA, other::AbstractA)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractA)
                    (self.a)
                end
                
assertTrue(self, fields(A)[1].kw_only)
mutable struct A <: AbstractA
a::Int64

                    A(a::Int64 = field(kw_only = false)) =
                        new(a)
end

                function __repr__(self::AbstractA)::String 
                    return AbstractA(self.a) 
                end
            

                function __eq__(self::AbstractA, other::AbstractA)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractA)
                    (self.a)
                end
                
assertFalse(self, fields(A)[1].kw_only)
mutable struct A <: AbstractA
a::Int64
end

                function __repr__(self::AbstractA)::String 
                    return AbstractA(self.a) 
                end
            

                function __eq__(self::AbstractA, other::AbstractA)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractA)
                    (self.a)
                end
                
assertFalse(self, fields(A)[1].kw_only)
mutable struct A <: AbstractA
a::Int64

                    A(a::Int64 = field(kw_only = true)) =
                        new(a)
end

                function __repr__(self::AbstractA)::String 
                    return AbstractA(self.a) 
                end
            

                function __eq__(self::AbstractA, other::AbstractA)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractA)
                    (self.a)
                end
                
assertTrue(self, fields(A)[1].kw_only)
mutable struct A <: AbstractA
a::Int64

                    A(a::Int64 = field(kw_only = false)) =
                        new(a)
end

                function __repr__(self::AbstractA)::String 
                    return AbstractA(self.a) 
                end
            

                function __eq__(self::AbstractA, other::AbstractA)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractA)
                    (self.a)
                end
                
assertFalse(self, fields(A)[1].kw_only)
mutable struct A <: AbstractA

end

                function __repr__(self::AbstractA)::String 
                    return AbstractA() 
                end
            

                function __eq__(self::AbstractA, other::AbstractA)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractA)
                    ()
                end
                
assertFalse(self, fields(A)[1].kw_only)
mutable struct A <: AbstractA

end

                function __repr__(self::AbstractA)::String 
                    return AbstractA() 
                end
            

                function __eq__(self::AbstractA, other::AbstractA)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractA)
                    ()
                end
                
assertTrue(self, fields(A)[1].kw_only)
mutable struct A <: AbstractA

end

                function __repr__(self::AbstractA)::String 
                    return AbstractA() 
                end
            

                function __eq__(self::AbstractA, other::AbstractA)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractA)
                    ()
                end
                
assertFalse(self, fields(A)[1].kw_only)
end

function test_match_args(self)
mutable struct C <: AbstractC
a::Int64
end

                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.a) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.a)
                end
                
assertEqual(self, C(42).__match_args__, ())
mutable struct C <: AbstractC

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                
assertEqual(self, C(42, 10).__match_args__, ("a",))
end

function test_KW_ONLY(self)
mutable struct A <: AbstractA

end

                function __repr__(self::AbstractA)::String 
                    return AbstractA() 
                end
            

                function __eq__(self::AbstractA, other::AbstractA)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractA)
                    ()
                end
                
A(3, 5, 4)
msg = "takes 2 positional arguments but 4 were given"
assertRaisesRegex(self, TypeError, msg) do 
A(3, 4, 5)
end
mutable struct B <: AbstractB
a::Int64
_::KW_ONLY
b::Int64
c::Int64
end

                function __repr__(self::AbstractB)::String 
                    return AbstractB(self.a, self._, self.b, self.c) 
                end
            

                function __eq__(self::AbstractB, other::AbstractB)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractB)
                    (self.a, self._, self.b, self.c)
                end
                
B(3, 4, 5)
msg = "takes 1 positional argument but 4 were given"
assertRaisesRegex(self, TypeError, msg) do 
B(3, 4, 5)
end
mutable struct C <: AbstractC

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                
c = C(1, 2, 3)
assertEqual(self, c.a, 1)
assertEqual(self, c.b, 3)
assertEqual(self, c.c, 2)
c = C(1, 3, 2)
assertEqual(self, c.a, 1)
assertEqual(self, c.b, 3)
assertEqual(self, c.c, 2)
c = C(1, 3, 2)
assertEqual(self, c.a, 1)
assertEqual(self, c.b, 3)
assertEqual(self, c.c, 2)
c = C(2, 3, 1)
assertEqual(self, c.a, 1)
assertEqual(self, c.b, 3)
assertEqual(self, c.c, 2)
end

function test_KW_ONLY_as_string(self)
mutable struct A <: AbstractA

end

                function __repr__(self::AbstractA)::String 
                    return AbstractA() 
                end
            

                function __eq__(self::AbstractA, other::AbstractA)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractA)
                    ()
                end
                
A(3, 5, 4)
msg = "takes 2 positional arguments but 4 were given"
assertRaisesRegex(self, TypeError, msg) do 
A(3, 4, 5)
end
end

function test_KW_ONLY_twice(self)
msg = "\'Y\' is KW_ONLY, but KW_ONLY has already been specified"
assertRaisesRegex(self, TypeError, msg) do 
mutable struct A <: AbstractA

end

                function __repr__(self::AbstractA)::String 
                    return AbstractA() 
                end
            

                function __eq__(self::AbstractA, other::AbstractA)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractA)
                    ()
                end
                
end
assertRaisesRegex(self, TypeError, msg) do 
mutable struct A <: AbstractA

end

                function __repr__(self::AbstractA)::String 
                    return AbstractA() 
                end
            

                function __eq__(self::AbstractA, other::AbstractA)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractA)
                    ()
                end
                
end
assertRaisesRegex(self, TypeError, msg) do 
mutable struct A <: AbstractA

end

                function __repr__(self::AbstractA)::String 
                    return AbstractA() 
                end
            

                function __eq__(self::AbstractA, other::AbstractA)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractA)
                    ()
                end
                
end
mutable struct A <: AbstractA

end

                function __repr__(self::AbstractA)::String 
                    return AbstractA() 
                end
            

                function __eq__(self::AbstractA, other::AbstractA)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractA)
                    ()
                end
                
mutable struct A <: AbstractA

end

                function __repr__(self::AbstractA)::String 
                    return AbstractA() 
                end
            

                function __eq__(self::AbstractA, other::AbstractA)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractA)
                    ()
                end
                
mutable struct B <: AbstractB

end

                function __repr__(self::AbstractB)::String 
                    return AbstractB() 
                end
            

                function __eq__(self::AbstractB, other::AbstractB)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractB)
                    ()
                end
                
assertRaisesRegex(self, TypeError, msg) do 
mutable struct A <: AbstractA

end

                function __repr__(self::AbstractA)::String 
                    return AbstractA() 
                end
            

                function __eq__(self::AbstractA, other::AbstractA)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractA)
                    ()
                end
                
mutable struct B <: AbstractB

end

                function __repr__(self::AbstractB)::String 
                    return AbstractB() 
                end
            

                function __eq__(self::AbstractB, other::AbstractB)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractB)
                    ()
                end
                
end
end

function test_post_init(self)
mutable struct A <: AbstractA

end
function __post_init__(self, b, d)
throw(CustomError("b=$('b') d=$('d')"))
end


                function __repr__(self::AbstractA)::String 
                    return AbstractA() 
                end
            

                function __eq__(self::AbstractA, other::AbstractA)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractA)
                    ()
                end
                
assertRaisesRegex(self, CustomError, "b=3 d=4") do 
A(1, 2, 3, 4)
end
mutable struct B <: AbstractB

end
function __post_init__(self, b, d)
self.a = b
self.c = d
end


                function __repr__(self::AbstractB)::String 
                    return AbstractB() 
                end
            

                function __eq__(self::AbstractB, other::AbstractB)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractB)
                    ()
                end
                
b = B(1, 2, 3, 4)
assertEqual(self, asdict(b), Dict("a" => 3, "c" => 4))
end

function test_defaults(self)
mutable struct A <: AbstractA

end

                function __repr__(self::AbstractA)::String 
                    return AbstractA() 
                end
            

                function __eq__(self::AbstractA, other::AbstractA)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractA)
                    ()
                end
                
a = A(4, 3)
assertEqual(self, a.a, 0)
assertEqual(self, a.b, 3)
assertEqual(self, a.c, 1)
assertEqual(self, a.d, 4)
err_regex = "non-default argument \'z\' follows default argument"
assertRaisesRegex(self, TypeError, err_regex) do 
mutable struct A <: AbstractA

end

                function __repr__(self::AbstractA)::String 
                    return AbstractA() 
                end
            

                function __eq__(self::AbstractA, other::AbstractA)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractA)
                    ()
                end
                
end
end

function test_make_dataclass(self)
A = make_dataclass("A", ["a"], kw_only = true)
@test fields(A)[1].kw_only
B = make_dataclass("B", ["a", ("b", int, field(kw_only = false))], kw_only = true)
@test fields(B)[1].kw_only
@test !(fields(B)[2].kw_only)
end

if abspath(PROGRAM_FILE) == @__FILE__
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
assertDocStrEqual(test_doc_string)
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
end