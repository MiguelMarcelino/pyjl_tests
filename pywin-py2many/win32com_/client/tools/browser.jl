using PyCall
win32api = pyimport("win32api")
win32ui = pyimport("win32ui")



import __main__

using win32com_.gen_py.mfc: dialog
include("hierlist.jl")
special_names = ["__doc__", "__name__", "__self__"]
mutable struct HLIPythonObject <: AbstractHLIPythonObject
myobject
knownExpandable
name

            HLIPythonObject(myobject = nothing, name = myobject, knownExpandable = nothing) = begin
                hierlist.HierListItem.__init__(self)
if name
name = name
else
try
name = myobject.__name__
catch exn
if exn isa (AttributeError, TypeError)
try
r = repr(myobject)
if length(r) > 20
r = r[begin:20] + "..."
end
name = r
catch exn
if exn isa (AttributeError, TypeError)
name = "???"
end
end
end
end
end
                new(myobject , name , knownExpandable )
            end
end
function __lt__(self::AbstractHLIPythonObject, other)::Bool
return self.name < other.name
end

function __eq__(self::AbstractHLIPythonObject, other)::Bool
return self.name == other.name
end

function __repr__(self::AbstractHLIPythonObject)::String
try
type_ = GetHLIType(self)
catch exn
type_ = "Generic"
end
return (("HLIPythonObject(" + type_) * ") - name: " + self.name) * " object: " + repr(self.myobject)
end

function GetText(self::AbstractHLIPythonObject)::String
try
return (string(self.name) * " (" + GetHLIType(self)) * ")"
catch exn
if exn isa AttributeError
return string(self.name) * " = " + repr(self.myobject)
end
end
end

function InsertDocString(self::AbstractHLIPythonObject, lst)
ob = nothing
try
ob = self.myobject.__doc__
catch exn
if exn isa (AttributeError, TypeError)
#= pass =#
end
end
if ob && isa(ob, str)
insert(lst, 0, HLIDocString(ob, "Doc"))
end
end

function GetSubList(self::AbstractHLIPythonObject)::Vector
ret = []
try
for (key, ob) in items(self.myobject.__dict__)
if key ∉ special_names
push!(ret, MakeHLI(ob, key))
end
end
catch exn
if exn isa (AttributeError, TypeError)
#= pass =#
end
end
try
for name in self.myobject.__methods__
push!(ret, HLIMethod(name))
end
catch exn
if exn isa (AttributeError, TypeError)
#= pass =#
end
end
try
for member in self.myobject.__members__
if !(member ∈ special_names)
push!(ret, MakeHLI(getfield(self.myobject, :member), member))
end
end
catch exn
if exn isa (AttributeError, TypeError)
#= pass =#
end
end
sort(ret)
InsertDocString(self, ret)
return ret
end

function IsExpandable(self::AbstractHLIPythonObject)
if self.knownExpandable === nothing
self.knownExpandable = CalculateIsExpandable(self)
end
return self.knownExpandable
end

function CalculateIsExpandable(self::AbstractHLIPythonObject)::Int64
if hasfield(typeof(self.myobject), :__doc__)
return 1
end
try
for key in keys(self.myobject.__dict__)
if key ∉ special_names
return 1
end
end
catch exn
if exn isa (AttributeError, TypeError)
#= pass =#
end
end
try
self.myobject.__methods__
return 1
catch exn
if exn isa (AttributeError, TypeError)
#= pass =#
end
end
try
for item in self.myobject.__members__
if item ∉ special_names
return 1
end
end
catch exn
if exn isa (AttributeError, TypeError)
#= pass =#
end
end
return 0
end

function GetBitmapColumn(self::AbstractHLIPythonObject)::Int64
if IsExpandable(self)
return 0
else
return 4
end
end

function TakeDefaultAction(self::AbstractHLIPythonObject)
ShowObject(self.myobject, self.name)
end

mutable struct HLIDocString <: AbstractHLIDocString

end
function GetHLIType(self::AbstractHLIDocString)::String
return "DocString"
end

function GetText(self::AbstractHLIDocString)
return strip(self.myobject)
end

function IsExpandable(self::AbstractHLIDocString)::Int64
return 0
end

