using Test


abstract type AbstractNamedExpressionInvalidTest end
abstract type AbstractNamedExpressionAssignmentTest end
abstract type AbstractNamedExpressionScopeTest end
GLOBAL_VAR = nothing
mutable struct NamedExpressionInvalidTest <: AbstractNamedExpressionInvalidTest

end
function test_named_expression_invalid_01(self)
code = "x := 0"
assertRaisesRegex(self, SyntaxError, "invalid syntax") do 
exec(code, Dict(), Dict())
end
end

function test_named_expression_invalid_02(self)
code = "x = y := 0"
assertRaisesRegex(self, SyntaxError, "invalid syntax") do 
exec(code, Dict(), Dict())
end
end

function test_named_expression_invalid_03(self)
code = "y := f(x)"
assertRaisesRegex(self, SyntaxError, "invalid syntax") do 
exec(code, Dict(), Dict())
end
end

function test_named_expression_invalid_04(self)
code = "y0 = y1 := f(x)"
assertRaisesRegex(self, SyntaxError, "invalid syntax") do 
exec(code, Dict(), Dict())
end
end

function test_named_expression_invalid_06(self)
code = "((a, b) := (1, 2))"
assertRaisesRegex(self, SyntaxError, "cannot use assignment expressions with tuple") do 
exec(code, Dict(), Dict())
end
end

function test_named_expression_invalid_07(self)
code = "def spam(a = b := 42): pass"
assertRaisesRegex(self, SyntaxError, "invalid syntax") do 
exec(code, Dict(), Dict())
end
end

function test_named_expression_invalid_08(self)
code = "def spam(a: b := 42 = 5): pass"
assertRaisesRegex(self, SyntaxError, "invalid syntax") do 
exec(code, Dict(), Dict())
end
end

function test_named_expression_invalid_09(self)
code = "spam(a=b := \'c\')"
assertRaisesRegex(self, SyntaxError, "invalid syntax") do 
exec(code, Dict(), Dict())
end
end

function test_named_expression_invalid_10(self)
code = "spam(x = y := f(x))"
assertRaisesRegex(self, SyntaxError, "invalid syntax") do 
exec(code, Dict(), Dict())
end
end

function test_named_expression_invalid_11(self)
code = "spam(a=1, b := 2)"
assertRaisesRegex(self, SyntaxError, "positional argument follows keyword argument") do 
exec(code, Dict(), Dict())
end
end

function test_named_expression_invalid_12(self)
code = "spam(a=1, (b := 2))"
assertRaisesRegex(self, SyntaxError, "positional argument follows keyword argument") do 
exec(code, Dict(), Dict())
end
end

function test_named_expression_invalid_13(self)
code = "spam(a=1, (b := 2))"
assertRaisesRegex(self, SyntaxError, "positional argument follows keyword argument") do 
exec(code, Dict(), Dict())
end
end

function test_named_expression_invalid_14(self)
code = "(x := lambda: y := 1)"
assertRaisesRegex(self, SyntaxError, "invalid syntax") do 
exec(code, Dict(), Dict())
end
end

function test_named_expression_invalid_15(self)
code = "(lambda: x := 1)"
assertRaisesRegex(self, SyntaxError, "cannot use assignment expressions with lambda") do 
exec(code, Dict(), Dict())
end
end

function test_named_expression_invalid_16(self)
code = "[i + 1 for i in i := [1,2]]"
assertRaisesRegex(self, SyntaxError, "invalid syntax") do 
exec(code, Dict(), Dict())
end
end

function test_named_expression_invalid_17(self)
code = "[i := 0, j := 1 for i, j in [(1, 2), (3, 4)]]"
assertRaisesRegex(self, SyntaxError, "did you forget parentheses around the comprehension target?") do 
exec(code, Dict(), Dict())
end
end

function test_named_expression_invalid_in_class_body(self)
code = "class Foo():\n            [(42, 1 + ((( j := i )))) for i in range(5)]\n        "
assertRaisesRegex(self, SyntaxError, "assignment expression within a comprehension cannot be used in a class body") do 
exec(code, Dict(), Dict())
end
end

