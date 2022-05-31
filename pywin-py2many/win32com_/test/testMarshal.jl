#= Testing pasing object between multiple COM threads

Uses standard COM marshalling to pass objects between threads.  Even
though Python generally seems to work when you just pass COM objects
between threads, it shouldnt.

This shows the "correct" way to do it.

It shows that although we create new threads to use the Python.Interpreter,
COM marshalls back all calls to that object to the main Python thread,
which must be running a message loop (as this sample does).

When this test is run in "free threaded" mode (at this stage, you must
manually mark the COM objects as "ThreadingModel=Free", or run from a
service which has marked itself as free-threaded), then no marshalling
is done, and the Python.Interpreter object start doing the "expected" thing
- ie, it reports being on the same thread as its caller!

Python.exe needs a good way to mark itself as FreeThreaded - at the moment
this is a pain in the but!

 =#
using Printf
using PyCall
win32api = pyimport("win32api")
import threading
import win32com_.client
import win32event
using ext_modules: pythoncom

using testServers: InterpCase
abstract type AbstractThreadInterpCase <: InterpCase end
freeThreaded = 1
mutable struct ThreadInterpCase <: AbstractThreadInterpCase
BeginThreadsSimpleMarshal
end
function _testInterpInThread(self::AbstractThreadInterpCase, stopEvent, interp)
try
_doTestInThread(self, interp)
finally
win32event.SetEvent(stopEvent)
end
end

function _doTestInThread(self::AbstractThreadInterpCase, interp)
pythoncom.CoInitialize()
myThread = win32api.GetCurrentThreadId()
if freeThreaded != 0
interp = pythoncom.CoGetInterfaceAndReleaseStream(interp, pythoncom.IID_IDispatch)
interp = win32com_.client.Dispatch(interp)
end
Exec(interp, "import win32api")
pythoncom.CoUninitialize()
end

function BeginThreadsSimpleMarshal(self::AbstractThreadInterpCase, numThreads)
#= Creates multiple threads using simple (but slower) marshalling.

        Single interpreter object, but a new stream is created per thread.

        Returns the handles the threads will set when complete.
         =#
interp = win32com_.client.Dispatch("Python.Interpreter")
events = []
threads = []
for i in 0:numThreads - 1
hEvent = win32event.CreateEvent(nothing, 0, 0, nothing)
push!(events, hEvent)
interpStream = pythoncom.CoMarshalInterThreadInterfaceInStream(pythoncom.IID_IDispatch, interp._oleobj_)
t = threading.Thread(target = self._testInterpInThread, args = (hEvent, interpStream))
setDaemon(t, 1)
start(t)
push!(threads, t)
end
interp = nothing
return (threads, events)
end

function BeginThreadsFastMarshal(self::AbstractThreadInterpCase, numThreads)
#= Creates multiple threads using fast (but complex) marshalling.

        The marshal stream is created once, and each thread uses the same stream

        Returns the handles the threads will set when complete.
         =#
interp = win32com_.client.Dispatch("Python.Interpreter")
if freeThreaded != 0
interp = pythoncom.CoMarshalInterThreadInterfaceInStream(pythoncom.IID_IDispatch, interp._oleobj_)
end
events = []
threads = []
for i in 0:numThreads - 1
hEvent = win32event.CreateEvent(nothing, 0, 0, nothing)
t = threading.Thread(target = self._testInterpInThread, args = (hEvent, interp))
setDaemon(t, 1)
start(t)
push!(events, hEvent)
push!(threads, t)
end
return (threads, events)
end

function _DoTestMarshal(self::AbstractThreadInterpCase, fn, bCoWait = 0)
threads, events = fn(2)
numFinished = 0
while true
try
if bCoWait
rc = pythoncom.CoWaitForMultipleHandles(0, 2000, events)
else
rc = win32event.MsgWaitForMultipleObjects(events, 0, 2000, win32event.QS_ALLINPUT)
end
if rc >= win32event.WAIT_OBJECT_0 && rc < (win32event.WAIT_OBJECT_0 + length(events))
numFinished = numFinished + 1
if numFinished >= length(events)
break;
end
elseif rc == (win32event.WAIT_OBJECT_0 + length(events))
pythoncom.PumpWaitingMessages()
else
@printf("Waiting for thread to stop with interfaces=%d, gateways=%d\n", (pythoncom._GetInterfaceCount(), pythoncom._GetGatewayCount()))
end
catch exn
if exn isa KeyboardInterrupt
break;
end
end
end
for t in threads
join(2, t)
assertFalse(self, is_alive(t), "thread failed to stop!?")
end
threads = nothing
end

function testSimpleMarshal(self::AbstractThreadInterpCase)
_DoTestMarshal(self, self.BeginThreadsSimpleMarshal)
end

function testSimpleMarshalCoWait(self::AbstractThreadInterpCase)
_DoTestMarshal(self, self.BeginThreadsSimpleMarshal, 1)
end

if abspath(PROGRAM_FILE) == @__FILE__
end