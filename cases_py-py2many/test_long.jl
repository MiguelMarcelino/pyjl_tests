using OrderedCollections
using Test



import random


abstract type AbstractLongTest end
abstract type Abstractmyint <: int end
abstract type Abstractmyint2 <: int end
abstract type Abstractmyint3 <: int end
abstract type AbstractInteger <: int end
SHIFT = sys.int_info.bits_per_digit
BASE = 2^SHIFT
MASK = BASE - 1
KARATSUBA_CUTOFF = 70
MAXDIGITS = 15
special = [0, 1, 2, BASE, BASE >> 1, 6148914691236517205, 12297829382473034410]
p2 = 4
for i in 0:2*SHIFT - 1
push!(special, p2 - 1)
p2 = p2 << 1
end
#Delete Unsupported
del(p2)
special = special + [~(x) for x in special] + [-(x) for x in special]
DBL_MAX = sys.float_info.max
DBL_MAX_EXP = sys.float_info.max_exp
DBL_MIN_EXP = sys.float_info.min_exp
DBL_MANT_DIG = sys.float_info.mant_dig
DBL_MIN_OVERFLOW = 2^DBL_MAX_EXP - 2^((DBL_MAX_EXP - DBL_MANT_DIG) - 1)
function int_to_float(n)::Float64
#= 
    Correctly-rounded integer-to-float conversion.

     =#
PRECISION = sys.float_info.mant_dig + 2
SHIFT_MAX = sys.float_info.max_exp - PRECISION
Q_MAX = 1 << PRECISION
ROUND_HALF_TO_EVEN_CORRECTION = [0, -1, -2, 1, 0, -1, 2, 1]
if n == 0
return 0.0
elseif n < 0
return -int_to_float(-(n))
end
shift = bit_length(n) - PRECISION
q = shift < 0 ? (n << -(shift)) : ((n >> shift) | Bool(n & ~(-1 << shift)))
q += ROUND_HALF_TO_EVEN_CORRECTION[q & 7]
if (shift + q === Q_MAX) > SHIFT_MAX
throw(OverflowError("integer too large to convert to float"))
end
@assert((q % 4) == 0 && (q ÷ 4) <= (2^sys.float_info.mant_dig))
@assert((q*2^shift) <= sys.float_info.max)
return ldexp(float(q), shift)
end

function truediv(a, b)
#= Correctly-rounded true division for integers. =#
negative = (a  ⊻  b) < 0
a, b = (abs(a), abs(b))
if !(b)
throw(ZeroDivisionError("division by zero"))
end
if a >= (DBL_MIN_OVERFLOW*b)
throw(OverflowError("int/int too large to represent as a float"))
end
d = bit_length(a) - bit_length(b)
if d >= 0 && a >= (2^d*b) || d < 0 && (a*2^-(d)) >= b
d += 1
end
exp = max(d, DBL_MIN_EXP) - DBL_MANT_DIG
a, b = (a << max(-(exp), 0), b << max(exp, 0))
q, r = div(a)
if (2*r) > b || (2*r) === b && (q % 2) == 1
q += 1
end
result = ldexp(q, exp)
return negative ? (-(result)) : (result)
end

mutable struct LongTest <: AbstractLongTest
n
d::Int64
foo::String
end
function getran(self, ndigits)::Int64
assertGreater(self, ndigits, 0)
nbits_hi = ndigits*SHIFT
nbits_lo = (nbits_hi - SHIFT) + 1
answer = 0
nbits = 0
r = Int(random()*SHIFT*2) | 1
while nbits < nbits_lo
bits = (r >> 1) + 1
bits = min(bits, nbits_hi - nbits)
@test 1 <= bits <= SHIFT
nbits = nbits + bits
answer = answer << bits
if (r & 1) != 0
answer = answer | ((1 << bits) - 1)
end
r = Int(random()*SHIFT*2)
end
@test nbits_lo <= nbits <= nbits_hi
if random() < 0.5
answer = -(answer)
end
return answer
end

function getran2(ndigits)::Int64
answer = 0
for i in 0:ndigits - 1
answer = (answer << SHIFT) | randint(0, MASK)
end
if random() < 0.5
answer = -(answer)
end
return answer
end

function check_division(self, x, y)
eq = self.assertEqual
subTest(self, x = x, y = y) do 
q, r = div(x)
q2, r2 = (x ÷ y, x % y)
pab, pba = (x*y, y*x)
eq(pab, pba, "multiplication does not commute")
eq(q, q2, "divmod returns different quotient than /")
eq(r, r2, "divmod returns different mod than %")
eq(x, q*y + r, "x != q*y + r after divmod")
if y > 0
@test 0 <= r < y
else
@test y < r <= 0
end
end
end

function test_division(self)
digits = append!(collect(1:MAXDIGITS), collect(KARATSUBA_CUTOFF:KARATSUBA_CUTOFF + 13))
push!(digits, KARATSUBA_CUTOFF*3)
for lenx in digits
x = getran(self, lenx)
for leny in digits
y = getran(self, leny) || 1
check_division(self, x, y)
end
end
check_division(self, 1231948412290879395966702881, 1147341367131428698)
check_division(self, 815427756481275430342312021515587883, 707270836069027745)
check_division(self, 627976073697012820849443363563599041, 643588798496057020)
check_division(self, 1115141373653752303710932756325578065, 1038556335171453937726882627)
check_division(self, 922498905405436751940989320930368494, 949985870686786135626943396)
check_division(self, 768235853328091167204009652174031844, 1091555541180371554426545266)
check_division(self, 20172188947443, 615611397)
check_division(self, 1020908530270155025, 950795710)
check_division(self, 128589565723112408, 736393718)
check_division(self, 609919780285761575, 18613274546784)
check_division(self, 710031681576388032, 26769404391308)
check_division(self, 1933622614268221, 30212853348836)
end

