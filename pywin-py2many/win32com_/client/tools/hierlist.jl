using PyCall
win32ui = pyimport("win32ui")
win32api = pyimport("win32api")


import win32con


using win32com_.gen_py.mfc: object, window, docview, dialog
import commctrl
abstract type AbstractHierDialog <: dialog.Dialog end
abstract type AbstractHierList <: object.Object end
abstract type AbstractHierListWithItems <: AbstractHierList end
abstract type AbstractHierListItem end
function GetItemText(item)
if type_(item) == type_(()) || type_(item) == type_([])
use = item[1]
else
use = item
end
if type_(use) == type_("")
return use
else
return repr(item)
end
end

mutable struct HierDialog <: AbstractHierDialog
dlgID
hierList
title
bitmapID
childListBoxID
dll

            HierDialog(title, hierList, bitmapID = win32ui.IDB_HIERFOLDERS, dlgID = win32ui.IDD_TREE, dll = nothing, childListBoxID = win32ui.IDC_LIST1) = begin
                dialog.Dialog.__init__(self, dlgID, dll)
                new(title, hierList, bitmapID , dlgID , dll , childListBoxID )
            end
end
function OnInitDialog(self::AbstractHierDialog)
SetWindowText(self, self.title)
HierInit(self.hierList, self)
return OnInitDialog(dialog.Dialog)
end

mutable struct HierList <: AbstractHierList
listControl
bitmapID
root
listBoxId
itemHandleMap::Dict
filledItemHandlesMap::Dict
bitmapMask
imageList
notify_parent
OnTreeItemExpanding
OnTreeItemSelChanged
OnTreeItemDoubleClick
HierList(root, bitmapID = win32ui.IDB_HIERFOLDERS, listBoxId = nothing, bitmapMask = nothing, listControl = nothing, itemHandleMap = Dict(), filledItemHandlesMap = Dict()) = new(root, bitmapID , listBoxId , bitmapMask , listControl , itemHandleMap , filledItemHandlesMap )
end
function __getattr__(self::AbstractHierList, attr)
try
return getfield(self.listControl, :attr)
catch exn
if exn isa AttributeError
return __getattr__(object.Object, self)
end
end
end

function ItemFromHandle(self::AbstractHierList, handle)::Dict
return self.itemHandleMap[handle]
end

function SetStyle(self::AbstractHierList, newStyle)
hwnd = GetSafeHwnd(self.listControl)
style = win32api.GetWindowLong(hwnd, win32con.GWL_STYLE)
win32api.SetWindowLong(hwnd, win32con.GWL_STYLE, style | newStyle)
end

function HierInit(self::AbstractHierList, parent, listControl = nothing)
if self.bitmapMask === nothing
bitmapMask = RGB(0, 0, 255)
else
bitmapMask = self.bitmapMask
end
self.imageList = win32ui.CreateImageList(self.bitmapID, 16, 0, bitmapMask)
if listControl === nothing
if self.listBoxId === nothing
self.listBoxId = win32ui.IDC_LIST1
end
self.listControl = GetDlgItem(parent, self.listBoxId)
else
self.listControl = listControl
lbid = GetDlgCtrlID(listControl)
@assert(self.listBoxId === nothing || self.listBoxId == lbid)
self.listBoxId = lbid
end
SetImageList(self.listControl, self.imageList, commctrl.LVSIL_NORMAL)
if sys.version_info[1] < 3
HookNotify(parent, self.OnTreeItemExpanding, commctrl.TVN_ITEMEXPANDINGA)
HookNotify(parent, self.OnTreeItemSelChanged, commctrl.TVN_SELCHANGEDA)
else
HookNotify(parent, self.OnTreeItemExpanding, commctrl.TVN_ITEMEXPANDINGW)
HookNotify(parent, self.OnTreeItemSelChanged, commctrl.TVN_SELCHANGEDW)
end
HookNotify(parent, self.OnTreeItemDoubleClick, commctrl.NM_DBLCLK)
self.notify_parent = parent
if self.root
AcceptRoot(self, self.root)
end
end

