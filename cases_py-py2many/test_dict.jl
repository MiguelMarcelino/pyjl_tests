using OrderedCollections
using Test
import _testcapi
using _testcapi: dict_getitem_knownhash


import gc

import random
import string




mutable struct DictTest <: AbstractDictTest
__class__
__dict__
__missing__
d::Dict{Int64, Int64}
eq_count::Int64
hash_count::Int64
i::Int64
msg
value
x
y
__iter__
fail::Bool
mutate_dict

                    DictTest(__class__, __dict__, __missing__, d::Dict{Int64, Int64}, eq_count::Int64, hash_count::Int64, i::Int64, msg, value, x, y, __iter__ = keys, fail::Bool = false, mutate_dict = nothing) =
                        new(__class__, __dict__, __missing__, d, eq_count, hash_count, i, msg, value, x, y, __iter__, fail, mutate_dict)
end
function test_invalid_keyword_arguments(self)
mutable struct Custom <: AbstractCustom

end

for invalid in (Dict(1 => 2), Custom(Dict(1 => 2)))
assertRaises(self, TypeError) do 
dict(None = invalid)
end
assertRaises(self, TypeError) do 
update(Dict(), None = invalid)
end
end
end

function test_constructor(self)
@test (dict() == Dict())
assertIsNot(self, dict(), Dict())
end

function test_literal_constructor(self)
for n in (0, 1, 6, 256, 400)
items = [(join(sample(string.ascii_letters, 8), ""), i) for i in 0:n - 1]
shuffle(items)
formatted_items = ("$(!r): $(:d)" for (k, v) in items)
dictliteral = ("{" + join(formatted_items, ", ")) * "}"
@test (eval(dictliteral) == dict(items))
end
end

function test_merge_operator(self)
a = Dict(0 => 0, 1 => 1, 2 => 1)
b = Dict(1 => 1, 2 => 2, 3 => 3)
c = copy(a)
c |= b
@test (a | b == Dict(0 => 0, 1 => 1, 2 => 2, 3 => 3))
@test (c == Dict(0 => 0, 1 => 1, 2 => 2, 3 => 3))
c = copy(b)
c |= a
@test (b | a == Dict(1 => 1, 2 => 1, 3 => 3, 0 => 0))
@test (c == Dict(1 => 1, 2 => 1, 3 => 3, 0 => 0))
c = copy(a)
c |= [(1, 1), (2, 2), (3, 3)]
@test (c == Dict(0 => 0, 1 => 1, 2 => 2, 3 => 3))
assertIs(self, __or__(a, nothing), NotImplemented)
assertIs(self, __or__(a, ()), NotImplemented)
assertIs(self, __or__(a, "BAD"), NotImplemented)
assertIs(self, __or__(a, ""), NotImplemented)
@test_throws TypeError a.__ior__(nothing)
@test (__ior__(a, ()) == Dict(0 => 0, 1 => 1, 2 => 1))
@test_throws ValueError a.__ior__("BAD")
@test (__ior__(a, "") == Dict(0 => 0, 1 => 1, 2 => 1))
end

function test_bool(self)
assertIs(self, !(Dict()), true)
@test Dict(1 => 2)
assertIs(self, Bool(Dict()), false)
assertIs(self, Bool(Dict(1 => 2)), true)
end

function test_keys(self)
d = OrderedDict()
@test (set(keys(d)) == set())
d = OrderedDict("a" => 1, "b" => 2)
k = keys(d)
@test (set(k) == Set(["a", "b"]))
assertIn(self, "a", k)
assertIn(self, "b", k)
assertIn(self, "a", d)
assertIn(self, "b", d)
@test_throws TypeError d.keys(nothing)
@test (repr(keys(dict(a = 1))) == "dict_keys([\'a\'])")
end

function test_values(self)
d = OrderedDict()
@test (set(values(d)) == set())
d = OrderedDict(1 => 2)
@test (set(values(d)) == Set([2]))
@test_throws TypeError d.values(nothing)
@test (repr(values(dict(a = 1))) == "dict_values([1])")
end

function test_items(self)
d = OrderedDict()
@test (set(collect(d)) == set())
d = OrderedDict(1 => 2)
@test (set(collect(d)) == Set([(1, 2)]))
@test_throws TypeError collect(d)(nothing)
@test (repr(items(dict(a = 1))) == "dict_items([(\'a\', 1)])")
end

function test_views_mapping(self)
mappingproxy = type_(type_.__dict__)
mutable struct Dict <: AbstractDict

end

for cls in [dict, Dict]
d = cls()
m1 = keys(d).mapping
m2 = values(d).mapping
m3 = collect(d).mapping
for m in [m1, m2, m3]
assertIsInstance(self, m, mappingproxy)
assertEqual(self, m, d)
end
d["foo"] = "bar"
for m in [m1, m2, m3]
assertIsInstance(self, m, mappingproxy)
assertEqual(self, m, d)
end
end
end

function test_contains(self)
d = OrderedDict()
assertNotIn(self, "a", d)
@test !("a" ∈ d)
@test "a" ∉ d
d = OrderedDict("a" => 1, "b" => 2)
assertIn(self, "a", d)
assertIn(self, "b", d)
assertNotIn(self, "c", d)
@test_throws TypeError d.__contains__()
end

function test_len(self)
d = OrderedDict()
@test (length(d) == 0)
d = OrderedDict("a" => 1, "b" => 2)
@test (length(d) == 2)
end

function test_getitem(self)
d = OrderedDict("a" => 1, "b" => 2)
assertEqual(self, d["a"], 1)
assertEqual(self, d["b"], 2)
d["c"] = 3
d["a"] = 4
assertEqual(self, d["c"], 3)
assertEqual(self, d["a"], 4)
#Delete Unsupported
del(d)
assertEqual(self, d, Dict("a" => 4, "c" => 3))
assertRaises(self, TypeError, d.__getitem__)
mutable struct BadEq <: AbstractBadEq

end
function __eq__(self, other)
throw(Exc())
end

function __hash__(self)::Int64
return 24
end

d = OrderedDict()
d[BadEq()] = 42
assertRaises(self, KeyError, d.__getitem__, 23)
mutable struct Exc <: AbstractExc

