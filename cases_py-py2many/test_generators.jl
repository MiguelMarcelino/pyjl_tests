# Transpiled with flags: 
# - oop
using ObjectOriented
using ResumableFunctions
using Test

import copy
import gc




import inspect

try
import _testcapi
catch exn
if exn isa ImportError
_testcapi = nothing
end
end
@oodef mutable struct SignalAndYieldFromTest <: unittest.TestCase
                    
                    
                    
                end
                @resumable function generator1(self::@like(SignalAndYieldFromTest))
return # Unsupported
# yield_from generator2(self)
end

@resumable function generator2(self::@like(SignalAndYieldFromTest))::String
try
@yield
catch exn
if exn isa KeyboardInterrupt
return "PASSED"
end
end
end

function test_raise_and_yield_from(self::@like(SignalAndYieldFromTest))
gen = generator1(self)
send(gen, nothing)
try
_testcapi.raise_SIGINT_then_send_None(gen)
catch exn
 let _exc = exn
if _exc isa BaseException
exc = _exc
end
end
end
@test self === type_(exc)
@test (exc.value == "PASSED")
end


@resumable function gen()
# Not Supported
# nonlocal frame
try
@yield
finally
frame = sys._getframe()
end
end

@resumable function gen()
# Not Supported
# nonlocal finalized
try
g = @yield
@yield 1
finally
finalized = true
end
end

@resumable function g()
return @yield 1
end

@resumable function g2()
return # Unsupported
# yield_from g()
end

@resumable function g3()
return # Unsupported
# yield_from f()
end

@oodef mutable struct FinalizationTest <: unittest.TestCase
                    
                    
                    
                end
                @resumable function test_frame_resurrect(self::@like(FinalizationTest))
g = gen()
wr = weakref.ref(g)
g()
# Delete Unsupported
# del(g)
support.gc_collect()
@test self === wr()
@test frame
# Delete Unsupported
# del(frame)
support.gc_collect()
end

@resumable function test_refcycle(self::@like(FinalizationTest))
old_garbage = gc.garbage[begin:end]
finalized = false
g = gen()
g()
send(g, g)
assertGreater(self, sys.getrefcount(g), 2)
@test !(finalized)
# Delete Unsupported
# del(g)
support.gc_collect()
@test finalized
@test (gc.garbage == old_garbage)
end

@resumable function test_lambda_generator(self::@like(FinalizationTest))
f = () -> @yield 1
f2 = () -> # Unsupported
# yield_from g()
f3 = () -> # Unsupported
# yield_from f()
for gen_fun in (f, g, f2, g2, f3, g3)
gen = gen_fun()
@test (gen() == 1)
@test_throws StopIteration do cm 
send(gen, 2)
end
@test (cm.exception.value == 2)
end
end


@resumable function func()
@yield 1
end

@resumable function f()
@yield 1
end

@resumable function f()
@yield 1
end

@resumable function f()
@yield 1
end

@oodef mutable struct GeneratorTest <: unittest.TestCase
                    
                    
                    
                end
                @resumable function test_name(self::@like(GeneratorTest))
gen = func()
@test (gen.__name__ == "func")
@test (gen.__qualname__ == "GeneratorTest.test_name.<locals>.func")
gen.__name__ = "name"
gen.__qualname__ = "qualname"
@test (gen.__name__ == "name")
@test (gen.__qualname__ == "qualname")
@test_throws
@test_throws
@test_throws
@test_throws
func.__qualname__ = "func_qualname"
func.__name__ = "func_name"
gen = func()
@test (gen.__name__ == "func_name")
@test (gen.__qualname__ == "func_qualname")
gen = (x for x in 0:9)
@test (gen.__name__ == "<genexpr>")
@test (gen.__qualname__ == "GeneratorTest.test_name.<locals>.<genexpr>")
end

@resumable function test_copy(self::@like(GeneratorTest))
g = f()
@test_throws TypeError do 
copy.copy(g)
end
end

@resumable function test_pickle(self::@like(GeneratorTest))
g = f()
for proto in 0:pickle.HIGHEST_PROTOCOL
@test_throws (TypeError, pickle.PicklingError) do 
pickle.dumps(g, proto)
end
end
end

@resumable function test_send_non_none_to_new_gen(self::@like(GeneratorTest))
g = f()
@test_throws TypeError do 
send(g, 0)
end
@test (g() == 1)
end


@resumable function store_raise_exc_generator()
try
@test (sys.exc_info()[1] == nothing)
@yield
catch exn
 let exc = exn
if exc isa Exception
@test (sys.exc_info()[1] == ValueError)
assertIsNone(self, exc.__context__)
@yield
@test (sys.exc_info()[1] == ValueError)
@yield
error()
end
end
end
end

@resumable function gen()
@test (sys.exc_info()[1] == ValueError)
@yield "done"
end

@resumable function gen()
try
@test (sys.exc_info()[1] == nothing)
@yield
throw(TypeError())
catch exn
 let exc = exn
if exc isa TypeError
@test (sys.exc_info()[1] == TypeError)
@test (type_(exc.__context__) == ValueError)
end
end
end
@test (sys.exc_info()[1] == ValueError)
@yield
assertIsNone(self, sys.exc_info()[1])
@yield "done"
end

@resumable function gen()
try
try
@test (sys.exc_info()[1] == nothing)
@yield
catch exn
if exn isa ValueError
@test (sys.exc_info()[1] == ValueError)
throw(TypeError())
end
end
catch exn
 let exc = exn
if exc isa Exception
@test (sys.exc_info()[1] == TypeError)
@test (type_(exc.__context__) == ValueError)
end
end
end
@test (sys.exc_info()[1] == ValueError)
@yield
assertIsNone(self, sys.exc_info()[1])
@yield "done"
end

@resumable function boring_generator()
@yield
end

@resumable function generator()
assertRaisesRegex(self, TypeError, err_msg) do 
@yield
end
end

@resumable function gen()
throw(StopIteration)
@yield
end

@resumable function f()
@yield 1
throw(StopIteration)
@yield 2
end

@resumable function g()
return @yield 1
end

@resumable function g()
return @yield 1
end

@oodef mutable struct E <: Exception
                    
                    
                    
                end
                function __new__(cls::@like(E), args...)
return cls
end


@oodef mutable struct ExceptionTest <: unittest.TestCase
                    
                    
                    
                end
                @resumable function test_except_throw(self::@like(ExceptionTest))
make = store_raise_exc_generator()
make()
try
throw(ValueError())
catch exn
 let exc = exn
if exc isa Exception
try
throw(make, exc)
catch exn
if exn isa Exception
#= pass =#
end
end
end
end
end
make()
@test_throws ValueError do cm 
make()
end
assertIsNone(self, cm.exception.__context__)
@test (sys.exc_info() == (nothing, nothing, nothing))
end

@resumable function test_except_next(self::@like(ExceptionTest))
g = gen()
try
throw(ValueError)
catch exn
if exn isa Exception
@test (g() == "done")
end
end
@test (sys.exc_info() == (nothing, nothing, nothing))
end

@resumable function test_except_gen_except(self::@like(ExceptionTest))
g = gen()
g()
try
throw(ValueError)
catch exn
if exn isa Exception
g()
end
end
@test (g() == "done")
@test (sys.exc_info() == (nothing, nothing, nothing))
end

@resumable function test_except_throw_exception_context(self::@like(ExceptionTest))
g = gen()
g()
try
throw(ValueError)
catch exn
 let exc = exn
if exc isa Exception
throw(g, exc)
end
end
end
@test (g() == "done")
@test (sys.exc_info() == (nothing, nothing, nothing))
end

@resumable function test_except_throw_bad_exception(self::@like(ExceptionTest))
gen = boring_generator()
err_msg = "should have returned an instance of BaseException"
assertRaisesRegex(self, TypeError, err_msg) do 
throw(gen, E)
end
@test_throws
gen = generator()
gen()
@test_throws StopIteration do 
throw(gen, E)
end
end

@resumable function test_stopiteration_error(self::@like(ExceptionTest))
assertRaisesRegex(self, RuntimeError, "raised StopIteration") do 
next(gen())
end
end

@resumable function test_tutorial_stopiteration(self::@like(ExceptionTest))
g = f()
@test (g() == 1)
assertRaisesRegex(self, RuntimeError, "raised StopIteration") do 
g()
end
end

@resumable function test_return_tuple(self::@like(ExceptionTest))
gen = g()
@test (gen() == 1)
@test_throws StopIteration do cm 
send(gen, (2,))
end
@test (cm.exception.value == (2,))
end

@resumable function test_return_stopiteration(self::@like(ExceptionTest))
gen = g()
@test (gen() == 1)
@test_throws StopIteration do cm 
send(gen, StopIteration(2))
end
@test isa(self, cm.exception.value)
@test (cm.exception.value.value == 2)
end


@resumable function f()
try
throw(KeyError("a"))
catch exn
if exn isa Exception
@yield
end
end
end

@resumable function f()
try
throw(KeyError("a"))
catch exn
if exn isa Exception
try
@yield
catch exn
 let exc = exn
if exc isa Exception
@test (type_(exc) == ValueError)
context = exc.__context__
@test ((type_(context), context.args) == (KeyError, ("a",)))
@yield "b"
end
end
end
end
end
end

