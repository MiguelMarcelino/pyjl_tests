# Transpiled with flags: 
# - oop
using ObjectOriented
using OrderedCollections
using Random
using ResumableFunctions
using Test
import _testcapi
using _testcapi: dict_getitem_knownhash


import gc


import string




@resumable function g()
@yield 1
end

@oodef mutable struct Custom <: dict
                    
                    
                    
                end
                

@oodef mutable struct Dict <: dict
                    
                    
                    
                end
                

@oodef mutable struct BadEq <: object
                    
                    
                    
                end
                function __eq__(self::@like(BadEq), other)
throw(Exc())
end

function __hash__(self::@like(BadEq))::Int64
return 24
end


@oodef mutable struct Exc <: Exception
                    
                    
                    
                end
                

@oodef mutable struct BadHash <: object
                    
                    fail::Bool
                    
function new(fail::Bool = false)
fail = fail
new(fail)
end

                end
                function __hash__(self::@like(BadHash))::Int64
if self.fail
throw(Exc())
else
return 42
end
end


@oodef mutable struct SimpleUserDict
                    
                    d::Dict{Int64, Int64}
                    
function new(d::Dict{Int64, Int64} = Dict{Int64, Int64}(1 => 1, 2 => 2, 3 => 3))
@mk begin
d = d
end
end

                end
                function keys(self::@like(SimpleUserDict))
return keys(self.d)
end

function __getitem__(self::@like(SimpleUserDict), i)
return self.d[i]
end


@oodef mutable struct Exc <: Exception
                    
                    
                    
                end
                

@oodef mutable struct FailingUserDict
                    
                    
                    
                end
                function keys(self::@like(FailingUserDict))
throw(Exc)
end


@oodef mutable struct FailingUserDict
                    
                    
                    
                end
                function keys(self::@like(FailingUserDict))::BogonIter
return BogonIter()
end

function __getitem__(self::@like(FailingUserDict), key)
return key
end


@oodef mutable struct FailingUserDict
                    
                    
                    
                end
                function keys(self::@like(FailingUserDict))::BogonIter
return BogonIter()
end

function __getitem__(self::@like(FailingUserDict), key)
throw(Exc)
end


@oodef mutable struct badseq <: object
                    
                    
                    
                end
                function __iter__(self::@like(badseq))
return self
end

function __next__(self::@like(badseq))
throw(Exc())
end


@oodef mutable struct dictlike <: dict
                    
                    
                    
                end
                

@oodef mutable struct mydict <: dict
                    
                    
                    
                end
                function __new__(cls::@like(mydict))
return collections.UserDict()
end


@oodef mutable struct Exc <: Exception
                    
                    
                    
                end
                

@oodef mutable struct baddict1 <: dict
                    
                    
                    
function new()
throw(Exc())
@mk begin

end
end

                end
                

@oodef mutable struct BadSeq <: object
                    
                    
                    
                end
                function __iter__(self::@like(BadSeq))
return self
end

function __next__(self::@like(BadSeq))
throw(Exc())
end


@oodef mutable struct baddict2 <: dict
                    
                    
                    
                end
                function __setitem__(self::@like(baddict2), key, value)
throw(Exc())
end


@oodef mutable struct baddict3 <: dict
                    
                    
                    
                end
                function __new__(cls::@like(baddict3))::Dict
return d
end


@oodef mutable struct A
                    
                    
                    
                end
                

@oodef mutable struct Exc <: Exception
                    
                    
                    
                end
                

@oodef mutable struct BadHash <: object
                    
                    fail::Bool
                    
function new(fail::Bool = false)
fail = fail
new(fail)
end

                end
                function __hash__(self::@like(BadHash))::Int64
if self.fail
throw(Exc())
else
return 42
end
end


@oodef mutable struct Hashed <: object
                    
                    hash_count::Int64
eq_count::Int64
                    
function new(hash_count::Int64 = 0, eq_count::Int64 = 0)
@mk begin
hash_count = hash_count
eq_count = eq_count
end
end

                end
                function __hash__(self::@like(Hashed))::Int64
self.hash_count += 1
return 42
end

function __eq__(self::@like(Hashed), other)::Bool
self.eq_count += 1
return id() == id(other)
end


@oodef mutable struct Hashed <: object
                    
                    hash_count::Int64
eq_count::Int64
                    
function new(hash_count::Int64 = 0, eq_count::Int64 = 0)
@mk begin
hash_count = hash_count
eq_count = eq_count
end
end

                end
                function __hash__(self::@like(Hashed))::Int64
self.hash_count += 1
return 42
end

function __eq__(self::@like(Hashed), other)::Bool
self.eq_count += 1
return id() == id(other)
end


@oodef mutable struct Exc <: Exception
                    
                    
                    
                end
                

@oodef mutable struct BadHash <: object
                    
                    fail::Bool
                    
function new(fail::Bool = false)
fail = fail
new(fail)
end

                end
                function __hash__(self::@like(BadHash))::Int64
if self.fail
throw(Exc())
else
return 42
end
end


@oodef mutable struct NastyKey
                    
                    value
                    
function new(value, mutate_dict = nothing)
@mk begin
value = value
end
end

                end
                function __hash__(self::@like(NastyKey))::Int64
return 1
end

function __eq__(self::@like(NastyKey), other)::Bool
if NastyKey.mutate_dict
(mydict, key) = NastyKey.mutate_dict
NastyKey.mutate_dict = nothing
# Delete Unsupported
# del(mydict)
end
return self.value == other.value
end


@oodef mutable struct Exc <: Exception
                    
                    
                    
                end
                

@oodef mutable struct BadRepr <: object
                    
                    
                    
                end
                function Base.show(self::@like(BadRepr))
                throw(Exc())
            end

@oodef mutable struct Exc <: Exception
                    
                    
                    
                end
                

@oodef mutable struct BadCmp <: object
                    
                    
                    
                end
                function __eq__(self::@like(BadCmp), other)
throw(Exc())
end

function __hash__(self::@like(BadCmp))::Int64
return 1
end


