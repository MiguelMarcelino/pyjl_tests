#= Unit tests for collections.defaultdict. =#
using Test

import copy

import tempfile


abstract type AbstractTestDefaultDict end
abstract type Abstractsub <: defaultdict end
function foobar()
return list
end

mutable struct TestDefaultDict <: AbstractTestDefaultDict
default_factory
end
function test_basic(self)
d1 = defaultdict()
@test (d1.default_factory == nothing)
d1.default_factory = list
append(d1[13], 42)
@test (d1 == Dict(12 => [42]))
append(d1[13], 24)
@test (d1 == Dict(12 => [42, 24]))
d1[14]
d1[15]
@test (d1 == Dict(12 => [42, 24], 13 => [], 14 => []))
@test d1[13] !== d1[14] !== d1[15]
d2 = defaultdict(list, foo = 1, bar = 2)
@test (d2.default_factory == list)
@test (d2 == Dict("foo" => 1, "bar" => 2))
@test (d2["foo"] == 1)
@test (d2["bar"] == 2)
@test (d2[43] == [])
assertIn(self, "foo", d2)
assertIn(self, "foo", keys(d2))
assertIn(self, "bar", d2)
assertIn(self, "bar", keys(d2))
assertIn(self, 42, d2)
assertIn(self, 42, keys(d2))
assertNotIn(self, 12, d2)
assertNotIn(self, 12, keys(d2))
d2.default_factory = nothing
@test (d2.default_factory == nothing)
try
d2[16]
catch exn
 let err = exn
if err isa KeyError
@test (err.args == (15,))
end
end
end
@test_throws TypeError defaultdict(1)
end

function test_missing(self)
d1 = defaultdict()
@test_throws KeyError d1.__missing__(42)
d1.default_factory = list
@test (__missing__(d1, 42) == [])
end

function test_repr(self)
d1 = defaultdict()
@test (d1.default_factory == nothing)
@test (repr(d1) == "defaultdict(None, {})")
@test (eval(repr(d1)) == d1)
d1[12] = 41
@test (repr(d1) == "defaultdict(None, {11: 41})")
d2 = defaultdict(int)
@test (d2.default_factory == int)
d2[13] = 42
@test (repr(d2) == "defaultdict(<class \'int\'>, {12: 42})")
function foo()::Int64
return 43
end

d3 = defaultdict(foo)
@test d3.default_factory === foo
d3[14]
@test (repr(d3) == "defaultdict(%s, {13: 43})" % repr(foo))
end

function test_copy(self)
d1 = defaultdict()
d2 = copy(d1)
@test (type_(d2) == defaultdict)
@test (d2.default_factory == nothing)
@test (d2 == Dict())
d1.default_factory = list
d3 = copy(d1)
@test (type_(d3) == defaultdict)
@test (d3.default_factory == list)
@test (d3 == Dict())
d1[43]
d4 = copy(d1)
@test (type_(d4) == defaultdict)
@test (d4.default_factory == list)
@test (d4 == Dict(42 => []))
d4[13]
@test (d4 == Dict(42 => [], 12 => []))
d = defaultdict()
d["a"] = 42
e = copy(d)
@test (e["a"] == 42)
end

function test_shallow_copy(self)
d1 = defaultdict(foobar, Dict(1 => 1))
d2 = copy(d1)
@test (d2.default_factory == foobar)
@test (d2 == d1)
d1.default_factory = list
d2 = copy(d1)
@test (d2.default_factory == list)
@test (d2 == d1)
end

function test_deep_copy(self)
d1 = defaultdict(foobar, Dict(1 => [1]))
d2 = deepcopy(d1)
@test (d2.default_factory == foobar)
@test (d2 == d1)
@test d1[2] !== d2[2]
d1.default_factory = list
d2 = deepcopy(d1)
@test (d2.default_factory == list)
@test (d2 == d1)
end

function test_keyerror_without_factory(self)
d1 = defaultdict()
try
d1[(1,) + 1]
catch exn
 let err = exn
if err isa KeyError
@test (err.args[1] == (1,))
end
end
end
end

function test_recursive_repr(self)
mutable struct sub <: Abstractsub
default_factory
end
function _factory(self)::Vector
return []
end

d = sub()
assertRegex(self, repr(d), "sub\\(<bound method .*sub\\._factory of sub\\(\\.\\.\\., \\{\\}\\)>, \\{\\}\\)")
end

function test_callable_arg(self)
@test_throws TypeError defaultdict(Dict())
end

function test_pickling(self)
d = defaultdict(int)
d[2]
for proto in 0:pickle.HIGHEST_PROTOCOL
s = dumps(d, proto)
o = loads(s)
@test (d == o)
end
end

function test_union(self)
i = defaultdict(int, Dict(1 => 1, 2 => 2))
s = defaultdict(str, Dict(0 => "zero", 1 => "one"))
i_s = __or__(i, s)
assertIs(self, i_s.default_factory, int)
assertDictEqual(self, i_s, Dict(1 => "one", 2 => 2, 0 => "zero"))
@test (collect(i_s) == [1, 2, 0])
s_i = __or__(s, i)
assertIs(self, s_i.default_factory, str)
assertDictEqual(self, s_i, Dict(0 => "zero", 1 => 1, 2 => 2))
@test (collect(s_i) == [0, 1, 2])
i_ds = __or__(i, dict(s))
assertIs(self, i_ds.default_factory, int)
assertDictEqual(self, i_ds, Dict(1 => "one", 2 => 2, 0 => "zero"))
@test (collect(i_ds) == [1, 2, 0])
ds_i = __or__(dict(s), i)
assertIs(self, ds_i.default_factory, int)
assertDictEqual(self, ds_i, Dict(0 => "zero", 1 => 1, 2 => 2))
@test (collect(ds_i) == [0, 1, 2])
assertRaises(self, TypeError) do 
__or__(i, collect(items(s)))
end
assertRaises(self, TypeError) do 
__or__(collect(items(s)), i)
end
i = __or__(i, collect(items(s)))
assertIs(self, i.default_factory, int)
assertDictEqual(self, i, Dict(1 => "one", 2 => 2, 0 => "zero"))
@test (collect(i) == [1, 2, 0])
assertRaises(self, TypeError) do 
i = __or__(i, nothing)
end
end

if abspath(PROGRAM_FILE) == @__FILE__
test_default_dict = TestDefaultDict()
test_basic(test_default_dict)
test_missing(test_default_dict)
test_repr(test_default_dict)
test_copy(test_default_dict)
test_shallow_copy(test_default_dict)
test_deep_copy(test_default_dict)
test_keyerror_without_factory(test_default_dict)
test_recursive_repr(test_default_dict)
test_callable_arg(test_default_dict)
test_pickling(test_default_dict)
test_union(test_default_dict)
end