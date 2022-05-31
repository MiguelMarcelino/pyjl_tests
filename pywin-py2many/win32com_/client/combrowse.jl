#= A utility for browsing COM objects.

 Usage:

  Command Prompt

    Use the command *"python.exe catbrowse.py"*.  This will display
    display a fairly small, modal dialog.

  Pythonwin

    Use the "Run Script" menu item, and this will create the browser in an
    MDI window.  This window can be fully resized.

 Details

   This module allows browsing of registered Type Libraries, COM categories,
   and running COM objects.  The display is similar to the Pythonwin object
   browser, and displays the objects in a hierarchical window.

   Note that this module requires the win32ui (ie, Pythonwin) distribution to
   work.

 =#
using PyCall
win32api = pyimport("win32api")
win32ui = pyimport("win32ui")



using ext_modules: pythoncom
import win32com_.ext_modules.win32con as win32con
using win32com_.client: util
using win32com_.client.tools: browser
mutable struct HLIRoot <: AbstractHLIRoot
name
HLIRoot(title, name = title) = new(title, name )
end
function GetSubList(self::AbstractHLIRoot)
return [HLIHeadingCategory(), HLI_IEnumMoniker(EnumRunning(pythoncom.GetRunningObjectTable()), "Running Objects"), HLIHeadingRegisterdTypeLibs()]
end

function __cmp__(self::AbstractHLIRoot, other)
return cmp(self.name, other.name)
end

abstract type AbstractHLIRoot <: browser.HLIPythonObject end
abstract type AbstractHLICOM <: browser.HLIPythonObject end
abstract type AbstractHLICLSID <: AbstractHLICOM end
abstract type AbstractHLI_Interface <: AbstractHLICOM end
abstract type AbstractHLI_Enum <: AbstractHLI_Interface end
abstract type AbstractHLI_IEnumMoniker <: AbstractHLI_Enum end
abstract type AbstractHLI_IMoniker <: AbstractHLI_Interface end
abstract type AbstractHLIHeadingCategory <: AbstractHLICOM end
abstract type AbstractHLICategory <: AbstractHLICOM end
abstract type AbstractHLIHelpFile <: AbstractHLICOM end
abstract type AbstractHLIRegisteredTypeLibrary <: AbstractHLICOM end
abstract type AbstractHLITypeLibEntry <: AbstractHLICOM end
abstract type AbstractHLICoClass <: AbstractHLITypeLibEntry end
abstract type AbstractHLITypeLibMethod <: AbstractHLITypeLibEntry end
abstract type AbstractHLITypeLibEnum <: AbstractHLITypeLibEntry end
abstract type AbstractHLITypeLibProperty <: AbstractHLICOM end
abstract type AbstractHLITypeLibFunction <: AbstractHLICOM end
abstract type AbstractHLITypeLib <: AbstractHLICOM end
abstract type AbstractHLIHeadingRegisterdTypeLibs <: AbstractHLICOM end
mutable struct HLICOM <: AbstractHLICOM
name
end
function GetText(self::AbstractHLICOM)
return self.name
end

function CalculateIsExpandable(self::AbstractHLICOM)::Int64
return 1
end

mutable struct HLICLSID <: AbstractHLICLSID
name

            HLICLSID(myobject, name = nothing) = begin
                if type_(myobject) == type_("")
myobject = pythoncom.MakeIID(myobject)
end
if name === nothing
try
name = pythoncom.ProgIDFromCLSID(myobject)
catch exn
if exn isa pythoncom.com_error
name = string(myobject)
end
end
name = "IID: " + name
end
HLICOM(myobject, name)
                new(myobject, name )
            end
end
function CalculateIsExpandable(self::AbstractHLICLSID)::Int64
return 0
end

function GetSubList(self::AbstractHLICLSID)::Vector
return []
end

mutable struct HLI_Interface <: AbstractHLI_Interface

end

mutable struct HLI_Enum <: AbstractHLI_Enum
myobject
end
function GetBitmapColumn(self::AbstractHLI_Enum)::Int64
return 0
end

function CalculateIsExpandable(self::AbstractHLI_Enum)
if self.myobject !== nothing
rc = length(Next(self.myobject, 1)) > 0
Reset(self.myobject)
else
rc = 0
end
return rc
end

