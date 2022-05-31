using PyCall
pywintypes = pyimport("pywintypes")

import gencache
import win32com_.ext_modules.winerror as winerror
using ext_modules: pythoncom
include("dynamic.jl")
include("gencache.jl")


_PyIDispatchType = pythoncom.TypeIIDs[pythoncom.IID_IDispatch + 1]
function __WrapDispatch(dispatch::AbstractVARIANT, userName = nothing, resultCLSID = nothing, typeinfo = nothing, UnicodeToString = nothing, clsctx = pythoncom.CLSCTX_SERVER, WrapperClass = nothing)
#= 
    Helper function to return a makepy generated class for a CLSID if it exists,
    otherwise cope by using CDispatch.
     =#
@assert(UnicodeToString === nothing)
if resultCLSID === nothing
try
typeinfo = GetTypeInfo(dispatch)
if typeinfo !== nothing
resultCLSID = string(GetTypeAttr(typeinfo)[1])
end
catch exn
if exn isa (pythoncom.com_error, AttributeError)
#= pass =#
end
end
end
if resultCLSID !== nothing
klass = gencache.GetClassForCLSID(resultCLSID)
if klass !== nothing
return klass(dispatch)
end
end
if WrapperClass === nothing
WrapperClass = CDispatch
end
return dynamic.Dispatch(dispatch, userName, WrapperClass, typeinfo, clsctx = clsctx)
end

abstract type AbstractCDispatch <: dynamic.CDispatch end
abstract type AbstractConstants end
abstract type AbstractEventsProxy end
abstract type AbstractDispatchBaseClass end
abstract type AbstractCoClassBaseClass end
abstract type AbstractVARIANT end
function GetObject(Pathname::AbstractVARIANT = nothing, Class = nothing, clsctx = nothing)
#= 
    Mimic VB's GetObject() function.

    ob = GetObject(Class = "ProgID") or GetObject(Class = clsid) will
    connect to an already running instance of the COM object.

    ob = GetObject(r"c:\blah\blah\foo.xls") (aka the COM moniker syntax)
    will return a ready to use Python wrapping of the required COM object.

    Note: You must specifiy one or the other of these arguments. I know
    this isn't pretty, but it is what VB does. Blech. If you don't
    I'll throw ValueError at you. :)

    This will most likely throw pythoncom.com_error if anything fails.
     =#
if clsctx === nothing
clsctx = pythoncom.CLSCTX_ALL
end
if Pathname === nothing && Class === nothing || Pathname !== nothing && Class !== nothing
throw(ValueError("You must specify a value for Pathname or Class, but not both."))
end
if Class !== nothing
return GetActiveObject(Class, clsctx)
else
return Moniker(Pathname, clsctx)
end
end

function GetActiveObject(Class::AbstractVARIANT, clsctx = pythoncom.CLSCTX_ALL)
#= 
    Python friendly version of GetObject's ProgID/CLSID functionality.
     =#
resultCLSID = pywintypes.IID(Class)
dispatch = pythoncom.GetActiveObject(resultCLSID)
dispatch = QueryInterface(dispatch, pythoncom.IID_IDispatch)
return __WrapDispatch(dispatch, Class)
end

function Moniker(Pathname::AbstractVARIANT, clsctx = pythoncom.CLSCTX_ALL)
#= 
    Python friendly version of GetObject's moniker functionality.
     =#
moniker, i, bindCtx = pythoncom.MkParseDisplayName(Pathname)
dispatch = BindToObject(moniker, bindCtx, nothing, pythoncom.IID_IDispatch)
return __WrapDispatch(dispatch, Pathname)
end

function Dispatch(dispatch::AbstractVARIANT, userName = nothing, resultCLSID = nothing, typeinfo = nothing, UnicodeToString = nothing, clsctx = pythoncom.CLSCTX_SERVER)
#= Creates a Dispatch based COM object. =#
@assert(UnicodeToString === nothing)
dispatch, userName = dynamic._GetGoodDispatchAndUserName(dispatch, userName, clsctx)
return __WrapDispatch(dispatch, userName, resultCLSID, typeinfo)
end

