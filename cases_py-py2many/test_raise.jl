#= Tests for the raise statement. =#
using Test
import gc




abstract type AbstractTestRaise end
abstract type AbstractMyException <: Exception end
abstract type AbstractTestCause end
abstract type AbstractTestTraceback end
abstract type AbstractTestTracebackType end
abstract type AbstractTestContext end
abstract type AbstractTestRemovedFunctionality end
function get_tb()
try
throw(OSError())
catch exn
 let e = exn
if e isa OSError
return e.__traceback__
end
end
end
end

mutable struct Context <: AbstractContext

end
function __enter__(self::Context)
return self
end

function __exit__(self::Context, exc_type, exc_value, exc_tb)::Bool
return true
end

mutable struct TestRaise <: AbstractTestRaise

end
function test_invalid_reraise(self::TestRaise)
try
error()
catch exn
 let e = exn
if e isa RuntimeError
assertIn(self, "No active exception", string(e))
end
end
end
end

function test_reraise(self::TestRaise)
try
try
throw(IndexError())
catch exn
 let e = exn
if e isa IndexError
exc1 = e
error()
end
end
end
catch exn
 let exc2 = exn
if exc2 isa IndexError
assertIs(self, exc1, exc2)
end
end
end
end

function test_except_reraise(self::TestRaise)
function reraise()
try
throw(TypeError("foo"))
catch exn
try
throw(KeyError("caught"))
catch exn
if exn isa KeyError
#= pass =#
end
end
error()
end
end

@test_throws TypeError reraise()
end

function test_finally_reraise(self::TestRaise)
function reraise()
try
throw(TypeError("foo"))
catch exn
try
throw(KeyError("caught"))
finally
error()
end
end
end

@test_throws KeyError reraise()
end

function test_nested_reraise(self::TestRaise)
function nested_reraise()
error()
end

function reraise()
try
throw(TypeError("foo"))
catch exn
nested_reraise()
end
end

@test_throws TypeError reraise()
end

function test_raise_from_None(self::TestRaise)
try
try
throw(TypeError("foo"))
catch exn
throw(ValueError())
end
catch exn
 let e = exn
if e isa ValueError
@test isa(self, e.__context__)
assertIsNone(self, e.__cause__)
end
end
end
end

function test_with_reraise1(self::TestRaise)
function reraise()
try
throw(TypeError("foo"))
catch exn
Context() do 
#= pass =#
end
error()
end
end

@test_throws TypeError reraise()
end

function test_with_reraise2(self::TestRaise)
function reraise()
try
throw(TypeError("foo"))
catch exn
Context() do 
throw(KeyError("caught"))
end
error()
end
end

@test_throws TypeError reraise()
end

function test_yield_reraise(self::TestRaise)
function reraise()
try
throw(TypeError("foo"))
catch exn
put!(ch_reraise, 1)
error()
end
end

g = reraise()
next(g)
@test_throws TypeError () -> next(g)()
@test_throws StopIteration () -> next(g)()
end

function test_erroneous_exception(self::MyException)
mutable struct MyException <: AbstractMyException


            MyException() = begin
                throw(RuntimeError())
                new()
            end
end

try
throw(MyException)
catch exn
if exn isa RuntimeError
#= pass =#
end
end
end

function test_new_returns_invalid_instance(self::MyException)
mutable struct MyException <: AbstractMyException

end
function __new__(cls)
return object()
end

assertRaises(self, TypeError) do 
throw(MyException)
end
end

function test_assert_with_tuple_arg(self::TestRaise)
try
@assert(false)
catch exn
 let e = exn
if e isa AssertionError
@test (string(e) == "(3,)")
end
end
end
end

mutable struct TestCause <: AbstractTestCause

end
function testCauseSyntax(self::TestCause)
try
try
try
throw(TypeError)
catch exn
if exn isa Exception
throw(ValueError)
end
end
catch exn
 let exc = exn
if exc isa ValueError
assertIsNone(self, exc.__cause__)
@test exc.__suppress_context__
exc.__suppress_context__ = false
throw(exc)
end
end
end
catch exn
 let exc = exn
