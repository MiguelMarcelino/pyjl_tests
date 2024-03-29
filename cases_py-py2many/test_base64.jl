# Transpiled with flags: 
# - oop
using ObjectOriented
using OrderedCollections
using Test








@oodef mutable struct LegacyBase64TestCase <: unittest.TestCase
                    
                    
                    
                end
                function check_type_errors(self::@like(LegacyBase64TestCase), f)
@test_throws
@test_throws
multidimensional = cast(memoryview(b"1234"), "B", (2, 2))
@test_throws
int_data = cast(memoryview(b"1234"), "I")
@test_throws
end

function test_encodebytes(self::@like(LegacyBase64TestCase))
eq = self.assertEqual
eq(base64.encodebytes(b"www.python.org"), b"d3d3LnB5dGhvbi5vcmc=\n")
eq(base64.encodebytes(b"a"), b"YQ==\n")
eq(base64.encodebytes(b"ab"), b"YWI=\n")
eq(base64.encodebytes(b"abc"), b"YWJj\n")
eq(base64.encodebytes(b""), b"")
eq(base64.encodebytes(b"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#0^&*();:<>,. []{}"), b"YWJjZGVmZ2hpamtsbW5vcHFyc3R1dnd4eXpBQkNERUZHSElKS0xNTk9QUVJTVFVWV1hZWjAxMjM0\nNTY3ODkhQCMwXiYqKCk7Ojw+LC4gW117fQ==\n")
eq(base64.encodebytes(Vector{UInt8}(b"abc")), b"YWJj\n")
eq(base64.encodebytes(memoryview(b"abc")), b"YWJj\n")
eq(base64.encodebytes(array("B", b"abc")), b"YWJj\n")
check_type_errors(self, base64.encodebytes)
end

function test_decodebytes(self::@like(LegacyBase64TestCase))
eq = self.assertEqual
eq(base64.decodebytes(b"d3d3LnB5dGhvbi5vcmc=\n"), b"www.python.org")
eq(base64.decodebytes(b"YQ==\n"), b"a")
eq(base64.decodebytes(b"YWI=\n"), b"ab")
eq(base64.decodebytes(b"YWJj\n"), b"abc")
eq(base64.decodebytes(b"YWJjZGVmZ2hpamtsbW5vcHFyc3R1dnd4eXpBQkNERUZHSElKS0xNTk9QUVJTVFVWV1hZWjAxMjM0\nNTY3ODkhQCMwXiYqKCk7Ojw+LC4gW117fQ==\n"), b"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#0^&*();:<>,. []{}")
eq(base64.decodebytes(b""), b"")
eq(base64.decodebytes(Vector{UInt8}(b"YWJj\n")), b"abc")
eq(base64.decodebytes(memoryview(b"YWJj\n")), b"abc")
eq(base64.decodebytes(array("B", b"YWJj\n")), b"abc")
check_type_errors(self, base64.decodebytes)
end

function test_encode(self::@like(LegacyBase64TestCase))
eq = self.assertEqual
infp = IOBuffer(b"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#0^&*();:<>,. []{}")
outfp = BytesIO()
base64.encode(infp, outfp)
eq(getvalue(outfp), b"YWJjZGVmZ2hpamtsbW5vcHFyc3R1dnd4eXpBQkNERUZHSElKS0xNTk9QUVJTVFVWV1hZWjAxMjM0\nNTY3ODkhQCMwXiYqKCk7Ojw+LC4gW117fQ==\n")
@test_throws
@test_throws
@test_throws
end

function test_decode(self::@like(LegacyBase64TestCase))
infp = IOBuffer(b"d3d3LnB5dGhvbi5vcmc=")
outfp = BytesIO()
base64.decode(infp, outfp)
@test (getvalue(outfp) == b"www.python.org")
@test_throws
@test_throws
@test_throws
end


@oodef mutable struct BaseXYTestCase <: unittest.TestCase
                    
                    
                    
                end
                function check_encode_type_errors(self::@like(BaseXYTestCase), f)
@test_throws
@test_throws
end

function check_decode_type_errors(self::@like(BaseXYTestCase), f)
@test_throws
end

function check_other_types(self::@like(BaseXYTestCase), f, bytes_data, expected)
eq = self.assertEqual
b = Vector{UInt8}(bytes_data)
eq(f(b), expected)
eq(b, bytes_data)
eq(f(memoryview(bytes_data)), expected)
eq(f(array("B", bytes_data)), expected)
check_nonbyte_element_format(self, base64.b64encode, bytes_data)
check_multidimensional(self, base64.b64encode, bytes_data)
end

function check_multidimensional(self::@like(BaseXYTestCase), f, data)
padding_ = length(data) % 2 ? (b"\x00") : (b"")
bytes_data = data + padding_
shape = (length(bytes_data) ÷ 2, 2)
multidimensional = cast(memoryview(bytes_data), "B", shape)
@test (f(multidimensional) == f(bytes_data))
end