end

mutable struct BadHash <: AbstractBadHash
fail::Bool

                    BadHash(fail::Bool = false) =
                        new(fail)
end
function __hash__(self)::Int64
if self.fail
throw(Exc())
else
return 42
end
end

x = BadHash()
d[x] = 42
x.fail = true
assertRaises(self, Exc, d.__getitem__, x)
end

function test_clear(self)
d = OrderedDict(1 => 1, 2 => 2, 3 => 3)
clear(d)
@test (d == Dict())
@test_throws TypeError d.clear(nothing)
end

function test_update(self)
d = OrderedDict()
update(d, Dict(1 => 100))
update(d, Dict(2 => 20))
update(d, Dict(1 => 1, 2 => 2, 3 => 3))
assertEqual(self, d, Dict(1 => 1, 2 => 2, 3 => 3))
update(d)
assertEqual(self, d, Dict(1 => 1, 2 => 2, 3 => 3))
assertRaises(self, (TypeError, AttributeError), d.update, nothing)
mutable struct SimpleUserDict <: AbstractSimpleUserDict
d::Dict{Int64, Int64}
end
function keys(self)
return keys(self.d)
end

function __getitem__(self, i)
return self.d[i + 1]
end

clear(d)
update(d, SimpleUserDict())
assertEqual(self, d, Dict(1 => 1, 2 => 2, 3 => 3))
mutable struct Exc <: AbstractExc

end

clear(d)
mutable struct FailingUserDict <: AbstractFailingUserDict

end
function keys(self)
throw(Exc)
end

assertRaises(self, Exc, d.update, FailingUserDict())
mutable struct FailingUserDict <: AbstractFailingUserDict
i::Int64
end
function keys(self)::BogonIter
mutable struct BogonIter <: AbstractBogonIter
i::Int64
end
function __iter__(self)
return self
end

function __next__(self)::String
if self.i != 0
self.i = 0
return "a"
end
throw(Exc)
end

return BogonIter()
end

function __getitem__(self, key)
return key
end

assertRaises(self, Exc, d.update, FailingUserDict())
mutable struct FailingUserDict <: AbstractFailingUserDict
i
end
function keys(self)::BogonIter
mutable struct BogonIter <: AbstractBogonIter
i
end
function __iter__(self)
return self
end

function __next__(self)
if self.i <= Int(codepoint('z'))
rtn = Char(self.i)
self.i += 1
return rtn
end
throw(StopIteration)
end

return BogonIter()
end

function __getitem__(self, key)
throw(Exc)
end

assertRaises(self, Exc, d.update, FailingUserDict())
mutable struct badseq <: Abstractbadseq

end
function __iter__(self)
return self
end

function __next__(self)
throw(Exc())
end

assertRaises(self, Exc, Dict().update, badseq())
assertRaises(self, ValueError, Dict().update, [(1, 2, 3)])
end

function test_fromkeys(self)
Channel() do ch_test_fromkeys 
assertEqual(self, fromkeys(dict, "abc"), Dict("a" => nothing, "b" => nothing, "c" => nothing))
d = OrderedDict()
assertIsNot(self, fromkeys(d, "abc"), d)
assertEqual(self, fromkeys(d, "abc"), Dict("a" => nothing, "b" => nothing, "c" => nothing))
assertEqual(self, fromkeys(d, (4, 5), 0), Dict(4 => 0, 5 => 0))
assertEqual(self, fromkeys(d, []), Dict())
function g()
Channel() do ch_g 
put!(ch_g, 1)
end
end

assertEqual(self, fromkeys(d, g()), Dict(1 => nothing))
assertRaises(self, TypeError, Dict().fromkeys, 3)
mutable struct dictlike <: Abstractdictlike

end

assertEqual(self, fromkeys(dictlike, "a"), Dict("a" => nothing))
assertEqual(self, fromkeys(dictlike(), "a"), Dict("a" => nothing))
assertIsInstance(self, fromkeys(dictlike, "a"), dictlike)
assertIsInstance(self, fromkeys(dictlike(), "a"), dictlike)
mutable struct mydict <: Abstractmydict

end
function __new__(cls)
return UserDict()
end

ud = fromkeys(mydict, "ab")
assertEqual(self, ud, Dict("a" => nothing, "b" => nothing))
assertIsInstance(self, ud, collections.UserDict)
assertRaises(self, TypeError, dict.fromkeys)
mutable struct Exc <: AbstractExc

end

mutable struct baddict1 <: Abstractbaddict1


            baddict1() = begin
                throw(Exc())
                new()
            end
end

assertRaises(self, Exc, baddict1.fromkeys, [1])
mutable struct BadSeq <: AbstractBadSeq

end
function __iter__(self)
return self
end

function __next__(self)
throw(Exc())
end

assertRaises(self, Exc, dict.fromkeys, BadSeq())
mutable struct baddict2 <: Abstractbaddict2

end
function __setitem__(self, key, value)
throw(Exc())
end

assertRaises(self, Exc, baddict2.fromkeys, [1])
d = dict(zip(0:5, 0:5))
assertEqual(self, fromkeys(dict, d, 0), dict(zip(0:5, repeat([0],6))))
mutable struct baddict3 <: Abstractbaddict3

end
function __new__(cls)::Dict
return d
end

d = OrderedDict(i => i for i in 0:9)
res = copy(d)
update(res, a = nothing, b = nothing, c = nothing)
assertEqual(self, fromkeys(baddict3, Set(["a", "b", "c"])), res)
end
end

function test_copy(self)
d = OrderedDict(1 => 1, 2 => 2, 3 => 3)
assertIsNot(self, copy(d), d)
@test (copy(d) == d)
@test (copy(d) == Dict(1 => 1, 2 => 2, 3 => 3))
copy = copy(d)
d[4] = 4
assertNotEqual(self, copy, d)
@test (copy(Dict()) == Dict())
@test_throws TypeError d.copy(nothing)
end