@resumable function f()
@yield
end

@resumable function g()
try
throw(KeyError("a"))
catch exn
if exn isa Exception
# Unsupported
# yield_from f()
end
end
end

@resumable function f()
@yield
end

@resumable function g(exc::GeneratorThrowTest)
# Not Supported
# nonlocal has_cycle
try
throw(exc)
catch exn
if exn isa Exception
try
# Unsupported
# yield_from f()
catch exn
 let exc = exn
if exc isa Exception
has_cycle = exc === exc.__context__
end
end
end
end
end
@yield
end

@resumable function g()
try
throw(KeyError)
catch exn
if exn isa KeyError
#= pass =#
end
end
try
@yield
catch exn
if exn isa Exception
throw(RuntimeError)
end
end
end

@oodef mutable struct GeneratorThrowTest <: unittest.TestCase
                    
                    
                    
                end
                @resumable function test_exception_context_with_yield(self::@like(GeneratorThrowTest))
gen = f()
send(gen, nothing)
@test_throws ValueError do cm 
throw(gen, ValueError)
end
context = cm.exception.__context__
@test ((type_(context), context.args) == (KeyError, ("a",)))
end

@resumable function test_exception_context_with_yield_inside_generator(self::@like(GeneratorThrowTest))
gen = f()
send(gen, nothing)
actual = throw(gen, ValueError)
@test (actual == "b")
end

@resumable function test_exception_context_with_yield_from(self::@like(GeneratorThrowTest))
gen = g()
send(gen, nothing)
@test_throws ValueError do cm 
throw(gen, ValueError)
end
context = cm.exception.__context__
@test ((type_(context), context.args) == (KeyError, ("a",)))
end

@resumable function test_exception_context_with_yield_from_with_context_cycle(self::@like(GeneratorThrowTest))
has_cycle = nothing
exc = KeyError("a")
gen = g(exc)
send(gen, nothing)
throw(gen, exc)
@test (has_cycle == false)
end

@resumable function test_throw_after_none_exc_type(self::@like(GeneratorThrowTest))
gen = g()
send(gen, nothing)
@test_throws RuntimeError do cm 
throw(gen, ValueError)
end
end


@resumable function f()
check_stack_names(self, sys._getframe(), ["f", "g"])
try
@yield
catch exn
if exn isa Exception
#= pass =#
end
end
check_stack_names(self, sys._getframe(), ["f", "g"])
end

@resumable function g()
check_stack_names(self, sys._getframe(), ["g"])
# Unsupported
# yield_from f()
check_stack_names(self, sys._getframe(), ["g"])
end

@oodef mutable struct GeneratorStackTraceTest <: unittest.TestCase
                    
                    
                    
                end
                function check_stack_names(self::@like(GeneratorStackTraceTest), frame, expected)
names_ = []
while frame
name = frame.f_code.co_name
if startswith(name, "check_")||startswith(name, "call_")
break;
end
push!(names_, name)
frame = frame.f_back
end
@test (names_ == expected)
end

@resumable function check_yield_from_example(self::@like(GeneratorStackTraceTest), call_method)
gen = g()
send(gen, nothing)
try
call_method(gen)
catch exn
if exn isa StopIteration
#= pass =#
end
end
end

function test_send_with_yield_from(self::@like(GeneratorStackTraceTest))
function call_send(gen::@like(GeneratorStackTraceTest))
send(gen, nothing)
end

check_yield_from_example(self, call_send)
end

function test_throw_with_yield_from(self::@like(GeneratorStackTraceTest))
function call_throw(gen::@like(GeneratorStackTraceTest))
throw(gen, RuntimeError)
end

check_yield_from_example(self, call_throw)
end


@resumable function a()
@test (inspect.getgeneratorstate(gen_b) == inspect.GEN_RUNNING)
assertIsNone(self, gen_b.gi_yieldfrom)
@yield
@test (inspect.getgeneratorstate(gen_b) == inspect.GEN_RUNNING)
assertIsNone(self, gen_b.gi_yieldfrom)
end

@resumable function b()
assertIsNone(self, gen_b.gi_yieldfrom)
# Unsupported
# yield_from a()
assertIsNone(self, gen_b.gi_yieldfrom)
@yield
assertIsNone(self, gen_b.gi_yieldfrom)
end

@oodef mutable struct YieldFromTests <: unittest.TestCase
                    
                    
                    
                end
                @resumable function test_generator_gi_yieldfrom(self::@like(YieldFromTests))
gen_b = b()
@test (inspect.getgeneratorstate(gen_b) == inspect.GEN_CREATED)
assertIsNone(self, gen_b.gi_yieldfrom)
send(gen_b, nothing)
@test (inspect.getgeneratorstate(gen_b) == inspect.GEN_SUSPENDED)
@test (gen_b.gi_yieldfrom.gi_code.co_name == "a")
send(gen_b, nothing)
@test (inspect.getgeneratorstate(gen_b) == inspect.GEN_SUSPENDED)
assertIsNone(self, gen_b.gi_yieldfrom)
() = gen_b
@test (inspect.getgeneratorstate(gen_b) == inspect.GEN_CLOSED)
assertIsNone(self, gen_b.gi_yieldfrom)
end