function test_named_expression_invalid_rebinding_list_comprehension_iteration_variable(self)
cases = [("Local reuse", "i", "[i := 0 for i in range(5)]"), ("Nested reuse", "j", "[[(j := 0) for i in range(5)] for j in range(5)]"), ("Reuse inner loop target", "j", "[(j := 0) for i in range(5) for j in range(5)]"), ("Unpacking reuse", "i", "[i := 0 for i, j in [(0, 1)]]"), ("Reuse in loop condition", "i", "[i+1 for i in range(5) if (i := 0)]"), ("Unreachable reuse", "i", "[False or (i:=0) for i in range(5)]"), ("Unreachable nested reuse", "i", "[(i, j) for i in range(5) for j in range(5) if True or (i:=10)]")]
for (case, target, code) in cases
msg = "assignment expression cannot rebind comprehension iteration variable \'$(target)\'"
subTest(self, case = case) do 
assertRaisesRegex(self, SyntaxError, msg) do 
exec(code, Dict(), Dict())
end
end
end
end

function test_named_expression_invalid_rebinding_list_comprehension_inner_loop(self)
cases = [("Inner reuse", "j", "[i for i in range(5) if (j := 0) for j in range(5)]"), ("Inner unpacking reuse", "j", "[i for i in range(5) if (j := 0) for j, k in [(0, 1)]]")]
for (case, target, code) in cases
msg = "comprehension inner loop cannot rebind assignment expression target \'$(target)\'"
subTest(self, case = case) do 
assertRaisesRegex(self, SyntaxError, msg) do 
exec(code, Dict())
end
assertRaisesRegex(self, SyntaxError, msg) do 
exec(code, Dict(), Dict())
end
assertRaisesRegex(self, SyntaxError, msg) do 
exec("lambda: $(code)", Dict())
end
end
end
end

function test_named_expression_invalid_list_comprehension_iterable_expression(self)
cases = [("Top level", "[i for i in (i := range(5))]"), ("Inside tuple", "[i for i in (2, 3, i := range(5))]"), ("Inside list", "[i for i in [2, 3, i := range(5)]]"), ("Different name", "[i for i in (j := range(5))]"), ("Lambda expression", "[i for i in (lambda:(j := range(5)))()]"), ("Inner loop", "[i for i in range(5) for j in (i := range(5))]"), ("Nested comprehension", "[i for i in [j for j in (k := range(5))]]"), ("Nested comprehension condition", "[i for i in [j for j in range(5) if (j := True)]]"), ("Nested comprehension body", "[i for i in [(j := True) for j in range(5)]]")]
msg = "assignment expression cannot be used in a comprehension iterable expression"
for (case, code) in cases
subTest(self, case = case) do 
assertRaisesRegex(self, SyntaxError, msg) do 
exec(code, Dict())
end
assertRaisesRegex(self, SyntaxError, msg) do 
exec(code, Dict(), Dict())
end
assertRaisesRegex(self, SyntaxError, msg) do 
exec("lambda: $(code)", Dict())
end
end
end
end

function test_named_expression_invalid_rebinding_set_comprehension_iteration_variable(self)
cases = [("Local reuse", "i", "{i := 0 for i in range(5)}"), ("Nested reuse", "j", "{{(j := 0) for i in range(5)} for j in range(5)}"), ("Reuse inner loop target", "j", "{(j := 0) for i in range(5) for j in range(5)}"), ("Unpacking reuse", "i", "{i := 0 for i, j in {(0, 1)}}"), ("Reuse in loop condition", "i", "{i+1 for i in range(5) if (i := 0)}"), ("Unreachable reuse", "i", "{False or (i:=0) for i in range(5)}"), ("Unreachable nested reuse", "i", "{(i, j) for i in range(5) for j in range(5) if True or (i:=10)}")]
for (case, target, code) in cases
msg = "assignment expression cannot rebind comprehension iteration variable \'$(target)\'"
subTest(self, case = case) do 
assertRaisesRegex(self, SyntaxError, msg) do 
exec(code, Dict(), Dict())
end
end
end
end