function test_karatsuba(self)
digits = append!(collect(1:4), collect(KARATSUBA_CUTOFF:KARATSUBA_CUTOFF + 9))
append!(digits, [KARATSUBA_CUTOFF*10, KARATSUBA_CUTOFF*100])
bits = [digit*SHIFT for digit in digits]
for abits in bits
a = (1 << abits) - 1
for bbits in bits
if bbits < abits
continue;
end
subTest(self, abits = abits, bbits = bbits) do 
b = (1 << bbits) - 1
x = a*b
y = (((1 << (abits + bbits)) - (1 << abits)) - (1 << bbits)) + 1
@test (x == y)
end
end
end
end

function check_bitop_identities_1(self, x)
eq = self.assertEqual
subTest(self, x = x) do 
eq(x & 0, 0)
eq(x | 0, x)
eq(x  ⊻  0, x)
eq(x & -1, x)
eq(x | -1, -1)
eq(x  ⊻  -1, ~(x))
eq(x, ~(~(x)))
eq(x & x, x)
eq(x | x, x)
eq(x  ⊻  x, 0)
eq(x & ~(x), 0)
eq(x | ~(x), -1)
eq(x  ⊻  ~(x), -1)
eq(-(x), 1 + ~(x))
eq(-(x), ~(x - 1))
end
for n in 0:2*SHIFT - 1
p2 = 2^n
subTest(self, x = x, n = n, p2 = p2) do 
eq((x << n) >> n, x)
eq(x ÷ p2, x >> n)
eq(x*p2, x << n)
eq(x & -(p2), (x >> n) << n)
eq(x & -(p2), x & ~(p2 - 1))
end
end
end

function check_bitop_identities_2(self, x, y)
eq = self.assertEqual
subTest(self, x = x, y = y) do 
eq(x & y, y & x)
eq(x | y, y | x)
eq(x  ⊻  y, y  ⊻  x)
eq((x  ⊻  y)  ⊻  x, y)
eq(x & y, ~(~(x) | ~(y)))
eq(x | y, ~(~(x) & ~(y)))
eq(x  ⊻  y, (x | y) & ~(x & y))
eq(x  ⊻  y, (x & ~(y)) | (~(x) & y))
eq(x  ⊻  y, (x | y) & (~(x) | ~(y)))
end
end

function check_bitop_identities_3(self, x, y, z)
eq = self.assertEqual
subTest(self, x = x, y = y, z = z) do 
eq((x & y) & z, x & (y & z))
eq((x | y) | z, x | (y | z))
eq((x  ⊻  y)  ⊻  z, x  ⊻  (y  ⊻  z))
eq(x & (y | z), (x & y) | (x & z))
eq(x | (y & z), (x | y) & (x | z))
end
end

function test_bitop_identities(self)
for x in special
check_bitop_identities_1(self, x)
end
digits = 1:MAXDIGITS
for lenx in digits
x = getran(self, lenx)
check_bitop_identities_1(self, x)
for leny in digits
y = getran(self, leny)
check_bitop_identities_2(self, x, y)
check_bitop_identities_3(self, x, y, getran(self, (lenx + leny) ÷ 2))
end
end
end

function slow_format(self, x, base)::Any
digits = []
sign = 0
if x < 0
sign, x = (1, -(x))
end
while x
x, r = div(x)
push!(digits, parse(Int, r))
end
reverse(digits)
digits = digits || [0]
return ("-"[begin:sign] + Dict(2 => "0b", 8 => "0o", 10 => "", 16 => "0x")[base + 1]) + join(("0123456789abcdef"[i + 1] for i in digits), "")
end

function check_format_1(self, x)
for (base, mapper) in ((2, bin), (8, oct), (10, str), (10, repr), (16, hex))
got = mapper(x)
subTest(self, x = x, mapper = mapper.__name__) do 
expected = slow_format(self, x, base)
@test (got == expected)
end
subTest(self, got = got) do 
@test (parse(Int, got) == x)
end
end
end

function test_format(self)
for x in special
check_format_1(self, x)
end
for i in 0:9
for lenx in 1:MAXDIGITS
x = getran(self, lenx)
check_format_1(self, x)
end
end
end

function test_long(self)
LL = [("1" * repeat("0",20), 10^20), ("1" * repeat("0",100), 10^100)]
for (s, v) in LL
for sign in ("", "+", "-")
for prefix in ("", " ", "\t", "  \t\t  ")
ss = prefix * sign + s
vv = v
if sign == "-" && v !== ValueError
vv = -(v)
end
try
@test (parse(Int, ss) == vv)
catch exn
if exn isa ValueError
#= pass =#
end
end
end
end
end
@test_throws ValueError int("123L")
@test_throws ValueError int("123l")
@test_throws ValueError int("0L")
@test_throws ValueError int("-37L")
@test_throws ValueError int("0x32L", 16)
@test_throws ValueError int("1L", 21)
@test (parse(Int, "1L") == 43)
@test (parse(Int, "000") == 0)
@test (parse(Int, "0o123") == 83)
@test (parse(Int, "0x123") == 291)
@test (parse(Int, "0b100") == 4)
@test (parse(Int, " 0O123   ") == 83)
@test (parse(Int, " 0X123  ") == 291)
@test (parse(Int, " 0B100 ") == 4)
@test (parse(Int, "0") == 0)
@test (parse(Int, "+0") == 0)
@test (parse(Int, "-0") == 0)
@test (parse(Int, "00") == 0)
@test_throws ValueError int("08", 0)
@test_throws ValueError int("-012395", 0)
invalid_bases = [-909, 2^31 - 1, 2^31, -(2^31), -(2^31) - 1, 2^63 - 1, 2^63, -(2^63), -(2^63) - 1, 2^100, -(2^100)]
for base in invalid_bases
@test_throws ValueError int("42", base)
end
@test_throws ValueError int("こんにちは")
end