function DispatchEx(clsid::AbstractVARIANT, machine = nothing, userName = nothing, resultCLSID = nothing, typeinfo = nothing, UnicodeToString = nothing, clsctx = nothing)
#= Creates a Dispatch based COM object on a specific machine. =#
@assert(UnicodeToString === nothing)
if clsctx === nothing
clsctx = pythoncom.CLSCTX_SERVER
if machine !== nothing
clsctx = clsctx & ~(pythoncom.CLSCTX_INPROC)
end
end
if machine === nothing
serverInfo = nothing
else
serverInfo = (machine,)
end
if userName === nothing
userName = clsid
end
dispatch = pythoncom.CoCreateInstanceEx(clsid, nothing, clsctx, serverInfo, (pythoncom.IID_IDispatch,))[1]
return Dispatch(dispatch, userName, resultCLSID, typeinfo)
end

mutable struct CDispatch <: AbstractCDispatch
#= 
    The dynamic class used as a last resort.
    The purpose of this overriding of dynamic.CDispatch is to perpetuate the policy
    of using the makepy generated wrapper Python class instead of dynamic.CDispatch
    if/when possible.
     =#

end
function _wrap_dispatch_(self::AbstractCDispatch, ob, userName = nothing, returnCLSID = nothing, UnicodeToString = nothing)
@assert(UnicodeToString === nothing)
return Dispatch(ob, userName, returnCLSID, nothing)
end

function __dir__(self::AbstractCDispatch)
return __dir__(dynamic.CDispatch)
end

function CastTo(ob::AbstractVARIANT, target, typelib = nothing)
#= 'Cast' a COM object to another interface =#
mod = nothing
if typelib !== nothing
mod = gencache.MakeModuleForTypelib(typelib.clsid, typelib.lcid, parse(Int, typelib.major), parse(Int, typelib.minor))
if !hasfield(typeof(mod), :target)
throw(ValueError("$(target)$(typelib.ver_desc)"))
end
elseif hasfield(typeof(target), :index)
if "CLSID" ∉ ob.__class__.__dict__
ob = gencache.EnsureDispatch(ob)
end
if "CLSID" ∉ ob.__class__.__dict__
throw(ValueError("Must be a makepy-able object for this to work"))
end
clsid = ob.CLSID
mod = gencache.GetModuleForCLSID(clsid)
mod = gencache.GetModuleForTypelib(mod.CLSID, mod.LCID, mod.MajorVersion, mod.MinorVersion)
target_clsid = get(mod.NamesToIIDMap, target)
if target_clsid === nothing
throw(ValueError("$(target)$(ob)'"))
end
mod = gencache.GetModuleForCLSID(target_clsid)
end
if mod !== nothing
target_class = getfield(mod, :target)
target_class = (hasfield(typeof(target_class), :default_interface) ? 
                getfield(target_class, :default_interface) : target_class)
return target_class(ob)
end
throw(ValueError)
end

mutable struct Constants <: AbstractConstants
#= A container for generated COM constants. =#
__dicts__::Vector
Constants(__dicts__ = []) = new(__dicts__ )
end
function __getattr__(self::AbstractConstants, a)
for d in self.__dicts__
if a ∈ d
return d[a + 1]
end
end
throw(AttributeError(a))
end

constants = Constants()
function _event_setattr_(self::AbstractVARIANT, attr, val)
try
__setattr__(self.__class__.__bases__[1], self, attr, val)
catch exn
if exn isa AttributeError
self.__dict__[attr] = val
end
end
end

mutable struct EventsProxy <: AbstractEventsProxy
_obj_
EventsProxy(ob, None = ob) = new(ob, None )
end
function __del__(self::AbstractEventsProxy)
try
close(self._obj_)
catch exn
if exn isa pythoncom.com_error
#= pass =#
end
end
end

function __getattr__(self::AbstractEventsProxy, attr)
return getfield(self._obj_, :attr)
end

function __setattr__(self::AbstractEventsProxy, attr, val)
setattr(self._obj_, attr, val)
end

function DispatchWithEvents(clsid::AbstractVARIANT, user_event_class)::EventsProxy
#= Create a COM object that can fire events to a user defined class.
    clsid -- The ProgID or CLSID of the object to create.
    user_event_class -- A Python class object that responds to the events.

    This requires makepy support for the COM object being created.  If
    this support does not exist it will be automatically generated by
    this function.  If the object does not support makepy, a TypeError
    exception will be raised.

    The result is a class instance that both represents the COM object
    and handles events from the COM object.

    It is important to note that the returned instance is not a direct
    instance of the user_event_class, but an instance of a temporary
    class object that derives from three classes:
    * The makepy generated class for the COM object
    * The makepy generated class for the COM events
    * The user_event_class as passed to this function.

    If this is not suitable, see the getevents function for an alternative
    technique of handling events.

    Object Lifetimes:  Whenever the object returned from this function is
    cleaned-up by Python, the events will be disconnected from
    the COM object.  This is almost always what should happen,
    but see the documentation for getevents() for more details.

    Example:

    >>> class IEEvents:
    ...    def OnVisible(self, visible):
    ...       print "Visible changed:", visible
    ...
    >>> ie = DispatchWithEvents("InternetExplorer.Application", IEEvents)
    >>> ie.Visible = 1
    Visible changed: 1
    >>>
     =#
