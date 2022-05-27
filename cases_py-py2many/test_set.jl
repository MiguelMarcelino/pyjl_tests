using Test



import gc


import copy

using random: randrange, shuffle
import warnings



mutable struct PassThru <: AbstractPassThru

end

abstract type AbstractPassThru <: Exception end
abstract type AbstractHashCountingInt <: int end
abstract type AbstractH <: self.thetype end
abstract type AbstractC <: object end
abstract type AbstractTestSet <: AbstractTestJointOps end
abstract type AbstractSetSubclass <: set end
abstract type AbstractTestSetSubclass <: AbstractTestSet end
abstract type AbstractSetSubclassWithKeywordArgs <: set end
abstract type AbstractTestSetSubclassWithKeywordArgs <: AbstractTestSet end
abstract type AbstractTestFrozenSet <: AbstractTestJointOps end
abstract type AbstractFrozenSetSubclass <: frozenset end
abstract type AbstractTestFrozenSetSubclass <: AbstractTestFrozenSet end
abstract type AbstractTestBasicOpsEmpty <: AbstractTestBasicOps end
abstract type AbstractTestBasicOpsSingleton <: AbstractTestBasicOps end
abstract type AbstractTestBasicOpsTuple <: AbstractTestBasicOps end
abstract type AbstractTestBasicOpsTriple <: AbstractTestBasicOps end
abstract type AbstractTestBasicOpsString <: AbstractTestBasicOps end
abstract type AbstractTestBasicOpsBytes <: AbstractTestBasicOps end
abstract type AbstractTestBasicOpsMixedStringBytes <: AbstractTestBasicOps end
abstract type AbstractTestExceptionPropagation end
abstract type AbstractTestSetOfSets end
abstract type AbstractTestBinaryOps end
abstract type AbstractTestUpdateOps end
abstract type AbstractTestMutate end
abstract type AbstractTestSubsetEqualEmpty <: AbstractTestSubsets end
abstract type AbstractTestSubsetEqualNonEmpty <: AbstractTestSubsets end
abstract type AbstractTestSubsetEmptyNonEmpty <: AbstractTestSubsets end
abstract type AbstractTestSubsetPartial <: AbstractTestSubsets end
abstract type AbstractTestSubsetNonOverlap <: AbstractTestSubsets end
abstract type AbstractTestOnlySetsNumeric <: AbstractTestOnlySetsInBinaryOps end
abstract type AbstractTestOnlySetsDict <: AbstractTestOnlySetsInBinaryOps end
abstract type AbstractTestOnlySetsOperator <: AbstractTestOnlySetsInBinaryOps end
abstract type AbstractTestOnlySetsTuple <: AbstractTestOnlySetsInBinaryOps end
abstract type AbstractTestOnlySetsString <: AbstractTestOnlySetsInBinaryOps end
abstract type AbstractTestOnlySetsGenerator <: AbstractTestOnlySetsInBinaryOps end
abstract type AbstractTestCopyingEmpty <: AbstractTestCopying end
abstract type AbstractTestCopyingSingleton <: AbstractTestCopying end
abstract type AbstractTestCopyingTriple <: AbstractTestCopying end
abstract type AbstractTestCopyingTuple <: AbstractTestCopying end
abstract type AbstractTestCopyingNested <: AbstractTestCopying end
abstract type AbstractTestIdentities end
abstract type AbstractTestVariousIteratorArgs end
abstract type AbstractTestWeirdBugs end
abstract type AbstractTestBinaryOpsMutating <: AbstractTestOperationsMutating end
abstract type AbstractTestBinaryOpsMutating_Set_Set <: AbstractTestBinaryOpsMutating end
abstract type AbstractTestBinaryOpsMutating_Subclass_Subclass <: AbstractTestBinaryOpsMutating end
abstract type AbstractTestBinaryOpsMutating_Set_Subclass <: AbstractTestBinaryOpsMutating end
abstract type AbstractTestBinaryOpsMutating_Subclass_Set <: AbstractTestBinaryOpsMutating end
abstract type AbstractTestMethodsMutating <: AbstractTestOperationsMutating end
abstract type AbstractTestMethodsMutating_Set_Set <: AbstractTestMethodsMutating end
abstract type AbstractTestMethodsMutating_Subclass_Subclass <: AbstractTestMethodsMutating end
abstract type AbstractTestMethodsMutating_Set_Subclass <: AbstractTestMethodsMutating end
abstract type AbstractTestMethodsMutating_Subclass_Set <: AbstractTestMethodsMutating end
abstract type AbstractTestMethodsMutating_Set_Dict <: AbstractTestMethodsMutating end
abstract type AbstractTestMethodsMutating_Set_List <: AbstractTestMethodsMutating end
abstract type AbstractTestGraphs end
function check_pass_thru()
Channel() do ch_check_pass_thru 
throw(PassThru)
put!(ch_check_pass_thru, 1)
end
end

mutable struct BadCmp <: AbstractBadCmp

end
function __hash__(self::BadCmp)::Int64
return 1
end

function __eq__(self::BadCmp, other)
throw(RuntimeError)
end

mutable struct ReprWrapper <: AbstractReprWrapper
#= Used to test self-referential repr() calls =#
value
end
function __repr__(self::ReprWrapper)
return repr(self.value)
end

mutable struct HashCountingInt <: AbstractHashCountingInt
#= int-like object that counts the number of times __hash__ is called =#
hash_count::Int64
end
function __hash__(self::HashCountingInt)
self.hash_count += 1
return __hash__(int)
end

mutable struct TestJointOps <: AbstractTestJointOps
value
word
otherword
letters
s
d
thetype
basetype
end
function setUp(self::TestJointOps)
self.word = "simsalabim"
word = "simsalabim"
self.otherword = "madagascar"
self.letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
self.s = thetype(self, word)
self.d = fromkeys(dict, word)
end

function test_new_or_init(self::TestJointOps)
assertRaises(self, TypeError, self.thetype, [], 2)
assertRaises(self, TypeError, set().__init__, 1)
end

function test_uniquification(self::TestJointOps)
actual = sorted(self.s)
expected = sorted(self.d)
assertEqual(self, actual, expected)
assertRaises(self, PassThru, self.thetype, check_pass_thru())
assertRaises(self, TypeError, self.thetype, [[]])
end

function test_len(self::TestJointOps)
assertEqual(self, length(self.s), length(self.d))
end

function test_contains(self::TestJointOps)
for c in self.letters
assertEqual(self, c ∈ self.s, c ∈ self.d)
end
assertRaises(self, TypeError, self.s.__contains__, [[]])
s = thetype(self, [frozenset(self.letters)])
assertIn(self, thetype(self, self.letters), s)
end

function test_union(self::TestJointOps)
u = union(self.s, self.otherword)
for c in self.letters
assertEqual(self, c ∈ u, c ∈ self.d || c ∈ self.otherword)
end
assertEqual(self, self.s, thetype(self, self.word))
assertEqual(self, type_(u), self.basetype)
assertRaises(self, PassThru, self.s.union, check_pass_thru())
assertRaises(self, TypeError, self.s.union, [[]])
for C in (set, frozenset, dict.fromkeys, str, list, tuple)
assertEqual(self, union(thetype(self, "abcba"), C("cdc")), set("abcd"))
assertEqual(self, union(thetype(self, "abcba"), C("efgfe")), set("abcefg"))
assertEqual(self, union(thetype(self, "abcba"), C("ccb")), set("abc"))
assertEqual(self, union(thetype(self, "abcba"), C("ef")), set("abcef"))
assertEqual(self, union(thetype(self, "abcba"), C("ef"), C("fg")), set("abcefg"))
end
x = thetype(self)
assertEqual(self, union(x, set([1]), x, set([2])), thetype(self, [1, 2]))
end

function test_or(self::TestJointOps)
i = union(self.s, self.otherword)
assertEqual(self, self.s | set(self.otherword), i)
assertEqual(self, self.s | frozenset(self.otherword), i)
try
self.s | self.otherword
catch exn
if exn isa TypeError
#= pass =#
end
end
end

function test_intersection(self::TestJointOps)
i = intersection(self.s, self.otherword)
for c in self.letters
assertEqual(self, c ∈ i, c ∈ self.d && c ∈ self.otherword)
end
assertEqual(self, self.s, thetype(self, self.word))
assertEqual(self, type_(i), self.basetype)
assertRaises(self, PassThru, self.s.intersection, check_pass_thru())
for C in (set, frozenset, dict.fromkeys, str, list, tuple)
assertEqual(self, intersection(thetype(self, "abcba"), C("cdc")), set("cc"))
assertEqual(self, intersection(thetype(self, "abcba"), C("efgfe")), set(""))
assertEqual(self, intersection(thetype(self, "abcba"), C("ccb")), set("bc"))
assertEqual(self, intersection(thetype(self, "abcba"), C("ef")), set(""))
assertEqual(self, intersection(thetype(self, "abcba"), C("cbcf"), C("bag")), set("b"))
end
s = thetype(self, "abcba")
z = intersection(s)
if self.thetype == frozenset()
assertEqual(self, id(s), id(z))
else
assertNotEqual(self, id(s), id(z))
end
end

function test_isdisjoint(self::TestJointOps)
function f(s1, s2)
#= Pure python equivalent of isdisjoint() =#
return !intersection(set(s1), s2)
end