function GetBitmapColumn(self::AbstractHLIDocString)::Int64
return 6
end

mutable struct HLIModule <: AbstractHLIModule

end
function GetHLIType(self::AbstractHLIModule)::String
return "Module"
end

mutable struct HLIFrame <: AbstractHLIFrame

end
function GetHLIType(self::AbstractHLIFrame)::String
return "Stack Frame"
end

abstract type AbstractHLIPythonObject <: hierlist.HierListItem end
abstract type AbstractHLIDocString <: AbstractHLIPythonObject end
abstract type AbstractHLIModule <: AbstractHLIPythonObject end
abstract type AbstractHLIFrame <: AbstractHLIPythonObject end
abstract type AbstractHLITraceback <: AbstractHLIPythonObject end
abstract type AbstractHLIClass <: AbstractHLIPythonObject end
abstract type AbstractHLIMethod <: AbstractHLIPythonObject end
abstract type AbstractHLICode <: AbstractHLIPythonObject end
abstract type AbstractHLIInstance <: AbstractHLIPythonObject end
abstract type AbstractHLIBuiltinFunction <: AbstractHLIPythonObject end
abstract type AbstractHLIFunction <: AbstractHLIPythonObject end
abstract type AbstractHLISeq <: AbstractHLIPythonObject end
abstract type AbstractHLIList <: AbstractHLISeq end
abstract type AbstractHLITuple <: AbstractHLISeq end
abstract type AbstractHLIDict <: AbstractHLIPythonObject end
abstract type AbstractHLIString <: AbstractHLIPythonObject end
abstract type AbstractDialogShowObject <: dialog.Dialog end
abstract type Abstractdynamic_browser <: dialog.Dialog end
abstract type AbstractBrowserTemplate <: docview.DocTemplate end
abstract type AbstractBrowserDocument <: docview.Document end
abstract type AbstractBrowserView <: docview.TreeView end
mutable struct HLITraceback <: AbstractHLITraceback

end
function GetHLIType(self::AbstractHLITraceback)::String
return "Traceback"
end

mutable struct HLIClass <: AbstractHLIClass
myobject
end
function GetHLIType(self::AbstractHLIClass)::String
return "Class"
end

function GetSubList(self::AbstractHLIClass)::Vector
ret = []
for base in self.myobject.__bases__
push!(ret, MakeHLI(base, "Base class: " + base.__name__))
end
ret = ret + HLIPythonObject.GetSubList(self)
return ret
end

mutable struct HLIMethod <: AbstractHLIMethod
myobject
end
function GetHLIType(self::AbstractHLIMethod)::String
return "Method"
end

function GetText(self::AbstractHLIMethod)::String
return ("Method: " + self.myobject) * "()"
end

mutable struct HLICode <: AbstractHLICode
myobject
end
function GetHLIType(self::AbstractHLICode)::String
return "Code"
end

function IsExpandable(self::AbstractHLICode)
return self.myobject
end

function GetSubList(self::AbstractHLICode)::Vector
ret = []
push!(ret, MakeHLI(self.myobject.co_consts, "Constants (co_consts)"))
push!(ret, MakeHLI(self.myobject.co_names, "Names (co_names)"))
push!(ret, MakeHLI(self.myobject.co_filename, "Filename (co_filename)"))
push!(ret, MakeHLI(self.myobject.co_argcount, "Number of args (co_argcount)"))
push!(ret, MakeHLI(self.myobject.co_varnames, "Param names (co_varnames)"))
return ret
end

mutable struct HLIInstance <: AbstractHLIInstance
name
myobject
end
function GetHLIType(self::AbstractHLIInstance)::String
return "Instance"
end

function GetText(self::AbstractHLIInstance)::String
return string(self.name) * " (Instance of class " * string(self.myobject.__class__.__name__) * ")"
end

function IsExpandable(self::AbstractHLIInstance)::Int64
return 1
end

function GetSubList(self::AbstractHLIInstance)::Vector
ret = []
push!(ret, MakeHLI(self.myobject.__class__))
ret = ret + HLIPythonObject.GetSubList(self)
return ret
end

mutable struct HLIBuiltinFunction <: AbstractHLIBuiltinFunction