tutorial_tests = "\nLet\'s try a simple generator:\n\n    >>> def f():\n    ...    yield 1\n    ...    yield 2\n\n    >>> for i in f():\n    ...     print(i)\n    1\n    2\n    >>> g = f()\n    >>> next(g)\n    1\n    >>> next(g)\n    2\n\n\"Falling off the end\" stops the generator:\n\n    >>> next(g)\n    Traceback (most recent call last):\n      File \"<stdin>\", line 1, in ?\n      File \"<stdin>\", line 2, in g\n    StopIteration\n\n\"return\" also stops the generator:\n\n    >>> def f():\n    ...     yield 1\n    ...     return\n    ...     yield 2 # never reached\n    ...\n    >>> g = f()\n    >>> next(g)\n    1\n    >>> next(g)\n    Traceback (most recent call last):\n      File \"<stdin>\", line 1, in ?\n      File \"<stdin>\", line 3, in f\n    StopIteration\n    >>> next(g) # once stopped, can\'t be resumed\n    Traceback (most recent call last):\n      File \"<stdin>\", line 1, in ?\n    StopIteration\n\nHowever, \"return\" and StopIteration are not exactly equivalent:\n\n    >>> def g1():\n    ...     try:\n    ...         return\n    ...     except:\n    ...         yield 1\n    ...\n    >>> list(g1())\n    []\n\n    >>> def g2():\n    ...     try:\n    ...         raise StopIteration\n    ...     except:\n    ...         yield 42\n    >>> print(list(g2()))\n    [42]\n\nThis may be surprising at first:\n\n    >>> def g3():\n    ...     try:\n    ...         return\n    ...     finally:\n    ...         yield 1\n    ...\n    >>> list(g3())\n    [1]\n\nLet\'s create an alternate range() function implemented as a generator:\n\n    >>> def yrange(n):\n    ...     for i in range(n):\n    ...         yield i\n    ...\n    >>> list(yrange(5))\n    [0, 1, 2, 3, 4]\n\nGenerators always return to the most recent caller:\n\n    >>> def creator():\n    ...     r = yrange(5)\n    ...     print(\"creator\", next(r))\n    ...     return r\n    ...\n    >>> def caller():\n    ...     r = creator()\n    ...     for i in r:\n    ...             print(\"caller\", i)\n    ...\n    >>> caller()\n    creator 0\n    caller 1\n    caller 2\n    caller 3\n    caller 4\n\nGenerators can call other generators:\n\n    >>> def zrange(n):\n    ...     for i in yrange(n):\n    ...         yield i\n    ...\n    >>> list(zrange(5))\n    [0, 1, 2, 3, 4]\n\n"
pep_tests = "\n\nSpecification:  Yield\n\n    Restriction:  A generator cannot be resumed while it is actively\n    running:\n\n    >>> def g():\n    ...     i = next(me)\n    ...     yield i\n    >>> me = g()\n    >>> next(me)\n    Traceback (most recent call last):\n     ...\n      File \"<string>\", line 2, in g\n    ValueError: generator already executing\n\nSpecification: Return\n\n    Note that return isn\'t always equivalent to raising StopIteration:  the\n    difference lies in how enclosing try/except constructs are treated.\n    For example,\n\n        >>> def f1():\n        ...     try:\n        ...         return\n        ...     except:\n        ...        yield 1\n        >>> print(list(f1()))\n        []\n\n    because, as in any function, return simply exits, but\n\n        >>> def f2():\n        ...     try:\n        ...         raise StopIteration\n        ...     except:\n        ...         yield 42\n        >>> print(list(f2()))\n        [42]\n\n    because StopIteration is captured by a bare \"except\", as is any\n    exception.\n\nSpecification: Generators and Exception Propagation\n\n    >>> def f():\n    ...     return 1//0\n    >>> def g():\n    ...     yield f()  # the zero division exception propagates\n    ...     yield 42   # and we\'ll never get here\n    >>> k = g()\n    >>> next(k)\n    Traceback (most recent call last):\n      File \"<stdin>\", line 1, in ?\n      File \"<stdin>\", line 2, in g\n      File \"<stdin>\", line 2, in f\n    ZeroDivisionError: integer division or modulo by zero\n    >>> next(k)  # and the generator cannot be resumed\n    Traceback (most recent call last):\n      File \"<stdin>\", line 1, in ?\n    StopIteration\n    >>>\n\nSpecification: Try/Except/Finally\n\n    >>> def f():\n    ...     try:\n    ...         yield 1\n    ...         try:\n    ...             yield 2\n    ...             1//0\n    ...             yield 3  # never get here\n    ...         except ZeroDivisionError:\n    ...             yield 4\n    ...             yield 5\n    ...             raise\n    ...         except:\n    ...             yield 6\n    ...         yield 7     # the \"raise\" above stops this\n    ...     except:\n    ...         yield 8\n    ...     yield 9\n    ...     try:\n    ...         x = 12\n    ...     finally:\n    ...         yield 10\n    ...     yield 11\n    >>> print(list(f()))\n    [1, 2, 4, 5, 8, 9, 10, 11]\n    >>>\n\nGuido\'s binary tree example.\n\n    >>> # A binary tree class.\n    >>> class Tree:\n    ...\n    ...     def __init__(self, label, left=None, right=None):\n    ...         self.label = label\n    ...         self.left = left\n    ...         self.right = right\n    ...\n    ...     def __repr__(self, level=0, indent=\"    \"):\n    ...         s = level*indent + repr(self.label)\n    ...         if self.left:\n    ...             s = s + \"\\n\" + self.left.__repr__(level+1, indent)\n    ...         if self.right:\n    ...             s = s + \"\\n\" + self.right.__repr__(level+1, indent)\n    ...         return s\n    ...\n    ...     def __iter__(self):\n    ...         return inorder(self)\n\n    >>> # Create a Tree from a list.\n    >>> def tree(list):\n    ...     n = len(list)\n    ...     if n == 0:\n    ...         return []\n    ...     i = n // 2\n    ...     return Tree(list[i], tree(list[:i]), tree(list[i+1:]))\n\n    >>> # Show it off: create a tree.\n    >>> t = tree(\"ABCDEFGHIJKLMNOPQRSTUVWXYZ\")\n\n    >>> # A recursive generator that generates Tree labels in in-order.\n    >>> def inorder(t):\n    ...     if t:\n    ...         for x in inorder(t.left):\n    ...             yield x\n    ...         yield t.label\n    ...         for x in inorder(t.right):\n    ...             yield x\n\n    >>> # Show it off: create a tree.\n    >>> t = tree(\"ABCDEFGHIJKLMNOPQRSTUVWXYZ\")\n    >>> # Print the nodes of the tree in in-order.\n    >>> for x in t:\n    ...     print(\' \'+x, end=\'\')\n     A B C D E F G H I J K L M N O P Q R S T U V W X Y Z\n\n    >>> # A non-recursive generator.\n    >>> def inorder(node):\n    ...     stack = []\n    ...     while node:\n    ...         while node.left:\n    ...             stack.append(node)\n    ...             node = node.left\n    ...         yield node.label\n    ...         while not node.right:\n    ...             try:\n    ...                 node = stack.pop()\n    ...             except IndexError:\n    ...                 return\n    ...             yield node.label\n    ...         node = node.right\n\n    >>> # Exercise the non-recursive generator.\n    >>> for x in t:\n    ...     print(\' \'+x, end=\'\')\n     A B C D E F G H I J K L M N O P Q R S T U V W X Y Z\n\n"
email_tests = "\n\nThe difference between yielding None and returning it.\n\n>>> def g():\n...     for i in range(3):\n...         yield None\n...     yield None\n...     return\n>>> list(g())\n[None, None, None, None]\n\nEnsure that explicitly raising StopIteration acts like any other exception\nin try/except, not like a return.\n\n>>> def g():\n...     yield 1\n...     try:\n...         raise StopIteration\n...     except:\n...         yield 2\n...     yield 3\n>>> list(g())\n[1, 2, 3]\n\nNext one was posted to c.l.py.\n\n>>> def gcomb(x, k):\n...     \"Generate all combinations of k elements from list x.\"\n...\n...     if k > len(x):\n...         return\n...     if k == 0:\n...         yield []\n...     else:\n...         first, rest = x[0], x[1:]\n...         # A combination does or doesn\'t contain first.\n...         # If it does, the remainder is a k-1 comb of rest.\n...         for c in gcomb(rest, k-1):\n...             c.insert(0, first)\n...             yield c\n...         # If it doesn\'t contain first, it\'s a k comb of rest.\n...         for c in gcomb(rest, k):\n...             yield c\n\n>>> seq = list(range(1, 5))\n>>> for k in range(len(seq) + 2):\n...     print(\"%d-combs of %s:\" % (k, seq))\n...     for c in gcomb(seq, k):\n...         print(\"   \", c)\n0-combs of [1, 2, 3, 4]:\n    []\n1-combs of [1, 2, 3, 4]:\n    [1]\n    [2]\n    [3]\n    [4]\n2-combs of [1, 2, 3, 4]:\n    [1, 2]\n    [1, 3]\n    [1, 4]\n    [2, 3]\n    [2, 4]\n    [3, 4]\n3-combs of [1, 2, 3, 4]:\n    [1, 2, 3]\n    [1, 2, 4]\n    [1, 3, 4]\n    [2, 3, 4]\n4-combs of [1, 2, 3, 4]:\n    [1, 2, 3, 4]\n5-combs of [1, 2, 3, 4]:\n\nFrom the Iterators list, about the types of these things.\n\n>>> def g():\n...     yield 1\n...\n>>> type(g)\n<class \'function\'>\n>>> i = g()\n>>> type(i)\n<class \'generator\'>\n>>> [s for s in dir(i) if not s.startswith(\'_\')]\n[\'close\', \'gi_code\', \'gi_frame\', \'gi_running\', \'gi_yieldfrom\', \'send\', \'throw\']\n>>> from test.support import HAVE_DOCSTRINGS\n>>> print(i.__next__.__doc__ if HAVE_DOCSTRINGS else \'Implement next(self).\')\nImplement next(self).\n>>> iter(i) is i\nTrue\n>>> import types\n>>> isinstance(i, types.GeneratorType)\nTrue\n\nAnd more, added later.\n\n>>> i.gi_running\n0\n>>> type(i.gi_frame)\n<class \'frame\'>\n>>> i.gi_running = 42\nTraceback (most recent call last):\n  ...\nAttributeError: attribute \'gi_running\' of \'generator\' objects is not writable\n>>> def g():\n...     yield me.gi_running\n>>> me = g()\n>>> me.gi_running\n0\n>>> next(me)\n1\n>>> me.gi_running\n0\n\nA clever union-find implementation from c.l.py, due to David Eppstein.\nSent: Friday, June 29, 2001 12:16 PM\nTo: python-list@python.org\nSubject: Re: PEP 255: Simple Generators\n\n>>> class disjointSet:\n...     def __init__(self, name):\n...         self.name = name\n...         self.parent = None\n...         self.generator = self.generate()\n...\n...     def generate(self):\n...         while not self.parent:\n...             yield self\n...         for x in self.parent.generator:\n...             yield x\n...\n...     def find(self):\n...         return next(self.generator)\n...\n...     def union(self, parent):\n...         if self.parent:\n...             raise ValueError(\"Sorry, I\'m not a root!\")\n...         self.parent = parent\n...\n...     def __str__(self):\n...         return self.name\n\n>>> names = \"ABCDEFGHIJKLM\"\n>>> sets = [disjointSet(name) for name in names]\n>>> roots = sets[:]\n\n>>> import random\n>>> gen = random.Random(42)\n>>> while 1:\n...     for s in sets:\n...         print(\" %s->%s\" % (s, s.find()), end=\'\')\n...     print()\n...     if len(roots) > 1:\n...         s1 = gen.choice(roots)\n...         roots.remove(s1)\n...         s2 = gen.choice(roots)\n...         s1.union(s2)\n...         print(\"merged\", s1, \"into\", s2)\n...     else:\n...         break\n A->A B->B C->C D->D E->E F->F G->G H->H I->I J->J K->K L->L M->M\nmerged K into B\n A->A B->B C->C D->D E->E F->F G->G H->H I->I J->J K->B L->L M->M\nmerged A into F\n A->F B->B C->C D->D E->E F->F G->G H->H I->I J->J K->B L->L M->M\nmerged E into F\n A->F B->B C->C D->D E->F F->F G->G H->H I->I J->J K->B L->L M->M\nmerged D into C\n A->F B->B C->C D->C E->F F->F G->G H->H I->I J->J K->B L->L M->M\nmerged M into C\n A->F B->B C->C D->C E->F F->F G->G H->H I->I J->J K->B L->L M->C\nmerged J into B\n A->F B->B C->C D->C E->F F->F G->G H->H I->I J->B K->B L->L M->C\nmerged B into C\n A->F B->C C->C D->C E->F F->F G->G H->H I->I J->C K->C L->L M->C\nmerged F into G\n A->G B->C C->C D->C E->G F->G G->G H->H I->I J->C K->C L->L M->C\nmerged L into C\n A->G B->C C->C D->C E->G F->G G->G H->H I->I J->C K->C L->C M->C\nmerged G into I\n A->I B->C C->C D->C E->I F->I G->I H->H I->I J->C K->C L->C M->C\nmerged I into H\n A->H B->C C->C D->C E->H F->H G->H H->H I->H J->C K->C L->C M->C\nmerged C into H\n A->H B->H C->H D->H E->H F->H G->H H->H I->H J->H K->H L->H M->H\n\n"
fun_tests = "\n\nBuild up to a recursive Sieve of Eratosthenes generator.\n\n>>> def firstn(g, n):\n...     return [next(g) for i in range(n)]\n\n>>> def intsfrom(i):\n...     while 1:\n...         yield i\n...         i += 1\n\n>>> firstn(intsfrom(5), 7)\n[5, 6, 7, 8, 9, 10, 11]\n\n>>> def exclude_multiples(n, ints):\n...     for i in ints:\n...         if i % n:\n...             yield i\n\n>>> firstn(exclude_multiples(3, intsfrom(1)), 6)\n[1, 2, 4, 5, 7, 8]\n\n>>> def sieve(ints):\n...     prime = next(ints)\n...     yield prime\n...     not_divisible_by_prime = exclude_multiples(prime, ints)\n...     for p in sieve(not_divisible_by_prime):\n...         yield p\n\n>>> primes = sieve(intsfrom(2))\n>>> firstn(primes, 20)\n[2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71]\n\n\nAnother famous problem:  generate all integers of the form\n    2**i * 3**j  * 5**k\nin increasing order, where i,j,k >= 0.  Trickier than it may look at first!\nTry writing it without generators, and correctly, and without generating\n3 internal results for each result output.\n\n>>> def times(n, g):\n...     for i in g:\n...         yield n * i\n>>> firstn(times(10, intsfrom(1)), 10)\n[10, 20, 30, 40, 50, 60, 70, 80, 90, 100]\n\n>>> def merge(g, h):\n...     ng = next(g)\n...     nh = next(h)\n...     while 1:\n...         if ng < nh:\n...             yield ng\n...             ng = next(g)\n...         elif ng > nh:\n...             yield nh\n...             nh = next(h)\n...         else:\n...             yield ng\n...             ng = next(g)\n...             nh = next(h)\n\nThe following works, but is doing a whale of a lot of redundant work --\nit\'s not clear how to get the internal uses of m235 to share a single\ngenerator.  Note that me_times2 (etc) each need to see every element in the\nresult sequence.  So this is an example where lazy lists are more natural\n(you can look at the head of a lazy list any number of times).\n\n>>> def m235():\n...     yield 1\n...     me_times2 = times(2, m235())\n...     me_times3 = times(3, m235())\n...     me_times5 = times(5, m235())\n...     for i in merge(merge(me_times2,\n...                          me_times3),\n...                    me_times5):\n...         yield i\n\nDon\'t print \"too many\" of these -- the implementation above is extremely\ninefficient:  each call of m235() leads to 3 recursive calls, and in\nturn each of those 3 more, and so on, and so on, until we\'ve descended\nenough levels to satisfy the print stmts.  Very odd:  when I printed 5\nlines of results below, this managed to screw up Win98\'s malloc in \"the\nusual\" way, i.e. the heap grew over 4Mb so Win98 started fragmenting\naddress space, and it *looked* like a very slow leak.\n\n>>> result = m235()\n>>> for i in range(3):\n...     print(firstn(result, 15))\n[1, 2, 3, 4, 5, 6, 8, 9, 10, 12, 15, 16, 18, 20, 24]\n[25, 27, 30, 32, 36, 40, 45, 48, 50, 54, 60, 64, 72, 75, 80]\n[81, 90, 96, 100, 108, 120, 125, 128, 135, 144, 150, 160, 162, 180, 192]\n\nHeh.  Here\'s one way to get a shared list, complete with an excruciating\nnamespace renaming trick.  The *pretty* part is that the times() and merge()\nfunctions can be reused as-is, because they only assume their stream\narguments are iterable -- a LazyList is the same as a generator to times().\n\n>>> class LazyList:\n...     def __init__(self, g):\n...         self.sofar = []\n...         self.fetch = g.__next__\n...\n...     def __getitem__(self, i):\n...         sofar, fetch = self.sofar, self.fetch\n...         while i >= len(sofar):\n...             sofar.append(fetch())\n...         return sofar[i]\n\n>>> def m235():\n...     yield 1\n...     # Gack:  m235 below actually refers to a LazyList.\n...     me_times2 = times(2, m235)\n...     me_times3 = times(3, m235)\n...     me_times5 = times(5, m235)\n...     for i in merge(merge(me_times2,\n...                          me_times3),\n...                    me_times5):\n...         yield i\n\nPrint as many of these as you like -- *this* implementation is memory-\nefficient.\n\n>>> m235 = LazyList(m235())\n>>> for i in range(5):\n...     print([m235[j] for j in range(15*i, 15*(i+1))])\n[1, 2, 3, 4, 5, 6, 8, 9, 10, 12, 15, 16, 18, 20, 24]\n[25, 27, 30, 32, 36, 40, 45, 48, 50, 54, 60, 64, 72, 75, 80]\n[81, 90, 96, 100, 108, 120, 125, 128, 135, 144, 150, 160, 162, 180, 192]\n[200, 216, 225, 240, 243, 250, 256, 270, 288, 300, 320, 324, 360, 375, 384]\n[400, 405, 432, 450, 480, 486, 500, 512, 540, 576, 600, 625, 640, 648, 675]\n\nYe olde Fibonacci generator, LazyList style.\n\n>>> def fibgen(a, b):\n...\n...     def sum(g, h):\n...         while 1:\n...             yield next(g) + next(h)\n...\n...     def tail(g):\n...         next(g)    # throw first away\n...         for x in g:\n...             yield x\n...\n...     yield a\n...     yield b\n...     for s in sum(iter(fib),\n...                  tail(iter(fib))):\n...         yield s\n\n>>> fib = LazyList(fibgen(1, 2))\n>>> firstn(iter(fib), 17)\n[1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144, 233, 377, 610, 987, 1597, 2584]\n\n\nRunning after your tail with itertools.tee (new in version 2.4)\n\nThe algorithms \"m235\" (Hamming) and Fibonacci presented above are both\nexamples of a whole family of FP (functional programming) algorithms\nwhere a function produces and returns a list while the production algorithm\nsuppose the list as already produced by recursively calling itself.\nFor these algorithms to work, they must:\n\n- produce at least a first element without presupposing the existence of\n  the rest of the list\n- produce their elements in a lazy manner\n\nTo work efficiently, the beginning of the list must not be recomputed over\nand over again. This is ensured in most FP languages as a built-in feature.\nIn python, we have to explicitly maintain a list of already computed results\nand abandon genuine recursivity.\n\nThis is what had been attempted above with the LazyList class. One problem\nwith that class is that it keeps a list of all of the generated results and\ntherefore continually grows. This partially defeats the goal of the generator\nconcept, viz. produce the results only as needed instead of producing them\nall and thereby wasting memory.\n\nThanks to itertools.tee, it is now clear \"how to get the internal uses of\nm235 to share a single generator\".\n\n>>> from itertools import tee\n>>> def m235():\n...     def _m235():\n...         yield 1\n...         for n in merge(times(2, m2),\n...                        merge(times(3, m3),\n...                              times(5, m5))):\n...             yield n\n...     m1 = _m235()\n...     m2, m3, m5, mRes = tee(m1, 4)\n...     return mRes\n\n>>> it = m235()\n>>> for i in range(5):\n...     print(firstn(it, 15))\n[1, 2, 3, 4, 5, 6, 8, 9, 10, 12, 15, 16, 18, 20, 24]\n[25, 27, 30, 32, 36, 40, 45, 48, 50, 54, 60, 64, 72, 75, 80]\n[81, 90, 96, 100, 108, 120, 125, 128, 135, 144, 150, 160, 162, 180, 192]\n[200, 216, 225, 240, 243, 250, 256, 270, 288, 300, 320, 324, 360, 375, 384]\n[400, 405, 432, 450, 480, 486, 500, 512, 540, 576, 600, 625, 640, 648, 675]\n\nThe \"tee\" function does just what we want. It internally keeps a generated\nresult for as long as it has not been \"consumed\" from all of the duplicated\niterators, whereupon it is deleted. You can therefore print the hamming\nsequence during hours without increasing memory usage, or very little.\n\nThe beauty of it is that recursive running-after-their-tail FP algorithms\nare quite straightforwardly expressed with this Python idiom.\n\nYe olde Fibonacci generator, tee style.\n\n>>> def fib():\n...\n...     def _isum(g, h):\n...         while 1:\n...             yield next(g) + next(h)\n...\n...     def _fib():\n...         yield 1\n...         yield 2\n...         next(fibTail) # throw first away\n...         for res in _isum(fibHead, fibTail):\n...             yield res\n...\n...     realfib = _fib()\n...     fibHead, fibTail, fibRes = tee(realfib, 3)\n...     return fibRes\n\n>>> firstn(fib(), 17)\n[1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144, 233, 377, 610, 987, 1597, 2584]\n\n"
syntax_tests = "\n\nThese are fine:\n\n>>> def f():\n...     yield 1\n...     return\n\n>>> def f():\n...     try:\n...         yield 1\n...     finally:\n...         pass\n\n>>> def f():\n...     try:\n...         try:\n...             1//0\n...         except ZeroDivisionError:\n...             yield 666\n...         except:\n...             pass\n...     finally:\n...         pass\n\n>>> def f():\n...     try:\n...         try:\n...             yield 12\n...             1//0\n...         except ZeroDivisionError:\n...             yield 666\n...         except:\n...             try:\n...                 x = 12\n...             finally:\n...                 yield 12\n...     except:\n...         return\n>>> list(f())\n[12, 666]\n\n>>> def f():\n...    yield\n>>> type(f())\n<class \'generator\'>\n\n\n>>> def f():\n...    if 0:\n...        yield\n>>> type(f())\n<class \'generator\'>\n\n\n>>> def f():\n...     if 0:\n...         yield 1\n>>> type(f())\n<class \'generator\'>\n\n>>> def f():\n...    if \"\":\n...        yield None\n>>> type(f())\n<class \'generator\'>\n\n>>> def f():\n...     return\n...     try:\n...         if x==4:\n...             pass\n...         elif 0:\n...             try:\n...                 1//0\n...             except SyntaxError:\n...                 pass\n...             else:\n...                 if 0:\n...                     while 12:\n...                         x += 1\n...                         yield 2 # don\'t blink\n...                         f(a, b, c, d, e)\n...         else:\n...             pass\n...     except:\n...         x = 1\n...     return\n>>> type(f())\n<class \'generator\'>\n\n>>> def f():\n...     if 0:\n...         def g():\n...             yield 1\n...\n>>> type(f())\n<class \'NoneType\'>\n\n>>> def f():\n...     if 0:\n...         class C:\n...             def __init__(self):\n...                 yield 1\n...             def f(self):\n...                 yield 2\n>>> type(f())\n<class \'NoneType\'>\n\n>>> def f():\n...     if 0:\n...         return\n...     if 0:\n...         yield 2\n>>> type(f())\n<class \'generator\'>\n\nThis one caused a crash (see SF bug 567538):\n\n>>> def f():\n...     for i in range(3):\n...         try:\n...             continue\n...         finally:\n...             yield i\n...\n>>> g = f()\n>>> print(next(g))\n0\n>>> print(next(g))\n1\n>>> print(next(g))\n2\n>>> print(next(g))\nTraceback (most recent call last):\nStopIteration\n\n\nTest the gi_code attribute\n\n>>> def f():\n...     yield 5\n...\n>>> g = f()\n>>> g.gi_code is f.__code__\nTrue\n>>> next(g)\n5\n>>> next(g)\nTraceback (most recent call last):\nStopIteration\n>>> g.gi_code is f.__code__\nTrue\n\n\nTest the __name__ attribute and the repr()\n\n>>> def f():\n...    yield 5\n...\n>>> g = f()\n>>> g.__name__\n\'f\'\n>>> repr(g)  # doctest: +ELLIPSIS\n\'<generator object f at ...>\'\n\nLambdas shouldn\'t have their usual return behavior.\n\n>>> x = lambda: (yield 1)\n>>> list(x())\n[1]\n\n>>> x = lambda: ((yield 1), (yield 2))\n>>> list(x())\n[1, 2]\n"
@resumable function gen(i)
if i >= length(gs)
@yield values
else
for values(i + 1) in gs[i + 1]()
for x in gen(i + 1)
@yield x
end
end
end
end

