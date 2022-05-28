using Test



abstract type AbstractMiscDecorators <: object end
abstract type AbstractDbcheckError <: Exception end
abstract type AbstractTestDecorators end
abstract type AbstractC <: object end
abstract type AbstractNameLookupTracer <: object end
abstract type AbstractTestClassDecorators end
function funcattrs()
function decorate(func)
update(func.__dict__, kwds)
return func
end

return decorate
end

mutable struct MiscDecorators <: AbstractMiscDecorators

end
function author(name)
function decorate(func)
func.__dict__["author"] = name
return func
end

return decorate
end

mutable struct DbcheckError <: AbstractDbcheckError


            DbcheckError(exprstr, func, args, kwds) = begin
                Exception.__init__(self, "dbcheck %r failed (func=%s args=%s kwds=%s)" % (exprstr, func, args, kwds))
                new(exprstr, func, args, kwds)
            end
end

function dbcheck(exprstr, globals = nothing, locals = nothing)
#= Decorator to implement debugging assertions =#
function decorate(func)
expr = compile(exprstr, "dbcheck-%s" % func.__name__, "eval")
function check()
if !eval(expr, globals, locals)
throw(DbcheckError(exprstr, func, args, kwds))
end
return func(args..., None = kwds)
end

return check
end

return decorate
end

function countcalls(counts)
#= Decorator to count calls to a function =#
function decorate(func)
func_name = func.__name__
counts[func_name + 1] = 0
function call()
counts[func_name + 1] += 1
return func(args..., None = kwds)
end

call.__name__ = func_name
return call
end

return decorate
end

function memoize(func)
saved = Dict()
function call()::Dict
try
return saved[args]
catch exn
if exn isa KeyError
res = func(args...)
saved[args] = res
return res
end
if exn isa TypeError
return func(args...)
end
end
end

call.__name__ = func.__name__
return call
end

mutable struct TestDecorators <: AbstractTestDecorators
index
__wrapped__
func
end
function test_single(self)
mutable struct C <: AbstractC

end
function foo()::Int64
return 42
end

assertEqual(self, C.foo(), 42)
assertEqual(self, foo(C()), 42)
end

function check_wrapper_attrs(self, method_wrapper, format_str)
function func(x)
return x
end

wrapper = method_wrapper(func)
assertIs(self, wrapper.__func__, func)
assertIs(self, wrapper.__wrapped__, func)
for attr in ("__module__", "__qualname__", "__name__", "__doc__", "__annotations__")
assertIs(self, getfield(wrapper, :attr), getfield(func, :attr))
end
@test (repr(wrapper) == format_str)
return wrapper
end

function test_staticmethod(self)
wrapper = check_wrapper_attrs(self, staticmethod, "<staticmethod({!r})>")
@test (wrapper(1) == 1)
end

function test_classmethod(self)
wrapper = check_wrapper_attrs(self, classmethod, "<classmethod({!r})>")
@test_throws TypeError wrapper(1)
end

function test_dotted(self)
decorators = MiscDecorators()
function foo()::Int64
return 42
end

@test (foo() == 42)
@test (foo.author == "Cleese")
end

function test_argforms(self)
function noteargs()
function decorate(func)
setattr(func, "dbval", (args, kwds))
return func
end

return decorate
end

args = ("Now", "is", "the", "time")
kwds = dict(one = 1, two = 2)
function f1()::Int64
return 42
end

@test (f1() == 42)
@test (f1.dbval == (args, kwds))
function f2()::Int64
return 84
end

@test (f2() == 84)
@test (f2.dbval == (("terry", "gilliam"), dict(eric = "idle", john = "cleese")))
function f3()
#= pass =#
end

@test (f3.dbval == ((1, 2), Dict()))
end

function test_dbcheck(self)
function f(a, b)::Any
return a + b
end

@test (f(1, 2) == 3)
@test_throws DbcheckError f(1, nothing)
end

function test_memoize(self)
counts = Dict()
function double(x)::Int64
return x*2
end

