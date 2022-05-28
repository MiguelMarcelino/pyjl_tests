




abstract type AbstractSeq2 <: object end
abstract type AbstractC <: object end
abstract type AbstractT <: tuple end
abstract type AbstractX <: object end
abstract type AbstractPyOperatorTestCase <: AbstractOperatorTestCase end
abstract type AbstractCOperatorTestCase <: AbstractOperatorTestCase end
abstract type AbstractPyPyOperatorPickleTestCase <: AbstractOperatorPickleTestCase end
abstract type AbstractPyCOperatorPickleTestCase <: AbstractOperatorPickleTestCase end
abstract type AbstractCPyOperatorPickleTestCase <: AbstractOperatorPickleTestCase end
abstract type AbstractCCOperatorPickleTestCase <: AbstractOperatorPickleTestCase end
py_operator = import_fresh_module("operator", blocked = ["_operator"])
c_operator = import_fresh_module("operator", fresh = ["_operator"])
mutable struct Seq1 <: AbstractSeq1
lst
end
function __len__(self)::Int64
return length(self.lst)
end

function __getitem__(self, i)
return self.lst[i + 1]
end

function __add__(self, other)::Any
return self.lst + other.lst
end

function __mul__(self, other)::Any
return self.lst*other
end

function __rmul__(self, other)::Any
return other*self.lst
end

mutable struct Seq2 <: AbstractSeq2
lst
end
function __len__(self)::Int64
return length(self.lst)
end

function __getitem__(self, i)
return self.lst[i + 1]
end

function __add__(self, other)::Any
return self.lst + other.lst
end

function __mul__(self, other)::Any
return self.lst*other
end

function __rmul__(self, other)::Any
return other*self.lst
end

mutable struct BadIterable <: AbstractBadIterable

end
function __iter__(self)
throw(ZeroDivisionError)
end

mutable struct OperatorTestCase <: AbstractOperatorTestCase
value
end
function test_lt(self)
operator = self.module
assertRaises(self, TypeError, operator.lt)
assertRaises(self, TypeError, operator.lt, 1im, 2im)
assertFalse(self, lt(operator, 1, 0))
assertFalse(self, lt(operator, 1, 0.0))
assertFalse(self, lt(operator, 1, 1))
assertFalse(self, lt(operator, 1, 1.0))
assertTrue(self, lt(operator, 1, 2))
assertTrue(self, lt(operator, 1, 2.0))
end

function test_le(self)
operator = self.module
assertRaises(self, TypeError, operator.le)
assertRaises(self, TypeError, operator.le, 1im, 2im)
assertFalse(self, le(operator, 1, 0))
assertFalse(self, le(operator, 1, 0.0))
assertTrue(self, le(operator, 1, 1))
assertTrue(self, le(operator, 1, 1.0))
assertTrue(self, le(operator, 1, 2))
assertTrue(self, le(operator, 1, 2.0))
end

function test_eq(self)
operator = self.module
mutable struct C <: AbstractC

end
function __eq__(self, other)
throw(SyntaxError)
end

assertRaises(self, TypeError, operator.eq)
assertRaises(self, SyntaxError, operator.eq, C(), C())
assertFalse(self, eq(operator, 1, 0))
assertFalse(self, eq(operator, 1, 0.0))
assertTrue(self, eq(operator, 1, 1))
assertTrue(self, eq(operator, 1, 1.0))
assertFalse(self, eq(operator, 1, 2))
assertFalse(self, eq(operator, 1, 2.0))
end

function test_ne(self)
operator = self.module
mutable struct C <: AbstractC

end
function __ne__(self, other)
throw(SyntaxError)
end

assertRaises(self, TypeError, operator.ne)
assertRaises(self, SyntaxError, operator.ne, C(), C())
assertTrue(self, ne(operator, 1, 0))
assertTrue(self, ne(operator, 1, 0.0))
assertFalse(self, ne(operator, 1, 1))
assertFalse(self, ne(operator, 1, 1.0))
assertTrue(self, ne(operator, 1, 2))
assertTrue(self, ne(operator, 1, 2.0))
end

function test_ge(self)
operator = self.module
assertRaises(self, TypeError, operator.ge)
assertRaises(self, TypeError, operator.ge, 1im, 2im)
assertTrue(self, ge(operator, 1, 0))
assertTrue(self, ge(operator, 1, 0.0))
assertTrue(self, ge(operator, 1, 1))
assertTrue(self, ge(operator, 1, 1.0))
assertFalse(self, ge(operator, 1, 2))
assertFalse(self, ge(operator, 1, 2.0))
end

