using StringEncodings
using Test

using doctest: DocTestSuite
import ast

import builtins

import decimal
import fractions
import gc

import locale


import platform
import random





import warnings

using functools: partial
using inspect: CO_COROUTINE

using textwrap: dedent




using test.support.os_helper: EnvironmentVarGuard, TESTFN, unlink
using test.support.script_helper: assert_python_ok
using test.support.warnings_helper: check_warnings
using unittest.mock: MagicMock, patch
try
import pty
import signal
catch exn
if exn isa ImportError
pty = nothing
signal = nothing
end
end
abstract type AbstractBuiltinTest end
abstract type AbstractAbsClass <: object end
abstract type AbstractC2 <: object end
abstract type AbstractC3 <: AbstractC2 end
abstract type AbstractFoo <: object end
abstract type AbstractD <: AbstractC end
abstract type AbstractC <: object end
abstract type Abstractfrozendict_error <: Exception end
abstract type Abstractfrozendict <: dict end
abstract type AbstractZ <: int end
abstract type AbstractNoLenMethod <: object end
abstract type AbstractC_get_vars <: object end
abstract type AbstractError <: Exception end
abstract type AbstractDerivedFromA <: AbstractA end
abstract type AbstractSimple <: object end
abstract type AbstractDerivedFromSimple <: AbstractSimple end
abstract type AbstractDerivedFromSimple2 <: AbstractDerivedFromSimple end
abstract type AbstractDerivedFromStr <: str end
abstract type AbstractTestBreakpoint end
abstract type AbstractPtyTests end
abstract type AbstractTestSorted end
abstract type AbstractShutdownTest end
abstract type AbstractTestType end
mutable struct Squares <: AbstractSquares
max
sofar::Vector
end
function __len__(self)::Int64
return length(self.sofar)
end

function __getitem__(self, i)::Vector
if !(0 <= i < self.max)
throw(IndexError)
end
n = length(self.sofar)
while n <= i
append(self.sofar, n*n)
n += 1
end
return self.sofar[i + 1]
end

mutable struct StrSquares <: AbstractStrSquares
max
sofar::Vector
end
function __len__(self)::Int64
return length(self.sofar)
end

function __getitem__(self, i)::Vector
if !(0 <= i < self.max)
throw(IndexError)
end
n = length(self.sofar)
while n <= i
append(self.sofar, string(n*n))
n += 1
end
return self.sofar[i + 1]
end

mutable struct BitBucket <: AbstractBitBucket

end
function write(self, line)
#= pass =#
end

test_conv_no_sign = [("0", 0), ("1", 1), ("9", 9), ("10", 10), ("99", 99), ("100", 100), ("314", 314), (" 314", 314), ("314 ", 314), ("  \t\t  314  \t\t  ", 314), (repr(sys.maxsize), sys.maxsize), ("  1x", ValueError), ("  1  ", 1), ("  1  ", ValueError), ("", ValueError), (" ", ValueError), ("  \t\t  ", ValueError), (string(b"\\u0663\\u0661\\u0664 "), 314), (Char(512), ValueError)]
test_conv_sign = [("0", 0), ("1", 1), ("9", 9), ("10", 10), ("99", 99), ("100", 100), ("314", 314), (" 314", ValueError), ("314 ", 314), ("  \t\t  314  \t\t  ", ValueError), (repr(sys.maxsize), sys.maxsize), ("  1x", ValueError), ("  1  ", ValueError), ("  1  ", ValueError), ("", ValueError), (" ", ValueError), ("  \t\t  ", ValueError), (string(b"\\u0663\\u0661\\u0664 "), 314), (Char(512), ValueError)]
mutable struct TestFailingBool <: AbstractTestFailingBool

end
function __bool__(self)
throw(RuntimeError)
end

mutable struct TestFailingIter <: AbstractTestFailingIter

end
function __iter__(self)
throw(RuntimeError)
end

function filter_char(arg)::Bool
return Int(codepoint(arg)) > Int(codepoint('d'))
end

function map_char(arg)
return Char(Int(codepoint(arg)) + 1)
end

mutable struct BuiltinTest <: AbstractBuiltinTest
bar::String
size
x::Int64
y::Int64
z::Int64
__dict__::Int64
__slots__::Vector
_cells::Dict
linux_alpha
system_round_bug::Bool

                    BuiltinTest(bar::String, size, x::Int64, y::Int64, z::Int64, __dict__::Int64 = 8, __slots__::Vector = [], _cells::Dict = Dict(), linux_alpha = startswith(system(), "Linux") && startswith(machine(), "alpha"), system_round_bug::Bool = round(5000000000000000.0 + 1) != (5000000000000000.0 + 1)) =
                        new(bar, size, x, y, z, __dict__, __slots__, _cells, linux_alpha, system_round_bug)
end
function check_iter_pickle(self, it, seq, proto)
itorg = it
d = dumps(it, proto)
it = loads(d)
@test (type_(itorg) == type_(it))
@test (collect(it) == seq)
it = loads(d)
try
next(it)
catch exn
if exn isa StopIteration
return
end
end
d = dumps(it, proto)
it = loads(d)
@test (collect(it) == seq[2:end])
end

function test_import(self)
__import__("sys")
__import__("time")
__import__("string")
__import__(name = "sys")
__import__(name = "time", level = 0)
@test_throws ImportError __import__("spamspam")
@test_throws TypeError __import__(1, 2, 3, 4)
@test_throws ValueError __import__("")
@test_throws TypeError __import__("sys", name = "sys")
assertWarns(self, ImportWarning) do 
@test_throws ImportError __import__("", Dict("__package__" => nothing, "__spec__" => nothing, "__name__" => "__main__"), locals = Dict(), fromlist = ("foo",), level = 1)
end
@test_throws ModuleNotFoundError __import__("string\0")
end

function test_abs(self)
assertEqual(self, abs(0), 0)
assertEqual(self, abs(1234), 1234)
assertEqual(self, abs(-1234), 1234)
assertTrue(self, abs(-(sys.maxsize) - 1) > 0)
assertEqual(self, abs(0.0), 0.0)
assertEqual(self, abs(3.14), 3.14)
assertEqual(self, abs(-3.14), 3.14)
assertRaises(self, TypeError, abs, "a")
assertEqual(self, abs(true), 1)
assertEqual(self, abs(false), 0)
assertRaises(self, TypeError, abs)
assertRaises(self, TypeError, abs, nothing)
mutable struct AbsClass <: AbstractAbsClass

end
function __abs__(self)::Int64
return -5
end

assertEqual(self, abs(AbsClass()), -5)
end

function test_all(self)
@test (all([2, 4, 6]) == true_)
@test (all([2, nothing, 6]) == false_)
@test_throws RuntimeError all([2, TestFailingBool(), 6])
@test_throws RuntimeError all(TestFailingIter())
@test_throws TypeError all(10)
@test_throws TypeError all()
@test_throws TypeError all([2, 4, 6], [])
@test (all([]) == true_)
@test (all([0, TestFailingBool()]) == false_)
S = [50, 60]
@test (all((x > 42 for x in S)) == true_)
S = [50, 40, 60]
@test (all((x > 42 for x in S)) == false_)
end

function test_any(self)
@test (any([nothing, nothing, nothing]) == false_)
@test (any([nothing, 4, nothing]) == true_)
@test_throws RuntimeError any([nothing, TestFailingBool(), 6])
@test_throws RuntimeError any(TestFailingIter())
@test_throws TypeError any(10)
@test_throws TypeError any()
@test_throws TypeError any([2, 4, 6], [])
@test (any([]) == false_)
@test (any([1, TestFailingBool()]) == true_)
S = [40, 60, 30]
@test (any((x > 42 for x in S)) == true_)
S = [10, 20, 30]
@test (any((x > 42 for x in S)) == false_)
end

function test_ascii(self)
@test (ascii("") == "\'\'")
@test (ascii(0) == "0")
@test (ascii(()) == "()")
@test (ascii([]) == "[]")
@test (ascii(Dict()) == "{}")
a = []
push!(a, a)
@test (ascii(a) == "[[...]]")
a = Dict()
a[1] = a
@test (ascii(a) == "{0: {...}}")
function _check_uni(s)
@test (ascii(s) == repr(s))
end

_check_uni("\'")
_check_uni("\"")
_check_uni("\"\'")
_check_uni("\0")
_check_uni("\r\n\t .")
_check_uni("")
_check_uni("῿")
_check_uni("𒿿")
_check_uni("\ud800")
_check_uni("\udfff")
@test (ascii("𝄡") == "\'\\U0001d121\'")
s = "\'\0\"\n\r\t abcd\xe9𒿿\ud800𝄡xxx."
@test (ascii(s) == "\'\\\'\\x00\"\\n\\r\\t abcd\\x85\\xe9\\U00012fff\\ud800\\U0001d121xxx.\'")
end

function test_neg(self)
x = -(sys.maxsize) - 1
@test isa(x, int)
@test (-(x) == sys.maxsize + 1)
end

function test_callable(self)
assertTrue(self, callable(len))
assertFalse(self, callable("a"))
assertTrue(self, callable(callable))
assertTrue(self, callable((x, y) -> x + y))
assertFalse(self, callable(__builtins__))
function f()
#= pass =#
end

assertTrue(self, callable(f))
mutable struct C1 <: AbstractC1

end
function meth(self)
#= pass =#
end

assertTrue(self, callable(C1))
c = C1()
assertTrue(self, callable(c.meth))
assertFalse(self, callable(c))
c.__call__ = nothing
assertFalse(self, callable(c))
c.__call__ = (self) -> 0
assertFalse(self, callable(c))
#Delete Unsupported
del(c.__call__)
assertFalse(self, callable(c))
mutable struct C2 <: AbstractC2

end
function __call__(self)
#= pass =#
end