if exc isa ValueError
e = exc
end
end
end
assertIsNone(self, e.__cause__)
@test !(e.__suppress_context__)
@test isa(self, e.__context__)
end

function test_invalid_cause(self::TestCause)
try
throw(IndexError)
catch exn
 let e = exn
if e isa TypeError
assertIn(self, "exception cause", string(e))
end
end
end
end

function test_class_cause(self::TestCause)
try
throw(IndexError)
catch exn
 let e = exn
if e isa IndexError
@test isa(self, e.__cause__)
end
end
end
end

function test_instance_cause(self::TestCause)
cause = KeyError()
try
throw(IndexError)
catch exn
 let e = exn
if e isa IndexError
assertIs(self, e.__cause__, cause)
end
end
end
end

function test_erroneous_cause(self::MyException)
mutable struct MyException <: AbstractMyException


            MyException() = begin
                throw(RuntimeError())
                new()
            end
end

try
throw(IndexError)
catch exn
if exn isa RuntimeError
#= pass =#
end
end
end

mutable struct TestTraceback <: AbstractTestTraceback

end
function test_sets_traceback(self::TestTraceback)
try
throw(IndexError())
catch exn
 let e = exn
if e isa IndexError
@test isa(self, e.__traceback__)
end
end
end
end

function test_accepts_traceback(self::TestTraceback)
tb = get_tb()
try
throw(with_traceback(IndexError(), tb))
catch exn
 let e = exn
if e isa IndexError
assertNotEqual(self, e.__traceback__, tb)
@test (e.__traceback__.tb_next == tb)
end
end
end
end

mutable struct TestTracebackType <: AbstractTestTracebackType

end
function raiser(self::TestTracebackType)
throw(ValueError)
end

function test_attrs(self::TestTracebackType)
try
raiser(self)
catch exn
 let exc = exn
if exc isa Exception
tb = exc.__traceback__
end
end
end
@test isa(self, tb.tb_next)
assertIs(self, tb.tb_frame, _getframe())
@test isa(self, tb.tb_lasti)
@test isa(self, tb.tb_lineno)
assertIs(self, tb.tb_next.tb_next, nothing)
assertRaises(self, TypeError) do 
#Delete Unsupported
del(tb.tb_next)
end
assertRaises(self, TypeError) do 
tb.tb_next = "asdf"
end
assertRaises(self, ValueError) do 
tb.tb_next = tb
end
assertRaises(self, ValueError) do 
tb.tb_next.tb_next = tb
end
tb.tb_next = nothing
assertIs(self, tb.tb_next, nothing)
new_tb = get_tb()
tb.tb_next = new_tb
assertIs(self, tb.tb_next, new_tb)
end

function test_constructor(self::TestTracebackType)
other_tb = get_tb()
frame = _getframe()
tb = TracebackType(other_tb, frame, 1, 2)
@test (tb.tb_next == other_tb)
@test (tb.tb_frame == frame)
@test (tb.tb_lasti == 1)
@test (tb.tb_lineno == 2)
tb = TracebackType(nothing, frame, 1, 2)
@test (tb.tb_next == nothing)
assertRaises(self, TypeError) do 
TracebackType("no", frame, 1, 2)
end
assertRaises(self, TypeError) do 
TracebackType(other_tb, "no", 1, 2)
end
assertRaises(self, TypeError) do 
TracebackType(other_tb, frame, "no", 2)
end
assertRaises(self, TypeError) do 
TracebackType(other_tb, frame, 1, "nuh-uh")
end
end

mutable struct TestContext <: AbstractTestContext

end
function test_instance_context_instance_raise(self::TestContext)
context = IndexError()
try
try
throw(context)
catch exn
throw(OSError())
end
catch exn
 let e = exn
if e isa OSError
assertIs(self, e.__context__, context)
end
end
end
end

function test_class_context_instance_raise(self::TestContext)
context = IndexError
try
try
throw(context)
catch exn
throw(OSError())
end
catch exn
 let e = exn
if e isa OSError
assertIsNot(self, e.__context__, context)
@test isa(self, e.__context__)
end
end
end
end

