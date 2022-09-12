# Transpiled with flags: 
# - oop
using ObjectOriented
using Random
using ResumableFunctions
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
pty=signal = nothing
end
end
@oodef mutable struct Squares
                    
                    max
sofar::Vector
                    
function new(max, sofar::Vector = [])
@mk begin
max = max
sofar = sofar
end
end

                end
                function __len__(self::@like(Squares))::Int64
return length(self.sofar)
end

function __getitem__(self::@like(Squares), i)::Any
if !(0 <= i < self.max)
throw(IndexError)
end
n = length(self.sofar)
while n <= i
push!(self.sofar, n*n)
n += 1
end
return self.sofar[i + 1]
end


@oodef mutable struct StrSquares
                    
                    max
sofar::Vector
                    
function new(max, sofar::Vector = [])
@mk begin
max = max
sofar = sofar
end
end

                end
                function __len__(self::@like(StrSquares))::Int64
return length(self.sofar)
end

function __getitem__(self::@like(StrSquares), i)::Any
if !(0 <= i < self.max)
throw(IndexError)
end
n = length(self.sofar)
while n <= i
push!(self.sofar, string(n*n))
n += 1
end
return self.sofar[i + 1]
end


@oodef mutable struct BitBucket
                    
                    
                    
                end
                function write(self::@like(BitBucket), line)
#= pass =#
end


test_conv_no_sign = [("0", 0), ("1", 1), ("9", 9), ("10", 10), ("99", 99), ("100", 100), ("314", 314), (" 314", 314), ("314 ", 314), ("  \t\t  314  \t\t  ", 314), (repr(typemax(Int)), typemax(Int)), ("  1x", ValueError), ("  1  ", 1), ("  1  ", ValueError), ("", ValueError), (" ", ValueError), ("  \t\t  ", ValueError), (string(b"\\u0663\\u0661\\u0664 "), 314), (Char(512), ValueError)]
test_conv_sign = [("0", 0), ("1", 1), ("9", 9), ("10", 10), ("99", 99), ("100", 100), ("314", 314), (" 314", ValueError), ("314 ", 314), ("  \t\t  314  \t\t  ", ValueError), (repr(typemax(Int)), typemax(Int)), ("  1x", ValueError), ("  1  ", ValueError), ("  1  ", ValueError), ("", ValueError), (" ", ValueError), ("  \t\t  ", ValueError), (string(b"\\u0663\\u0661\\u0664 "), 314), (Char(512), ValueError)]
@oodef mutable struct TestFailingBool
                    
                    
                    
                end
                function __bool__(self::@like(TestFailingBool))
throw(RuntimeError)
end


@oodef mutable struct TestFailingIter
                    
                    
                    
                end
                function __iter__(self::@like(TestFailingIter))
throw(RuntimeError)
end


function filter_char(arg)::Bool
return Int(codepoint(arg)) > Int(codepoint('d'))
end

function map_char(arg)
return Char(Int(codepoint(arg)) + 1)
end

@resumable function gen()
@yield 1
return
end

@oodef mutable struct AbsClass <: object
                    
                    
                    
                end
                function __abs__(self::@like(AbsClass))::Int64
return -5
end


@oodef mutable struct C1
                    
                    
                    
                end
                function meth(self::@like(C1))
#= pass =#
end


@oodef mutable struct C2 <: object
                    
                    
                    
                end
                function __call__(self::@like(C2))
#= pass =#
end


@oodef mutable struct C3 <: C2
                    
                    
                    
                end
                

@oodef mutable struct Foo <: types.ModuleType
                    
                    __dict__::Int64
                    
function new(__dict__::Int64 = 8)
__dict__ = __dict__
new(__dict__)
end

                end
                

@oodef mutable struct Foo <: object
                    
                    x::Int64
y::Int64
z::Int64
                    
function new(x::Int64 = 7, y::Int64 = 8, z::Int64 = 9)
@mk begin
x = x
y = y
z = z
end
end

                end
                

@oodef mutable struct Foo <: object
                    
                    __slots__::Vector
                    
function new(__slots__::Vector = [])
__slots__ = __slots__
new(__slots__)
end

                end
                

@oodef mutable struct Foo <: object
                    
                    bar::String
                    
function new(bar::String = "wow", __slots__::Vector{String} = ["__class__", "__dict__"])
@mk begin
bar = bar
end
end

                end
                

@oodef mutable struct Foo <: object
                    
                    
                    
                end
                function __dir__(self::@like(Foo))
return ["kan", "ga", "roo"]
end


@oodef mutable struct Foo <: object
                    
                    
                    
                end
                function __dir__(self::@like(Foo))
return ("b", "c", "a")
end


@oodef mutable struct Foo <: object
                    
                    
                    
                end
                function __dir__(self::@like(Foo))::Int64
return 7
end


@oodef mutable struct X
                    
                    
                    
                end
                function __getitem__(self::@like(X), key)
throw(ValueError)
end


@oodef mutable struct M
                    #= Test mapping interface versus possible calls from eval(). =#

                    
                    
                end
                function __getitem__(self::@like(M), key)::Int64
if key == "a"
return 12
end
throw(KeyError)
end

function keys(self::@like(M))::Vector
return collect("xyz")
end


@oodef mutable struct A
                    #= Non-mapping =#

                    
                    
                end
                

@oodef mutable struct D <: dict
                    
                    
                    
                end
                function __getitem__(self::@like(D), key)::Int64
if key == "a"
return 12
end
return __getitem__(dict, key)
end

function keys(self::@like(D))::Vector
return collect("xyz")
end


@oodef mutable struct SpreadSheet
                    #= Sample application showing nested, calculated lookups. =#

                    _cells::Dict
                    
function new(_cells::Dict = Dict())
_cells = _cells
new(_cells)
end

                end
                function __setitem__(self::@like(SpreadSheet), key, formula)
self._cells[key + 1] = formula
end

function __getitem__(self::@like(SpreadSheet), key)
return py"self._cells[key + 1], globals(), self"
end


@oodef mutable struct C
                    
                    
                    
                end
                function __getitem__(self::@like(C), item)
throw(KeyError(item))
end

function keys(self::@like(C))::Int64
return 1
end


@oodef mutable struct frozendict_error <: Exception
                    
                    
                    
                end
                

@oodef mutable struct frozendict <: dict
                    
                    
                    
                end
                function __setitem__(self::@like(frozendict), key, value)
throw(frozendict_error("frozendict is readonly"))
end


@oodef mutable struct BadSeq <: object
                    
                    
                    
                end
                function __getitem__(self::@like(BadSeq), index)::Int64
if index < 4
return 42
end
throw(ValueError)
end


@oodef mutable struct A
                    
                    
                    
                end
                function Base.getproperty(self::@like(A), what::Symbol)
                if hasproperty(self, Symbol(what))
                    return Base.getfield(self, Symbol(what))
                end
                throw(SystemExit)
            end

@oodef mutable struct B
                    
                    
                    
                end
                function Base.getproperty(self::@like(B), what::Symbol)
                if hasproperty(self, Symbol(what))
                    return Base.getfield(self, Symbol(what))
                end
                throw(ValueError)
            end

@oodef mutable struct X
                    
                    
                    
                end
                function __hash__(self::@like(X))::Int64
return 2^100
end


@oodef mutable struct Z <: Int64
                    
                    
                    
                end
                function __hash__(self::@like(Z))
return self
end


@oodef mutable struct C
                    
                    
                    
                end
                

@oodef mutable struct D <: C
                    
                    
                    
                end
                

@oodef mutable struct E
                    
                    
                    
                end
                

@oodef mutable struct C
                    
                    
                    
                end
                

@oodef mutable struct D <: C
                    
                    
                    
                end
                

@oodef mutable struct E
                    
                    
                    
                end
                

@oodef mutable struct BadSeq
                    
                    
                    
                end
                function __len__(self::@like(BadSeq))
throw(ValueError)
end


@oodef mutable struct InvalidLen
                    
                    
                    
                end
                function __len__(self::@like(InvalidLen))
return nothing
end


@oodef mutable struct FloatLen
                    
                    
                    
                end
                function __len__(self::@like(FloatLen))::Float64
return 4.5
end


@oodef mutable struct NegativeLen
                    
                    
                    
                end
                function __len__(self::@like(NegativeLen))::Int64
return -10
end