function check_nonbyte_element_format(self::@like(BaseXYTestCase), f, data)
padding_ = repeat(b"\x00",((4 - length(data)) % 4))
bytes_data = data + padding_
int_data = cast(memoryview(bytes_data), "I")
@test (f(int_data) == f(bytes_data))
end

function test_b64encode(self::@like(BaseXYTestCase))
eq = self.assertEqual
eq(base64.b64encode(b"www.python.org"), b"d3d3LnB5dGhvbi5vcmc=")
eq(base64.b64encode(b"\x00"), b"AA==")
eq(base64.b64encode(b"a"), b"YQ==")
eq(base64.b64encode(b"ab"), b"YWI=")
eq(base64.b64encode(b"abc"), b"YWJj")
eq(base64.b64encode(b""), b"")
eq(base64.b64encode(b"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#0^&*();:<>,. []{}"), b"YWJjZGVmZ2hpamtsbW5vcHFyc3R1dnd4eXpBQkNERUZHSElKS0xNTk9QUVJTVFVWV1hZWjAxMjM0NTY3ODkhQCMwXiYqKCk7Ojw+LC4gW117fQ==")
eq(base64.b64encode(b"\xd3V\xbeo\xf7\x1d", altchars = b"*$"), b"01a*b$cd")
eq(base64.b64encode(b"\xd3V\xbeo\xf7\x1d", altchars = Vector{UInt8}(b"*$")), b"01a*b$cd")
eq(base64.b64encode(b"\xd3V\xbeo\xf7\x1d", altchars = memoryview(b"*$")), b"01a*b$cd")
eq(base64.b64encode(b"\xd3V\xbeo\xf7\x1d", altchars = array("B", b"*$")), b"01a*b$cd")
check_other_types(self, base64.b64encode, b"abcd", b"YWJjZA==")
check_encode_type_errors(self, base64.b64encode)
@test_throws
eq(base64.standard_b64encode(b"www.python.org"), b"d3d3LnB5dGhvbi5vcmc=")
eq(base64.standard_b64encode(b"a"), b"YQ==")
eq(base64.standard_b64encode(b"ab"), b"YWI=")
eq(base64.standard_b64encode(b"abc"), b"YWJj")
eq(base64.standard_b64encode(b""), b"")
eq(base64.standard_b64encode(b"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#0^&*();:<>,. []{}"), b"YWJjZGVmZ2hpamtsbW5vcHFyc3R1dnd4eXpBQkNERUZHSElKS0xNTk9QUVJTVFVWV1hZWjAxMjM0NTY3ODkhQCMwXiYqKCk7Ojw+LC4gW117fQ==")
check_other_types(self, base64.standard_b64encode, b"abcd", b"YWJjZA==")
check_encode_type_errors(self, base64.standard_b64encode)
eq(base64.urlsafe_b64encode(b"\xd3V\xbeo\xf7\x1d"), b"01a-b_cd")
check_other_types(self, base64.urlsafe_b64encode, b"\xd3V\xbeo\xf7\x1d", b"01a-b_cd")
check_encode_type_errors(self, base64.urlsafe_b64encode)
end

function test_b64decode(self::@like(BaseXYTestCase))
eq = self.assertEqual
tests = OrderedDict(b"d3d3LnB5dGhvbi5vcmc=" => b"www.python.org", b"AA==" => b"\x00", b"YQ==" => b"a", b"YWI=" => b"ab", b"YWJj" => b"abc", b"YWJjZGVmZ2hpamtsbW5vcHFyc3R1dnd4eXpBQkNERUZHSElKS0xNTk9QUVJTVFVWV1hZWjAxMjM0\nNTY3ODkhQCMwXiYqKCk7Ojw+LC4gW117fQ==" => b"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#0^&*();:<>,. []{}", b"" => b"")
for (data, res) in collect(tests)
eq(base64.b64decode(data), res)
eq(base64.b64decode(decode(data, "ascii")), res)
end
check_other_types(self, base64.b64decode, b"YWJj", b"abc")
check_decode_type_errors(self, base64.b64decode)
tests_altchars = OrderedDict((b"01a*b$cd", b"*$") => b"\xd3V\xbeo\xf7\x1d")
for ((data, altchars), res) in collect(tests_altchars)
data_str = decode(data, "ascii")
altchars_str = decode(altchars, "ascii")
eq(base64.b64decode(data, altchars = altchars), res)
eq(base64.b64decode(data_str, altchars = altchars), res)
eq(base64.b64decode(data, altchars = altchars_str), res)
eq(base64.b64decode(data_str, altchars = altchars_str), res)
end
for (data, res) in collect(tests)
eq(base64.standard_b64decode(data), res)
eq(base64.standard_b64decode(decode(data, "ascii")), res)
end
check_other_types(self, base64.standard_b64decode, b"YWJj", b"abc")
check_decode_type_errors(self, base64.standard_b64decode)
tests_urlsafe = OrderedDict(b"01a-b_cd" => b"\xd3V\xbeo\xf7\x1d", b"" => b"")
for (data, res) in collect(tests_urlsafe)
eq(base64.urlsafe_b64decode(data), res)
eq(base64.urlsafe_b64decode(decode(data, "ascii")), res)
end
check_other_types(self, base64.urlsafe_b64decode, b"01a-b_cd", b"\xd3V\xbeo\xf7\x1d")
check_decode_type_errors(self, base64.urlsafe_b64decode)
end