@oodef mutable struct C
                    
                    
                    
                end
                function __eq__(self::@like(C), other)
throw(RuntimeError)
end


@oodef mutable struct D <: dict
                    
                    
                    
                end
                function __missing__(self::@like(D), key)::Int64
return 42
end


@oodef mutable struct E <: dict
                    
                    
                    
                end
                function __missing__(self::@like(E), key)
throw(ErrorException(key))
end


@oodef mutable struct F <: dict
                    
                    __missing__
                    
function new(__missing__ = (key) -> nothing)
@mk begin
__missing__ = __missing__
end
end

                end
                

@oodef mutable struct G <: dict
                    
                    
                    
                end
                

@oodef mutable struct CustomException <: Exception
                    
                    
                    
                end
                

@oodef mutable struct BadDictKey
                    
                    
                    
                end
                function __hash__(self::@like(BadDictKey))
return hash(self.__class__)
end

function __eq__(self::@like(BadDictKey), other)
if isa(other, self.__class__)
throw(CustomException)
end
return other
end


@oodef mutable struct X <: object
                    
                    
                    
                end
                function __hash__(self::@like(X))::Int64
return 5
end

function __eq__(self::@like(X), other)::Bool
if resizing
clear(d)
end
return false
end


@oodef mutable struct C <: object
                    
                    
                    
                end
                

@oodef mutable struct MyObject <: object
                    
                    
                    
                end
                

@oodef mutable struct MyDict <: dict
                    
                    
                    
                end
                

@oodef mutable struct C
                    
                    
                    
                end
                

@oodef mutable struct C
                    
                    
                    
                end
                

@oodef mutable struct Foo
                    
                    msg
                    
function new(msg)
@mk begin
msg = msg
end
end

                end
                

@oodef mutable struct _str <: String
                    
                    
                    
                end
                

@oodef mutable struct Foo
                    
                    
                    
                end
                

@oodef mutable struct Mutating
                    
                    
                    
                end
                function __del__(self::@like(Mutating))
mutate(d)
end


@oodef mutable struct X
                    
                    
                    
                end
                function __hash__(self::@like(X))::Int64
return 0
end

function __eq__(self::@like(X), o)::Bool
clear(other)
return false
end


@oodef mutable struct X
                    
                    
                    
                end
                function __del__(self::@like(X))
clear(dict_b)
end

function __eq__(self::@like(X), other)::Bool
clear(dict_a)
return true
end

function __hash__(self::@like(X))::Int64
return 13
end


@oodef mutable struct Y
                    
                    
                    
                end
                function __eq__(self::@like(Y), other)::Bool
clear(dict_d)
return true
end


@oodef mutable struct X <: Int64
                    
                    
                    
                end
                function __hash__(self::@like(X))::Int64
return 13
end

function __eq__(self::@like(X), other)::Bool
if length(d) > 1
clear(d)
end
return false
end


@oodef mutable struct X <: Int64
                    
                    
                    
                end
                function __hash__(self::@like(X))::Int64
return 13
end

function __eq__(self::@like(X), other)::Bool
if length(d) > 1
clear(d)
end
return false
end


@oodef mutable struct X
                    
                    
                    
                end
                function __eq__(self::@like(X), other)
clear(d)
return NotImplemented
end


@oodef mutable struct S <: String
                    
                    
                    
                end
                function __eq__(self::@like(S), other)
clear(d)
return NotImplemented
end

function __hash__(self::@like(S))
return hash("test")
end


@oodef mutable struct X
                    
                    
                    
                end
                function __hash__(self::@like(X))::Int64
pair[begin:end] = []
return 13
end


@oodef mutable struct X <: Int64
                    
                    
                    
                end
                function __del__(self::@like(X))
clear(d)
end


@oodef mutable struct A
                    
                    x
y
                    
function new(x, y)
if x
self.x = x
end
if y
self.y = y
end
@mk begin
x = x
y = y
end
end

                end
                

@oodef mutable struct CustomDict <: dict
                    
                    
                    
                end
                

@oodef mutable struct CustomReversedDict <: dict
                    
                    __iter__
                    
function new(__iter__ = keys)
__iter__ = __iter__
new(__iter__)
end

                end
                function keys(self::@like(CustomReversedDict))
return reversed(collect(keys(dict)))
end

function items(self::@like(CustomReversedDict))
return reversed(collect(self))
end


@oodef mutable struct StrSub <: String
                    
                    
                    
                end
                

@oodef mutable struct Key3
                    
                    
                    
                end
                function __hash__(self::@like(Key3))
return hash("key3")
end

function __eq__(self::@like(Key3), other)::Bool
# Not Supported
# nonlocal eq_count
if isa(other, Key3)||isa(other, String)&&other == "key3"
eq_count += 1
return true
end
return false
end


@oodef mutable struct BogonIter
                    
                    i::Int64
                    
function new(i::Int64 = 1)
@mk begin
i = i
end
end

                end
                function __iter__(self::@like(BogonIter))
return self
end

function __next__(self::@like(BogonIter))::String
if self.i != 0
self.i = 0
return "a"
end
throw(Exc)
end


@oodef mutable struct BogonIter
                    
                    i
                    
function new(i = Int(codepoint('a')))
@mk begin
i = i
end
end

                end
                function __iter__(self::@like(BogonIter))
return self
end

function __next__(self::@like(BogonIter))
if self.i <= Int(codepoint('z'))
rtn = Char(self.i)
self.i += 1
return rtn
end
throw(StopIteration)
end


@oodef mutable struct DictTest <: unittest.TestCase
                    
                    
                    
                end
                function test_invalid_keyword_arguments(self::@like(DictTest))
for invalid in (Dict{int, int}(1 => 2), Custom(Dict{int, int}(1 => 2)))
@test_throws TypeError do 
dict(None = invalid)
end
@test_throws TypeError do 
update(Dict(), None = invalid)
end
end
end

function test_constructor(self::@like(DictTest))
@test (dict() == Dict())
assertIsNot(self, dict(), Dict())
end