for larg in ("", "a", "ab", "abc", "ababac", "cdc", "cc", "efgfe", "ccb", "ef")
s1 = thetype(self, larg)
for rarg in ("", "a", "ab", "abc", "ababac", "cdc", "cc", "efgfe", "ccb", "ef")
for C in (set, frozenset, dict.fromkeys, str, list, tuple)
s2 = C(rarg)
actual = isdisjoint(s1, s2)
expected = f(s1, s2)
assertEqual(self, actual, expected)
assertTrue(self, actual === true || actual === false)
end
end
end
end

function test_and(self::TestJointOps)
i = intersection(self.s, self.otherword)
assertEqual(self, self.s & set(self.otherword), i)
assertEqual(self, self.s & frozenset(self.otherword), i)
try
self.s & self.otherword
catch exn
if exn isa TypeError
#= pass =#
end
end
end

function test_difference(self::TestJointOps)
i = difference(self.s, self.otherword)
for c in self.letters
assertEqual(self, c ∈ i, c ∈ self.d && c ∉ self.otherword)
end
assertEqual(self, self.s, thetype(self, self.word))
assertEqual(self, type_(i), self.basetype)
assertRaises(self, PassThru, self.s.difference, check_pass_thru())
assertRaises(self, TypeError, self.s.difference, [[]])
for C in (set, frozenset, dict.fromkeys, str, list, tuple)
assertEqual(self, difference(thetype(self, "abcba"), C("cdc")), set("ab"))
assertEqual(self, difference(thetype(self, "abcba"), C("efgfe")), set("abc"))
assertEqual(self, difference(thetype(self, "abcba"), C("ccb")), set("a"))
assertEqual(self, difference(thetype(self, "abcba"), C("ef")), set("abc"))
assertEqual(self, difference(thetype(self, "abcba")), set("abc"))
assertEqual(self, difference(thetype(self, "abcba"), C("a"), C("b")), set("c"))
end
end

function test_sub(self::TestJointOps)
i = difference(self.s, self.otherword)
assertEqual(self, self.s - set(self.otherword), i)
assertEqual(self, self.s - frozenset(self.otherword), i)
try
self.s - self.otherword
catch exn
if exn isa TypeError
#= pass =#
end
end
end

function test_symmetric_difference(self::TestJointOps)
i = symmetric_difference(self.s, self.otherword)
for c in self.letters
assertEqual(self, c ∈ i, c ∈ self.d  ⊻  c ∈ self.otherword)
end
assertEqual(self, self.s, thetype(self, self.word))
assertEqual(self, type_(i), self.basetype)
assertRaises(self, PassThru, self.s.symmetric_difference, check_pass_thru())
assertRaises(self, TypeError, self.s.symmetric_difference, [[]])
for C in (set, frozenset, dict.fromkeys, str, list, tuple)
assertEqual(self, symmetric_difference(thetype(self, "abcba"), C("cdc")), set("abd"))
assertEqual(self, symmetric_difference(thetype(self, "abcba"), C("efgfe")), set("abcefg"))
assertEqual(self, symmetric_difference(thetype(self, "abcba"), C("ccb")), set("a"))
assertEqual(self, symmetric_difference(thetype(self, "abcba"), C("ef")), set("abcef"))
end
end

function test_xor(self::TestJointOps)
i = symmetric_difference(self.s, self.otherword)
assertEqual(self, self.s  ⊻  set(self.otherword), i)
assertEqual(self, self.s  ⊻  frozenset(self.otherword), i)
try
self.s  ⊻  self.otherword
catch exn
if exn isa TypeError
#= pass =#
end
end
end

function test_equality(self::TestJointOps)
assertEqual(self, self.s, set(self.word))
assertEqual(self, self.s, frozenset(self.word))
assertEqual(self, self.s == self.word, false)
assertNotEqual(self, self.s, set(self.otherword))
assertNotEqual(self, self.s, frozenset(self.otherword))
assertEqual(self, self.s != self.word, true)
end

function test_setOfFrozensets(self::TestJointOps)
t = map(frozenset, ["abcdef", "bcd", "bdcb", "fed", "fedccba"])
s = thetype(self, t)
assertEqual(self, length(s), 3)
end

function test_sub_and_super(self::TestJointOps)
p, q, r = map(self.thetype, ["ab", "abcde", "def"])
assertTrue(self, p < q)
assertTrue(self, p <= q)
assertTrue(self, q <= q)
assertTrue(self, q > p)
assertTrue(self, q >= p)
assertFalse(self, q < r)
assertFalse(self, q <= r)
assertFalse(self, q > r)
assertFalse(self, q >= r)
assertTrue(self, issubset(set("a"), "abc"))
assertTrue(self, issuperset(set("abc"), "a"))
assertFalse(self, issubset(set("a"), "cbs"))
assertFalse(self, issuperset(set("cbs"), "a"))
end

function test_pickling(self::TestJointOps)
for i in 0:pickle.HIGHEST_PROTOCOL
p = dumps(self.s, i)
dup = loads(p)
assertEqual(self, self.s, dup, "%s != %s" % (self.s, dup))
if type_(self.s) ∉ (set, frozenset)
self.s.x = 10
p = dumps(self.s, i)
dup = loads(p)
assertEqual(self, self.s.x, dup.x)
end
end
end

function test_iterator_pickling(self::TestJointOps)
for proto in 0:pickle.HIGHEST_PROTOCOL
itorg = (x for x in self.s)
data = thetype(self, self.s)
d = dumps(itorg, proto)
it = loads(d)
assertIsInstance(self, it, collections.abc.Iterator)
assertEqual(self, thetype(self, it), data)
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
assertEqual(self, thetype(self, it), data - thetype(self, (drop,)))
end
end

function test_deepcopy(self::Tracer)
mutable struct Tracer <: AbstractTracer
value
end
function __hash__(self::Tracer)
return self.value
end

function __deepcopy__(self::Tracer, memo = nothing)::Tracer
return Tracer(self.value + 1)
end

t = Tracer(10)
s = thetype(self, [t])
dup = deepcopy(s)
assertNotEqual(self, id(s), id(dup))
for elem in dup
newt = elem
end
assertNotEqual(self, id(t), id(newt))
assertEqual(self, t.value + 1, newt.value)
end

function test_gc(self::A)
mutable struct A <: AbstractA

end

s = set((A() for i in 0:999))
for elem in s
elem.cycle = s
elem.sub = elem
elem.set = set([elem])
end
end

function test_subclass_with_custom_hash(self::H)
mutable struct H <: AbstractH
thetype
end
function __hash__(self::H)::Int64
return Int(id(self) & 2147483647)
end

s = H()
f = set()
add(f, s)
assertIn(self, s, f)
remove(f, s)
add(f, s)
discard(f, s)
end

function test_badcmp(self::TestJointOps)
s = thetype(self, [BadCmp()])
assertRaises(self, RuntimeError, self.thetype, [BadCmp(), BadCmp()])
assertRaises(self, RuntimeError, s.__contains__, BadCmp())
if hasfield(typeof(s), :add)
assertRaises(self, RuntimeError, s.add, BadCmp())
assertRaises(self, RuntimeError, s.discard, BadCmp())
assertRaises(self, RuntimeError, s.remove, BadCmp())
end
end

function test_cyclical_repr(self::TestJointOps)
w = ReprWrapper()
s = thetype(self, [w])
w.value = s
if self.thetype == set
assertEqual(self, repr(s), "{set(...)}")
else
name = partition(repr(s), "(")[1]
assertEqual(self, repr(s), "%s({%s(...)})" % (name, name))
end
end

function test_do_not_rehash_dict_keys(self::TestJointOps)
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
d2 = fromkeys(dict, set(d))
assertEqual(self, sum((elem.hash_count for elem in d)), n)
d3 = fromkeys(dict, frozenset(d))
assertEqual(self, sum((elem.hash_count for elem in d)), n)
d3 = fromkeys(dict, frozenset(d), 123)
assertEqual(self, sum((elem.hash_count for elem in d)), n)
assertEqual(self, d3, fromkeys(dict, d, 123))
end

function test_container_iterator(self::C)
mutable struct C <: AbstractC

end

obj = C()
ref = ref(obj)
container = set([obj, 1])
obj.x = (x for x in container)
#Delete Unsupported
del(container)
collect()
assertTrue(self, ref() === nothing, "Cycle was not collected")
end

function test_free_after_iterating(self::TestJointOps)
check_free_after_iterating(self, iter, self.thetype)
end

mutable struct TestSet <: AbstractTestSet
ge_called::Bool
gt_called::Bool
le_called::Bool
lt_called::Bool
otherword
s
word
basetype
thetype

                    TestSet(ge_called::Bool, gt_called::Bool, le_called::Bool, lt_called::Bool, otherword, s, word, basetype = set, thetype = set) =
                        new(ge_called, gt_called, le_called, lt_called, otherword, s, word, basetype, thetype)
end
function test_init(self::TestSet)
s = thetype(self)
__init__(s, self.word)
@test (s == set(self.word))
__init__(s, self.otherword)
@test (s == set(self.otherword))
@test_throws TypeError s.__init__(s, 2)
@test_throws TypeError s.__init__(1)
end

function test_constructor_identity(self::TestSet)
s = thetype(self, 0:2)
t = thetype(self, s)
assertNotEqual(self, id(s), id(t))
end

function test_set_literal(self::TestSet)
s = set([1, 2, 3])
t = Set([1, 2, 3])
@test (s == t)
end

