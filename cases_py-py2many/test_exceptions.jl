# Transpiled with flags: 
# - oop
using ObjectOriented
using ResumableFunctions
using Test
import marshal
import _testcapi

using _testcapi: raise_memoryerror
import copy
import gc





import errno
using textwrap: dedent

using test.support.import_helper: import_module
using test.support.os_helper: TESTFN, unlink
using test.support.warnings_helper: check_warnings

@oodef mutable struct NaiveException <: Exception
                    
                    x
                    
function new(x)
@mk begin
x = x
end
end

                end
                

@oodef mutable struct SlottedNaiveException <: Exception
                    
                    x
                    
function new(x, __slots__::Tuple{String} = ("x",))
@mk begin
x = x
end
end

                end
                

@oodef mutable struct BrokenStrException <: Exception
                    
                    
                    
                end
                function __str__(self::@like(BrokenStrException))
throw(Exception("str() is broken"))
end


@resumable function yield_raise()
try
throw(KeyError("caught"))
catch exn
if exn isa KeyError
@yield sys.exc_info()[1]
@yield sys.exc_info()[1]
end
end
@yield sys.exc_info()[1]
end

@resumable function g()
@yield
end

@resumable function g()
try
@yield
catch exn
if exn isa ZeroDivisionError
@yield sys.exc_info()[2]
end
end
end

@resumable function g()
try
1 / 0
catch exn
if exn isa ZeroDivisionError
@yield sys.exc_info()[1]
error()
end
end
end

@resumable function g()
@test isa(self, sys.exc_info()[2])
@yield
@test (sys.exc_info() == (nothing, nothing, nothing))
end

@resumable function simple_gen()
@yield 1
end

@resumable function raising_gen()
try
throw(MyException(obj))
catch exn
if exn isa MyException
@yield
end
end
end

@resumable function main()
try
throw(MainError())
catch exn
if exn isa MainError
try
@yield
catch exn
if exn isa SubError
#= pass =#
end
end
error()
end
end
end

@resumable function g()
try
throw(ValueError)
catch exn
if exn isa ValueError
@yield 1
end
end
@test (sys.exc_info() == (nothing, nothing, nothing))
@yield 2
end

@resumable function g()
@yield 1
error()
@yield 2
end

@oodef mutable struct BadException <: Exception
                    
                    
                    
function new()
throw(ErrorException("can\'t instantiate BadException"))
@mk begin

end
end

                end
                

@oodef mutable struct InvalidException
                    
                    
                    
                end
                

@oodef mutable struct MyException <: Exception
                    
                    
                    
                end
                

@oodef mutable struct MyException <: OSError
                    
                    
                    
                end
                

@oodef mutable struct DerivedException <: BaseException
                    
                    fancy_arg
                    
function new(fancy_arg)
BaseException()
@mk begin
fancy_arg = fancy_arg
end
end

                end
                

@oodef mutable struct MyException <: Exception
                    
                    obj
                    
function new(obj)
@mk begin
obj = obj
end
end

                end
                

@oodef mutable struct MyObj
                    
                    
                    
                end
                

@oodef mutable struct Context
                    
                    
                    
                end
                function __enter__(self::@like(Context))
return self
end

function __exit__(self::@like(Context), exc_type, exc_value, exc_tb)::Bool
return true
end


@oodef mutable struct MyException <: Exception
                    
                    obj
                    
function new(obj)
@mk begin
obj = obj
end
end

                end
                

@oodef mutable struct MyObj
                    
                    
                    
                end
                

@oodef mutable struct MyObject
                    
                    
                    
                end
                function __del__(self::@like(MyObject))
# Not Supported
# nonlocal e
e = sys.exc_info()
end


@oodef mutable struct A <: Exception
                    
                    
                    
                end
                

@oodef mutable struct B <: Exception
                    
                    
                    
                end
                

@oodef mutable struct C <: Exception
                    
                    
                    
                end
                

@oodef mutable struct A <: Exception
                    
                    
                    
                end
                

@oodef mutable struct B <: Exception
                    
                    
                    
                end
                

@oodef mutable struct C <: Exception
                    
                    
                    
                end
                

@oodef mutable struct A <: Exception
                    
                    
                    
                end
                

@oodef mutable struct B <: Exception
                    
                    
                    
                end
                

@oodef mutable struct C <: Exception
                    
                    
                    
                end
                

@oodef mutable struct D <: Exception
                    
                    
                    
                end
                

@oodef mutable struct E <: Exception
                    
                    
                    
                end
                

@oodef mutable struct Meta <: type_
                    
                    
                    
                end
                function __subclasscheck__(cls::@like(Meta), subclass)
throw(ValueError())
end


@oodef mutable struct MyException <: Exception
                    
                    
                    
                end
                

@oodef mutable struct C <: object
                    
                    
                    
                end
                

@oodef mutable struct C
                    
                    
                    
                end
                

@oodef mutable struct C
                    
                    
                    
                end
                

@oodef mutable struct BrokenDel
                    
                    
                    
                end
                function __del__(self::@like(BrokenDel))
exc = ValueError("del is broken")
throw(exc)
end


@oodef mutable struct MainError <: Exception
                    
                    
                    
                end
                

@oodef mutable struct SubError <: Exception
                    
                    
                    
                end
                

@oodef mutable struct TestException <: MemoryError
                    
                    
                    
                end
                

@oodef mutable struct ExceptionTests <: unittest.TestCase
                    
                    
                    
                end
                function raise_catch(self::@like(ExceptionTests), exc, excname)
subTest(self, exc = exc, excname = excname) do 
try
throw(exc("spam"))
catch exn
 let err = exn
if err isa exc
buf1 = string(err)
end
end
end
try
throw(exc("spam"))
catch exn
 let err = exn
if err isa exc
buf2 = string(err)
end
end
end
@test (buf1 == buf2)
@test (exc.__name__ == excname)
end
end

function testRaising(self::@like(ExceptionTests))
raise_catch(self, AttributeError, "AttributeError")
@test_throws
raise_catch(self, EOFError, "EOFError")
fp = readline(TESTFN)
close(fp)
fp = readline(TESTFN)
savestdin = sys.stdin
try
try
marshal.loads(b"")
catch exn
if exn isa EOFError
#= pass =#
end
end
finally
sys.stdin = savestdin
close(fp)
unlink(TESTFN)
end
raise_catch(self, OSError, "OSError")
@test_throws
raise_catch(self, ImportError, "ImportError")
@test_throws
raise_catch(self, IndexError, "IndexError")
x = []
@test_throws
raise_catch(self, KeyError, "KeyError")
x = Dict()
@test_throws
raise_catch(self, KeyboardInterrupt, "KeyboardInterrupt")
raise_catch(self, MemoryError, "MemoryError")
raise_catch(self, NameError, "NameError")
try
x = undefined_variable
catch exn
if exn isa NameError
#= pass =#
end
end
raise_catch(self, OverflowError, "OverflowError")
x = 1
for dummy in 0:127
x += x
end
raise_catch(self, RuntimeError, "RuntimeError")
raise_catch(self, RecursionError, "RecursionError")
raise_catch(self, SyntaxError, "SyntaxError")
try
py""""/\n""""
catch exn
if exn isa SyntaxError
#= pass =#
end
end
raise_catch(self, IndentationError, "IndentationError")
raise_catch(self, TabError, "TabError")
try
compile("try:\n\t1/0\n    \t1/0\nfinally:\n pass\n", "<string>", "exec")
catch exn
if exn isa TabError
#= pass =#
end
end
raise_catch(self, SystemError, "SystemError")
raise_catch(self, SystemExit, "SystemExit")
@test_throws
raise_catch(self, TypeError, "TypeError")
try
[] + ()
catch exn
if exn isa TypeError
#= pass =#
end
end
raise_catch(self, ValueError, "ValueError")
@test_throws
raise_catch(self, ZeroDivisionError, "ZeroDivisionError")
try
x = 1 / 0
catch exn
if exn isa ZeroDivisionError
#= pass =#
end
end
raise_catch(self, Exception, "Exception")
try
x = 1 / 0
catch exn
 let e = exn
if e isa Exception
#= pass =#
end
end
end
raise_catch(self, StopAsyncIteration, "StopAsyncIteration")
end

function testSyntaxErrorMessage(self::@like(ExceptionTests))
function ckmsg(src::@like(ExceptionTests), msg)
subTest(self, src = src, msg = msg) do 
try
compile(src, "<fragment>", "exec")
catch exn
 let e = exn
if e isa SyntaxError
if e.msg != msg
fail(self, "expected $(msg), got $(e.msg)")
end
end
end
end
end
end

s = "if 1:\n        try:\n            continue\n        except:\n            pass"
ckmsg(s, "\'continue\' not properly in loop")
ckmsg("continue\n", "\'continue\' not properly in loop")
end

function testSyntaxErrorMissingParens(self::@like(ExceptionTests))
function ckmsg(src::@like(ExceptionTests), msg, exception = SyntaxError)
try
compile(src, "<fragment>", "exec")
catch exn
 let e = exn
if e isa exception
if e.msg != msg
fail(self, "expected $(msg), got $(e.msg)")
end
end
end
end
end

s = "print \"old style\""
ckmsg(s, "Missing parentheses in call to \'print\'. Did you mean print(...)?")
s = "print \"old style\","
ckmsg(s, "Missing parentheses in call to \'print\'. Did you mean print(...)?")
s = "print f(a+b,c)"
ckmsg(s, "Missing parentheses in call to \'print\'. Did you mean print(...)?")
s = "exec \"old style\""
ckmsg(s, "Missing parentheses in call to \'exec\'. Did you mean exec(...)?")
s = "exec f(a+b,c)"
ckmsg(s, "Missing parentheses in call to \'exec\'. Did you mean exec(...)?")
s = "print (a+b,c) \$ 42"
ckmsg(s, "invalid syntax")
s = "exec (a+b,c) \$ 42"
ckmsg(s, "invalid syntax")
s = "if True:\nprint \"No indent\""
ckmsg(s, "expected an indented block after \'if\' statement on line 1", IndentationError)
s = "if True:\n        print()\n\texec \"mixed tabs and spaces\""
ckmsg(s, "inconsistent use of tabs and spaces in indentation", TabError)
end

