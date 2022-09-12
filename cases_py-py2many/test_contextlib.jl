# Transpiled with flags: 
# - oop
#= Unit tests for contextlib.py, and other context managers. =#
using ObjectOriented
using ResumableFunctions
using Test



import threading





@oodef mutable struct DefaultEnter <: AbstractContextManager
                    
                    
                    
                end
                function __exit__(self::@like(DefaultEnter), args...)
AbstractContextManager(args...)
end


@oodef mutable struct MissingExit <: AbstractContextManager
                    
                    
                    
                end
                

@oodef mutable struct ManagerFromScratch
                    
                    
                    
                end
                function __enter__(self::@like(ManagerFromScratch))
return self
end

function __exit__(self::@like(ManagerFromScratch), exc_type, exc_value, traceback)
return nothing
end


@oodef mutable struct DefaultEnter <: AbstractContextManager
                    
                    
                    
                end
                function __exit__(self::@like(DefaultEnter), args...)
AbstractContextManager(args...)
end


@oodef mutable struct NoEnter <: ManagerFromScratch
                    
                    __enter__
                    
function new(__enter__ = nothing)
__enter__ = __enter__
new(__enter__)
end

                end
                

@oodef mutable struct NoExit <: ManagerFromScratch
                    
                    __exit__
                    
function new(__exit__ = nothing)
__exit__ = __exit__
new(__exit__)
end

                end
                

@oodef mutable struct TestAbstractContextManager <: unittest.TestCase
                    
                    
                    
                end
                function test_enter(self::@like(TestAbstractContextManager))
manager = DefaultEnter()
@test self === __enter__(manager)
end

function test_exit_is_abstract(self::@like(TestAbstractContextManager))
@test_throws TypeError do 
MissingExit()
end
end

function test_structural_subclassing(self::@like(TestAbstractContextManager))
@test ManagerFromScratch <: AbstractContextManager
@test DefaultEnter <: AbstractContextManager
@test !(NoEnter <: AbstractContextManager)
@test !(NoExit <: AbstractContextManager)
end


@resumable function woohoo()
push!(state, 1)
@yield 42
push!(state, 999)
end

@resumable function woohoo()
push!(state, 1)
try
@yield 42
finally
push!(state, 999)
end
end

@resumable function whee()
@yield
end

@resumable function whoo()
try
@yield
catch exn
@yield
end
end

@resumable function woohoo()
push!(state, 1)
try
@yield 42
catch exn
 let e = exn
if e isa ZeroDivisionError
push!(state, e.args[1])
@test (state == [1, 42, 999])
end
end
end
end

@resumable function woohoo()
@yield
end

@resumable function test_issue29692()
try
@yield
catch exn
 let exc = exn
if exc isa Exception
throw(ErrorException("issue29692:Chained"))
end
end
end
end

@resumable function woohoo(self::ContextManagerTestCase, func, args, kwds)
@yield (self, func, args, kwds)
end

@resumable function woohoo(a::ContextManagerTestCase, b)
a = weakref.ref(a)
b = weakref.ref(b)
support.gc_collect()
assertIsNone(self, a())
assertIsNone(self, b())
@yield
end

@resumable function woohoo(a::ContextManagerTestCase)
@yield
end

@resumable function woohoo()
# Not Supported
# nonlocal depth
before = depth
depth += 1
@yield
depth -= 1
@test (depth == before)
end

@oodef mutable struct StopIterationSubclass <: StopIteration
                    
                    
                    
                end
                

@oodef mutable struct A
                    
                    
                    
                end
                

@oodef mutable struct ContextManagerTestCase <: unittest.TestCase
                    
                    
                    
                end
                @resumable function test_contextmanager_plain(self::@like(ContextManagerTestCase))
state = []
woohoo() do x 
@test (state == [1])
@test (x == 42)
push!(state, x)
end
@test (state == [1, 42, 999])
end

@resumable function test_contextmanager_finally(self::@like(ContextManagerTestCase))
state = []
@test_throws ZeroDivisionError do 
woohoo() do x 
@test (state == [1])
@test (x == 42)
push!(state, x)
throw(ZeroDivisionError())
end
end
@test (state == [1, 42, 999])
end

@resumable function test_contextmanager_no_reraise(self::@like(ContextManagerTestCase))
ctx = whee()
__enter__(ctx)
@test !(__exit__(ctx, TypeError, TypeError("foo"), nothing))
end

