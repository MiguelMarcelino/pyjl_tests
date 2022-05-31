using PyCall
datetime = pyimport("datetime")
pywintypes = pyimport("pywintypes")
import tempfile



import copy

import win32timezone
try
sys_maxsize = sys.maxsize
catch exn
if exn isa AttributeError
sys_maxsize = sys.maxint
end
end
import win32con
using ext_modules: pythoncom

using win32com_.shell: shell
using win32com_.shell.shellcon: *
using win32com_.storagecon: *
import win32com_.test.util
abstract type AbstractShellTester <: win32com_.test.util.TestCase end
abstract type AbstractPIDLTester <: win32com_.test.util.TestCase end
abstract type AbstractFILEGROUPDESCRIPTORTester <: win32com_.test.util.TestCase end
abstract type AbstractFileOperationTester <: win32com_.test.util.TestCase end
using pywin32_testutil: str2bytes
mutable struct ShellTester <: AbstractShellTester

end
function testShellLink(self::AbstractShellTester)
desktop = string(shell.SHGetSpecialFolderPath(0, CSIDL_DESKTOP))
num = 0
shellLink = pythoncom.CoCreateInstance(shell.CLSID_ShellLink, nothing, pythoncom.CLSCTX_INPROC_SERVER, shell.IID_IShellLink)
persistFile = QueryInterface(shellLink, pythoncom.IID_IPersistFile)
names = [joinpath(desktop, n) for n in os.listdir(desktop)]
programs = string(shell.SHGetSpecialFolderPath(0, CSIDL_PROGRAMS))
extend(names, [joinpath(programs, n) for n in os.listdir(programs)])
for name in names
try
Load(persistFile, name, STGM_READ)
catch exn
if exn isa pythoncom.com_error
continue;
end
end
fname, findData = GetPath(shellLink, 0)
unc = GetPath(shellLink, shell.SLGP_UNCPRIORITY)[1]
num += 1
end
if num == 0
println("Could not find any links on your desktop or programs dir, which is unusual")
end
end

function testShellFolder(self::AbstractShellTester)
sf = shell.SHGetDesktopFolder()
names_1 = []
for i in sf
name = GetDisplayNameOf(sf, i, SHGDN_NORMAL)
push!(names_1, name)
end
enum = EnumObjects(sf, 0, (SHCONTF_FOLDERS | SHCONTF_NONFOLDERS) | SHCONTF_INCLUDEHIDDEN)
names_2 = []
for i in enum
name = GetDisplayNameOf(sf, i, SHGDN_NORMAL)
push!(names_2, name)
end
sort(names_1)
sort(names_2)
assertEqual(self, names_1, names_2)
end

mutable struct PIDLTester <: AbstractPIDLTester

end
function _rtPIDL(self::AbstractPIDLTester, pidl)
pidl_str = shell.PIDLAsString(pidl)
pidl_rt = shell.StringAsPIDL(pidl_str)
assertEqual(self, pidl_rt, pidl)
pidl_str_rt = shell.PIDLAsString(pidl_rt)
assertEqual(self, pidl_str_rt, pidl_str)
end

function _rtCIDA(self::AbstractPIDLTester, parent, kids)
cida = (parent, kids)
cida_str = shell.CIDAAsString(cida)
cida_rt = shell.StringAsCIDA(cida_str)
assertEqual(self, cida, cida_rt)
cida_str_rt = shell.CIDAAsString(cida_rt)
assertEqual(self, cida_str_rt, cida_str)
end

function testPIDL(self::AbstractPIDLTester)
expect = str2bytes("\0\0\0")
assertEqual(self, shell.PIDLAsString([str2bytes("")]), expect)
_rtPIDL(self, [str2bytes("\0")])
_rtPIDL(self, [str2bytes(""), str2bytes(""), str2bytes("")])
_rtPIDL(self, repeat([str2bytes("\0")*2048],2048))
assertRaises(self, TypeError, shell.PIDLAsString, "foo")
end

function testCIDA(self::AbstractPIDLTester)
_rtCIDA(self, [str2bytes("\0")], [[str2bytes("\0")]])
_rtCIDA(self, [str2bytes("")], [[str2bytes("")]])
_rtCIDA(self, [str2bytes("\0")], [[str2bytes("\0")], [str2bytes("")], [str2bytes("")]])
end

function testBadShortPIDL(self::AbstractPIDLTester)
pidl = str2bytes("\0")
assertRaises(self, ValueError, shell.StringAsPIDL, pidl)
end

mutable struct FILEGROUPDESCRIPTORTester <: AbstractFILEGROUPDESCRIPTORTester

end
function _getTestTimes(self::AbstractFILEGROUPDESCRIPTORTester)::Tuple
if pywintypes.TimeType <: datetime.datetime
ctime = win32timezone.now()
ctime = replace(ctime, microsecond = (ctime.microsecond ÷ 1000)*1000)
atime = ctime + datetime.timedelta(seconds = 1)
wtime = atime + datetime.timedelta(seconds = 1)
else
ctime = pywintypes.Time(11)
atime = pywintypes.Time(12)
wtime = pywintypes.Time(13)
end
return (ctime, atime, wtime)
end