function test_conversion(self)
mutable struct JustLong <: AbstractJustLong

end
function __long__(self)::Int64
return 42
end

assertRaises(self, TypeError, int, JustLong())
mutable struct LongTrunc <: AbstractLongTrunc

end
function __long__(self)::Int64
return 42
end

function __trunc__(self)::Int64
return 1729
end

assertEqual(self, parse(Int, LongTrunc()), 1729)
end

function check_float_conversion(self, n)
try
actual = float(n)
catch exn
if exn isa OverflowError
actual = "overflow"
end
end
try
expected = int_to_float(n)
catch exn
if exn isa OverflowError
expected = "overflow"
end
end
msg = "Error in conversion of integer $() to float.  Got $(), expected $()."
@test (actual == expected)
end

function test_float_conversion(self)
exact_values = [0, 1, 2, 2^53 - 3, 2^53 - 2, 2^53 - 1, 2^53, 2^53 + 2, 2^54 - 4, 2^54 - 2, 2^54, 2^54 + 4]
for x in exact_values
@test (float(x) == x)
@test (float(-(x)) == -(x))
end
for (x, y) in [(1, 0), (2, 2), (3, 4), (4, 4), (5, 4), (6, 6), (7, 8)]
for p in 0:14
@test (Int(floor(float(2^p*(2^53 + x)))) == 2^p*(2^53 + y))
end
end
for (x, y) in [(0, 0), (1, 0), (2, 0), (3, 4), (4, 4), (5, 4), (6, 8), (7, 8), (8, 8), (9, 8), (10, 8), (11, 12), (12, 12), (13, 12), (14, 16), (15, 16)]
for p in 0:14
@test (Int(floor(float(2^p*(2^54 + x)))) == 2^p*(2^54 + y))
end
end
int_dbl_max = parse(Int, DBL_MAX)
top_power = 2^DBL_MAX_EXP
halfway = (int_dbl_max + top_power) ÷ 2
@test (float(int_dbl_max) == DBL_MAX)
@test (float(int_dbl_max + 1) == DBL_MAX)
@test (float(halfway - 1) == DBL_MAX)
@test_throws OverflowError float(halfway)
@test (float(1 - halfway) == -(DBL_MAX))
@test_throws OverflowError float(-(halfway))
@test_throws OverflowError float(top_power - 1)
@test_throws OverflowError float(top_power)
@test_throws OverflowError float(top_power + 1)
@test_throws OverflowError float(2*top_power - 1)
@test_throws OverflowError float(2*top_power)
@test_throws OverflowError float(top_power*top_power)
for p in 0:99
x = 2^p*(2^53 + 1) + 1
y = 2^p*(2^53 + 2)
@test (Int(floor(float(x))) == y)
x = 2^p*(2^53 + 1)
y = 2^p*2^53
@test (Int(floor(float(x))) == y)
end
test_values = [int_dbl_max - 1, int_dbl_max, int_dbl_max + 1, halfway - 1, halfway, halfway + 1, top_power - 1, top_power, top_power + 1, 2*top_power - 1, 2*top_power, top_power*top_power]
append!(test_values, exact_values)
for p in -4:7
for x in -128:127
push!(test_values, 2^(p + 53) + x)
end
end
for value in test_values
check_float_conversion(self, value)
check_float_conversion(self, -(value))
end
end

function test_float_overflow(self)
for x in (-2.0, -1.0, 0.0, 1.0, 2.0)
@test (float(Int(floor(x))) == x)
end
shuge = repeat("12345",120)
huge = 1 << 30000
mhuge = -(huge)
namespace = Dict("huge" => huge, "mhuge" => mhuge, "shuge" => shuge, "math" => math)
for test in ["float(huge)", "float(mhuge)", "complex(huge)", "complex(mhuge)", "complex(huge, 1)", "complex(mhuge, 1)", "complex(1, huge)", "complex(1, mhuge)", "1. + huge", "huge + 1.", "1. + mhuge", "mhuge + 1.", "1. - huge", "huge - 1.", "1. - mhuge", "mhuge - 1.", "1. * huge", "huge * 1.", "1. * mhuge", "mhuge * 1.", "1. // huge", "huge // 1.", "1. // mhuge", "mhuge // 1.", "1. / huge", "huge / 1.", "1. / mhuge", "mhuge / 1.", "1. ** huge", "huge ** 1.", "1. ** mhuge", "mhuge ** 1.", "math.sin(huge)", "math.sin(mhuge)", "math.sqrt(huge)", "math.sqrt(mhuge)"]
@test_throws OverflowError eval(test, namespace)
end
assertNotEqual(self, float(shuge), parse(Int, shuge), "float(shuge) should not equal int(shuge)")
end

function test_logs(self)
LOG10E = log10(math.e)
for exp in append!(collect(0:9), [100, 1000, 10000])
value = 10^exp
log10 = log10(value)
assertAlmostEqual(self, log10, exp)
expected = exp / LOG10E
log = log(value)
assertAlmostEqual(self, log, expected)
end
for bad in (-(1 << 10000), -2, 0)
@test_throws ValueError math.log(bad)
@test_throws ValueError math.log10(bad)
end
end

function test_mixed_compares(self)
eq = self.assertEqual
mutable struct Rat <: AbstractRat
n
d::Int64

            Rat(value) = begin
                if isa(value, int)
n = value
d = 1
elseif isa(value, float)
f, e = math.frexp(abs(value))
@assert(f == 0 || 0.5 <= f < 1.0)
CHUNK = 28
top = 0
while f
f = math.ldexp(f, CHUNK)
digit = parse(Int, f)
@assert((digit >> CHUNK) == 0)
top = (top << CHUNK) | digit
f -= digit
@assert(0.0 <= f < 1.0)
e -= CHUNK
end
if e >= 0
n = top << e
d = 1
else
n = top
d = 1 << -(e)
end
if value < 0
n = -(n)
end
n = n
d = d
@assert((float(n) / float(d)) == value)
else
throw(TypeError("can\'t deal with %r" % value))
end
                new(value)
            end
