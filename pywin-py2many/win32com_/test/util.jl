using PyCall
win32api = pyimport("win32api")
pywintypes = pyimport("pywintypes")
using win32com_.shell.shell: IsUserAnAdmin


import tempfile

import gc

using ext_modules: pythoncom
import winerror
using pythoncom: _GetInterfaceCount, _GetGatewayCount
import win32com_
import logging
import winreg

import pywin32_testutil
using pywin32_testutil: TestLoader, TestResult, TestRunner, LeakTestCase
abstract type AbstractFailed <: Exception end
abstract type AbstractCaptureWriter end
abstract type AbstractLogHandler <: logging.Handler end
abstract type Abstract_CapturingFunctionTestCase end
abstract type AbstractShellTestCase end
function CheckClean()
try
sys.exc_clear()
catch exn
if exn isa AttributeError
#= pass =#
end
end
c = _GetInterfaceCount()
if c
println("Warning -  com interface objects still alive")
end
c = _GetGatewayCount()
if c
println("Warning -  com gateway objects still alive")
end
end

function RegisterPythonServer(filename::AbstractShellTestCase, progids = nothing, verbose = 0)
if progids
if isa(progids, str)
progids = [progids]
end
why_not = nothing
has_break = false
for progid in progids
try
clsid = pywintypes.IID(progid)
catch exn
if exn isa pythoncom.com_error
break;
end
end
try
HKCR = winreg.HKEY_CLASSES_ROOT
hk = winreg.OpenKey(HKCR, "CLSID\")
dll = winreg.QueryValue(hk, "InprocServer32")
catch exn
if exn isa WindowsError
break;
end
end
ok_files = [basename(os.path, pythoncom.__file__), "$(sys.version_info[1])$(sys.version_info[2]).dll"]
if basename(os.path, dll) ∉ ok_files
why_not = "$(progid)$(dll))"
break;
end
end
if has_break != true
return
end
end
try
catch exn
if exn isa ImportError
println("Can\'t import win32com_.shell - no idea if you are an admin or not?")
is_admin = false
end
end
if !(is_admin)
msg = " isn't registered, but I'm not an administrator who can register it."
if why_not
msg += "
(registration check failed as )"
end
throw(pythoncom.com_error(winerror.CO_E_CLASSSTRING, msg, nothing, -1))
end
cmd = "$(win32api.GetModuleFileName(0))$(filename)" --unattended > nul 2>&1"
if verbose
println("Registering engine$(filename)")
end
rc = os.system(cmd)
if rc
println("Registration command was:")
println(cmd)
throw(RuntimeError("Registration of engine '' failed"))
end
end

function ExecuteShellCommand(cmd::AbstractFailed, testcase, expected_output = nothing, tracebacks_ok = 0)
output_name = tempfile.mktemp("win32com_test")
cmd = cmd + " > "" 2>&1"
rc = os.system(cmd)
output = strip(read(readline(output_name)))
rm(output_name)
mutable struct Failed <: AbstractFailed

end

try
if rc
throw(Failed("exit code was " * string(rc)))
end
if expected_output !== nothing && output != expected_output
throw(Failed("$(expected_output)$(output))"))
end
if !(tracebacks_ok) && find(output, "Traceback (most recent call last)") >= 0
throw(Failed("traceback in program output"))
end
return output
catch exn
 let why = exn
if why isa Failed
println("Failed to exec command ''")
println("Failed as$(why)")
println("** start of program output **")
println(output)
println("** end of program output **")
fail(testcase, "$(cmd)$(why)")
end
end
end
end

function assertRaisesCOM_HRESULT(testcase::AbstractShellTestCase, hresult, func)
try
func(args..., None = kw)
catch exn
 let details = exn
if details isa pythoncom.com_error
if details.hresult == hresult
return
end
end
end
end
fail(testcase, "Excepected COM exception with HRESULT 0x")
end

mutable struct CaptureWriter <: AbstractCaptureWriter
old_err
old_out
captured::Vector

            CaptureWriter(old_err = nothing) = begin
                clear()
                new(old_err )
            end
end
function capture(self::AbstractCaptureWriter)
clear(self)
self.old_out = sys.stdout
self.old_err = sys.stderr
sys.stdout = self
sys.stderr = self
end

function release(self::AbstractCaptureWriter)
if self.old_out
sys.stdout = self.old_out
self.old_out = nothing
end
if self.old_err
sys.stderr = self.old_err
self.old_err = nothing
end
end

function clear(self::AbstractCaptureWriter)
self.captured = []
end

function write(self::AbstractCaptureWriter, msg)
append(self.captured, msg)
end

function get_captured(self::AbstractCaptureWriter)
return join(self.captured, "")
end

function get_num_lines_captured(self::AbstractCaptureWriter)::Int64
return length(split(join(self.captured, ""), "\n"))
end

mutable struct LogHandler <: AbstractLogHandler
emitted::Vector

            LogHandler(emitted = []) = begin
                logging.Handler.__init__(self)
                new(emitted )
            end
end
function emit(self::AbstractLogHandler, record)
append(self.emitted, record)
end

_win32com_logger = nothing
function setup_test_logger()::Tuple
old_log = (hasfield(typeof(win32com_), :logger) ? 
                getfield(win32com_, :logger) : nothing)
global _win32com_logger
if _win32com_logger === nothing
_win32com_logger = logging.Logger("test")
handler = LogHandler()
addHandler(_win32com_logger, handler)
end
win32com_.logger = _win32com_logger
handler = _win32com_logger.handlers[1]
handler.emitted = []
return (handler.emitted, old_log)
end

function restore_test_logger(prev_logger::AbstractShellTestCase)
@assert(prev_logger === nothing)
if prev_logger === nothing
#Delete Unsupported
del(win32com_.logger)
else
win32com_.logger = prev_logger
end
end

TestCase = unittest.TestCase
function CapturingFunctionTestCase()
real_test = _CapturingFunctionTestCase(args..., kw)
return LeakTestCase(real_test)
end

mutable struct _CapturingFunctionTestCase <: Abstract_CapturingFunctionTestCase

end
function __call__(self::Abstract_CapturingFunctionTestCase, result = nothing)
if result === nothing
result = defaultTestResult(self)
end
writer = CaptureWriter()
capture(writer)
try
__call__(unittest.FunctionTestCase, self)
if (hasfield(typeof(self), :do_leak_tests) ? 
                getfield(self, :do_leak_tests) : 0) && hasfield(typeof(sys), :gettotalrefcount)
run_leak_tests(self, result)
end
finally
release(writer)
end
output = get_captured(writer)
checkOutput(self, output, result)
if result.showAll
println(output)
end
end

function checkOutput(self::Abstract_CapturingFunctionTestCase, output, result)
if find(output, "Traceback") >= 0
msg = "Test output contained a traceback
---

---"
append(result.errors, (self, msg))
end
end

mutable struct ShellTestCase <: AbstractShellTestCase
__cmd
__eo

            ShellTestCase(cmd, expected_output, __cmd = cmd, __eo = expected_output) = begin
                unittest.TestCase.__init__(self)
                new(cmd, expected_output, __cmd , __eo )
            end
end
function runTest(self::AbstractShellTestCase)
ExecuteShellCommand(self.__cmd, self, self.__eo)
end

function __str__(self::AbstractShellTestCase)::String
max = 30
if length(self.__cmd) > max
cmd_repr = self.__cmd[begin:max] + "..."
else
cmd_repr = self.__cmd
end
return "exec: " + cmd_repr
end

function testmain()
pywin32_testutil.testmain(args..., None = kw)
CheckClean()
end
