#= Unit tests for collections.py. =#
using OrderedCollections
using ResumableFunctions
using Test

import copy
import doctest
import inspect


using random: choice, randrange

import string








using collections.abc: Awaitable, Coroutine
using collections.abc: AsyncIterator, AsyncIterable, AsyncGenerator
using collections.abc: Hashable, Iterable, Iterator, Generator, Reversible
using collections.abc: Sized, Container, Callable, Collection
using collections.abc: Set, MutableSet
using collections.abc: Mapping, MutableMapping, KeysView, ItemsView, ValuesView
using collections.abc: Sequence, MutableSequence
using collections.abc: ByteString
abstract type AbstractTestUserObjects end
abstract type AbstractTestChainMap end
abstract type AbstractDefaultChainMap <: ChainMap end
abstract type AbstractDictWithGetItem <: UserDict end
abstract type Abstractlowerdict <: dict end
abstract type AbstractSubclass <: ChainMap end
abstract type AbstractSubclassRor <: ChainMap end
abstract type AbstractTestNamedTuple end
abstract type AbstractB <: A end
abstract type AbstractPoint <: None end
abstract type AbstractNewPoint <: tuple end
abstract type AbstractABCTestCase end
abstract type AbstractTestOneTrickPonyABCs <: AbstractABCTestCase end
abstract type AbstractMinimalCoro <: Coroutine end
abstract type AbstractH <: Hashable end
abstract type AbstractI <: Iterable end
abstract type AbstractItBlocked <: AbstractIt end
abstract type AbstractR <: Reversible end
abstract type AbstractRevPlusIter <: AbstractRevNoIter end
abstract type AbstractRevItBlocked <: AbstractRev end
abstract type AbstractRevRevBlocked <: AbstractRev end
abstract type AbstractCol <: Collection end
abstract type AbstractDerCol <: AbstractCol end
abstract type AbstractNonCol <: AbstractColImpl end
abstract type AbstractMinimalGen <: Generator end
abstract type AbstractFailOnClose <: AsyncGenerator end
abstract type AbstractIgnoreGeneratorExit <: AsyncGenerator end
abstract type AbstractMinimalAGen <: AsyncGenerator end
abstract type AbstractWithSet <: MutableSet end
abstract type AbstractTestCollectionABCs <: AbstractABCTestCase end
abstract type AbstractMySet <: MutableSet end
abstract type AbstractOneTwoThreeSet <: Set end
abstract type AbstractMyComparableSet <: Set end
abstract type AbstractMyNonComparableSet <: Set end
abstract type AbstractCustomSequence <: Sequence end
abstract type AbstractSetUsingInstanceFromIterable <: MutableSet end
abstract type AbstractListSet <: Set end
abstract type AbstractMyMapping <: Mapping end
abstract type AbstractSequenceSubclass <: Sequence end
abstract type AbstractMutableSequenceSubclass <: MutableSequence end
abstract type AbstractBoth <: Collection end
abstract type AbstractCounterSubclassWithSetItem <: Counter end
abstract type AbstractCounterSubclassWithGet <: Counter end
abstract type AbstractTestCounter end
abstract type AbstractMyCounter <: Counter end
mutable struct TestUserObjects <: AbstractTestUserObjects

end
function _superset_test(self, a, b)
assertGreaterEqual(self, set(dir(a)), set(dir(b)), "$(a.__name__) should have all the methods of $(b.__name__)")
end

function _copy_test(self, obj)
obj_copy = copy(obj)
assertIsNot(self, obj.data, obj_copy.data)
@test (obj.data == obj_copy.data)
obj.test = [1234]
obj_copy = copy(obj)
assertIsNot(self, obj.data, obj_copy.data)
@test (obj.data == obj_copy.data)
assertIs(self, obj.test, obj_copy.test)
end

function test_str_protocol(self)
_superset_test(self, UserString, str)
end

function test_list_protocol(self)
_superset_test(self, UserList, list)
end

function test_dict_protocol(self)
_superset_test(self, UserDict, dict)
end

function test_list_copy(self)
obj = UserList()
append(obj, 123)
_copy_test(self, obj)
end

function test_dict_copy(self)
obj = UserDict()
obj[124] = "abc"
_copy_test(self, obj)
end

mutable struct TestChainMap <: AbstractTestChainMap
called::Bool
end
function test_basics(self)
c = ChainMap()
c["a"] = 1
c["b"] = 2
d = new_child(c)
d["b"] = 20
d["c"] = 30
@test (d.maps == [Dict("b" => 20, "c" => 30), Dict("a" => 1, "b" => 2)])
@test (items(d) == items(dict(a = 1, b = 20, c = 30)))
@test (length(d) == 3)
for key in "abc"
assertIn(self, key, d)
end
for (k, v) in items(dict(a = 1, b = 20, c = 30, z = 100))
@test (get(d, k, 100) == v)
end
#Delete Unsupported
del(d)
@test (d.maps == [Dict("c" => 30), Dict("a" => 1, "b" => 2)])
@test (items(d) == items(dict(a = 1, b = 2, c = 30)))
@test (length(d) == 3)
for key in "abc"
assertIn(self, key, d)
end
for (k, v) in items(dict(a = 1, b = 2, c = 30, z = 100))
@test (get(d, k, 100) == v)
end
assertIn(self, repr(d), [type_(d).__name__ + "({\'c\': 30}, {\'a\': 1, \'b\': 2})", type_(d).__name__ + "({\'c\': 30}, {\'b\': 2, \'a\': 1})"])
for e in (copy(d), copy(d))
@test (d == e)
@test (d.maps == e.maps)
assertIsNot(self, d, e)
assertIsNot(self, d.maps[1], e.maps[1])
for (m1, m2) in zip(d.maps[2:end], e.maps[2:end])
assertIs(self, m1, m2)
end
end
for proto in 0:pickle.HIGHEST_PROTOCOL
e = loads(dumps(d, proto))
@test (d == e)
@test (d.maps == e.maps)
assertIsNot(self, d, e)
for (m1, m2) in zip(d.maps, e.maps)
assertIsNot(self, m1, m2, e)
end
end
for e in [deepcopy(d), eval(repr(d))]
@test (d == e)
@test (d.maps == e.maps)
assertIsNot(self, d, e)
for (m1, m2) in zip(d.maps, e.maps)
assertIsNot(self, m1, m2, e)
end
end
f = new_child(d)
f["b"] = 5
@test (f.maps == [Dict("b" => 5), Dict("c" => 30), Dict("a" => 1, "b" => 2)])
@test (f.parents.maps == [Dict("c" => 30), Dict("a" => 1, "b" => 2)])
@test (f["b"] == 5)
@test (f.parents["b"] == 2)
end

function test_ordering(self)
baseline = Dict("music" => "bach", "art" => "rembrandt")
adjustments = Dict("art" => "van gogh", "opera" => "carmen")
cm = ChainMap(adjustments, baseline)
combined = copy(baseline)
update(combined, adjustments)
@test (collect(items(combined)) == collect(items(cm)))
end

function test_constructor(self)
@test (ChainMap().maps == [Dict()])
@test (ChainMap(Dict(1 => 2)).maps == [Dict(1 => 2)])
end

function test_bool(self)
@test !(ChainMap())
@test !(ChainMap(Dict(), Dict()))
@test ChainMap(Dict(1 => 2), Dict())
@test ChainMap(Dict(), Dict(1 => 2))
end

function test_missing(self)
mutable struct DefaultChainMap <: AbstractDefaultChainMap

end
function __missing__(self, key)::Int64
return 999
end

d = DefaultChainMap(dict(a = 1, b = 2), dict(b = 20, c = 30))
for (k, v) in items(dict(a = 1, b = 2, c = 30, d = 999))
assertEqual(self, d[k + 1], v)
end
for (k, v) in items(dict(a = 1, b = 2, c = 30, d = 77))
assertEqual(self, get(d, k, 77), v)
end
for (k, v) in items(dict(a = true, b = true, c = true, d = false))
assertEqual(self, k ∈ d, v)
end
assertEqual(self, pop(d, "a", 1001), 1, d)
assertEqual(self, pop(d, "a", 1002), 1002)
assertEqual(self, popitem(d), ("b", 2))
assertRaises(self, KeyError) do 
popitem(d)
end
end

function test_order_preservation(self)
d = ChainMap(OrderedDict(j = 0, h = 88888), OrderedDict(), OrderedDict(i = 9999, d = 4444, c = 3333), OrderedDict(f = 666, b = 222, g = 777, c = 333, h = 888), OrderedDict(), OrderedDict(e = 55, b = 22), OrderedDict(a = 1, b = 2, c = 3, d = 4, e = 5), OrderedDict())
@test (join(d, "") == "abcdefghij")
@test (collect(items(d)) == [("a", 1), ("b", 222), ("c", 3333), ("d", 4444), ("e", 55), ("f", 666), ("g", 777), ("h", 88888), ("i", 9999), ("j", 0)])
end

function test_iter_not_calling_getitem_on_maps(self)
mutable struct DictWithGetItem <: AbstractDictWithGetItem
called::Bool

            DictWithGetItem() = begin
                UserDict.__init__(self, args..., None = kwds)
                new()
            end
end
function __getitem__(self, item)
self.called = true
__getitem__(self, item)
end

d = DictWithGetItem(1)
c = ChainMap(d)
d.called = false
set(c)
assertFalse(self, d.called, "__getitem__ was called")
end

function test_dict_coercion(self)
d = ChainMap(dict(a = 1, b = 2), dict(b = 20, c = 30))
@test (dict(d) == dict(a = 1, b = 2, c = 30))
@test (dict(items(d)) == dict(a = 1, b = 2, c = 30))
end

function test_new_child(self)
#= Tests for changes for issue #16613. =#
c = ChainMap()
c["a"] = 1
c["b"] = 2
m = Dict("b" => 20, "c" => 30)
d = new_child(c, m)
assertEqual(self, d.maps, [Dict("b" => 20, "c" => 30), Dict("a" => 1, "b" => 2)])
assertIs(self, m, d.maps[1])
mutable struct lowerdict <: Abstractlowerdict

end
function __getitem__(self, key)
if isa(key, str)
key = lower(key)
end
return __getitem__(dict, self)
end

function __contains__(self, key)
if isa(key, str)
key = lower(key)
end
return __contains__(dict, self)
end

c = ChainMap()
c["a"] = 1
c["b"] = 2
m = lowerdict(20, 30)
d = new_child(c, m)
assertIs(self, m, d.maps[1])
for key in "abc"
assertIn(self, key, d)
end
for (k, v) in collect(dict(a = 1, B = 20, C = 30, z = 100))
assertEqual(self, get(d, k, 100), v)
end
c = ChainMap(Dict("a" => 1, "b" => 2))
d = new_child(c, b = 20, c = 30)
assertEqual(self, d.maps, [Dict("b" => 20, "c" => 30), Dict("a" => 1, "b" => 2)])
end