function test_b64decode_padding_error(self::@like(BaseXYTestCase))
@test_throws
@test_throws
end

function test_b64decode_invalid_chars(self::@like(BaseXYTestCase))
tests = ((b"%3d==", b"\xdd"), (b"$3d==", b"\xdd"), (b"[==", b""), (b"YW]3=", b"am"), (b"3{d==", b"\xdd"), (b"3d}==", b"\xdd"), (b"@@", b""), (b"!", b""), (b"YWJj\n", b"abc"), (b"YWJj\nYWI=", b"abcab"))
funcs = (base64.b64decode, base64.standard_b64decode, base64.urlsafe_b64decode)
for (bstr, res) in tests
for func in funcs
subTest(self, bstr = bstr, func = func) do 
@test (func(bstr) == res)
@test (func(decode(bstr, "ascii")) == res)
end
end
@test_throws binascii.Error do 
base64.b64decode(bstr, validate = true)
end
@test_throws binascii.Error do 
base64.b64decode(decode(bstr, "ascii"), validate = true)
end
end
res = b"\xfb\xef\xbe\xff\xff\xff"
@test (base64.b64decode(b"++[[//]]", b"[]") == res)
@test (base64.urlsafe_b64decode(b"++--//__") == res)
end

function test_b32encode(self::@like(BaseXYTestCase))
eq = self.assertEqual
eq(base64.b32encode(b""), b"")
eq(base64.b32encode(b"\x00"), b"AA======")
eq(base64.b32encode(b"a"), b"ME======")
eq(base64.b32encode(b"ab"), b"MFRA====")
eq(base64.b32encode(b"abc"), b"MFRGG===")
eq(base64.b32encode(b"abcd"), b"MFRGGZA=")
eq(base64.b32encode(b"abcde"), b"MFRGGZDF")
check_other_types(self, base64.b32encode, b"abcd", b"MFRGGZA=")
check_encode_type_errors(self, base64.b32encode)
end

function test_b32decode(self::@like(BaseXYTestCase))
eq = self.assertEqual
tests = OrderedDict(b"" => b"", b"AA======" => b"\x00", b"ME======" => b"a", b"MFRA====" => b"ab", b"MFRGG===" => b"abc", b"MFRGGZA=" => b"abcd", b"MFRGGZDF" => b"abcde")
for (data, res) in collect(tests)
eq(base64.b32decode(data), res)
eq(base64.b32decode(decode(data, "ascii")), res)
end
check_other_types(self, base64.b32decode, b"MFRGG===", b"abc")
check_decode_type_errors(self, base64.b32decode)
end

function test_b32decode_casefold(self::@like(BaseXYTestCase))
eq = self.assertEqual
tests = OrderedDict(b"" => b"", b"ME======" => b"a", b"MFRA====" => b"ab", b"MFRGG===" => b"abc", b"MFRGGZA=" => b"abcd", b"MFRGGZDF" => b"abcde", b"me======" => b"a", b"mfra====" => b"ab", b"mfrgg===" => b"abc", b"mfrggza=" => b"abcd", b"mfrggzdf" => b"abcde")
for (data, res) in collect(tests)
eq(base64.b32decode(data, true), res)
eq(base64.b32decode(decode(data, "ascii"), true), res)
end
@test_throws
@test_throws
eq(base64.b32decode(b"MLO23456"), b"b\xdd\xad\xf3\xbe")
eq(base64.b32decode("MLO23456"), b"b\xdd\xad\xf3\xbe")
map_tests = OrderedDict((b"M1023456", b"L") => b"b\xdd\xad\xf3\xbe", (b"M1023456", b"I") => b"b\x1d\xad\xf3\xbe")
for ((data, map01), res) in collect(map_tests)
data_str = decode(data, "ascii")
map01_str = decode(map01, "ascii")
eq(base64.b32decode(data, map01 = map01), res)
eq(base64.b32decode(data_str, map01 = map01), res)
eq(base64.b32decode(data, map01 = map01_str), res)
eq(base64.b32decode(data_str, map01 = map01_str), res)
@test_throws
@test_throws
end
end

function test_b32decode_error(self::@like(BaseXYTestCase))
tests = [b"abc", b"ABCDEF==", b"==ABCDEF"]
prefixes = [b"M", b"ME", b"MFRA", b"MFRGG", b"MFRGGZA", b"MFRGGZDF"]
for i in 0:16
if i
push!(tests, b"="*i)
end
for prefix in prefixes
if (length(prefix) + i) != 8
push!(tests, [prefix; repeat(b"=",i)])
end
end
end
for data in tests
subTest(self, data = data) do 
@test_throws binascii.Error do 
base64.b32decode(data)
end
@test_throws binascii.Error do 
base64.b32decode(decode(data, "ascii"))
end
end
end
end

