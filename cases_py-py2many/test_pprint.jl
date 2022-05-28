using Test




import pprint
import random




abstract type Abstractlist2 <: list end
abstract type Abstractlist3 <: list end
abstract type Abstractlist_custom_repr <: list end
abstract type Abstracttuple2 <: tuple end
abstract type Abstracttuple3 <: tuple end
abstract type Abstracttuple_custom_repr <: tuple end
abstract type Abstractset2 <: set end
abstract type Abstractset3 <: set end
abstract type Abstractset_custom_repr <: set end
abstract type Abstractfrozenset2 <: frozenset end
abstract type Abstractfrozenset3 <: frozenset end
abstract type Abstractfrozenset_custom_repr <: frozenset end
abstract type Abstractdict2 <: dict end
abstract type Abstractdict3 <: dict end
abstract type Abstractdict_custom_repr <: dict end
abstract type AbstractQueryTestCase end
abstract type AbstractTemperature <: int end
abstract type AbstractAdvancedNamespace end
abstract type AbstractDottedPrettyPrinter <: pprint.PrettyPrinter end
mutable struct list2 <: Abstractlist2

end

mutable struct list3 <: Abstractlist3

end
function __repr__(self)
return __repr__(list)
end

mutable struct list_custom_repr <: Abstractlist_custom_repr

end
function __repr__(self)::String
return repeat("*",length(__repr__(list)))
end

mutable struct tuple2 <: Abstracttuple2

end

mutable struct tuple3 <: Abstracttuple3

end
function __repr__(self)
return __repr__(tuple)
end

mutable struct tuple_custom_repr <: Abstracttuple_custom_repr

end
function __repr__(self)::String
return repeat("*",length(__repr__(tuple)))
end

mutable struct set2 <: Abstractset2

end

mutable struct set3 <: Abstractset3

end
function __repr__(self)
return __repr__(set)
end

mutable struct set_custom_repr <: Abstractset_custom_repr

end
function __repr__(self)::String
return repeat("*",length(__repr__(set)))
end

mutable struct frozenset2 <: Abstractfrozenset2

end

mutable struct frozenset3 <: Abstractfrozenset3

end
function __repr__(self)
return __repr__(frozenset)
end

mutable struct frozenset_custom_repr <: Abstractfrozenset_custom_repr

end
function __repr__(self)::String
return repeat("*",length(__repr__(frozenset)))
end

mutable struct dict2 <: Abstractdict2

end

mutable struct dict3 <: Abstractdict3

end
function __repr__(self)
return __repr__(dict)
end

mutable struct dict_custom_repr <: Abstractdict_custom_repr

end
function __repr__(self)::String
return repeat("*",length(__repr__(dict)))
end

mutable struct dataclass1 <: Abstractdataclass1
field1::String
field2::Int64
field3::Bool
field4::Int64

                    dataclass1(field1::String, field2::Int64, field3::Bool = false, field4::Int64 = field(default = 1, repr = false)) =
                        new(field1, field2, field3, field4)
end

mutable struct dataclass2 <: Abstractdataclass2
a::Int64

                    dataclass2(a::Int64 = 1) =
                        new(a)
end
function __repr__(self)::String
return "custom repr that doesn\'t fit within pprint width"
end

mutable struct dataclass3 <: Abstractdataclass3
a::Int64

                    dataclass3(a::Int64 = 1) =
                        new(a)
end

mutable struct dataclass4 <: Abstractdataclass4
a::Abstractdataclass4
b::Int64

                    dataclass4(a::Abstractdataclass4, b::Int64 = 1) =
                        new(a, b)
end

mutable struct dataclass5 <: Abstractdataclass5
a::Abstractdataclass6
b::Int64

                    dataclass5(a::Abstractdataclass6, b::Int64 = 1) =
                        new(a, b)
end

mutable struct dataclass6 <: Abstractdataclass6
c::Abstractdataclass5
d::Int64

                    dataclass6(c::Abstractdataclass5, d::Int64 = 1) =
                        new(c, d)
end

mutable struct Unorderable <: AbstractUnorderable

end
function __repr__(self)::String
return string(id(self))
end

mutable struct Orderable <: AbstractOrderable
_hash
end
function __lt__(self, other)::Bool
return false
end

function __gt__(self, other)::Bool
return self != other
end

function __le__(self, other)::Bool
return self == other
end

function __ge__(self, other)::Bool
return true
end

function __eq__(self, other)::Bool
return self === other
end

function __ne__(self, other)::Bool
return self !== other
end

function __hash__(self)
return self._hash
end

mutable struct QueryTestCase <: AbstractQueryTestCase
a
b
d
assertTrue
end
function setUp(self)
self.a = collect(0:99)
self.b = collect(0:199)
self.a[end - -10] = self.b
end

function test_init(self)
pp = PrettyPrinter()
pp = PrettyPrinter(indent = 4, width = 40, depth = 5, stream = StringIO(), compact = true)
pp = PrettyPrinter(4, 40, 5, StringIO())
pp = PrettyPrinter(sort_dicts = false)
assertRaises(self, TypeError) do 
pp = PrettyPrinter(4, 40, 5, StringIO(), true)
end
@test_throws ValueError pprint.PrettyPrinter(indent = -1)
@test_throws ValueError pprint.PrettyPrinter(depth = 0)
@test_throws ValueError pprint.PrettyPrinter(depth = -1)
@test_throws ValueError pprint.PrettyPrinter(width = 0)
end