mutable struct HLI_IEnumMoniker <: AbstractHLI_IEnumMoniker
myobject
end
function GetSubList(self::AbstractHLI_IEnumMoniker)::Vector
ctx = pythoncom.CreateBindCtx()
ret = []
for mon in util.Enumerator(self.myobject)
push!(ret, HLI_IMoniker(mon, GetDisplayName(mon, ctx, nothing)))
end
return ret
end

mutable struct HLI_IMoniker <: AbstractHLI_IMoniker

end
function GetSubList(self::AbstractHLI_IMoniker)::Vector
ret = []
push!(ret, browser.MakeHLI(Hash(self.myobject), "Hash Value"))
subenum = Enum(self.myobject, 1)
push!(ret, HLI_IEnumMoniker(subenum, "Sub Monikers"))
return ret
end

mutable struct HLIHeadingCategory <: AbstractHLIHeadingCategory
#= A tree heading for registered categories =#

end
function GetText(self::AbstractHLIHeadingCategory)::String
return "Registered Categories"
end

function GetSubList(self::AbstractHLIHeadingCategory)::Vector
catinf = pythoncom.CoCreateInstance(pythoncom.CLSID_StdComponentCategoriesMgr, nothing, pythoncom.CLSCTX_INPROC, pythoncom.IID_ICatInformation)
enum = util.Enumerator(EnumCategories(catinf))
ret = []
try
for (catid, lcid, desc) in enum
push!(ret, HLICategory((catid, lcid, desc)))
end
catch exn
if exn isa pythoncom.com_error
#= pass =#
end
end
return ret
end

mutable struct HLICategory <: AbstractHLICategory
#= An actual Registered Category =#

end
function GetText(self::AbstractHLICategory)
desc = self.myobject[3]
if !(desc)
desc = "(unnamed category)"
end
return desc
end

function GetSubList(self::AbstractHLICategory)::Vector
win32ui.DoWaitCursor(1)
catid, lcid, desc = self.myobject
catinf = pythoncom.CoCreateInstance(pythoncom.CLSID_StdComponentCategoriesMgr, nothing, pythoncom.CLSCTX_INPROC, pythoncom.IID_ICatInformation)
ret = []
for clsid in util.Enumerator(EnumClassesOfCategories(catinf, (catid,), ()))
push!(ret, HLICLSID(clsid))
end
win32ui.DoWaitCursor(0)
return ret
end

mutable struct HLIHelpFile <: AbstractHLIHelpFile

end
function CalculateIsExpandable(self::AbstractHLIHelpFile)::Int64
return 0
end

function GetText(self::AbstractHLIHelpFile)::String
fname, ctx = self.myobject
base = splitdir(fname)[2]
return "Help reference in "
end

function TakeDefaultAction(self::AbstractHLIHelpFile)
fname, ctx = self.myobject
if ctx
cmd = win32con.HELP_CONTEXT
else
cmd = win32con.HELP_FINDER
end
win32api.WinHelp(GetSafeHwnd(win32ui.GetMainFrame()), fname, cmd, ctx)
end

function GetBitmapColumn(self::AbstractHLIHelpFile)::Int64
return 6
end

mutable struct HLIRegisteredTypeLibrary <: AbstractHLIRegisteredTypeLibrary

