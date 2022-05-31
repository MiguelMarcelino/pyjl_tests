#= Utilities for makegw - Parse a header file to build an interface

 This module contains the core code for parsing a header file describing a
 COM interface, and building it into an "Interface" structure.

 Each Interface has methods, and each method has arguments.

 Each argument knows how to use Py_BuildValue or Py_ParseTuple to
 exchange itself with Python.
 
 See the @win32com_.makegw@ module for information in building a COM
 interface
 =#
using OrderedCollections


abstract type Abstracterror_not_found <: Exception end
abstract type Abstracterror_not_supported <: Exception end
abstract type AbstractArgFormatter end
abstract type AbstractArgFormatterFloat <: AbstractArgFormatter end
abstract type AbstractArgFormatterShort <: AbstractArgFormatter end
abstract type AbstractArgFormatterLONG_PTR <: AbstractArgFormatter end
abstract type AbstractArgFormatterPythonCOM <: AbstractArgFormatter end
abstract type AbstractArgFormatterBSTR <: AbstractArgFormatterPythonCOM end
abstract type AbstractArgFormatterOLECHAR <: AbstractArgFormatterPythonCOM end
abstract type AbstractArgFormatterTCHAR <: AbstractArgFormatterPythonCOM end
abstract type AbstractArgFormatterIID <: AbstractArgFormatterPythonCOM end
abstract type AbstractArgFormatterTime <: AbstractArgFormatterPythonCOM end
abstract type AbstractArgFormatterSTATSTG <: AbstractArgFormatterPythonCOM end
abstract type AbstractArgFormatterGeneric <: AbstractArgFormatterPythonCOM end
abstract type AbstractArgFormatterIDLIST <: AbstractArgFormatterPythonCOM end
abstract type AbstractArgFormatterHANDLE <: AbstractArgFormatterPythonCOM end
abstract type AbstractArgFormatterLARGE_INTEGER <: AbstractArgFormatterPythonCOM end
abstract type AbstractArgFormatterULARGE_INTEGER <: AbstractArgFormatterLARGE_INTEGER end
abstract type AbstractArgFormatterInterface <: AbstractArgFormatterPythonCOM end
abstract type AbstractArgFormatterVARIANT <: AbstractArgFormatterPythonCOM end
abstract type AbstractArgFormatterSimple <: AbstractArgFormatter end
abstract type AbstractArgument end
abstract type AbstractMethod end
abstract type AbstractInterface end
mutable struct error_not_found <: Abstracterror_not_found
msg::String

            error_not_found(msg = "The requested item could not be found") = begin
                super(error_not_found, self).__init__(msg)
                new(msg )
            end
end

mutable struct error_not_supported <: Abstracterror_not_supported
msg::String

            error_not_supported(msg = "The required functionality is not supported") = begin
                super(error_not_supported, self).__init__(msg)
                new(msg )
            end
end