end
function _cmp__(self, other)::Bool
if !isa(other, Rat)
other = Rat(other)
end
x, y = (self.n*other.d, self.d*other.n)
return x > y - x < y
end

function __eq__(self, other)::Bool
return _cmp__(self, other) == 0
end

function __ge__(self, other)::Bool
return _cmp__(self, other) >= 0
end

function __gt__(self, other)::Bool
return _cmp__(self, other) > 0
end

function __le__(self, other)::Bool
return _cmp__(self, other) <= 0
end

function __lt__(self, other)::Bool
return _cmp__(self, other) < 0
end

cases = [0, 0.001, 0.99, 1.0, 1.5, 1e+20, 1e+200]
for t in (2.0^48, 2.0^50, 2.0^53)
append!(cases, [t - 1.0, t - 0.3, t, t + 0.3, t + 1.0, Int(floor(t - 1)), Int(floor(t)), Int(floor(t + 1))])
end
append!(cases, [0, 1, 2, sys.maxsize, float(sys.maxsize)])
t = Int(floor(1e+200))
append!(cases, [0, 1, 2, 1 << 20000, t - 1, t, t + 1])
append!(cases, [-(x) for x in cases])
for x in cases
Rx = Rat(x)
for y in cases
Ry = Rat(y)
Rcmp = Rx > Ry - Rx < Ry
subTest(self, x = x, y = y, Rcmp = Rcmp) do 
xycmp = x > y - x < y
eq(Rcmp, xycmp)
eq(x == y, Rcmp == 0)
eq(x != y, Rcmp != 0)
eq(x < y, Rcmp < 0)
eq(x <= y, Rcmp <= 0)
eq(x > y, Rcmp > 0)
eq(x >= y, Rcmp >= 0)
end
end
end
end

function test__format__(self)
@test (123456789 == "123456789")
@test (123456789 == "123456789")
@test (123456789 == "123,456,789")
@test (123456789 == "123_456_789")
@test (1 == "1")
@test (-1 == "-1")
@test (1 == "  1")
@test (-1 == " -1")
@test (1 == " +1")
@test (-1 == " -1")
@test (1 == "  1")
@test (-1 == " -1")
@test (1 == " 1")
@test (-1 == "-1")
@test (3 == "3")
@test (3 == "3")
@test (1234 == "4d2")
@test (-1234 == "-4d2")
@test (1234 == "     4d2")
@test (-1234 == "    -4d2")
@test (1234 == "4d2")
@test (-1234 == "-4d2")
@test (-3 == "-3")
@test (-3 == "-3")
@test (parse(Int, "be") == "be")
@test (parse(Int, "be") == "BE")
@test (-parse(Int, "be") == "-be")
@test (-parse(Int, "be") == "-BE")
@test_throws ValueError format(1234567890, ",x")
@test (1234567890 == "4996_02d2")
@test (1234567890 == "4996_02D2")
@test (3 == "3")
@test (-3 == "-3")
@test (1234 == "2322")
@test (-1234 == "-2322")
@test (1234 == "2322")
@test (-1234 == "-2322")
@test (1234 == " 2322")
@test (-1234 == "-2322")
@test (1234 == "+2322")
@test (-1234 == "-2322")
@test_throws ValueError format(1234567890, ",o")
@test (1234567890 == "111_4540_1322")
@test (3 == "11")
@test (-3 == "-11")
@test (1234 == "10011010010")
@test (-1234 == "-10011010010")
@test (1234 == "10011010010")
@test (-1234 == "-10011010010")
@test (1234 == " 10011010010")
@test (-1234 == "-10011010010")
@test (1234 == "+10011010010")
@test (-1234 == "-10011010010")
@test_throws ValueError format(1234567890, ",b")
@test (12345 == "11_0000_0011_1001")
@test_throws ValueError format(3, "1.3")
@test_throws ValueError format(3, "_c")
@test_throws ValueError format(3, ",c")
@test_throws ValueError format(3, "+c")
@test_throws ValueError format(format, 3, "_,")
            @test match(@r_str("Cannot specify both"), repr(format))
@test_throws ValueError format(format, 3, ",_")
            @test match(@r_str("Cannot specify both"), repr(format))
@test_throws ValueError format(format, 3, "_,d")
            @test match(@r_str("Cannot specify both"), repr(format))
@test_throws ValueError format(format, 3, ",_d")
            @test match(@r_str("Cannot specify both"), repr(format))
@test_throws ValueError format(format, 3, ",s")
            @test match(@r_str("Cannot specify \',\' with \'s\'"), repr(format))
@test_throws ValueError format(format, 3, "_s")
            @test match(@r_str("Cannot specify \'_\' with \'s\'"), repr(format))
for format_spec in [Char(x) for x in Int(codepoint('a')):Int(codepoint('z'))] + [Char(x) for x in Int(codepoint('A')):Int(codepoint('Z'))]
if !(format_spec ∈ "bcdoxXeEfFgGn%")
@test_throws ValueError format(0, format_spec)
@test_throws ValueError format(1, format_spec)
@test_throws ValueError format(-1, format_spec)
@test_throws ValueError format(2^100, format_spec)
@test_throws ValueError format(-(2^100), format_spec)
end
end
for format_spec in "eEfFgG%"
for value in [0, 1, -1, 100, -100, 1234567890, -1234567890]
@test (value == float(value))
end
end
end

function test_nan_inf(self)
@test_throws OverflowError int(float("inf"))
@test_throws OverflowError int(float("-inf"))
@test_throws ValueError int(float("nan"))
end