function test_union_operators(self)
cm1 = ChainMap(dict(a = 1, b = 2), dict(c = 3, d = 4))
cm2 = ChainMap(dict(a = 10, e = 5), dict(b = 20, d = 4))
cm3 = copy(cm1)
d = dict(a = 10, c = 30)
pairs = [("c", 3), ("p", 0)]
tmp = __or__(cm1, cm2)
assertEqual(self, tmp.maps, [cm1.maps[1] | dict(cm2), cm1.maps[2:end]...])
cm1 = __or__(cm1, cm2)
assertEqual(self, tmp, cm1)
tmp = __or__(cm2, d)
assertEqual(self, tmp.maps, [cm2.maps[1] | d, cm2.maps[2:end]...])
assertEqual(self, __or__(d, cm2).maps, [d | dict(cm2)])
cm2 = __or__(cm2, d)
assertEqual(self, tmp, cm2)
assertRaises(self, TypeError) do 
__or__(cm3, pairs)
end
tmp = copy(cm3)
cm3 = __or__(cm3, pairs)
assertEqual(self, cm3.maps, [tmp.maps[1] | dict(pairs), tmp.maps[2:end]...])
mutable struct Subclass <: AbstractSubclass

end

mutable struct SubclassRor <: AbstractSubclassRor

end
function __ror__(self, other)
return __ror__(super(), other)
end

tmp = ChainMap() | ChainMap()
assertIs(self, type_(tmp), ChainMap)
assertIs(self, type_(tmp.maps[1]), dict)
tmp = ChainMap() | Subclass()
assertIs(self, type_(tmp), ChainMap)
assertIs(self, type_(tmp.maps[1]), dict)
tmp = Subclass() | ChainMap()
assertIs(self, type_(tmp), Subclass)
assertIs(self, type_(tmp.maps[1]), dict)
tmp = ChainMap() | SubclassRor()
assertIs(self, type_(tmp), SubclassRor)
assertIs(self, type_(tmp.maps[1]), dict)
end

TestNT = namedtuple("TestNT", "x y z")
mutable struct TestNamedTuple <: AbstractTestNamedTuple
x
y

                    TestNamedTuple(x = loads(dumps(Point.x)), y = loads(dumps(Point.y))) =
                        new(x, y)
end
function test_factory(self)
Point = namedtuple("Point", "x y")
@test (Point.__name__ == "Point")
@test (Point.__slots__ == ())
@test (Point.__module__ == __name__)
@test (Point.__getitem__ == tuple.__getitem__)
@test (Point._fields == ("x", "y"))
@test_throws ValueError namedtuple("abc%", "efg ghi")
@test_throws ValueError namedtuple("class", "efg ghi")
@test_throws ValueError namedtuple("9abc", "efg ghi")
@test_throws ValueError namedtuple("abc", "efg g%hi")
@test_throws ValueError namedtuple("abc", "abc class")
@test_throws ValueError namedtuple("abc", "8efg 9ghi")
@test_throws ValueError namedtuple("abc", "_efg ghi")
@test_throws ValueError namedtuple("abc", "efg efg ghi")
namedtuple("Point0", "x1 y2")
namedtuple("_", "a b c")
nt = namedtuple("nt", "the quick brown fox")
assertNotIn(self, "u\'", repr(nt._fields))
nt = namedtuple("nt", ("the", "quick"))
assertNotIn(self, "u\'", repr(nt._fields))
@test_throws TypeError Point._make([11])
@test_throws TypeError Point._make([11, 22, 33])
end

function test_defaults(self)
Point = namedtuple("Point", "x y", defaults = (10, 20))
@test (Point._field_defaults == Dict("x" => 10, "y" => 20))
@test (Point(1, 2) == (1, 2))
@test (Point(1) == (1, 20))
@test (Point() == (10, 20))
Point = namedtuple("Point", "x y", defaults = (20,))
@test (Point._field_defaults == Dict("y" => 20))
@test (Point(1, 2) == (1, 2))
@test (Point(1) == (1, 20))
Point = namedtuple("Point", "x y", defaults = ())
@test (Point._field_defaults == Dict())
@test (Point(1, 2) == (1, 2))
assertRaises(self, TypeError) do 
Point(1)
end
assertRaises(self, TypeError) do 
Point()
end
assertRaises(self, TypeError) do 
Point(1, 2, 3)
end
assertRaises(self, TypeError) do 
Point = namedtuple("Point", "x y", defaults = (10, 20, 30))
end
assertRaises(self, TypeError) do 
Point = namedtuple("Point", "x y", defaults = 10)
end
assertRaises(self, TypeError) do 
Point = namedtuple("Point", "x y", defaults = false)
end
Point = namedtuple("Point", "x y", defaults = nothing)
@test (Point._field_defaults == Dict())
assertIsNone(self, Point.__new__.__defaults__, nothing)
@test (Point(10, 20) == (10, 20))
assertRaises(self, TypeError) do 
Point(10)
end
Point = namedtuple("Point", "x y", defaults = [10, 20])
@test (Point._field_defaults == Dict("x" => 10, "y" => 20))
@test (Point.__new__.__defaults__ == (10, 20))
@test (Point(1, 2) == (1, 2))
@test (Point(1) == (1, 20))
@test (Point() == (10, 20))
Point = namedtuple("Point", "x y", defaults = (x for x in [10, 20]))
@test (Point._field_defaults == Dict("x" => 10, "y" => 20))
@test (Point.__new__.__defaults__ == (10, 20))
@test (Point(1, 2) == (1, 2))
@test (Point(1) == (1, 20))
@test (Point() == (10, 20))
end

function test_readonly(self)
Point = namedtuple("Point", "x y")
p = Point(11, 22)
assertRaises(self, AttributeError) do 
p.x = 33
end
assertRaises(self, AttributeError) do 
#Delete Unsupported
del(p.x)
end
assertRaises(self, TypeError) do 
p[1] = 33
end
assertRaises(self, TypeError) do 
#Delete Unsupported
del(p)
end
@test (p.x == 11)
@test (p[1] == 11)
end

function test_factory_doc_attr(self)
Point = namedtuple("Point", "x y")
@test (Point.__doc__ == "Point(x, y)")
Point.__doc__ = "2D point"
@test (Point.__doc__ == "2D point")
end

function test_field_doc(self)
Point = namedtuple("Point", "x y")
@test (Point.x.__doc__ == "Alias for field number 0")
@test (Point.y.__doc__ == "Alias for field number 1")
Point.x.__doc__ = "docstring for Point.x"
@test (Point.x.__doc__ == "docstring for Point.x")
Vector = namedtuple("Vector", "x y")
@test (Vector.x.__doc__ == "Alias for field number 0")
Vector.x.__doc__ = "docstring for Vector.x"
@test (Vector.x.__doc__ == "docstring for Vector.x")
end

function test_field_doc_reuse(self)
P = namedtuple("P", ["m", "n"])
Q = namedtuple("Q", ["o", "p"])
assertIs(self, P.m.__doc__, Q.o.__doc__)
assertIs(self, P.n.__doc__, Q.p.__doc__)
end

function test_field_repr(self)
Point = namedtuple("Point", "x y")
@test (repr(Point.x) == "_tuplegetter(0, \'Alias for field number 0\')")
@test (repr(Point.y) == "_tuplegetter(1, \'Alias for field number 1\')")
Point.x.__doc__ = "The x-coordinate"
Point.y.__doc__ = "The y-coordinate"
@test (repr(Point.x) == "_tuplegetter(0, \'The x-coordinate\')")
@test (repr(Point.y) == "_tuplegetter(1, \'The y-coordinate\')")
end

function test_name_fixer(self)
for (spec, renamed) in [[("efg", "g%hi"), ("efg", "_1")], [("abc", "class"), ("abc", "_1")], [("8efg", "9ghi"), ("_0", "_1")], [("abc", "_efg"), ("abc", "_1")], [("abc", "efg", "efg", "ghi"), ("abc", "efg", "_2", "ghi")], [("abc", "", "x"), ("abc", "_1", "x")]]
@test (namedtuple("NT", spec, rename = true)._fields == renamed)
end
end

function test_module_parameter(self)
NT = namedtuple("NT", ["x", "y"], module_ = collections)
@test (NT.__module__ == collections)
end

function test_instance(self)
Point = namedtuple("Point", "x y")
p = Point(11, 22)
@test (p == Point(11, 22))
@test (p == Point(11, 22))
@test (p == Point(22, 11))
@test (p == Point((11, 22)...))
@test (p == Point(dict(x = 11, y = 22)))
@test_throws TypeError Point(1)
@test_throws TypeError Point(1, 2, 3)
assertRaises(self, TypeError) do 
Point(1, 2)
end
assertRaises(self, TypeError) do 
Point(1)
end
@test (repr(p) == "Point(x=11, y=22)")
assertNotIn(self, "__weakref__", dir(p))
@test (p == _make(Point, [11, 22]))
@test (p._fields == ("x", "y"))
@test (_replace(p, x = 1) == (1, 22))
@test (_asdict(p) == dict(x = 11, y = 22))
try
_replace(p, x = 1, error = 2)
catch exn
if exn isa ValueError
#= pass =#
end
end
Point = namedtuple("Point", "x, y")
p = Point(11, 22)
@test (repr(p) == "Point(x=11, y=22)")
Point = namedtuple("Point", ("x", "y"))
p = Point(11, 22)
@test (repr(p) == "Point(x=11, y=22)")
end

function test_tupleness(self)
Point = namedtuple("Point", "x y")
p = Point(11, 22)
@test isa(self, p)
@test (p == (11, 22))
@test (tuple(p) == (11, 22))
@test (collect(p) == [11, 22])
@test (max(p) == 22)
@test (max(p...) == 22)
x, y = p
@test (p == (x, y))
@test ((p[1], p[2]) == (11, 22))
assertRaises(self, IndexError) do 
p[4]
end
@test (p[end] == 22)
@test (hash(p) == hash((11, 22)))
@test (p.x == x)
@test (p.y == y)
assertRaises(self, AttributeError) do 
p.z
end
end

function test_odd_sizes(self)
Zero = namedtuple("Zero", "")
@test (Zero() == ())
@test (_make(Zero, []) == ())
@test (repr(Zero()) == "Zero()")
@test (_asdict(Zero()) == Dict())
@test (Zero()._fields == ())
Dot = namedtuple("Dot", "d")
@test (Dot(1) == (1,))
@test (_make(Dot, [1]) == (1,))
@test (Dot(1).d == 1)
@test (repr(Dot(1)) == "Dot(d=1)")
@test (_asdict(Dot(1)) == Dict("d" => 1))
@test (_replace(Dot(1), d = 999) == (999,))
@test (Dot(1)._fields == ("d",))
n = 5000
names = collect(set((join([choice(string.ascii_letters) for j in 0:9], "") for i in 0:n - 1)))
n = length(names)
Big = namedtuple("Big", names)
b = Big(0:n - 1...)
@test (b == tuple(0:n - 1))
@test (_make(Big, 0:n - 1) == tuple(0:n - 1))
for (pos, name) in enumerate(names)
@test (getfield(b, :name) == pos)
end
repr(b)
d = _asdict(b)
d_expected = dict(zip(names, 0:n - 1))
@test (d == d_expected)
b2 = _replace(b, None = dict([(names[2], 999), (names[end - -3], 42)]))
b2_expected = collect(0:n - 1)
b2_expected[2] = 999
b2_expected[end - -3] = 42
@test (b2 == tuple(b2_expected))
@test (b._fields == tuple(names))
end