function test_gt(self)
operator = self.module
assertRaises(self, TypeError, operator.gt)
assertRaises(self, TypeError, operator.gt, 1im, 2im)
assertTrue(self, gt(operator, 1, 0))
assertTrue(self, gt(operator, 1, 0.0))
assertFalse(self, gt(operator, 1, 1))
assertFalse(self, gt(operator, 1, 1.0))
assertFalse(self, gt(operator, 1, 2))
assertFalse(self, gt(operator, 1, 2.0))
end

function test_abs(self)
operator = self.module
assertRaises(self, TypeError, operator.abs)
assertRaises(self, TypeError, operator.abs, nothing)
assertEqual(self, abs(operator, -1), 1)
assertEqual(self, abs(operator, 1), 1)
end

function test_add(self)
operator = self.module
assertRaises(self, TypeError, operator.add)
assertRaises(self, TypeError, operator.add, nothing, nothing)
assertEqual(self, add(operator, 3, 4), 7)
end

function test_bitwise_and(self)
operator = self.module
assertRaises(self, TypeError, operator.and_)
assertRaises(self, TypeError, operator.and_, nothing, nothing)
assertEqual(self, and_(operator, 15, 10), 10)
end

function test_concat(self)
operator = self.module
assertRaises(self, TypeError, operator.concat)
assertRaises(self, TypeError, operator.concat, nothing, nothing)
assertEqual(self, concat(operator, "py", "thon"), "python")
assertEqual(self, concat(operator, [1, 2], [3, 4]), [1, 2, 3, 4])
assertEqual(self, concat(operator, Seq1([5, 6]), Seq1([7])), [5, 6, 7])
assertEqual(self, concat(operator, Seq2([5, 6]), Seq2([7])), [5, 6, 7])
assertRaises(self, TypeError, operator.concat, 13, 29)
end

function test_countOf(self)
operator = self.module
assertRaises(self, TypeError, operator.countOf)
assertRaises(self, TypeError, operator.countOf, nothing, nothing)
assertRaises(self, ZeroDivisionError, operator.countOf, BadIterable(), 1)
assertEqual(self, countOf(operator, [1, 2, 1, 3, 1, 4], 3), 1)
assertEqual(self, countOf(operator, [1, 2, 1, 3, 1, 4], 5), 0)
nan = float("nan")
assertEqual(self, countOf(operator, [nan, nan, 21], nan), 2)
assertEqual(self, countOf(operator, [Dict(), 1, Dict(), 2], Dict()), 2)
end

function test_delitem(self)
operator = self.module
a = [4, 3, 2, 1]
assertRaises(self, TypeError, operator.delitem, a)
assertRaises(self, TypeError, operator.delitem, a, nothing)
assertIsNone(self, delitem(operator, a, 1))
assertEqual(self, a, [4, 2, 1])
end

function test_floordiv(self)
operator = self.module
assertRaises(self, TypeError, operator.floordiv, 5)
assertRaises(self, TypeError, operator.floordiv, nothing, nothing)
assertEqual(self, floordiv(operator, 5, 2), 2)
end

function test_truediv(self)
operator = self.module
assertRaises(self, TypeError, operator.truediv, 5)
assertRaises(self, TypeError, operator.truediv, nothing, nothing)
assertEqual(self, truediv(operator, 5, 2), 2.5)
end

function test_getitem(self)
operator = self.module
a = 0:9
assertRaises(self, TypeError, operator.getitem)
assertRaises(self, TypeError, operator.getitem, a, nothing)
assertEqual(self, getitem(operator, a, 2), 2)
end

function test_indexOf(self)
operator = self.module
assertRaises(self, TypeError, operator.indexOf)
assertRaises(self, TypeError, operator.indexOf, nothing, nothing)
assertRaises(self, ZeroDivisionError, operator.indexOf, BadIterable(), 1)
assertEqual(self, indexOf(operator, [4, 3, 2, 1], 3), 1)
assertRaises(self, ValueError, operator.indexOf, [4, 3, 2, 1], 0)
nan = float("nan")
assertEqual(self, indexOf(operator, [nan, nan, 21], nan), 0)
assertEqual(self, indexOf(operator, [Dict(), 1, Dict(), 2], Dict()), 0)
end

function test_invert(self)
operator = self.module
assertRaises(self, TypeError, operator.invert)
assertRaises(self, TypeError, operator.invert, nothing)
assertEqual(self, inv(operator, 4), -5)
end

