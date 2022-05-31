using Test
using win32com_.test: util

using ext_modules: pythoncom
import win32con
import winerror
import win32clipboard
using win32com_.server.util: NewEnum, wrap
using win32com_.server.exception: COMException
abstract type AbstractTestDataObject end
abstract type AbstractClipboardTester end
IDataObject_Methods = split("GetData GetDataHere QueryGetData\n                         GetCanonicalFormatEtc SetData EnumFormatEtc\n                         DAdvise DUnadvise EnumDAdvise")
num_do_objects = 0
function WrapCOMObject(ob::AbstractClipboardTester, iid = nothing)
return wrap(ob, iid = iid, useDispatcher = 0)
end

mutable struct TestDataObject <: AbstractTestDataObject
bytesval
supported_fe::Vector
_com_interfaces_::Vector
_public_methods_

            TestDataObject(bytesval = bytesval, supported_fe = [], _com_interfaces_::Vector = [pythoncom.IID_IDataObject], _public_methods_ = IDataObject_Methods) = begin
                global num_do_objects
num_do_objects += 1
for cf in (win32con.CF_TEXT, win32con.CF_UNICODETEXT)
fe = (cf, nothing, pythoncom.DVASPECT_CONTENT, -1, pythoncom.TYMED_HGLOBAL)
supported_fe.append(fe)
end
                new(bytesval , supported_fe , _com_interfaces_, _public_methods_ )
            end
end
function __del__(self::AbstractTestDataObject)
global num_do_objects
num_do_objects -= 1
end

function _query_interface_(self::AbstractTestDataObject, iid)
if iid == pythoncom.IID_IEnumFORMATETC
return NewEnum(self.supported_fe, iid = iid)
end
end

function GetData(self::AbstractTestDataObject, fe)
ret_stg = nothing
cf, target, aspect, index, tymed = fe
if aspect & pythoncom.DVASPECT_CONTENT && tymed == pythoncom.TYMED_HGLOBAL
if cf == win32con.CF_TEXT
ret_stg = pythoncom.STGMEDIUM()
set(ret_stg, pythoncom.TYMED_HGLOBAL, self.bytesval)
elseif cf == win32con.CF_UNICODETEXT
ret_stg = pythoncom.STGMEDIUM()
set(ret_stg, pythoncom.TYMED_HGLOBAL, decode(self.bytesval, "latin1"))
end
end
if ret_stg === nothing
throw(COMException(hresult = winerror.E_NOTIMPL))
end
return ret_stg
end

function GetDataHere(self::AbstractTestDataObject, fe)
throw(COMException(hresult = winerror.E_NOTIMPL))
end

function QueryGetData(self::AbstractTestDataObject, fe)
cf, target, aspect, index, tymed = fe
if (aspect & pythoncom.DVASPECT_CONTENT) == 0
throw(COMException(hresult = winerror.DV_E_DVASPECT))
end
if tymed != pythoncom.TYMED_HGLOBAL
throw(COMException(hresult = winerror.DV_E_TYMED))
end
return nothing
end

function GetCanonicalFormatEtc(self::AbstractTestDataObject, fe)
RaiseCOMException(winerror.DATA_S_SAMEFORMATETC)
end

function SetData(self::AbstractTestDataObject, fe, medium)
throw(COMException(hresult = winerror.E_NOTIMPL))
end

function EnumFormatEtc(self::AbstractTestDataObject, direction)
if direction != pythoncom.DATADIR_GET
throw(COMException(hresult = winerror.E_NOTIMPL))
end
return NewEnum(self.supported_fe, iid = pythoncom.IID_IEnumFORMATETC)
end

function DAdvise(self::AbstractTestDataObject, fe, flags, sink)
throw(COMException(hresult = winerror.E_NOTIMPL))
end

function DUnadvise(self::AbstractTestDataObject, connection)
throw(COMException(hresult = winerror.E_NOTIMPL))
end

function EnumDAdvise(self::AbstractTestDataObject)
throw(COMException(hresult = winerror.E_NOTIMPL))
end

mutable struct ClipboardTester <: AbstractClipboardTester

end
function setUp(self::AbstractClipboardTester)
pythoncom.OleInitialize()
end

function tearDown(self::AbstractClipboardTester)
try
pythoncom.OleFlushClipboard()
catch exn
if exn isa pythoncom.com_error
#= pass =#
end
end
end

function testIsCurrentClipboard(self::AbstractClipboardTester)
do_ = TestDataObject(b"Hello from Python")
do_ = WrapCOMObject(do_)
pythoncom.OleSetClipboard(do_)
@test pythoncom.OleIsCurrentClipboard(do_)
end

function testComToWin32(self::AbstractClipboardTester)
do_ = TestDataObject(b"Hello from Python")
do_ = WrapCOMObject(do_)
pythoncom.OleSetClipboard(do_)
win32clipboard.OpenClipboard()
got = win32clipboard.GetClipboardData(win32con.CF_TEXT)
expected = b"Hello from Python"
@test (got == expected)
got = win32clipboard.GetClipboardData(win32con.CF_UNICODETEXT)
@test (got == "Hello from Python")
win32clipboard.CloseClipboard()
end

function testWin32ToCom(self::AbstractClipboardTester)
val = b"Hello again!"
win32clipboard.OpenClipboard()
win32clipboard.SetClipboardData(win32con.CF_TEXT, val)
win32clipboard.CloseClipboard()
do_ = pythoncom.OleGetClipboard()
cf = (win32con.CF_TEXT, nothing, pythoncom.DVASPECT_CONTENT, -1, pythoncom.TYMED_HGLOBAL)
stg = GetData(do_, cf)
got = stg.data
@test got
end

function testDataObjectFlush(self::AbstractClipboardTester)
do_ = TestDataObject(b"Hello from Python")
do_ = WrapCOMObject(do_)
pythoncom.OleSetClipboard(do_)
@test (num_do_objects == 1)
do_ = nothing
pythoncom.OleFlushClipboard()
@test (num_do_objects == 0)
end

function testDataObjectReset(self::AbstractClipboardTester)
do_ = TestDataObject(b"Hello from Python")
do_ = WrapCOMObject(do_)
pythoncom.OleSetClipboard(do_)
do_ = nothing
@test (num_do_objects == 1)
pythoncom.OleSetClipboard(nothing)
@test (num_do_objects == 0)
end

if abspath(PROGRAM_FILE) == @__FILE__
util.testmain()
clipboard_tester = ClipboardTester()
setUp(clipboard_tester)
tearDown(clipboard_tester)
testIsCurrentClipboard(clipboard_tester)
testComToWin32(clipboard_tester)
testWin32ToCom(clipboard_tester)
testDataObjectFlush(clipboard_tester)
testDataObjectReset(clipboard_tester)
end