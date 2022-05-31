using Dates
using PyCall
win32api = pyimport("win32api")
win32ui = pyimport("win32ui")
using pywin.mfc: dialog
using pywin.mfc.thread: WinThread
import threading

import win32con

function MakeProgressDlgTemplate(caption, staticText = "")
    style =
        (
            (
                ((win32con.DS_MODALFRAME | win32con.WS_POPUP) | win32con.WS_VISIBLE) |
                win32con.WS_CAPTION
            ) | win32con.WS_SYSMENU
        ) | win32con.DS_SETFONT
    cs = win32con.WS_CHILD | win32con.WS_VISIBLE
    w = 215
    h = 36
    h = 40
    dlg = [[caption, (0, 0, w, h), style, nothing, (8, "MS Sans Serif")]]
    s = win32con.WS_TABSTOP | cs
    push!(dlg, [130, staticText, 1000, (7, 7, w - 7, h - 32), cs | win32con.SS_LEFT])
    return dlg
end

mutable struct CStatusProgressDialog <: AbstractCStatusProgressDialog
    initMsg
    maxticks
    pbar
    pincr::Int64
    progress::Int64
    static
    tickincr
    msg::String

    CStatusProgressDialog(
        title,
        msg = "",
        maxticks = 100,
        tickincr = 1,
        templ = MakeProgressDlgTemplate(title, msg),
        pbar = nothing,
    ) = begin
        dialog.Dialog.__init__(self, templ)
        new(title, msg, maxticks, tickincr, templ, pbar)
    end
end
function OnInitDialog(self::AbstractCStatusProgressDialog)
    rc = OnInitDialog(dialog.Dialog)
    self.static = GetDlgItem(self, 1000)
    self.pbar = win32ui.CreateProgressCtrl()
    CreateWindow(
        self.pbar,
        win32con.WS_CHILD | win32con.WS_VISIBLE,
        (10, 30, 310, 44),
        self,
        1001,
    )
    SetRange(self.pbar, 0, self.maxticks)
    SetStep(self.pbar, self.tickincr)
    self.progress = 0
    self.pincr = 5
    return rc
end

function Close(self::AbstractCStatusProgressDialog)
    EndDialog(self, 0)
end

function SetMaxTicks(self::AbstractCStatusProgressDialog, maxticks)
    if self.pbar !== nothing
        SetRange(self.pbar, 0, maxticks)
    end
end

function Tick(self::AbstractCStatusProgressDialog)
    if self.pbar !== nothing
        StepIt(self.pbar)
    end
end

function SetTitle(self::AbstractCStatusProgressDialog, text)
    SetWindowText(self, text)
end

function SetText(self::AbstractCStatusProgressDialog, text)
    SetDlgItemText(self, 1000, text)
end

function Set(self::AbstractCStatusProgressDialog, pos, max = nothing)
    if self.pbar !== nothing
        SetPos(self.pbar, pos)
        if max !== nothing
            SetRange(self.pbar, 0, max)
        end
    end
end

abstract type AbstractCStatusProgressDialog <: dialog.Dialog end
abstract type AbstractCThreadedStatusProcessDialog <: AbstractCStatusProgressDialog end
abstract type AbstractProgressThread <: WinThread end
MYWM_SETTITLE = win32con.WM_USER + 10
MYWM_SETMSG = win32con.WM_USER + 11
MYWM_TICK = win32con.WM_USER + 12
MYWM_SETMAXTICKS = win32con.WM_USER + 13
MYWM_SET = win32con.WM_USER + 14
mutable struct CThreadedStatusProcessDialog <: AbstractCThreadedStatusProcessDialog
    OnMaxTicks
    OnMsg
    OnSet
    OnTick
    OnTitle
    max
    msg
    pos
    threadid
    title
    maxticks::Int64
    tickincr::Int64

    CThreadedStatusProcessDialog(
        title,
        msg = "",
        maxticks = 100,
        tickincr = 1,
        threadid = win32api.GetCurrentThreadId(),
    ) = begin
        CStatusProgressDialog(title, msg, maxticks, tickincr)
        new(title, msg, maxticks, tickincr, threadid)
    end
end
function OnInitDialog(self::AbstractCThreadedStatusProcessDialog)
    rc = CStatusProgressDialog.OnInitDialog(self)
    HookMessage(self, self.OnTitle, MYWM_SETTITLE)
    HookMessage(self, self.OnMsg, MYWM_SETMSG)
    HookMessage(self, self.OnTick, MYWM_TICK)
    HookMessage(self, self.OnMaxTicks, MYWM_SETMAXTICKS)
    HookMessage(self, self.OnSet, MYWM_SET)
    return rc