@test (double.__name__ == "double")
@test (counts == dict(double = 0))
@test (double(2) == 4)
@test (counts["double"] == 1)
@test (double(2) == 4)
@test (counts["double"] == 1)
@test (double(3) == 6)
@test (counts["double"] == 2)
@test (double([10]) == [10, 10])
@test (counts["double"] == 3)
@test (double([10]) == [10, 10])
@test (counts["double"] == 4)
end

function test_errors(self)
for stmt in ("x,", "x, y", "x = y", "pass", "import sys")
compile(stmt, "test", "exec")
assertRaises(self, SyntaxError) do 
compile("@$(stmt)\ndef f(): pass", "test", "exec")
end
end
for expr in ("1.+2j", "[1, 2][-1]", "(1, 2)", "True", "...", "None")
compile(expr, "test", "eval")
assertRaises(self, TypeError) do 
exec("@$(expr)\ndef f(): pass")
end
end
function unimp(func)
throw(NotImplementedError)
end

context = dict(nullval = nothing, unimp = unimp)
for (expr, exc) in [("undef", NameError), ("nullval", TypeError), ("nullval.attr", AttributeError), ("unimp", NotImplementedError)]
codestr = "@%s\ndef f(): pass\nassert f() is None" % expr
code = compile(codestr, "test", "exec")
@test_throws exc eval(code, context)
end
end

function test_expressions(self)
for expr in ("(x,)", "(x, y)", "x := y", "(x := y)", "x @y", "(x @ y)", "x[0]", "w[x].y.z", "w + x - (y + z)", "x(y)()(z)", "[w, x, y][z]", "x.y")
compile("@$(expr)\ndef f(): pass", "test", "exec")
end
end

function test_double(self)
mutable struct C <: AbstractC

end
function foo(self)::Int64
return 42
end

assertEqual(self, foo(C()), 42)
assertEqual(self, C.foo.abc, 1)
assertEqual(self, C.foo.xyz, "haha")
assertEqual(self, C.foo.booh, 42)
end

function test_order(self)
function callnum(num)
#= Decorator factory that returns a decorator that replaces the
            passed-in function with one that returns the value of 'num' =#
function deco(func)
return () -> num
end

return deco
end

function foo()::Int64
return 42
end

@test (foo() == 2)
end

function test_eval_order(self)
actions = []
function make_decorator(tag)
push!(actions, "makedec" + tag)
function decorate(func)
push!(actions, "calldec" + tag)
return func
end

return decorate
end

mutable struct NameLookupTracer <: AbstractNameLookupTracer
index
end
function __getattr__(self, fname)
if fname == "make_decorator"
opname, res = ("evalname", make_decorator)
elseif fname == "arg"
opname, res = ("evalargs", string(self.index))
else
@assert(false)
end
push!(actions, "%s%d" % (opname, self.index))
return res
end

c1, c2, c3 = map(NameLookupTracer, [1, 2, 3])
expected_actions = ["evalname1", "evalargs1", "makedec1", "evalname2", "evalargs2", "makedec2", "evalname3", "evalargs3", "makedec3", "calldec3", "calldec2", "calldec1"]
actions = []
function foo()::Int64
return 42
end

assertEqual(self, foo(), 42)
assertEqual(self, actions, expected_actions)
actions = []
function bar()::Int64
return 42
end

bar = make_decorator(c1)(make_decorator(c2)(make_decorator(c3)(bar)))
assertEqual(self, bar(), 42)
assertEqual(self, actions, expected_actions)
end

function test_wrapped_descriptor_inside_classmethod(self)
mutable struct BoundWrapper <: AbstractBoundWrapper
__wrapped__
end
function __call__(self)
return __wrapped__(self, args..., None = kwargs)
end

mutable struct Wrapper <: AbstractWrapper
__wrapped__
end
function __get__(self, instance, owner)::BoundWrapper
bound_function = __get__(self.__wrapped__, instance, owner)
return BoundWrapper(bound_function)
end

function decorator(wrapped)::Wrapper
return Wrapper(wrapped)
end

mutable struct Class <: AbstractClass