function test_set_literal_insertion_order(self::TestSet)
s = Set([1, 1.0, true])
@test (length(s) == 1)
stored_value = pop(s)
@test (type_(stored_value) == int)
end

function test_set_literal_evaluation_order(self::TestSet)
events = []
function record(obj)
push!(events, obj)
end

s = Set([record(1), record(2), record(3)])
@test (events == [1, 2, 3])
end

function test_hash(self::TestSet)
@test_throws TypeError hash(self.s)
end

function test_clear(self::TestSet)
clear(self.s)
@test (self.s == set())
@test (length(self.s) == 0)
end

function test_copy(self::TestSet)
dup = copy(self.s)
@test (self.s == dup)
assertNotEqual(self, id(self.s), id(dup))
@test (type_(dup) == self.basetype)
end

function test_add(self::TestSet)
add(self.s, "Q")
assertIn(self, "Q", self.s)
dup = copy(self.s)
add(self.s, "Q")
@test (self.s == dup)
@test_throws TypeError self.s.add([])
end

function test_remove(self::TestSet)
remove(self.s, "a")
assertNotIn(self, "a", self.s)
@test_throws KeyError self.s.remove("Q")
@test_throws TypeError self.s.remove([])
s = thetype(self, [frozenset(self.word)])
assertIn(self, thetype(self, self.word), s)
remove(s, thetype(self, self.word))
assertNotIn(self, thetype(self, self.word), s)
@test_throws KeyError self.s.remove(thetype(self, self.word))
end

function test_remove_keyerror_unpacking(self::TestSet)
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

function test_remove_keyerror_set(self::TestSet)
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

function test_discard(self::TestSet)
discard(self.s, "a")
assertNotIn(self, "a", self.s)
discard(self.s, "Q")
@test_throws TypeError self.s.discard([])
s = thetype(self, [frozenset(self.word)])
assertIn(self, thetype(self, self.word), s)
discard(s, thetype(self, self.word))
assertNotIn(self, thetype(self, self.word), s)
discard(s, thetype(self, self.word))
end

function test_pop(self::TestSet)
for i in 0:length(self.s) - 1
elem = pop(self.s)
assertNotIn(self, elem, self.s)
end
@test_throws KeyError self.s.pop()
end

function test_update(self::TestSet)
retval = update(self.s, self.otherword)
@test (retval == nothing)
for c in self.word + self.otherword
assertIn(self, c, self.s)
end
@test_throws PassThru self.s.update(check_pass_thru())
@test_throws TypeError self.s.update([[]])
for (p, q) in (("cdc", "abcd"), ("efgfe", "abcefg"), ("ccb", "abc"), ("ef", "abcef"))
for C in (set, frozenset, dict.fromkeys, str, list, tuple)
s = thetype(self, "abcba")
@test (update(s, C(p)) == nothing)
@test (s == set(q))
end
end
for p in ("cdc", "efgfe", "ccb", "ef", "abcda")
q = "ahi"
for C in (set, frozenset, dict.fromkeys, str, list, tuple)
s = thetype(self, "abcba")
@test (update(s, C(p), C(q)) == nothing)
@test (s == (set(s) | set(p)) | set(q))
end
end
end

function test_ior(self::TestSet)
self.s |= set(self.otherword)
for c in self.word + self.otherword
assertIn(self, c, self.s)
end
end

function test_intersection_update(self::TestSet)
retval = intersection_update(self.s, self.otherword)
@test (retval == nothing)
for c in self.word + self.otherword
if c ∈ self.otherword && c ∈ self.word
assertIn(self, c, self.s)
else
assertNotIn(self, c, self.s)
end
end
@test_throws PassThru self.s.intersection_update(check_pass_thru())
@test_throws TypeError self.s.intersection_update([[]])
for (p, q) in (("cdc", "c"), ("efgfe", ""), ("ccb", "bc"), ("ef", ""))
for C in (set, frozenset, dict.fromkeys, str, list, tuple)
s = thetype(self, "abcba")
@test (intersection_update(s, C(p)) == nothing)
@test (s == set(q))
ss = "abcba"
s = thetype(self, ss)
t = "cbc"
@test (intersection_update(s, C(p), C(t)) == nothing)
@test (s == (set("abcba") & set(p)) & set(t))
end
end
end

function test_iand(self::TestSet)
self.s = self.s & set(self.otherword)
for c in self.word + self.otherword
if c ∈ self.otherword && c ∈ self.word
assertIn(self, c, self.s)
else
assertNotIn(self, c, self.s)
end
end
end

function test_difference_update(self::TestSet)
retval = difference_update(self.s, self.otherword)
@test (retval == nothing)
for c in self.word + self.otherword
if c ∈ self.word && c ∉ self.otherword
assertIn(self, c, self.s)
else
assertNotIn(self, c, self.s)
end
end
@test_throws PassThru self.s.difference_update(check_pass_thru())
@test_throws TypeError self.s.difference_update([[]])
@test_throws TypeError self.s.symmetric_difference_update([[]])
for (p, q) in (("cdc", "ab"), ("efgfe", "abc"), ("ccb", "a"), ("ef", "abc"))
for C in (set, frozenset, dict.fromkeys, str, list, tuple)
s = thetype(self, "abcba")
@test (difference_update(s, C(p)) == nothing)
@test (s == set(q))
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

function test_isub(self::TestSet)
self.s -= set(self.otherword)
for c in self.word + self.otherword
if c ∈ self.word && c ∉ self.otherword
assertIn(self, c, self.s)
else
assertNotIn(self, c, self.s)
end
end
end

function test_symmetric_difference_update(self::TestSet)
retval = symmetric_difference_update(self.s, self.otherword)
@test (retval == nothing)
for c in self.word + self.otherword
if c ∈ self.word  ⊻  c ∈ self.otherword
assertIn(self, c, self.s)
else
assertNotIn(self, c, self.s)
end
end
@test_throws PassThru self.s.symmetric_difference_update(check_pass_thru())
@test_throws TypeError self.s.symmetric_difference_update([[]])
for (p, q) in (("cdc", "abd"), ("efgfe", "abcefg"), ("ccb", "a"), ("ef", "abcef"))
for C in (set, frozenset, dict.fromkeys, str, list, tuple)
s = thetype(self, "abcba")
@test (symmetric_difference_update(s, C(p)) == nothing)
@test (s == set(q))
end
end
end

function test_ixor(self::TestSet)
self.s = self.s  ⊻  set(self.otherword)
for c in self.word + self.otherword
if c ∈ self.word  ⊻  c ∈ self.otherword
assertIn(self, c, self.s)
else
assertNotIn(self, c, self.s)
end
end
end

function test_inplace_on_self(self::TestSet)
t = copy(self.s)
t = __or__(t, t)
@test (t == self.s)
t = __and__(t, t)
@test (t == self.s)
t = __sub__(t, t)
@test (t == thetype(self))
t = copy(self.s)
t = __xor__(t, t)
@test (t == thetype(self))
end

function test_weakref(self::TestSet)
s = thetype(self, "gallahad")
p = proxy(s)
@test (string(p) == string(s))
s = nothing
gc_collect()
@test_throws ReferenceError str(p)
end

function test_rich_compare(self::TestRichSetCompare)
mutable struct TestRichSetCompare <: AbstractTestRichSetCompare
gt_called::Bool
lt_called::Bool
ge_called::Bool
le_called::Bool
end
function __gt__(self::TestRichSetCompare, some_set)::Bool
self.gt_called = true
return false
end

function __lt__(self::TestRichSetCompare, some_set)::Bool
self.lt_called = true
return false
end

function __ge__(self::TestRichSetCompare, some_set)::Bool
self.ge_called = true
return false
end

function __le__(self::TestRichSetCompare, some_set)::Bool
self.le_called = true
return false
end

myset = Set([1, 2, 3])
myobj = TestRichSetCompare()
myset < myobj
assertTrue(self, myobj.gt_called)
myobj = TestRichSetCompare()
myset > myobj
assertTrue(self, myobj.lt_called)
myobj = TestRichSetCompare()
myset <= myobj
assertTrue(self, myobj.ge_called)
myobj = TestRichSetCompare()
myset >= myobj
assertTrue(self, myobj.le_called)
end

function test_c_api(self::TestSet)
@test (test_c_api(set()) == true_)
end

mutable struct SetSubclass <: AbstractSetSubclass

end

mutable struct TestSetSubclass <: AbstractTestSetSubclass
basetype
thetype::AbstractSetSubclass

                    TestSetSubclass(basetype = set, thetype::AbstractSetSubclass = SetSubclass) =
                        new(basetype, thetype)
end

mutable struct SetSubclassWithKeywordArgs <: AbstractSetSubclassWithKeywordArgs
iterable::Vector
newarg

            SetSubclassWithKeywordArgs(iterable = [], newarg = nothing) = begin
                set.__init__(self, iterable)
                new(iterable , newarg )
            end
end

mutable struct TestSetSubclassWithKeywordArgs <: AbstractTestSetSubclassWithKeywordArgs

end
function test_keywords_in_subclass(self::TestSetSubclassWithKeywordArgs)
#= SF bug #1486663 -- this used to erroneously raise a TypeError =#
SetSubclassWithKeywordArgs(1)
end

