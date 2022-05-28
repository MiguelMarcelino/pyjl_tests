#= Basic test of the frozen module (source is in Python/frozen.c). =#
using Test
import __hello__



abstract type AbstractTestFrozen end
mutable struct TestFrozen <: AbstractTestFrozen

end
function test_frozen(self)
name = "__hello__"
if name ∈ sys.modules
#Delete Unsupported
del(sys.modules)
end
captured_stdout() do out 

end
@test (getvalue(out) == "Hello world!\n")
end

if abspath(PROGRAM_FILE) == @__FILE__
test_frozen = TestFrozen()
test_frozen(test_frozen)
end