function test_copy_fuzz(self)
for dict_size in [10, 100, 1000, 10000, 100000]
dict_size = randrange(dict_size ÷ 2, dict_size + (dict_size ÷ 2))
subTest(self, dict_size = dict_size) do 
d = OrderedDict()
for i in 0:dict_size - 1
d[i] = i
end
d2 = copy(d)
assertIsNot(self, d2, d)
@test (d == d2)
d2["key"] = "value"
assertNotEqual(self, d, d2)
@test (length(d2) == length(d) + 1)
end
end
end

function test_copy_maintains_tracking(self)
mutable struct A <: AbstractA

end

key = A()
for d in (Dict(), Dict("a" => 1), Dict(key => "val"))
d2 = copy(d)
assertEqual(self, is_tracked(d), is_tracked(d2))
end
end

function test_copy_noncompact(self)
d = OrderedDict(k => k for k in 0:999)
for k in 0:949
delete!(d, k)
end
d2 = copy(d)
@test (d2 == d)
end

function test_get(self)
d = OrderedDict()
assertIs(self, get(d, "c"), nothing)
@test (get(d, "c", 3) == 3)
d = OrderedDict("a" => 1, "b" => 2)
assertIs(self, get(d, "c"), nothing)
@test (get(d, "c", 3) == 3)
@test (get(d, "a") == 1)
@test (get(d, "a", 3) == 1)
@test_throws TypeError d.get()
@test_throws TypeError d.get(nothing, nothing, nothing)
end

function test_setdefault(self)
d = OrderedDict()
assertIs(self, setdefault(d, "key0"), nothing)
setdefault(d, "key0", [])
assertIs(self, setdefault(d, "key0"), nothing)
append(setdefault(d, "key", []), 3)
assertEqual(self, d["key"][0], 3)
append(setdefault(d, "key", []), 4)
assertEqual(self, length(d["key"]), 2)
assertRaises(self, TypeError, d.setdefault)
mutable struct Exc <: AbstractExc

end

mutable struct BadHash <: AbstractBadHash
fail::Bool

                    BadHash(fail::Bool = false) =
                        new(fail)
end
function __hash__(self)::Int64
if self.fail
throw(Exc())
else
return 42
end
end

x = BadHash()
d[x] = 42
x.fail = true
assertRaises(self, Exc, d.setdefault, x, [])
end

function test_setdefault_atomic(self)
mutable struct Hashed <: AbstractHashed
hash_count::Int64
eq_count::Int64
end
function __hash__(self)::Int64
self.hash_count += 1
return 42
end

function __eq__(self, other)::Bool
self.eq_count += 1
return id(self) == id(other)
end

hashed1 = Hashed()
y = Dict(hashed1 => 5)
hashed2 = Hashed()
setdefault(y, hashed2, [])
assertEqual(self, hashed1.hash_count, 1)
assertEqual(self, hashed2.hash_count, 1)
assertEqual(self, hashed1.eq_count + hashed2.eq_count, 1)
end

function test_setitem_atomic_at_resize(self)
mutable struct Hashed <: AbstractHashed
hash_count::Int64
eq_count::Int64
end
function __hash__(self)::Int64
self.hash_count += 1
return 42
end

function __eq__(self, other)::Bool
self.eq_count += 1
return id(self) == id(other)
end

hashed1 = Hashed()
y = Dict(hashed1 => 5, 0 => 0, 1 => 1, 2 => 2, 3 => 3)
hashed2 = Hashed()
y[hashed2] = []
assertEqual(self, hashed1.hash_count, 1)
assertEqual(self, hashed2.hash_count, 1)
assertEqual(self, hashed1.eq_count + hashed2.eq_count, 1)
end

function test_popitem(self)
for copymode in (-1, +1)
for log2size in 0:11
size = 2^log2size
a = Dict()
b = Dict()
for i in 0:size - 1
a[repr(i)] = i
if copymode < 0
b[repr(i)] = i
end
end
if copymode > 0
b = copy(a)
end
for i in 0:size - 1
ka, va = popitem(a)
ta = popitem(a)
@test (va == parse(Int, ka))
kb, vb = popitem(b)
tb = popitem(b)
@test (vb == parse(Int, kb))
@test !(copymode < 0 && ta != tb)
end
@test !(a)
@test !(b)
end
end
d = OrderedDict()
@test_throws KeyError d.popitem()
end

function test_pop(self)
d = OrderedDict()
k, v = ("abc", "def")
d[k] = v
assertRaises(self, KeyError, d.pop, "ghi")
assertEqual(self, pop(d, k), v)
assertEqual(self, length(d), 0)
assertRaises(self, KeyError, d.pop, k)
assertEqual(self, pop(d, k, v), v)
d[k] = v
assertEqual(self, pop(d, k, 1), v)
assertRaises(self, TypeError, d.pop)
mutable struct Exc <: AbstractExc

end

mutable struct BadHash <: AbstractBadHash
fail::Bool

                    BadHash(fail::Bool = false) =
                        new(fail)
end
function __hash__(self)::Int64
if self.fail
throw(Exc())
else
return 42
end
end

x = BadHash()
d[x] = 42
x.fail = true
assertRaises(self, Exc, d.pop, x)
end

function test_mutating_iteration(self)
d = OrderedDict()
d[1] = 1
assertRaises(self, RuntimeError) do 
for i in d
d[i + 1] = 1
end
end
end

function test_mutating_iteration_delete(self)
d = OrderedDict()
d[0] = 0
assertRaises(self, RuntimeError) do 
for i in d
delete!(d, 0)
d[0] = 0
end
end
end

function test_mutating_iteration_delete_over_values(self)
d = OrderedDict()
d[0] = 0
assertRaises(self, RuntimeError) do 
for i in values(d)
delete!(d, 0)
d[0] = 0
end
end
end

function test_mutating_iteration_delete_over_items(self)
d = OrderedDict()
d[0] = 0
assertRaises(self, RuntimeError) do 
for i in collect(d)
delete!(d, 0)
d[0] = 0
end
end
end

function test_mutating_lookup(self)
mutable struct NastyKey <: AbstractNastyKey
value
mutate_dict

                    NastyKey(value, mutate_dict = nothing) =
                        new(value, mutate_dict)
end
function __hash__(self)::Int64
return 1
end

function __eq__(self, other)::Bool
if NastyKey.mutate_dict
mydict, key = NastyKey.mutate_dict
NastyKey.mutate_dict = nothing
#Delete Unsupported
del(mydict)
end
return self.value == other.value
end