mutable struct TestFrozenSet <: AbstractTestFrozenSet
otherword
s
word
basetype
thetype

                    TestFrozenSet(otherword, s, word, basetype = frozenset, thetype = frozenset) =
                        new(otherword, s, word, basetype, thetype)
end
function test_init(self::TestFrozenSet)
s = thetype(self, self.word)
__init__(s, self.otherword)
@test (s == set(self.word))
end

function test_constructor_identity(self::TestFrozenSet)
s = thetype(self, 0:2)
t = thetype(self, s)
@test (id(s) == id(t))
end

function test_hash(self::TestFrozenSet)
@test (hash(thetype(self, "abcdeb")) == hash(thetype(self, "ebecda")))
n = 100
seq = [randrange(n) for i in 0:n - 1]
results = set()
for i in 0:199
shuffle(seq)
add(results, hash(thetype(self, seq)))
end
@test (length(results) == 1)
end

function test_copy(self::TestFrozenSet)
dup = copy(self.s)
@test (id(self.s) == id(dup))
end

function test_frozen_as_dictkey(self::TestFrozenSet)
seq = append!(append!(collect(0:9), collect("abcdefg")), ["apple"])
key1 = thetype(self, seq)
key2 = thetype(self, reversed(seq))
@test (key1 == key2)
assertNotEqual(self, id(key1), id(key2))
d = Dict()
d[key1] = 42
@test (d[key2] == 42)
end

function test_hash_caching(self::TestFrozenSet)
f = thetype(self, "abcdcda")
@test (hash(f) == hash(f))
end

function test_hash_effectiveness(self::TestFrozenSet)
Channel() do ch_test_hash_effectiveness 
n = 13
hashvalues = set()
addhashvalue = hashvalues.add
elemmasks = [(i + 1, 1 << i) for i in 0:n - 1]
for i in 0:2^n - 1
addhashvalue(hash(frozenset([e for (e, m) in elemmasks if m & i ])))
end
@test (length(hashvalues) == 2^n)
function zf_range(n)::Vector
nums = [frozenset()]
for i in 0:n - 2
num = frozenset(nums)
push!(nums, num)
end
return nums[begin:n]
end

function powerset(s)
Channel() do ch_powerset 
for i in 0:length(s)
# Unsupported
@yield_from map(frozenset, combinations(s, i))
end
end
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
end

mutable struct FrozenSetSubclass <: AbstractFrozenSetSubclass

end

mutable struct TestFrozenSetSubclass <: AbstractTestFrozenSetSubclass
s
basetype
thetype::AbstractFrozenSetSubclass

                    TestFrozenSetSubclass(s, basetype = frozenset, thetype::AbstractFrozenSetSubclass = FrozenSetSubclass) =
                        new(s, basetype, thetype)
end
function test_constructor_identity(self::TestFrozenSetSubclass)
s = thetype(self, 0:2)
t = thetype(self, s)
assertNotEqual(self, id(s), id(t))
end

function test_copy(self::TestFrozenSetSubclass)
dup = copy(self.s)
assertNotEqual(self, id(self.s), id(dup))
end

function test_nested_empty_constructor(self::TestFrozenSetSubclass)
s = thetype(self)
t = thetype(self, s)
assertEqual(self, s, t)
end

function test_singleton_empty_frozenset(self::TestFrozenSetSubclass)
Frozenset = self.thetype
f = frozenset()
F = Frozenset()
efs = [Frozenset(), Frozenset([]), Frozenset(()), Frozenset(""), Frozenset(), Frozenset([]), Frozenset(()), Frozenset(""), Frozenset(0:-1), Frozenset(Frozenset()), Frozenset(frozenset()), f, F, Frozenset(f), Frozenset(F)]
assertEqual(self, length(set(map(id, efs))), length(efs))
end

empty_set = set()
mutable struct TestBasicOps <: AbstractTestBasicOps
repr
set
length
dup
values
end
function test_repr(self::TestBasicOps)
if self.repr !== nothing
assertEqual(self, repr(self.set), self.repr)
end
end

function check_repr_against_values(self::TestBasicOps)
text = repr(self.set)
assertTrue(self, startswith(text, "{"))
assertTrue(self, endswith(text, "}"))
result = split(text[2:-1], ", ")
sort(result)
sorted_repr_values = [repr(value) for value in self.values]
sort(sorted_repr_values)
assertEqual(self, result, sorted_repr_values)
end

function test_length(self::TestBasicOps)
assertEqual(self, length(self.set), self.length)
end

function test_self_equality(self::TestBasicOps)
assertEqual(self, self.set, self.set)
end

function test_equivalent_equality(self::TestBasicOps)
assertEqual(self, self.set, self.dup)
end

function test_copy(self::TestBasicOps)
assertEqual(self, copy(self.set), self.dup)
end

function test_self_union(self::TestBasicOps)
result = self.set | self.set
assertEqual(self, result, self.dup)
end

function test_empty_union(self::TestBasicOps)
result = self.set | empty_set
assertEqual(self, result, self.dup)
end

function test_union_empty(self::TestBasicOps)
result = empty_set | self.set
assertEqual(self, result, self.dup)
end

function test_self_intersection(self::TestBasicOps)
result = self.set & self.set
assertEqual(self, result, self.dup)
end

function test_empty_intersection(self::TestBasicOps)
result = self.set & empty_set
assertEqual(self, result, empty_set)
end

function test_intersection_empty(self::TestBasicOps)
result = empty_set & self.set
assertEqual(self, result, empty_set)
end

function test_self_isdisjoint(self::TestBasicOps)
result = isdisjoint(self.set, self.set)
assertEqual(self, result, !(self.set))
end

function test_empty_isdisjoint(self::TestBasicOps)
result = isdisjoint(self.set, empty_set)
assertEqual(self, result, true)
end

function test_isdisjoint_empty(self::TestBasicOps)
result = isdisjoint(empty_set, self.set)
assertEqual(self, result, true)
end

function test_self_symmetric_difference(self::TestBasicOps)
result = self.set  ⊻  self.set
assertEqual(self, result, empty_set)
end

function test_empty_symmetric_difference(self::TestBasicOps)
result = self.set  ⊻  empty_set
assertEqual(self, result, self.set)
end

function test_self_difference(self::TestBasicOps)
result = self.set - self.set
assertEqual(self, result, empty_set)
end

function test_empty_difference(self::TestBasicOps)
result = self.set - empty_set
assertEqual(self, result, self.dup)
end

function test_empty_difference_rev(self::TestBasicOps)
result = empty_set - self.set
assertEqual(self, result, empty_set)
end

function test_iteration(self::TestBasicOps)
for v in self.set
assertIn(self, v, self.values)
end
setiter = (x for x in self.set)
assertEqual(self, __length_hint__(setiter), length(self.set))
end

function test_pickling(self::TestBasicOps)
for proto in 0:pickle.HIGHEST_PROTOCOL
p = dumps(self.set, proto)
copy = loads(p)
assertEqual(self, self.set, copy, "%s != %s" % (self.set, copy))
end
end

function test_issue_37219(self::TestBasicOps)
assertRaises(self, TypeError) do 
difference(set(), 123)
end
assertRaises(self, TypeError) do 
difference_update(set(), 123)
end
end

mutable struct TestBasicOpsEmpty <: AbstractTestBasicOpsEmpty
case::String
values::Vector
set
dup
length::Int64
repr::String
end
function setUp(self::TestBasicOpsEmpty)
self.case = "empty set"
self.values = []
self.set = set(self.values)
self.dup = set(self.values)
self.length = 0
self.repr = "set()"
end

mutable struct TestBasicOpsSingleton <: AbstractTestBasicOpsSingleton
case::String
values::Vector{Int64}
set
dup
length::Int64
repr::String
end
function setUp(self::TestBasicOpsSingleton)
self.case = "unit set (number)"
self.values = [3]
self.set = set(self.values)
self.dup = set(self.values)
self.length = 1
self.repr = "{3}"
end

function test_in(self::TestBasicOpsSingleton)
assertIn(self, 3, self.set)
end

function test_not_in(self::TestBasicOpsSingleton)
assertNotIn(self, 2, self.set)
end

mutable struct TestBasicOpsTuple <: AbstractTestBasicOpsTuple
case::String
values::Vector{Tuple{Union{Int64, String}}}
set
dup
length::Int64
repr::String
end
function setUp(self::TestBasicOpsTuple)
self.case = "unit set (tuple)"
self.values = [(0, "zero")]
self.set = set(self.values)
self.dup = set(self.values)
self.length = 1
self.repr = "{(0, \'zero\')}"
end

function test_in(self::TestBasicOpsTuple)
assertIn(self, (0, "zero"), self.set)
end

function test_not_in(self::TestBasicOpsTuple)
assertNotIn(self, 9, self.set)
end

mutable struct TestBasicOpsTriple <: AbstractTestBasicOpsTriple
case::String
values::Vector{Union{Int64, String}}
set
dup
length::Int64
repr
end
function setUp(self::TestBasicOpsTriple)
self.case = "triple set"
self.values = [0, "zero", operator.add]
self.set = set(self.values)
self.dup = set(self.values)
self.length = 3
self.repr = nothing
end

mutable struct TestBasicOpsString <: AbstractTestBasicOpsString
case::String
values::Vector{String}
set
dup
length::Int64
end
function setUp(self::TestBasicOpsString)
self.case = "string set"
self.values = ["a", "b", "c"]
self.set = set(self.values)
self.dup = set(self.values)
self.length = 3
end