function test_mod_division(self)
assertRaises(self, ZeroDivisionError) do 
_ = 1 % 0
end
@test (13 % 10 == 3)
@test (-13 % 10 == 7)
@test (13 % -10 == -7)
@test (-13 % -10 == -3)
@test (12 % 4 == 0)
@test (-12 % 4 == 0)
@test (12 % -4 == 0)
@test (-12 % -4 == 0)
end

function test_true_division(self)
huge = 1 << 40000
mhuge = -(huge)
@test (huge / huge == 1.0)
@test (mhuge / mhuge == 1.0)
@test (huge / mhuge == -1.0)
@test (mhuge / huge == -1.0)
@test (1 / huge == 0.0)
@test (1 / huge == 0.0)
@test (1 / mhuge == 0.0)
@test (1 / mhuge == 0.0)
@test ((666*huge + (huge >> 1)) / huge == 666.5)
@test ((666*mhuge + (mhuge >> 1)) / mhuge == 666.5)
@test ((666*huge + (huge >> 1)) / mhuge == -666.5)
@test ((666*mhuge + (mhuge >> 1)) / huge == -666.5)
@test (huge / (huge << 1) == 0.5)
@test (1000000*huge / huge == 1000000)
namespace = Dict("huge" => huge, "mhuge" => mhuge)
for overflow in ["float(huge)", "float(mhuge)", "huge / 1", "huge / 2", "huge / -1", "huge / -2", "mhuge / 100", "mhuge / 200"]
@test_throws OverflowError eval(overflow, namespace)
end
for underflow in ["1 / huge", "2 / huge", "-1 / huge", "-2 / huge", "100 / mhuge", "200 / mhuge"]
result = eval(underflow, namespace)
@test (result == 0.0)
end
for zero in ["huge / 0", "mhuge / 0"]
@test_throws ZeroDivisionError eval(zero, namespace)
end
end

function test_floordiv(self)
assertRaises(self, ZeroDivisionError) do 
_ = 1 ÷ 0
end
@test (2 ÷ 3 == 0)
@test (2 ÷ -3 == -1)
@test (-2 ÷ 3 == -1)
@test (-2 ÷ -3 == 0)
@test (-11 ÷ -3 == 3)
@test (-11 ÷ 3 == -4)
@test (11 ÷ -3 == -4)
@test (11 ÷ 3 == 3)
@test (-12 ÷ -3 == 4)
@test (-12 ÷ 3 == -4)
@test (12 ÷ -3 == -4)
@test (12 ÷ 3 == 4)
end

function check_truediv(self, a, b, skip_small = true)
#= Verify that the result of a/b is correctly rounded, by
        comparing it with a pure Python implementation of correctly
        rounded division.  b should be nonzero. =#
if skip_small && max(abs(a), abs(b)) < (2^DBL_MANT_DIG)
return
end
try
expected = repr(truediv(a, b))
catch exn
if exn isa OverflowError
expected = "overflow"
end
if exn isa ZeroDivisionError
expected = "zerodivision"
end
end
try
got = repr(a / b)
catch exn
if exn isa OverflowError
got = "overflow"
end
if exn isa ZeroDivisionError
got = "zerodivision"
end
end
@test (expected == got)
end

function test_correctly_rounded_true_division(self)
check_truediv(self, 123, 0)
check_truediv(self, -456, 0)
check_truediv(self, 0, 3)
check_truediv(self, 0, -3)
check_truediv(self, 0, 0)
check_truediv(self, 671*12345*2^DBL_MAX_EXP, 12345)
check_truediv(self, 12345, 345678*2^(DBL_MANT_DIG - DBL_MIN_EXP))
check_truediv(self, 12345*2^100, 98765)
check_truediv(self, 12345*2^30, 98765*7^81)
bases = (0, DBL_MANT_DIG, DBL_MIN_EXP, DBL_MAX_EXP, DBL_MIN_EXP - DBL_MANT_DIG)
for base in bases
for exp in base - 15:base + 14
check_truediv(self, 75312*2^max(exp, 0), 69187*2^max(-(exp), 0))
check_truediv(self, 69187*2^max(exp, 0), 75312*2^max(-(exp), 0))
end
end
for m in [1, 2, 7, 17, 12345, 7^100, -1, -2, -5, -23, -67891, -(41^50)]
for n in -10:9
check_truediv(self, m*DBL_MIN_OVERFLOW + n, m)
check_truediv(self, m*DBL_MIN_OVERFLOW + n, -(m))
end
end
for n in 0:249
check_truediv(self, (2^DBL_MANT_DIG + 1)*12345*2^200 + 2^n, 2^DBL_MANT_DIG*12345)
end
check_truediv(self, 1, 2731)
check_truediv(self, 295147931372582273023, 295147932265116303360)
for i in 0:999
check_truediv(self, 10^(i + 1), 10^i)
check_truediv(self, 10^i, 10^(i + 1))
end
for m in [1, 2, 4, 7, 8, 16, 17, 32, 12345, 7^100, -1, -2, -5, -23, -67891, -(41^50)]
for n in -10:9
check_truediv(self, 2^DBL_MANT_DIG*m + n, m)
end
end
for n in -20:19
check_truediv(self, n, 2^1076)
end
for M in [10^10, 10^100, 10^1000]
for i in 0:999
a = randrange(1, M)
b = randrange(a, 2*a + 1)
check_truediv(self, a, b)
check_truediv(self, -(a), b)
check_truediv(self, a, -(b))
check_truediv(self, -(a), -(b))
end
end
for _ in 0:9999
a_bits = randrange(1000)
b_bits = randrange(1, 1000)
x = randrange(2^a_bits)
y = randrange(1, 2^b_bits)
check_truediv(self, x, y)
check_truediv(self, x, -(y))
check_truediv(self, -(x), y)
check_truediv(self, -(x), -(y))
end
end