function test_literal_constructor(self::@like(DictTest))
for n in (0, 1, 6, 256, 400)
items = [(join(random.sample(string.ascii_letters, 8), ""), i) for i in 0:n - 1]
shuffle(items)
formatted_items = ("$(k): :d" for (k, v) in items)
dictliteral = ("{" + join(formatted_items, ", ")) + "}"
@test (py"dictliteral" == dict(items))
end
end

function test_merge_operator(self::@like(DictTest))
a = Dict{Int64, Int64}(0 => 0, 1 => 1, 2 => 1)
b = Dict{Int64, Int64}(1 => 1, 2 => 2, 3 => 3)
c = copy(a)
c |= b
@test (a | b == Dict{int, int}(0 => 0, 1 => 1, 2 => 2, 3 => 3))
@test (c == Dict{int, int}(0 => 0, 1 => 1, 2 => 2, 3 => 3))
c = copy(b)
c |= a
@test (b | a == Dict{int, int}(1 => 1, 2 => 1, 3 => 3, 0 => 0))
@test (c == Dict{int, int}(1 => 1, 2 => 1, 3 => 3, 0 => 0))
c = copy(a)
c |= [(1, 1), (2, 2), (3, 3)]
@test (c == Dict{int, int}(0 => 0, 1 => 1, 2 => 2, 3 => 3))
@test self === __or__(a, nothing)
@test self === __or__(a, ())
@test self === __or__(a, "BAD")
@test self === __or__(a, "")
@test_throws
@test (__ior__(a, ()) == Dict{int, int}(0 => 0, 1 => 1, 2 => 1))
@test_throws
@test (__ior__(a, "") == Dict{int, int}(0 => 0, 1 => 1, 2 => 1))
end

function test_bool(self::@like(DictTest))
@test self === !(Dict())
@test Dict{int, int}(1 => 2)
@test self === Bool(Dict())
@test self === Bool(Dict{int, int}(1 => 2))
end

function test_keys(self::@like(DictTest))
d = OrderedDict()
@test (Set(keys(d)) == Set())
d = OrderedDict("a" => 1, "b" => 2)
k = keys(d)
@test (Set(k) == Set(["a", "b"]))
assertIn(self, "a", k)
assertIn(self, "b", k)
assertIn(self, "a", d)
assertIn(self, "b", d)
@test_throws
@test (repr(keys(dict(a = 1))) == "dict_keys([\'a\'])")
end

function test_values(self::@like(DictTest))
d = OrderedDict()
@test (Set(values(d)) == Set())
d = OrderedDict(1 => 2)
@test (Set(values(d)) == Set([2]))
@test_throws
@test (repr(values(dict(a = 1))) == "dict_values([1])")
end

function test_items(self::@like(DictTest))
d = OrderedDict()
@test (Set(collect(d)) == Set())
d = OrderedDict(1 => 2)
@test (Set(collect(d)) == Set([(1, 2)]))
@test_throws
@test (repr(items(dict(a = 1))) == "dict_items([(\'a\', 1)])")
end

function test_views_mapping(self::@like(DictTest))
mappingproxy = type_(type_.__dict__)
for cls in [dict, Dict]
d = cls()
m1 = keys(d).mapping
m2 = values(d).mapping
m3 = collect(d).mapping
for m in [m1, m2, m3]
@test isa(self, m)
@test (m == d)
end
d["foo"] = "bar"
for m in [m1, m2, m3]
@test isa(self, m)
@test (m == d)
end
end
end

function test_contains(self::@like(DictTest))
d = OrderedDict()
assertNotIn(self, "a", d)
@test !("a" ∈ d)
@test "a" ∉ d
d = OrderedDict("a" => 1, "b" => 2)
assertIn(self, "a", d)
assertIn(self, "b", d)
assertNotIn(self, "c", d)
@test_throws
end

function test_len(self::@like(DictTest))
d = OrderedDict()
@test (length(d) == 0)
d = OrderedDict("a" => 1, "b" => 2)
@test (length(d) == 2)
end

function test_getitem(self::@like(DictTest))
d = OrderedDict("a" => 1, "b" => 2)
@test (d["a"] == 1)
@test (d["b"] == 2)
d["c"] = 3
d["a"] = 4
@test (d["c"] == 3)
@test (d["a"] == 4)
# Delete Unsupported
# del(d)
@test (d == Dict{str, int}("a" => 4, "c" => 3))
@test_throws
d = OrderedDict()
d[BadEq()] = 42
@test_throws
x = BadHash()
d[x] = 42
x.fail = true
@test_throws
end

function test_clear(self::@like(DictTest))
d = OrderedDict(1 => 1, 2 => 2, 3 => 3)
clear(d)
@test (d == Dict())
@test_throws
end

function test_update(self::@like(DictTest))
d = OrderedDict()
update(d, Dict{int, int}(1 => 100))
update(d, Dict{int, int}(2 => 20))
update(d, Dict{int, int}(1 => 1, 2 => 2, 3 => 3))
@test (d == Dict{int, int}(1 => 1, 2 => 2, 3 => 3))
update(d)
@test (d == Dict{int, int}(1 => 1, 2 => 2, 3 => 3))
@test_throws
clear(d)
update(d, SimpleUserDict())
@test (d == Dict{int, int}(1 => 1, 2 => 2, 3 => 3))
clear(d)
@test_throws
@test_throws
@test_throws
@test_throws
@test_throws
end

