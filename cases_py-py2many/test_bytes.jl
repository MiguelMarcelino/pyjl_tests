# Transpiled with flags: 
# - oop
#= Unit tests for the bytes and bytearray types.

XXX This is a mess.  Common tests should be unified with string_tests.py (and
the latter should be modernized).
 =#
using ObjectOriented
using ResumableFunctions
using StringEncodings
using Test
using _testcapi: getbuffer_with_null_view




import copy
import functools


import textwrap







using test.support.script_helper: assert_python_failure
if sys.flags.bytes_warning
function check_bytes_warnings(func)
function wrapper(args...)
warnings_helper.check_warnings(("", BytesWarning)) do 
return func(args..., None = kw)
end
end

return wrapper
end

else
function check_bytes_warnings(func)
return func
end

end
@oodef mutable struct Indexable
                    
                    value
                    
function new(value = 0)
@mk begin
value = value
end
end

                end
                function __index__(self::@like(Indexable))
return self.value
end


@oodef mutable struct S
                    
                    
                    
                end
                function __getitem__(self::@like(S), i)::Int64
return (1, 2, 3)[i + 1]
end


@oodef mutable struct X
                    
                    
                    
                end
                function __index__(self::@like(X))::Int64
clear(a)
return 42
end


@oodef mutable struct Y
                    
                    
                    
                end
                function __index__(self::@like(Y))::Int64
if length(a) < 1000
append(a)
end
return 42
end


@oodef mutable struct B <: Array{UInt8}
                    
                    
                    
                end
                function __index__(self::@like(B))
throw(TypeError)
end


@oodef mutable struct C
                    
                    
                    
                end
                

@oodef mutable struct BadInt
                    
                    
                    
                end
                function __index__(self::@like(BadInt))
1 / 0
end


@oodef mutable struct BadIterable
                    
                    
                    
                end
                function __iter__(self::@like(BadIterable))
1 / 0
end


@oodef mutable struct BaseBytesTest
                    
                    
                    
                end
                function test_basics(self::@like(BaseBytesTest))
b = type2test(self)
assertEqual(self, type_(b), self.type2test)
assertEqual(self, b.__class__, self.type2test)
end

function test_copy(self::@like(BaseBytesTest))
a = type2test(self, b"abcd")
for copy_method in (copy.copy, copy.deepcopy)
b = copy_method(a)
assertEqual(self, a, b)
assertEqual(self, type_(a), type_(b))
end
end

function test_empty_sequence(self::@like(BaseBytesTest))
b = type2test(self)
assertEqual(self, length(b), 0)
assertRaises(self, IndexError, () -> b[1])
assertRaises(self, IndexError, () -> b[2])
assertRaises(self, IndexError, () -> b[typemax(Int) + 1])
assertRaises(self, IndexError, () -> b[typemax(Int) + 2])
assertRaises(self, IndexError, () -> b[10^100])
assertRaises(self, IndexError, () -> b[end])
assertRaises(self, IndexError, () -> b[end - 1])
assertRaises(self, IndexError, () -> b[-(typemax(Int)) + 1])
assertRaises(self, IndexError, () -> b[-(typemax(Int))])
assertRaises(self, IndexError, () -> b[-(typemax(Int)) - -1])
assertRaises(self, IndexError, () -> b[-(10^100) + 1])
end

function test_from_iterable(self::@like(BaseBytesTest))
b = type2test(self, 0:255)
assertEqual(self, length(b), 256)
assertEqual(self, collect(b), collect(0:255))
b = type2test(self, Set([42]))
assertEqual(self, b, b"*")
b = type2test(self, Set([43, 45]))
assertIn(self, tuple(b), Set([(43, 45), (45, 43)]))
b = type2test(self, (x for x in 0:255))
assertEqual(self, length(b), 256)
assertEqual(self, collect(b), collect(0:255))
b = type2test(self, (i for i in 0:255 if i % 2 ))
assertEqual(self, length(b), 128)
assertEqual(self, collect(b), collect(0:255)[2:2:end])
b = type2test(self, S())
assertEqual(self, b, b"\x01\x02\x03")
end

function test_from_tuple(self::@like(BaseBytesTest))
b = type2test(self, tuple(0:255))
assertEqual(self, length(b), 256)
assertEqual(self, collect(b), collect(0:255))
b = type2test(self, (1, 2, 3))
assertEqual(self, b, b"\x01\x02\x03")
end

function test_from_list(self::@like(BaseBytesTest))
b = type2test(self, collect(0:255))
assertEqual(self, length(b), 256)
assertEqual(self, collect(b), collect(0:255))
b = type2test(self, [1, 2, 3])
assertEqual(self, b, b"\x01\x02\x03")
end

function test_from_mutating_list(self::@like(BaseBytesTest))
a = [X(), X()]
assertEqual(self, bytes(a), b"*")
a = [Y()]
assertEqual(self, bytes(a), repeat(b"*",1000))
end

function test_from_index(self::@like(BaseBytesTest))
b = type2test(self, [Indexable(), Indexable(1), Indexable(254), Indexable(255)])
assertEqual(self, collect(b), [0, 1, 254, 255])
assertRaises(self, ValueError, self.type2test, [Indexable(-1)])
assertRaises(self, ValueError, self.type2test, [Indexable(256)])
end

function test_from_buffer(self::@like(BaseBytesTest))
a = type2test(self, array.array("B", [1, 2, 3]))
assertEqual(self, a, b"\x01\x02\x03")
a = type2test(self, b"\x01\x02\x03")
assertEqual(self, a, b"\x01\x02\x03")
assertEqual(self, type2test(self, B(b"foobar")), b"foobar")
end

function test_from_ssize(self::@like(BaseBytesTest))
assertEqual(self, type2test(self, 0), b"")
assertEqual(self, type2test(self, 1), b"\x00")
assertEqual(self, type2test(self, 5), b"\x00\x00\x00\x00\x00")
assertRaises(self, ValueError, self.type2test, -1)
assertEqual(self, type2test(self, "0", "ascii"), b"0")
assertEqual(self, type2test(self, b"0"), b"0")
assertRaises(self, OverflowError, self.type2test, typemax(Int) + 1)
end

function test_constructor_type_errors(self::@like(BaseBytesTest))
assertRaises(self, TypeError, self.type2test, 0.0)
assertRaises(self, TypeError, self.type2test, ["0"])
assertRaises(self, TypeError, self.type2test, [0.0])
assertRaises(self, TypeError, self.type2test, [nothing])
assertRaises(self, TypeError, self.type2test, [C()])
assertRaises(self, TypeError, self.type2test, encoding = "ascii")
assertRaises(self, TypeError, self.type2test, errors = "ignore")
assertRaises(self, TypeError, self.type2test, 0, "ascii")
assertRaises(self, TypeError, self.type2test, b"", "ascii")
assertRaises(self, TypeError, self.type2test, 0, errors = "ignore")
assertRaises(self, TypeError, self.type2test, b"", errors = "ignore")
assertRaises(self, TypeError, self.type2test, "")
assertRaises(self, TypeError, self.type2test, "", errors = "ignore")
assertRaises(self, TypeError, self.type2test, "", b"ascii")
assertRaises(self, TypeError, self.type2test, "", "ascii", b"ignore")
end

function test_constructor_value_errors(self::@like(BaseBytesTest))
assertRaises(self, ValueError, self.type2test, [-1])
assertRaises(self, ValueError, self.type2test, [-(typemax(Int))])
assertRaises(self, ValueError, self.type2test, [-(typemax(Int)) - 1])
assertRaises(self, ValueError, self.type2test, [-(typemax(Int)) - 2])
assertRaises(self, ValueError, self.type2test, [-(10^100)])
assertRaises(self, ValueError, self.type2test, [256])
assertRaises(self, ValueError, self.type2test, [257])
assertRaises(self, ValueError, self.type2test, [typemax(Int)])
assertRaises(self, ValueError, self.type2test, [typemax(Int) + 1])
assertRaises(self, ValueError, self.type2test, [10^100])
end

function test_constructor_overflow(self::@like(BaseBytesTest))
size_ = MAX_Py_ssize_t
assertRaises(self, (OverflowError, MemoryError), self.type2test, size_)
try
Vector{UInt8}(size_ - 4)
catch exn
if exn isa (OverflowError, MemoryError)
#= pass =#
end
end
end

function test_constructor_exceptions(self::@like(BaseBytesTest))
assertRaises(self, ZeroDivisionError, self.type2test, BadInt())
assertRaises(self, ZeroDivisionError, self.type2test, [BadInt()])
assertRaises(self, ZeroDivisionError, self.type2test, BadIterable())
end

function test_compare(self::@like(BaseBytesTest))
b1 = type2test(self, [1, 2, 3])
b2 = type2test(self, [1, 2, 3])
b3 = type2test(self, [1, 3])
assertEqual(self, b1, b2)
assertTrue(self, b2 != b3)
assertTrue(self, b1 <= b2)
assertTrue(self, b1 <= b3)
assertTrue(self, b1 < b3)
assertTrue(self, b1 >= b2)
assertTrue(self, b3 >= b2)
assertTrue(self, b3 > b2)
assertFalse(self, b1 != b2)
assertFalse(self, b2 == b3)
assertFalse(self, b1 > b2)
assertFalse(self, b1 > b3)
assertFalse(self, b1 >= b3)
assertFalse(self, b1 < b2)
assertFalse(self, b3 < b2)
assertFalse(self, b3 <= b2)
end

function test_compare_to_str(self::@like(BaseBytesTest))
assertEqual(self, type2test(self, b"\x00a\x00b\x00c") == "abc", false)
assertEqual(self, type2test(self, b"\x00\x00\x00a\x00\x00\x00b\x00\x00\x00c") == "abc", false)
assertEqual(self, type2test(self, b"a\x00b\x00c\x00") == "abc", false)
assertEqual(self, type2test(self, b"a\x00\x00\x00b\x00\x00\x00c\x00\x00\x00") == "abc", false)
assertEqual(self, type2test(self) == string(), false)
assertEqual(self, type2test(self) != string(), true)
end

function test_reversed(self::@like(BaseBytesTest))
input = collect(map(ord, "Hello"))
b = type2test(self, input)
output = collect(reversed(b))
reverse(input)
assertEqual(self, output, input)
end

function test_getslice(self::@like(BaseBytesTest))
function by(s::@like(BaseBytesTest))
return type2test(self, map(ord, s))
end