function test_pickle(self)
p = TestNT(x = 10, y = 20, z = 30)
for module_ in (pickle,)
loads = getfield(module_, :loads)
dumps = getfield(module_, :dumps)
for protocol in -1:module_.HIGHEST_PROTOCOL
q = loads(dumps(p, protocol))
@test (p == q)
@test (p._fields == q._fields)
assertNotIn(self, b"OrderedDict", dumps(p, protocol))
end
end
end

function test_copy(self)
p = TestNT(x = 10, y = 20, z = 30)
for copier in (copy.copy, copy.deepcopy)
q = copier(p)
@test (p == q)
@test (p._fields == q._fields)
end
end

function test_name_conflicts(self)
T = namedtuple("T", "itemgetter property self cls tuple")
t = T(1, 2, 3, 4, 5)
@test (t == (1, 2, 3, 4, 5))
newt = _replace(t, itemgetter = 10, property = 20, self = 30, cls = 40, tuple = 50)
@test (newt == (10, 20, 30, 40, 50))
words = Set(["Alias", "At", "AttributeError", "Build", "Bypass", "Create", "Encountered", "Expected", "Field", "For", "Got", "Helper", "IronPython", "Jython", "KeyError", "Make", "Modify", "Note", "OrderedDict", "Point", "Return", "Returns", "Type", "TypeError", "Used", "Validate", "ValueError", "Variables", "a", "accessible", "add", "added", "all", "also", "an", "arg_list", "args", "arguments", "automatically", "be", "build", "builtins", "but", "by", "cannot", "class_namespace", "classmethod", "cls", "collections", "convert", "copy", "created", "creation", "d", "debugging", "defined", "dict", "dictionary", "doc", "docstring", "docstrings", "duplicate", "effect", "either", "enumerate", "environments", "error", "example", "exec", "f", "f_globals", "field", "field_names", "fields", "formatted", "frame", "function", "functions", "generate", "get", "getter", "got", "greater", "has", "help", "identifiers", "index", "indexable", "instance", "instantiate", "interning", "introspection", "isidentifier", "isinstance", "itemgetter", "iterable", "join", "keyword", "keywords", "kwds", "len", "like", "list", "map", "maps", "message", "metadata", "method", "methods", "module", "module_name", "must", "name", "named", "namedtuple", "namedtuple_", "names", "namespace", "needs", "new", "nicely", "num_fields", "number", "object", "of", "operator", "option", "p", "particular", "pickle", "pickling", "plain", "pop", "positional", "property", "r", "regular", "rename", "replace", "replacing", "repr", "repr_fmt", "representation", "result", "reuse_itemgetter", "s", "seen", "self", "sequence", "set", "side", "specified", "split", "start", "startswith", "step", "str", "string", "strings", "subclass", "sys", "targets", "than", "the", "their", "this", "to", "tuple", "tuple_new", "type", "typename", "underscore", "unexpected", "unpack", "up", "use", "used", "user", "valid", "values", "variable", "verbose", "where", "which", "work", "x", "y", "z", "zip"])
T = namedtuple("T", words)
values = tuple(0:length(words) - 1)
t = T(values...)
@test (t == values)
t = T(None = dict(zip(T._fields, values)))
@test (t == values)
t = _make(T, values)
@test (t == values)
repr(t)
@test (_asdict(t) == dict(zip(T._fields, values)))
t = _make(T, values)
newvalues = tuple((v*10 for v in values)...)
newt = _replace(t, None = dict(zip(T._fields, newvalues)))
@test (newt == newvalues)
@test (T._fields == tuple(words))
@test (__getnewargs__(t) == values)
end

function test_repr(self)
A = namedtuple("A", "x")
assertEqual(self, repr(A(1)), "A(x=1)")
mutable struct B <: AbstractB

end

assertEqual(self, repr(B(1)), "B(x=1)")
end

function test_keyword_only_arguments(self)
assertRaises(self, TypeError) do 
NT = namedtuple("NT", ["x", "y"], true)
end
NT = namedtuple("NT", ["abc", "def"], rename = true)
@test (NT._fields == ("abc", "_1"))
assertRaises(self, TypeError) do 
NT = namedtuple("NT", ["abc", "def"], false, true)
end
end

function test_namedtuple_subclass_issue_24931(self)
mutable struct Point <: AbstractPoint

end

a = Point(3, 4)
assertEqual(self, _asdict(a), OrderedDict([("x", 3), ("y", 4)]))
a.w = 5
assertEqual(self, a.__dict__, Dict("w" => 5))
end

function test_field_descriptor(self)
Point = namedtuple("Point", "x y")
p = Point(11, 22)
assertTrue(self, isdatadescriptor(Point.x))
assertEqual(self, __get__(Point.x, p), 11)
assertRaises(self, AttributeError, Point.x.__set__, p, 33)
assertRaises(self, AttributeError, Point.x.__delete__, p)
mutable struct NewPoint <: AbstractNewPoint
x
y

                    NewPoint(x = loads(dumps(Point.x)), y = loads(dumps(Point.y))) =
                        new(x, y)
end

np = NewPoint([1, 2])
assertEqual(self, np.x, 1)
assertEqual(self, np.y, 2)
end

function test_new_builtins_issue_43102(self)
obj = namedtuple("C", ())
new_func = obj.__new__
@test (new_func.__globals__["__builtins__"] == Dict())
@test (new_func.__builtins__ == Dict())
end

function test_match_args(self)
Point = namedtuple("Point", "x y")
@test (Point.__match_args__ == ("x", "y"))
end

mutable struct ABCTestCase <: AbstractABCTestCase
right_side::Bool
__ge__
__gt__
__le__
__lt__
__ne__
__rand__
__ror__
__rsub__
__rxor__

                    ABCTestCase(right_side::Bool, __ge__ = __eq__, __gt__ = __eq__, __le__ = __eq__, __lt__ = __eq__, __ne__ = __eq__, __rand__ = __eq__, __ror__ = __eq__, __rsub__ = __eq__, __rxor__ = __eq__) =
                        new(right_side, __ge__, __gt__, __le__, __lt__, __ne__, __rand__, __ror__, __rsub__, __rxor__)
end
function validate_abstract_methods(self, abc)
methodstubs = fromkeys(dict, names, (s) -> 0)
C = type_("C", (abc,), methodstubs)
C()
for name in names
stubs = copy(methodstubs)
#Delete Unsupported
del(stubs)
C = type_("C", (abc,), stubs)
@test_throws TypeError C(name)
end
end

function validate_isinstance(self, abc, name)
stub = (s) -> 0
C = type_("C", (object,), Dict("__hash__" => nothing))
setattr(C, name, stub)
@test isa(self, C())
@test C <: abc
C = type_("C", (object,), Dict("__hash__" => nothing))
assertNotIsInstance(self, C(), abc)
@test !(C <: abc)
end

function validate_comparison(self, instance)
ops = ["lt", "gt", "le", "ge", "ne", "or", "and", "xor", "sub"]
operators = OrderedDict()
for op in ops
name = "__" * op * "__"
operators[name] = getfield(operator, :name)
end
mutable struct Other <: AbstractOther
right_side::Bool
__ge__
__gt__
__le__
__lt__
__ne__
__rand__
__ror__
__rsub__
__rxor__

                    Other(right_side::Bool, __ge__ = __eq__, __gt__ = __eq__, __le__ = __eq__, __lt__ = __eq__, __ne__ = __eq__, __rand__ = __eq__, __ror__ = __eq__, __rsub__ = __eq__, __rxor__ = __eq__) =
                        new(right_side, __ge__, __gt__, __le__, __lt__, __ne__, __rand__, __ror__, __rsub__, __rxor__)
end
function __eq__(self, other)::Bool
self.right_side = true
return true
end

for (name, op) in collect(operators)
if !hasfield(typeof(instance), :name)
continue;
end
other = Other()
op(instance, other)
assertTrue(self, other.right_side, "Right side not called for %s.%s" % (type_(instance), name))
end
end

@resumable function _test_gen()
@yield
end

mutable struct TestOneTrickPonyABCs <: AbstractTestOneTrickPonyABCs
__contains__
__hash__
__iter__
__len__
__reversed__

                    TestOneTrickPonyABCs(__contains__ = nothing, __hash__ = nothing, __iter__ = nothing, __len__ = nothing, __reversed__ = nothing) =
                        new(__contains__, __hash__, __iter__, __len__, __reversed__)
end
function test_Awaitable(self)
Channel() do ch_test_Awaitable 
@resumable function gen()
@yield
end

@resumable function coro()
@yield
end

@async function new_coro()
#= pass =#
end
mutable struct Bar <: AbstractBar

end
@resumable function __await__(self)
@yield
end

mutable struct MinimalCoro <: AbstractMinimalCoro

end
function send(self, value)
return value
end

function throw(self, typ, val = nothing, tb = nothing)
throw(super(), typ, val, tb)
end

@resumable function __await__(self)
@yield
end

non_samples = [nothing, zero(Int), gen(), object()]
for x in non_samples
assertNotIsInstance(self, x, Awaitable)
assertFalse(self, type_(x) <: Awaitable, repr(type_(x)))
end
samples = [Bar(), MinimalCoro()]
for x in samples
assertIsInstance(self, x, Awaitable)
assertTrue(self, type_(x) <: Awaitable)
end
c = coro()
assertNotIsInstance(self, c, Awaitable)
c = new_coro()
assertIsInstance(self, c, Awaitable)
close(c)
mutable struct CoroLike <: AbstractCoroLike

end

register(CoroLike)
assertTrue(self, isa(CoroLike(), Awaitable))
assertTrue(self, CoroLike <: Awaitable)
CoroLike = nothing
gc_collect()
end
end

function test_Coroutine(self)
Channel() do ch_test_Coroutine 
@resumable function gen()
@yield
end

@resumable function coro()
@yield
end

@async function new_coro()
#= pass =#
end
mutable struct Bar <: AbstractBar

end
@resumable function __await__(self)
@yield
end

mutable struct MinimalCoro <: AbstractMinimalCoro

end
function send(self, value)
return value
end

function throw(self, typ, val = nothing, tb = nothing)
throw(super(), typ, val, tb)
end

@resumable function __await__(self)
@yield
end