@resumable function simple_conjoin(gs)
values_ = repeat([nothing],length(gs))
for x in gen(0)
@yield x
end
end

@resumable function gen(i)
if i >= n
@yield values
elseif (n - i) % 3
ip1 = i + 1
for values(i + 1) in gs[i + 1]()
for x in gen(ip1)
@yield x
end
end
else
for x in _gen3(i)
@yield x
end
end
end

@resumable function _gen3(i)
@assert(i < n&&((n - i) % 3) == 0)
(ip1, ip2, ip3) = (i + 1, i + 2, i + 3)
(g, g1, g2) = gs[i + 1:ip3]
if ip3 >= n
for values(i + 1) in g()
for values(ip1 + 1) in g1()
for values(ip2 + 1) in g2()
@yield values
end
end
end
else
for values(i + 1) in g()
for values(ip1 + 1) in g1()
for values(ip2 + 1) in g2()
for x in _gen3(ip3)
@yield x
end
end
end
end
end
end

@resumable function conjoin(gs)
n = length(gs)
values_ = repeat([nothing],n)
for x in gen(0)
@yield x
end
end

@resumable function flat_conjoin(gs)
n = length(gs)
values_ = repeat([nothing],n)
iters = repeat([nothing],n)
_StopIteration = StopIteration
i = 0
while true
try
while i < n
it=iters[i + 1] = gs[i + 1]().__next__
values_[i + 1] = it()
i += 1
end
catch exn
if exn isa _StopIteration
#= pass =#
end
end
i -= 1
has_break = false
while i >= 0
try
values_[i + 1] = iters[i + 1]()
i += 1
break;
catch exn
if exn isa _StopIteration
i -= 1
end
end
end
if has_break != true
@assert(i < 0)
break;
end
end
end

