using StringEncodings
using Test
using _testcapi: INT_MAX

import locale




abstract type AbstractFormatTest end
abstract type AbstractFakeBytes <: object end
maxsize = support.MAX_Py_ssize_t
function testformat(formatstr, args, output = nothing, limit = nothing, overflowok = false)
if verbose
if output
print("$("$(!a) % $(!a) =? $(!a) ...")" )
else
print("$("$(!a) % $(!a) works? ...")" )
end
end
try
result = formatstr % args
catch exn
if exn isa OverflowError
if !(overflowok)
error()
end
if verbose
println("overflow (this is fine)")
end
end
end
end

function testcommon(formatstr, args, output = nothing, limit = nothing, overflowok = false)
if isa(formatstr, str)
testformat(formatstr, args, output, limit, overflowok)
b_format = encode(formatstr, "ascii")
else
b_format = formatstr
end
ba_format = Vector{UInt8}(b_format)
b_args = []
if !isa(args, tuple)
args = (args,)
end
b_args = tuple(args)
if output === nothing
b_output = nothing
ba_output = nothing
else
if isa(output, str)
b_output = encode(output, "ascii")
else
b_output = output
end
ba_output = Vector{UInt8}(b_output)
end
testformat(b_format, b_args, b_output, limit, overflowok)
testformat(ba_format, b_args, ba_output, limit, overflowok)
end

function test_exc(formatstr, args, exception, excmsg)
try
testformat(formatstr, args)
catch exn
 let exc = exn
if exc isa exception
if string(exc) == excmsg
if verbose
println("yes")
end
else
if verbose
println("no")
end
println("Unexpected $(exception):$(repr(string(exc)))")
end
end
end
if verbose
println("no")
end
println("Unexpected exception")
error()
end
end

function test_exc_common(formatstr, args, exception, excmsg)
test_exc(formatstr, args, exception, excmsg)
test_exc(encode(formatstr, "ascii"), args, exception, excmsg)
end

mutable struct FormatTest <: AbstractFormatTest