non_samples = [nothing, zero(Int), gen(), object(), Bar()]
for x in non_samples
assertNotIsInstance(self, x, Coroutine)
assertFalse(self, type_(x) <: Coroutine, repr(type_(x)))
end
samples = [MinimalCoro()]
for x in samples
assertIsInstance(self, x, Awaitable)
assertTrue(self, type_(x) <: Awaitable)
end
c = coro()
assertNotIsInstance(self, c, Coroutine)
c = new_coro()
assertIsInstance(self, c, Coroutine)
close(c)
mutable struct CoroLike <: AbstractCoroLike

end
function send(self, value)
#= pass =#
end

function throw(self, typ, val = nothing, tb = nothing)
#= pass =#
end

function close(self)
#= pass =#
end

function __await__(self)
#= pass =#
end

assertTrue(self, isa(CoroLike(), Coroutine))
assertTrue(self, CoroLike <: Coroutine)
mutable struct CoroLike <: AbstractCoroLike

end
function send(self, value)
#= pass =#
end

function close(self)
#= pass =#
end

function __await__(self)
#= pass =#
end

assertFalse(self, isa(CoroLike(), Coroutine))
assertFalse(self, CoroLike <: Coroutine)
end
end

function test_Hashable(self)
non_samples = [Vector{UInt8}(), Vector(), set(), dict()]
for x in non_samples
assertNotIsInstance(self, x, Hashable)
assertFalse(self, type_(x) <: Hashable, repr(type_(x)))
end
samples = [nothing, zero(Int), float(), complex(), string(), tuple(), frozenset(), int, list, object, type_, bytes()]
for x in samples
assertIsInstance(self, x, Hashable)
assertTrue(self, type_(x) <: Hashable, repr(type_(x)))
end
assertRaises(self, TypeError, Hashable)
mutable struct H <: AbstractH

end
function __hash__(self)
return __hash__(super())
end

assertEqual(self, hash(H()), 0)
assertFalse(self, Int64 <: H)
validate_abstract_methods(self, Hashable, "__hash__")
validate_isinstance(self, Hashable, "__hash__")
end

function test_AsyncIterable(self)
mutable struct AI <: AbstractAI

end
function __aiter__(self)
return self
end

assertTrue(self, isa(AI(), AsyncIterable))
assertTrue(self, AI <: AsyncIterable)
non_samples = [nothing, object, []]
for x in non_samples
assertNotIsInstance(self, x, AsyncIterable)
assertFalse(self, type_(x) <: AsyncIterable, repr(type_(x)))
end
validate_abstract_methods(self, AsyncIterable, "__aiter__")
validate_isinstance(self, AsyncIterable, "__aiter__")
end

function test_AsyncIterator(self)
mutable struct AI <: AbstractAI

end
function __aiter__(self)
return self
end

assertTrue(self, isa(AI(), AsyncIterator))
assertTrue(self, AI <: AsyncIterator)
non_samples = [nothing, object, []]
for x in non_samples
assertNotIsInstance(self, x, AsyncIterator)
assertFalse(self, type_(x) <: AsyncIterator, repr(type_(x)))
end
mutable struct AnextOnly <: AbstractAnextOnly

end

assertNotIsInstance(self, AnextOnly(), AsyncIterator)
validate_abstract_methods(self, AsyncIterator, "__anext__", "__aiter__")
end

function test_Iterable(self)
non_samples = [nothing, 42, 3.14, 1im]
for x in non_samples
assertNotIsInstance(self, x, Iterable)
assertFalse(self, type_(x) <: Iterable, repr(type_(x)))
end
samples = [bytes(), string(), tuple(), Vector(), set(), frozenset(), dict(), keys(dict()), items(dict()), values(dict()), _test_gen(), (x for x in [])]
for x in samples
assertIsInstance(self, x, Iterable)
assertTrue(self, type_(x) <: Iterable, repr(type_(x)))
end
mutable struct I <: AbstractI

end
function __iter__(self)
return __iter__(super())
end

assertEqual(self, collect(I()), [])
assertFalse(self, String <: I)
validate_abstract_methods(self, Iterable, "__iter__")
validate_isinstance(self, Iterable, "__iter__")
mutable struct It <: AbstractIt

end
function __iter__(self)
return (x for x in [])
end

mutable struct ItBlocked <: AbstractItBlocked
__iter__

                    ItBlocked(__iter__ = nothing) =
                        new(__iter__)
end

assertTrue(self, It <: Iterable)
assertTrue(self, isa(It(), Iterable))
assertFalse(self, ItBlocked <: Iterable)
assertFalse(self, isa(ItBlocked(), Iterable))
end

function test_Reversible(self)
non_samples = [nothing, 42, 3.14, 1im, set(), frozenset()]
for x in non_samples
assertNotIsInstance(self, x, Reversible)
assertFalse(self, type_(x) <: Reversible, repr(type_(x)))
end
non_reversibles = [_test_gen(), (x for x in []), (x for x in []), reversed([])]
for x in non_reversibles
assertNotIsInstance(self, x, Reversible)
assertFalse(self, type_(x) <: Reversible, repr(type_(x)))
end
samples = [bytes(), string(), tuple(), Vector(), OrderedDict(), keys(OrderedDict()), items(OrderedDict()), values(OrderedDict()), Counter(), keys(Counter()), items(Counter()), values(Counter()), dict(), keys(dict()), items(dict()), values(dict())]
for x in samples
assertIsInstance(self, x, Reversible)
assertTrue(self, type_(x) <: Reversible, repr(type_(x)))
end
assertTrue(self, Sequence <: Reversible, repr(Sequence))
assertFalse(self, Mapping <: Reversible, repr(Mapping))
assertFalse(self, MutableMapping <: Reversible, repr(MutableMapping))
mutable struct R <: AbstractR

end
function __iter__(self)
return (x for x in Vector())
end

function __reversed__(self)
return (x for x in Vector())
end

assertEqual(self, collect(reversed(R())), [])
assertFalse(self, Float64 <: R)
validate_abstract_methods(self, Reversible, "__reversed__", "__iter__")
mutable struct RevNoIter <: AbstractRevNoIter

end
function __reversed__(self)
return reversed([])
end

mutable struct RevPlusIter <: AbstractRevPlusIter

end
function __iter__(self)
return (x for x in [])
end

assertFalse(self, RevNoIter <: Reversible)
assertFalse(self, isa(RevNoIter(), Reversible))
assertTrue(self, RevPlusIter <: Reversible)
assertTrue(self, isa(RevPlusIter(), Reversible))
mutable struct Rev <: AbstractRev

end
function __iter__(self)
return (x for x in [])
end

function __reversed__(self)
return reversed([])
end

mutable struct RevItBlocked <: AbstractRevItBlocked
__iter__

                    RevItBlocked(__iter__ = nothing) =
                        new(__iter__)
end

mutable struct RevRevBlocked <: AbstractRevRevBlocked
__reversed__

                    RevRevBlocked(__reversed__ = nothing) =
                        new(__reversed__)
end

assertTrue(self, Rev <: Reversible)
assertTrue(self, isa(Rev(), Reversible))
assertFalse(self, RevItBlocked <: Reversible)
assertFalse(self, isa(RevItBlocked(), Reversible))
assertFalse(self, RevRevBlocked <: Reversible)
assertFalse(self, isa(RevRevBlocked(), Reversible))
end

function test_Collection(self)
non_collections = [nothing, 42, 3.14, 1im, (x) -> 2*x]
for x in non_collections
assertNotIsInstance(self, x, Collection)
assertFalse(self, type_(x) <: Collection, repr(type_(x)))
end
non_col_iterables = [_test_gen(), (x for x in b""), (x for x in Vector{UInt8}()), (x for x in [])]
for x in non_col_iterables
assertNotIsInstance(self, x, Collection)
assertFalse(self, type_(x) <: Collection, repr(type_(x)))
end
samples = [set(), frozenset(), dict(), bytes(), string(), tuple(), Vector(), keys(dict()), items(dict()), values(dict())]
for x in samples
assertIsInstance(self, x, Collection)
assertTrue(self, type_(x) <: Collection, repr(type_(x)))
end
assertTrue(self, Sequence <: Collection, repr(Sequence))
assertTrue(self, Mapping <: Collection, repr(Mapping))
assertTrue(self, MutableMapping <: Collection, repr(MutableMapping))
assertTrue(self, Set <: Collection, repr(Set))
assertTrue(self, MutableSet <: Collection, repr(MutableSet))
assertTrue(self, Sequence <: Collection, repr(MutableSet))
mutable struct Col <: AbstractCol

end
function __iter__(self)
return (x for x in Vector())
end

function __len__(self)::Int64
return 0
end

function __contains__(self, item)::Bool
return false
end

mutable struct DerCol <: AbstractDerCol

end

assertEqual(self, collect((x for x in Col())), [])
assertFalse(self, Vector <: Col)
assertFalse(self, set <: Col)
assertFalse(self, Float64 <: Col)
assertEqual(self, collect((x for x in DerCol())), [])
assertFalse(self, Vector <: DerCol)
assertFalse(self, set <: DerCol)
assertFalse(self, Float64 <: DerCol)
validate_abstract_methods(self, Collection, "__len__", "__iter__", "__contains__")
mutable struct ColNoIter <: AbstractColNoIter

end
function __len__(self)::Int64
return 0
end

function __contains__(self, item)::Bool
return false
end

mutable struct ColNoSize <: AbstractColNoSize

end
function __iter__(self)
return (x for x in [])
end

function __contains__(self, item)::Bool
return false
end

mutable struct ColNoCont <: AbstractColNoCont

end
function __iter__(self)
return (x for x in [])
end

function __len__(self)::Int64
return 0
end

assertFalse(self, ColNoIter <: Collection)
assertFalse(self, isa(ColNoIter(), Collection))
assertFalse(self, ColNoSize <: Collection)
assertFalse(self, isa(ColNoSize(), Collection))
assertFalse(self, ColNoCont <: Collection)
assertFalse(self, isa(ColNoCont(), Collection))
mutable struct SizeBlock <: AbstractSizeBlock
__len__

                    SizeBlock(__len__ = nothing) =
                        new(__len__)
end
function __iter__(self)
return (x for x in [])
end

function __contains__(self)::Bool
return false
end

mutable struct IterBlock <: AbstractIterBlock
__iter__

                    IterBlock(__iter__ = nothing) =
                        new(__iter__)
end
function __len__(self)::Int64
return 0
end

function __contains__(self)::Bool
return true
end

assertFalse(self, SizeBlock <: Collection)
assertFalse(self, isa(SizeBlock(), Collection))
assertFalse(self, IterBlock <: Collection)
assertFalse(self, isa(IterBlock(), Collection))
mutable struct ColImpl <: AbstractColImpl

end
function __iter__(self)
return (x for x in Vector())
end

function __len__(self)::Int64
return 0
end

function __contains__(self, item)::Bool
return false
end

mutable struct NonCol <: AbstractNonCol
__contains__

                    NonCol(__contains__ = nothing) =
                        new(__contains__)
end

assertFalse(self, NonCol <: Collection)
assertFalse(self, isa(NonCol(), Collection))
end