c2 = C2()
assertTrue(self, callable(c2))
c2.__call__ = nothing
assertTrue(self, callable(c2))
mutable struct C3 <: AbstractC3

end

c3 = C3()
assertTrue(self, callable(c3))
end

function test_chr(self)
@test (Char(32) == " ")
@test (Char(65) == "A")
@test (Char(97) == "a")
@test (Char(255) == "\xff")
@test_throws ValueError chr(1 << 24)
@test (Char(sys.maxunicode) == string(encode("\\U0010ffff", "ascii")))
@test_throws TypeError chr()
@test (Char(65535) == "￿")
@test (Char(65536) == "𐀀")
@test (Char(65537) == "𐀁")
@test (Char(1048574) == "󿿾")
@test (Char(1048575) == "󿿿")
@test (Char(1048576) == "􀀀")
@test (Char(1048577) == "􀀁")
@test (Char(1114110) == "􏿾")
@test (Char(1114111) == "􏿿")
@test_throws ValueError chr(-1)
@test_throws ValueError chr(1114112)
@test_throws (OverflowError, ValueError) chr(2^32)
end

function test_cmp(self)
@test !hasfield(typeof(builtins), :cmp)
end

function test_compile(self)
compile("print(1)\n", "", "exec")
bom = b"\xef\xbb\xbf"
compile(append!(bom, b"print(1)\n"), "", "exec")
compile(source = "pass", filename = "?", mode = "exec")
compile(dont_inherit = false, filename = "tmp", source = "0", mode = "eval")
compile("pass", "?", dont_inherit = true, mode = "exec")
compile(memoryview(b"text"), "name", "exec")
@test_throws TypeError compile()
@test_throws ValueError compile("print(42)\n", "<string>", "badmode")
@test_throws ValueError compile("print(42)\n", "<string>", "single", 255)
@test_throws ValueError compile(Char(0), "f", "exec")
@test_throws TypeError compile("pass", "?", "exec", mode = "eval", source = "0", filename = "tmp")
compile("print(\"å\")\n", "", "exec")
@test_throws ValueError compile(Char(0), "f", "exec")
@test_throws ValueError compile(string("a = 1"), "f", "bad")
codestr = "def f():\n        \"\"\"doc\"\"\"\n        debug_enabled = False\n        if __debug__:\n            debug_enabled = True\n        try:\n            assert False\n        except AssertionError:\n            return (True, f.__doc__, debug_enabled, __debug__)\n        else:\n            return (False, f.__doc__, debug_enabled, __debug__)\n        "
function f()
#= doc =#
end

values = [(-1, __debug__, f.__doc__, __debug__, __debug__), (0, true, "doc", true, true), (1, false, "doc", false, false), (2, false, nothing, false, false)]
for (optval, expected...) in values
codeobjs = []
push!(codeobjs, compile(codestr, "<test>", "exec", optimize = optval))
tree = parse(codestr)
push!(codeobjs, compile(tree, "<test>", "exec", optimize = optval))
for code in codeobjs
ns = Dict()
exec(code, ns)
rv = ns["f"]()
@test (rv == tuple(expected))
end
end
end

function test_compile_top_level_await_no_coro(self)
#= Make sure top level non-await codes get the correct coroutine flags =#
modes = ("single", "exec")
code_samples = ["def f():pass\n", "[x for x in l]", "{x for x in l}", "(x for x in l)", "{x:x for x in l}"]
for (mode, code_sample) in product(modes, code_samples)
source = dedent(code_sample)
co = compile(source, "?", mode, flags = ast.PyCF_ALLOW_TOP_LEVEL_AWAIT)
assertNotEqual(self, __and__(co.co_flags, CO_COROUTINE), CO_COROUTINE, msg = "source=$(source) mode=$(mode)")
end
end

function test_compile_top_level_await(self)
#= Test whether code some top level await can be compiled.

        Make sure it compiles only with the PyCF_ALLOW_TOP_LEVEL_AWAIT flag
        set, and make sure the generated code object has the CO_COROUTINE flag
        set in order to execute it with  `await eval(.....)` instead of exec,
        or via a FunctionType.
         =#
Channel() do ch_test_compile_top_level_await 
@async function arange(n)
for i in 0:n - 1
put!(ch_test_compile_top_level_await, i)
end
end
modes = ("single", "exec")
code_samples = ["a = await asyncio.sleep(0, result=1)", "async for i in arange(1):\n                   a = 1", "async with asyncio.Lock() as l:\n                   a = 1", "a = [x async for x in arange(2)][1]", "a = 1 in {x async for x in arange(2)}", "a = {x:1 async for x in arange(1)}[0]", "a = [x async for x in arange(2) async for x in arange(2)][1]", "a = [x async for x in (x async for x in arange(5))][1]", "a, = [1 for x in {x async for x in arange(1)}]", "a = [await asyncio.sleep(0, x) async for x in arange(2)][1]"]
policy = maybe_get_event_loop_policy()
try
for (mode, code_sample) in product(modes, code_samples)
source = dedent(code_sample)
@test_throws SyntaxError msg = "source=$(source) mode=$(mode)"() do 
compile(source, "?", mode)
end
co = compile(source, "?", mode, flags = ast.PyCF_ALLOW_TOP_LEVEL_AWAIT)
@test (__and__(co.co_flags, CO_COROUTINE) == CO_COROUTINE)
globals_ = Dict("asyncio" => asyncio, "a" => 0, "arange" => arange)
async_f = FunctionType(co, globals_)
run(async_f())
@test (globals_["a"] == 1)
globals_ = Dict("asyncio" => asyncio, "a" => 0, "arange" => arange)
run(eval(co, globals_))
@test (globals_["a"] == 1)
end
finally
set_event_loop_policy(policy)
end
end
end

function test_compile_top_level_await_invalid_cases(self)
Channel() do ch_test_compile_top_level_await_invalid_cases 
@async function arange(n)
for i in 0:n - 1
put!(ch_test_compile_top_level_await_invalid_cases, i)
end
end
modes = ("single", "exec")
code_samples = ["def f():  await arange(10)\n", "def f():  [x async for x in arange(10)]\n", "def f():  [await x async for x in arange(10)]\n", "def f():\n                   async for i in arange(1):\n                       a = 1\n            ", "def f():\n                   async with asyncio.Lock() as l:\n                       a = 1\n            "]
policy = maybe_get_event_loop_policy()
try
for (mode, code_sample) in product(modes, code_samples)
source = dedent(code_sample)
@test_throws SyntaxError msg = "source=$(source) mode=$(mode)"() do 
compile(source, "?", mode)
end
@test_throws SyntaxError msg = "source=$(source) mode=$(mode)"() do 
co = compile(source, "?", mode, flags = ast.PyCF_ALLOW_TOP_LEVEL_AWAIT)
end
end
finally
set_event_loop_policy(policy)
end
end
end

function test_compile_async_generator(self)
#= 
        With the PyCF_ALLOW_TOP_LEVEL_AWAIT flag added in 3.8, we want to
        make sure AsyncGenerators are still properly not marked with the
        CO_COROUTINE flag.
         =#
code = dedent("async def ticker():\n                for i in range(10):\n                    yield i\n                    await asyncio.sleep(0)")
co = compile(code, "?", "exec", flags = ast.PyCF_ALLOW_TOP_LEVEL_AWAIT)
glob = Dict()
exec(co, glob)
@test (type_(glob["ticker"]()) == AsyncGeneratorType)
end

function test_delattr(self)
sys.spam = 1
delattr(sys, "spam")
@test_throws TypeError delattr()
end

function test_dir(self)
assertRaises(self, TypeError, dir, 42, 42)
local_var = 1
assertIn(self, "local_var", dir())
assertIn(self, "exit", dir(sys))
mutable struct Foo <: AbstractFoo
__dict__::Int64

                    Foo(__dict__::Int64 = 8) =
                        new(__dict__)
end

f = Foo("foo")
assertRaises(self, TypeError, dir, f)
assertIn(self, "strip", dir(str))
assertNotIn(self, "__mro__", dir(str))
mutable struct Foo <: AbstractFoo
x::Int64
y::Int64
z::Int64
end

f = Foo()
assertIn(self, "y", dir(f))
mutable struct Foo <: AbstractFoo
__slots__::Vector

                    Foo(__slots__::Vector = []) =
                        new(__slots__)
end

f = Foo()
assertIn(self, "__repr__", dir(f))
mutable struct Foo <: AbstractFoo
bar::String
__slots__::Vector{String}

                    Foo(bar::String, __slots__::Vector{String} = ["__class__", "__dict__"]) =
                        new(bar, __slots__)
end

f = Foo()
assertNotIn(self, "__repr__", dir(f))
assertIn(self, "bar", dir(f))
mutable struct Foo <: AbstractFoo

end
function __dir__(self)
return ["kan", "ga", "roo"]
end

f = Foo()
assertTrue(self, dir(f) == ["ga", "kan", "roo"])
mutable struct Foo <: AbstractFoo

end
function __dir__(self)
return ("b", "c", "a")
end

res = dir(Foo())
assertIsInstance(self, res, list)
assertTrue(self, res == ["a", "b", "c"])
mutable struct Foo <: AbstractFoo

end
function __dir__(self)::Int64
return 7
end

f = Foo()
assertRaises(self, TypeError, dir, f)
try
throw(IndexError)
catch exn
 let e = exn
if e isa IndexError
assertEqual(self, length(dir(e.__traceback__)), 4)
end
end
end
assertEqual(self, sorted(__dir__([])), dir([]))
end

function test_divmod(self)
@test (div(12) == (1, 5))
@test (div(-12) == (-2, 2))
@test (div(12) == (-2, -2))
@test (div(-12) == (1, -5))
@test (div(-(sys.maxsize) - 1) == (sys.maxsize + 1, 0))
for (num, denom, exp_result) in [(3.25, 1.0, (3.0, 0.25)), (-3.25, 1.0, (-4.0, 0.75)), (3.25, -1.0, (-4.0, -0.75)), (-3.25, -1.0, (3.0, -0.25))]
result = div(num)
assertAlmostEqual(self, result[1], exp_result[1])
assertAlmostEqual(self, result[2], exp_result[2])
end
@test_throws TypeError divmod()
end