@resumable function test_contextmanager_trap_yield_after_throw(self::@like(ContextManagerTestCase))
ctx = whoo()
__enter__(ctx)
@test_throws
end

@resumable function test_contextmanager_except(self::@like(ContextManagerTestCase))
state = []
woohoo() do x 
@test (state == [1])
@test (x == 42)
push!(state, x)
throw(ZeroDivisionError(999))
end
@test (state == [1, 42, 999])
end

@resumable function test_contextmanager_except_stopiter(self::@like(ContextManagerTestCase))
for stop_exc in (StopIteration("spam"), StopIterationSubclass("spam"))
subTest(self, type_ = type_(stop_exc)) do 
try
woohoo() do 
throw(stop_exc)
end
catch exn
 let ex = exn
if ex isa Exception
@test self === ex
end
end
end
end
end
end

function test_contextmanager_except_pep479(self::@like(ContextManagerTestCase))
code = "from __future__ import generator_stop\nfrom contextlib import contextmanager\n@contextmanager\ndef woohoo():\n    yield\n"
locals = Dict()
py"""code, locals, locals"""
woohoo = locals["woohoo"]
stop_exc = StopIteration("spam")
try
woohoo() do 
throw(stop_exc)
end
catch exn
 let ex = exn
if ex isa Exception
@test self === ex
end
end
end
end

@resumable function test_contextmanager_do_not_unchain_non_stopiteration_exceptions(self::@like(ContextManagerTestCase))
try
catch exn
 let ex = exn
if ex isa Exception
@test self === type_(ex)
@test (ex.args[1] == "issue29692:Chained")
@test isa(self, ex.__cause__)
end
end
end
try
catch exn
 let ex = exn
if ex isa Exception
@test self === type_(ex)
@test (ex.args[1] == "issue29692:Unchained")
assertIsNone(self, ex.__cause__)
end
end
end
throw(ZeroDivisionError)
throw(StopIteration("issue29692:Unchained"))
end

function _create_contextmanager_attribs(self::@like(ContextManagerTestCase))
function attribs()
function decorate(func::@like(ContextManagerTestCase))
for (k, v) in items(kw)
setfield!(func, :k, v)
end
return func
end

return decorate
end

function baz(spam::@like(ContextManagerTestCase))
#= Whee! =#
end

return baz
end

function test_contextmanager_attribs(self::@like(ContextManagerTestCase))
baz = _create_contextmanager_attribs(self)
@test (baz.__name__ == "baz")
@test (baz.foo == "bar")
end

function test_contextmanager_doc_attrib(self::@like(ContextManagerTestCase))
baz = _create_contextmanager_attribs(self)
@test (baz.__doc__ == "Whee!")
end

function test_instance_docstring_given_cm_docstring(self::@like(ContextManagerTestCase))
baz = _create_contextmanager_attribs(self)(nothing)
@test (baz.__doc__ == "Whee!")
end

@resumable function test_keywords(self::@like(ContextManagerTestCase))
woohoo(self = 11, func = 22, args = 33, kwds = 44) do target 
@test (target == (11, 22, 33, 44))
end
end

@resumable function test_nokeepref(self::@like(ContextManagerTestCase))
woohoo(A(), b = A()) do 
#= pass =#
end
end

@resumable function test_param_errors(self::@like(ContextManagerTestCase))
@test_throws TypeError do 
woohoo()
end
@test_throws TypeError do 
woohoo(3, 5)
end
@test_throws TypeError do 
woohoo(b = 3)
end
end

function test_recursive(self::@like(ContextManagerTestCase))
depth = 0
function recursive()
if depth < 10
recursive()
end
end

recursive()
@test (depth == 0)
end


@oodef mutable struct C
                    
                    
                    
                end
                function close(self::@like(C))
push!(state, 1)
end


@oodef mutable struct C
                    
                    
                    
                end
                function close(self::@like(C))
push!(state, 1)
end


@oodef mutable struct ClosingTestCase <: unittest.TestCase
                    
                    
                    
                end
                function test_instance_docs(self::@like(ClosingTestCase))
cm_docstring = closing.__doc__
obj = closing(nothing)
@test (obj.__doc__ == cm_docstring)
end