end
function inner(cls)::String
return "spam"
end

function outer(cls)::String
return "eggs"
end

assertEqual(self, Class.inner(), "spam")
assertEqual(self, Class.outer(), "eggs")
assertEqual(self, inner(Class()), "spam")
assertEqual(self, outer(Class()), "eggs")
end

function test_wrapped_classmethod_inside_classmethod(self)
mutable struct MyClassMethod1 <: AbstractMyClassMethod1
func
end
function __call__(self, cls)
if hasfield(typeof(self.func), :__get__)
return __get__(self.func, cls, cls)()
end
return func(self, cls)
end

function __get__(self, instance, owner = nothing)
if owner === nothing
owner = type_(instance)
end
return MethodType(self, owner)
end

mutable struct MyClassMethod2 <: AbstractMyClassMethod2
func

            MyClassMethod2(func) = begin
                if isa(func, classmethod)
func = func.__func__
end
                new(func)
            end
end
function __call__(self, cls)
return func(self, cls)
end

function __get__(self, instance, owner = nothing)
if owner === nothing
owner = type_(instance)
end
return MethodType(self, owner)
end

for myclassmethod in [MyClassMethod1, MyClassMethod2]
mutable struct A <: AbstractA

end
function f1(cls)
return cls
end

function f2(cls)
return cls
end

function f3(cls)
return cls
end

function f4(cls)
return cls
end

function f5(cls)
return cls
end

function f6(cls)
return cls
end

assertIs(self, A.f1(), A)
assertIs(self, A.f2(), A)
assertIs(self, A.f3(), A)
assertIs(self, A.f4(), A)
assertIs(self, A.f5(), A)
assertIs(self, A.f6(), A)
a = A()
assertIs(self, f1(a), A)
assertIs(self, f2(a), A)
assertIs(self, f3(a), A)
assertIs(self, f4(a), A)
assertIs(self, f5(a), A)
assertIs(self, f6(a), A)
function f(cls)
return cls
end

assertIs(self, __get__(myclassmethod(f), a)(), A)
assertIs(self, __get__(myclassmethod(f), a, A)(), A)
assertIs(self, __get__(myclassmethod(f), A, A)(), A)
assertIs(self, __get__(myclassmethod(f), A)(), type_(A))
assertIs(self, __get__(classmethod(f), a)(), A)
assertIs(self, __get__(classmethod(f), a, A)(), A)
assertIs(self, __get__(classmethod(f), A, A)(), A)
assertIs(self, __get__(classmethod(f), A)(), type_(A))
end
end

mutable struct TestClassDecorators <: AbstractTestClassDecorators

end
function test_simple(self)
function plain(x)
x.extra = "Hello"
return x
end

mutable struct C <: AbstractC

end

assertEqual(self, C.extra, "Hello")
end

function test_double(self)
function ten(x)
x.extra = 10
return x
end

function add_five(x)
x.extra += 5
return x
end

mutable struct C <: AbstractC

end

assertEqual(self, C.extra, 15)
end

function test_order(self)
function applied_first(x)
x.extra = "first"
return x
end

function applied_second(x)
x.extra = "second"
return x
end

mutable struct C <: AbstractC

end

assertEqual(self, C.extra, "second")
end

if abspath(PROGRAM_FILE) == @__FILE__
test_decorators = TestDecorators()
test_single(test_decorators)
check_wrapper_attrs(test_decorators)
test_staticmethod(test_decorators)
test_classmethod(test_decorators)
test_dotted(test_decorators)
test_argforms(test_decorators)
test_dbcheck(test_decorators)
test_memoize(test_decorators)
test_errors(test_decorators)
test_expressions(test_decorators)
test_double(test_decorators)
test_order(test_decorators)
test_eval_order(test_decorators)
test_wrapped_descriptor_inside_classmethod(test_decorators)
test_wrapped_classmethod_inside_classmethod(test_decorators)
test_class_decorators = TestClassDecorators()
test_simple(test_class_decorators)
test_double(test_class_decorators)
test_order(test_class_decorators)
end