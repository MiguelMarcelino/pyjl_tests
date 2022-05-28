using PyCall
pythoncom = pyimport("pythoncom")
datetime = pyimport("datetime")
pywintypes = pyimport("pywintypes")
win32api = pyimport("win32api")
win32ui = pyimport("win32ui")

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
now = now()
mutable struct LockBytes <: AbstractLockBytes
    atime
    ctime
    data
    mtime
    _com_interfaces_::Vector
    _public_methods_::Vector{String}

    LockBytes(
        atime,
        ctime,
        data,
        mtime,
        _com_interfaces_::Vector = [pythoncom.IID_ILockBytes],
        _public_methods_::Vector{String} = [
            "ReadAt",
            "WriteAt",
            "Flush",
            "SetSize",
            "LockRegion",
            "UnlockRegion",
            "Stat",
        ],
    ) = new(atime, ctime, data, mtime, _com_interfaces_, _public_methods_)
end
function ReadAt(self::LockBytes, offset, cb)
    println("ReadAt")
    result = self.data[offset+1:offset+cb]
    return result
end

function WriteAt(self::LockBytes, offset, data)::Int64
    println("WriteAt $(string(offset))")
    println("len $(string(length(data)))")
    println("data:")
    if length(self.data) >= offset
        newdata = self.data[1:offset] + data
    end
    println(length(newdata))
    if length(self.data) >= (offset + length(data))
        newdata = newdata + self.data[offset+length(data)+1:end]
    end
    println(length(newdata))
    self.data = newdata
    return length(data)
end

function Flush(self::LockBytes, whatsthis = 0)::Int64
    println("Flush$(string(whatsthis))")
    fname = joinpath(GetTempPath(), "persist.doc")
    write(readline(fname), self.data)
    return S_OK
end

function SetSize(self::LockBytes, size)::Int64
    println("Set Size$(string(size))")
    if size > length(self.data)
        self.data = self.data + str2bytes(repeat("\0", (size - length(self.data))))
    else
        self.data = self.data[1:size]
    end
    return S_OK
end

function LockRegion(self::LockBytes, offset, size, locktype)
    println("LockRegion")
    #= pass =#
end

function UnlockRegion(self::LockBytes, offset, size, locktype)
    println("UnlockRegion")
    #= pass =#
end

function Stat(self::LockBytes, statflag)
    println("returning Stat $(string(statflag))")
    return (
        "PyMemBytes",
        storagecon.STGTY_LOCKBYTES,
        length(self.data),
        self.mtime,
        self.ctime,
        self.atime,
        (storagecon.STGM_DIRECT | storagecon.STGM_READWRITE) | storagecon.STGM_CREATE,
        storagecon.STGM_SHARE_EXCLUSIVE,
        "{00020905-0000-0000-C000-000000000046}",
        0,
        0,
    )
end

mutable struct OleClientSite <: AbstractOleClientSite
    IPersistStorage
    IStorage
    _com_interfaces_::Vector
    _public_methods_::Vector{String}
    data::String

    OleClientSite(
        IPersistStorage,
        IStorage,
        _com_interfaces_::Vector = [axcontrol.IID_IOleClientSite],
        _public_methods_::Vector{String} = [
            "SaveObject",
            "GetMoniker",
            "GetContainer",
            "ShowObject",
            "OnShowWindow",
            "RequestNewObjectLayout",
        ],
        data::String = "",
    ) = new(IPersistStorage, IStorage, _com_interfaces_, _public_methods_, data)
end
function SetIPersistStorage(self::OleClientSite, IPersistStorage)
    self.IPersistStorage = IPersistStorage
end

function SetIStorage(self::OleClientSite, IStorage)
    self.IStorage = IStorage
end

function SaveObject(self::OleClientSite)::Int64
    println("SaveObject")
    if self.IPersistStorage !== nothing && self.IStorage !== nothing
        Save(self.IPersistStorage, self.IStorage, 1)
        Commit(self.IStorage, 0)
    end
    return S_OK
end

function GetMoniker(self::OleClientSite, dwAssign, dwWhichMoniker)
    println("$("GetMoniker " * string(dwAssign) * " ")$(string(dwWhichMoniker))")
end

function GetContainer(self::OleClientSite)
    println("GetContainer")
end

function ShowObject(self::OleClientSite)
    println("ShowObject")
end

function OnShowWindow(self::OleClientSite, fShow)
    println("ShowObject$(string(fShow))")
end

function RequestNewObjectLayout(self::OleClientSite)
    println("RequestNewObjectLayout")
end

function test()
    lbcom = wrap(LockBytes(), pythoncom.IID_ILockBytes)
    stcom = StgCreateDocfileOnILockBytes(
        lbcom,
        ((storagecon.STGM_DIRECT | storagecon.STGM_CREATE) | storagecon.STGM_READWRITE) | storagecon.STGM_SHARE_EXCLUSIVE,
        0,
    )
    ocs = OleClientSite()
    ocscom = wrap(ocs, axcontrol.IID_IOleClientSite)
    oocom = OleCreate(
        "{00020906-0000-0000-C000-000000000046}",
        axcontrol.IID_IOleObject,
        0,
        (0,),
        ocscom,
        stcom,
    )
    mf = GetMainFrame()
    hwnd = GetSafeHwnd(mf)
    SetHostNames(oocom, "OTPython", "This is Cool")
    DoVerb(oocom, -1, ocscom, 0, hwnd, GetWindowRect(mf))
    SetHostNames(oocom, "OTPython2", "ThisisCool2")
    doc = Dispatch(QueryInterface(oocom, pythoncom.IID_IDispatch))
    dpcom = QueryInterface(oocom, pythoncom.IID_IPersistStorage)
    SetIPersistStorage(ocs, dpcom)
    SetIStorage(ocs, stcom)
    wrange = Range(doc)
    for i = 0:9
        InsertAfter(wrange, "Hello from Python %d\n" % i)
    end
    paras = doc.Paragraphs
    for i = 0:length(paras)-1
        paras[i+1]().Font.ColorIndex = i + 1
        paras[i+1]().Font.Size = 12 + 4 * i
    end
    Save(dpcom, stcom, 0)
    HandsOffStorage(dpcom)
    Flush(lbcom)
    Quit(doc.Application)
end

if abspath(PROGRAM_FILE) == @__FILE__
    test()
    CoUninitialize()
    CheckClean()
end