function check(self::@like(ExceptionTests), src, lineno, offset, encoding = "utf-8")
subTest(self, source = src, lineno = lineno, offset = offset) do 
@test_throws SyntaxError do cm 
compile(src, "<fragment>", "exec")
end
@test (cm.exception.lineno == lineno)
@test (cm.exception.offset == offset)
if cm.exception.text !== nothing
if !isa(src, String)
src = decode(src, encoding, "replace")
end
line = split(src, "\n")[lineno]
assertIn(self, line, cm.exception.text)
end
end
end

function test_error_offset_continuation_characters(self::@like(ExceptionTests))
check = self.check
check("\"\\\n\"(1 for c in I,\\\n\\", 2, 2)
end

function testSyntaxErrorOffset(self::@like(ExceptionTests))
check = self.check
check("def fact(x):\n\treturn x!\n", 2, 10)
check("1 +\n", 1, 4)
check("def spam():\n  print(1)\n print(2)", 3, 10)
check("Python = \"Python\" +", 1, 20)
check("Python = \"Ṕýţĥòñ\" +", 1, 20)
check(b"# -*- coding: cp1251 -*-\nPython = \"\xcf\xb3\xf2\xee\xed\" +", 2, 19, encoding = "cp1251")
check(b"Python = \"\xcf\xb3\xf2\xee\xed\" +", 1, 18)
check("x = \"a", 1, 5)
check("lambda x: x = 2", 1, 1)
check("f{a + b + c}", 1, 2)
check("[file for str(file) in []\n]", 1, 11)
check("a = « hello » « world »", 1, 5)
check("[\nfile\nfor str(file)\nin\n[]\n]", 3, 5)
check("[file for\n str(file) in []]", 2, 2)
check("ages = {\'Alice\'=22, \'Bob\'=23}", 1, 9)
check("match ...:\n    case {**rest, \"key\": value}:\n        ...", 2, 19)
check("[a b c d e f]", 1, 2)
check("for x yfff:", 1, 7)
check("class foo:return 1", 1, 11)
check("def f():\n  continue", 2, 3)
check("def f():\n  break", 2, 3)
check("try:\n  pass\nexcept:\n  pass\nexcept ValueError:\n  pass", 3, 1)
check("(0x+1)", 1, 3)
check("x = 0xI", 1, 6)
check("0010 + 2", 1, 1)
check("x = 32e-+4", 1, 8)
check("x = 0o9", 1, 7)
check("α = 0xI", 1, 6)
check(b"\xce\xb1 = 0xI", 1, 6)
check(b"# -*- coding: iso8859-7 -*-\n\xe1 = 0xI", 2, 6, encoding = "iso8859-7")
check(b"if 1:\n            def foo():\n                '''\n\n            def bar():\n                pass\n\n            def baz():\n                '''quux'''\n            ", 9, 24)
check("pass\npass\npass\n(1+)\npass\npass\npass", 4, 4)
check("(1+)", 1, 4)
check("[interesting\nfoo()\n", 1, 1)
check(b"\xef\xbb\xbf#coding: utf8\nprint('\xe6\x88\x91')\n", 0, -1)
check("f\'\'\'\n            {\n            (123_a)\n            }\'\'\'", 3, 17)
check("f\'\'\'\n            {\n            f\"\"\"\n            {\n            (123_a)\n            }\n            \"\"\"\n            }\'\'\'", 5, 17)
check("f\"\"\"\n\n\n            {\n            6\n            0=\"\"\"", 5, 13)
check("x = [(yield i) for i in range(3)]", 1, 7)
check("def f():\n  from _ import *", 2, 17)
check("def f(x, x):\n  pass", 1, 10)
check("{i for i in range(5) if (j := 0) for j in range(5)}", 1, 38)
check("def f(x):\n  nonlocal x", 2, 3)
check("def f(x):\n  x = 1\n  global x", 3, 3)
check("nonlocal x", 1, 1)
check("def f():\n  global x\n  nonlocal x", 2, 3)
check("from __future__ import doesnt_exist", 1, 1)
check("from __future__ import braces", 1, 1)
check("x=1\nfrom __future__ import division", 2, 1)
check("foo(1=2)", 1, 5)
check("def f():\n  x, y: int", 2, 3)
check("[*x for x in xs]", 1, 2)
check("foo(x for x in range(10), 100)", 1, 5)
check("for 1 in []: pass", 1, 5)
check("(yield i) = 2", 1, 2)
check("def f(*):\n  pass", 1, 7)
end

function testSettingException(self::@like(ExceptionTests))
function test_capi1()
try
_testcapi.raise_exception(BadException, 1)
catch exn
 let err = exn
if err isa TypeError
(exc, err, tb) = sys.exc_info()
co = tb.tb_frame.f_code
@test (co.co_name == "test_capi1")
@test endswith(co.co_filename, "test_exceptions.py")
end
end
end
end

function test_capi2()
try
_testcapi.raise_exception(BadException, 0)
catch exn
 let err = exn
if err isa RuntimeError
(exc, err, tb) = sys.exc_info()
co = tb.tb_frame.f_code
@test (co.co_name == "__init__")
@test endswith(co.co_filename, "test_exceptions.py")
co2 = tb.tb_frame.f_back.f_code
@test (co2.co_name == "test_capi2")
end
end
end
end

function test_capi3()
@test_throws
end

if !sys.startswith("java")
test_capi1()
test_capi2()
test_capi3()
end
end

function test_WindowsError(self::@like(ExceptionTests))
try
WindowsError
catch exn
if exn isa NameError
#= pass =#
end
end
end

function test_windows_message(self::@like(ExceptionTests))
#= Should fill in unknown error code in Windows error message =#
ctypes = import_module("ctypes")
code = 3765269347
assertRaisesRegex(self, OSError, "Windows Error 0x$(code)") do 
PyErr_SetFromWindowsErr(ctypes.pythonapi, code)
end
end

function testAttributes(self::@like(ExceptionTests))
exceptionList = [(BaseException, (), Dict{str, Tuple}("args" => ())), (BaseException, (1,), Dict{str, Tuple[int]}("args" => (1,))), (BaseException, ("foo",), Dict{str, Tuple[str]}("args" => ("foo",))), (BaseException, ("foo", 1), Dict{str, Any}("args" => ("foo", 1))), (SystemExit, ("foo",), Dict{str, Any}("args" => ("foo",), "code" => "foo")), (OSError, ("foo",), Dict{str, Any}("args" => ("foo",), "filename" => nothing, "filename2" => nothing, "errno" => nothing, "strerror" => nothing)), (OSError, ("foo", "bar"), Dict{str, Any}("args" => ("foo", "bar"), "filename" => nothing, "filename2" => nothing, "errno" => "foo", "strerror" => "bar")), (OSError, ("foo", "bar", "baz"), Dict{str, Any}("args" => ("foo", "bar"), "filename" => "baz", "filename2" => nothing, "errno" => "foo", "strerror" => "bar")), (OSError, ("foo", "bar", "baz", nothing, "quux"), Dict{str, Any}("args" => ("foo", "bar"), "filename" => "baz", "filename2" => "quux")), (OSError, ("errnoStr", "strErrorStr", "filenameStr"), Dict{str, Any}("args" => ("errnoStr", "strErrorStr"), "strerror" => "strErrorStr", "errno" => "errnoStr", "filename" => "filenameStr")), (OSError, (1, "strErrorStr", "filenameStr"), Dict{str, Any}("args" => (1, "strErrorStr"), "errno" => 1, "strerror" => "strErrorStr", "filename" => "filenameStr", "filename2" => nothing)), (SyntaxError, (), Dict{str, Any}("msg" => nothing, "text" => nothing, "filename" => nothing, "lineno" => nothing, "offset" => nothing, "end_offset" => nothing, "print_file_and_line" => nothing)), (SyntaxError, ("msgStr",), Dict{str, Any}("args" => ("msgStr",), "text" => nothing, "print_file_and_line" => nothing, "msg" => "msgStr", "filename" => nothing, "lineno" => nothing, "offset" => nothing, "end_offset" => nothing)), (SyntaxError, ("msgStr", ("filenameStr", "linenoStr", "offsetStr", "textStr", "endLinenoStr", "endOffsetStr")), Dict{str, Any}("offset" => "offsetStr", "text" => "textStr", "args" => ("msgStr", ("filenameStr", "linenoStr", "offsetStr", "textStr", "endLinenoStr", "endOffsetStr")), "print_file_and_line" => nothing, "msg" => "msgStr", "filename" => "filenameStr", "lineno" => "linenoStr", "end_lineno" => "endLinenoStr", "end_offset" => "endOffsetStr")), (SyntaxError, ("msgStr", "filenameStr", "linenoStr", "offsetStr", "textStr", "endLinenoStr", "endOffsetStr", "print_file_and_lineStr"), Dict{str, Any}("text" => nothing, "args" => ("msgStr", "filenameStr", "linenoStr", "offsetStr", "textStr", "endLinenoStr", "endOffsetStr", "print_file_and_lineStr"), "print_file_and_line" => nothing, "msg" => "msgStr", "filename" => nothing, "lineno" => nothing, "offset" => nothing, "end_lineno" => nothing, "end_offset" => nothing)), (UnicodeError, (), Dict{str, Tuple}("args" => ())), (UnicodeEncodeError, ("ascii", "a", 0, 1, "ordinal not in range"), Dict{str, Any}("args" => ("ascii", "a", 0, 1, "ordinal not in range"), "encoding" => "ascii", "object" => "a", "start" => 0, "reason" => "ordinal not in range")), (UnicodeDecodeError, ("ascii", Vector{UInt8}(b"\xff"), 0, 1, "ordinal not in range"), Dict{str, Any}("args" => ("ascii", Vector{UInt8}(b"\xff"), 0, 1, "ordinal not in range"), "encoding" => "ascii", "object" => b"\xff", "start" => 0, "reason" => "ordinal not in range")), (UnicodeDecodeError, ("ascii", b"\xff", 0, 1, "ordinal not in range"), Dict{str, Any}("args" => ("ascii", b"\xff", 0, 1, "ordinal not in range"), "encoding" => "ascii", "object" => b"\xff", "start" => 0, "reason" => "ordinal not in range")), (UnicodeTranslateError, ("あ", 0, 1, "ouch"), Dict{str, Any}("args" => ("あ", 0, 1, "ouch"), "object" => "あ", "reason" => "ouch", "start" => 0, "end" => 1)), (NaiveException, ("foo",), Dict{str, Any}("args" => ("foo",), "x" => "foo")), (SlottedNaiveException, ("foo",), Dict{str, Any}("args" => ("foo",), "x" => "foo"))]
try
push!(exceptionList, (WindowsError, (1, "strErrorStr", "filenameStr"), Dict{str, Any}("args" => (1, "strErrorStr"), "strerror" => "strErrorStr", "winerror" => nothing, "errno" => 1, "filename" => "filenameStr", "filename2" => nothing)))
catch exn
if exn isa NameError
#= pass =#
end
end
for (exc, args, expected) in exceptionList
try
e = exc(args...)
catch exn
write(sys.stderr, "\nexc=$(exc), args=$(args)")
end
end
end

