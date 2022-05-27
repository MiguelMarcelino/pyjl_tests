#= Test the binascii C module. =#
using StringEncodings
using Test





abstract type AbstractBinASCIITest end
abstract type AbstractArrayBinASCIITest <: AbstractBinASCIITest end
abstract type AbstractBytearrayBinASCIITest <: AbstractBinASCIITest end
abstract type AbstractMemoryviewBinASCIITest <: AbstractBinASCIITest end
abstract type AbstractChecksumBigBufferTestCase end
b2a_functions = ["b2a_base64", "b2a_hex", "b2a_hqx", "b2a_qp", "b2a_uu", "hexlify", "rlecode_hqx"]
a2b_functions = ["a2b_base64", "a2b_hex", "a2b_hqx", "a2b_qp", "a2b_uu", "unhexlify", "rledecode_hqx"]
all_functions = append!(append!(a2b_functions, b2a_functions), ["crc32", "crc_hqx"])
mutable struct BinASCIITest <: AbstractBinASCIITest
data
rawdata::Array{UInt8}
type2test

                    BinASCIITest(data, rawdata::Array{UInt8} = b"The quick brown fox jumps over the lazy dog.\r\n", type2test = bytes) =
                        new(data, rawdata, type2test)
end
function setUp(self::BinASCIITest)
self.data = type2test(self, self.rawdata)
end

function test_exceptions(self::BinASCIITest)
@test binascii.Error <: Exception
@test binascii.Incomplete <: Exception
end

function test_functions(self::BinASCIITest)
for name in all_functions
@test hasfield(typeof(getfield(binascii, :name)), :__call__)
@test_throws TypeError getfield(binascii, :name)()
end
end

function test_returned_value(self::BinASCIITest)
MAX_ALL = 45
raw = self.rawdata[begin:MAX_ALL]
for (fa, fb) in zip(a2b_functions, b2a_functions)
a2b = getfield(binascii, :fa)
b2a = getfield(binascii, :fb)
try
a = b2a(type2test(self, raw))
res = a2b(type2test(self, a))
catch exn
 let err = exn
if err isa Exception
fail(self, "$()/$() conversion raises $(!r)")
end
end
end
if fb == "b2a_hqx"
res, _ = res
end
@test (res == raw)
@test isa(self, res)
@test isa(self, a)
assertLess(self, max(a), 128)
end
@test isa(self, crc_hqx(raw, 0))
@test isa(self, crc32(raw))
end

function test_base64valid(self::BinASCIITest)
MAX_BASE64 = 57
lines = []
for i in 0:MAX_BASE64:length(self.rawdata) - 1
b = type2test(self, self.rawdata[i + 1:i + MAX_BASE64])
a = b2a_base64(b)
push!(lines, a)
end
res = bytes()
for line in lines
a = type2test(self, line)
b = a2b_base64(a)
res += b
end
@test (res == self.rawdata)
end

function test_base64invalid(self::BinASCIITest)
MAX_BASE64 = 57
lines = []
for i in 0:MAX_BASE64:length(self.data) - 1
b = type2test(self, self.rawdata[i + 1:i + MAX_BASE64])
a = b2a_base64(b)
push!(lines, a)
end
fillers = Vector{UInt8}()
valid = b"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789+/"
for i in 0:255
if i ∉ valid
append(fillers, i)
end
end
function addnoise(line)::Vector{Int8}
noise = fillers
ratio = length(line) ÷ length(noise)
res = Vector{UInt8}()
while line && noise
if (length(line) ÷ length(noise)) > ratio
c, line = (line[1], line[2:end])
else
c, noise = (noise[1], noise[2:end])
end
append(res, c)
end
return append!(res, noise) + line
end

res = Vector{UInt8}()
for line in map(addnoise, lines)
a = type2test(self, line)
b = a2b_base64(a)
res += b
end
@test (res == self.rawdata)
@test (a2b_base64(type2test(self, fillers)) == b"")
end

