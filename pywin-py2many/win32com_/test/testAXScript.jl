using PyCall
win32api = pyimport("win32api")
include("util.jl")

import win32com_.axscript
import win32com_.axscript.client

include("util.jl")
abstract type AbstractAXScript <: win32com_.test.util.TestCase end
verbose = "-v" ∈ append!([PROGRAM_FILE], ARGS)
mutable struct AXScript <: AbstractAXScript
    verbose
end
function setUp(self::AbstractAXScript)
    file = win32api.GetFullPathName(
        joinpath(win32com_.axscript.client.__path__[1], "pyscript.py"),
    )
    self.verbose = verbose
    RegisterPythonServer(file, "python", verbose = self.verbose)
end

function testHost(self::AbstractAXScript)
    file = win32api.GetFullPathName(
        joinpath(win32com_.axscript.__path__[1], "test\\testHost.py"),
    )
    cmd = "$(win32api.GetModuleFileName(0)) \"$(file)\""
    if verbose
        println("Testing Python Scripting host")
    end
    win32com_.test.util.ExecuteShellCommand(cmd, self)
end

function testCScript(self::AbstractAXScript)
    file = win32api.GetFullPathName(
        joinpath(win32com_.axscript.__path__[1], "Demos\\Client\\wsh\\test.pys"),
    )
    cmd = "cscript.exe \"$(file)\""
    if verbose
        println("Testing Windows Scripting host with Python script")
    end
    win32com_.test.util.ExecuteShellCommand(cmd, self)
end

if abspath(PROGRAM_FILE) == @__FILE__
    win32com_.test.util.testmain()
end