disp = Dispatch(clsid)
if !get(disp.__class__.__dict__, "CLSID")
try
ti = GetTypeInfo(disp._oleobj_)
disp_clsid = GetTypeAttr(ti)[1]
tlb, index = GetContainingTypeLib(ti)
tla = GetLibAttr(tlb)
gencache.EnsureModule(tla[1], tla[2], tla[4], tla[5], bValidateFile = 0)
disp_class = gencache.GetClassForProgID(string(disp_clsid))
catch exn
if exn isa pythoncom.com_error
throw(TypeError("This COM object can not automate the makepy process - please run makepy manually for this object"))
end
end
else
disp_class = disp.__class__
end
clsid = disp_class.CLSID
try
catch exn
if exn isa ImportError
new_type = type_
end
end
events_class = getevents(clsid)
if events_class === nothing
throw(ValueError("This COM object does not support events."))
end
result_class = new_type("COMEventClass", (disp_class, events_class, user_event_class), Dict("__setattr__" => _event_setattr_))
instance = result_class(disp._oleobj_)
__init__(events_class, instance, instance)
if hasfield(typeof(user_event_class), :__init__)
__init__(user_event_class, instance)
end
return EventsProxy(instance)
end

function WithEvents(disp::AbstractVARIANT, user_event_class)
#= Similar to DispatchWithEvents - except that the returned
    object is *not* also usable as the original Dispatch object - that is
    the returned object is not dispatchable.

    The difference is best summarised by example.

    >>> class IEEvents:
    ...    def OnVisible(self, visible):
    ...       print "Visible changed:", visible
    ...
    >>> ie = Dispatch("InternetExplorer.Application")
    >>> ie_events = WithEvents(ie, IEEvents)
    >>> ie.Visible = 1
    Visible changed: 1

    Compare with the code sample for DispatchWithEvents, where you get a
    single object that is both the interface and the event handler.  Note that
    the event handler instance will *not* be able to use 'self.' to refer to
    IE's methods and properties.

    This is mainly useful where using DispatchWithEvents causes
    circular reference problems that the simple proxy doesn't deal with
     =#
disp = Dispatch(disp)
if !get(disp.__class__.__dict__, "CLSID")
try
ti = GetTypeInfo(disp._oleobj_)
disp_clsid = GetTypeAttr(ti)[1]
tlb, index = GetContainingTypeLib(ti)
tla = GetLibAttr(tlb)
gencache.EnsureModule(tla[1], tla[2], tla[4], tla[5], bValidateFile = 0)
disp_class = gencache.GetClassForProgID(string(disp_clsid))
catch exn
if exn isa pythoncom.com_error
throw(TypeError("This COM object can not automate the makepy process - please run makepy manually for this object"))
end
end
else
disp_class = disp.__class__
end
clsid = disp_class.CLSID
try
catch exn
if exn isa ImportError
new_type = type_
end
end
events_class = getevents(clsid)
if events_class === nothing
throw(ValueError("This COM object does not support events."))
end
result_class = new_type("COMEventClass", (events_class, user_event_class), Dict())
instance = result_class(disp)
if hasfield(typeof(user_event_class), :__init__)
__init__(user_event_class, instance)
end
return instance
end