end
function GetHLIType(self::AbstractHLIBuiltinFunction)::String
return "Builtin Function"
end

mutable struct HLIFunction <: AbstractHLIFunction
myobject
end
function GetHLIType(self::AbstractHLIFunction)::String
return "Function"
end

function IsExpandable(self::AbstractHLIFunction)::Int64
return 1
end

function GetSubList(self::AbstractHLIFunction)::Vector
ret = []
try
push!(ret, MakeHLI(self.myobject.func_argdefs, "Arg Defs"))
catch exn
if exn isa AttributeError
#= pass =#
end
end
try
code = self.myobject.__code__
globs = self.myobject.__globals__
catch exn
if exn isa AttributeError
code = self.myobject.func_code
globs = self.myobject.func_globals
end
end
push!(ret, MakeHLI(code, "Code"))
push!(ret, MakeHLI(globs, "Globals"))
InsertDocString(self, ret)
return ret
end

mutable struct HLISeq <: AbstractHLISeq
myobject
end
function GetHLIType(self::AbstractHLISeq)::String
return "Sequence (abstract!)"
end

function IsExpandable(self::AbstractHLISeq)::Bool
return length(self.myobject) > 0
end

function GetSubList(self::AbstractHLISeq)::Vector
ret = []
pos = 0
for item in self.myobject
push!(ret, MakeHLI(item, "[" * string(pos) * "]"))
pos = pos + 1
end
InsertDocString(self, ret)
return ret
end

mutable struct HLIList <: AbstractHLIList

end
function GetHLIType(self::AbstractHLIList)::String
return "List"
end

mutable struct HLITuple <: AbstractHLITuple

end
function GetHLIType(self::AbstractHLITuple)::String
return "Tuple"
end

mutable struct HLIDict <: AbstractHLIDict
myobject
end
function GetHLIType(self::AbstractHLIDict)::String
return "Dict"
end

function IsExpandable(self::AbstractHLIDict)::Union[Union[Union[int,bool],int],bool]
try
self.myobject.__doc__
return 1
catch exn
if exn isa (AttributeError, TypeError)
return length(self.myobject) > 0
end
end
end

function GetSubList(self::AbstractHLIDict)::Vector
ret = []
keys = collect(keys(self.myobject))
sort(keys)
for key in keys
ob = self.myobject[key + 1]
push!(ret, MakeHLI(ob, string(key)))
end
InsertDocString(self, ret)
return ret
end

mutable struct HLIString <: AbstractHLIString

end
function IsExpandable(self::AbstractHLIString)::Int64
return 0
end

TypeMap = Dict(type_ => HLIClass, types.FunctionType => HLIFunction, tuple => HLITuple, dict => HLIDict, list => HLIList, types.ModuleType => HLIModule, types.CodeType => HLICode, types.BuiltinFunctionType => HLIBuiltinFunction, types.FrameType => HLIFrame, types.TracebackType => HLITraceback, str => HLIString, int => HLIPythonObject, bool => HLIPythonObject, float => HLIPythonObject)
function MakeHLI(ob::AbstractBrowserView, name = nothing)
try
cls = TypeMap[type_(ob)]
catch exn
if exn isa KeyError
if hasfield(typeof(ob), :__class__)
cls = HLIInstance
else
cls = HLIPythonObject
end
end
end
return cls(ob, name)
end

mutable struct DialogShowObject <: AbstractDialogShowObject
object
title
edit

            DialogShowObject(object = object, title = title) = begin
                dialog.Dialog.__init__(self, win32ui.IDD_LARGE_EDIT)
                new(object , title )
            end
end
function OnInitDialog(self::AbstractDialogShowObject)
SetWindowText(self, self.title)
self.edit = GetDlgItem(self, win32ui.IDC_EDIT1)
try
strval = string(self.object)
catch exn
t, v, tb = sys.exc_info()
strval = "$(t)$(v)"
tb = nothing
end
strval = 
                # Unsupported use of re.sub with less than 3 arguments
                sub()("\n", "\r\n", strval)
ReplaceSel(self.edit, strval)
end

function ShowObject(object::AbstractBrowserView, title)
dlg = DialogShowObject(object, title)
DoModal(dlg)
end