function test_b32hexencode(self::@like(BaseXYTestCase))
test_cases = [(b"", b""), (b"\x00", b"00======"), (b"a", b"C4======"), (b"ab", b"C5H0===="), (b"abc", b"C5H66==="), (b"abcd", b"C5H66P0="), (b"abcde", b"C5H66P35")]
for (to_encode, expected) in test_cases
subTest(self, to_decode = to_encode) do 
@test (base64.b32hexencode(to_encode) == expected)
end
end
end

function test_b32hexencode_other_types(self::@like(BaseXYTestCase))
check_other_types(self, base64.b32hexencode, b"abcd", b"C5H66P0=")
check_encode_type_errors(self, base64.b32hexencode)
end

function test_b32hexdecode(self::@like(BaseXYTestCase))
test_cases = [(b"", b"", false), (b"00======", b"\x00", false), (b"C4======", b"a", false), (b"C5H0====", b"ab", false), (b"C5H66===", b"abc", false), (b"C5H66P0=", b"abcd", false), (b"C5H66P35", b"abcde", false), (b"", b"", true), (b"00======", b"\x00", true), (b"C4======", b"a", true), (b"C5H0====", b"ab", true), (b"C5H66===", b"abc", true), (b"C5H66P0=", b"abcd", true), (b"C5H66P35", b"abcde", true), (b"c4======", b"a", true), (b"c5h0====", b"ab", true), (b"c5h66===", b"abc", true), (b"c5h66p0=", b"abcd", true), (b"c5h66p35", b"abcde", true)]
for (to_decode, expected, casefold) in test_cases
subTest(self, to_decode = to_decode, casefold = casefold) do 
@test (base64.b32hexdecode(to_decode, casefold) == expected)
@test (base64.b32hexdecode(decode(to_decode, "ascii"), casefold) == expected)
end
end
end

function test_b32hexdecode_other_types(self::@like(BaseXYTestCase))
check_other_types(self, base64.b32hexdecode, b"C5H66===", b"abc")
check_decode_type_errors(self, base64.b32hexdecode)
end

function test_b32hexdecode_error(self::@like(BaseXYTestCase))
tests = [b"abc", b"ABCDEF==", b"==ABCDEF", b"c4======"]
prefixes = [b"M", b"ME", b"MFRA", b"MFRGG", b"MFRGGZA", b"MFRGGZDF"]
for i in 0:16
if i
push!(tests, b"="*i)
end
for prefix in prefixes
if (length(prefix) + i) != 8
push!(tests, [prefix; repeat(b"=",i)])
end
end
end
for data in tests
subTest(self, to_decode = data) do 
@test_throws binascii.Error do 
base64.b32hexdecode(data)
end
@test_throws binascii.Error do 
base64.b32hexdecode(decode(data, "ascii"))
end
end
end
end

function test_b16encode(self::@like(BaseXYTestCase))
eq = self.assertEqual
eq(base64.b16encode(b"\x01\x02\xab\xcd\xef"), b"0102ABCDEF")
eq(base64.b16encode(b"\x00"), b"00")
check_other_types(self, base64.b16encode, b"\x01\x02\xab\xcd\xef", b"0102ABCDEF")
check_encode_type_errors(self, base64.b16encode)
end

function test_b16decode(self::@like(BaseXYTestCase))
eq = self.assertEqual
eq(base64.b16decode(b"0102ABCDEF"), b"\x01\x02\xab\xcd\xef")
eq(base64.b16decode("0102ABCDEF"), b"\x01\x02\xab\xcd\xef")
eq(base64.b16decode(b"00"), b"\x00")
eq(base64.b16decode("00"), b"\x00")
@test_throws
@test_throws
eq(base64.b16decode(b"0102abcdef", true), b"\x01\x02\xab\xcd\xef")
eq(base64.b16decode("0102abcdef", true), b"\x01\x02\xab\xcd\xef")
check_other_types(self, base64.b16decode, b"0102ABCDEF", b"\x01\x02\xab\xcd\xef")
check_decode_type_errors(self, base64.b16decode)
eq(base64.b16decode(Vector{UInt8}(b"0102abcdef"), true), b"\x01\x02\xab\xcd\xef")
eq(base64.b16decode(memoryview(b"0102abcdef"), true), b"\x01\x02\xab\xcd\xef")
eq(base64.b16decode(array("B", b"0102abcdef"), true), b"\x01\x02\xab\xcd\xef")
@test_throws
@test_throws
end