function testWithTraceback(self::@like(ExceptionTests))
try
throw(IndexError(4))
catch exn
tb = sys.exc_info()[3]
end
e = with_traceback(BaseException(), tb)
@test isa(self, e)
@test (e.__traceback__ == tb)
e = with_traceback(IndexError(5), tb)
@test isa(self, e)
@test (e.__traceback__ == tb)
e = with_traceback(MyException(), tb)
@test isa(self, e)
@test (e.__traceback__ == tb)
end

function testInvalidTraceback(self::@like(ExceptionTests))
try
Exception().__traceback__ = 5
catch exn
 let e = exn
if e isa TypeError
assertIn(self, "__traceback__ must be a traceback", string(e))
end
end
end
end

function testInvalidAttrs(self::@like(ExceptionTests))
@test_throws
@test_throws
@test_throws
@test_throws
end

function testNoneClearsTracebackAttr(self::@like(ExceptionTests))
try
throw(IndexError(4))
catch exn
tb = sys.exc_info()[3]
end
e = Exception()
e.__traceback__ = tb
e.__traceback__ = nothing
@test (e.__traceback__ == nothing)
end

function testChainingAttrs(self::@like(ExceptionTests))
e = Exception()
assertIsNone(self, e.__context__)
assertIsNone(self, e.__cause__)
e = TypeError()
assertIsNone(self, e.__context__)
assertIsNone(self, e.__cause__)
e = MyException()
assertIsNone(self, e.__context__)
assertIsNone(self, e.__cause__)
end

function testChainingDescriptors(self::@like(ExceptionTests))
try
throw(Exception())
catch exn
 let exc = exn
if exc isa Exception
e = exc
end
end
end
assertIsNone(self, e.__context__)
assertIsNone(self, e.__cause__)
@test !(e.__suppress_context__)
e.__context__ = NameError()
e.__cause__ = nothing
@test isa(self, e.__context__)
assertIsNone(self, e.__cause__)
@test e.__suppress_context__
e.__suppress_context__ = false
@test !(e.__suppress_context__)
end

function testKeywordArgs(self::@like(ExceptionTests))
@test_throws
x = DerivedException(fancy_arg = 42)
@test (x.fancy_arg == 42)
end

function testInfiniteRecursion(self::@like(ExceptionTests))
function f()
return f()
end

@test_throws
function g()::Int64
try
return g()
catch exn
if exn isa ValueError
return -1
end
end
end

@test_throws
end

function test_str(self::@like(ExceptionTests))
@test string(Exception)
@test string(Exception("a"))
@test string(Exception("a", "b"))
end

function test_exception_cleanup_names(self::@like(ExceptionTests))
try
throw(Exception())
catch exn
 let e = exn
if e isa Exception
@test isa(self, e)
end
end
end
assertNotIn(self, "e", locals())
@test_throws UnboundLocalError do 
e
end
end

function test_exception_cleanup_names2(self::@like(ExceptionTests))
try
throw(Exception())
catch exn
 let e = exn
if e isa Exception
@test isa(self, e)
# Delete Unsupported
# del(e)
end
end
end
assertNotIn(self, "e", locals())
@test_throws UnboundLocalError do 
e
end
end

function testExceptionCleanupState(self::@like(ExceptionTests))
function inner_raising_func()
local_ref = obj
throw(MyException(obj))
end

obj = MyObj()
wr = weakref.ref(obj)
try
inner_raising_func()
catch exn
 let e = exn
if e isa MyException
#= pass =#
end
end
end
obj = nothing
gc_collect()
obj = wr()
assertIsNone(self, obj)
obj = MyObj()
wr = weakref.ref(obj)
try
inner_raising_func()
catch exn
if exn isa MyException
#= pass =#
end
end
obj = nothing
gc_collect()
obj = wr()
assertIsNone(self, obj)
obj = MyObj()
wr = weakref.ref(obj)
try
inner_raising_func()
catch exn
#= pass =#
end
obj = nothing
gc_collect()
obj = wr()
assertIsNone(self, obj)
obj = MyObj()
wr = weakref.ref(obj)
for i in [0]
try
inner_raising_func()
catch exn
break;
end
end
obj = nothing
gc_collect()
obj = wr()
assertIsNone(self, obj)
obj = MyObj()
wr = weakref.ref(obj)
try
try
inner_raising_func()
catch exn
throw(KeyError)
end
catch exn
 let e = exn
if e isa KeyError
e.__context__ = nothing
obj = nothing
gc_collect()
obj = wr()
if check_impl_detail(cpython = false)
gc_collect()
end
assertIsNone(self, obj)
end
end
end
obj = MyObj()
wr = weakref.ref(obj)
try
inner_raising_func()
catch exn
if exn isa MyException
try
try
error()
finally
error()
end
catch exn
if exn isa MyException
#= pass =#
end
end
end
end
obj = nothing
if check_impl_detail(cpython = false)
gc_collect()
end
obj = wr()
assertIsNone(self, obj)
obj = MyObj()
wr = weakref.ref(obj)
Context() do 
inner_raising_func()
end
obj = nothing
if check_impl_detail(cpython = false)
gc_collect()
end
obj = wr()
assertIsNone(self, obj)
end

function test_exception_target_in_nested_scope(self::@like(ExceptionTests))
function print_error()
e
end

try
something
catch exn
 let e = exn
if e isa Exception
print_error()
end
end
end
end

@resumable function test_generator_leaking(self::@like(ExceptionTests))
g = yield_raise()
@test (next(g) == KeyError)
@test (sys.exc_info()[1] == nothing)
@test (next(g) == KeyError)
@test (sys.exc_info()[1] == nothing)
@test (next(g) == nothing)
try
throw(TypeError("foo"))
catch exn
if exn isa TypeError
g = yield_raise()
@test (next(g) == KeyError)
@test (sys.exc_info()[1] == TypeError)
@test (next(g) == KeyError)
@test (sys.exc_info()[1] == TypeError)
@test (next(g) == TypeError)
# Delete Unsupported
# del(g)
@test (sys.exc_info()[1] == TypeError)
end
end
end

@resumable function test_generator_leaking2(self::@like(ExceptionTests))
try
throw(RuntimeError)
catch exn
if exn isa RuntimeError
it = g()
next(it)
end
end
try
next(it)
catch exn
if exn isa StopIteration
#= pass =#
end
end
@test (sys.exc_info() == (nothing, nothing, nothing))
end

@resumable function test_generator_leaking3(self::@like(ExceptionTests))
it = g()
next(it)
try
1 / 0
catch exn
 let e = exn
if e isa ZeroDivisionError
@test self === sys.exc_info()[2]
gen_exc = throw(it, e)
@test self === sys.exc_info()[2]
@test self === gen_exc
end
end
end
@test (sys.exc_info() == (nothing, nothing, nothing))
end

@resumable function test_generator_leaking4(self::@like(ExceptionTests))
it = g()
try
throw(TypeError)
catch exn
if exn isa TypeError
tp = next(it)
end
end
@test self === tp
try
next(it)
catch exn
 let e = exn
if e isa ZeroDivisionError
@test self === sys.exc_info()[2]
end
end
end
@test (sys.exc_info() == (nothing, nothing, nothing))
end

@resumable function test_generator_doesnt_retain_old_exc(self::@like(ExceptionTests))
it = g()
try
throw(RuntimeError)
catch exn
if exn isa RuntimeError
next(it)
end
end
@test_throws
end

function test_generator_finalizing_and_exc_info(self::@like(ExceptionTests))
function run_gen()
gen = simple_gen()
try
throw(RuntimeError)
catch exn
if exn isa RuntimeError
return gen()
end
end
end

run_gen()
gc_collect()
@test (sys.exc_info() == (nothing, nothing, nothing))
end

@resumable function _check_generator_cleanup_exc_state(self::@like(ExceptionTests), testfunc)
obj = MyObj()
wr = weakref.ref(obj)
g = raising_gen()
next(g)
testfunc(g)
g=obj = nothing
gc_collect()
obj = wr()
assertIsNone(self, obj)
end

function test_generator_throw_cleanup_exc_state(self::@like(ExceptionTests))
function do_throw(g::@like(ExceptionTests))
try
throw(g, ErrorException())
catch exn
if exn isa RuntimeError
#= pass =#
end
end
end

_check_generator_cleanup_exc_state(self, do_throw)
end

function test_generator_close_cleanup_exc_state(self::@like(ExceptionTests))
function do_close(g::@like(ExceptionTests))
close(g)
end

_check_generator_cleanup_exc_state(self, do_close)
end

function test_generator_del_cleanup_exc_state(self::@like(ExceptionTests))
function do_del(g::@like(ExceptionTests))
g = nothing
end

_check_generator_cleanup_exc_state(self, do_del)
end

function test_generator_next_cleanup_exc_state(self::@like(ExceptionTests))
function do_next(g::@like(ExceptionTests))
try
next(g)
catch exn
if exn isa StopIteration
#= pass =#
end
end
end