function test_named_expression_invalid_rebinding_set_comprehension_inner_loop(self)
cases = [("Inner reuse", "j", "{i for i in range(5) if (j := 0) for j in range(5)}"), ("Inner unpacking reuse", "j", "{i for i in range(5) if (j := 0) for j, k in {(0, 1)}}")]
for (case, target, code) in cases
msg = "comprehension inner loop cannot rebind assignment expression target \'$(target)\'"
subTest(self, case = case) do 
assertRaisesRegex(self, SyntaxError, msg) do 
exec(code, Dict())
end
assertRaisesRegex(self, SyntaxError, msg) do 
exec(code, Dict(), Dict())
end
assertRaisesRegex(self, SyntaxError, msg) do 
exec("lambda: $(code)", Dict())
end
end
end
end

function test_named_expression_invalid_set_comprehension_iterable_expression(self)
cases = [("Top level", "{i for i in (i := range(5))}"), ("Inside tuple", "{i for i in (2, 3, i := range(5))}"), ("Inside list", "{i for i in {2, 3, i := range(5)}}"), ("Different name", "{i for i in (j := range(5))}"), ("Lambda expression", "{i for i in (lambda:(j := range(5)))()}"), ("Inner loop", "{i for i in range(5) for j in (i := range(5))}"), ("Nested comprehension", "{i for i in {j for j in (k := range(5))}}"), ("Nested comprehension condition", "{i for i in {j for j in range(5) if (j := True)}}"), ("Nested comprehension body", "{i for i in {(j := True) for j in range(5)}}")]
msg = "assignment expression cannot be used in a comprehension iterable expression"
for (case, code) in cases
subTest(self, case = case) do 
assertRaisesRegex(self, SyntaxError, msg) do 
exec(code, Dict())
end
assertRaisesRegex(self, SyntaxError, msg) do 
exec(code, Dict(), Dict())
end
assertRaisesRegex(self, SyntaxError, msg) do 
exec("lambda: $(code)", Dict())
end
end
end
end

mutable struct NamedExpressionAssignmentTest <: AbstractNamedExpressionAssignmentTest

end
function test_named_expression_assignment_01(self)
(a = 10)
@test (a == 10)
end

function test_named_expression_assignment_02(self)
a = 20
(a = a)
@test (a == 20)
end

function test_named_expression_assignment_03(self)
(total = 1 + 2)
@test (total == 3)
end

function test_named_expression_assignment_04(self)
(info = (1, 2, 3))
@test (info == (1, 2, 3))
end

function test_named_expression_assignment_05(self)
((x = 1), 2)
@test (x == 1)
end

function test_named_expression_assignment_06(self)
(z = (y = (x = 0)))
@test (x == 0)
@test (y == 0)
@test (z == 0)
end

function test_named_expression_assignment_07(self)
(loc = (1, 2))
@test (loc == (1, 2))
end

function test_named_expression_assignment_08(self)
if (spam = "eggs")
@test (spam == "eggs")
else
fail(self, "variable was not assigned using named expression")
end
end

function test_named_expression_assignment_09(self)
if true && (spam = true)
@test spam
else
fail(self, "variable was not assigned using named expression")
end
end

function test_named_expression_assignment_10(self)
if (match = 10) == 10
#= pass =#
else
fail(self, "variable was not assigned using named expression")
end
end

function test_named_expression_assignment_11(self)
function spam(a)
return a
end

input_data = [1, 2, 3]
res = [(x, y, x / y) for x in input_data if (y = spam(x)) > 0 ]
@test (res == [(1, 1, 1.0), (2, 2, 1.0), (3, 3, 1.0)])
end

function test_named_expression_assignment_12(self)
function spam(a)
return a
end

res = [[(y = spam(x)), x / y] for x in 1:4]
@test (res == [[1, 1.0], [2, 1.0], [3, 1.0], [4, 1.0]])
end

function test_named_expression_assignment_13(self)
length = length((lines = [1, 2]))
@test (length == 2)
@test (lines == [1, 2])
end