@oodef mutable struct HugeLen
                    
                    
                    
                end
                function __len__(self::@like(HugeLen))
return typemax(Int) + 1
end


@oodef mutable struct HugeNegativeLen
                    
                    
                    
                end
                function __len__(self::@like(HugeNegativeLen))
return -(typemax(Int)) - 10
end


@oodef mutable struct NoLenMethod <: object
                    
                    
                    
                end
                

@oodef mutable struct BadSeq
                    
                    
                    
                end
                @resumable function __iter__(self::@like(BadSeq))
throw(ValueError)
@yield nothing
end


@oodef mutable struct BadSeq
                    
                    
                    
                end
                function __getitem__(self::@like(BadSeq), index)
throw(ValueError)
end


@oodef mutable struct BadSeq
                    
                    
                    
                end
                function __getitem__(self::@like(BadSeq), index)
throw(ValueError)
end


@oodef mutable struct Iter <: object
                    
                    
                    
                end
                function __iter__(self::@like(Iter))
return self
end

function __next__(self::@like(Iter))
throw(StopIteration)
end


@oodef mutable struct TestRound
                    
                    
                    
                end
                function __round__(self::@like(TestRound))::Int64
return 23
end


@oodef mutable struct TestNoRound
                    
                    
                    
                end
                

@oodef mutable struct BadSeq
                    
                    
                    
                end
                function __getitem__(self::@like(BadSeq), index)
throw(ValueError)
end


@oodef mutable struct C_get_vars <: {object, AbstractBuiltinTest}
                    
                    __dict__
                    
function new(__dict__ = property(fget = getDict))
__dict__ = __dict__
new(__dict__)
end

                end
                function getDict(self::@like(C_get_vars))
return Dict{str, int}("a" => 2)
end


@oodef mutable struct I
                    
                    
                    
                end
                function __getitem__(self::@like(I), i)
if i < 0||i > 2
throw(IndexError)
end
return i + 4
end


@oodef mutable struct G
                    
                    
                    
                end
                

@oodef mutable struct SequenceWithoutALength
                    
                    
                    
                end
                function __getitem__(self::@like(SequenceWithoutALength), i)
if i == 5
throw(IndexError)
else
return i
end
end


@oodef mutable struct BadSeq
                    
                    
                    
                end
                function __getitem__(self::@like(BadSeq), i)
if i == 5
throw(ValueError)
else
return i
end
end


@oodef mutable struct BadIterable
                    
                    
                    
                end
                function __iter__(self::@like(BadIterable))
throw(exception)
end


@oodef mutable struct Error <: Exception
                    
                    
                    
                end
                

@oodef mutable struct Iter
                    
                    size
                    
function new(size)
@mk begin
size = size
end
end

                end
                function __iter__(self::@like(Iter))
return self
end

function __next__(self::@like(Iter))
self.size_ -= 1
if self.size_ < 0
throw(Error)
end
return self.size_
end


@oodef mutable struct Iter
                    
                    size
                    
function new(size)
@mk begin
size = size
end
end

                end
                function __iter__(self::@like(Iter))
return self
end

function __next__(self::@like(Iter))
self.size_ -= 1
if self.size_ < 0
throw(StopIteration)
end
return self.size_
end


@oodef mutable struct BadFormatResult
                    
                    
                    
                end
                function __format__(self::@like(BadFormatResult), format_spec)::Float64
return 1.0
end


@oodef mutable struct A
                    
                    
                    
                end
                function __format__(self::@like(A), fmt_str)
return ""
end


@oodef mutable struct B
                    
                    
                    
                end
                

@oodef mutable struct C <: object
                    
                    
                    
                end
                

@oodef mutable struct DerivedFromStr <: String
                    
                    
                    
                end
                

@oodef mutable struct BuiltinTest <: unittest.TestCase
                    
                    linux_alpha
system_round_bug::Bool
                    
function new(linux_alpha = startswith(platform.system(), "Linux")&&startswith(platform.machine(), "alpha"), system_round_bug::Bool = round(5000000000000000.0 + 1) != (5000000000000000.0 + 1))
linux_alpha = linux_alpha
system_round_bug = system_round_bug
new(linux_alpha, system_round_bug)
end

                end
                function check_iter_pickle(self::@like(BuiltinTest), it, seq, proto)
itorg = it
d = pickle.dumps(it, proto)
it = pickle.loads(d)
@test (type_(itorg) == type_(it))
@test (collect(it) == seq)
it = pickle.loads(d)
try
next(it)
catch exn
if exn isa StopIteration
return
end
end
d = pickle.dumps(it, proto)
it = pickle.loads(d)
@test (collect(it) == seq[2:end])
end

function test_import(self::@like(BuiltinTest))
__import__("sys")
__import__("time")
__import__("string")
__import__(name = "sys")
__import__(name = "time", level = 0)
@test_throws
@test_throws
@test_throws
@test_throws
assertWarns(self, ImportWarning) do 
@test_throws
end
@test_throws
end

function test_abs(self::@like(BuiltinTest))
@test (abs(0) == 0)
@test (abs(1234) == 1234)
@test (abs(-1234) == 1234)
@test abs(-(typemax(Int)) - 1) > 0
@test (abs(0.0) == 0.0)
@test (abs(3.14) == 3.14)
@test (abs(-3.14) == 3.14)
@test_throws
@test (abs(true) == 1)
@test (abs(false) == 0)
@test_throws
@test_throws
@test (abs(AbsClass()) == -5)
end

function test_all(self::@like(BuiltinTest))
@test (all([2, 4, 6]) == true)
@test (all([2, nothing, 6]) == false)
@test_throws
@test_throws
@test_throws
@test_throws
@test_throws
@test (all([]) == true)
@test (all([0, TestFailingBool()]) == false)
S = [50, 60]
@test (all((x > 42 for x in S)) == true)
S = [50, 40, 60]
@test (all((x > 42 for x in S)) == false)
end

function test_any(self::@like(BuiltinTest))
@test (any([nothing, nothing, nothing]) == false)
@test (any([nothing, 4, nothing]) == true)
@test_throws
@test_throws
@test_throws
@test_throws
@test_throws
@test (any([]) == false)
@test (any([1, TestFailingBool()]) == true)
S = [40, 60, 30]
@test (any((x > 42 for x in S)) == true)
S = [10, 20, 30]
@test (any((x > 42 for x in S)) == false)
end

function test_ascii(self::@like(BuiltinTest))
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
function _check_uni(s::@like(BuiltinTest))
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

function test_neg(self::@like(BuiltinTest))
x = -(typemax(Int)) - 1
@test isa(x, Int64)
@test (-x == typemax(Int) + 1)
end

function test_callable(self::@like(BuiltinTest))
@test callable(len)
@test !(callable("a"))
@test callable(callable)
@test callable((x, y) -> x + y)
@test !(callable(__builtins__))
function f()
#= pass =#
end

@test callable(f)
@test callable(C1)
c = C1()
@test callable(c.meth)
@test !(callable(c))
c.__call__ = nothing
@test !(callable(c))
c.__call__ = (self) -> 0
@test !(callable(c))
# Delete Unsupported
# del(c.__call__)
@test !(callable(c))
c2 = C2()
@test callable(c2)
c2.__call__ = nothing
@test callable(c2)
c3 = C3()
@test callable(c3)
end

function test_chr(self::@like(BuiltinTest))
@test (Char(32) == " ")
@test (Char(65) == "A")
@test (Char(97) == "a")
@test (Char(255) == "\xff")
@test_throws
@test (Char(sys.maxunicode) == string(encode("\\U0010ffff", "ascii")))
@test_throws
@test (Char(65535) == "￿")
@test (Char(65536) == "𐀀")
@test (Char(65537) == "𐀁")
@test (Char(1048574) == "󿿾")
@test (Char(1048575) == "󿿿")
@test (Char(1048576) == "􀀀")
@test (Char(1048577) == "􀀁")
@test (Char(1114110) == "􏿾")
@test (Char(1114111) == "􏿿")
@test_throws
@test_throws
@test_throws
end

function test_cmp(self::@like(BuiltinTest))
@test !hasfield(typeof(builtins), :cmp)
end

