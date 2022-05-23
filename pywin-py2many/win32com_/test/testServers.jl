using PyCall
pythoncom = pyimport("pythoncom")
import win32com_.demos.connect
using win32com_.test.util: RegisterPythonServer
using win32com_.servers: interp
import win32com_.client.dynamic
import winerror
import win32com_.test.util

abstract type AbstractInterpCase <: win32com_.test.util.TestCase end
abstract type AbstractConnectionsTestCase <: win32com_.test.util.TestCase end
function TestConnections()
    win32com_.demos.connect.test()
end

mutable struct InterpCase <: AbstractInterpCase

end
function setUp(self::InterpCase)
    RegisterPythonServer(interp.__file__, "Python.Interpreter")
end

function _testInterp(self::InterpCase, interp)
    assertEqual(self, interp.Eval("1+1"), 2)
    win32com_.test.util.assertRaisesCOM_HRESULT(
        self,
        winerror.DISP_E_TYPEMISMATCH,
        interp.Eval,
        2,
    )
end

function testInproc(self::InterpCase)
    interp =
        win32com_.client.dynamic.Dispatch("Python.Interpreter", pythoncom.CLSCTX_INPROC)
    _testInterp(self, interp)
end

function testLocalServer(self::InterpCase)
    interp = win32com_.client.dynamic.Dispatch(
        "Python.Interpreter",
        pythoncom.CLSCTX_LOCAL_SERVER,
    )
    _testInterp(self, interp)
end

function testAny(self::InterpCase)
    interp = win32com_.client.dynamic.Dispatch("Python.Interpreter")
    _testInterp(self, interp)
end

mutable struct ConnectionsTestCase <: AbstractConnectionsTestCase

end
function testConnections(self::ConnectionsTestCase)
    TestConnections()
end

if abspath(PROGRAM_FILE) == @__FILE__
end