function getevents(clsid::AbstractVARIANT)
#= Determine the default outgoing interface for a class, given
    either a clsid or progid. It returns a class - you can
    conveniently derive your own handler from this class and implement
    the appropriate methods.

    This method relies on the classes produced by makepy. You must use
    either makepy or the gencache module to ensure that the
    appropriate support classes have been generated for the com server
    that you will be handling events from.

    Beware of COM circular references.  When the Events class is connected
    to the COM object, the COM object itself keeps a reference to the Python
    events class.  Thus, neither the Events instance or the COM object will
    ever die by themselves.  The 'close' method on the events instance
    must be called to break this chain and allow standard Python collection
    rules to manage object lifetimes.  Note that DispatchWithEvents() does
    work around this problem by the use of a proxy object, but if you use
    the getevents() function yourself, you must make your own arrangements
    to manage this circular reference issue.

    Beware of creating Python circular references: this will happen if your
    handler has a reference to an object that has a reference back to
    the event source. Call the 'close' method to break the chain.

    Example:

    >>>win32com_.client.gencache.EnsureModule('{EAB22AC0-30C1-11CF-A7EB-0000C05BAE0B}',0,1,1)
    <module 'win32com_.gen_py.....
    >>>
    >>> class InternetExplorerEvents(win32com_.client.getevents("InternetExplorer.Application.1")):
    ...    def OnVisible(self, Visible):
    ...        print "Visibility changed: ", Visible
    ...
    >>>
    >>> ie=win32com_.client.Dispatch("InternetExplorer.Application.1")
    >>> events=InternetExplorerEvents(ie)
    >>> ie.Visible=1
    Visibility changed:  1
    >>>
     =#
clsid = string(pywintypes.IID(clsid))
klass = gencache.GetClassForCLSID(clsid)
try
return klass.default_source
catch exn
if exn isa AttributeError
try
return gencache.GetClassForCLSID(klass.coclass_clsid).default_source
catch exn
if exn isa AttributeError
return nothing
end
end
end
end
end

function Record(name::AbstractVARIANT, object)
#= Creates a new record object, given the name of the record,
    and an object from the same type library.

    Example usage would be:
      app = win32com_.client.Dispatch("Some.Application")
      point = win32com_.client.Record("SomeAppPoint", app)
      point.x = 0
      point.y = 0
      app.MoveTo(point)
     =#
object = gencache.EnsureDispatch(object)
module_ = sys.modules[object.__class__.__module__ + 1]
package = gencache.GetModuleForTypelib(module_.CLSID, module_.LCID, module_.MajorVersion, module_.MinorVersion)
try
struct_guid = package.RecordMap[name + 1]
catch exn
if exn isa KeyError
throw(ValueError("$(name)$(package)'"))
end
end
return pythoncom.GetRecordFromGuids(module_.CLSID, module_.MajorVersion, module_.MinorVersion, module_.LCID, struct_guid)
end

mutable struct DispatchBaseClass <: AbstractDispatchBaseClass
__class__
__dict__
_oleobj_
oobj

            DispatchBaseClass(oobj = nothing, None = oobj) = begin
                if oobj === nothing
oobj = pythoncom.new(CLSID)
elseif isa(oobj, DispatchBaseClass)
try
oobj = oobj._oleobj_.QueryInterface(CLSID, pythoncom.IID_IDispatch)
catch exn
 let details = exn
if details isa pythoncom.com_error
if details.hresult != winerror.E_NOINTERFACE
error()
end
oobj = oobj._oleobj_
end
end
end
end
                new(oobj , None )
            end
end
function __dir__(self::AbstractDispatchBaseClass)::Vector
lst = append!(append!((collect(keys(self.__dict__)) + dir(self.__class__)), collect(keys(self._prop_map_get_))), collect(keys(self._prop_map_put_)))
try
lst = lst + [p.Name for p in self.Properties_]
catch exn
if exn isa AttributeError
#= pass =#
end
end
return collect(set(lst))
end

function __repr__(self::AbstractDispatchBaseClass)
try
mod_doc = sys.modules[self.__class__.__module__ + 1].__doc__
if mod_doc
mod_name = "win32com_.gen_py." + mod_doc
else
mod_name = sys.modules[self.__class__.__module__ + 1].__name__
end
catch exn
if exn isa KeyError
mod_name = "win32com_.gen_py.unknown"
end
end
return "$(mod_name)$(self.__class__.__name__)$(id(self))>"
end

function __eq__(self::AbstractDispatchBaseClass, other)::Bool
other = (hasfield(typeof(other), :_oleobj_) ? 
                getfield(other, :_oleobj_) : other)
return self._oleobj_ == other
end

function __ne__(self::AbstractDispatchBaseClass, other)::Bool
other = (hasfield(typeof(other), :_oleobj_) ? 
                getfield(other, :_oleobj_) : other)
return self._oleobj_ != other
end

function _ApplyTypes_(self::AbstractDispatchBaseClass, dispid, wFlags, retType, argTypes, user, resultCLSID)
return _get_good_object_(self, InvokeTypes(self._oleobj_, dispid, 0, wFlags, retType, argTypes, args...), user, resultCLSID)
end