function test_base64errors(self::BinASCIITest)
function assertIncorrectPadding(data)
assertRaisesRegex(self, binascii.Error, "(?i)Incorrect padding") do 
a2b_base64(type2test(self, data))
end
end

assertIncorrectPadding(b"ab")
assertIncorrectPadding(b"ab=")
assertIncorrectPadding(b"abc")
assertIncorrectPadding(b"abcdef")
assertIncorrectPadding(b"abcdef=")
assertIncorrectPadding(b"abcdefg")
assertIncorrectPadding(b"a=b=")
assertIncorrectPadding(b"a\nb=")
function assertInvalidLength(data)
n_data_chars = length(sub(b"[^A-Za-z0-9/+]", b"", data))
expected_errmsg_re = "(?i)Invalid.+number of data characters.+" * string(n_data_chars)
assertRaisesRegex(self, binascii.Error, expected_errmsg_re) do 
a2b_base64(type2test(self, data))
end
end

assertInvalidLength(b"a")
assertInvalidLength(b"a=")
assertInvalidLength(b"a==")
assertInvalidLength(b"a===")
assertInvalidLength(repeat(b"a",5))
assertInvalidLength(repeat(b"a",(4*87 + 1)))
assertInvalidLength(b"A\tB\nC ??DE")
end

function test_uu(self::BinASCIITest)
MAX_UU = 45
for backtick in (true, false)
lines = []
for i in 0:MAX_UU:length(self.data) - 1
b = type2test(self, self.rawdata[i + 1:i + MAX_UU])
a = b2a_uu(b, backtick)
push!(lines, a)
end
res = bytes()
for line in lines
a = type2test(self, line)
b = a2b_uu(a)
res += b
end
@test (res == self.rawdata)
end
@test (a2b_uu(b"\x7f") == repeat(b"\x00",31))
@test (a2b_uu(b"\x80") == repeat(b"\x00",32))
@test (a2b_uu(b"\xff") == repeat(b"\x00",31))
@test_throws binascii.Error binascii.a2b_uu(b"\xff\x00")
@test_throws binascii.Error binascii.a2b_uu(b"!!!!")
@test_throws binascii.Error binascii.b2a_uu(repeat(b"!",46))
@test (b2a_uu(b"x") == b"!>   \n")
@test (b2a_uu(b"") == b" \n")
@test (b2a_uu(b"", true) == b"`\n")
@test (a2b_uu(b" \n") == b"")
@test (a2b_uu(b"`\n") == b"")
@test (b2a_uu(b"\x00Cat") == b"$ $-A=   \n")
@test (b2a_uu(b"\x00Cat", true) == b"$`$-A=```\n")
@test (a2b_uu(b"$`$-A=```\n") == a2b_uu(b"$ $-A=   \n"))
assertRaises(self, TypeError) do 
b2a_uu(b"", true)
end
end

function test_crc_hqx(self::BinASCIITest)
crc = crc_hqx(type2test(self, b"Test the CRC-32 of"), 0)
crc = crc_hqx(type2test(self, b" this string."), crc)
@test (crc == 14290)
@test_throws TypeError binascii.crc_hqx()
@test_throws TypeError binascii.crc_hqx(type2test(self, b""))
for crc in (0, 1, 4660, 74565, 305419896, -1)
@test (crc_hqx(type2test(self, b""), crc) == crc & 65535)
end
end

function test_crc32(self::BinASCIITest)
crc = crc32(type2test(self, b"Test the CRC-32 of"))
crc = crc32(type2test(self, b" this string."), crc)
@test (crc == 1571220330)
@test_throws TypeError binascii.crc32()
end

function test_hqx(self::BinASCIITest)
rle = rlecode_hqx(self.data)
a = b2a_hqx(type2test(self, rle))
b, _ = a2b_hqx(type2test(self, a))
res = rledecode_hqx(b)
@test (res == self.rawdata)
end

function test_rle(self::BinASCIITest)
data = append!(append!(repeat(b"a",100), b"b"), repeat(b"c",300))
encoded = rlecode_hqx(data)
@test (encoded == b"a\x90dbc\x90\xffc\x90-")
decoded = rledecode_hqx(encoded)
@test (decoded == data)
end