b = by("Hello, world")
assertEqual(self, b[begin:5], by("Hello"))
assertEqual(self, b[2:5], by("ello"))
assertEqual(self, b[6:7], by(", "))
assertEqual(self, b[8:end], by("world"))
assertEqual(self, b[8:12], by("world"))
assertEqual(self, b[8:100], by("world"))
assertEqual(self, b[begin:end - 7], by("Hello"))
assertEqual(self, b[-11:end - 7], by("ello"))
assertEqual(self, b[-7:end - 5], by(", "))
assertEqual(self, b[length(b) - 5 + 1:end], by("world"))
assertEqual(self, b[length(b) - 5 + 1:12], by("world"))
assertEqual(self, b[length(b) - 5 + 1:100], by("world"))
assertEqual(self, b[length(b) - 100 + 1:5], by("Hello"))
end

function test_extended_getslice(self::@like(BaseBytesTest))
L = collect(0:254)
b = type2test(self, L)
indices = (0, nothing, 1, 3, 19, 100, typemax(Int), -1, -2, -31, -100)
for start in indices
for stop in indices
for step_ in indices[2:end]
assertEqual(self, b[start + 1:step_:stop], type2test(self, L[start + 1:step_:stop]))
end
end
end
end

function test_encoding(self::@like(BaseBytesTest))
sample = "Hello world\nሴ噸骼"
for enc in ("utf-8", "utf-16")
b = type2test(self, sample, enc)
assertEqual(self, b, type2test(self, encode(sample, enc)))
end
assertRaises(self, UnicodeEncodeError, self.type2test, sample, "latin-1")
b = type2test(self, sample, "latin-1", "ignore")
assertEqual(self, b, type2test(self, sample[begin:end - 3], "utf-8"))
end

function test_decode(self::@like(BaseBytesTest))
sample = "Hello world\nሴ噸骼"
for enc in ("utf-8", "utf-16")
b = type2test(self, sample, enc)
assertEqual(self, decode(b, enc), sample)
end
sample = "Hello world\n\x80þ\xff"
b = type2test(self, sample, "latin-1")
assertRaises(self, UnicodeDecodeError, b.decode, "utf-8")
assertEqual(self, decode(b, "utf-8", "ignore"), "Hello world\n")
assertEqual(self, decode(b, errors = "ignore", encoding = "utf-8"), "Hello world\n")
assertEqual(self, decode(type2test(self, b"\xe2\x98\x83")), "☃")
end

function test_check_encoding_errors(self::@like(BaseBytesTest))
invalid = "Boom, Shaka Laka, Boom!"
encodings = ("ascii", "utf8", "latin1")
code = textwrap.dedent("\n            import sys\n            type2test = $(self.type2test.__name__)\n            encodings = $(encodings)\n\n            for data in (\'\', \'short string\'):\n                try:\n                    type2test(data, encoding=$(invalid))\n                except LookupError:\n                    pass\n                else:\n                    sys.exit(21)\n\n                for encoding in encodings:\n                    try:\n                        type2test(data, encoding=encoding, errors=$(invalid))\n                    except LookupError:\n                        pass\n                    else:\n                        sys.exit(22)\n\n            for data in (b\'\', b\'short string\'):\n                data = type2test(data)\n                print(repr(data))\n                try:\n                    data.decode(encoding=$(invalid))\n                except LookupError:\n                    sys.exit(10)\n                else:\n                    sys.exit(23)\n\n                try:\n                    data.decode(errors=$(invalid))\n                except LookupError:\n                    pass\n                else:\n                    sys.exit(24)\n\n                for encoding in encodings:\n                    try:\n                        data.decode(encoding=encoding, errors=$(invalid))\n                    except LookupError:\n                        pass\n                    else:\n                        sys.exit(25)\n\n            sys.exit(10)\n        ")
proc = assert_python_failure("-X", "dev", "-c", code)
assertEqual(self, proc.rc, 10, proc)
end

function test_from_int(self::@like(BaseBytesTest))
b = type2test(self, 0)
assertEqual(self, b, type2test(self))
b = type2test(self, 10)
assertEqual(self, b, type2test(self, repeat([0],10)))
b = type2test(self, 10000)
assertEqual(self, b, type2test(self, repeat([0],10000)))
end

function test_concat(self::@like(BaseBytesTest))
b1 = type2test(self, b"abc")
b2 = type2test(self, b"def")
assertEqual(self, b1 + b2, b"abcdef")
assertEqual(self, b1 + bytes(b"def"), b"abcdef")
assertEqual(self, bytes(b"def") + b1, b"defabc")
assertRaises(self, TypeError, () -> b1 + "def")
assertRaises(self, TypeError, () -> "abc" + b2)
end

function test_repeat(self::@like(BaseBytesTest))
for b in (b"abc", type2test(self, b"abc"))
assertEqual(self, repeat(b,3), b"abcabcabc")
assertEqual(self, repeat(b,0), b"")
assertEqual(self, repeat(b,-1), b"")
assertRaises(self, TypeError, () -> repeat(b,3.14))
assertRaises(self, TypeError, () -> repeat(b,3.14))
assertRaises(self, (OverflowError, MemoryError)) do 
c = b*typemax(Int)
end
assertRaises(self, (OverflowError, MemoryError)) do 
b *= typemax(Int)
end
end
end

function test_repeat_1char(self::@like(BaseBytesTest))
assertEqual(self, type2test(self, b"x")*100, type2test(self, repeat([Int(codepoint('x'))],100)))
end

function test_contains(self::@like(BaseBytesTest))
b = type2test(self, b"abc")
assertIn(self, Int(codepoint('a')), b)
assertIn(self, parse(Int, Int(codepoint('a'))), b)
assertNotIn(self, 200, b)
assertRaises(self, ValueError, () -> 300 ∈ b)
assertRaises(self, ValueError, () -> -1 ∈ b)
assertRaises(self, ValueError, () -> (typemax(Int) + 1) ∈ b)
assertRaises(self, TypeError, () -> nothing ∈ b)
assertRaises(self, TypeError, () -> float(Int(codepoint('a'))) ∈ b)
assertRaises(self, TypeError, () -> "a" ∈ b)
for f in (Array{UInt8}, Vector{UInt8})
assertIn(self, f(b""), b)
assertIn(self, f(b"a"), b)
assertIn(self, f(b"b"), b)
assertIn(self, f(b"c"), b)
assertIn(self, f(b"ab"), b)
assertIn(self, f(b"bc"), b)
assertIn(self, f(b"abc"), b)
assertNotIn(self, f(b"ac"), b)
assertNotIn(self, f(b"d"), b)
assertNotIn(self, f(b"dab"), b)
assertNotIn(self, f(b"abd"), b)
end
end

function test_fromhex(self::@like(BaseBytesTest))
assertRaises(self, TypeError, self.type2test.fromhex)
assertRaises(self, TypeError, self.type2test.fromhex, 1)
assertEqual(self, fromhex(self.type2test, ""), type2test(self))
b = Vector{UInt8}([26, 43, 48])
assertEqual(self, fromhex(self.type2test, "1a2B30"), b)
assertEqual(self, fromhex(self.type2test, "  1A 2B  30   "), b)
assertEqual(self, fromhex(self.type2test, " 1A\n2B\t30\v"), b)
for c in "\t\n\v\f\r "
assertEqual(self, fromhex(self.type2test, c), type2test(self))
end
for c in "    "
assertRaises(self, ValueError, self.type2test.fromhex, c)
end
assertEqual(self, fromhex(self.type2test, "0000"), b"\x00\x00")
assertRaises(self, TypeError, self.type2test.fromhex, b"1B")
assertRaises(self, ValueError, self.type2test.fromhex, "a")
assertRaises(self, ValueError, self.type2test.fromhex, "rt")
assertRaises(self, ValueError, self.type2test.fromhex, "1a b cd")
assertRaises(self, ValueError, self.type2test.fromhex, "\0")
assertRaises(self, ValueError, self.type2test.fromhex, "12   \0   34")
for (data, pos) in (("12 x4 56", 3), ("12 3x 56", 4), ("12 xy 56", 3), ("12 3\xff 56", 4))
assertRaises(self, ValueError) do cm 
fromhex(self.type2test, data)
end
assertIn(self, "at position $(pos)", string(cm.exception))
end
end

function test_hex(self::@like(BaseBytesTest))
assertRaises(self, TypeError, self.type2test.hex)
assertRaises(self, TypeError, self.type2test.hex, 1)
assertEqual(self, hex(type2test(self, b"")), "")
assertEqual(self, hex(Vector{UInt8}([26, 43, 48])), "1a2b30")
assertEqual(self, hex(type2test(self, b"\x1a+0")), "1a2b30")
assertEqual(self, hex(memoryview(b"\x1a+0")), "1a2b30")
end

function test_hex_separator_basics(self::@like(BaseBytesTest))
three_bytes = type2test(self, b"\xb9\x01\xef")
assertEqual(self, hex(three_bytes), "b901ef")
assertRaises(self, ValueError) do 
hex(three_bytes, "")
end
assertRaises(self, ValueError) do 
hex(three_bytes, "xx")
end
assertEqual(self, hex(three_bytes, ":", 0), "b901ef")
assertRaises(self, TypeError) do 
hex(three_bytes, nothing, 0)
end
assertRaises(self, ValueError) do 
hex(three_bytes, "\xff")
end
assertRaises(self, ValueError) do 
hex(three_bytes, b"\xff")
end
assertRaises(self, ValueError) do 
hex(three_bytes, b"\x80")
end
assertRaises(self, ValueError) do 
hex(three_bytes, Char(256))
end
assertEqual(self, hex(three_bytes, ":", 0), "b901ef")
assertEqual(self, hex(three_bytes, b"\x00"), "b9\001\0ef")
assertEqual(self, hex(three_bytes, "\0"), "b9\001\0ef")
assertEqual(self, hex(three_bytes, b"\x7f"), "b901ef")
assertEqual(self, hex(three_bytes, ""), "b901ef")
assertEqual(self, hex(three_bytes, ":", 3), "b901ef")
assertEqual(self, hex(three_bytes, ":", 4), "b901ef")
assertEqual(self, hex(three_bytes, ":", -4), "b901ef")
assertEqual(self, hex(three_bytes, ":"), "b9:01:ef")
assertEqual(self, hex(three_bytes, b"$"), "b9\$01\$ef")
assertEqual(self, hex(three_bytes, ":", 1), "b9:01:ef")
assertEqual(self, hex(three_bytes, ":", -1), "b9:01:ef")
assertEqual(self, hex(three_bytes, ":", 2), "b9:01ef")
assertEqual(self, hex(three_bytes, ":", 1), "b9:01:ef")
assertEqual(self, hex(three_bytes, "*", -2), "b901*ef")
value = b"{s\x05\x00\x00\x00worldi\x02\x00\x00\x00s\x05\x00\x00\x00helloi\x01\x00\x00\x000"
assertEqual(self, hex(value, ".", 8), "7b7305000000776f.726c646902000000.730500000068656c.6c6f690100000030")
end

