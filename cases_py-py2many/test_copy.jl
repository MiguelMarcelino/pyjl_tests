#= Unit tests for the copy module. =#
using Test
import copy
import copyreg

import abc



abstract type AbstractTestCopy end
abstract type AbstractC <: object end
abstract type AbstractNewStyle <: object end
abstract type AbstractMeta <: type_ end
abstract type AbstractEvilState <: object end
abstract type AbstractFoo <: object end
order_comparisons = (le, lt, ge, gt)
equality_comparisons = (eq, ne)
comparisons = order_comparisons + equality_comparisons
mutable struct TestCopy <: AbstractTestCopy
__dict__
_keys::Vector
foo
i
__slots__::Vector{String}
d

                    TestCopy(__dict__, _keys::Vector, foo, i, __slots__::Vector{String} = ["foo"], d = nothing) =
                        new(__dict__, _keys, foo, i, __slots__, d)
end
function test_exceptions(self)
assertIs(self, copy.Error, copy.error)
@test copy.Error <: Exception
end

function test_copy_basic(self)
x = 42
y = copy(x)
@test (x == y)
end

function test_copy_copy(self)
mutable struct C <: AbstractC
foo
end
function __copy__(self)::C
return C(self.foo)
end

x = C(42)
y = copy(x)
assertEqual(self, y.__class__, x.__class__)
assertEqual(self, y.foo, x.foo)
end

function test_copy_registry(self)
mutable struct C <: AbstractC

end
function __new__(cls, foo)
obj = __new__(object, cls)
obj.foo = foo
return obj
end

function pickle_C(obj)
return (C, (obj.foo,))
end

x = C(42)
assertRaises(self, TypeError, copy.copy, x)
pickle(C, pickle_C, C)
y = copy(x)
end

function test_copy_reduce_ex(self)
mutable struct C <: AbstractC

end
function __reduce_ex__(self, proto)::String
push!(c, 1)
return ""
end

function __reduce__(self)
fail(self, "shouldn\'t call this")
end

c = []
x = C()
y = copy(x)
assertIs(self, y, x)
assertEqual(self, c, [1])
end

function test_copy_reduce(self)
mutable struct C <: AbstractC

end
function __reduce__(self)::String
push!(c, 1)
return ""
end

c = []
x = C()
y = copy(x)
assertIs(self, y, x)
assertEqual(self, c, [1])
end

function test_copy_cant(self)
mutable struct C <: AbstractC

end
function __getattribute__(self, name)
if startswith(name, "__reduce")
throw(AttributeError(name))
end
return __getattribute__(object, self)
end

x = C()
assertRaises(self, copy.Error, copy.copy, x)
end

function test_copy_atomic(self)
mutable struct Classic <: AbstractClassic

end

mutable struct NewStyle <: AbstractNewStyle

end

function f()
#= pass =#
end

mutable struct WithMetaclass <: AbstractWithMetaclass

end

tests = [nothing, ..., NotImplemented, 42, 2^100, 3.14, true, false, 1im, "hello", "helloሴ", f.__code__, b"world", bytes(0:255), 0:9, (1:10), NewStyle, Classic, max, WithMetaclass, property()]
for x in tests
assertIs(self, copy(x), x)
end
end

function test_copy_list(self)
x = [1, 2, 3]
y = copy(x)
@test (y == x)
assertIsNot(self, y, x)
x = []
y = copy(x)
@test (y == x)
assertIsNot(self, y, x)
end

function test_copy_tuple(self)
x = (1, 2, 3)
assertIs(self, copy(x), x)
x = ()
assertIs(self, copy(x), x)
x = (1, 2, 3, [])
assertIs(self, copy(x), x)
end

function test_copy_dict(self)
x = Dict("foo" => 1, "bar" => 2)
y = copy(x)
@test (y == x)
assertIsNot(self, y, x)
x = Dict()
y = copy(x)
@test (y == x)
assertIsNot(self, y, x)
end

function test_copy_set(self)
x = Set([1, 2, 3])
y = copy(x)
@test (y == x)
assertIsNot(self, y, x)
x = set()
y = copy(x)
@test (y == x)
assertIsNot(self, y, x)
end

