




abstract type AbstractListTest <: list_tests.CommonTest end
abstract type AbstractL <: list end
mutable struct ListTest <: AbstractListTest
type2test

                    ListTest(type2test = list) =
                        new(type2test)
end
function test_basic(self::ListTest)
assertEqual(self, collect([]), [])
l0_3 = [0, 1, 2, 3]
l0_3_bis = collect(l0_3)
assertEqual(self, l0_3, l0_3_bis)
assertTrue(self, l0_3 !== l0_3_bis)
assertEqual(self, collect(()), [])
assertEqual(self, collect((0, 1, 2, 3)), [0, 1, 2, 3])
assertEqual(self, collect(""), [])
assertEqual(self, collect("spam"), ["s", "p", "a", "m"])
assertEqual(self, collect((x for x in 0:9 if x % 2 )), [1, 3, 5, 7, 9])
if sys.maxsize == 2147483647
assertRaises(self, MemoryError, list, 0:sys.maxsize ÷ 2)
end
x = []
append!(x, (-(y) for y in x))
assertEqual(self, x, [])
end

function test_keyword_args(self::ListTest)
assertRaisesRegex(self, TypeError, "keyword argument") do 
collect([])
end
end

function test_truth(self::ListTest)
test_truth(super())
assertTrue(self, !([]))
assertTrue(self, [42])
end

function test_identity(self::ListTest)
assertTrue(self, [] !== [])
end

function test_len(self::ListTest)
test_len(super())
assertEqual(self, length([]), 0)
assertEqual(self, length([0]), 1)
assertEqual(self, length([0, 1, 2]), 3)
end

function test_overflow(self::ListTest)
lst = [4, 5, 6, 7]
n = Int((sys.maxsize*2 + 2) ÷ length(lst))
function mul(a, b)::Any
return a*b
end

function imul(a, b)
a *= b
end

assertRaises(self, (MemoryError, OverflowError), mul, lst, n)
assertRaises(self, (MemoryError, OverflowError), imul, lst, n)
end

function test_repr_large(self::ListTest)
function check(n)
l = [0]*n
s = repr(l)
assertEqual(self, s, ("[" + join(["0"]*n, ", ")) * "]")
end

check(10)
check(1000000)
end

function test_iterator_pickle(self::ListTest)
orig = type2test(self, [4, 5, 6, 7])
data = [10, 11, 12, 13, 14, 15]
for proto in 0:pickle.HIGHEST_PROTOCOL
itorig = (x for x in orig)
d = dumps((itorig, orig), proto)
it, a = loads(d)
a[begin:end] = data
assertEqual(self, type_(it), type_(itorig))
assertEqual(self, collect(it), data)
next(itorig)
d = dumps((itorig, orig), proto)
it, a = loads(d)
a[begin:end] = data
assertEqual(self, type_(it), type_(itorig))
assertEqual(self, collect(it), data[2:end])
for i in 1:length(orig) - 1
next(itorig)
end
d = dumps((itorig, orig), proto)
it, a = loads(d)
a[begin:end] = data
assertEqual(self, type_(it), type_(itorig))
assertEqual(self, collect(it), data[length(orig) + 1:end])
assertRaises(self, StopIteration, next, itorig)
d = dumps((itorig, orig), proto)
it, a = loads(d)
a[begin:end] = data
assertEqual(self, collect(it), [])
end
end

function test_reversed_pickle(self::ListTest)
orig = type2test(self, [4, 5, 6, 7])
data = [10, 11, 12, 13, 14, 15]
for proto in 0:pickle.HIGHEST_PROTOCOL
itorig = reversed(orig)
d = dumps((itorig, orig), proto)
it, a = loads(d)
a[begin:end] = data
assertEqual(self, type_(it), type_(itorig))
assertEqual(self, collect(it), data[end:-1:length(orig)])
next(itorig)
d = dumps((itorig, orig), proto)
it, a = loads(d)
a[begin:end] = data
assertEqual(self, type_(it), type_(itorig))
assertEqual(self, collect(it), data[end:-1:length(orig) - -1])
for i in 1:length(orig) - 1
next(itorig)
end
d = dumps((itorig, orig), proto)
it, a = loads(d)
a[begin:end] = data
assertEqual(self, type_(it), type_(itorig))
assertEqual(self, collect(it), [])
assertRaises(self, StopIteration, next, itorig)
d = dumps((itorig, orig), proto)
it, a = loads(d)
a[begin:end] = data
assertEqual(self, collect(it), [])
end
end

function test_step_overflow(self::ListTest)
a = [0, 1, 2, 3, 4]
a[end:sys.maxsize:2] = [0]
assertEqual(self, a[end:sys.maxsize:4], [3])
end

function test_no_comdat_folding(self::L)
mutable struct L <: AbstractL

end

assertRaises(self, TypeError) do 
(3,) + L([1, 2])
end
end

function test_equal_operator_modifying_operand(self::Z)
mutable struct X <: AbstractX

end
function __eq__(self::X, other)
empty!(list2)
return NotImplemented
end

mutable struct Y <: AbstractY

end
function __eq__(self::Y, other)
empty!(list1)
return NotImplemented
end

mutable struct Z <: AbstractZ

end
function __eq__(self::Z, other)
empty!(list3)
return NotImplemented
end

list1 = [X()]
list2 = [Y()]
assertTrue(self, list1 == list2)
list3 = [Z()]
list4 = [1]
assertFalse(self, list3 == list4)
end

function test_preallocation(self::ListTest)
iterable = repeat([0],10)
iter_size = getsizeof(iterable)
assertEqual(self, iter_size, getsizeof(collect(repeat([0],10))))
assertEqual(self, iter_size, getsizeof(collect(0:9)))
end

function test_count_index_remove_crashes(self::L)
mutable struct X <: AbstractX

end
function __eq__(self::X, other)
empty!(lst)
return NotImplemented
end

lst = [X()]
assertRaises(self, ValueError) do 
findfirst(isequal(lst), lst)
end
mutable struct L <: AbstractL

end
function __eq__(self::L, other)
string(other)
return NotImplemented
end

lst = L([X()])
count(isequal(lst), lst)
lst = L([X()])
assertRaises(self, ValueError) do 
deleteat!(lst, findfirst(isequal(lst), lst))
end
lst = [X(), X()]
3 ∈ lst
lst = [X(), X()]
X() ∈ lst
end

if abspath(PROGRAM_FILE) == @__FILE__
end