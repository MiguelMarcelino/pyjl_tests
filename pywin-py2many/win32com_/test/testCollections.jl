using PyCall
pywintypes = pyimport("pywintypes")

include("../server/util.jl")
include("util.jl")
import win32com_.client

using ext_modules: pythoncom

import winerror
L = pywintypes.Unicode
abstract type AbstractTestCase <: win32com_.test.util.TestCase end

error = "collection test error"
function MakeEmptyEnum()
    o = win32com_.server.util.wrap(win32com_.server.util.Collection())
    return win32com_.client.Dispatch(o)
end

function MakeTestEnum()
    sub = win32com_.server.util.wrap(win32com_.server.util.Collection(["Sub1", 2, "Sub3"]))
    o = win32com_.server.util.wrap(win32com_.server.util.Collection([1, "Two", 3, sub]))
    return win32com_.client.Dispatch(o)
end

function TestEnumAgainst(o, check)
    for i = 0:length(check)-1
        if o(i) != check[i+1]
            throw(
                error(
                    "Using default method gave the incorrect value - $(repr(o(i)))/$(repr(check[i + 1]))",
                ),
            )
        end
    end
    for i = 0:length(check)-1
        if Item(o, i) != check[i+1]
            throw(
                error(
                    "Using Item method gave the incorrect value - $(repr(o(i)))/$(repr(check[i + 1]))",
                ),
            )
        end
    end
    cmp = []
    for s in o
        push!(cmp, s)
    end
    if cmp[begin:length(check)] != check
        throw(
            error(
                "Result after looping isnt correct - $(repr(cmp[begin:length(check)]))/$(repr(check))",
            ),
        )
    end
    for i = 0:length(check)-1
        if o[i+1] != check[i+1]
            throw(error("Using indexing gave the incorrect value"))
        end
    end
end

function TestEnum(quiet = nothing)
    if quiet === nothing
        quiet = !("-v" ∈ append!([PROGRAM_FILE], ARGS))
    end
    if !(quiet)
        println("Simple enum test")
    end
    o = MakeTestEnum()
    check = [1, "Two", 3]
    TestEnumAgainst(o, check)
    if !(quiet)
        println("sub-collection test")
    end
    sub = o[4]
    TestEnumAgainst(sub, ["Sub1", 2, "Sub3"])
    Remove(o, Count(o) - 1)
    if !(quiet)
        println("Remove item test")
    end
    #Delete Unsupported
    del(check)
    Remove(o, 1)
    TestEnumAgainst(o, check)
    if !(quiet)
        println("Add item test")
    end
    Add(o, "New Item")
    append(check, "New Item")
    TestEnumAgainst(o, check)
    if !(quiet)
        println("Insert item test")
    end
    Insert(o, 2, -1)
    insert(check, 2, -1)
    TestEnumAgainst(o, check)
    try
        o()
        throw(error("default method with no args worked when it shouldnt have!"))
    catch exn
        let exc = exn
            if exc isa pythoncom.com_error
                if exc.hresult != winerror.DISP_E_BADPARAMCOUNT
                    throw(error("Expected DISP_E_BADPARAMCOUNT - got $(exc)"))
                end
            end
        end
    end
    try
        Insert(o, "foo", 2)
        throw(error("Insert worked when it shouldnt have!"))
    catch exn
        let exc = exn
            if exc isa pythoncom.com_error
                if exc.hresult != winerror.DISP_E_TYPEMISMATCH
                    throw(error("Expected DISP_E_TYPEMISMATCH - got $(exc)"))
                end
            end
        end
    end
    try
        Remove(o, Count(o))
        throw(error("Remove worked when it shouldnt have!"))
    catch exn
        let exc = exn
            if exc isa pythoncom.com_error
                if exc.hresult != winerror.DISP_E_BADINDEX
                    throw(error("Expected DISP_E_BADINDEX - got $(exc)"))
                end
            end
        end
    end
    if !(quiet)
        println("Empty collection test")
    end
    o = MakeEmptyEnum()
    for item in o
        throw(error("Empty list performed an iteration"))
    end
    try
        ob = o[2]
        throw(error("Empty list could be indexed"))
    catch exn
        if exn isa IndexError
            #= pass =#
        end
    end
    try
        ob = o[1]
        throw(error("Empty list could be indexed"))
    catch exn
        if exn isa IndexError
            #= pass =#
        end
    end
    try
        ob = o(0)
        throw(error("Empty list could be indexed"))
    catch exn
        let exc = exn
            if exc isa pythoncom.com_error
                if exc.hresult != winerror.DISP_E_BADINDEX
                    throw(error("Expected DISP_E_BADINDEX - got $(exc)"))
                end
            end
        end
    end
end

mutable struct TestCase <: AbstractTestCase
end
function testEnum(self::AbstractTestCase)
    TestEnum()
end

if abspath(PROGRAM_FILE) == @__FILE__
end
