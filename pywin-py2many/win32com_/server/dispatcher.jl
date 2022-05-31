#= Dispatcher

Please see policy.py for a discussion on dispatchers and policies
 =#
import win32traceutil
using ext_modules: pythoncom, traceback, win32api

using win32com_.server.exception: IsCOMServerException
using win32com_.util: IIDToInterfaceName
import win32com_
mutable struct DispatcherBase <: AbstractDispatcherBase
#= The base class for all Dispatchers.

    This dispatcher supports wrapping all operations in exception handlers,
    and all the necessary delegation to the policy.

    This base class supports the printing of "unexpected" exceptions.  Note, however,
    that exactly where the output of print goes may not be useful!  A derived class may
    provide additional semantics for this.
     =#
policy
logger
DispatcherBase(policyClass, object, policy = policyClass(object), logger = (hasfield(typeof(win32com_), :logger) ? 
                getfield(win32com_, :logger) : nothing)) = new(policyClass, object, policy , logger )
end
function _CreateInstance_(self::AbstractDispatcherBase, clsid, reqIID)
try
_CreateInstance_(self.policy, clsid, reqIID)
return pythoncom.WrapObject(self, reqIID)
catch exn
return _HandleException_(self)
end
end

function _QueryInterface_(self::AbstractDispatcherBase, iid)
try
return _QueryInterface_(self.policy, iid)
catch exn
return _HandleException_(self)
end
end

function _Invoke_(self::AbstractDispatcherBase, dispid, lcid, wFlags, args)
try
return _Invoke_(self.policy, dispid, lcid, wFlags, args)
catch exn
return _HandleException_(self)
end
end

function _GetIDsOfNames_(self::AbstractDispatcherBase, names, lcid)
try
return _GetIDsOfNames_(self.policy, names, lcid)
catch exn
return _HandleException_(self)
end
end

function _GetTypeInfo_(self::AbstractDispatcherBase, index, lcid)
try
return _GetTypeInfo_(self.policy, index, lcid)
catch exn
return _HandleException_(self)
end
end

function _GetTypeInfoCount_(self::AbstractDispatcherBase)
try
return _GetTypeInfoCount_(self.policy)
catch exn
return _HandleException_(self)
end
end

function _GetDispID_(self::AbstractDispatcherBase, name, fdex)
try
return _GetDispID_(self.policy, name, fdex)
catch exn
return _HandleException_(self)
end
end

function _InvokeEx_(self::AbstractDispatcherBase, dispid, lcid, wFlags, args, kwargs, serviceProvider)
try
return _InvokeEx_(self.policy, dispid, lcid, wFlags, args, kwargs, serviceProvider)
catch exn
return _HandleException_(self)
end
end

function _DeleteMemberByName_(self::AbstractDispatcherBase, name, fdex)
try
return _DeleteMemberByName_(self.policy, name, fdex)
catch exn
return _HandleException_(self)
end
end

function _DeleteMemberByDispID_(self::AbstractDispatcherBase, id)
try
return _DeleteMemberByDispID_(self.policy, id)
catch exn
return _HandleException_(self)
end
end

function _GetMemberProperties_(self::AbstractDispatcherBase, id, fdex)
try
return _GetMemberProperties_(self.policy, id, fdex)
catch exn
return _HandleException_(self)
end
end

function _GetMemberName_(self::AbstractDispatcherBase, dispid)
try
return _GetMemberName_(self.policy, dispid)
catch exn
return _HandleException_(self)
end
end

function _GetNextDispID_(self::AbstractDispatcherBase, fdex, flags)
try
return _GetNextDispID_(self.policy, fdex, flags)
catch exn
return _HandleException_(self)
end
end

function _GetNameSpaceParent_(self::AbstractDispatcherBase)
try
return _GetNameSpaceParent_(self.policy)
catch exn
return _HandleException_(self)
end
end

function _HandleException_(self::AbstractDispatcherBase)
#= Called whenever an exception is raised.

        Default behaviour is to print the exception.
         =#
if !IsCOMServerException()
if self.logger !== nothing
exception(self.logger, "pythoncom server error")
else
traceback.print_exc()
end
end
error()
end

function _trace_(self::AbstractDispatcherBase)
if self.logger !== nothing
record = join(map(str, args), " ")
debug(self.logger, record)
else
for arg in args[begin:end - 1]
print("$(arg)" )
end
println(args[end])
end
end

abstract type AbstractDispatcherBase end
abstract type AbstractDispatcherTrace <: AbstractDispatcherBase end
abstract type AbstractDispatcherWin32trace <: AbstractDispatcherTrace end
abstract type AbstractDispatcherOutputDebugString <: AbstractDispatcherTrace end
abstract type AbstractDispatcherWin32dbg <: AbstractDispatcherBase end
mutable struct DispatcherTrace <: AbstractDispatcherTrace
#= A dispatcher, which causes a 'print' line for each COM function called. =#
policy
end
function _QueryInterface_(self::AbstractDispatcherTrace, iid)
rc = DispatcherBase._QueryInterface_(self, iid)
if !(rc)
_trace_(self, "in $(repr(self.policy._obj_))._QueryInterface_ with unsupported IID $(IIDToInterfaceName(iid)) ($(iid))")
end
return rc
end