function test_copy_frozenset(self)
x = frozenset(Set([1, 2, 3]))
assertIs(self, copy(x), x)
x = frozenset()
assertIs(self, copy(x), x)
end

function test_copy_bytearray(self)
x = Vector{UInt8}(b"abc")
y = copy(x)
@test (y == x)
assertIsNot(self, y, x)
x = Vector{UInt8}()
y = copy(x)
@test (y == x)
assertIsNot(self, y, x)
end

function test_copy_inst_vanilla(self)
mutable struct C <: AbstractC
foo
end
function __eq__(self, other)::Bool
return self.foo == other.foo
end

x = C(42)
assertEqual(self, copy(x), x)
end

function test_copy_inst_copy(self)
mutable struct C <: AbstractC
foo
end
function __copy__(self)::C
return C(self.foo)
end

function __eq__(self, other)::Bool
return self.foo == other.foo
end

x = C(42)
assertEqual(self, copy(x), x)
end

function test_copy_inst_getinitargs(self)
mutable struct C <: AbstractC
foo
end
function __getinitargs__(self)::Tuple
return (self.foo,)
end

function __eq__(self, other)::Bool
return self.foo == other.foo
end

x = C(42)
assertEqual(self, copy(x), x)
end

function test_copy_inst_getnewargs(self)
mutable struct C <: AbstractC
foo
end
function __new__(cls, foo)
self = __new__(int, cls)
self.foo = foo
return self
end

function __getnewargs__(self)::Tuple
return (self.foo,)
end

function __eq__(self, other)::Bool
return self.foo == other.foo
end

x = C(42)
y = copy(x)
assertIsInstance(self, y, C)
assertEqual(self, y, x)
assertIsNot(self, y, x)
assertEqual(self, y.foo, x.foo)
end

function test_copy_inst_getnewargs_ex(self)
mutable struct C <: AbstractC
foo
end
function __new__(cls)
self = __new__(int)
self.foo = foo
return self
end

function __getnewargs_ex__(self)
return ((), Dict("foo" => self.foo))
end

function __eq__(self, other)::Bool
return self.foo == other.foo
end

x = C(42)
y = copy(x)
assertIsInstance(self, y, C)
assertEqual(self, y, x)
assertIsNot(self, y, x)
assertEqual(self, y.foo, x.foo)
end

function test_copy_inst_getstate(self)
mutable struct C <: AbstractC
foo
end
function __getstate__(self)
return Dict("foo" => self.foo)
end

function __eq__(self, other)::Bool
return self.foo == other.foo
end

x = C(42)
assertEqual(self, copy(x), x)
end

function test_copy_inst_setstate(self)
mutable struct C <: AbstractC
foo
end
function __setstate__(self, state)
self.foo = state["foo"]
end

function __eq__(self, other)::Bool
return self.foo == other.foo
end

x = C(42)
assertEqual(self, copy(x), x)
end

function test_copy_inst_getstate_setstate(self)
mutable struct C <: AbstractC
foo
end
function __getstate__(self)
return self.foo
end

function __setstate__(self, state)
self.foo = state
end

function __eq__(self, other)::Bool
return self.foo == other.foo
end

x = C(42)
assertEqual(self, copy(x), x)
x = C(0.0)
assertEqual(self, copy(x), x)
end

function test_deepcopy_basic(self)
x = 42
y = deepcopy(x)
@test (y == x)
end

function test_deepcopy_memo(self)
x = []
x = [x, x]
y = deepcopy(x)
@test (y == x)
assertIsNot(self, y, x)
assertIsNot(self, y[1], x[1])
assertIs(self, y[1], y[2])
end

function test_deepcopy_issubclass(self)
mutable struct Meta <: AbstractMeta

end

mutable struct C <: AbstractC

end

assertEqual(self, deepcopy(C), C)
end

function test_deepcopy_deepcopy(self)
mutable struct C <: AbstractC
foo
end
function __deepcopy__(self, memo = nothing)::C
return C(self.foo)
end

x = C(42)
y = deepcopy(x)
assertEqual(self, y.__class__, x.__class__)
assertEqual(self, y.foo, x.foo)
end

function test_deepcopy_registry(self)
mutable struct C <: AbstractC