function test_a85encode(self::@like(BaseXYTestCase))
eq = self.assertEqual
tests = OrderedDict(b"" => b"", b"www.python.org" => b"GB\\6`E-ZP=Df.1GEb>", bytes(0:254) => b"!!*-\'\"9eu7#RLhG$k3[W&.oNg\'GVB\"(`=52*$$(B+<_pR,UFcb-n-Vr/1iJ-0JP==1c70M3&s#]4?Ykm5X@_(6q\'R884cEH9MJ8X:f1+h<)lt#=BSg3>[:ZC?t!MSA7]@cBPD3sCi+\'.E,fo>FEMbNG^4U^I!pHnJ:W<)KS>/9Ll%\"IN/`jYOHG]iPa.Q$R$jD4S=Q7DTV8*TUnsrdW2ZetXKAY/Yd(L?[\'d?O\\@K2_]Y2%o^qmn*`5Ta:aN;TJbg\"GZd*^:jeCE.%f\\,!5gtgiEi8N\\UjQ5OekiqBum-X60nF?)@o_%qPq\"ad`r;HT", b"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#0^&*();:<>,. []{}" => b"@:E_WAS,RgBkhF\"D/O92EH6,BF`qtRH$VbC6UX@47n?3D92&&T:Jand;cHat=\'/U/0JP==1c70M3&r-I,;<FN.OZ`-3]oSW/g+A(H[P", b"no padding.." => b"DJpY:@:Wn_DJ(RS", b"zero compression\x00\x00\x00\x00" => b"H=_,8+Cf>,E,oN2F(oQ1z", b"zero compression\x00\x00\x00" => b"H=_,8+Cf>,E,oN2F(oQ1!!!!", b"Boundary:\x00\x00\x00\x00" => b"6>q!aA79M(3WK-[!!", b"Space compr:    " => b";fH/TAKYK$D/aMV+<VdL", b"\xff" => b"rr", repeat(b"\xff",2) => b"s8N", repeat(b"\xff",3) => b"s8W*", repeat(b"\xff",4) => b"s8W-!")
for (data, res) in collect(tests)
eq(base64.a85encode(data), res, data)
eq(base64.a85encode(data, adobe = false), res, data)
eq(base64.a85encode(data, adobe = true), (b"<~" + res) + b"~>", data)
end
check_other_types(self, base64.a85encode, b"www.python.org", b"GB\\6`E-ZP=Df.1GEb>")
@test_throws
eq(base64.a85encode(b"www.python.org", wrapcol = 7, adobe = false), b"GB\\6`E-\nZP=Df.1\nGEb>")
eq(base64.a85encode(b"\x00\x00\x00\x00www.python.org", wrapcol = 7, adobe = false), b"zGB\\6`E\n-ZP=Df.\n1GEb>")
eq(base64.a85encode(b"www.python.org", wrapcol = 7, adobe = true), b"<~GB\\6`\nE-ZP=Df\n.1GEb>\n~>")
eq(base64.a85encode(repeat(b" ",8), foldspaces = true, adobe = false), b"yy")
eq(base64.a85encode(repeat(b" ",7), foldspaces = true, adobe = false), b"y+<Vd")
eq(base64.a85encode(repeat(b" ",6), foldspaces = true, adobe = false), b"y+<U")
eq(base64.a85encode(repeat(b" ",5), foldspaces = true, adobe = false), b"y+9")
end

function test_b85encode(self::@like(BaseXYTestCase))
eq = self.assertEqual
tests = OrderedDict(b"" => b"", b"www.python.org" => b"cXxL#aCvlSZ*DGca%T", bytes(0:254) => b"009C61O)~M2nh-c3=Iws5D^j+6crX17#SKH9337XAR!_nBqb&%C@Cr{EG;fCFflSSG&MFiI5|2yJUu=?KtV!7L`6nNNJ&adOifNtP*GA-R8>}2SXo+ITwPvYU}0ioWMyV&XlZI|Y;A6DaB*^Tbai%jczJqze0_d@fPsR8goTEOh>41ejE#<ukdcy;l$Dm3n3<ZJoSmMZprN9pq@|{(sHv)}tgWuEu(7hUw6(UkxVgH!yuH4^z`?@9#Kp$P$jQpf%+1cv(9zP<)YaD4*xB0K+}+;a;Njxq<mKk)=;`X~?CtLF@bU8V^!4`l`1$(#{Qdp", b"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#0^&*();:<>,. []{}" => b"VPa!sWoBn+X=-b1ZEkOHadLBXb#`}nd3r%YLqtVJM@UIZOH55pPf$@(Q&d$}S6EqEFflSSG&MFiI5{CeBQRbjDkv#CIy^osE+AW7dwl", b"no padding.." => b"Zf_uPVPs@!Zf7no", b"zero compression\x00\x00\x00\x00" => b"dS!BNAY*TBaB^jHb7^mG00000", b"zero compression\x00\x00\x00" => b"dS!BNAY*TBaB^jHb7^mG0000", b"Boundary:\x00\x00\x00\x00" => b"LT`0$WMOi7IsgCw00", b"Space compr:    " => b"Q*dEpWgug3ZE$irARr(h", b"\xff" => b"{{", repeat(b"\xff",2) => b"|Nj", repeat(b"\xff",3) => b"|Ns9", repeat(b"\xff",4) => b"|NsC0")
for (data, res) in collect(tests)
eq(base64.b85encode(data), res)
end
check_other_types(self, base64.b85encode, b"www.python.org", b"cXxL#aCvlSZ*DGca%T")
end