function _GetIDsOfNames_(self::AbstractDispatcherTrace, names, lcid)
_trace_(self, "in _GetIDsOfNames_ with \'$(names)\' and \'$(lcid)\'\n")
return DispatcherBase._GetIDsOfNames_(self, names, lcid)
end

function _GetTypeInfo_(self::AbstractDispatcherTrace, index, lcid)
_trace_(self, "in _GetTypeInfo_ with index=$(index), lcid=$(lcid)\n")
return DispatcherBase._GetTypeInfo_(self, index, lcid)
end

function _GetTypeInfoCount_(self::AbstractDispatcherTrace)
_trace_(self, "in _GetTypeInfoCount_\n")
return DispatcherBase._GetTypeInfoCount_(self)
end

function _Invoke_(self::AbstractDispatcherTrace, dispid, lcid, wFlags, args)
_trace_(self, "in _Invoke_ with", dispid, lcid, wFlags, args)
return DispatcherBase._Invoke_(self, dispid, lcid, wFlags, args)
end

function _GetDispID_(self::AbstractDispatcherTrace, name, fdex)
_trace_(self, "in _GetDispID_ with", name, fdex)
return DispatcherBase._GetDispID_(self, name, fdex)
end

function _InvokeEx_(self::AbstractDispatcherTrace, dispid, lcid, wFlags, args, kwargs, serviceProvider)
_trace_(self, "in $(self.policy._obj_)._InvokeEx_-$(dispid)$(args) [$(wFlags),$(lcid),$(serviceProvider)]")
return DispatcherBase._InvokeEx_(self, dispid, lcid, wFlags, args, kwargs, serviceProvider)
end

function _DeleteMemberByName_(self::AbstractDispatcherTrace, name, fdex)
_trace_(self, "in _DeleteMemberByName_ with", name, fdex)
return DispatcherBase._DeleteMemberByName_(self, name, fdex)
end

function _DeleteMemberByDispID_(self::AbstractDispatcherTrace, id)
_trace_(self, "in _DeleteMemberByDispID_ with", id)
return DispatcherBase._DeleteMemberByDispID_(self, id)
end

function _GetMemberProperties_(self::AbstractDispatcherTrace, id, fdex)
_trace_(self, "in _GetMemberProperties_ with", id, fdex)
return DispatcherBase._GetMemberProperties_(self, id, fdex)
end

function _GetMemberName_(self::AbstractDispatcherTrace, dispid)
_trace_(self, "in _GetMemberName_ with", dispid)
return DispatcherBase._GetMemberName_(self, dispid)
end

function _GetNextDispID_(self::AbstractDispatcherTrace, fdex, flags)
_trace_(self, "in _GetNextDispID_ with", fdex, flags)
return DispatcherBase._GetNextDispID_(self, fdex, flags)
end

function _GetNameSpaceParent_(self::AbstractDispatcherTrace)
_trace_(self, "in _GetNameSpaceParent_")
return DispatcherBase._GetNameSpaceParent_(self)
end

mutable struct DispatcherWin32trace <: AbstractDispatcherWin32trace
#= A tracing dispatcher that sends its output to the win32trace remote collector. =#


            DispatcherWin32trace(policyClass, object) = begin
                DispatcherTrace(policyClass, object)
if logger === nothing
end
_trace_("Object with win32trace dispatcher created (object=$(repr(object)))")
                new(policyClass, object)
            end
end

mutable struct DispatcherOutputDebugString <: AbstractDispatcherOutputDebugString
#= A tracing dispatcher that sends its output to win32api.OutputDebugString =#

end
function _trace_(self::AbstractDispatcherOutputDebugString)
for arg in args[begin:end - 1]
win32api.OutputDebugString(string(arg) * " ")
end
win32api.OutputDebugString(string(args[end]) * "\n")
end

mutable struct DispatcherWin32dbg <: AbstractDispatcherWin32dbg
#= A source-level debugger dispatcher

    A dispatcher which invokes the debugger as an object is instantiated, or
    when an unexpected exception occurs.

    Requires Pythonwin.
     =#


            DispatcherWin32dbg(policyClass, ob) = begin
                win32com_.gen_py.debugger.brk()
println("The DispatcherWin32dbg dispatcher is deprecated!")
println("Please let me know if this is a problem.")
println("Uncomment the relevant lines in dispatcher.py to re-enable")
DispatcherBase(policyClass, ob)
                new(policyClass, ob)
            end
end
function _HandleException_(self::AbstractDispatcherWin32dbg)
#= Invoke the debugger post mortem capability =#
typ, val, tb = exc_info()
debug = 0
try
throw(typ(val))
catch exn
if exn isa Exception
debug = get_option(win32com_.gen_py.debugger.GetDebugger(), win32com_.gen_py.debugger.dbgcon.OPT_STOP_EXCEPTIONS)
end
debug = 1
end
if debug != 0
try
post_mortem(win32com_.gen_py.debugger, tb, typ, val)
catch exn
traceback.print_exc()
end
end
#Delete Unsupported
del(tb)
error()
end

try
import win32trace
DefaultDebugDispatcher = DispatcherWin32trace
catch exn
if exn isa ImportError
DefaultDebugDispatcher = DispatcherTrace
end
end