function test_eval(self)
assertEqual(self, eval("1+1"), 2)
assertEqual(self, eval(" 1+1\n"), 2)
globals = Dict("a" => 1, "b" => 2)
locals = Dict("b" => 200, "c" => 300)
assertEqual(self, eval("a", globals), 1)
assertEqual(self, eval("a", globals, locals), 1)
assertEqual(self, eval("b", globals, locals), 200)
assertEqual(self, eval("c", globals, locals), 300)
globals = Dict("a" => 1, "b" => 2)
locals = Dict("b" => 200, "c" => 300)
bom = b"\xef\xbb\xbf"
assertEqual(self, eval(append!(bom, b"a"), globals, locals), 1)
assertEqual(self, eval("\"å\"", globals), "å")
assertRaises(self, TypeError, eval)
assertRaises(self, TypeError, eval, ())
assertRaises(self, SyntaxError, eval, append!(bom[begin:2], b"a"))
mutable struct X <: AbstractX

end
function __getitem__(self, key)
throw(ValueError)
end

assertRaises(self, ValueError, eval, "foo", Dict(), X())
end

function test_general_eval(self)
mutable struct M <: AbstractM
#= Test mapping interface versus possible calls from eval(). =#

end
function __getitem__(self, key)::Int64
if key == "a"
return 12
end
throw(KeyError)
end

function keys(self)::Vector
return collect("xyz")
end

m = M()
g = globals()
assertEqual(self, eval("a", g, m), 12)
assertRaises(self, NameError, eval, "b", g, m)
assertEqual(self, eval("dir()", g, m), collect("xyz"))
assertEqual(self, eval("globals()", g, m), g)
assertEqual(self, eval("locals()", g, m), m)
assertRaises(self, TypeError, eval, "a", m)
mutable struct A <: AbstractA
#= Non-mapping =#

end

m = A()
assertRaises(self, TypeError, eval, "a", g, m)
mutable struct D <: AbstractD

end
function __getitem__(self, key)::Int64
if key == "a"
return 12
end
return __getitem__(dict, self)
end

function keys(self)::Vector
return collect("xyz")
end

d = D()
assertEqual(self, eval("a", g, d), 12)
assertRaises(self, NameError, eval, "b", g, d)
assertEqual(self, eval("dir()", g, d), collect("xyz"))
assertEqual(self, eval("globals()", g, d), g)
assertEqual(self, eval("locals()", g, d), d)
eval("[locals() for i in (2,3)]", g, d)
eval("[locals() for i in (2,3)]", g, UserDict())
mutable struct SpreadSheet <: AbstractSpreadSheet
#= Sample application showing nested, calculated lookups. =#
_cells::Dict

                    SpreadSheet(_cells::Dict = Dict()) =
                        new(_cells)
end
function __setitem__(self, key, formula)
self._cells[key + 1] = formula
end

function __getitem__(self, key)
return eval(self._cells[key + 1], globals(), self)
end

ss = SpreadSheet()
ss["a1"] = "5"
ss["a2"] = "a1*6"
ss["a3"] = "a2*7"
assertEqual(self, ss["a3"], 210)
mutable struct C <: AbstractC

end
function __getitem__(self, item)
throw(KeyError(item))
end

function keys(self)::Int64
return 1
end

assertRaises(self, TypeError, eval, "dir()", globals(), C())
end

function test_exec(self)
g = Dict()
exec("z = 1", g)
if "__builtins__" ∈ g
delete!(g, "__builtins__")
end
@test (g == Dict("z" => 1))
exec("z = 1+1", g)
if "__builtins__" ∈ g
delete!(g, "__builtins__")
end
@test (g == Dict("z" => 2))
g = Dict()
l = Dict()
check_warnings() do 
filterwarnings("ignore", "global statement", module_ = "<string>")
exec("global a; a = 1; b = 2", g, l)
end
if "__builtins__" ∈ g
delete!(g, "__builtins__")
end
if "__builtins__" ∈ l
delete!(l, "__builtins__")
end
@test ((g, l) == (Dict("a" => 1), Dict("b" => 2)))
end

function test_exec_globals(self)
code = compile("print(\'Hello World!\')", "", "exec")
assertRaisesRegex(self, NameError, "name \'print\' is not defined", exec, code, Dict("__builtins__" => Dict()))
assertRaises(self, TypeError, exec, code, Dict("__builtins__" => 123))
code = compile("class A: pass", "", "exec")
assertRaisesRegex(self, NameError, "__build_class__ not found", exec, code, Dict("__builtins__" => Dict()))
mutable struct frozendict_error <: Abstractfrozendict_error

end

mutable struct frozendict <: Abstractfrozendict

end
function __setitem__(self, key, value)
throw(frozendict_error("frozendict is readonly"))
end

if isa(__builtins__, types.ModuleType)
frozen_builtins = frozendict(__builtins__.__dict__)
else
frozen_builtins = frozendict(__builtins__)
end
code = compile("__builtins__[\'superglobal\']=2; print(superglobal)", "test", "exec")
assertRaises(self, frozendict_error, exec, code, Dict("__builtins__" => frozen_builtins))
namespace = frozendict(Dict())
code = compile("x=1", "test", "exec")
assertRaises(self, frozendict_error, exec, code, namespace)
end

function test_exec_redirected(self)
savestdout = sys.stdout
sys.stdout = nothing
try
exec("a")
catch exn
if exn isa NameError
#= pass =#
end
finally
sys.stdout = savestdout
end
end

function test_filter(self)
assertEqual(self, collect(filter((c) -> "a" <= c <= "z", "Hello World")), collect("elloorld"))
assertEqual(self, collect(filter(nothing, [1, "hello", [], [3], "", nothing, 9, 0])), [1, "hello", [3], 9])
assertEqual(self, collect(filter((x) -> x > 0, [1, -3, 9, 0, 2])), [1, 9, 2])
assertEqual(self, collect(filter(nothing, Squares(10))), [1, 4, 9, 16, 25, 36, 49, 64, 81])
assertEqual(self, collect(filter((x) -> x % 2, Squares(10))), [1, 9, 25, 49, 81])
function identity(item)::Int64
return 1
end

filter(identity, Squares(5))
assertRaises(self, TypeError, filter)
mutable struct BadSeq <: AbstractBadSeq

end
function __getitem__(self, index)::Int64
if index < 4
return 42
end
throw(ValueError)
end

assertRaises(self, ValueError, list, filter((x) -> x, BadSeq()))
function badfunc()
#= pass =#
end

assertRaises(self, TypeError, list, filter(badfunc, 0:4))
assertEqual(self, collect(filter(nothing, (1, 2))), [1, 2])
assertEqual(self, collect(filter((x) -> x >= 3, (1, 2, 3, 4))), [3, 4])
assertRaises(self, TypeError, list, filter(42, (1, 2)))
end

function test_filter_pickle(self)
for proto in 0:pickle.HIGHEST_PROTOCOL
f1 = filter(filter_char, "abcdeabcde")
f2 = filter(filter_char, "abcdeabcde")
check_iter_pickle(self, f1, collect(f2), proto)
end
end

function test_getattr(self)
@test getfield(sys, :stdout) === sys.stdout
@test_throws TypeError getattr(sys, 1)
@test_throws TypeError getattr(sys, 1, "foo")
@test_throws TypeError getattr()
@test_throws AttributeError getattr(sys, Char(sys.maxunicode))
@test_throws AttributeError getattr(1, "\udad1픞")
end

function test_hasattr(self)
assertTrue(self, hasfield(typeof(sys), :stdout))
assertRaises(self, TypeError, hasattr, sys, 1)
assertRaises(self, TypeError, hasattr)
assertEqual(self, false, hasfield(typeof(sys), :Char(sys.maxunicode)))
mutable struct A <: AbstractA

end
function __getattr__(self, what)
throw(SystemExit)
end

assertRaises(self, SystemExit, hasattr, A(), "b")
mutable struct B <: AbstractB

end
function __getattr__(self, what)
throw(ValueError)
end

assertRaises(self, ValueError, hasattr, B(), "b")
end

function test_hash(self)
hash(nothing)
assertEqual(self, hash(1), hash(1))
assertEqual(self, hash(1), hash(1.0))
hash("spam")
assertEqual(self, hash("spam"), hash(b"spam"))
hash((0, 1, 2, 3))
function f()
#= pass =#
end

hash(f)
assertRaises(self, TypeError, hash, [])
assertRaises(self, TypeError, hash, Dict())
mutable struct X <: AbstractX

end
function __hash__(self)::Int64
return 2^100
end

assertEqual(self, type_(hash(X())), int)
mutable struct Z <: AbstractZ

end
function __hash__(self)
return self
end

assertEqual(self, hash(Z(42)), hash(42))
end

function test_hex(self)
@test (hex(16) == "0x10")
@test (hex(-16) == "-0x10")
@test_throws TypeError hex(Dict())
end

function test_id(self)
id(nothing)
id(1)
id(1.0)
id("spam")
id((0, 1, 2, 3))
id([0, 1, 2, 3])
id(Dict("spam" => 1, "eggs" => 2, "ham" => 3))
end

function test_iter(self)
@test_throws TypeError iter()
@test_throws TypeError iter(42, 42)
lists = [("1", "2"), ["1", "2"], "12"]
for l in lists
i = (x for x in l)
@test (next(i) == "1")
@test (next(i) == "2")
@test_throws StopIteration next(i)
end
end

function test_isinstance(self)
mutable struct C <: AbstractC

end

mutable struct D <: AbstractD