@oodef mutable struct Queens
                    
                    n
rowgenerators::Vector
                    
@resumable function new(n, rowgenerators::Vector = [])
rangen = 0:n - 1
for i in rangen
rowuses = [((1 << j) | (1 << ((((n + i) - j) + n) - 1))) | (1 << ((((n + 2*n) - 1) + i) + j)) for j in rangen]
@resumable function rowgen(rowuses::@like(Queens) = rowuses)
for j in rangen
uses = rowuses[j + 1]
if (uses & self.used) == 0
self.used |= uses
@yield j
self.used &= ~uses
end
end
end

push!(self.rowgenerators, rowgen)
end
@mk begin
n = n
rowgenerators = rowgenerators
used = used
end
end

                end
                @resumable function solve(self::@like(Queens))
self.used = 0
for row2col in conjoin(self.rowgenerators)
@yield row2col
end
end

function printsolution(self::@like(Queens), row2col)
n = self.n
@assert(n == length(row2col))
sep = "+" + "-+"*n
println(sep)
for i in 0:n - 1
squares = [" " for j in 0:n - 1]
squares[row2col[i + 1] + 1] = "Q"
println("|$(join(squares, "|"))|")
println(sep)
end
end


@resumable function first()
if m < 1||n < 1
return
end
corner = coords2index(self, 0, 0)
remove_from_successors(corner)
self.lastij = corner
@yield corner
add_to_successors(corner)
end

@resumable function second()
corner = coords2index(self, 0, 0)
@assert(self.lastij == corner)
if m < 3||n < 3
return
end
@assert(length(succs[corner + 1]) == 2)
@assert(coords2index(self, 1, 2) ∈ succs[corner + 1])
@assert(coords2index(self, 2, 1) ∈ succs[corner + 1])
for (i, j) in ((1, 2), (2, 1))
this = coords2index(self, i, j)
final = coords2index(self, 3 - i, 3 - j)
self.final = final
remove_from_successors(this)
append(succs[final + 1], corner)
self.lastij = this
@yield this
remove(succs[final + 1], corner)
add_to_successors(this)
end
end

@resumable function advance(len::Knights = len)
candidates = []
has_break = false
for i in succs[self.lastij + 1]
e = length(succs[i + 1])
@assert(e > 0)
if e == 1
candidates = [(e, i)]
has_break = true
break;
end
push!(candidates, (e, i))
end
if has_break != true
sort(candidates)
end
for (e, i) in candidates
if i != self.final
if remove_from_successors(i)
self.lastij = i
@yield i
end
add_to_successors(i)
end
end
end

@resumable function advance_hard(vmid::Knights = (m - 1) / 2.0, hmid = (n - 1) / 2.0, len = len)
candidates = []
has_break = false
for i in succs[self.lastij + 1]
e = length(succs[i + 1])
@assert(e > 0)
if e == 1
candidates = [(e, 0, i)]
has_break = true
break;
end
(i1, j1) = index2coords(self, i)
d = (i1 - vmid)^2 + (j1 - hmid)^2
push!(candidates, (e, -d, i))
end
if has_break != true
sort(candidates)
end
for (e, d, i) in candidates
if i != self.final
if remove_from_successors(i)
self.lastij = i
@yield i
end
add_to_successors(i)
end
end
end

@resumable function last()
@assert(self.final ∈ succs[self.lastij + 1])
@yield self.final
end

@oodef mutable struct Knights
                    
                    
                    
@resumable function new(m, n, hard = 0)
(self.m, self.n) = (m, n)
succs=self.succs = []
function remove_from_successors(i0::@like(Knights), len = len)
ne0=ne1 = 0
for i in succs[i0 + 1]
s = succs[i + 1]
remove(s, i0)
e = length(s)
if e == 0
ne0 += 1
elseif e == 1
ne1 += 1
end
end
return ne0 == 0&&ne1 < 2
end

function add_to_successors(i0::@like(Knights))
for i in succs[i0 + 1]
append(succs[i + 1], i0)
end
end

if (m*n) < 4
self.squaregenerators = [first]
else
self.squaregenerators = ([first, second] + [hard&&advance_hard||advance]*(m*n - 3)) + [last]
end
@mk begin
squaregenerators = squaregenerators
end
end

                end
                function coords2index(self::@like(Knights), i, j)
