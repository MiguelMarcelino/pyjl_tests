using PyCall
win32api = pyimport("win32api")
using win32com_.client: gencache


import win32com_.client.dynamic
using win32com_.client: Dispatch

import win32con
import winerror
import glob
using ext_modules: pythoncom

using win32com_.test.util: CheckClean
abstract type AbstractExplorerEvents end
bVisibleEventFired = 0
HRESULTS_IN_AUTOMATION = [-2125463506, winerror.MK_E_UNAVAILABLE]
mutable struct ExplorerEvents <: AbstractExplorerEvents

end
function OnVisible(self::AbstractExplorerEvents, visible)
global bVisibleEventFired
bVisibleEventFired = 1
end

function TestExplorerEvents()
global bVisibleEventFired
try
iexplore = DispatchWithEvents(win32com_.client, "InternetExplorer.Application", ExplorerEvents)
catch exn
 let exc = exn
if exc isa pythoncom.com_error
if exc.hresult ∉ HRESULTS_IN_AUTOMATION
error()
end
println("IE events appear to not be available, so skipping this test")
return
end
end
end
iexplore.Visible = 1
if !(bVisibleEventFired)
throw(RuntimeError("The IE event did not appear to fire!"))
end
Quit(iexplore)
iexplore = nothing
bVisibleEventFired = 0
ie = Dispatch(win32com_.client, "InternetExplorer.Application")
ie_events = DispatchWithEvents(win32com_.client, ie, ExplorerEvents)
ie.Visible = 1
if !(bVisibleEventFired) != 0
throw(RuntimeError("The IE event did not appear to fire!"))
end
Quit(ie)
ie = nothing
println("IE Event tests worked.")
end

function TestObjectFromWindow()
hwnd = FindWindow(win32gui, "IEFrame", nothing)
for child_class in ["TabWindowClass", "Shell DocObject View", "Internet Explorer_Server"]
hwnd = FindWindowEx(win32gui, hwnd, 0, child_class, nothing)
return
end
msg = RegisterWindowMessage(win32gui, "WM_HTML_GETOBJECT")
rc, result = SendMessageTimeout(win32gui, hwnd, msg, 0, 0, win32con.SMTO_ABORTIFHUNG, 1000)
ob = pythoncom.ObjectFromLresult(result, pythoncom.IID_IDispatch, 0)
doc = Dispatch(ob)
for color in split("red green blue orange white")
doc.bgColor = color
time.sleep(0.2)
end
end

function TestExplorer(iexplore::AbstractExplorerEvents)
if !(iexplore.Visible)
iexplore.Visible = -1
end
filename = joinpath(dirname(__file__), "..\\readme.html")
Navigate(iexplore, win32api.GetFullPathName(filename))
win32api.Sleep(1000)
TestObjectFromWindow()
win32api.Sleep(3000)
try
Quit(iexplore)
catch exn
if exn isa (AttributeError, pythoncom.com_error)
#= pass =#
end
end
end

function TestAll()
try
try
try
iexplore = win32com_.client.dynamic.Dispatch("InternetExplorer.Application")
catch exn
 let exc = exn
if exc isa pythoncom.com_error
if exc.hresult ∉ HRESULTS_IN_AUTOMATION
error()
end
println("IE appears to not be available, so skipping this test")
return
end
end
end
TestExplorer(iexplore)
win32api.Sleep(1000)
iexplore = nothing
TestExplorerEvents()
time.sleep(2)
gencache.EnsureModule("{EAB22AC0-30C1-11CF-A7EB-0000C05BAE0B}", 0, 1, 1)
iexplore = Dispatch(win32com_.client, "InternetExplorer.Application")
TestExplorer(iexplore)
catch exn
 let exc = exn
if exc isa pythoncom.com_error
if exc.hresult != winerror.RPC_E_DISCONNECTED
error()
end
end
end
end
finally
iexplore = nothing
end
end

if abspath(PROGRAM_FILE) == @__FILE__
TestAll()
CheckClean()
end