end
function __new__(cls, foo)
obj = __new__(object, cls)
obj.foo = foo
return obj
end

function pickle_C(obj)
return (C, (obj.foo,))
end

x = C(42)
assertRaises(self, TypeError, copy.deepcopy, x)
pickle(C, pickle_C, C)
y = deepcopy(x)
end

function test_deepcopy_reduce_ex(self)
mutable struct C <: AbstractC

end
function __reduce_ex__(self, proto)::String
push!(c, 1)
return ""
end

function __reduce__(self)
fail(self, "shouldn\'t call this")
end

c = []
x = C()
y = deepcopy(x)
assertIs(self, y, x)
assertEqual(self, c, [1])
end

function test_deepcopy_reduce(self)
mutable struct C <: AbstractC

end
function __reduce__(self)::String
push!(c, 1)
return ""
end

c = []
x = C()
y = deepcopy(x)
assertIs(self, y, x)
assertEqual(self, c, [1])
end

function test_deepcopy_cant(self)
mutable struct C <: AbstractC

end
function __getattribute__(self, name)
if startswith(name, "__reduce")
throw(AttributeError(name))
end
return __getattribute__(object, self)
end

x = C()
assertRaises(self, copy.Error, copy.deepcopy, x)
end

function test_deepcopy_atomic(self)
mutable struct Classic <: AbstractClassic

end

mutable struct NewStyle <: AbstractNewStyle

end

function f()
#= pass =#
end

tests = [nothing, 42, 2^100, 3.14, true, false, 1im, "hello", "helloሴ", f.__code__, NewStyle, 0:9, Classic, max, property()]
for x in tests
assertIs(self, deepcopy(x), x)
end
end

function test_deepcopy_list(self)
x = [[1, 2], 3]
y = deepcopy(x)
@test (y == x)
assertIsNot(self, x, y)
assertIsNot(self, x[1], y[1])
end

function test_deepcopy_reflexive_list(self)
x = []
push!(x, x)
y = deepcopy(x)
for op in comparisons
@test_throws RecursionError op(y, x)
end
assertIsNot(self, y, x)
assertIs(self, y[1], y)
@test (length(y) == 1)
end

function test_deepcopy_empty_tuple(self)
x = ()
y = deepcopy(x)
assertIs(self, x, y)
end

function test_deepcopy_tuple(self)
x = ([1, 2], 3)
y = deepcopy(x)
@test (y == x)
assertIsNot(self, x, y)
assertIsNot(self, x[1], y[1])
end

function test_deepcopy_tuple_of_immutables(self)
x = ((1, 2), 3)
y = deepcopy(x)
assertIs(self, x, y)
end

function test_deepcopy_reflexive_tuple(self)
x = ([],)
push!(x[1], x)
y = deepcopy(x)
for op in comparisons
@test_throws RecursionError op(y, x)
end
assertIsNot(self, y, x)
assertIsNot(self, y[1], x[1])
assertIs(self, y[1][1], y)
end

function test_deepcopy_dict(self)
x = Dict("foo" => [1, 2], "bar" => 3)
y = deepcopy(x)
@test (y == x)
assertIsNot(self, x, y)
assertIsNot(self, x["foo"], y["foo"])
end

function test_deepcopy_reflexive_dict(self)
x = Dict()
x["foo"] = x
y = deepcopy(x)
for op in order_comparisons
@test_throws TypeError op(y, x)
end
for op in equality_comparisons
@test_throws RecursionError op(y, x)
end
assertIsNot(self, y, x)
assertIs(self, y["foo"], y)
@test (length(y) == 1)
end

function test_deepcopy_keepalive(self)
memo = Dict()
x = []
y = deepcopy(x, memo)
assertIs(self, memo[id(memo)][0], x)
end

function test_deepcopy_dont_memo_immutable(self)
memo = Dict()
x = [1, 2, 3, 4]
y = deepcopy(x, memo)
@test (y == x)
@test (length(memo) == 2)
memo = Dict()
x = [(1, 2)]
y = deepcopy(x, memo)
@test (y == x)
@test (length(memo) == 2)
end

function test_deepcopy_inst_vanilla(self)
mutable struct C <: AbstractC
foo
end
function __eq__(self, other)::Bool
return self.foo == other.foo
end