@assert(0 <= i < self.m)
@assert(0 <= j < self.n)
return i*self.n + j
end

function index2coords(self::@like(Knights), index)
@assert(0 <= index < (self.m*self.n))
return div(index)
end

function _init_board(self::@like(Knights))
succs = self.succs
deleteat!(succs, begin:end)
(m, n) = (self.m, self.n)
c2i = self.coords2index
offsets = [(1, 2), (2, 1), (2, -1), (1, -2), (-1, -2), (-2, -1), (-2, 1), (-1, 2)]
rangen = 0:n - 1
for i in 0:m - 1
for j in rangen
s = [c2i(i + io, j + jo) for (io, jo) in offsets if 0 <= (i + io) < m&&0 <= (j + jo) < n ]
push!(succs, s)
end
end
end

@resumable function solve(self::@like(Knights))
_init_board(self)
for x in conjoin(self.squaregenerators)
@yield x
end
end

function printsolution(self::@like(Knights), x)
(m, n) = (self.m, self.n)
@assert(length(x) == (m*n))
w = length(string(m*n))
format = "%" * string(w) * "d"
squares = [[nothing]*n for i in 0:m - 1]
k = 1
for i in x
(i1, j1) = index2coords(self, i)
squares[i1 + 1][j1 + 1] = format % k
k += 1
end
sep = "+" + repeat("-",w) * "+"*n
println(sep)
for i in 0:m - 1
row = squares[i + 1]
println("|$(join(row, "|"))|")
println(sep)
end
end