function __getattr__(self::AbstractDispatchBaseClass, attr)
args = get(self._prop_map_get_, attr)
if args === nothing
throw(AttributeError("$(repr(self))$(attr)'"))
end
return _ApplyTypes_(self, args...)
end

function __setattr__(self::AbstractDispatchBaseClass, attr, value)
if attr ∈ self.__dict__
self.__dict__[attr] = value
return
end
try
args, defArgs = self._prop_map_put_[attr + 1]
catch exn
if exn isa KeyError
throw(AttributeError("$(repr(self))$(attr)'"))
end
end
Invoke(self._oleobj_, (args + (value,)) + defArgs...)
end

function _get_good_single_object_(self::AbstractDispatchBaseClass, obj, obUserName = nothing, resultCLSID = nothing)
return _get_good_single_object_(obj, obUserName, resultCLSID)
end

function _get_good_object_(self::AbstractDispatchBaseClass, obj, obUserName = nothing, resultCLSID = nothing)
return _get_good_object_(obj, obUserName, resultCLSID)
end

function _get_good_single_object_(obj::AbstractVARIANT, obUserName = nothing, resultCLSID = nothing)
if _PyIDispatchType == type_(obj)
return Dispatch(obj, obUserName, resultCLSID)
end
return obj
end

function _get_good_object_(obj::AbstractVARIANT, obUserName = nothing, resultCLSID = nothing)::Tuple
if obj === nothing
return nothing
elseif isa(obj, tuple)
obUserNameTuple = repeat([(obUserName,)...],length(obj))
resultCLSIDTuple = repeat([(resultCLSID,)...],length(obj))
return tuple(map(_get_good_object_, obj, obUserNameTuple, resultCLSIDTuple))
else
return _get_good_single_object_(obj, obUserName, resultCLSID)
end
end

mutable struct CoClassBaseClass <: AbstractCoClassBaseClass
__class__
__dict__
oobj

            CoClassBaseClass(oobj = nothing, dispobj = default_interface(oobj)) = begin
                if oobj === nothing
oobj = pythoncom.new(CLSID)
end
for maybe in ["__call__", "__str__", "__int__", "__iter__", "__len__", "__nonzero__"]
if hasfield(typeof(dispobj), :maybe)
setattr(self, maybe, getfield(self, :"__maybe" * maybe))
end
end
                new(oobj , dispobj )
            end
end
function __repr__(self::AbstractCoClassBaseClass)
return "$(__doc__)$(self.__class__.__name__)>"
end

function __getattr__(self::AbstractCoClassBaseClass, attr)
d = self.__dict__["_dispobj_"]
if d !== nothing
return getfield(d, :attr)
end
throw(AttributeError(attr))
end

function __setattr__(self::AbstractCoClassBaseClass, attr, value)
if attr ∈ self.__dict__
self.__dict__[attr] = value
return
end
try
d = self.__dict__["_dispobj_"]
if d !== nothing
__setattr__(d, attr, value)
return
end
catch exn
if exn isa AttributeError
#= pass =#
end
end
self.__dict__[attr] = value
end

function __maybe__call__(self::AbstractCoClassBaseClass)
return __call__(self.__dict__["_dispobj_"], args..., None = kwargs)
end

function __maybe__str__(self::AbstractCoClassBaseClass)
return __str__(self.__dict__["_dispobj_"], args...)
end

function __maybe__int__(self::AbstractCoClassBaseClass)
return __int__(self.__dict__["_dispobj_"], args...)
end

function __maybe__iter__(self::AbstractCoClassBaseClass)
return __iter__(self.__dict__["_dispobj_"])
end

function __maybe__len__(self::AbstractCoClassBaseClass)
return __len__(self.__dict__["_dispobj_"])
end

function __maybe__nonzero__(self::AbstractCoClassBaseClass)
return __nonzero__(self.__dict__["_dispobj_"])
end

mutable struct VARIANT <: AbstractVARIANT
_value
varianttype
value
VARIANT(vt, value, varianttype = vt, _value = value) = new(vt, value, varianttype , _value )
end
function _get_value(self::AbstractVARIANT)
return self._value
end

function _set_value(self::AbstractVARIANT, newval)
self._value = _get_good_object_(newval)
end

function _del_value(self::AbstractVARIANT)
#Delete Unsupported
del(self._value)
end

function __repr__(self::AbstractVARIANT)
return "$(self.varianttype)$(self._value))"
end