end
function GetSubList(self::AbstractHLIRegisteredTypeLibrary)::Vector
clsidstr, versionStr = self.myobject
collected = []
helpPath = ""
key = win32api.RegOpenKey(win32con.HKEY_CLASSES_ROOT, "$(clsidstr)$(versionStr)")
win32ui.DoWaitCursor(1)
try
num = 0
while true
try
subKey = win32api.RegEnumKey(key, num)
catch exn
if exn isa win32api.error
break;
end
end
hSubKey = win32api.RegOpenKey(key, subKey)
try
value, typ = win32api.RegQueryValueEx(hSubKey, nothing)
if typ == win32con.REG_EXPAND_SZ
value = win32api.ExpandEnvironmentStrings(value)
end
catch exn
if exn isa win32api.error
value = ""
end
end
if subKey == "HELPDIR"
helpPath = value
elseif subKey == "Flags"
flags = value
else
try
lcid = parse(Int, subKey)
lcidkey = win32api.RegOpenKey(key, subKey)
lcidnum = 0
while true
try
platform = win32api.RegEnumKey(lcidkey, lcidnum)
catch exn
if exn isa win32api.error
break;
end
end
try
hplatform = win32api.RegOpenKey(lcidkey, platform)
fname, typ = win32api.RegQueryValueEx(hplatform, nothing)
if typ == win32con.REG_EXPAND_SZ
fname = win32api.ExpandEnvironmentStrings(fname)
end
catch exn
if exn isa win32api.error
fname = ""
end
end
push!(collected, (lcid, platform, fname))
lcidnum = lcidnum + 1
end
win32api.RegCloseKey(lcidkey)
catch exn
if exn isa ValueError
#= pass =#
end
end
end
num = num + 1
end
finally
win32ui.DoWaitCursor(0)
win32api.RegCloseKey(key)
end
ret = []
push!(ret, HLICLSID(clsidstr))
for (lcid, platform, fname) in collected
extraDescs = []
if platform != "win32"
push!(extraDescs, platform)
end
if lcid
push!(extraDescs, "locale=")
end
extraDesc = ""
if extraDescs
extraDesc = " ()"
end
push!(ret, HLITypeLib(fname, "Type Library" * extraDesc))
end
sort(ret)
return ret
end

mutable struct HLITypeLibEntry <: AbstractHLITypeLibEntry

end
function GetText(self::AbstractHLITypeLibEntry)::Union[str,Any]
tlb, index = self.myobject
name, doc, ctx, helpFile = GetDocumentation(tlb, index)
try
typedesc = HLITypeKinds[GetTypeInfoType(tlb, index) + 1][2]
catch exn
if exn isa KeyError
typedesc = "Unknown!"
end
end
return (name + " - ") + typedesc
end

function GetSubList(self::AbstractHLITypeLibEntry)::Vector
tlb, index = self.myobject
name, doc, ctx, helpFile = GetDocumentation(tlb, index)
ret = []
if doc
push!(ret, browser.HLIDocString(doc, "Doc"))
end
if helpFile
push!(ret, HLIHelpFile((helpFile, ctx)))
end
return ret
end

mutable struct HLICoClass <: AbstractHLICoClass

end
function GetSubList(self::AbstractHLICoClass)
ret = HLITypeLibEntry.GetSubList(self)
tlb, index = self.myobject
typeinfo = GetTypeInfo(tlb, index)
attr = GetTypeAttr(typeinfo)
for j in 0:attr[9] - 1
flags = GetImplTypeFlags(typeinfo, j)
refType = GetRefTypeInfo(typeinfo, GetRefTypeOfImplType(typeinfo, j))
refAttr = GetTypeAttr(refType)
append(ret, browser.MakeHLI(refAttr[1], "$(refAttr[1])$(flags)"))
end
return ret
end

mutable struct HLITypeLibMethod <: AbstractHLITypeLibMethod
entry_type::String
name

            HLITypeLibMethod(ob, name = nothing, entry_type = "Method") = begin
                HLITypeLibEntry(ob, name)
                new(ob, name , entry_type )
            end
end
function GetSubList(self::AbstractHLITypeLibMethod)
ret = HLITypeLibEntry.GetSubList(self)
tlb, index = self.myobject
typeinfo = GetTypeInfo(tlb, index)
attr = GetTypeAttr(typeinfo)
for i in 0:attr[8] - 1
append(ret, HLITypeLibProperty((typeinfo, i)))
end
for i in 0:attr[7] - 1
append(ret, HLITypeLibFunction((typeinfo, i)))
end
return ret
end

mutable struct HLITypeLibEnum <: AbstractHLITypeLibEnum
id
name

            HLITypeLibEnum(myitem, None = myitem, typeinfo = typelib.GetTypeInfo(index), id = typeinfo.GetVarDesc(index)[0], name = typeinfo.GetNames(id)[0]) = begin
                HLITypeLibEntry(myitem, name)
                new(myitem, None , typeinfo , id , name )
            end
