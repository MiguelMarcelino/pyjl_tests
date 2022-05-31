#= A COM Server which exposes the NT Performance monitor in a very rudimentary way

Usage from VB:
\tset ob = CreateObject("Python.PerfmonQuery")
\tfreeBytes = ob.Query("Memory", "Available Bytes")
 =#
using win32com_.server: exception, register
using ext_modules: pythoncom, win32pdhutil, winerror
abstract type AbstractPerfMonQuery end
mutable struct PerfMonQuery <: AbstractPerfMonQuery
_public_methods_::Vector{String}
_reg_class_spec_::String
_reg_clsid_::String
_reg_desc_::String
_reg_progid_::String
_reg_verprogid_::String
end
function Query(self::AbstractPerfMonQuery, object, counter, instance = nothing, machine = nothing)
try
return win32pdhutil.GetPerformanceAttributes(object, counter, instance, machine = machine)
catch exn
 let exc = exn
if exc isa win32pdhutil.error
throw(exception.Exception(desc = exc.strerror))
end
end
 let desc = exn
if desc isa TypeError
throw(exception.Exception(desc = desc, scode = winerror.DISP_E_TYPEMISMATCH))
end
end
end
end

if abspath(PROGRAM_FILE) == @__FILE__
println("Registering COM server...")
register.UseCommandLine(PerfMonQuery)
end