function test_closing(self::@like(ClosingTestCase))
state = []
x = C()
@test (state == [])
closing(x) do y 
@test (x == y)
end
@test (state == [1])
end

function test_closing_error(self::@like(ClosingTestCase))
state = []
x = C()
@test (state == [])
@test_throws ZeroDivisionError do 
closing(x) do y 
@test (x == y)
1 / 0
end
end
@test (state == [1])
end


@oodef mutable struct C
                    
                    
                    
                end
                

@oodef mutable struct NullcontextTestCase <: unittest.TestCase
                    
                    
                    
                end
                function test_nullcontext(self::@like(NullcontextTestCase))
c = C()
nullcontext(c) do c_in 
@test self === c_in
end
end


@oodef mutable struct FileContextTestCase <: unittest.TestCase
                    
                    
                    
                end
                function testWithOpen(self::@like(FileContextTestCase))
tfn = tempfile.mktemp()
try
f = nothing
readline(tfn) do f 
@test !(f.closed)
write(f, "Booh\n")
end
@test f.closed
f = nothing
@test_throws ZeroDivisionError do 
readline(tfn) do f 
@test !(f.closed)
@test (read(f) == "Booh\n")
1 / 0
end
end
@test f.closed
finally
os_helper.unlink(tfn)
end
end


@oodef mutable struct LockContextTestCase <: unittest.TestCase
                    
                    
                    
                end
                function boilerPlate(self::@like(LockContextTestCase), lock, locked)
@test !(locked())
lock do 
@test locked()
end
@test !(locked())
@test_throws ZeroDivisionError do 
lock do 
@test locked()
1 / 0
end
end
@test !(locked())
end

function testWithLock(self::@like(LockContextTestCase))
lock_ = threading.Lock()
boilerPlate(self, lock_, lock_.locked)
end

function testWithRLock(self::@like(LockContextTestCase))
lock_ = threading.RLock()
boilerPlate(self, lock_, lock_._is_owned)
end

function testWithCondition(self::@like(LockContextTestCase))
lock_ = threading.Condition()
function locked()
return _is_owned(lock_)
end

boilerPlate(self, lock_, locked)
end

function testWithSemaphore(self::@like(LockContextTestCase))
lock_ = threading.Semaphore()
function locked()::Bool
if acquire(lock_, false)
release(lock_)
return false
else
return true
end
end

boilerPlate(self, lock_, locked)
end

function testWithBoundedSemaphore(self::@like(LockContextTestCase))
lock_ = threading.BoundedSemaphore()
function locked()::Bool
if acquire(lock_, false)
release(lock_)
return false
else
return true
end
end

boilerPlate(self, lock_, locked)
end


@oodef mutable struct mycontext <: ContextDecorator
                    #= Example decoration-compatible context manager for testing =#

                    catch_::Bool
exc
started::Bool
                    
function new(catch_::Bool = false, exc = exc, started::Bool = true)
catch_ = catch_
exc = exc
started = started
new(catch_, exc, started)
end

                end
                function __enter__(self::@like(mycontext))
self.started = true
return self
end

function __exit__(self::@like(mycontext), exc...)
self.exc = exc
return self.catch
end


@resumable function woohoo(y::TestContextDecorator)
append(state, y)
@yield
append(state, 999)
end

@oodef mutable struct Test <: object
                    
                    a
b
c
                    
function new(a = a, b = b, c = c)
a = a
b = b
c = c
new(a, b, c)
end

                end
                function method(self::@like(Test), a, b, c = nothing)
self.a = a
self.b = b
self.c = c
end


@oodef mutable struct mycontext <: ContextDecorator
                    
                    
                    
                end
                function __unter__(self::@like(mycontext))
#= pass =#
end

function __exit__(self::@like(mycontext), exc...)
#= pass =#
end


@oodef mutable struct mycontext <: ContextDecorator
                    
                    
                    
                end
                function __enter__(self::@like(mycontext))
#= pass =#
end

function __uxit__(self::@like(mycontext), exc...)
#= pass =#
end


@oodef mutable struct somecontext <: object
                    
                    exc
started::Bool
                    
function new(exc = exc, started::Bool = true)
exc = exc
started = started
new(exc, started)
end

                end
                function __enter__(self::@like(somecontext))
self.started = true
return self
end

function __exit__(self::@like(somecontext), exc...)
self.exc = exc
end