function test_hex(self::BinASCIITest)
s = b"{s\x05\x00\x00\x00worldi\x02\x00\x00\x00s\x05\x00\x00\x00helloi\x01\x00\x00\x000"
t = b2a_hex(type2test(self, s))
u = a2b_hex(type2test(self, t))
@test (s == u)
@test_throws binascii.Error binascii.a2b_hex(t[begin:-1])
@test_throws binascii.Error binascii.a2b_hex(t[begin:-1] + b"q")
@test_throws binascii.Error binascii.a2b_hex(bytes([255, 255]))
@test_throws binascii.Error binascii.a2b_hex(b"0G")
@test_throws binascii.Error binascii.a2b_hex(b"0g")
@test_throws binascii.Error binascii.a2b_hex(b"G0")
@test_throws binascii.Error binascii.a2b_hex(b"g0")
@test (hexlify(type2test(self, s)) == t)
@test (unhexlify(type2test(self, t)) == u)
end

function test_hex_separator(self::BinASCIITest)
#= Test that hexlify and b2a_hex are binary versions of bytes.hex. =#
s = b"{s\x05\x00\x00\x00worldi\x02\x00\x00\x00s\x05\x00\x00\x00helloi\x01\x00\x00\x000"
@test (hexlify(type2test(self, s)) == encode(hex(s), "ascii"))
expected8 = encode(hex(s, ".", 8), "ascii")
@test (hexlify(type2test(self, s), ".", 8) == expected8)
expected1 = encode(hex(s, ":"), "ascii")
@test (b2a_hex(type2test(self, s), ":") == expected1)
end