end

function _Send(self::AbstractCThreadedStatusProcessDialog, msg)
    try
        PostMessage(self, msg)
    catch exn
        if exn isa win32ui.error
            #= pass =#
        end
    end
end

function OnTitle(self::AbstractCThreadedStatusProcessDialog, msg)
    CStatusProgressDialog.SetTitle(self, self.title)
end

function OnMsg(self::AbstractCThreadedStatusProcessDialog, msg)
    CStatusProgressDialog.SetText(self, self.msg)
end

function OnTick(self::AbstractCThreadedStatusProcessDialog, msg)
    CStatusProgressDialog.Tick(self)
end

function OnMaxTicks(self::AbstractCThreadedStatusProcessDialog, msg)
    CStatusProgressDialog.SetMaxTicks(self, self.maxticks)
end

function OnSet(self::AbstractCThreadedStatusProcessDialog, msg)
    CStatusProgressDialog.Set(self, self.pos, self.max)
end

function Close(self::AbstractCThreadedStatusProcessDialog)
    @assert(self.threadid)
    win32api.PostThreadMessage(self.threadid, win32con.WM_QUIT, 0, 0)
end

function SetMaxTicks(self::AbstractCThreadedStatusProcessDialog, maxticks)
    self.maxticks = maxticks
    _Send(self, MYWM_SETMAXTICKS)
end

function SetTitle(self::AbstractCThreadedStatusProcessDialog, title)
    self.title = title
    _Send(self, MYWM_SETTITLE)
end

function SetText(self::AbstractCThreadedStatusProcessDialog, text)
    self.msg = text
    _Send(self, MYWM_SETMSG)
end

function Tick(self::AbstractCThreadedStatusProcessDialog)
    _Send(self, MYWM_TICK)
end

function Set(self::AbstractCThreadedStatusProcessDialog, pos, max = nothing)
    self.pos = pos
    self.max = max
    _Send(self, MYWM_SET)
end

mutable struct ProgressThread <: AbstractProgressThread
    title
    msg
    maxticks
    tickincr
    dialog
    createdEvent

    ProgressThread(
        title,
        msg = "",
        maxticks = 100,
        tickincr = 1,
        dialog = nothing,
        createdEvent = threading.Event(),
    ) = begin
        WinThread.__init__(self)
        new(title, msg, maxticks, tickincr, dialog, createdEvent)
    end
end
function InitInstance(self::AbstractProgressThread)
    self.dialog =
        CThreadedStatusProcessDialog(self.title, self.msg, self.maxticks, self.tickincr)
    CreateWindow(self.dialog)
    try
        SetForegroundWindow(self.dialog)
    catch exn
        if exn isa win32ui.error
            #= pass =#
        end
    end
    set(self.createdEvent)
    return WinThread.InitInstance(self)
end

function ExitInstance(self::AbstractProgressThread)::Int64
    return 0
end

function StatusProgressDialog(
    title,
    msg = "",
    maxticks = 100,
    parent = nothing,
)::CStatusProgressDialog
    d = CStatusProgressDialog(title, msg, maxticks)
    CreateWindow(d, parent)
    return d
end

function ThreadedStatusProgressDialog(title, msg = "", maxticks = 100)
    t = ProgressThread(title, msg, maxticks)
    CreateThread(t)
    end_time = Dates.datetime2unix(Dates.now())() + 10
    while Dates.datetime2unix(Dates.now())() < end_time
        if isSet(t.createdEvent)
            break
        end
        win32ui.PumpWaitingMessages()
        time.sleep(0.1)
    end
    return t.dialog
end

function demo()
    d = StatusProgressDialog("A Demo", "Doing something...")
    for i = 0:99
        if i == 50
            SetText(d, "Getting there...")
        end
        if i == 90
            SetText(d, "Nearly done...")
        end
        win32api.Sleep(20)
        Tick(d)
    end
    Close(d)
end

function thread_demo()
    d = ThreadedStatusProgressDialog("A threaded demo", "Doing something")
    for i = 0:99
        if i == 50
            SetText(d, "Getting there...")
        end
        if i == 90
            SetText(d, "Nearly done...")
        end
        win32api.Sleep(20)
        Tick(d)
    end
    Close(d)
end

if abspath(PROGRAM_FILE) == @__FILE__
    thread_demo()
end
