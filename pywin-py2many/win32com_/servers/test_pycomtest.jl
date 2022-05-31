import win32com_.server.register
using win32com_: universal
using win32com_.server.exception: COMException
using win32com_.client: gencache
import winerror
using win32com_.client: constants
using win32com_.server.util: wrap
using ext_modules: pythoncom
abstract type AbstractPyCOMTest end
abstract type AbstractPyCOMTestMI <: AbstractPyCOMTest end
pythoncom.__future_currency__ = true
gencache.EnsureModule("{6BCDCB60-5605-11D0-AE5F-CADD4C000000}", 0, 1, 1)
mutable struct PyCOMTest <: AbstractPyCOMTest
intval
longval
ulongval
_com_interfaces_::Vector{String}
_reg_clsid_::String
_reg_progid_::String
_typelib_guid_::String
_typelib_version::Tuple{Int64}

                    PyCOMTest(intval, longval, ulongval, _com_interfaces_::Vector{String} = ["IPyCOMTest"], _reg_clsid_::String = "{e743d9cd-cb03-4b04-b516-11d3a81c1597}", _reg_progid_::String = "Python.Test.PyCOMTest", _typelib_guid_::String = "{6BCDCB60-5605-11D0-AE5F-CADD4C000000}", _typelib_version::Tuple{Int64} = (1, 0)) =
                        new(intval, longval, ulongval, _com_interfaces_, _reg_clsid_, _reg_progid_, _typelib_guid_, _typelib_version)
end
function DoubleString(self::AbstractPyCOMTest, str)::Int64
return str*2
end

function DoubleInOutString(self::AbstractPyCOMTest, str)::Int64
return str*2
end

function Fire(self::AbstractPyCOMTest, nID)
throw(COMException(hresult = winerror.E_NOTIMPL))
end

function GetLastVarArgs(self::AbstractPyCOMTest)
throw(COMException(hresult = winerror.E_NOTIMPL))
end

function GetMultipleInterfaces(self::AbstractPyCOMTest, outinterface1, outinterface2)
throw(COMException(hresult = winerror.E_NOTIMPL))
end

function GetSafeArrays(self::AbstractPyCOMTest, attrs, attrs2, ints)
throw(COMException(hresult = winerror.E_NOTIMPL))
end

function GetSetDispatch(self::AbstractPyCOMTest, indisp)
throw(COMException(hresult = winerror.E_NOTIMPL))
end

function GetSetInterface(self::AbstractPyCOMTest, ininterface)
return wrap(self)
end

function GetSetVariant(self::AbstractPyCOMTest, indisp)
return indisp
end

function TestByRefVariant(self::AbstractPyCOMTest, v)::Int64
return v*2
end

function TestByRefString(self::AbstractPyCOMTest, v)::Int64
return v*2
end

function GetSetInterfaceArray(self::AbstractPyCOMTest, ininterface)
throw(COMException(hresult = winerror.E_NOTIMPL))
end

function GetSetUnknown(self::AbstractPyCOMTest, inunk)
throw(COMException(hresult = winerror.E_NOTIMPL))
end

function GetSimpleCounter(self::AbstractPyCOMTest)
throw(COMException(hresult = winerror.E_NOTIMPL))
end

function GetSimpleSafeArray(self::AbstractPyCOMTest, ints)
throw(COMException(hresult = winerror.E_NOTIMPL))
end

function GetStruct(self::AbstractPyCOMTest)
throw(COMException(hresult = winerror.E_NOTIMPL))
end

function SetIntSafeArray(self::AbstractPyCOMTest, ints)::Int64
return length(ints)
end

function SetLongLongSafeArray(self::AbstractPyCOMTest, ints)::Int64
return length(ints)
end

function SetULongLongSafeArray(self::AbstractPyCOMTest, ints)::Int64
return length(ints)
end

function SetBinSafeArray(self::AbstractPyCOMTest, buf)::Int64
return length(buf)
end