function test_Iterator(self)
Channel() do ch_test_Iterator 
non_samples = [nothing, 42, 3.14, 1im, b"", "", (), [], Dict(), set()]
for x in non_samples
assertNotIsInstance(self, x, Iterator)
assertFalse(self, type_(x) <: Iterator, repr(type_(x)))
end
samples = [(x for x in bytes()), (x for x in string()), (x for x in tuple()), (x for x in Vector()), (x for x in dict()), (x for x in set()), (x for x in frozenset()), (x for x in keys(dict())), (x for x in items(dict())), (x for x in values(dict())), _test_gen(), (x for x in [])]
for x in samples
assertIsInstance(self, x, Iterator)
assertTrue(self, type_(x) <: Iterator, repr(type_(x)))
end
validate_abstract_methods(self, Iterator, "__next__", "__iter__")
mutable struct NextOnly <: AbstractNextOnly

end
@resumable function __next__(self)
@yield 1
return
end

assertNotIsInstance(self, NextOnly(), Iterator)
end
end

@resumable function test_Generator(self)
mutable struct NonGen1 <: AbstractNonGen1

end
function __iter__(self)
return self
end

function __next__(self)
return nothing
end

function close(self)
#= pass =#
end

function throw(self, typ, val = nothing, tb = nothing)
#= pass =#
end

mutable struct NonGen2 <: AbstractNonGen2

end
function __iter__(self)
return self
end

function __next__(self)
return nothing
end

function close(self)
#= pass =#
end

function send(self, value)
return value
end

mutable struct NonGen3 <: AbstractNonGen3

end
function close(self)
#= pass =#
end

function send(self, value)
return value
end

function throw(self, typ, val = nothing, tb = nothing)
#= pass =#
end

non_samples = [nothing, 42, 3.14, 1im, b"", "", (), [], Dict(), set(), (x for x in ()), (x for x in []), NonGen1(), NonGen2(), NonGen3()]
for x in non_samples
assertNotIsInstance(self, x, Generator)
assertFalse(self, type_(x) <: Generator, repr(type_(x)))
end
mutable struct Gen <: AbstractGen

end
function __iter__(self)
return self
end

function __next__(self)
return nothing
end

function close(self)
#= pass =#
end

function send(self, value)
return value
end

function throw(self, typ, val = nothing, tb = nothing)
#= pass =#
end

mutable struct MinimalGen <: AbstractMinimalGen

end
function send(self, value)
return value
end

function throw(self, typ, val = nothing, tb = nothing)
throw(super(), typ, val, tb)
end

samples = [gen(), () -> @yield(), Gen(), MinimalGen()]
for x in samples
assertIsInstance(self, x, Iterator)
assertIsInstance(self, x, Generator)
assertTrue(self, type_(x) <: Generator, repr(type_(x)))
end
validate_abstract_methods(self, Generator, "send", "throw")
mgen = MinimalGen()
assertIs(self, mgen, (x for x in mgen))
assertIs(self, send(mgen, nothing), next(mgen))
assertEqual(self, 2, send(mgen, 2))
assertIsNone(self, close(mgen))
assertRaises(self, ValueError, mgen.throw, ValueError)
assertRaisesRegex(self, ValueError, "^huhu\$", mgen.throw, ValueError, ValueError("huhu"))
assertRaises(self, StopIteration, mgen.throw, StopIteration())
mutable struct FailOnClose <: AbstractFailOnClose

end
function send(self, value)
return value
end

function throw(self)
throw(ValueError)
end

assertRaises(self, ValueError, FailOnClose().close)
mutable struct IgnoreGeneratorExit <: AbstractIgnoreGeneratorExit

end
function send(self, value)
return value
end

function throw(self)
#= pass =#
end

assertRaises(self, RuntimeError, IgnoreGeneratorExit().close)
end

function test_AsyncGenerator(self)
Channel() do ch_test_AsyncGenerator 
mutable struct NonAGen1 <: AbstractNonAGen1

end
function __aiter__(self)
return self
end

function __anext__(self)
return nothing
end

function aclose(self)
#= pass =#
end

function athrow(self, typ, val = nothing, tb = nothing)
#= pass =#
end

mutable struct NonAGen2 <: AbstractNonAGen2

end
function __aiter__(self)
return self
end

function __anext__(self)
return nothing
end

function aclose(self)
#= pass =#
end

function asend(self, value)
return value
end

mutable struct NonAGen3 <: AbstractNonAGen3

end
function aclose(self)
#= pass =#
end

function asend(self, value)
return value
end

function athrow(self, typ, val = nothing, tb = nothing)
#= pass =#
end

non_samples = [nothing, 42, 3.14, 1im, b"", "", (), [], Dict(), set(), (x for x in ()), (x for x in []), NonAGen1(), NonAGen2(), NonAGen3()]
for x in non_samples
assertNotIsInstance(self, x, AsyncGenerator)
assertFalse(self, type_(x) <: AsyncGenerator, repr(type_(x)))
end
mutable struct Gen <: AbstractGen

end
function __aiter__(self)
return self
end

mutable struct MinimalAGen <: AbstractMinimalAGen

end

@async function gen()
put!(ch_test_AsyncGenerator, 1)
end
samples = [gen(), Gen(), MinimalAGen()]
for x in samples
assertIsInstance(self, x, AsyncIterator)
assertIsInstance(self, x, AsyncGenerator)
assertTrue(self, type_(x) <: AsyncGenerator, repr(type_(x)))
end
validate_abstract_methods(self, AsyncGenerator, "asend", "athrow")
function run_async(coro)
result = nothing
while true
try
send(coro, nothing)
catch exn
 let ex = exn
if ex isa StopIteration
result = ex.args ? (ex.args[1]) : (nothing)
break;
end
end
end
end
return result
end

mgen = MinimalAGen()
assertIs(self, mgen, __aiter__(mgen))
assertIs(self, run_async(asend(mgen, nothing)), run_async(__anext__(mgen)))
assertEqual(self, 2, run_async(asend(mgen, 2)))
assertIsNone(self, run_async(aclose(mgen)))
assertRaises(self, ValueError) do 
run_async(athrow(mgen, ValueError))
end
mutable struct FailOnClose <: AbstractFailOnClose

end

assertRaises(self, ValueError) do 
run_async(aclose(FailOnClose()))
end
mutable struct IgnoreGeneratorExit <: AbstractIgnoreGeneratorExit

end

assertRaises(self, RuntimeError) do 
run_async(aclose(IgnoreGeneratorExit()))
end
end
end

function test_Sized(self)
non_samples = [nothing, 42, 3.14, 1im, _test_gen(), (x for x in [])]
for x in non_samples
assertNotIsInstance(self, x, Sized)
assertFalse(self, type_(x) <: Sized, repr(type_(x)))
end
samples = [bytes(), string(), tuple(), Vector(), set(), frozenset(), dict(), keys(dict()), items(dict()), values(dict())]
for x in samples
assertIsInstance(self, x, Sized)
assertTrue(self, type_(x) <: Sized, repr(type_(x)))
end
validate_abstract_methods(self, Sized, "__len__")
validate_isinstance(self, Sized, "__len__")
end

function test_Container(self)
non_samples = [nothing, 42, 3.14, 1im, _test_gen(), (x for x in [])]
for x in non_samples
assertNotIsInstance(self, x, Container)
assertFalse(self, type_(x) <: Container, repr(type_(x)))
end
samples = [bytes(), string(), tuple(), Vector(), set(), frozenset(), dict(), keys(dict()), items(dict())]
for x in samples
assertIsInstance(self, x, Container)
assertTrue(self, type_(x) <: Container, repr(type_(x)))
end
validate_abstract_methods(self, Container, "__contains__")
validate_isinstance(self, Container, "__contains__")
end

function test_Callable(self)
non_samples = [nothing, 42, 3.14, 1im, "", b"", (), [], Dict(), set(), _test_gen(), (x for x in [])]
for x in non_samples
assertNotIsInstance(self, x, Callable)
assertFalse(self, type_(x) <: Callable, repr(type_(x)))
end
samples = [() -> nothing, type_, int, object, len, list.append, [].append]
for x in samples
assertIsInstance(self, x, Callable)
assertTrue(self, type_(x) <: Callable, repr(type_(x)))
end
validate_abstract_methods(self, Callable, "__call__")
validate_isinstance(self, Callable, "__call__")
end

function test_direct_subclassing(self)
for B in (Hashable, Iterable, Iterator, Reversible, Sized, Container, Callable)
mutable struct C <: AbstractC

end

assertTrue(self, C <: B)
assertFalse(self, Int64 <: C)
end
end

function test_registration(self)
for B in (Hashable, Iterable, Iterator, Reversible, Sized, Container, Callable)
mutable struct C <: AbstractC
__hash__

                    C(__hash__ = nothing) =
                        new(__hash__)
end

assertFalse(self, C <: B, B.__name__)
register(B, C)
assertTrue(self, C <: B)
end
end

mutable struct WithSet <: AbstractWithSet
data
it::Tuple

                    WithSet(data, it::Tuple = ()) =
                        new(data, it)
end
function __len__(self)::Int64
return length(self.data)
end

function __iter__(self)
return (x for x in self.data)
end

function __contains__(self, item)::Bool
return item ∈ self.data
end

function add(self, item)
add(self.data, item)
end

function discard(self, item)
discard(self.data, item)
end

mutable struct TestCollectionABCs <: AbstractTestCollectionABCs
__s
_seq
_values
contents::Vector{Int64}
created_by
data::Vector
lst::Vector
seq
__abc_tpflags__
__slots__::Vector{String}
elements::Tuple
items

                    TestCollectionABCs(__s, _seq, _values, contents::Vector{Int64}, created_by, data::Vector, lst::Vector, seq, __abc_tpflags__ = Sequence.__flags__ | Mapping.__flags__, __slots__::Vector{String} = ["__s"], elements::Tuple = (), items = nothing) =
                        new(__s, _seq, _values, contents, created_by, data, lst, seq, __abc_tpflags__, __slots__, elements, items)
end
function test_Set(self)
for sample in [set, frozenset]
assertIsInstance(self, sample(), Set)
assertTrue(self, sample <: Set)
end
validate_abstract_methods(self, Set, "__contains__", "__iter__", "__len__")
mutable struct MySet <: AbstractMySet

end
function __contains__(self, x)::Bool
return false
end

function __len__(self)::Int64
return 0
end

function __iter__(self)
return (x for x in [])
end

validate_comparison(self, MySet())
end

function test_hash_Set(self)
mutable struct OneTwoThreeSet <: AbstractOneTwoThreeSet
contents::Vector{Int64}
end
function __contains__(self, x)::Bool
return x ∈ self.contents
end

function __len__(self)::Int64
return length(self.contents)
end

function __iter__(self)
return (x for x in self.contents)
end

function __hash__(self)
return _hash(self)
end

a, b = (OneTwoThreeSet(), OneTwoThreeSet())
assertTrue(self, hash(a) == hash(b))
end

function test_isdisjoint_Set(self)
mutable struct MySet <: AbstractMySet
contents
end
function __contains__(self, x)::Bool
return x ∈ self.contents
end