function test_lshift(self)
operator = self.module
assertRaises(self, TypeError, operator.lshift)
assertRaises(self, TypeError, operator.lshift, nothing, 42)
assertEqual(self, lshift(operator, 5, 1), 10)
assertEqual(self, lshift(operator, 5, 0), 5)
assertRaises(self, ValueError, operator.lshift, 2, -1)
end

function test_mod(self)
operator = self.module
assertRaises(self, TypeError, operator.mod)
assertRaises(self, TypeError, operator.mod, nothing, 42)
assertEqual(self, mod(operator, 5, 2), 1)
end

function test_mul(self)
operator = self.module
assertRaises(self, TypeError, operator.mul)
assertRaises(self, TypeError, operator.mul, nothing, nothing)
assertEqual(self, mul(operator, 5, 2), 10)
end

function test_matmul(self)
operator = self.module
assertRaises(self, TypeError, operator.matmul)
assertRaises(self, TypeError, operator.matmul, 42, 42)
mutable struct M <: AbstractM

end
function __matmul__(self, other)::Int64
return other - 1
end

assertEqual(self, M() * 42, 41)
end

function test_neg(self)
operator = self.module
assertRaises(self, TypeError, operator.neg)
assertRaises(self, TypeError, operator.neg, nothing)
assertEqual(self, neg(operator, 5), -5)
assertEqual(self, neg(operator, -5), 5)
assertEqual(self, neg(operator, 0), 0)
assertEqual(self, neg(operator, -0), 0)
end

function test_bitwise_or(self)
operator = self.module
assertRaises(self, TypeError, operator.or_)
assertRaises(self, TypeError, operator.or_, nothing, nothing)
assertEqual(self, or_(operator, 10, 5), 15)
end

function test_pos(self)
operator = self.module
assertRaises(self, TypeError, operator.pos)
assertRaises(self, TypeError, operator.pos, nothing)
assertEqual(self, pos(operator, 5), 5)
assertEqual(self, pos(operator, -5), -5)
assertEqual(self, pos(operator, 0), 0)
assertEqual(self, pos(operator, -0), 0)
end

function test_pow(self)
operator = self.module
assertRaises(self, TypeError, operator.pow)
assertRaises(self, TypeError, operator.pow, nothing, nothing)
assertEqual(self, pow(operator, 3, 5), 3^5)
assertRaises(self, TypeError, operator.pow, 1)
assertRaises(self, TypeError, operator.pow, 1, 2, 3)
end

function test_rshift(self)
operator = self.module
assertRaises(self, TypeError, operator.rshift)
assertRaises(self, TypeError, operator.rshift, nothing, 42)
assertEqual(self, rshift(operator, 5, 1), 2)
assertEqual(self, rshift(operator, 5, 0), 5)
assertRaises(self, ValueError, operator.rshift, 2, -1)
end

function test_contains(self)
operator = self.module
assertRaises(self, TypeError, operator.contains)
assertRaises(self, TypeError, operator.contains, nothing, nothing)
assertRaises(self, ZeroDivisionError, operator.contains, BadIterable(), 1)
assertTrue(self, contains(operator, 0:3, 2))
assertFalse(self, contains(operator, 0:3, 5))
end

function test_setitem(self)
operator = self.module
a = collect(0:2)
assertRaises(self, TypeError, operator.setitem, a)
assertRaises(self, TypeError, operator.setitem, a, nothing, nothing)
assertIsNone(self, setitem(operator, a, 0, 2))
assertEqual(self, a, [2, 1, 2])
assertRaises(self, IndexError, operator.setitem, a, 4, 2)
end

function test_sub(self)
operator = self.module
assertRaises(self, TypeError, operator.sub)
assertRaises(self, TypeError, operator.sub, nothing, nothing)
assertEqual(self, sub(operator, 5, 2), 3)
end

function test_truth(self)
operator = self.module
mutable struct C <: AbstractC

end
function __bool__(self)
throw(SyntaxError)
end

assertRaises(self, TypeError, operator.truth)
assertRaises(self, SyntaxError, operator.truth, C())
assertTrue(self, truth(operator, 5))
assertTrue(self, truth(operator, [0]))
assertFalse(self, truth(operator, 0))
assertFalse(self, truth(operator, []))
end

function test_bitwise_xor(self)
operator = self.module
assertRaises(self, TypeError, operator.xor)
assertRaises(self, TypeError, operator.xor, nothing, nothing)
assertEqual(self, xor(operator, 11, 12), 7)
end