function DeleteAllItems(self::AbstractHierList)
DeleteAllItems(self.listControl)
self.root = nothing
self.itemHandleMap = Dict()
self.filledItemHandlesMap = Dict()
end

function HierTerm(self::AbstractHierList)
parent = self.notify_parent
if sys.version_info[1] < 3
HookNotify(parent, nothing, commctrl.TVN_ITEMEXPANDINGA)
HookNotify(parent, nothing, commctrl.TVN_SELCHANGEDA)
else
HookNotify(parent, nothing, commctrl.TVN_ITEMEXPANDINGW)
HookNotify(parent, nothing, commctrl.TVN_SELCHANGEDW)
end
HookNotify(parent, nothing, commctrl.NM_DBLCLK)
DeleteAllItems(self)
self.listControl = nothing
self.notify_parent = nothing
end

function OnTreeItemDoubleClick(self::AbstractHierList, info, extra)::Int64
hwndFrom, idFrom, code = info
if idFrom != self.listBoxId
return nothing
end
item = self.itemHandleMap[GetSelectedItem(self.listControl)]
TakeDefaultAction(self, item)
return 1
end

function OnTreeItemExpanding(self::AbstractHierList, info, extra)::Int64
hwndFrom, idFrom, code = info
if idFrom != self.listBoxId
return nothing
end
action, itemOld, itemNew, pt = extra
itemHandle = itemNew[1]
if itemHandle ∉ self.filledItemHandlesMap
item = self.itemHandleMap[itemHandle]
AddSubList(self, itemHandle, GetSubList(self, item))
self.filledItemHandlesMap[itemHandle] = nothing
end
return 0
end

function OnTreeItemSelChanged(self::AbstractHierList, info, extra)::Int64
hwndFrom, idFrom, code = info
if idFrom != self.listBoxId
return nothing
end
action, itemOld, itemNew, pt = extra
itemHandle = itemNew[1]
item = self.itemHandleMap[itemHandle]
PerformItemSelected(self, item)
return 1
end

function AddSubList(self::AbstractHierList, parentHandle, subItems)
for item in subItems
AddItem(self, parentHandle, item)
end
end

function AddItem(self::AbstractHierList, parentHandle, item, hInsertAfter = commctrl.TVI_LAST)
text = GetText(self, item)
if IsExpandable(self, item)
cItems = 1
else
cItems = 0
end
bitmapCol = GetBitmapColumn(self, item)
bitmapSel = GetSelectedBitmapColumn(self, item)
if bitmapSel === nothing
bitmapSel = bitmapCol
end
hitem = InsertItem(self.listControl, parentHandle, hInsertAfter, (nothing, nothing, nothing, text, bitmapCol, bitmapSel, cItems, 0))
self.itemHandleMap[hitem] = item
return hitem
end

function _GetChildHandles(self::AbstractHierList, handle)::Vector
ret = []
try
handle = GetChildItem(self.listControl, handle)
while true
push!(ret, handle)
handle = GetNextItem(self.listControl, handle, commctrl.TVGN_NEXT)
end
catch exn
if exn isa win32ui.error
#= pass =#
end
end
return ret
end

function ItemFromHandle(self::AbstractHierList, handle)::Dict
return self.itemHandleMap[handle]
end

function Refresh(self::AbstractHierList, hparent = nothing)
if hparent === nothing
hparent = commctrl.TVI_ROOT
end
if hparent ∉ self.filledItemHandlesMap
return
end
root_item = self.itemHandleMap[hparent]
old_handles = _GetChildHandles(self, hparent)
old_items = collect(map(self.ItemFromHandle, old_handles))
new_items = GetSubList(self, root_item)
inew = 0
hAfter = commctrl.TVI_FIRST
for iold in 0:length(old_items) - 1
inewlook = inew
matched = 0
while inewlook < length(new_items)
if old_items[iold + 1] == new_items[inewlook + 1]
matched = 1
break;
end
inewlook = inewlook + 1
end
if matched != 0
for i in inew:inewlook - 1
hAfter = AddItem(self, hparent, new_items[i + 1], hAfter)
end
inew = inewlook + 1
hold = old_handles[iold + 1]
if hold ∈ self.filledItemHandlesMap
Refresh(self, hold)
end
else
hdelete = old_handles[iold + 1]
for hchild in _GetChildHandles(self, hdelete)
delete!(self.itemHandleMap, hchild)
if hchild ∈ self.filledItemHandlesMap
delete!(self.filledItemHandlesMap, hchild)
end
end
DeleteItem(self.listControl, hdelete)
end
hAfter = old_handles[iold + 1]
end
for newItem in new_items[inew + 1:end]
AddItem(self, hparent, newItem)
end
end