function test_repr(self::TestBasicOpsString)
check_repr_against_values(self)
end

mutable struct TestBasicOpsBytes <: AbstractTestBasicOpsBytes
case::String
values::Vector{Array{UInt8}}
set
dup
length::Int64
end
function setUp(self::TestBasicOpsBytes)
self.case = "bytes set"
self.values = [b"a", b"b", b"c"]
self.set = set(self.values)
self.dup = set(self.values)
self.length = 3
end

function test_repr(self::TestBasicOpsBytes)
check_repr_against_values(self)
end

mutable struct TestBasicOpsMixedStringBytes <: AbstractTestBasicOpsMixedStringBytes
_warning_filters
case::String
values::Vector{Union{Array{UInt8}, String}}
set
dup
length::Int64
end
function setUp(self::TestBasicOpsMixedStringBytes)
self._warning_filters = check_warnings()
__enter__(self._warning_filters)
simplefilter("ignore", BytesWarning)
self.case = "string and bytes set"
self.values = ["a", "b", b"a", b"b"]
self.set = set(self.values)
self.dup = set(self.values)
self.length = 4
end

function tearDown(self::TestBasicOpsMixedStringBytes)
__exit__(self._warning_filters, nothing, nothing, nothing)
end

function test_repr(self::TestBasicOpsMixedStringBytes)
check_repr_against_values(self)
end

function baditer()
Channel() do ch_baditer 
throw(TypeError)
put!(ch_baditer, true)
end
end

function gooditer()
Channel() do ch_gooditer 
put!(ch_gooditer, true)
end
end

mutable struct TestExceptionPropagation <: AbstractTestExceptionPropagation
#= SF 628246:  Set constructor should not trap iterator TypeErrors =#

end
function test_instanceWithException(self::TestExceptionPropagation)
@test_throws TypeError set(baditer())
end

function test_instancesWithoutException(self::TestExceptionPropagation)
set([1, 2, 3])
set((1, 2, 3))
set(Dict("one" => 1, "two" => 2, "three" => 3))
set(0:2)
set("abc")
set(gooditer())
end

function test_changingSizeWhileIterating(self::TestExceptionPropagation)
s = set([1, 2, 3])
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

mutable struct TestSetOfSets <: AbstractTestSetOfSets

end
function test_constructor(self::TestSetOfSets)
inner = frozenset([1])
outer = set([inner])
element = pop(outer)
@test (type_(element) == frozenset)
add(outer, inner)
remove(outer, inner)
@test (outer == set())
discard(outer, inner)
end

mutable struct TestBinaryOps <: AbstractTestBinaryOps
set
end
function setUp(self::TestBinaryOps)
self.set = set((2, 4, 6))
end

function test_eq(self::TestBinaryOps)
@test (self.set == set(Dict(2 => 1, 4 => 3, 6 => 5)))
end

function test_union_subset(self::TestBinaryOps)
result = self.set | set([2])
@test (result == set((2, 4, 6)))
end

function test_union_superset(self::TestBinaryOps)
result = self.set | set([2, 4, 6, 8])
@test (result == set([2, 4, 6, 8]))
end

function test_union_overlap(self::TestBinaryOps)
result = self.set | set([3, 4, 5])
@test (result == set([2, 3, 4, 5, 6]))
end

function test_union_non_overlap(self::TestBinaryOps)
result = self.set | set([8])
@test (result == set([2, 4, 6, 8]))
end

function test_intersection_subset(self::TestBinaryOps)
result = self.set & set((2, 4))
@test (result == set((2, 4)))
end

function test_intersection_superset(self::TestBinaryOps)
result = self.set & set([2, 4, 6, 8])
@test (result == set([2, 4, 6]))
end

function test_intersection_overlap(self::TestBinaryOps)
result = self.set & set([3, 4, 5])
@test (result == set([4]))
end

function test_intersection_non_overlap(self::TestBinaryOps)
result = self.set & set([8])
@test (result == empty_set)
end

function test_isdisjoint_subset(self::TestBinaryOps)
result = isdisjoint(self.set, set((2, 4)))
@test (result == false_)
end

function test_isdisjoint_superset(self::TestBinaryOps)
result = isdisjoint(self.set, set([2, 4, 6, 8]))
@test (result == false_)
end

function test_isdisjoint_overlap(self::TestBinaryOps)
result = isdisjoint(self.set, set([3, 4, 5]))
@test (result == false_)
end

function test_isdisjoint_non_overlap(self::TestBinaryOps)
result = isdisjoint(self.set, set([8]))
@test (result == true_)
end

function test_sym_difference_subset(self::TestBinaryOps)
result = self.set  ⊻  set((2, 4))
@test (result == set([6]))
end

function test_sym_difference_superset(self::TestBinaryOps)
result = self.set  ⊻  set((2, 4, 6, 8))
@test (result == set([8]))
end

function test_sym_difference_overlap(self::TestBinaryOps)
result = self.set  ⊻  set((3, 4, 5))
@test (result == set([2, 3, 5, 6]))
end

function test_sym_difference_non_overlap(self::TestBinaryOps)
result = self.set  ⊻  set([8])
@test (result == set([2, 4, 6, 8]))
end

mutable struct TestUpdateOps <: AbstractTestUpdateOps
set
end
function setUp(self::TestUpdateOps)
self.set = set((2, 4, 6))
end

function test_union_subset(self::TestUpdateOps)
self.set |= set([2])
@test (self.set == set((2, 4, 6)))
end

function test_union_superset(self::TestUpdateOps)
self.set |= set([2, 4, 6, 8])
@test (self.set == set([2, 4, 6, 8]))
end

function test_union_overlap(self::TestUpdateOps)
self.set |= set([3, 4, 5])
@test (self.set == set([2, 3, 4, 5, 6]))
end

function test_union_non_overlap(self::TestUpdateOps)
self.set |= set([8])
@test (self.set == set([2, 4, 6, 8]))
end

function test_union_method_call(self::TestUpdateOps)
update(self.set, set([3, 4, 5]))
@test (self.set == set([2, 3, 4, 5, 6]))
end

function test_intersection_subset(self::TestUpdateOps)
self.set = self.set & set((2, 4))
@test (self.set == set((2, 4)))
end

function test_intersection_superset(self::TestUpdateOps)
self.set = self.set & set([2, 4, 6, 8])
@test (self.set == set([2, 4, 6]))
end

function test_intersection_overlap(self::TestUpdateOps)
self.set = self.set & set([3, 4, 5])
@test (self.set == set([4]))
end

function test_intersection_non_overlap(self::TestUpdateOps)
self.set = self.set & set([8])
@test (self.set == empty_set)
end

function test_intersection_method_call(self::TestUpdateOps)
intersection_update(self.set, set([3, 4, 5]))
@test (self.set == set([4]))
end

function test_sym_difference_subset(self::TestUpdateOps)
self.set = self.set  ⊻  set((2, 4))
@test (self.set == set([6]))
end

function test_sym_difference_superset(self::TestUpdateOps)
self.set = self.set  ⊻  set((2, 4, 6, 8))
@test (self.set == set([8]))
end

function test_sym_difference_overlap(self::TestUpdateOps)
self.set = self.set  ⊻  set((3, 4, 5))
@test (self.set == set([2, 3, 5, 6]))
end

function test_sym_difference_non_overlap(self::TestUpdateOps)
self.set = self.set  ⊻  set([8])
@test (self.set == set([2, 4, 6, 8]))
end

function test_sym_difference_method_call(self::TestUpdateOps)
symmetric_difference_update(self.set, set([3, 4, 5]))
@test (self.set == set([2, 3, 5, 6]))
end

function test_difference_subset(self::TestUpdateOps)
self.set -= set((2, 4))
@test (self.set == set([6]))
end

function test_difference_superset(self::TestUpdateOps)
self.set -= set((2, 4, 6, 8))
@test (self.set == set([]))
end

function test_difference_overlap(self::TestUpdateOps)
self.set -= set((3, 4, 5))
@test (self.set == set([2, 6]))
end

function test_difference_non_overlap(self::TestUpdateOps)
self.set -= set([8])
@test (self.set == set([2, 4, 6]))
end

function test_difference_method_call(self::TestUpdateOps)
difference_update(self.set, set([3, 4, 5]))
@test (self.set == set([2, 6]))
end

mutable struct TestMutate <: AbstractTestMutate
values::Vector{String}
set
end
function setUp(self::TestMutate)
self.values = ["a", "b", "c"]
self.set = set(self.values)
end

function test_add_present(self::TestMutate)
add(self.set, "c")
@test (self.set == set("abc"))
end

function test_add_absent(self::TestMutate)
add(self.set, "d")
@test (self.set == set("abcd"))
end

function test_add_until_full(self::TestMutate)
tmp = set()
expected_len = 0
for v in self.values
add(tmp, v)
expected_len += 1
@test (length(tmp) == expected_len)
end
@test (tmp == self.set)
end

function test_remove_present(self::TestMutate)
remove(self.set, "b")
@test (self.set == set("ac"))
end

function test_remove_absent(self::TestMutate)
try
remove(self.set, "d")
fail(self, "Removing missing element should have raised LookupError")
catch exn
if exn isa LookupError
#= pass =#
end
end
end

function test_remove_until_empty(self::TestMutate)
expected_len = length(self.set)
for v in self.values
remove(self.set, v)
expected_len -= 1
@test (length(self.set) == expected_len)
end
end