key1 = NastyKey(1)
key2 = NastyKey(2)
d = OrderedDict(key1 => 1)
NastyKey.mutate_dict = (d, key1)
d[key2] = 2
assertEqual(self, d, Dict(key2 => 2))
end

function test_repr(self)
d = OrderedDict()
assertEqual(self, repr(d), "{}")
d[1] = 2
assertEqual(self, repr(d), "{1: 2}")
d = OrderedDict()
d[1] = d
assertEqual(self, repr(d), "{1: {...}}")
mutable struct Exc <: AbstractExc

end

mutable struct BadRepr <: AbstractBadRepr

end
function __repr__(self)
throw(Exc())
end

d = OrderedDict(1 => BadRepr())
assertRaises(self, Exc, repr, d)
end

function test_repr_deep(self)
d = OrderedDict()
for i in 0:getrecursionlimit() + 99
d = OrderedDict(1 => d)
end
@test_throws RecursionError repr(d)
end

function test_eq(self)
assertEqual(self, Dict(), Dict())
assertEqual(self, Dict(1 => 2), Dict(1 => 2))
mutable struct Exc <: AbstractExc

end

mutable struct BadCmp <: AbstractBadCmp

end
function __eq__(self, other)
throw(Exc())
end

function __hash__(self)::Int64
return 1
end

d1 = Dict(BadCmp() => 1)
d2 = Dict(1 => 1)
assertRaises(self, Exc) do 
d1 == d2
end
end

function test_keys_contained(self)
helper_keys_contained(self, (x) -> keys(x))
helper_keys_contained(self, (x) -> items(x))
end

function helper_keys_contained(self, fn)
empty = fn(dict())
empty2 = fn(dict())
smaller = fn(Dict(1 => 1, 2 => 2))
larger = fn(Dict(1 => 1, 2 => 2, 3 => 3))
larger2 = fn(Dict(1 => 1, 2 => 2, 3 => 3))
larger3 = fn(Dict(4 => 1, 2 => 2, 3 => 3))
@test smaller < larger
@test smaller <= larger
@test larger > smaller
@test larger >= smaller
@test !(smaller >= larger)
@test !(smaller > larger)
@test !(larger <= smaller)
@test !(larger < smaller)
@test !(smaller < larger3)
@test !(smaller <= larger3)
@test !(larger3 > smaller)
@test !(larger3 >= smaller)
@test larger2 >= larger
@test larger2 <= larger
@test !(larger2 > larger)
@test !(larger2 < larger)
@test larger == larger2
@test smaller != larger
@test empty == empty2
@test !(empty != empty2)
@test !(empty == smaller)
@test empty != smaller
@test larger != larger3
@test !(larger == larger3)
end

function test_errors_in_view_containment_check(self)
mutable struct C <: AbstractC

end
function __eq__(self, other)
throw(RuntimeError)
end

d1 = Dict(1 => C())
d2 = Dict(1 => C())
assertRaises(self, RuntimeError) do 
collect(d1) == collect(d2)
end
assertRaises(self, RuntimeError) do 
collect(d1) != collect(d2)
end
assertRaises(self, RuntimeError) do 
collect(d1) <= collect(d2)
end
assertRaises(self, RuntimeError) do 
collect(d1) >= collect(d2)
end
d3 = Dict(1 => C(), 2 => C())
assertRaises(self, RuntimeError) do 
collect(d2) < collect(d3)
end
assertRaises(self, RuntimeError) do 
collect(d3) > collect(d2)
end
end

function test_dictview_set_operations_on_keys(self)
k1 = keys(Dict(1 => 1, 2 => 2))
k2 = keys(Dict(1 => 1, 2 => 2, 3 => 3))
k3 = keys(Dict(4 => 4))
@test (k1 - k2 == set())
@test (k1 - k3 == Set([1, 2]))
@test (k2 - k1 == Set([3]))
@test (k3 - k1 == Set([4]))
@test (k1 & k2 == Set([1, 2]))
@test (k1 & k3 == set())
@test (k1 | k2 == Set([1, 2, 3]))
@test (k1  ⊻  k2 == Set([3]))
@test (k1  ⊻  k3 == Set([1, 2, 4]))
end

function test_dictview_set_operations_on_items(self)
k1 = collect(Dict(1 => 1, 2 => 2))
k2 = collect(Dict(1 => 1, 2 => 2, 3 => 3))
k3 = collect(Dict(4 => 4))
@test (k1 - k2 == set())
@test (k1 - k3 == Set([(1, 1), (2, 2)]))
@test (k2 - k1 == Set([(3, 3)]))
@test (k3 - k1 == Set([(4, 4)]))
@test (k1 & k2 == Set([(1, 1), (2, 2)]))
@test (k1 & k3 == set())
@test (k1 | k2 == Set([(1, 1), (2, 2), (3, 3)]))
@test (k1  ⊻  k2 == Set([(3, 3)]))
@test (k1  ⊻  k3 == Set([(1, 1), (2, 2), (4, 4)]))
end

function test_items_symmetric_difference(self)
rr = random.randrange
for _ in 0:99
left = Dict(x => rr(3) for x in 0:19 if rr(2) )
right = Dict(x => rr(3) for x in 0:19 if rr(2) )
subTest(self, left = left, right = right) do 
expected = set(collect(left))  ⊻  set(collect(right))
actual = collect(left)  ⊻  collect(right)
@test (actual == expected)
end
end
end

function test_dictview_mixed_set_operations(self)
@test keys(Dict(1 => 1)) == Set([1])
@test Set([1]) == keys(Dict(1 => 1))
@test (keys(Dict(1 => 1)) | Set([2]) == Set([1, 2]))
@test (Set([2]) | keys(Dict(1 => 1)) == Set([1, 2]))
@test collect(Dict(1 => 1)) == Set([(1, 1)])
@test Set([(1, 1)]) == collect(Dict(1 => 1))
@test (collect(Dict(1 => 1)) | Set([2]) == Set([(1, 1), 2]))
@test (Set([2]) | collect(Dict(1 => 1)) == Set([(1, 1), 2]))
end