function test_basic(self)
pp = PrettyPrinter()
for safe in (2, 2.0, 2im, "abc", [3], (2, 2), Dict(3 => 3), b"def", Vector{UInt8}(b"ghi"), true, false, nothing, ..., self.a, self.b)
@test !(isrecursive(safe))
@test isreadable(safe)
@test !(isrecursive(pp, safe))
@test isreadable(pp, safe)
end
end

function test_knotted(self)
self.b[68] = self.a
self.d = Dict()
self.d[1] = self.d
self.d[2] = self.d
self.d[3] = self.d
pp = PrettyPrinter()
for icky in (self.a, self.b, self.d, (self.d, self.d))
@test isrecursive(icky)
@test !(isreadable(icky))
@test isrecursive(pp, icky)
@test !(isreadable(pp, icky))
end
clear(self.d)
#Delete Unsupported
del(self.a)
#Delete Unsupported
del(self.b)
for safe in (self.a, self.b, self.d, (self.d, self.d))
@test !(isrecursive(safe))
@test isreadable(safe)
@test !(isrecursive(pp, safe))
@test isreadable(pp, safe)
end
end

function test_unreadable(self)
pp = PrettyPrinter()
for unreadable in (type_(3), pprint, pprint.isrecursive)
@test !(isrecursive(unreadable))
@test !(isreadable(unreadable))
@test !(isrecursive(pp, unreadable))
@test !(isreadable(pp, unreadable))
end
end

function test_same_as_repr(self)
for simple in (0, 0, 0 + 0im, 0.0, "", b"", Vector{UInt8}(), (), tuple2(), tuple3(), [], list2(), list3(), set(), set2(), set3(), frozenset(), frozenset2(), frozenset3(), Dict(), dict2(), dict3(), self.assertTrue, pprint, -6, -6, -6 - 6im, -1.5, "x", b"x", Vector{UInt8}(b"x"), (3,), [3], Dict(3 => 6), (1, 2), [3, 4], Dict(5 => 6), tuple2((1, 2)), tuple3((1, 2)), tuple3(0:99), [3, 4], list2([3, 4]), list3([3, 4]), list3(0:99), set(Set([7])), set2(Set([7])), set3(Set([7])), frozenset(Set([8])), frozenset2(Set([8])), frozenset3(Set([8])), dict2(Dict(5 => 6)), dict3(Dict(5 => 6)), -10:-1:10, true, false, nothing, ...)
native = repr(simple)
@test (pformat(simple) == native)
@test (replace(pformat(simple, width = 1, indent = 0), "\n", " ") == native)
@test (pformat(simple, underscore_numbers = true) == native)
@test (saferepr(simple) == native)
end
end

function test_container_repr_override_called(self)
N = 1000
for cont in (list_custom_repr(), list_custom_repr([1, 2, 3]), list_custom_repr(0:N - 1), tuple_custom_repr(), tuple_custom_repr([1, 2, 3]), tuple_custom_repr(0:N - 1), set_custom_repr(), set_custom_repr([1, 2, 3]), set_custom_repr(0:N - 1), frozenset_custom_repr(), frozenset_custom_repr([1, 2, 3]), frozenset_custom_repr(0:N - 1), dict_custom_repr(), dict_custom_repr(Dict(5 => 6)), dict_custom_repr(zip(0:N - 1, 0:N - 1)))
native = repr(cont)
expected = repeat("*",length(native))
@test (pformat(cont) == expected)
@test (pformat(cont, width = 1, indent = 0) == expected)
@test (saferepr(cont) == expected)
end
end

function test_basic_line_wrap(self)
o = Dict("RPM_cal" => 0, "RPM_cal2" => 48059, "Speed_cal" => 0, "controldesk_runtime_us" => 0, "main_code_runtime_us" => 0, "read_io_runtime_us" => 0, "write_io_runtime_us" => 43690)
exp = "{\'RPM_cal\': 0,\n \'RPM_cal2\': 48059,\n \'Speed_cal\': 0,\n \'controldesk_runtime_us\': 0,\n \'main_code_runtime_us\': 0,\n \'read_io_runtime_us\': 0,\n \'write_io_runtime_us\': 43690}"
for type_ in [dict, dict2]
@test (pformat(type_(o)) == exp)
end
o = 0:99
exp = "[%s]" % join(map(str, o), ",\n ")
for type_ in [list, list2]
@test (pformat(type_(o)) == exp)
end
o = tuple(0:99)
exp = "(%s)" % join(map(str, o), ",\n ")
for type_ in [tuple, tuple2]
@test (pformat(type_(o)) == exp)
end
o = 0:99
exp = "[   %s]" % join(map(str, o), ",\n    ")
for type_ in [list, list2]
@test (pformat(type_(o), indent = 4) == exp)
end
end

function test_nested_indentations(self)
o1 = collect(0:9)
o2 = dict(first = 1, second = 2, third = 3)
o = [o1, o2]
expected = "[   [0, 1, 2, 3, 4, 5, 6, 7, 8, 9],\n    {\'first\': 1, \'second\': 2, \'third\': 3}]"
@test (pformat(o, indent = 4, width = 42) == expected)
expected = "[   [0, 1, 2, 3, 4, 5, 6, 7, 8, 9],\n    {   \'first\': 1,\n        \'second\': 2,\n        \'third\': 3}]"
@test (pformat(o, indent = 4, width = 41) == expected)
end

