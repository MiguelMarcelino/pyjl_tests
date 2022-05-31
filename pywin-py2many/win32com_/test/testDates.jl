using PyCall
pywintypes = pyimport("pywintypes")
datetime = pyimport("datetime")



import win32com_.client
import win32com_.test.util
import win32com_.server.util
using win32timezone: TimeZoneInfo
abstract type AbstractTester end
abstract type AbstractTestCase <: win32com_.test.util.TestCase end
mutable struct Tester <: AbstractTester
_public_methods_::Vector{String}
end
function TestDate(self::AbstractTester, d)
@assert(isa(d, datetime))
return d
end

function test_ob()
return win32com_.client.Dispatch(win32com_.server.util.wrap(Tester()))
end

mutable struct TestCase <: AbstractTestCase

end
function check(self::AbstractTestCase, d, expected = nothing)
if !pywintypes.TimeType <: datetime
skipTest(self, "this is testing pywintypes and datetime")
end
got = TestDate(test_ob(), d)
assertEqual(self, got, expected || d)
end

function testUTC(self::AbstractTestCase)
check(self, datetime(year = 2000, month = 12, day = 25, microsecond = 500000, tzinfo = TimeZoneInfo.utc()))
end

function testLocal(self::AbstractTestCase)
check(self, datetime(year = 2000, month = 12, day = 25, microsecond = 500000, tzinfo = TimeZoneInfo.local()))
end

function testMSTruncated(self::AbstractTestCase)
check(self, datetime(year = 2000, month = 12, day = 25, microsecond = 500500, tzinfo = TimeZoneInfo.utc()), datetime(year = 2000, month = 12, day = 25, microsecond = 500000, tzinfo = TimeZoneInfo.utc()))
end

if abspath(PROGRAM_FILE) == @__FILE__
end