function AcceptRoot(self::AbstractHierList, root)
DeleteAllItems(self.listControl)
self.itemHandleMap = Dict(commctrl.TVI_ROOT => root)
self.filledItemHandlesMap = Dict(commctrl.TVI_ROOT => root)
subItems = GetSubList(self, root)
AddSubList(self, 0, subItems)
end

function GetBitmapColumn(self::AbstractHierList, item)::Int64
if IsExpandable(self, item)
return 0
else
return 4
end
end

function GetSelectedBitmapColumn(self::AbstractHierList, item)
return nothing
end

function GetSelectedBitmapColumn(self::AbstractHierList, item)::Int64
return 0
end

function CheckChangedChildren(self::AbstractHierList)
return CheckChangedChildren(self.listControl)
end

function GetText(self::AbstractHierList, item)
return GetItemText(item)
end

function PerformItemSelected(self::AbstractHierList, item)
try
win32ui.SetStatusText("Selected " + GetText(self, item))
catch exn
if exn isa win32ui.error
#= pass =#
end
end
end

function TakeDefaultAction(self::AbstractHierList, item)
win32ui.MessageBox("Got item " + GetText(self, item))
end

mutable struct HierListWithItems <: AbstractHierListWithItems
bitmapID
bitmapMask
listBoxID

            HierListWithItems(root, bitmapID = win32ui.IDB_HIERFOLDERS, listBoxID = nothing, bitmapMask = nothing) = begin
                HierList(root, bitmapID, listBoxID, bitmapMask)
                new(root, bitmapID , listBoxID , bitmapMask )
            end
end
function DelegateCall(self::AbstractHierListWithItems, fn)
return fn()
end

function GetBitmapColumn(self::AbstractHierListWithItems, item)
rc = DelegateCall(self, item.GetBitmapColumn)
if rc === nothing
rc = HierList.GetBitmapColumn(self, item)
end
return rc
end

function GetSelectedBitmapColumn(self::AbstractHierListWithItems, item)
return DelegateCall(self, item.GetSelectedBitmapColumn)
end

function IsExpandable(self::AbstractHierListWithItems, item)
return DelegateCall(self, item.IsExpandable)
end

function GetText(self::AbstractHierListWithItems, item)
return DelegateCall(self, item.GetText)
end

function GetSubList(self::AbstractHierListWithItems, item)
return DelegateCall(self, item.GetSubList)
end

function PerformItemSelected(self::AbstractHierListWithItems, item)
func = (hasfield(typeof(item), :PerformItemSelected) ? 
                getfield(item, :PerformItemSelected) : nothing)
if func === nothing
return HierList.PerformItemSelected(self, item)
else
return DelegateCall(self, func)
end
end

function TakeDefaultAction(self::AbstractHierListWithItems, item)
func = (hasfield(typeof(item), :TakeDefaultAction) ? 
                getfield(item, :TakeDefaultAction) : nothing)
if func === nothing
return HierList.TakeDefaultAction(self, item)
else
return DelegateCall(self, func)
end
end

mutable struct HierListItem <: AbstractHierListItem


            HierListItem() = begin
                #= pass =#
                new()
            end
end
function GetText(self::AbstractHierListItem)
#= pass =#
end

function GetSubList(self::AbstractHierListItem)
#= pass =#
end

function IsExpandable(self::AbstractHierListItem)
#= pass =#
end

function GetBitmapColumn(self::AbstractHierListItem)
return nothing
end

function GetSelectedBitmapColumn(self::AbstractHierListItem)
return nothing
end

function __lt__(self::AbstractHierListItem, other)::Bool
return id(self) < id(other)
end

function __eq__(self::AbstractHierListItem, other)::Bool
return false
end