function test_fromkeys(self::@like(DictTest))
@test (fromkeys(dict, "abc") == Dict{str, Any}("a" => nothing, "b" => nothing, "c" => nothing))
d = OrderedDict()
assertIsNot(self, fromkeys(d, "abc"), d)
@test (fromkeys(d, "abc") == Dict{str, Any}("a" => nothing, "b" => nothing, "c" => nothing))
@test (fromkeys(d, (4, 5), 0) == Dict{int, int}(4 => 0, 5 => 0))
@test (fromkeys(d, []) == Dict())
@test (fromkeys(d, g()) == Dict{int, Any}(1 => nothing))
@test_throws
@test (dictlike.fromkeys("a") == Dict{str, Any}("a" => nothing))
@test (fromkeys(dictlike(), "a") == Dict{str, Any}("a" => nothing))
@test isa(self, dictlike.fromkeys("a"))
@test isa(self, fromkeys(dictlike(), "a"))
ud = mydict.fromkeys("ab")
@test (ud == Dict{str, Any}("a" => nothing, "b" => nothing))
@test isa(self, ud)
@test_throws
@test_throws
@test_throws
@test_throws
d = dict(zip(0:5, 0:5))
@test (fromkeys(dict, d, 0) == dict(zip(0:5, repeat([0],6))))
d = Dict(i => i for i in 0:9)
res = copy(d)
update(res, a = nothing, b = nothing, c = nothing)
@test (baddict3.fromkeys(Set(["a", "b", "c"])) == res)
end

function test_copy(self::@like(DictTest))
d = OrderedDict(1 => 1, 2 => 2, 3 => 3)
assertIsNot(self, copy_(d), d)
@test (copy_(d) == d)
@test (copy_(d) == Dict{int, int}(1 => 1, 2 => 2, 3 => 3))
copy_ = copy_(d)
d[4] = 4
@test (copy_ != d)
@test (copy_(Dict()) == Dict())
@test_throws
end

function test_copy_fuzz(self::@like(DictTest))
for dict_size in [10, 100, 1000, 10000, 100000]
dict_size = random.randrange(dict_size ÷ 2, dict_size + (dict_size ÷ 2))
subTest(self, dict_size = dict_size) do 
d = OrderedDict()
for i in 0:dict_size - 1
d[i] = i
end
d2 = copy(d)
assertIsNot(self, d2, d)
@test (d == d2)
d2["key"] = "value"
@test (d != d2)
@test (length(d2) == length(d) + 1)
end
end
end

function test_copy_maintains_tracking(self::@like(DictTest))
key = A()
for d in (Dict(), Dict{str, int}("a" => 1), Dict{A, str}(key => "val"))
d2 = copy(d)
@test (gc.is_tracked(d) == gc.is_tracked(d2))
end
end

function test_copy_noncompact(self::@like(DictTest))
d = Dict(k => k for k in 0:999)
for k in 0:949
# Delete Unsupported
# del(d)
end
d2 = copy(d)
@test (d2 == d)
end

function test_get(self::@like(DictTest))
d = OrderedDict()
@test self === get(d, "c")
@test (get(d, "c", 3) == 3)
d = OrderedDict("a" => 1, "b" => 2)
@test self === get(d, "c")
@test (get(d, "c", 3) == 3)
@test (get(d, "a") == 1)
@test (get(d, "a", 3) == 1)
@test_throws
@test_throws
end

function test_setdefault(self::@like(DictTest))
d = OrderedDict()
@test self === setdefault(d, "key0")
setdefault(d, "key0", [])
@test self === setdefault(d, "key0")
append(setdefault(d, "key", []), 3)
@test (d["key"][0] == 3)
append(setdefault(d, "key", []), 4)
@test (length(d["key"]) == 2)
@test_throws
x = BadHash()
d[x] = 42
x.fail = true
@test_throws
end

function test_setdefault_atomic(self::@like(DictTest))
hashed1 = Hashed()
y = Dict{Hashed, Int64}(hashed1 => 5)
hashed2 = Hashed()
setdefault(y, hashed2, [])
@test (hashed1.hash_count == 1)
@test (hashed2.hash_count == 1)
@test (hashed1.eq_count + hashed2.eq_count == 1)
end

function test_setitem_atomic_at_resize(self::@like(DictTest))
hashed1 = Hashed()
y = Dict{Any, Int64}(hashed1 => 5, 0 => 0, 1 => 1, 2 => 2, 3 => 3)
hashed2 = Hashed()
y[hashed2] = []
@test (hashed1.hash_count == 1)
@test (hashed2.hash_count == 1)
@test (hashed1.eq_count + hashed2.eq_count == 1)
end

function test_popitem(self::@like(DictTest))
for copymode in (-1, +1)
for log2size in 0:11
size_ = 2^log2size
a = Dict()
b = Dict()
for i in 0:size_ - 1
a[repr(i)] = i
if copymode < 0
b[repr(i)] = i
end
end
if copymode > 0
b = copy(a)
end
for i in 0:size_ - 1
(ka, va)=ta = popitem(a)
@test (va == parse(Int, ka))
(kb, vb)=tb = popitem(b)
@test (vb == parse(Int, kb))
@test !(copymode < 0&&ta != tb)
end
@test !(a)
@test !(b)
end
end
d = OrderedDict()
@test_throws
end

function test_pop(self::@like(DictTest))
d = OrderedDict()
(k, v) = ("abc", "def")
d[k] = v
@test_throws
@test (pop(d, k) == v)
@test (length(d) == 0)
@test_throws
@test (pop(d, k, v) == v)
d[k] = v
@test (pop(d, k, 1) == v)
@test_throws
x = BadHash()
d[x] = 42
x.fail = true
@test_throws
end

function test_mutating_iteration(self::@like(DictTest))
d = OrderedDict()
d[1] = 1
@test_throws RuntimeError do 
for i in d
d[i + 1] = 1
end
end
end

function test_mutating_iteration_delete(self::@like(DictTest))
d = OrderedDict()
d[0] = 0
@test_throws RuntimeError do 
for i in d
# Delete Unsupported
# del(d)
d[0] = 0
end
end
end

function test_mutating_iteration_delete_over_values(self::@like(DictTest))
d = OrderedDict()
d[0] = 0
@test_throws RuntimeError do 
for i in values(d)
# Delete Unsupported
# del(d)
d[0] = 0
end
end
end

function test_mutating_iteration_delete_over_items(self::@like(DictTest))
d = OrderedDict()
d[0] = 0
@test_throws RuntimeError do 
for i in collect(d)
# Delete Unsupported
# del(d)
d[0] = 0
end
end
end