_check_generator_cleanup_exc_state(self, do_next)
end

function test_generator_send_cleanup_exc_state(self::@like(ExceptionTests))
function do_send(g::@like(ExceptionTests))
try
send(g, nothing)
catch exn
if exn isa StopIteration
#= pass =#
end
end
end

_check_generator_cleanup_exc_state(self, do_send)
end

function test_3114(self::@like(ExceptionTests))
e = ()
try
throw(Exception(MyObject()))
catch exn
#= pass =#
end
gc_collect()
@test (e == (nothing, nothing, nothing))
end

function test_raise_does_not_create_context_chain_cycle(self::@like(ExceptionTests))
try
try
throw(A)
catch exn
 let a_ = exn
if a_ isa A
a = a_
try
throw(B)
catch exn
 let b_ = exn
if b_ isa B
b = b_
try
throw(C)
catch exn
 let c_ = exn
if c_ isa C
c = c_
@test isa(self, a)
@test isa(self, b)
@test isa(self, c)
assertIsNone(self, a.__context__)
@test self === b.__context__
@test self === c.__context__
throw(a)
end
end
end
end
end
end
end
end
end
catch exn
 let e = exn
if e isa A
exc = e
end
end
end
@test self === exc
@test self === a.__context__
@test self === c.__context__
assertIsNone(self, b.__context__)
end

function test_no_hang_on_context_chain_cycle1(self::@like(ExceptionTests))
function cycle()
try
throw(ValueError(1))
catch exn
 let ex = exn
if ex isa ValueError
ex.__context__ = ex
throw(TypeError(2))
end
end
end
end

try
cycle()
catch exn
 let e = exn
if e isa Exception
exc = e
end
end
end
@test isa(self, exc)
@test isa(self, exc.__context__)
@test self === exc.__context__.__context__
end

function test_no_hang_on_context_chain_cycle2(self::@like(ExceptionTests))
@test_throws C do cm 
try
throw(A())
catch exn
 let _a = exn
if _a isa A
a = _a
try
throw(B())
catch exn
 let _b = exn
if _b isa B
b = _b
try
throw(C())
catch exn
 let _c = exn
if _c isa C
c = _c
a.__context__ = c
throw(c)
end
end
end
end
end
end
end
end
end
end
@test self === cm.exception
@test self === c.__context__
@test self === b.__context__
@test self === a.__context__
end

function test_no_hang_on_context_chain_cycle3(self::@like(ExceptionTests))
@test_throws E do cm 
try
throw(A())
catch exn
 let _a = exn
if _a isa A
a = _a
try
throw(B())
catch exn
 let _b = exn
if _b isa B
b = _b
try
throw(C())
catch exn
 let _c = exn
if _c isa C
c = _c
a.__context__ = c
try
throw(D())
catch exn
 let _d = exn
if _d isa D
d = _d
e = E()
throw(e)
end
end
end
end
end
end
end
end
end
end
end
end
end
@test self === cm.exception
@test self === e.__context__
@test self === d.__context__
@test self === c.__context__
@test self === b.__context__
@test self === a.__context__
end

function test_unicode_change_attributes(self::@like(ExceptionTests))
u = UnicodeEncodeError("baz", "xxxxx", 1, 5, "foo")
@test (string(u) == "\'baz\' codec can\'t encode characters in position 1-4: foo")
u.end = 2
@test (string(u) == "\'baz\' codec can\'t encode character \'\\x78\' in position 1: foo")
u.end = 5
u.reason = 965230951443685724997
@test (string(u) == "\'baz\' codec can\'t encode characters in position 1-4: 965230951443685724997")
u.encoding = 4000
@test (string(u) == "\'4000\' codec can\'t encode characters in position 1-4: 965230951443685724997")
u.start = 1000
@test (string(u) == "\'4000\' codec can\'t encode characters in position 1000-4: 965230951443685724997")
u = UnicodeDecodeError("baz", b"xxxxx", 1, 5, "foo")
@test (string(u) == "\'baz\' codec can\'t decode bytes in position 1-4: foo")
u.end = 2
@test (string(u) == "\'baz\' codec can\'t decode byte 0x78 in position 1: foo")
u.end = 5
u.reason = 965230951443685724997
@test (string(u) == "\'baz\' codec can\'t decode bytes in position 1-4: 965230951443685724997")
u.encoding = 4000
@test (string(u) == "\'4000\' codec can\'t decode bytes in position 1-4: 965230951443685724997")
u.start = 1000
@test (string(u) == "\'4000\' codec can\'t decode bytes in position 1000-4: 965230951443685724997")
u = UnicodeTranslateError("xxxx", 1, 5, "foo")
@test (string(u) == "can\'t translate characters in position 1-4: foo")
u.end = 2
@test (string(u) == "can\'t translate character \'\\x78\' in position 1: foo")
u.end = 5
u.reason = 965230951443685724997
@test (string(u) == "can\'t translate characters in position 1-4: 965230951443685724997")
u.start = 1000
@test (string(u) == "can\'t translate characters in position 1000-4: 965230951443685724997")
end

function test_unicode_errors_no_object(self::@like(ExceptionTests))
klasses = (UnicodeEncodeError, UnicodeDecodeError, UnicodeTranslateError)
for klass in klasses
@test (string(__new__(klass, klass)) == "")
end
end

function test_badisinstance(self::@like(ExceptionTests))
captured_stderr() do stderr 
try
throw(KeyError())
catch exn
 let e = exn
if e isa MyException
fail(self, "exception should not be a MyException")
end
end
if exn isa KeyError
#= pass =#
end
fail(self, "Should have raised KeyError")
end
end
function g()
try
return g()
catch exn
if exn isa RecursionError
return sys.exc_info()
end
end
end

(e, v, tb) = g()
@test isa(self, v)
assertIn(self, "maximum recursion depth exceeded", string(v))
end

function test_trashcan_recursion(self::@like(ExceptionTests))
function foo()
o = object()
for x in 0:999999
o = o.__dir__
end
end

foo()
support.gc_collect()
end

function test_recursion_normalizing_exception(self::@like(ExceptionTests))
code = "if 1:\n            import sys\n            from _testinternalcapi import get_recursion_depth\n\n            class MyException(Exception): pass\n\n            def setrecursionlimit(depth):\n                while 1:\n                    try:\n                        sys.setrecursionlimit(depth)\n                        return depth\n                    except RecursionError:\n                        # sys.setrecursionlimit() raises a RecursionError if\n                        # the new recursion limit is too low (issue #25274).\n                        depth += 1\n\n            def recurse(cnt):\n                cnt -= 1\n                if cnt:\n                    recurse(cnt)\n                else:\n                    generator.throw(MyException)\n\n            def gen():\n                f = open($(@__FILE__), mode=\'rb\', buffering=0)\n                yield\n\n            generator = gen()\n            next(generator)\n            recursionlimit = sys.getrecursionlimit()\n            depth = get_recursion_depth()\n            try:\n                # Upon the last recursive invocation of recurse(),\n                # tstate->recursion_depth is equal to (recursion_limit - 1)\n                # and is equal to recursion_limit when _gen_throw() calls\n                # PyErr_NormalizeException().\n                recurse(setrecursionlimit(depth + 2) - depth)\n            finally:\n                sys.setrecursionlimit(recursionlimit)\n                print(\'Done.\')\n        "
(rc, out, err) = script_helper.assert_python_failure("-Wd", "-c", code)
@test (rc == 1)
assertIn(self, b"RecursionError", err)
assertIn(self, b"ResourceWarning", err)
assertIn(self, b"Done.", out)
end

function test_recursion_normalizing_infinite_exception(self::@like(ExceptionTests))
code = "if 1:\n            import _testcapi\n            try:\n                raise _testcapi.RecursingInfinitelyError\n            finally:\n                print(\'Done.\')\n        "
(rc, out, err) = script_helper.assert_python_failure("-c", code)
@test (rc == 1)
assertIn(self, b"RecursionError: maximum recursion depth exceeded while normalizing an exception", err)
assertIn(self, b"Done.", out)
end

function test_recursion_in_except_handler(self::@like(ExceptionTests))
function set_relative_recursion_limit(n::@like(ExceptionTests))
depth = 1
while true
try
sys.setrecursionlimit(depth)
catch exn
if exn isa RecursionError
depth += 1
end
end
end
sys.setrecursionlimit(depth + n)
end

function recurse_in_except()
try
1 / 0
catch exn
recurse_in_except()
end
end

function recurse_after_except()
try
1 / 0
catch exn
#= pass =#
end
recurse_after_except()
end

function recurse_in_body_and_except()
try
recurse_in_body_and_except()
catch exn
recurse_in_body_and_except()
end
end

recursionlimit = sys.getrecursionlimit()
try
set_relative_recursion_limit(10)
for func in (recurse_in_except, recurse_after_except, recurse_in_body_and_except)
subTest(self, func = func) do 
try
func()
catch exn
if exn isa RecursionError
#= pass =#
end
end
end
end
finally
sys.setrecursionlimit(recursionlimit)
end
end

function test_recursion_normalizing_with_no_memory(self::@like(ExceptionTests))
code = "if 1:\n            import _testcapi\n            class C(): pass\n            def recurse(cnt):\n                cnt -= 1\n                if cnt:\n                    recurse(cnt)\n                else:\n                    _testcapi.set_nomemory(0)\n                    C()\n            recurse(16)\n        "
SuppressCrashReport() do 
(rc, out, err) = script_helper.assert_python_failure("-c", code)
assertIn(self, b"Fatal Python error: _PyErr_NormalizeException: Cannot recover from MemoryErrors while normalizing exceptions.", err)
end
end

function test_MemoryError(self::@like(ExceptionTests))
function raiseMemError()
try
raise_memoryerror()
catch exn
 let e = exn
if e isa MemoryError
tb = e.__traceback__
end
end
end
return traceback.format_tb(tb)
end

tb1 = raiseMemError()
tb2 = raiseMemError()
@test (tb1 == tb2)
end