@oodef mutable struct mycontext <: {somecontext, ContextDecorator}
                    
                    exc
started::Bool
                    
function new(exc = exc, started::Bool = true)
exc = exc
started = started
new(exc, started)
end

                end
                

@oodef mutable struct TestContextDecorator <: unittest.TestCase
                    
                    
                    
                end
                function test_instance_docs(self::@like(TestContextDecorator))
cm_docstring = mycontext.__doc__
obj = mycontext()
@test (obj.__doc__ == cm_docstring)
end

function test_contextdecorator(self::@like(TestContextDecorator))
context = mycontext()
context do result 
@test self === result
@test context.started
end
@test (context.exc == (nothing, nothing, nothing))
end

function test_contextdecorator_with_exception(self::@like(TestContextDecorator))
context = mycontext()
assertRaisesRegex(self, NameError, "foo") do 
context do 
throw(NameError("foo"))
end
end
assertIsNotNone(self, context.exc)
@test self === context.exc[1]
context = mycontext()
context.catch = true
context do 
throw(NameError("foo"))
end
assertIsNotNone(self, context.exc)
@test self === context.exc[1]
end

function test_decorator(self::@like(TestContextDecorator))
context = mycontext()
function test()
assertIsNone(self, context.exc)
@test context.started
end

test()
@test (context.exc == (nothing, nothing, nothing))
end

function test_decorator_with_exception(self::@like(TestContextDecorator))
context = mycontext()
function test()
assertIsNone(self, context.exc)
@test context.started
throw(NameError("foo"))
end

assertRaisesRegex(self, NameError, "foo") do 
test()
end
assertIsNotNone(self, context.exc)
@test self === context.exc[1]
end

function test_decorating_method(self::@like(TestContextDecorator))
context = mycontext()
test = Test()
method(test, 1, 2)
@test (test.a == 1)
@test (test.b == 2)
@test (test.c == nothing)
test = Test()
method(test, "a", "b", "c")
@test (test.a == "a")
@test (test.b == "b")
@test (test.c == "c")
test = Test()
method(test, a = 1, b = 2)
@test (test.a == 1)
@test (test.b == 2)
end

function test_typo_enter(self::@like(TestContextDecorator))
@test_throws AttributeError do 
mycontext() do 
#= pass =#
end
end
end

function test_typo_exit(self::@like(TestContextDecorator))
@test_throws AttributeError do 
mycontext() do 
#= pass =#
end
end
end

function test_contextdecorator_as_mixin(self::@like(TestContextDecorator))
context = mycontext()
function test()
assertIsNone(self, context.exc)
@test context.started
end

test()
@test (context.exc == (nothing, nothing, nothing))
end

function test_contextmanager_as_decorator(self::@like(TestContextDecorator))
state = []
function test(x::@like(TestContextDecorator))
@test (state == [1])
push!(state, x)
end

test("something")
@test (state == [1, "something", 999])
state = []
test("something else")
@test (state == [1, "something else", 999])
end


@resumable function my_cm()
try
@yield
catch exn
if exn isa BaseException
exc = MyException()
try
throw(exc)
finally
exc.__context__ = nothing
end
end
end
end

@resumable function my_cm_with_exit_stack()
exit_stack(self) do stack 
enter_context(stack, my_cm())
@yield stack
end
end

@resumable function gets_the_context_right(exc::TestBaseExitStack)
try
@yield
finally
throw(exc)
end
end

@resumable function second()
try
@yield 1
catch exn
 let exc = exn
if exc isa Exception
throw(UniqueException("new exception"))
end
end
end
end

@resumable function first()
try
@yield 1
catch exn
 let exc = exn
if exc isa Exception
throw(exc)
end
end
end
end

@oodef mutable struct ExitCM <: object
                    
                    check_exc
                    
function new(check_exc)
@mk begin
check_exc = check_exc
end
end

                end
                function __enter__(self::@like(ExitCM))
fail(self, "Should not be called!")
end

function __exit__(self::@like(ExitCM), exc_details...)
check_exc(self, exc_details...)
end


@oodef mutable struct TestCM <: object
                    
                    
                    
                end
                function __enter__(self::@like(TestCM))
append(result, 1)
end

function __exit__(self::@like(TestCM), exc_details...)
append(result, 3)
end


@oodef mutable struct RaiseExc
                    
                    exc
                    