function test_width(self)
expected = "[[[[[[1, 2, 3],\n     \'1 2\']]]],\n {1: [1, 2, 3],\n  2: [12, 34]},\n \'abc def ghi\',\n (\'ab cd ef\',),\n set2({1, 23}),\n [[[[[1, 2, 3],\n     \'1 2\']]]]]"
o = eval(expected)
@test (pformat(o, width = 15) == expected)
@test (pformat(o, width = 16) == expected)
@test (pformat(o, width = 25) == expected)
@test (pformat(o, width = 14) == "[[[[[[1,\n      2,\n      3],\n     \'1 \'\n     \'2\']]]],\n {1: [1,\n      2,\n      3],\n  2: [12,\n      34]},\n \'abc def \'\n \'ghi\',\n (\'ab cd \'\n  \'ef\',),\n set2({1,\n       23}),\n [[[[[1,\n      2,\n      3],\n     \'1 \'\n     \'2\']]]]]")
end

function test_integer(self)
assertEqual(self, pformat(1234567), "1234567")
assertEqual(self, pformat(1234567, underscore_numbers = true), "1_234_567")
mutable struct Temperature <: AbstractTemperature

end
function __new__(cls, celsius_degrees)
return __new__(super(), Temperature)
end

function __repr__(self)
kelvin_degrees = self + 273.15
return "$(kelvin_degrees)°K"
end

assertEqual(self, pformat(Temperature(1000)), "1273.15°K")
end

function test_sorted_dict(self)
d = Dict("a" => 1, "b" => 1, "c" => 1)
@test (pformat(d) == "{\'a\': 1, \'b\': 1, \'c\': 1}")
@test (pformat([d, d]) == "[{\'a\': 1, \'b\': 1, \'c\': 1}, {\'a\': 1, \'b\': 1, \'c\': 1}]")
@test (pformat(Dict("xy\tab\n" => (3,), 5 => [[]], () => Dict())) == "{5: [[]], \'xy\\tab\\n\': (3,), (): {}}")
end

function test_sort_dict(self)
d = fromkeys(dict, "cba")
@test (pformat(d, sort_dicts = false) == "{\'c\': None, \'b\': None, \'a\': None}")
@test (pformat([d, d], sort_dicts = false) == "[{\'c\': None, \'b\': None, \'a\': None}, {\'c\': None, \'b\': None, \'a\': None}]")
end

function test_ordered_dict(self)
d = OrderedDict()
@test (pformat(d, width = 1) == "OrderedDict()")
d = OrderedDict([])
@test (pformat(d, width = 1) == "OrderedDict()")
words = split("the quick brown fox jumped over a lazy dog")
d = OrderedDict(zip(words, count()))
@test (pformat(d) == "OrderedDict([(\'the\', 0),\n             (\'quick\', 1),\n             (\'brown\', 2),\n             (\'fox\', 3),\n             (\'jumped\', 4),\n             (\'over\', 5),\n             (\'a\', 6),\n             (\'lazy\', 7),\n             (\'dog\', 8)])")
end

function test_mapping_proxy(self)
words = split("the quick brown fox jumped over a lazy dog")
d = dict(zip(words, count()))
m = MappingProxyType(d)
@test (pformat(m) == "mappingproxy({\'a\': 6,\n              \'brown\': 2,\n              \'dog\': 8,\n              \'fox\': 3,\n              \'jumped\': 4,\n              \'lazy\': 7,\n              \'over\': 5,\n              \'quick\': 1,\n              \'the\': 0})")
d = OrderedDict(zip(words, count()))
m = MappingProxyType(d)
@test (pformat(m) == "mappingproxy(OrderedDict([(\'the\', 0),\n                          (\'quick\', 1),\n                          (\'brown\', 2),\n                          (\'fox\', 3),\n                          (\'jumped\', 4),\n                          (\'over\', 5),\n                          (\'a\', 6),\n                          (\'lazy\', 7),\n                          (\'dog\', 8)]))")
end

function test_empty_simple_namespace(self)
ns = SimpleNamespace()
formatted = pformat(ns)
@test (formatted == "namespace()")
end

function test_small_simple_namespace(self)
ns = SimpleNamespace(a = 1, b = 2)
formatted = pformat(ns)
@test (formatted == "namespace(a=1, b=2)")
end

function test_simple_namespace(self)
ns = SimpleNamespace(the = 0, quick = 1, brown = 2, fox = 3, jumped = 4, over = 5, a = 6, lazy = 7, dog = 8)
formatted = pformat(ns, width = 60, indent = 4)
@test (formatted == "namespace(the=0,\n          quick=1,\n          brown=2,\n          fox=3,\n          jumped=4,\n          over=5,\n          a=6,\n          lazy=7,\n          dog=8)")
end

function test_simple_namespace_subclass(self)
mutable struct AdvancedNamespace <: AbstractAdvancedNamespace

end

ns = AdvancedNamespace(0, 1, 2, 3, 4, 5, 6, 7, 8)
formatted = pformat(ns, width = 60)
assertEqual(self, formatted, "AdvancedNamespace(the=0,\n                  quick=1,\n                  brown=2,\n                  fox=3,\n                  jumped=4,\n                  over=5,\n                  a=6,\n                  lazy=7,\n                  dog=8)")
end

function test_empty_dataclass(self)
dc = make_dataclass("MyDataclass", ())()
formatted = pformat(dc)
@test (formatted == "MyDataclass()")
end

function test_small_dataclass(self)
dc = dataclass1("text", 123)
formatted = pformat(dc)
@test (formatted == "dataclass1(field1=\'text\', field2=123, field3=False)")
end

function test_larger_dataclass(self)
dc = dataclass1("some fairly long text", Int(floor(10000000000.0)), true)
formatted = pformat([dc, dc], width = 60, indent = 4)
@test (formatted == "[   dataclass1(field1=\'some fairly long text\',\n               field2=10000000000,\n               field3=True),\n    dataclass1(field1=\'some fairly long text\',\n               field2=10000000000,\n               field3=True)]")
end

