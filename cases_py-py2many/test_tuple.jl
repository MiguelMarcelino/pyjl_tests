




import gc

abstract type AbstractTupleTest <: seq_tests.CommonTest end
abstract type AbstractMyTuple <: tuple end
abstract type AbstractT <: tuple end
RUN_ALL_HASH_TESTS = false
JUST_SHOW_HASH_RESULTS = false
mutable struct TupleTest <: AbstractTupleTest
type2test

                    TupleTest(type2test = tuple) =
                        new(type2test)
end
function test_getitem_error(self)
t = ()
msg = "tuple indices must be integers or slices"
assertRaisesRegex(self, TypeError, msg) do 
t["a"]
end
end

function test_constructors(self)
test_constructors(super())
assertEqual(self, tuple(), ())
t0_3 = (0, 1, 2, 3)
t0_3_bis = tuple(t0_3)
assertTrue(self, t0_3 === t0_3_bis)
assertEqual(self, tuple([]), ())
assertEqual(self, tuple([0, 1, 2, 3]), (0, 1, 2, 3))
assertEqual(self, tuple(""), ())
assertEqual(self, tuple("spam"), ("s", "p", "a", "m"))
assertEqual(self, tuple((x for x in 0:9 if x % 2 )...), (1, 3, 5, 7, 9))
end

function test_keyword_args(self)
assertRaisesRegex(self, TypeError, "keyword argument") do 
tuple(sequence = ())
end
end

function test_truth(self)
test_truth(super())
assertTrue(self, !(()))
assertTrue(self, (42,))
end

function test_len(self)
test_len(super())
assertEqual(self, length(()), 0)
assertEqual(self, length((0,)), 1)
assertEqual(self, length((0, 1, 2)), 3)
end

function test_iadd(self)
test_iadd(super())
u = (0, 1)
u2 = u
u += (2, 3)
assertTrue(self, u !== u2)
end

function test_imul(self)
test_imul(super())
u = (0, 1)
u2 = u
u *= 3
assertTrue(self, u !== u2)
end

function test_tupleresizebug(self)
Channel() do ch_test_tupleresizebug 
function f()
Channel() do ch_f 
for i in 0:999
put!(ch_f, i)
end
end
end

assertEqual(self, collect(tuple(f())), collect(0:999))
end
end

function test_hash_exact(self)
function check_one_exact(t, e32, e64)
got = hash(t)
expected = support.NHASHBITS == 32 ? (e32) : (e64)
if got != expected
msg = "FAIL hash($('t')) == $(got) != $(expected)"
fail(self, msg)
end
end

check_one_exact((), 750394483, 5740354900026072187)
check_one_exact((0,), 1214856301, -8753497827991233192)
check_one_exact((0, 0), -168982784, -8458139203682520985)
check_one_exact((0.5,), 2077348973, -408149959306781352)
check_one_exact((0.5, (), (-2, 3, (4, 6))), 714642271, -1845940830829704396)
end

function test_hash_optional(self)
if !(RUN_ALL_HASH_TESTS)
return
end
function tryone_inner(tag, nbins, hashes, expected = nothing, zlimit = nothing)
nballs = length(hashes)
mean, sdev = collision_stats(nbins, nballs)
c = Counter(hashes)
collisions = nballs - length(c)
z = (collisions - mean) / sdev
pileup = max(values(c)) - 1
#Delete Unsupported
del(c)
got = (collisions, pileup)
failed = false
prefix = ""
if zlimit !== nothing && z > zlimit
failed = true
prefix = "FAIL z > $(zlimit); "
end
if expected !== nothing && got != expected
failed = true
prefix += "FAIL $(got) != $(expected); "
end
if failed || JUST_SHOW_HASH_RESULTS
msg = "$(prefix)$(tag); pileup $(round(pileup, digits=",")) mean $(round(mean, digits=1f)) "
msg += "coll $(round(collisions, digits=",")) z $(round(z, digits=1f))"
if JUST_SHOW_HASH_RESULTS
write(sys.__stdout__, "$(msg)")
else
fail(self, msg)
end
end
end

function tryone(tag, xs, native32 = nothing, native64 = nothing, hi32 = nothing, lo32 = nothing, zlimit = nothing)
NHASHBITS = support.NHASHBITS
hashes = collect(map(hash, xs))
tryone_inner(tag + "; $(NHASHBITS)-bit hash codes", 1 << NHASHBITS, hashes, NHASHBITS == 32 ? (native32) : (native64), zlimit)
if NHASHBITS > 32
shift = NHASHBITS - 32
tryone_inner(tag + "; 32-bit upper hash codes", 1 << 32, [h >> shift for h in hashes], hi32, zlimit)
mask = (1 << 32) - 1
tryone_inner(tag + "; 32-bit lower hash codes", 1 << 32, [h & mask for h in hashes], lo32, zlimit)
end
end