conjoin_tests = "\n\nGenerate the 3-bit binary numbers in order.  This illustrates dumbest-\npossible use of conjoin, just to generate the full cross-product.\n\n>>> for c in conjoin([lambda: iter((0, 1))] * 3):\n...     print(c)\n[0, 0, 0]\n[0, 0, 1]\n[0, 1, 0]\n[0, 1, 1]\n[1, 0, 0]\n[1, 0, 1]\n[1, 1, 0]\n[1, 1, 1]\n\nFor efficiency in typical backtracking apps, conjoin() yields the same list\nobject each time.  So if you want to save away a full account of its\ngenerated sequence, you need to copy its results.\n\n>>> def gencopy(iterator):\n...     for x in iterator:\n...         yield x[:]\n\n>>> for n in range(10):\n...     all = list(gencopy(conjoin([lambda: iter((0, 1))] * n)))\n...     print(n, len(all), all[0] == [0] * n, all[-1] == [1] * n)\n0 1 True True\n1 2 True True\n2 4 True True\n3 8 True True\n4 16 True True\n5 32 True True\n6 64 True True\n7 128 True True\n8 256 True True\n9 512 True True\n\nAnd run an 8-queens solver.\n\n>>> q = Queens(8)\n>>> LIMIT = 2\n>>> count = 0\n>>> for row2col in q.solve():\n...     count += 1\n...     if count <= LIMIT:\n...         print(\"Solution\", count)\n...         q.printsolution(row2col)\nSolution 1\n+-+-+-+-+-+-+-+-+\n|Q| | | | | | | |\n+-+-+-+-+-+-+-+-+\n| | | | |Q| | | |\n+-+-+-+-+-+-+-+-+\n| | | | | | | |Q|\n+-+-+-+-+-+-+-+-+\n| | | | | |Q| | |\n+-+-+-+-+-+-+-+-+\n| | |Q| | | | | |\n+-+-+-+-+-+-+-+-+\n| | | | | | |Q| |\n+-+-+-+-+-+-+-+-+\n| |Q| | | | | | |\n+-+-+-+-+-+-+-+-+\n| | | |Q| | | | |\n+-+-+-+-+-+-+-+-+\nSolution 2\n+-+-+-+-+-+-+-+-+\n|Q| | | | | | | |\n+-+-+-+-+-+-+-+-+\n| | | | | |Q| | |\n+-+-+-+-+-+-+-+-+\n| | | | | | | |Q|\n+-+-+-+-+-+-+-+-+\n| | |Q| | | | | |\n+-+-+-+-+-+-+-+-+\n| | | | | | |Q| |\n+-+-+-+-+-+-+-+-+\n| | | |Q| | | | |\n+-+-+-+-+-+-+-+-+\n| |Q| | | | | | |\n+-+-+-+-+-+-+-+-+\n| | | | |Q| | | |\n+-+-+-+-+-+-+-+-+\n\n>>> print(count, \"solutions in all.\")\n92 solutions in all.\n\nAnd run a Knight\'s Tour on a 10x10 board.  Note that there are about\n20,000 solutions even on a 6x6 board, so don\'t dare run this to exhaustion.\n\n>>> k = Knights(10, 10)\n>>> LIMIT = 2\n>>> count = 0\n>>> for x in k.solve():\n...     count += 1\n...     if count <= LIMIT:\n...         print(\"Solution\", count)\n...         k.printsolution(x)\n...     else:\n...         break\nSolution 1\n+---+---+---+---+---+---+---+---+---+---+\n|  1| 58| 27| 34|  3| 40| 29| 10|  5|  8|\n+---+---+---+---+---+---+---+---+---+---+\n| 26| 35|  2| 57| 28| 33|  4|  7| 30| 11|\n+---+---+---+---+---+---+---+---+---+---+\n| 59|100| 73| 36| 41| 56| 39| 32|  9|  6|\n+---+---+---+---+---+---+---+---+---+---+\n| 74| 25| 60| 55| 72| 37| 42| 49| 12| 31|\n+---+---+---+---+---+---+---+---+---+---+\n| 61| 86| 99| 76| 63| 52| 47| 38| 43| 50|\n+---+---+---+---+---+---+---+---+---+---+\n| 24| 75| 62| 85| 54| 71| 64| 51| 48| 13|\n+---+---+---+---+---+---+---+---+---+---+\n| 87| 98| 91| 80| 77| 84| 53| 46| 65| 44|\n+---+---+---+---+---+---+---+---+---+---+\n| 90| 23| 88| 95| 70| 79| 68| 83| 14| 17|\n+---+---+---+---+---+---+---+---+---+---+\n| 97| 92| 21| 78| 81| 94| 19| 16| 45| 66|\n+---+---+---+---+---+---+---+---+---+---+\n| 22| 89| 96| 93| 20| 69| 82| 67| 18| 15|\n+---+---+---+---+---+---+---+---+---+---+\nSolution 2\n+---+---+---+---+---+---+---+---+---+---+\n|  1| 58| 27| 34|  3| 40| 29| 10|  5|  8|\n+---+---+---+---+---+---+---+---+---+---+\n| 26| 35|  2| 57| 28| 33|  4|  7| 30| 11|\n+---+---+---+---+---+---+---+---+---+---+\n| 59|100| 73| 36| 41| 56| 39| 32|  9|  6|\n+---+---+---+---+---+---+---+---+---+---+\n| 74| 25| 60| 55| 72| 37| 42| 49| 12| 31|\n+---+---+---+---+---+---+---+---+---+---+\n| 61| 86| 99| 76| 63| 52| 47| 38| 43| 50|\n+---+---+---+---+---+---+---+---+---+---+\n| 24| 75| 62| 85| 54| 71| 64| 51| 48| 13|\n+---+---+---+---+---+---+---+---+---+---+\n| 87| 98| 89| 80| 77| 84| 53| 46| 65| 44|\n+---+---+---+---+---+---+---+---+---+---+\n| 90| 23| 92| 95| 70| 79| 68| 83| 14| 17|\n+---+---+---+---+---+---+---+---+---+---+\n| 97| 88| 21| 78| 81| 94| 19| 16| 45| 66|\n+---+---+---+---+---+---+---+---+---+---+\n| 22| 91| 96| 93| 20| 69| 82| 67| 18| 15|\n+---+---+---+---+---+---+---+---+---+---+\n"
weakref_tests = "Generators are weakly referencable:\n\n>>> import weakref\n>>> def gen():\n...     yield \'foo!\'\n...\n>>> wr = weakref.ref(gen)\n>>> wr() is gen\nTrue\n>>> p = weakref.proxy(gen)\n\nGenerator-iterators are weakly referencable as well:\n\n>>> gi = gen()\n>>> wr = weakref.ref(gi)\n>>> wr() is gi\nTrue\n>>> p = weakref.proxy(gi)\n>>> list(p)\n[\'foo!\']\n\n"
coroutine_tests = ">>> from test.support import gc_collect\n\nSending a value into a started generator:\n\n>>> def f():\n...     print((yield 1))\n...     yield 2\n>>> g = f()\n>>> next(g)\n1\n>>> g.send(42)\n42\n2\n\nSending a value into a new generator produces a TypeError:\n\n>>> f().send(\"foo\")\nTraceback (most recent call last):\n...\nTypeError: can\'t send non-None value to a just-started generator\n\n\nYield by itself yields None:\n\n>>> def f(): yield\n>>> list(f())\n[None]\n\n\nYield is allowed only in the outermost iterable in generator expression:\n\n>>> def f(): list(i for i in [(yield 26)])\n>>> type(f())\n<class \'generator\'>\n\n\nA yield expression with augmented assignment.\n\n>>> def coroutine(seq):\n...     count = 0\n...     while count < 200:\n...         count += yield\n...         seq.append(count)\n>>> seq = []\n>>> c = coroutine(seq)\n>>> next(c)\n>>> print(seq)\n[]\n>>> c.send(10)\n>>> print(seq)\n[10]\n>>> c.send(10)\n>>> print(seq)\n[10, 20]\n>>> c.send(10)\n>>> print(seq)\n[10, 20, 30]\n\n\nCheck some syntax errors for yield expressions:\n\n>>> f=lambda: (yield 1),(yield 2)\nTraceback (most recent call last):\n  ...\nSyntaxError: \'yield\' outside function\n\n# Pegen does not produce this error message yet\n# >>> def f(): x = yield = y\n# Traceback (most recent call last):\n#   ...\n# SyntaxError: assignment to yield expression not possible\n\n>>> def f(): (yield bar) = y\nTraceback (most recent call last):\n  ...\nSyntaxError: cannot assign to yield expression here. Maybe you meant \'==\' instead of \'=\'?\n\n>>> def f(): (yield bar) += y\nTraceback (most recent call last):\n  ...\nSyntaxError: \'yield expression\' is an illegal expression for augmented assignment\n\n\nNow check some throw() conditions:\n\n>>> def f():\n...     while True:\n...         try:\n...             print((yield))\n...         except ValueError as v:\n...             print(\"caught ValueError (%s)\" % (v))\n>>> import sys\n>>> g = f()\n>>> next(g)\n\n>>> g.throw(ValueError) # type only\ncaught ValueError ()\n\n>>> g.throw(ValueError(\"xyz\"))  # value only\ncaught ValueError (xyz)\n\n>>> g.throw(ValueError, ValueError(1))   # value+matching type\ncaught ValueError (1)\n\n>>> g.throw(ValueError, TypeError(1))  # mismatched type, rewrapped\ncaught ValueError (1)\n\n>>> g.throw(ValueError, ValueError(1), None)   # explicit None traceback\ncaught ValueError (1)\n\n>>> g.throw(ValueError(1), \"foo\")       # bad args\nTraceback (most recent call last):\n  ...\nTypeError: instance exception may not have a separate value\n\n>>> g.throw(ValueError, \"foo\", 23)      # bad args\nTraceback (most recent call last):\n  ...\nTypeError: throw() third argument must be a traceback object\n\n>>> g.throw(\"abc\")\nTraceback (most recent call last):\n  ...\nTypeError: exceptions must be classes or instances deriving from BaseException, not str\n\n>>> g.throw(0)\nTraceback (most recent call last):\n  ...\nTypeError: exceptions must be classes or instances deriving from BaseException, not int\n\n>>> g.throw(list)\nTraceback (most recent call last):\n  ...\nTypeError: exceptions must be classes or instances deriving from BaseException, not type\n\n>>> def throw(g,exc):\n...     try:\n...         raise exc\n...     except:\n...         g.throw(*sys.exc_info())\n>>> throw(g,ValueError) # do it with traceback included\ncaught ValueError ()\n\n>>> g.send(1)\n1\n\n>>> throw(g,TypeError)  # terminate the generator\nTraceback (most recent call last):\n  ...\nTypeError\n\n>>> print(g.gi_frame)\nNone\n\n>>> g.send(2)\nTraceback (most recent call last):\n  ...\nStopIteration\n\n>>> g.throw(ValueError,6)       # throw on closed generator\nTraceback (most recent call last):\n  ...\nValueError: 6\n\n>>> f().throw(ValueError,7)     # throw on just-opened generator\nTraceback (most recent call last):\n  ...\nValueError: 7\n\nPlain \"raise\" inside a generator should preserve the traceback (#13188).\nThe traceback should have 3 levels:\n- g.throw()\n- f()\n- 1/0\n\n>>> def f():\n...     try:\n...         yield\n...     except:\n...         raise\n>>> g = f()\n>>> try:\n...     1/0\n... except ZeroDivisionError as v:\n...     try:\n...         g.throw(v)\n...     except Exception as w:\n...         tb = w.__traceback__\n>>> levels = 0\n>>> while tb:\n...     levels += 1\n...     tb = tb.tb_next\n>>> levels\n3\n\nNow let\'s try closing a generator:\n\n>>> def f():\n...     try: yield\n...     except GeneratorExit:\n...         print(\"exiting\")\n\n>>> g = f()\n>>> next(g)\n>>> g.close()\nexiting\n>>> g.close()  # should be no-op now\n\n>>> f().close()  # close on just-opened generator should be fine\n\n>>> def f(): yield      # an even simpler generator\n>>> f().close()         # close before opening\n>>> g = f()\n>>> next(g)\n>>> g.close()           # close normally\n\nAnd finalization:\n\n>>> def f():\n...     try: yield\n...     finally:\n...         print(\"exiting\")\n\n>>> g = f()\n>>> next(g)\n>>> del g; gc_collect()  # For PyPy or other GCs.\nexiting\n\n\nGeneratorExit is not caught by except Exception:\n\n>>> def f():\n...     try: yield\n...     except Exception:\n...         print(\'except\')\n...     finally:\n...         print(\'finally\')\n\n>>> g = f()\n>>> next(g)\n>>> del g; gc_collect()  # For PyPy or other GCs.\nfinally\n\n\nNow let\'s try some ill-behaved generators:\n\n>>> def f():\n...     try: yield\n...     except GeneratorExit:\n...         yield \"foo!\"\n>>> g = f()\n>>> next(g)\n>>> g.close()\nTraceback (most recent call last):\n  ...\nRuntimeError: generator ignored GeneratorExit\n>>> g.close()\n\n\nOur ill-behaved code should be invoked during GC:\n\n>>> with support.catch_unraisable_exception() as cm:\n...     g = f()\n...     next(g)\n...     del g\n...\n...     cm.unraisable.exc_type == RuntimeError\n...     \"generator ignored GeneratorExit\" in str(cm.unraisable.exc_value)\n...     cm.unraisable.exc_traceback is not None\nTrue\nTrue\nTrue\n\nAnd errors thrown during closing should propagate:\n\n>>> def f():\n...     try: yield\n...     except GeneratorExit:\n...         raise TypeError(\"fie!\")\n>>> g = f()\n>>> next(g)\n>>> g.close()\nTraceback (most recent call last):\n  ...\nTypeError: fie!\n\n\nEnsure that various yield expression constructs make their\nenclosing function a generator:\n\n>>> def f(): x += yield\n>>> type(f())\n<class \'generator\'>\n\n>>> def f(): x = yield\n>>> type(f())\n<class \'generator\'>\n\n>>> def f(): lambda x=(yield): 1\n>>> type(f())\n<class \'generator\'>\n\n>>> def f(d): d[(yield \"a\")] = d[(yield \"b\")] = 27\n>>> data = [1,2]\n>>> g = f(data)\n>>> type(g)\n<class \'generator\'>\n>>> g.send(None)\n\'a\'\n>>> data\n[1, 2]\n>>> g.send(0)\n\'b\'\n>>> data\n[27, 2]\n>>> try: g.send(1)\n... except StopIteration: pass\n>>> data\n[27, 27]\n\n"
refleaks_tests = "\nPrior to adding cycle-GC support to itertools.tee, this code would leak\nreferences. We add it to the standard suite so the routine refleak-tests\nwould trigger if it starts being uncleanable again.\n\n>>> import itertools\n>>> def leak():\n...     class gen:\n...         def __iter__(self):\n...             return self\n...         def __next__(self):\n...             return self.item\n...     g = gen()\n...     head, tail = itertools.tee(g)\n...     g.item = head\n...     return head\n>>> it = leak()\n\nMake sure to also test the involvement of the tee-internal teedataobject,\nwhich stores returned items.\n\n>>> item = next(it)\n\n\n\nThis test leaked at one point due to generator finalization/destruction.\nIt was copied from Lib/test/leakers/test_generator_cycle.py before the file\nwas removed.\n\n>>> def leak():\n...    def gen():\n...        while True:\n...            yield g\n...    g = gen()\n\n>>> leak()\n\n\n\nThis test isn\'t really generator related, but rather exception-in-cleanup\nrelated. The coroutine tests (above) just happen to cause an exception in\nthe generator\'s __del__ (tp_del) method. We can also test for this\nexplicitly, without generators. We do have to redirect stderr to avoid\nprinting warnings and to doublecheck that we actually tested what we wanted\nto test.\n\n>>> from test import support\n>>> class Leaker:\n...     def __del__(self):\n...         def invoke(message):\n...             raise RuntimeError(message)\n...         invoke(\"del failed\")\n...\n>>> with support.catch_unraisable_exception() as cm:\n...     l = Leaker()\n...     del l\n...\n...     cm.unraisable.object == Leaker.__del__\n...     cm.unraisable.exc_type == RuntimeError\n...     str(cm.unraisable.exc_value) == \"del failed\"\n...     cm.unraisable.exc_traceback is not None\nTrue\nTrue\nTrue\nTrue\n\n\nThese refleak tests should perhaps be in a testfile of their own,\ntest_generators just happened to be the test that drew these out.\n\n"
__test__ = Dict{String, String}("tut" => tutorial_tests, "pep" => pep_tests, "email" => email_tests, "fun" => fun_tests, "syntax" => syntax_tests, "conjoin" => conjoin_tests, "weakref" => weakref_tests, "coroutine" => coroutine_tests, "refleaks" => refleaks_tests)
function test_main(verbose = nothing)
support.run_unittest(__name__)
support.run_doctest(test_generators, verbose)
end