function test_mutating_lookup(self::@like(DictTest))
key1 = NastyKey(1)
key2 = NastyKey(2)
d = OrderedDict(key1 => 1)
NastyKey.mutate_dict = (d, key1)
d[key2] = 2
@test (d == Dict{NastyKey, int}(key2 => 2))
end

function test_repr(self::@like(DictTest))
d = OrderedDict()
@test (repr(d) == "{}")
d[1] = 2
@test (repr(d) == "{1: 2}")
d = OrderedDict()
d[1] = d
@test (repr(d) == "{1: {...}}")
d = OrderedDict(1 => BadRepr())
@test_throws
end

function test_repr_deep(self::@like(DictTest))
d = OrderedDict()
for i in 0:sys.getrecursionlimit() + 99
d = OrderedDict(1 => d)
end
@test_throws
end

function test_eq(self::@like(DictTest))
@test (Dict() == Dict())
@test (Dict{int, int}(1 => 2) == Dict{int, int}(1 => 2))
d1 = Dict{BadCmp, Int64}(BadCmp() => 1)
d2 = Dict{Int64, Int64}(1 => 1)
@test_throws Exc do 
d1 == d2
end
end

function test_keys_contained(self::@like(DictTest))
helper_keys_contained(self, (x) -> keys(x))
helper_keys_contained(self, (x) -> items(x))
end

function helper_keys_contained(self::@like(DictTest), fn)
empty_ = fn(dict())
empty2 = fn(dict())
smaller = fn(Dict{int, int}(1 => 1, 2 => 2))
larger = fn(Dict{int, int}(1 => 1, 2 => 2, 3 => 3))
larger2 = fn(Dict{int, int}(1 => 1, 2 => 2, 3 => 3))
larger3 = fn(Dict{int, int}(4 => 1, 2 => 2, 3 => 3))
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
@test empty_ == empty2
@test !(empty_ != empty2)
@test !(empty_ == smaller)
@test empty_ != smaller
@test larger != larger3
@test !(larger == larger3)
end

function test_errors_in_view_containment_check(self::@like(DictTest))
d1 = Dict{Int64, C}(1 => C())
d2 = Dict{Int64, C}(1 => C())
@test_throws RuntimeError do 
collect(d1) == collect(d2)
end
@test_throws RuntimeError do 
collect(d1) != collect(d2)
end
@test_throws RuntimeError do 
collect(d1) <= collect(d2)
end
@test_throws RuntimeError do 
collect(d1) >= collect(d2)
end
d3 = Dict{Int64, C}(1 => C(), 2 => C())
@test_throws RuntimeError do 
collect(d2) < collect(d3)
end
@test_throws RuntimeError do 
collect(d3) > collect(d2)
end
end

function test_dictview_set_operations_on_keys(self::@like(DictTest))
k1 = keys(Dict{int, int}(1 => 1, 2 => 2))
k2 = keys(Dict{int, int}(1 => 1, 2 => 2, 3 => 3))
k3 = keys(Dict{int, int}(4 => 4))
@test (k1 - k2 == Set())
@test (k1 - k3 == Set([1, 2]))
@test (k2 - k1 == Set([3]))
@test (k3 - k1 == Set([4]))
@test (k1 & k2 == Set([1, 2]))
@test (k1 & k3 == Set())
@test (k1 | k2 == Set([1, 2, 3]))
@test (k1 ⊻ k2 == Set([3]))
@test (k1 ⊻ k3 == Set([1, 2, 4]))
end

function test_dictview_set_operations_on_items(self::@like(DictTest))
k1 = collect(Dict{int, int}(1 => 1, 2 => 2))
k2 = collect(Dict{int, int}(1 => 1, 2 => 2, 3 => 3))
k3 = collect(Dict{int, int}(4 => 4))
@test (k1 - k2 == Set())
@test (k1 - k3 == Set([(1, 1), (2, 2)]))
@test (k2 - k1 == Set([(3, 3)]))
@test (k3 - k1 == Set([(4, 4)]))
@test (k1 & k2 == Set([(1, 1), (2, 2)]))
@test (k1 & k3 == Set())
@test (k1 | k2 == Set([(1, 1), (2, 2), (3, 3)]))
@test (k1 ⊻ k2 == Set([(3, 3)]))
@test (k1 ⊻ k3 == Set([(1, 1), (2, 2), (4, 4)]))
end

function test_items_symmetric_difference(self::@like(DictTest))
rr = random.randrange
for _ in 0:99
left = Dict(x => rr(3) for x in 0:19 if rr(2) )
right = Dict(x => rr(3) for x in 0:19 if rr(2) )
subTest(self, left = left, right = right) do 
expected = Set(items(left)) ⊻ Set(items(right))
actual = items(left) ⊻ items(right)
@test (actual == expected)
end
end
end

function test_dictview_mixed_set_operations(self::@like(DictTest))
@test keys(Dict{int, int}(1 => 1)) == Set([1])
@test Set([1]) == keys(Dict{int, int}(1 => 1))
@test (keys(Dict{int, int}(1 => 1)) | Set([2]) == Set([1, 2]))
@test (Set([2]) | keys(Dict{int, int}(1 => 1)) == Set([1, 2]))
@test collect(Dict{int, int}(1 => 1)) == Set([(1, 1)])
@test Set([(1, 1)]) == collect(Dict{int, int}(1 => 1))
@test (collect(Dict{int, int}(1 => 1)) | Set([2]) == Set([(1, 1), 2]))
@test (Set([2]) | collect(Dict{int, int}(1 => 1)) == Set([(1, 1), 2]))
end

function test_missing(self::@like(DictTest))
@test !(hasfield(typeof(dict), :__missing__))
@test !(hasfield(typeof(Dict()), :__missing__))
d = D(Dict{int, int}(1 => 2, 3 => 4))
@test (d[2] == 2)
@test (d[4] == 4)
assertNotIn(self, 2, d)
assertNotIn(self, 2, keys(d))
@test (d[3] == 42)
e = E()
@test_throws RuntimeError do c 
e[43]
end
@test (c.exception.args == (42,))
f = F()
@test_throws KeyError do c 
f[43]
end
@test (c.exception.args == (42,))
g = G()
@test_throws KeyError do c 
g[43]
end
@test (c.exception.args == (42,))
end