function __iter__(self)
return (x for x in self.contents)
end

function __len__(self)::Int64
return length([x for x in self.contents])
end

s1 = MySet((1, 2, 3))
s2 = MySet((4, 5, 6))
s3 = MySet((1, 5, 6))
assertTrue(self, isdisjoint(s1, s2))
assertFalse(self, isdisjoint(s1, s3))
end

function test_equality_Set(self)
mutable struct MySet <: AbstractMySet
contents
end
function __contains__(self, x)::Bool
return x ∈ self.contents
end

function __iter__(self)
return (x for x in self.contents)
end

function __len__(self)::Int64
return length([x for x in self.contents])
end

s1 = MySet((1,))
s2 = MySet((1, 2))
s3 = MySet((3, 4))
s4 = MySet((3, 4))
assertTrue(self, s2 > s1)
assertTrue(self, s1 < s2)
assertFalse(self, s2 <= s1)
assertFalse(self, s2 <= s3)
assertFalse(self, s1 >= s2)
assertEqual(self, s3, s4)
assertNotEqual(self, s2, s3)
end

function test_arithmetic_Set(self)
mutable struct MySet <: AbstractMySet
contents
end
function __contains__(self, x)::Bool
return x ∈ self.contents
end

function __iter__(self)
return (x for x in self.contents)
end

function __len__(self)::Int64
return length([x for x in self.contents])
end

s1 = MySet((1, 2, 3))
s2 = MySet((3, 4, 5))
s3 = __and__(s1, s2)
assertEqual(self, s3, MySet((3,)))
end

function test_MutableSet(self)
assertIsInstance(self, set(), MutableSet)
assertTrue(self, set <: MutableSet)
assertNotIsInstance(self, frozenset(), MutableSet)
assertFalse(self, pset <: MutableSet)
validate_abstract_methods(self, MutableSet, "__contains__", "__iter__", "__len__", "add", "discard")
end

function test_issue_5647(self)
s = WithSet("abcd")
s = __and__(s, WithSet("cdef"))
assertEqual(self, set(s), set("cd"))
end

function test_issue_4920(self)
mutable struct MySet <: AbstractMySet
__s
__slots__::Vector{String}
items

            MySet(items = nothing, __slots__::Vector{String} = ["__s"]) = begin
                if items === nothing
items = []
end
                new(items , __slots__)
            end
end
function __contains__(self, v)::Bool
return v ∈ self.__s
end

function __iter__(self)
return (x for x in self.__s)
end

function __len__(self)::Int64
return length(self.__s)
end

function add(self, v)::Bool
result = v ∉ self.__s
add(self.__s, v)
return result
end

function discard(self, v)::Bool
result = v ∈ self.__s
discard(self.__s, v)
return result
end

function __repr__(self)::String
return "MySet(%s)" % repr(collect(self))
end

items = [5, 43, 2, 1]
s = MySet(items)
r = pop(s)
assertEqual(self, length(s), length(items) - 1)
assertNotIn(self, r, s)
assertIn(self, r, items)
end

function test_issue8750(self)
empty = WithSet()
full = WithSet(0:9)
s = WithSet(full)
s = __sub__(s, s)
assertEqual(self, s, empty)
s = WithSet(full)
s = __xor__(s, s)
assertEqual(self, s, empty)
s = WithSet(full)
s = __and__(s, s)
assertEqual(self, s, full)
s = __or__(s, s)
assertEqual(self, s, full)
end

function test_issue16373(self)
mutable struct MyComparableSet <: AbstractMyComparableSet

end
function __contains__(self, x)::Bool
return false
end

function __len__(self)::Int64
return 0
end

function __iter__(self)
return (x for x in [])
end

mutable struct MyNonComparableSet <: AbstractMyNonComparableSet

end
function __contains__(self, x)::Bool
return false
end

function __len__(self)::Int64
return 0
end

function __iter__(self)
return (x for x in [])
end

function __le__(self, x)
return NotImplemented
end

function __lt__(self, x)
return NotImplemented
end

cs = MyComparableSet()
ncs = MyNonComparableSet()
assertFalse(self, ncs < cs)
assertTrue(self, ncs <= cs)
assertFalse(self, ncs > cs)
assertTrue(self, ncs >= cs)
end

function test_issue26915(self)
mutable struct CustomSequence <: AbstractCustomSequence
_seq
end
function __getitem__(self, index)
return self._seq[index + 1]
end

function __len__(self)::Int64
return length(self._seq)
end

nan = float("nan")
obj = support.NEVER_EQ
seq = CustomSequence([nan, obj, nan])
containers = [seq, ItemsView(Dict(1 => nan, 2 => obj)), ValuesView(Dict(1 => nan, 2 => obj))]
for container in containers
for elem in container
assertIn(self, elem, container)
end
end
assertEqual(self, index(seq, nan), 0)
assertEqual(self, index(seq, obj), 1)
assertEqual(self, count(seq, nan), 2)
assertEqual(self, count(seq, obj), 1)
end

function assertSameSet(self, s1, s2)
assertSetEqual(self, set(s1), set(s2))
end

function test_Set_from_iterable(self)
#= Verify _from_iterable overridden to an instance method works. =#
Channel() do ch_test_Set_from_iterable 
mutable struct SetUsingInstanceFromIterable <: AbstractSetUsingInstanceFromIterable
created_by
_values

            SetUsingInstanceFromIterable(values, created_by) = begin
                if !(created_by)
throw(ValueError("created_by must be specified"))
end
                new(values, created_by)
            end
end
function _from_iterable(self, values)
return type_(self)(values, "from_iterable")
end

function __contains__(self, value)::Bool
return value ∈ self._values
end

function __iter__(self)
Channel() do ch___iter__ 
# Unsupported
@yield_from self._values
end
end

function __len__(self)::Int64
return length(self._values)
end

function add(self, value)
add(self._values, value)
end

function discard(self, value)
discard(self._values, value)
end

impl = SetUsingInstanceFromIterable([1, 2, 3], "test")
actual = __sub__(impl, Set([1]))
assertIsInstance(self, actual, SetUsingInstanceFromIterable)
assertEqual(self, "from_iterable", actual.created_by)
assertEqual(self, Set([2, 3]), actual)
actual = __or__(impl, Set([4]))
assertIsInstance(self, actual, SetUsingInstanceFromIterable)
assertEqual(self, "from_iterable", actual.created_by)
assertEqual(self, Set([1, 2, 3, 4]), actual)
actual = __and__(impl, Set([2]))
assertIsInstance(self, actual, SetUsingInstanceFromIterable)
assertEqual(self, "from_iterable", actual.created_by)
assertEqual(self, Set([2]), actual)
actual = __xor__(impl, Set([3, 4]))
assertIsInstance(self, actual, SetUsingInstanceFromIterable)
assertEqual(self, "from_iterable", actual.created_by)
assertEqual(self, Set([1, 2, 4]), actual)
impl = __xor__(impl, [3, 4])
assertIsInstance(self, impl, SetUsingInstanceFromIterable)
assertEqual(self, "test", impl.created_by)
assertEqual(self, Set([1, 2, 4]), impl)
end
end

function test_Set_interoperability_with_real_sets(self)
mutable struct ListSet <: AbstractListSet
data::Vector
elements::Tuple

            ListSet(elements = ()) = begin
                for elem in elements
if elem ∉ data
data.append(elem)
end
end
                new(elements )
            end
end
function __contains__(self, elem)::Bool
return elem ∈ self.data
end

function __iter__(self)
return (x for x in self.data)
end

function __len__(self)::Int64
return length(self.data)
end

function __repr__(self)
return "Set($(!r))"
end

r1 = set("abc")
r2 = set("bcd")
r3 = set("abcde")
f1 = ListSet("abc")
f2 = ListSet("bcd")
f3 = ListSet("abcde")
l1 = collect("abccba")
l2 = collect("bcddcb")
l3 = collect("abcdeedcba")
target = r1 & r2
assertSameSet(self, __and__(f1, f2), target)
assertSameSet(self, __and__(f1, r2), target)
assertSameSet(self, __and__(r2, f1), target)
assertSameSet(self, __and__(f1, l2), target)
target = r1 | r2
assertSameSet(self, __or__(f1, f2), target)
assertSameSet(self, __or__(f1, r2), target)
assertSameSet(self, __or__(r2, f1), target)
assertSameSet(self, __or__(f1, l2), target)
fwd_target = r1 - r2
rev_target = r2 - r1
assertSameSet(self, __sub__(f1, f2), fwd_target)
assertSameSet(self, __sub__(f2, f1), rev_target)
assertSameSet(self, __sub__(f1, r2), fwd_target)
assertSameSet(self, __sub__(f2, r1), rev_target)
assertSameSet(self, __sub__(r1, f2), fwd_target)
assertSameSet(self, __sub__(r2, f1), rev_target)
assertSameSet(self, __sub__(f1, l2), fwd_target)
assertSameSet(self, __sub__(f2, l1), rev_target)
target = r1  ⊻  r2
assertSameSet(self, __xor__(f1, f2), target)
assertSameSet(self, __xor__(f1, r2), target)
assertSameSet(self, __xor__(r2, f1), target)
assertSameSet(self, __xor__(f1, l2), target)
assertTrue(self, f1 < f3)
assertFalse(self, f1 < f1)
assertFalse(self, f1 < f2)
assertTrue(self, r1 < f3)
assertFalse(self, r1 < f1)
assertFalse(self, r1 < f2)
assertTrue(self, r1 < r3)
assertFalse(self, r1 < r1)
assertFalse(self, r1 < r2)
assertRaises(self, TypeError) do 
f1 < l3
end
assertRaises(self, TypeError) do 
f1 < l1
end
assertRaises(self, TypeError) do 
f1 < l2
end
assertTrue(self, f1 <= f3)
assertTrue(self, f1 <= f1)
assertFalse(self, f1 <= f2)
assertTrue(self, r1 <= f3)
assertTrue(self, r1 <= f1)
assertFalse(self, r1 <= f2)
assertTrue(self, r1 <= r3)
assertTrue(self, r1 <= r1)
assertFalse(self, r1 <= r2)
assertRaises(self, TypeError) do 
f1 <= l3
end
assertRaises(self, TypeError) do 
f1 <= l1
end
assertRaises(self, TypeError) do 
f1 <= l2
end
assertTrue(self, f3 > f1)
assertFalse(self, f1 > f1)
assertFalse(self, f2 > f1)
assertTrue(self, r3 > r1)
assertFalse(self, f1 > r1)
assertFalse(self, f2 > r1)
assertTrue(self, r3 > r1)
assertFalse(self, r1 > r1)
assertFalse(self, r2 > r1)
assertRaises(self, TypeError) do 
f1 > l3
end
assertRaises(self, TypeError) do 
f1 > l1
end
assertRaises(self, TypeError) do 
f1 > l2
end
assertTrue(self, f3 >= f1)
assertTrue(self, f1 >= f1)
assertFalse(self, f2 >= f1)
assertTrue(self, r3 >= r1)
assertTrue(self, f1 >= r1)
assertFalse(self, f2 >= r1)
assertTrue(self, r3 >= r1)
assertTrue(self, r1 >= r1)
assertFalse(self, r2 >= r1)
assertRaises(self, TypeError) do 
f1 >= l3
end
assertRaises(self, TypeError) do 
f1 >= l1
end
assertRaises(self, TypeError) do 
f1 >= l2
end
assertTrue(self, f1 == f1)
assertTrue(self, r1 == f1)
assertTrue(self, f1 == r1)
assertFalse(self, f1 == f3)
assertFalse(self, r1 == f3)
assertFalse(self, f1 == r3)
assertFalse(self, f1 == l3)
assertFalse(self, f1 == l1)
assertFalse(self, f1 == l2)
assertFalse(self, f1 != f1)
assertFalse(self, r1 != f1)
assertFalse(self, f1 != r1)
assertTrue(self, f1 != f3)
assertTrue(self, r1 != f3)
assertTrue(self, f1 != r3)
assertTrue(self, f1 != l3)
assertTrue(self, f1 != l1)
assertTrue(self, f1 != l2)
end

