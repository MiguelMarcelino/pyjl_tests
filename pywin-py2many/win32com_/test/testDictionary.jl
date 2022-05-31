using PyCall
pywintypes = pyimport("pywintypes")
datetime = pyimport("datetime")
import win32com_.servers.dictionary
using win32com_.test.util: RegisterPythonServer

import win32com_.server.util
import win32com_.test.util
import win32com_.client

using ext_modules: pythoncom

import winerror
import win32timezone

abstract type AbstractTestCase <: win32com_.test.util.TestCase end
function MakeTestDictionary()
    return win32com_.client.Dispatch("Python.Dictionary")
end

function TestDictAgainst(dict, check)
    for (key, value) in collect(items(check))
        if dict(key) != value
            throw(
                Exception(
                    "Indexing for \'$(repr(key))\' gave the incorrect value - $(repr(dict[key + 1]))/$(repr(check[key + 1]))",
                ),
            )
        end
    end
end

function Register(quiet)
    RegisterPythonServer(win32com_.servers.dictionary.__file__, "Python.Dictionary")
end

function TestDict(quiet = nothing)
    if quiet === nothing
        quiet = !("-v" ∈ append!([PROGRAM_FILE], ARGS))
    end
    Register(quiet)
    if !(quiet)
        println("Simple enum test")
    end
    dict = MakeTestDictionary()
    checkDict = Dict()
    TestDictAgainst(dict, checkDict)
    dict["NewKey"] = "NewValue"
    checkDict["NewKey"] = "NewValue"
    TestDictAgainst(dict, checkDict)
    dict["NewKey"] = nothing
    delete!(checkDict, "NewKey")
    TestDictAgainst(dict, checkDict)
    now = win32timezone.now()
    now = replace(now, microsecond = round(now.microsecond / 1000) * 1000)
    dict["Now"] = now
    checkDict["Now"] = now
    TestDictAgainst(dict, checkDict)
    if !(quiet)
        println("Failure tests")
    end
    try
        dict()
        throw(Exception("default method with no args worked when it shouldnt have!"))
    catch exn
        let xxx_todo_changeme = exn
            if xxx_todo_changeme isa pythoncom.com_error
                hr, desc, exc, argErr = xxx_todo_changeme.args
                if hr != winerror.DISP_E_BADPARAMCOUNT
                    throw(Exception("Expected DISP_E_BADPARAMCOUNT - got $(hr) ($(desc))"))
                end
            end
        end
    end
    try
        dict("hi", "there")
        throw(Exception("multiple args worked when it shouldnt have!"))
    catch exn
        let xxx_todo_changeme1 = exn
            if xxx_todo_changeme1 isa pythoncom.com_error
                hr, desc, exc, argErr = xxx_todo_changeme1.args
                if hr != winerror.DISP_E_BADPARAMCOUNT
                    throw(Exception("Expected DISP_E_BADPARAMCOUNT - got $(hr) ($(desc))"))
                end
            end
        end
    end
    try
        dict(0)
        throw(Exception("int key worked when it shouldnt have!"))
    catch exn
        let xxx_todo_changeme2 = exn
            if xxx_todo_changeme2 isa pythoncom.com_error
                hr, desc, exc, argErr = xxx_todo_changeme2.args
                if hr != winerror.DISP_E_TYPEMISMATCH
                    throw(Exception("Expected DISP_E_TYPEMISMATCH - got $(hr) ($(desc))"))
                end
            end
        end
    end
    if !(quiet)
        println("Python.Dictionary tests complete.")
    end
end

mutable struct TestCase <: AbstractTestCase
end
function testDict(self::AbstractTestCase)
    TestDict()
end

if abspath(PROGRAM_FILE) == @__FILE__
end