function test_dataclass_with_repr(self)
dc = dataclass2()
formatted = pformat(dc, width = 20)
@test (formatted == "custom repr that doesn\'t fit within pprint width")
end

function test_dataclass_no_repr(self)
dc = dataclass3()
formatted = pformat(dc, width = 10)
assertRegex(self, formatted, "<test.test_pprint.dataclass3 object at \\w+>")
end

function test_recursive_dataclass(self)
dc = dataclass4(nothing)
dc.a = dc
formatted = pformat(dc, width = 10)
@test (formatted == "dataclass4(a=...,\n           b=1)")
end

function test_cyclic_dataclass(self)
dc5 = dataclass5(nothing)
dc6 = dataclass6(nothing)
dc5.a = dc6
dc6.c = dc5
formatted = pformat(dc5, width = 10)
@test (formatted == "dataclass5(a=dataclass6(c=...,\n                        d=1),\n           b=1)")
end

function test_subclassing(self)
o = Dict("names with spaces" => "should be presented using repr()", "others.should.not.be" => "like.this")
exp = "{\'names with spaces\': \'should be presented using repr()\',\n others.should.not.be: like.this}"
dotted_printer = DottedPrettyPrinter()
@test (pformat(dotted_printer, o) == exp)
o1 = ["with space"]
exp1 = "[\'with space\']"
@test (pformat(dotted_printer, o1) == exp1)
o2 = ["without.space"]
exp2 = "[without.space]"
@test (pformat(dotted_printer, o2) == exp2)
end

function test_set_reprs(self)
@test (pformat(set()) == "set()")
@test (pformat(set(0:2)) == "{0, 1, 2}")
@test (pformat(set(0:6), width = 20) == "{0,\n 1,\n 2,\n 3,\n 4,\n 5,\n 6}")
@test (pformat(set2(0:6), width = 20) == "set2({0,\n      1,\n      2,\n      3,\n      4,\n      5,\n      6})")
@test (pformat(set3(0:6), width = 20) == "set3({0, 1, 2, 3, 4, 5, 6})")
@test (pformat(frozenset()) == "frozenset()")
@test (pformat(frozenset(0:2)) == "frozenset({0, 1, 2})")
@test (pformat(frozenset(0:6), width = 20) == "frozenset({0,\n           1,\n           2,\n           3,\n           4,\n           5,\n           6})")
@test (pformat(frozenset2(0:6), width = 20) == "frozenset2({0,\n            1,\n            2,\n            3,\n            4,\n            5,\n            6})")
@test (pformat(frozenset3(0:6), width = 20) == "frozenset3({0, 1, 2, 3, 4, 5, 6})")
end