function new(exc)
@mk begin
exc = exc
end
end

                end
                function __enter__(self::@like(RaiseExc))
return self
end

function __exit__(self::@like(RaiseExc), exc_details...)
throw(self.exc)
end


@oodef mutable struct RaiseExcWithContext
                    
                    outer
inner
                    
function new(outer, inner)
@mk begin
outer = outer
inner = inner
end
end

                end
                function __enter__(self::@like(RaiseExcWithContext))
return self
end

function __exit__(self::@like(RaiseExcWithContext), exc_details...)
try
throw(self.inner)
catch exn
throw(self.outer)
end
end


@oodef mutable struct SuppressExc
                    
                    
                    
                end
                function __enter__(self::@like(SuppressExc))
return self
end

function __exit__(self::@like(SuppressExc), exc_details...)::Bool
type_().saved_details = exc_details
return true
end


@oodef mutable struct MyException <: Exception
                    
                    
                    
                end
                

@oodef mutable struct Example <: object
                    
                    
                    
                end
                

@oodef mutable struct UniqueException <: Exception
                    
                    
                    
                end
                

@oodef mutable struct UniqueRuntimeError <: RuntimeError
                    
                    
                    
                end
                

@oodef mutable struct TestBaseExitStack
                    
                    exit_stack
                    
function new(exit_stack = nothing)
exit_stack = exit_stack
new(exit_stack)
end

                end
                function test_instance_docs(self::@like(TestBaseExitStack))
cm_docstring = self.exit_stack.__doc__
obj = exit_stack(self)
assertEqual(self, obj.__doc__, cm_docstring)
end

function test_no_resources(self::@like(TestBaseExitStack))
exit_stack(self) do 
#= pass =#
end
end

function test_callback(self::@like(TestBaseExitStack))
expected = [((), Dict()), ((1,), Dict()), ((1, 2), Dict()), ((), dict(example = 1)), ((1,), dict(example = 1)), ((1, 2), dict(example = 1)), ((1, 2), dict(self = 3, callback = 4))]
result = []
function _exit(args...)
#= Test metadata propagation =#
push!(result, (args, kwds))
end

exit_stack(self) do stack 
for (args, kwds) in reversed(expected)
if args&&kwds
f = callback(stack, _exit, args..., None = kwds)
elseif args
f = callback(stack, _exit, args...)
elseif kwds
f = callback(stack, _exit, None = kwds)
else
f = callback(stack, _exit)
end
assertIs(self, f, _exit)
end
for wrapper in stack._exit_callbacks
assertIs(self, wrapper[2].__wrapped__, _exit)
assertNotEqual(self, wrapper[2].__name__, _exit.__name__)
assertIsNone(self, wrapper[2].__doc__, _exit.__doc__)
end
end
assertEqual(self, result, expected)
result = []
exit_stack(self) do stack 
assertRaises(self, TypeError) do 
callback(stack, arg = 1)
end
assertRaises(self, TypeError) do 
callback(self.exit_stack, arg = 2)
end
assertRaises(self, TypeError) do 
callback(stack, callback = _exit, arg = 3)
end
end
assertEqual(self, result, [])
end

function test_push(self::@like(TestBaseExitStack))
exc_raised = ZeroDivisionError
function _expect_exc(exc_type::@like(TestBaseExitStack), exc, exc_tb)
assertIs(self, exc_type, exc_raised)
end

function _suppress_exc(exc_details...)::Bool
return true
end

function _expect_ok(exc_type::@like(TestBaseExitStack), exc, exc_tb)
assertIsNone(self, exc_type)
assertIsNone(self, exc)
assertIsNone(self, exc_tb)
end

exit_stack(self) do stack 
push(stack, _expect_ok)
assertIs(self, stack._exit_callbacks[end][2], _expect_ok)
cm = ExitCM(_expect_ok)
push(stack, cm)
assertIs(self, stack._exit_callbacks[end][2].__self__, cm)
push(stack, _suppress_exc)
assertIs(self, stack._exit_callbacks[end][2], _suppress_exc)
cm = ExitCM(_expect_exc)
push(stack, cm)
assertIs(self, stack._exit_callbacks[end][2].__self__, cm)
push(stack, _expect_exc)
assertIs(self, stack._exit_callbacks[end][2], _expect_exc)
push(stack, _expect_exc)
assertIs(self, stack._exit_callbacks[end][2], _expect_exc)
1 / 0
end
end