end
function test_common_format(self)
testcommon("%%", (), "%")
testcommon("%.1d", (1,), "1")
testcommon("%.*d", (sys.maxsize, 1))
testcommon("%.100d", (1,), "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001")
testcommon("%#.117x", (1,), "0x000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001")
testcommon("%#.118x", (1,), "0x0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001")
testcommon("%f", (1.0,), "1.000000")
testcommon("%#.*g", (109, -1e+49 / 3.0))
testcommon("%#.*g", (110, -1e+49 / 3.0))
testcommon("%#.*g", (110, -1e+100 / 3.0))
testcommon("%12.*f", (123456, 1.0))
testcommon("%#.*g", (110, -1e+100 / 3.0))
testcommon("%#.*G", (110, -1e+100 / 3.0))
testcommon("%#.*f", (110, -1e+100 / 3.0))
testcommon("%#.*F", (110, -1e+100 / 3.0))
testcommon("%x", 10, "a")
testcommon("%x", 100000000000, "174876e800")
testcommon("%o", 10, "12")
testcommon("%o", 100000000000, "1351035564000")
testcommon("%d", 10, "10")
testcommon("%d", 100000000000, "100000000000")
big = 123456789012345678901234567890
testcommon("%d", big, "123456789012345678901234567890")
testcommon("%d", -(big), "-123456789012345678901234567890")
testcommon("%5d", -(big), "-123456789012345678901234567890")
testcommon("%31d", -(big), "-123456789012345678901234567890")
testcommon("%32d", -(big), " -123456789012345678901234567890")
testcommon("%-32d", -(big), "-123456789012345678901234567890 ")
testcommon("%032d", -(big), "-0123456789012345678901234567890")
testcommon("%-032d", -(big), "-123456789012345678901234567890 ")
testcommon("%034d", -(big), "-000123456789012345678901234567890")
testcommon("%034d", big, "0000123456789012345678901234567890")
testcommon("%0+34d", big, "+000123456789012345678901234567890")
testcommon("%+34d", big, "   +123456789012345678901234567890")
testcommon("%34d", big, "    123456789012345678901234567890")
testcommon("%.2d", big, "123456789012345678901234567890")
testcommon("%.30d", big, "123456789012345678901234567890")
testcommon("%.31d", big, "0123456789012345678901234567890")
testcommon("%32.31d", big, " 0123456789012345678901234567890")
testcommon("%d", float(big), "123456________________________", 6)
big = 1375488932362216742658885
testcommon("%x", big, "1234567890abcdef12345")
testcommon("%x", -(big), "-1234567890abcdef12345")
testcommon("%5x", -(big), "-1234567890abcdef12345")
testcommon("%22x", -(big), "-1234567890abcdef12345")
testcommon("%23x", -(big), " -1234567890abcdef12345")
testcommon("%-23x", -(big), "-1234567890abcdef12345 ")
testcommon("%023x", -(big), "-01234567890abcdef12345")
testcommon("%-023x", -(big), "-1234567890abcdef12345 ")
testcommon("%025x", -(big), "-0001234567890abcdef12345")
testcommon("%025x", big, "00001234567890abcdef12345")
testcommon("%0+25x", big, "+0001234567890abcdef12345")
testcommon("%+25x", big, "   +1234567890abcdef12345")
testcommon("%25x", big, "    1234567890abcdef12345")
testcommon("%.2x", big, "1234567890abcdef12345")
testcommon("%.21x", big, "1234567890abcdef12345")
testcommon("%.22x", big, "01234567890abcdef12345")
testcommon("%23.22x", big, " 01234567890abcdef12345")
testcommon("%-23.22x", big, "01234567890abcdef12345 ")
testcommon("%X", big, "1234567890ABCDEF12345")
testcommon("%#X", big, "0X1234567890ABCDEF12345")
testcommon("%#x", big, "0x1234567890abcdef12345")
testcommon("%#x", -(big), "-0x1234567890abcdef12345")
testcommon("%#27x", big, "    0x1234567890abcdef12345")
testcommon("%#-27x", big, "0x1234567890abcdef12345    ")
testcommon("%#027x", big, "0x00001234567890abcdef12345")
testcommon("%#.23x", big, "0x001234567890abcdef12345")
testcommon("%#.23x", -(big), "-0x001234567890abcdef12345")
testcommon("%#27.23x", big, "  0x001234567890abcdef12345")
testcommon("%#-27.23x", big, "0x001234567890abcdef12345  ")
testcommon("%#027.23x", big, "0x00001234567890abcdef12345")
testcommon("%#+.23x", big, "+0x001234567890abcdef12345")
testcommon("%# .23x", big, " 0x001234567890abcdef12345")
testcommon("%#+.23X", big, "+0X001234567890ABCDEF12345")
testcommon("%#+027.23X", big, "+0X0001234567890ABCDEF12345")
testcommon("%# 027.23X", big, " 0X0001234567890ABCDEF12345")
testcommon("%#+27.23X", big, " +0X001234567890ABCDEF12345")
testcommon("%#-+27.23x", big, "+0x001234567890abcdef12345 ")
testcommon("%#- 27.23x", big, " 0x001234567890abcdef12345 ")
big = 12935167030485801517351291832
testcommon("%o", big, "12345670123456701234567012345670")
testcommon("%o", -(big), "-12345670123456701234567012345670")
testcommon("%5o", -(big), "-12345670123456701234567012345670")
testcommon("%33o", -(big), "-12345670123456701234567012345670")
testcommon("%34o", -(big), " -12345670123456701234567012345670")
testcommon("%-34o", -(big), "-12345670123456701234567012345670 ")
testcommon("%034o", -(big), "-012345670123456701234567012345670")
testcommon("%-034o", -(big), "-12345670123456701234567012345670 ")
testcommon("%036o", -(big), "-00012345670123456701234567012345670")
testcommon("%036o", big, "000012345670123456701234567012345670")
testcommon("%0+36o", big, "+00012345670123456701234567012345670")
testcommon("%+36o", big, "   +12345670123456701234567012345670")
testcommon("%36o", big, "    12345670123456701234567012345670")
testcommon("%.2o", big, "12345670123456701234567012345670")
testcommon("%.32o", big, "12345670123456701234567012345670")
testcommon("%.33o", big, "012345670123456701234567012345670")
testcommon("%34.33o", big, " 012345670123456701234567012345670")
testcommon("%-34.33o", big, "012345670123456701234567012345670 ")
testcommon("%o", big, "12345670123456701234567012345670")
testcommon("%#o", big, "0o12345670123456701234567012345670")
testcommon("%#o", -(big), "-0o12345670123456701234567012345670")
testcommon("%#38o", big, "    0o12345670123456701234567012345670")
testcommon("%#-38o", big, "0o12345670123456701234567012345670    ")
testcommon("%#038o", big, "0o000012345670123456701234567012345670")
testcommon("%#.34o", big, "0o0012345670123456701234567012345670")
testcommon("%#.34o", -(big), "-0o0012345670123456701234567012345670")
testcommon("%#38.34o", big, "  0o0012345670123456701234567012345670")
testcommon("%#-38.34o", big, "0o0012345670123456701234567012345670  ")
testcommon("%#038.34o", big, "0o000012345670123456701234567012345670")
testcommon("%#+.34o", big, "+0o0012345670123456701234567012345670")
testcommon("%# .34o", big, " 0o0012345670123456701234567012345670")
testcommon("%#+38.34o", big, " +0o0012345670123456701234567012345670")
testcommon("%#-+38.34o", big, "+0o0012345670123456701234567012345670 ")
testcommon("%#- 38.34o", big, " 0o0012345670123456701234567012345670 ")
testcommon("%#+038.34o", big, "+0o00012345670123456701234567012345670")
testcommon("%# 038.34o", big, " 0o00012345670123456701234567012345670")
testcommon("%.33o", big, "012345670123456701234567012345670")
testcommon("%#.33o", big, "0o012345670123456701234567012345670")
testcommon("%#.32o", big, "0o12345670123456701234567012345670")
testcommon("%035.33o", big, "00012345670123456701234567012345670")
testcommon("%0#35.33o", big, "0o012345670123456701234567012345670")
testcommon("%d", 42, "42")
testcommon("%d", -42, "-42")
testcommon("%d", 42.0, "42")
testcommon("%#x", 1, "0x1")
testcommon("%#X", 1, "0X1")
testcommon("%#o", 1, "0o1")
testcommon("%#o", 0, "0o0")
testcommon("%o", 0, "0")
testcommon("%d", 0, "0")
testcommon("%#x", 0, "0x0")
testcommon("%#X", 0, "0X0")
testcommon("%x", 66, "42")
testcommon("%x", -66, "-42")
testcommon("%o", 34, "42")
testcommon("%o", -34, "-42")
testcommon("%g", 1.1, "1.1")
testcommon("%#g", 1.1, "1.10000")
if verbose
println("Testing exceptions")
end
test_exc_common("%", (), ValueError, "incomplete format")
test_exc_common("% %s", 1, ValueError, "unsupported format character \'%\' (0x25) at index 2")
test_exc_common("%d", "1", TypeError, "%d format: a real number is required, not str")
test_exc_common("%d", b"1", TypeError, "%d format: a real number is required, not bytes")
test_exc_common("%x", "1", TypeError, "%x format: an integer is required, not str")
test_exc_common("%x", 3.14, TypeError, "%x format: an integer is required, not float")
end