function test_qp(self::BinASCIITest)
type2test = self.type2test
a2b_qp = binascii.a2b_qp
b2a_qp = binascii.b2a_qp
a2b_qp(b"", false)
try
a2b_qp(b"", Dict(1 => 1))
catch exn
if exn isa TypeError
#= pass =#
end
end
@test (a2b_qp(type2test(b"=")) == b"")
@test (a2b_qp(type2test(b"= ")) == b"= ")
@test (a2b_qp(type2test(b"==")) == b"=")
@test (a2b_qp(type2test(b"=\nAB")) == b"AB")
@test (a2b_qp(type2test(b"=\r\nAB")) == b"AB")
@test (a2b_qp(type2test(b"=\rAB")) == b"")
@test (a2b_qp(type2test(b"=\rAB\nCD")) == b"CD")
@test (a2b_qp(type2test(b"=AB")) == b"\xab")
@test (a2b_qp(type2test(b"=ab")) == b"\xab")
@test (a2b_qp(type2test(b"=AX")) == b"=AX")
@test (a2b_qp(type2test(b"=XA")) == b"=XA")
@test (a2b_qp(type2test(b"=AB")[begin:-1]) == b"=A")
@test (a2b_qp(type2test(b"_")) == b"_")
@test (a2b_qp(type2test(b"_"), true) == b" ")
@test_throws TypeError b2a_qp("bar")
@test (a2b_qp(type2test(b"=00\r\n=00")) == b"\x00\r\n\x00")
@test (b2a_qp(type2test(b"\xff\r\n\xff\n\xff")) == b"=FF\r\n=FF\r\n=FF")
@test (b2a_qp(type2test(append!(repeat(b"0",75), b"\xff\r\n\xff\r\n\xff"))) == append!(repeat(b"0",75), b"=\r\n=FF\r\n=FF\r\n=FF"))
@test (b2a_qp(type2test(b"\x7f")) == b"=7F")
@test (b2a_qp(type2test(b"=")) == b"=3D")
@test (b2a_qp(type2test(b"_")) == b"_")
@test (b2a_qp(type2test(b"_"), true) == b"=5F")
@test (b2a_qp(type2test(b"x y"), true) == b"x_y")
@test (b2a_qp(type2test(b"x "), true) == b"x=20")
@test (b2a_qp(type2test(b"x y"), true, true) == b"x=20y")
@test (b2a_qp(type2test(b"x\ty"), true) == b"x\ty")
@test (b2a_qp(type2test(b" ")) == b"=20")
@test (b2a_qp(type2test(b"\t")) == b"=09")
@test (b2a_qp(type2test(b" x")) == b" x")
@test (b2a_qp(type2test(b"\tx")) == b"\tx")
@test (b2a_qp(type2test(b" x")[begin:-1]) == b"=20")
@test (b2a_qp(type2test(b"\tx")[begin:-1]) == b"=09")
@test (b2a_qp(type2test(b"\x00")) == b"=00")
@test (b2a_qp(type2test(b"\x00\n")) == b"=00\n")
@test (b2a_qp(type2test(b"\x00\n"), true) == b"=00\n")
@test (b2a_qp(type2test(b"x y\tz")) == b"x y\tz")
@test (b2a_qp(type2test(b"x y\tz"), true) == b"x=20y=09z")
@test (b2a_qp(type2test(b"x y\tz"), false) == b"x y\tz")
@test (b2a_qp(type2test(b"x \ny\t\n")) == b"x=20\ny=09\n")
@test (b2a_qp(type2test(b"x \ny\t\n"), true) == b"x=20\ny=09\n")
@test (b2a_qp(type2test(b"x \ny\t\n"), false) == b"x =0Ay\t=0A")
@test (b2a_qp(type2test(b"x \ry\t\r")) == b"x \ry\t\r")
@test (b2a_qp(type2test(b"x \ry\t\r"), true) == b"x=20\ry=09\r")
@test (b2a_qp(type2test(b"x \ry\t\r"), false) == b"x =0Dy\t=0D")
@test (b2a_qp(type2test(b"x \r\ny\t\r\n")) == b"x=20\r\ny=09\r\n")
@test (b2a_qp(type2test(b"x \r\ny\t\r\n"), true) == b"x=20\r\ny=09\r\n")
@test (b2a_qp(type2test(b"x \r\ny\t\r\n"), false) == b"x =0D=0Ay\t=0D=0A")
@test (b2a_qp(type2test(b"x \r\n")[begin:-1]) == b"x \r")
@test (b2a_qp(type2test(b"x\t\r\n")[begin:-1]) == b"x\t\r")
@test (b2a_qp(type2test(b"x \r\n")[begin:-1], true) == b"x=20\r")
@test (b2a_qp(type2test(b"x\t\r\n")[begin:-1], true) == b"x=09\r")
@test (b2a_qp(type2test(b"x \r\n")[begin:-1], false) == b"x =0D")
@test (b2a_qp(type2test(b"x\t\r\n")[begin:-1], false) == b"x\t=0D")
@test (b2a_qp(type2test(b".")) == b"=2E")
@test (b2a_qp(type2test(b".\n")) == b"=2E\n")
@test (b2a_qp(type2test(b".\r")) == b"=2E\r")
@test (b2a_qp(type2test(b".\x00")) == b"=2E=00")
@test (b2a_qp(type2test(b"a.\n")) == b"a.\n")
@test (b2a_qp(type2test(b".a")[begin:-1]) == b"=2E")
end

function test_empty_string(self::BinASCIITest)
empty = type2test(self, b"")
for func in all_functions
if func == "crc_hqx"
crc_hqx(empty, 0)
continue;
end
f = getfield(binascii, :func)
try
f(empty)
catch exn
 let err = exn
if err isa Exception
fail(self, "$()($(!r)) raises $(!r)")
end
end
end
end
end

function test_unicode_b2a(self::BinASCIITest)
for func in (set(all_functions) - set(a2b_functions)) | Set(["rledecode_hqx"])
try
@test_throws TypeError getfield(binascii, :func)("test")
catch exn
 let err = exn
if err isa Exception
fail(self, "$()(\"test\") raises $(!r)")
end
end
end
end
@test_throws TypeError binascii.crc_hqx("test", 0)
end