function test_compile(self::@like(BuiltinTest))
compile("print(1)\n", "", "exec")
bom = b"\xef\xbb\xbf"
compile([bom; b"print(1)\n"], "", "exec")
compile(source = "pass", filename = "?", mode = "exec")
compile(dont_inherit = false, filename = "tmp", source = "0", mode = "eval")
compile("pass", "?", dont_inherit = true, mode = "exec")
compile(memoryview(b"text"), "name", "exec")
@test_throws
@test_throws
@test_throws
@test_throws
@test_throws
compile("print(\"å\")\n", "", "exec")
@test_throws
@test_throws
codestr = "def f():\n        \"\"\"doc\"\"\"\n        debug_enabled = False\n        if __debug__:\n            debug_enabled = True\n        try:\n            assert False\n        except AssertionError:\n            return (True, f.__doc__, debug_enabled, __debug__)\n        else:\n            return (False, f.__doc__, debug_enabled, __debug__)\n        "
function f()
#= doc =#
end

values_ = [(-1, __debug__, f.__doc__, __debug__, __debug__), (0, true, "doc", true, true), (1, false, "doc", false, false), (2, false, nothing, false, false)]
for (optval, expected...) in values_
codeobjs = []
push!(codeobjs, compile(codestr, "<test>", "exec", optimize = optval))
tree = ast.parse(codestr)
push!(codeobjs, compile(tree, "<test>", "exec", optimize = optval))
for code in codeobjs
ns = Dict()
py"""code, ns"""
rv = ns["f"]()
@test (rv == tuple(expected))
end
end
end

function test_compile_top_level_await_no_coro(self::@like(BuiltinTest))
#= Make sure top level non-await codes get the correct coroutine flags =#
modes = ("single", "exec")
code_samples = ["def f():pass\n", "[x for x in l]", "{x for x in l}", "(x for x in l)", "{x:x for x in l}"]
for (mode, code_sample) in product(modes, code_samples)
source = dedent(code_sample)
co = compile(source, "?", mode, flags = ast.PyCF_ALLOW_TOP_LEVEL_AWAIT)
@test (__and__(co.co_flags, CO_COROUTINE) != CO_COROUTINE)
end
end

@resumable function test_compile_top_level_await(self::@like(BuiltinTest))
@async function arange(n)
for i in 0:n - 1
@yield i
end
end
modes = ("single", "exec")
code_samples = ["a = await asyncio.sleep(0, result=1)", "async for i in arange(1):\n                   a = 1", "async with asyncio.Lock() as l:\n                   a = 1", "a = [x async for x in arange(2)][1]", "a = 1 in {x async for x in arange(2)}", "a = {x:1 async for x in arange(1)}[0]", "a = [x async for x in arange(2) async for x in arange(2)][1]", "a = [x async for x in (x async for x in arange(5))][1]", "a, = [1 for x in {x async for x in arange(1)}]", "a = [await asyncio.sleep(0, x) async for x in arange(2)][1]"]
policy = maybe_get_event_loop_policy()
try
for (mode, code_sample) in product(modes, code_samples)
source = dedent(code_sample)
@test_throws SyntaxError do 
compile(source, "?", mode)
end
co = compile(source, "?", mode, flags = ast.PyCF_ALLOW_TOP_LEVEL_AWAIT)
@test (__and__(co.co_flags, CO_COROUTINE) == CO_COROUTINE)
globals_ = Dict{String, Any}("asyncio" => asyncio, "a" => 0, "arange" => arange)
async_f = FunctionType(co, globals_)
asyncio.run(async_f())
@test (globals_["a"] == 1)
globals_ = Dict{String, Any}("asyncio" => asyncio, "a" => 0, "arange" => arange)
asyncio.run(py"co, globals_")
@test (globals_["a"] == 1)
end
finally
asyncio.set_event_loop_policy(policy)
end
end

@resumable function test_compile_top_level_await_invalid_cases(self::@like(BuiltinTest))
@async function arange(n)
for i in 0:n - 1
@yield i
end
end
modes = ("single", "exec")
code_samples = ["def f():  await arange(10)\n", "def f():  [x async for x in arange(10)]\n", "def f():  [await x async for x in arange(10)]\n", "def f():\n                   async for i in arange(1):\n                       a = 1\n            ", "def f():\n                   async with asyncio.Lock() as l:\n                       a = 1\n            "]
policy = maybe_get_event_loop_policy()
try
for (mode, code_sample) in product(modes, code_samples)
source = dedent(code_sample)
@test_throws SyntaxError do 
compile(source, "?", mode)
end
@test_throws SyntaxError do 
co = compile(source, "?", mode, flags = ast.PyCF_ALLOW_TOP_LEVEL_AWAIT)
end
end
finally
asyncio.set_event_loop_policy(policy)
end
end

function test_compile_async_generator(self::@like(BuiltinTest))
#= 
        With the PyCF_ALLOW_TOP_LEVEL_AWAIT flag added in 3.8, we want to
        make sure AsyncGenerators are still properly not marked with the
        CO_COROUTINE flag.
         =#
code = dedent("async def ticker():\n                for i in range(10):\n                    yield i\n                    await asyncio.sleep(0)")
co = compile(code, "?", "exec", flags = ast.PyCF_ALLOW_TOP_LEVEL_AWAIT)
glob = Dict()
py"""co, glob"""
@test (type_(glob["ticker"]()) == AsyncGeneratorType)
end

function test_delattr(self::@like(BuiltinTest))
sys.spam = 1
delattr(sys, "spam")
@test_throws
end

function test_dir(self::@like(BuiltinTest))
@test_throws
local_var = 1
assertIn(self, "local_var", dir())
assertIn(self, "exit", dir(sys))
f = Foo("foo")
@test_throws
assertIn(self, "strip", dir(String))
assertNotIn(self, "__mro__", dir(String))
f = Foo()
assertIn(self, "y", dir(f))
f = Foo()
assertIn(self, "__repr__", dir(f))
f = Foo()
assertNotIn(self, "__repr__", dir(f))
assertIn(self, "bar", dir(f))
f = Foo()
@test dir(f) == ["ga", "kan", "roo"]
res = dir(Foo())
@test isa(self, res)
@test res == ["a", "b", "c"]
f = Foo()
@test_throws
try
throw(IndexError)
catch exn
 let e = exn
if e isa IndexError
@test (length(dir(e.__traceback__)) == 4)
end
end
end
@test (sorted(__dir__([])) == dir([]))
end

function test_divmod(self::@like(BuiltinTest))
@test (div(12) == (1, 5))
@test (div(-12) == (-2, 2))
@test (div(12) == (-2, -2))
@test (div(-12) == (1, -5))
@test (div(-(typemax(Int)) - 1) == (typemax(Int) + 1, 0))
for (num, denom, exp_result) in [(3.25, 1.0, (3.0, 0.25)), (-3.25, 1.0, (-4.0, 0.75)), (3.25, -1.0, (-4.0, -0.75)), (-3.25, -1.0, (3.0, -0.25))]
result = div(num)
assertAlmostEqual(self, result[1], exp_result[1])
assertAlmostEqual(self, result[2], exp_result[2])
end
@test_throws
end