function test_Set_hash_matches_frozenset(self)
sets = [Dict(), Set([1]), Set([nothing]), Set([-1]), Set([0.0]), Set(["abc"]), Set([1, 2, 3]), Set([10^100, 10^101]), Set(["a", "b", "ab", ""]), Set([false, true]), Set([object(), object(), object()]), Set([float("nan")]), Set([frozenset()]), Set([0:999...]), Set([0:999...]) - Set([100, 200, 300]), Set([sys.maxsize - 10:sys.maxsize + 9...])]
for s in sets
fs = frozenset(s)
assertEqual(self, hash(fs), _hash(fs), msg = s)
end
end

function test_Mapping(self)
for sample in [dict]
assertIsInstance(self, sample(), Mapping)
assertTrue(self, sample <: Mapping)
end
validate_abstract_methods(self, Mapping, "__contains__", "__iter__", "__len__", "__getitem__")
mutable struct MyMapping <: AbstractMyMapping

end
function __len__(self)::Int64
return 0
end

function __getitem__(self, i)
throw(IndexError)
end

function __iter__(self)
return (x for x in ())
end

validate_comparison(self, MyMapping())
assertRaises(self, TypeError, reversed, MyMapping())
end

function test_MutableMapping(self)
for sample in [dict]
assertIsInstance(self, sample(), MutableMapping)
assertTrue(self, sample <: MutableMapping)
end
validate_abstract_methods(self, MutableMapping, "__contains__", "__iter__", "__len__", "__getitem__", "__setitem__", "__delitem__")
end

function test_MutableMapping_subclass(self)
mymap = UserDict()
mymap["red"] = 5
assertIsInstance(self, keys(mymap), Set)
assertIsInstance(self, keys(mymap), KeysView)
assertIsInstance(self, items(mymap), Set)
assertIsInstance(self, items(mymap), ItemsView)
mymap = UserDict()
mymap["red"] = 5
z = keys(mymap) | Set(["orange"])
assertIsInstance(self, z, set)
collect(z)
mymap["blue"] = 7
assertEqual(self, sorted(z), ["orange", "red"])
mymap = UserDict()
mymap["red"] = 5
z = items(mymap) | Set([("orange", 3)])
assertIsInstance(self, z, set)
collect(z)
mymap["blue"] = 7
assertEqual(self, z, Set([("orange", 3), ("red", 5)]))
end

function test_Sequence(self)
for sample in [tuple, list, bytes, str]
assertIsInstance(self, sample(), Sequence)
assertTrue(self, sample <: Sequence)
end
assertIsInstance(self, 0:9, Sequence)
assertTrue(self, range <: Sequence)
assertIsInstance(self, memoryview(b""), Sequence)
assertTrue(self, memoryview <: Sequence)
assertTrue(self, String <: Sequence)
validate_abstract_methods(self, Sequence, "__contains__", "__iter__", "__len__", "__getitem__")
end

function test_Sequence_mixins(self)
mutable struct SequenceSubclass <: AbstractSequenceSubclass
seq
end
function __getitem__(self, index)
return self.seq[index + 1]
end

function __len__(self)::Int64
return length(self.seq)
end

function assert_index_same(seq1, seq2, index_args)
try
expected = index(seq1, index_args...)
catch exn
if exn isa ValueError
assertRaises(self, ValueError) do 
index(seq2, index_args...)
end
end
end
end

for ty in (list, str)
nativeseq = ty("abracadabra")
indexes = append!([-10000, -9999], collect(-3:length(nativeseq) + 2))
seqseq = SequenceSubclass(nativeseq)
for letter in set(nativeseq) | Set(["z"])
assert_index_same(nativeseq, seqseq, (letter,))
for start in -3:length(nativeseq) + 2
assert_index_same(nativeseq, seqseq, (letter, start))
for stop in -3:length(nativeseq) + 2
assert_index_same(nativeseq, seqseq, (letter, start, stop))
end
end
end
end
end

function test_ByteString(self)
for sample in [bytes, bytearray]
assertIsInstance(self, sample(), ByteString)
assertTrue(self, sample <: ByteString)
end
for sample in [str, list, tuple]
assertNotIsInstance(self, sample(), ByteString)
assertFalse(self, sample <: ByteString)
end
assertNotIsInstance(self, memoryview(b""), ByteString)
assertFalse(self, memoryview <: ByteString)
end

function test_MutableSequence(self)
for sample in [tuple, str, bytes]
assertNotIsInstance(self, sample(), MutableSequence)
assertFalse(self, sample <: MutableSequence)
end
for sample in [list, bytearray, deque]
assertIsInstance(self, sample(), MutableSequence)
assertTrue(self, sample <: MutableSequence)
end
assertFalse(self, String <: MutableSequence)
validate_abstract_methods(self, MutableSequence, "__contains__", "__iter__", "__len__", "__getitem__", "__setitem__", "__delitem__", "insert")
end

function test_MutableSequence_mixins(self)
mutable struct MutableSequenceSubclass <: AbstractMutableSequenceSubclass
lst::Vector
end
function __setitem__(self, index, value)
self.lst[index + 1] = value
end

function __getitem__(self, index)::Vector
return self.lst[index + 1]
end

function __len__(self)::Int64
return length(self.lst)
end

function __delitem__(self, index)
#Delete Unsupported
del(self.lst)
end

function insert(self, index, value)
insert(self.lst, index, value)
end

mss = MutableSequenceSubclass()
append(mss, 0)
extend(mss, (1, 2, 3, 4))
assertEqual(self, length(mss), 5)
assertEqual(self, mss[4], 3)
reverse(mss)
assertEqual(self, mss[4], 1)
pop(mss)
assertEqual(self, length(mss), 4)
remove(mss, 3)
assertEqual(self, length(mss), 3)
mss = __add__(mss, (10, 20, 30))
assertEqual(self, length(mss), 6)
assertEqual(self, mss[end], 30)
clear(mss)
assertEqual(self, length(mss), 0)
items = "ABCD"
mss2 = MutableSequenceSubclass()
extend(mss2, items * items)
clear(mss)
extend(mss, items)
extend(mss, mss)
assertEqual(self, length(mss), length(mss2))
assertEqual(self, collect(mss), collect(mss2))
end

function test_illegal_patma_flags(self)
assertRaises(self, TypeError) do 
mutable struct Both <: AbstractBoth
__abc_tpflags__

                    Both(__abc_tpflags__ = Sequence.__flags__ | Mapping.__flags__) =
                        new(__abc_tpflags__)
end

end
end

mutable struct CounterSubclassWithSetItem <: AbstractCounterSubclassWithSetItem
called::Bool

            CounterSubclassWithSetItem() = begin
                Counter.__init__(self, args..., None = kwds)
                new()
            end
end
function __setitem__(self, key, value)
self.called = true
__setitem__(self, key, value)
end

mutable struct CounterSubclassWithGet <: AbstractCounterSubclassWithGet
called::Bool

            CounterSubclassWithGet() = begin
                Counter.__init__(self, args..., None = kwds)
                new()
            end
end
function get(self, key, default)
self.called = true
return get(self, key, default)
end

mutable struct TestCounter <: AbstractTestCounter

end
function test_basics(self)
c = Counter("abcaba")
@test (c == Counter(Dict("a" => 3, "b" => 2, "c" => 1)))
@test (c == Counter(a = 3, b = 2, c = 1))
@test isa(self, c)
@test isa(self, c)
@test Counter <: dict
@test Counter <: Mapping
@test (length(c) == 3)
@test (sum(values(c)) == 6)
@test (collect(values(c)) == [3, 2, 1])
@test (collect(keys(c)) == ["a", "b", "c"])
@test (collect(c) == ["a", "b", "c"])
@test (collect(items(c)) == [("a", 3), ("b", 2), ("c", 1)])
@test (c["b"] == 2)
@test (c["z"] == 0)
@test (__contains__(c, "c") == true_)
@test (__contains__(c, "z") == false_)
@test (get(c, "b", 10) == 2)
@test (get(c, "z", 10) == 10)
@test (c == dict(a = 3, b = 2, c = 1))
@test (repr(c) == "Counter({\'a\': 3, \'b\': 2, \'c\': 1})")
@test (most_common(c) == [("a", 3), ("b", 2), ("c", 1)])
for i in 0:4
@test (most_common(c, i) == [("a", 3), ("b", 2), ("c", 1)][begin:i])
end
@test (join(elements(c), "") == "aaabbc")
c["a"] += 1
c["b"] -= 2
#Delete Unsupported
del(c)
#Delete Unsupported
del(c)
c["d"] -= 2
c["e"] = -5
c["f"] += 4
@test (c == dict(a = 4, b = 0, d = -2, e = -5, f = 4))
@test (join(elements(c), "") == "aaaaffff")
@test (pop(c, "f") == 4)
assertNotIn(self, "f", c)
for i in 0:2
elem, cnt = popitem(c)
assertNotIn(self, elem, c)
end
clear(c)
@test (c == Dict())
@test (repr(c) == "Counter()")
@test_throws NotImplementedError Counter.fromkeys("abc")
@test_throws TypeError hash(c)
update(c, dict(a = 5, b = 3))
update(c, c = 1)
update(c, Counter(repeat("a",50) * repeat("b",30)))
update(c)
__init__(c, repeat("a",500) * repeat("b",300))
__init__(c, "cdc")
__init__(c)
@test (c == dict(a = 555, b = 333, c = 3, d = 1))
@test (setdefault(c, "d", 5) == 1)
@test (c["d"] == 1)
@test (setdefault(c, "e", 5) == 5)
@test (c["e"] == 5)
end

function test_init(self)
@test (collect(items(Counter(self = 42))) == [("self", 42)])
@test (collect(items(Counter(iterable = 42))) == [("iterable", 42)])
@test (collect(items(Counter(iterable = nothing))) == [("iterable", nothing)])
@test_throws TypeError Counter(42)
@test_throws TypeError Counter((), ())
@test_throws TypeError Counter.__init__()
end