function _testRT(self::AbstractFILEGROUPDESCRIPTORTester, fd)
fgd_string = shell.FILEGROUPDESCRIPTORAsString([fd])
fd2 = shell.StringAsFILEGROUPDESCRIPTOR(fgd_string)[1]
fd = copy(fd)
fd2 = copy(fd2)
if "dwFlags" ∉ fd
#Delete Unsupported
del(fd2)
end
if "cFileName" ∉ fd
assertEqual(self, fd2["cFileName"], "")
#Delete Unsupported
del(fd2)
end
assertEqual(self, fd, fd2)
end

function _testSimple(self::AbstractFILEGROUPDESCRIPTORTester, make_unicode)
fgd = shell.FILEGROUPDESCRIPTORAsString([], make_unicode)
header = struct_.pack("i", 0)
assertEqual(self, header, fgd[begin:length(header)])
_testRT(self, dict())
d = dict()
fgd = shell.FILEGROUPDESCRIPTORAsString([d], make_unicode)
header = struct_.pack("i", 1)
assertEqual(self, header, fgd[begin:length(header)])
_testRT(self, d)
end

function testSimpleBytes(self::AbstractFILEGROUPDESCRIPTORTester)
_testSimple(self, false)
end

function testSimpleUnicode(self::AbstractFILEGROUPDESCRIPTORTester)
_testSimple(self, true)
end

function testComplex(self::AbstractFILEGROUPDESCRIPTORTester)
clsid = pythoncom.MakeIID("{CD637886-DB8B-4b04-98B5-25731E1495BE}")
ctime, atime, wtime = _getTestTimes(self)
d = dict(cFileName = "foo.txt", clsid = clsid, sizel = (1, 2), pointl = (3, 4), dwFileAttributes = win32con.FILE_ATTRIBUTE_NORMAL, ftCreationTime = ctime, ftLastAccessTime = atime, ftLastWriteTime = wtime, nFileSize = sys_maxsize + 1)
_testRT(self, d)
end

function testUnicode(self::AbstractFILEGROUPDESCRIPTORTester)
ctime, atime, wtime = _getTestTimes(self)
d = [dict(cFileName = "foo.txt", sizel = (1, 2), pointl = (3, 4), dwFileAttributes = win32con.FILE_ATTRIBUTE_NORMAL, ftCreationTime = ctime, ftLastAccessTime = atime, ftLastWriteTime = wtime, nFileSize = sys_maxsize + 1), dict(cFileName = "foo2.txt", sizel = (1, 2), pointl = (3, 4), dwFileAttributes = win32con.FILE_ATTRIBUTE_NORMAL, ftCreationTime = ctime, ftLastAccessTime = atime, ftLastWriteTime = wtime, nFileSize = sys_maxsize + 1), dict(cFileName = "foo©.txt", sizel = (1, 2), pointl = (3, 4), dwFileAttributes = win32con.FILE_ATTRIBUTE_NORMAL, ftCreationTime = ctime, ftLastAccessTime = atime, ftLastWriteTime = wtime, nFileSize = sys_maxsize + 1)]
s = shell.FILEGROUPDESCRIPTORAsString(d, 1)
d2 = shell.StringAsFILEGROUPDESCRIPTOR(s)
for t in d2
#Delete Unsupported
del(t)
end
assertEqual(self, d, d2)
end

mutable struct FileOperationTester <: AbstractFileOperationTester
src_name
dest_name
test_data
end
function setUp(self::AbstractFileOperationTester)
self.src_name = joinpath(tempfile.gettempdir(), "pywin32_testshell")
self.dest_name = joinpath(tempfile.gettempdir(), "pywin32_testshell_dest")
self.test_data = str2bytes("Hello from\0Python")
f = readline(self.src_name)
write(f, self.test_data)
close(f)
try
rm(self.dest_name)
catch exn
if exn isa os.error
#= pass =#
end
end
end

function tearDown(self::AbstractFileOperationTester)
for fname in (self.src_name, self.dest_name)
if isfile(fname)
rm(fname)
end
end
end

function testCopy(self::AbstractFileOperationTester)
s = (0, FO_COPY, self.src_name, self.dest_name)
rc, aborted = shell.SHFileOperation(s)
assertTrue(self, !(aborted))
assertEqual(self, 0, rc)
assertTrue(self, isfile(self.src_name))
assertTrue(self, isfile(self.dest_name))
end

function testRename(self::AbstractFileOperationTester)
s = (0, FO_RENAME, self.src_name, self.dest_name)
rc, aborted = shell.SHFileOperation(s)
assertTrue(self, !(aborted))
assertEqual(self, 0, rc)
assertTrue(self, isfile(self.dest_name))
assertTrue(self, !isfile(self.src_name))
end

function testMove(self::AbstractFileOperationTester)
s = (0, FO_MOVE, self.src_name, self.dest_name)
rc, aborted = shell.SHFileOperation(s)
assertTrue(self, !(aborted))
assertEqual(self, 0, rc)
assertTrue(self, isfile(self.dest_name))
assertTrue(self, !isfile(self.src_name))
end

function testDelete(self::AbstractFileOperationTester)
s = (0, FO_DELETE, self.src_name, nothing, FOF_NOCONFIRMATION)
rc, aborted = shell.SHFileOperation(s)
assertTrue(self, !(aborted))
assertEqual(self, 0, rc)
assertTrue(self, !isfile(self.src_name))
end

if abspath(PROGRAM_FILE) == @__FILE__
win32com_.test.util.testmain()
end