end

mutable struct E <: AbstractE

end

c = C()
d = D()
e = E()
assertTrue(self, isa(c, C))
assertTrue(self, isa(d, C))
assertTrue(self, !isa(e, C))
assertTrue(self, !isa(c, D))
assertTrue(self, !isa("foo", E))
assertRaises(self, TypeError, isinstance, E, "foo")
assertRaises(self, TypeError, isinstance)
end

function test_issubclass(self)
mutable struct C <: AbstractC

end

mutable struct D <: AbstractD

end

mutable struct E <: AbstractE

end

c = C()
d = D()
e = E()
assertTrue(self, D <: C)
assertTrue(self, C <: C)
assertTrue(self, !C <: D)
assertRaises(self, TypeError, issubclass, "foo", E)
assertRaises(self, TypeError, issubclass, E, "foo")
assertRaises(self, TypeError, issubclass)
end

function test_len(self)
assertEqual(self, length("123"), 3)
assertEqual(self, length(()), 0)
assertEqual(self, length((1, 2, 3, 4)), 4)
assertEqual(self, length([1, 2, 3, 4]), 4)
assertEqual(self, length(Dict()), 0)
assertEqual(self, length(Dict("a" => 1, "b" => 2)), 2)
mutable struct BadSeq <: AbstractBadSeq

end
function __len__(self)
throw(ValueError)
end

assertRaises(self, ValueError, len, BadSeq())
mutable struct InvalidLen <: AbstractInvalidLen

end
function __len__(self)
return nothing
end

assertRaises(self, TypeError, len, InvalidLen())
mutable struct FloatLen <: AbstractFloatLen

end
function __len__(self)::Float64
return 4.5
end

assertRaises(self, TypeError, len, FloatLen())
mutable struct NegativeLen <: AbstractNegativeLen

end
function __len__(self)::Int64
return -10
end

assertRaises(self, ValueError, len, NegativeLen())
mutable struct HugeLen <: AbstractHugeLen

end
function __len__(self)::Int64
return sys.maxsize + 1
end

assertRaises(self, OverflowError, len, HugeLen())
mutable struct HugeNegativeLen <: AbstractHugeNegativeLen

end
function __len__(self)::Int64
return -(sys.maxsize) - 10
end

assertRaises(self, ValueError, len, HugeNegativeLen())
mutable struct NoLenMethod <: AbstractNoLenMethod

end

assertRaises(self, TypeError, len, NoLenMethod())
end

function test_map(self)
Channel() do ch_test_map 
assertEqual(self, collect(map((x) -> x*x, 1:3)), [1, 4, 9])
try
catch exn
if exn isa ImportError
function sqrt(x)
return pow(x, 0.5)
end

end
end
assertEqual(self, collect(map((x) -> collect(map(sqrt, x)), [[16, 4], [81, 9]])), [[4.0, 2.0], [9.0, 3.0]])
assertEqual(self, collect(map((x, y) -> x + y, [1, 3, 2], [9, 1, 4])), [10, 4, 6])
function plus()::Int64
accu = 0
for i in v
accu = accu + i
end
return accu
end

assertEqual(self, collect(map(plus, [1, 3, 7])), [1, 3, 7])
assertEqual(self, collect(map(plus, [1, 3, 7], [4, 9, 2])), [1 + 4, 3 + 9, 7 + 2])
assertEqual(self, collect(map(plus, [1, 3, 7], [4, 9, 2], [1, 1, 0])), [(1 + 4) + 1, (3 + 9) + 1, (7 + 2) + 0])
assertEqual(self, collect(map(int, Squares(10))), [0, 1, 4, 9, 16, 25, 36, 49, 64, 81])
function Max(a, b)
if a === nothing
return b
end
if b === nothing
return a
end
return max(a, b)
end

assertEqual(self, collect(map(Max, Squares(3), Squares(2))), [0, 1])
assertRaises(self, TypeError, map)
assertRaises(self, TypeError, map, (x) -> x, 42)
mutable struct BadSeq <: AbstractBadSeq

end
function __iter__(self)
Channel() do ch___iter__ 
throw(ValueError)
put!(ch___iter__, nothing)
end
end

assertRaises(self, ValueError, list, map((x) -> x, BadSeq()))
function badfunc(x)
throw(RuntimeError)
end

assertRaises(self, RuntimeError, list, map(badfunc, 0:4))
end
end

function test_map_pickle(self)
for proto in 0:pickle.HIGHEST_PROTOCOL
m1 = map(map_char, "Is this the real life?")
m2 = map(map_char, "Is this the real life?")
check_iter_pickle(self, m1, collect(m2), proto)
end
end

function test_max(self)
assertEqual(self, max("123123"), "3")
assertEqual(self, max(1, 2, 3), 3)
assertEqual(self, max((1, 2, 3, 1, 2, 3)), 3)
assertEqual(self, max([1, 2, 3, 1, 2, 3]), 3)
assertEqual(self, max(1, 2, 3.0), 3.0)
assertEqual(self, max(1, 2.0, 3), 3)
assertEqual(self, max(1.0, 2, 3), 3)
assertRaisesRegex(self, TypeError, "max expected at least 1 argument, got 0") do 
max()
end
assertRaises(self, TypeError, max, 42)
assertRaises(self, ValueError, max, ())
mutable struct BadSeq <: AbstractBadSeq

end
function __getitem__(self, index)
throw(ValueError)
end

assertRaises(self, ValueError, max, BadSeq())
for stmt in ("max(key=int)", "max(default=None)", "max(1, 2, default=None)", "max(default=None, key=int)", "max(1, key=int)", "max(1, 2, keystone=int)", "max(1, 2, key=int, abc=int)", "max(1, 2, key=1)")
try
exec(stmt, globals())
catch exn
if exn isa TypeError
#= pass =#
end
end
end
assertEqual(self, max((1,), key = neg), 1)
assertEqual(self, max((1, 2), key = neg), 1)
assertEqual(self, max(1, 2, key = neg), 1)
assertEqual(self, max((), default = nothing), nothing)
assertEqual(self, max((1,), default = nothing), 1)
assertEqual(self, max((1, 2), default = nothing), 2)
assertEqual(self, max((), default = 1, key = neg), 1)
assertEqual(self, max((1, 2), default = 3, key = neg), 1)
assertEqual(self, max((1, 2), key = nothing), 2)
data = [randrange(200) for i in 0:99]
keys = dict(((elem, randrange(50)) for elem in data))
f = keys.__getitem__
assertEqual(self, max(data, key = f), sorted(reversed(data), key = f)[end])
end

function test_min(self)
assertEqual(self, min("123123"), "1")
assertEqual(self, min(1, 2, 3), 1)
assertEqual(self, min((1, 2, 3, 1, 2, 3)), 1)
assertEqual(self, min([1, 2, 3, 1, 2, 3]), 1)
assertEqual(self, min(1, 2, 3.0), 1)
assertEqual(self, min(1, 2.0, 3), 1)
assertEqual(self, min(1.0, 2, 3), 1.0)
assertRaisesRegex(self, TypeError, "min expected at least 1 argument, got 0") do 
min()
end
assertRaises(self, TypeError, min, 42)
assertRaises(self, ValueError, min, ())
mutable struct BadSeq <: AbstractBadSeq

end
function __getitem__(self, index)
throw(ValueError)
end

assertRaises(self, ValueError, min, BadSeq())
for stmt in ("min(key=int)", "min(default=None)", "min(1, 2, default=None)", "min(default=None, key=int)", "min(1, key=int)", "min(1, 2, keystone=int)", "min(1, 2, key=int, abc=int)", "min(1, 2, key=1)")
try
exec(stmt, globals())
catch exn
if exn isa TypeError
#= pass =#
end
end
end
assertEqual(self, min((1,), key = neg), 1)
assertEqual(self, min((1, 2), key = neg), 2)
assertEqual(self, min(1, 2, key = neg), 2)
assertEqual(self, min((), default = nothing), nothing)
assertEqual(self, min((1,), default = nothing), 1)
assertEqual(self, min((1, 2), default = nothing), 1)
assertEqual(self, min((), default = 1, key = neg), 1)
assertEqual(self, min((1, 2), default = 1, key = neg), 2)
assertEqual(self, min((1, 2), key = nothing), 1)
data = [randrange(200) for i in 0:99]
keys = dict(((elem, randrange(50)) for elem in data))
f = keys.__getitem__
assertEqual(self, min(data, key = f), sorted(data, key = f)[1])
end

function test_next(self)
Channel() do ch_test_next 
it = (x for x in 0:1)
assertEqual(self, take!(it), 0)
assertEqual(self, take!(it), 1)
assertRaises(self, StopIteration, next, it)
assertRaises(self, StopIteration, next, it)
assertEqual(self, take!(it), 42)
mutable struct Iter <: AbstractIter

end
function __iter__(self)
return self
end

function __next__(self)
throw(StopIteration)
end

it = (x for x in Iter())
assertEqual(self, take!(it), 42)
assertRaises(self, StopIteration, next, it)
function gen()
Channel() do ch_gen 
put!(ch_gen, 1)
return
end
end

it = gen()
assertEqual(self, take!(it), 1)
assertRaises(self, StopIteration, next, it)
assertEqual(self, take!(it), 42)
end
end

function test_oct(self)
@test (oct(100) == "0o144")
@test (oct(-100) == "-0o144")
@test_throws TypeError oct(())
end

function write_testfile(self)
fp = readline(TESTFN)
addCleanup(self, unlink, TESTFN)
fp do 
write(fp, "1+1\n")
write(fp, "The quick brown fox jumps over the lazy dog")
write(fp, ".\n")
write(fp, "Dear John\n")
write(fp, repeat("XXX",100))
write(fp, repeat("YYY",100))
end
end