function test_class_context_class_raise(self::TestContext)
context = IndexError
try
try
throw(context)
catch exn
throw(OSError)
end
catch exn
 let e = exn
if e isa OSError
assertIsNot(self, e.__context__, context)
@test isa(self, e.__context__)
end
end
end
end

function test_c_exception_context(self::TestContext)
try
try
1 / 0
catch exn
throw(OSError)
end
catch exn
 let e = exn
if e isa OSError
@test isa(self, e.__context__)
end
end
end
end

function test_c_exception_raise(self::TestContext)
try
try
1 / 0
catch exn
xyzzy
end
catch exn
 let e = exn
if e isa NameError
@test isa(self, e.__context__)
end
end
end
end

function test_noraise_finally(self::TestContext)
try
try
#= pass =#
finally
throw(OSError)
end
catch exn
 let e = exn
if e isa OSError
assertIsNone(self, e.__context__)
end
end
end
end

function test_raise_finally(self::TestContext)
try
try
1 / 0
finally
throw(OSError)
end
catch exn
 let e = exn
if e isa OSError
@test isa(self, e.__context__)
end
end
end
end

function test_context_manager(self::ContextManager)
mutable struct ContextManager <: AbstractContextManager

end
function __enter__(self::ContextManager)
#= pass =#
end

function __exit__(self::ContextManager, t, v, tb)
xyzzy
end

try
ContextManager() do 
1 / 0
end
catch exn
 let e = exn
if e isa NameError
assertIsInstance(self, e.__context__, ZeroDivisionError)
end
end
end
end

function test_cycle_broken(self::TestContext)
try
try
1 / 0
catch exn
 let e = exn
if e isa ZeroDivisionError
throw(e)
end
end
end
catch exn
 let e = exn
if e isa ZeroDivisionError
assertIsNone(self, e.__context__)
end
end
end
end

function test_reraise_cycle_broken(self::TestContext)
try
try
xyzzy
catch exn
 let a = exn
if a isa NameError
try
1 / 0
catch exn
if exn isa ZeroDivisionError
throw(a)
end
end
end
end
end
catch exn
 let e = exn
if e isa NameError
assertIsNone(self, e.__context__.__context__)
end
end
end
end

function test_not_last(self::TestContext)
context = Exception("context")
try
throw(context)
catch exn
if exn isa Exception
try
throw(Exception("caught"))
catch exn
if exn isa Exception
#= pass =#
end
end
try
throw(Exception("new"))
catch exn
 let exc = exn
if exc isa Exception
raised = exc
end
end
end
end
end
assertIs(self, raised.__context__, context)
end

function test_3118(self::TestContext)
Channel() do ch_test_3118 
function gen()
Channel() do ch_gen 
try
put!(ch_gen, 1)
finally
#= pass =#
end
end
end

function f()
g = gen()
take!(g)
try
try
throw(ValueError)
catch exn
#Delete Unsupported
del(g)
throw(KeyError)
end
catch exn
 let e = exn
if e isa Exception
@test isa(self, e.__context__)
end
end
end
end

f()
end
end

function test_3611(self::C)
mutable struct C <: AbstractC

end
function __del__(self::C)
try
1 / 0
catch exn
error()
end
end

function f()
x = C()
try
try
f.x
catch exn
if exn isa AttributeError
#Delete Unsupported
del(x)
collect()
throw(TypeError)
end
end
catch exn
 let e = exn
if e isa Exception
assertNotEqual(self, e.__context__, nothing)
assertIsInstance(self, e.__context__, AttributeError)
end
end
end
end

catch_unraisable_exception() do cm 
f()
assertEqual(self, ZeroDivisionError, cm.unraisable.exc_type)
end
end

mutable struct TestRemovedFunctionality <: AbstractTestRemovedFunctionality

end
function test_tuples(self::TestRemovedFunctionality)
try
throw((IndexError, KeyError))
catch exn
if exn isa TypeError
#= pass =#
end
end
end

function test_strings(self::TestRemovedFunctionality)
try
throw("foo")
catch exn
if exn isa TypeError
#= pass =#
end
end
end

if abspath(PROGRAM_FILE) == @__FILE__
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
raiser(test_traceback_type)
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
end