function test_tuple_keyerror(self::@like(DictTest))
d = OrderedDict()
@test_throws KeyError do c 
d[(1,)]
end
@test (c.exception.args == ((1,),))
end

function test_bad_key(self::@like(DictTest))
d = OrderedDict()
x1 = BadDictKey()
x2 = BadDictKey()
d[x1] = 1
for stmt in ["d[x2] = 2", "z = d[x2]", "x2 in d", "d.get(x2)", "d.setdefault(x2, 42)", "d.pop(x2)", "d.update({x2: 2})"]
@test_throws CustomException do 
py"""stmt, locals()"""
end
end
end

function test_resize1(self::@like(DictTest))
d = OrderedDict()
for i in 0:4
d[i] = i
end
for i in 0:4
# Delete Unsupported
# del(d)
end
for i in 5:8
d[i] = i
end
end

function test_resize2(self::@like(DictTest))
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

function test_empty_presized_dict_in_freelist(self::@like(DictTest))
@test_throws ZeroDivisionError do 
d = OrderedDict("a" => 1 ÷ 0, "b" => nothing, "c" => nothing, "d" => nothing, "e" => nothing, "f" => nothing, "g" => nothing, "h" => nothing)
end
d = OrderedDict()
end

function test_container_iterator(self::@like(DictTest))
views = (collect(dict), dict.values, dict.keys)
for v in views
obj = C()
ref = weakref.ref(obj)
container = Dict{C, Int64}(obj => 1)
obj.v = v(container)
obj.x = (x for x in obj.v)
# Delete Unsupported
# del(container)
gc.collect()
@test self === ref()
end
end

function _not_tracked(self::@like(DictTest), t)
gc.collect()
gc.collect()
@test !(gc.is_tracked(t))
end

function _tracked(self::@like(DictTest), t)
@test gc.is_tracked(t)
gc.collect()
gc.collect()
@test gc.is_tracked(t)
end

function test_track_literals(self::@like(DictTest))
(x, y, z, w) = (1.5, "a", (1, nothing), [])
_not_tracked(self, Dict())
_not_tracked(self, Dict(x => (), y => x, z => 1))
_not_tracked(self, Dict(1 => "a", "b" => 2))
_not_tracked(self, Dict(1 => 2, (nothing, true, false, ()) => Int64))
_not_tracked(self, Dict{int, Any}(1 => object()))
_tracked(self, Dict{int, List}(1 => []))
_tracked(self, Dict{int, Tuple[List]}(1 => ([],)))
_tracked(self, Dict{int, Dict}(1 => Dict()))
_tracked(self, Dict{int, Any}(1 => Set()))
end

function test_track_dynamic(self::@like(DictTest))
(x, y, z, w, o) = (1.5, "a", (1, object()), [], MyObject())
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

function test_track_subtypes(self::@like(DictTest))
_tracked(self, MyDict())
end

function make_shared_key_dict(self::@like(DictTest), n)::Vector
dicts = []
for i in 0:n - 1
a = C()
(a.x, a.y, a.z) = (1, 2, 3)
push!(dicts, a.__dict__)
end
return dicts
end

function test_splittable_setdefault(self::@like(DictTest))
#= split table must be combined when setdefault()
        breaks insertion order =#
(a, b) = make_shared_key_dict(self, 2)
a["a"] = 1
size_a = sys.getsizeof(a)
a["b"] = 2
setdefault(b, "b", 2)
size_b = sys.getsizeof(b)
b["a"] = 1
assertGreater(self, size_b, size_a)
@test (collect(a) == ["x", "y", "z", "a", "b"])
@test (collect(b) == ["x", "y", "z", "b", "a"])
end

function test_splittable_del(self::@like(DictTest))
#= split table must be combined when del d[k] =#
(a, b) = make_shared_key_dict(self, 2)
orig_size = sys.getsizeof(a)
# Delete Unsupported
# del(a)
@test_throws KeyError do 
# Delete Unsupported
# del(a)
end
assertGreater(self, sys.getsizeof(a), orig_size)
@test (collect(a) == ["x", "z"])
@test (collect(b) == ["x", "y", "z"])
a["y"] = 42
@test (collect(a) == ["x", "z", "y"])
@test (collect(b) == ["x", "y", "z"])
end

function test_splittable_pop(self::@like(DictTest))
#= split table must be combined when d.pop(k) =#
(a, b) = make_shared_key_dict(self, 2)
orig_size = sys.getsizeof(a)
pop(a, "y")
@test_throws KeyError do 
pop(a, "y")
end
assertGreater(self, sys.getsizeof(a), orig_size)
@test (collect(a) == ["x", "z"])
@test (collect(b) == ["x", "y", "z"])
a["y"] = 42
@test (collect(a) == ["x", "z", "y"])
@test (collect(b) == ["x", "y", "z"])
end

function test_splittable_pop_pending(self::@like(DictTest))
#= pop a pending key in a split table should not crash =#
(a, b) = make_shared_key_dict(self, 2)
a["a"] = 4
@test_throws KeyError do 
pop(b, "a")
end
end

function test_splittable_popitem(self::@like(DictTest))
#= split table must be combined when d.popitem() =#
(a, b) = make_shared_key_dict(self, 2)
orig_size = sys.getsizeof(a)
item = popitem(a)
@test (item == ("z", 3))
@test_throws KeyError do 
# Delete Unsupported
# del(a)
end
assertGreater(self, sys.getsizeof(a), orig_size)
@test (collect(a) == ["x", "y"])
@test (collect(b) == ["x", "y", "z"])
end

function test_splittable_setattr_after_pop(self::@like(DictTest))
#= setattr() must not convert combined table into split table. =#
a = C()
a.a = 1
@test _testcapi.dict_hassplittable(a.__dict__)
pop(a.__dict__, "a")
@test !(_testcapi.dict_hassplittable(a.__dict__))
a.a = 1
@test !(_testcapi.dict_hassplittable(a.__dict__))
a = C()
a.a = 2
@test _testcapi.dict_hassplittable(a.__dict__)
popitem(a.__dict__)
@test !(_testcapi.dict_hassplittable(a.__dict__))
a.a = 3
@test !(_testcapi.dict_hassplittable(a.__dict__))
end