function test_is(self)
operator = self.module
a = "xyzpdq"
b = "xyzpdq"
c = a[begin:3] * b[4:end]
assertRaises(self, TypeError, operator.is_)
assertTrue(self, is_(operator, a, b))
assertFalse(self, is_(operator, a, c))
end

function test_is_not(self)
operator = self.module
a = "xyzpdq"
b = "xyzpdq"
c = a[begin:3] * b[4:end]
assertRaises(self, TypeError, operator.is_not)
assertFalse(self, is_not(operator, a, b))
assertTrue(self, is_not(operator, a, c))
end

function test_attrgetter(self)
operator = self.module
mutable struct A <: AbstractA

end

a = A()
a.name = "arthur"
f = attrgetter(operator, "name")
assertEqual(self, f(a), "arthur")
assertRaises(self, TypeError, f)
assertRaises(self, TypeError, f, a, "dent")
assertRaises(self, TypeError, f, a, surname = "dent")
f = attrgetter(operator, "rank")
assertRaises(self, AttributeError, f, a)
assertRaises(self, TypeError, operator.attrgetter, 2)
assertRaises(self, TypeError, operator.attrgetter)
record = A()
record.x = "X"
record.y = "Y"
record.z = "Z"
assertEqual(self, attrgetter(operator, "x", "z", "y")(record), ("X", "Z", "Y"))
assertRaises(self, TypeError, operator.attrgetter, ("x", (), "y"))
mutable struct C <: AbstractC

end
function __getattr__(self, name)
throw(SyntaxError)
end

assertRaises(self, SyntaxError, attrgetter(operator, "foo"), C())
a = A()
a.name = "arthur"
a.child = A()
a.child.name = "thomas"
f = attrgetter(operator, "child.name")
assertEqual(self, f(a), "thomas")
assertRaises(self, AttributeError, f, a.child)
f = attrgetter(operator, "name", "child.name")
assertEqual(self, f(a), ("arthur", "thomas"))
f = attrgetter(operator, "name", "child.name", "child.child.name")
assertRaises(self, AttributeError, f, a)
f = attrgetter(operator, "child.")
assertRaises(self, AttributeError, f, a)
f = attrgetter(operator, ".child")
assertRaises(self, AttributeError, f, a)
a.child.child = A()
a.child.child.name = "johnson"
f = attrgetter(operator, "child.child.name")
assertEqual(self, f(a), "johnson")
f = attrgetter(operator, "name", "child.name", "child.child.name")
assertEqual(self, f(a), ("arthur", "thomas", "johnson"))
end

function test_itemgetter(self)
operator = self.module
a = "ABCDE"
f = itemgetter(operator, 2)
assertEqual(self, f(a), "C")
assertRaises(self, TypeError, f)
assertRaises(self, TypeError, f, a, 3)
assertRaises(self, TypeError, f, a, size = 3)
f = itemgetter(operator, 10)
assertRaises(self, IndexError, f, a)
mutable struct C <: AbstractC

end
function __getitem__(self, name)
throw(SyntaxError)
end

assertRaises(self, SyntaxError, itemgetter(operator, 42), C())
f = itemgetter(operator, "name")
assertRaises(self, TypeError, f, a)
assertRaises(self, TypeError, operator.itemgetter)
d = dict(key = "val")
f = itemgetter(operator, "key")
assertEqual(self, f(d), "val")
f = itemgetter(operator, "nonkey")
assertRaises(self, KeyError, f, d)
inventory = [("apple", 3), ("banana", 2), ("pear", 5), ("orange", 1)]
getcount = itemgetter(operator, 1)
assertEqual(self, collect(map(getcount, inventory)), [3, 2, 5, 1])
assertEqual(self, sorted(inventory, key = getcount), [("orange", 1), ("banana", 2), ("apple", 3), ("pear", 5)])
data = collect(map(str, 0:19))
assertEqual(self, itemgetter(operator, 2, 10, 5)(data), ("2", "10", "5"))
assertRaises(self, TypeError, itemgetter(operator, 2, "x", 5), data)
t = tuple("abcde")
assertEqual(self, itemgetter(operator, -1)(t), "e")
assertEqual(self, itemgetter(operator, (2:4))(t), ("c", "d"))
mutable struct T <: AbstractT
#= Tuple subclass =#

end