function test_hex_separator_five_bytes(self::@like(BaseBytesTest))
five_bytes = type2test(self, 90:94)
assertEqual(self, hex(five_bytes), "5a5b5c5d5e")
end

function test_hex_separator_six_bytes(self::@like(BaseBytesTest))
six_bytes = type2test(self, (x*3 for x in 1:6))
assertEqual(self, hex(six_bytes), "0306090c0f12")
assertEqual(self, hex(six_bytes, ".", 1), "03.06.09.0c.0f.12")
assertEqual(self, hex(six_bytes, " ", 2), "0306 090c 0f12")
assertEqual(self, hex(six_bytes, "-", 3), "030609-0c0f12")
assertEqual(self, hex(six_bytes, ":", 4), "0306:090c0f12")
assertEqual(self, hex(six_bytes, ":", 5), "03:06090c0f12")
assertEqual(self, hex(six_bytes, ":", 6), "0306090c0f12")
assertEqual(self, hex(six_bytes, ":", 95), "0306090c0f12")
assertEqual(self, hex(six_bytes, "_", -3), "030609_0c0f12")
assertEqual(self, hex(six_bytes, ":", -4), "0306090c:0f12")
assertEqual(self, hex(six_bytes, b"@", -5), "0306090c0f@12")
assertEqual(self, hex(six_bytes, ":", -6), "0306090c0f12")
assertEqual(self, hex(six_bytes, " ", -95), "0306090c0f12")
end

function test_join(self::@like(BaseBytesTest))
assertEqual(self, join(type2test(self, b""), []), b"")
assertEqual(self, join(type2test(self, b""), [b""]), b"")
for lst in [[b"abc"], [b"a", b"bc"], [b"ab", b"c"], [b"a", b"b", b"c"]]
lst = collect(map(self.type2test, lst))
assertEqual(self, join(type2test(self, b""), lst), b"abc")
assertEqual(self, join(type2test(self, b""), tuple(lst)), b"abc")
assertEqual(self, join(type2test(self, b""), (x for x in lst)), b"abc")
end
dot_join = type2test(self, b".:").join
assertEqual(self, dot_join([b"ab", b"cd"]), b"ab.:cd")
assertEqual(self, dot_join([memoryview(b"ab"), b"cd"]), b"ab.:cd")
assertEqual(self, dot_join([b"ab", memoryview(b"cd")]), b"ab.:cd")
assertEqual(self, dot_join([Vector{UInt8}(b"ab"), b"cd"]), b"ab.:cd")
assertEqual(self, dot_join([b"ab", Vector{UInt8}(b"cd")]), b"ab.:cd")
seq = repeat([b"abc"],100000)
expected = [b"abc"; repeat(b".:abc",99999)]
assertEqual(self, dot_join(seq), expected)
seq = repeat([b"abc"],100000)
expected = repeat(b"abc",100000)
assertEqual(self, join(type2test(self, b""), seq), expected)
assertRaises(self, TypeError, type2test(self, b" ").join, nothing)
assertRaises(self, TypeError) do 
dot_join([Vector{UInt8}(b"ab"), "cd", b"ef"])
end
assertRaises(self, TypeError) do 
dot_join([memoryview(b"ab"), "cd", b"ef"])
end
end

function test_count(self::@like(BaseBytesTest))
b = type2test(self, b"mississippi")
i = 105
p = 112
w = 119
assertEqual(self, count(b, b"i"), 4)
assertEqual(self, count(b, b"ss"), 2)
assertEqual(self, count(b, b"w"), 0)
assertEqual(self, count(b, i), 4)
assertEqual(self, count(b, w), 0)
assertEqual(self, count(b, b"i", 6), 2)
assertEqual(self, count(b, b"p", 6), 2)
assertEqual(self, count(b, b"i", 1, 3), 1)
assertEqual(self, count(b, b"p", 7, 9), 1)
assertEqual(self, count(b, i, 6), 2)
assertEqual(self, count(b, p, 6), 2)
assertEqual(self, count(b, i, 1, 3), 1)
assertEqual(self, count(b, p, 7, 9), 1)
end

function test_startswith(self::@like(BaseBytesTest))
b = type2test(self, b"hello")
assertFalse(self, startswith(type2test(self), b"anything"))
assertTrue(self, startswith(b, b"hello"))
assertTrue(self, startswith(b, b"hel"))
assertTrue(self, startswith(b, b"h"))
assertFalse(self, startswith(b, b"hellow"))
assertFalse(self, startswith(b, b"ha"))
assertRaises(self, TypeError) do cm 
startswith(b, [b"h"])
end
exc = string(cm.exception)
assertIn(self, "bytes", exc)
assertIn(self, "tuple", exc)
end

function test_endswith(self::@like(BaseBytesTest))
b = type2test(self, b"hello")
assertFalse(self, endswith(Vector{UInt8}(), b"anything"))
assertTrue(self, endswith(b, b"hello"))
assertTrue(self, endswith(b, b"llo"))
assertTrue(self, endswith(b, b"o"))
assertFalse(self, endswith(b, b"whello"))
assertFalse(self, endswith(b, b"no"))
assertRaises(self, TypeError) do cm 
endswith(b, [b"o"])
end
exc = string(cm.exception)
assertIn(self, "bytes", exc)
assertIn(self, "tuple", exc)
end

function test_find(self::@like(BaseBytesTest))
b = type2test(self, b"mississippi")
i = 105
w = 119
assertEqual(self, find(b, b"ss"), 2)
assertEqual(self, find(b, b"w"), -1)
assertEqual(self, find(b, b"mississippian"), -1)
assertEqual(self, find(b, i), 1)
assertEqual(self, find(b, w), -1)
assertEqual(self, find(b, b"ss", 3), 5)
assertEqual(self, find(b, b"ss", 1, 7), 2)
assertEqual(self, find(b, b"ss", 1, 3), -1)
assertEqual(self, find(b, i, 6), 7)
assertEqual(self, find(b, i, 1, 3), 1)
assertEqual(self, find(b, w, 1, 3), -1)
for index in (-1, 256, typemax(Int) + 1)
assertRaisesRegex(self, ValueError, "byte must be in range\\(0, 256\\)", b.find, index)
end
end

function test_rfind(self::@like(BaseBytesTest))
b = type2test(self, b"mississippi")
i = 105
w = 119
assertEqual(self, rfind(b, b"ss"), 5)
assertEqual(self, rfind(b, b"w"), -1)
assertEqual(self, rfind(b, b"mississippian"), -1)
assertEqual(self, rfind(b, i), 10)
assertEqual(self, rfind(b, w), -1)
assertEqual(self, rfind(b, b"ss", 3), 5)
assertEqual(self, rfind(b, b"ss", 0, 6), 2)
assertEqual(self, rfind(b, i, 1, 3), 1)
assertEqual(self, rfind(b, i, 3, 9), 7)
assertEqual(self, rfind(b, w, 1, 3), -1)
end

function test_index(self::@like(BaseBytesTest))
b = type2test(self, b"mississippi")
i = 105
w = 119
assertEqual(self, index(b, b"ss"), 2)
assertRaises(self, ValueError, b.index, b"w")
assertRaises(self, ValueError, b.index, b"mississippian")
assertEqual(self, index(b, i), 1)
assertRaises(self, ValueError, b.index, w)
assertEqual(self, index(b, b"ss", 3), 5)
assertEqual(self, index(b, b"ss", 1, 7), 2)
assertRaises(self, ValueError, b.index, b"ss", 1, 3)
assertEqual(self, index(b, i, 6), 7)
assertEqual(self, index(b, i, 1, 3), 1)
assertRaises(self, ValueError, b.index, w, 1, 3)
end

function test_rindex(self::@like(BaseBytesTest))
b = type2test(self, b"mississippi")
i = 105
w = 119
assertEqual(self, rindex(b, b"ss"), 5)
assertRaises(self, ValueError, b.rindex, b"w")
assertRaises(self, ValueError, b.rindex, b"mississippian")
assertEqual(self, rindex(b, i), 10)
assertRaises(self, ValueError, b.rindex, w)
assertEqual(self, rindex(b, b"ss", 3), 5)
assertEqual(self, rindex(b, b"ss", 0, 6), 2)
assertEqual(self, rindex(b, i, 1, 3), 1)
assertEqual(self, rindex(b, i, 3, 9), 7)
assertRaises(self, ValueError, b.rindex, w, 1, 3)
end

function test_mod(self::@like(BaseBytesTest))
b = type2test(self, b"hello, %b!")
orig = b
b = b % b"world"
assertEqual(self, b, b"hello, world!")
assertEqual(self, orig, b"hello, %b!")
assertFalse(self, b === orig)
b = type2test(self, b"%s / 100 = %d%%")
a = b % (b"seventy-nine", 79)
assertEqual(self, a, b"seventy-nine / 100 = 79%")
assertIs(self, type_(a), self.type2test)
b = type2test(self, b"hello,\x00%b!")
b = b % b"world"
assertEqual(self, b, b"hello,\x00world!")
assertIs(self, type_(b), self.type2test)
end

function test_imod(self::@like(BaseBytesTest))
b = type2test(self, b"hello, %b!")
orig = b
b %= b"world"
assertEqual(self, b, b"hello, world!")
assertEqual(self, orig, b"hello, %b!")
assertFalse(self, b === orig)
b = type2test(self, b"%s / 100 = %d%%")
b %= (b"seventy-nine", 79)
assertEqual(self, b, b"seventy-nine / 100 = 79%")
assertIs(self, type_(b), self.type2test)
b = type2test(self, b"hello,\x00%b!")
b %= b"world"
assertEqual(self, b, b"hello,\x00world!")
assertIs(self, type_(b), self.type2test)
end

function test_rmod(self::@like(BaseBytesTest))
assertRaises(self, TypeError) do 
object() % type2test(self, b"abc")
end
assertIs(self, __rmod__(type2test(self, b"abc"), "%r"), NotImplemented)
end

function test_replace(self::@like(BaseBytesTest))
b = type2test(self, b"mississippi")
assertEqual(self, replace(b, b"i", b"a"), b"massassappa")
assertEqual(self, replace(b, b"ss", b"x"), b"mixixippi")
end

