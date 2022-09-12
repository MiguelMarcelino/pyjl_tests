# Transpiled with flags: 
# - oop
using ObjectOriented
using Random
using ResumableFunctions
using Test



import gc


import copy


import warnings



@oodef mutable struct PassThru <: Exception
                    
                    
                    
                end
                

@resumable function check_pass_thru()
throw(PassThru)
@yield 1
end

@oodef mutable struct BadCmp
                    
                    
                    
                end
                function __hash__(self::@like(BadCmp))::Int64
return 1
end

function __eq__(self::@like(BadCmp), other)
throw(RuntimeError)
end


@oodef mutable struct ReprWrapper
                    #= Used to test self-referential repr() calls =#

                    
                    
                end
                function Base.show(self::@like(ReprWrapper))
                return repr(self.value)
            end

@oodef mutable struct HashCountingInt <: Int64
                    #= int-like object that counts the number of times __hash__ is called =#

                    hash_count::Int64
                    
function new(hash_count::Int64 = 0, args...)
@mk begin
hash_count = hash_count
end
end

                end
                function __hash__(self::@like(HashCountingInt))
self.hash_count += 1
return __hash__(Int64)
end


@oodef mutable struct Tracer
                    
                    value
                    
function new(value)
@mk begin
value = value
end
end

                end
                function __hash__(self::@like(Tracer))
return self.value
end

function __deepcopy__(self::@like(Tracer), memo = nothing)::Tracer
return Tracer(self.value + 1)
end


@oodef mutable struct A
                    
                    
                    
                end
                

@oodef mutable struct H <: self.thetype
                    
                    
                    
                end
                function __hash__(self::@like(H))::Int64
return parse(Int, id(self) & 2147483647)
end


@oodef mutable struct C <: object
                    
                    
                    
                end
                

@oodef mutable struct TestJointOps
                    
                    d
letters::String
otherword::String
s
word::String
                    