function test_a85decode(self::@like(BaseXYTestCase))
eq = self.assertEqual
tests = OrderedDict(b"" => b"", b"GB\\6`E-ZP=Df.1GEb>" => b"www.python.org", b"! ! * -\'\"\n\t\t9eu\r\n7#  RL\x0bhG$k3[W&.oNg\'GVB\"(`=52*$$(B+<_pR,UFcb-n-Vr/1iJ-0JP==1c70M3&s#]4?Ykm5X@_(6q\'R884cEH9MJ8X:f1+h<)lt#=BSg3>[:ZC?t!MSA7]@cBPD3sCi+\'.E,fo>FEMbNG^4U^I!pHnJ:W<)KS>/9Ll%\"IN/`jYOHG]iPa.Q$R$jD4S=Q7DTV8*TUnsrdW2ZetXKAY/Yd(L?[\'d?O\\@K2_]Y2%o^qmn*`5Ta:aN;TJbg\"GZd*^:jeCE.%f\\,!5gtgiEi8N\\UjQ5OekiqBum-X60nF?)@o_%qPq\"ad`r;HT" => bytes(0:254), b"@:E_WAS,RgBkhF\"D/O92EH6,BF`qtRH$VbC6UX@47n?3D92&&T:Jand;cHat=\'/U/0JP==1c70M3&r-I,;<FN.OZ`-3]oSW/g+A(H[P" => b"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#0^&*();:<>,. []{}", b"DJpY:@:Wn_DJ(RS" => b"no padding..", b"H=_,8+Cf>,E,oN2F(oQ1z" => b"zero compression\x00\x00\x00\x00", b"H=_,8+Cf>,E,oN2F(oQ1!!!!" => b"zero compression\x00\x00\x00", b"6>q!aA79M(3WK-[!!" => b"Boundary:\x00\x00\x00\x00", b";fH/TAKYK$D/aMV+<VdL" => b"Space compr:    ", b"rr" => b"\xff", b"s8N" => repeat(b"\xff",2), b"s8W*" => repeat(b"\xff",3), b"s8W-!" => repeat(b"\xff",4))
for (data, res) in collect(tests)
eq(base64.a85decode(data), res, data)
eq(base64.a85decode(data, adobe = false), res, data)
eq(base64.a85decode(decode(data, "ascii"), adobe = false), res, data)
eq(base64.a85decode((b"<~" + data) + b"~>", adobe = true), res, data)
eq(base64.a85decode(data + b"~>", adobe = true), res, data)
eq(base64.a85decode("<~$(decode(data, "ascii"))~>", adobe = true), res, data)
end
eq(base64.a85decode(b"yy", foldspaces = true, adobe = false), repeat(b" ",8))
eq(base64.a85decode(b"y+<Vd", foldspaces = true, adobe = false), repeat(b" ",7))
eq(base64.a85decode(b"y+<U", foldspaces = true, adobe = false), repeat(b" ",6))
eq(base64.a85decode(b"y+9", foldspaces = true, adobe = false), repeat(b" ",5))
check_other_types(self, base64.a85decode, b"GB\\6`E-ZP=Df.1GEb>", b"www.python.org")
end

function test_b85decode(self::@like(BaseXYTestCase))
eq = self.assertEqual
tests = OrderedDict(b"" => b"", b"cXxL#aCvlSZ*DGca%T" => b"www.python.org", b"009C61O)~M2nh-c3=Iws5D^j+6crX17#SKH9337XAR!_nBqb&%C@Cr{EG;fCFflSSG&MFiI5|2yJUu=?KtV!7L`6nNNJ&adOifNtP*GA-R8>}2SXo+ITwPvYU}0ioWMyV&XlZI|Y;A6DaB*^Tbai%jczJqze0_d@fPsR8goTEOh>41ejE#<ukdcy;l$Dm3n3<ZJoSmMZprN9pq@|{(sHv)}tgWuEu(7hUw6(UkxVgH!yuH4^z`?@9#Kp$P$jQpf%+1cv(9zP<)YaD4*xB0K+}+;a;Njxq<mKk)=;`X~?CtLF@bU8V^!4`l`1$(#{Qdp" => bytes(0:254), b"VPa!sWoBn+X=-b1ZEkOHadLBXb#`}nd3r%YLqtVJM@UIZOH55pPf$@(Q&d$}S6EqEFflSSG&MFiI5{CeBQRbjDkv#CIy^osE+AW7dwl" => b"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#0^&*();:<>,. []{}", b"Zf_uPVPs@!Zf7no" => b"no padding..", b"dS!BNAY*TBaB^jHb7^mG00000" => b"zero compression\x00\x00\x00\x00", b"dS!BNAY*TBaB^jHb7^mG0000" => b"zero compression\x00\x00\x00", b"LT`0$WMOi7IsgCw00" => b"Boundary:\x00\x00\x00\x00", b"Q*dEpWgug3ZE$irARr(h" => b"Space compr:    ", b"{{" => b"\xff", b"|Nj" => repeat(b"\xff",2), b"|Ns9" => repeat(b"\xff",3), b"|NsC0" => repeat(b"\xff",4))
for (data, res) in collect(tests)
eq(base64.b85decode(data), res)
eq(base64.b85decode(decode(data, "ascii")), res)
end
check_other_types(self, base64.b85decode, b"cXxL#aCvlSZ*DGca%T", b"www.python.org")
end