function test_open(self)
write_testfile(self)
fp = readline(TESTFN)
fp do 
@test (readline(fp, 4) == "1+1\n")
@test (readline(fp) == "The quick brown fox jumps over the lazy dog.\n")
@test (readline(fp, 4) == "Dear")
@test (readline(fp, 100) == " John\n")
@test (read(fp, 300) == repeat("XXX",100))
@test (read(fp, 1000) == repeat("YYY",100))
end
@test_throws ValueError open("a\0b")
@test_throws ValueError open(b"a\x00b")
end

function test_open_default_encoding(self)
old_environ = dict(os.environ)
try
for key in ("LC_ALL", "LANG", "LC_CTYPE")
if key ∈ os.environ
#Delete Unsupported
del(os.environ)
end
end
write_testfile(self)
current_locale_encoding = getpreferredencoding(false)
catch_warnings() do 
simplefilter("ignore", EncodingWarning)
fp = readline(TESTFN)
end
fp do 
@test (fp.encoding == current_locale_encoding)
end
finally
clear(os.environ)
update(os.environ, old_environ)
end
end

function test_open_non_inheritable(self)
fileobj = readline(__file__)
fileobj do 
@test !(get_inheritable(fileno(fileobj)))
end
end

function test_ord(self)
@test (Int(codepoint(' ')) == 32)
@test (Int(codepoint('A')) == 65)
@test (Int(codepoint('a')) == 97)
@test (Int(codepoint('\x80')) == 128)
@test (Int(codepoint('\xff')) == 255)
@test (Int(codepoint(b'')) == 32)
@test (Int(codepoint(b'A')) == 65)
@test (Int(codepoint(b'a')) == 97)
@test (Int(codepoint(b'\x80')) == 128)
@test (Int(codepoint(b'\xff')) == 255)
@test (Int(codepoint(Char(sys.maxunicode))) == sys.maxunicode)
@test_throws TypeError ord(42)
@test (Int(codepoint(Char(1114111))) == 1114111)
@test (Int(codepoint('￿')) == 65535)
@test (Int(codepoint('𐀀')) == 65536)
@test (Int(codepoint('𐀁')) == 65537)
@test (Int(codepoint('󿿾')) == 1048574)
@test (Int(codepoint('󿿿')) == 1048575)
@test (Int(codepoint('􀀀')) == 1048576)
@test (Int(codepoint('􀀁')) == 1048577)
@test (Int(codepoint('􏿾')) == 1114110)
@test (Int(codepoint('􏿿')) == 1114111)
end

function test_pow(self)
@test (pow(0, 0) == 1)
@test (pow(0, 1) == 0)
@test (pow(1, 0) == 1)
@test (pow(1, 1) == 1)
@test (pow(2, 0) == 1)
@test (pow(2, 10) == 1024)
@test (pow(2, 20) == 1024*1024)
@test (pow(2, 30) == 1024*1024*1024)
@test (pow(-2, 0) == 1)
@test (pow(-2, 1) == -2)
@test (pow(-2, 2) == 4)
@test (pow(-2, 3) == -8)
assertAlmostEqual(self, pow(0.0, 0), 1.0)
assertAlmostEqual(self, pow(0.0, 1), 0.0)
assertAlmostEqual(self, pow(1.0, 0), 1.0)
assertAlmostEqual(self, pow(1.0, 1), 1.0)
assertAlmostEqual(self, pow(2.0, 0), 1.0)
assertAlmostEqual(self, pow(2.0, 10), 1024.0)
assertAlmostEqual(self, pow(2.0, 20), 1024.0*1024.0)
assertAlmostEqual(self, pow(2.0, 30), 1024.0*1024.0*1024.0)
assertAlmostEqual(self, pow(-2.0, 0), 1.0)
assertAlmostEqual(self, pow(-2.0, 1), -2.0)
assertAlmostEqual(self, pow(-2.0, 2), 4.0)
assertAlmostEqual(self, pow(-2.0, 3), -8.0)
for x in (2, 2.0)
for y in (10, 10.0)
for z in (1000, 1000.0)
if isa(x, float) || isa(y, float) || isa(z, float)
@test_throws TypeError pow(x, y, z)
else
assertAlmostEqual(self, pow(x, y, z), 24.0)
end
end
end
end
assertAlmostEqual(self, pow(-1, 0.5), 1im)
assertAlmostEqual(self, pow(-1, 1 / 3), 0.5 + 0.8660254037844386im)
@test (pow(-1, -2, 3) == 1)
@test_throws ValueError pow(1, 2, 0)
@test_throws TypeError pow()
@test (pow(0, exp = 0) == 1)
@test (pow(base = 2, exp = 4) == 16)
@test (pow(base = 5, exp = 2, mod = 14) == 11)
twopow = partial(pow, base = 2)
@test (twopow(exp = 5) == 32)
fifth_power = partial(pow, exp = 5)
@test (fifth_power(2) == 32)
mod10 = partial(pow, mod = 10)
@test (mod10(2, 6) == 4)
@test (mod10(exp = 6, base = 2) == 4)
end

function test_input(self)
write_testfile(self)
fp = readline(TESTFN)
savestdin = sys.stdin
savestdout = sys.stdout
try
sys.stdin = fp
sys.stdout = BitBucket()
@test (input() == "1+1")
@test (input() == "The quick brown fox jumps over the lazy dog.")
@test (input("testing\n") == "Dear John")
sys.stdout = savestdout
close(sys.stdin)
@test_throws ValueError input()
sys.stdout = BitBucket()
sys.stdin = StringIO("NULL\0")
@test_throws TypeError input(42, 42)
sys.stdin = StringIO("    \'whitespace\'")
@test (input() == "    \'whitespace\'")
sys.stdin = StringIO()
@test_throws EOFError input()
#Delete Unsupported
del(sys.stdout)
@test_throws RuntimeError input("prompt")
#Delete Unsupported
del(sys.stdin)
@test_throws RuntimeError input("prompt")
finally
sys.stdin = savestdin
sys.stdout = savestdout
close(fp)
end
end

function test_repr(self)
@test (repr("") == "\'\'")
@test (repr(0) == "0")
@test (repr(()) == "()")
@test (repr([]) == "[]")
@test (repr(Dict()) == "{}")
a = []
push!(a, a)
@test (repr(a) == "[[...]]")
a = Dict()
a[1] = a
@test (repr(a) == "{0: {...}}")
end

function test_round(self)
assertEqual(self, round(0.0), 0.0)
assertEqual(self, type_(round(0.0)), int)
assertEqual(self, round(1.0), 1.0)
assertEqual(self, round(10.0), 10.0)
assertEqual(self, round(1000000000.0), 1000000000.0)
assertEqual(self, round(1e+20), 1e+20)
assertEqual(self, round(-1.0), -1.0)
assertEqual(self, round(-10.0), -10.0)
assertEqual(self, round(-1000000000.0), -1000000000.0)
assertEqual(self, round(-1e+20), -1e+20)
assertEqual(self, round(0.1), 0.0)
assertEqual(self, round(1.1), 1.0)
assertEqual(self, round(10.1), 10.0)
assertEqual(self, round(1000000000.1), 1000000000.0)
assertEqual(self, round(-1.1), -1.0)
assertEqual(self, round(-10.1), -10.0)
assertEqual(self, round(-1000000000.1), -1000000000.0)
assertEqual(self, round(0.9), 1.0)
assertEqual(self, round(9.9), 10.0)
assertEqual(self, round(999999999.9), 1000000000.0)
assertEqual(self, round(-0.9), -1.0)
assertEqual(self, round(-9.9), -10.0)
assertEqual(self, round(-999999999.9), -1000000000.0)
assertEqual(self, round(-8.0, digits = -1), -10.0)
assertEqual(self, type_(round(-8.0, digits = -1)), float)
assertEqual(self, type_(round(-8.0, digits = 0)), float)
assertEqual(self, type_(round(-8.0, digits = 1)), float)
assertEqual(self, round(5.5), 6)
assertEqual(self, round(6.5), 6)
assertEqual(self, round(-5.5), -6)
assertEqual(self, round(-6.5), -6)
assertEqual(self, round(0), 0)
assertEqual(self, round(8), 8)
assertEqual(self, round(-8), -8)
assertEqual(self, type_(round(0)), int)
assertEqual(self, type_(round(-8, digits = -1)), int)
assertEqual(self, type_(round(-8, digits = 0)), int)
assertEqual(self, type_(round(-8, digits = 1)), int)
assertEqual(self, round(number = -8.0, digits = ndigits = -1), -10.0)
assertRaises(self, TypeError, round)
mutable struct TestRound <: AbstractTestRound

end
function __round__(self)::Int64
return 23
end

mutable struct TestNoRound <: AbstractTestNoRound

end

assertEqual(self, round(TestRound()), 23)
assertRaises(self, TypeError, round, 1, 2, 3)
assertRaises(self, TypeError, round, TestNoRound())
t = TestNoRound()
t.__round__ = () -> args
assertRaises(self, TypeError, round, t)
assertRaises(self, TypeError, round, t, 0)
end

function test_round_large(self)
@test (round(5000000000000000.0 - 1) == 5000000000000000.0 - 1)
@test (round(5000000000000000.0) == 5000000000000000.0)
@test (round(5000000000000000.0 + 1) == 5000000000000000.0 + 1)
@test (round(5000000000000000.0 + 2) == 5000000000000000.0 + 2)
@test (round(5000000000000000.0 + 3) == 5000000000000000.0 + 3)
end

function test_bug_27936(self)
for x in [1234, 1234.56, Decimal("1234.56"), Fraction(123456, 100)]
@test (round(x, digits = nothing) == round(x))
@test (type_(round(x, digits = nothing)) == type_(round(x)))
end
end

function test_setattr(self)
setattr(sys, "spam", 1)
@test (sys.spam == 1)
@test_throws TypeError setattr(sys, 1, "spam")
@test_throws TypeError setattr()
end