x = C([42])
y = deepcopy(x)
assertEqual(self, y, x)
assertIsNot(self, y.foo, x.foo)
end

function test_deepcopy_inst_deepcopy(self)
mutable struct C <: AbstractC
foo
end
function __deepcopy__(self, memo)::C
return C(deepcopy(self.foo, memo))
end

function __eq__(self, other)::Bool
return self.foo == other.foo
end

x = C([42])
y = deepcopy(x)
assertEqual(self, y, x)
assertIsNot(self, y, x)
assertIsNot(self, y.foo, x.foo)
end

function test_deepcopy_inst_getinitargs(self)
mutable struct C <: AbstractC
foo
end
function __getinitargs__(self)::Tuple
return (self.foo,)
end

function __eq__(self, other)::Bool
return self.foo == other.foo
end

x = C([42])
y = deepcopy(x)
assertEqual(self, y, x)
assertIsNot(self, y, x)
assertIsNot(self, y.foo, x.foo)
end

function test_deepcopy_inst_getnewargs(self)
mutable struct C <: AbstractC
foo
end
function __new__(cls, foo)
self = __new__(int, cls)
self.foo = foo
return self
end

function __getnewargs__(self)::Tuple
return (self.foo,)
end

function __eq__(self, other)::Bool
return self.foo == other.foo
end

x = C([42])
y = deepcopy(x)
assertIsInstance(self, y, C)
assertEqual(self, y, x)
assertIsNot(self, y, x)
assertEqual(self, y.foo, x.foo)
assertIsNot(self, y.foo, x.foo)
end

function test_deepcopy_inst_getnewargs_ex(self)
mutable struct C <: AbstractC
foo
end
function __new__(cls)
self = __new__(int)
self.foo = foo
return self
end

function __getnewargs_ex__(self)
return ((), Dict("foo" => self.foo))
end

function __eq__(self, other)::Bool
return self.foo == other.foo
end

x = C([42])
y = deepcopy(x)
assertIsInstance(self, y, C)
assertEqual(self, y, x)
assertIsNot(self, y, x)
assertEqual(self, y.foo, x.foo)
assertIsNot(self, y.foo, x.foo)
end

function test_deepcopy_inst_getstate(self)
mutable struct C <: AbstractC
foo
end
function __getstate__(self)
return Dict("foo" => self.foo)
end

function __eq__(self, other)::Bool
return self.foo == other.foo
end

x = C([42])
y = deepcopy(x)
assertEqual(self, y, x)
assertIsNot(self, y, x)
assertIsNot(self, y.foo, x.foo)
end

function test_deepcopy_inst_setstate(self)
mutable struct C <: AbstractC
foo
end
function __setstate__(self, state)
self.foo = state["foo"]
end

function __eq__(self, other)::Bool
return self.foo == other.foo
end

x = C([42])
y = deepcopy(x)
assertEqual(self, y, x)
assertIsNot(self, y, x)
assertIsNot(self, y.foo, x.foo)
end

function test_deepcopy_inst_getstate_setstate(self)
mutable struct C <: AbstractC
foo
end
function __getstate__(self)
return self.foo
end

function __setstate__(self, state)
self.foo = state
end

function __eq__(self, other)::Bool
return self.foo == other.foo
end

x = C([42])
y = deepcopy(x)
assertEqual(self, y, x)
assertIsNot(self, y, x)
assertIsNot(self, y.foo, x.foo)
x = C([])
y = deepcopy(x)
assertEqual(self, y, x)
assertIsNot(self, y, x)
assertIsNot(self, y.foo, x.foo)
end

function test_deepcopy_reflexive_inst(self)
mutable struct C <: AbstractC

end

x = C()
x.foo = x
y = deepcopy(x)
assertIsNot(self, y, x)
assertIs(self, y.foo, y)
end

function test_reconstruct_string(self)
mutable struct C <: AbstractC

end
function __reduce__(self)::String
return ""
end

x = C()
y = copy(x)
assertIs(self, y, x)
y = deepcopy(x)
assertIs(self, y, x)
end

function test_reconstruct_nostate(self)
mutable struct C <: AbstractC

end
function __reduce__(self)
return (C, ())
end