end
function GetText(self::AbstractHLITypeLibEnum)::String
return self.name + " - Enum/Module"
end

function GetSubList(self::AbstractHLITypeLibEnum)::Vector
ret = []
typelib, index = self.myobject
typeinfo = GetTypeInfo(typelib, index)
attr = GetTypeAttr(typeinfo)
for j in 0:attr[8] - 1
vdesc = GetVarDesc(typeinfo, j)
name = GetNames(typeinfo, vdesc[1])[1]
push!(ret, browser.MakeHLI(vdesc[2], name))
end
return ret
end

mutable struct HLITypeLibProperty <: AbstractHLITypeLibProperty
id
name

            HLITypeLibProperty(myitem, None = myitem, id = typeinfo.GetVarDesc(index)[0], name = typeinfo.GetNames(id)[0]) = begin
                HLICOM(myitem, name)
                new(myitem, None , id , name )
            end
end
function GetText(self::AbstractHLITypeLibProperty)::String
return self.name + " - Property"
end

function GetSubList(self::AbstractHLITypeLibProperty)::Vector
ret = []
typeinfo, index = self.myobject
names = GetNames(typeinfo, self.id)
if length(names) > 1
push!(ret, browser.MakeHLI(names[2:end], "Named Params"))
end
vd = GetVarDesc(typeinfo, index)
push!(ret, browser.MakeHLI(self.id, "Dispatch ID"))
push!(ret, browser.MakeHLI(vd[2], "Value"))
push!(ret, browser.MakeHLI(vd[3], "Elem Desc"))
push!(ret, browser.MakeHLI(vd[4], "Var Flags"))
push!(ret, browser.MakeHLI(vd[5], "Var Kind"))
return ret
end

mutable struct HLITypeLibFunction <: AbstractHLITypeLibFunction
id
name
funcflags::Vector{Tuple{String}}
funckinds::Dict{Any, String}
invokekinds::Dict{Any, String}
type_flags::Vector{Tuple{String}}
vartypes::Dict{Any, String}

            HLITypeLibFunction(myitem, None = myitem, id = typeinfo.GetFuncDesc(index)[0], name = typeinfo.GetNames(id)[0], funcflags::Vector{Tuple{String}} = [(pythoncom.FUNCFLAG_FRESTRICTED, "Restricted"), (pythoncom.FUNCFLAG_FSOURCE, "Source"), (pythoncom.FUNCFLAG_FBINDABLE, "Bindable"), (pythoncom.FUNCFLAG_FREQUESTEDIT, "Request Edit"), (pythoncom.FUNCFLAG_FDISPLAYBIND, "Display Bind"), (pythoncom.FUNCFLAG_FDEFAULTBIND, "Default Bind"), (pythoncom.FUNCFLAG_FHIDDEN, "Hidden"), (pythoncom.FUNCFLAG_FUSESGETLASTERROR, "Uses GetLastError")], funckinds::Dict{Any, String} = Dict(pythoncom.FUNC_VIRTUAL => "Virtual", pythoncom.FUNC_PUREVIRTUAL => "Pure Virtual", pythoncom.FUNC_STATIC => "Static", pythoncom.FUNC_DISPATCH => "Dispatch"), invokekinds::Dict{Any, String} = Dict(pythoncom.INVOKE_FUNC => "Function", pythoncom.INVOKE_PROPERTYGET => "Property Get", pythoncom.INVOKE_PROPERTYPUT => "Property Put", pythoncom.INVOKE_PROPERTYPUTREF => "Property Put by reference"), type_flags::Vector{Tuple{String}} = [(pythoncom.VT_VECTOR, "Vector"), (pythoncom.VT_ARRAY, "Array"), (pythoncom.VT_BYREF, "ByRef"), (pythoncom.VT_RESERVED, "Reserved")], vartypes::Dict{Any, String} = Dict(pythoncom.VT_EMPTY => "Empty", pythoncom.VT_NULL => "NULL", pythoncom.VT_I2 => "Integer 2", pythoncom.VT_I4 => "Integer 4", pythoncom.VT_R4 => "Real 4", pythoncom.VT_R8 => "Real 8", pythoncom.VT_CY => "CY", pythoncom.VT_DATE => "Date", pythoncom.VT_BSTR => "String", pythoncom.VT_DISPATCH => "IDispatch", pythoncom.VT_ERROR => "Error", pythoncom.VT_BOOL => "BOOL", pythoncom.VT_VARIANT => "Variant", pythoncom.VT_UNKNOWN => "IUnknown", pythoncom.VT_DECIMAL => "Decimal", pythoncom.VT_I1 => "Integer 1", pythoncom.VT_UI1 => "Unsigned integer 1", pythoncom.VT_UI2 => "Unsigned integer 2", pythoncom.VT_UI4 => "Unsigned integer 4", pythoncom.VT_I8 => "Integer 8", pythoncom.VT_UI8 => "Unsigned integer 8", pythoncom.VT_INT => "Integer", pythoncom.VT_UINT => "Unsigned integer", pythoncom.VT_VOID => "Void", pythoncom.VT_HRESULT => "HRESULT", pythoncom.VT_PTR => "Pointer", pythoncom.VT_SAFEARRAY => "SafeArray", pythoncom.VT_CARRAY => "C Array", pythoncom.VT_USERDEFINED => "User Defined", pythoncom.VT_LPSTR => "Pointer to string", pythoncom.VT_LPWSTR => "Pointer to Wide String", pythoncom.VT_FILETIME => "File time", pythoncom.VT_BLOB => "Blob", pythoncom.VT_STREAM => "IStream", pythoncom.VT_STORAGE => "IStorage", pythoncom.VT_STORED_OBJECT => "Stored object", pythoncom.VT_STREAMED_OBJECT => "Streamed object", pythoncom.VT_BLOB_OBJECT => "Blob object", pythoncom.VT_CF => "CF", pythoncom.VT_CLSID => "CLSID")) = begin
                HLICOM(myitem, name)
                new(myitem, None , id , name , funcflags, funckinds, invokekinds, type_flags, vartypes)
            end