function test_enter_context(self::@like(TestBaseExitStack))
result = []
cm = TestCM()
exit_stack(self) do stack 
function _exit()
push!(result, 4)
end

assertIsNotNone(self, _exit)
enter_context(stack, cm)
assertIs(self, stack._exit_callbacks[end][2].__self__, cm)
push!(result, 2)
end
assertEqual(self, result, [1, 2, 3, 4])
end

function test_close(self::@like(TestBaseExitStack))
result = []
exit_stack(self) do stack 
function _exit()
push!(result, 1)
end

assertIsNotNone(self, _exit)
close(stack)
push!(result, 2)
end
assertEqual(self, result, [1, 2])
end

function test_pop_all(self::@like(TestBaseExitStack))
result = []
exit_stack(self) do stack 
function _exit()
push!(result, 3)
end

assertIsNotNone(self, _exit)
new_stack = pop_all(stack)
push!(result, 1)
end
push!(result, 2)
close(new_stack)
assertEqual(self, result, [1, 2, 3])
end

function test_exit_raise(self::@like(TestBaseExitStack))
assertRaises(self, ZeroDivisionError) do 
exit_stack(self) do stack 
push(stack, () -> false)
1 / 0
end
end
end

function test_exit_suppress(self::@like(TestBaseExitStack))
exit_stack(self) do stack 
push(stack, () -> true)
1 / 0
end
end

function test_exit_exception_chaining_reference(self::@like(TestBaseExitStack))
try
RaiseExc(IndexError) do 
RaiseExcWithContext(KeyError, AttributeError) do 
SuppressExc() do 
RaiseExc(ValueError) do 
1 / 0
end
end
end
end
catch exn
 let exc = exn
if exc isa IndexError
assertIsInstance(self, exc.__context__, KeyError)
assertIsInstance(self, exc.__context__.__context__, AttributeError)
assertIsNone(self, exc.__context__.__context__.__context__)
end
end
end
inner_exc = SuppressExc.saved_details[2]
assertIsInstance(self, inner_exc, ValueError)
assertIsInstance(self, inner_exc.__context__, ZeroDivisionError)
end

function test_exit_exception_chaining(self::@like(TestBaseExitStack))
function raise_exc(exc::@like(TestBaseExitStack))
throw(exc)
end

saved_details = nothing
function suppress_exc(exc_details...)::Bool
# Not Supported
# nonlocal saved_details
saved_details = exc_details
return true
end

try
exit_stack(self) do stack 
callback(stack, raise_exc, IndexError)
callback(stack, raise_exc, KeyError)
callback(stack, raise_exc, AttributeError)
push(stack, suppress_exc)
callback(stack, raise_exc, ValueError)
1 / 0
end
catch exn
 let exc = exn
if exc isa IndexError
assertIsInstance(self, exc.__context__, KeyError)
assertIsInstance(self, exc.__context__.__context__, AttributeError)
assertIsNone(self, exc.__context__.__context__.__context__)
end
end
end
inner_exc = saved_details[2]
assertIsInstance(self, inner_exc, ValueError)
assertIsInstance(self, inner_exc.__context__, ZeroDivisionError)
end

@resumable function test_exit_exception_explicit_none_context(self::@like(TestBaseExitStack))
for cm in (my_cm, my_cm_with_exit_stack)
subTest(self) do 
try
cm() do 
throw(IndexError())
end
catch exn
 let exc = exn
if exc isa MyException
assertIsNone(self, exc.__context__)
end
end
end
end
end
end

function test_exit_exception_non_suppressing(self::@like(TestBaseExitStack))
function raise_exc(exc::@like(TestBaseExitStack))
throw(exc)
end

function suppress_exc(exc_details...)::Bool
return true
end

try
exit_stack(self) do stack 
callback(stack, () -> nothing)
callback(stack, raise_exc, IndexError)
end
catch exn
 let exc = exn
if exc isa Exception
assertIsInstance(self, exc, IndexError)
end
end
end
try
exit_stack(self) do stack 
callback(stack, raise_exc, KeyError)
push(stack, suppress_exc)
callback(stack, raise_exc, IndexError)
end
catch exn
 let exc = exn
if exc isa Exception
assertIsInstance(self, exc, KeyError)
end
end
end
end