if abspath(PROGRAM_FILE) == @__FILE__
test_main(1)
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
general_float_cases = GeneralFloatCases()
test_float(general_float_cases)
test_noargs(general_float_cases)
test_underscores(general_float_cases)
test_non_numeric_input_types(general_float_cases)
test_float_memoryview(general_float_cases)
test_error_message(general_float_cases)
test_float_with_comma(general_float_cases)
test_floatconversion(general_float_cases)
test_keyword_args(general_float_cases)
test_is_integer(general_float_cases)
test_floatasratio(general_float_cases)
test_float_containment(general_float_cases)
test_float_floor(general_float_cases)
test_float_ceil(general_float_cases)
test_float_mod(general_float_cases)
test_float_pow(general_float_cases)
test_hash(general_float_cases)
test_hash_nan(general_float_cases)
format_functions_test_case = FormatFunctionsTestCase()
setUp(format_functions_test_case)
test_getformat(format_functions_test_case)
test_setformat(format_functions_test_case)
tearDown(format_functions_test_case)
unknown_format_test_case = UnknownFormatTestCase()
setUp(unknown_format_test_case)
test_double_specials_dont_unpack(unknown_format_test_case)
test_float_specials_dont_unpack(unknown_format_test_case)
tearDown(unknown_format_test_case)
i_e_e_e_format_test_case = IEEEFormatTestCase()
test_double_specials_do_unpack(i_e_e_e_format_test_case)
test_float_specials_do_unpack(i_e_e_e_format_test_case)
test_serialized_float_rounding(i_e_e_e_format_test_case)
format_test_case = FormatTestCase()
test_format(format_test_case)
test_format_testfile(format_test_case)
test_issue5864(format_test_case)
test_issue35560(format_test_case)
repr_test_case = ReprTestCase()
test_repr(repr_test_case)
test_short_repr(repr_test_case)
round_test_case = RoundTestCase()
test_inf_nan(round_test_case)
test_large_n(round_test_case)
test_small_n(round_test_case)
test_overflow(round_test_case)
test_previous_round_bugs(round_test_case)
test_matches_float_format(round_test_case)
test_format_specials(round_test_case)
test_None_ndigits(round_test_case)
inf_nan_test = InfNanTest()
test_inf_from_str(inf_nan_test)
test_inf_as_str(inf_nan_test)
test_nan_from_str(inf_nan_test)
test_nan_as_str(inf_nan_test)
test_inf_signs(inf_nan_test)
test_nan_signs(inf_nan_test)
hex_float_test_case = HexFloatTestCase()
test_ends(hex_float_test_case)
test_invalid_inputs(hex_float_test_case)
test_whitespace(hex_float_test_case)
test_from_hex(hex_float_test_case)
test_roundtrip(hex_float_test_case)
test_subclass(hex_float_test_case)
format_test = FormatTest()
test_common_format(format_test)
test_str_format(format_test)
test_bytes_and_bytearray_format(format_test)
test_nul(format_test)
test_non_ascii(format_test)
test_locale(format_test)
test_optimisations(format_test)
test_precision(format_test)
test_precision_c_limits(format_test)
test_g_format_has_no_trailing_zeros(format_test)
test_with_two_commas_in_format_specifier(format_test)
test_with_two_underscore_in_format_specifier(format_test)
test_with_a_commas_and_an_underscore_in_format_specifier(format_test)
test_with_an_underscore_and_a_comma_in_format_specifier(format_test)
fraction_test = FractionTest()
testInit(fraction_test)
testInitFromFloat(fraction_test)
testInitFromDecimal(fraction_test)
testFromString(fraction_test)
testImmutable(fraction_test)
testFromFloat(fraction_test)
testFromDecimal(fraction_test)
test_as_integer_ratio(fraction_test)
testLimitDenominator(fraction_test)
testConversions(fraction_test)
testBoolGuarateesBoolReturn(fraction_test)
testRound(fraction_test)
testArithmetic(fraction_test)
testLargeArithmetic(fraction_test)
testMixedArithmetic(fraction_test)
testMixingWithDecimal(fraction_test)
testComparisons(fraction_test)
testComparisonsDummyRational(fraction_test)
testComparisonsDummyFloat(fraction_test)
testMixedLess(fraction_test)
testMixedLessEqual(fraction_test)
testBigFloatComparisons(fraction_test)
testBigComplexComparisons(fraction_test)
testMixedEqual(fraction_test)
testStringification(fraction_test)
testHash(fraction_test)
testApproximatePi(fraction_test)
testApproximateCos1(fraction_test)
test_copy_deepcopy_pickle(fraction_test)
test_slots(fraction_test)
test_int_subclass(fraction_test)
test_frozen = TestFrozen()
test_frozen(test_frozen)
test_case = TestCase()
test__format__lookup(test_case)
test_ast(test_case)
test_ast_line_numbers(test_case)
test_ast_line_numbers_multiple_formattedvalues(test_case)
test_ast_line_numbers_nested(test_case)
test_ast_line_numbers_duplicate_expression(test_case)
test_ast_numbers_fstring_with_formatting(test_case)
test_ast_line_numbers_multiline_fstring(test_case)
test_ast_line_numbers_with_parentheses(test_case)
test_docstring(test_case)
test_literal_eval(test_case)
test_ast_compile_time_concat(test_case)
test_compile_time_concat_errors(test_case)
test_literal(test_case)
test_unterminated_string(test_case)
test_mismatched_parens(test_case)
test_double_braces(test_case)
test_compile_time_concat(test_case)
test_comments(test_case)
test_many_expressions(test_case)
test_format_specifier_expressions(test_case)
test_side_effect_order(test_case)
test_missing_expression(test_case)
test_parens_in_expressions(test_case)
test_newlines_before_syntax_error(test_case)
test_backslashes_in_string_part(test_case)
test_misformed_unicode_character_name(test_case)
test_no_backslashes_in_expression_part(test_case)
test_no_escapes_for_braces(test_case)
test_newlines_in_expressions(test_case)
test_lambda(test_case)
test_yield(test_case)
test_yield_send(test_case)
test_expressions_with_triple_quoted_strings(test_case)
test_multiple_vars(test_case)
test_closure(test_case)
test_arguments(test_case)
test_locals(test_case)
test_missing_variable(test_case)
test_missing_format_spec(test_case)
test_global(test_case)
test_shadowed_global(test_case)
test_call(test_case)
test_nested_fstrings(test_case)
test_invalid_string_prefixes(test_case)
test_leading_trailing_spaces(test_case)
test_not_equal(test_case)
test_equal_equal(test_case)
test_conversions(test_case)
test_assignment(test_case)
test_del(test_case)
test_mismatched_braces(test_case)
test_if_conditional(test_case)
test_empty_format_specifier(test_case)
test_str_format_differences(test_case)
test_errors(test_case)
test_filename_in_syntaxerror(test_case)
test_loop(test_case)
test_dict(test_case)
test_backslash_char(test_case)
test_debug_conversion(test_case)
test_walrus(test_case)
test_invalid_syntax_error_message(test_case)
test_with_two_commas_in_format_specifier(test_case)
test_with_two_underscore_in_format_specifier(test_case)
test_with_a_commas_and_an_underscore_in_format_specifier(test_case)
test_with_an_underscore_and_a_comma_in_format_specifier(test_case)
test_syntax_error_for_starred_expressions(test_case)
test_p_e_p479 = TestPEP479()
test_stopiteration_wrapping(test_p_e_p479)
test_stopiteration_wrapping_context(test_p_e_p479)
signal_and_yield_from_test = SignalAndYieldFromTest()
test_raise_and_yield_from(signal_and_yield_from_test)
finalization_test = FinalizationTest()
test_frame_resurrect(finalization_test)
test_refcycle(finalization_test)
test_lambda_generator(finalization_test)
generator_test = GeneratorTest()
test_name(generator_test)
test_copy(generator_test)
test_pickle(generator_test)
test_send_non_none_to_new_gen(generator_test)
exception_test = ExceptionTest()
test_except_throw(exception_test)
test_except_next(exception_test)
test_except_gen_except(exception_test)
test_except_throw_exception_context(exception_test)
test_except_throw_bad_exception(exception_test)
test_stopiteration_error(exception_test)
test_tutorial_stopiteration(exception_test)
test_return_tuple(exception_test)
test_return_stopiteration(exception_test)
generator_throw_test = GeneratorThrowTest()
test_exception_context_with_yield(generator_throw_test)
test_exception_context_with_yield_inside_generator(generator_throw_test)
test_exception_context_with_yield_from(generator_throw_test)
test_exception_context_with_yield_from_with_context_cycle(generator_throw_test)
test_throw_after_none_exc_type(generator_throw_test)
generator_stack_trace_test = GeneratorStackTraceTest()
test_send_with_yield_from(generator_stack_trace_test)
test_throw_with_yield_from(generator_stack_trace_test)
yield_from_tests = YieldFromTests()
test_generator_gi_yieldfrom(yield_from_tests)
end