#= Python.Interpreter COM Server

  This module implements a very very simple COM server which
  exposes the Python interpreter.

  This is designed more as a demonstration than a full blown COM server.
  General functionality and Error handling are both limited.

  To use this object, ensure it is registered by running this module
  from Python.exe.  Then, from Visual Basic, use "CreateObject('Python.Interpreter')",
  and call its methods!
 =#
include("../server/register.jl")
include("../server/exception.jl")
import winerror
abstract type AbstractInterpreter end
mutable struct Interpreter <: AbstractInterpreter
    #= The interpreter object exposed via COM =#
    dict::Dict
    _public_methods_::Vector{String}
    _reg_class_spec_::String
    _reg_clsid_::String
    _reg_desc_::String
    _reg_progid_::String
    _reg_verprogid_::String
    Interpreter(dict = Dict()) = new(dict)
end
function Eval(self::AbstractInterpreter, exp)
    #= Evaluate an expression. =#
    if type_(exp) != str
        throw(Exception(desc = "Must be a string", scode = winerror.DISP_E_TYPEMISMATCH))
    end
    return eval(string(exp), self.dict)
end

function Exec(self::AbstractInterpreter, exp)
    #= Execute a statement. =#
    if type_(exp) != str
        throw(Exception(desc = "Must be a string", scode = winerror.DISP_E_TYPEMISMATCH))
    end
    exec(string(exp), self.dict)
end

function Register()
    return win32com_.server.register.UseCommandLine(Interpreter)
end

if abspath(PROGRAM_FILE) == @__FILE__
    println("Registering COM server...")
    Register()
end