function test_missing(self)
assertFalse(self, hasfield(typeof(dict), :__missing__))
assertFalse(self, hasfield(typeof(Dict()), :__missing__))
mutable struct D <: AbstractD

end
function __missing__(self, key)::Int64
return 42
end

d = D(Dict(1 => 2, 3 => 4))
assertEqual(self, d[2], 2)
assertEqual(self, d[4], 4)
assertNotIn(self, 2, d)
assertNotIn(self, 2, keys(d))
assertEqual(self, d[3], 42)
mutable struct E <: AbstractE

end
function __missing__(self, key)
throw(RuntimeError(key))
end

e = E()
assertRaises(self, RuntimeError) do c 
e[43]
end
assertEqual(self, c.exception.args, (42,))
mutable struct F <: AbstractF
__missing__
end

f = F()
assertRaises(self, KeyError) do c 
f[43]
end
assertEqual(self, c.exception.args, (42,))
mutable struct G <: AbstractG

end

g = G()
assertRaises(self, KeyError) do c 
g[43]
end
assertEqual(self, c.exception.args, (42,))
end

function test_tuple_keyerror(self)
d = OrderedDict()
assertRaises(self, KeyError) do c 
d[(1,)]
end
@test (c.exception.args == ((1,),))
end

function test_bad_key(self)
mutable struct CustomException <: AbstractCustomException

end

mutable struct BadDictKey <: AbstractBadDictKey
__class__
end
function __hash__(self)
return hash(self.__class__)
end

function __eq__(self, other)
if isa(other, self.__class__)
throw(CustomException)
end
return other
end

d = OrderedDict()
x1 = BadDictKey()
x2 = BadDictKey()
d[x1] = 1
for stmt in ["d[x2] = 2", "z = d[x2]", "x2 in d", "d.get(x2)", "d.setdefault(x2, 42)", "d.pop(x2)", "d.update({x2: 2})"]
assertRaises(self, CustomException) do 
exec(stmt, locals())
end
end
end

function test_resize1(self)
d = OrderedDict()
for i in 0:4
d[i] = i
end
for i in 0:4
delete!(d, i)
end
for i in 5:8
d[i] = i
end
end

function test_resize2(self)
mutable struct X <: AbstractX

end
function __hash__(self)::Int64
return 5
end

function __eq__(self, other)::Bool
if resizing
clear(d)
end
return false
end

d = OrderedDict()
resizing = false
d[X()] = 1
d[X()] = 2
d[X()] = 3
d[X()] = 4
d[X()] = 5
resizing = true
d[9] = 6
end

function test_empty_presized_dict_in_freelist(self)
assertRaises(self, ZeroDivisionError) do 
d = OrderedDict("a" => 1 ÷ 0, "b" => nothing, "c" => nothing, "d" => nothing, "e" => nothing, "f" => nothing, "g" => nothing, "h" => nothing)
end
d = OrderedDict()
end

function test_container_iterator(self)
mutable struct C <: AbstractC

end

views = (dict.items, dict.values, dict.keys)
for v in views
obj = C()
ref = ref(obj)
container = Dict(obj => 1)
obj.v = v(container)
obj.x = (x for x in obj.v)
delete!(container)
collect()
assertIs(self, ref(), nothing, "Cycle was not collected")
end
end

function _not_tracked(self, t)
collect()
collect()
@test !(is_tracked(t))
end

function _tracked(self, t)
@test is_tracked(t)
collect()
collect()
@test is_tracked(t)
end

function test_track_literals(self)
x, y, z, w = (1.5, "a", (1, nothing), [])
_not_tracked(self, Dict())
_not_tracked(self, Dict(x => (), y => x, z => 1))
_not_tracked(self, Dict(1 => "a", "b" => 2))
_not_tracked(self, Dict(1 => 2, (nothing, true, false, ()) => int))
_not_tracked(self, Dict(1 => object()))
_tracked(self, Dict(1 => []))
_tracked(self, Dict(1 => ([],)))
_tracked(self, Dict(1 => Dict()))
_tracked(self, Dict(1 => set()))
end

function test_track_dynamic(self)
mutable struct MyObject <: AbstractMyObject

end

x, y, z, w, o = (1.5, "a", (1, object()), [], MyObject())
d = dict()
_not_tracked(self, d)
d[2] = "a"
_not_tracked(self, d)
d[y + 1] = 2
_not_tracked(self, d)
d[z + 1] = 3
_not_tracked(self, d)
_not_tracked(self, copy(d))
d[5] = w
_tracked(self, d)
_tracked(self, copy(d))
d[5] = nothing
_not_tracked(self, d)
_not_tracked(self, copy(d))
d = dict()
dd = dict()
d[2] = dd
_not_tracked(self, dd)
_tracked(self, d)
dd[2] = d
_tracked(self, dd)
d = fromkeys(dict, [x, y, z])
_not_tracked(self, d)
dd = dict()
update(dd, d)
_not_tracked(self, dd)
d = fromkeys(dict, [x, y, z, o])
_tracked(self, d)
dd = dict()
update(dd, d)
_tracked(self, dd)
d = dict(x = x, y = y, z = z)
_not_tracked(self, d)
d = dict(x = x, y = y, z = z, w = w)
_tracked(self, d)
d = dict()
update(d, x = x, y = y, z = z)
_not_tracked(self, d)
update(d, w = w)
_tracked(self, d)
d = dict([(x, y), (z, 1)])
_not_tracked(self, d)
d = dict([(x, y), (z, w)])
_tracked(self, d)
d = dict()
update(d, [(x, y), (z, 1)])
_not_tracked(self, d)
update(d, [(x, y), (z, w)])
_tracked(self, d)
end

function test_track_subtypes(self)
mutable struct MyDict <: AbstractMyDict

end

_tracked(self, MyDict())
end

function make_shared_key_dict(self, n)::Vector
mutable struct C <: AbstractC

end

dicts = []
for i in 0:n - 1
a = C()
a.x, a.y, a.z = (1, 2, 3)
push!(dicts, a.__dict__)
end
return dicts
end

function test_splittable_setdefault(self)
#= split table must be combined when setdefault()
        breaks insertion order =#