import win32con

import commctrl
mutable struct dynamic_browser <: Abstractdynamic_browser
hier_list
cs
dt::Vector
style

            dynamic_browser(hli_root, hier_list = hierlist.HierListWithItems(hli_root, win32ui.IDB_BROWSER_HIER), cs = (((win32con.WS_CHILD | win32con.WS_VISIBLE) | commctrl.TVS_HASLINES) | commctrl.TVS_LINESATROOT) | commctrl.TVS_HASBUTTONS, dt::Vector = [["Python Object Browser", (0, 0, 200, 200), style, nothing, (8, "MS Sans Serif")], ["SysTreeView32", nothing, win32ui.IDC_LIST1, (0, 0, 200, 200), cs]], style = win32con.WS_OVERLAPPEDWINDOW | win32con.WS_VISIBLE) = begin
                dialog.Dialog.__init__(self, dt)
HookMessage(on_size, win32con.WM_SIZE)
                new(hli_root, hier_list , cs , dt, style )
            end
end
function OnInitDialog(self::Abstractdynamic_browser)
HierInit(self.hier_list, self)
return OnInitDialog(dialog.Dialog)
end

function OnOK(self::Abstractdynamic_browser)
HierTerm(self.hier_list)
self.hier_list = nothing
return OnOK(self._obj_)
end

function OnCancel(self::Abstractdynamic_browser)
HierTerm(self.hier_list)
self.hier_list = nothing
return OnCancel(self._obj_)
end

function on_size(self::Abstractdynamic_browser, params)
lparam = params[4]
w = win32api.LOWORD(lparam)
h = win32api.HIWORD(lparam)
MoveWindow(GetDlgItem(self, win32ui.IDC_LIST1), (0, 0, w, h))
end

function Browse(ob::AbstractBrowserView = __main__)
#= Browse the argument, or the main dictionary =#
root = MakeHLI(ob, "root")
if !IsExpandable(root)
throw(TypeError("Browse() argument must have __dict__ attribute, or be a Browser supported type"))
end
dlg = dynamic_browser(root)
CreateWindow(dlg)
end

using win32com_.gen_py.mfc: docview
mutable struct BrowserTemplate <: AbstractBrowserTemplate


            BrowserTemplate() = begin
                docview.DocTemplate.__init__(self, win32ui.IDR_PYTHONTYPE, BrowserDocument, nothing, BrowserView)
                new()
            end
end
function OpenObject(self::AbstractBrowserTemplate, root)::BrowserDocument
for doc in GetDocumentList(self)
if doc.root == root
ActivateFrame(GetFirstView(doc))
return doc
end
end
doc = BrowserDocument(self, root)
frame = CreateNewFrame(self, doc)
OnNewDocument(doc)
InitialUpdateFrame(self, frame, doc, 1)
return doc
end

mutable struct BrowserDocument <: AbstractBrowserDocument
root

            BrowserDocument(template, root = root) = begin
                docview.Document.__init__(self, template)
SetTitle("Browser: " + root.name)
                new(template, root )
            end
end
function OnOpenDocument(self::AbstractBrowserDocument, name)::Int64
throw(TypeError("This template can not open files"))
return 0
end

mutable struct BrowserView <: AbstractBrowserView

end
function OnInitialUpdate(self::AbstractBrowserView)
rc = OnInitialUpdate(self._obj_)
list = hierlist.HierListWithItems(GetDocument(self).root, win32ui.IDB_BROWSER_HIER, win32ui.AFX_IDW_PANE_FIRST)
HierInit(list, GetParent(self))
SetStyle(list, (commctrl.TVS_HASLINES | commctrl.TVS_LINESATROOT) | commctrl.TVS_HASBUTTONS)
return rc
end

template = nothing
function MakeTemplate()
global template
if template === nothing
template = BrowserTemplate()
end
end

function BrowseMDI(ob::AbstractBrowserView = __main__)
#= Browse an object using an MDI window. =#
MakeTemplate()
root = MakeHLI(ob, repr(ob))
if !IsExpandable(root)
throw(TypeError("Browse() argument must have __dict__ attribute, or be a Browser supported type"))
end
OpenObject(template, root)
end