assertEqual(self, itemgetter(operator, 0)(T("abc")), "a")
assertEqual(self, itemgetter(operator, 0)(["a", "b", "c"]), "a")
assertEqual(self, itemgetter(operator, 0)(100:199), 100)
end

function test_methodcaller(self)
operator = self.module
assertRaises(self, TypeError, operator.methodcaller)
assertRaises(self, TypeError, operator.methodcaller, 12)
mutable struct A <: AbstractA

end
function foo(self)::Any
return args[1] + args[2]
end

function bar(self, f = 42)
return f
end

function baz()::Tuple
return (kwds["name"], kwds["self"])
end

a = A()
f = methodcaller(operator, "foo")
assertRaises(self, IndexError, f, a)
f = methodcaller(operator, "foo", 1, 2)
assertEqual(self, f(a), 3)
assertRaises(self, TypeError, f)
assertRaises(self, TypeError, f, a, 3)
assertRaises(self, TypeError, f, a, spam = 3)
f = methodcaller(operator, "bar")
assertEqual(self, f(a), 42)
assertRaises(self, TypeError, f, a, a)
f = methodcaller(operator, "bar", f = 5)
assertEqual(self, f(a), 5)
f = methodcaller(operator, "baz", name = "spam", self = "eggs")
assertEqual(self, f(a), ("spam", "eggs"))
end

function test_inplace(self)
operator = self.module
mutable struct C <: AbstractC

end
function __iadd__(self, other)::String
return "iadd"
end

function __iand__(self, other)::String
return "iand"
end

function __ifloordiv__(self, other)::String
return "ifloordiv"
end

function __ilshift__(self, other)::String
return "ilshift"
end

function __imod__(self, other)::String
return "imod"
end

function __imul__(self, other)::String
return "imul"
end

function __imatmul__(self, other)::String
return "imatmul"
end

function __ior__(self, other)::String
return "ior"
end

function __ipow__(self, other)::String
return "ipow"
end

function __irshift__(self, other)::String
return "irshift"
end

function __isub__(self, other)::String
return "isub"
end

function __itruediv__(self, other)::String
return "itruediv"
end

function __ixor__(self, other)::String
return "ixor"
end

function __getitem__(self, other)::Int64
return 5
end

c = C()
assertEqual(self, iadd(operator, c, 5), "iadd")
assertEqual(self, iand(operator, c, 5), "iand")
assertEqual(self, ifloordiv(operator, c, 5), "ifloordiv")
assertEqual(self, ilshift(operator, c, 5), "ilshift")
assertEqual(self, imod(operator, c, 5), "imod")
assertEqual(self, imul(operator, c, 5), "imul")
assertEqual(self, imatmul(operator, c, 5), "imatmul")
assertEqual(self, ior(operator, c, 5), "ior")
assertEqual(self, ipow(operator, c, 5), "ipow")
assertEqual(self, irshift(operator, c, 5), "irshift")
assertEqual(self, isub(operator, c, 5), "isub")
assertEqual(self, itruediv(operator, c, 5), "itruediv")
assertEqual(self, ixor(operator, c, 5), "ixor")
assertEqual(self, iconcat(operator, c, c), "iadd")
end

function test_length_hint(self)
operator = self.module
mutable struct X <: AbstractX
value
end
function __length_hint__(self)
if type_(self.value) === type_
throw(self.value)
else
return self.value
end
end

assertEqual(self, length_hint(operator, [], 2), 0)
assertEqual(self, length_hint(operator, (x for x in [1, 2, 3])), 3)
assertEqual(self, length_hint(operator, X(2)), 2)
assertEqual(self, length_hint(operator, X(NotImplemented), 4), 4)
assertEqual(self, length_hint(operator, X(TypeError), 12), 12)
assertRaises(self, TypeError) do 
length_hint(operator, X("abc"))
end
assertRaises(self, ValueError) do 
length_hint(operator, X(-2))
end
assertRaises(self, LookupError) do 
length_hint(operator, X(LookupError))
end
end

function test_dunder_is_original(self)
operator = self.module
names = [name for name in dir(operator) if !startswith(name, "_") ]
for name in names
orig = getfield(operator, :name)
dunder = (hasfield(typeof(operator), :("__" + strip(name, "_"))+__) ? 
                getfield(operator, :("__" + strip(name, "_"))+__) : nothing)
if dunder
assertIs(self, dunder, orig)
end
end
end

mutable struct PyOperatorTestCase <: AbstractPyOperatorTestCase
module_

                    PyOperatorTestCase(module_ = py_operator) =
                        new(module_)