a, b = make_shared_key_dict(self, 2)
a["a"] = 1
size_a = getsizeof(a)
a["b"] = 2
setdefault(b, "b", 2)
size_b = getsizeof(b)
b["a"] = 1
assertGreater(self, size_b, size_a)
@test (collect(a) == ["x", "y", "z", "a", "b"])
@test (collect(b) == ["x", "y", "z", "b", "a"])
end

function test_splittable_del(self)
#= split table must be combined when del d[k] =#
a, b = make_shared_key_dict(self, 2)
orig_size = getsizeof(a)
#Delete Unsupported
del(a)
assertRaises(self, KeyError) do 
#Delete Unsupported
del(a)
end
assertGreater(self, getsizeof(a), orig_size)
@test (collect(a) == ["x", "z"])
@test (collect(b) == ["x", "y", "z"])
a["y"] = 42
@test (collect(a) == ["x", "z", "y"])
@test (collect(b) == ["x", "y", "z"])
end

function test_splittable_pop(self)
#= split table must be combined when d.pop(k) =#
a, b = make_shared_key_dict(self, 2)
orig_size = getsizeof(a)
pop(a, "y")
assertRaises(self, KeyError) do 
pop(a, "y")
end
assertGreater(self, getsizeof(a), orig_size)
@test (collect(a) == ["x", "z"])
@test (collect(b) == ["x", "y", "z"])
a["y"] = 42
@test (collect(a) == ["x", "z", "y"])
@test (collect(b) == ["x", "y", "z"])
end

function test_splittable_pop_pending(self)
#= pop a pending key in a split table should not crash =#
a, b = make_shared_key_dict(self, 2)
a["a"] = 4
assertRaises(self, KeyError) do 
pop(b, "a")
end
end

function test_splittable_popitem(self)
#= split table must be combined when d.popitem() =#
a, b = make_shared_key_dict(self, 2)
orig_size = getsizeof(a)
item = popitem(a)
@test (item == ("z", 3))
assertRaises(self, KeyError) do 
#Delete Unsupported
del(a)
end
assertGreater(self, getsizeof(a), orig_size)
@test (collect(a) == ["x", "y"])
@test (collect(b) == ["x", "y", "z"])
end

function test_splittable_setattr_after_pop(self)
#= setattr() must not convert combined table into split table. =#
mutable struct C <: AbstractC

end

a = C()
a.a = 1
assertTrue(self, dict_hassplittable(a.__dict__))
pop(a.__dict__, "a")
assertFalse(self, dict_hassplittable(a.__dict__))
a.a = 1
assertFalse(self, dict_hassplittable(a.__dict__))
a = C()
a.a = 2
assertTrue(self, dict_hassplittable(a.__dict__))
popitem(a.__dict__)
assertFalse(self, dict_hassplittable(a.__dict__))
a.a = 3
assertFalse(self, dict_hassplittable(a.__dict__))
end

function test_iterator_pickling(self)
for proto in 0:pickle.HIGHEST_PROTOCOL
data = Dict(1 => "a", 2 => "b", 3 => "c")
it = (x for x in data)
d = dumps(it, proto)
it = loads(d)
@test (collect(it) == collect(data))
it = loads(d)
try
drop = next(it)
catch exn
if exn isa StopIteration
continue;
end
end
d = dumps(it, proto)
it = loads(d)
#Delete Unsupported
del(data)
@test (collect(it) == collect(data))
end
end

function test_itemiterator_pickling(self)
for proto in 0:pickle.HIGHEST_PROTOCOL
data = Dict(1 => "a", 2 => "b", 3 => "c")
itorg = (x for x in collect(data))
d = dumps(itorg, proto)
it = loads(d)
@test isa(self, it)
@test (dict(it) == data)
it = loads(d)
drop = next(it)
d = dumps(it, proto)
it = loads(d)
#Delete Unsupported
del(data)
@test (dict(it) == data)
end
end

function test_valuesiterator_pickling(self)
for proto in 0:pickle.HIGHEST_PROTOCOL
data = Dict(1 => "a", 2 => "b", 3 => "c")
it = (x for x in values(data))
d = dumps(it, proto)
it = loads(d)
@test (collect(it) == collect(values(data)))
it = loads(d)
drop = next(it)
d = dumps(it, proto)
it = loads(d)
values = append!(collect(it), [drop])
@test (sorted(values) == sorted(collect(values(data))))
end
end

function test_reverseiterator_pickling(self)
for proto in 0:pickle.HIGHEST_PROTOCOL
data = Dict(1 => "a", 2 => "b", 3 => "c")
it = reversed(data)
d = dumps(it, proto)
it = loads(d)
@test (collect(it) == collect(reversed(data)))
it = loads(d)
try
drop = next(it)
catch exn
if exn isa StopIteration
continue;
end
end
d = dumps(it, proto)
it = loads(d)
#Delete Unsupported
del(data)
@test (collect(it) == collect(reversed(data)))
end
end

function test_reverseitemiterator_pickling(self)
for proto in 0:pickle.HIGHEST_PROTOCOL
data = Dict(1 => "a", 2 => "b", 3 => "c")
itorg = reversed(collect(data))
d = dumps(itorg, proto)
it = loads(d)
@test isa(self, it)
@test (dict(it) == data)
it = loads(d)
drop = next(it)
d = dumps(it, proto)
it = loads(d)
#Delete Unsupported
del(data)
@test (dict(it) == data)
end
end

function test_reversevaluesiterator_pickling(self)
for proto in 0:pickle.HIGHEST_PROTOCOL
data = Dict(1 => "a", 2 => "b", 3 => "c")
it = reversed(values(data))
d = dumps(it, proto)
it = loads(d)
@test (collect(it) == collect(reversed(values(data))))
it = loads(d)
drop = next(it)
d = dumps(it, proto)
it = loads(d)
values = append!(collect(it), [drop])
@test (sorted(values) == sorted(values(data)))
end
end

function test_instance_dict_getattr_str_subclass(self)
mutable struct Foo <: AbstractFoo
msg
end

f = Foo("123")
mutable struct _str <: Abstract_str

end

assertEqual(self, f.msg, getfield(f, :_str("msg")))
assertEqual(self, f.msg, f.__dict__[_str("msg")])
end

