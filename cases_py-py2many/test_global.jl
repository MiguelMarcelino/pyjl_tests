#= Verify that warnings are issued for global statements following use. =#

using test.support.warnings_helper: check_warnings

import warnings
abstract type AbstractGlobalTests end
mutable struct GlobalTests <: AbstractGlobalTests
_warnings_manager
end
function setUp(self)
self._warnings_manager = check_warnings()
__enter__(self._warnings_manager)
filterwarnings("error", module_ = "<test string>")
end

function tearDown(self)
__exit__(self._warnings_manager, nothing, nothing, nothing)
end

function test1(self)
prog_text_1 = "def wrong1():\n    a = 1\n    b = 2\n    global a\n    global b\n"
check_syntax_error(self, prog_text_1, lineno = 4, offset = 5)
end

function test2(self)
prog_text_2 = "def wrong2():\n    print(x)\n    global x\n"
check_syntax_error(self, prog_text_2, lineno = 3, offset = 5)
end

function test3(self)
prog_text_3 = "def wrong3():\n    print(x)\n    x = 2\n    global x\n"
check_syntax_error(self, prog_text_3, lineno = 4, offset = 5)
end

function test4(self)
prog_text_4 = "global x\nx = 2\n"
compile(prog_text_4, "<test string>", "exec")
end

function setUpModule()
cm = catch_warnings()
__enter__(cm)
addModuleCleanup(cm.__exit__, nothing, nothing, nothing)
filterwarnings("error", module_ = "<test string>")
end

if abspath(PROGRAM_FILE) == @__FILE__
global_tests = GlobalTests()
setUp(global_tests)
tearDown(global_tests)
test1(global_tests)
test2(global_tests)
test3(global_tests)
test4(global_tests)
end