function test_discard_present(self::TestMutate)
discard(self.set, "c")
@test (self.set == set("ab"))
end

function test_discard_absent(self::TestMutate)
discard(self.set, "d")
@test (self.set == set("abc"))
end

function test_clear(self::TestMutate)
clear(self.set)
@test (length(self.set) == 0)
end

function test_pop(self::TestMutate)
popped = Dict()
while self.set
popped[pop(self.set)] = nothing
end
@test (length(popped) == length(self.values))
for v in self.values
assertIn(self, v, popped)
end
end

function test_update_empty_tuple(self::TestMutate)
update(self.set, ())
@test (self.set == set(self.values))
end

function test_update_unit_tuple_overlap(self::TestMutate)
update(self.set, ("a",))
@test (self.set == set(self.values))
end

function test_update_unit_tuple_non_overlap(self::TestMutate)
update(self.set, ("a", "z"))
@test (self.set == set(append!(self.values, ["z"])))
end

mutable struct TestSubsets <: AbstractTestSubsets
case2method::Dict{String, String}
reverse::Dict{String, String}

                    TestSubsets(case2method::Dict{String, String} = Dict("<=" => "issubset", ">=" => "issuperset"), reverse::Dict{String, String} = Dict("==" => "==", "!=" => "!=", "<" => ">", ">" => "<", "<=" => ">=", ">=" => "<=")) =
                        new(case2method, reverse)
end
function test_issubset(self::TestSubsets)
x = self.left
y = self.right
for case in ("!=", "==", "<", "<=", ">", ">=")
expected = case ∈ self.cases
result = eval("x" * case * "y", locals())
assertEqual(self, result, expected)
if case ∈ TestSubsets.case2method
method = getfield(x, :TestSubsets.case2method[case + 1])
result = method(y)
assertEqual(self, result, expected)
end
rcase = TestSubsets.reverse[case + 1]
result = eval(("y" + rcase) * "x", locals())
assertEqual(self, result, expected)
if rcase ∈ TestSubsets.case2method
method = getfield(y, :TestSubsets.case2method[rcase + 1])
result = method(x)
assertEqual(self, result, expected)
end
end
end

mutable struct TestSubsetEqualEmpty <: AbstractTestSubsetEqualEmpty
cases::Tuple{String}
left
name::String
right

                    TestSubsetEqualEmpty(cases::Tuple{String} = ("==", "<=", ">="), left = set(), name::String = "both empty", right = set()) =
                        new(cases, left, name, right)
end

mutable struct TestSubsetEqualNonEmpty <: AbstractTestSubsetEqualNonEmpty
cases::Tuple{String}
left
name::String
right

                    TestSubsetEqualNonEmpty(cases::Tuple{String} = ("==", "<=", ">="), left = set([1, 2]), name::String = "equal pair", right = set([1, 2])) =
                        new(cases, left, name, right)
end

mutable struct TestSubsetEmptyNonEmpty <: AbstractTestSubsetEmptyNonEmpty
cases::Tuple{String}
left
name::String
right

                    TestSubsetEmptyNonEmpty(cases::Tuple{String} = ("!=", "<", "<="), left = set(), name::String = "one empty, one non-empty", right = set([1, 2])) =
                        new(cases, left, name, right)
end

mutable struct TestSubsetPartial <: AbstractTestSubsetPartial
cases::Tuple{String}
left
name::String
right

                    TestSubsetPartial(cases::Tuple{String} = ("!=", "<", "<="), left = set([1]), name::String = "one a non-empty proper subset of other", right = set([1, 2])) =
                        new(cases, left, name, right)
end

mutable struct TestSubsetNonOverlap <: AbstractTestSubsetNonOverlap
cases::String
left
name::String
right

                    TestSubsetNonOverlap(cases::String = "!=", left = set([1]), name::String = "neither empty, neither contains", right = set([2])) =
                        new(cases, left, name, right)
end

mutable struct TestOnlySetsInBinaryOps <: AbstractTestOnlySetsInBinaryOps
other
set
otherIsIterable
end
function test_eq_ne(self::TestOnlySetsInBinaryOps)
assertEqual(self, self.other == self.set, false)
assertEqual(self, self.set == self.other, false)
assertEqual(self, self.other != self.set, true)
assertEqual(self, self.set != self.other, true)
end

function test_ge_gt_le_lt(self::TestOnlySetsInBinaryOps)
assertRaises(self, TypeError, () -> self.set < self.other)
assertRaises(self, TypeError, () -> self.set <= self.other)
assertRaises(self, TypeError, () -> self.set > self.other)
assertRaises(self, TypeError, () -> self.set >= self.other)
assertRaises(self, TypeError, () -> self.other < self.set)
assertRaises(self, TypeError, () -> self.other <= self.set)
assertRaises(self, TypeError, () -> self.other > self.set)
assertRaises(self, TypeError, () -> self.other >= self.set)
end

function test_update_operator(self::TestOnlySetsInBinaryOps)
try
self.set |= self.other
catch exn
if exn isa TypeError
#= pass =#
end
end
end

function test_update(self::TestOnlySetsInBinaryOps)
if self.otherIsIterable
update(self.set, self.other)
else
assertRaises(self, TypeError, self.set.update, self.other)
end
end

function test_union(self::TestOnlySetsInBinaryOps)
assertRaises(self, TypeError, () -> self.set | self.other)
assertRaises(self, TypeError, () -> self.other | self.set)
if self.otherIsIterable
union(self.set, self.other)
else
assertRaises(self, TypeError, self.set.union, self.other)
end
end

function test_intersection_update_operator(self::TestOnlySetsInBinaryOps)
try
self.set = self.set & self.other
catch exn
if exn isa TypeError
#= pass =#
end
end
end

function test_intersection_update(self::TestOnlySetsInBinaryOps)
if self.otherIsIterable
intersection_update(self.set, self.other)
else
assertRaises(self, TypeError, self.set.intersection_update, self.other)
end
end

function test_intersection(self::TestOnlySetsInBinaryOps)
assertRaises(self, TypeError, () -> self.set & self.other)
assertRaises(self, TypeError, () -> self.other & self.set)
if self.otherIsIterable
intersection(self.set, self.other)
else
assertRaises(self, TypeError, self.set.intersection, self.other)
end
end

function test_sym_difference_update_operator(self::TestOnlySetsInBinaryOps)
try
self.set = self.set  ⊻  self.other
catch exn
if exn isa TypeError
#= pass =#
end
end
end

function test_sym_difference_update(self::TestOnlySetsInBinaryOps)
if self.otherIsIterable
symmetric_difference_update(self.set, self.other)
else
assertRaises(self, TypeError, self.set.symmetric_difference_update, self.other)
end
end

function test_sym_difference(self::TestOnlySetsInBinaryOps)
assertRaises(self, TypeError, () -> self.set  ⊻  self.other)
assertRaises(self, TypeError, () -> self.other  ⊻  self.set)
if self.otherIsIterable
symmetric_difference(self.set, self.other)
else
assertRaises(self, TypeError, self.set.symmetric_difference, self.other)
end
end

function test_difference_update_operator(self::TestOnlySetsInBinaryOps)
try
self.set -= self.other
catch exn
if exn isa TypeError
#= pass =#
end
end
end

function test_difference_update(self::TestOnlySetsInBinaryOps)
if self.otherIsIterable
difference_update(self.set, self.other)
else
assertRaises(self, TypeError, self.set.difference_update, self.other)
end
end

function test_difference(self::TestOnlySetsInBinaryOps)
assertRaises(self, TypeError, () -> self.set - self.other)
assertRaises(self, TypeError, () -> self.other - self.set)
if self.otherIsIterable
difference(self.set, self.other)
else
assertRaises(self, TypeError, self.set.difference, self.other)
end
end

mutable struct TestOnlySetsNumeric <: AbstractTestOnlySetsNumeric
set
other::Int64
otherIsIterable::Bool
end
function setUp(self::TestOnlySetsNumeric)
self.set = set((1, 2, 3))
self.other = 19
self.otherIsIterable = false
end

mutable struct TestOnlySetsDict <: AbstractTestOnlySetsDict
set
other::Dict{Int64, Int64}
otherIsIterable::Bool
end
function setUp(self::TestOnlySetsDict)
self.set = set((1, 2, 3))
self.other = Dict(1 => 2, 3 => 4)
self.otherIsIterable = true
end

mutable struct TestOnlySetsOperator <: AbstractTestOnlySetsOperator
set
other
otherIsIterable::Bool
end
function setUp(self::TestOnlySetsOperator)
self.set = set((1, 2, 3))
self.other = operator.add
self.otherIsIterable = false
end

mutable struct TestOnlySetsTuple <: AbstractTestOnlySetsTuple
set
other::Tuple{Int64}
otherIsIterable::Bool
end
function setUp(self::TestOnlySetsTuple)
self.set = set((1, 2, 3))
self.other = (2, 4, 6)
self.otherIsIterable = true
end

mutable struct TestOnlySetsString <: AbstractTestOnlySetsString
set
other::String
otherIsIterable::Bool
end
function setUp(self::TestOnlySetsString)
self.set = set((1, 2, 3))
self.other = "abc"
self.otherIsIterable = true
end

