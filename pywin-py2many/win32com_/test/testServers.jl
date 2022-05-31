import win32com_.demos.connect
include("util.jl")
using win32com_.servers: interp
using ext_modules: pythoncom
include("../client/dynamic.jl")
import winerror
include("util.jl")

abstract type AbstractInterpCase <: win32com_.test.util.TestCase end
abstract type AbstractConnectionsTestCase <: win32com_.test.util.TestCase end
function TestConnections()
    win32com_.demos.connect.test()
end

mutable struct InterpCase <: AbstractInterpCase
end
function setUp(self::AbstractInterpCase)
    RegisterPythonServer(interp.__file__, "Python.Interpreter")
end

function _testInterp(self::AbstractInterpCase, interp)
    assertEqual(self, interp.Eval("1+1"), 2)
    win32com_.test.util.assertRaisesCOM_HRESULT(
        self,
        winerror.DISP_E_TYPEMISMATCH,
        interp.Eval,
        2,
    )
end

function testInproc(self::AbstractInterpCase)
    interp = win32com_.client.dynamic.Dispatch(
        "Python.Interpreter",
        clsctx = pythoncom.CLSCTX_INPROC,
    )
    _testInterp(self, interp)
end

function testLocalServer(self::AbstractInterpCase)
    interp = win32com_.client.dynamic.Dispatch(
        "Python.Interpreter",
        clsctx = pythoncom.CLSCTX_LOCAL_SERVER,
    )
    _testInterp(self, interp)
end

function testAny(self::AbstractInterpCase)
    interp = win32com_.client.dynamic.Dispatch("Python.Interpreter")
    _testInterp(self, interp)
end

mutable struct ConnectionsTestCase <: AbstractConnectionsTestCase
end
function testConnections(self::AbstractConnectionsTestCase)
    TestConnections()
end

if abspath(PROGRAM_FILE) == @__FILE__
end