function test_str_format(self)
testformat("%r", "͸", "\'\\u0378\'")
testformat("%a", "͸", "\'\\u0378\'")
testformat("%r", "ʹ", "\'ʹ\'")
testformat("%a", "ʹ", "\'\\u0374\'")
if verbose
println("Testing exceptions")
end
test_exc("abc %b", 1, ValueError, "unsupported format character \'b\' (0x62) at index 5")
test_exc("%g", "1", TypeError, "must be real number, not str")
test_exc("no format", "1", TypeError, "not all arguments converted during string formatting")
test_exc("%c", -1, OverflowError, "%c arg not in range(0x110000)")
test_exc("%c", sys.maxunicode + 1, OverflowError, "%c arg not in range(0x110000)")
test_exc("%c", 3.14, TypeError, "%c requires int or char")
test_exc("%c", "ab", TypeError, "%c requires int or char")
test_exc("%c", b"x", TypeError, "%c requires int or char")
if maxsize == (2^31 - 1)
try
"%*d" % (maxsize, -127)
catch exn
if exn isa MemoryError
#= pass =#
end
end
end
end

function test_bytes_and_bytearray_format(self)
testcommon(b"%c", 7, b"\x07")
testcommon(b"%c", b"Z", b"Z")
testcommon(b"%c", Vector{UInt8}(b"Z"), b"Z")
testcommon(b"%5c", 65, b"    A")
testcommon(b"%-5c", 65, b"A    ")
mutable struct FakeBytes <: AbstractFakeBytes

