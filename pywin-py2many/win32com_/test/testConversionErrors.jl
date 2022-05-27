<<<<<<< HEAD

import win32com_.client
import win32com_.test.util
import win32com_.server.util
abstract type AbstractTester end
abstract type AbstractTestException <: Exception end
abstract type AbstractBadConversions end
abstract type AbstractTestCase <: win32com_.test.util.TestCase end
mutable struct Tester <: AbstractTester
_public_methods_::Vector{String}

                    Tester(_public_methods_::Vector{String} = ["TestValue"]) =
                        new(_public_methods_)
end
function TestValue(self::Tester, v)
#= pass =#
end

function test_ob()
return Dispatch(wrap(Tester()))
end

mutable struct TestException <: AbstractTestException

end

mutable struct BadConversions <: AbstractBadConversions

end
function __float__(self::BadConversions)
throw(TestException())
end

mutable struct TestCase <: AbstractTestCase

end
function test_float(self::TestCase)
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
=======

import win32com_.client
import win32com_.test.util
import win32com_.server.util
abstract type AbstractTester end
abstract type AbstractTestException <: Exception end
abstract type AbstractBadConversions end
abstract type AbstractTestCase <: win32com_.test.util.TestCase end
mutable struct Tester <: AbstractTester
    _public_methods_::Vector{String}

    Tester(_public_methods_::Vector{String} = ["TestValue"]) = new(_public_methods_)
end
function TestValue(self::Tester, v)
    #= pass =#
end

function test_ob()
    return Dispatch(wrap(Tester()))
end

mutable struct TestException <: AbstractTestException
end

mutable struct BadConversions <: AbstractBadConversions
end
function __float__(self::BadConversions)
    throw(TestException())
end

mutable struct TestCase <: AbstractTestCase
end
function test_float(self::TestCase)
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
>>>>>>> f214ca7f5ced7424e7132e581746e8672e842fb6