function test_object_set_item_single_instance_non_str_key(self)
mutable struct Foo <: AbstractFoo

end

f = Foo()
f.__dict__[1] = 1
f.a = "a"
assertEqual(self, f.__dict__, Dict(1 => 1, "a" => "a"))
end

function check_reentrant_insertion(self, mutate)
mutable struct Mutating <: AbstractMutating

end
function __del__(self)
mutate(d)
end

d = OrderedDict(k => Mutating() for k in "abcdefghijklmnopqr")
for k in collect(d)
d[k] = k
end
end

function test_reentrant_insertion(self)
function mutate(d)
d["b"] = 5
end

check_reentrant_insertion(self, mutate)
function mutate(d)
update(d, self.__dict__)
clear(d)
end

check_reentrant_insertion(self, mutate)
function mutate(d)
while d
popitem(d)
end
end

check_reentrant_insertion(self, mutate)
end

function test_merge_and_mutate(self)
mutable struct X <: AbstractX

end
function __hash__(self)::Int64
return 0
end

function __eq__(self, o)::Bool
clear(other)
return false
end

l = [(i, 0) for i in 1:1336]
other = dict(l)
other[X() + 1] = 0
d = OrderedDict(X() => 0, 1 => 1)
assertRaises(self, RuntimeError, d.update, other)
end

function test_free_after_iterating(self)
check_free_after_iterating(self, iter, dict)
check_free_after_iterating(self, (d) -> (x for x in keys(d)), dict)
check_free_after_iterating(self, (d) -> (x for x in values(d)), dict)
check_free_after_iterating(self, (d) -> (x for x in items(d)), dict)
end

function test_equal_operator_modifying_operand(self)
mutable struct X <: AbstractX

end
function __del__(self)
clear(dict_b)
end

function __eq__(self, other)::Bool
clear(dict_a)
return true
end

function __hash__(self)::Int64
return 13
end

dict_a = Dict(X() => 0)
dict_b = Dict(X() => X())
assertTrue(self, dict_a == dict_b)
mutable struct Y <: AbstractY

end
function __eq__(self, other)::Bool
clear(dict_d)
return true
end

dict_c = Dict(0 => Y())
dict_d = Dict(0 => set())
assertTrue(self, dict_c == dict_d)
end

function test_fromkeys_operator_modifying_dict_operand(self)
mutable struct X <: AbstractX

end
function __hash__(self)::Int64
return 13
end

function __eq__(self, other)::Bool
if length(d) > 1
clear(d)
end
return false
end

d = OrderedDict()
d = OrderedDict(X(1) => 1, X(2) => 2)
try
fromkeys(dict, d)
catch exn
if exn isa RuntimeError
#= pass =#
end
end
end

function test_fromkeys_operator_modifying_set_operand(self)
mutable struct X <: AbstractX

end
function __hash__(self)::Int64
return 13
end

function __eq__(self, other)::Bool
if length(d) > 1
clear(d)
end
return false
end

d = OrderedDict()
d = OrderedSet([X(1), X(2)])
try
fromkeys(dict, d)
catch exn
if exn isa RuntimeError
#= pass =#
end
end
end

function test_dictitems_contains_use_after_free(self)
mutable struct X <: AbstractX

end
function __eq__(self, other)
clear(d)
return NotImplemented
end

d = OrderedDict(0 => set())
(0, X()) ∈ collect(d)
end

function test_dict_contain_use_after_free(self)
mutable struct S <: AbstractS

end
function __eq__(self, other)
clear(d)
return NotImplemented
end

function __hash__(self)
return hash("test")
end

d = OrderedDict(S() => "value")
assertFalse(self, "test" ∈ keys(d))
end

function test_init_use_after_free(self)
mutable struct X <: AbstractX

end
function __hash__(self)::Int64
pair[begin:end] = []
return 13
end

pair = [X(), 123]
dict([pair])
end

function test_oob_indexing_dictiter_iternextitem(self)
mutable struct X <: AbstractX

end
function __del__(self)
clear(d)
end

d = OrderedDict(i => X(i) for i in 0:7)
function iter_and_mutate()
for result in collect(d)
if result[1] == 2
d[2] = nothing
end
end
end

assertRaises(self, RuntimeError, iter_and_mutate)
end

function test_reversed(self)
d = OrderedDict("a" => 1, "b" => 2, "foo" => 0, "c" => 3, "d" => 4)
#Delete Unsupported
del(d)
r = reversed(d)
@test (collect(r) == collect("dcba"))
@test_throws StopIteration next(r)
end

function test_reverse_iterator_for_empty_dict(self)
@test (collect(reversed(Dict())) == [])
@test (collect(reversed(collect(Dict()))) == [])
@test (collect(reversed(values(Dict()))) == [])
@test (collect(reversed(keys(Dict()))) == [])
@test (collect(reversed(dict())) == [])
@test (collect(reversed(items(dict()))) == [])
@test (collect(reversed(values(dict()))) == [])
@test (collect(reversed(keys(dict()))) == [])
end

function test_reverse_iterator_for_shared_shared_dicts(self)
mutable struct A <: AbstractA
x
y

            A(x, y) = begin
                if x
x = x
end
if y
y = y
end
                new(x, y)
            end
end

assertEqual(self, collect(reversed(A(1, 2).__dict__)), ["y", "x"])
assertEqual(self, collect(reversed(A(1, 0).__dict__)), ["x"])
assertEqual(self, collect(reversed(A(0, 1).__dict__)), ["y"])
end

function test_dict_copy_order(self)
od = OrderedDict([("a", 1), ("b", 2)])
move_to_end(od, "a")
expected = collect(collect(od))
copy = dict(od)
assertEqual(self, collect(collect(copy)), expected)
mutable struct CustomDict <: AbstractCustomDict

end

pairs = [("a", 1), ("b", 2), ("c", 3)]
d = CustomDict(pairs)
assertEqual(self, pairs, collect(collect(dict(d))))
mutable struct CustomReversedDict <: AbstractCustomReversedDict
__iter__

                    CustomReversedDict(__iter__ = keys) =
                        new(__iter__)