function test_exception_with_doc(self::@like(ExceptionTests))
doc2 = "This is a test docstring."
doc4 = "This is another test docstring."
@test_throws
error1 = _testcapi.make_exception_with_doc("_testcapi.error1")
@test self === type_(error1)
@test error1 <: Exception
assertIsNone(self, error1.__doc__)
error2 = _testcapi.make_exception_with_doc("_testcapi.error2", doc2)
@test (error2.__doc__ == doc2)
error3 = _testcapi.make_exception_with_doc("_testcapi.error3", base = error2)
@test error3 <: error2
error4 = _testcapi.make_exception_with_doc("_testcapi.error4", doc4, (error3, C))
@test error4 <: error3
@test error4 <: C
@test (error4.__doc__ == doc4)
error5 = _testcapi.make_exception_with_doc("_testcapi.error5", "", error4, Dict{str, int}("a" => 1))
@test error5 <: error4
@test (error5.a == 1)
@test (error5.__doc__ == "")
end

function test_memory_error_cleanup(self::@like(ExceptionTests))
wr = nothing
function inner()
# Not Supported
# nonlocal wr
c = C()
wr = weakref.ref(c)
raise_memoryerror()
end

try
inner()
catch exn
 let e = exn
if e isa MemoryError
@test (wr() != nothing)
end
end
end
gc_collect()
@test (wr() == nothing)
end

function test_recursion_error_cleanup(self::@like(ExceptionTests))
wr = nothing
function inner()
# Not Supported
# nonlocal wr
c = C()
wr = weakref.ref(c)
inner()
end

try
inner()
catch exn
 let e = exn
if e isa RecursionError
@test (wr() != nothing)
end
end
end
gc_collect()
@test (wr() == nothing)
end

function test_errno_ENOTDIR(self::@like(ExceptionTests))
@test_throws OSError do cm 
os.listdir(@__FILE__)
end
@test (cm.exception.errno == errno.ENOTDIR)
end

function test_unraisable(self::@like(ExceptionTests))
obj = BrokenDel()
support.catch_unraisable_exception() do cm 
# Delete Unsupported
# del(obj)
gc_collect()
@test (cm.unraisable.object == BrokenDel.__del__)
assertIsNotNone(self, cm.unraisable.exc_traceback)
end
end

function test_unhandled(self::@like(ExceptionTests))
for exc_type in (ValueError, BrokenStrException)
subTest(self, exc_type) do 
try
exc = exc_type("test message")
throw(exc)
catch exn
if exn isa exc_type
captured_stderr() do stderr 
sys.__excepthook__(sys.exc_info()...)
end
end
end
report = getvalue(stderr)
assertIn(self, "test_exceptions.py", report)
assertIn(self, "raise exc", report)
assertIn(self, exc_type.__name__, report)
if exc_type === BrokenStrException
assertIn(self, "<exception str() failed>", report)
else
assertIn(self, "test message", report)
end
@test endswith(report, "\n")
end
end
end

function test_memory_error_in_PyErr_PrintEx(self::@like(ExceptionTests))
code = "if 1:\n            import _testcapi\n            class C(): pass\n            _testcapi.set_nomemory(0, %d)\n            C()\n        "
for i in 1:19
(rc, out, err) = script_helper.assert_python_failure("-c", code % i)
assertIn(self, rc, (1, 120))
assertIn(self, b"MemoryError", err)
end
end

@resumable function test_yield_in_nested_try_excepts(self::@like(ExceptionTests))
coro = main()
send(coro, nothing)
@test_throws MainError do 
throw(coro, SubError())
end
end

@resumable function test_generator_doesnt_retain_old_exc2(self::@like(ExceptionTests))
gen = g()
try
throw(IndexError)
catch exn
if exn isa IndexError
@test (next(gen) == 1)
end
end
@test (next(gen) == 2)
end

@resumable function test_raise_in_generator(self::@like(ExceptionTests))
@test_throws ZeroDivisionError do 
i = g()
try
1 / 0
catch exn
next(i)
next(i)
end
end
end

function test_assert_shadowing(self::@like(ExceptionTests))
global AssertionError
AssertionError = TypeError
try
@assert(false)
catch exn
 let e = exn
if e isa BaseException
# Delete Unsupported
# del(AssertionError)
@test isa(self, e)
@test (string(e) == "hello")
end
end
end
end

function test_memory_error_subclasses(self::@like(ExceptionTests))
try
throw(MemoryError)
catch exn
 let exc = exn
if exc isa MemoryError
inst = exc
end
end
end
try
throw(TestException)
catch exn
if exn isa Exception
#= pass =#
end
end
for _ in 0:9
try
throw(MemoryError)
catch exn
 let exc = exn
if exc isa MemoryError
#= pass =#
end
end
end
gc_collect()
end
end


global_for_suggestions = nothing
@oodef mutable struct NameErrorTests <: unittest.TestCase
                    
                    
                    
                end
                function test_name_error_has_name(self::@like(NameErrorTests))
try
bluch
catch exn
 let exc = exn
if exc isa NameError
@test ("bluch" == exc.name)
end
end
end
end

function test_name_error_suggestions(self::@like(NameErrorTests))
function Substitution()
noise=more_noise=a=bc = nothing
blech = nothing
println(bluch)
end

function Elimination()
noise=more_noise=a=bc = nothing
blch = nothing
println(bluch)
end

function Addition()
noise=more_noise=a=bc = nothing
bluchin = nothing
println(bluch)
end

function SubstitutionOverElimination()
blach = nothing
bluc = nothing
println(bluch)
end

function SubstitutionOverAddition()
blach = nothing
bluchi = nothing
println(bluch)
end

function EliminationOverAddition()
blucha = nothing
bluc = nothing
println(bluch)
end

for (func, suggestion) in [(Substitution, "\'blech\'?"), (Elimination, "\'blch\'?"), (Addition, "\'bluchin\'?"), (EliminationOverAddition, "\'blucha\'?"), (SubstitutionOverElimination, "\'blach\'?"), (SubstitutionOverAddition, "\'blach\'?")]
err = nothing
try
func()
catch exn
 let exc = exn
if exc isa NameError
support.captured_stderr() do err 
sys.__excepthook__(sys.exc_info()...)
end
end
end
end
assertIn(self, suggestion, getvalue(err))
end
end

function test_name_error_suggestions_from_globals(self::@like(NameErrorTests))
function func()
println(global_for_suggestio)
end

try
func()
catch exn
 let exc = exn
if exc isa NameError
support.captured_stderr() do err 
sys.__excepthook__(sys.exc_info()...)
end
end
end
end
assertIn(self, "\'global_for_suggestions\'?", getvalue(err))
end

function test_name_error_suggestions_from_builtins(self::@like(NameErrorTests))
function func()
println(ZeroDivisionErrrrr)
end

try
func()
catch exn
 let exc = exn
if exc isa NameError
support.captured_stderr() do err 
sys.__excepthook__(sys.exc_info()...)
end
end
end
end
assertIn(self, "\'ZeroDivisionError\'?", getvalue(err))
end

function test_name_error_suggestions_do_not_trigger_for_long_names(self::@like(NameErrorTests))
function f()
somethingverywronghehehehehehe = nothing
println(somethingverywronghe)
end

try
f()
catch exn
 let exc = exn
if exc isa NameError
support.captured_stderr() do err 
sys.__excepthook__(sys.exc_info()...)
end
end
end
end
assertNotIn(self, "somethingverywronghehe", getvalue(err))
end

function test_name_error_bad_suggestions_do_not_trigger_for_small_names(self::@like(NameErrorTests))
vvv=mom=w=id=pytho = nothing
subTest(self, name = "b") do 
try
b
catch exn
 let exc = exn
if exc isa NameError
support.captured_stderr() do err 
sys.__excepthook__(sys.exc_info()...)
end
end
end
end
assertNotIn(self, "you mean", getvalue(err))
assertNotIn(self, "vvv", getvalue(err))
assertNotIn(self, "mom", getvalue(err))
assertNotIn(self, "\'id\'", getvalue(err))
assertNotIn(self, "\'w\'", getvalue(err))
assertNotIn(self, "\'pytho\'", getvalue(err))
end
subTest(self, name = "v") do 
try
v
catch exn
 let exc = exn
if exc isa NameError
support.captured_stderr() do err 
sys.__excepthook__(sys.exc_info()...)
end
end
end
end
assertNotIn(self, "you mean", getvalue(err))
assertNotIn(self, "vvv", getvalue(err))
assertNotIn(self, "mom", getvalue(err))
assertNotIn(self, "\'id\'", getvalue(err))
assertNotIn(self, "\'w\'", getvalue(err))
assertNotIn(self, "\'pytho\'", getvalue(err))
end
subTest(self, name = "m") do 
try
m
catch exn
 let exc = exn
if exc isa NameError
support.captured_stderr() do err 
sys.__excepthook__(sys.exc_info()...)
end
end
end
end
assertNotIn(self, "you mean", getvalue(err))
assertNotIn(self, "vvv", getvalue(err))
assertNotIn(self, "mom", getvalue(err))
assertNotIn(self, "\'id\'", getvalue(err))
assertNotIn(self, "\'w\'", getvalue(err))
assertNotIn(self, "\'pytho\'", getvalue(err))
end
subTest(self, name = "py") do 
try
py
catch exn
 let exc = exn
if exc isa NameError
support.captured_stderr() do err 
sys.__excepthook__(sys.exc_info()...)
end
end
end
end
assertNotIn(self, "you mean", getvalue(err))
assertNotIn(self, "vvv", getvalue(err))
assertNotIn(self, "mom", getvalue(err))
assertNotIn(self, "\'id\'", getvalue(err))
assertNotIn(self, "\'w\'", getvalue(err))
assertNotIn(self, "\'pytho\'", getvalue(err))
end
end