x = C()
x.foo = 42
y = copy(x)
assertIs(self, y.__class__, x.__class__)
y = deepcopy(x)
assertIs(self, y.__class__, x.__class__)
end

function test_reconstruct_state(self)
mutable struct C <: AbstractC
__dict__
end
function __reduce__(self)
return (C, (), self.__dict__)
end

function __eq__(self, other)::Bool
return self.__dict__ == other.__dict__
end

x = C()
x.foo = [42]
y = copy(x)
assertEqual(self, y, x)
y = deepcopy(x)
assertEqual(self, y, x)
assertIsNot(self, y.foo, x.foo)
end

function test_reconstruct_state_setstate(self)
mutable struct C <: AbstractC
__dict__
end
function __reduce__(self)
return (C, (), self.__dict__)
end

function __setstate__(self, state)
update(self.__dict__, state)
end

function __eq__(self, other)::Bool
return self.__dict__ == other.__dict__
end

x = C()
x.foo = [42]
y = copy(x)
assertEqual(self, y, x)
y = deepcopy(x)
assertEqual(self, y, x)
assertIsNot(self, y.foo, x.foo)
end

function test_reconstruct_reflexive(self)
mutable struct C <: AbstractC

end

x = C()
x.foo = x
y = deepcopy(x)
assertIsNot(self, y, x)
assertIs(self, y.foo, y)
end

function test_reduce_4tuple(self)
mutable struct C <: AbstractC
__dict__
end
function __reduce__(self)
return (C, (), self.__dict__, (x for x in self))
end

function __eq__(self, other)
return collect(self) == collect(other) && self.__dict__ == other.__dict__
end

x = C([[1, 2], 3])
y = copy(x)
assertEqual(self, x, y)
assertIsNot(self, x, y)
assertIs(self, x[1], y[1])
y = deepcopy(x)
assertEqual(self, x, y)
assertIsNot(self, x, y)
assertIsNot(self, x[1], y[1])
end

function test_reduce_5tuple(self)
mutable struct C <: AbstractC
__dict__
end
function __reduce__(self)
return (C, (), self.__dict__, nothing, collect(self))
end

function __eq__(self, other)
return dict(self) == dict(other) && self.__dict__ == other.__dict__
end

x = C([("foo", [1, 2]), ("bar", 3)])
y = copy(x)
assertEqual(self, x, y)
assertIsNot(self, x, y)
assertIs(self, x["foo"], y["foo"])
y = deepcopy(x)
assertEqual(self, x, y)
assertIsNot(self, x, y)
assertIsNot(self, x["foo"], y["foo"])
end

function test_copy_slots(self)
mutable struct C <: AbstractC
__slots__::Vector{String}

                    C(__slots__::Vector{String} = ["foo"]) =
                        new(__slots__)
end

x = C()
x.foo = [42]
y = copy(x)
assertIs(self, x.foo, y.foo)
end

function test_deepcopy_slots(self)
mutable struct C <: AbstractC
__slots__::Vector{String}

                    C(__slots__::Vector{String} = ["foo"]) =
                        new(__slots__)
end

x = C()
x.foo = [42]
y = deepcopy(x)
assertEqual(self, x.foo, y.foo)
assertIsNot(self, x.foo, y.foo)
end

function test_deepcopy_dict_subclass(self)
mutable struct C <: AbstractC
_keys::Vector
d

            C(d = nothing) = begin
                if !(d)
d = Dict()
end
super().__init__(d)
                new(d )
            end
end
function __setitem__(self, key, item)
__setitem__(super(), key, item)
if key ∉ self._keys
append(self._keys, key)
end
end

x = C(Dict("foo" => 0))
y = deepcopy(x)
assertEqual(self, x, y)
assertEqual(self, x._keys, y._keys)
assertIsNot(self, x, y)
x["bar"] = 1
assertNotEqual(self, x, y)
assertNotEqual(self, x._keys, y._keys)
end

function test_copy_list_subclass(self)
mutable struct C <: AbstractC

end

x = C([[1, 2], 3])
x.foo = [4, 5]
y = copy(x)
assertEqual(self, collect(x), collect(y))
assertEqual(self, x.foo, y.foo)
assertIs(self, x[1], y[1])
assertIs(self, x.foo, y.foo)
end