function test_negative_shift_count(self)
assertRaises(self, ValueError) do 
42 << -3
end
assertRaises(self, ValueError) do 
42 << -(1 << 1000)
end
assertRaises(self, ValueError) do 
42 >> -3
end
assertRaises(self, ValueError) do 
42 >> -(1 << 1000)
end
end

function test_lshift_of_zero(self)
@test (0 << 0 == 0)
@test (0 << 10 == 0)
assertRaises(self, ValueError) do 
0 << -1
end
@test (0 << (1 << 1000) == 0)
assertRaises(self, ValueError) do 
0 << -(1 << 1000)
end
end

function test_huge_lshift_of_zero(self)
@test (0 << sys.maxsize == 0)
@test (0 << (sys.maxsize + 1) == 0)
end

function test_huge_lshift(self, size)
@test (1 << (sys.maxsize + 1000) == (1 << 1000) << sys.maxsize)
end

function test_huge_rshift(self)
@test (42 >> (1 << 1000) == 0)
@test (-42 >> (1 << 1000) == -1)
end

function test_huge_rshift_of_huge(self, size)
huge = ((1 << 500) + 11) << sys.maxsize
@test (huge >> (sys.maxsize + 1) == (1 << 499) + 5)
@test (huge >> (sys.maxsize + 1000) == 0)
end

function test_small_ints_in_huge_calculation(self)
a = 2^100
b = -(a) + 1
c = a + 1
assertIs(self, a + b, 1)
assertIs(self, c - a, 1)
end

function test_small_ints(self)
for i in -5:256
assertIs(self, i, i + 0)
assertIs(self, i, i*1)
assertIs(self, i, i - 0)
assertIs(self, i, i ÷ 1)
assertIs(self, i, i & -1)
assertIs(self, i, i | 0)
assertIs(self, i, i  ⊻  0)
assertIs(self, i, ~(~(i)))
assertIs(self, i, i^1)
assertIs(self, i, parse(Int, string(i)))
assertIs(self, i, (i << 2) >> 2, string(i))
end
i = 1 << 70
assertIs(self, i - i, 0)
assertIs(self, 0*i, 0)
end

function test_bit_length(self)
tiny = 1e-10
for x in -65000:64999
k = bit_length(x)
@test (k == length(lstrip(bin(x), "-0b")))
if x != 0
@test (2^(k - 1)) <= abs(x) < (2^k)
else
@test (k == 0)
end
if x != 0
@test (k == 1 + floor((log(abs(x)) / log(2)) + tiny))
end
end
@test (bit_length(0) == 0)
@test (bit_length(1) == 1)
@test (bit_length(-1) == 1)
@test (bit_length(2) == 2)
@test (bit_length(-2) == 2)
for i in [2, 3, 15, 16, 17, 31, 32, 33, 63, 64, 234]
a = 2^i
@test (bit_length(a - 1) == i)
@test (bit_length(1 - a) == i)
@test (bit_length(a) == i + 1)
@test (bit_length(-(a)) == i + 1)
@test (bit_length(a + 1) == i + 1)
@test (bit_length(-(a) - 1) == i + 1)
end
end

function test_bit_count(self)
for a in -1000:999
@test (bit_count(a) == count(bin(a), "1"))
end
for exp in [10, 17, 63, 64, 65, 1009, 70234, 1234567]
a = 2^exp
@test (bit_count(a) == 1)
@test (bit_count(a - 1) == exp)
@test (bit_count(a  ⊻  63) == 7)
@test (bit_count((a - 1)  ⊻  510) == exp - 8)
end
end

function test_round(self)
test_dict = OrderedDict(0 => 0, 1 => 0, 2 => 0, 3 => 0, 4 => 0, 5 => 0, 6 => 10, 7 => 10, 8 => 10, 9 => 10, 10 => 10, 11 => 10, 12 => 10, 13 => 10, 14 => 10, 15 => 20, 16 => 20, 17 => 20, 18 => 20, 19 => 20)
for offset in -520:20:519
for (k, v) in collect(test_dict)
got = round(k + offset, digits = -1)
expected = v + offset
@test (got == expected)
assertIs(self, type_(got), int)
end
end
@test (round(-150, digits = -2) == -200)
@test (round(-149, digits = -2) == -100)
@test (round(-51, digits = -2) == -100)
@test (round(-50, digits = -2) == 0)
@test (round(-49, digits = -2) == 0)
@test (round(-1, digits = -2) == 0)
@test (round(0, digits = -2) == 0)
@test (round(1, digits = -2) == 0)
@test (round(49, digits = -2) == 0)
@test (round(50, digits = -2) == 0)
@test (round(51, digits = -2) == 100)
@test (round(149, digits = -2) == 100)
@test (round(150, digits = -2) == 200)
@test (round(250, digits = -2) == 200)
@test (round(251, digits = -2) == 300)
@test (round(172500, digits = -3) == 172000)
@test (round(173500, digits = -3) == 174000)
@test (round(31415926535, digits = -1) == 31415926540)
@test (round(31415926535, digits = -2) == 31415926500)
@test (round(31415926535, digits = -3) == 31415927000)
@test (round(31415926535, digits = -4) == 31415930000)
@test (round(31415926535, digits = -5) == 31415900000)
@test (round(31415926535, digits = -6) == 31416000000)
@test (round(31415926535, digits = -7) == 31420000000)
@test (round(31415926535, digits = -8) == 31400000000)
@test (round(31415926535, digits = -9) == 31000000000)
@test (round(31415926535, digits = -10) == 30000000000)
@test (round(31415926535, digits = -11) == 0)
@test (round(31415926535, digits = -12) == 0)
@test (round(31415926535, digits = -999) == 0)
for k in 10:99
got = round(10^k + 324678, digits = -3)
expect = 10^k + 325000
@test (got == expect)
assertIs(self, type_(got), int)
end
for n in 0:4
for i in 0:99
x = randrange(-10000, 10000)
got = round(x, digits = n)
@test (got == x)
assertIs(self, type_(got), int)
end
end
for huge_n in (2^31 - 1, 2^31, 2^63 - 1, 2^63, 2^100, 10^100)
@test (round(8979323, digits = huge_n) == 8979323)
end
for i in 0:99
x = randrange(-10000, 10000)
got = round(x)
@test (got == x)
assertIs(self, type_(got), int)
end
bad_exponents = ("brian", 2.0, 0im)
for e in bad_exponents
@test_throws TypeError round(3, e)
end
end