function test_named_expression_assignment_14(self)
#= 
        Where all variables are positive integers, and a is at least as large
        as the n'th root of x, this algorithm returns the floor of the n'th
        root of x (and roughly doubling the number of accurate bits per
        iteration):
         =#
a = 9
n = 2
x = 3
while a > (d = x ÷ a^(n - 1))
a = ((n - 1)*a + d) ÷ n
end
@test (a == 1)
end

function test_named_expression_assignment_15(self)
while (a = false)
#= pass =#
end
@test (a == false_)
end

function test_named_expression_assignment_16(self)
a, b = (1, 2)
fib = Dict((c = a) => ((a = b) + (b = a + c)) - b for __ in 0:5)
@test (fib == Dict(1 => 2, 2 => 3, 3 => 5, 5 => 8, 8 => 13, 13 => 21))
end

mutable struct NamedExpressionScopeTest <: AbstractNamedExpressionScopeTest

end
function test_named_expression_scope_01(self)
code = "def spam():\n    (a := 5)\nprint(a)"
assertRaisesRegex(self, NameError, "name \'a\' is not defined") do 
exec(code, Dict(), Dict())
end
end

function test_named_expression_scope_02(self)
total = 0
partial_sums = [(total = total + v) for v in 0:4]
@test (partial_sums == [0, 1, 3, 6, 10])
@test (total == 10)
end

function test_named_expression_scope_03(self)
containsOne = any(((lastNum = num) == 1 for num in [1, 2, 3]))
@test containsOne
@test (lastNum == 1)
end

function test_named_expression_scope_04(self)
function spam(a)
return a
end

res = [[(y = spam(x)), x / y] for x in 1:4]
@test (y == 4)
end

function test_named_expression_scope_05(self)
function spam(a)
return a
end

input_data = [1, 2, 3]
res = [(x, y, x / y) for x in input_data if (y = spam(x)) > 0 ]
@test (res == [(1, 1, 1.0), (2, 2, 1.0), (3, 3, 1.0)])
@test (y == 3)
end

function test_named_expression_scope_06(self)
res = [[(spam = i) for i in 0:2] for j in 0:1]
@test (res == [[0, 1, 2], [0, 1, 2]])
@test (spam == 2)
end

function test_named_expression_scope_07(self)
length((lines = [1, 2]))
@test (lines == [1, 2])
end

function test_named_expression_scope_08(self)
function spam(a)
return a
end

function eggs(b)::Int64
return b*2
end

res = [spam((a = eggs((b = h)))) for h in 0:1]
@test (res == [0, 2])
@test (a == 2)
@test (b == 1)
end

function test_named_expression_scope_09(self)
function spam(a)
return a
end

function eggs(b)::Int64
return b*2
end

res = [spam((a = eggs((a = h)))) for h in 0:1]
@test (res == [0, 2])
@test (a == 2)
end

function test_named_expression_scope_10(self)
res = [(b = [(a = 1) for i in 0:1]) for j in 0:1]
@test (res == [[1, 1], [1, 1]])
@test (a == 1)
@test (b == [1, 1])
end

function test_named_expression_scope_11(self)
res = [(j = i) for i in 0:4]
@test (res == [0, 1, 2, 3, 4])
@test (j == 4)
end

function test_named_expression_scope_17(self)
b = 0
res = [(b = i + b) for i in 0:4]
@test (res == [0, 1, 3, 6, 10])
@test (b == 10)
end

function test_named_expression_scope_18(self)
function spam(a)
return a
end

res = spam((b = 2))
@test (res == 2)
@test (b == 2)
end

function test_named_expression_scope_19(self)
function spam(a)
return a
end

res = spam((b = 2))
@test (res == 2)
@test (b == 2)
end

function test_named_expression_scope_20(self)
function spam(a)
return a
end

res = spam()
@test (res == 2)
@test (b == 2)
end

function test_named_expression_scope_21(self)
function spam(a, b)::Any
return a + b
end

res = spam((c = 2))
@test (res == 3)
@test (c == 2)
end