@resumable function test_exit_exception_with_correct_context(self::@like(TestBaseExitStack))
exc1 = Exception(1)
exc2 = Exception(2)
exc3 = Exception(3)
exc4 = Exception(4)
try
exit_stack(self) do stack 
enter_context(stack, gets_the_context_right(exc4))
enter_context(stack, gets_the_context_right(exc3))
enter_context(stack, gets_the_context_right(exc2))
throw(exc1)
end
catch exn
 let exc = exn
if exc isa Exception
assertIs(self, exc, exc4)
assertIs(self, exc.__context__, exc3)
assertIs(self, exc.__context__.__context__, exc2)
assertIs(self, exc.__context__.__context__.__context__, exc1)
assertIsNone(self, exc.__context__.__context__.__context__.__context__)
end
end
end
end

function test_exit_exception_with_existing_context(self::@like(TestBaseExitStack))
function raise_nested(inner_exc::@like(TestBaseExitStack), outer_exc)
try
throw(inner_exc)
finally
throw(outer_exc)
end
end

exc1 = Exception(1)
exc2 = Exception(2)
exc3 = Exception(3)
exc4 = Exception(4)
exc5 = Exception(5)
try
exit_stack(self) do stack 
callback(stack, raise_nested, exc4, exc5)
callback(stack, raise_nested, exc2, exc3)
throw(exc1)
end
catch exn
 let exc = exn
if exc isa Exception
assertIs(self, exc, exc5)
assertIs(self, exc.__context__, exc4)
assertIs(self, exc.__context__.__context__, exc3)
assertIs(self, exc.__context__.__context__.__context__, exc2)
assertIs(self, exc.__context__.__context__.__context__.__context__, exc1)
assertIsNone(self, exc.__context__.__context__.__context__.__context__.__context__)
end
end
end
end

function test_body_exception_suppress(self::@like(TestBaseExitStack))
function suppress_exc(exc_details...)::Bool
return true
end

try
exit_stack(self) do stack 
push(stack, suppress_exc)
1 / 0
end
catch exn
 let exc = exn
if exc isa IndexError
fail(self, "Expected no exception, got IndexError")
end
end
end
end

function test_exit_exception_chaining_suppress(self::@like(TestBaseExitStack))
exit_stack(self) do stack 
push(stack, () -> true)
push(stack, () -> 1 / 0)
push(stack, () -> Dict{Any}()[1])
end
end

function test_excessive_nesting(self::@like(TestBaseExitStack))
exit_stack(self) do stack 
for i in 0:9999
callback(stack, Int64)
end
end
end

function test_instance_bypass(self::@like(TestBaseExitStack))
cm = Example()
cm.__exit__ = object()
stack = exit_stack(self)
assertRaises(self, AttributeError, stack.enter_context, cm)
push(stack, cm)
assertIs(self, stack._exit_callbacks[end][2], cm)
end

@resumable function test_dont_reraise_RuntimeError(self::@like(TestBaseExitStack))
assertRaises(self, UniqueException) do err_ctx 
exit_stack(self) do es_ctx 
enter_context(es_ctx, second())
enter_context(es_ctx, first())
throw(UniqueRuntimeError("please no infinite loop."))
end
end
exc = err_ctx.exception
assertIsInstance(self, exc, UniqueException)
assertIsInstance(self, exc.__context__, UniqueRuntimeError)
assertIsNone(self, exc.__context__.__context__)
assertIsNone(self, exc.__context__.__cause__)
assertIs(self, exc.__cause__, exc.__context__)
end


@oodef mutable struct TestExitStack <: {TestBaseExitStack, unittest.TestCase}
                    
                    exit_stack
                    
function new(exit_stack = ExitStack)
exit_stack = exit_stack
new(exit_stack)
end

                end
                

@oodef mutable struct TestRedirectStream
                    
                    orig_stream
redirect_stream
                    
function new(orig_stream = nothing, redirect_stream = nothing)
orig_stream = orig_stream
redirect_stream = redirect_stream
new(orig_stream, redirect_stream)
end

                end
                function test_instance_docs(self::@like(TestRedirectStream))
cm_docstring = self.redirect_stream.__doc__
obj = redirect_stream(self, nothing)
assertEqual(self, obj.__doc__, cm_docstring)
end