function test_to_bytes(self)
function check(tests, byteorder, signed = false)
for (test, expected) in items(tests)
try
@test (to_bytes(test, length(expected), byteorder, signed = signed) == expected)
catch exn
 let err = exn
if err isa Exception
throw(AssertionError("failed to convert $(test) with byteorder=$(byteorder) and signed=$(signed)"))
end
end
end
end
end

tests1 = Dict(0 => b"\x00", 1 => b"\x01", -1 => b"\xff", -127 => b"\x81", -128 => b"\x80", -129 => b"\xff\x7f", 127 => b"\x7f", 129 => b"\x00\x81", -255 => b"\xff\x01", -256 => b"\xff\x00", 255 => b"\x00\xff", 256 => b"\x01\x00", 32767 => b"\x7f\xff", -32768 => b"\xff\x80\x00", 65535 => b"\x00\xff\xff", -65536 => b"\xff\x00\x00", -8388608 => b"\x80\x00\x00")
check(tests1, "big")
tests2 = Dict(0 => b"\x00", 1 => b"\x01", -1 => b"\xff", -127 => b"\x81", -128 => b"\x80", -129 => b"\x7f\xff", 127 => b"\x7f", 129 => b"\x81\x00", -255 => b"\x01\xff", -256 => b"\x00\xff", 255 => b"\xff\x00", 256 => b"\x00\x01", 32767 => b"\xff\x7f", -32768 => b"\x00\x80", 65535 => b"\xff\xff\x00", -65536 => b"\x00\x00\xff", -8388608 => b"\x00\x00\x80")
check(tests2, "little")
tests3 = Dict(0 => b"\x00", 1 => b"\x01", 127 => b"\x7f", 128 => b"\x80", 255 => b"\xff", 256 => b"\x01\x00", 32767 => b"\x7f\xff", 32768 => b"\x80\x00", 65535 => b"\xff\xff", 65536 => b"\x01\x00\x00")
check(tests3, "big")
tests4 = Dict(0 => b"\x00", 1 => b"\x01", 127 => b"\x7f", 128 => b"\x80", 255 => b"\xff", 256 => b"\x00\x01", 32767 => b"\xff\x7f", 32768 => b"\x00\x80", 65535 => b"\xff\xff", 65536 => b"\x00\x00\x01")
check(tests4, "little")
@test_throws OverflowError 256.to_bytes(1, "big", signed = false)
@test_throws OverflowError 256.to_bytes(1, "big", signed = true)
@test_throws OverflowError 256.to_bytes(1, "little", signed = false)
@test_throws OverflowError 256.to_bytes(1, "little", signed = true)
@test_throws OverflowError -1.to_bytes(2, "big", signed = false)
@test_throws OverflowError -1.to_bytes(2, "little", signed = false)
@test (to_bytes(0, 0, "big") == b"")
@test (to_bytes(1, 5, "big") == b"\x00\x00\x00\x00\x01")
@test (to_bytes(0, 5, "big") == b"\x00\x00\x00\x00\x00")
@test (to_bytes(-1, 5, "big", signed = true) == b"\xff\xff\xff\xff\xff")
@test_throws OverflowError 1.to_bytes(0, "big")
end

function test_from_bytes(self)
function check(tests, byteorder, signed = false)
for (test, expected) in items(tests)
try
assertEqual(self, from_bytes(int, test, byteorder, signed = signed), expected)
catch exn
 let err = exn
if err isa Exception
throw(AssertionError("failed to convert $(test) with byteorder=$(byteorder!r) and signed=$(signed)"))
end
end
end
end
end

tests1 = Dict(b"" => 0, b"\x00" => 0, b"\x00\x00" => 0, b"\x01" => 1, b"\x00\x01" => 1, b"\xff" => -1, b"\xff\xff" => -1, b"\x81" => -127, b"\x80" => -128, b"\xff\x7f" => -129, b"\x7f" => 127, b"\x00\x81" => 129, b"\xff\x01" => -255, b"\xff\x00" => -256, b"\x00\xff" => 255, b"\x01\x00" => 256, b"\x7f\xff" => 32767, b"\x80\x00" => -32768, b"\x00\xff\xff" => 65535, b"\xff\x00\x00" => -65536, b"\x80\x00\x00" => -8388608)
check(tests1, "big")
tests2 = Dict(b"" => 0, b"\x00" => 0, b"\x00\x00" => 0, b"\x01" => 1, b"\x00\x01" => 256, b"\xff" => -1, b"\xff\xff" => -1, b"\x81" => -127, b"\x80" => -128, b"\x7f\xff" => -129, b"\x7f" => 127, b"\x81\x00" => 129, b"\x01\xff" => -255, b"\x00\xff" => -256, b"\xff\x00" => 255, b"\x00\x01" => 256, b"\xff\x7f" => 32767, b"\x00\x80" => -32768, b"\xff\xff\x00" => 65535, b"\x00\x00\xff" => -65536, b"\x00\x00\x80" => -8388608)
check(tests2, "little")
tests3 = Dict(b"" => 0, b"\x00" => 0, b"\x01" => 1, b"\x7f" => 127, b"\x80" => 128, b"\xff" => 255, b"\x01\x00" => 256, b"\x7f\xff" => 32767, b"\x80\x00" => 32768, b"\xff\xff" => 65535, b"\x01\x00\x00" => 65536)
check(tests3, "big")
tests4 = Dict(b"" => 0, b"\x00" => 0, b"\x01" => 1, b"\x7f" => 127, b"\x80" => 128, b"\xff" => 255, b"\x00\x01" => 256, b"\xff\x7f" => 32767, b"\x00\x80" => 32768, b"\xff\xff" => 65535, b"\x00\x00\x01" => 65536)
check(tests4, "little")
mutable struct myint <: Abstractmyint

