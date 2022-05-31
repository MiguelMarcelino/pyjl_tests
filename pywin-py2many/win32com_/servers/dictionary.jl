#= Python.Dictionary COM Server.

This module implements a simple COM server that acts much like a Python
dictionary or as a standard string-keyed VB Collection.  The keys of
the dictionary are strings and are case-insensitive.

It uses a highly customized policy to fine-tune the behavior exposed to
the COM client.

The object exposes the following properties:

    int Count                       (readonly)
    VARIANT Item(BSTR key)          (propget for Item)
    Item(BSTR key, VARIANT value)   (propput for Item)

    Note that 'Item' is the default property, so the following forms of
    VB code are acceptable:

        set ob = CreateObject("Python.Dictionary")
        ob("hello") = "there"
        ob.Item("hi") = ob("HELLO")

All keys are defined, returning VT_NULL (None) if a value has not been
stored.  To delete a key, simply assign VT_NULL to the key.

The object responds to the _NewEnum method by returning an enumerator over
the dictionary's keys. This allows for the following type of VB code:

    for each name in ob
        debug.print name, ob(name)
    next
 =#
using PyCall
pywintypes = pyimport("pywintypes")
using win32com_.server.register: UseCommandLine
using ext_modules: pythoncom
using win32com_.server: util, policy
using win32com_.server.exception: COMException
import winerror


using pythoncom: DISPATCH_METHOD, DISPATCH_PROPERTYGET
using winerror: S_OK
abstract type AbstractDictionaryPolicy <: policy.BasicWrapPolicy end
mutable struct DictionaryPolicy <: AbstractDictionaryPolicy
_obj_
_com_interfaces_::Vector
_name_to_dispid_::Dict{String, Any}
_reg_clsid_::String
_reg_desc_::String
_reg_policy_spec_::String
_reg_progid_::String
_reg_verprogid_::String

                    DictionaryPolicy(_obj_, _com_interfaces_::Vector = [], _name_to_dispid_::Dict{String, Any} = Dict("item" => pythoncom.DISPID_VALUE, "_newenum" => pythoncom.DISPID_NEWENUM, "count" => 1), _reg_clsid_::String = "{39b61048-c755-11d0-86fa-00c04fc2e03e}", _reg_desc_::String = "Python Dictionary", _reg_policy_spec_::String = "win32com_.servers.dictionary.DictionaryPolicy", _reg_progid_::String = "Python.Dictionary", _reg_verprogid_::String = "Python.Dictionary.1") =
                        new(_obj_, _com_interfaces_, _name_to_dispid_, _reg_clsid_, _reg_desc_, _reg_policy_spec_, _reg_progid_, _reg_verprogid_)
end
function _CreateInstance_(self::AbstractDictionaryPolicy, clsid, reqIID)
_wrap_(self, Dict())
return pythoncom.WrapObject(self, reqIID)
end

function _wrap_(self::AbstractDictionaryPolicy, ob)
self._obj_ = ob
end

function _invokeex_(self::AbstractDictionaryPolicy, dispid, lcid, wFlags, args, kwargs, serviceProvider)::Int64
if dispid == 0
l = length(args)
if l < 1
throw(COMException(desc = "not enough parameters", scode = winerror.DISP_E_BADPARAMCOUNT))
end
key = args[1]
if type_(key) ∉ [str, str]
throw(COMException(desc = "Key must be a string", scode = winerror.DISP_E_TYPEMISMATCH))
end
key = lower(key)
if wFlags & __or__(DISPATCH_METHOD, DISPATCH_PROPERTYGET)
if l > 1
throw(COMException(scode = winerror.DISP_E_BADPARAMCOUNT))
end
try
return self._obj_[key + 1]
catch exn
if exn isa KeyError
return nothing
end
end
end
if l != 2
throw(COMException(scode = winerror.DISP_E_BADPARAMCOUNT))
end
if args[2] === nothing
try
#Delete Unsupported
del(self._obj_)
catch exn
if exn isa KeyError
#= pass =#
end
end
else
self._obj_[key + 1] = args[2]
end
return S_OK
end
if dispid == 1
if !(__and__(wFlags, DISPATCH_PROPERTYGET))
throw(COMException(scode = winerror.DISP_E_MEMBERNOTFOUND))
end
if length(args) != 0
throw(COMException(scode = winerror.DISP_E_BADPARAMCOUNT))
end
return length(self._obj_)
end
if dispid == pythoncom.DISPID_NEWENUM
return util.NewEnum(collect(keys(self._obj_)))
end
throw(COMException(scode = winerror.DISP_E_MEMBERNOTFOUND))
end

function _getidsofnames_(self::AbstractDictionaryPolicy, names, lcid)
name = lower(names[1])
try
return (self._name_to_dispid_[name + 1],)
catch exn
if exn isa KeyError
throw(COMException(scode = winerror.DISP_E_MEMBERNOTFOUND, desc = "Member not found"))
end
end
end

function Register()
return UseCommandLine(DictionaryPolicy)
end

if abspath(PROGRAM_FILE) == @__FILE__
Register()
end