function test_set_of_sets_reprs(self)
cube_repr_tgt = "{frozenset(): frozenset({frozenset({2}), frozenset({0}), frozenset({1})}),\n frozenset({0}): frozenset({frozenset(),\n                            frozenset({0, 2}),\n                            frozenset({0, 1})}),\n frozenset({1}): frozenset({frozenset(),\n                            frozenset({1, 2}),\n                            frozenset({0, 1})}),\n frozenset({2}): frozenset({frozenset(),\n                            frozenset({1, 2}),\n                            frozenset({0, 2})}),\n frozenset({1, 2}): frozenset({frozenset({2}),\n                               frozenset({1}),\n                               frozenset({0, 1, 2})}),\n frozenset({0, 2}): frozenset({frozenset({2}),\n                               frozenset({0}),\n                               frozenset({0, 1, 2})}),\n frozenset({0, 1}): frozenset({frozenset({0}),\n                               frozenset({1}),\n                               frozenset({0, 1, 2})}),\n frozenset({0, 1, 2}): frozenset({frozenset({1, 2}),\n                                  frozenset({0, 2}),\n                                  frozenset({0, 1})})}"
cube = cube(3)
@test (pformat(cube) == cube_repr_tgt)
cubo_repr_tgt = "{frozenset({frozenset({0, 2}), frozenset({0})}): frozenset({frozenset({frozenset({0,\n                                                                                  2}),\n                                                                       frozenset({0,\n                                                                                  1,\n                                                                                  2})}),\n                                                            frozenset({frozenset({0}),\n                                                                       frozenset({0,\n                                                                                  1})}),\n                                                            frozenset({frozenset(),\n                                                                       frozenset({0})}),\n                                                            frozenset({frozenset({2}),\n                                                                       frozenset({0,\n                                                                                  2})})}),\n frozenset({frozenset({0, 1}), frozenset({1})}): frozenset({frozenset({frozenset({0,\n                                                                                  1}),\n                                                                       frozenset({0,\n                                                                                  1,\n                                                                                  2})}),\n                                                            frozenset({frozenset({0}),\n                                                                       frozenset({0,\n                                                                                  1})}),\n                                                            frozenset({frozenset({1}),\n                                                                       frozenset({1,\n                                                                                  2})}),\n                                                            frozenset({frozenset(),\n                                                                       frozenset({1})})}),\n frozenset({frozenset({1, 2}), frozenset({1})}): frozenset({frozenset({frozenset({1,\n                                                                                  2}),\n                                                                       frozenset({0,\n                                                                                  1,\n                                                                                  2})}),\n                                                            frozenset({frozenset({2}),\n                                                                       frozenset({1,\n                                                                                  2})}),\n                                                            frozenset({frozenset(),\n                                                                       frozenset({1})}),\n                                                            frozenset({frozenset({1}),\n                                                                       frozenset({0,\n                                                                                  1})})}),\n frozenset({frozenset({1, 2}), frozenset({2})}): frozenset({frozenset({frozenset({1,\n                                                                                  2}),\n                                                                       frozenset({0,\n                                                                                  1,\n                                                                                  2})}),\n                                                            frozenset({frozenset({1}),\n                                                                       frozenset({1,\n                                                                                  2})}),\n                                                            frozenset({frozenset({2}),\n                                                                       frozenset({0,\n                                                                                  2})}),\n                                                            frozenset({frozenset(),\n                                                                       frozenset({2})})}),\n frozenset({frozenset(), frozenset({0})}): frozenset({frozenset({frozenset({0}),\n                                                                 frozenset({0,\n                                                                            1})}),\n                                                      frozenset({frozenset({0}),\n                                                                 frozenset({0,\n                                                                            2})}),\n                                                      frozenset({frozenset(),\n                                                                 frozenset({1})}),\n                                                      frozenset({frozenset(),\n                                                                 frozenset({2})})}),\n frozenset({frozenset(), frozenset({1})}): frozenset({frozenset({frozenset(),\n                                                                 frozenset({0})}),\n                                                      frozenset({frozenset({1}),\n                                                                 frozenset({1,\n                                                                            2})}),\n                                                      frozenset({frozenset(),\n                                                                 frozenset({2})}),\n                                                      frozenset({frozenset({1}),\n                                                                 frozenset({0,\n                                                                            1})})}),\n frozenset({frozenset({2}), frozenset()}): frozenset({frozenset({frozenset({2}),\n                                                                 frozenset({1,\n                                                                            2})}),\n                                                      frozenset({frozenset(),\n                                                                 frozenset({0})}),\n                                                      frozenset({frozenset(),\n                                                                 frozenset({1})}),\n                                                      frozenset({frozenset({2}),\n                                                                 frozenset({0,\n                                                                            2})})}),\n frozenset({frozenset({0, 1, 2}), frozenset({0, 1})}): frozenset({frozenset({frozenset({1,\n                                                                                        2}),\n                                                                             frozenset({0,\n                                                                                        1,\n                                                                                        2})}),\n                                                                  frozenset({frozenset({0,\n                                                                                        2}),\n                                                                             frozenset({0,\n                                                                                        1,\n                                                                                        2})}),\n                                                                  frozenset({frozenset({0}),\n                                                                             frozenset({0,\n                                                                                        1})}),\n                                                                  frozenset({frozenset({1}),\n                                                                             frozenset({0,\n                                                                                        1})})}),\n frozenset({frozenset({0}), frozenset({0, 1})}): frozenset({frozenset({frozenset(),\n                                                                       frozenset({0})}),\n                                                            frozenset({frozenset({0,\n                                                                                  1}),\n                                                                       frozenset({0,\n                                                                                  1,\n                                                                                  2})}),\n                                                            frozenset({frozenset({0}),\n                                                                       frozenset({0,\n                                                                                  2})}),\n                                                            frozenset({frozenset({1}),\n                                                                       frozenset({0,\n                                                                                  1})})}),\n frozenset({frozenset({2}), frozenset({0, 2})}): frozenset({frozenset({frozenset({0,\n                                                                                  2}),\n                                                                       frozenset({0,\n                                                                                  1,\n                                                                                  2})}),\n                                                            frozenset({frozenset({2}),\n                                                                       frozenset({1,\n                                                                                  2})}),\n                                                            frozenset({frozenset({0}),\n                                                                       frozenset({0,\n                                                                                  2})}),\n                                                            frozenset({frozenset(),\n                                                                       frozenset({2})})}),\n frozenset({frozenset({0, 1, 2}), frozenset({0, 2})}): frozenset({frozenset({frozenset({1,\n                                                                                        2}),\n                                                                             frozenset({0,\n                                                                                        1,\n                                                                                        2})}),\n                                                                  frozenset({frozenset({0,\n                                                                                        1}),\n                                                                             frozenset({0,\n                                                                                        1,\n                                                                                        2})}),\n                                                                  frozenset({frozenset({0}),\n                                                                             frozenset({0,\n                                                                                        2})}),\n                                                                  frozenset({frozenset({2}),\n                                                                             frozenset({0,\n                                                                                        2})})}),\n frozenset({frozenset({1, 2}), frozenset({0, 1, 2})}): frozenset({frozenset({frozenset({0,\n                                                                                        2}),\n                                                                             frozenset({0,\n                                                                                        1,\n                                                                                        2})}),\n                                                                  frozenset({frozenset({0,\n                                                                                        1}),\n                                                                             frozenset({0,\n                                                                                        1,\n                                                                                        2})}),\n                                                                  frozenset({frozenset({2}),\n                                                                             frozenset({1,\n                                                                                        2})}),\n                                                                  frozenset({frozenset({1}),\n                                                                             frozenset({1,\n                                                                                        2})})})}"
cubo = linegraph(cube)
@test (pformat(cubo) == cubo_repr_tgt)
end

function test_depth(self)
nested_tuple = (1, (2, (3, (4, (5, 6)))))
nested_dict = Dict(1 => Dict(2 => Dict(3 => Dict(4 => Dict(5 => Dict(6 => 6))))))
nested_list = [1, [2, [3, [4, [5, [6, []]]]]]]
@test (pformat(nested_tuple) == repr(nested_tuple))
@test (pformat(nested_dict) == repr(nested_dict))
@test (pformat(nested_list) == repr(nested_list))
lv1_tuple = "(1, (...))"
lv1_dict = "{1: {...}}"
lv1_list = "[1, [...]]"
@test (pformat(nested_tuple, depth = 1) == lv1_tuple)
@test (pformat(nested_dict, depth = 1) == lv1_dict)
@test (pformat(nested_list, depth = 1) == lv1_list)
end