function new(d = fromkeys(dict, word), letters::String = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ", otherword::String = "madagascar", s = thetype(self, word), word::String = "simsalabim")
d = d
letters = letters
otherword = otherword
s = s
word = word
new(d, letters, otherword, s, word)
end

                end
                function setUp(self::@like(TestJointOps))
self.word=word = "simsalabim"
self.otherword = "madagascar"
self.letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
self.s = thetype(self, word)
self.d = fromkeys(dict, word)
end

function test_new_or_init(self::@like(TestJointOps))
assertRaises(self, TypeError, self.thetype, [], 2)
assertRaises(self, TypeError, Set().__init__, a = 1)
end

function test_uniquification(self::@like(TestJointOps))
actual = sorted(self.s)
expected = sorted(self.d)
assertEqual(self, actual, expected)
assertRaises(self, PassThru, self.thetype, check_pass_thru())
assertRaises(self, TypeError, self.thetype, [[]])
end

function test_len(self::@like(TestJointOps))
assertEqual(self, length(self.s), length(self.d))
end

function test_contains(self::@like(TestJointOps))
for c in self.letters
assertEqual(self, c ∈ self.s, c ∈ self.d)
end
assertRaises(self, TypeError, self.s.__contains__, [[]])
s = thetype(self, [frozenset(self.letters)])
assertIn(self, thetype(self, self.letters), s)
end

function test_union(self::@like(TestJointOps))
u = union(self.s, self.otherword)
for c in self.letters
assertEqual(self, c ∈ u, c ∈ self.d||c ∈ self.otherword)
end
assertEqual(self, self.s, thetype(self, self.word))
assertEqual(self, type_(u), self.basetype)
assertRaises(self, PassThru, self.s.union, check_pass_thru())
assertRaises(self, TypeError, self.s.union, [[]])
for C in (set, pset, dict.fromkeys, String, Vector, Tuple)
assertEqual(self, union(thetype(self, "abcba"), C("cdc")), Set("abcd"))
assertEqual(self, union(thetype(self, "abcba"), C("efgfe")), Set("abcefg"))
assertEqual(self, union(thetype(self, "abcba"), C("ccb")), Set("abc"))
assertEqual(self, union(thetype(self, "abcba"), C("ef")), Set("abcef"))
assertEqual(self, union(thetype(self, "abcba"), C("ef"), C("fg")), Set("abcefg"))
end
x = thetype(self)
assertEqual(self, union(x, Set([1]), x, Set([2])), thetype(self, [1, 2]))
end

function test_or(self::@like(TestJointOps))
i = union(self.s, self.otherword)
assertEqual(self, self.s | Set(self.otherword), i)
assertEqual(self, self.s | frozenset(self.otherword), i)
try
self.s | self.otherword
catch exn
if exn isa TypeError
#= pass =#
end
end
end

function test_intersection(self::@like(TestJointOps))
i = intersection(self.s, self.otherword)
for c in self.letters
assertEqual(self, c ∈ i, c ∈ self.d&&c ∈ self.otherword)
end
assertEqual(self, self.s, thetype(self, self.word))
assertEqual(self, type_(i), self.basetype)
assertRaises(self, PassThru, self.s.intersection, check_pass_thru())
for C in (set, pset, dict.fromkeys, String, Vector, Tuple)
assertEqual(self, intersection(thetype(self, "abcba"), C("cdc")), Set("cc"))
assertEqual(self, intersection(thetype(self, "abcba"), C("efgfe")), Set(""))
assertEqual(self, intersection(thetype(self, "abcba"), C("ccb")), Set("bc"))
assertEqual(self, intersection(thetype(self, "abcba"), C("ef")), Set(""))
assertEqual(self, intersection(thetype(self, "abcba"), C("cbcf"), C("bag")), Set("b"))
end
s = thetype(self, "abcba")
z = intersection(s)
if self.thetype == frozenset()
assertEqual(self, id(s), id(z))
else
assertNotEqual(self, id(s), id(z))
end
end

function test_isdisjoint(self::@like(TestJointOps))
function f(s1::@like(TestJointOps), s2)
#= Pure python equivalent of isdisjoint() =#
return !intersection(Set(s1), s2)
end

for larg in ("", "a", "ab", "abc", "ababac", "cdc", "cc", "efgfe", "ccb", "ef")
s1 = thetype(self, larg)
for rarg in ("", "a", "ab", "abc", "ababac", "cdc", "cc", "efgfe", "ccb", "ef")
for C in (set, pset, dict.fromkeys, String, Vector, Tuple)
s2 = C(rarg)
actual = isdisjoint(s1, s2)
expected = f(s1, s2)
assertEqual(self, actual, expected)
assertTrue(self, actual === true||actual === false)
end
end
end
end

function test_and(self::@like(TestJointOps))
i = intersection(self.s, self.otherword)
assertEqual(self, self.s & Set(self.otherword), i)
assertEqual(self, self.s & frozenset(self.otherword), i)
try
self.s & self.otherword
catch exn
if exn isa TypeError
#= pass =#
end
end
end

function test_difference(self::@like(TestJointOps))
i = difference(self.s, self.otherword)
for c in self.letters
assertEqual(self, c ∈ i, c ∈ self.d&&c ∉ self.otherword)
end
assertEqual(self, self.s, thetype(self, self.word))
assertEqual(self, type_(i), self.basetype)
assertRaises(self, PassThru, self.s.difference, check_pass_thru())
assertRaises(self, TypeError, self.s.difference, [[]])
for C in (set, pset, dict.fromkeys, String, Vector, Tuple)
assertEqual(self, difference(thetype(self, "abcba"), C("cdc")), Set("ab"))
assertEqual(self, difference(thetype(self, "abcba"), C("efgfe")), Set("abc"))
assertEqual(self, difference(thetype(self, "abcba"), C("ccb")), Set("a"))
assertEqual(self, difference(thetype(self, "abcba"), C("ef")), Set("abc"))
assertEqual(self, difference(thetype(self, "abcba")), Set("abc"))
assertEqual(self, difference(thetype(self, "abcba"), C("a"), C("b")), Set("c"))
end
end

function test_sub(self::@like(TestJointOps))
i = difference(self.s, self.otherword)
assertEqual(self, self.s - Set(self.otherword), i)
assertEqual(self, self.s - frozenset(self.otherword), i)
try
self.s - self.otherword
catch exn
if exn isa TypeError
#= pass =#
end
end
end

function test_symmetric_difference(self::@like(TestJointOps))
i = symmetric_difference(self.s, self.otherword)
for c in self.letters
assertEqual(self, c ∈ i, c ∈ self.d ⊻ c ∈ self.otherword)
end
assertEqual(self, self.s, thetype(self, self.word))
assertEqual(self, type_(i), self.basetype)
assertRaises(self, PassThru, self.s.symmetric_difference, check_pass_thru())
assertRaises(self, TypeError, self.s.symmetric_difference, [[]])
for C in (set, pset, dict.fromkeys, String, Vector, Tuple)
assertEqual(self, symmetric_difference(thetype(self, "abcba"), C("cdc")), Set("abd"))
assertEqual(self, symmetric_difference(thetype(self, "abcba"), C("efgfe")), Set("abcefg"))
assertEqual(self, symmetric_difference(thetype(self, "abcba"), C("ccb")), Set("a"))
assertEqual(self, symmetric_difference(thetype(self, "abcba"), C("ef")), Set("abcef"))
end
end

function test_xor(self::@like(TestJointOps))
i = symmetric_difference(self.s, self.otherword)
assertEqual(self, self.s ⊻ Set(self.otherword), i)
assertEqual(self, self.s ⊻ frozenset(self.otherword), i)
try
self.s ⊻ self.otherword
catch exn
if exn isa TypeError
#= pass =#
end
end
end

function test_equality(self::@like(TestJointOps))
assertEqual(self, self.s, Set(self.word))
assertEqual(self, self.s, frozenset(self.word))
assertEqual(self, self.s == self.word, false)
assertNotEqual(self, self.s, Set(self.otherword))
assertNotEqual(self, self.s, frozenset(self.otherword))
assertEqual(self, self.s != self.word, true)
end

function test_setOfFrozensets(self::@like(TestJointOps))
t = map(pset, ["abcdef", "bcd", "bdcb", "fed", "fedccba"])
s = thetype(self, t)
assertEqual(self, length(s), 3)
end

function test_sub_and_super(self::@like(TestJointOps))
(p, q, r) = map(self.thetype, ["ab", "abcde", "def"])
assertTrue(self, p < q)
assertTrue(self, p <= q)
assertTrue(self, q <= q)
assertTrue(self, q > p)
assertTrue(self, q >= p)
assertFalse(self, q < r)
assertFalse(self, q <= r)
assertFalse(self, q > r)
assertFalse(self, q >= r)
assertTrue(self, issubset(Set("a"), "abc"))
assertTrue(self, issuperset(Set("abc"), "a"))
assertFalse(self, issubset(Set("a"), "cbs"))
assertFalse(self, issuperset(Set("cbs"), "a"))
end

function test_pickling(self::@like(TestJointOps))
for i in 0:pickle.HIGHEST_PROTOCOL
p = pickle.dumps(self.s, i)
dup = pickle.loads(p)
assertEqual(self, self.s, dup, "$(self.s) != $(dup)")
if type_(self.s) ∉ (set, pset)
self.s.x = 10
p = pickle.dumps(self.s, i)
dup = pickle.loads(p)
assertEqual(self, self.s.x, dup.x)
end
end
end

function test_iterator_pickling(self::@like(TestJointOps))
for proto in 0:pickle.HIGHEST_PROTOCOL
itorg = (x for x in self.s)
data = thetype(self, self.s)
d = pickle.dumps(itorg, proto)
it = pickle.loads(d)
assertIsInstance(self, it, collections.abc.Iterator)
assertEqual(self, thetype(self, it), data)
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
assertEqual(self, thetype(self, it), data - thetype(self, (drop,)))
end
end

function test_deepcopy(self::@like(TestJointOps))
t = Tracer(10)
s = thetype(self, [t])
dup = copy.deepcopy(s)
assertNotEqual(self, id(s), id(dup))
for elem in dup
newt = elem
end
assertNotEqual(self, id(t), id(newt))
assertEqual(self, t.value + 1, newt.value)
end

function test_gc(self::@like(TestJointOps))
s = Set((A() for i in 0:999))
for elem in s
elem.cycle = s
elem.sub = elem
elem.set = Set([elem])
end
end

function test_subclass_with_custom_hash(self::@like(TestJointOps))
s = H()
f = Set()
add(f, s)
assertIn(self, s, f)
remove(f, s)
add(f, s)
discard(f, s)
end

function test_badcmp(self::@like(TestJointOps))
s = thetype(self, [BadCmp()])
assertRaises(self, RuntimeError, self.thetype, [BadCmp(), BadCmp()])
assertRaises(self, RuntimeError, s.__contains__, BadCmp())
if hasfield(typeof(s), :add)
assertRaises(self, RuntimeError, s.add, BadCmp())
assertRaises(self, RuntimeError, s.discard, BadCmp())
assertRaises(self, RuntimeError, s.remove, BadCmp())
end
end

function test_cyclical_repr(self::@like(TestJointOps))
w = ReprWrapper()
s = thetype(self, [w])
w.value = s
if self.thetype == set
assertEqual(self, repr(s), "{set(...)}")
else
name = partition(repr(s), "(")[1]
assertEqual(self, repr(s), "$(name)({$(name)(...)})")
end
end

function test_do_not_rehash_dict_keys(self::@like(TestJointOps))
n = 10
d = fromkeys(dict, map(HashCountingInt, 0:n - 1))
assertEqual(self, sum((elem.hash_count for elem in d)), n)
s = thetype(self, d)
assertEqual(self, sum((elem.hash_count for elem in d)), n)
difference(s, d)
assertEqual(self, sum((elem.hash_count for elem in d)), n)
if hasfield(typeof(s), :symmetric_difference_update)
symmetric_difference_update(s, d)
end
assertEqual(self, sum((elem.hash_count for elem in d)), n)
d2 = fromkeys(dict, Set(d))
assertEqual(self, sum((elem.hash_count for elem in d)), n)
d3 = fromkeys(dict, frozenset(d))
assertEqual(self, sum((elem.hash_count for elem in d)), n)
d3 = fromkeys(dict, frozenset(d), 123)
assertEqual(self, sum((elem.hash_count for elem in d)), n)
assertEqual(self, d3, fromkeys(dict, d, 123))
end

function test_container_iterator(self::@like(TestJointOps))
obj = C()
ref = weakref.ref(obj)
container = Set([obj, 1])
obj.x = (x for x in container)
# Delete Unsupported
# del(container)
gc.collect()
assertTrue(self, ref() === nothing, "Cycle was not collected")
end

function test_free_after_iterating(self::@like(TestJointOps))
support.check_free_after_iterating(iter, self.thetype)
end


@oodef mutable struct TestRichSetCompare
                    
                    ge_called::Bool
gt_called::Bool
le_called::Bool
lt_called::Bool
                    
function new(ge_called::Bool = true, gt_called::Bool = true, le_called::Bool = true, lt_called::Bool = true)
ge_called = ge_called
gt_called = gt_called
le_called = le_called
lt_called = lt_called
new(ge_called, gt_called, le_called, lt_called)
end

                end
                function __gt__(self::@like(TestRichSetCompare), some_set)::Bool
self.gt_called = true
return false
end

function __lt__(self::@like(TestRichSetCompare), some_set)::Bool
self.lt_called = true
return false
end

function __ge__(self::@like(TestRichSetCompare), some_set)::Bool
self.ge_called = true
return false
end

function __le__(self::@like(TestRichSetCompare), some_set)::Bool
self.le_called = true
return false
end


@oodef mutable struct TestSet <: {TestJointOps, unittest.TestCase}
                    
                    basetype
d
letters::String
otherword::String
s
thetype
word::String
                    
function new(basetype = set, d = fromkeys(dict, word), letters::String = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ", otherword::String = "madagascar", s = thetype(self, word), thetype = set, word::String = "simsalabim")
basetype = basetype
d = d
letters = letters
otherword = otherword
s = s
thetype = thetype
word = word
new(basetype, d, letters, otherword, s, thetype, word)
end

                end
                function test_init(self::@like(TestSet))
s = thetype(self)
s(self.word)
@test (s == Set(self.word))
s(self.otherword)
@test (s == Set(self.otherword))
@test_throws
@test_throws
end

function test_constructor_identity(self::@like(TestSet))
s = thetype(self, 0:2)
t = thetype(self, s)
@test (id(s) != id(t))
end

function test_set_literal(self::@like(TestSet))
s = Set([1, 2, 3])
t = Set([1, 2, 3])
@test (s == t)
end

function test_set_literal_insertion_order(self::@like(TestSet))
s = Set([1, 1.0, true])
@test (length(s) == 1)
stored_value = pop(s)
@test (type_(stored_value) == Int64)
end

function test_set_literal_evaluation_order(self::@like(TestSet))
events = []
function record(obj::@like(TestSet))
push!(events, obj)
end

s = Set([record(1), record(2), record(3)])
@test (events == [1, 2, 3])
end

function test_hash(self::@like(TestSet))
@test_throws
end

function test_clear(self::@like(TestSet))
clear(self.s)
@test (self.s == Set())
@test (length(self.s) == 0)
end

function test_copy(self::@like(TestSet))
dup = copy(self.s)
@test (self.s == dup)
@test (id(self.s) != id(dup))
@test (type_(dup) == self.basetype)
end

function test_add(self::@like(TestSet))
add(self.s, "Q")
assertIn(self, "Q", self.s)
dup = copy(self.s)
add(self.s, "Q")
@test (self.s == dup)
@test_throws
end

function test_remove(self::@like(TestSet))
remove(self.s, "a")
assertNotIn(self, "a", self.s)
@test_throws
@test_throws
s = thetype(self, [frozenset(self.word)])
assertIn(self, thetype(self, self.word), s)
remove(s, thetype(self, self.word))
assertNotIn(self, thetype(self, self.word), s)
@test_throws
end

function test_remove_keyerror_unpacking(self::@like(TestSet))
for v1 in ["Q", (1,)]
try
remove(self.s, v1)
catch exn
 let e = exn
if e isa KeyError
v2 = e.args[1]
@test (v1 == v2)
end
end
end
end
end

function test_remove_keyerror_set(self::@like(TestSet))
key = thetype(self, [3, 4])
try
remove(self.s, key)
catch exn
 let e = exn
if e isa KeyError
@test e.args[1] === key
end
end
end
end

function test_discard(self::@like(TestSet))
discard(self.s, "a")
assertNotIn(self, "a", self.s)
discard(self.s, "Q")
@test_throws
s = thetype(self, [frozenset(self.word)])
assertIn(self, thetype(self, self.word), s)
discard(s, thetype(self, self.word))
assertNotIn(self, thetype(self, self.word), s)
discard(s, thetype(self, self.word))
end

function test_pop(self::@like(TestSet))
for i in 0:length(self.s) - 1
elem = pop(self.s)
assertNotIn(self, elem, self.s)
end
@test_throws
end

function test_update(self::@like(TestSet))
retval = update(self.s, self.otherword)
@test (retval == nothing)
for c in self.word + self.otherword
assertIn(self, c, self.s)
end
@test_throws
@test_throws
for (p, q) in (("cdc", "abcd"), ("efgfe", "abcefg"), ("ccb", "abc"), ("ef", "abcef"))
for C in (set, pset, dict.fromkeys, String, Vector, Tuple)
s = thetype(self, "abcba")
@test (update(s, C(p)) == nothing)
@test (s == Set(q))
end
end
for p in ("cdc", "efgfe", "ccb", "ef", "abcda")
q = "ahi"
for C in (set, pset, dict.fromkeys, String, Vector, Tuple)
s = thetype(self, "abcba")
@test (update(s, C(p), C(q)) == nothing)
@test (s == (Set(s) | Set(p)) | Set(q))
end
end
end

function test_ior(self::@like(TestSet))
self.s |= Set(self.otherword)
for c in self.word + self.otherword
assertIn(self, c, self.s)
end
end

function test_intersection_update(self::@like(TestSet))
retval = intersection_update(self.s, self.otherword)
@test (retval == nothing)
for c in self.word + self.otherword
if c ∈ self.otherword&&c ∈ self.word
assertIn(self, c, self.s)
else
assertNotIn(self, c, self.s)
end
end
@test_throws
@test_throws
for (p, q) in (("cdc", "c"), ("efgfe", ""), ("ccb", "bc"), ("ef", ""))
for C in (set, pset, dict.fromkeys, String, Vector, Tuple)
s = thetype(self, "abcba")
@test (intersection_update(s, C(p)) == nothing)
@test (s == Set(q))
ss = "abcba"
s = thetype(self, ss)
t = "cbc"
@test (intersection_update(s, C(p), C(t)) == nothing)
@test (s == (Set("abcba") & Set(p)) & Set(t))
end
end
end

function test_iand(self::@like(TestSet))
self.s &= Set(self.otherword)
for c in self.word + self.otherword
if c ∈ self.otherword&&c ∈ self.word
assertIn(self, c, self.s)
else
assertNotIn(self, c, self.s)
end
end
end

function test_difference_update(self::@like(TestSet))
retval = difference_update(self.s, self.otherword)
@test (retval == nothing)
for c in self.word + self.otherword
if c ∈ self.word&&c ∉ self.otherword
assertIn(self, c, self.s)
else
assertNotIn(self, c, self.s)
end
end
@test_throws
@test_throws
@test_throws
for (p, q) in (("cdc", "ab"), ("efgfe", "abc"), ("ccb", "a"), ("ef", "abc"))
for C in (set, pset, dict.fromkeys, String, Vector, Tuple)
s = thetype(self, "abcba")
@test (difference_update(s, C(p)) == nothing)
@test (s == Set(q))
s = thetype(self, "abcdefghih")
difference_update(s)
@test (s == thetype(self, "abcdefghih"))
s = thetype(self, "abcdefghih")
difference_update(s, C("aba"))
@test (s == thetype(self, "cdefghih"))
s = thetype(self, "abcdefghih")
difference_update(s, C("cdc"), C("aba"))
@test (s == thetype(self, "efghih"))
end
end
end

function test_isub(self::@like(TestSet))
self.s -= Set(self.otherword)
for c in self.word + self.otherword
if c ∈ self.word&&c ∉ self.otherword
assertIn(self, c, self.s)
else
assertNotIn(self, c, self.s)
end
end
end

function test_symmetric_difference_update(self::@like(TestSet))
retval = symmetric_difference_update(self.s, self.otherword)
@test (retval == nothing)
for c in self.word + self.otherword
if c ∈ self.word ⊻ c ∈ self.otherword
assertIn(self, c, self.s)
else
assertNotIn(self, c, self.s)
end
end
@test_throws
@test_throws
for (p, q) in (("cdc", "abd"), ("efgfe", "abcefg"), ("ccb", "a"), ("ef", "abcef"))
for C in (set, pset, dict.fromkeys, String, Vector, Tuple)
s = thetype(self, "abcba")
@test (symmetric_difference_update(s, C(p)) == nothing)
@test (s == Set(q))
end
end
end

function test_ixor(self::@like(TestSet))
self.s ⊻= Set(self.otherword)
for c in self.word + self.otherword
if c ∈ self.word ⊻ c ∈ self.otherword
assertIn(self, c, self.s)
else
assertNotIn(self, c, self.s)
end
end
end

function test_inplace_on_self(self::@like(TestSet))
t = copy(self.s)
t |= t
@test (t == self.s)
t &= t
@test (t == self.s)
t -= t
@test (t == thetype(self))
t = copy(self.s)
t ⊻= t
@test (t == thetype(self))
end

function test_weakref(self::@like(TestSet))
s = thetype(self, "gallahad")
p = weakref.proxy(s)
@test (string(p) == string(s))
s = nothing
support.gc_collect()
@test_throws
end

function test_rich_compare(self::@like(TestSet))
myset = Set([1, 2, 3])
myobj = TestRichSetCompare()
myset < myobj
@test myobj.gt_called
myobj = TestRichSetCompare()
myset > myobj
@test myobj.lt_called
myobj = TestRichSetCompare()
myset <= myobj
@test myobj.ge_called
myobj = TestRichSetCompare()
myset >= myobj
@test myobj.le_called
end

function test_c_api(self::@like(TestSet))
@test (test_c_api(Set()) == true)
end


@oodef mutable struct SetSubclass <: set
                    
                    
                    
                end
                

@oodef mutable struct TestSetSubclass <: TestSet
                    
                    basetype
d
letters::String
otherword::String
s
thetype::AbstractSetSubclass
word::String
                    
function new(basetype = set, d = fromkeys(dict, word), letters::String = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ", otherword::String = "madagascar", s = thetype(self, word), thetype::SetSubclass = SetSubclass, word::String = "simsalabim")
basetype = basetype
d = d
letters = letters
otherword = otherword
s = s
thetype = thetype
word = word
new(basetype, d, letters, otherword, s, thetype, word)
end

                end
                

@oodef mutable struct SetSubclassWithKeywordArgs <: set
                    
                    
                    
function new(iterable = [], newarg = nothing)
Set(iterable)
@mk begin

end
end

                end
                

@oodef mutable struct TestSetSubclassWithKeywordArgs <: TestSet
                    
                    d
letters::String
otherword::String
s
word::String
                    
function new(d = fromkeys(dict, word), letters::String = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ", otherword::String = "madagascar", s = thetype(self, word), word::String = "simsalabim")
d = d
letters = letters
otherword = otherword
s = s
word = word
new(d, letters, otherword, s, word)
end

                end
                function test_keywords_in_subclass(self::@like(TestSetSubclassWithKeywordArgs))
#= SF bug #1486663 -- this used to erroneously raise a TypeError =#
SetSubclassWithKeywordArgs(newarg = 1)
end


@resumable function powerset(s::TestFrozenSet)
for i in 0:length(s)
# Unsupported
# yield_from map(pset, itertools.combinations(s, i))
end
end

@oodef mutable struct TestFrozenSet <: {TestJointOps, unittest.TestCase}
                    
                    basetype
d
letters::String
otherword::String
s
thetype
word::String
                    
function new(basetype = pset, d = fromkeys(dict, word), letters::String = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ", otherword::String = "madagascar", s = thetype(self, word), thetype = pset, word::String = "simsalabim")
basetype = basetype
d = d
letters = letters
otherword = otherword
s = s
thetype = thetype
word = word
new(basetype, d, letters, otherword, s, thetype, word)
end

                end
                function test_init(self::@like(TestFrozenSet))
s = thetype(self, self.word)
s(self.otherword)
@test (s == Set(self.word))
end

function test_constructor_identity(self::@like(TestFrozenSet))
s = thetype(self, 0:2)
t = thetype(self, s)
@test (id(s) == id(t))
end

function test_hash(self::@like(TestFrozenSet))
@test (hash(thetype(self, "abcdeb")) == hash(thetype(self, "ebecda")))
n = 100
seq = [randrange(n) for i in 0:n - 1]
results = Set()
for i in 0:199
shuffle(seq)
add(results, hash(thetype(self, seq)))
end
@test (length(results) == 1)
end

function test_copy(self::@like(TestFrozenSet))
dup = copy(self.s)
@test (id(self.s) == id(dup))
end

function test_frozen_as_dictkey(self::@like(TestFrozenSet))
seq = [[collect(0:9); collect("abcdefg")]; ["apple"]]
key1 = thetype(self, seq)
key2 = thetype(self, reversed(seq))
@test (key1 == key2)
@test (id(key1) != id(key2))
d = Dict()
d[key1] = 42
@test (d[key2] == 42)
end

function test_hash_caching(self::@like(TestFrozenSet))
f = thetype(self, "abcdcda")
@test (hash(f) == hash(f))
end

@resumable function test_hash_effectiveness(self::@like(TestFrozenSet))
n = 13
hashvalues = Set()
addhashvalue = hashvalues.add
elemmasks = [(i + 1, 1 << i) for i in 0:n - 1]
for i in 0:2^n - 1
addhashvalue(hash(frozenset([e for (e, m) in elemmasks if m & i ])))
end
@test (length(hashvalues) == 2^n)
function zf_range(n::@like(TestFrozenSet))::Vector
nums = [frozenset()]
for i in 0:n - 2
num = frozenset(nums)
push!(nums, num)
end
return nums[begin:n]
end

for n in 0:17
t = 2^n
mask = t - 1
for nums in (range, zf_range)
u = length((h & mask for h in map(hash, powerset(nums(n)))))
assertGreater(self, 4*u, t)
end
end
end


@oodef mutable struct FrozenSetSubclass <: pset
                    
                    
                    
                end
                

@oodef mutable struct TestFrozenSetSubclass <: TestFrozenSet
                    
                    basetype
d
letters::String
otherword::String
s
thetype::AbstractFrozenSetSubclass
word::String
                    
function new(basetype = pset, d = fromkeys(dict, word), letters::String = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ", otherword::String = "madagascar", s = thetype(self, word), thetype::FrozenSetSubclass = FrozenSetSubclass, word::String = "simsalabim")
basetype = basetype
d = d
letters = letters
otherword = otherword
s = s
thetype = thetype
word = word
new(basetype, d, letters, otherword, s, thetype, word)
end

                end
                function test_constructor_identity(self::@like(TestFrozenSetSubclass))
s = thetype(self, 0:2)
t = thetype(self, s)
assertNotEqual(self, id(s), id(t))
end

function test_copy(self::@like(TestFrozenSetSubclass))
dup = copy(self.s)
assertNotEqual(self, id(self.s), id(dup))
end

function test_nested_empty_constructor(self::@like(TestFrozenSetSubclass))
s = thetype(self)
t = thetype(self, s)
assertEqual(self, s, t)
end

function test_singleton_empty_frozenset(self::@like(TestFrozenSetSubclass))
Frozenset = self.thetype
f = frozenset()
F = Frozenset()
efs = [Frozenset(), Frozenset([]), Frozenset(()), Frozenset(""), Frozenset(), Frozenset([]), Frozenset(()), Frozenset(""), Frozenset(0:-1), Frozenset(Frozenset()), Frozenset(frozenset()), f, F, Frozenset(f), Frozenset(F)]
assertEqual(self, length(Set(map(id, efs))), length(efs))
end


empty_set = Set()
@oodef mutable struct TestBasicOps
                    
                    
                    
                end
                function test_repr(self::@like(TestBasicOps))
if self.repr !== nothing
assertEqual(self, repr(self.set), self.repr)
end
end

function check_repr_against_values(self::@like(TestBasicOps))
text = repr(self.set)
assertTrue(self, startswith(text, "{"))
assertTrue(self, endswith(text, "}"))
result = split(text[1:end - 1], ", ")
sort(result)
sorted_repr_values = [repr(value) for value in self.values]
sort(sorted_repr_values)
assertEqual(self, result, sorted_repr_values)
end

function test_length(self::@like(TestBasicOps))
assertEqual(self, length(self.set), self.length)
end

function test_self_equality(self::@like(TestBasicOps))
assertEqual(self, self.set, self.set)
end

function test_equivalent_equality(self::@like(TestBasicOps))
assertEqual(self, self.set, self.dup)
end

function test_copy(self::@like(TestBasicOps))
assertEqual(self, copy(self.set), self.dup)
end

function test_self_union(self::@like(TestBasicOps))
result = self.set | self.set
assertEqual(self, result, self.dup)
end

function test_empty_union(self::@like(TestBasicOps))
result = self.set | empty_set
assertEqual(self, result, self.dup)
end

function test_union_empty(self::@like(TestBasicOps))
result = empty_set | self.set
assertEqual(self, result, self.dup)
end

function test_self_intersection(self::@like(TestBasicOps))
result = self.set & self.set
assertEqual(self, result, self.dup)
end

function test_empty_intersection(self::@like(TestBasicOps))
result = self.set & empty_set
assertEqual(self, result, empty_set)
end

function test_intersection_empty(self::@like(TestBasicOps))
result = empty_set & self.set
assertEqual(self, result, empty_set)
end

function test_self_isdisjoint(self::@like(TestBasicOps))
result = isdisjoint(self.set, self.set)
assertEqual(self, result, !(self.set))
end

function test_empty_isdisjoint(self::@like(TestBasicOps))
result = isdisjoint(self.set, empty_set)
assertEqual(self, result, true)
end

function test_isdisjoint_empty(self::@like(TestBasicOps))
result = isdisjoint(empty_set, self.set)
assertEqual(self, result, true)
end

function test_self_symmetric_difference(self::@like(TestBasicOps))
result = self.set ⊻ self.set
assertEqual(self, result, empty_set)
end

function test_empty_symmetric_difference(self::@like(TestBasicOps))
result = self.set ⊻ empty_set
assertEqual(self, result, self.set)
end

function test_self_difference(self::@like(TestBasicOps))
result = self.set - self.set
assertEqual(self, result, empty_set)
end

function test_empty_difference(self::@like(TestBasicOps))
result = self.set - empty_set
assertEqual(self, result, self.dup)
end

function test_empty_difference_rev(self::@like(TestBasicOps))
result = empty_set - self.set
assertEqual(self, result, empty_set)
end

function test_iteration(self::@like(TestBasicOps))
for v in self.set
assertIn(self, v, self.values)
end
setiter = (x for x in self.set)
assertEqual(self, __length_hint__(setiter), length(self.set))
end

function test_pickling(self::@like(TestBasicOps))
for proto in 0:pickle.HIGHEST_PROTOCOL
p = pickle.dumps(self.set, proto)
copy_ = pickle.loads(p)
assertEqual(self, self.set, copy_, "$(self.set) != $(copy_)")
end
end

function test_issue_37219(self::@like(TestBasicOps))
assertRaises(self, TypeError) do 
difference(Set(), 123)
end
assertRaises(self, TypeError) do 
difference_update(Set(), 123)
end
end


@oodef mutable struct TestBasicOpsEmpty <: {TestBasicOps, unittest.TestCase}
                    
                    case::String
dup
length::Int64
repr::String
set
values::Vector
                    
function new(case::String = "empty set", dup = Set(self.values_), length::Int64 = 0, repr::String = "set()", set = Set(self.values_), values::Vector = [])
case = case
dup = dup
length = length
repr = repr
set = set
values = values
new(case, dup, length, repr, set, values)
end

                end
                function setUp(self::@like(TestBasicOpsEmpty))
self.case = "empty set"
self.values_ = []
self.set = Set(self.values_)
self.dup = Set(self.values_)
self.length_ = 0
self.repr = "set()"
end


@oodef mutable struct TestBasicOpsSingleton <: {TestBasicOps, unittest.TestCase}
                    
                    case::String
dup
length::Int64
repr::String
set
values::Vector{Int64}
                    
function new(case::String = "unit set (number)", dup = Set(self.values_), length::Int64 = 1, repr::String = "{3}", set = Set(self.values_), values::Vector{Int64} = [3])
case = case
dup = dup
length = length
repr = repr
set = set
values = values
new(case, dup, length, repr, set, values)
end

                end
                function setUp(self::@like(TestBasicOpsSingleton))
self.case = "unit set (number)"
self.values_ = [3]
self.set = Set(self.values_)
self.dup = Set(self.values_)
self.length_ = 1
self.repr = "{3}"
end

function test_in(self::@like(TestBasicOpsSingleton))
assertIn(self, 3, self.set)
end

function test_not_in(self::@like(TestBasicOpsSingleton))
assertNotIn(self, 2, self.set)
end


@oodef mutable struct TestBasicOpsTuple <: {TestBasicOps, unittest.TestCase}
                    
                    case::String
dup
length::Int64
repr::String
set
values::Vector
                    
function new(case::String = "unit set (tuple)", dup = Set(self.values_), length::Int64 = 1, repr::String = "{(0, \'zero\')}", set = Set(self.values_), values::Vector = [(0, "zero")])
case = case
dup = dup
length = length
repr = repr
set = set
values = values
new(case, dup, length, repr, set, values)
end

                end
                function setUp(self::@like(TestBasicOpsTuple))
self.case = "unit set (tuple)"
self.values_ = [(0, "zero")]
self.set = Set(self.values_)
self.dup = Set(self.values_)
self.length_ = 1
self.repr = "{(0, \'zero\')}"
end

function test_in(self::@like(TestBasicOpsTuple))
assertIn(self, (0, "zero"), self.set)
end

function test_not_in(self::@like(TestBasicOpsTuple))
assertNotIn(self, 9, self.set)
end


@oodef mutable struct TestBasicOpsTriple <: {TestBasicOps, unittest.TestCase}
                    
                    case::String
dup
length::Int64
repr
set
values
                    
function new(case::String = "triple set", dup = Set(self.values_), length::Int64 = 3, repr = nothing, set = Set(self.values_), values = [0, "zero", operator.add])
case = case
dup = dup
length = length
repr = repr
set = set
values = values
new(case, dup, length, repr, set, values)
end

                end
                function setUp(self::@like(TestBasicOpsTriple))
self.case = "triple set"
self.values_ = [0, "zero", operator.add]
self.set = Set(self.values_)
self.dup = Set(self.values_)
self.length_ = 3
self.repr = nothing
end


@oodef mutable struct TestBasicOpsString <: {TestBasicOps, unittest.TestCase}
                    
                    case::String
dup
length::Int64
set
values::Vector{String}
                    
function new(case::String = "string set", dup = Set(self.values_), length::Int64 = 3, set = Set(self.values_), values::Vector{String} = ["a", "b", "c"])
case = case
dup = dup
length = length
set = set
values = values
new(case, dup, length, set, values)
end

                end
                function setUp(self::@like(TestBasicOpsString))
self.case = "string set"
self.values_ = ["a", "b", "c"]
self.set = Set(self.values_)
self.dup = Set(self.values_)
self.length_ = 3
end

function test_repr(self::@like(TestBasicOpsString))
check_repr_against_values(self)
end


@oodef mutable struct TestBasicOpsBytes <: {TestBasicOps, unittest.TestCase}
                    
                    case::String
dup
length::Int64
set
values::Vector{Array{UInt8}}
                    
function new(case::String = "bytes set", dup = Set(self.values_), length::Int64 = 3, set = Set(self.values_), values::Vector{Array{UInt8}} = [b"a", b"b", b"c"])
case = case
dup = dup
length = length
set = set
values = values
new(case, dup, length, set, values)
end

                end
                function setUp(self::@like(TestBasicOpsBytes))
self.case = "bytes set"
self.values_ = [b"a", b"b", b"c"]
self.set = Set(self.values_)
self.dup = Set(self.values_)
self.length_ = 3
end

function test_repr(self::@like(TestBasicOpsBytes))
check_repr_against_values(self)
end


@oodef mutable struct TestBasicOpsMixedStringBytes <: {TestBasicOps, unittest.TestCase}
                    
                    _warning_filters
case::String
dup
length::Int64
set
values
                    
function new(_warning_filters = warnings_helper.check_warnings(), case::String = "string and bytes set", dup = Set(self.values_), length::Int64 = 4, set = Set(self.values_), values = ["a", "b", b"a", b"b"])
_warning_filters = _warning_filters
case = case
dup = dup
length = length
set = set
values = values
new(_warning_filters, case, dup, length, set, values)
end

                end
                function setUp(self::@like(TestBasicOpsMixedStringBytes))
self._warning_filters = warnings_helper.check_warnings()
__enter__(self._warning_filters)
warnings.simplefilter("ignore", BytesWarning)
self.case = "string and bytes set"
self.values_ = ["a", "b", b"a", b"b"]
self.set = Set(self.values_)
self.dup = Set(self.values_)
self.length_ = 4
end

function tearDown(self::@like(TestBasicOpsMixedStringBytes))
__exit__(self._warning_filters, nothing, nothing, nothing)
end

function test_repr(self::@like(TestBasicOpsMixedStringBytes))
check_repr_against_values(self)
end


@resumable function baditer()
throw(TypeError)
@yield true
end

@resumable function gooditer()
@yield true
end

@oodef mutable struct TestExceptionPropagation <: unittest.TestCase
                    #= SF 628246:  Set constructor should not trap iterator TypeErrors =#

                    
                    
                end
                function test_instanceWithException(self::@like(TestExceptionPropagation))
@test_throws
end

function test_instancesWithoutException(self::@like(TestExceptionPropagation))
Set([1, 2, 3])
Set((1, 2, 3))
Set(Dict{str, int}("one" => 1, "two" => 2, "three" => 3))
Set(0:2)
Set("abc")
Set(gooditer())
end

function test_changingSizeWhileIterating(self::@like(TestExceptionPropagation))
s = Set([1, 2, 3])
try
for i in s
update(s, [4])
end
catch exn
if exn isa RuntimeError
#= pass =#
end
end
end


@oodef mutable struct TestSetOfSets <: unittest.TestCase
                    
                    
                    
                end
                function test_constructor(self::@like(TestSetOfSets))
inner = frozenset([1])
outer = Set([inner])
element = pop(outer)
@test (type_(element) == pset)
add(outer, inner)
remove(outer, inner)
@test (outer == Set())
discard(outer, inner)
end


@oodef mutable struct TestBinaryOps <: unittest.TestCase
                    
                    set
                    
function new(set = Set((2, 4, 6)))
set = set
new(set)
end

                end
                function setUp(self::@like(TestBinaryOps))
self.set = Set((2, 4, 6))
end

function test_eq(self::@like(TestBinaryOps))
@test (self.set == Set(Dict{int, int}(2 => 1, 4 => 3, 6 => 5)))
end

function test_union_subset(self::@like(TestBinaryOps))
result = self.set | Set([2])
@test (result == Set((2, 4, 6)))
end

function test_union_superset(self::@like(TestBinaryOps))
result = self.set | Set([2, 4, 6, 8])
@test (result == Set([2, 4, 6, 8]))
end

function test_union_overlap(self::@like(TestBinaryOps))
result = self.set | Set([3, 4, 5])
@test (result == Set([2, 3, 4, 5, 6]))
end

function test_union_non_overlap(self::@like(TestBinaryOps))
result = self.set | Set([8])
@test (result == Set([2, 4, 6, 8]))
end

function test_intersection_subset(self::@like(TestBinaryOps))
result = self.set & Set((2, 4))
@test (result == Set((2, 4)))
end

function test_intersection_superset(self::@like(TestBinaryOps))
result = self.set & Set([2, 4, 6, 8])
@test (result == Set([2, 4, 6]))
end

function test_intersection_overlap(self::@like(TestBinaryOps))
result = self.set & Set([3, 4, 5])
@test (result == Set([4]))
end

function test_intersection_non_overlap(self::@like(TestBinaryOps))
result = self.set & Set([8])
@test (result == empty_set)
end

function test_isdisjoint_subset(self::@like(TestBinaryOps))
result = isdisjoint(self.set, Set((2, 4)))
@test (result == false)
end

function test_isdisjoint_superset(self::@like(TestBinaryOps))
result = isdisjoint(self.set, Set([2, 4, 6, 8]))
@test (result == false)
end

function test_isdisjoint_overlap(self::@like(TestBinaryOps))
result = isdisjoint(self.set, Set([3, 4, 5]))
@test (result == false)
end

function test_isdisjoint_non_overlap(self::@like(TestBinaryOps))
result = isdisjoint(self.set, Set([8]))
@test (result == true)
end

function test_sym_difference_subset(self::@like(TestBinaryOps))
result = self.set ⊻ Set((2, 4))
@test (result == Set([6]))
end

function test_sym_difference_superset(self::@like(TestBinaryOps))
result = self.set ⊻ Set((2, 4, 6, 8))
@test (result == Set([8]))
end

function test_sym_difference_overlap(self::@like(TestBinaryOps))
result = self.set ⊻ Set((3, 4, 5))
@test (result == Set([2, 3, 5, 6]))
end

function test_sym_difference_non_overlap(self::@like(TestBinaryOps))
result = self.set ⊻ Set([8])
@test (result == Set([2, 4, 6, 8]))
end


@oodef mutable struct TestUpdateOps <: unittest.TestCase
                    
                    set
                    
function new(set = Set((2, 4, 6)))
set = set
new(set)
end

                end
                function setUp(self::@like(TestUpdateOps))
self.set = Set((2, 4, 6))
end

function test_union_subset(self::@like(TestUpdateOps))
self.set |= Set([2])
@test (self.set == Set((2, 4, 6)))
end

function test_union_superset(self::@like(TestUpdateOps))
self.set |= Set([2, 4, 6, 8])
@test (self.set == Set([2, 4, 6, 8]))
end

function test_union_overlap(self::@like(TestUpdateOps))
self.set |= Set([3, 4, 5])
@test (self.set == Set([2, 3, 4, 5, 6]))
end

function test_union_non_overlap(self::@like(TestUpdateOps))
self.set |= Set([8])
@test (self.set == Set([2, 4, 6, 8]))
end

function test_union_method_call(self::@like(TestUpdateOps))
update(self.set, Set([3, 4, 5]))
@test (self.set == Set([2, 3, 4, 5, 6]))
end

function test_intersection_subset(self::@like(TestUpdateOps))
self.set &= Set((2, 4))
@test (self.set == Set((2, 4)))
end

function test_intersection_superset(self::@like(TestUpdateOps))
self.set &= Set([2, 4, 6, 8])
@test (self.set == Set([2, 4, 6]))
end

function test_intersection_overlap(self::@like(TestUpdateOps))
self.set &= Set([3, 4, 5])
@test (self.set == Set([4]))
end

function test_intersection_non_overlap(self::@like(TestUpdateOps))
self.set &= Set([8])
@test (self.set == empty_set)
end

function test_intersection_method_call(self::@like(TestUpdateOps))
intersection_update(self.set, Set([3, 4, 5]))
@test (self.set == Set([4]))
end

function test_sym_difference_subset(self::@like(TestUpdateOps))
self.set ⊻= Set((2, 4))
@test (self.set == Set([6]))
end

function test_sym_difference_superset(self::@like(TestUpdateOps))
self.set ⊻= Set((2, 4, 6, 8))
@test (self.set == Set([8]))
end

function test_sym_difference_overlap(self::@like(TestUpdateOps))
self.set ⊻= Set((3, 4, 5))
@test (self.set == Set([2, 3, 5, 6]))
end

function test_sym_difference_non_overlap(self::@like(TestUpdateOps))
self.set ⊻= Set([8])
@test (self.set == Set([2, 4, 6, 8]))
end

function test_sym_difference_method_call(self::@like(TestUpdateOps))
symmetric_difference_update(self.set, Set([3, 4, 5]))
@test (self.set == Set([2, 3, 5, 6]))
end

function test_difference_subset(self::@like(TestUpdateOps))
self.set -= Set((2, 4))
@test (self.set == Set([6]))
end

function test_difference_superset(self::@like(TestUpdateOps))
self.set -= Set((2, 4, 6, 8))
@test (self.set == Set([]))
end

function test_difference_overlap(self::@like(TestUpdateOps))
self.set -= Set((3, 4, 5))
@test (self.set == Set([2, 6]))
end

function test_difference_non_overlap(self::@like(TestUpdateOps))
self.set -= Set([8])
@test (self.set == Set([2, 4, 6]))
end

function test_difference_method_call(self::@like(TestUpdateOps))
difference_update(self.set, Set([3, 4, 5]))
@test (self.set == Set([2, 6]))
end


@oodef mutable struct TestMutate <: unittest.TestCase
                    
                    set
values::Vector{String}
                    
function new(set = Set(self.values_), values::Vector{String} = ["a", "b", "c"])
set = set
values = values
new(set, values)
end

                end
                function setUp(self::@like(TestMutate))
self.values_ = ["a", "b", "c"]
self.set = Set(self.values_)
end

function test_add_present(self::@like(TestMutate))
add(self.set, "c")
@test (self.set == Set("abc"))
end

function test_add_absent(self::@like(TestMutate))
add(self.set, "d")
@test (self.set == Set("abcd"))
end

function test_add_until_full(self::@like(TestMutate))
tmp = Set()
expected_len = 0
for v in self.values_
add(tmp, v)
expected_len += 1
@test (length(tmp) == expected_len)
end
@test (tmp == self.set)
end

function test_remove_present(self::@like(TestMutate))
remove(self.set, "b")
@test (self.set == Set("ac"))
end

function test_remove_absent(self::@like(TestMutate))
try
remove(self.set, "d")
fail(self, "Removing missing element should have raised LookupError")
catch exn
if exn isa LookupError
#= pass =#
end
end
end

function test_remove_until_empty(self::@like(TestMutate))
expected_len = length(self.set)
for v in self.values_
remove(self.set, v)
expected_len -= 1
@test (length(self.set) == expected_len)
end
end

function test_discard_present(self::@like(TestMutate))
discard(self.set, "c")
@test (self.set == Set("ab"))
end

function test_discard_absent(self::@like(TestMutate))
discard(self.set, "d")
@test (self.set == Set("abc"))
end

function test_clear(self::@like(TestMutate))
clear(self.set)
@test (length(self.set) == 0)
end

function test_pop(self::@like(TestMutate))
popped = Dict()
while self.set
popped[pop(self.set)] = nothing
end
@test (length(popped) == length(self.values_))
for v in self.values_
assertIn(self, v, popped)
end
end

function test_update_empty_tuple(self::@like(TestMutate))
update(self.set, ())
@test (self.set == Set(self.values_))
end

function test_update_unit_tuple_overlap(self::@like(TestMutate))
update(self.set, ("a",))
@test (self.set == Set(self.values_))
end

function test_update_unit_tuple_non_overlap(self::@like(TestMutate))
update(self.set, ("a", "z"))
@test (self.set == Set([self.values_; ["z"]]))
end


@oodef mutable struct TestSubsets
                    
                    case2method::Dict{String, String}
reverse::Dict{String, String}
                    
function new(case2method::Dict{String, String} = Dict{String, String}("<=" => "issubset", ">=" => "issuperset"), reverse::Dict{String, String} = Dict{String, String}("==" => "==", "!=" => "!=", "<" => ">", ">" => "<", "<=" => ">=", ">=" => "<="))
case2method = case2method
reverse = reverse
new(case2method, reverse)
end

                end
                function test_issubset(self::@like(TestSubsets))
x = self.left
y = self.right
for case in ("!=", "==", "<", "<=", ">", ">=")
expected = case ∈ self.cases
result = py""x" * case * "y", locals()"
assertEqual(self, result, expected)
if case ∈ TestSubsets.case2method
method = getfield(x, :TestSubsets.case2method[case + 1])
result = method(y)
assertEqual(self, result, expected)
end
rcase = TestSubsets.reverse_[case + 1]
result = py"("y" + rcase) + "x", locals()"
assertEqual(self, result, expected)
if rcase ∈ TestSubsets.case2method
method = getfield(y, :TestSubsets.case2method[rcase + 1])
result = method(x)
assertEqual(self, result, expected)
end
end
end


@oodef mutable struct TestSubsetEqualEmpty <: {TestSubsets, unittest.TestCase}
                    
                    cases::Tuple{String}
left
name::String
right
                    
function new(cases::Tuple{String} = ("==", "<=", ">="), left = Set(), name::String = "both empty", right = Set())
cases = cases
left = left
name = name
right = right
new(cases, left, name, right)
end

                end
                

@oodef mutable struct TestSubsetEqualNonEmpty <: {TestSubsets, unittest.TestCase}
                    
                    cases::Tuple{String}
left
name::String
right
                    
function new(cases::Tuple{String} = ("==", "<=", ">="), left = Set([1, 2]), name::String = "equal pair", right = Set([1, 2]))
cases = cases
left = left
name = name
right = right
new(cases, left, name, right)
end

                end
                

@oodef mutable struct TestSubsetEmptyNonEmpty <: {TestSubsets, unittest.TestCase}
                    
                    cases::Tuple{String}
left
name::String
right
                    
function new(cases::Tuple{String} = ("!=", "<", "<="), left = Set(), name::String = "one empty, one non-empty", right = Set([1, 2]))
cases = cases
left = left
name = name
right = right
new(cases, left, name, right)
end

                end
                

@oodef mutable struct TestSubsetPartial <: {TestSubsets, unittest.TestCase}
                    
                    cases::Tuple{String}
left
name::String
right
                    
function new(cases::Tuple{String} = ("!=", "<", "<="), left = Set([1]), name::String = "one a non-empty proper subset of other", right = Set([1, 2]))
cases = cases
left = left
name = name
right = right
new(cases, left, name, right)
end

                end
                

@oodef mutable struct TestSubsetNonOverlap <: {TestSubsets, unittest.TestCase}
                    
                    cases::String
left
name::String
right
                    
function new(cases::String = "!=", left = Set([1]), name::String = "neither empty, neither contains", right = Set([2]))
cases = cases
left = left
name = name
right = right
new(cases, left, name, right)
end

                end
                

@oodef mutable struct TestOnlySetsInBinaryOps
                    
                    
                    
                end
                function test_eq_ne(self::@like(TestOnlySetsInBinaryOps))
assertEqual(self, self.other == self.set, false)
assertEqual(self, self.set == self.other, false)
assertEqual(self, self.other != self.set, true)
assertEqual(self, self.set != self.other, true)
end

function test_ge_gt_le_lt(self::@like(TestOnlySetsInBinaryOps))
assertRaises(self, TypeError, () -> self.set < self.other)
assertRaises(self, TypeError, () -> self.set <= self.other)
assertRaises(self, TypeError, () -> self.set > self.other)
assertRaises(self, TypeError, () -> self.set >= self.other)
assertRaises(self, TypeError, () -> self.other < self.set)
assertRaises(self, TypeError, () -> self.other <= self.set)
assertRaises(self, TypeError, () -> self.other > self.set)
assertRaises(self, TypeError, () -> self.other >= self.set)
end

function test_update_operator(self::@like(TestOnlySetsInBinaryOps))
try
self.set |= self.other
catch exn
if exn isa TypeError
#= pass =#
end
end
end

function test_update(self::@like(TestOnlySetsInBinaryOps))
if self.otherIsIterable
update(self.set, self.other)
else
assertRaises(self, TypeError, self.set.update, self.other)
end
end

function test_union(self::@like(TestOnlySetsInBinaryOps))
assertRaises(self, TypeError, () -> self.set | self.other)
assertRaises(self, TypeError, () -> self.other | self.set)
if self.otherIsIterable
union(self.set, self.other)
else
assertRaises(self, TypeError, self.set.union, self.other)
end
end

function test_intersection_update_operator(self::@like(TestOnlySetsInBinaryOps))
try
self.set &= self.other
catch exn
if exn isa TypeError
#= pass =#
end
end
end

function test_intersection_update(self::@like(TestOnlySetsInBinaryOps))
if self.otherIsIterable
intersection_update(self.set, self.other)
else
assertRaises(self, TypeError, self.set.intersection_update, self.other)
end
end

function test_intersection(self::@like(TestOnlySetsInBinaryOps))
assertRaises(self, TypeError, () -> self.set & self.other)
assertRaises(self, TypeError, () -> self.other & self.set)
if self.otherIsIterable
intersection(self.set, self.other)
else
assertRaises(self, TypeError, self.set.intersection, self.other)
end
end

function test_sym_difference_update_operator(self::@like(TestOnlySetsInBinaryOps))
try
self.set ⊻= self.other
catch exn
if exn isa TypeError
#= pass =#
end
end
end

function test_sym_difference_update(self::@like(TestOnlySetsInBinaryOps))
if self.otherIsIterable
symmetric_difference_update(self.set, self.other)
else
assertRaises(self, TypeError, self.set.symmetric_difference_update, self.other)
end
end

function test_sym_difference(self::@like(TestOnlySetsInBinaryOps))
assertRaises(self, TypeError, () -> self.set ⊻ self.other)
assertRaises(self, TypeError, () -> self.other ⊻ self.set)
if self.otherIsIterable
symmetric_difference(self.set, self.other)
else
assertRaises(self, TypeError, self.set.symmetric_difference, self.other)
end
end

function test_difference_update_operator(self::@like(TestOnlySetsInBinaryOps))
try
self.set -= self.other
catch exn
if exn isa TypeError
#= pass =#
end
end
end

function test_difference_update(self::@like(TestOnlySetsInBinaryOps))
if self.otherIsIterable
difference_update(self.set, self.other)
else
assertRaises(self, TypeError, self.set.difference_update, self.other)
end
end

function test_difference(self::@like(TestOnlySetsInBinaryOps))
assertRaises(self, TypeError, () -> self.set - self.other)
assertRaises(self, TypeError, () -> self.other - self.set)
if self.otherIsIterable
difference(self.set, self.other)
else
assertRaises(self, TypeError, self.set.difference, self.other)
end
end


@oodef mutable struct TestOnlySetsNumeric <: {TestOnlySetsInBinaryOps, unittest.TestCase}
                    
                    other::Int64
otherIsIterable::Bool
set
                    
function new(other::Int64 = 19, otherIsIterable::Bool = false, set = Set((1, 2, 3)))
other = other
otherIsIterable = otherIsIterable
set = set
new(other, otherIsIterable, set)
end

                end
                function setUp(self::@like(TestOnlySetsNumeric))
self.set = Set((1, 2, 3))
self.other = 19
self.otherIsIterable = false
end


@oodef mutable struct TestOnlySetsDict <: {TestOnlySetsInBinaryOps, unittest.TestCase}
                    
                    other::Dict{Int64, Int64}
otherIsIterable::Bool
set
                    
function new(other::Dict{Int64, Int64} = Dict{Int64, Int64}(1 => 2, 3 => 4), otherIsIterable::Bool = true, set = Set((1, 2, 3)))
other = other
otherIsIterable = otherIsIterable
set = set
new(other, otherIsIterable, set)
end

                end
                function setUp(self::@like(TestOnlySetsDict))
self.set = Set((1, 2, 3))
self.other = Dict{Int64, Int64}(1 => 2, 3 => 4)
self.otherIsIterable = true
end


@oodef mutable struct TestOnlySetsOperator <: {TestOnlySetsInBinaryOps, unittest.TestCase}
                    
                    other
otherIsIterable::Bool
set
                    
function new(other = operator.add, otherIsIterable::Bool = false, set = Set((1, 2, 3)))
other = other
otherIsIterable = otherIsIterable
set = set
new(other, otherIsIterable, set)
end

                end
                function setUp(self::@like(TestOnlySetsOperator))
self.set = Set((1, 2, 3))
self.other = operator.add
self.otherIsIterable = false
end


@oodef mutable struct TestOnlySetsTuple <: {TestOnlySetsInBinaryOps, unittest.TestCase}
                    
                    other::Tuple{Int64}
otherIsIterable::Bool
set
                    
function new(other::Tuple{Int64} = (2, 4, 6), otherIsIterable::Bool = true, set = Set((1, 2, 3)))
other = other
otherIsIterable = otherIsIterable
set = set
new(other, otherIsIterable, set)
end

                end
                function setUp(self::@like(TestOnlySetsTuple))
self.set = Set((1, 2, 3))
self.other = (2, 4, 6)
self.otherIsIterable = true
end


@oodef mutable struct TestOnlySetsString <: {TestOnlySetsInBinaryOps, unittest.TestCase}
                    
                    other::String
otherIsIterable::Bool
set
                    
function new(other::String = "abc", otherIsIterable::Bool = true, set = Set((1, 2, 3)))
other = other
otherIsIterable = otherIsIterable
set = set
new(other, otherIsIterable, set)
end

                end
                function setUp(self::@like(TestOnlySetsString))
self.set = Set((1, 2, 3))
self.other = "abc"
self.otherIsIterable = true
end


@resumable function gen()
for i in 0:2:9
@yield i
end
end

@oodef mutable struct TestOnlySetsGenerator <: {TestOnlySetsInBinaryOps, unittest.TestCase}
                    
                    other
otherIsIterable::Bool
set
                    
function new(other = gen(), otherIsIterable::Bool = true, set = Set((1, 2, 3)))
other = other
otherIsIterable = otherIsIterable
set = set
new(other, otherIsIterable, set)
end

                end
                @resumable function setUp(self::@like(TestOnlySetsGenerator))
self.set = Set((1, 2, 3))
self.other = gen()
self.otherIsIterable = true
end


@oodef mutable struct TestCopying
                    
                    
                    
                end
                function test_copy(self::@like(TestCopying))
dup = copy(self.set)
dup_list = sorted(dup, key = repr)
set_list = sorted(self.set, key = repr)
assertEqual(self, length(dup_list), length(set_list))
for i in 0:length(dup_list) - 1
assertTrue(self, dup_list[i + 1] === set_list[i + 1])
end
end

function test_deep_copy(self::@like(TestCopying))
dup = copy.deepcopy(self.set)
dup_list = sorted(dup, key = repr)
set_list = sorted(self.set, key = repr)
assertEqual(self, length(dup_list), length(set_list))
for i in 0:length(dup_list) - 1
assertEqual(self, dup_list[i + 1], set_list[i + 1])
end
end


@oodef mutable struct TestCopyingEmpty <: {TestCopying, unittest.TestCase}
                    
                    set
                    
function new(set = Set())
set = set
new(set)
end

                end
                function setUp(self::@like(TestCopyingEmpty))
self.set = Set()
end


@oodef mutable struct TestCopyingSingleton <: {TestCopying, unittest.TestCase}
                    
                    set
                    
function new(set = Set(["hello"]))
set = set
new(set)
end

                end
                function setUp(self::@like(TestCopyingSingleton))
self.set = Set(["hello"])
end


@oodef mutable struct TestCopyingTriple <: {TestCopying, unittest.TestCase}
                    
                    set
                    
function new(set = Set(["zero", 0, nothing]))
set = set
new(set)
end

                end
                function setUp(self::@like(TestCopyingTriple))
self.set = Set(["zero", 0, nothing])
end


@oodef mutable struct TestCopyingTuple <: {TestCopying, unittest.TestCase}
                    
                    set
                    
function new(set = Set([(1, 2)]))
set = set
new(set)
end

                end
                function setUp(self::@like(TestCopyingTuple))
self.set = Set([(1, 2)])
end


@oodef mutable struct TestCopyingNested <: {TestCopying, unittest.TestCase}
                    
                    set
                    
function new(set = Set([((1, 2), (3, 4))]))
set = set
new(set)
end

                end
                function setUp(self::@like(TestCopyingNested))
self.set = Set([((1, 2), (3, 4))])
end


@oodef mutable struct TestIdentities <: unittest.TestCase
                    
                    a
b
                    
function new(a = Set("abracadabra"), b = Set("alacazam"))
a = a
b = b
new(a, b)
end

                end
                function setUp(self::@like(TestIdentities))
self.a = Set("abracadabra")
self.b = Set("alacazam")
end

function test_binopsVsSubsets(self::@like(TestIdentities))
(a, b) = (self.a, self.b)
@test (a - b) < a
@test (b - a) < b
@test (a & b) < a
@test (a & b) < b
@test (a | b) > a
@test (a | b) > b
@test (a ⊻ b) < (a | b)
end

function test_commutativity(self::@like(TestIdentities))
(a, b) = (self.a, self.b)
@test (a & b == b & a)
@test (a | b == b | a)
@test (a ⊻ b == b ⊻ a)
if a != b
@test (a - b != b - a)
end
end

function test_summations(self::@like(TestIdentities))
(a, b) = (self.a, self.b)
@test (((a - b) | (a & b)) | (b - a) == a | b)
@test ((a & b) | (a ⊻ b) == a | b)
@test (a | (b - a) == a | b)
@test ((a - b) | b == a | b)
@test ((a - b) | (a & b) == a)
@test ((b - a) | (a & b) == b)
@test ((a - b) | (b - a) == a ⊻ b)
end

function test_exclusion(self::@like(TestIdentities))
(a, b, zero_) = (self.a, self.b, Set())
@test ((a - b) & b == zero)
@test ((b - a) & a == zero)
@test ((a & b) & (a ⊻ b) == zero)
end


@resumable function R(seqn)
for i in seqn
@yield i
end
end

@oodef mutable struct G
                    #= Sequence using __getitem__ =#

                    seqn
                    
function new(seqn)
@mk begin
seqn = seqn
end
end

                end
                function __getitem__(self::@like(G), i)
return self.seqn[i + 1]
end


@oodef mutable struct I
                    #= Sequence using iterator protocol =#

                    seqn
i::Int64
                    
function new(seqn, i::Int64 = 0)
@mk begin
seqn = seqn
i = i
end
end

                end
                function __iter__(self::@like(I))
return self
end

function __next__(self::@like(I))
if self.i >= length(self.seqn)
throw(StopIteration)
end
v = self.seqn[self.i + 1]
self.i += 1
return v
end


@oodef mutable struct Ig
                    #= Sequence using iterator protocol defined with a generator =#

                    seqn
i::Int64
                    
function new(seqn, i::Int64 = 0)
@mk begin
seqn = seqn
i = i
end
end

                end
                @resumable function __iter__(self::@like(Ig))
for val in self.seqn
@yield val
end
end


@oodef mutable struct X
                    #= Missing __getitem__ and __iter__ =#

                    seqn
i::Int64
                    
function new(seqn, i::Int64 = 0)
@mk begin
seqn = seqn
i = i
end
end

                end
                function __next__(self::@like(X))
if self.i >= length(self.seqn)
throw(StopIteration)
end
v = self.seqn[self.i + 1]
self.i += 1
return v
end


@oodef mutable struct N
                    #= Iterator missing __next__() =#

                    seqn
i::Int64
                    
function new(seqn, i::Int64 = 0)
@mk begin
seqn = seqn
i = i
end
end

                end
                function __iter__(self::@like(N))
return self
end


@oodef mutable struct E
                    #= Test propagation of exceptions =#

                    seqn
i::Int64
                    
function new(seqn, i::Int64 = 0)
@mk begin
seqn = seqn
i = i
end
end

                end
                function __iter__(self::@like(E))
return self
end

function __next__(self::@like(E))
3 ÷ 0
end


@oodef mutable struct S
                    #= Test immediate stop =#

                    
                    
function new(seqn)
#= pass =#
@mk begin

end
end

                end
                function __iter__(self::@like(S))
return self
end

function __next__(self::@like(S))
throw(StopIteration)
end



function L(seqn)
#= Test multiple tiers of iterators =#
return chain(map((x) -> x, R(Ig(G(seqn)))))
end

@oodef mutable struct TestVariousIteratorArgs <: unittest.TestCase
                    
                    
                    
                end
                function test_constructor(self::@like(TestVariousIteratorArgs))
for cons in (set, pset)
for s in ("123", "", 0:999, ("do", 1.2), 2000:5:2199)
for g in (G, I, Ig, S, L, R)
@test (sorted(cons(g(s)), key = repr) == sorted(g(s), key = repr))
end
@test_throws
@test_throws
@test_throws
end
end
end

function test_inline_methods(self::@like(TestVariousIteratorArgs))
s = Set("november")
for data in ("123", "", 0:999, ("do", 1.2), 2000:5:2199, "december")
for meth in (s.union, s.intersection, s.difference, s.symmetric_difference, s.isdisjoint)
for g in (G, I, Ig, L, R)
expected = meth(data)
actual = meth(g(data))
if isa(expected, Bool)
@test (actual == expected)
else
@test (sorted(actual, key = repr) == sorted(expected, key = repr))
end
end
@test_throws
@test_throws
@test_throws
end
end
end

function test_inplace_methods(self::@like(TestVariousIteratorArgs))
for data in ("123", "", 0:999, ("do", 1.2), 2000:5:2199, "december")
for methname in ("update", "intersection_update", "difference_update", "symmetric_difference_update")
for g in (G, I, Ig, S, L, R)
s = Set("january")
t = copy(s)
getfield(s, :methname)(collect(g(data)))
getfield(t, :methname)(g(data))
@test (sorted(s, key = repr) == sorted(t, key = repr))
end
@test_throws
@test_throws
@test_throws
end
end
end


@oodef mutable struct bad_eq
                    
                    
                    
                end
                function __eq__(self::@like(bad_eq), other)::Bool
if be_bad
clear(set2)
throw(ZeroDivisionError)
end
return self === other
end

function __hash__(self::@like(bad_eq))::Int64
return 0
end


@oodef mutable struct bad_dict_clear
                    
                    
                    
                end
                function __eq__(self::@like(bad_dict_clear), other)::Bool
if be_bad
clear(dict2)
end
return self === other
end

function __hash__(self::@like(bad_dict_clear))::Int64
return 0
end


@oodef mutable struct X
                    
                    
                    
                end
                function __hash__(self::@like(X))
return hash(0)
end

function __eq__(self::@like(X), o)::Bool
clear(other)
return false
end


@oodef mutable struct TestWeirdBugs <: unittest.TestCase
                    
                    
                    
                end
                function test_8420_set_merge(self::@like(TestWeirdBugs))
global be_bad, set2, dict2
be_bad = false
set1 = Set([bad_eq()])
set2 = (bad_eq() for i in 0:74)
be_bad = true
@test_throws
be_bad = false
set1 = Set([bad_dict_clear()])
dict2 = Dict{bad_dict_clear, Any}(bad_dict_clear() => nothing)
be_bad = true
symmetric_difference_update(set1, dict2)
end

function test_iter_and_mutate(self::@like(TestWeirdBugs))
s = Set(0:99)
clear(s)
update(s, 0:99)
si = (x for x in s)
clear(s)
a = collect(0:99)
update(s, 0:99)
collect(si)
end

function test_merge_and_mutate(self::@like(TestWeirdBugs))
other = Set()
other = (X() for i in 0:9)
s = Set([0])
update(s, other)
end


@oodef mutable struct Bad
                    
                    
                    
                end
                function __eq__(self::@like(Bad), other)::Bool
if !enabled
return false
end
if randrange(20) == 0
clear(set1)
end
if randrange(20) == 0
clear(set2)
end
return Bool(randrange(2))
end

function __hash__(self::@like(Bad))
return randrange(2)
end


@oodef mutable struct TestOperationsMutating
                    #= Regression test for bpo-46615 =#

                    constructor1
constructor2
                    
function new(constructor1 = nothing, constructor2 = nothing)
constructor1 = constructor1
constructor2 = constructor2
new(constructor1, constructor2)
end

                end
                function make_sets_of_bad_objects(self::@like(TestOperationsMutating))::Tuple
enabled = false
set1 = constructor1(self, (Bad() for _ in 0:randrange(50) - 1))
set2 = constructor2(self, (Bad() for _ in 0:randrange(50) - 1))
enabled = true
return (set1, set2)
end

function check_set_op_does_not_crash(self::@like(TestOperationsMutating), function_)
for _ in 0:99
(set1, set2) = make_sets_of_bad_objects(self)
try
function_(set1, set2)
catch exn
 let e = exn
if e isa RuntimeError
assertIn(self, "changed size during iteration", string(e))
end
end
end
end
end


@oodef mutable struct TestBinaryOpsMutating <: TestOperationsMutating
                    
                    
                    
                end
                function test_eq_with_mutation(self::@like(TestBinaryOpsMutating))
check_set_op_does_not_crash(self, (a, b) -> a == b)
end

function test_ne_with_mutation(self::@like(TestBinaryOpsMutating))
check_set_op_does_not_crash(self, (a, b) -> a != b)
end

function test_lt_with_mutation(self::@like(TestBinaryOpsMutating))
check_set_op_does_not_crash(self, (a, b) -> a < b)
end

function test_le_with_mutation(self::@like(TestBinaryOpsMutating))
check_set_op_does_not_crash(self, (a, b) -> a <= b)
end

function test_gt_with_mutation(self::@like(TestBinaryOpsMutating))
check_set_op_does_not_crash(self, (a, b) -> a > b)
end

function test_ge_with_mutation(self::@like(TestBinaryOpsMutating))
check_set_op_does_not_crash(self, (a, b) -> a >= b)
end

function test_and_with_mutation(self::@like(TestBinaryOpsMutating))
check_set_op_does_not_crash(self, (a, b) -> a & b)
end

function test_or_with_mutation(self::@like(TestBinaryOpsMutating))
check_set_op_does_not_crash(self, (a, b) -> a | b)
end

function test_sub_with_mutation(self::@like(TestBinaryOpsMutating))
check_set_op_does_not_crash(self, (a, b) -> a - b)
end

function test_xor_with_mutation(self::@like(TestBinaryOpsMutating))
check_set_op_does_not_crash(self, (a, b) -> a ⊻ b)
end

function test_iadd_with_mutation(self::@like(TestBinaryOpsMutating))
function f(a::@like(TestBinaryOpsMutating), b)
a &= b
end

check_set_op_does_not_crash(self, f)
end

function test_ior_with_mutation(self::@like(TestBinaryOpsMutating))
function f(a::@like(TestBinaryOpsMutating), b)
a |= b
end

check_set_op_does_not_crash(self, f)
end

function test_isub_with_mutation(self::@like(TestBinaryOpsMutating))
function f(a::@like(TestBinaryOpsMutating), b)
a -= b
end

check_set_op_does_not_crash(self, f)
end

function test_ixor_with_mutation(self::@like(TestBinaryOpsMutating))
function f(a::@like(TestBinaryOpsMutating), b)
a ⊻= b
end

check_set_op_does_not_crash(self, f)
end

function test_iteration_with_mutation(self::@like(TestBinaryOpsMutating))
function f1(a::@like(TestBinaryOpsMutating), b)
for x in a
#= pass =#
end
for y in b
#= pass =#
end
end

function f2(a::@like(TestBinaryOpsMutating), b)
for y in b
#= pass =#
end
for x in a
#= pass =#
end
end

function f3(a::@like(TestBinaryOpsMutating), b)
for (x, y) in zip(a, b)
#= pass =#
end
end

check_set_op_does_not_crash(self, f1)
check_set_op_does_not_crash(self, f2)
check_set_op_does_not_crash(self, f3)
end


@oodef mutable struct TestBinaryOpsMutating_Set_Set <: {TestBinaryOpsMutating, unittest.TestCase}
                    
                    constructor1
constructor2
                    
function new(constructor1 = set, constructor2 = set)
constructor1 = constructor1
constructor2 = constructor2
new(constructor1, constructor2)
end

                end
                

@oodef mutable struct TestBinaryOpsMutating_Subclass_Subclass <: {TestBinaryOpsMutating, unittest.TestCase}
                    
                    constructor1::AbstractSetSubclass
constructor2::AbstractSetSubclass
                    
function new(constructor1::SetSubclass = SetSubclass, constructor2::SetSubclass = SetSubclass)
constructor1 = constructor1
constructor2 = constructor2
new(constructor1, constructor2)
end

                end
                

@oodef mutable struct TestBinaryOpsMutating_Set_Subclass <: {TestBinaryOpsMutating, unittest.TestCase}
                    
                    constructor1
constructor2::AbstractSetSubclass
                    
function new(constructor1 = set, constructor2::SetSubclass = SetSubclass)
constructor1 = constructor1
constructor2 = constructor2
new(constructor1, constructor2)
end

                end
                

@oodef mutable struct TestBinaryOpsMutating_Subclass_Set <: {TestBinaryOpsMutating, unittest.TestCase}
                    
                    constructor1::AbstractSetSubclass
constructor2
                    
function new(constructor1::SetSubclass = SetSubclass, constructor2 = set)
constructor1 = constructor1
constructor2 = constructor2
new(constructor1, constructor2)
end

                end
                

@oodef mutable struct TestMethodsMutating <: TestOperationsMutating
                    
                    
                    
                end
                function test_issubset_with_mutation(self::@like(TestMethodsMutating))
check_set_op_does_not_crash(self, set.issubset)
end

function test_issuperset_with_mutation(self::@like(TestMethodsMutating))
check_set_op_does_not_crash(self, set.issuperset)
end

function test_intersection_with_mutation(self::@like(TestMethodsMutating))
check_set_op_does_not_crash(self, set.intersection)
end

function test_union_with_mutation(self::@like(TestMethodsMutating))
check_set_op_does_not_crash(self, set.union)
end

function test_difference_with_mutation(self::@like(TestMethodsMutating))
check_set_op_does_not_crash(self, set.difference)
end

function test_symmetric_difference_with_mutation(self::@like(TestMethodsMutating))
check_set_op_does_not_crash(self, set.symmetric_difference)
end

function test_isdisjoint_with_mutation(self::@like(TestMethodsMutating))
check_set_op_does_not_crash(self, set.isdisjoint)
end

function test_difference_update_with_mutation(self::@like(TestMethodsMutating))
check_set_op_does_not_crash(self, set.difference_update)
end

function test_intersection_update_with_mutation(self::@like(TestMethodsMutating))
check_set_op_does_not_crash(self, set.intersection_update)
end

function test_symmetric_difference_update_with_mutation(self::@like(TestMethodsMutating))
check_set_op_does_not_crash(self, set.symmetric_difference_update)
end

function test_update_with_mutation(self::@like(TestMethodsMutating))
check_set_op_does_not_crash(self, set.update)
end


@oodef mutable struct TestMethodsMutating_Set_Set <: {TestMethodsMutating, unittest.TestCase}
                    
                    constructor1
constructor2
                    
function new(constructor1 = set, constructor2 = set)
constructor1 = constructor1
constructor2 = constructor2
new(constructor1, constructor2)
end

                end
                

@oodef mutable struct TestMethodsMutating_Subclass_Subclass <: {TestMethodsMutating, unittest.TestCase}
                    
                    constructor1::AbstractSetSubclass
constructor2::AbstractSetSubclass
                    
function new(constructor1::SetSubclass = SetSubclass, constructor2::SetSubclass = SetSubclass)
constructor1 = constructor1
constructor2 = constructor2
new(constructor1, constructor2)
end

                end
                

@oodef mutable struct TestMethodsMutating_Set_Subclass <: {TestMethodsMutating, unittest.TestCase}
                    
                    constructor1
constructor2::AbstractSetSubclass
                    
function new(constructor1 = set, constructor2::SetSubclass = SetSubclass)
constructor1 = constructor1
constructor2 = constructor2
new(constructor1, constructor2)
end

                end
                

@oodef mutable struct TestMethodsMutating_Subclass_Set <: {TestMethodsMutating, unittest.TestCase}
                    
                    constructor1::AbstractSetSubclass
constructor2
                    
function new(constructor1::SetSubclass = SetSubclass, constructor2 = set)
constructor1 = constructor1
constructor2 = constructor2
new(constructor1, constructor2)
end

                end
                

@oodef mutable struct TestMethodsMutating_Set_Dict <: {TestMethodsMutating, unittest.TestCase}
                    
                    constructor1
constructor2
                    
function new(constructor1 = set, constructor2 = dict.fromkeys)
constructor1 = constructor1
constructor2 = constructor2
new(constructor1, constructor2)
end

                end
                

@oodef mutable struct TestMethodsMutating_Set_List <: {TestMethodsMutating, unittest.TestCase}
                    
                    constructor1
constructor2
                    
function new(constructor1 = set, constructor2 = Vector)
constructor1 = constructor1
constructor2 = constructor2
new(constructor1, constructor2)
end

                end
                

@resumable function powerset(U)
U = (x for x in U)
try
x = frozenset([next(U)])
for S in powerset(U)
@yield S
@yield __or__(S, x)
end
catch exn
if exn isa StopIteration
@yield frozenset()
end
end
end

function cube(n)
#= Graph of n-dimensional hypercube. =#
singletons = [frozenset([x]) for x in 0:n - 1]
return dict([(x, frozenset([x ⊻ s for s in singletons])) for x in powerset(0:n - 1)])
end

function linegraph(G)::Dict
#= Graph, the vertices of which are edges of G,
    with two vertices being adjacent iff the corresponding
    edges share a vertex. =#
L = Dict()
for x in G
for y in G[x + 1]
nx = [frozenset([x, z]) for z in G[x + 1] if z != y ]
ny = [frozenset([y, z]) for z in G[y + 1] if z != x ]
L[frozenset((x, y))] = frozenset(nx + ny)
end
end
return L
end

function faces(G)
#= Return a set of faces in G.  Where a face is a set of vertices on that face =#
f = Set()
for (v1, edges) in G.items()
for v2 in edges
for v3 in G[v2 + 1]
if v1 == v3
continue;
end
if v1 ∈ G[v3 + 1]
add(f, frozenset([v1, v2, v3]))
else
for v4 in G[v3 + 1]
if v4 == v2
continue;
end
if v1 ∈ G[v4 + 1]
add(f, frozenset([v1, v2, v3, v4]))
else
for v5 in G[v4 + 1]
if v5 == v3||v5 == v2
continue;
end
if v1 ∈ G[v5 + 1]
add(f, frozenset([v1, v2, v3, v4, v5]))
end
end
end
end
end
end
end
end
return f
end

@oodef mutable struct TestGraphs <: unittest.TestCase
                    
                    
                    
                end
                function test_cube(self::@like(TestGraphs))
g = cube(3)
vertices1 = Set(g)
@test (length(vertices1) == 8)
for edge in values(g)
@test (length(edge) == 3)
end
vertices2 = Set((v for edges in values(g) for v in edges))
@test (vertices1 == vertices2)
cubefaces = faces(g)
@test (length(cubefaces) == 6)
for face in cubefaces
@test (length(face) == 4)
end
end

function test_cuboctahedron(self::@like(TestGraphs))
g = cube(3)
cuboctahedron = linegraph(g)
@test (length(cuboctahedron) == 12)
vertices = Set(cuboctahedron)
for edges in values(cuboctahedron)
@test (length(edges) == 4)
end
othervertices = Set((edge for edges in values(cuboctahedron) for edge in edges))
@test (vertices == othervertices)
cubofaces = faces(cuboctahedron)
facesizes = collections.defaultdict(Int64)
for face in cubofaces
facesizes[length(face) + 1] += 1
end
@test (facesizes[4] == 8)
@test (facesizes[5] == 6)
for vertex in cuboctahedron
edge = vertex
@test (length(edge) == 2)
for cubevert in edge
assertIn(self, cubevert, g)
end
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
test_hex_oct_bin = TestHexOctBin()
test_hex_baseline(test_hex_oct_bin)
test_hex_unsigned(test_hex_oct_bin)
test_oct_baseline(test_hex_oct_bin)
test_oct_unsigned(test_hex_oct_bin)
test_bin_baseline(test_hex_oct_bin)
test_bin_unsigned(test_hex_oct_bin)
test_is_instance_exceptions = TestIsInstanceExceptions()
test_class_has_no_bases(test_is_instance_exceptions)
test_bases_raises_other_than_attribute_error(test_is_instance_exceptions)
test_dont_mask_non_attribute_error(test_is_instance_exceptions)
test_mask_attribute_error(test_is_instance_exceptions)
test_isinstance_dont_mask_non_attribute_error(test_is_instance_exceptions)
test_is_subclass_exceptions = TestIsSubclassExceptions()
test_dont_mask_non_attribute_error(test_is_subclass_exceptions)
test_mask_attribute_error(test_is_subclass_exceptions)
test_dont_mask_non_attribute_error_in_cls_arg(test_is_subclass_exceptions)
test_mask_attribute_error_in_cls_arg(test_is_subclass_exceptions)
test_is_instance_is_subclass = TestIsInstanceIsSubclass()
test_isinstance_normal(test_is_instance_is_subclass)
test_isinstance_abstract(test_is_instance_is_subclass)
test_subclass_normal(test_is_instance_is_subclass)
test_subclass_abstract(test_is_instance_is_subclass)
test_subclass_tuple(test_is_instance_is_subclass)
test_subclass_recursion_limit(test_is_instance_is_subclass)
test_isinstance_recursion_limit(test_is_instance_is_subclass)
test_issubclass_refcount_handling(test_is_instance_is_subclass)
test_infinite_recursion_in_bases(test_is_instance_is_subclass)
test_infinite_recursion_via_bases_tuple(test_is_instance_is_subclass)
test_infinite_cycle_in_bases(test_is_instance_is_subclass)
test_infinitely_many_bases(test_is_instance_is_subclass)
test_case = TestCase()
test_iter_basic(test_case)
test_iter_idempotency(test_case)
test_iter_for_loop(test_case)
test_iter_independence(test_case)
test_nested_comprehensions_iter(test_case)
test_nested_comprehensions_for(test_case)
test_iter_class_for(test_case)
test_iter_class_iter(test_case)
test_seq_class_for(test_case)
test_seq_class_iter(test_case)
test_mutating_seq_class_iter_pickle(test_case)
test_mutating_seq_class_exhausted_iter(test_case)
test_new_style_iter_class(test_case)
test_iter_callable(test_case)
test_iter_function(test_case)
test_iter_function_stop(test_case)
test_exception_function(test_case)
test_exception_sequence(test_case)
test_stop_sequence(test_case)
test_iter_big_range(test_case)
test_iter_empty(test_case)
test_iter_tuple(test_case)
test_iter_range(test_case)
test_iter_string(test_case)
test_iter_dict(test_case)
test_iter_file(test_case)
test_builtin_list(test_case)
test_builtin_tuple(test_case)
test_builtin_filter(test_case)
test_builtin_max_min(test_case)
test_builtin_map(test_case)
test_builtin_zip(test_case)
test_unicode_join_endcase(test_case)
test_in_and_not_in(test_case)
test_countOf(test_case)
test_indexOf(test_case)
test_writelines(test_case)
test_unpack_iter(test_case)
test_ref_counting_behavior(test_case)
test_sinkstate_list(test_case)
test_sinkstate_tuple(test_case)
test_sinkstate_string(test_case)
test_sinkstate_sequence(test_case)
test_sinkstate_callable(test_case)
test_sinkstate_dict(test_case)
test_sinkstate_yield(test_case)
test_sinkstate_range(test_case)
test_sinkstate_enumerate(test_case)
test_3720(test_case)
test_extending_list_with_iterator_does_not_segfault(test_case)
test_iter_overflow(test_case)
test_iter_neg_setstate(test_case)
test_free_after_iterating(test_case)
test_error_iter(test_case)
test_repeat = TestRepeat()
setUp(test_repeat)
test_xrange = TestXrange()
setUp(test_xrange)
test_xrange_custom_reversed = TestXrangeCustomReversed()
setUp(test_xrange_custom_reversed)
test_tuple = TestTuple()
setUp(test_tuple)
test_deque = TestDeque()
setUp(test_deque)
test_deque_reversed = TestDequeReversed()
setUp(test_deque_reversed)
test_dict_keys = TestDictKeys()
setUp(test_dict_keys)
test_dict_items = TestDictItems()
setUp(test_dict_items)
test_dict_values = TestDictValues()
setUp(test_dict_values)
test_set = TestSet()
setUp(test_set)
test_list = TestList()
setUp(test_list)
test_mutation(test_list)
test_list_reversed = TestListReversed()
setUp(test_list_reversed)
test_mutation(test_list_reversed)
test_length_hint_exceptions = TestLengthHintExceptions()
test_issue1242657(test_length_hint_exceptions)
test_invalid_hint(test_length_hint_exceptions)
keyword_only_arg_test_case = KeywordOnlyArgTestCase()
testSyntaxErrorForFunctionDefinition(keyword_only_arg_test_case)
testSyntaxForManyArguments(keyword_only_arg_test_case)
testTooManyPositionalErrorMessage(keyword_only_arg_test_case)
testSyntaxErrorForFunctionCall(keyword_only_arg_test_case)
testRaiseErrorFuncallWithUnexpectedKeywordArgument(keyword_only_arg_test_case)
testFunctionCall(keyword_only_arg_test_case)
testKwDefaults(keyword_only_arg_test_case)
test_kwonly_methods(keyword_only_arg_test_case)
test_issue13343(keyword_only_arg_test_case)
test_mangling(keyword_only_arg_test_case)
test_default_evaluation_order(keyword_only_arg_test_case)
long_test = LongTest()
test_division(long_test)
test_karatsuba(long_test)
test_bitop_identities(long_test)
test_format(long_test)
test_long(long_test)
test_conversion(long_test)
test_float_conversion(long_test)
test_float_overflow(long_test)
test_logs(long_test)
test_mixed_compares(long_test)
test__format__(long_test)
test_nan_inf(long_test)
test_mod_division(long_test)
test_true_division(long_test)
test_floordiv(long_test)
test_correctly_rounded_true_division(long_test)
test_negative_shift_count(long_test)
test_lshift_of_zero(long_test)
test_huge_lshift_of_zero(long_test)
test_huge_lshift(long_test)
test_huge_rshift(long_test)
test_huge_rshift_of_huge(long_test)
test_small_ints_in_huge_calculation(long_test)
test_small_ints(long_test)
test_bit_length(long_test)
test_bit_count(long_test)
test_round(long_test)
test_to_bytes(long_test)
test_from_bytes(long_test)
test_access_to_nonexistent_digit_0(long_test)
test_shift_bool(long_test)
test_as_integer_ratio(long_test)
long_exp_text = LongExpText()
test_longexp(long_exp_text)
math_tests = MathTests()
testConstants(math_tests)
testAcos(math_tests)
testAcosh(math_tests)
testAsin(math_tests)
testAsinh(math_tests)
testAtan(math_tests)
testAtanh(math_tests)
testAtan2(math_tests)
testCeil(math_tests)
testCopysign(math_tests)
testCos(math_tests)
testCosh(math_tests)
testDegrees(math_tests)
testExp(math_tests)
testFabs(math_tests)
testFactorial(math_tests)
testFactorialNonIntegers(math_tests)
testFactorialHugeInputs(math_tests)
testFloor(math_tests)
testFmod(math_tests)
testFrexp(math_tests)
testFsum(math_tests)
testGcd(math_tests)
testHypot(math_tests)
testHypotAccuracy(math_tests)
testDist(math_tests)
testIsqrt(math_tests)
test_lcm(math_tests)
testLdexp(math_tests)
testLog(math_tests)
testLog1p(math_tests)
testLog2(math_tests)
testLog2Exact(math_tests)
testLog10(math_tests)
testModf(math_tests)
testPow(math_tests)
testRadians(math_tests)
testRemainder(math_tests)
testSin(math_tests)
testSinh(math_tests)
testSqrt(math_tests)
testTan(math_tests)
testTanh(math_tests)
testTanhSign(math_tests)
test_trunc(math_tests)
testIsfinite(math_tests)
testIsnan(math_tests)
testIsinf(math_tests)
test_nan_constant(math_tests)
test_inf_constant(math_tests)
test_exceptions(math_tests)
test_testfile(math_tests)
test_mtestfile(math_tests)
test_prod(math_tests)
testPerm(math_tests)
testComb(math_tests)
test_nextafter(math_tests)
test_ulp(math_tests)
test_issue39871(math_tests)
is_close_tests = IsCloseTests()
test_negative_tolerances(is_close_tests)
test_identical(is_close_tests)
test_eight_decimal_places(is_close_tests)
test_near_zero(is_close_tests)
test_identical_infinite(is_close_tests)
test_inf_ninf_nan(is_close_tests)
test_zero_tolerance(is_close_tests)
test_asymmetry(is_close_tests)
test_integers(is_close_tests)
test_decimals(is_close_tests)
test_fractions(is_close_tests)
hash_test = HashTest()
test_bools(hash_test)
test_integers(hash_test)
test_binary_floats(hash_test)
test_complex(hash_test)
test_decimals(hash_test)
test_fractions(hash_test)
test_hash_normalization(hash_test)
comparison_test = ComparisonTest()
test_mixed_comparisons(comparison_test)
test_complex(comparison_test)
py_operator_test_case = PyOperatorTestCase()
c_operator_test_case = COperatorTestCase()
py_py_operator_pickle_test_case = PyPyOperatorPickleTestCase()
py_c_operator_pickle_test_case = PyCOperatorPickleTestCase()
c_py_operator_pickle_test_case = CPyOperatorPickleTestCase()
c_c_operator_pickle_test_case = CCOperatorPickleTestCase()
pow_test = PowTest()
test_powint(pow_test)
test_powfloat(pow_test)
test_other(pow_test)
test_bug643260(pow_test)
test_bug705231(pow_test)
test_negative_exponent(pow_test)
test_print = TestPrint()
test_print(test_print)
test_print_flush(test_print)
test_py2_migration_hint = TestPy2MigrationHint()
test_normal_string(test_py2_migration_hint)
test_string_with_soft_space(test_py2_migration_hint)
test_string_with_excessive_whitespace(test_py2_migration_hint)
test_string_with_leading_whitespace(test_py2_migration_hint)
test_string_with_semicolon(test_py2_migration_hint)
test_string_in_loop_on_same_line(test_py2_migration_hint)
test_stream_redirection_hint_for_py2_migration(test_py2_migration_hint)
test_raise = TestRaise()
test_invalid_reraise(test_raise)
test_reraise(test_raise)
test_except_reraise(test_raise)
test_finally_reraise(test_raise)
test_nested_reraise(test_raise)
test_raise_from_None(test_raise)
test_with_reraise1(test_raise)
test_with_reraise2(test_raise)
test_yield_reraise(test_raise)
test_erroneous_exception(test_raise)
test_new_returns_invalid_instance(test_raise)
test_assert_with_tuple_arg(test_raise)
test_cause = TestCause()
testCauseSyntax(test_cause)
test_invalid_cause(test_cause)
test_class_cause(test_cause)
test_instance_cause(test_cause)
test_erroneous_cause(test_cause)
test_traceback = TestTraceback()
test_sets_traceback(test_traceback)
test_accepts_traceback(test_traceback)
test_traceback_type = TestTracebackType()
test_attrs(test_traceback_type)
test_constructor(test_traceback_type)
test_context = TestContext()
test_instance_context_instance_raise(test_context)
test_class_context_instance_raise(test_context)
test_class_context_class_raise(test_context)
test_c_exception_context(test_context)
test_c_exception_raise(test_context)
test_noraise_finally(test_context)
test_raise_finally(test_context)
test_context_manager(test_context)
test_cycle_broken(test_context)
test_reraise_cycle_broken(test_context)
test_not_last(test_context)
test_3118(test_context)
test_3611(test_context)
test_removed_functionality = TestRemovedFunctionality()
test_tuples(test_removed_functionality)
test_strings(test_removed_functionality)
system_random__test_basic_ops = SystemRandom_TestBasicOps()
test_autoseed(system_random__test_basic_ops)
test_saverestore(system_random__test_basic_ops)
test_seedargs(system_random__test_basic_ops)
test_gauss(system_random__test_basic_ops)
test_pickling(system_random__test_basic_ops)
test_53_bits_per_float(system_random__test_basic_ops)
test_bigrand(system_random__test_basic_ops)
test_bigrand_ranges(system_random__test_basic_ops)
test_rangelimits(system_random__test_basic_ops)
test_randrange_nonunit_step(system_random__test_basic_ops)
test_randrange_errors(system_random__test_basic_ops)
test_randrange_argument_handling(system_random__test_basic_ops)
test_randrange_step(system_random__test_basic_ops)
test_randbelow_logic(system_random__test_basic_ops)
mersenne_twister__test_basic_ops = MersenneTwister_TestBasicOps()
test_guaranteed_stable(mersenne_twister__test_basic_ops)
test_bug_27706(mersenne_twister__test_basic_ops)
test_bug_31478(mersenne_twister__test_basic_ops)
test_bug_31482(mersenne_twister__test_basic_ops)
test_setstate_first_arg(mersenne_twister__test_basic_ops)
test_setstate_middle_arg(mersenne_twister__test_basic_ops)
test_referenceImplementation(mersenne_twister__test_basic_ops)
test_strong_reference_implementation(mersenne_twister__test_basic_ops)
test_long_seed(mersenne_twister__test_basic_ops)
test_53_bits_per_float(mersenne_twister__test_basic_ops)
test_bigrand(mersenne_twister__test_basic_ops)
test_bigrand_ranges(mersenne_twister__test_basic_ops)
test_rangelimits(mersenne_twister__test_basic_ops)
test_getrandbits(mersenne_twister__test_basic_ops)
test_randrange_uses_getrandbits(mersenne_twister__test_basic_ops)
test_randbelow_logic(mersenne_twister__test_basic_ops)
test_randbelow_without_getrandbits(mersenne_twister__test_basic_ops)
test_randrange_bug_1590891(mersenne_twister__test_basic_ops)
test_choices_algorithms(mersenne_twister__test_basic_ops)
test_randbytes(mersenne_twister__test_basic_ops)
test_randbytes_getrandbits(mersenne_twister__test_basic_ops)
test_sample_counts_equivalence(mersenne_twister__test_basic_ops)
test_distributions = TestDistributions()
test_zeroinputs(test_distributions)
test_avg_std(test_distributions)
test_constant(test_distributions)
test_von_mises_range(test_distributions)
test_von_mises_large_kappa(test_distributions)
test_gammavariate_errors(test_distributions)
test_gammavariate_alpha_greater_one(test_distributions)
test_gammavariate_alpha_equal_one(test_distributions)
test_gammavariate_alpha_equal_one_equals_expovariate(test_distributions)
test_gammavariate_alpha_between_zero_and_one(test_distributions)
test_betavariate_return_zero(test_distributions)
test_random_subclassing = TestRandomSubclassing()
test_random_subclass_with_kwargs(test_random_subclassing)
test_subclasses_overriding_methods(test_random_subclassing)
test_module = TestModule()
testMagicConstants(test_module)
test__all__(test_module)
test_after_fork(test_module)
range_test = RangeTest()
test_range(range_test)
test_range_constructor_error_messages(range_test)
test_large_operands(range_test)
test_large_range(range_test)
test_invalid_invocation(range_test)
test_index(range_test)
test_user_index_method(range_test)
test_count(range_test)
test_repr(range_test)
test_pickling(range_test)
test_iterator_pickling(range_test)
test_iterator_pickling_overflowing_index(range_test)
test_exhausted_iterator_pickling(range_test)
test_large_exhausted_iterator_pickling(range_test)
test_odd_bug(range_test)
test_types(range_test)
test_strided_limits(range_test)
test_empty(range_test)
test_range_iterators(range_test)
test_range_iterators_invocation(range_test)
test_slice(range_test)
test_contains(range_test)
test_reverse_iteration(range_test)
test_issue11845(range_test)
test_comparison(range_test)
test_attributes(range_test)
test_set = TestSet()
test_init(test_set)
test_constructor_identity(test_set)
test_set_literal(test_set)
test_set_literal_insertion_order(test_set)
test_set_literal_evaluation_order(test_set)
test_hash(test_set)
test_clear(test_set)
test_copy(test_set)
test_add(test_set)
test_remove(test_set)
test_remove_keyerror_unpacking(test_set)
test_remove_keyerror_set(test_set)
test_discard(test_set)
test_pop(test_set)
test_update(test_set)
test_ior(test_set)
test_intersection_update(test_set)
test_iand(test_set)
test_difference_update(test_set)
test_isub(test_set)
test_symmetric_difference_update(test_set)
test_ixor(test_set)
test_inplace_on_self(test_set)
test_weakref(test_set)
test_rich_compare(test_set)
test_c_api(test_set)
test_frozen_set = TestFrozenSet()
test_init(test_frozen_set)
test_constructor_identity(test_frozen_set)
test_hash(test_frozen_set)
test_copy(test_frozen_set)
test_frozen_as_dictkey(test_frozen_set)
test_hash_caching(test_frozen_set)
test_hash_effectiveness(test_frozen_set)
test_basic_ops_empty = TestBasicOpsEmpty()
setUp(test_basic_ops_empty)
test_basic_ops_singleton = TestBasicOpsSingleton()
setUp(test_basic_ops_singleton)
test_in(test_basic_ops_singleton)
test_not_in(test_basic_ops_singleton)
test_basic_ops_tuple = TestBasicOpsTuple()
setUp(test_basic_ops_tuple)
test_in(test_basic_ops_tuple)
test_not_in(test_basic_ops_tuple)
test_basic_ops_triple = TestBasicOpsTriple()
setUp(test_basic_ops_triple)
test_basic_ops_string = TestBasicOpsString()
setUp(test_basic_ops_string)
test_repr(test_basic_ops_string)
test_basic_ops_bytes = TestBasicOpsBytes()
setUp(test_basic_ops_bytes)
test_repr(test_basic_ops_bytes)
test_basic_ops_mixed_string_bytes = TestBasicOpsMixedStringBytes()
setUp(test_basic_ops_mixed_string_bytes)
test_repr(test_basic_ops_mixed_string_bytes)
tearDown(test_basic_ops_mixed_string_bytes)
test_exception_propagation = TestExceptionPropagation()
test_instanceWithException(test_exception_propagation)
test_instancesWithoutException(test_exception_propagation)
test_changingSizeWhileIterating(test_exception_propagation)
test_set_of_sets = TestSetOfSets()
test_constructor(test_set_of_sets)
test_binary_ops = TestBinaryOps()
setUp(test_binary_ops)
test_eq(test_binary_ops)
test_union_subset(test_binary_ops)
test_union_superset(test_binary_ops)
test_union_overlap(test_binary_ops)
test_union_non_overlap(test_binary_ops)
test_intersection_subset(test_binary_ops)
test_intersection_superset(test_binary_ops)
test_intersection_overlap(test_binary_ops)
test_intersection_non_overlap(test_binary_ops)
test_isdisjoint_subset(test_binary_ops)
test_isdisjoint_superset(test_binary_ops)
test_isdisjoint_overlap(test_binary_ops)
test_isdisjoint_non_overlap(test_binary_ops)
test_sym_difference_subset(test_binary_ops)
test_sym_difference_superset(test_binary_ops)
test_sym_difference_overlap(test_binary_ops)
test_sym_difference_non_overlap(test_binary_ops)
test_update_ops = TestUpdateOps()
setUp(test_update_ops)
test_union_subset(test_update_ops)
test_union_superset(test_update_ops)
test_union_overlap(test_update_ops)
test_union_non_overlap(test_update_ops)
test_union_method_call(test_update_ops)
test_intersection_subset(test_update_ops)
test_intersection_superset(test_update_ops)
test_intersection_overlap(test_update_ops)
test_intersection_non_overlap(test_update_ops)
test_intersection_method_call(test_update_ops)
test_sym_difference_subset(test_update_ops)
test_sym_difference_superset(test_update_ops)
test_sym_difference_overlap(test_update_ops)
test_sym_difference_non_overlap(test_update_ops)
test_sym_difference_method_call(test_update_ops)
test_difference_subset(test_update_ops)
test_difference_superset(test_update_ops)
test_difference_overlap(test_update_ops)
test_difference_non_overlap(test_update_ops)
test_difference_method_call(test_update_ops)
test_mutate = TestMutate()
setUp(test_mutate)
test_add_present(test_mutate)
test_add_absent(test_mutate)
test_add_until_full(test_mutate)
test_remove_present(test_mutate)
test_remove_absent(test_mutate)
test_remove_until_empty(test_mutate)
test_discard_present(test_mutate)
test_discard_absent(test_mutate)
test_clear(test_mutate)
test_pop(test_mutate)
test_update_empty_tuple(test_mutate)
test_update_unit_tuple_overlap(test_mutate)
test_update_unit_tuple_non_overlap(test_mutate)
test_subset_equal_empty = TestSubsetEqualEmpty()
test_subset_equal_non_empty = TestSubsetEqualNonEmpty()
test_subset_empty_non_empty = TestSubsetEmptyNonEmpty()
test_subset_partial = TestSubsetPartial()
test_subset_non_overlap = TestSubsetNonOverlap()
test_only_sets_numeric = TestOnlySetsNumeric()
setUp(test_only_sets_numeric)
test_only_sets_dict = TestOnlySetsDict()
setUp(test_only_sets_dict)
test_only_sets_operator = TestOnlySetsOperator()
setUp(test_only_sets_operator)
test_only_sets_tuple = TestOnlySetsTuple()
setUp(test_only_sets_tuple)
test_only_sets_string = TestOnlySetsString()
setUp(test_only_sets_string)
test_only_sets_generator = TestOnlySetsGenerator()
setUp(test_only_sets_generator)
test_copying_empty = TestCopyingEmpty()
setUp(test_copying_empty)
test_copying_singleton = TestCopyingSingleton()
setUp(test_copying_singleton)
test_copying_triple = TestCopyingTriple()
setUp(test_copying_triple)
test_copying_tuple = TestCopyingTuple()
setUp(test_copying_tuple)
test_copying_nested = TestCopyingNested()
setUp(test_copying_nested)
test_identities = TestIdentities()
setUp(test_identities)
test_binopsVsSubsets(test_identities)
test_commutativity(test_identities)
test_summations(test_identities)
test_exclusion(test_identities)
test_various_iterator_args = TestVariousIteratorArgs()
test_constructor(test_various_iterator_args)
test_inline_methods(test_various_iterator_args)
test_inplace_methods(test_various_iterator_args)
test_weird_bugs = TestWeirdBugs()
test_8420_set_merge(test_weird_bugs)
test_iter_and_mutate(test_weird_bugs)
test_merge_and_mutate(test_weird_bugs)
test_binary_ops_mutating__set__set = TestBinaryOpsMutating_Set_Set()
test_binary_ops_mutating__subclass__subclass = TestBinaryOpsMutating_Subclass_Subclass()
test_binary_ops_mutating__set__subclass = TestBinaryOpsMutating_Set_Subclass()
test_binary_ops_mutating__subclass__set = TestBinaryOpsMutating_Subclass_Set()
test_methods_mutating__set__set = TestMethodsMutating_Set_Set()
test_methods_mutating__subclass__subclass = TestMethodsMutating_Subclass_Subclass()
test_methods_mutating__set__subclass = TestMethodsMutating_Set_Subclass()
test_methods_mutating__subclass__set = TestMethodsMutating_Subclass_Set()
test_methods_mutating__set__dict = TestMethodsMutating_Set_Dict()
test_methods_mutating__set__list = TestMethodsMutating_Set_List()
test_graphs = TestGraphs()
test_cube(test_graphs)
test_cuboctahedron(test_graphs)
end