function SetVarArgs(self::AbstractPyCOMTest)
throw(COMException(hresult = winerror.E_NOTIMPL))
end

function SetVariantSafeArray(self::AbstractPyCOMTest, vars)
throw(COMException(hresult = winerror.E_NOTIMPL))
end

function Start(self::AbstractPyCOMTest)
throw(COMException(hresult = winerror.E_NOTIMPL))
end

function Stop(self::AbstractPyCOMTest, nID)
throw(COMException(hresult = winerror.E_NOTIMPL))
end

function StopAll(self::AbstractPyCOMTest)
throw(COMException(hresult = winerror.E_NOTIMPL))
end

function TakeByRefDispatch(self::AbstractPyCOMTest, inout)
throw(COMException(hresult = winerror.E_NOTIMPL))
end

function TakeByRefTypedDispatch(self::AbstractPyCOMTest, inout)
throw(COMException(hresult = winerror.E_NOTIMPL))
end

function Test(self::AbstractPyCOMTest, key, inval)
return !(inval)
end

function Test2(self::AbstractPyCOMTest, inval)
return inval
end

function Test3(self::AbstractPyCOMTest, inval)
throw(COMException(hresult = winerror.E_NOTIMPL))
end

function Test4(self::AbstractPyCOMTest, inval)
throw(COMException(hresult = winerror.E_NOTIMPL))
end

function Test5(self::AbstractPyCOMTest, inout)::Int64
if inout == constants.TestAttr1
return constants.TestAttr1_1
elseif inout == constants.TestAttr1_1
return constants.TestAttr1
else
return -1
end
end

function Test6(self::AbstractPyCOMTest, inval)
return inval
end

function TestInOut(self::AbstractPyCOMTest, fval, bval, lval)
return (winerror.S_OK, fval*2, !(bval), lval*2)
end

function TestOptionals(self::AbstractPyCOMTest, strArg = "def", sval = 0, lval = 1, dval = 3.140000104904175)
throw(COMException(hresult = winerror.E_NOTIMPL))
end

function TestOptionals2(self::AbstractPyCOMTest, dval, strval = "", sval = 1)
throw(COMException(hresult = winerror.E_NOTIMPL))
end

function CheckVariantSafeArray(self::AbstractPyCOMTest, data)::Int64
return 1
end

function LongProp(self::AbstractPyCOMTest)
return self.longval
end

function SetLongProp(self::AbstractPyCOMTest, val)
self.longval = val
end

function ULongProp(self::AbstractPyCOMTest)
return self.ulongval
end

function SetULongProp(self::AbstractPyCOMTest, val)
self.ulongval = val
end

function IntProp(self::AbstractPyCOMTest)
return self.intval
end

function SetIntProp(self::AbstractPyCOMTest, val)
self.intval = val
end

mutable struct PyCOMTestMI <: AbstractPyCOMTestMI
_com_interfaces_::Vector{String}
_reg_clsid_::String
_reg_progid_::String
_typelib_guid_::String
_typelib_version::Tuple{Int64}

                    PyCOMTestMI(_com_interfaces_::Vector{String} = ["IPyCOMTest", pythoncom.IID_IStream, string(pythoncom.IID_IStorage)], _reg_clsid_::String = "{F506E9A1-FB46-4238-A597-FA4EB69787CA}", _reg_progid_::String = "Python.Test.PyCOMTestMI", _typelib_guid_::String = "{6BCDCB60-5605-11D0-AE5F-CADD4C000000}", _typelib_version::Tuple{Int64} = (1, 0)) =
                        new(_com_interfaces_, _reg_clsid_, _reg_progid_, _typelib_guid_, _typelib_version)
end

if abspath(PROGRAM_FILE) == @__FILE__
win32com_.server.register.UseCommandLine(PyCOMTest)
win32com_.server.register.UseCommandLine(PyCOMTestMI)
end