end

mutable struct COperatorTestCase <: AbstractCOperatorTestCase
module_

                    COperatorTestCase(module_ = c_operator) =
                        new(module_)
end

mutable struct OperatorPickleTestCase <: AbstractOperatorPickleTestCase
module_
module2
end
function copy(self, obj, proto)
swap_item(sys.modules, "operator", self.module) do 
pickled = dumps(obj, proto)
end
swap_item(sys.modules, "operator", self.module2) do 
return loads(pickled)
end
end

function test_attrgetter(self)
attrgetter = self.module.attrgetter
mutable struct A <: AbstractA

end

a = A()
a.x = "X"
a.y = "Y"
a.z = "Z"
a.t = A()
a.t.u = A()
a.t.u.v = "V"
for proto in 0:pickle.HIGHEST_PROTOCOL
subTest(self, proto = proto) do 
f = attrgetter("x")
f2 = copy(self, f, proto)
assertEqual(self, repr(f2), repr(f))
assertEqual(self, f2(a), f(a))
f = attrgetter("x", "y", "z")
f2 = copy(self, f, proto)
assertEqual(self, repr(f2), repr(f))
assertEqual(self, f2(a), f(a))
f = attrgetter("t.u.v")
f2 = copy(self, f, proto)
assertEqual(self, repr(f2), repr(f))
assertEqual(self, f2(a), f(a))
end
end
end

function test_itemgetter(self)
itemgetter = self.module.itemgetter
a = "ABCDE"
for proto in 0:pickle.HIGHEST_PROTOCOL
subTest(self, proto = proto) do 
f = itemgetter(2)
f2 = copy(self, f, proto)
assertEqual(self, repr(f2), repr(f))
assertEqual(self, f2(a), f(a))
f = itemgetter(2, 0, 4)
f2 = copy(self, f, proto)
assertEqual(self, repr(f2), repr(f))
assertEqual(self, f2(a), f(a))
end
end
end

function test_methodcaller(self)
methodcaller = self.module.methodcaller
mutable struct A <: AbstractA

end
function foo(self)::Any
return args[1] + args[2]
end

function bar(self, f = 42)
return f
end

function baz()::Tuple
return (kwds["name"], kwds["self"])
end

a = A()
for proto in 0:pickle.HIGHEST_PROTOCOL
subTest(self, proto = proto) do 
f = methodcaller("bar")
f2 = copy(self, f, proto)
assertEqual(self, repr(f2), repr(f))
assertEqual(self, f2(a), f(a))
f = methodcaller("foo", 1, 2)
f2 = copy(self, f, proto)
assertEqual(self, repr(f2), repr(f))
assertEqual(self, f2(a), f(a))
f = methodcaller("bar", f = 5)
f2 = copy(self, f, proto)
assertEqual(self, repr(f2), repr(f))
assertEqual(self, f2(a), f(a))
f = methodcaller("baz", self = "eggs", name = "spam")
f2 = copy(self, f, proto)
assertEqual(self, f2(a), f(a))
end
end
end

mutable struct PyPyOperatorPickleTestCase <: AbstractPyPyOperatorPickleTestCase
module_
module2

                    PyPyOperatorPickleTestCase(module_ = py_operator, module2 = py_operator) =
                        new(module_, module2)
end

mutable struct PyCOperatorPickleTestCase <: AbstractPyCOperatorPickleTestCase
module_
module2

                    PyCOperatorPickleTestCase(module_ = py_operator, module2 = c_operator) =
                        new(module_, module2)
end

mutable struct CPyOperatorPickleTestCase <: AbstractCPyOperatorPickleTestCase
module_
module2

                    CPyOperatorPickleTestCase(module_ = c_operator, module2 = py_operator) =
                        new(module_, module2)
end

mutable struct CCOperatorPickleTestCase <: AbstractCCOperatorPickleTestCase
module_
module2

                    CCOperatorPickleTestCase(module_ = c_operator, module2 = c_operator) =
                        new(module_, module2)
end

if abspath(PROGRAM_FILE) == @__FILE__
py_operator_test_case = PyOperatorTestCase()
c_operator_test_case = COperatorTestCase()
py_py_operator_pickle_test_case = PyPyOperatorPickleTestCase()
py_c_operator_pickle_test_case = PyCOperatorPickleTestCase()
c_py_operator_pickle_test_case = CPyOperatorPickleTestCase()
c_c_operator_pickle_test_case = CCOperatorPickleTestCase()
end