function test_sort_unorderable_values(self)
n = 20
keys = [Unorderable() for i in 0:n - 1]
shuffle(keys)
skeys = sorted(keys, key = id)
clean = (s) -> replace(replace(s, " ", ""), "\n", "")
@test (clean(pformat(set(keys))) == ("{" + join(map(repr, skeys), ",")) * "}")
@test (clean(pformat(frozenset(keys))) == ("frozenset({" + join(map(repr, skeys), ",")) * "})")
@test (clean(pformat(fromkeys(dict, keys))) == ("{" + join(("%r:None" % k for k in skeys), ",")) * "}")
@test (pformat(Dict(Unorderable => 0, 1 => 0)) == ("{1: 0, " + repr(Unorderable)) * ": 0}")
keys = [(1,), (nothing,)]
@test (pformat(fromkeys(dict, keys, 0)) == "{%r: 0, %r: 0}" % tuple(sorted(keys, key = id)))
end

function test_sort_orderable_and_unorderable_values(self)
a = Unorderable()
b = Orderable(hash(a))
assertLess(self, a, b)
assertLess(self, string(type_(b)), string(type_(a)))
@test (sorted([b, a]) == [a, b])
@test (sorted([a, b]) == [a, b])
@test (pformat(set([b, a]), width = 1) == "{%r,\n %r}" % (a, b))
@test (pformat(set([a, b]), width = 1) == "{%r,\n %r}" % (a, b))
@test (pformat(fromkeys(dict, [b, a]), width = 1) == "{%r: None,\n %r: None}" % (a, b))
@test (pformat(fromkeys(dict, [a, b]), width = 1) == "{%r: None,\n %r: None}" % (a, b))
end

function test_str_wrap(self)
fox = "the quick brown fox jumped over a lazy dog"
@test (pformat(fox, width = 19) == "(\'the quick brown \'\n \'fox jumped over \'\n \'a lazy dog\')")
@test (pformat(Dict("a" => 1, "b" => fox, "c" => 2), width = 25) == "{\'a\': 1,\n \'b\': \'the quick brown \'\n      \'fox jumped over \'\n      \'a lazy dog\',\n \'c\': 2}")
special = "Portons dix bons \"whiskys\"\nà l\'avocat goujat\t qui fumait au zoo"
@test (pformat(special, width = 68) == repr(special))
@test (pformat(special, width = 31) == "(\'Portons dix bons \"whiskys\"\\n\'\n \"à l\'avocat goujat\\t qui \"\n \'fumait au zoo\')")
@test (pformat(special, width = 20) == "(\'Portons dix bons \'\n \'\"whiskys\"\\n\'\n \"à l\'avocat \"\n \'goujat\\t qui \'\n \'fumait au zoo\')")
@test (pformat([[[[[special]]]]], width = 35) == "[[[[[\'Portons dix bons \"whiskys\"\\n\'\n     \"à l\'avocat goujat\\t qui \"\n     \'fumait au zoo\']]]]]")
@test (pformat([[[[[special]]]]], width = 25) == "[[[[[\'Portons dix bons \'\n     \'\"whiskys\"\\n\'\n     \"à l\'avocat \"\n     \'goujat\\t qui \'\n     \'fumait au zoo\']]]]]")
@test (pformat([[[[[special]]]]], width = 23) == "[[[[[\'Portons dix \'\n     \'bons \"whiskys\"\\n\'\n     \"à l\'avocat \"\n     \'goujat\\t qui \'\n     \'fumait au \'\n     \'zoo\']]]]]")
unwrappable = repeat("x",100)
@test (pformat(unwrappable, width = 80) == repr(unwrappable))
@test (pformat("") == "\'\'")
special *= 10
for width in 3:39
formatted = pformat(special, width = width)
@test (eval(formatted) == special)
formatted = pformat(repeat([special],2), width = width)
@test (eval(formatted) == repeat([special],2))
end
end

function test_compact(self)
o = [collect(0:i*i - 1) for i in 0:4] + [collect(0:i - 1) for i in 0:5]
expected = "[[], [0], [0, 1, 2, 3],\n [0, 1, 2, 3, 4, 5, 6, 7, 8],\n [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13,\n  14, 15],\n [], [0], [0, 1], [0, 1, 2], [0, 1, 2, 3],\n [0, 1, 2, 3, 4]]"
@test (pformat(o, width = 47, compact = true) == expected)
end

function test_compact_width(self)
levels = 20
number = 10
o = repeat([0],number)
for i in 0:levels - 2
o = [o]
end
for w in levels*2:(levels + 3*number) - 2
lines = splitlines(pformat(o, width = w, compact = true))
maxwidth = max(map(len, lines))
assertLessEqual(self, maxwidth, w)
assertGreater(self, maxwidth, w - 3)
end
end

