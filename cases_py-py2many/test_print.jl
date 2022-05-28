using Test




abstract type AbstractTestPrint end
abstract type AbstractTestPy2MigrationHint end
NotDefined = object()
dispatch = Dict((false, false, false) => (args, sep, end_, file) -> println(args...), (false, false, true) => (args, sep, end_, file) -> write(file, "$(args...)"), (false, true, false) => (args, sep, end_, file) -> print("$(args...)"), (false, true, true) => (args, sep, end_, file) -> write(file, "$(args...)"), (true, false, false) => (args, sep, end_, file) -> println("$(args...)"), (true, false, true) => (args, sep, end_, file) -> write(file, "$(args...)"), (true, true, false) => (args, sep, end_, file) -> print("$(args...)"), (true, true, true) => (args, sep, end_, file) -> write(file, "$(args...)"))
mutable struct ClassWith__str__ <: AbstractClassWith__str__
x
end
function __str__(self)
return self.x
end

mutable struct TestPrint <: AbstractTestPrint
#= Test correct operation of the print function. =#
written::String
flushed::Int64
end
function check(self, expected, args, sep = NotDefined, end_ = NotDefined, file = NotDefined)
fn = dispatch[(sep !== NotDefined, end_ !== NotDefined, file !== NotDefined)]
captured_stdout() do t 
fn(args, sep, end_, file)
end
@test (getvalue(t) == expected)
end

function test_print(self)
function x(expected, args, sep = NotDefined, end_ = NotDefined)
check(self, expected, args)
o = StringIO()
check(self, "", args)
@test (getvalue(o) == expected)
end

x("\n", ())
x("a\n", ("a",))
x("None\n", (nothing,))
x("1 2\n", (1, 2))
x("1   2\n", (1, " ", 2))
x("1*2\n", (1, 2))
x("1 s", (1, "s"))
x("a\nb\n", ("a", "b"))
x("1.01", (1.0, 1))
x("1*a*1.3+", (1, "a", 1.3))
x("a\n\nb\n", ("a\n", "b"))
x("\0+ +\0\n", ("\0", " ", "\0"))
x("a\n b\n", ("a\n", "b"))
x("a\n b\n", ("a\n", "b"))
x("a\n b\n", ("a\n", "b"))
x("a\n b\n", ("a\n", "b"))
x("*\n", (ClassWith__str__("*"),))
x("abc 1\n", (ClassWith__str__("abc"), 1))
@test_throws TypeError print("", sep = 3)
@test_throws TypeError print("", end_ = 3)
@test_throws AttributeError print("", file = "")
end

function test_print_flush(self)
mutable struct filelike <: Abstractfilelike
written::String
flushed::Int64
end
function write(self, str)
self.written += str
end

function flush(self)
self.flushed += 1
end

f = filelike()
flush(f, true, "$(1)")
flush(f, true, "$(2)")
flush(f, false, "$(3)")
assertEqual(self, f.written, "123\n")
assertEqual(self, f.flushed, 2)
mutable struct noflush <: Abstractnoflush

end
function write(self, str)
#= pass =#
end

function flush(self)
throw(RuntimeError)
end

assertRaises(self, RuntimeError, print, 1, file = noflush(), flush = true)
end

mutable struct TestPy2MigrationHint <: AbstractTestPy2MigrationHint
#= Test that correct hint is produced analogous to Python3 syntax,
    if print statement is executed as in Python 2.
     =#

end
function test_normal_string(self)
python2_print_str = "print \"Hello World\""
assertRaises(self, SyntaxError) do context 
exec(python2_print_str)
end
assertIn(self, "Missing parentheses in call to \'print\'. Did you mean print(...)", string(context.exception))
end

function test_string_with_soft_space(self)
python2_print_str = "print \"Hello World\","
assertRaises(self, SyntaxError) do context 
exec(python2_print_str)
end
assertIn(self, "Missing parentheses in call to \'print\'. Did you mean print(...)", string(context.exception))
end

function test_string_with_excessive_whitespace(self)
python2_print_str = "print  \"Hello World\", "
assertRaises(self, SyntaxError) do context 
exec(python2_print_str)
end
assertIn(self, "Missing parentheses in call to \'print\'. Did you mean print(...)", string(context.exception))
end

function test_string_with_leading_whitespace(self)
python2_print_str = "if 1:\n            print \"Hello World\"\n        "
assertRaises(self, SyntaxError) do context 
exec(python2_print_str)
end
assertIn(self, "Missing parentheses in call to \'print\'. Did you mean print(...)", string(context.exception))
end

function test_string_with_semicolon(self)
python2_print_str = "print p;"
assertRaises(self, SyntaxError) do context 
exec(python2_print_str)
end
assertIn(self, "Missing parentheses in call to \'print\'. Did you mean print(...)", string(context.exception))
end

function test_string_in_loop_on_same_line(self)
python2_print_str = "for i in s: print i"
assertRaises(self, SyntaxError) do context 
exec(python2_print_str)
end
assertIn(self, "Missing parentheses in call to \'print\'. Did you mean print(...)", string(context.exception))
end

function test_stream_redirection_hint_for_py2_migration(self)
assertRaises(self, TypeError) do context 
(print >> sys.stderr, "message")
end
assertIn(self, "Did you mean \"print(<message>, file=<output_stream>)\"?", string(context.exception))
assertRaises(self, TypeError) do context 
print >> 42
end
assertIn(self, "Did you mean \"print(<message>, file=<output_stream>)\"?", string(context.exception))
assertRaises(self, TypeError) do context 
max >> sys.stderr
end
assertNotIn(self, "Did you mean ", string(context.exception))
assertRaises(self, TypeError) do context 
print << sys.stderr
end
assertNotIn(self, "Did you mean", string(context.exception))
mutable struct OverrideRRShift <: AbstractOverrideRRShift

end
function __rrshift__(self, lhs)::Int64
return 42
end

assertEqual(self, print >> OverrideRRShift(), 42)
end

if abspath(PROGRAM_FILE) == @__FILE__
test_print = TestPrint()
check(test_print)
test_print(test_print)
test_print_flush(test_print)
test_py2_migration_hint = TestPy2MigrationHint()
test_normal_string(test_py2_migration_hint)
test_string_with_soft_space(test_py2_migration_hint)
test_string_with_excessive_whitespace(test_py2_migration_hint)
test_string_with_leading_whitespace(test_py2_migration_hint)
test_string_with_semicolon(test_py2_migration_hint)
test_string_in_loop_on_same_line(test_py2_migration_hint)
test_stream_redirection_hint_for_py2_migration(test_py2_migration_hint)
end