end

assertIs(self, type_(myint.from_bytes(b"\x00", "big")), myint)
assertEqual(self, myint.from_bytes(b"\x01", "big"), 1)
assertIs(self, type_(myint.from_bytes(b"\x00", "big", signed = false)), myint)
assertEqual(self, myint.from_bytes(b"\x01", "big", signed = false), 1)
assertIs(self, type_(myint.from_bytes(b"\x00", "little")), myint)
assertEqual(self, myint.from_bytes(b"\x01", "little"), 1)
assertIs(self, type_(myint.from_bytes(b"\x00", "little", signed = false)), myint)
assertEqual(self, myint.from_bytes(b"\x01", "little", signed = false), 1)
assertEqual(self, from_bytes(int, [255, 0, 0], "big", signed = true), -65536)
assertEqual(self, from_bytes(int, (255, 0, 0), "big", signed = true), -65536)
assertEqual(self, from_bytes(int, Vector{UInt8}(b"\xff\x00\x00"), "big", signed = true), -65536)
assertEqual(self, from_bytes(int, Vector{UInt8}(b"\xff\x00\x00"), "big", signed = true), -65536)
assertEqual(self, from_bytes(int, array("B", b"\xff\x00\x00"), "big", signed = true), -65536)
assertEqual(self, from_bytes(int, memoryview(b"\xff\x00\x00"), "big", signed = true), -65536)
assertRaises(self, ValueError, int.from_bytes, [256], "big")
assertRaises(self, ValueError, int.from_bytes, [0], "big\0")
assertRaises(self, ValueError, int.from_bytes, [0], "little\0")
assertRaises(self, TypeError, int.from_bytes, "", "big")
assertRaises(self, TypeError, int.from_bytes, "\0", "big")
assertRaises(self, TypeError, int.from_bytes, 0, "big")
assertRaises(self, TypeError, int.from_bytes, 0, "big", true)
assertRaises(self, TypeError, myint.from_bytes, "", "big")
assertRaises(self, TypeError, myint.from_bytes, "\0", "big")
assertRaises(self, TypeError, myint.from_bytes, 0, "big")
assertRaises(self, TypeError, int.from_bytes, 0, "big", true)
mutable struct myint2 <: Abstractmyint2

end
function __new__(cls, value)
return __new__(int, cls)
end

i = myint2.from_bytes(b"\x01", "big")
assertIs(self, type_(i), myint2)
assertEqual(self, i, 2)
mutable struct myint3 <: Abstractmyint3
foo::String
end

i = myint3.from_bytes(b"\x01", "big")
assertIs(self, type_(i), myint3)
assertEqual(self, i, 1)
assertEqual(self, (hasfield(typeof(i), :foo) ? 
                getfield(i, :foo) : "none"), "bar")
end

function test_access_to_nonexistent_digit_0(self)
mutable struct Integer <: AbstractInteger
foo::String
end
function __new__(cls, value = 0)
self = __new__(int, cls)
self.foo = "foo"
return self
end

integers = [Integer(0) for i in 0:999]
for n in map(int, integers)
assertEqual(self, n, 0)
end
end

function test_shift_bool(self)
for value in (true, false)
for shift in (0, 2)
@test (type_(value << shift) == int)
@test (type_(value >> shift) == int)
end
end
end

function test_as_integer_ratio(self)
mutable struct myint <: Abstractmyint

end

tests = [10, 0, -10, 1, sys.maxsize + 1, true, false, myint(42)]
for value in tests
numerator, denominator = as_integer_ratio(value)
assertEqual(self, (numerator, denominator), (parse(Int, value), 1))
assertEqual(self, type_(numerator), int)
assertEqual(self, type_(denominator), int)
end
end

if abspath(PROGRAM_FILE) == @__FILE__
long_test = LongTest()
getran(long_test)
getran2(long_test)
check_division(long_test)
test_division(long_test)
test_karatsuba(long_test)
check_bitop_identities_1(long_test)
check_bitop_identities_2(long_test)
check_bitop_identities_3(long_test)
test_bitop_identities(long_test)
slow_format(long_test)
check_format_1(long_test)
test_format(long_test)
test_long(long_test)
test_conversion(long_test)
check_float_conversion(long_test)
test_float_conversion(long_test)
test_float_overflow(long_test)
test_logs(long_test)
test_mixed_compares(long_test)
test__format__(long_test)
test_nan_inf(long_test)
test_mod_division(long_test)
test_true_division(long_test)
test_floordiv(long_test)
check_truediv(long_test)
test_correctly_rounded_true_division(long_test)
test_negative_shift_count(long_test)
test_lshift_of_zero(long_test)
test_huge_lshift_of_zero(long_test)
test_huge_lshift(long_test)
test_huge_rshift(long_test)
test_huge_rshift_of_huge(long_test)
test_small_ints_in_huge_calculation(long_test)
test_small_ints(long_test)
test_bit_length(long_test)
test_bit_count(long_test)
test_round(long_test)
test_to_bytes(long_test)
test_from_bytes(long_test)
test_access_to_nonexistent_digit_0(long_test)
test_shift_bool(long_test)
test_as_integer_ratio(long_test)
end