function test_unicode_a2b(self::BinASCIITest)
MAX_ALL = 45
raw = self.rawdata[begin:MAX_ALL]
for (fa, fb) in zip(a2b_functions, b2a_functions)
if fa == "rledecode_hqx"
continue;
end
a2b = getfield(binascii, :fa)
b2a = getfield(binascii, :fb)
try
a = b2a(type2test(self, raw))
binary_res = a2b(a)
a = decode(a, "ascii")
res = a2b(a)
catch exn
 let err = exn
if err isa Exception
fail(self, "$()/$() conversion raises $(!r)")
end
end
end
if fb == "b2a_hqx"
res, _ = res
binary_res, _ = binary_res
end
@test (res == raw)
@test (res == binary_res)
@test isa(self, res)
@test_throws ValueError a2b("\x80")
end
end

function test_b2a_base64_newline(self::BinASCIITest)
b = type2test(self, b"hello")
@test (b2a_base64(b) == b"aGVsbG8=\n")
@test (b2a_base64(b, true) == b"aGVsbG8=\n")
@test (b2a_base64(b, false) == b"aGVsbG8=")
end

function test_deprecated_warnings(self::BinASCIITest)
assertWarns(self, DeprecationWarning) do 
@test (b2a_hqx(b"abc") == b"B@*M")
end
assertWarns(self, DeprecationWarning) do 
@test (a2b_hqx(b"B@*M") == (b"abc", 0))
end
assertWarns(self, DeprecationWarning) do 
@test (rlecode_hqx(repeat(b"a",10)) == b"a\x90\n")
end
assertWarns(self, DeprecationWarning) do 
@test (rledecode_hqx(b"a\x90\n") == repeat(b"a",10))
end
end

mutable struct ArrayBinASCIITest <: AbstractArrayBinASCIITest

end
function type2test(self::ArrayBinASCIITest, s)
return array("B", collect(s))
end

mutable struct BytearrayBinASCIITest <: AbstractBytearrayBinASCIITest
type2test

                    BytearrayBinASCIITest(type2test = bytearray) =
                        new(type2test)
end

mutable struct MemoryviewBinASCIITest <: AbstractMemoryviewBinASCIITest
type2test

                    MemoryviewBinASCIITest(type2test = memoryview) =
                        new(type2test)
end

mutable struct ChecksumBigBufferTestCase <: AbstractChecksumBigBufferTestCase
#= bpo-38256 - check that inputs >=4 GiB are handled correctly. =#

end
function test_big_buffer(self::ChecksumBigBufferTestCase, size)
data = repeat(b"nyan",__add__(_1G, 1))
@test (crc32(data) == 1044521549)
end

if abspath(PROGRAM_FILE) == @__FILE__
bin_a_s_c_i_i_test = BinASCIITest()
setUp(bin_a_s_c_i_i_test)
test_exceptions(bin_a_s_c_i_i_test)
test_functions(bin_a_s_c_i_i_test)
test_returned_value(bin_a_s_c_i_i_test)
test_base64valid(bin_a_s_c_i_i_test)
test_base64invalid(bin_a_s_c_i_i_test)
test_base64errors(bin_a_s_c_i_i_test)
test_uu(bin_a_s_c_i_i_test)
test_crc_hqx(bin_a_s_c_i_i_test)
test_crc32(bin_a_s_c_i_i_test)
test_hqx(bin_a_s_c_i_i_test)
test_rle(bin_a_s_c_i_i_test)
test_hex(bin_a_s_c_i_i_test)
test_hex_separator(bin_a_s_c_i_i_test)
test_qp(bin_a_s_c_i_i_test)
test_empty_string(bin_a_s_c_i_i_test)
test_unicode_b2a(bin_a_s_c_i_i_test)
test_unicode_a2b(bin_a_s_c_i_i_test)
test_b2a_base64_newline(bin_a_s_c_i_i_test)
test_deprecated_warnings(bin_a_s_c_i_i_test)
checksum_big_buffer_test_case = ChecksumBigBufferTestCase()
test_big_buffer(checksum_big_buffer_test_case)
end