function test_deepcopy_list_subclass(self)
mutable struct C <: AbstractC

end

x = C([[1, 2], 3])
x.foo = [4, 5]
y = deepcopy(x)
assertEqual(self, collect(x), collect(y))
assertEqual(self, x.foo, y.foo)
assertIsNot(self, x[1], y[1])
assertIsNot(self, x.foo, y.foo)
end

function test_copy_tuple_subclass(self)
mutable struct C <: AbstractC

end

x = C([1, 2, 3])
assertEqual(self, tuple(x), (1, 2, 3))
y = copy(x)
assertEqual(self, tuple(y), (1, 2, 3))
end

function test_deepcopy_tuple_subclass(self)
mutable struct C <: AbstractC

end

x = C([[1, 2], 3])
assertEqual(self, tuple(x), ([1, 2], 3))
y = deepcopy(x)
assertEqual(self, tuple(y), ([1, 2], 3))
assertIsNot(self, x, y)
assertIsNot(self, x[1], y[1])
end

function test_getstate_exc(self)
mutable struct EvilState <: AbstractEvilState

end
function __getstate__(self)
throw(ValueError("ain\'t got no stickin\' state"))
end

assertRaises(self, ValueError, copy.copy, EvilState())
end

function test_copy_function(self)
@test (copy(global_foo) == global_foo)
function foo(x, y)::Any
return x + y
end

@test (copy(foo) == foo)
bar = () -> nothing
@test (copy(bar) == bar)
end

function test_deepcopy_function(self)
@test (deepcopy(global_foo) == global_foo)
function foo(x, y)::Any
return x + y
end

@test (deepcopy(foo) == foo)
bar = () -> nothing
@test (deepcopy(bar) == bar)
end

function _check_weakref(self, _copy)
mutable struct C <: AbstractC

end

obj = C()
x = ref(obj)
y = _copy(x)
assertIs(self, y, x)
#Delete Unsupported
del(obj)
y = _copy(x)
assertIs(self, y, x)
end

function test_copy_weakref(self)
_check_weakref(self, copy.copy)
end

function test_deepcopy_weakref(self)
_check_weakref(self, copy.deepcopy)
end

function _check_copy_weakdict(self, _dicttype)
mutable struct C <: AbstractC

end

a, b, c, d = [C() for i in 0:3]
u = _dicttype()
u[a + 1] = b
u[c + 1] = d
v = copy(u)
assertIsNot(self, v, u)
assertEqual(self, v, u)
assertEqual(self, v[a + 1], b)
assertEqual(self, v[c + 1], d)
assertEqual(self, length(v), 2)
#Delete Unsupported
del(d)
gc_collect()
assertEqual(self, length(v), 1)
x, y = (C(), C())
v[x + 1] = y
assertNotIn(self, x, u)
end

function test_copy_weakkeydict(self)
_check_copy_weakdict(self, weakref.WeakKeyDictionary)
end

function test_copy_weakvaluedict(self)
_check_copy_weakdict(self, weakref.WeakValueDictionary)
end

function test_deepcopy_weakkeydict(self)
mutable struct C <: AbstractC
i
end

a, b, c, d = [C(i) for i in 0:3]
u = WeakKeyDictionary()
u[a + 1] = b
u[c + 1] = d
v = deepcopy(u)
assertNotEqual(self, v, u)
assertEqual(self, length(v), 2)
assertIsNot(self, v[a + 1], b)
assertIsNot(self, v[c + 1], d)
assertEqual(self, v[a + 1].i, b.i)
assertEqual(self, v[c + 1].i, d.i)
#Delete Unsupported
del(c)
gc_collect()
assertEqual(self, length(v), 1)
end

function test_deepcopy_weakvaluedict(self)
mutable struct C <: AbstractC
i
end

a, b, c, d = [C(i) for i in 0:3]
u = WeakValueDictionary()
u[a + 1] = b
u[c + 1] = d
v = deepcopy(u)
assertNotEqual(self, v, u)
assertEqual(self, length(v), 2)
(x, y), (z, t) = sorted(items(v), key = (pair) -> pair[1].i)
assertIsNot(self, x, a)
assertEqual(self, x.i, a.i)
assertIs(self, y, b)
assertIsNot(self, z, c)
assertEqual(self, z.i, c.i)
assertIs(self, t, d)
#Delete Unsupported
del(t)
#Delete Unsupported
del(d)
gc_collect()
assertEqual(self, length(v), 1)
end