function test_sum(self)
assertEqual(self, sum([]), 0)
assertEqual(self, sum(collect(2:7)), 27)
assertEqual(self, sum((x for x in collect(2:7))), 27)
assertEqual(self, sum(Squares(10)), 285)
assertEqual(self, sum((x for x in Squares(10))), 285)
assertEqual(self, sum([[1], [2], [3]], []), [1, 2, 3])
assertEqual(self, sum(0:9, 1000), 1045)
assertEqual(self, sum(0:9, start = 1000), 1045)
assertEqual(self, sum(0:9, 2^31 - 5), 2^31 + 40)
assertEqual(self, sum(0:9, 2^63 - 5), 2^63 + 40)
assertEqual(self, sum(((i % 2) != 0 for i in 0:9)), 5)
assertEqual(self, sum(((i % 2) != 0 for i in 0:9), 2^31 - 3), 2^31 + 2)
assertEqual(self, sum(((i % 2) != 0 for i in 0:9), 2^63 - 3), 2^63 + 2)
assertIs(self, sum([], false), false)
assertEqual(self, sum((i / 2 for i in 0:9)), 22.5)
assertEqual(self, sum((i / 2 for i in 0:9), 1000), 1022.5)
assertEqual(self, sum((i / 2 for i in 0:9), 1000.25), 1022.75)
assertEqual(self, sum([0.5, 1]), 1.5)
assertEqual(self, sum([1, 0.5]), 1.5)
assertEqual(self, repr(sum([-0.0])), "0.0")
assertEqual(self, repr(sum([-0.0], -0.0)), "-0.0")
assertEqual(self, repr(sum([], -0.0)), "-0.0")
assertRaises(self, TypeError, sum)
assertRaises(self, TypeError, sum, 42)
assertRaises(self, TypeError, sum, ["a", "b", "c"])
assertRaises(self, TypeError, sum, ["a", "b", "c"], "")
assertRaises(self, TypeError, sum, [b"a", b"c"], b"")
values = [Vector{UInt8}(b"a"), Vector{UInt8}(b"b")]
assertRaises(self, TypeError, sum, values, Vector{UInt8}(b""))
assertRaises(self, TypeError, sum, [[1], [2], [3]])
assertRaises(self, TypeError, sum, [Dict(2 => 3)])
assertRaises(self, TypeError, sum, repeat([Dict(2 => 3)],2), Dict(2 => 3))
assertRaises(self, TypeError, sum, [], "")
assertRaises(self, TypeError, sum, [], b"")
assertRaises(self, TypeError, sum, [], Vector{UInt8}())
mutable struct BadSeq <: AbstractBadSeq

end
function __getitem__(self, index)
throw(ValueError)
end

assertRaises(self, ValueError, sum, BadSeq())
empty = []
sum(([x] for x in 0:9), empty)
assertEqual(self, empty, [])
end

function test_type(self)
@test (type_("") == type_("123"))
assertNotEqual(self, type_(""), type_(()))
end

function get_vars_f0()
return vars()
end

function get_vars_f2()
BuiltinTest.get_vars_f0()
a = 1
b = 2
return vars()
end

function test_vars(self)
@test (set(vars()) == set(dir()))
@test (set(vars(sys)) == set(dir(sys)))
@test (get_vars_f0() == Dict())
@test (get_vars_f2() == Dict("a" => 1, "b" => 2))
@test_throws TypeError vars(42, 42)
@test_throws TypeError vars(42)
@test (vars(C_get_vars(self)) == Dict("a" => 2))
end

function iter_error(self, iterable, error)::Vector
#= Collect `iterable` into a list, catching an expected `error`. =#
items = []
assertRaises(self, error) do 
for item in iterable
push!(items, item)
end
end
return items
end

function test_zip(self)
a = (1, 2, 3)
b = (4, 5, 6)
t = [(1, 4), (2, 5), (3, 6)]
assertEqual(self, collect(zip(a, b)), t)
b = [4, 5, 6]
assertEqual(self, collect(zip(a, b)), t)
b = (4, 5, 6, 7)
assertEqual(self, collect(zip(a, b)), t)
mutable struct I <: AbstractI

end
function __getitem__(self, i)::Int64
if i < 0 || i > 2
throw(IndexError)
end
return i + 4
end

assertEqual(self, collect(zip(a, I())), t)
assertEqual(self, collect(zip()), [])
assertEqual(self, collect(zip([]...)), [])
assertRaises(self, TypeError, zip, nothing)
mutable struct G <: AbstractG

end

assertRaises(self, TypeError, zip, a, G())
assertRaises(self, RuntimeError, zip, a, TestFailingIter())
mutable struct SequenceWithoutALength <: AbstractSequenceWithoutALength

end
function __getitem__(self, i)
if i == 5
throw(IndexError)
else
return i
end
end

assertEqual(self, collect(zip(SequenceWithoutALength(), 0:2^30)), collect(enumerate(0:4)))
mutable struct BadSeq <: AbstractBadSeq

end
function __getitem__(self, i)
if i == 5
throw(ValueError)
else
return i
end
end

assertRaises(self, ValueError, list, zip(BadSeq(), BadSeq()))
end

function test_zip_pickle(self)
a = (1, 2, 3)
b = (4, 5, 6)
t = [(1, 4), (2, 5), (3, 6)]
for proto in 0:pickle.HIGHEST_PROTOCOL
z1 = zip(a, b)
check_iter_pickle(self, z1, t, proto)
end
end

function test_zip_pickle_strict(self)
a = (1, 2, 3)
b = (4, 5, 6)
t = [(1, 4), (2, 5), (3, 6)]
for proto in 0:pickle.HIGHEST_PROTOCOL
z1 = zip(a, b)
check_iter_pickle(self, z1, t, proto)
end
end

function test_zip_pickle_strict_fail(self)
a = (1, 2, 3)
b = (4, 5, 6, 7)
t = [(1, 4), (2, 5), (3, 6)]
for proto in 0:pickle.HIGHEST_PROTOCOL
z1 = zip(a, b)
z2 = loads(dumps(z1, proto))
@test (iter_error(self, z1, ValueError) == t)
@test (iter_error(self, z2, ValueError) == t)
end
end

function test_zip_bad_iterable(self)
exception = TypeError()
mutable struct BadIterable <: AbstractBadIterable

end
function __iter__(self)
throw(exception)
end

assertRaises(self, TypeError) do cm 
zip(BadIterable())
end
assertIs(self, cm.exception, exception)
end

function test_zip_strict(self)
@test (tuple(zip((1, 2, 3), "abc")) == ((1, "a"), (2, "b"), (3, "c")))
@test_throws ValueError tuple(zip((1, 2, 3, 4), "abc"))
@test_throws ValueError tuple(zip((1, 2), "abc"))
@test_throws ValueError tuple(zip((1, 2), (1, 2)))
end

function test_zip_strict_iterators(self)
x = (x for x in 0:4)
y = [0]
z = (x for x in 0:4)
@test_throws ValueError list(zip(x, y))
@test (next(x) == 2)
@test (next(z) == 1)
end

function test_zip_strict_error_handling(self)
mutable struct Error <: AbstractError

end

mutable struct Iter <: AbstractIter
size
end
function __iter__(self)
return self
end

function __next__(self)
self.size -= 1
if self.size < 0
throw(Error)
end
return self.size
end

l1 = iter_error(self, zip(["A", "B"], Iter(1)), Error)
assertEqual(self, l1, [("A", 0)])
l2 = iter_error(self, zip(["A", "B"], Iter(2)), ValueError)
assertEqual(self, l2, [("A", 1, "A")])
l3 = iter_error(self, zip(["A", "B"], Iter(2)), Error)
assertEqual(self, l3, [("A", 1, "A"), ("B", 0, "B")])
l4 = iter_error(self, zip(["A", "B"], Iter(3)), ValueError)
assertEqual(self, l4, [("A", 2), ("B", 1)])
l5 = iter_error(self, zip(Iter(1), "AB"), Error)
assertEqual(self, l5, [(0, "A")])
l6 = iter_error(self, zip(Iter(2), "A"), ValueError)
assertEqual(self, l6, [(1, "A")])
l7 = iter_error(self, zip(Iter(2), "ABC"), Error)
assertEqual(self, l7, [(1, "A"), (0, "B")])
l8 = iter_error(self, zip(Iter(3), "AB"), ValueError)
assertEqual(self, l8, [(2, "A"), (1, "B")])
end

function test_zip_strict_error_handling_stopiteration(self)
mutable struct Iter <: AbstractIter
size
end
function __iter__(self)
return self
end

function __next__(self)
self.size -= 1
if self.size < 0
throw(StopIteration)
end
return self.size
end

l1 = iter_error(self, zip(["A", "B"], Iter(1)), ValueError)
assertEqual(self, l1, [("A", 0)])
l2 = iter_error(self, zip(["A", "B"], Iter(2)), ValueError)
assertEqual(self, l2, [("A", 1, "A")])
l3 = iter_error(self, zip(["A", "B"], Iter(2)), ValueError)
assertEqual(self, l3, [("A", 1, "A"), ("B", 0, "B")])
l4 = iter_error(self, zip(["A", "B"], Iter(3)), ValueError)
assertEqual(self, l4, [("A", 2), ("B", 1)])
l5 = iter_error(self, zip(Iter(1), "AB"), ValueError)
assertEqual(self, l5, [(0, "A")])
l6 = iter_error(self, zip(Iter(2), "A"), ValueError)
assertEqual(self, l6, [(1, "A")])
l7 = iter_error(self, zip(Iter(2), "ABC"), ValueError)
assertEqual(self, l7, [(1, "A"), (0, "B")])
l8 = iter_error(self, zip(Iter(3), "AB"), ValueError)
assertEqual(self, l8, [(2, "A"), (1, "B")])
end