function test_total(self)
c = Counter(a = 10, b = 5, c = 0)
@test (total(c) == 15)
end

function test_order_preservation(self)
@test (collect(items(Counter("abracadabra"))) == [("a", 5), ("b", 2), ("r", 2), ("c", 1), ("d", 1)])
@test (collect(items(Counter("xyzpdqqdpzyx"))) == [("x", 2), ("y", 2), ("z", 2), ("p", 2), ("d", 2), ("q", 2)])
@test (collect(elements(Counter("abracadabra simsalabim"))) == ["a", "a", "a", "a", "a", "a", "a", "b", "b", "b", "r", "r", "c", "d", " ", "s", "s", "i", "i", "m", "m", "l"])
ps = "aaabbcdddeefggghhijjjkkl"
qs = "abbcccdeefffhkkllllmmnno"
order = Dict(letter => i for (i, letter) in enumerate(fromkeys(dict, ps * qs)))
function correctly_ordered(seq)::Bool
#= Return true if the letters occur in the expected order =#
positions = [order[letter] for letter in seq]
return positions == sorted(positions)
end

p, q = (Counter(ps), Counter(qs))
@test correctly_ordered(+(p))
@test correctly_ordered(-(p))
@test correctly_ordered(p + q)
@test correctly_ordered(p - q)
@test correctly_ordered(p | q)
@test correctly_ordered(p & q)
p, q = (Counter(ps), Counter(qs))
p += q
@test correctly_ordered(p)
p, q = (Counter(ps), Counter(qs))
p -= q
@test correctly_ordered(p)
p, q = (Counter(ps), Counter(qs))
p |= q
@test correctly_ordered(p)
p, q = (Counter(ps), Counter(qs))
p = p & q
@test correctly_ordered(p)
p, q = (Counter(ps), Counter(qs))
update(p, q)
@test correctly_ordered(p)
p, q = (Counter(ps), Counter(qs))
subtract(p, q)
@test correctly_ordered(p)
end

function test_update(self)
c = Counter()
update(c, self = 42)
@test (collect(items(c)) == [("self", 42)])
c = Counter()
update(c, iterable = 42)
@test (collect(items(c)) == [("iterable", 42)])
c = Counter()
update(c, iterable = nothing)
@test (collect(items(c)) == [("iterable", nothing)])
@test_throws TypeError Counter().update(42)
@test_throws TypeError Counter().update(Dict(), Dict())
@test_throws TypeError Counter.update()
end

function test_copying(self)
words = Counter(split("which witch had which witches wrist watch"))
function check(dup)
msg = "\ncopy: %s\nwords: %s" % (dup, words)
assertIsNot(self, dup, words, msg)
@test (dup == words)
end

check(copy(words))
check(copy(words))
check(deepcopy(words))
for proto in 0:pickle.HIGHEST_PROTOCOL
subTest(self, proto = proto) do 
check(loads(dumps(words, proto)))
end
end
check(eval(repr(words)))
update_test = Counter()
update(update_test, words)
check(update_test)
check(Counter(words))
end

function test_copy_subclass(self)
mutable struct MyCounter <: AbstractMyCounter

end

c = MyCounter("slartibartfast")
d = copy(c)
assertEqual(self, d, c)
assertEqual(self, length(d), length(c))
assertEqual(self, type_(d), type_(c))
end

function test_conversions(self)
s = "she sells sea shells by the sea shore"
@test (sorted(elements(Counter(s))) == sorted(s))
@test (sorted(Counter(s)) == sorted(set(s)))
@test (dict(Counter(s)) == dict(items(Counter(s))))
@test (set(Counter(s)) == set(s))
end

function test_invariant_for_the_in_operator(self)
c = Counter(a = 10, b = -2, c = 0)
for elem in c
@test elem ∈ c
assertIn(self, elem, c)
end
end

function test_multiset_operations(self)
c = Counter(a = 10, b = -2, c = 0) + Counter()
@test (dict(c) == dict(a = 10))
elements = "abcd"
for i in 0:999
p = Counter(dict(((elem, randrange(-2, 4)) for elem in elements)))
update(p, e = 1, f = -1, g = 0)
q = Counter(dict(((elem, randrange(-2, 4)) for elem in elements)))
update(q, h = 1, i = -1, j = 0)
for (counterop, numberop) in [(Counter.__add__, (x, y) -> max(0, x + y)), (Counter.__sub__, (x, y) -> max(0, x - y)), (Counter.__or__, (x, y) -> max(0, x, y)), (Counter.__and__, (x, y) -> max(0, min(x, y)))]
result = counterop(p, q)
for x in elements
@test (numberop(p[x + 1], q[x + 1]) == result[x + 1])
end
@test (x > 0 for x in values(result))
end
end
elements = "abcdef"
for i in 0:99
p = Counter(dict(((elem, randrange(0, 2)) for elem in elements)))
q = Counter(dict(((elem, randrange(0, 2)) for elem in elements)))
for (counterop, setop) in [(Counter.__sub__, set.__sub__), (Counter.__or__, set.__or__), (Counter.__and__, set.__and__)]
counter_result = counterop(p, q)
set_result = setop(set(elements(p)), set(elements(q)))
@test (counter_result == fromkeys(dict, set_result, 1))
end
end
end

function test_inplace_operations(self)
elements = "abcd"
for i in 0:999
p = Counter(dict(((elem, randrange(-2, 4)) for elem in elements)))
update(p, e = 1, f = -1, g = 0)
q = Counter(dict(((elem, randrange(-2, 4)) for elem in elements)))
update(q, h = 1, i = -1, j = 0)
for (inplace_op, regular_op) in [(Counter.__iadd__, Counter.__add__), (Counter.__isub__, Counter.__sub__), (Counter.__ior__, Counter.__or__), (Counter.__iand__, Counter.__and__)]
c = copy(p)
c_id = id(c)
regular_result = regular_op(c, q)
inplace_result = inplace_op(c, q)
@test (inplace_result == regular_result)
@test (id(inplace_result) == c_id)
end
end
end

function test_subtract(self)
c = Counter(a = -5, b = 0, c = 5, d = 10, e = 15, g = 40)
subtract(c, a = 1, b = 2, c = -3, d = 10, e = 20, f = 30, h = -50)
@test (c == Counter(a = -6, b = -2, c = 8, d = 0, e = -5, f = -30, g = 40, h = 50))
c = Counter(a = -5, b = 0, c = 5, d = 10, e = 15, g = 40)
subtract(c, Counter(a = 1, b = 2, c = -3, d = 10, e = 20, f = 30, h = -50))
@test (c == Counter(a = -6, b = -2, c = 8, d = 0, e = -5, f = -30, g = 40, h = 50))
c = Counter("aaabbcd")
subtract(c, "aaaabbcce")
@test (c == Counter(a = -1, b = 0, c = -1, d = 1, e = -1))
c = Counter()
subtract(c, self = 42)
@test (collect(items(c)) == [("self", -42)])
c = Counter()
subtract(c, iterable = 42)
@test (collect(items(c)) == [("iterable", -42)])
@test_throws TypeError Counter().subtract(42)
@test_throws TypeError Counter().subtract(Dict(), Dict())
@test_throws TypeError Counter.subtract()
end

function test_unary(self)
c = Counter(a = -5, b = 0, c = 5, d = 10, e = 15, g = 40)
@test (dict(+(c)) == dict(c = 5, d = 10, e = 15, g = 40))
@test (dict(-(c)) == dict(a = 5))
end

function test_repr_nonsortable(self)
c = Counter(a = 2, b = nothing)
r = repr(c)
assertIn(self, "\'a\': 2", r)
assertIn(self, "\'b\': None", r)
end

function test_helper_function(self)
elems = collect("abracadabra")
d = dict()
_count_elements(d, elems)
@test (d == Dict("a" => 5, "r" => 2, "b" => 2, "c" => 1, "d" => 1))
m = OrderedDict()
_count_elements(m, elems)
@test (m == OrderedDict([("a", 5), ("b", 2), ("r", 2), ("c", 1), ("d", 1)]))
c = CounterSubclassWithSetItem("abracadabra")
@test c.called
@test (dict(c) == Dict("a" => 5, "b" => 2, "c" => 1, "d" => 1, "r" => 2))
c = CounterSubclassWithGet("abracadabra")
@test c.called
@test (dict(c) == Dict("a" => 5, "b" => 2, "c" => 1, "d" => 1, "r" => 2))
end

function test_multiset_operations_equivalent_to_set_operations(self)
s = collect(product(("a", "b", "c"), 0:1))
powerset = from_iterable((combinations(s, r) for r in 0:length(s)))
counters = [Counter(dict(groups)) for groups in powerset]
for (cp, cq) in product(counters, repeat = 2)
sp = set(elements(cp))
sq = set(elements(cq))
@test (set(cp + cq) == sp | sq)
@test (set(cp - cq) == sp - sq)
@test (set(cp | cq) == sp | sq)
@test (set(cp & cq) == sp & sq)
@test (cp == cq == sp == sq)
@test (cp != cq == sp != sq)
@test (cp <= cq == sp <= sq)
@test (cp >= cq == sp >= sq)
@test (cp < cq == sp < sq)
@test (cp > cq == sp > sq)
end
end

function test_eq(self)
@test (Counter(a = 3, b = 2, c = 0) == Counter("ababa"))
assertNotEqual(self, Counter(a = 3, b = 2), Counter("babab"))
end

function test_le(self)
@test Counter(a = 3, b = 2, c = 0) <= Counter("ababa")
@test !(Counter(a = 3, b = 2) <= Counter("babab"))
end

function test_lt(self)
@test Counter(a = 3, b = 1, c = 0) < Counter("ababa")
@test !(Counter(a = 3, b = 2, c = 0) < Counter("ababa"))
end

function test_ge(self)
@test Counter(a = 2, b = 1, c = 0) >= Counter("aab")
@test !(Counter(a = 3, b = 2, c = 0) >= Counter("aabd"))
end

function test_gt(self)
@test Counter(a = 3, b = 2, c = 0) > Counter("aab")
@test !(Counter(a = 2, b = 1, c = 0) > Counter("aab"))
end

function test_main(verbose = nothing)
NamedTupleDocs = DocTestSuite(module_ = collections)
test_classes = [TestNamedTuple, NamedTupleDocs, TestOneTrickPonyABCs, TestCollectionABCs, TestCounter, TestChainMap, TestUserObjects]
run_unittest(test_classes...)
run_doctest(collections, verbose)
end

if abspath(PROGRAM_FILE) == @__FILE__
test_main()
test_user_objects = TestUserObjects()
_superset_test(test_user_objects)
_copy_test(test_user_objects)
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
validate_abstract_methods(a_b_c_test_case)
validate_isinstance(a_b_c_test_case)
validate_comparison(a_b_c_test_case)
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
end