end
function GetText(self::AbstractHLITypeLibFunction)::String
return self.name + " - Function"
end

function MakeReturnTypeName(self::AbstractHLITypeLibFunction, typ)
justtyp = typ & pythoncom.VT_TYPEMASK
try
typname = self.vartypes[justtyp + 1]
catch exn
if exn isa KeyError
typname = "?Bad type?"
end
end
for (flag, desc) in self.type_flags
if flag & typ
typname = "$(desc)$(typname))"
end
end
return typname
end

function MakeReturnType(self::AbstractHLITypeLibFunction, returnTypeDesc)
if type_(returnTypeDesc) == type_(())
first = returnTypeDesc[1]
result = MakeReturnType(self, first)
if first != pythoncom.VT_USERDEFINED
result = result * " " + MakeReturnType(self, returnTypeDesc[2])
end
return result
else
return MakeReturnTypeName(self, returnTypeDesc)
end
end

function GetSubList(self::AbstractHLITypeLibFunction)::Vector
ret = []
typeinfo, index = self.myobject
names = GetNames(typeinfo, self.id)
push!(ret, browser.MakeHLI(self.id, "Dispatch ID"))
if length(names) > 1
push!(ret, browser.MakeHLI(join(names[2:end], ", "), "Named Params"))
end
fd = GetFuncDesc(typeinfo, index)
if fd[2]
push!(ret, browser.MakeHLI(fd[2], "Possible result values"))
end
if fd[9]
typ, flags, default = fd[9]
val = MakeReturnType(self, typ)
if flags
val = "$(val)$(flags)$(default))"
end
push!(ret, browser.MakeHLI(val, "Return Type"))
end
for argDesc in fd[3]
typ, flags, default = argDesc
val = MakeReturnType(self, typ)
if flags
val = "$(val)$(flags))"
end
if default !== nothing
val = "$(val)$(default))"
end
push!(ret, browser.MakeHLI(val, "Argument"))
end
try
fkind = self.funckinds[fd[4] + 1]
catch exn
if exn isa KeyError
fkind = "Unknown"
end
end
push!(ret, browser.MakeHLI(fkind, "Function Kind"))
try
ikind = self.invokekinds[fd[5] + 1]
catch exn
if exn isa KeyError
ikind = "Unknown"
end
end
push!(ret, browser.MakeHLI(ikind, "Invoke Kind"))
push!(ret, browser.MakeHLI(fd[7], "Number Optional Params"))
flagDescs = []
for (flag, desc) in self.funcflags
if flag & fd[10]
push!(flagDescs, desc)
end
end
if flagDescs
push!(ret, browser.MakeHLI(join(flagDescs, ", "), "Function Flags"))
end
return ret
end