tryone("range(100) by 3", collect(product(0:99, repeat = 3)), (0, 0), (0, 0), (4, 1), (0, 0))
cands = append!(collect(-10:0), collect(0:8))
tryone("-10 .. 8 by 4", collect(product(cands, repeat = 4)), (0, 0), (0, 0), (0, 0), (0, 0))
#Delete Unsupported
del(cands)
L = [n << 60 for n in 0:99]
tryone("0..99 << 60 by 3", collect(product(L, repeat = 3)), (0, 0), (0, 0), (0, 0), (324, 1))
#Delete Unsupported
del(L)
tryone("[-3, 3] by 18", collect(product([-3, 3], repeat = 18)), (7, 1), (0, 0), (7, 1), (6, 1))
tryone("[0, 0.5] by 18", collect(product([0, 0.5], repeat = 18)), (5, 1), (0, 0), (9, 1), (12, 1))
tryone("4-char tuples", collect(product("abcdefghijklmnopqrstuvwxyz", repeat = 4)))
N = 50
base = collect(0:N - 1)
xp = collect(product(base, repeat = 2))
inps = append!(append!(append!(append!(base, collect(product(base, xp))), collect(product(xp, base))), xp), collect(zip(base)))
tryone("old tuple test", inps, (2, 1), (0, 0), (52, 49), (7, 1))
#Delete Unsupported
del(inps)
n = 5
A = [x for x in -(n):n if x != -1 ]
B = A + [(a,) for a in A]
L2 = collect(product(A, repeat = 2))
L3 = append!(L2, collect(product(A, repeat = 3)))
L4 = append!(L3, collect(product(A, repeat = 4)))
T = A
T = T + [(a,) for a in B + L4]
T = T + product(L3, B)
T = T + product(L2, repeat = 2)
T = T + product(B, L3)
T = T + product(B, B, L2)
T = T + product(B, L2, B)
T = T + product(L2, B, B)
T = T + product(B, repeat = 4)
@assert(length(T) == 345130)
tryone("new tuple test", T, (9, 1), (0, 0), (21, 5), (6, 1))
end

function test_repr(self)
l0 = tuple()
l2 = (0, 1, 2)
a0 = type2test(self, l0)
a2 = type2test(self, l2)
assertEqual(self, string(a0), repr(l0))
assertEqual(self, string(a2), repr(l2))
assertEqual(self, repr(a0), "()")
assertEqual(self, repr(a2), "(0, 1, 2)")
end

function _not_tracked(self, t)
collect()
collect()
assertFalse(self, is_tracked(t), t)
end

function _tracked(self, t)
assertTrue(self, is_tracked(t), t)
collect()
collect()
assertTrue(self, is_tracked(t), t)
end

function test_track_literals(self)
x, y, z = (1.5, "a", [])
_not_tracked(self, ())
_not_tracked(self, (1,))
_not_tracked(self, (1, 2))
_not_tracked(self, (1, 2, "a"))
_not_tracked(self, (1, 2, (nothing, true, false, ()), int))
_not_tracked(self, (object(),))
_not_tracked(self, ((1, x), y, (2, 3)))
_tracked(self, ([],))
_tracked(self, ([1],))
_tracked(self, (Dict(),))
_tracked(self, (set(),))
_tracked(self, (x, y, z))
end

function check_track_dynamic(self, tp, always_track)
x, y, z = (1.5, "a", [])
check = always_track ? (self._tracked) : (self._not_tracked)
check(tp())
check(tp([]))
check(tp(set()))
check(tp([1, x, y]))
check(tp((obj for obj in [1, x, y])))
check(tp(set([1, x, y])))
check(tp((tuple([obj]) for obj in [1, x, y])))
check(tuple((tp([obj]) for obj in [1, x, y])...))
_tracked(self, tp([z]))
_tracked(self, tp([[x, y]]))
_tracked(self, tp([Dict(x => y)]))
_tracked(self, tp((obj for obj in [x, y, z])))
_tracked(self, tp((tuple([obj]) for obj in [x, y, z])))
_tracked(self, tuple((tp([obj]) for obj in [x, y, z])...))
end

function test_track_dynamic(self)
check_track_dynamic(self, tuple, false)
end

function test_track_subtypes(self)
mutable struct MyTuple <: AbstractMyTuple

end

check_track_dynamic(self, MyTuple, true)
end

function test_bug7466(self)
_not_tracked(self, tuple((collect() for i in 0:100)...))
end

function test_repr_large(self)
function check(n)
l = (0,)*n
s = repr(l)
assertEqual(self, s, ("(" + join(["0"]*n, ", ")) * ")")
end

check(10)
check(1000000)
end

function test_iterator_pickle(self)
data = type2test(self, [4, 5, 6, 7])
for proto in 0:pickle.HIGHEST_PROTOCOL
itorg = (x for x in data)
d = dumps(itorg, proto)
it = loads(d)
assertEqual(self, type_(itorg), type_(it))
assertEqual(self, type2test(self, it), type2test(self, data))
it = loads(d)
next(it)
d = dumps(it, proto)
assertEqual(self, type2test(self, it), type2test(self, data)[2:end])
end
end

function test_reversed_pickle(self)
data = type2test(self, [4, 5, 6, 7])
for proto in 0:pickle.HIGHEST_PROTOCOL
itorg = reversed(data)
d = dumps(itorg, proto)
it = loads(d)
assertEqual(self, type_(itorg), type_(it))
assertEqual(self, type2test(self, it), type2test(self, reversed(data)))
it = loads(d)
next(it)
d = dumps(it, proto)
assertEqual(self, type2test(self, it), type2test(self, reversed(data))[2:end])
end
end

function test_no_comdat_folding(self)
mutable struct T <: AbstractT

end

assertRaises(self, TypeError) do 
[3] + T((1, 2))
end
end

function test_lexicographic_ordering(self)
a = type2test(self, [1, 2])
b = type2test(self, [1, 2, 0])
c = type2test(self, [1, 3])
assertLess(self, a, b)
assertLess(self, b, c)
end

if abspath(PROGRAM_FILE) == @__FILE__
end