function test_zip_result_gc(self)
it = zip([[]])
collect()
@test is_tracked(next(it))
end

function test_format(self)
assertEqual(self, 3, "3")
function classes_new()
mutable struct A <: AbstractA
x
end
function __format__(self, format_spec)::String
return string(self.x) + format_spec
end

mutable struct DerivedFromA <: AbstractDerivedFromA

end

mutable struct Simple <: AbstractSimple

end

mutable struct DerivedFromSimple <: AbstractDerivedFromSimple
x
end
function __format__(self, format_spec)::String
return string(self.x) + format_spec
end

mutable struct DerivedFromSimple2 <: AbstractDerivedFromSimple2

end

return (A, DerivedFromA, DerivedFromSimple, DerivedFromSimple2)
end

function class_test(A, DerivedFromA, DerivedFromSimple, DerivedFromSimple2)
assertEqual(self, A(3), "3spec")
assertEqual(self, DerivedFromA(4), "4spec")
assertEqual(self, DerivedFromSimple(5), "5abc")
assertEqual(self, DerivedFromSimple2(10), "10abcdef")
end

class_test(classes_new()...)
function empty_format_spec(value)
assertEqual(self, value, string(value))
assertEqual(self, value, string(value))
end

empty_format_spec(17^13)
empty_format_spec(1.0)
empty_format_spec(3.1415e+104)
empty_format_spec(-3.1415e+104)
empty_format_spec(3.1415e-104)
empty_format_spec(-3.1415e-104)
empty_format_spec(object)
empty_format_spec(nothing)
mutable struct BadFormatResult <: AbstractBadFormatResult

end
function __format__(self, format_spec)::Float64
return 1.0
end

assertRaises(self, TypeError, format, BadFormatResult(), "")
assertRaises(self, TypeError, format, object(), 4)
assertRaises(self, TypeError, format, object(), object())
x = __format__(object(), "")
assertTrue(self, startswith(x, "<object object at"))
assertRaises(self, TypeError, object().__format__, 3)
assertRaises(self, TypeError, object().__format__, object())
assertRaises(self, TypeError, object().__format__, nothing)
mutable struct A <: AbstractA

end
function __format__(self, fmt_str)
return ""
end

assertEqual(self, A(), "")
assertEqual(self, A(), "")
assertEqual(self, A(), "")
mutable struct B <: AbstractB

end

mutable struct C <: AbstractC

end

for cls in [object, B, C]
obj = cls()
assertEqual(self, obj, string(obj))
assertEqual(self, obj, string(obj))
assertRaisesRegex(self, TypeError, "\\b%s\\b" % escape(cls.__name__)) do 
obj
end
end
mutable struct DerivedFromStr <: AbstractDerivedFromStr

end

assertEqual(self, 0, "         0")
end

function test_bin(self)
@test (bin(0) == "0b0")
@test (bin(1) == "0b1")
@test (bin(-1) == "-0b1")
@test (bin(2^65) == "0b1" * repeat("0",65))
@test (bin(2^65 - 1) == "0b" * repeat("1",65))
@test (bin(-(2^65)) == "-0b1" * repeat("0",65))
@test (bin(-(2^65 - 1)) == "-0b" * repeat("1",65))
end

function test_bytearray_translate(self)
x = Vector{UInt8}(b"abc")
@test_throws ValueError replace!(b"1", 1)
@test_throws TypeError replace!(repeat(b"1",256), 1)
end

function test_bytearray_extend_error(self)
array = Vector{UInt8}()
bad_iter = map(int, "X")
@test_throws ValueError array.extend(bad_iter)
end

function test_construct_singletons(self)
for const_ in (nothing, Ellipsis, NotImplemented)
tp = type_(const_)
assertIs(self, tp(), const_)
@test_throws TypeError tp(1, 2)
@test_throws TypeError tp(a = 1, b = 2)
end
end

function test_warning_notimplemented(self)
assertWarns(self, DeprecationWarning, bool, NotImplemented)
assertWarns(self, DeprecationWarning) do 
@test NotImplemented
end
assertWarns(self, DeprecationWarning) do 
@test !(!(NotImplemented))
end
end

mutable struct TestBreakpoint <: AbstractTestBreakpoint
resources
env
end
function setUp(self)
self.resources = ExitStack()
addCleanup(self, self.resources.close)
self.env = enter_context(self.resources, EnvironmentVarGuard())
#Delete Unsupported
del(self.env)
enter_context(self.resources, swap_attr(sys, "breakpointhook", sys.__breakpointhook__))
end

function test_breakpoint(self)
patch("pdb.set_trace") do mock 
breakpoint()
end
assert_called_once(mock)
end

function test_breakpoint_with_breakpointhook_set(self)
my_breakpointhook = MagicMock()
sys.breakpointhook = my_breakpointhook
breakpoint()
assert_called_once_with(my_breakpointhook)
end

function test_breakpoint_with_breakpointhook_reset(self)
my_breakpointhook = MagicMock()
sys.breakpointhook = my_breakpointhook
breakpoint()
assert_called_once_with(my_breakpointhook)
sys.breakpointhook = sys.__breakpointhook__
patch("pdb.set_trace") do mock 
breakpoint()
assert_called_once_with(mock)
end
assert_called_once_with(my_breakpointhook)
end

function test_breakpoint_with_args_and_keywords(self)
my_breakpointhook = MagicMock()
sys.breakpointhook = my_breakpointhook
breakpoint(1, 2, 3, four = 4, five = 5)
assert_called_once_with(my_breakpointhook, 1, 2, 3, four = 4, five = 5)
end

function test_breakpoint_with_passthru_error(self)
function my_breakpointhook()
#= pass =#
end

sys.breakpointhook = my_breakpointhook
@test_throws TypeError breakpoint(1, 2, 3, four = 4, five = 5)
end

function test_envar_good_path_builtin(self)
self.env["PYTHONBREAKPOINT"] = "int"
patch("builtins.int") do mock 
breakpoint("7")
assert_called_once_with(mock, "7")
end
end

function test_envar_good_path_other(self)
self.env["PYTHONBREAKPOINT"] = "sys.exit"
patch("sys.exit") do mock 
breakpoint()
assert_called_once_with(mock)
end
end

function test_envar_good_path_noop_0(self)
self.env["PYTHONBREAKPOINT"] = "0"
patch("pdb.set_trace") do mock 
breakpoint()
assert_not_called(mock)
end
end

function test_envar_good_path_empty_string(self)
self.env["PYTHONBREAKPOINT"] = ""
patch("pdb.set_trace") do mock 
breakpoint()
assert_called_once_with(mock)
end
end

function test_envar_unimportable(self)
for envar in (".", "..", ".foo", "foo.", ".int", "int.", ".foo.bar", "..foo.bar", "/./", "nosuchbuiltin", "nosuchmodule.nosuchcallable")
subTest(self, envar = envar) do 
self.env["PYTHONBREAKPOINT"] = envar
mock = enter_context(self.resources, patch("pdb.set_trace"))
w = enter_context(self.resources, check_warnings(quiet = true))
breakpoint()
@test (string(w.message) == "Ignoring unimportable \$PYTHONBREAKPOINT: \"$(envar)\"")
@test (w.category == RuntimeWarning)
assert_not_called(mock)
end
end
end

function test_envar_ignored_when_hook_is_set(self)
self.env["PYTHONBREAKPOINT"] = "sys.exit"
patch("sys.exit") do mock 
sys.breakpointhook = int
breakpoint()
assert_not_called(mock)
end
end

mutable struct PtyTests <: AbstractPtyTests
#= Tests that use a pseudo terminal to guarantee stdin and stdout are
    terminals in the test environment =#

end
function handle_sighup(signum, frame)
#= pass =#
end

function run_child(self, child, terminal_input)
old_sighup = signal(signal.SIGHUP, self.handle_sighup)
try
return _run_child(self, child, terminal_input)
finally
signal(signal.SIGHUP, old_sighup)
end
end

function _run_child(self, child, terminal_input)
r, w = pipe()
try
pid, fd = fork()
catch exn
 let e = exn
if e isa (OSError, AttributeError)
close(r)
close(w)
skipTest(self, "pty.fork() raised $()")
error()
end
end
end
if pid === 0
try
alarm(2)
close(r)
readline(w) do wpipe 
child(wpipe)
end
catch exn
print_exc()
finally
_exit(0)
end
end
close(w)
write(fd, terminal_input)
readline(r) do rpipe 
lines = []
while true
line = strip(readline(rpipe))
if line == ""
has_break = true
break;
end
push!(lines, line)
end
end
if length(lines) != 2
child_output = Vector{UInt8}()
while true
try
chunk = read(fd, 3000)
catch exn
if exn isa OSError
break;
end
end
if !(chunk)
has_break = true
break;
end
extend(child_output, chunk)
end
close(fd)
child_output = decode(child_output, "ascii", "ignore")
fail(self, "got %d lines in pipe but expected 2, child output was:\n%s" % (length(lines), child_output))
end
close(fd)
wait_process(pid, exitcode = 0)
return lines
end

function check_input_tty(self, prompt, terminal_input, stdio_encoding = nothing)
if !isatty(sys.stdin) || !isatty(sys.stdout)
skipTest(self, "stdin and stdout must be ttys")
end
function child(wpipe)
if stdio_encoding
sys.stdin = TextIOWrapper(detach(sys.stdin), encoding = stdio_encoding, errors = "surrogateescape")
sys.stdout = TextIOWrapper(detach(sys.stdout), encoding = stdio_encoding, errors = "replace")
end
write(wpipe, "tty =$(isatty(sys.stdin) && isatty(sys.stdout))")
write(wpipe, "$(ascii(input(prompt)))")
end

