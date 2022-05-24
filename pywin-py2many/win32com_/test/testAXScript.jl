using PyCall
win32api = pyimport("win32api")
using win32com_.test.util: RegisterPythonServer

import win32com_.axscript
import win32com_.axscript.client

import win32com_.test.util
abstract type AbstractAXScript <: win32com_.test.util.TestCase end
verbose = "-v" ∈ append!([PROGRAM_FILE], ARGS)
mutable struct AXScript <: AbstractAXScript
    verbose
end
function setUp(self::AXScript)
    file = win32api.GetFullPathName(join)
    self.verbose = verbose
    RegisterPythonServer(file, "python", self.verbose)
end

function testHost(self::AXScript)
    file = win32api.GetFullPathName(join)
    cmd = "%s \"%s\"" % (win32api.GetModuleFileName(0), file)
    if verbose
        println("Testing Python Scripting host")
    end
    win32com_.test.util.ExecuteShellCommand(cmd, self)
end

function testCScript(self::AXScript)
    file = win32api.GetFullPathName(join)
    cmd = "cscript.exe \"%s\"" % file
    if verbose
        println("Testing Windows Scripting host with Python script")
    end
    win32com_.test.util.ExecuteShellCommand(cmd, self)
end

if abspath(PROGRAM_FILE) == @__FILE__
    win32com_.test.util.testmain()
end