function test_eval(self::@like(BuiltinTest))
@test (py""1+1"" == 2)
@test (py"" 1+1\n"" == 2)
globals = Dict{String, Int64}("a" => 1, "b" => 2)
locals = Dict{String, Int64}("b" => 200, "c" => 300)
@test (py""a", globals" == 1)
@test (py""a", globals, locals" == 1)
@test (py""b", globals, locals" == 200)
@test (py""c", globals, locals" == 300)
globals = Dict{String, Int64}("a" => 1, "b" => 2)
locals = Dict{String, Int64}("b" => 200, "c" => 300)
bom = b"\xef\xbb\xbf"
@test (py"[bom; b"a"], globals, locals" == 1)
@test (py""\"å\"", globals" == "å")
@test_throws
@test_throws
@test_throws
@test_throws
end

function test_general_eval(self::@like(BuiltinTest))
m = M()
g = globals()
@test (py""a", g, m" == 12)
@test_throws
@test (py""dir()", g, m" == collect("xyz"))
@test (py""globals()", g, m" == g)
@test (py""locals()", g, m" == m)
@test_throws
m = A()
@test_throws
d = D()
@test (py""a", g, d" == 12)
@test_throws
@test (py""dir()", g, d" == collect("xyz"))
@test (py""globals()", g, d" == g)
@test (py""locals()", g, d" == d)
py""[locals() for i in (2,3)]", g, d"
py""[locals() for i in (2,3)]", g, collections.UserDict()"
ss = SpreadSheet()
ss["a1"] = "5"
ss["a2"] = "a1*6"
ss["a3"] = "a2*7"
@test (ss["a3"] == 210)
@test_throws
end

function test_exec(self::@like(BuiltinTest))
g = Dict()
py""""z = 1", g"""
if "__builtins__" ∈ g
# Delete Unsupported
# del(g)
end
@test (g == Dict{str, int}("z" => 1))
py""""z = 1+1", g"""
if "__builtins__" ∈ g
# Delete Unsupported
# del(g)
end
@test (g == Dict{str, int}("z" => 2))
g = Dict()
l = Dict()
check_warnings() do 
warnings.filterwarnings("ignore", "global statement", module_ = "<string>")
py""""global a; a = 1; b = 2", g, l"""
end
if "__builtins__" ∈ g
# Delete Unsupported
# del(g)
end
if "__builtins__" ∈ l
# Delete Unsupported
# del(l)
end
@test ((g, l) == (Dict{str, int}("a" => 1), Dict{str, int}("b" => 2)))
end

function test_exec_globals(self::@like(BuiltinTest))
code = compile("print(\'Hello World!\')", "", "exec")
@test_throws NameError exec(exec, code, Dict{str, Dict}("__builtins__" => Dict()))
            @test match(@r_str("name \'print\' is not defined"), repr(exec))
@test_throws
code = compile("class A: pass", "", "exec")
@test_throws NameError exec(exec, code, Dict{str, Dict}("__builtins__" => Dict()))
            @test match(@r_str("__build_class__ not found"), repr(exec))
if isa(__builtins__, types.ModuleType)
frozen_builtins = frozendict(__builtins__.__dict__)
else
frozen_builtins = frozendict(__builtins__)
end
code = compile("__builtins__[\'superglobal\']=2; print(superglobal)", "test", "exec")
@test_throws
namespace = frozendict(Dict())
code = compile("x=1", "test", "exec")
@test_throws
end

function test_exec_redirected(self::@like(BuiltinTest))
savestdout = stdout
stdout = nothing
try
py""""a""""
catch exn
if exn isa NameError
#= pass =#
end
finally
stdout = savestdout
end
end

function test_filter(self::@like(BuiltinTest))
@test (collect(filter((c) -> "a" <= c <= "z", "Hello World")) == collect("elloorld"))
@test (collect(filter(nothing, [1, "hello", [], [3], "", nothing, 9, 0])) == [1, "hello", [3], 9])
@test (collect(filter((x) -> x > 0, [1, -3, 9, 0, 2])) == [1, 9, 2])
@test (collect(filter(nothing, Squares(10))) == [1, 4, 9, 16, 25, 36, 49, 64, 81])
@test (collect(filter((x) -> x % 2, Squares(10))) == [1, 9, 25, 49, 81])
function identity(item::@like(BuiltinTest))::Int64
return 1
end

filter(identity, Squares(5))
@test_throws
@test_throws
function badfunc()
#= pass =#
end

@test_throws
@test (collect(filter(nothing, (1, 2))) == [1, 2])
@test (collect(filter((x) -> x >= 3, (1, 2, 3, 4))) == [3, 4])
@test_throws
end

function test_filter_pickle(self::@like(BuiltinTest))
for proto in 0:pickle.HIGHEST_PROTOCOL
f1 = filter(filter_char, "abcdeabcde")
f2 = filter(filter_char, "abcdeabcde")
check_iter_pickle(self, f1, collect(f2), proto)
end
end

function test_getattr(self::@like(BuiltinTest))
@test getfield(sys, :stdout) === stdout
@test_throws
@test_throws
@test_throws
@test_throws
@test_throws
end

function test_hasattr(self::@like(BuiltinTest))
@test hasfield(typeof(sys), :stdout)
@test_throws
@test_throws
@test (false == hasfield(typeof(sys), :Char(sys.maxunicode)))
@test_throws
@test_throws
end

function test_hash(self::@like(BuiltinTest))
hash(nothing)
@test (hash(1) == hash(1))
@test (hash(1) == hash(1.0))
hash("spam")
@test (hash("spam") == hash(b"spam"))
hash((0, 1, 2, 3))
function f()
#= pass =#
end

hash(f)
@test_throws
@test_throws
@test (type_(hash(X())) == Int64)
@test (hash(Z(42)) == hash(42))
end

function test_hex(self::@like(BuiltinTest))
@test (hex(16) == "0x10")
@test (hex(-16) == "-0x10")
@test_throws
end

function test_id(self::@like(BuiltinTest))
id(nothing)
id(1)
id(1.0)
id("spam")
id((0, 1, 2, 3))
id([0, 1, 2, 3])
id(Dict{str, int}("spam" => 1, "eggs" => 2, "ham" => 3))
end

function test_iter(self::@like(BuiltinTest))
@test_throws
@test_throws
lists = [("1", "2"), ["1", "2"], "12"]
for l in lists
i = (x for x in l)
@test (next(i) == "1")
@test (next(i) == "2")
@test_throws
end
end

function test_isinstance(self::@like(BuiltinTest))
c = C()
d = D()
e = E()
@test isa(c, C)
@test isa(d, C)
@test !isa(e, C)
@test !isa(c, D)
@test !isa("foo", E)
@test_throws
@test_throws
end

function test_issubclass(self::@like(BuiltinTest))
c = C()
d = D()
e = E()
@test D <: C
@test C <: C
@test !C <: D
@test_throws
@test_throws
@test_throws
end

function test_len(self::@like(BuiltinTest))
@test (length("123") == 3)
@test (length(()) == 0)
@test (length((1, 2, 3, 4)) == 4)
@test (length([1, 2, 3, 4]) == 4)
@test (length(Dict()) == 0)
@test (length(Dict{str, int}("a" => 1, "b" => 2)) == 2)
@test_throws
@test_throws
@test_throws
@test_throws
@test_throws
@test_throws
@test_throws
end

function test_map(self::@like(BuiltinTest))
@test (collect(map((x) -> x*x, 1:3)) == [1, 4, 9])
try
catch exn
if exn isa ImportError
function sqrt(x::@like(BuiltinTest))
return pow(x, 0.5)
end

end
end
@test (collect(map((x) -> collect(map(sqrt, x)), [[16, 4], [81, 9]])) == [[4.0, 2.0], [9.0, 3.0]])
@test (collect(map((x, y) -> x + y, [1, 3, 2], [9, 1, 4])) == [10, 4, 6])
function plus(v...)::Int64
accu = 0
for i in v
accu = accu + i
end
return accu
end

@test (collect(map(plus, [1, 3, 7])) == [1, 3, 7])
@test (collect(map(plus, [1, 3, 7], [4, 9, 2])) == [1 + 4, 3 + 9, 7 + 2])
@test (collect(map(plus, [1, 3, 7], [4, 9, 2], [1, 1, 0])) == [(1 + 4) + 1, (3 + 9) + 1, (7 + 2) + 0])
@test (collect(map(Int64, Squares(10))) == [0, 1, 4, 9, 16, 25, 36, 49, 64, 81])
function Max(a::@like(BuiltinTest), b)
if a === nothing
return b
end
if b === nothing
return a
end
return max(a, b)
end

@test (collect(map(Max, Squares(3), Squares(2))) == [0, 1])
@test_throws
@test_throws
@test_throws
function badfunc(x::@like(BuiltinTest))
throw(RuntimeError)
end

@test_throws
end

function test_map_pickle(self::@like(BuiltinTest))
#= pass =#
end

function test_max(self::@like(BuiltinTest))
assertRaisesRegex(self, TypeError, "max expected at least 1 argument, got 0") do 
max()
end
@test_throws
@test_throws
@test_throws
for stmt in ("max(key=int)", "max(default=None)", "max(1, 2, default=None)", "max(default=None, key=int)", "max(1, key=int)", "max(1, 2, keystone=int)", "max(1, 2, key=int, abc=int)", "max(1, 2, key=1)")
try
py"""stmt, globals()"""
catch exn
if exn isa TypeError
#= pass =#
end
end
end
@test (max((1,), key = neg) == 1)
@test (max((1, 2), key = neg) == 1)
@test (max(1, 2, key = neg) == 1)
@test (max((), default = nothing) == nothing)
@test (max((1,), default = nothing) == 1)
@test (max((1, 2), default = nothing) == 2)
@test (max((), default = 1, key = neg) == 1)
@test (max((1, 2), default = 3, key = neg) == 1)
@test (max((1, 2), key = nothing) == 2)
data = [random.randrange(200) for i in 0:99]
keys_ = dict(((elem, random.randrange(50)) for elem in data))
f = keys_.__getitem__
@test (max(data, key = f) == sorted(reversed(data), key = f)[end])
end

function test_min(self::@like(BuiltinTest))
@test (min("123123") == "1")
@test (min(1, 2, 3) == 1)
@test (min((1, 2, 3, 1, 2, 3)) == 1)
@test (min([1, 2, 3, 1, 2, 3]) == 1)
@test (min(1, 2, 3.0) == 1)
@test (min(1, 2.0, 3) == 1)
@test (min(1.0, 2, 3) == 1.0)
assertRaisesRegex(self, TypeError, "min expected at least 1 argument, got 0") do 
min()
end
@test_throws
@test_throws
@test_throws
for stmt in ("min(key=int)", "min(default=None)", "min(1, 2, default=None)", "min(default=None, key=int)", "min(1, key=int)", "min(1, 2, keystone=int)", "min(1, 2, key=int, abc=int)", "min(1, 2, key=1)")
try
py"""stmt, globals()"""
catch exn
if exn isa TypeError
#= pass =#
end
end
end
@test (min((1,), key = neg) == 1)
@test (min((1, 2), key = neg) == 2)
@test (min(1, 2, key = neg) == 2)
@test (min((), default = nothing) == nothing)
@test (min((1,), default = nothing) == 1)
@test (min((1, 2), default = nothing) == 1)
@test (min((), default = 1, key = neg) == 1)
@test (min((1, 2), default = 1, key = neg) == 2)
@test (min((1, 2), key = nothing) == 1)
data = [random.randrange(200) for i in 0:99]
keys_ = dict(((elem, random.randrange(50)) for elem in data))
f = keys_.__getitem__
@test (min(data, key = f) == sorted(data, key = f)[1])
end

@resumable function test_next(self::@like(BuiltinTest))
it = (x for x in 0:1)
@test (it() == 0)
@test (it() == 1)
@test_throws
@test_throws
@test (it(42) == 42)
it = (x for x in Iter())
@test (it(42) == 42)
@test_throws
it = gen()
@test (it() == 1)
@test_throws
@test (it(42) == 42)
end

function test_oct(self::@like(BuiltinTest))
@test (oct(100) == "0o144")
@test (oct(-100) == "-0o144")
@test_throws
end

function write_testfile(self::@like(BuiltinTest))
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

function test_open(self::@like(BuiltinTest))
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
@test_throws
@test_throws
end

function test_open_default_encoding(self::@like(BuiltinTest))
old_environ = dict(keys(ENV))
try
for key in ("LC_ALL", "LANG", "LC_CTYPE")
if key ∈ keys(ENV)
# Delete Unsupported
# del(keys(ENV))
end
end
write_testfile(self)
current_locale_encoding = locale.getpreferredencoding(false)
warnings.catch_warnings() do 
warnings.simplefilter("ignore", builtins.EncodingWarning)
fp = readline(TESTFN)
end
fp do 
@test (fp.encoding == current_locale_encoding)
end
finally
os.clear()
os.update(old_environ)
end
end

function test_open_non_inheritable(self::@like(BuiltinTest))
fileobj = readline(@__FILE__)
fileobj do 
@test !(os.get_inheritable(fileno(fileobj)))
end
end

function test_ord(self::@like(BuiltinTest))
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
@test_throws
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

function test_pow(self::@like(BuiltinTest))
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
if isa(x, Float64)||isa(y, Float64)||isa(z, Float64)
@test_throws
else
assertAlmostEqual(self, pow(x, y, z), 24.0)
end
end
end
end
assertAlmostEqual(self, pow(-1, 0.5), 1im)
assertAlmostEqual(self, pow(-1, 1 / 3), 0.5 + 0.8660254037844386im)
@test (pow(-1, -2, 3) == 1)
@test_throws
@test_throws
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

function test_input(self::@like(BuiltinTest))
write_testfile(self)
fp = readline(TESTFN)
savestdin = sys.stdin
savestdout = stdout
try
sys.stdin = fp
stdout = BitBucket()
@test (input() == "1+1")
@test (input() == "The quick brown fox jumps over the lazy dog.")
@test (input("testing\n") == "Dear John")
stdout = savestdout
sys.close()
@test_throws
stdout = BitBucket()
sys.stdin = io.StringIO("NULL\0")
@test_throws
sys.stdin = io.StringIO("    \'whitespace\'")
@test (input() == "    \'whitespace\'")
sys.stdin = io.StringIO()
@test_throws
# Delete Unsupported
# del(stdout)
@test_throws
# Delete Unsupported
# del(sys.stdin)
@test_throws
finally
sys.stdin = savestdin
stdout = savestdout
close(fp)
end
end

function test_repr(self::@like(BuiltinTest))
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

function test_round(self::@like(BuiltinTest))
@test (round(0.0) == 0.0)
@test (type_(round(0.0)) == Int64)
@test (round(1.0) == 1.0)
@test (round(10.0) == 10.0)
@test (round(1000000000.0) == 1000000000.0)
@test (round(1e+20) == 1e+20)
@test (round(-1.0) == -1.0)
@test (round(-10.0) == -10.0)
@test (round(-1000000000.0) == -1000000000.0)
@test (round(-1e+20) == -1e+20)
@test (round(0.1) == 0.0)
@test (round(1.1) == 1.0)
@test (round(10.1) == 10.0)
@test (round(1000000000.1) == 1000000000.0)
@test (round(-1.1) == -1.0)
@test (round(-10.1) == -10.0)
@test (round(-1000000000.1) == -1000000000.0)
@test (round(0.9) == 1.0)
@test (round(9.9) == 10.0)
@test (round(999999999.9) == 1000000000.0)
@test (round(-0.9) == -1.0)
@test (round(-9.9) == -10.0)
@test (round(-999999999.9) == -1000000000.0)
@test (round(-8.0, digits = -1) == -10.0)
@test (type_(round(-8.0, digits = -1)) == Float64)
@test (type_(round(-8.0, digits = 0)) == Float64)
@test (type_(round(-8.0, digits = 1)) == Float64)
@test (round(5.5) == 6)
@test (round(6.5) == 6)
@test (round(-5.5) == -6)
@test (round(-6.5) == -6)
@test (round(0) == 0)
@test (round(8) == 8)
@test (round(-8) == -8)
@test (type_(round(0)) == Int64)
@test (type_(round(-8, digits = -1)) == Int64)
@test (type_(round(-8, digits = 0)) == Int64)
@test (type_(round(-8, digits = 1)) == Int64)
@test (round(number = -8.0, ndigits = -1) == -10.0)
@test_throws
@test (round(TestRound()) == 23)
@test_throws
@test_throws
t = TestNoRound()
t.__round__ = () -> args
@test_throws
@test_throws
end

function test_round_large(self::@like(BuiltinTest))
@test (round(5000000000000000.0 - 1) == 5000000000000000.0 - 1)
@test (round(5000000000000000.0) == 5000000000000000.0)
@test (round(5000000000000000.0 + 1) == 5000000000000000.0 + 1)
@test (round(5000000000000000.0 + 2) == 5000000000000000.0 + 2)
@test (round(5000000000000000.0 + 3) == 5000000000000000.0 + 3)
end

function test_bug_27936(self::@like(BuiltinTest))
for x in [1234, 1234.56, decimal.Decimal("1234.56"), fractions.Fraction(123456, 100)]
@test (round(x, digits = nothing) == round(x))
@test (type_(round(x, digits = nothing)) == type_(round(x)))
end
end

function test_setattr(self::@like(BuiltinTest))
setfield!(sys, :"spam", 1)
@test (sys.spam == 1)
@test_throws
@test_throws
end

function test_sum(self::@like(BuiltinTest))
@test (sum([]) == 0)
@test (sum(collect(2:7)) == 27)
@test (sum((x for x in collect(2:7))) == 27)
@test (sum(Squares(10)) == 285)
@test (sum((x for x in Squares(10))) == 285)
@test (sum([[1], [2], [3]], []) == [1, 2, 3])
@test (sum(0:9, 1000) == 1045)
@test (sum(0:9) == 1045)
@test (sum(0:9, 2^31 - 5) == 2^31 + 40)
@test (sum(0:9, 2^63 - 5) == 2^63 + 40)
@test (sum(((i % 2) != 0 for i in 0:9)) == 5)
@test (sum(((i % 2) != 0 for i in 0:9), 2^31 - 3) == 2^31 + 2)
@test (sum(((i % 2) != 0 for i in 0:9), 2^63 - 3) == 2^63 + 2)
@test self === sum([], false)
@test (sum((i / 2 for i in 0:9)) == 22.5)
@test (sum((i / 2 for i in 0:9), 1000) == 1022.5)
@test (sum((i / 2 for i in 0:9), 1000.25) == 1022.75)
@test (sum([0.5, 1]) == 1.5)
@test (sum([1, 0.5]) == 1.5)
@test (repr(sum([-0.0])) == "0.0")
@test (repr(sum([-0.0], -0.0)) == "-0.0")
@test (repr(sum([], -0.0)) == "-0.0")
@test_throws
@test_throws
@test_throws
@test_throws
@test_throws
values_ = [Vector{UInt8}(b"a"), Vector{UInt8}(b"b")]
@test_throws
@test_throws
@test_throws
@test_throws
@test_throws
@test_throws
@test_throws
@test_throws
empty_ = []
sum(([x] for x in 0:9), empty_)
@test (empty_ == [])
end

function test_type(self::@like(BuiltinTest))
@test (type_("") == type_("123"))
@test (type_("") != type_(()))
end

function get_vars_f0()
return vars()
end

function get_vars_f2()
get_vars_f0()
a = 1
b = 2
return vars()
end

function test_vars(self::@like(BuiltinTest))
@test (Set(vars()) == Set(dir()))
@test (Set(vars(sys)) == Set(dir(sys)))
@test (get_vars_f0(self) == Dict())
@test (get_vars_f2(self) == Dict{str, int}("a" => 1, "b" => 2))
@test_throws
@test_throws
@test (vars(C_get_vars(self)) == Dict{str, int}("a" => 2))
end

function iter_error(self::@like(BuiltinTest), iterable, error)::Vector
#= Collect `iterable` into a list, catching an expected `error`. =#
items = []
@test_throws error do 
for item in iterable
push!(items, item)
end
end
return items
end

function test_zip(self::@like(BuiltinTest))
a = (1, 2, 3)
b = (4, 5, 6)
t = [(1, 4), (2, 5), (3, 6)]
@test (collect(zip(a, b)) == t)
b = [4, 5, 6]
@test (collect(zip(a, b)) == t)
b = (4, 5, 6, 7)
@test (collect(zip(a, b)) == t)
@test (collect(zip(a, I())) == t)
@test (collect(zip()) == [])
@test (collect(zip([]...)) == [])
@test_throws
@test_throws
@test_throws
@test (collect(zip(SequenceWithoutALength(), 0:2^30)) == collect(enumerate(0:4)))
@test_throws
end

function test_zip_pickle(self::@like(BuiltinTest))
a = (1, 2, 3)
b = (4, 5, 6)
t = [(1, 4), (2, 5), (3, 6)]
for proto in 0:pickle.HIGHEST_PROTOCOL
z1 = zip(a, b)
check_iter_pickle(self, z1, t, proto)
end
end

function test_zip_pickle_strict(self::@like(BuiltinTest))
a = (1, 2, 3)
b = (4, 5, 6)
t = [(1, 4), (2, 5), (3, 6)]
for proto in 0:pickle.HIGHEST_PROTOCOL
z1 = zip(a, b)
check_iter_pickle(self, z1, t, proto)
end
end

function test_zip_pickle_strict_fail(self::@like(BuiltinTest))
a = (1, 2, 3)
b = (4, 5, 6, 7)
t = [(1, 4), (2, 5), (3, 6)]
for proto in 0:pickle.HIGHEST_PROTOCOL
z1 = zip(a, b)
z2 = pickle.loads(pickle.dumps(z1, proto))
@test (iter_error(self, z1, ValueError) == t)
@test (iter_error(self, z2, ValueError) == t)
end
end

function test_zip_bad_iterable(self::@like(BuiltinTest))
exception = TypeError()
@test_throws TypeError do cm 
zip(BadIterable())
end
@test self === cm.exception
end

function test_zip_strict(self::@like(BuiltinTest))
@test (tuple(zip((1, 2, 3), "abc")) == ((1, "a"), (2, "b"), (3, "c")))
@test_throws
@test_throws
@test_throws
end

function test_zip_strict_iterators(self::@like(BuiltinTest))
x = (x for x in 0:4)
y = [0]
z = (x for x in 0:4)
@test_throws
@test (next(x) == 2)
@test (next(z) == 1)
end

function test_zip_strict_error_handling(self::@like(BuiltinTest))
l1 = iter_error(self, zip(["A", "B"], Iter(1)), Error)
@test (l1 == [("A", 0)])
l2 = iter_error(self, zip(["A", "B"], Iter(2)), ValueError)
@test (l2 == [("A", 1, "A")])
l3 = iter_error(self, zip(["A", "B"], Iter(2)), Error)
@test (l3 == [("A", 1, "A"), ("B", 0, "B")])
l4 = iter_error(self, zip(["A", "B"], Iter(3)), ValueError)
@test (l4 == [("A", 2), ("B", 1)])
l5 = iter_error(self, zip(Iter(1), "AB"), Error)
@test (l5 == [(0, "A")])
l6 = iter_error(self, zip(Iter(2), "A"), ValueError)
@test (l6 == [(1, "A")])
l7 = iter_error(self, zip(Iter(2), "ABC"), Error)
@test (l7 == [(1, "A"), (0, "B")])
l8 = iter_error(self, zip(Iter(3), "AB"), ValueError)
@test (l8 == [(2, "A"), (1, "B")])
end

function test_zip_strict_error_handling_stopiteration(self::@like(BuiltinTest))
l1 = iter_error(self, zip(["A", "B"], Iter(1)), ValueError)
@test (l1 == [("A", 0)])
l2 = iter_error(self, zip(["A", "B"], Iter(2)), ValueError)
@test (l2 == [("A", 1, "A")])
l3 = iter_error(self, zip(["A", "B"], Iter(2)), ValueError)
@test (l3 == [("A", 1, "A"), ("B", 0, "B")])
l4 = iter_error(self, zip(["A", "B"], Iter(3)), ValueError)
@test (l4 == [("A", 2), ("B", 1)])
l5 = iter_error(self, zip(Iter(1), "AB"), ValueError)
@test (l5 == [(0, "A")])
l6 = iter_error(self, zip(Iter(2), "A"), ValueError)
@test (l6 == [(1, "A")])
l7 = iter_error(self, zip(Iter(2), "ABC"), ValueError)
@test (l7 == [(1, "A"), (0, "B")])
l8 = iter_error(self, zip(Iter(3), "AB"), ValueError)
@test (l8 == [(2, "A"), (1, "B")])
end

function test_zip_result_gc(self::@like(BuiltinTest))
it = zip([[]])
gc.collect()
@test gc.is_tracked(next(it))
end

function test_format(self::BuiltinTest)
@test (3 == "3")
function classes_new()
@oodef mutable struct A <: object
                    
                    
                    
function new(x)
@mk begin
x = x
end
end

                end
                function __format__(self::@like(A), format_spec)
return string(self.x) + format_spec
end


@oodef mutable struct DerivedFromA <: A
                    
                    
                    
function new(x = x)
x = x
new(x)
end

                end
                

@oodef mutable struct Simple <: object
                    
                    
                    
                end
                

@oodef mutable struct DerivedFromSimple <: Simple
                    
                    
                    
function new(x)
@mk begin
x = x
end
end

                end
                function __format__(self::@like(DerivedFromSimple), format_spec)
return string(self.x) + format_spec
end


@oodef mutable struct DerivedFromSimple2 <: DerivedFromSimple
                    
                    
                    
function new(x = x)
x = x
new(x)
end

                end
                

return (A, DerivedFromA, DerivedFromSimple, DerivedFromSimple2)
end

function class_test(A::BuiltinTest, DerivedFromA, DerivedFromSimple, DerivedFromSimple2)
@test (A(3) == "3spec")
@test (DerivedFromA(4) == "4spec")
@test (DerivedFromSimple(5) == "5abc")
@test (DerivedFromSimple2(10) == "10abcdef")
end

class_test(classes_new()...)
function empty_format_spec(value::BuiltinTest)
@test (value == string(value))
@test (value == string(value))
end

empty_format_spec(17^13)
empty_format_spec(1.0)
empty_format_spec(3.1415e+104)
empty_format_spec(-3.1415e+104)
empty_format_spec(3.1415e-104)
empty_format_spec(-3.1415e-104)
empty_format_spec(object)
empty_format_spec(nothing)
@test_throws
@test_throws
@test_throws
x = __format__(object(), "")
@test startswith(x, "<object object at")
@test_throws
@test_throws
@test_throws
@test (A() == "")
@test (A() == "")
@test (A() == "")
for cls in [object, B, C]
obj = cls()
@test (obj == string(obj))
@test (obj == string(obj))
assertRaisesRegex(self, TypeError, "\\b$(re.escape(cls.__name__))\\b") do 
obj
end
end
@test (0 == "         0")
end

function test_bin(self::BuiltinTest)
@test (bin(0) == "0b0")
@test (bin(1) == "0b1")
@test (bin(-1) == "-0b1")
@test (bin(2^65) == "0b1" * repeat("0",65))
@test (bin(2^65 - 1) == "0b" * repeat("1",65))
@test (bin(-(2^65)) == "-0b1" * repeat("0",65))
@test (bin(-(2^65 - 1)) == "-0b" * repeat("1",65))
end

function test_bytearray_translate(self::BuiltinTest)
x = Vector{UInt8}(b"abc")
@test_throws
@test_throws
end

function test_bytearray_extend_error(self::BuiltinTest)
array = Vector{UInt8}()
bad_iter = map(Int64, "X")
@test_throws
end

function test_construct_singletons(self::BuiltinTest)
for const_ in (nothing, Ellipsis, NotImplemented)
tp = type_(const_)
@test self === tp()
@test_throws
@test_throws
end
end

function test_warning_notimplemented(self::BuiltinTest)
assertWarns(self, DeprecationWarning, Bool, NotImplemented)
assertWarns(self, DeprecationWarning) do 
@test NotImplemented
end
assertWarns(self, DeprecationWarning) do 
@test !(!NotImplemented)
end
end


@oodef mutable struct TestBreakpoint <: unittest.TestCase
                    
                    env
resources
                    
function new(env = enter_context(self.resources, EnvironmentVarGuard()), resources = ExitStack())
env = env
resources = resources
new(env, resources)
end

                end
                function setUp(self::@like(TestBreakpoint))
self.resources = ExitStack()
addCleanup(self, self.resources.close)
self.env = enter_context(self.resources, EnvironmentVarGuard())
# Delete Unsupported
# del(self.env)
enter_context(self.resources, swap_attr(sys, "breakpointhook", sys.__breakpointhook__))
end

function test_breakpoint(self::@like(TestBreakpoint))
patch("pdb.set_trace") do mock 
breakpoint()
end
assert_called_once(mock)
end

function test_breakpoint_with_breakpointhook_set(self::@like(TestBreakpoint))
my_breakpointhook = MagicMock()
sys.breakpointhook = my_breakpointhook
breakpoint()
assert_called_once_with(my_breakpointhook)
end

function test_breakpoint_with_breakpointhook_reset(self::@like(TestBreakpoint))
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

function test_breakpoint_with_args_and_keywords(self::@like(TestBreakpoint))
my_breakpointhook = MagicMock()
sys.breakpointhook = my_breakpointhook
breakpoint(1, 2, 3, four = 4, five = 5)
assert_called_once_with(my_breakpointhook, 1, 2, 3, four = 4, five = 5)
end

function test_breakpoint_with_passthru_error(self::@like(TestBreakpoint))
function my_breakpointhook()
#= pass =#
end

sys.breakpointhook = my_breakpointhook
@test_throws
end

function test_envar_good_path_builtin(self::@like(TestBreakpoint))
self.env["PYTHONBREAKPOINT"] = "int"
patch("builtins.int") do mock 
breakpoint("7")
assert_called_once_with(mock, "7")
end
end

function test_envar_good_path_other(self::@like(TestBreakpoint))
self.env["PYTHONBREAKPOINT"] = "sys.exit"
patch("sys.exit") do mock 
breakpoint()
assert_called_once_with(mock)
end
end

function test_envar_good_path_noop_0(self::@like(TestBreakpoint))
self.env["PYTHONBREAKPOINT"] = "0"
patch("pdb.set_trace") do mock 
breakpoint()
assert_not_called(mock)
end
end

function test_envar_good_path_empty_string(self::@like(TestBreakpoint))
self.env["PYTHONBREAKPOINT"] = ""
patch("pdb.set_trace") do mock 
breakpoint()
assert_called_once_with(mock)
end
end

function test_envar_unimportable(self::@like(TestBreakpoint))
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

function test_envar_ignored_when_hook_is_set(self::@like(TestBreakpoint))
self.env["PYTHONBREAKPOINT"] = "sys.exit"
patch("sys.exit") do mock 
sys.breakpointhook = Int64
breakpoint()
assert_not_called(mock)
end
end


@oodef mutable struct PtyTests <: unittest.TestCase
                    #= Tests that use a pseudo terminal to guarantee stdin and stdout are
    terminals in the test environment =#

                    
                    
                end
                function handle_sighup(signum::@like(PtyTests), frame)
#= pass =#
end

function run_child(self::@like(PtyTests), child, terminal_input)
old_sighup = signal.signal(signal.SIGHUP, self.handle_sighup)
try
return _run_child(self, child, terminal_input)
finally
signal.signal(signal.SIGHUP, old_sighup)
end
end

function _run_child(self::@like(PtyTests), child, terminal_input)
(r, w) = os.pipe()
try
(pid, fd_) = pty.fork()
catch exn
 let e = exn
if e isa (OSError, AttributeError)
os.close(r)
os.close(w)
skipTest(self, "pty.fork() raised $(e)")
error()
end
end
end
if pid == 0
try
signal.alarm(2)
os.close(r)
readline(w) do wpipe 
child(wpipe)
end
catch exn
current_exceptions() != [] ? current_exceptions()[end] : nothing
finally
os._exit(0)
end
end
os.close(w)
os.write(fd_, terminal_input)
readline(r) do rpipe 
lines = []
while true
line = strip(readline(rpipe))
if line == ""
break;
end
push!(lines, line)
end
end
if length(lines) != 2
child_output = Vector{UInt8}()
while true
try
chunk = os.read(fd_, 3000)
catch exn
if exn isa OSError
break;
end
end
if !chunk
break;
end
extend(child_output, chunk)
end
os.close(fd_)
child_output = decode(child_output, "ascii", "ignore")
fail(self, "got $(length(lines)) lines in pipe but expected 2, child output was:\n$(child_output)")
end
os.close(fd_)
support.wait_process(pid, exitcode = 0)
return lines
end

function check_input_tty(self::@like(PtyTests), prompt, terminal_input, stdio_encoding = nothing)
if !sys.isatty()||!sys.isatty()
skipTest(self, "stdin and stdout must be ttys")
end
function child(wpipe::@like(PtyTests))
if stdio_encoding
sys.stdin = io.TextIOWrapper(sys.detach(), encoding = stdio_encoding, errors = "surrogateescape")
stdout = io.TextIOWrapper(sys.detach(), encoding = stdio_encoding, errors = "replace")
end
write(wpipe, "tty = $(sys.isatty()&&sys.isatty())")
write(wpipe, "ascii(input(prompt))")
end

lines = run_child(self, child, terminal_input + b"\r\n")
assertIn(self, lines[1], Set(["tty = True", "tty = False"]))
if lines[1] != "tty = True"
skipTest(self, "standard IO in should have been a tty")
end
input_result = py"lines[2]"
if stdio_encoding
expected = decode(terminal_input, stdio_encoding, "surrogateescape")
else
expected = decode(terminal_input, sys.stdin.encoding)
end
@test (input_result == expected)
end

function test_input_tty(self::@like(PtyTests))
check_input_tty(self, "prompt", b"quux")
end

function skip_if_readline(self::@like(PtyTests))
if "readline" ∈ sys.modules
skipTest(self, "the readline module is loaded")
end
end

function test_input_tty_non_ascii(self::@like(PtyTests))
skip_if_readline(self)
check_input_tty(self, "prompt\xe9", b"quux\xe9", "utf-8")
end

function test_input_tty_non_ascii_unicode_errors(self::@like(PtyTests))
skip_if_readline(self)
check_input_tty(self, "prompt\xe9", b"quux\xe9", "ascii")
end

function test_input_no_stdout_fileno(self::@like(PtyTests))
function child(wpipe::@like(PtyTests))
write(wpipe, "stdin.isatty(): sys.isatty()")
stdout = io.StringIO()
input("prompt")
write(wpipe, "captured: ascii(sys.getvalue())")
end

lines = run_child(self, child, b"quux\r")
expected = ("stdin.isatty(): True", "captured: \'prompt\'")
assertSequenceEqual(self, lines, expected)
end


@oodef mutable struct TestSorted <: unittest.TestCase
                    
                    
                    
                end
                function test_basic(self::@like(TestSorted))
data = collect(0:99)
copy_ = data[begin:end]
shuffle(copy_)
@test (data == sorted(copy_))
@test (data != copy)
reverse(data)
shuffle(copy_)
@test (data == sorted(copy_, key = (x) -> -x))
@test (data != copy)
shuffle(copy_)
@test (data == sorted(copy_, reverse = true))
@test (data != copy)
end

function test_bad_arguments(self::@like(TestSorted))
sorted([])
@test_throws TypeError do 
sorted(iterable = [])
end
sorted([], key = nothing)
@test_throws TypeError do 
sorted([], nothing)
end
end

function test_inputtypes(self::@like(TestSorted))
s = "abracadabra"
types = [Vector, Tuple, String]
for T in types
@test (sorted(s) == sorted(T(s)))
end
s = join(Set(s), "")
types = [String, set, pset, Vector, Tuple, dict.fromkeys]
for T in types
@test (sorted(s) == sorted(T(s)))
end
end

function test_baddecorator(self::@like(TestSorted))
data = split("The quick Brown fox Jumped over The lazy Dog")
@test_throws
end


@oodef mutable struct ShutdownTest <: unittest.TestCase
                    
                    
                    
                end
                function test_cleanup(self::@like(ShutdownTest))
code = "if 1:\n            import builtins\n            import sys\n\n            class C:\n                def __del__(self):\n                    print(\"before\")\n                    # Check that builtins still exist\n                    len(())\n                    print(\"after\")\n\n            c = C()\n            # Make this module survive until builtins and sys are cleaned\n            builtins.here = sys.modules[__name__]\n            sys.here = sys.modules[__name__]\n            # Create a reference loop so that this module needs to go\n            # through a GC phase.\n            here = sys.modules[__name__]\n            "
(rc, out, err) = assert_python_ok("-c", code, PYTHONIOENCODING = "ascii")
@test (["before", "after"] == splitlines(decode(out)))
end


@oodef mutable struct B
                    
                    
                    
                end
                function ham(self::@like(B))
return "ham$(self)"
end


@oodef mutable struct B
                    
                    
                    
                end
                

@oodef mutable struct TestType <: unittest.TestCase
                    
                    
                    
                end
                function test_new_type(self::@like(TestType))
A = type_("A", (), Dict())
@test (A.__name__ == "A")
@test (A.__qualname__ == "A")
@test (A.__module__ == __name__)
@test (A.__bases__ == (object,))
@test self === A.__base__
x = A()
@test self === type_(x)
@test self === x.__class__
C = type_("C", (B, Int64), Dict{str, Any}("spam" => (self) -> "spam$(self)"))
@test (C.__name__ == "C")
@test (C.__qualname__ == "C")
@test (C.__module__ == __name__)
@test (C.__bases__ == (B, Int64))
@test self === C.__base__
assertIn(self, "spam", C.__dict__)
assertNotIn(self, "ham", C.__dict__)
x = C(42)
@test (x == 42)
@test self === type_(x)
@test self === x.__class__
@test (ham(x) == "ham42")
@test (spam(x) == "spam42")
@test (to_bytes(x, 2, "little") == b"*\x00")
end

function test_type_nokwargs(self::@like(TestType))
@test_throws TypeError do 
type_("a", (), Dict(), x = 5)
end
@test_throws TypeError do 
type_("a", (), dict = Dict())
end
end

function test_type_name(self::@like(TestType))
for name in ("A", "Ä", "🐍", "B.A", "42", "")
subTest(self, name = name) do 
A = type_(name, (), Dict())
@test (A.__name__ == name)
@test (A.__qualname__ == name)
@test (A.__module__ == __name__)
end
end
@test_throws ValueError do 
type_("A\0B", (), Dict())
end
@test_throws ValueError do 
type_("A\udcdcB", (), Dict())
end
@test_throws TypeError do 
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
@test_throws ValueError do 
A.__name__ = "A\0B"
end
@test (A.__name__ == "C")
@test_throws ValueError do 
A.__name__ = "A\udcdcB"
end
@test (A.__name__ == "C")
@test_throws TypeError do 
A.__name__ = b"A"
end
@test (A.__name__ == "C")
end

function test_type_qualname(self::@like(TestType))
A = type_("A", (), Dict{str, str}("__qualname__" => "B.C"))
@test (A.__name__ == "A")
@test (A.__qualname__ == "B.C")
@test (A.__module__ == __name__)
@test_throws TypeError do 
type_("A", (), Dict{str, bytes}("__qualname__" => b"B"))
end
@test (A.__qualname__ == "B.C")
A.__qualname__ = "D.E"
@test (A.__name__ == "A")
@test (A.__qualname__ == "D.E")
@test_throws TypeError do 
A.__qualname__ = b"B"
end
@test (A.__qualname__ == "D.E")
end

function test_type_doc(self::@like(TestType))
for doc in ("x", "Ä", "🐍", "x\0y", b"x", 42, nothing)
A = type_("A", (), Dict{str, Any}("__doc__" => doc))
@test (A.__doc__ == doc)
end
@test_throws UnicodeEncodeError do 
type_("A", (), Dict{str, str}("__doc__" => "x\udcdcy"))
end
A = type_("A", (), Dict())
@test (A.__doc__ == nothing)
for doc in ("x", "Ä", "🐍", "x\0y", "x\udcdcy", b"x", 42, nothing)
A.__doc__ = doc
@test (A.__doc__ == doc)
end
end

function test_bad_args(self::@like(TestType))
@test_throws TypeError do 
type_()
end
@test_throws TypeError do 
type_("A", ())
end
@test_throws TypeError do 
type_("A", (), Dict(), ())
end
@test_throws TypeError do 
type_("A", (), dict = Dict())
end
@test_throws TypeError do 
type_("A", [], Dict())
end
@test_throws TypeError do 
type_("A", (), types.MappingProxyType(Dict()))
end
@test_throws TypeError do 
type_("A", (nothing,), Dict())
end
@test_throws TypeError do 
type_("A", (Bool,), Dict())
end
@test_throws TypeError do 
type_("A", (Int64, String), Dict())
end
end

function test_bad_slots(self::@like(TestType))
@test_throws TypeError do 
type_("A", (), Dict{str, bytes}("__slots__" => b"x"))
end
@test_throws TypeError do 
type_("A", (Int64,), Dict{str, str}("__slots__" => "x"))
end
@test_throws TypeError do 
type_("A", (), Dict{str, str}("__slots__" => ""))
end
@test_throws TypeError do 
type_("A", (), Dict{str, str}("__slots__" => "42"))
end
@test_throws TypeError do 
type_("A", (), Dict{str, str}("__slots__" => "x\0y"))
end
@test_throws ValueError do 
type_("A", (), Dict{str, Any}("__slots__" => "x", "x" => 0))
end
@test_throws TypeError do 
type_("A", (), Dict{str, Tuple[str]}("__slots__" => ("__dict__", "__dict__")))
end
@test_throws TypeError do 
type_("A", (), Dict{str, Tuple[str]}("__slots__" => ("__weakref__", "__weakref__")))
end
@test_throws TypeError do 
type_("A", (B,), Dict{str, str}("__slots__" => "__dict__"))
end
@test_throws TypeError do 
type_("A", (B,), Dict{str, str}("__slots__" => "__weakref__"))
end
end

function test_namespace_order(self::@like(TestType))
od = collections.OrderedDict([("a", 1), ("b", 2)])
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
end