function test_deepcopy_bound_method(self)
mutable struct Foo <: AbstractFoo

end
function m(self)
#= pass =#
end

f = Foo()
f.b = f.m
g = deepcopy(f)
assertEqual(self, g.m, g.b)
assertIs(self, g.b.__self__, g)
b(g)
end

function global_foo(x, y)::Any
return x + y
end

if abspath(PROGRAM_FILE) == @__FILE__
test_copy = TestCopy()
test_exceptions(test_copy)
test_copy_basic(test_copy)
test_copy_copy(test_copy)
test_copy_registry(test_copy)
test_copy_reduce_ex(test_copy)
test_copy_reduce(test_copy)
test_copy_cant(test_copy)
test_copy_atomic(test_copy)
test_copy_list(test_copy)
test_copy_tuple(test_copy)
test_copy_dict(test_copy)
test_copy_set(test_copy)
test_copy_frozenset(test_copy)
test_copy_bytearray(test_copy)
test_copy_inst_vanilla(test_copy)
test_copy_inst_copy(test_copy)
test_copy_inst_getinitargs(test_copy)
test_copy_inst_getnewargs(test_copy)
test_copy_inst_getnewargs_ex(test_copy)
test_copy_inst_getstate(test_copy)
test_copy_inst_setstate(test_copy)
test_copy_inst_getstate_setstate(test_copy)
test_deepcopy_basic(test_copy)
test_deepcopy_memo(test_copy)
test_deepcopy_issubclass(test_copy)
test_deepcopy_deepcopy(test_copy)
test_deepcopy_registry(test_copy)
test_deepcopy_reduce_ex(test_copy)
test_deepcopy_reduce(test_copy)
test_deepcopy_cant(test_copy)
test_deepcopy_atomic(test_copy)
test_deepcopy_list(test_copy)
test_deepcopy_reflexive_list(test_copy)
test_deepcopy_empty_tuple(test_copy)
test_deepcopy_tuple(test_copy)
test_deepcopy_tuple_of_immutables(test_copy)
test_deepcopy_reflexive_tuple(test_copy)
test_deepcopy_dict(test_copy)
test_deepcopy_reflexive_dict(test_copy)
test_deepcopy_keepalive(test_copy)
test_deepcopy_dont_memo_immutable(test_copy)
test_deepcopy_inst_vanilla(test_copy)
test_deepcopy_inst_deepcopy(test_copy)
test_deepcopy_inst_getinitargs(test_copy)
test_deepcopy_inst_getnewargs(test_copy)
test_deepcopy_inst_getnewargs_ex(test_copy)
test_deepcopy_inst_getstate(test_copy)
test_deepcopy_inst_setstate(test_copy)
test_deepcopy_inst_getstate_setstate(test_copy)
test_deepcopy_reflexive_inst(test_copy)
test_reconstruct_string(test_copy)
test_reconstruct_nostate(test_copy)
test_reconstruct_state(test_copy)
test_reconstruct_state_setstate(test_copy)
test_reconstruct_reflexive(test_copy)
test_reduce_4tuple(test_copy)
test_reduce_5tuple(test_copy)
test_copy_slots(test_copy)
test_deepcopy_slots(test_copy)
test_deepcopy_dict_subclass(test_copy)
test_copy_list_subclass(test_copy)
test_deepcopy_list_subclass(test_copy)
test_copy_tuple_subclass(test_copy)
test_deepcopy_tuple_subclass(test_copy)
test_getstate_exc(test_copy)
test_copy_function(test_copy)
test_deepcopy_function(test_copy)
_check_weakref(test_copy)
test_copy_weakref(test_copy)
test_deepcopy_weakref(test_copy)
_check_copy_weakdict(test_copy)
test_copy_weakkeydict(test_copy)
test_copy_weakvaluedict(test_copy)
test_deepcopy_weakkeydict(test_copy)
test_deepcopy_weakvaluedict(test_copy)
test_deepcopy_bound_method(test_copy)
end