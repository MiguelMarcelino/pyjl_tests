<<<<<<< HEAD
using PyCall
win32api = pyimport("win32api")
using win32com_.test.util: RegisterPythonServer

import win32com_.axscript
import win32com_.axscript.client

import win32com_.test.util
abstract type AbstractAXScript <: win32com_.test.util.TestCase end
verbose = "-v" ∈ sys.argv
mutable struct AXScript <: AbstractAXScript
verbose
end
function setUp(self::AXScript)
file = GetFullPathName(joinpath(win32com_.axscript.client.__path__[1], "pyscript.py"))
self.verbose = verbose
RegisterPythonServer(file, "python", self.verbose)
end

function testHost(self::AXScript)
file = GetFullPathName(joinpath(win32com_.axscript.__path__[1], "test\\testHost.py"))
cmd = "%s \"%s\"" % (GetModuleFileName(0), file)
if verbose
println("Testing Python Scripting host")
end
ExecuteShellCommand(cmd, self)
end

function testCScript(self::AXScript)
file = GetFullPathName(joinpath(win32com_.axscript.__path__[1], "Demos\\Client\\wsh\\test.pys"))
cmd = "cscript.exe \"%s\"" % file
if verbose
println("Testing Windows Scripting host with Python script")
end
ExecuteShellCommand(cmd, self)
end

if abspath(PROGRAM_FILE) == @__FILE__
testmain()
end
=======
using PyCall
win32api = pyimport("win32api")
using win32com_.test.util: RegisterPythonServer

import win32com_.axscript
import win32com_.axscript.client

import win32com_.test.util
abstract type AbstractAXScript <: win32com_.test.util.TestCase end
verbose = "-v" ∈ sys.argv
mutable struct AXScript <: AbstractAXScript
    verbose
end
function setUp(self::AXScript)
    file = GetFullPathName(joinpath(win32com_.axscript.client.__path__[1], "pyscript.py"))
    self.verbose = verbose
    RegisterPythonServer(file, "python", self.verbose)
end

function testHost(self::AXScript)
    file = GetFullPathName(joinpath(win32com_.axscript.__path__[1], "test\\testHost.py"))
    cmd = "%s \"%s\"" % (GetModuleFileName(0), file)
    if verbose
        println("Testing Python Scripting host")
    end
    ExecuteShellCommand(cmd, self)
end

function testCScript(self::AXScript)
    file = GetFullPathName(
        joinpath(win32com_.axscript.__path__[1], "Demos\\Client\\wsh\\test.pys"),
    )
    cmd = "cscript.exe \"%s\"" % file
    if verbose
        println("Testing Windows Scripting host with Python script")
    end
    ExecuteShellCommand(cmd, self)
end

if abspath(PROGRAM_FILE) == @__FILE__
    testmain()
end
>>>>>>> f214ca7f5ced7424e7132e581746e8672e842fb6