HLITypeKinds = Dict(pythoncom.TKIND_ENUM => (HLITypeLibEnum, "Enumeration"), pythoncom.TKIND_RECORD => (HLITypeLibEntry, "Record"), pythoncom.TKIND_MODULE => (HLITypeLibEnum, "Module"), pythoncom.TKIND_INTERFACE => (HLITypeLibMethod, "Interface"), pythoncom.TKIND_DISPATCH => (HLITypeLibMethod, "Dispatch"), pythoncom.TKIND_COCLASS => (HLICoClass, "CoClass"), pythoncom.TKIND_ALIAS => (HLITypeLibEntry, "Alias"), pythoncom.TKIND_UNION => (HLITypeLibEntry, "Union"))
mutable struct HLITypeLib <: AbstractHLITypeLib
myobject
end
function GetSubList(self::AbstractHLITypeLib)::Vector
ret = []
push!(ret, browser.MakeHLI(self.myobject, "Filename"))
try
tlb = pythoncom.LoadTypeLib(self.myobject)
catch exn
if exn isa pythoncom.com_error
return [browser.MakeHLI(" can not be loaded")]
end
end
for i in 0:GetTypeInfoCount(tlb) - 1
try
push!(ret, HLITypeKinds[GetTypeInfoType(tlb, i)][0]((tlb, i)))
catch exn
if exn isa pythoncom.com_error
push!(ret, browser.MakeHLI("The type info can not be loaded!"))
end
end
end
sort(ret)
return ret
end

mutable struct HLIHeadingRegisterdTypeLibs <: AbstractHLIHeadingRegisterdTypeLibs
#= A tree heading for registered type libraries =#

end
function GetText(self::AbstractHLIHeadingRegisterdTypeLibs)::String
return "Registered Type Libraries"
end

function GetSubList(self::AbstractHLIHeadingRegisterdTypeLibs)::Vector
ret = []
key = win32api.RegOpenKey(win32con.HKEY_CLASSES_ROOT, "TypeLib")
win32ui.DoWaitCursor(1)
try
num = 0
while true
try
keyName = win32api.RegEnumKey(key, num)
catch exn
if exn isa win32api.error
break;
end
end
subKey = win32api.RegOpenKey(key, keyName)
name = nothing
try
subNum = 0
bestVersion = 0.0
while true
try
versionStr = win32api.RegEnumKey(subKey, subNum)
catch exn
if exn isa win32api.error
break;
end
end
try
versionFlt = float(versionStr)
catch exn
if exn isa ValueError
versionFlt = 0
end
end
if versionFlt > bestVersion
bestVersion = versionFlt
name = win32api.RegQueryValue(subKey, versionStr)
end
subNum = subNum + 1
end
finally
win32api.RegCloseKey(subKey)
end
if name !== nothing
push!(ret, HLIRegisteredTypeLibrary((keyName, versionStr), name))
end
num = num + 1
end
finally
win32api.RegCloseKey(key)
win32ui.DoWaitCursor(0)
end
sort(ret)
return ret
end

function main(modal::AbstractHLIHeadingRegisterdTypeLibs = false)
root = HLIRoot("COM Browser")
if "app" ∈ sys.modules
browser.MakeTemplate()
OpenObject(browser.template, root)
else
dlg = browser.dynamic_browser(root)
if modal
DoModal(dlg)
else
CreateWindow(dlg)
ShowWindow(dlg)
end
end
end

if abspath(PROGRAM_FILE) == @__FILE__
main()
ni = pythoncom._GetInterfaceCount()
ng = pythoncom._GetGatewayCount()
if ni || ng
println("$(ni)$(ng) objects alive")
end
end