function test_no_redirect_in_init(self::@like(TestRedirectStream))
orig_stdout = getfield(sys, :self.orig_stream)
redirect_stream(self, nothing)
assertIs(self, getfield(sys, :self.orig_stream), orig_stdout)
end

function test_redirect_to_string_io(self::@like(TestRedirectStream))
f = io.StringIO()
msg = "Consider an API like help(), which prints directly to stdout"
orig_stdout = getfield(sys, :self.orig_stream)
redirect_stream(self, f) do 
write(getfield(sys, :self.orig_stream), "$(msg)")
end
assertIs(self, getfield(sys, :self.orig_stream), orig_stdout)
s = strip(getvalue(f))
assertEqual(self, s, msg)
end

function test_enter_result_is_target(self::@like(TestRedirectStream))
f = io.StringIO()
redirect_stream(self, f) do enter_result 
assertIs(self, enter_result, f)
end
end

function test_cm_is_reusable(self::@like(TestRedirectStream))
f = io.StringIO()
write_to_f = redirect_stream(self, f)
orig_stdout = getfield(sys, :self.orig_stream)
write_to_f do 
write(getfield(sys, :self.orig_stream), "Hello")
end
write_to_f do 
write(getfield(sys, :self.orig_stream), "World!")
end
assertIs(self, getfield(sys, :self.orig_stream), orig_stdout)
s = getvalue(f)
assertEqual(self, s, "Hello World!\n")
end

function test_cm_is_reentrant(self::@like(TestRedirectStream))
f = io.StringIO()
write_to_f = redirect_stream(self, f)
orig_stdout = getfield(sys, :self.orig_stream)
write_to_f do 
write(getfield(sys, :self.orig_stream), "Hello")
write_to_f do 
write(getfield(sys, :self.orig_stream), "World!")
end
end
assertIs(self, getfield(sys, :self.orig_stream), orig_stdout)
s = getvalue(f)
assertEqual(self, s, "Hello World!\n")
end


@oodef mutable struct TestRedirectStdout <: {TestRedirectStream, unittest.TestCase}
                    
                    orig_stream::String
redirect_stream
                    
function new(orig_stream::String = "stdout", redirect_stream = redirect_stdout)
orig_stream = orig_stream
redirect_stream = redirect_stream
new(orig_stream, redirect_stream)
end

                end
                

@oodef mutable struct TestRedirectStderr <: {TestRedirectStream, unittest.TestCase}
                    
                    orig_stream::String
redirect_stream
                    
function new(orig_stream::String = "stderr", redirect_stream = redirect_stderr)
orig_stream = orig_stream
redirect_stream = redirect_stream
new(orig_stream, redirect_stream)
end

                end
                

@oodef mutable struct TestSuppress <: unittest.TestCase
                    
                    
                    
                end
                function test_instance_docs(self::@like(TestSuppress))
cm_docstring = suppress.__doc__
obj = suppress()
@test (obj.__doc__ == cm_docstring)
end

function test_no_result_from_enter(self::@like(TestSuppress))
suppress(ValueError) do enter_result 
assertIsNone(self, enter_result)
end
end

function test_no_exception(self::@like(TestSuppress))
suppress(ValueError) do 
@test (pow(2, 5) == 32)
end
end

function test_exact_exception(self::@like(TestSuppress))
suppress(TypeError) do 
length(5)
end
end

function test_exception_hierarchy(self::@like(TestSuppress))
suppress(LookupError) do 
"Hello"[51]
end
end

function test_other_exception(self::@like(TestSuppress))
@test_throws ZeroDivisionError do 
suppress(TypeError) do 
1 / 0
end
end
end

function test_no_args(self::@like(TestSuppress))
@test_throws ZeroDivisionError do 
suppress() do 
1 / 0
end
end
end

function test_multiple_exception_args(self::@like(TestSuppress))
suppress(ZeroDivisionError, TypeError) do 
1 / 0
end
suppress(ZeroDivisionError, TypeError) do 
length(5)
end
end

function test_cm_is_reentrant(self::@like(TestSuppress))
ignore_exceptions = suppress(Exception)
ignore_exceptions do 
#= pass =#
end
ignore_exceptions do 
length(5)
end
ignore_exceptions do 
ignore_exceptions do 
length(5)
end
outer_continued = true
1 / 0
end
@test outer_continued
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
end