function test_a85_padding(self::@like(BaseXYTestCase))
eq = self.assertEqual
eq(base64.a85encode(b"x", pad = true), b"GQ7^D")
eq(base64.a85encode(b"xx", pad = true), b"G^'2g")
eq(base64.a85encode(b"xxx", pad = true), b"G^+H5")
eq(base64.a85encode(b"xxxx", pad = true), b"G^+IX")
eq(base64.a85encode(b"xxxxx", pad = true), b"G^+IXGQ7^D")
eq(base64.a85decode(b"GQ7^D"), b"x\x00\x00\x00")
eq(base64.a85decode(b"G^'2g"), b"xx\x00\x00")
eq(base64.a85decode(b"G^+H5"), b"xxx\x00")
eq(base64.a85decode(b"G^+IX"), b"xxxx")
eq(base64.a85decode(b"G^+IXGQ7^D"), b"xxxxx\x00\x00\x00")
end

function test_b85_padding(self::@like(BaseXYTestCase))
eq = self.assertEqual
eq(base64.b85encode(b"x", pad = true), b"cmMzZ")
eq(base64.b85encode(b"xx", pad = true), b"cz6H+")
eq(base64.b85encode(b"xxx", pad = true), b"czAdK")
eq(base64.b85encode(b"xxxx", pad = true), b"czAet")
eq(base64.b85encode(b"xxxxx", pad = true), b"czAetcmMzZ")
eq(base64.b85decode(b"cmMzZ"), b"x\x00\x00\x00")
eq(base64.b85decode(b"cz6H+"), b"xx\x00\x00")
eq(base64.b85decode(b"czAdK"), b"xxx\x00")
eq(base64.b85decode(b"czAet"), b"xxxx")
eq(base64.b85decode(b"czAetcmMzZ"), b"xxxxx\x00\x00\x00")
end

function test_a85decode_errors(self::@like(BaseXYTestCase))
illegal = (Set(0:31) | Set(118:255)) - Set(b" \t\n\r\x0b")
for c in illegal
@test_throws ValueError do 
base64.a85decode([b"!!!!"; bytes([c])])
end
@test_throws ValueError do 
base64.a85decode([b"!!!!"; bytes([c])], adobe = false)
end
@test_throws ValueError do 
base64.a85decode([[b"<~!!!!"; bytes([c])]; b"~>"], adobe = true)
end
end
@test_throws
@test_throws
@test_throws
@test_throws
base64.a85decode(b"<~~>", adobe = true)
@test_throws
@test_throws
@test_throws
@test_throws
@test_throws
@test_throws
@test_throws
@test_throws
end

function test_b85decode_errors(self::@like(BaseXYTestCase))
illegal = [[collect(0:32); collect(b"\"\',./:[\\]")]; collect(128:255)]
for c in illegal
@test_throws ValueError do 
base64.b85decode([b"0000"; bytes([c])])
end
end
@test_throws
@test_throws
@test_throws
@test_throws
@test_throws
end

function test_decode_nonascii_str(self::@like(BaseXYTestCase))
decode_funcs = (base64.b64decode, base64.standard_b64decode, base64.urlsafe_b64decode, base64.b32decode, base64.b16decode, base64.b85decode, base64.a85decode)
for f in decode_funcs
@test_throws
end
end

function test_ErrorHeritage(self::@like(BaseXYTestCase))
@test binascii.Error <: ValueError
end