function test_bytes_wrap(self)
@test (pformat(b"", width = 1) == "b\'\'")
@test (pformat(b"abcd", width = 1) == "b\'abcd\'")
letters = b"abcdefghijklmnopqrstuvwxyz"
@test (pformat(letters, width = 29) == repr(letters))
@test (pformat(letters, width = 19) == "(b\'abcdefghijkl\'\n b\'mnopqrstuvwxyz\')")
@test (pformat(letters, width = 18) == "(b\'abcdefghijkl\'\n b\'mnopqrstuvwx\'\n b\'yz\')")
@test (pformat(letters, width = 16) == "(b\'abcdefghijkl\'\n b\'mnopqrstuvwx\'\n b\'yz\')")
special = bytes(0:15)
@test (pformat(special, width = 61) == repr(special))
@test (pformat(special, width = 48) == "(b\'\\x00\\x01\\x02\\x03\\x04\\x05\\x06\\x07\\x08\\t\\n\\x0b\'\n b\'\\x0c\\r\\x0e\\x0f\')")
@test (pformat(special, width = 32) == "(b\'\\x00\\x01\\x02\\x03\'\n b\'\\x04\\x05\\x06\\x07\\x08\\t\\n\\x0b\'\n b\'\\x0c\\r\\x0e\\x0f\')")
@test (pformat(special, width = 1) == "(b\'\\x00\\x01\\x02\\x03\'\n b\'\\x04\\x05\\x06\\x07\'\n b\'\\x08\\t\\n\\x0b\'\n b\'\\x0c\\r\\x0e\\x0f\')")
@test (pformat(Dict("a" => 1, "b" => letters, "c" => 2), width = 21) == "{\'a\': 1,\n \'b\': b\'abcdefghijkl\'\n      b\'mnopqrstuvwx\'\n      b\'yz\',\n \'c\': 2}")
@test (pformat(Dict("a" => 1, "b" => letters, "c" => 2), width = 20) == "{\'a\': 1,\n \'b\': b\'abcdefgh\'\n      b\'ijklmnop\'\n      b\'qrstuvwxyz\',\n \'c\': 2}")
@test (pformat([[[[[[letters]]]]]], width = 25) == "[[[[[[b\'abcdefghijklmnop\'\n      b\'qrstuvwxyz\']]]]]]")
@test (pformat([[[[[[special]]]]]], width = 41) == "[[[[[[b\'\\x00\\x01\\x02\\x03\\x04\\x05\\x06\\x07\'\n      b\'\\x08\\t\\n\\x0b\\x0c\\r\\x0e\\x0f\']]]]]]")
for width in 1:63
formatted = pformat(special, width = width)
@test (eval(formatted) == special)
formatted = pformat(repeat([special],2), width = width)
@test (eval(formatted) == repeat([special],2))
end
end

function test_bytearray_wrap(self)
@test (pformat(Vector{UInt8}(), width = 1) == "bytearray(b\'\')")
letters = Vector{UInt8}(b"abcdefghijklmnopqrstuvwxyz")
@test (pformat(letters, width = 40) == repr(letters))
@test (pformat(letters, width = 28) == "bytearray(b\'abcdefghijkl\'\n          b\'mnopqrstuvwxyz\')")
@test (pformat(letters, width = 27) == "bytearray(b\'abcdefghijkl\'\n          b\'mnopqrstuvwx\'\n          b\'yz\')")
@test (pformat(letters, width = 25) == "bytearray(b\'abcdefghijkl\'\n          b\'mnopqrstuvwx\'\n          b\'yz\')")
special = Vector{UInt8}(0:15)
@test (pformat(special, width = 72) == repr(special))
@test (pformat(special, width = 57) == "bytearray(b\'\\x00\\x01\\x02\\x03\\x04\\x05\\x06\\x07\\x08\\t\\n\\x0b\'\n          b\'\\x0c\\r\\x0e\\x0f\')")
@test (pformat(special, width = 41) == "bytearray(b\'\\x00\\x01\\x02\\x03\'\n          b\'\\x04\\x05\\x06\\x07\\x08\\t\\n\\x0b\'\n          b\'\\x0c\\r\\x0e\\x0f\')")
@test (pformat(special, width = 1) == "bytearray(b\'\\x00\\x01\\x02\\x03\'\n          b\'\\x04\\x05\\x06\\x07\'\n          b\'\\x08\\t\\n\\x0b\'\n          b\'\\x0c\\r\\x0e\\x0f\')")
@test (pformat(Dict("a" => 1, "b" => letters, "c" => 2), width = 31) == "{\'a\': 1,\n \'b\': bytearray(b\'abcdefghijkl\'\n                b\'mnopqrstuvwx\'\n                b\'yz\'),\n \'c\': 2}")
@test (pformat([[[[[letters]]]]], width = 37) == "[[[[[bytearray(b\'abcdefghijklmnop\'\n               b\'qrstuvwxyz\')]]]]]")
@test (pformat([[[[[special]]]]], width = 50) == "[[[[[bytearray(b\'\\x00\\x01\\x02\\x03\\x04\\x05\\x06\\x07\'\n               b\'\\x08\\t\\n\\x0b\\x0c\\r\\x0e\\x0f\')]]]]]")
end

function test_default_dict(self)
d = defaultdict(int)
@test (pformat(d, width = 1) == "defaultdict(<class \'int\'>, {})")
words = split("the quick brown fox jumped over a lazy dog")
d = defaultdict(int, zip(words, count()))
@test (pformat(d) == "defaultdict(<class \'int\'>,\n            {\'a\': 6,\n             \'brown\': 2,\n             \'dog\': 8,\n             \'fox\': 3,\n             \'jumped\': 4,\n             \'lazy\': 7,\n             \'over\': 5,\n             \'quick\': 1,\n             \'the\': 0})")
end

function test_counter(self)
d = Counter()
@test (pformat(d, width = 1) == "Counter()")
d = Counter("senselessness")
@test (pformat(d, width = 40) == "Counter({\'s\': 6,\n         \'e\': 4,\n         \'n\': 2,\n         \'l\': 1})")
end