function test_replace_int_error(self::@like(BaseBytesTest))
assertRaises(self, TypeError, type2test(self, b"a b").replace, 32, b"")
end

function test_split_string_error(self::@like(BaseBytesTest))
assertRaises(self, TypeError, type2test(self, b"a b").split, " ")
assertRaises(self, TypeError, type2test(self, b"a b").rsplit, " ")
end

function test_split_int_error(self::@like(BaseBytesTest))
assertRaises(self, TypeError, type2test(self, b"a b").split, 32)
assertRaises(self, TypeError, type2test(self, b"a b").rsplit, 32)
end

function test_split_unicodewhitespace(self::@like(BaseBytesTest))
for b in (b"a\x1cb", b"a\x1db", b"a\x1eb", b"a\x1fb")
b = type2test(self, b)
assertEqual(self, split(b), [b])
end
b = type2test(self, b"\t\n\x0b\x0c\r\x1c\x1d\x1e\x1f")
assertEqual(self, split(b), [b"\x1c\x1d\x1e\x1f"])
end

function test_rsplit_unicodewhitespace(self::@like(BaseBytesTest))
b = type2test(self, b"\t\n\x0b\x0c\r\x1c\x1d\x1e\x1f")
assertEqual(self, rsplit(b), [b"\x1c\x1d\x1e\x1f"])
end

function test_partition(self::@like(BaseBytesTest))
b = type2test(self, b"mississippi")
assertEqual(self, partition(b, b"ss"), (b"mi", b"ss", b"issippi"))
assertEqual(self, partition(b, b"w"), (b"mississippi", b"", b""))
end

function test_rpartition(self::@like(BaseBytesTest))
b = type2test(self, b"mississippi")
assertEqual(self, rpartition(b, b"ss"), (b"missi", b"ss", b"ippi"))
assertEqual(self, rpartition(b, b"i"), (b"mississipp", b"i", b""))
assertEqual(self, rpartition(b, b"w"), (b"", b"", b"mississippi"))
end

function test_partition_string_error(self::@like(BaseBytesTest))
assertRaises(self, TypeError, type2test(self, b"a b").partition, " ")
assertRaises(self, TypeError, type2test(self, b"a b").rpartition, " ")
end

function test_partition_int_error(self::@like(BaseBytesTest))
assertRaises(self, TypeError, type2test(self, b"a b").partition, 32)
assertRaises(self, TypeError, type2test(self, b"a b").rpartition, 32)
end

function test_pickling(self::@like(BaseBytesTest))
for proto in 0:pickle.HIGHEST_PROTOCOL
for b in (b"", b"a", b"abc", b"\xffab\x80", b"\x00\x00\xff\x00\x00")
b = type2test(self, b)
ps = pickle.dumps(b, proto)
q = pickle.loads(ps)
assertEqual(self, b, q)
end
end
end

function test_iterator_pickling(self::@like(BaseBytesTest))
for proto in 0:pickle.HIGHEST_PROTOCOL
for b in (b"", b"a", b"abc", b"\xffab\x80", b"\x00\x00\xff\x00\x00")
it=itorg = (x for x in type2test(self, b))
data = collect(type2test(self, b))
d = pickle.dumps(it, proto)
it = pickle.loads(d)
assertEqual(self, type_(itorg), type_(it))
assertEqual(self, collect(it), data)
it = pickle.loads(d)
if !b
continue;
end
next(it)
d = pickle.dumps(it, proto)
it = pickle.loads(d)
assertEqual(self, collect(it), data[2:end])
end
end
end

function test_strip_bytearray(self::@like(BaseBytesTest))
assertEqual(self, strip(type2test(self, b"abc"), memoryview(b"ac")), b"b")
assertEqual(self, lstrip(type2test(self, b"abc"), memoryview(b"ac")), b"bc")
assertEqual(self, rstrip(type2test(self, b"abc"), memoryview(b"ac")), b"ab")
end

function test_strip_string_error(self::@like(BaseBytesTest))
assertRaises(self, TypeError, type2test(self, b"abc").strip, "ac")
assertRaises(self, TypeError, type2test(self, b"abc").lstrip, "ac")
assertRaises(self, TypeError, type2test(self, b"abc").rstrip, "ac")
end

function test_strip_int_error(self::@like(BaseBytesTest))
assertRaises(self, TypeError, type2test(self, b" abc ").strip, 32)
assertRaises(self, TypeError, type2test(self, b" abc ").lstrip, 32)
assertRaises(self, TypeError, type2test(self, b" abc ").rstrip, 32)
end

function test_center(self::@like(BaseBytesTest))
b = type2test(self, b"abc")
for fill_type in (Array{UInt8}, Vector{UInt8})
assertEqual(self, center(b, 7, fill_type(b"-")), type2test(self, b"--abc--"))
end
end

function test_ljust(self::@like(BaseBytesTest))
b = type2test(self, b"abc")
for fill_type in (Array{UInt8}, Vector{UInt8})
assertEqual(self, ljust(b, 7, fill_type(b"-")), type2test(self, b"abc----"))
end
end

function test_rjust(self::@like(BaseBytesTest))
b = type2test(self, b"abc")
for fill_type in (Array{UInt8}, Vector{UInt8})
assertEqual(self, rjust(b, 7, fill_type(b"-")), type2test(self, b"----abc"))
end
end

function test_xjust_int_error(self::@like(BaseBytesTest))
assertRaises(self, TypeError, type2test(self, b"abc").center, 7, 32)
assertRaises(self, TypeError, type2test(self, b"abc").ljust, 7, 32)
assertRaises(self, TypeError, type2test(self, b"abc").rjust, 7, 32)
end

function test_ord(self::@like(BaseBytesTest))
b = type2test(self, b"\x00A\x7f\x80\xff")
assertEqual(self, [Int(codepoint(b[i + 1:i + 1])) for i in 0:length(b) - 1], [0, 65, 127, 128, 255])
end

function test_maketrans(self::@like(BaseBytesTest))
transtable = b"\x00\x01\x02\x03\x04\x05\x06\x07\x08\t\n\x0b\x0c\r\x0e\x0f\x10\x11\x12\x13\x14\x15\x16\x17\x18\x19\x1a\x1b\x1c\x1d\x1e\x1f !\"#$%&\'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`xyzdefghijklmnopqrstuvwxyz{|}~\x7f\x80\x81\x82\x83\x84\x85\x86\x87\x88\x89\x8a\x8b\x8c\x8d\x8e\x8f\x90\x91\x92\x93\x94\x95\x96\x97\x98\x99\x9a\x9b\x9c\x9d\x9e\x9f\xa0\xa1\xa2\xa3\xa4\xa5\xa6\xa7\xa8\xa9\xaa\xab\xac\xad\xae\xaf\xb0\xb1\xb2\xb3\xb4\xb5\xb6\xb7\xb8\xb9\xba\xbb\xbc\xbd\xbe\xbf\xc0\xc1\xc2\xc3\xc4\xc5\xc6\xc7\xc8\xc9\xca\xcb\xcc\xcd\xce\xcf\xd0\xd1\xd2\xd3\xd4\xd5\xd6\xd7\xd8\xd9\xda\xdb\xdc\xdd\xde\xdf\xe0\xe1\xe2\xe3\xe4\xe5\xe6\xe7\xe8\xe9\xea\xeb\xec\xed\xee\xef\xf0\xf1\xf2\xf3\xf4\xf5\xf6\xf7\xf8\xf9\xfa\xfb\xfc\xfd\xfe\xff"
assertEqual(self, maketrans(self.type2test, b"abc", b"xyz"), transtable)
transtable = b"\x00\x01\x02\x03\x04\x05\x06\x07\x08\t\n\x0b\x0c\r\x0e\x0f\x10\x11\x12\x13\x14\x15\x16\x17\x18\x19\x1a\x1b\x1c\x1d\x1e\x1f !\"#$%&\'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~\x7f\x80\x81\x82\x83\x84\x85\x86\x87\x88\x89\x8a\x8b\x8c\x8d\x8e\x8f\x90\x91\x92\x93\x94\x95\x96\x97\x98\x99\x9a\x9b\x9c\x9d\x9e\x9f\xa0\xa1\xa2\xa3\xa4\xa5\xa6\xa7\xa8\xa9\xaa\xab\xac\xad\xae\xaf\xb0\xb1\xb2\xb3\xb4\xb5\xb6\xb7\xb8\xb9\xba\xbb\xbc\xbd\xbe\xbf\xc0\xc1\xc2\xc3\xc4\xc5\xc6\xc7\xc8\xc9\xca\xcb\xcc\xcd\xce\xcf\xd0\xd1\xd2\xd3\xd4\xd5\xd6\xd7\xd8\xd9\xda\xdb\xdc\xdd\xde\xdf\xe0\xe1\xe2\xe3\xe4\xe5\xe6\xe7\xe8\xe9\xea\xeb\xec\xed\xee\xef\xf0\xf1\xf2\xf3\xf4\xf5\xf6\xf7\xf8\xf9\xfa\xfb\xfcxyz"
assertEqual(self, maketrans(self.type2test, b"\xfd\xfe\xff", b"xyz"), transtable)
assertRaises(self, ValueError, self.type2test.maketrans, b"abc", b"xyzq")
assertRaises(self, TypeError, self.type2test.maketrans, "abc", "def")
end

function test_none_arguments(self::@like(BaseBytesTest))
b = type2test(self, b"hello")
l = type2test(self, b"l")
h = type2test(self, b"h")
x = type2test(self, b"x")
o = type2test(self, b"o")
assertEqual(self, 2, find(b, l, nothing))
assertEqual(self, 3, find(b, l, -2, nothing))
assertEqual(self, 2, find(b, l, nothing, -2))
assertEqual(self, 0, find(b, h, nothing, nothing))
assertEqual(self, 3, rfind(b, l, nothing))
assertEqual(self, 3, rfind(b, l, -2, nothing))
assertEqual(self, 2, rfind(b, l, nothing, -2))
assertEqual(self, 0, rfind(b, h, nothing, nothing))
assertEqual(self, 2, index(b, l, nothing))
assertEqual(self, 3, index(b, l, -2, nothing))
assertEqual(self, 2, index(b, l, nothing, -2))
assertEqual(self, 0, index(b, h, nothing, nothing))
assertEqual(self, 3, rindex(b, l, nothing))
assertEqual(self, 3, rindex(b, l, -2, nothing))
assertEqual(self, 2, rindex(b, l, nothing, -2))
assertEqual(self, 0, rindex(b, h, nothing, nothing))
assertEqual(self, 2, count(b, l, nothing))
assertEqual(self, 1, count(b, l, -2, nothing))
assertEqual(self, 1, count(b, l, nothing, -2))
assertEqual(self, 0, count(b, x, nothing, nothing))
assertEqual(self, true, endswith(b, o, nothing))
assertEqual(self, true, endswith(b, o, -2, nothing))
assertEqual(self, true, endswith(b, l, nothing, -2))
assertEqual(self, false, endswith(b, x, nothing, nothing))
assertEqual(self, true, startswith(b, h, nothing))
assertEqual(self, true, startswith(b, l, -2, nothing))
assertEqual(self, true, startswith(b, h, nothing, -2))
assertEqual(self, false, startswith(b, x, nothing, nothing))
end