VERBOSE = 0
DEBUG = 0
mutable struct ArgFormatter <: AbstractArgFormatter
#= An instance for a specific type of argument.\t Knows how to convert itself =#
arg
builtinIndirection
declaredIndirection
gatewayMode::Int64
ArgFormatter(arg = arg, builtinIndirection = builtinIndirection, declaredIndirection = declaredIndirection, gatewayMode = 0) = new(arg , builtinIndirection , declaredIndirection , gatewayMode )
end
function _IndirectPrefix(self::AbstractArgFormatter, indirectionFrom, indirectionTo)::String
#= Given the indirection level I was declared at (0=Normal, 1=*, 2=**)
        return a string prefix so I can pass to a function with the
        required indirection (where the default is the indirection of the method's param.

        eg, assuming my arg has indirection level of 2, if this function was passed 1
        it would return "&", so that a variable declared with indirection of 1
        can be prefixed with this to turn it into the indirection level required of 2
         =#
dif = indirectionFrom - indirectionTo
if dif == 0
return ""
elseif dif == -1
return "&"
elseif dif == 1
return "*"
else
return "$(dif))"
throw(error_not_supported("Can\'t indirect this far - please fix me :-)"))
end
end

function GetIndirectedArgName(self::AbstractArgFormatter, indirectFrom, indirectionTo)::String
if indirectFrom === nothing
indirectFrom = _GetDeclaredIndirection(self) + self.builtinIndirection
end
return _IndirectPrefix(self, indirectFrom, indirectionTo) + self.arg.name
end

function GetBuildValueArg(self::AbstractArgFormatter)
#= Get the argument to be passes to Py_BuildValue =#
return self.arg.name
end

function GetParseTupleArg(self::AbstractArgFormatter)::String
#= Get the argument to be passed to PyArg_ParseTuple =#
if self.gatewayMode != 0
return GetIndirectedArgName(self, nothing, 1)
end
return GetIndirectedArgName(self, self.builtinIndirection, 1)
end

function GetInterfaceCppObjectInfo(self::AbstractArgFormatter)
#= Provide information about the C++ object used.

        Simple variables (such as integers) can declare their type (eg an integer)
        and use it as the target of both PyArg_ParseTuple and the COM function itself.

        More complex types require a PyObject * declared as the target of PyArg_ParseTuple,
        then some conversion routine to the C++ object which is actually passed to COM.

        This method provides the name, and optionally the type of that C++ variable.
        If the type if provided, the caller will likely generate a variable declaration.
        The name must always be returned.

        Result is a tuple of (variableName, [DeclareType|None|""])
         =#
return (GetIndirectedArgName(self, self.builtinIndirection, self.arg.indirectionLevel + self.builtinIndirection), "$(GetUnconstType(self))$(self.arg.name)")
end

function GetInterfaceArgCleanup(self::AbstractArgFormatter)::String
#= Return cleanup code for C++ args passed to the interface method. =#
if DEBUG != 0
return "/* GetInterfaceArgCleanup output goes here:  */
"
else
return ""
end
end

function GetInterfaceArgCleanupGIL(self::AbstractArgFormatter)::String
#= Return cleanup code for C++ args passed to the interface
        method that must be executed with the GIL held =#
if DEBUG != 0
return "/* GetInterfaceArgCleanup (GIL held) output goes here:  */
"
else
return ""
end
end

function GetUnconstType(self::AbstractArgFormatter)
return self.arg.unc_type
end

function SetGatewayMode(self::AbstractArgFormatter)
self.gatewayMode = 1
end

function _GetDeclaredIndirection(self::AbstractArgFormatter)
return self.arg.indirectionLevel
println("declared:$(self.arg.name)$(self.gatewayMode)")
if self.gatewayMode != 0
return self.arg.indirectionLevel
else
return self.declaredIndirection
end
end

function DeclareParseArgTupleInputConverter(self::AbstractArgFormatter)::String
#= Declare the variable used as the PyArg_ParseTuple param for a gateway =#
if DEBUG != 0
return "/* Declare ParseArgTupleInputConverter goes here:  */
"
else
return ""
end
end

function GetParsePostCode(self::AbstractArgFormatter)::String
#= Get a string of C++ code to be executed after (ie, to finalise) the PyArg_ParseTuple conversion =#
if DEBUG != 0
return "/* GetParsePostCode code goes here:  */
"
else
return ""
end
end

function GetBuildForInterfacePreCode(self::AbstractArgFormatter)::String
#= Get a string of C++ code to be executed before (ie, to initialise) the Py_BuildValue conversion for Interfaces =#
if DEBUG != 0
return "/* GetBuildForInterfacePreCode goes here:  */
"
else
return ""
end
end

function GetBuildForGatewayPreCode(self::AbstractArgFormatter)::String
#= Get a string of C++ code to be executed before (ie, to initialise) the Py_BuildValue conversion for Gateways =#
s = GetBuildForInterfacePreCode(self)
if DEBUG != 0
if s[begin:4] == "/* G"
s = "/* GetBuildForGatewayPreCode goes here:  */
"
end
end
return s
end

function GetBuildForInterfacePostCode(self::AbstractArgFormatter)::String
#= Get a string of C++ code to be executed after (ie, to finalise) the Py_BuildValue conversion for Interfaces =#
if DEBUG != 0
return "/* GetBuildForInterfacePostCode goes here:  */
"
end
return ""
end

function GetBuildForGatewayPostCode(self::AbstractArgFormatter)::String
#= Get a string of C++ code to be executed after (ie, to finalise) the Py_BuildValue conversion for Gateways =#
s = GetBuildForInterfacePostCode(self)
if DEBUG != 0
if s[begin:4] == "/* G"
s = "/* GetBuildForGatewayPostCode goes here:  */
"
end
end
return s
end

function GetAutoduckString(self::AbstractArgFormatter)
return "$(_GetPythonTypeDesc(self))$(self.arg.name)$(self.arg.name)"
end

function _GetPythonTypeDesc(self::AbstractArgFormatter)
#= Returns a string with the description of the type.\t Used for doco purposes =#
return nothing
end

function NeedUSES_CONVERSION(self::AbstractArgFormatter)::Int64
#= Determines if this arg forces a USES_CONVERSION macro =#
return 0
end

mutable struct ArgFormatterFloat <: AbstractArgFormatterFloat
arg
gatewayMode
end
function GetFormatChar(self::AbstractArgFormatterFloat)::String
return "f"
end

function DeclareParseArgTupleInputConverter(self::AbstractArgFormatterFloat)::String
return "	double dbl;
"
end

function GetParseTupleArg(self::AbstractArgFormatterFloat)::String
return "&dbl" + self.arg.name
end

function _GetPythonTypeDesc(self::AbstractArgFormatterFloat)::String
return "float"
end

function GetBuildValueArg(self::AbstractArgFormatterFloat)::String
return "&dbl" + self.arg.name
end

function GetBuildForInterfacePreCode(self::AbstractArgFormatterFloat)::String
return (("\tdbl" + self.arg.name) * " = " + self.arg.name) * ";\n"
end

function GetBuildForGatewayPreCode(self::AbstractArgFormatterFloat)::String
return (("	dbl = " + _IndirectPrefix(self, _GetDeclaredIndirection(self), 0)) + self.arg.name) * ";\n"
end

function GetParsePostCode(self::AbstractArgFormatterFloat)::String
s = "\t"
if self.gatewayMode
s = s + _IndirectPrefix(self, _GetDeclaredIndirection(self), 0)
end
s = s + self.arg.name
s = s * " = (float)dbl;
"
return s
end

mutable struct ArgFormatterShort <: AbstractArgFormatterShort
arg
gatewayMode
end
function GetFormatChar(self::AbstractArgFormatterShort)::String
return "i"
end

function DeclareParseArgTupleInputConverter(self::AbstractArgFormatterShort)::String
return "	INT i;
"
end

function GetParseTupleArg(self::AbstractArgFormatterShort)::String
return "&i" + self.arg.name
end

function _GetPythonTypeDesc(self::AbstractArgFormatterShort)::String
return "int"
end

function GetBuildValueArg(self::AbstractArgFormatterShort)::String
return "&i" + self.arg.name
end

function GetBuildForInterfacePreCode(self::AbstractArgFormatterShort)::String
return (("\ti" + self.arg.name) * " = " + self.arg.name) * ";\n"
end

function GetBuildForGatewayPreCode(self::AbstractArgFormatterShort)::String
return (("	i = " + _IndirectPrefix(self, _GetDeclaredIndirection(self), 0)) + self.arg.name) * ";\n"
end

function GetParsePostCode(self::AbstractArgFormatterShort)::String
s = "\t"
if self.gatewayMode
s = s + _IndirectPrefix(self, _GetDeclaredIndirection(self), 0)
end
s = s + self.arg.name
s = s * " = i;
"
return s
end

mutable struct ArgFormatterLONG_PTR <: AbstractArgFormatterLONG_PTR
arg
end
function GetFormatChar(self::AbstractArgFormatterLONG_PTR)::String
return "O"
end

function DeclareParseArgTupleInputConverter(self::AbstractArgFormatterLONG_PTR)::String
return "	PyObject *ob;
"
end

function GetParseTupleArg(self::AbstractArgFormatterLONG_PTR)::String
return "&ob" + self.arg.name
end

function _GetPythonTypeDesc(self::AbstractArgFormatterLONG_PTR)::String
return "int/long"
end

function GetBuildValueArg(self::AbstractArgFormatterLONG_PTR)::String
return "ob" + self.arg.name
end

function GetBuildForInterfacePostCode(self::AbstractArgFormatterLONG_PTR)::String
return "	Py_XDECREF(ob);
"
end

function DeclareParseArgTupleInputConverter(self::AbstractArgFormatterLONG_PTR)::String
return "	PyObject *ob;
"
end

function GetParsePostCode(self::AbstractArgFormatterLONG_PTR)
return "$(self.arg.name)$(GetIndirectedArgName(self, nothing, 2)))) bPythonIsHappy = FALSE;
"
end

function GetBuildForInterfacePreCode(self::AbstractArgFormatterLONG_PTR)
notdirected = GetIndirectedArgName(self, nothing, 1)
return "$(self.arg.name)$(notdirected));
"
end

function GetBuildForGatewayPostCode(self::AbstractArgFormatterLONG_PTR)::String
return "	Py_XDECREF(ob);
"
end

mutable struct ArgFormatterPythonCOM <: AbstractArgFormatterPythonCOM
#= An arg formatter for types exposed in the PythonCOM module =#
arg
end
function GetFormatChar(self::AbstractArgFormatterPythonCOM)::String
return "O"
end

function DeclareParseArgTupleInputConverter(self::AbstractArgFormatterPythonCOM)::String
return "	PyObject *ob;
"
end

function GetParseTupleArg(self::AbstractArgFormatterPythonCOM)::String
return "&ob" + self.arg.name
end

function _GetPythonTypeDesc(self::AbstractArgFormatterPythonCOM)::String
return "<o Py>"
end

function GetBuildValueArg(self::AbstractArgFormatterPythonCOM)::String
return "ob" + self.arg.name
end

function GetBuildForInterfacePostCode(self::AbstractArgFormatterPythonCOM)::String
return "	Py_XDECREF(ob);
"
end

function DeclareParseArgTupleInputConverter(self::AbstractArgFormatterPythonCOM)::String
return "	PyObject *ob;
"
end

mutable struct ArgFormatterBSTR <: AbstractArgFormatterBSTR
arg
end
function _GetPythonTypeDesc(self::AbstractArgFormatterBSTR)::String
return "<o unicode>"
end

function GetParsePostCode(self::AbstractArgFormatterBSTR)
return "$(self.arg.name)$(GetIndirectedArgName(self, nothing, 2)))) bPythonIsHappy = FALSE;
"
end

function GetBuildForInterfacePreCode(self::AbstractArgFormatterBSTR)
notdirected = GetIndirectedArgName(self, nothing, 1)
return "$(self.arg.name)$(notdirected));
"
end

function GetBuildForInterfacePostCode(self::AbstractArgFormatterBSTR)::Any
return "$(self.arg.name));
" + ArgFormatterPythonCOM.GetBuildForInterfacePostCode(self)
end

function GetBuildForGatewayPostCode(self::AbstractArgFormatterBSTR)::String
return "	Py_XDECREF(ob);
"
end

mutable struct ArgFormatterOLECHAR <: AbstractArgFormatterOLECHAR
arg
end
function _GetPythonTypeDesc(self::AbstractArgFormatterOLECHAR)::String
return "<o unicode>"
end

function GetUnconstType(self::AbstractArgFormatterOLECHAR)::Any
if self.arg.type[begin:3] == "LPC"
return self.arg.type[begin:2] + self.arg.type[4:end]
else
return self.arg.unc_type
end
end

function GetParsePostCode(self::AbstractArgFormatterOLECHAR)
return "$(self.arg.name)$(GetIndirectedArgName(self, nothing, 2)))) bPythonIsHappy = FALSE;
"
end

function GetInterfaceArgCleanup(self::AbstractArgFormatterOLECHAR)::String
return "	SysFreeString();
"
end

function GetBuildForInterfacePreCode(self::AbstractArgFormatterOLECHAR)
notdirected = GetIndirectedArgName(self, self.builtinIndirection, 1)
return "$(self.arg.name)$(notdirected));
"
end

function GetBuildForInterfacePostCode(self::AbstractArgFormatterOLECHAR)::Any
return "$(self.arg.name));
" + ArgFormatterPythonCOM.GetBuildForInterfacePostCode(self)
end

function GetBuildForGatewayPostCode(self::AbstractArgFormatterOLECHAR)::String
return "	Py_XDECREF(ob);
"
end

mutable struct ArgFormatterTCHAR <: AbstractArgFormatterTCHAR
arg
end
function _GetPythonTypeDesc(self::AbstractArgFormatterTCHAR)::String
return "string/<o unicode>"
end

function GetUnconstType(self::AbstractArgFormatterTCHAR)::Any
if self.arg.type[begin:3] == "LPC"
return self.arg.type[begin:2] + self.arg.type[4:end]
else
return self.arg.unc_type
end
end

function GetParsePostCode(self::AbstractArgFormatterTCHAR)
return "$(self.arg.name)$(GetIndirectedArgName(self, nothing, 2)))) bPythonIsHappy = FALSE;
"
end

function GetInterfaceArgCleanup(self::AbstractArgFormatterTCHAR)::String
return "	PyWinObject_FreeTCHAR();
"
end

function GetBuildForInterfacePreCode(self::AbstractArgFormatterTCHAR)
notdirected = GetIndirectedArgName(self, self.builtinIndirection, 1)
return "$(self.arg.name)$(notdirected));
"
end

function GetBuildForInterfacePostCode(self::AbstractArgFormatterTCHAR)::String
return "// ??? - TCHAR post code\n"
end

function GetBuildForGatewayPostCode(self::AbstractArgFormatterTCHAR)::String
return "	Py_XDECREF(ob);
"
end

mutable struct ArgFormatterIID <: AbstractArgFormatterIID
arg
end
function _GetPythonTypeDesc(self::AbstractArgFormatterIID)::String
return "<o PyIID>"
end

function GetParsePostCode(self::AbstractArgFormatterIID)
return "$(self.arg.name)$(self.arg.name))) bPythonIsHappy = FALSE;
"
end

function GetBuildForInterfacePreCode(self::AbstractArgFormatterIID)
notdirected = GetIndirectedArgName(self, nothing, 0)
return "$(self.arg.name)$(notdirected));
"
end

function GetInterfaceCppObjectInfo(self::AbstractArgFormatterIID)
return (self.arg.name, "IID ")
end

mutable struct ArgFormatterTime <: AbstractArgFormatterTime
arg
builtinIndirection
declaredIndirection::Int64

            ArgFormatterTime(arg, builtinIndirection, declaredIndirection = 0) = begin
                if arg.indirectionLevel == 0 && arg.unc_type[begin:2] == "LP"
arg.unc_type = arg.unc_type[2:end]
arg.indirectionLevel = arg.indirectionLevel + 1
builtinIndirection = 0
end
ArgFormatterPythonCOM(arg, builtinIndirection, declaredIndirection)
                new(arg, builtinIndirection, declaredIndirection )
            end
end
function _GetPythonTypeDesc(self::AbstractArgFormatterTime)::String
return "<o PyDateTime>"
end

function GetParsePostCode(self::AbstractArgFormatterTime)
return "$(self.arg.name)$(self.arg.name)$(GetIndirectedArgName(self, self.builtinIndirection, 1)))) bPythonIsHappy = FALSE;
"
end

function GetBuildForInterfacePreCode(self::AbstractArgFormatterTime)
notdirected = GetIndirectedArgName(self, self.builtinIndirection, 0)
return "$(self.arg.name)$(notdirected));
"
end

function GetBuildForInterfacePostCode(self::AbstractArgFormatterTime)::String
ret = ""
if (self.builtinIndirection + self.arg.indirectionLevel) > 1
ret = "	CoTaskMemFree();
"
end
return ret + ArgFormatterPythonCOM.GetBuildForInterfacePostCode(self)
end

mutable struct ArgFormatterSTATSTG <: AbstractArgFormatterSTATSTG
arg
end
function _GetPythonTypeDesc(self::AbstractArgFormatterSTATSTG)::String
return "<o STATSTG>"
end

function GetParsePostCode(self::AbstractArgFormatterSTATSTG)
return "$(self.arg.name)$(GetIndirectedArgName(self, nothing, 1)), 0/*flags*/)) bPythonIsHappy = FALSE;
"
end

function GetBuildForInterfacePreCode(self::AbstractArgFormatterSTATSTG)
notdirected = GetIndirectedArgName(self, nothing, 1)
return "$(self.arg.name)$(GetIndirectedArgName(self, nothing, 1))$(notdirected)$(notdirected)).pwcsName);
"
end

mutable struct ArgFormatterGeneric <: AbstractArgFormatterGeneric
arg
end
function _GetPythonTypeDesc(self::AbstractArgFormatterGeneric)::String
return "<o >"
end

function GetParsePostCode(self::AbstractArgFormatterGeneric)
return "$(self.arg.type)$(self.arg.name)$(GetIndirectedArgName(self, nothing, 1))) bPythonIsHappy = FALSE;
"
end

function GetInterfaceArgCleanup(self::AbstractArgFormatterGeneric)
return "$(self.arg.type)$(self.arg.name));
"
end

function GetBuildForInterfacePreCode(self::AbstractArgFormatterGeneric)
notdirected = GetIndirectedArgName(self, nothing, 1)
return "$(self.arg.name)$(self.arg.type)$(GetIndirectedArgName(self, nothing, 1)));
"
end

mutable struct ArgFormatterIDLIST <: AbstractArgFormatterIDLIST
arg
end
function _GetPythonTypeDesc(self::AbstractArgFormatterIDLIST)::String
return "<o PyIDL>"
end

function GetParsePostCode(self::AbstractArgFormatterIDLIST)
return "$(self.arg.name)$(GetIndirectedArgName(self, nothing, 1)))) bPythonIsHappy = FALSE;
"
end

function GetInterfaceArgCleanup(self::AbstractArgFormatterIDLIST)
return "$(self.arg.name));
"
end

function GetBuildForInterfacePreCode(self::AbstractArgFormatterIDLIST)
notdirected = GetIndirectedArgName(self, nothing, 1)
return "$(self.arg.name)$(GetIndirectedArgName(self, nothing, 1)));
"
end

mutable struct ArgFormatterHANDLE <: AbstractArgFormatterHANDLE
arg
end
function _GetPythonTypeDesc(self::AbstractArgFormatterHANDLE)::String
return "<o PyHANDLE>"
end

function GetParsePostCode(self::AbstractArgFormatterHANDLE)
return "$(self.arg.name)$(GetIndirectedArgName(self, nothing, 1)), FALSE) bPythonIsHappy = FALSE;
"
end

function GetBuildForInterfacePreCode(self::AbstractArgFormatterHANDLE)
notdirected = GetIndirectedArgName(self, nothing, 1)
return "$(self.arg.name)$(GetIndirectedArgName(self, nothing, 0)));
"
end

mutable struct ArgFormatterLARGE_INTEGER <: AbstractArgFormatterLARGE_INTEGER
arg
end
function GetKeyName(self::AbstractArgFormatterLARGE_INTEGER)::String
return "LARGE_INTEGER"
end

function _GetPythonTypeDesc(self::AbstractArgFormatterLARGE_INTEGER)::String
return "<o >"
end

function GetParsePostCode(self::AbstractArgFormatterLARGE_INTEGER)
return "$(GetKeyName(self))$(self.arg.name)$(GetIndirectedArgName(self, nothing, 1)))) bPythonIsHappy = FALSE;
"
end

function GetBuildForInterfacePreCode(self::AbstractArgFormatterLARGE_INTEGER)
notdirected = GetIndirectedArgName(self, nothing, 0)
return "$(self.arg.name)$(GetKeyName(self))$(notdirected));
"
end

mutable struct ArgFormatterULARGE_INTEGER <: AbstractArgFormatterULARGE_INTEGER

end
function GetKeyName(self::AbstractArgFormatterULARGE_INTEGER)::String
return "ULARGE_INTEGER"
end

mutable struct ArgFormatterInterface <: AbstractArgFormatterInterface
arg
gatewayMode
end
function GetInterfaceCppObjectInfo(self::AbstractArgFormatterInterface)::Tuple
return (GetIndirectedArgName(self, 1, self.arg.indirectionLevel), "$(GetUnconstType(self))$(self.arg.name)")
end

function GetParsePostCode(self::AbstractArgFormatterInterface)
if self.gatewayMode
sArg = GetIndirectedArgName(self, nothing, 2)
else
sArg = GetIndirectedArgName(self, 1, 2)
end
return "$(self.arg.name)$(self.arg.type)$(sArg), TRUE /* bNoneOK */))
		 bPythonIsHappy = FALSE;
"
end

function GetBuildForInterfacePreCode(self::AbstractArgFormatterInterface)
return "$(self.arg.name)$(self.arg.name)$(self.arg.type), FALSE);
"
end

function GetBuildForGatewayPreCode(self::AbstractArgFormatterInterface)
sPrefix = _IndirectPrefix(self, _GetDeclaredIndirection(self), 1)
return "$(self.arg.name)$(sPrefix)$(self.arg.name)$(self.arg.type), TRUE);
"
end

function GetInterfaceArgCleanup(self::AbstractArgFormatterInterface)
return "$(self.arg.name)$(self.arg.name)->Release();
"
end

mutable struct ArgFormatterVARIANT <: AbstractArgFormatterVARIANT
arg
end
function GetParsePostCode(self::AbstractArgFormatterVARIANT)
return "$(self.arg.name)$(GetIndirectedArgName(self, nothing, 1))) )
		bPythonIsHappy = FALSE;
"
end

function GetBuildForGatewayPreCode(self::AbstractArgFormatterVARIANT)
notdirected = GetIndirectedArgName(self, nothing, 1)
return "$(self.arg.name)$(notdirected));
"
end

function GetBuildForGatewayPostCode(self::AbstractArgFormatterVARIANT)::String
return "	Py_XDECREF(ob);
"
end

ConvertSimpleTypes = OrderedDict("BOOL" => ("BOOL", "int", "i"), "UINT" => ("UINT", "int", "i"), "BYTE" => ("BYTE", "int", "i"), "INT" => ("INT", "int", "i"), "DWORD" => ("DWORD", "int", "l"), "HRESULT" => ("HRESULT", "int", "l"), "ULONG" => ("ULONG", "int", "l"), "LONG" => ("LONG", "int", "l"), "int" => ("int", "int", "i"), "long" => ("long", "int", "l"), "DISPID" => ("DISPID", "long", "l"), "APPBREAKFLAGS" => ("int", "int", "i"), "BREAKRESUMEACTION" => ("int", "int", "i"), "ERRORRESUMEACTION" => ("int", "int", "i"), "BREAKREASON" => ("int", "int", "i"), "BREAKPOINT_STATE" => ("int", "int", "i"), "BREAKRESUME_ACTION" => ("int", "int", "i"), "SOURCE_TEXT_ATTR" => ("int", "int", "i"), "TEXT_DOC_ATTR" => ("int", "int", "i"), "QUERYOPTION" => ("int", "int", "i"), "PARSEACTION" => ("int", "int", "i"))
mutable struct ArgFormatterSimple <: AbstractArgFormatterSimple
#= An arg formatter for simple integer etc types =#
arg
end
function GetFormatChar(self::AbstractArgFormatterSimple)::Tuple<str>
return ConvertSimpleTypes[self.arg.type][2]
end

function _GetPythonTypeDesc(self::AbstractArgFormatterSimple)::Tuple<str>
return ConvertSimpleTypes[self.arg.type][1]
end

AllConverters = Dict("const OLECHAR" => (ArgFormatterOLECHAR, 0, 1), "WCHAR" => (ArgFormatterOLECHAR, 0, 1), "OLECHAR" => (ArgFormatterOLECHAR, 0, 1), "LPCOLESTR" => (ArgFormatterOLECHAR, 1, 1), "LPOLESTR" => (ArgFormatterOLECHAR, 1, 1), "LPCWSTR" => (ArgFormatterOLECHAR, 1, 1), "LPWSTR" => (ArgFormatterOLECHAR, 1, 1), "LPCSTR" => (ArgFormatterOLECHAR, 1, 1), "LPTSTR" => (ArgFormatterTCHAR, 1, 1), "LPCTSTR" => (ArgFormatterTCHAR, 1, 1), "HANDLE" => (ArgFormatterHANDLE, 0), "BSTR" => (ArgFormatterBSTR, 1, 0), "const IID" => (ArgFormatterIID, 0), "CLSID" => (ArgFormatterIID, 0), "IID" => (ArgFormatterIID, 0), "GUID" => (ArgFormatterIID, 0), "const GUID" => (ArgFormatterIID, 0), "const IID" => (ArgFormatterIID, 0), "REFCLSID" => (ArgFormatterIID, 0), "REFIID" => (ArgFormatterIID, 0), "REFGUID" => (ArgFormatterIID, 0), "const FILETIME" => (ArgFormatterTime, 0), "const SYSTEMTIME" => (ArgFormatterTime, 0), "const LPSYSTEMTIME" => (ArgFormatterTime, 1, 1), "LPSYSTEMTIME" => (ArgFormatterTime, 1, 1), "FILETIME" => (ArgFormatterTime, 0), "SYSTEMTIME" => (ArgFormatterTime, 0), "STATSTG" => (ArgFormatterSTATSTG, 0), "LARGE_INTEGER" => (ArgFormatterLARGE_INTEGER, 0), "ULARGE_INTEGER" => (ArgFormatterULARGE_INTEGER, 0), "VARIANT" => (ArgFormatterVARIANT, 0), "float" => (ArgFormatterFloat, 0), "single" => (ArgFormatterFloat, 0), "short" => (ArgFormatterShort, 0), "WORD" => (ArgFormatterShort, 0), "VARIANT_BOOL" => (ArgFormatterShort, 0), "HWND" => (ArgFormatterLONG_PTR, 1), "HMENU" => (ArgFormatterLONG_PTR, 1), "HOLEMENU" => (ArgFormatterLONG_PTR, 1), "HICON" => (ArgFormatterLONG_PTR, 1), "HDC" => (ArgFormatterLONG_PTR, 1), "LPARAM" => (ArgFormatterLONG_PTR, 1), "WPARAM" => (ArgFormatterLONG_PTR, 1), "LRESULT" => (ArgFormatterLONG_PTR, 1), "UINT" => (ArgFormatterShort, 0), "SVSIF" => (ArgFormatterShort, 0), "Control" => (ArgFormatterInterface, 0, 1), "DataObject" => (ArgFormatterInterface, 0, 1), "_PropertyBag" => (ArgFormatterInterface, 0, 1), "AsyncProp" => (ArgFormatterInterface, 0, 1), "DataSource" => (ArgFormatterInterface, 0, 1), "DataFormat" => (ArgFormatterInterface, 0, 1), "void **" => (ArgFormatterInterface, 2, 2), "ITEMIDLIST" => (ArgFormatterIDLIST, 0, 0), "LPITEMIDLIST" => (ArgFormatterIDLIST, 0, 1), "LPCITEMIDLIST" => (ArgFormatterIDLIST, 0, 1), "const ITEMIDLIST" => (ArgFormatterIDLIST, 0, 1))
for key in keys(ConvertSimpleTypes)
AllConverters[key] = (ArgFormatterSimple, 0)
end
function make_arg_converter(arg::AbstractInterface)::ArgFormatterInterface
try
clz = AllConverters[arg.type][0]
bin = AllConverters[arg.type][1]
decl = 0
if length(AllConverters[arg.type]) > 2
decl = AllConverters[arg.type][2]
end
return clz(arg, bin, decl)
catch exn
if exn isa KeyError
if arg.type[1] == "I"
return ArgFormatterInterface(arg, 0, 1)
end
throw(error_not_supported("$(arg.type)$(arg.name)) is unknown."))
end
end
end

mutable struct Argument <: AbstractArgument
#= A representation of an argument to a COM method

    This class contains information about a specific argument to a method.
    In addition, methods exist so that an argument knows how to convert itself
    to/from Python arguments.
     =#
arrayDecl::Int64
const_::Int64
good_interface_names
indirectionLevel::Int64
inout
name
raw_type
type_
unc_type
regex
Argument(good_interface_names = good_interface_names, inout = nothing, const_ = 0, arrayDecl = 0, regex = re.compile("/\\* \\[([^\\]]*.*?)] \\*/[ \\t](.*[* ]+)(\\w+)(\\[ *])?[\\),]")) = new(good_interface_names , inout , const_ , arrayDecl , regex )
end
function BuildFromFile(self::AbstractArgument, file)
#= Parse and build my data from a file

        Reads the next line in the file, and matches it as an argument
        description.  If not a valid argument line, an error_not_found exception
        is raised.
         =#
line = readline(file)
mo = search(self.regex, line)
if !(mo)
throw(error_not_found)
end
self.name = group(mo, 3)
self.inout = split(group(mo, 1), "][")
typ = strip(group(mo, 2))
self.raw_type = typ
self.indirectionLevel = 0
if group(mo, 4)
self.arrayDecl = 1
try
pos = rindex(typ, "__RPC_FAR")
self.indirectionLevel = self.indirectionLevel + 1
typ = strip(typ[begin:pos])
catch exn
if exn isa ValueError
#= pass =#
end
end
end
typ = replace(typ, "__RPC_FAR", "")
while true
try
pos = rindex(typ, "*")
self.indirectionLevel = self.indirectionLevel + 1
typ = strip(typ[begin:pos])
catch exn
if exn isa ValueError
break;
end
end
end
self.type = typ
if self.type[begin:6] == "const "
self.unc_type = self.type[7:end]
else
self.unc_type = self.type
end
if VERBOSE != 0
println("$(self.name)$(self.type)$(repeat("*",self.indirectionLevel))$(self.inout))")
end
end

function HasAttribute(self::AbstractArgument, typ)::Bool
#= Determines if the argument has the specific attribute.

        Argument attributes are specified in the header file, such as
        "[in][out][retval]" etc.  You can pass a specific string (eg "out")
        to find if this attribute was specified for the argument
         =#
return typ ∈ self.inout
end

function GetRawDeclaration(self::AbstractArgument)
ret = "$(self.raw_type)$(self.name)"
if self.arrayDecl != 0
ret = ret * "[]"
end
return ret
end

mutable struct Method <: AbstractMethod
#= A representation of a C++ method on a COM interface

    This class contains information about a specific method, as well as
    a list of all @Argument@s
     =#
args::Vector
callconv
good_interface_names
name
result
regex
Method(good_interface_names = good_interface_names, name = nothing, args = [], regex = re.compile("virtual (/\\*.*?\\*/ )?(.*?) (.*?) (.*?)\\(\\w?")) = new(good_interface_names , name , args , regex )
end
function BuildFromFile(self::AbstractMethod, file)
#= Parse and build my data from a file

        Reads the next line in the file, and matches it as a method
        description.  If not a valid method line, an error_not_found exception
        is raised.
         =#
line = readline(file)
mo = search(self.regex, line)
if !(mo)
throw(error_not_found)
end
self.name = group(mo, 4)
self.result = group(mo, 2)
if self.result != "HRESULT"
if self.result == "DWORD"
println("Warning: Old style interface detected - compilation errors likely!")
else
println("Method  - Only HRESULT return types are supported.")
end
println("$(self.result)$(self.name)(")
end
while true
arg = Argument(self.good_interface_names)
try
BuildFromFile(arg, file)
append(self.args, arg)
catch exn
if exn isa error_not_found
break;
end
end
end
end

mutable struct Interface <: AbstractInterface
#= A representation of a C++ COM Interface

    This class contains information about a specific interface, as well as
    a list of all @Method@s
     =#
base
methods::Vector
name
regex

            Interface(mo, methods = [], name = mo.group(2), base = mo.group(3), regex = re.compile("(interface|) ([^ ]*) : public (.*)\$")) = begin
                if VERBOSE
println("$(name)$(base)")
end
                new(mo, methods , name , base , regex )
            end
end
function BuildMethods(self::AbstractInterface, file)
#= Build all sub-methods for this interface =#
readline(file)
readline(file)
while true
try
method = Method([self.name])
BuildFromFile(method, file)
append(self.methods, method)
catch exn
if exn isa error_not_found
break;
end
end
end
end

function find_interface(interfaceName::AbstractInterface, file)
#= Find and return an interface in a file

    Given an interface name and file, search for the specified interface.

    Upon return, the interface itself has been built,
    but not the methods.
     =#
interface = nothing
line = readline(file)
while line
mo = search(Interface.regex, line)
if mo
name = group(mo, 2)
println(name)
AllConverters[name] = (ArgFormatterInterface, 0, 1)
if name == interfaceName
interface = Interface(mo)
BuildMethods(interface, file)
end
end
line = readline(file)
end
if interface
return interface
end
throw(error_not_found)
end

function parse_interface_info(interfaceName::AbstractInterface, file)
#= Find, parse and return an interface in a file

    Given an interface name and file, search for the specified interface.

    Upon return, the interface itself is fully built,
     =#
try
return find_interface(interfaceName, file)
catch exn
if exn isa re.error
current_exceptions() != [] ? current_exceptions()[end] : nothing()
println("The interface could not be built, as the regular expression failed!")
end
end
end

function test()
f = readline("d:\\msdev\\include\\objidl.h")
try
parse_interface_info("IPersistStream", f)
finally
close(f)
end
end

function test_regex(r::AbstractInterface, text)
res = search(r, text, 0)
if res == -1
println("** Not found")
else
println("$(res)$(group(r, 1))$(group(r, 2))$(group(r, 3))$(group(r, 4))")
end
end