mutable struct TestOnlySetsGenerator <: AbstractTestOnlySetsGenerator
set
other
otherIsIterable::Bool
end
function setUp(self::TestOnlySetsGenerator)
Channel() do ch_setUp 
function gen()
Channel() do ch_gen 
for i in 0:2:9
put!(ch_gen, i)
end
end
end

self.set = set((1, 2, 3))
self.other = gen()
self.otherIsIterable = true
end
end

mutable struct TestCopying <: AbstractTestCopying

end
function test_copy(self::TestCopying)
dup = copy(self.set)
dup_list = sorted(dup, repr)
set_list = sorted(self.set, repr)
assertEqual(self, length(dup_list), length(set_list))
for i in 0:length(dup_list) - 1
assertTrue(self, dup_list[i + 1] === set_list[i + 1])
end
end

function test_deep_copy(self::TestCopying)
dup = deepcopy(self.set)
dup_list = sorted(dup, repr)
set_list = sorted(self.set, repr)
assertEqual(self, length(dup_list), length(set_list))
for i in 0:length(dup_list) - 1
assertEqual(self, dup_list[i + 1], set_list[i + 1])
end
end

mutable struct TestCopyingEmpty <: AbstractTestCopyingEmpty
set
end
function setUp(self::TestCopyingEmpty)
self.set = set()
end

mutable struct TestCopyingSingleton <: AbstractTestCopyingSingleton
set
end
function setUp(self::TestCopyingSingleton)
self.set = set(["hello"])
end

mutable struct TestCopyingTriple <: AbstractTestCopyingTriple
set
end
function setUp(self::TestCopyingTriple)
self.set = set(["zero", 0, nothing])
end

mutable struct TestCopyingTuple <: AbstractTestCopyingTuple
set
end
function setUp(self::TestCopyingTuple)
self.set = set([(1, 2)])
end

mutable struct TestCopyingNested <: AbstractTestCopyingNested
set
end
function setUp(self::TestCopyingNested)
self.set = set([((1, 2), (3, 4))])
end

mutable struct TestIdentities <: AbstractTestIdentities
a
b
end
function setUp(self::TestIdentities)
self.a = set("abracadabra")
self.b = set("alacazam")
end

function test_binopsVsSubsets(self::TestIdentities)
a, b = (self.a, self.b)
@test (a - b) < a
@test (b - a) < b
@test (a & b) < a
@test (a & b) < b
@test (a | b) > a
@test (a | b) > b
@test (a  ⊻  b) < (a | b)
end

function test_commutativity(self::TestIdentities)
a, b = (self.a, self.b)
@test (a & b == b & a)
@test (a | b == b | a)
@test (a  ⊻  b == b  ⊻  a)
if a !== b
assertNotEqual(self, a - b, b - a)
end
end

function test_summations(self::TestIdentities)
a, b = (self.a, self.b)
@test (((a - b) | (a & b)) | (b - a) == a | b)
@test ((a & b) | (a  ⊻  b) == a | b)
@test (a | (b - a) == a | b)
@test ((a - b) | b == a | b)
@test ((a - b) | (a & b) == a)
@test ((b - a) | (a & b) == b)
@test ((a - b) | (b - a) == a  ⊻  b)
end

function test_exclusion(self::TestIdentities)
a, b, zero = (self.a, self.b, set())
@test ((a - b) & b == zero)
@test ((b - a) & a == zero)
@test ((a & b) & (a  ⊻  b) == zero)
end

function R(seqn)
#= Regular generator =#
Channel() do ch_R 
for i in seqn
put!(ch_R, i)
end
end
end

mutable struct G <: AbstractG
#= Sequence using __getitem__ =#
seqn
end
function __getitem__(self::G, i)
return self.seqn[i + 1]
end

mutable struct I <: AbstractI
#= Sequence using iterator protocol =#
seqn
i::Int64
end
function __iter__(self::I)
return self
end

function __next__(self::I)
if self.i >= length(self.seqn)
throw(StopIteration)
end
v = self.seqn[self.i + 1]
self.i += 1
return v
end

mutable struct Ig <: AbstractIg
#= Sequence using iterator protocol defined with a generator =#
seqn
i::Int64
end
function __iter__(self::Ig)
Channel() do ch___iter__ 
for val in self.seqn
put!(ch___iter__, val)
end
end
end

mutable struct X <: AbstractX
#= Missing __getitem__ and __iter__ =#
seqn
i::Int64
end
function __next__(self::X)
if self.i >= length(self.seqn)
throw(StopIteration)
end
v = self.seqn[self.i + 1]
self.i += 1
return v
end

mutable struct N <: AbstractN
#= Iterator missing __next__() =#
seqn
i::Int64
end
function __iter__(self::N)
return self
end

mutable struct E <: AbstractE
#= Test propagation of exceptions =#
seqn
i::Int64
end
function __iter__(self::E)
return self
end

function __next__(self::E)
3 ÷ 0
end

mutable struct S <: AbstractS
#= Test immediate stop =#


            S(seqn) = begin
                #= pass =#
                new(seqn)
            end
end
function __iter__(self::S)
return self
end

function __next__(self::S)
throw(StopIteration)
end


function L(seqn)
#= Test multiple tiers of iterators =#
return chain(map((x) -> x, R(Ig(G(seqn)))))
end

mutable struct TestVariousIteratorArgs <: AbstractTestVariousIteratorArgs

end
function test_constructor(self::TestVariousIteratorArgs)
for cons in (set, frozenset)
for s in ("123", "", 0:999, ("do", 1.2), 2000:5:2199)
for g in (G, I, Ig, S, L, R)
@test (sorted(cons(g(s)), repr) == sorted(g(s), repr))
end
@test_throws TypeError cons(X(s))
@test_throws TypeError cons(N(s))
@test_throws ZeroDivisionError cons(E(s))
end
end
end

function test_inline_methods(self::TestVariousIteratorArgs)
s = set("november")
for data in ("123", "", 0:999, ("do", 1.2), 2000:5:2199, "december")
for meth in (s.union, s.intersection, s.difference, s.symmetric_difference, s.isdisjoint)
for g in (G, I, Ig, L, R)
expected = meth(data)
actual = meth(g(data))
if isa(expected, bool)
@test (actual == expected)
else
@test (sorted(actual, repr) == sorted(expected, repr))
end
end
@test_throws TypeError meth(X(s))
@test_throws TypeError meth(N(s))
@test_throws ZeroDivisionError meth(E(s))
end
end
end

function test_inplace_methods(self::TestVariousIteratorArgs)
for data in ("123", "", 0:999, ("do", 1.2), 2000:5:2199, "december")
for methname in ("update", "intersection_update", "difference_update", "symmetric_difference_update")
for g in (G, I, Ig, S, L, R)
s = set("january")
t = copy(s)
getfield(s, :methname)(collect(g(data)))
getfield(t, :methname)(g(data))
@test (sorted(s, repr) == sorted(t, repr))
end
@test_throws TypeError getfield(set("january"), :methname)(X(data))
@test_throws TypeError getfield(set("january"), :methname)(N(data))
@test_throws ZeroDivisionError getfield(set("january"), :methname)(E(data))
end
end
end

mutable struct bad_eq <: Abstractbad_eq

end
function __eq__(self::bad_eq, other)::Bool
if be_bad
clear(set2)
throw(ZeroDivisionError)
end
return self === other
end

function __hash__(self::bad_eq)::Int64
return 0
end

mutable struct bad_dict_clear <: Abstractbad_dict_clear

end
function __eq__(self::bad_dict_clear, other)::Bool
if be_bad
clear(dict2)
end
return self === other
end

function __hash__(self::bad_dict_clear)::Int64
return 0
end

mutable struct TestWeirdBugs <: AbstractTestWeirdBugs

end
function test_8420_set_merge(self::TestWeirdBugs)
global be_bad, set2, dict2
be_bad = false
set1 = Set([bad_eq()])
set2 = (bad_eq() for i in 0:74)
be_bad = true
@test_throws ZeroDivisionError set1.update(set2)
be_bad = false
set1 = Set([bad_dict_clear()])
dict2 = Dict(bad_dict_clear() => nothing)
be_bad = true
symmetric_difference_update(set1, dict2)
end

function test_iter_and_mutate(self::TestWeirdBugs)
s = set(0:99)
clear(s)
update(s, 0:99)
si = (x for x in s)
clear(s)
a = collect(0:99)
update(s, 0:99)
collect(si)
end

function test_merge_and_mutate(self::X)
mutable struct X <: AbstractX

end
function __hash__(self::X)
return hash(0)
end

function __eq__(self::X, o)::Bool
clear(other)
return false
end

other = set()
other = (X() for i in 0:9)
s = Set([0])
update(s, other)
end

mutable struct TestOperationsMutating <: AbstractTestOperationsMutating
#= Regression test for bpo-46615 =#
constructor1
constructor2

                    TestOperationsMutating(constructor1 = nothing, constructor2 = nothing) =
                        new(constructor1, constructor2)
end
function make_sets_of_bad_objects(self::Bad)::Tuple
mutable struct Bad <: AbstractBad

end
function __eq__(self::Bad, other)::Bool
if !(enabled)
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

function __hash__(self::Bad)
return randrange(2)
end

enabled = false
set1 = constructor1(self, (Bad() for _ in 0:randrange(50) - 1))
set2 = constructor2(self, (Bad() for _ in 0:randrange(50) - 1))
enabled = true
return (set1, set2)
end