function test_name_error_suggestions_do_not_trigger_for_too_many_locals(self::@like(NameErrorTests))
function f()
a1=a2=a3=a4=a5=a6=a7=a8=a9=a10=a11=a12=a13=a14=a15=a16=a17=a18=a19=a20=a21=a22=a23=a24=a25=a26=a27=a28=a29=a30=a31=a32=a33=a34=a35=a36=a37=a38=a39=a40=a41=a42=a43=a44=a45=a46=a47=a48=a49=a50=a51=a52=a53=a54=a55=a56=a57=a58=a59=a60=a61=a62=a63=a64=a65=a66=a67=a68=a69=a70=a71=a72=a73=a74=a75=a76=a77=a78=a79=a80=a81=a82=a83=a84=a85=a86=a87=a88=a89=a90=a91=a92=a93=a94=a95=a96=a97=a98=a99=a100=a101=a102=a103=a104=a105=a106=a107=a108=a109=a110=a111=a112=a113=a114=a115=a116=a117=a118=a119=a120=a121=a122=a123=a124=a125=a126=a127=a128=a129=a130=a131=a132=a133=a134=a135=a136=a137=a138=a139=a140=a141=a142=a143=a144=a145=a146=a147=a148=a149=a150=a151=a152=a153=a154=a155=a156=a157=a158=a159=a160=a161=a162=a163=a164=a165=a166=a167=a168=a169=a170=a171=a172=a173=a174=a175=a176=a177=a178=a179=a180=a181=a182=a183=a184=a185=a186=a187=a188=a189=a190=a191=a192=a193=a194=a195=a196=a197=a198=a199=a200=a201=a202=a203=a204=a205=a206=a207=a208=a209=a210=a211=a212=a213=a214=a215=a216=a217=a218=a219=a220=a221=a222=a223=a224=a225=a226=a227=a228=a229=a230=a231=a232=a233=a234=a235=a236=a237=a238=a239=a240=a241=a242=a243=a244=a245=a246=a247=a248=a249=a250=a251=a252=a253=a254=a255=a256=a257=a258=a259=a260=a261=a262=a263=a264=a265=a266=a267=a268=a269=a270=a271=a272=a273=a274=a275=a276=a277=a278=a279=a280=a281=a282=a283=a284=a285=a286=a287=a288=a289=a290=a291=a292=a293=a294=a295=a296=a297=a298=a299=a300=a301=a302=a303=a304=a305=a306=a307=a308=a309=a310=a311=a312=a313=a314=a315=a316=a317=a318=a319=a320=a321=a322=a323=a324=a325=a326=a327=a328=a329=a330=a331=a332=a333=a334=a335=a336=a337=a338=a339=a340=a341=a342=a343=a344=a345=a346=a347=a348=a349=a350=a351=a352=a353=a354=a355=a356=a357=a358=a359=a360=a361=a362=a363=a364=a365=a366=a367=a368=a369=a370=a371=a372=a373=a374=a375=a376=a377=a378=a379=a380=a381=a382=a383=a384=a385=a386=a387=a388=a389=a390=a391=a392=a393=a394=a395=a396=a397=a398=a399=a400=a401=a402=a403=a404=a405=a406=a407=a408=a409=a410=a411=a412=a413=a414=a415=a416=a417=a418=a419=a420=a421=a422=a423=a424=a425=a426=a427=a428=a429=a430=a431=a432=a433=a434=a435=a436=a437=a438=a439=a440=a441=a442=a443=a444=a445=a446=a447=a448=a449=a450=a451=a452=a453=a454=a455=a456=a457=a458=a459=a460=a461=a462=a463=a464=a465=a466=a467=a468=a469=a470=a471=a472=a473=a474=a475=a476=a477=a478=a479=a480=a481=a482=a483=a484=a485=a486=a487=a488=a489=a490=a491=a492=a493=a494=a495=a496=a497=a498=a499=a500=a501=a502=a503=a504=a505=a506=a507=a508=a509=a510=a511=a512=a513=a514=a515=a516=a517=a518=a519=a520=a521=a522=a523=a524=a525=a526=a527=a528=a529=a530=a531=a532=a533=a534=a535=a536=a537=a538=a539=a540=a541=a542=a543=a544=a545=a546=a547=a548=a549=a550=a551=a552=a553=a554=a555=a556=a557=a558=a559=a560=a561=a562=a563=a564=a565=a566=a567=a568=a569=a570=a571=a572=a573=a574=a575=a576=a577=a578=a579=a580=a581=a582=a583=a584=a585=a586=a587=a588=a589=a590=a591=a592=a593=a594=a595=a596=a597=a598=a599=a600=a601=a602=a603=a604=a605=a606=a607=a608=a609=a610=a611=a612=a613=a614=a615=a616=a617=a618=a619=a620=a621=a622=a623=a624=a625=a626=a627=a628=a629=a630=a631=a632=a633=a634=a635=a636=a637=a638=a639=a640=a641=a642=a643=a644=a645=a646=a647=a648=a649=a650=a651=a652=a653=a654=a655=a656=a657=a658=a659=a660=a661=a662=a663=a664=a665=a666=a667=a668=a669=a670=a671=a672=a673=a674=a675=a676=a677=a678=a679=a680=a681=a682=a683=a684=a685=a686=a687=a688=a689=a690=a691=a692=a693=a694=a695=a696=a697=a698=a699=a700=a701=a702=a703=a704=a705=a706=a707=a708=a709=a710=a711=a712=a713=a714=a715=a716=a717=a718=a719=a720=a721=a722=a723=a724=a725=a726=a727=a728=a729=a730=a731=a732=a733=a734=a735=a736=a737=a738=a739=a740=a741=a742=a743=a744=a745=a746=a747=a748=a749=a750=a751=a752=a753=a754=a755=a756=a757=a758=a759=a760=a761=a762=a763=a764=a765=a766=a767=a768=a769=a770=a771=a772=a773=a774=a775=a776=a777=a778=a779=a780=a781=a782=a783=a784=a785=a786=a787=a788=a789=a790=a791=a792=a793=a794=a795=a796=a797=a798=a799=a800 = nothing
println(a0)
end

try
f()
catch exn
 let exc = exn
if exc isa NameError
support.captured_stderr() do err 
sys.__excepthook__(sys.exc_info()...)
end
end
end
end
assertNotRegex(self, getvalue(err), "NameError.*a1")
end

function test_name_error_with_custom_exceptions(self::@like(NameErrorTests))
function f()
blech = nothing
throw(NameError())
end

try
f()
catch exn
 let exc = exn
if exc isa NameError
support.captured_stderr() do err 
sys.__excepthook__(sys.exc_info()...)
end
end
end
end
assertNotIn(self, "blech", getvalue(err))
function f()
blech = nothing
throw(NameError)
end

try
f()
catch exn
 let exc = exn
if exc isa NameError
support.captured_stderr() do err 
sys.__excepthook__(sys.exc_info()...)
end
end
end
end
assertNotIn(self, "blech", getvalue(err))
end

function test_unbound_local_error_doesn_not_match(self::@like(NameErrorTests))
function foo()
something_ = 3
println(somethong)
somethong = 3
end

try
foo()
catch exn
 let exc = exn
if exc isa UnboundLocalError
support.captured_stderr() do err 
sys.__excepthook__(sys.exc_info()...)
end
end
end
end
assertNotIn(self, "something", getvalue(err))
end

function test_issue45826(self::@like(NameErrorTests))
function f()
assertRaisesRegex(self, NameError, "aaa") do 
aab
end
end

try
f()
catch exn
if exn isa self.failureException
support.captured_stderr() do err 
sys.__excepthook__(sys.exc_info()...)
end
end
end
assertIn(self, "aab", getvalue(err))
end

function test_issue45826_focused(self::@like(NameErrorTests))
function f()
try
nonsense
catch exn
 let E = exn
if E isa BaseException
E.with_traceback(nothing)
throw(ZeroDivisionError())
end
end
end
end

try
f()
catch exn
if exn isa ZeroDivisionError
support.captured_stderr() do err 
sys.__excepthook__(sys.exc_info()...)
end
end
end
assertIn(self, "nonsense", getvalue(err))
assertIn(self, "ZeroDivisionError", getvalue(err))
end


@oodef mutable struct A
                    
                    blech
                    
function new(blech = nothing)
blech = blech
new(blech)
end

                end
                

@oodef mutable struct A
                    
                    
                    
                end
                function blech(self::@like(A))
return
end


@oodef mutable struct Substitution
                    
                    blech
noise
                    
function new(blech = nothing, noise = nothing)
blech = blech
noise = noise
new(blech, noise)
end

                end
                

@oodef mutable struct Elimination
                    
                    blch
noise
                    
function new(blch = nothing, noise = nothing)
blch = blch
noise = noise
new(blch, noise)
end

                end
                

@oodef mutable struct Addition
                    
                    bluchin
noise
                    
function new(bluchin = nothing, noise = nothing)
bluchin = bluchin
noise = noise
new(bluchin, noise)
end

                end
                

@oodef mutable struct SubstitutionOverElimination
                    
                    blach
bluc
                    
function new(blach = nothing, bluc = nothing)
blach = blach
bluc = bluc
new(blach, bluc)
end

                end
                

@oodef mutable struct SubstitutionOverAddition
                    
                    blach
bluchi
                    
function new(blach = nothing, bluchi = nothing)
blach = blach
bluchi = bluchi
new(blach, bluchi)
end

                end
                

@oodef mutable struct EliminationOverAddition
                    
                    bluc
blucha
                    
function new(bluc = nothing, blucha = nothing)
bluc = bluc
blucha = blucha
new(bluc, blucha)
end

                end
                

@oodef mutable struct A
                    
                    blech
                    
function new(blech = nothing)
blech = blech
new(blech)
end

                end
                

@oodef mutable struct MyClass
                    
                    vvv
                    
function new(vvv = nothing)
vvv = vvv
new(vvv)
end

                end
                

@oodef mutable struct A
                    
                    blech
                    
function new(blech = nothing)
blech = blech
new(blech)
end

                end
                

@oodef mutable struct A
                    
                    blech
                    
function new(blech = nothing)
blech = blech
new(blech)
end

                end
                function Base.getproperty(self::@like(A), attr::Symbol)
                if hasproperty(self, Symbol(attr))
                    return Base.getfield(self, Symbol(attr))
                end
                throw(AttributeError())
            end

@oodef mutable struct A
                    
                    blech
                    