function test_chainmap(self)
d = ChainMap()
@test (pformat(d, width = 1) == "ChainMap({})")
words = split("the quick brown fox jumped over a lazy dog")
items = collect(zip(words, count()))
d = ChainMap(dict(items))
@test (pformat(d) == "ChainMap({\'a\': 6,\n          \'brown\': 2,\n          \'dog\': 8,\n          \'fox\': 3,\n          \'jumped\': 4,\n          \'lazy\': 7,\n          \'over\': 5,\n          \'quick\': 1,\n          \'the\': 0})")
d = ChainMap(dict(items), OrderedDict(items))
@test (pformat(d) == "ChainMap({\'a\': 6,\n          \'brown\': 2,\n          \'dog\': 8,\n          \'fox\': 3,\n          \'jumped\': 4,\n          \'lazy\': 7,\n          \'over\': 5,\n          \'quick\': 1,\n          \'the\': 0},\n         OrderedDict([(\'the\', 0),\n                      (\'quick\', 1),\n                      (\'brown\', 2),\n                      (\'fox\', 3),\n                      (\'jumped\', 4),\n                      (\'over\', 5),\n                      (\'a\', 6),\n                      (\'lazy\', 7),\n                      (\'dog\', 8)]))")
end

function test_deque(self)
d = deque()
@test (pformat(d, width = 1) == "deque([])")
d = deque(maxlen = 7)
@test (pformat(d, width = 1) == "deque([], maxlen=7)")
words = split("the quick brown fox jumped over a lazy dog")
d = deque(zip(words, count()))
@test (pformat(d) == "deque([(\'the\', 0),\n       (\'quick\', 1),\n       (\'brown\', 2),\n       (\'fox\', 3),\n       (\'jumped\', 4),\n       (\'over\', 5),\n       (\'a\', 6),\n       (\'lazy\', 7),\n       (\'dog\', 8)])")
d = deque(zip(words, count()), maxlen = 7)
@test (pformat(d) == "deque([(\'brown\', 2),\n       (\'fox\', 3),\n       (\'jumped\', 4),\n       (\'over\', 5),\n       (\'a\', 6),\n       (\'lazy\', 7),\n       (\'dog\', 8)],\n      maxlen=7)")
end

function test_user_dict(self)
d = UserDict()
@test (pformat(d, width = 1) == "{}")
words = split("the quick brown fox jumped over a lazy dog")
d = UserDict(zip(words, count()))
@test (pformat(d) == "{\'a\': 6,\n \'brown\': 2,\n \'dog\': 8,\n \'fox\': 3,\n \'jumped\': 4,\n \'lazy\': 7,\n \'over\': 5,\n \'quick\': 1,\n \'the\': 0}")
end

function test_user_list(self)
d = UserList()
@test (pformat(d, width = 1) == "[]")
words = split("the quick brown fox jumped over a lazy dog")
d = UserList(zip(words, count()))
@test (pformat(d) == "[(\'the\', 0),\n (\'quick\', 1),\n (\'brown\', 2),\n (\'fox\', 3),\n (\'jumped\', 4),\n (\'over\', 5),\n (\'a\', 6),\n (\'lazy\', 7),\n (\'dog\', 8)]")
end

function test_user_string(self)
d = UserString("")
@test (pformat(d, width = 1) == "\'\'")
d = UserString("the quick brown fox jumped over a lazy dog")
@test (pformat(d, width = 20) == "(\'the quick brown \'\n \'fox jumped over \'\n \'a lazy dog\')")
@test (pformat(Dict(1 => d), width = 20) == "{1: \'the quick \'\n    \'brown fox \'\n    \'jumped over a \'\n    \'lazy dog\'}")
end

mutable struct DottedPrettyPrinter <: AbstractDottedPrettyPrinter

end
function format(self, object, context, maxlevels, level)
if isa(object, str)
if " " ∈ object
return (repr(object), 1, 0)
else
return (object, 0, 0)
end
else
return pprint.PrettyPrinter
end
end

if abspath(PROGRAM_FILE) == @__FILE__
query_test_case = QueryTestCase()
setUp(query_test_case)
test_init(query_test_case)
test_basic(query_test_case)
test_knotted(query_test_case)
test_unreadable(query_test_case)
test_same_as_repr(query_test_case)
test_container_repr_override_called(query_test_case)
test_basic_line_wrap(query_test_case)
test_nested_indentations(query_test_case)
test_width(query_test_case)
test_integer(query_test_case)
test_sorted_dict(query_test_case)
test_sort_dict(query_test_case)
test_ordered_dict(query_test_case)
test_mapping_proxy(query_test_case)
test_empty_simple_namespace(query_test_case)
test_small_simple_namespace(query_test_case)
test_simple_namespace(query_test_case)
test_simple_namespace_subclass(query_test_case)
test_empty_dataclass(query_test_case)
test_small_dataclass(query_test_case)
test_larger_dataclass(query_test_case)
test_dataclass_with_repr(query_test_case)
test_dataclass_no_repr(query_test_case)
test_recursive_dataclass(query_test_case)
test_cyclic_dataclass(query_test_case)
test_subclassing(query_test_case)
test_set_reprs(query_test_case)
test_set_of_sets_reprs(query_test_case)
test_depth(query_test_case)
test_sort_unorderable_values(query_test_case)
test_sort_orderable_and_unorderable_values(query_test_case)
test_str_wrap(query_test_case)
test_compact(query_test_case)
test_compact_width(query_test_case)
test_bytes_wrap(query_test_case)
test_bytearray_wrap(query_test_case)
test_default_dict(query_test_case)
test_counter(query_test_case)
test_chainmap(query_test_case)
test_deque(query_test_case)
test_user_dict(query_test_case)
test_user_list(query_test_case)
test_user_string(query_test_case)
end