end
function keys(self)
return reversed(collect(keys(dict)))
end

function items(self)
return reversed(collect(dict))
end

d = CustomReversedDict(pairs)
assertEqual(self, pairs[end:-1:begin], collect(collect(dict(d))))
end

function test_dict_items_result_gc(self)
it = (x for x in collect(Dict(nothing => [])))
collect()
@test is_tracked(next(it))
end

function test_dict_items_result_gc_reversed(self)
it = reversed(collect(Dict(nothing => [])))
collect()
@test is_tracked(next(it))
end

function test_str_nonstr(self)
Channel() do ch_test_str_nonstr 
mutable struct StrSub <: AbstractStrSub

end

eq_count = 0
mutable struct Key3 <: AbstractKey3

end
function __hash__(self)
return hash("key3")
end

function __eq__(self, other)::Bool
# Not Supported
# nonlocal eq_count
if isa(other, Key3) || isa(other, str) && other == "key3"
eq_count += 1
return true
end
return false
end

key3_1 = StrSub("key3")
key3_2 = Key3()
key3_3 = Key3()
dicts = []
for key3 in (key3_1, key3_2)
push!(dicts, Dict("key1" => 42, "key2" => 43, key3 => 44))
d = OrderedDict("key1" => 42, "key2" => 43)
d[key3] = 44
push!(dicts, d)
d = OrderedDict("key1" => 42, "key2" => 43)
assertEqual(self, setdefault(d, key3, 44), 44)
push!(dicts, d)
d = OrderedDict("key1" => 42, "key2" => 43)
update(d, Dict(key3 => 44))
push!(dicts, d)
d = OrderedDict("key1" => 42, "key2" => 43)
d |= Dict(key3 => 44)
push!(dicts, d)
function make_pairs()
Channel() do ch_make_pairs 
put!(ch_make_pairs, ("key1", 42))
put!(ch_make_pairs, ("key2", 43))
put!(ch_make_pairs, (key3, 44))
end
end

d = dict(make_pairs())
push!(dicts, d)
d = copy(d)
push!(dicts, d)
d = OrderedDict(key => 42 + i for (i, key) in enumerate(["key1", "key2", key3]))
push!(dicts, d)
end
for d in dicts
subTest(self, d = d) do 
assertEqual(self, get(d, "key1"), 42)
noninterned_key1 = "ke"
noninterned_key1 += "y1"
if check_impl_detail(cpython = true)
interned_key1 = "key1"
assertFalse(self, noninterned_key1 === interned_key1)
end
assertEqual(self, get(d, noninterned_key1), 42)
assertEqual(self, get(d, "key3"), 44)
assertEqual(self, get(d, key3_1), 44)
assertEqual(self, get(d, key3_2), 44)
eq_count = 0
assertEqual(self, get(d, key3_3), 44)
assertGreaterEqual(self, eq_count, 1)
end
end
end
end

abstract type AbstractDictTest end
abstract type AbstractCustom <: dict end
abstract type AbstractDict <: dict end
abstract type AbstractExc <: Exception end
abstract type AbstractBadHash <: object end
abstract type Abstractbadseq <: object end
abstract type Abstractdictlike <: dict end
abstract type Abstractmydict <: dict end
abstract type Abstractbaddict1 <: dict end
abstract type AbstractBadSeq <: object end
abstract type Abstractbaddict2 <: dict end
abstract type Abstractbaddict3 <: dict end
abstract type AbstractHashed <: object end
abstract type AbstractBadRepr <: object end
abstract type AbstractBadCmp <: object end
abstract type AbstractD <: dict end
abstract type AbstractE <: dict end
abstract type AbstractF <: dict end
abstract type AbstractG <: dict end
abstract type AbstractCustomException <: Exception end
abstract type AbstractX <: int end
abstract type AbstractMyObject <: object end
abstract type AbstractMyDict <: dict end
abstract type Abstract_str <: str end
abstract type AbstractS <: str end
abstract type AbstractCustomDict <: dict end
abstract type AbstractCustomReversedDict <: dict end
abstract type AbstractStrSub <: str end
abstract type AbstractCAPITest end
abstract type AbstractGeneralMappingTests <: mapping_tests.BasicTestMappingProtocol end
abstract type AbstractSubclassMappingTests <: mapping_tests.BasicTestMappingProtocol end
mutable struct CAPITest <: AbstractCAPITest

end
function test_getitem_knownhash(self)
d = OrderedDict("x" => 1, "y" => 2, "z" => 3)
assertEqual(self, dict_getitem_knownhash(d, "x", hash("x")), 1)
assertEqual(self, dict_getitem_knownhash(d, "y", hash("y")), 2)
assertEqual(self, dict_getitem_knownhash(d, "z", hash("z")), 3)
assertRaises(self, SystemError, dict_getitem_knownhash, [], 1, hash(1))
assertRaises(self, KeyError, dict_getitem_knownhash, Dict(), 1, hash(1))
mutable struct Exc <: AbstractExc

end

mutable struct BadEq <: AbstractBadEq

end
function __eq__(self, other)
throw(Exc)
end

function __hash__(self)::Int64
return 7
end

k1, k2 = (BadEq(), BadEq())
d = OrderedDict(k1 => 1)
assertEqual(self, dict_getitem_knownhash(d, k1, hash(k1)), 1)
assertRaises(self, Exc, dict_getitem_knownhash, d, k2, hash(k2))
end


mutable struct GeneralMappingTests <: AbstractGeneralMappingTests
type2test

                    GeneralMappingTests(type2test = dict) =
                        new(type2test)
end

mutable struct Dict <: AbstractDict

end

mutable struct SubclassMappingTests <: AbstractSubclassMappingTests
type2test::Dict{Any}

                    SubclassMappingTests(type2test::Dict{Any} = Dict) =
                        new(type2test)
end

if abspath(PROGRAM_FILE) == @__FILE__
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
helper_keys_contained(dict_test)
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
_not_tracked(dict_test)
_tracked(dict_test)
test_track_literals(dict_test)
test_track_dynamic(dict_test)
test_track_subtypes(dict_test)
make_shared_key_dict(dict_test)
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
check_reentrant_insertion(dict_test)
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
end