function new(blech = nothing)
blech = blech
new(blech)
end

                end
                function Base.getproperty(self::@like(A), attr::Symbol)
                if hasproperty(self, Symbol(attr))
                    return Base.getfield(self, Symbol(attr))
                end
                throw(AttributeError)
            end

@oodef mutable struct NonStringifyClass
                    
                    __repr__
__str__
                    
function new(__repr__ = nothing, __str__ = nothing)
__repr__ = __repr__
__str__ = __str__
new(__repr__, __str__)
end

                end
                

@oodef mutable struct A
                    
                    blech
                    
function new(blech = nothing)
blech = blech
new(blech)
end

                end
                function Base.getproperty(self::@like(A), attr::Symbol)
                if hasproperty(self, Symbol(attr))
                    return Base.getfield(self, Symbol(attr))
                end
                throw(AttributeError(NonStringifyClass()))
            end

@oodef mutable struct B
                    
                    blech
                    
function new(blech = nothing)
blech = blech
new(blech)
end

                end
                function Base.getproperty(self::@like(B), attr::Symbol)
                if hasproperty(self, Symbol(attr))
                    return Base.getfield(self, Symbol(attr))
                end
                throw(AttributeError("Error", 23))
            end

@oodef mutable struct C
                    
                    blech
                    
function new(blech = nothing)
blech = blech
new(blech)
end

                end
                function Base.getproperty(self::@like(C), attr::Symbol)
                if hasproperty(self, Symbol(attr))
                    return Base.getfield(self, Symbol(attr))
                end
                throw(AttributeError(23))
            end

@oodef mutable struct A
                    
                    
                    
                end
                function __dir__(self::@like(A))
return ["blech"]
end


@oodef mutable struct T
                    
                    bluch::Int64
                    
function new(bluch::Int64 = 1)
bluch = bluch
new(bluch)
end

                end
                function __dir__(self::@like(T))
throw(AttributeError("oh no!"))
end


@oodef mutable struct A
                    
                    bluch::Int64
                    
function new(bluch::Int64 = 1)
bluch = bluch
new(bluch)
end

                end
                

@oodef mutable struct B
                    
                    
                    
                end
                function __getattribute__(self::@like(B), attr)
a = A()
return a.blich
end


@oodef mutable struct AttributeErrorTests <: unittest.TestCase
                    
                    
                    
                end
                function test_attributes(self::@like(AttributeErrorTests))
exc = AttributeError("Ouch!")
assertIsNone(self, exc.name)
assertIsNone(self, exc.obj)
sentinel = object()
exc = AttributeError("Ouch", name = "carry", obj = sentinel)
@test (exc.name == "carry")
@test self === exc.obj
end

function test_getattr_has_name_and_obj(self::@like(AttributeErrorTests))
obj = A()
try
obj.bluch
catch exn
 let exc = exn
if exc isa AttributeError
@test ("bluch" == exc.name)
@test (obj == exc.obj)
end
end
end
end

function test_getattr_has_name_and_obj_for_method(self::@like(AttributeErrorTests))
obj = A()
try
bluch(obj)
catch exn
 let exc = exn
if exc isa AttributeError
@test ("bluch" == exc.name)
@test (obj == exc.obj)
end
end
end
end

function test_getattr_suggestions(self::@like(AttributeErrorTests))
for (cls, suggestion) in [(Substitution, "\'blech\'?"), (Elimination, "\'blch\'?"), (Addition, "\'bluchin\'?"), (EliminationOverAddition, "\'bluc\'?"), (SubstitutionOverElimination, "\'blach\'?"), (SubstitutionOverAddition, "\'blach\'?")]
try
cls().bluch
catch exn
 let exc = exn
if exc isa AttributeError
support.captured_stderr() do err 
sys.__excepthook__(sys.exc_info()...)
end
end
end
end
assertIn(self, suggestion, getvalue(err))
end
end

function test_getattr_suggestions_do_not_trigger_for_long_attributes(self::@like(AttributeErrorTests))
try
A().somethingverywrong
catch exn
 let exc = exn
if exc isa AttributeError
support.captured_stderr() do err 
sys.__excepthook__(sys.exc_info()...)
end
end
end
end
assertNotIn(self, "blech", getvalue(err))
end

function test_getattr_error_bad_suggestions_do_not_trigger_for_small_names(self::@like(AttributeErrorTests))
subTest(self, name = "b") do 
try
MyClass.b
catch exn
 let exc = exn
if exc isa AttributeError
support.captured_stderr() do err 
sys.__excepthook__(sys.exc_info()...)
end
end
end
end
assertNotIn(self, "you mean", getvalue(err))
assertNotIn(self, "vvv", getvalue(err))
assertNotIn(self, "mom", getvalue(err))
assertNotIn(self, "\'id\'", getvalue(err))
assertNotIn(self, "\'w\'", getvalue(err))
assertNotIn(self, "\'pytho\'", getvalue(err))
end
subTest(self, name = "v") do 
try
MyClass.v
catch exn
 let exc = exn
if exc isa AttributeError
support.captured_stderr() do err 
sys.__excepthook__(sys.exc_info()...)
end
end
end
end
assertNotIn(self, "you mean", getvalue(err))
assertNotIn(self, "vvv", getvalue(err))
assertNotIn(self, "mom", getvalue(err))
assertNotIn(self, "\'id\'", getvalue(err))
assertNotIn(self, "\'w\'", getvalue(err))
assertNotIn(self, "\'pytho\'", getvalue(err))
end
subTest(self, name = "m") do 
try
MyClass.m
catch exn
 let exc = exn
if exc isa AttributeError
support.captured_stderr() do err 
sys.__excepthook__(sys.exc_info()...)
end
end
end
end
assertNotIn(self, "you mean", getvalue(err))
assertNotIn(self, "vvv", getvalue(err))
assertNotIn(self, "mom", getvalue(err))
assertNotIn(self, "\'id\'", getvalue(err))
assertNotIn(self, "\'w\'", getvalue(err))
assertNotIn(self, "\'pytho\'", getvalue(err))
end
subTest(self, name = "py") do 
try
MyClass.py
catch exn
 let exc = exn
if exc isa AttributeError
support.captured_stderr() do err 
sys.__excepthook__(sys.exc_info()...)
end
end
end
end
assertNotIn(self, "you mean", getvalue(err))
assertNotIn(self, "vvv", getvalue(err))
assertNotIn(self, "mom", getvalue(err))
assertNotIn(self, "\'id\'", getvalue(err))
assertNotIn(self, "\'w\'", getvalue(err))
assertNotIn(self, "\'pytho\'", getvalue(err))
end
end

function test_getattr_suggestions_do_not_trigger_for_big_dicts(self::@like(AttributeErrorTests))
for index in 0:1999
setfield!(A, :"index_$(index)", nothing)
end
try
A().bluch
catch exn
 let exc = exn
if exc isa AttributeError
support.captured_stderr() do err 
sys.__excepthook__(sys.exc_info()...)
end
end
end
end
assertNotIn(self, "blech", getvalue(err))
end

function test_getattr_suggestions_no_args(self::@like(AttributeErrorTests))
try
A().bluch
catch exn
 let exc = exn
if exc isa AttributeError
support.captured_stderr() do err 
sys.__excepthook__(sys.exc_info()...)
end
end
end
end
assertIn(self, "blech", getvalue(err))
try
A().bluch
catch exn
 let exc = exn
if exc isa AttributeError
support.captured_stderr() do err 
sys.__excepthook__(sys.exc_info()...)
end
end
end
end
assertIn(self, "blech", getvalue(err))
end

function test_getattr_suggestions_invalid_args(self::@like(AttributeErrorTests))
for cls in [A, B, C]
try
cls().bluch
catch exn
 let exc = exn
if exc isa AttributeError
support.captured_stderr() do err 
sys.__excepthook__(sys.exc_info()...)
end
end
end
end
assertIn(self, "blech", getvalue(err))
end
end

function test_getattr_suggestions_for_same_name(self::@like(AttributeErrorTests))
try
A().blech
catch exn
 let exc = exn
if exc isa AttributeError
support.captured_stderr() do err 
sys.__excepthook__(sys.exc_info()...)
end
end
end
end
assertNotIn(self, "Did you mean", getvalue(err))
end

function test_attribute_error_with_failing_dict(self::@like(AttributeErrorTests))
try
T().blich
catch exn
 let exc = exn
if exc isa AttributeError
support.captured_stderr() do err 
sys.__excepthook__(sys.exc_info()...)
end
end
end
end
assertNotIn(self, "blech", getvalue(err))
assertNotIn(self, "oh no!", getvalue(err))
end

function test_attribute_error_with_bad_name(self::@like(AttributeErrorTests))
try
throw(AttributeError(name = 12, obj = 23))
catch exn
 let exc = exn
if exc isa AttributeError
support.captured_stderr() do err 
sys.__excepthook__(sys.exc_info()...)
end
end
end
end
assertNotIn(self, "?", getvalue(err))
end

function test_attribute_error_inside_nested_getattr(self::@like(AttributeErrorTests))
try
B().something
catch exn
 let exc = exn
if exc isa AttributeError
support.captured_stderr() do err 
sys.__excepthook__(sys.exc_info()...)
end
end
end
end
assertIn(self, "Did you mean", getvalue(err))
assertIn(self, "bluch", getvalue(err))
end


@oodef mutable struct ImportErrorTests <: unittest.TestCase
                    
                    
                    
                end
                function test_attributes(self::@like(ImportErrorTests))
exc = ImportError("test")
assertIsNone(self, exc.name)
assertIsNone(self, exc.path)
exc = ImportError("test", name = "somemodule")
@test (exc.name == "somemodule")
assertIsNone(self, exc.path)
exc = ImportError("test", path = "somepath")
@test (exc.path == "somepath")
assertIsNone(self, exc.name)
exc = ImportError("test", path = "somepath", name = "somename")
@test (exc.name == "somename")
@test (exc.path == "somepath")
msg = "\'invalid\' is an invalid keyword argument for ImportError"
assertRaisesRegex(self, TypeError, msg) do 
ImportError("test", invalid = "keyword")
end
assertRaisesRegex(self, TypeError, msg) do 
ImportError("test", name = "name", invalid = "keyword")
end
assertRaisesRegex(self, TypeError, msg) do 
ImportError("test", path = "path", invalid = "keyword")
end
assertRaisesRegex(self, TypeError, msg) do 
ImportError(invalid = "keyword")
end
assertRaisesRegex(self, TypeError, msg) do 
ImportError("test", invalid = "keyword", another = true)
end
end