function check_set_op_does_not_crash(self::TestOperationsMutating, function_)
for _ in 0:99
set1, set2 = make_sets_of_bad_objects(self)
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

mutable struct TestBinaryOpsMutating <: AbstractTestBinaryOpsMutating

end
function test_eq_with_mutation(self::TestBinaryOpsMutating)
check_set_op_does_not_crash(self, (a, b) -> a == b)
end

function test_ne_with_mutation(self::TestBinaryOpsMutating)
check_set_op_does_not_crash(self, (a, b) -> a != b)
end

function test_lt_with_mutation(self::TestBinaryOpsMutating)
check_set_op_does_not_crash(self, (a, b) -> a < b)
end

function test_le_with_mutation(self::TestBinaryOpsMutating)
check_set_op_does_not_crash(self, (a, b) -> a <= b)
end

function test_gt_with_mutation(self::TestBinaryOpsMutating)
check_set_op_does_not_crash(self, (a, b) -> a > b)
end

function test_ge_with_mutation(self::TestBinaryOpsMutating)
check_set_op_does_not_crash(self, (a, b) -> a >= b)
end

function test_and_with_mutation(self::TestBinaryOpsMutating)
check_set_op_does_not_crash(self, (a, b) -> a & b)
end

function test_or_with_mutation(self::TestBinaryOpsMutating)
check_set_op_does_not_crash(self, (a, b) -> a | b)
end

function test_sub_with_mutation(self::TestBinaryOpsMutating)
check_set_op_does_not_crash(self, (a, b) -> a - b)
end

function test_xor_with_mutation(self::TestBinaryOpsMutating)
check_set_op_does_not_crash(self, (a, b) -> a  ⊻  b)
end

function test_iadd_with_mutation(self::TestBinaryOpsMutating)
function f(a, b)
a = a & b
end

check_set_op_does_not_crash(self, f)
end

function test_ior_with_mutation(self::TestBinaryOpsMutating)
function f(a, b)
a |= b
end

check_set_op_does_not_crash(self, f)
end

function test_isub_with_mutation(self::TestBinaryOpsMutating)
function f(a, b)
a -= b
end

check_set_op_does_not_crash(self, f)
end

function test_ixor_with_mutation(self::TestBinaryOpsMutating)
function f(a, b)
a = a  ⊻  b
end

check_set_op_does_not_crash(self, f)
end

function test_iteration_with_mutation(self::TestBinaryOpsMutating)
function f1(a, b)
for x in a
#= pass =#
end
for y in b
#= pass =#
end
end

function f2(a, b)
for y in b
#= pass =#
end
for x in a
#= pass =#
end
end

function f3(a, b)
for (x, y) in zip(a, b)
#= pass =#
end
end

check_set_op_does_not_crash(self, f1)
check_set_op_does_not_crash(self, f2)
check_set_op_does_not_crash(self, f3)
end

mutable struct TestBinaryOpsMutating_Set_Set <: AbstractTestBinaryOpsMutating_Set_Set
constructor1
constructor2

                    TestBinaryOpsMutating_Set_Set(constructor1 = set, constructor2 = set) =
                        new(constructor1, constructor2)
end

mutable struct TestBinaryOpsMutating_Subclass_Subclass <: AbstractTestBinaryOpsMutating_Subclass_Subclass
constructor1::AbstractSetSubclass
constructor2::AbstractSetSubclass

                    TestBinaryOpsMutating_Subclass_Subclass(constructor1::AbstractSetSubclass = SetSubclass, constructor2::AbstractSetSubclass = SetSubclass) =
                        new(constructor1, constructor2)
end

mutable struct TestBinaryOpsMutating_Set_Subclass <: AbstractTestBinaryOpsMutating_Set_Subclass
constructor1
constructor2::AbstractSetSubclass

                    TestBinaryOpsMutating_Set_Subclass(constructor1 = set, constructor2::AbstractSetSubclass = SetSubclass) =
                        new(constructor1, constructor2)
end

mutable struct TestBinaryOpsMutating_Subclass_Set <: AbstractTestBinaryOpsMutating_Subclass_Set
constructor1::AbstractSetSubclass
constructor2

                    TestBinaryOpsMutating_Subclass_Set(constructor1::AbstractSetSubclass = SetSubclass, constructor2 = set) =
                        new(constructor1, constructor2)
end

mutable struct TestMethodsMutating <: AbstractTestMethodsMutating

end
function test_issubset_with_mutation(self::TestMethodsMutating)
check_set_op_does_not_crash(self, set.issubset)
end

function test_issuperset_with_mutation(self::TestMethodsMutating)
check_set_op_does_not_crash(self, set.issuperset)
end

function test_intersection_with_mutation(self::TestMethodsMutating)
check_set_op_does_not_crash(self, set.intersection)
end

function test_union_with_mutation(self::TestMethodsMutating)
check_set_op_does_not_crash(self, set.union)
end

function test_difference_with_mutation(self::TestMethodsMutating)
check_set_op_does_not_crash(self, set.difference)
end

function test_symmetric_difference_with_mutation(self::TestMethodsMutating)
check_set_op_does_not_crash(self, set.symmetric_difference)
end

function test_isdisjoint_with_mutation(self::TestMethodsMutating)
check_set_op_does_not_crash(self, set.isdisjoint)
end

function test_difference_update_with_mutation(self::TestMethodsMutating)
check_set_op_does_not_crash(self, set.difference_update)
end

function test_intersection_update_with_mutation(self::TestMethodsMutating)
check_set_op_does_not_crash(self, set.intersection_update)
end

function test_symmetric_difference_update_with_mutation(self::TestMethodsMutating)
check_set_op_does_not_crash(self, set.symmetric_difference_update)
end

function test_update_with_mutation(self::TestMethodsMutating)
check_set_op_does_not_crash(self, set.update)
end

mutable struct TestMethodsMutating_Set_Set <: AbstractTestMethodsMutating_Set_Set
constructor1
constructor2

                    TestMethodsMutating_Set_Set(constructor1 = set, constructor2 = set) =
                        new(constructor1, constructor2)
end

mutable struct TestMethodsMutating_Subclass_Subclass <: AbstractTestMethodsMutating_Subclass_Subclass
constructor1::AbstractSetSubclass
constructor2::AbstractSetSubclass

                    TestMethodsMutating_Subclass_Subclass(constructor1::AbstractSetSubclass = SetSubclass, constructor2::AbstractSetSubclass = SetSubclass) =
                        new(constructor1, constructor2)
end

mutable struct TestMethodsMutating_Set_Subclass <: AbstractTestMethodsMutating_Set_Subclass
constructor1
constructor2::AbstractSetSubclass

                    TestMethodsMutating_Set_Subclass(constructor1 = set, constructor2::AbstractSetSubclass = SetSubclass) =
                        new(constructor1, constructor2)
end

mutable struct TestMethodsMutating_Subclass_Set <: AbstractTestMethodsMutating_Subclass_Set
constructor1::AbstractSetSubclass
constructor2

                    TestMethodsMutating_Subclass_Set(constructor1::AbstractSetSubclass = SetSubclass, constructor2 = set) =
                        new(constructor1, constructor2)
end

mutable struct TestMethodsMutating_Set_Dict <: AbstractTestMethodsMutating_Set_Dict
constructor1
constructor2

                    TestMethodsMutating_Set_Dict(constructor1 = set, constructor2 = dict.fromkeys) =
                        new(constructor1, constructor2)
end

mutable struct TestMethodsMutating_Set_List <: AbstractTestMethodsMutating_Set_List
constructor1
constructor2

                    TestMethodsMutating_Set_List(constructor1 = set, constructor2 = list) =
                        new(constructor1, constructor2)
end

function powerset(U)
#= Generates all subsets of a set or sequence U. =#
Channel() do ch_powerset 
U = (x for x in U)
try
x = frozenset([next(U)])
for S in powerset(U)
put!(ch_powerset, S)
put!(ch_powerset, __or__(S, x))
end
catch exn
if exn isa StopIteration
put!(ch_powerset, frozenset())
end
end
end
end

function cube(n)
#= Graph of n-dimensional hypercube. =#
singletons = [frozenset([x]) for x in 0:n - 1]
return dict([(x, frozenset([x  ⊻  s for s in singletons])) for x in powerset(0:n - 1)])
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
f = set()
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
if v5 == v3 || v5 == v2
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

mutable struct TestGraphs <: AbstractTestGraphs

end
function test_cube(self::TestGraphs)
g = cube(3)
vertices1 = set(g)
@test (length(vertices1) == 8)
for edge in values(g)
@test (length(edge) == 3)
end
vertices2 = set((v for edges in values(g) for v in edges))
@test (vertices1 == vertices2)
cubefaces = faces(g)
@test (length(cubefaces) == 6)
for face in cubefaces
@test (length(face) == 4)
end
end

function test_cuboctahedron(self::TestGraphs)
g = cube(3)
cuboctahedron = linegraph(g)
@test (length(cuboctahedron) == 12)
vertices = set(cuboctahedron)
for edges in values(cuboctahedron)
@test (length(edges) == 4)
end
othervertices = set((edge for edges in values(cuboctahedron) for edge in edges))
@test (vertices == othervertices)
cubofaces = faces(cuboctahedron)
facesizes = defaultdict(int)
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
tearDown(test_basic_ops_mixed_string_bytes)
test_repr(test_basic_ops_mixed_string_bytes)
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