function test_integer_arguments_out_of_byte_range(self::@like(BaseBytesTest))
b = type2test(self, b"hello")
for method in (b.count, b.find, b.index, b.rfind, b.rindex)
assertRaises(self, ValueError, method, -1)
assertRaises(self, ValueError, method, 256)
assertRaises(self, ValueError, method, 9999)
end
end

function test_find_etc_raise_correct_error_messages(self::@like(BaseBytesTest))
b = type2test(self, b"hello")
x = type2test(self, b"x")
assertRaisesRegex(self, TypeError, "\\bfind\\b", b.find, x, nothing, nothing, nothing)
assertRaisesRegex(self, TypeError, "\\brfind\\b", b.rfind, x, nothing, nothing, nothing)
assertRaisesRegex(self, TypeError, "\\bindex\\b", b.index, x, nothing, nothing, nothing)
assertRaisesRegex(self, TypeError, "\\brindex\\b", b.rindex, x, nothing, nothing, nothing)
assertRaisesRegex(self, TypeError, "\\bcount\\b", b.count, x, nothing, nothing, nothing)
assertRaisesRegex(self, TypeError, "\\bstartswith\\b", b.startswith, x, nothing, nothing, nothing)
assertRaisesRegex(self, TypeError, "\\bendswith\\b", b.endswith, x, nothing, nothing, nothing)
end

function test_free_after_iterating(self::@like(BaseBytesTest))
test.support.check_free_after_iterating(iter, self.type2test)
test.support.check_free_after_iterating(reversed, self.type2test)
end

function test_translate(self::@like(BaseBytesTest))
b = type2test(self, b"hello")
rosetta = Vector{UInt8}(0:255)
rosetta[Int(codepoint('o')) + 1] = Int(codepoint('e'))
assertRaises(self, TypeError, b.translate)
assertRaises(self, TypeError, b.translate, nothing, nothing)
assertRaises(self, ValueError, b.translate, bytes(0:254))
c = translate(b, rosetta, b"hello")
assertEqual(self, b, b"hello")
assertIsInstance(self, c, self.type2test)
c = translate(b, rosetta)
d = translate(b, rosetta, b"")
assertEqual(self, c, d)
assertEqual(self, c, b"helle")
c = translate(b, rosetta, b"l")
assertEqual(self, c, b"hee")
c = translate(b, nothing, b"e")
assertEqual(self, c, b"hllo")
c = translate(b, rosetta, delete = b"")
assertEqual(self, c, b"helle")
c = translate(b, rosetta, delete = b"l")
assertEqual(self, c, b"hee")
c = translate(b, nothing, delete = b"e")
assertEqual(self, c, b"hllo")
end

function test_sq_item(self::@like(BaseBytesTest))
_testcapi = import_helper.import_module("_testcapi")
obj = type2test(self, (42,))
assertRaises(self, IndexError) do 
sequence_getitem(_testcapi, obj, -2)
end
assertRaises(self, IndexError) do 
sequence_getitem(_testcapi, obj, 1)
end
assertEqual(self, sequence_getitem(_testcapi, obj, 0), 42)
end


@oodef mutable struct IterationBlocked <: Vector
                    
                    __bytes__
                    
function new(__bytes__ = nothing)
__bytes__ = __bytes__
new(__bytes__)
end

                end
                

@oodef mutable struct IntBlocked <: Int64
                    
                    __bytes__
                    
function new(__bytes__ = nothing)
__bytes__ = __bytes__
new(__bytes__)
end

                end
                

@oodef mutable struct BytesSubclassBlocked <: Array{UInt8}
                    
                    __bytes__
                    
function new(__bytes__ = nothing)
__bytes__ = __bytes__
new(__bytes__)
end

                end
                

@oodef mutable struct BufferBlocked <: Vector{UInt8}
                    
                    __bytes__
                    
function new(__bytes__ = nothing)
__bytes__ = __bytes__
new(__bytes__)
end

                end
                

@oodef mutable struct SubBytes <: Array{UInt8}
                    
                    
                    
                end
                

@oodef mutable struct BytesTest <: {BaseBytesTest, unittest.TestCase}
                    
                    type2test
                    
function new(type2test = Array{UInt8})
type2test = type2test
new(type2test)
end

                end
                function test_getitem_error(self::@like(BytesTest))
b = b"python"
msg = "byte indices must be integers or slices"
assertRaisesRegex(self, TypeError, msg) do 
b["a"]
end
end

function test_buffer_is_readonly(self::@like(BytesTest))
fd_ = os.open(@__FILE__, os.O_RDONLY)
readline(fd_) do f 
@test_throws
end
end

function test_bytes_blocking(self::@like(BytesTest))
i = [0, 1, 2, 3]
@test (bytes(i) == b"\x00\x01\x02\x03")
@test_throws
@test (bytes(3) == b"\x00\x00\x00")
@test_throws
@test (bytes(b"ab") == b"ab")
@test_throws
(ba, bb) = (Vector{UInt8}(b"ab"), BufferBlocked(b"ab"))
@test (bytes(ba) == b"ab")
@test_throws
end

function test_repeat_id_preserving(self::@like(BytesTest))
a = b"123abc1@"
b = b"456zyx-+"
@test (id(a) == id(a))
@test (id(a) != id(b))
@test (id(a) != id(repeat(a,-4)))
@test (id(a) != id(repeat(a,0)))
@test (id(a) == id(repeat(a,1)))
@test (id(a) == id(repeat(a,1)))
@test (id(a) != id(repeat(a,2)))
s = SubBytes(b"qwerty()")
@test (id(s) == id(s))
@test (id(s) != id(__mul__(s, -4)))
@test (id(s) != id(__mul__(s, 0)))
@test (id(s) != id(__mul__(s, 1)))
@test (id(s) != id(__mul__(1, s)))
@test (id(s) != id(__mul__(s, 2)))
end


@resumable function g()
for i in 1:99
@yield i
a = collect(b)
@test (a == collect(1:length(a)))
@test (length(b) == length(a))
assertLessEqual(self, length(b), i)
alloc = __alloc__(b)
assertGreater(self, alloc, length(b))
end
end

@oodef mutable struct ByteArrayTest <: {BaseBytesTest, unittest.TestCase}
                    
                    test_exhausted_iterator
type2test
                    
function new(test_exhausted_iterator = test.list_tests.CommonTest.test_exhausted_iterator, type2test = Vector{UInt8})
test_exhausted_iterator = test_exhausted_iterator
type2test = type2test
new(test_exhausted_iterator, type2test)
end

                end
                function test_getitem_error(self::@like(ByteArrayTest))
b = Vector{UInt8}(b"python")
msg = "bytearray indices must be integers or slices"
assertRaisesRegex(self, TypeError, msg) do 
b["a"]
end
end

function test_setitem_error(self::@like(ByteArrayTest))
b = Vector{UInt8}(b"python")
msg = "bytearray indices must be integers or slices"
assertRaisesRegex(self, TypeError, msg) do 
b["a"] = "python"
end
end

function test_nohash(self::@like(ByteArrayTest))
@test_throws
end

function test_bytearray_api(self::@like(ByteArrayTest))
short_sample = b"Hello world\n"
sample = [short_sample; repeat(b"\x00",(20 - length(short_sample)))]
tfn = tempfile.mktemp()
try
readline(tfn) do f 
write(f, short_sample)
end
readline(tfn) do f 
b = Vector{UInt8}(20)
n = readinto(f, b)
end
@test (n == length(short_sample))
@test (collect(b) == collect(sample))
readline(tfn) do f 
write(f, b)
end
readline(tfn) do f 
@test (read(f) == sample)
end
finally
try
rm(tfn)
catch exn
if exn isa OSError
#= pass =#
end
end
end
end

function test_reverse(self::@like(ByteArrayTest))
b = Vector{UInt8}(b"hello")
@test (reverse(b) == nothing)
@test (b == b"olleh")
b = Vector{UInt8}(b"hello1")
reverse(b)
@test (b == b"1olleh")
b = Vector{UInt8}()
reverse(b)
@test !(b)
end

function test_clear(self::@like(ByteArrayTest))
b = Vector{UInt8}(b"python")
clear(b)
@test (b == b"")
b = Vector{UInt8}(b"")
clear(b)
@test (b == b"")
b = Vector{UInt8}(b"")
append(b, Int(codepoint('r')))
clear(b)
append(b, Int(codepoint('p')))
@test (b == b"p")
end

function test_copy(self::@like(ByteArrayTest))
b = Vector{UInt8}(b"abc")
bb = copy(b)
@test (bb == b"abc")
b = Vector{UInt8}(b"")
bb = copy(b)
@test (bb == b"")
b = Vector{UInt8}(b"abc")
bb = copy(b)
@test (b == bb)
assertIsNot(self, b, bb)
append(bb, Int(codepoint('d')))
@test (bb == b"abcd")
@test (b == b"abc")
end

function test_regexps(self::@like(ByteArrayTest))
function by(s::@like(ByteArrayTest))::Vector{UInt8}
return Vector{UInt8}(map(ord, s))
end

b = by("Hello, world")
@test (collect(eachmatch(b"\\w+", b)) == [by("Hello"), by("world")])
end

function test_setitem(self::@like(ByteArrayTest))
b = Vector{UInt8}([1, 2, 3])
b[2] = 100
@test (b == Vector{UInt8}([1, 100, 3]))
b[end] = 200
@test (b == Vector{UInt8}([1, 100, 200]))
b[1] = Indexable(10)
@test (b == Vector{UInt8}([10, 100, 200]))
try
b[4] = 0
fail(self, "Didn\'t raise IndexError")
catch exn
if exn isa IndexError
#= pass =#
end
end
try
b[end - 9] = 0
fail(self, "Didn\'t raise IndexError")
catch exn
if exn isa IndexError
#= pass =#
end
end
try
b[1] = 256
fail(self, "Didn\'t raise ValueError")
catch exn
if exn isa ValueError
#= pass =#
end
end
try
b[1] = Indexable(-1)
fail(self, "Didn\'t raise ValueError")
catch exn
if exn isa ValueError
#= pass =#
end
end
try
b[1] = nothing
fail(self, "Didn\'t raise TypeError")
catch exn
if exn isa TypeError
#= pass =#
end
end
end