function test_reset_attributes(self::@like(ImportErrorTests))
exc = ImportError("test", name = "name", path = "path")
@test (exc.args == ("test",))
@test (exc.msg == "test")
@test (exc.name == "name")
@test (exc.path == "path")
exc()
@test (exc.args == ())
@test (exc.msg == nothing)
@test (exc.name == nothing)
@test (exc.path == nothing)
end

function test_non_str_argument(self::@like(ImportErrorTests))
check_warnings(("", BytesWarning), quiet = true) do 
arg = b"abc"
exc = ImportError(arg)
@test (string(arg) == string(exc))
end
end

function test_copy_pickle(self::@like(ImportErrorTests))
for kwargs in (dict(), dict(name = "somename"), dict(path = "somepath"), dict(name = "somename", path = "somepath"))
orig = ImportError("test", None = kwargs)
for proto in 0:pickle.HIGHEST_PROTOCOL
exc = pickle.loads(pickle.dumps(orig, proto))
@test (exc.args == ("test",))
@test (exc.msg == "test")
@test (exc.name == orig.name)
@test (exc.path == orig.path)
end
for c in (copy.copy, copy.deepcopy)
exc = c(orig)
@test (exc.args == ("test",))
@test (exc.msg == "test")
@test (exc.name == orig.name)
@test (exc.path == orig.path)
end
end
end


@oodef mutable struct SyntaxErrorTests <: unittest.TestCase
                    
                    
                    
                end
                function test_range_of_offsets(self::@like(SyntaxErrorTests))
cases = [(("bad.py", 1, 2, "abcdefg", 1, 7), dedent("\n               File \"bad.py\", line 1\n                 abcdefg\n                  ^^^^^\n             SyntaxError: bad bad\n             ")), (("bad.py", 1, 2, "abcdefg", 1, 3), dedent("\n               File \"bad.py\", line 1\n                 abcdefg\n                  ^\n             SyntaxError: bad bad\n             ")), (("bad.py", 1, 2, "abcdefg", 1, -2), dedent("\n               File \"bad.py\", line 1\n                 abcdefg\n                  ^\n             SyntaxError: bad bad\n             ")), (("bad.py", 1, 4, "abcdefg", 1, 2), dedent("\n               File \"bad.py\", line 1\n                 abcdefg\n                    ^\n             SyntaxError: bad bad\n             ")), (("bad.py", 1, -4, "abcdefg", 1, -2), dedent("\n               File \"bad.py\", line 1\n                 abcdefg\n             SyntaxError: bad bad\n             ")), (("bad.py", 1, -4, "abcdefg", 1, -5), dedent("\n               File \"bad.py\", line 1\n                 abcdefg\n             SyntaxError: bad bad\n             ")), (("bad.py", 1, 0, "abcdefg", 1, 0), dedent("\n               File \"bad.py\", line 1\n                 abcdefg\n             SyntaxError: bad bad\n             ")), (("bad.py", 1, 0, "abcdefg", 1, 5), dedent("\n               File \"bad.py\", line 1\n                 abcdefg\n             SyntaxError: bad bad\n             ")), (("bad.py", 1, 2, "abcdefg", 1, 100), dedent("\n               File \"bad.py\", line 1\n                 abcdefg\n                  ^^^^^^\n             SyntaxError: bad bad\n             "))]
for (args, expected) in cases
subTest(self, args = args) do 
try
throw(SyntaxError("bad bad", args))
catch exn
 let exc = exn
if exc isa SyntaxError
support.captured_stderr() do err 
sys.__excepthook__(sys.exc_info()...)
end
assertIn(self, expected, getvalue(err))
the_exception = exc
end
end
end
end
end
end

function test_encodings(self::@like(SyntaxErrorTests))
source = "# -*- coding: cp437 -*-\n\"┬ó┬ó┬ó┬ó┬ó┬ó\" + f(4, x for x in range(1))\n"
try
readline(TESTFN) do testfile 
write(testfile, source)
end
(rc, out, err) = script_helper.assert_python_failure("-Wd", "-X", "utf8", TESTFN)
err = splitlines(decode(err, "utf-8"))
@test (err[end - 2] == "    \"┬ó┬ó┬ó┬ó┬ó┬ó\" + f(4, x for x in range(1))")
@test (err[end - 1] == "                          ^^^^^^^^^^^^^^^^^^^")
finally
unlink(TESTFN)
end
source = "# -*- coding: ascii -*-\n\n(\n"
try
readline(TESTFN) do testfile 
write(testfile, source)
end
(rc, out, err) = script_helper.assert_python_failure("-Wd", "-X", "utf8", TESTFN)
err = splitlines(decode(err, "utf-8"))
@test (err[end - 2] == "    (")
@test (err[end - 1] == "    ^")
finally
unlink(TESTFN)
end
end

function test_non_utf8(self::@like(SyntaxErrorTests))
try
readline(TESTFN) do testfile 
write(testfile, b"\x89")
end
(rc, out, err) = script_helper.assert_python_failure("-Wd", "-X", "utf8", TESTFN)
err = splitlines(decode(err, "utf-8"))
assertIn(self, "SyntaxError: Non-UTF-8 code starting with \'\\x89\' in file", err[end])
finally
unlink(TESTFN)
end
end

function test_attributes_new_constructor(self::@like(SyntaxErrorTests))
args = ("bad.py", 1, 2, "abcdefg", 1, 100)
the_exception = SyntaxError("bad bad", args)
(filename, lineno, offset, error_, end_lineno, end_offset) = args
@test (filename == the_exception.filename)
@test (lineno == the_exception.lineno)
@test (end_lineno == the_exception.end_lineno)
@test (offset == the_exception.offset)
@test (end_offset == the_exception.end_offset)
@test (error_ == the_exception.text)
@test ("bad bad" == the_exception.msg)
end

function test_attributes_old_constructor(self::@like(SyntaxErrorTests))
args = ("bad.py", 1, 2, "abcdefg")
the_exception = SyntaxError("bad bad", args)
(filename, lineno, offset, error_) = args
@test (filename == the_exception.filename)
@test (lineno == the_exception.lineno)
@test (nothing == the_exception.end_lineno)
@test (offset == the_exception.offset)
@test (nothing == the_exception.end_offset)
@test (error_ == the_exception.text)
@test ("bad bad" == the_exception.msg)
end

function test_incorrect_constructor(self::@like(SyntaxErrorTests))
args = ("bad.py", 1, 2)
@test_throws
args = ("bad.py", 1, 2, 4, 5, 6, 7)
@test_throws
args = ("bad.py", 1, 2, "abcdefg", 1)
@test_throws
end


@oodef mutable struct Noop
                    
                    
                    
                end
                function __enter__(self::@like(Noop))
return self
end

function __exit__(self::@like(Noop), args...)
#= pass =#
end


@oodef mutable struct ExitFails
                    
                    
                    
                end
                function __enter__(self::@like(ExitFails))
return self
end

function __exit__(self::@like(ExitFails), args...)
throw(ValueError)
end


@oodef mutable struct PEP626Tests <: unittest.TestCase
                    
                    
                    
                end
                function lineno_after_raise(self::@like(PEP626Tests), f, expected...)
try
f()
catch exn
 let ex = exn
if ex isa Exception
t = ex.__traceback__
end
end
end
lines = []
t = t.tb_next
while t
frame = t.tb_frame
push!(lines, frame.f_lineno === nothing ? (nothing) : (frame.f_lineno - frame.f_code.co_firstlineno))
t = t.tb_next
end
@test (tuple(lines) == expected)
end

function test_lineno_after_raise_simple(self::@like(PEP626Tests))
function simple()
1 / 0
#= pass =#
end

lineno_after_raise(self, simple)
end

function test_lineno_after_raise_in_except(self::@like(PEP626Tests))
function in_except()
try
1 / 0
catch exn
1 / 0
#= pass =#
end
end

lineno_after_raise(self, in_except)
end

function test_lineno_after_other_except(self::@like(PEP626Tests))
function other_except()
try
1 / 0
catch exn
 let ex = exn
if ex isa TypeError
#= pass =#
end
end
end
end

lineno_after_raise(self, other_except)
end

function test_lineno_in_named_except(self::@like(PEP626Tests))
function in_named_except()
try
1 / 0
catch exn
 let ex = exn
if ex isa Exception
1 / 0
#= pass =#
end
end
end
end

lineno_after_raise(self, in_named_except)
end

function test_lineno_in_try(self::@like(PEP626Tests))
function in_try()
try
1 / 0
finally
#= pass =#
end
end

lineno_after_raise(self, in_try)
end

function test_lineno_in_finally_normal(self::@like(PEP626Tests))
function in_finally_normal()
try
#= pass =#
finally
1 / 0
#= pass =#
end
end

lineno_after_raise(self, in_finally_normal)
end

function test_lineno_in_finally_except(self::@like(PEP626Tests))
function in_finally_except()
try
1 / 0
finally
1 / 0
#= pass =#
end
end

lineno_after_raise(self, in_finally_except)
end

function test_lineno_after_with(self::@like(PEP626Tests))
function after_with()
Noop() do 
1 / 0
#= pass =#
end
end

lineno_after_raise(self, after_with)
end

function test_missing_lineno_shows_as_none(self::@like(PEP626Tests))
function f()
1 / 0
end

lineno_after_raise(self, f)
f.__code__ = replace(f.__code__, co_linetable = b"\x04\x80\xff\x80")
lineno_after_raise(self, f)
end

function test_lineno_after_raise_in_with_exit(self::@like(PEP626Tests))
function after_with()
ExitFails() do 
1 / 0
end
end

lineno_after_raise(self, after_with)
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
end