function test_named_expression_scope_22(self)
function spam(a, b)::Any
return a + b
end

res = spam((c = 2))
@test (res == 3)
@test (c == 2)
end

function test_named_expression_scope_23(self)
function spam(a, b)::Any
return a + b
end

res = spam()
@test (res == 3)
@test (c == 2)
end

function test_named_expression_scope_24(self)
a = 10
function spam()
# Not Supported
# nonlocal a
(a = 20)
end

spam()
@test (a == 20)
end

function test_named_expression_scope_25(self)
ns = Dict()
code = "a = 10\ndef spam():\n    global a\n    (a := 20)\nspam()"
exec(code, ns, Dict())
@test (ns["a"] == 20)
end

function test_named_expression_variable_reuse_in_comprehensions(self)
rebinding = "[x := i for i in range(3) if (x := i) or not x]"
filter_ref = "[x := i for i in range(3) if x or not x]"
body_ref = "[x for i in range(3) if (x := i) or not x]"
nested_ref = "[j for i in range(3) if x or not x for j in range(3) if (x := i)][:-3]"
cases = [("Rebind global", "x = 1; result = $(rebinding)"), ("Rebind nonlocal", "result, x = (lambda x=1: ($(rebinding), x))()"), ("Filter global", "x = 1; result = $(filter_ref)"), ("Filter nonlocal", "result, x = (lambda x=1: ($(filter_ref), x))()"), ("Body global", "x = 1; result = $(body_ref)"), ("Body nonlocal", "result, x = (lambda x=1: ($(body_ref), x))()"), ("Nested global", "x = 1; result = $(nested_ref)"), ("Nested nonlocal", "result, x = (lambda x=1: ($(nested_ref), x))()")]
for (case, code) in cases
subTest(self, case = case) do 
ns = Dict()
exec(code, ns)
@test (ns["x"] == 2)
@test (ns["result"] == [0, 1, 2])
end
end
end

function test_named_expression_global_scope(self)
sentinel = object()
global GLOBAL_VAR
function f()
global GLOBAL_VAR
[(GLOBAL_VAR = sentinel) for _ in 0:0]
@test (GLOBAL_VAR == sentinel)
end

try
f()
@test (GLOBAL_VAR == sentinel)
finally
GLOBAL_VAR = nothing
end
end

function test_named_expression_global_scope_no_global_keyword(self)
sentinel = object()
function f()
GLOBAL_VAR = nothing
[(GLOBAL_VAR = sentinel) for _ in 0:0]
@test (GLOBAL_VAR == sentinel)
end

f()
@test (GLOBAL_VAR == nothing)
end

function test_named_expression_nonlocal_scope(self)
sentinel = object()
function f()
nonlocal_var = nothing
function g()
# Not Supported
# nonlocal nonlocal_var
[(nonlocal_var = sentinel) for _ in 0:0]
end

g()
@test (nonlocal_var == sentinel)
end

f()
end

function test_named_expression_nonlocal_scope_no_nonlocal_keyword(self)
sentinel = object()
function f()
nonlocal_var = nothing
function g()
[(nonlocal_var = sentinel) for _ in 0:0]
end

g()
@test (nonlocal_var == nothing)
end

f()
end

function test_named_expression_scope_in_genexp(self)
a = 1
b = [1, 2, 3, 4]
genexp = ((c = i + a) for i in b)
assertNotIn(self, "c", locals())
for (idx, elem) in enumerate(genexp)
@test (elem == b[idx + 1] + a)
end
end