end
function __bytes__(self)::Array{UInt8}
return b"123"
end

fb = FakeBytes()
testcommon(b"%b", b"abc", b"abc")
testcommon(b"%b", Vector{UInt8}(b"def"), b"def")
testcommon(b"%b", fb, b"123")
testcommon(b"%b", memoryview(b"abc"), b"abc")
testcommon(b"%s", b"abc", b"abc")
testcommon(b"%s", Vector{UInt8}(b"def"), b"def")
testcommon(b"%s", fb, b"123")
testcommon(b"%s", memoryview(b"abc"), b"abc")
testcommon(b"%a", 3.14, b"3.14")
testcommon(b"%a", b"ghi", b"b'ghi'")
testcommon(b"%a", "jkl", b"'jkl'")
testcommon(b"%a", "Մ", b"'\\u0544'")
testcommon(b"%r", 3.14, b"3.14")
testcommon(b"%r", b"ghi", b"b'ghi'")
testcommon(b"%r", "jkl", b"'jkl'")
testcommon(b"%r", "Մ", b"'\\u0544'")
if verbose
println("Testing exceptions")
end
test_exc(b"%g", "1", TypeError, "float argument required, not str")
test_exc(b"%g", b"1", TypeError, "float argument required, not bytes")
test_exc(b"no format", 7, TypeError, "not all arguments converted during bytes formatting")
test_exc(b"no format", b"1", TypeError, "not all arguments converted during bytes formatting")
test_exc(b"no format", Vector{UInt8}(b"1"), TypeError, "not all arguments converted during bytes formatting")
test_exc(b"%c", -1, OverflowError, "%c arg not in range(256)")
test_exc(b"%c", 256, OverflowError, "%c arg not in range(256)")
test_exc(b"%c", 2^128, OverflowError, "%c arg not in range(256)")
test_exc(b"%c", b"Za", TypeError, "%c requires an integer in range(256) or a single byte")
test_exc(b"%c", "Y", TypeError, "%c requires an integer in range(256) or a single byte")
test_exc(b"%c", 3.14, TypeError, "%c requires an integer in range(256) or a single byte")
test_exc(b"%b", "Xc", TypeError, "%b requires a bytes-like object, or an object that implements __bytes__, not \'str\'")
test_exc(b"%s", "Wd", TypeError, "%b requires a bytes-like object, or an object that implements __bytes__, not \'str\'")
if maxsize == (2^31 - 1)
try
"%*d" % (maxsize, -127)
catch exn
if exn isa MemoryError
#= pass =#
end
end
end
end

function test_nul(self)
testcommon("a\0b", (), "a\0b")
testcommon("a%cb", (0,), "a\0b")
testformat("a%sb", ("c\0d",), "ac\0db")
testcommon(b"a%sb", (b"c\x00d",), b"ac\x00db")
end

function test_non_ascii(self)
testformat("€=%f", (1.0,), "€=1.000000")
@test ("abc" == "abc  ")
@test (123 == "123  ")
@test (12.3 == "12.3  ")
@test (0im == "0j  ")
@test (1 + 2im == "(1+2j)  ")
@test ("abc" == "  abc")
@test (123 == "  123")
@test (12.3 == "  12.3")
@test (1 + 2im == "  (1+2j)")
@test (0im == "  0j")
@test ("abc" == " abc ")
@test (123 == " 123 ")
@test (12.3 == " 12.3 ")
@test (1 + 2im == " (1+2j) ")
@test (0im == " 0j ")
end

