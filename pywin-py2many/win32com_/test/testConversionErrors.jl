
import win32com_.client
import win32com_.test.util
import win32com_.server.util
abstract type AbstractTester end
abstract type AbstractTestException <: Exception end
abstract type AbstractBadConversions end
abstract type AbstractTestCase <: win32com_.test.util.TestCase end
mutable struct Tester <: AbstractTester
_public_methods_::Vector{String}
end
function TestValue(self::AbstractTester, v)
#= pass =#
end

function test_ob()
return win32com_.client.Dispatch(win32com_.server.util.wrap(Tester()))
end

mutable struct TestException <: AbstractTestException

end

mutable struct BadConversions <: AbstractBadConversions

end
function __float__(self::AbstractBadConversions)
throw(TestException())
end

mutable struct TestCase <: AbstractTestCase

end
function test_float(self::AbstractTestCase)
try
TestValue(test_ob(), BadConversions())
throw(Exception("Should not have worked"))
catch exn
 let e = exn
if e isa Exception
@assert(isa(e, TestException))
end
end
end
end

if abspath(PROGRAM_FILE) == @__FILE__
end