function test_RFC4648_test_cases(self::@like(BaseXYTestCase))
b64encode = base64.b64encode
b32hexencode = base64.b32hexencode
b32encode = base64.b32encode
b16encode = base64.b16encode
@test (b64encode(b"") == b"")
@test (b64encode(b"f") == b"Zg==")
@test (b64encode(b"fo") == b"Zm8=")
@test (b64encode(b"foo") == b"Zm9v")
@test (b64encode(b"foob") == b"Zm9vYg==")
@test (b64encode(b"fooba") == b"Zm9vYmE=")
@test (b64encode(b"foobar") == b"Zm9vYmFy")
@test (b32encode(b"") == b"")
@test (b32encode(b"f") == b"MY======")
@test (b32encode(b"fo") == b"MZXQ====")
@test (b32encode(b"foo") == b"MZXW6===")
@test (b32encode(b"foob") == b"MZXW6YQ=")
@test (b32encode(b"fooba") == b"MZXW6YTB")
@test (b32encode(b"foobar") == b"MZXW6YTBOI======")
@test (b32hexencode(b"") == b"")
@test (b32hexencode(b"f") == b"CO======")
@test (b32hexencode(b"fo") == b"CPNG====")
@test (b32hexencode(b"foo") == b"CPNMU===")
@test (b32hexencode(b"foob") == b"CPNMUOG=")
@test (b32hexencode(b"fooba") == b"CPNMUOJ1")
@test (b32hexencode(b"foobar") == b"CPNMUOJ1E8======")
@test (b16encode(b"") == b"")
@test (b16encode(b"f") == b"66")
@test (b16encode(b"fo") == b"666F")
@test (b16encode(b"foo") == b"666F6F")
@test (b16encode(b"foob") == b"666F6F62")
@test (b16encode(b"fooba") == b"666F6F6261")
@test (b16encode(b"foobar") == b"666F6F626172")
end


@oodef mutable struct TestMain <: unittest.TestCase
                    
                    
                    
                end
                function tearDown(self::@like(TestMain))
if os.exists(os_helper.TESTFN)
rm(os_helper.TESTFN)
end
end

function get_output(self::@like(TestMain), args...)
return script_helper.assert_python_ok("-m", "base64", args...).out
end

function test_encode_decode(self::@like(TestMain))
output = get_output(self)
assertSequenceEqual(self, splitlines(output), (b"b'Aladdin:open sesame'", b"b'QWxhZGRpbjpvcGVuIHNlc2FtZQ==\\n'", b"b'Aladdin:open sesame'"))
end

function test_encode_file(self::@like(TestMain))
readline(os_helper.TESTFN) do fp 
write(fp, b"a\xffb\n")
end
output = get_output(self)
@test (rstrip(output) == b"Yf9iCg==")
end

function test_encode_from_stdin(self::@like(TestMain))
script_helper.spawn_python("-m", "base64", "-e") do proc 
(out, err) = communicate(proc, b"a\xffb\n")
end
@test (rstrip(out) == b"Yf9iCg==")
assertIsNone(self, err)
end

function test_decode(self::@like(TestMain))
readline(os_helper.TESTFN) do fp 
write(fp, b"Yf9iCg==")
end
output = get_output(self)
@test (rstrip(output) == b"a\xffb")
end


if abspath(PROGRAM_FILE) == @__FILE__
test_numbers = TestNumbers()
test_int(test_numbers)
test_float(test_numbers)
test_complex(test_numbers)
aug_assign_test = AugAssignTest()
testBasic(aug_assign_test)
testInList(aug_assign_test)
testInDict(aug_assign_test)
testSequences(aug_assign_test)
testCustomMethods1(aug_assign_test)
testCustomMethods2(aug_assign_test)
legacy_base64_test_case = LegacyBase64TestCase()
test_encodebytes(legacy_base64_test_case)
test_decodebytes(legacy_base64_test_case)
test_encode(legacy_base64_test_case)
test_decode(legacy_base64_test_case)
base_x_y_test_case = BaseXYTestCase()
test_b64encode(base_x_y_test_case)
test_b64decode(base_x_y_test_case)
test_b64decode_padding_error(base_x_y_test_case)
test_b64decode_invalid_chars(base_x_y_test_case)
test_b32encode(base_x_y_test_case)
test_b32decode(base_x_y_test_case)
test_b32decode_casefold(base_x_y_test_case)
test_b32decode_error(base_x_y_test_case)
test_b32hexencode(base_x_y_test_case)
test_b32hexencode_other_types(base_x_y_test_case)
test_b32hexdecode(base_x_y_test_case)
test_b32hexdecode_other_types(base_x_y_test_case)
test_b32hexdecode_error(base_x_y_test_case)
test_b16encode(base_x_y_test_case)
test_b16decode(base_x_y_test_case)
test_a85encode(base_x_y_test_case)
test_b85encode(base_x_y_test_case)
test_a85decode(base_x_y_test_case)
test_b85decode(base_x_y_test_case)
test_a85_padding(base_x_y_test_case)
test_b85_padding(base_x_y_test_case)
test_a85decode_errors(base_x_y_test_case)
test_b85decode_errors(base_x_y_test_case)
test_decode_nonascii_str(base_x_y_test_case)
test_ErrorHeritage(base_x_y_test_case)
test_RFC4648_test_cases(base_x_y_test_case)
test_main = TestMain()
test_encode_decode(test_main)
test_encode_file(test_main)
test_encode_from_stdin(test_main)
test_decode(test_main)
tearDown(test_main)
end