function test_iterator_pickling(self::@like(DictTest))
for proto in 0:pickle.HIGHEST_PROTOCOL
data = Dict{Int64, String}(1 => "a", 2 => "b", 3 => "c")
it = (x for x in data)
d = pickle.dumps(it, proto)
it = pickle.loads(d)
@test (collect(it) == collect(data))
it = pickle.loads(d)
try
drop = next(it)
catch exn
if exn isa StopIteration
continue;
end
end
d = pickle.dumps(it, proto)
it = pickle.loads(d)
# Delete Unsupported
# del(data)
@test (collect(it) == collect(data))
end
end

function test_itemiterator_pickling(self::@like(DictTest))
for proto in 0:pickle.HIGHEST_PROTOCOL
data = Dict{Int64, String}(1 => "a", 2 => "b", 3 => "c")
itorg = (x for x in collect(data))
d = pickle.dumps(itorg, proto)
it = pickle.loads(d)
@test isa(self, it)
@test (dict(it) == data)
it = pickle.loads(d)
drop = next(it)
d = pickle.dumps(it, proto)
it = pickle.loads(d)
# Delete Unsupported
# del(data)
@test (dict(it) == data)
end
end

function test_valuesiterator_pickling(self::@like(DictTest))
for proto in 0:pickle.HIGHEST_PROTOCOL
data = Dict{Int64, String}(1 => "a", 2 => "b", 3 => "c")
it = (x for x in values_(data))
d = pickle.dumps(it, proto)
it = pickle.loads(d)
@test (collect(it) == collect(values_(data)))
it = pickle.loads(d)
drop = next(it)
d = pickle.dumps(it, proto)
it = pickle.loads(d)
values_ = [collect(it); [drop]]
@test (sorted(values_) == sorted(collect(values_(data))))
end
end

function test_reverseiterator_pickling(self::@like(DictTest))
for proto in 0:pickle.HIGHEST_PROTOCOL
data = Dict{Int64, String}(1 => "a", 2 => "b", 3 => "c")
it = reversed(data)
d = pickle.dumps(it, proto)
it = pickle.loads(d)
@test (collect(it) == collect(reversed(data)))
it = pickle.loads(d)
try
drop = next(it)
catch exn
if exn isa StopIteration
continue;
end
end
d = pickle.dumps(it, proto)
it = pickle.loads(d)
# Delete Unsupported
# del(data)
@test (collect(it) == collect(reversed(data)))
end
end

function test_reverseitemiterator_pickling(self::@like(DictTest))
for proto in 0:pickle.HIGHEST_PROTOCOL
data = Dict{Int64, String}(1 => "a", 2 => "b", 3 => "c")
itorg = reversed(collect(data))
d = pickle.dumps(itorg, proto)
it = pickle.loads(d)
@test isa(self, it)
@test (dict(it) == data)
it = pickle.loads(d)
drop = next(it)
d = pickle.dumps(it, proto)
it = pickle.loads(d)
# Delete Unsupported
# del(data)
@test (dict(it) == data)
end
end

function test_reversevaluesiterator_pickling(self::@like(DictTest))
for proto in 0:pickle.HIGHEST_PROTOCOL
data = Dict{Int64, String}(1 => "a", 2 => "b", 3 => "c")
it = reversed(values_(data))
d = pickle.dumps(it, proto)
it = pickle.loads(d)
@test (collect(it) == collect(reversed(values_(data))))
it = pickle.loads(d)
drop = next(it)
d = pickle.dumps(it, proto)
it = pickle.loads(d)
values_ = [collect(it); [drop]]
@test (sorted(values_) == sorted(values_(data)))
end
end

function test_instance_dict_getattr_str_subclass(self::@like(DictTest))
f = Foo("123")
@test (f.msg == getfield(f, :_str("msg")))
@test (f.msg == f.__dict__[_str("msg")])
end

function test_object_set_item_single_instance_non_str_key(self::@like(DictTest))
f = Foo()
f.__dict__[Symbol(1)] = 1
f.a = "a"
@test (f.__dict__ == Dict(1 => 1, "a" => "a"))
end

function check_reentrant_insertion(self::@like(DictTest), mutate)
d = Dict(k => Mutating() for k in "abcdefghijklmnopqr")
for k in collect(d)
d[k + 1] = k
end
end

function test_reentrant_insertion(self::@like(DictTest))
function mutate(d::@like(DictTest))
d["b"] = 5
end

check_reentrant_insertion(self, mutate)
function mutate(d::@like(DictTest))
update(d, self.__dict__)
clear(d)
end

check_reentrant_insertion(self, mutate)
function mutate(d::@like(DictTest))
while d
popitem(d)
end
end

check_reentrant_insertion(self, mutate)
end

function test_merge_and_mutate(self::@like(DictTest))
l = [(i, 0) for i in 1:1336]
other = dict(l)
other[X() + 1] = 0
d = OrderedDict(X() => 0, 1 => 1)
@test_throws
end

function test_free_after_iterating(self::@like(DictTest))
support.check_free_after_iterating(iter, dict)
support.check_free_after_iterating((d) -> (x for x in keys(d)), dict)
support.check_free_after_iterating((d) -> (x for x in values(d)), dict)
support.check_free_after_iterating((d) -> (x for x in items(d)), dict)
end

function test_equal_operator_modifying_operand(self::@like(DictTest))
dict_a = Dict{X, Int64}(X() => 0)
dict_b = Dict{X, X}(X() => X())
@test dict_a == dict_b
dict_c = Dict{Int64, Y}(0 => Y())
dict_d = Dict{Int64, Any}(0 => Set())
@test dict_c == dict_d
end

function test_fromkeys_operator_modifying_dict_operand(self::@like(DictTest))
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

function test_fromkeys_operator_modifying_set_operand(self::@like(DictTest))
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