function test_delitem(self::@like(ByteArrayTest))
b = Vector{UInt8}(0:9)
# Delete Unsupported
# del(b)
@test (b == Vector{UInt8}(1:9))
# Delete Unsupported
# del(b)
@test (b == Vector{UInt8}(1:8))
# Delete Unsupported
# del(b)
@test (b == Vector{UInt8}([1, 2, 3, 4, 6, 7, 8]))
end

function test_setslice(self::@like(ByteArrayTest))
b = Vector{UInt8}(0:9)
@test (collect(b) == collect(0:9))
b[1:5] .= Vector{UInt8}([1, 1, 1, 1, 1])
@test (b == Vector{UInt8}([1, 1, 1, 1, 1, 5, 6, 7, 8, 9]))
deleteat!(b, 0:end - 5)
@test (b == Vector{UInt8}([5, 6, 7, 8, 9]))
b[1:0] .= Vector{UInt8}([0, 1, 2, 3, 4])
@test (b == Vector{UInt8}(0:9))
b[-7:end - 3] .= Vector{UInt8}([100, 101])
@test (b == Vector{UInt8}([0, 1, 2, 100, 101, 7, 8, 9]))
b[4:5] = [3, 4, 5, 6]
@test (b == Vector{UInt8}(0:9))
b[4:0] = [42, 42, 42]
@test (b == Vector{UInt8}([0, 1, 2, 42, 42, 42, 3, 4, 5, 6, 7, 8, 9]))
b[4:end] .= b"foo"
@test (b == Vector{UInt8}([0, 1, 2, 102, 111, 111]))
b[begin:3] = memoryview(b"foo")
@test (b == Vector{UInt8}([102, 111, 111, 102, 111, 111]))
b[4:4] = []
@test (b == Vector{UInt8}([102, 111, 111, 111, 111]))
for elem in [5, -5, 0, Int(floor(1e+21)), "str", 2.3, ["a", "b"], [b"a", b"b"], [[]]]
@test_throws TypeError do 
b[4:4] = elem
end
end
for elem in [[254, 255, 256], [-256, 9000]]
@test_throws ValueError do 
b[4:4] = elem
end
end
end

function test_setslice_extend(self::@like(ByteArrayTest))
b = Vector{UInt8}(0:99)
@test (collect(b) == collect(0:99))
deleteat!(b, begin:10)
@test (collect(b) == collect(10:99))
extend(b, 100:109)
@test (collect(b) == collect(10:109))
end

function test_fifo_overrun(self::@like(ByteArrayTest))
b = Vector{UInt8}(10)
pop(b)
deleteat!(b, begin:1)
b += bytes(2)
# Delete Unsupported
# del(b)
end

function test_del_expand(self::@like(ByteArrayTest))
b = Vector{UInt8}(10)
size_ = sys.getsizeof(b)
deleteat!(b, begin:1)
assertLessEqual(self, sys.getsizeof(b), size_)
end

function test_extended_set_del_slice(self::@like(ByteArrayTest))
indices = (0, nothing, 1, 3, 19, 300, 1 << 333, typemax(Int), -1, -2, -31, -300)
for start in indices
for stop in indices
for step_ in indices[2:end]
L = collect(0:254)
b = Vector{UInt8}(L)
data = L[start + 1:step_:stop]
reverse(data)
L[start + 1:step_:stop] = data
b[start + 1:step_:stop] = data
@test (b == Vector{UInt8}(L))
deleteat!(L, start + 1:step_:stop)
deleteat!(b, start + 1:step_:stop)
@test (b == Vector{UInt8}(L))
end
end
end
end

function test_setslice_trap(self::@like(ByteArrayTest))
b = Vector{UInt8}(0:255)
b[9:end] .= b
@test (b == Vector{UInt8}([collect(0:7); collect(0:255)]))
end

function test_iconcat(self::@like(ByteArrayTest))
b = Vector{UInt8}(b"abc")
b1 = b
b += b"def"
@test (b == b"abcdef")
@test (b == b1)
@test self === b
b += b"xyz"
@test (b == b"abcdefxyz")
try
b += ""
catch exn
if exn isa TypeError
#= pass =#
end
end
end

function test_irepeat(self::@like(ByteArrayTest))
b = Vector{UInt8}(b"abc")
b1 = b
b *= 3
@test (b == b"abcabcabc")
@test (b == b1)
@test self === b
end

function test_irepeat_1char(self::@like(ByteArrayTest))
b = Vector{UInt8}(b"x")
b1 = b
b *= 100
@test (b == repeat(b"x",100))
@test (b == b1)
@test self === b
end

function test_alloc(self::@like(ByteArrayTest))
b = Vector{UInt8}()
alloc = __alloc__(b)
assertGreaterEqual(self, alloc, 0)
seq = [alloc]
for i in 0:99
b += b"x"
alloc = __alloc__(b)
assertGreater(self, alloc, length(b))
if alloc ∉ seq
push!(seq, alloc)
end
end
end

@resumable function test_init_alloc(self::@like(ByteArrayTest))
b = Vector{UInt8}()
b(g())
@test (collect(b) == collect(1:99))
@test (length(b) == 99)
alloc = __alloc__(b)
assertGreater(self, alloc, length(b))
end

function test_extend(self::@like(ByteArrayTest))
orig = b"hello"
a = Vector{UInt8}(orig)
extend(a, a)
@test (a == [orig; orig])
@test (a[6:end] == orig)
a = Vector{UInt8}(b"")
extend(a, map(Int64, repeat(orig,25)))
extend(a, (parse(Int, x) for x in repeat(orig,25)))
@test (a == repeat(orig,50))
@test (a[length(a) - 5 + 1:end] == orig)
a = Vector{UInt8}(b"")
extend(a, (x for x in map(Int64, repeat(orig,50))))
@test (a == repeat(orig,50))
@test (a[length(a) - 5 + 1:end] == orig)
a = Vector{UInt8}(b"")
extend(a, collect(map(Int64, repeat(orig,50))))
@test (a == repeat(orig,50))
@test (a[length(a) - 5 + 1:end] == orig)
a = Vector{UInt8}(b"")
@test_throws
@test_throws
@test (length(a) == 0)
a = Vector{UInt8}(b"")
extend(a, [Indexable(Int(codepoint('a')))])
@test (a == b"a")
end

function test_remove(self::@like(ByteArrayTest))
b = Vector{UInt8}(b"hello")
remove(b, Int(codepoint('l')))
@test (b == b"helo")
remove(b, Int(codepoint('l')))
@test (b == b"heo")
@test_throws
@test_throws
@test_throws
remove(b, Int(codepoint('o')))
remove(b, Int(codepoint('h')))
@test (b == b"e")
@test_throws
remove(b, Indexable(Int(codepoint('e'))))
@test (b == b"")
c = Vector{UInt8}([126, 127, 128, 129])
remove(c, 127)
@test (c == bytes([126, 128, 129]))
remove(c, 129)
@test (c == bytes([126, 128]))
end

function test_pop(self::@like(ByteArrayTest))
b = Vector{UInt8}(b"world")
@test (pop(b) == Int(codepoint('d')))
@test (pop(b, 0) == Int(codepoint('w')))
@test (pop(b, -2) == Int(codepoint('r')))
@test_throws
@test_throws
@test (pop(Vector{UInt8}(b"\xff")) == 255)
end

function test_nosort(self::@like(ByteArrayTest))
@test_throws
end

function test_append(self::@like(ByteArrayTest))
b = Vector{UInt8}(b"hell")
append(b, Int(codepoint('o')))
@test (b == b"hello")
@test (append(b, 100) == nothing)
b = Vector{UInt8}()
append(b, Int(codepoint('A')))
@test (length(b) == 1)
@test_throws
b = Vector{UInt8}()
append(b, Indexable(Int(codepoint('A'))))
@test (b == b"A")
end

function test_insert(self::@like(ByteArrayTest))
b = Vector{UInt8}(b"msssspp")
insert(b, 1, Int(codepoint('i')))
insert(b, 4, Int(codepoint('i')))
insert(b, -2, Int(codepoint('i')))
insert(b, 1000, Int(codepoint('i')))
@test (b == b"mississippi")
@test_throws
b = Vector{UInt8}()
insert(b, 0, Indexable(Int(codepoint('A'))))
@test (b == b"A")
end

function test_copied(self::@like(ByteArrayTest))
b = Vector{UInt8}(b"abc")
assertIsNot(self, b, replace(b, b"abc", b"cde", 0))
t = Vector{UInt8}([i for i in 0:255])
x = Vector{UInt8}(b"")
assertIsNot(self, x, replace!(collect(x), t...))
end

function test_partition_bytearray_doesnt_share_nullstring(self::@like(ByteArrayTest))
(a, b, c) = partition(Vector{UInt8}(b"x"), b"y")
@test (b == b"")
@test (c == b"")
assertIsNot(self, b, c)
b += b"!"
@test (c == b"")
(a, b, c) = partition(Vector{UInt8}(b"x"), b"y")
@test (b == b"")
@test (c == b"")
(b, c, a) = rpartition(Vector{UInt8}(b"x"), b"y")
@test (b == b"")
@test (c == b"")
assertIsNot(self, b, c)
b += b"!"
@test (c == b"")
(c, b, a) = rpartition(Vector{UInt8}(b"x"), b"y")
@test (b == b"")
@test (c == b"")
end

function test_resize_forbidden(self::@like(ByteArrayTest))
b = Vector{UInt8}(0:9)
v = memoryview(b)
function resize(n::@like(ByteArrayTest))
b[1:end - 1] .= n + 1:2*n - 2
end

resize(10)
orig = b[begin:end]
@test_throws
@test (b == orig)
@test_throws
@test (b == orig)
@test_throws
@test (b == orig)
@test_throws
@test (b == orig)
@test_throws
@test (b == orig)
function delitem()
# Delete Unsupported
# del(b)
end

@test_throws
@test (b == orig)
function delslice()
b[1:2:end - 1] .= b""
end

@test_throws
@test (b == orig)
end

function test_obsolete_write_lock(self::@like(ByteArrayTest))
@test_throws
end