function test_locale(self)
try
oldloc = setlocale(locale.LC_ALL)
setlocale(locale.LC_ALL, "")
catch exn
 let err = exn
if err isa locale.Error
skipTest(self, "Cannot set locale: $()")
end
end
end
try
localeconv = localeconv()
sep = localeconv["thousands_sep"]
point = localeconv["decimal_point"]
grouping = localeconv["grouping"]
text = 123456789
if grouping
assertIn(self, sep, text)
end
@test (replace(text, sep, "") == "123456789")
text = 1234.5
if grouping
assertIn(self, sep, text)
end
assertIn(self, point, text)
@test (replace(text, sep, "") == ("1234" + point) * "5")
finally
setlocale(locale.LC_ALL, oldloc)
end
end

function test_optimisations(self)
text = "abcde"
assertIs(self, "%s" % text, text)
assertIs(self, "%.5s" % text, text)
assertIs(self, "%.10s" % text, text)
assertIs(self, "%1s" % text, text)
assertIs(self, "%5s" % text, text)
assertIs(self, "$(text)", text)
assertIs(self, "$(text:s)", text)
assertIs(self, "$(text:.5s)", text)
assertIs(self, "$(text:.10s)", text)
assertIs(self, "$(text:1s)", text)
assertIs(self, "$(text:5s)", text)
assertIs(self, text % (), text)
assertIs(self, text, text)
end

function test_precision(self)
f = 1.2
@test (f == "1")
@test (f == "1.200")
assertRaises(self, ValueError) do cm 
f
end
c = complex(f)
@test (c == "1+0j")
@test (c == "1.200+0.000j")
assertRaises(self, ValueError) do cm 
c
end
end

function test_precision_c_limits(self)
f = 1.2
assertRaises(self, ValueError) do cm 
f
end
c = complex(f)
assertRaises(self, ValueError) do cm 
c
end
end

function test_g_format_has_no_trailing_zeros(self)
@test ("%.3g" % 1505.0 == "1.5e+03")
@test ("%#.3g" % 1505.0 == "1.50e+03")
@test (1505.0 == "1.5e+03")
@test (1505.0 == "1.50e+03")
@test (12300050.0 == "1.23e+07")
@test (12300050.0 == "1.23000e+07")
end

function test_with_two_commas_in_format_specifier(self)
error_msg = escape("Cannot specify \',\' with \',\'.")
assertRaisesRegex(self, ValueError, error_msg) do 
"$(:,,)"
end
end

function test_with_two_underscore_in_format_specifier(self)
error_msg = escape("Cannot specify \'_\' with \'_\'.")
assertRaisesRegex(self, ValueError, error_msg) do 
"$(:__)"
end
end

function test_with_a_commas_and_an_underscore_in_format_specifier(self)
error_msg = escape("Cannot specify both \',\' and \'_\'.")
assertRaisesRegex(self, ValueError, error_msg) do 
"$(:,_)"
end
end

function test_with_an_underscore_and_a_comma_in_format_specifier(self)
error_msg = escape("Cannot specify both \',\' and \'_\'.")
assertRaisesRegex(self, ValueError, error_msg) do 
"$(:_,)"
end
end

if abspath(PROGRAM_FILE) == @__FILE__
format_test = FormatTest()
test_common_format(format_test)
test_str_format(format_test)
test_bytes_and_bytearray_format(format_test)
test_nul(format_test)
test_non_ascii(format_test)
test_locale(format_test)
test_optimisations(format_test)
test_precision(format_test)
test_precision_c_limits(format_test)
test_g_format_has_no_trailing_zeros(format_test)
test_with_two_commas_in_format_specifier(format_test)
test_with_two_underscore_in_format_specifier(format_test)
test_with_a_commas_and_an_underscore_in_format_specifier(format_test)
test_with_an_underscore_and_a_comma_in_format_specifier(format_test)
end