lines = run_child(self, child, terminal_input + b"\r\n")
assertIn(self, lines[1], Set(["tty = True", "tty = False"]))
if lines[1] != "tty = True"
skipTest(self, "standard IO in should have been a tty")
end
input_result = eval(lines[2])
if stdio_encoding
expected = decode(terminal_input, stdio_encoding, "surrogateescape")
else
expected = decode(terminal_input, sys.stdin.encoding)
end
@test (input_result == expected)
end

function test_input_tty(self)
check_input_tty(self, "prompt", b"quux")
end

function skip_if_readline(self)
if "readline" ∈ sys.modules
skipTest(self, "the readline module is loaded")
end
end

function test_input_tty_non_ascii(self)
skip_if_readline(self)
check_input_tty(self, "prompt\xe9", b"quux\xe9", "utf-8")
end

function test_input_tty_non_ascii_unicode_errors(self)
skip_if_readline(self)
check_input_tty(self, "prompt\xe9", b"quux\xe9", "ascii")
end

function test_input_no_stdout_fileno(self)
function child(wpipe)
write(wpipe, "stdin.isatty():$(isatty(sys.stdin))")
sys.stdout = StringIO()
input("prompt")
write(wpipe, "captured:$(ascii(getvalue(sys.stdout)))")
end

lines = run_child(self, child, b"quux\r")
expected = ("stdin.isatty(): True", "captured: \'prompt\'")
assertSequenceEqual(self, lines, expected)
end

mutable struct TestSorted <: AbstractTestSorted

end
function test_basic(self)
data = collect(0:99)
copy = data[begin:end]
shuffle(copy)
@test (data == sorted(copy))
assertNotEqual(self, data, copy)
reverse(data)
shuffle(copy)
@test (data == sorted(copy, key = (x) -> -(x)))
assertNotEqual(self, data, copy)
shuffle(copy)
@test (data == sorted(copy, reverse = true))
assertNotEqual(self, data, copy)
end

function test_bad_arguments(self)
sorted([])
assertRaises(self, TypeError) do 
sorted(iterable = [])
end
sorted([], key = nothing)
assertRaises(self, TypeError) do 
sorted([], nothing)
end
end

function test_inputtypes(self)
s = "abracadabra"
types = [list, tuple, str]
for T in types
@test (sorted(s) == sorted(T(s)))
end
s = join(set(s), "")
types = [str, set, frozenset, list, tuple, dict.fromkeys]
for T in types
@test (sorted(s) == sorted(T(s)))
end
end

function test_baddecorator(self)
data = split("The quick Brown fox Jumped over The lazy Dog")
@test_throws TypeError sorted(data, nothing, (x, y) -> 0)
end

mutable struct ShutdownTest <: AbstractShutdownTest

end
function test_cleanup(self)
code = "if 1:\n            import builtins\n            import sys\n\n            class C:\n                def __del__(self):\n                    print(\"before\")\n                    # Check that builtins still exist\n                    len(())\n                    print(\"after\")\n\n            c = C()\n            # Make this module survive until builtins and sys are cleaned\n            builtins.here = sys.modules[__name__]\n            sys.here = sys.modules[__name__]\n            # Create a reference loop so that this module needs to go\n            # through a GC phase.\n            here = sys.modules[__name__]\n            "
rc, out, err = assert_python_ok("-c", code, PYTHONIOENCODING = "ascii")
@test (["before", "after"] == splitlines(decode(out)))
end

mutable struct TestType <: AbstractTestType

end
function test_new_type(self)
A = type_("A", (), Dict())
assertEqual(self, A.__name__, "A")
assertEqual(self, A.__qualname__, "A")
assertEqual(self, A.__module__, __name__)
assertEqual(self, A.__bases__, (object,))
assertIs(self, A.__base__, object)
x = A()
assertIs(self, type_(x), A)
assertIs(self, x.__class__, A)
mutable struct B <: AbstractB

end
function ham(self)::String
return "ham%d" % self
end

C = type_("C", (B, int), Dict("spam" => (self) -> "spam%s" % self))
assertEqual(self, C.__name__, "C")
assertEqual(self, C.__qualname__, "C")
assertEqual(self, C.__module__, __name__)
assertEqual(self, C.__bases__, (B, int))
assertIs(self, C.__base__, int)
assertIn(self, "spam", C.__dict__)
assertNotIn(self, "ham", C.__dict__)
x = C(42)
assertEqual(self, x, 42)
assertIs(self, type_(x), C)
assertIs(self, x.__class__, C)
assertEqual(self, ham(x), "ham42")
assertEqual(self, spam(x), "spam42")
assertEqual(self, to_bytes(x, 2, "little"), b"*\x00")
end

function test_type_nokwargs(self)
assertRaises(self, TypeError) do 
type_("a", (), Dict(), x = 5)
end
assertRaises(self, TypeError) do 
type_("a", (), dict = Dict())
end
end

function test_type_name(self)
for name in ("A", "Ä", "🐍", "B.A", "42", "")
subTest(self, name = name) do 
A = type_(name, (), Dict())
@test (A.__name__ == name)
@test (A.__qualname__ == name)
@test (A.__module__ == __name__)
end
end
assertRaises(self, ValueError) do 
type_("A\0B", (), Dict())
end
assertRaises(self, ValueError) do 
type_("A\udcdcB", (), Dict())
end
assertRaises(self, TypeError) do 
type_(b"A", (), Dict())
end
C = type_("C", (), Dict())
for name in ("A", "Ä", "🐍", "B.A", "42", "")
subTest(self, name = name) do 
C.__name__ = name
@test (C.__name__ == name)
@test (C.__qualname__ == "C")
@test (C.__module__ == __name__)
end
end
A = type_("C", (), Dict())
assertRaises(self, ValueError) do 
A.__name__ = "A\0B"
end
@test (A.__name__ == "C")
assertRaises(self, ValueError) do 
A.__name__ = "A\udcdcB"
end
@test (A.__name__ == "C")
assertRaises(self, TypeError) do 
A.__name__ = b"A"
end
@test (A.__name__ == "C")
end

function test_type_qualname(self)
A = type_("A", (), Dict("__qualname__" => "B.C"))
@test (A.__name__ == "A")
@test (A.__qualname__ == "B.C")
@test (A.__module__ == __name__)
assertRaises(self, TypeError) do 
type_("A", (), Dict("__qualname__" => b"B"))
end
@test (A.__qualname__ == "B.C")
A.__qualname__ = "D.E"
@test (A.__name__ == "A")
@test (A.__qualname__ == "D.E")
assertRaises(self, TypeError) do 
A.__qualname__ = b"B"
end
@test (A.__qualname__ == "D.E")
end

function test_type_doc(self)
for doc in ("x", "Ä", "🐍", "x\0y", b"x", 42, nothing)
A = type_("A", (), Dict("__doc__" => doc))
@test (A.__doc__ == doc)
end
assertRaises(self, UnicodeEncodeError) do 
type_("A", (), Dict("__doc__" => "x\udcdcy"))
end
A = type_("A", (), Dict())
@test (A.__doc__ == nothing)
for doc in ("x", "Ä", "🐍", "x\0y", "x\udcdcy", b"x", 42, nothing)
A.__doc__ = doc
@test (A.__doc__ == doc)
end
end

function test_bad_args(self)
assertRaises(self, TypeError) do 
type_()
end
assertRaises(self, TypeError) do 
type_("A", ())
end
assertRaises(self, TypeError) do 
type_("A", (), Dict(), ())
end
assertRaises(self, TypeError) do 
type_("A", (), dict = Dict())
end
assertRaises(self, TypeError) do 
type_("A", [], Dict())
end
assertRaises(self, TypeError) do 
type_("A", (), MappingProxyType(Dict()))
end
assertRaises(self, TypeError) do 
type_("A", (nothing,), Dict())
end
assertRaises(self, TypeError) do 
type_("A", (bool,), Dict())
end
assertRaises(self, TypeError) do 
type_("A", (int, str), Dict())
end
end

function test_bad_slots(self)
assertRaises(self, TypeError) do 
type_("A", (), Dict("__slots__" => b"x"))
end
assertRaises(self, TypeError) do 
type_("A", (int,), Dict("__slots__" => "x"))
end
assertRaises(self, TypeError) do 
type_("A", (), Dict("__slots__" => ""))
end
assertRaises(self, TypeError) do 
type_("A", (), Dict("__slots__" => "42"))
end
assertRaises(self, TypeError) do 
type_("A", (), Dict("__slots__" => "x\0y"))
end
assertRaises(self, ValueError) do 
type_("A", (), Dict("__slots__" => "x", "x" => 0))
end
assertRaises(self, TypeError) do 
type_("A", (), Dict("__slots__" => ("__dict__", "__dict__")))
end
assertRaises(self, TypeError) do 
type_("A", (), Dict("__slots__" => ("__weakref__", "__weakref__")))
end
mutable struct B <: AbstractB

end

assertRaises(self, TypeError) do 
type_("A", (B,), Dict("__slots__" => "__dict__"))
end
assertRaises(self, TypeError) do 
type_("A", (B,), Dict("__slots__" => "__weakref__"))
end
end

function test_namespace_order(self)
od = OrderedDict([("a", 1), ("b", 2)])
move_to_end(od, "a")
expected = collect(items(od))
C = type_("C", (), od)
@test (collect(items(C.__dict__))[begin:2] == [("b", 2), ("a", 1)])
end

function load_tests(loader, tests, pattern)
addTest(tests, DocTestSuite(builtins))
return tests
end

if abspath(PROGRAM_FILE) == @__FILE__
builtin_test = BuiltinTest()
check_iter_pickle(builtin_test)
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
write_testfile(builtin_test)
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
get_vars_f0(builtin_test)
get_vars_f2(builtin_test)
test_vars(builtin_test)
iter_error(builtin_test)
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
handle_sighup(pty_tests)
run_child(pty_tests)
_run_child(pty_tests)
check_input_tty(pty_tests)
test_input_tty(pty_tests)
skip_if_readline(pty_tests)
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
end