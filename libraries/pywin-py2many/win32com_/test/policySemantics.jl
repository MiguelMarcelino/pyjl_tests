include("../server/dispatcher.jl")
include("../server/util.jl")
import win32com_.client
using ext_modules: pythoncom
import winerror
include("util.jl")

abstract type AbstractError <: Exception end
abstract type AbstractPythonSemanticClass end
abstract type AbstractTester <: win32com_.test.util.TestCase end
mutable struct Error <: AbstractError
end

mutable struct PythonSemanticClass <: AbstractPythonSemanticClass
    list::Vector
    _dispid_to_func_::Dict{Int64, String}
    _public_methods_::Vector{String}
    PythonSemanticClass(list = []) = new(list)
end
function _NewEnum(self::AbstractPythonSemanticClass)
    return win32com_.server.util.NewEnum(self.list)
end

function _value_(self::AbstractPythonSemanticClass)::Vector
    return self.list
end

function _Evaluate(self::AbstractPythonSemanticClass)
    return sum(self.list)
end

function In(self::AbstractPythonSemanticClass, value)::Bool
    return value ∈ self.list
end

function Add(self::AbstractPythonSemanticClass, value)
    append(self.list, value)
end

function Remove(self::AbstractPythonSemanticClass, value)
    remove(self.list, value)
end

function DispExTest(ob)
    if !(__debug__)
        println("WARNING: Tests dressed up as assertions are being skipped!")
    end
    @assert(GetDispID(ob, "Add", 0) == 10)
    @assert(GetDispID(ob, "Remove", 0) == 11)
    @assert(GetDispID(ob, "In", 0) == 1000)
    @assert(GetDispID(ob, "_NewEnum", 0) == pythoncom.DISPID_NEWENUM)
    dispids = []
    dispid = -1
    while true
        try
            dispid = GetNextDispID(ob, 0, dispid)
            push!(dispids, dispid)
        catch exn
            let xxx_todo_changeme = exn
                if xxx_todo_changeme isa pythoncom.com_error
                    hr, desc, exc, arg = xxx_todo_changeme.args
                    @assert(hr == winerror.S_FALSE)
                    break
                end
            end
        end
    end
    sort(dispids)
    if dispids != [pythoncom.DISPID_EVALUATE, pythoncom.DISPID_NEWENUM, 10, 11, 1000]
        throw(Error("Got back the wrong dispids: $(dispids)"))
    end
end

function SemanticTest(ob)
    Add(ob, 1)
    Add(ob, 2)
    Add(ob, 3)
    if ob() != (1, 2, 3)
        throw(Error("Bad result - got $(repr(ob()))"))
    end
    dispob = ob._oleobj_
    rc = Invoke(
        dispob,
        pythoncom.DISPID_EVALUATE,
        0,
        pythoncom.DISPATCH_METHOD | pythoncom.DISPATCH_PROPERTYGET,
        1,
    )
    if rc != 6
        throw(Error("Evaluate returned $(rc)"))
    end
end

mutable struct Tester <: AbstractTester
    ob
end
function setUp(self::AbstractTester)
    debug = 0
    if debug != 0
        dispatcher = win32com_.server.dispatcher.DefaultDebugDispatcher
    else
        dispatcher = nothing
    end
    disp = win32com_.server.util.wrap(PythonSemanticClass(), useDispatcher = dispatcher)
    self.ob = win32com_.client.Dispatch(disp)
end

function tearDown(self::AbstractTester)
    self.ob = nothing
end

function testSemantics(self::AbstractTester)
    SemanticTest(self.ob)
end

function testIDispatchEx(self::AbstractTester)
    dispexob = QueryInterface(self.ob._oleobj_, pythoncom.IID_IDispatchEx)
    DispExTest(dispexob)
end

if abspath(PROGRAM_FILE) == @__FILE__
end