function test_iterator_pickling2(self::@like(ByteArrayTest))
orig = Vector{UInt8}(b"abc")
data = collect(b"qwerty")
for proto in 0:pickle.HIGHEST_PROTOCOL
itorig = (x for x in orig)
d = pickle.dumps((itorig, orig), proto)
(it, b) = pickle.loads(d)
b[begin:end] = data
@test (type_(it) == type_(itorig))
@test (collect(it) == data)
next(itorig)
d = pickle.dumps((itorig, orig), proto)
(it, b) = pickle.loads(d)
b[begin:end] = data
@test (type_(it) == type_(itorig))
@test (collect(it) == data[2:end])
for i in 1:length(orig) - 1
next(itorig)
end
d = pickle.dumps((itorig, orig), proto)
(it, b) = pickle.loads(d)
b[begin:end] = data
@test (type_(it) == type_(itorig))
@test (collect(it) == data[length(orig) + 1:end])
@test_throws
d = pickle.dumps((itorig, orig), proto)
(it, b) = pickle.loads(d)
b[begin:end] = data
@test (collect(it) == [])
end
end

function test_iterator_length_hint(self::@like(ByteArrayTest))
ba = Vector{UInt8}(b"ab")
it = (x for x in ba)
next(it)
clear(ba)
@test (collect(it) == [])
end

function test_repeat_after_setslice(self::@like(ByteArrayTest))
b = Vector{UInt8}(b"abc")
b[begin:2] .= b"x"
b1 = repeat(b,1)
b3 = repeat(b,3)
@test (b1 == b"xc")
@test (b1 == b)
@test (b3 == b"xcxcxc")
end


@oodef mutable struct AssortedBytesTest <: unittest.TestCase
                    
                    
                    
                end
                function test_repr_str(self::@like(AssortedBytesTest))
for f in (String, repr)
@test (f(Vector{UInt8}()) == "bytearray(b\'\')")
@test (f(Vector{UInt8}([0])) == "bytearray(b\'\\x00\')")
@test (f(Vector{UInt8}([0, 1, 254, 255])) == "bytearray(b\'\\x00\\x01\\xfe\\xff\')")
@test (f(b"abc") == "b\'abc\'")
@test (f(b"'") == "b\"\'\"")
@test (f(b"\'\"") == "b\'\\\'\"\'")
end
end

function test_format(self::@like(AssortedBytesTest))
for b in (b"abc", Vector{UInt8}(b"abc"))
@test (b == string(b))
@test (b == string(b))
assertRaisesRegex(self, TypeError, "\\b$(re.escape(type_(b).__name__))\\b") do 
b
end
end
end

function test_compare_bytes_to_bytearray(self::@like(AssortedBytesTest))
@test (b"abc" == bytes(b"abc") == true)
@test (b"ab" != bytes(b"abc") == true)
@test (b"ab" <= bytes(b"abc") == true)
@test (b"ab" < bytes(b"abc") == true)
@test (b"abc" >= bytes(b"ab") == true)
@test (b"abc" > bytes(b"ab") == true)
@test (b"abc" != bytes(b"abc") == false)
@test (b"ab" == bytes(b"abc") == false)
@test (b"ab" > bytes(b"abc") == false)
@test (b"ab" >= bytes(b"abc") == false)
@test (b"abc" < bytes(b"ab") == false)
@test (b"abc" <= bytes(b"ab") == false)
@test (bytes(b"abc") == b"abc" == true)
@test (bytes(b"ab") != b"abc" == true)
@test (bytes(b"ab") <= b"abc" == true)
@test (bytes(b"ab") < b"abc" == true)
@test (bytes(b"abc") >= b"ab" == true)
@test (bytes(b"abc") > b"ab" == true)
@test (bytes(b"abc") != b"abc" == false)
@test (bytes(b"ab") == b"abc" == false)
@test (bytes(b"ab") > b"abc" == false)
@test (bytes(b"ab") >= b"abc" == false)
@test (bytes(b"abc") < b"ab" == false)
@test (bytes(b"abc") <= b"ab" == false)
end

function test_doc(self::@like(AssortedBytesTest))
assertIsNotNone(self, Vector{UInt8}.__doc__)
@test startswith(Vector{UInt8}.__doc__, "bytearray(")
assertIsNotNone(self, Array{UInt8}.__doc__)
@test startswith(Array{UInt8}.__doc__, "bytes(")
end

function test_from_bytearray(self::@like(AssortedBytesTest))
sample = bytes(b"Hello world\n\x80\x81\xfe\xff")
buf = memoryview(sample)
b = Vector{UInt8}(buf)
@test (b == Vector{UInt8}(sample))
end

function test_to_str(self::@like(AssortedBytesTest))
@test (string(b"") == "b\'\'")
@test (string(b"x") == "b\'x\'")
@test (string(b"\x80") == "b\'\\x80\'")
@test (string(Vector{UInt8}(b"")) == "bytearray(b\'\')")
@test (string(Vector{UInt8}(b"x")) == "bytearray(b\'x\')")
@test (string(Vector{UInt8}(b"\x80")) == "bytearray(b\'\\x80\')")
end

function test_literal(self::@like(AssortedBytesTest))
tests = [(b"Wonderful spam", "Wonderful spam"), (b"Wonderful spam too", "Wonderful spam too"), (b"\xaa\x00\x00\x80", "ª\0\0\x80"), (b"\\xaa\\x00\\000\\200", "\\xaa\\x00\\000\\200")]
for (b, s) in tests
@test (b == Vector{UInt8}(s))
end
for c in 128:255
@test_throws
end
end

function test_split_bytearray(self::@like(AssortedBytesTest))
@test (split(b"a b", memoryview(b" ")) == [b"a", b"b"])
end

function test_rsplit_bytearray(self::@like(AssortedBytesTest))
@test (rsplit(b"a b", memoryview(b" ")) == [b"a", b"b"])
end

function test_return_self(self::@like(AssortedBytesTest))
b = Vector{UInt8}()
assertIsNot(self, replace(b, b"", b""), b)
end

function test_compare(self::@like(AssortedBytesTest))
function bytes_warning()
return warnings_helper.check_warnings(("", BytesWarning))
end

bytes_warning() do 
b"" == ""
end
bytes_warning() do 
"" == b""
end
bytes_warning() do 
b"" != ""
end
bytes_warning() do 
"" != b""
end
bytes_warning() do 
Vector{UInt8}(b"") == ""
end
bytes_warning() do 
"" == Vector{UInt8}(b"")
end
bytes_warning() do 
Vector{UInt8}(b"") != ""
end
bytes_warning() do 
"" != Vector{UInt8}(b"")
end
bytes_warning() do 
b"\x00" == 0
end
bytes_warning() do 
0 == b"\x00"
end
bytes_warning() do 
b"\x00" != 0
end
bytes_warning() do 
0 != b"\x00"
end
end


@oodef mutable struct BytearrayPEP3137Test <: unittest.TestCase
                    
                    
                    
                end
                function marshal(self::@like(BytearrayPEP3137Test), x)::Vector{UInt8}
return Vector{UInt8}(x)
end

function test_returns_new_copy(self::@like(BytearrayPEP3137Test))
val = marshal(self, b"1234")
for methname in ("zfill", "rjust", "ljust", "center")
method = getfield(val, :methname)
newval = method(3)
@test (val == newval)
assertIsNot(self, val, newval, methname * " returned self on a mutable object")
end
for expr in ("val.split()[0]", "val.rsplit()[0]", "val.partition(b\".\")[0]", "val.rpartition(b\".\")[2]", "val.splitlines()[0]", "val.replace(b\"\", b\"\")")
newval = py"expr"
@test (val == newval)
assertIsNot(self, val, newval, expr * " returned val on a mutable object")
end
sep = marshal(self, b"")
newval = join(sep, [val])
@test (val == newval)
assertIsNot(self, val, newval)
end


@oodef mutable struct FixedStringTest <: test.string_tests.BaseTest
                    
                    contains_bytes::Bool
                    
function new(contains_bytes::Bool = true)
contains_bytes = contains_bytes
new(contains_bytes)
end

                end
                function fixtype(self::@like(FixedStringTest), obj)
if isa(obj, String)
return type2test(self, encode(obj, "utf-8"))
end
return test.string_tests.BaseTest(obj)
end


@oodef mutable struct ByteArrayAsStringTest <: {FixedStringTest, unittest.TestCase}
                    
                    type2test
                    
function new(type2test = Vector{UInt8})
type2test = type2test
new(type2test)
end

                end
                

@oodef mutable struct BytesAsStringTest <: {FixedStringTest, unittest.TestCase}
                    
                    type2test
                    
function new(type2test = Array{UInt8})
type2test = type2test
new(type2test)
end

                end
                

@oodef mutable struct B1 <: self.basetype
                    
                    
                    
                end
                function __new__(cls::@like(B1), value)
me = __new__(self.basetype, cls)
me.foo = "bar"
return me
end


@oodef mutable struct B2 <: self.basetype
                    
                    
                    
function new(args...)
if self.basetype !== Array{UInt8}
basetype(self, me, args..., None = kwargs)
end
me.foo = "bar"
@mk begin

end
end

                end
                

@oodef mutable struct SubclassTest
                    
                    
                    
                end
                function test_basic(self::@like(SubclassTest))
assertTrue(self, self.type2test <: self.basetype)
assertIsInstance(self, type2test(self), self.basetype)
(a, b) = (b"abcd", b"efgh")
(_a, _b) = (type2test(self, a), type2test(self, b))
assertTrue(self, _a == _a)
assertTrue(self, _a != _b)
assertTrue(self, _a < _b)
assertTrue(self, _a <= _b)
assertTrue(self, _b >= _a)
assertTrue(self, _b > _a)
assertIsNot(self, _a, a)
assertEqual(self, a + b, _a + _b)
assertEqual(self, a + b, a + _b)
assertEqual(self, a + b, _a + b)
assertTrue(self, (a*5) == (_a*5))
end

function test_join(self::@like(SubclassTest))
s1 = type2test(self, b"abcd")
s2 = join(basetype(self), [s1])
assertIsNot(self, s1, s2)
assertIs(self, type_(s2), self.basetype, type_(s2))
s3 = join(s1, [b"abcd"])
assertIs(self, type_(s3), self.basetype)
end

function test_pickle(self::@like(SubclassTest))
a = type2test(self, b"abcd")
a.x = 10
a.y = type2test(self, b"efgh")
for proto in 0:pickle.HIGHEST_PROTOCOL
b = pickle.loads(pickle.dumps(a, proto))
assertNotEqual(self, id(a), id(b))
assertEqual(self, a, b)
assertEqual(self, a.x, b.x)
assertEqual(self, a.y, b.y)
assertEqual(self, type_(a), type_(b))
assertEqual(self, type_(a.y), type_(b.y))
end
end