function test_dictitems_contains_use_after_free(self::@like(DictTest))
d = OrderedDict(0 => Set())
(0, X()) ∈ collect(d)
end

function test_dict_contain_use_after_free(self::@like(DictTest))
d = OrderedDict(S() => "value")
@test !("test" ∈ keys(d))
end

function test_init_use_after_free(self::@like(DictTest))
pair = [X(), 123]
dict([pair])
end

function test_oob_indexing_dictiter_iternextitem(self::@like(DictTest))
d = Dict(i => X(i) for i in 0:7)
function iter_and_mutate()
for result in items(d)
if result[1] == 2
d[3] = nothing
end
end
end

@test_throws
end

function test_reversed(self::@like(DictTest))
d = OrderedDict("a" => 1, "b" => 2, "foo" => 0, "c" => 3, "d" => 4)
# Delete Unsupported
# del(d)
r = reversed(d)
@test (collect(r) == collect("dcba"))
@test_throws
end

function test_reverse_iterator_for_empty_dict(self::@like(DictTest))
@test (collect(reversed(Dict())) == [])
@test (collect(reversed(collect(Dict()))) == [])
@test (collect(reversed(values(Dict()))) == [])
@test (collect(reversed(keys(Dict()))) == [])
@test (collect(reversed(dict())) == [])
@test (collect(reversed(items(dict()))) == [])
@test (collect(reversed(values(dict()))) == [])
@test (collect(reversed(keys(dict()))) == [])
end

function test_reverse_iterator_for_shared_shared_dicts(self::@like(DictTest))
@test (collect(reversed(A(1, 2).__dict__)) == ["y", "x"])
@test (collect(reversed(A(1, 0).__dict__)) == ["x"])
@test (collect(reversed(A(0, 1).__dict__)) == ["y"])
end

function test_dict_copy_order(self::@like(DictTest))
od = collections.OrderedDict([("a", 1), ("b", 2)])
move_to_end(od, "a")
expected = collect(items(od))
copy_ = dict(od)
@test (collect(items(copy_)) == expected)
pairs_ = [("a", 1), ("b", 2), ("c", 3)]
d = CustomDict(pairs_)
@test (pairs_ == collect(items(dict(d))))
d = CustomReversedDict(pairs_)
@test (pairs_[end:-1:begin] == collect(items(dict(d))))
end

function test_dict_items_result_gc(self::@like(DictTest))
it = (x for x in collect(Dict{Any, List}(nothing => [])))
gc.collect()
@test gc.is_tracked(next(it))
end

function test_dict_items_result_gc_reversed(self::@like(DictTest))
it = reversed(collect(Dict{Any, List}(nothing => [])))
gc.collect()
@test gc.is_tracked(next(it))
end

@resumable function test_str_nonstr(self::@like(DictTest))
eq_count = 0
key3_1 = StrSub("key3")
key3_2 = Key3()
key3_3 = Key3()
dicts = []
for key3 in (key3_1, key3_2)
push!(dicts, Dict{Any, int}("key1" => 42, "key2" => 43, key3 => 44))
d = OrderedDict("key1" => 42, "key2" => 43)
d[key3] = 44
push!(dicts, d)
d = OrderedDict("key1" => 42, "key2" => 43)
@test (setdefault(d, key3, 44) == 44)
push!(dicts, d)
d = OrderedDict("key1" => 42, "key2" => 43)
update(d, Dict{Any, int}(key3 => 44))
push!(dicts, d)
d = OrderedDict("key1" => 42, "key2" => 43)
d |= Dict{Any, int}(key3 => 44)
push!(dicts, d)
@resumable function make_pairs()
@yield ("key1", 42)
@yield ("key2", 43)
@yield (key3, 44)
end

d = dict(make_pairs())
push!(dicts, d)
d = copy(d)
push!(dicts, d)
d = Dict(key => 42 + i for (i, key) in enumerate(["key1", "key2", key3]))
push!(dicts, d)
end
for d in dicts
subTest(self, d = d) do 
@test (get(d, "key1") == 42)
noninterned_key1 = "ke"
noninterned_key1 += "y1"
if support.check_impl_detail(cpython = true)
interned_key1 = "key1"
@test !(noninterned_key1 === interned_key1)
end
@test (get(d, noninterned_key1) == 42)
@test (get(d, "key3") == 44)
@test (get(d, key3_1) == 44)
@test (get(d, key3_2) == 44)
eq_count = 0
@test (get(d, key3_3) == 44)
assertGreaterEqual(self, eq_count, 1)
end
end
end


@oodef mutable struct Exc <: Exception
                    
                    
                    
                end
                

@oodef mutable struct BadEq
                    
                    
                    
                end
                function __eq__(self::@like(BadEq), other)
throw(Exc)
end

function __hash__(self::@like(BadEq))::Int64
return 7
end


@oodef mutable struct CAPITest <: unittest.TestCase
                    
                    
                    
                end
                function test_getitem_knownhash(self::@like(CAPITest))
d = OrderedDict("x" => 1, "y" => 2, "z" => 3)
@test (dict_getitem_knownhash(d, "x", hash("x")) == 1)
@test (dict_getitem_knownhash(d, "y", hash("y")) == 2)
@test (dict_getitem_knownhash(d, "z", hash("z")) == 3)
@test_throws
@test_throws
(k1, k2) = (BadEq(), BadEq())
d = OrderedDict(k1 => 1)
@test (dict_getitem_knownhash(d, k1, hash(k1)) == 1)
@test_throws
end



@oodef mutable struct GeneralMappingTests <: mapping_tests.BasicTestMappingProtocol
                    
                    type2test
                    
function new(type2test = dict)
type2test = type2test
new(type2test)
end

                end
                

@oodef mutable struct Dict <: dict
                    
                    
                    
                end
                

@oodef mutable struct SubclassMappingTests <: mapping_tests.BasicTestMappingProtocol
                    
                    type2test::AbstractDict
                    
function new(type2test::Dict = Dict)
type2test = type2test
new(type2test)
end

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
end