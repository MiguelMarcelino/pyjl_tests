using PyCall
pywintypes = pyimport("pywintypes")
win32api = pyimport("win32api")
win32ui = pyimport("win32ui")
datetime = pyimport("datetime")
using ext_modules: pythoncom
import win32com_.server.util

import win32com_
import string
import win32com_.client.dynamic
import win32com_.client
using win32com_.axcontrol: axcontrol

using win32com_: storagecon
using win32com_.test.util: CheckClean



using pywin32_testutil: str2bytes
S_OK = 0

import win32timezone
abstract type AbstractLockBytes end
abstract type AbstractOleClientSite end
now = win32timezone.now()
mutable struct LockBytes <: AbstractLockBytes
atime
ctime
data
mtime
_com_interfaces_::Vector
_public_methods_::Vector{String}
LockBytes(data = str2bytes(data), ctime = now, mtime = now, atime = now) = new(data , ctime , mtime , atime )
end
function ReadAt(self::AbstractLockBytes, offset, cb)
println("ReadAt")
result = self.data[offset + 1:offset + cb]
return result
end

function WriteAt(self::AbstractLockBytes, offset, data)::Int64
println("$(WriteAt " * string(offset)")
println("$(len " * string(length(data))")
println("data:")
if length(self.data) >= offset
newdata = self.data[1:offset] + data
end
println(length(newdata))
if length(self.data) >= (offset + length(data))
newdata = newdata + self.data[offset + length(data) + 1:end]
end
println(length(newdata))
self.data = newdata
return length(data)
end

function Flush(self::AbstractLockBytes, whatsthis = 0)::Int64
println("$(Flush" * string(whatsthis)")
fname = joinpath(win32api.GetTempPath(), "persist.doc")
write(readline(fname), self.data)
return S_OK
end

function SetSize(self::AbstractLockBytes, size)::Int64
println("$(Set Size" * string(size)")
if size > length(self.data)
self.data = self.data + str2bytes(repeat("\0",(size - length(self.data))))
else
self.data = self.data[1:size]
end
return S_OK
end

function LockRegion(self::AbstractLockBytes, offset, size, locktype)
println("LockRegion")
#= pass =#
end

function UnlockRegion(self::AbstractLockBytes, offset, size, locktype)
println("UnlockRegion")
#= pass =#
end

function Stat(self::AbstractLockBytes, statflag)
println("$(returning Stat " * string(statflag)")
return ("PyMemBytes", storagecon.STGTY_LOCKBYTES, length(self.data), self.mtime, self.ctime, self.atime, (storagecon.STGM_DIRECT | storagecon.STGM_READWRITE) | storagecon.STGM_CREATE, storagecon.STGM_SHARE_EXCLUSIVE, "{00020905-0000-0000-C000-000000000046}", 0, 0)
end

mutable struct OleClientSite <: AbstractOleClientSite
IPersistStorage
IStorage
_com_interfaces_::Vector
_public_methods_::Vector{String}
data::String
OleClientSite(data = "", IPersistStorage = nothing, IStorage = nothing) = new(data , IPersistStorage , IStorage )
end
function SetIPersistStorage(self::AbstractOleClientSite, IPersistStorage)
self.IPersistStorage = IPersistStorage
end

function SetIStorage(self::AbstractOleClientSite, IStorage)
self.IStorage = IStorage
end

function SaveObject(self::AbstractOleClientSite)::Int64
println("SaveObject")
if self.IPersistStorage !== nothing && self.IStorage !== nothing
Save(self.IPersistStorage, self.IStorage, 1)
Commit(self.IStorage, 0)
end
return S_OK
end

function GetMoniker(self::AbstractOleClientSite, dwAssign, dwWhichMoniker)
println("$(GetMoniker " * string(dwAssign) * " " * string(dwWhichMoniker)")
end

function GetContainer(self::AbstractOleClientSite)
println("GetContainer")
end

function ShowObject(self::AbstractOleClientSite)
println("ShowObject")
end

function OnShowWindow(self::AbstractOleClientSite, fShow)
println("$(ShowObject" * string(fShow)")
end

function RequestNewObjectLayout(self::AbstractOleClientSite)
println("RequestNewObjectLayout")
end

function test()
lbcom = win32com_.server.util.wrap(LockBytes(), pythoncom.IID_ILockBytes)
stcom = pythoncom.StgCreateDocfileOnILockBytes(lbcom, ((storagecon.STGM_DIRECT | storagecon.STGM_CREATE) | storagecon.STGM_READWRITE) | storagecon.STGM_SHARE_EXCLUSIVE, 0)
ocs = OleClientSite()
ocscom = win32com_.server.util.wrap(ocs, axcontrol.IID_IOleClientSite)
oocom = axcontrol.OleCreate("{00020906-0000-0000-C000-000000000046}", axcontrol.IID_IOleObject, 0, (0,), ocscom, stcom)
mf = win32ui.GetMainFrame()
hwnd = GetSafeHwnd(mf)
SetHostNames(oocom, "OTPython", "This is Cool")
DoVerb(oocom, -1, ocscom, 0, hwnd, GetWindowRect(mf))
SetHostNames(oocom, "OTPython2", "ThisisCool2")
doc = win32com_.client.Dispatch(QueryInterface(oocom, pythoncom.IID_IDispatch))
dpcom = QueryInterface(oocom, pythoncom.IID_IPersistStorage)
SetIPersistStorage(ocs, dpcom)
SetIStorage(ocs, stcom)
wrange = Range(doc)
for i in 0:9
InsertAfter(wrange, "Hello from Python $(i)\n")
end
paras = doc.Paragraphs
for i in 0:length(paras) - 1
paras[i + 1]().Font.ColorIndex = i + 1
paras[i + 1]().Font.Size = 12 + 4*i
end
Save(dpcom, stcom, 0)
HandsOffStorage(dpcom)
Flush(lbcom)
Quit(doc.Application)
end

if abspath(PROGRAM_FILE) == @__FILE__
test()
pythoncom.CoUninitialize()
CheckClean()
end