if abspath(PROGRAM_FILE) == @__FILE__
named_expression_invalid_test = NamedExpressionInvalidTest()
test_named_expression_invalid_01(named_expression_invalid_test)
test_named_expression_invalid_02(named_expression_invalid_test)
test_named_expression_invalid_03(named_expression_invalid_test)
test_named_expression_invalid_04(named_expression_invalid_test)
test_named_expression_invalid_06(named_expression_invalid_test)
test_named_expression_invalid_07(named_expression_invalid_test)
test_named_expression_invalid_08(named_expression_invalid_test)
test_named_expression_invalid_09(named_expression_invalid_test)
test_named_expression_invalid_10(named_expression_invalid_test)
test_named_expression_invalid_11(named_expression_invalid_test)
test_named_expression_invalid_12(named_expression_invalid_test)
test_named_expression_invalid_13(named_expression_invalid_test)
test_named_expression_invalid_14(named_expression_invalid_test)
test_named_expression_invalid_15(named_expression_invalid_test)
test_named_expression_invalid_16(named_expression_invalid_test)
test_named_expression_invalid_17(named_expression_invalid_test)
test_named_expression_invalid_in_class_body(named_expression_invalid_test)
test_named_expression_invalid_rebinding_list_comprehension_iteration_variable(named_expression_invalid_test)
test_named_expression_invalid_rebinding_list_comprehension_inner_loop(named_expression_invalid_test)
test_named_expression_invalid_list_comprehension_iterable_expression(named_expression_invalid_test)
test_named_expression_invalid_rebinding_set_comprehension_iteration_variable(named_expression_invalid_test)
test_named_expression_invalid_rebinding_set_comprehension_inner_loop(named_expression_invalid_test)
test_named_expression_invalid_set_comprehension_iterable_expression(named_expression_invalid_test)
named_expression_assignment_test = NamedExpressionAssignmentTest()
test_named_expression_assignment_01(named_expression_assignment_test)
test_named_expression_assignment_02(named_expression_assignment_test)
test_named_expression_assignment_03(named_expression_assignment_test)
test_named_expression_assignment_04(named_expression_assignment_test)
test_named_expression_assignment_05(named_expression_assignment_test)
test_named_expression_assignment_06(named_expression_assignment_test)
test_named_expression_assignment_07(named_expression_assignment_test)
test_named_expression_assignment_08(named_expression_assignment_test)
test_named_expression_assignment_09(named_expression_assignment_test)
test_named_expression_assignment_10(named_expression_assignment_test)
test_named_expression_assignment_11(named_expression_assignment_test)
test_named_expression_assignment_12(named_expression_assignment_test)
test_named_expression_assignment_13(named_expression_assignment_test)
test_named_expression_assignment_14(named_expression_assignment_test)
test_named_expression_assignment_15(named_expression_assignment_test)
test_named_expression_assignment_16(named_expression_assignment_test)
named_expression_scope_test = NamedExpressionScopeTest()
test_named_expression_scope_01(named_expression_scope_test)
test_named_expression_scope_02(named_expression_scope_test)
test_named_expression_scope_03(named_expression_scope_test)
test_named_expression_scope_04(named_expression_scope_test)
test_named_expression_scope_05(named_expression_scope_test)
test_named_expression_scope_06(named_expression_scope_test)
test_named_expression_scope_07(named_expression_scope_test)
test_named_expression_scope_08(named_expression_scope_test)
test_named_expression_scope_09(named_expression_scope_test)
test_named_expression_scope_10(named_expression_scope_test)
test_named_expression_scope_11(named_expression_scope_test)
test_named_expression_scope_17(named_expression_scope_test)
test_named_expression_scope_18(named_expression_scope_test)
test_named_expression_scope_19(named_expression_scope_test)
test_named_expression_scope_20(named_expression_scope_test)
test_named_expression_scope_21(named_expression_scope_test)
test_named_expression_scope_22(named_expression_scope_test)
test_named_expression_scope_23(named_expression_scope_test)
test_named_expression_scope_24(named_expression_scope_test)
test_named_expression_scope_25(named_expression_scope_test)
test_named_expression_variable_reuse_in_comprehensions(named_expression_scope_test)
test_named_expression_global_scope(named_expression_scope_test)
test_named_expression_global_scope_no_global_keyword(named_expression_scope_test)
test_named_expression_nonlocal_scope(named_expression_scope_test)
test_named_expression_nonlocal_scope_no_nonlocal_keyword(named_expression_scope_test)
test_named_expression_scope_in_genexp(named_expression_scope_test)
end