function test_copy(self::@like(SubclassTest))
a = type2test(self, b"abcd")
a.x = 10
a.y = type2test(self, b"efgh")
for copy_method in (copy.copy, copy.deepcopy)
b = copy_method(a)
assertNotEqual(self, id(a), id(b))
assertEqual(self, a, b)
assertEqual(self, a.x, b.x)
assertEqual(self, a.y, b.y)
assertEqual(self, type_(a), type_(b))
assertEqual(self, type_(a.y), type_(b.y))
end
end

function test_fromhex(self::@like(SubclassTest))
b = fromhex(self.type2test, "1a2B30")
assertEqual(self, b, b"\x1a+0")
assertIs(self, type_(b), self.type2test)
b = B1.fromhex("1a2B30")
assertEqual(self, b, b"\x1a+0")
assertIs(self, type_(b), B1)
assertEqual(self, b.foo, "bar")
b = B2.fromhex("1a2B30")
assertEqual(self, b, b"\x1a+0")
assertIs(self, type_(b), B2)
assertEqual(self, b.foo, "bar")
end


@oodef mutable struct ByteArraySubclass <: Vector{UInt8}
                    
                    
                    
                end
                

@oodef mutable struct BytesSubclass <: Array{UInt8}
                    
                    
                    
                end
                

@oodef mutable struct OtherBytesSubclass <: Array{UInt8}
                    
                    
                    
                end
                

@oodef mutable struct subclass <: Vector{UInt8}
                    
                    
                    
function new(newarg = 1, args...)
Vector{UInt8}(me)
@mk begin

end
end

                end
                

@oodef mutable struct ByteArraySubclassTest <: {SubclassTest, unittest.TestCase}
                    
                    basetype
type2test::AbstractByteArraySubclass
                    
function new(basetype = Vector{UInt8}, type2test::ByteArraySubclass = ByteArraySubclass)
basetype = basetype
type2test = type2test
new(basetype, type2test)
end

                end
                function test_init_override(self::@like(ByteArraySubclassTest))
x = subclass(4, b"abcd")
x = subclass(4, source = b"abcd")
@test (x == b"abcd")
x = subclass(newarg = 4, source = b"abcd")
@test (x == b"abcd")
end


@oodef mutable struct BytesSubclassTest <: {SubclassTest, unittest.TestCase}
                    
                    basetype
type2test::AbstractBytesSubclass
                    
function new(basetype = Array{UInt8}, type2test::BytesSubclass = BytesSubclass)
basetype = basetype
type2test = type2test
new(basetype, type2test)
end

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
rat_test_case = RatTestCase()
test_gcd(rat_test_case)
test_constructor(rat_test_case)
test_add(rat_test_case)
test_sub(rat_test_case)
test_mul(rat_test_case)
test_div(rat_test_case)
test_floordiv(rat_test_case)
test_eq(rat_test_case)
test_true_div(rat_test_case)
operation_order_tests = OperationOrderTests()
test_comparison_orders(operation_order_tests)
fallback_blocking_tests = FallbackBlockingTests()
test_fallback_rmethod_blocking(fallback_blocking_tests)
test_fallback_ne_blocking(fallback_blocking_tests)
bool_test = BoolTest()
test_repr(bool_test)
test_str(bool_test)
test_int(bool_test)
test_float(bool_test)
test_math(bool_test)
test_convert(bool_test)
test_keyword_args(bool_test)
test_format(bool_test)
test_hasattr(bool_test)
test_callable(bool_test)
test_isinstance(bool_test)
test_issubclass(bool_test)
test_contains(bool_test)
test_string(bool_test)
test_boolean(bool_test)
test_fileclosed(bool_test)
test_types(bool_test)
test_operator(bool_test)
test_marshal(bool_test)
test_pickle(bool_test)
test_picklevalues(bool_test)
test_convert_to_bool(bool_test)
test_from_bytes(bool_test)
test_sane_len(bool_test)
test_blocked(bool_test)
test_real_and_imag(bool_test)
test_bool_called_at_least_once(bool_test)
builtin_test = BuiltinTest()
test_import(builtin_test)
test_abs(builtin_test)
test_all(builtin_test)
test_any(builtin_test)
test_ascii(builtin_test)
test_neg(builtin_test)
test_callable(builtin_test)
test_chr(builtin_test)
test_cmp(builtin_test)
test_compile(builtin_test)
test_compile_top_level_await_no_coro(builtin_test)
test_compile_top_level_await(builtin_test)
test_compile_top_level_await_invalid_cases(builtin_test)
test_compile_async_generator(builtin_test)
test_delattr(builtin_test)
test_dir(builtin_test)
test_divmod(builtin_test)
test_eval(builtin_test)
test_general_eval(builtin_test)
test_exec(builtin_test)
test_exec_globals(builtin_test)
test_exec_redirected(builtin_test)
test_filter(builtin_test)
test_filter_pickle(builtin_test)
test_getattr(builtin_test)
test_hasattr(builtin_test)
test_hash(builtin_test)
test_hex(builtin_test)
test_id(builtin_test)
test_iter(builtin_test)
test_isinstance(builtin_test)
test_issubclass(builtin_test)
test_len(builtin_test)
test_map(builtin_test)
test_map_pickle(builtin_test)
test_max(builtin_test)
test_min(builtin_test)
test_next(builtin_test)
test_oct(builtin_test)
test_open(builtin_test)
test_open_default_encoding(builtin_test)
test_open_non_inheritable(builtin_test)
test_ord(builtin_test)
test_pow(builtin_test)
test_input(builtin_test)
test_repr(builtin_test)
test_round(builtin_test)
test_round_large(builtin_test)
test_bug_27936(builtin_test)
test_setattr(builtin_test)
test_sum(builtin_test)
test_type(builtin_test)
test_vars(builtin_test)
test_zip(builtin_test)
test_zip_pickle(builtin_test)
test_zip_pickle_strict(builtin_test)
test_zip_pickle_strict_fail(builtin_test)
test_zip_bad_iterable(builtin_test)
test_zip_strict(builtin_test)
test_zip_strict_iterators(builtin_test)
test_zip_strict_error_handling(builtin_test)
test_zip_strict_error_handling_stopiteration(builtin_test)
test_zip_result_gc(builtin_test)
test_format(builtin_test)
test_bin(builtin_test)
test_bytearray_translate(builtin_test)
test_bytearray_extend_error(builtin_test)
test_construct_singletons(builtin_test)
test_warning_notimplemented(builtin_test)
test_breakpoint = TestBreakpoint()
setUp(test_breakpoint)
test_breakpoint(test_breakpoint)
test_breakpoint_with_breakpointhook_set(test_breakpoint)
test_breakpoint_with_breakpointhook_reset(test_breakpoint)
test_breakpoint_with_args_and_keywords(test_breakpoint)
test_breakpoint_with_passthru_error(test_breakpoint)
test_envar_good_path_builtin(test_breakpoint)
test_envar_good_path_other(test_breakpoint)
test_envar_good_path_noop_0(test_breakpoint)
test_envar_good_path_empty_string(test_breakpoint)
test_envar_unimportable(test_breakpoint)
test_envar_ignored_when_hook_is_set(test_breakpoint)
pty_tests = PtyTests()
test_input_tty(pty_tests)
test_input_tty_non_ascii(pty_tests)
test_input_tty_non_ascii_unicode_errors(pty_tests)
test_input_no_stdout_fileno(pty_tests)
test_sorted = TestSorted()
test_basic(test_sorted)
test_bad_arguments(test_sorted)
test_inputtypes(test_sorted)
test_baddecorator(test_sorted)
shutdown_test = ShutdownTest()
test_cleanup(shutdown_test)
test_type = TestType()
test_new_type(test_type)
test_type_nokwargs(test_type)
test_type_name(test_type)
test_type_qualname(test_type)
test_type_doc(test_type)
test_bad_args(test_type)
test_bad_slots(test_type)
test_namespace_order(test_type)
bytes_test = BytesTest()
test_getitem_error(bytes_test)
test_buffer_is_readonly(bytes_test)
test_bytes_blocking(bytes_test)
test_repeat_id_preserving(bytes_test)
byte_array_test = ByteArrayTest()
test_getitem_error(byte_array_test)
test_setitem_error(byte_array_test)
test_nohash(byte_array_test)
test_bytearray_api(byte_array_test)
test_reverse(byte_array_test)
test_clear(byte_array_test)
test_copy(byte_array_test)
test_regexps(byte_array_test)
test_setitem(byte_array_test)
test_delitem(byte_array_test)
test_setslice(byte_array_test)
test_setslice_extend(byte_array_test)
test_fifo_overrun(byte_array_test)
test_del_expand(byte_array_test)
test_extended_set_del_slice(byte_array_test)
test_setslice_trap(byte_array_test)
test_iconcat(byte_array_test)
test_irepeat(byte_array_test)
test_irepeat_1char(byte_array_test)
test_alloc(byte_array_test)
test_init_alloc(byte_array_test)
test_extend(byte_array_test)
test_remove(byte_array_test)
test_pop(byte_array_test)
test_nosort(byte_array_test)
test_append(byte_array_test)
test_insert(byte_array_test)
test_copied(byte_array_test)
test_partition_bytearray_doesnt_share_nullstring(byte_array_test)
test_resize_forbidden(byte_array_test)
test_obsolete_write_lock(byte_array_test)
test_iterator_pickling2(byte_array_test)
test_iterator_length_hint(byte_array_test)
test_repeat_after_setslice(byte_array_test)
assorted_bytes_test = AssortedBytesTest()
test_repr_str(assorted_bytes_test)
test_format(assorted_bytes_test)
test_compare_bytes_to_bytearray(assorted_bytes_test)
test_doc(assorted_bytes_test)
test_from_bytearray(assorted_bytes_test)
test_to_str(assorted_bytes_test)
test_literal(assorted_bytes_test)
test_split_bytearray(assorted_bytes_test)
test_rsplit_bytearray(assorted_bytes_test)
test_return_self(assorted_bytes_test)
test_compare(assorted_bytes_test)
bytearray_p_e_p3137_test = BytearrayPEP3137Test()
test_returns_new_copy(bytearray_p_e_p3137_test)
byte_array_as_string_test = ByteArrayAsStringTest()
bytes_as_string_test = BytesAsStringTest()
byte_array_subclass_test = ByteArraySubclassTest()
test_init_override(byte_array_subclass_test)
bytes_subclass_test = BytesSubclassTest()
end