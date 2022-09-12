# Transpiled with flags: 
# - oop
using ObjectOriented
using OrderedCollections
using Random
using Test
function to_bytes(n::Integer; bigendian=true, len=sizeof(n))
           bytes = Array{UInt8}(undef, len)
           for byte in (bigendian ? (1:len) : reverse(1:len))
               bytes[byte] = n & 0xff
               n >>= 8
           end
           return bytes
        end






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
# Delete Unsupported
# del(p2)
append!(special, [~x for x in special] + [-x for x in special])
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
return -int_to_float(-n)
end
shift = bit_length(n) - PRECISION
q = shift < 0 ? (n << -shift) : ((n >> shift) | Bool(n & ~(-1 << shift)))
q += ROUND_HALF_TO_EVEN_CORRECTION[q & 7]
if (shift + q == Q_MAX) > SHIFT_MAX
throw(OverflowError("integer too large to convert to float"))
end
@assert((q % 4) == 0&&(q ÷ 4) <= (2^sys.float_info.mant_dig))
@assert((q*2^shift) <= sys.float_info.max)
return math.ldexp(float(q), shift)
end

function truediv(a, b)
#= Correctly-rounded true division for integers. =#
negative = (a ⊻ b) < 0
(a, b) = (abs(a), abs(b))
if !b
throw(ZeroDivisionError("division by zero"))
end
if a >= (DBL_MIN_OVERFLOW*b)
throw(OverflowError("int/int too large to represent as a float"))
end
d = bit_length(a) - bit_length(b)
if d >= 0&&a >= (2^d*b)||d < 0&&(a*2^-d) >= b
d += 1
end
exp_ = max(d, DBL_MIN_EXP) - DBL_MANT_DIG
(a, b) = (a << max(-exp_, 0), b << max(exp_, 0))
(q, r) = div(a)
if (2*r) > b||(2*r) == b&&(q % 2) == 1
q += 1
end
result = math.ldexp(q, exp_)
return negative ? (-result) : (result)
end

@oodef mutable struct JustLong
                    
                    
                    
                end
                function __long__(self::@like(JustLong))::Int64
return 42
end


@oodef mutable struct LongTrunc
                    
                    
                    
                end
                function __long__(self::@like(LongTrunc))::Int64
return 42
end

function __trunc__(self::@like(LongTrunc))::Int64
return 1729
end


@oodef mutable struct Rat
                    
                    
                    
function new(value)
if isa(value, Int64)
self.n = value
self.d = 1
elseif isa(value, Float64)
(f, e) = math.frexp(abs(value))
@assert(f == 0||0.5 <= f < 1.0)
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
d = 1 << -e
end
if value < 0
n = -n
end
self.n = n
self.d = d
@assert((float(n) / float(d)) == value)
else
throw(TypeError("can\'t deal with $(value)"))
end
@mk begin
n = n
d = d
end
end

                end
                function _cmp__(self::@like(Rat), other)::Bool
if !isa(other, Rat)
other = Rat(other)
end
(x, y) = (self.n*other.d, self.d*other.n)
return x > y - x < y
end

function __eq__(self::@like(Rat), other)::Bool
return _cmp__(self, other) == 0
end

function __ge__(self::@like(Rat), other)::Bool
return _cmp__(self, other) >= 0
end

function __gt__(self::@like(Rat), other)::Bool
return _cmp__(self, other) > 0
end

function __le__(self::@like(Rat), other)::Bool
return _cmp__(self, other) <= 0
end

function __lt__(self::@like(Rat), other)::Bool
return _cmp__(self, other) < 0
end


@oodef mutable struct myint <: Int64
                    
                    
                    
                end
                

@oodef mutable struct myint2 <: Int64
                    
                    
                    
                end
                function __new__(cls::@like(myint2), value)
return __new__(Int64, cls)
end


@oodef mutable struct myint3 <: Int64
                    
                    foo::String
                    
function new(value, foo::String = "bar")
@mk begin
foo = foo
end
end

                end
                

@oodef mutable struct Integer <: Int64
                    
                    foo::String
                    
function new(foo::String = "foo")
foo = foo
new(foo)
end

                end
                function __new__(cls::@like(Integer), value = 0)
self = __new__(Int64, cls)
self.foo = "foo"
return self
end


@oodef mutable struct myint <: Int64
                    
                    
                    
                end
                

@oodef mutable struct LongTest <: unittest.TestCase
                    
                    
                    
                end
                function getran(self::@like(LongTest), ndigits)::Int64
assertGreater(self, ndigits, 0)
nbits_hi = ndigits*SHIFT
nbits_lo = (nbits_hi - SHIFT) + 1
answer = 0
nbits = 0
r = parse(Int, rand()*SHIFT*2) | 1
while nbits < nbits_lo
bits = (r >> 1) + 1
bits = min(bits, nbits_hi - nbits)
@test 1 <= bits <= SHIFT
nbits = nbits + bits
answer = answer << bits
if (r & 1) != 0
answer = answer | ((1 << bits) - 1)
end
r = parse(Int, rand()*SHIFT*2)
end
@test nbits_lo <= nbits <= nbits_hi
if rand() < 0.5
answer = -answer
end
return answer
end

function getran2(ndigits::@like(LongTest))::Int64
answer = 0
for i in 0:ndigits - 1
answer = (answer << SHIFT) | random.randint(0, MASK)
end
if rand() < 0.5
answer = -answer
end
return answer
end

function check_division(self::@like(LongTest), x, y)
eq = self.assertEqual
subTest(self, x = x, y = y) do 
(q, r) = div(x)
(q2, r2) = (x ÷ y, x % y)
(pab, pba) = (x*y, y*x)
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

function test_division(self::@like(LongTest))
digits_ = [collect(1:MAXDIGITS); collect(KARATSUBA_CUTOFF:KARATSUBA_CUTOFF + 13)]
push!(digits_, KARATSUBA_CUTOFF*3)
for lenx in digits_
x = getran(self, lenx)
for leny in digits_
y = getran(self, leny)||1
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

function test_karatsuba(self::@like(LongTest))
digits_ = [collect(1:4); collect(KARATSUBA_CUTOFF:KARATSUBA_CUTOFF + 9)]
append!(digits_, [KARATSUBA_CUTOFF*10, KARATSUBA_CUTOFF*100])
bits = [digit*SHIFT for digit in digits_]
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

function check_bitop_identities_1(self::@like(LongTest), x)
eq = self.assertEqual
subTest(self, x = x) do 
eq(x & 0, 0)
eq(x | 0, x)
eq(x ⊻ 0, x)
eq(x & -1, x)
eq(x | -1, -1)
eq(x ⊻ -1, ~x)
eq(x, ~(~x))
eq(x & x, x)
eq(x | x, x)
eq(x ⊻ x, 0)
eq(x & ~x, 0)
eq(x | ~x, -1)
eq(x ⊻ ~x, -1)
eq(-x, 1 + ~x)
eq(-x, ~(x - 1))
end
for n in 0:2*SHIFT - 1
p2 = 2^n
subTest(self, x = x, n = n, p2 = p2) do 
eq((x << n) >> n, x)
eq(x ÷ p2, x >> n)
eq(x*p2, x << n)
eq(x & -p2, (x >> n) << n)
eq(x & -p2, x & ~(p2 - 1))
end
end
end

function check_bitop_identities_2(self::@like(LongTest), x, y)
eq = self.assertEqual
subTest(self, x = x, y = y) do 
eq(x & y, y & x)
eq(x | y, y | x)
eq(x ⊻ y, y ⊻ x)
eq((x ⊻ y) ⊻ x, y)
eq(x & y, ~(~x | ~y))
eq(x | y, ~(~x & ~y))
eq(x ⊻ y, (x | y) & ~(x & y))
eq(x ⊻ y, (x & ~y) | (~x & y))
eq(x ⊻ y, (x | y) & (~x | ~y))
end
end

function check_bitop_identities_3(self::@like(LongTest), x, y, z)
eq = self.assertEqual
subTest(self, x = x, y = y, z = z) do 
eq((x & y) & z, x & (y & z))
eq((x | y) | z, x | (y | z))
eq((x ⊻ y) ⊻ z, x ⊻ (y ⊻ z))
eq(x & (y | z), (x & y) | (x & z))
eq(x | (y & z), (x | y) & (x | z))
end
end

function test_bitop_identities(self::@like(LongTest))
for x in special
check_bitop_identities_1(self, x)
end
digits_ = 1:MAXDIGITS
for lenx in digits_
x = getran(self, lenx)
check_bitop_identities_1(self, x)
for leny in digits_
y = getran(self, leny)
check_bitop_identities_2(self, x, y)
check_bitop_identities_3(self, x, y, getran(self, (lenx + leny) ÷ 2))
end
end
end

function slow_format(self::@like(LongTest), x, base)
digits_ = []
sign_ = 0
if x < 0
(sign_, x) = (1, -x)
end
while x
(x, r) = div(x)
push!(digits_, parse(Int, r))
end
reverse(digits_)
digits_ = digits_||[0]
return ("-"[begin:sign_] + Dict{int, str}(2 => "0b", 8 => "0o", 10 => "", 16 => "0x")[base]) + join(("0123456789abcdef"[i + 1] for i in digits_), "")
end

function check_format_1(self::@like(LongTest), x)
for (base, mapper) in ((2, bin), (8, oct), (10, String), (10, repr), (16, hex))
got = mapper(x)
subTest(self, x = x, mapper = mapper.__name__) do 
expected = slow_format(self, x, base)
@test (got == expected)
end
subTest(self, got = got) do 
@test (Int(got) == x)
end
end
end

function test_format(self::@like(LongTest))
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

function test_long(self::@like(LongTest))
LL = [("1" * repeat("0",20), 10^20), ("1" * repeat("0",100), 10^100)]
for (s, v) in LL
for sign_ in ("", "+", "-")
for prefix in ("", " ", "\t", "  \t\t  ")
ss = prefix * sign_ + s
vv = v
if sign_ == "-"&&v !== ValueError
vv = -v
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
@test_throws
@test_throws
@test_throws
@test_throws
@test_throws
@test_throws
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
@test_throws
@test_throws
invalid_bases = [-909, 2^31 - 1, 2^31, -(2^31), -(2^31) - 1, 2^63 - 1, 2^63, -(2^63), -(2^63) - 1, 2^100, -(2^100)]
for base in invalid_bases
@test_throws
end
@test_throws
end

function test_conversion(self::@like(LongTest))
@test_throws
@test (parse(Int, LongTrunc()) == 1729)
end

function check_float_conversion(self::@like(LongTest), n)
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
msg = "Error in conversion of integer $(n) to float.  Got $(actual), expected $(expected)."
@test (actual == expected)
end

function test_float_conversion(self::@like(LongTest))
exact_values = [0, 1, 2, 2^53 - 3, 2^53 - 2, 2^53 - 1, 2^53, 2^53 + 2, 2^54 - 4, 2^54 - 2, 2^54, 2^54 + 4]
for x in exact_values
@test (float(x) == x)
@test (float(-x) == -x)
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
@test_throws
@test (float(1 - halfway) == -DBL_MAX)
@test_throws
@test_throws
@test_throws
@test_throws
@test_throws
@test_throws
@test_throws
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
check_float_conversion(self, -value)
end
end

function test_float_overflow(self::@like(LongTest))
for x in (-2.0, -1.0, 0.0, 1.0, 2.0)
@test (float(Int(floor(x))) == x)
end
shuge = repeat("12345",120)
huge = 1 << 30000
mhuge = -huge
namespace = Dict{String, Any}("huge" => huge, "mhuge" => mhuge, "shuge" => shuge, "math" => math)
for test in ["float(huge)", "float(mhuge)", "complex(huge)", "complex(mhuge)", "complex(huge, 1)", "complex(mhuge, 1)", "complex(1, huge)", "complex(1, mhuge)", "1. + huge", "huge + 1.", "1. + mhuge", "mhuge + 1.", "1. - huge", "huge - 1.", "1. - mhuge", "mhuge - 1.", "1. * huge", "huge * 1.", "1. * mhuge", "mhuge * 1.", "1. // huge", "huge // 1.", "1. // mhuge", "mhuge // 1.", "1. / huge", "huge / 1.", "1. / mhuge", "mhuge / 1.", "1. ** huge", "huge ** 1.", "1. ** mhuge", "mhuge ** 1.", "math.sin(huge)", "math.sin(mhuge)", "math.sqrt(huge)", "math.sqrt(mhuge)"]
@test_throws
end
@test (parse(Float64, shuge) != parse(Int, shuge))
end

function test_logs(self::@like(LongTest))
LOG10E = math.log10(math.e)
for exp_ in [collect(0:9); [100, 1000, 10000]]
value = 10^exp_
log10_ = math.log10_(value)
assertAlmostEqual(self, log10_, exp_)
expected = exp_ / LOG10E
log_ = math.log_(value)
assertAlmostEqual(self, log_, expected)
end
for bad in (-(1 << 10000), -2, 0)
@test_throws
@test_throws
end
end

function test_mixed_compares(self::@like(LongTest))
eq = self.assertEqual
cases = [0, 0.001, 0.99, 1.0, 1.5, 1e+20, 1e+200]
for t in (2.0^48, 2.0^50, 2.0^53)
append!(cases, [t - 1.0, t - 0.3, t, t + 0.3, t + 1.0, parse(Int, t - 1), parse(Int, t), parse(Int, t + 1)])
end
append!(cases, [0, 1, 2, typemax(Int), float(typemax(Int))])
t = Int(floor(1e+200))
append!(cases, [0, 1, 2, 1 << 20000, t - 1, t, t + 1])
append!(cases, [-x for x in cases])
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

function test__format__(self::@like(LongTest))
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
@test_throws
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
@test_throws
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
@test_throws
@test (12345 == "11_0000_0011_1001")
@test_throws
@test_throws
@test_throws
@test_throws
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
@test_throws
@test_throws
@test_throws
@test_throws
@test_throws
end
end
for format_spec in "eEfFgG%"
for value in [0, 1, -1, 100, -100, 1234567890, -1234567890]
@test (value == float(value))
end
end
end

function test_nan_inf(self::@like(LongTest))
@test_throws
@test_throws
@test_throws
end

function test_mod_division(self::@like(LongTest))
@test_throws ZeroDivisionError do 
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

function test_true_division(self::@like(LongTest))
huge = 1 << 40000
mhuge = -huge
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
namespace = Dict{String, Int64}("huge" => huge, "mhuge" => mhuge)
for overflow in ["float(huge)", "float(mhuge)", "huge / 1", "huge / 2", "huge / -1", "huge / -2", "mhuge / 100", "mhuge / 200"]
@test_throws
end
for underflow in ["1 / huge", "2 / huge", "-1 / huge", "-2 / huge", "100 / mhuge", "200 / mhuge"]
result = py"underflow, namespace"
@test (result == 0.0)
end
for zero_ in ["huge / 0", "mhuge / 0"]
@test_throws
end
end

function test_floordiv(self::@like(LongTest))
@test_throws ZeroDivisionError do 
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

function check_truediv(self::@like(LongTest), a, b, skip_small = true)
#= Verify that the result of a/b is correctly rounded, by
        comparing it with a pure Python implementation of correctly
        rounded division.  b should be nonzero. =#
if skip_small&&max(abs(a), abs(b)) < (2^DBL_MANT_DIG)
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

function test_correctly_rounded_true_division(self::@like(LongTest))
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
for exp_ in base - 15:base + 14
check_truediv(self, 75312*2^max(exp_, 0), 69187*2^max(-exp_, 0))
check_truediv(self, 69187*2^max(exp_, 0), 75312*2^max(-exp_, 0))
end
end
for m in [1, 2, 7, 17, 12345, 7^100, -1, -2, -5, -23, -67891, -(41^50)]
for n in -10:9
check_truediv(self, m*DBL_MIN_OVERFLOW + n, m)
check_truediv(self, m*DBL_MIN_OVERFLOW + n, -m)
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
a = random.randrange(1, M)
b = random.randrange(a, 2*a + 1)
check_truediv(self, a, b)
check_truediv(self, -a, b)
check_truediv(self, a, -b)
check_truediv(self, -a, -b)
end
end
for _ in 0:9999
a_bits = random.randrange(1000)
b_bits = random.randrange(1, 1000)
x = random.randrange(2^a_bits)
y = random.randrange(1, 2^b_bits)
check_truediv(self, x, y)
check_truediv(self, x, -y)
check_truediv(self, -x, y)
check_truediv(self, -x, -y)
end
end

function test_negative_shift_count(self::@like(LongTest))
@test_throws ValueError do 
42 << -3
end
@test_throws ValueError do 
42 << -(1 << 1000)
end
@test_throws ValueError do 
42 >> -3
end
@test_throws ValueError do 
42 >> -(1 << 1000)
end
end

function test_lshift_of_zero(self::@like(LongTest))
@test (0 << 0 == 0)
@test (0 << 10 == 0)
@test_throws ValueError do 
0 << -1
end
@test (0 << (1 << 1000) == 0)
@test_throws ValueError do 
0 << -(1 << 1000)
end
end

function test_huge_lshift_of_zero(self::@like(LongTest))
@test (0 << typemax(Int) == 0)
@test (0 << (typemax(Int) + 1) == 0)
end

function test_huge_lshift(self::@like(LongTest), size)
@test (1 << (typemax(Int) + 1000) == (1 << 1000) << typemax(Int))
end

function test_huge_rshift(self::@like(LongTest))
@test (42 >> (1 << 1000) == 0)
@test (-42 >> (1 << 1000) == -1)
end

function test_huge_rshift_of_huge(self::@like(LongTest), size)
huge = ((1 << 500) + 11) << typemax(Int)
@test (huge >> (typemax(Int) + 1) == (1 << 499) + 5)
@test (huge >> (typemax(Int) + 1000) == 0)
end

function test_small_ints_in_huge_calculation(self::@like(LongTest))
a = 2^100
b = -a + 1
c = a + 1
@test self === a + b
@test self === c - a
end

function test_small_ints(self::@like(LongTest))
for i in -5:256
@test self === i
@test self === i
@test self === i
@test self === i
@test self === i
@test self === i
@test self === i
@test self === i
@test self === i
@test self === i
@test self === i
end
i = 1 << 70
@test self === i - i
@test self === 0*i
end

function test_bit_length(self::@like(LongTest))
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
@test (k == 1 + floor(Int, (math.log(abs(x)) / math.log(2)) + tiny))
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
@test (bit_length(-a) == i + 1)
@test (bit_length(a + 1) == i + 1)
@test (bit_length(-a - 1) == i + 1)
end
end

function test_bit_count(self::@like(LongTest))
for a in -1000:999
@test (bit_count(a) == count(bin(a), "1"))
end
for exp_ in [10, 17, 63, 64, 65, 1009, 70234, 1234567]
a = 2^exp_
@test (bit_count(a) == 1)
@test (bit_count(a - 1) == exp)
@test (bit_count(a ⊻ 63) == 7)
@test (bit_count((a - 1) ⊻ 510) == exp_ - 8)
end
end

function test_round(self::@like(LongTest))
test_dict = OrderedDict(0 => 0, 1 => 0, 2 => 0, 3 => 0, 4 => 0, 5 => 0, 6 => 10, 7 => 10, 8 => 10, 9 => 10, 10 => 10, 11 => 10, 12 => 10, 13 => 10, 14 => 10, 15 => 20, 16 => 20, 17 => 20, 18 => 20, 19 => 20)
for offset in -520:20:519
for (k, v) in items()
got = round(k + offset, digits = -1)
expected = v + offset
@test (got == expected)
@test self === type_(got)
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
@test self === type_(got)
end
for n in 0:4
for i in 0:99
x = random.randrange(-10000, 10000)
got = round(x, digits = n)
@test (got == x)
@test self === type_(got)
end
end
for huge_n in (2^31 - 1, 2^31, 2^63 - 1, 2^63, 2^100, 10^100)
@test (round(8979323, digits = huge_n) == 8979323)
end
for i in 0:99
x = random.randrange(-10000, 10000)
got = round(x)
@test (got == x)
@test self === type_(got)
end
bad_exponents = ("brian", 2.0, 0im)
for e in bad_exponents
@test_throws
end
end

function test_to_bytes(self::@like(LongTest))
function check(tests::@like(LongTest), byteorder, signed = false)
for (test, expected) in items(tests)
try
@test (to_bytes(test, length(expected), byteorder, signed = signed) == expected)
catch exn
 let err = exn
if err isa Exception
throw(AssertionError("failed to convert 0 with byteorder=1 and signed=2"))
end
end
end
end
end

tests1 = Dict{Int64, Array{UInt8}}(0 => b"\x00", 1 => b"\x01", -1 => b"\xff", -127 => b"\x81", -128 => b"\x80", -129 => b"\xff\x7f", 127 => b"\x7f", 129 => b"\x00\x81", -255 => b"\xff\x01", -256 => b"\xff\x00", 255 => b"\x00\xff", 256 => b"\x01\x00", 32767 => b"\x7f\xff", -32768 => b"\xff\x80\x00", 65535 => b"\x00\xff\xff", -65536 => b"\xff\x00\x00", -8388608 => b"\x80\x00\x00")
check(tests1, "big", signed = true)
tests2 = Dict{Int64, Array{UInt8}}(0 => b"\x00", 1 => b"\x01", -1 => b"\xff", -127 => b"\x81", -128 => b"\x80", -129 => b"\x7f\xff", 127 => b"\x7f", 129 => b"\x81\x00", -255 => b"\x01\xff", -256 => b"\x00\xff", 255 => b"\xff\x00", 256 => b"\x00\x01", 32767 => b"\xff\x7f", -32768 => b"\x00\x80", 65535 => b"\xff\xff\x00", -65536 => b"\x00\x00\xff", -8388608 => b"\x00\x00\x80")
check(tests2, "little", signed = true)
tests3 = Dict{Int64, Array{UInt8}}(0 => b"\x00", 1 => b"\x01", 127 => b"\x7f", 128 => b"\x80", 255 => b"\xff", 256 => b"\x01\x00", 32767 => b"\x7f\xff", 32768 => b"\x80\x00", 65535 => b"\xff\xff", 65536 => b"\x01\x00\x00")
check(tests3, "big", signed = false)
tests4 = Dict{Int64, Array{UInt8}}(0 => b"\x00", 1 => b"\x01", 127 => b"\x7f", 128 => b"\x80", 255 => b"\xff", 256 => b"\x00\x01", 32767 => b"\xff\x7f", 32768 => b"\x00\x80", 65535 => b"\xff\xff", 65536 => b"\x00\x00\x01")
check(tests4, "little", signed = false)
@test_throws
@test_throws
@test_throws
@test_throws
@test_throws
@test_throws
@test (to_bytes(0) == b"")
@test (to_bytes(1) == b"\x00\x00\x00\x00\x01")
@test (to_bytes(0) == b"\x00\x00\x00\x00\x00")
@test (to_bytes(-, 1) == b"\xff\xff\xff\xff\xff")
@test_throws
end

function test_from_bytes(self::@like(LongTest))
function check(tests::@like(LongTest), byteorder, signed = false)
for (test, expected) in items(tests)
try
@test (from_bytes(Int64, test, byteorder, signed = signed) == expected)
catch exn
 let err = exn
if err isa Exception
throw(AssertionError("failed to convert 0 with byteorder=1!r and signed=2"))
end
end
end
end
end

tests1 = Dict{Array{UInt8}, Int64}(b"" => 0, b"\x00" => 0, b"\x00\x00" => 0, b"\x01" => 1, b"\x00\x01" => 1, b"\xff" => -1, b"\xff\xff" => -1, b"\x81" => -127, b"\x80" => -128, b"\xff\x7f" => -129, b"\x7f" => 127, b"\x00\x81" => 129, b"\xff\x01" => -255, b"\xff\x00" => -256, b"\x00\xff" => 255, b"\x01\x00" => 256, b"\x7f\xff" => 32767, b"\x80\x00" => -32768, b"\x00\xff\xff" => 65535, b"\xff\x00\x00" => -65536, b"\x80\x00\x00" => -8388608)
check(tests1, "big", signed = true)
tests2 = Dict{Array{UInt8}, Int64}(b"" => 0, b"\x00" => 0, b"\x00\x00" => 0, b"\x01" => 1, b"\x00\x01" => 256, b"\xff" => -1, b"\xff\xff" => -1, b"\x81" => -127, b"\x80" => -128, b"\x7f\xff" => -129, b"\x7f" => 127, b"\x81\x00" => 129, b"\x01\xff" => -255, b"\x00\xff" => -256, b"\xff\x00" => 255, b"\x00\x01" => 256, b"\xff\x7f" => 32767, b"\x00\x80" => -32768, b"\xff\xff\x00" => 65535, b"\x00\x00\xff" => -65536, b"\x00\x00\x80" => -8388608)
check(tests2, "little", signed = true)
tests3 = Dict{Array{UInt8}, Int64}(b"" => 0, b"\x00" => 0, b"\x01" => 1, b"\x7f" => 127, b"\x80" => 128, b"\xff" => 255, b"\x01\x00" => 256, b"\x7f\xff" => 32767, b"\x80\x00" => 32768, b"\xff\xff" => 65535, b"\x01\x00\x00" => 65536)
check(tests3, "big", signed = false)
tests4 = Dict{Array{UInt8}, Int64}(b"" => 0, b"\x00" => 0, b"\x01" => 1, b"\x7f" => 127, b"\x80" => 128, b"\xff" => 255, b"\x00\x01" => 256, b"\xff\x7f" => 32767, b"\x00\x80" => 32768, b"\xff\xff" => 65535, b"\x00\x00\x01" => 65536)
check(tests4, "little", signed = false)
@test self === type_(myint.from_bytes(b"\x00", "big"))
@test (myint.from_bytes(b"\x01", "big") == 1)
@test self === type_(myint.from_bytes(b"\x00", "big", signed = false))
@test (myint.from_bytes(b"\x01", "big", signed = false) == 1)
@test self === type_(myint.from_bytes(b"\x00", "little"))
@test (myint.from_bytes(b"\x01", "little") == 1)
@test self === type_(myint.from_bytes(b"\x00", "little", signed = false))
@test (myint.from_bytes(b"\x01", "little", signed = false) == 1)
@test (from_bytes(Int64, [255, 0, 0], "big", signed = true) == -65536)
@test (from_bytes(Int64, (255, 0, 0), "big", signed = true) == -65536)
@test (from_bytes(Int64, Vector{UInt8}(b"\xff\x00\x00"), "big", signed = true) == -65536)
@test (from_bytes(Int64, Vector{UInt8}(b"\xff\x00\x00"), "big", signed = true) == -65536)
@test (from_bytes(Int64, array.array("B", b"\xff\x00\x00"), "big", signed = true) == -65536)
@test (from_bytes(Int64, memoryview(b"\xff\x00\x00"), "big", signed = true) == -65536)
@test_throws
@test_throws
@test_throws
@test_throws
@test_throws
@test_throws
@test_throws
@test_throws
@test_throws
@test_throws
@test_throws
i = myint2.from_bytes(b"\x01", "big")
@test self === type_(i)
@test (i == 2)
i = myint3.from_bytes(b"\x01", "big")
@test self === type_(i)
@test (i == 1)
@test ((hasfield(typeof(i), :foo) ? 
                getfield(i, :foo) : "none") == "bar")
end

function test_access_to_nonexistent_digit_0(self::@like(LongTest))
integers = [Integer(0) for i in 0:999]
for n in map(Int64, integers)
@test (n == 0)
end
end

function test_shift_bool(self::@like(LongTest))
for value in (true, false)
for shift in (0, 2)
@test (type_(value << shift) == Int64)
@test (type_(value >> shift) == Int64)
end
end
end

function test_as_integer_ratio(self::@like(LongTest))
tests = [10, 0, -10, 1, typemax(Int) + 1, true, false, myint(42)]
for value in tests
(numerator_, denominator_) = as_integer_ratio(value)
@test ((numerator_, denominator_) == (parse(Int, value), 1))
@test (type_(numerator_) == Int64)
@test (type_(denominator_) == Int64)
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
test_user_objects = TestUserObjects()
test_str_protocol(test_user_objects)
test_list_protocol(test_user_objects)
test_dict_protocol(test_user_objects)
test_list_copy(test_user_objects)
test_dict_copy(test_user_objects)
test_chain_map = TestChainMap()
test_basics(test_chain_map)
test_ordering(test_chain_map)
test_constructor(test_chain_map)
test_bool(test_chain_map)
test_missing(test_chain_map)
test_order_preservation(test_chain_map)
test_iter_not_calling_getitem_on_maps(test_chain_map)
test_dict_coercion(test_chain_map)
test_new_child(test_chain_map)
test_union_operators(test_chain_map)
test_named_tuple = TestNamedTuple()
test_factory(test_named_tuple)
test_defaults(test_named_tuple)
test_readonly(test_named_tuple)
test_factory_doc_attr(test_named_tuple)
test_field_doc(test_named_tuple)
test_field_doc_reuse(test_named_tuple)
test_field_repr(test_named_tuple)
test_name_fixer(test_named_tuple)
test_module_parameter(test_named_tuple)
test_instance(test_named_tuple)
test_tupleness(test_named_tuple)
test_odd_sizes(test_named_tuple)
test_pickle(test_named_tuple)
test_copy(test_named_tuple)
test_name_conflicts(test_named_tuple)
test_repr(test_named_tuple)
test_keyword_only_arguments(test_named_tuple)
test_namedtuple_subclass_issue_24931(test_named_tuple)
test_field_descriptor(test_named_tuple)
test_new_builtins_issue_43102(test_named_tuple)
test_match_args(test_named_tuple)
a_b_c_test_case = ABCTestCase()
test_counter = TestCounter()
test_basics(test_counter)
test_init(test_counter)
test_total(test_counter)
test_order_preservation(test_counter)
test_update(test_counter)
test_copying(test_counter)
test_copy_subclass(test_counter)
test_conversions(test_counter)
test_invariant_for_the_in_operator(test_counter)
test_multiset_operations(test_counter)
test_inplace_operations(test_counter)
test_subtract(test_counter)
test_unary(test_counter)
test_repr_nonsortable(test_counter)
test_helper_function(test_counter)
test_multiset_operations_equivalent_to_set_operations(test_counter)
test_eq(test_counter)
test_le(test_counter)
test_lt(test_counter)
test_ge(test_counter)
test_gt(test_counter)
comparison_test = ComparisonTest()
test_comparisons(comparison_test)
test_id_comparisons(comparison_test)
test_ne_defaults_to_not_eq(comparison_test)
test_ne_high_priority(comparison_test)
test_ne_low_priority(comparison_test)
test_other_delegation(comparison_test)
test_issue_1393(comparison_test)
complex_test = ComplexTest()
test_truediv(complex_test)
test_truediv_zero_division(complex_test)
test_floordiv(complex_test)
test_floordiv_zero_division(complex_test)
test_richcompare(complex_test)
test_richcompare_boundaries(complex_test)
test_mod(complex_test)
test_mod_zero_division(complex_test)
test_divmod(complex_test)
test_divmod_zero_division(complex_test)
test_pow(complex_test)
test_pow_with_small_integer_exponents(complex_test)
test_boolcontext(complex_test)
test_conjugate(complex_test)
test_constructor(complex_test)
test_constructor_special_numbers(complex_test)
test_underscores(complex_test)
test_hash(complex_test)
test_abs(complex_test)
test_repr_str(complex_test)
test_negative_zero_repr_str(complex_test)
test_neg(complex_test)
test_getnewargs(complex_test)
test_plus_minus_0j(complex_test)
test_negated_imaginary_literal(complex_test)
test_overflow(complex_test)
test_repr_roundtrip(complex_test)
test_format(complex_test)
test_contains = TestContains()
test_common_tests(test_contains)
test_builtin_sequence_types(test_contains)
test_nonreflexive(test_contains)
test_block_fallback(test_contains)
test_abstract_context_manager = TestAbstractContextManager()
test_enter(test_abstract_context_manager)
test_exit_is_abstract(test_abstract_context_manager)
test_structural_subclassing(test_abstract_context_manager)
context_manager_test_case = ContextManagerTestCase()
test_contextmanager_plain(context_manager_test_case)
test_contextmanager_finally(context_manager_test_case)
test_contextmanager_no_reraise(context_manager_test_case)
test_contextmanager_trap_yield_after_throw(context_manager_test_case)
test_contextmanager_except(context_manager_test_case)
test_contextmanager_except_stopiter(context_manager_test_case)
test_contextmanager_except_pep479(context_manager_test_case)
test_contextmanager_do_not_unchain_non_stopiteration_exceptions(context_manager_test_case)
test_contextmanager_attribs(context_manager_test_case)
test_contextmanager_doc_attrib(context_manager_test_case)
test_instance_docstring_given_cm_docstring(context_manager_test_case)
test_keywords(context_manager_test_case)
test_nokeepref(context_manager_test_case)
test_param_errors(context_manager_test_case)
test_recursive(context_manager_test_case)
closing_test_case = ClosingTestCase()
test_instance_docs(closing_test_case)
test_closing(closing_test_case)
test_closing_error(closing_test_case)
nullcontext_test_case = NullcontextTestCase()
test_nullcontext(nullcontext_test_case)
file_context_test_case = FileContextTestCase()
testWithOpen(file_context_test_case)
lock_context_test_case = LockContextTestCase()
testWithLock(lock_context_test_case)
testWithRLock(lock_context_test_case)
testWithCondition(lock_context_test_case)
testWithSemaphore(lock_context_test_case)
testWithBoundedSemaphore(lock_context_test_case)
test_context_decorator = TestContextDecorator()
test_instance_docs(test_context_decorator)
test_contextdecorator(test_context_decorator)
test_contextdecorator_with_exception(test_context_decorator)
test_decorator(test_context_decorator)
test_decorator_with_exception(test_context_decorator)
test_decorating_method(test_context_decorator)
test_typo_enter(test_context_decorator)
test_typo_exit(test_context_decorator)
test_contextdecorator_as_mixin(test_context_decorator)
test_contextmanager_as_decorator(test_context_decorator)
test_exit_stack = TestExitStack()
test_redirect_stdout = TestRedirectStdout()
test_redirect_stderr = TestRedirectStderr()
test_suppress = TestSuppress()
test_instance_docs(test_suppress)
test_no_result_from_enter(test_suppress)
test_no_exception(test_suppress)
test_exact_exception(test_suppress)
test_exception_hierarchy(test_suppress)
test_other_exception(test_suppress)
test_no_args(test_suppress)
test_multiple_exception_args(test_suppress)
test_cm_is_reentrant(test_suppress)
test_abstract_async_context_manager = TestAbstractAsyncContextManager()
test_exit_is_abstract(test_abstract_async_context_manager)
test_structural_subclassing(test_abstract_async_context_manager)
async_context_manager_test_case = AsyncContextManagerTestCase()
test_contextmanager_attribs(async_context_manager_test_case)
test_contextmanager_doc_attrib(async_context_manager_test_case)
aclosing_test_case = AclosingTestCase()
test_instance_docs(aclosing_test_case)
test_async_exit_stack = TestAsyncExitStack()
setUp(test_async_exit_stack)
test_async_nullcontext = TestAsyncNullcontext()
test_case = TestCase()
test_no_fields(test_case)
test_no_fields_but_member_variable(test_case)
test_one_field_no_default(test_case)
test_field_default_default_factory_error(test_case)
test_field_repr(test_case)
test_named_init_params(test_case)
test_two_fields_one_default(test_case)
test_overwrite_hash(test_case)
test_overwrite_fields_in_derived_class(test_case)
test_field_named_self(test_case)
test_field_named_object(test_case)
test_field_named_object_frozen(test_case)
test_field_named_like_builtin(test_case)
test_field_named_like_builtin_frozen(test_case)
test_0_field_compare(test_case)
test_1_field_compare(test_case)
test_simple_compare(test_case)
test_compare_subclasses(test_case)
test_eq_order(test_case)
test_field_no_default(test_case)
test_field_default(test_case)
test_not_in_repr(test_case)
test_not_in_compare(test_case)
test_hash_field_rules(test_case)
test_init_false_no_default(test_case)
test_class_marker(test_case)
test_field_order(test_case)
test_class_attrs(test_case)
test_disallowed_mutable_defaults(test_case)
test_deliberately_mutable_defaults(test_case)
test_no_options(test_case)
test_not_tuple(test_case)
test_not_other_dataclass(test_case)
test_function_annotations(test_case)
test_missing_default(test_case)
test_missing_default_factory(test_case)
test_missing_repr(test_case)
test_dont_include_other_annotations(test_case)
test_post_init(test_case)
test_post_init_super(test_case)
test_post_init_staticmethod(test_case)
test_post_init_classmethod(test_case)
test_class_var(test_case)
test_class_var_no_default(test_case)
test_class_var_default_factory(test_case)
test_class_var_with_default(test_case)
test_class_var_frozen(test_case)
test_init_var_no_default(test_case)
test_init_var_default_factory(test_case)
test_init_var_with_default(test_case)
test_init_var(test_case)
test_init_var_preserve_type(test_case)
test_init_var_inheritance(test_case)
test_default_factory(test_case)
test_default_factory_with_no_init(test_case)
test_default_factory_not_called_if_value_given(test_case)
test_default_factory_derived(test_case)
test_intermediate_non_dataclass(test_case)
test_classvar_default_factory(test_case)
test_is_dataclass(test_case)
test_is_dataclass_when_getattr_always_returns(test_case)
test_is_dataclass_genericalias(test_case)
test_helper_fields_with_class_instance(test_case)
test_helper_fields_exception(test_case)
test_helper_asdict(test_case)
test_helper_asdict_raises_on_classes(test_case)
test_helper_asdict_copy_values(test_case)
test_helper_asdict_nested(test_case)
test_helper_asdict_builtin_containers(test_case)
test_helper_asdict_builtin_object_containers(test_case)
test_helper_asdict_factory(test_case)
test_helper_asdict_namedtuple(test_case)
test_helper_asdict_namedtuple_key(test_case)
test_helper_asdict_namedtuple_derived(test_case)
test_helper_astuple(test_case)
test_helper_astuple_raises_on_classes(test_case)
test_helper_astuple_copy_values(test_case)
test_helper_astuple_nested(test_case)
test_helper_astuple_builtin_containers(test_case)
test_helper_astuple_builtin_object_containers(test_case)
test_helper_astuple_factory(test_case)
test_helper_astuple_namedtuple(test_case)
test_dynamic_class_creation(test_case)
test_dynamic_class_creation_using_field(test_case)
test_init_in_order(test_case)
test_items_in_dicts(test_case)
test_alternate_classmethod_constructor(test_case)
test_field_metadata_default(test_case)
test_field_metadata_mapping(test_case)
test_field_metadata_custom_mapping(test_case)
test_generic_dataclasses(test_case)
test_generic_extending(test_case)
test_generic_dynamic(test_case)
test_dataclasses_pickleable(test_case)
test_dataclasses_qualnames(test_case)
test_field_no_annotation = TestFieldNoAnnotation()
test_field_without_annotation(test_field_no_annotation)
test_field_without_annotation_but_annotation_in_base(test_field_no_annotation)
test_field_without_annotation_but_annotation_in_base_not_dataclass(test_field_no_annotation)
test_doc_string = TestDocString()
test_existing_docstring_not_overridden(test_doc_string)
test_docstring_no_fields(test_doc_string)
test_docstring_one_field(test_doc_string)
test_docstring_two_fields(test_doc_string)
test_docstring_three_fields(test_doc_string)
test_docstring_one_field_with_default(test_doc_string)
test_docstring_one_field_with_default_none(test_doc_string)
test_docstring_list_field(test_doc_string)
test_docstring_list_field_with_default_factory(test_doc_string)
test_docstring_deque_field(test_doc_string)
test_docstring_deque_field_with_default_factory(test_doc_string)
test_init = TestInit()
test_base_has_init(test_init)
test_no_init(test_init)
test_overwriting_init(test_init)
test_inherit_from_protocol(test_init)
test_repr = TestRepr()
test_repr(test_repr)
test_no_repr(test_repr)
test_overwriting_repr(test_repr)
test_eq = TestEq()
test_no_eq(test_eq)
test_overwriting_eq(test_eq)
test_ordering = TestOrdering()
test_functools_total_ordering(test_ordering)
test_no_order(test_ordering)
test_overwriting_order(test_ordering)
test_hash = TestHash()
test_unsafe_hash(test_hash)
test_hash_rules(test_hash)
test_eq_only(test_hash)
test_0_field_hash(test_hash)
test_1_field_hash(test_hash)
test_hash_no_args(test_hash)
test_frozen = TestFrozen()
test_frozen(test_frozen)
test_inherit(test_frozen)
test_inherit_nonfrozen_from_empty_frozen(test_frozen)
test_inherit_nonfrozen_from_empty(test_frozen)
test_inherit_nonfrozen_from_frozen(test_frozen)
test_inherit_frozen_from_nonfrozen(test_frozen)
test_inherit_from_normal_class(test_frozen)
test_non_frozen_normal_derived(test_frozen)
test_overwriting_frozen(test_frozen)
test_frozen_hash(test_frozen)
test_slots = TestSlots()
test_simple(test_slots)
test_derived_added_field(test_slots)
test_generated_slots(test_slots)
test_add_slots_when_slots_exists(test_slots)
test_generated_slots_value(test_slots)
test_returns_new_class(test_slots)
test_frozen_pickle(test_slots)
test_slots_with_default_no_init(test_slots)
test_slots_with_default_factory_no_init(test_slots)
test_descriptors = TestDescriptors()
test_set_name(test_descriptors)
test_non_descriptor(test_descriptors)
test_lookup_on_instance(test_descriptors)
test_lookup_on_class(test_descriptors)
test_string_annotations = TestStringAnnotations()
test_classvar(test_string_annotations)
test_isnt_classvar(test_string_annotations)
test_initvar(test_string_annotations)
test_isnt_initvar(test_string_annotations)
test_classvar_module_level_import(test_string_annotations)
test_text_annotations(test_string_annotations)
test_make_dataclass = TestMakeDataclass()
test_simple(test_make_dataclass)
test_no_mutate_namespace(test_make_dataclass)
test_base(test_make_dataclass)
test_base_dataclass(test_make_dataclass)
test_init_var(test_make_dataclass)
test_class_var(test_make_dataclass)
test_other_params(test_make_dataclass)
test_no_types(test_make_dataclass)
test_invalid_type_specification(test_make_dataclass)
test_duplicate_field_names(test_make_dataclass)
test_keyword_field_names(test_make_dataclass)
test_non_identifier_field_names(test_make_dataclass)
test_underscore_field_names(test_make_dataclass)
test_funny_class_names_names(test_make_dataclass)
test_replace = TestReplace()
test(test_replace)
test_frozen(test_replace)
test_invalid_field_name(test_replace)
test_invalid_object(test_replace)
test_no_init(test_replace)
test_classvar(test_replace)
test_initvar_is_specified(test_replace)
test_initvar_with_default_value(test_replace)
test_recursive_repr(test_replace)
test_recursive_repr_two_attrs(test_replace)
test_recursive_repr_indirection(test_replace)
test_recursive_repr_indirection_two(test_replace)
test_recursive_repr_misc_attrs(test_replace)
test_abstract = TestAbstract()
test_abc_implementation(test_abstract)
test_maintain_abc(test_abstract)
test_match_args = TestMatchArgs()
test_match_args(test_match_args)
test_explicit_match_args(test_match_args)
test_bpo_43764(test_match_args)
test_match_args_argument(test_match_args)
test_make_dataclasses(test_match_args)
test_keyword_args = TestKeywordArgs()
test_no_classvar_kwarg(test_keyword_args)
test_field_marked_as_kwonly(test_keyword_args)
test_match_args(test_keyword_args)
test_KW_ONLY(test_keyword_args)
test_KW_ONLY_as_string(test_keyword_args)
test_KW_ONLY_twice(test_keyword_args)
test_post_init(test_keyword_args)
test_defaults(test_keyword_args)
test_make_dataclass(test_keyword_args)
i_b_m_test_cases = IBMTestCases()
setUp(i_b_m_test_cases)
explicit_construction_test = ExplicitConstructionTest()
test_explicit_empty(explicit_construction_test)
test_explicit_from_None(explicit_construction_test)
test_explicit_from_int(explicit_construction_test)
test_explicit_from_string(explicit_construction_test)
test_from_legacy_strings(explicit_construction_test)
test_explicit_from_tuples(explicit_construction_test)
test_explicit_from_list(explicit_construction_test)
test_explicit_from_bool(explicit_construction_test)
test_explicit_from_Decimal(explicit_construction_test)
test_explicit_from_float(explicit_construction_test)
test_explicit_context_create_decimal(explicit_construction_test)
test_explicit_context_create_from_float(explicit_construction_test)
test_unicode_digits(explicit_construction_test)
implicit_construction_test = ImplicitConstructionTest()
test_implicit_from_None(implicit_construction_test)
test_implicit_from_int(implicit_construction_test)
test_implicit_from_string(implicit_construction_test)
test_implicit_from_float(implicit_construction_test)
test_implicit_from_Decimal(implicit_construction_test)
test_rop(implicit_construction_test)
format_test = FormatTest()
test_formatting(format_test)
test_n_format(format_test)
test_wide_char_separator_decimal_point(format_test)
test_decimal_from_float_argument_type(format_test)
arithmetic_operators_test = ArithmeticOperatorsTest()
test_addition(arithmetic_operators_test)
test_subtraction(arithmetic_operators_test)
test_multiplication(arithmetic_operators_test)
test_division(arithmetic_operators_test)
test_floor_division(arithmetic_operators_test)
test_powering(arithmetic_operators_test)
test_module(arithmetic_operators_test)
test_floor_div_module(arithmetic_operators_test)
test_unary_operators(arithmetic_operators_test)
test_nan_comparisons(arithmetic_operators_test)
test_copy_sign(arithmetic_operators_test)
threading_test = ThreadingTest()
test_threading(threading_test)
usability_test = UsabilityTest()
test_comparison_operators(usability_test)
test_decimal_float_comparison(usability_test)
test_decimal_complex_comparison(usability_test)
test_decimal_fraction_comparison(usability_test)
test_copy_and_deepcopy_methods(usability_test)
test_hash_method(usability_test)
test_hash_method_nan(usability_test)
test_min_and_max_methods(usability_test)
test_as_nonzero(usability_test)
test_tostring_methods(usability_test)
test_tonum_methods(usability_test)
test_nan_to_float(usability_test)
test_snan_to_float(usability_test)
test_eval_round_trip(usability_test)
test_as_tuple(usability_test)
test_as_integer_ratio(usability_test)
test_subclassing(usability_test)
test_implicit_context(usability_test)
test_none_args(usability_test)
test_conversions_from_int(usability_test)
python_a_p_itests = PythonAPItests()
test_abc(python_a_p_itests)
test_pickle(python_a_p_itests)
test_int(python_a_p_itests)
test_trunc(python_a_p_itests)
test_from_float(python_a_p_itests)
test_create_decimal_from_float(python_a_p_itests)
test_quantize(python_a_p_itests)
test_complex(python_a_p_itests)
test_named_parameters(python_a_p_itests)
test_exception_hierarchy(python_a_p_itests)
context_a_p_itests = ContextAPItests()
test_none_args(context_a_p_itests)
test_from_legacy_strings(context_a_p_itests)
test_pickle(context_a_p_itests)
test_equality_with_other_types(context_a_p_itests)
test_copy(context_a_p_itests)
test__clamp(context_a_p_itests)
test_abs(context_a_p_itests)
test_add(context_a_p_itests)
test_compare(context_a_p_itests)
test_compare_signal(context_a_p_itests)
test_compare_total(context_a_p_itests)
test_compare_total_mag(context_a_p_itests)
test_copy_abs(context_a_p_itests)
test_copy_decimal(context_a_p_itests)
test_copy_negate(context_a_p_itests)
test_copy_sign(context_a_p_itests)
test_divide(context_a_p_itests)
test_divide_int(context_a_p_itests)
test_divmod(context_a_p_itests)
test_exp(context_a_p_itests)
test_fma(context_a_p_itests)
test_is_finite(context_a_p_itests)
test_is_infinite(context_a_p_itests)
test_is_nan(context_a_p_itests)
test_is_normal(context_a_p_itests)
test_is_qnan(context_a_p_itests)
test_is_signed(context_a_p_itests)
test_is_snan(context_a_p_itests)
test_is_subnormal(context_a_p_itests)
test_is_zero(context_a_p_itests)
test_ln(context_a_p_itests)
test_log10(context_a_p_itests)
test_logb(context_a_p_itests)
test_logical_and(context_a_p_itests)
test_logical_invert(context_a_p_itests)
test_logical_or(context_a_p_itests)
test_logical_xor(context_a_p_itests)
test_max(context_a_p_itests)
test_max_mag(context_a_p_itests)
test_min(context_a_p_itests)
test_min_mag(context_a_p_itests)
test_minus(context_a_p_itests)
test_multiply(context_a_p_itests)
test_next_minus(context_a_p_itests)
test_next_plus(context_a_p_itests)
test_next_toward(context_a_p_itests)
test_normalize(context_a_p_itests)
test_number_class(context_a_p_itests)
test_plus(context_a_p_itests)
test_power(context_a_p_itests)
test_quantize(context_a_p_itests)
test_remainder(context_a_p_itests)
test_remainder_near(context_a_p_itests)
test_rotate(context_a_p_itests)
test_sqrt(context_a_p_itests)
test_same_quantum(context_a_p_itests)
test_scaleb(context_a_p_itests)
test_shift(context_a_p_itests)
test_subtract(context_a_p_itests)
test_to_eng_string(context_a_p_itests)
test_to_sci_string(context_a_p_itests)
test_to_integral_exact(context_a_p_itests)
test_to_integral_value(context_a_p_itests)
context_with_statement = ContextWithStatement()
test_localcontext(context_with_statement)
test_localcontextarg(context_with_statement)
test_nested_with_statements(context_with_statement)
test_with_statements_gc1(context_with_statement)
test_with_statements_gc2(context_with_statement)
test_with_statements_gc3(context_with_statement)
context_flags = ContextFlags()
test_flags_irrelevant(context_flags)
test_flag_comparisons(context_flags)
test_float_operation(context_flags)
test_float_comparison(context_flags)
test_float_operation_default(context_flags)
special_contexts = SpecialContexts()
test_context_templates(special_contexts)
test_default_context(special_contexts)
context_input_validation = ContextInputValidation()
test_invalid_context(context_input_validation)
context_subclassing = ContextSubclassing()
test_context_subclassing(context_subclassing)
check_attributes = CheckAttributes()
test_module_attributes(check_attributes)
test_context_attributes(check_attributes)
test_decimal_attributes(check_attributes)
coverage = Coverage()
test_adjusted(coverage)
test_canonical(coverage)
test_context_repr(coverage)
test_implicit_context(coverage)
test_divmod(coverage)
test_power(coverage)
test_quantize(coverage)
test_radix(coverage)
test_rop(coverage)
test_round(coverage)
test_create_decimal(coverage)
test_int(coverage)
test_copy(coverage)
py_functionality = PyFunctionality()
test_py_alternate_formatting(py_functionality)
py_whitebox = PyWhitebox()
test_py_exact_power(py_whitebox)
test_py_immutability_operations(py_whitebox)
test_py_decimal_id(py_whitebox)
test_py_rescale(py_whitebox)
test_py__round(py_whitebox)
c_functionality = CFunctionality()
test_c_ieee_context(c_functionality)
test_c_context(c_functionality)
test_constants(c_functionality)
c_whitebox = CWhitebox()
test_bignum(c_whitebox)
test_invalid_construction(c_whitebox)
test_c_input_restriction(c_whitebox)
test_c_context_repr(c_whitebox)
test_c_context_errors(c_whitebox)
test_rounding_strings_interned(c_whitebox)
test_c_context_errors_extra(c_whitebox)
test_c_valid_context(c_whitebox)
test_c_valid_context_extra(c_whitebox)
test_c_round(c_whitebox)
test_c_format(c_whitebox)
test_c_integral(c_whitebox)
test_c_funcs(c_whitebox)
test_va_args_exceptions(c_whitebox)
test_c_context_templates(c_whitebox)
test_c_signal_dict(c_whitebox)
test_invalid_override(c_whitebox)
test_exact_conversion(c_whitebox)
test_from_tuple(c_whitebox)
test_sizeof(c_whitebox)
test_internal_use_of_overridden_methods(c_whitebox)
test_maxcontext_exact_arith(c_whitebox)
signature_test = SignatureTest()
test_inspect_module(signature_test)
test_inspect_types(signature_test)
dict_test = DictTest()
test_invalid_keyword_arguments(dict_test)
test_constructor(dict_test)
test_literal_constructor(dict_test)
test_merge_operator(dict_test)
test_bool(dict_test)
test_keys(dict_test)
test_values(dict_test)
test_items(dict_test)
test_views_mapping(dict_test)
test_contains(dict_test)
test_len(dict_test)
test_getitem(dict_test)
test_clear(dict_test)
test_update(dict_test)
test_fromkeys(dict_test)
test_copy(dict_test)
test_copy_fuzz(dict_test)
test_copy_maintains_tracking(dict_test)
test_copy_noncompact(dict_test)
test_get(dict_test)
test_setdefault(dict_test)
test_setdefault_atomic(dict_test)
test_setitem_atomic_at_resize(dict_test)
test_popitem(dict_test)
test_pop(dict_test)
test_mutating_iteration(dict_test)
test_mutating_iteration_delete(dict_test)
test_mutating_iteration_delete_over_values(dict_test)
test_mutating_iteration_delete_over_items(dict_test)
test_mutating_lookup(dict_test)
test_repr(dict_test)
test_repr_deep(dict_test)
test_eq(dict_test)
test_keys_contained(dict_test)
test_errors_in_view_containment_check(dict_test)
test_dictview_set_operations_on_keys(dict_test)
test_dictview_set_operations_on_items(dict_test)
test_items_symmetric_difference(dict_test)
test_dictview_mixed_set_operations(dict_test)
test_missing(dict_test)
test_tuple_keyerror(dict_test)
test_bad_key(dict_test)
test_resize1(dict_test)
test_resize2(dict_test)
test_empty_presized_dict_in_freelist(dict_test)
test_container_iterator(dict_test)
test_track_literals(dict_test)
test_track_dynamic(dict_test)
test_track_subtypes(dict_test)
test_splittable_setdefault(dict_test)
test_splittable_del(dict_test)
test_splittable_pop(dict_test)
test_splittable_pop_pending(dict_test)
test_splittable_popitem(dict_test)
test_splittable_setattr_after_pop(dict_test)
test_iterator_pickling(dict_test)
test_itemiterator_pickling(dict_test)
test_valuesiterator_pickling(dict_test)
test_reverseiterator_pickling(dict_test)
test_reverseitemiterator_pickling(dict_test)
test_reversevaluesiterator_pickling(dict_test)
test_instance_dict_getattr_str_subclass(dict_test)
test_object_set_item_single_instance_non_str_key(dict_test)
test_reentrant_insertion(dict_test)
test_merge_and_mutate(dict_test)
test_free_after_iterating(dict_test)
test_equal_operator_modifying_operand(dict_test)
test_fromkeys_operator_modifying_dict_operand(dict_test)
test_fromkeys_operator_modifying_set_operand(dict_test)
test_dictitems_contains_use_after_free(dict_test)
test_dict_contain_use_after_free(dict_test)
test_init_use_after_free(dict_test)
test_oob_indexing_dictiter_iternextitem(dict_test)
test_reversed(dict_test)
test_reverse_iterator_for_empty_dict(dict_test)
test_reverse_iterator_for_shared_shared_dicts(dict_test)
test_dict_copy_order(dict_test)
test_dict_items_result_gc(dict_test)
test_dict_items_result_gc_reversed(dict_test)
test_str_nonstr(dict_test)
c_a_p_i_test = CAPITest()
test_getitem_knownhash(c_a_p_i_test)
dict_version_tests = DictVersionTests()
setUp(dict_version_tests)
test_constructor(dict_version_tests)
test_copy(dict_version_tests)
test_setitem(dict_version_tests)
test_setitem_same_value(dict_version_tests)
test_setitem_equal(dict_version_tests)
test_setdefault(dict_version_tests)
test_delitem(dict_version_tests)
test_pop(dict_version_tests)
test_popitem(dict_version_tests)
test_update(dict_version_tests)
test_clear(dict_version_tests)
dict_comprehension_test = DictComprehensionTest()
test_basics(dict_comprehension_test)
test_scope_isolation(dict_comprehension_test)
test_scope_isolation_from_global(dict_comprehension_test)
test_global_visibility(dict_comprehension_test)
test_local_visibility(dict_comprehension_test)
test_illegal_assignment(dict_comprehension_test)
test_evaluation_order(dict_comprehension_test)
test_assignment_idiom_in_comprehensions(dict_comprehension_test)
test_star_expression(dict_comprehension_test)
dict_set_test = DictSetTest()
test_constructors_not_callable(dict_set_test)
test_dict_keys(dict_set_test)
test_dict_items(dict_set_test)
test_dict_mixed_keys_items(dict_set_test)
test_dict_values(dict_set_test)
test_dict_repr(dict_set_test)
test_keys_set_operations(dict_set_test)
test_items_set_operations(dict_set_test)
test_set_operations_with_iterator(dict_set_test)
test_set_operations_with_noniterable(dict_set_test)
test_recursive_repr(dict_set_test)
test_deeply_nested_repr(dict_set_test)
test_copy(dict_set_test)
test_compare_error(dict_set_test)
test_pickle(dict_set_test)
test_abc_registry(dict_set_test)
e_o_f_test_case = EOFTestCase()
test_EOF_single_quote(e_o_f_test_case)
test_EOFS(e_o_f_test_case)
test_EOFS_with_file(e_o_f_test_case)
test_eof_with_line_continuation(e_o_f_test_case)
test_line_continuation_EOF(e_o_f_test_case)
test_line_continuation_EOF_from_file_bpo2180(e_o_f_test_case)
exception_tests = ExceptionTests()
testRaising(exception_tests)
testSyntaxErrorMessage(exception_tests)
testSyntaxErrorMissingParens(exception_tests)
test_error_offset_continuation_characters(exception_tests)
testSyntaxErrorOffset(exception_tests)
testSettingException(exception_tests)
test_WindowsError(exception_tests)
test_windows_message(exception_tests)
testAttributes(exception_tests)
testWithTraceback(exception_tests)
testInvalidTraceback(exception_tests)
testInvalidAttrs(exception_tests)
testNoneClearsTracebackAttr(exception_tests)
testChainingAttrs(exception_tests)
testChainingDescriptors(exception_tests)
testKeywordArgs(exception_tests)
testInfiniteRecursion(exception_tests)
test_str(exception_tests)
test_exception_cleanup_names(exception_tests)
test_exception_cleanup_names2(exception_tests)
testExceptionCleanupState(exception_tests)
test_exception_target_in_nested_scope(exception_tests)
test_generator_leaking(exception_tests)
test_generator_leaking2(exception_tests)
test_generator_leaking3(exception_tests)
test_generator_leaking4(exception_tests)
test_generator_doesnt_retain_old_exc(exception_tests)
test_generator_finalizing_and_exc_info(exception_tests)
test_generator_throw_cleanup_exc_state(exception_tests)
test_generator_close_cleanup_exc_state(exception_tests)
test_generator_del_cleanup_exc_state(exception_tests)
test_generator_next_cleanup_exc_state(exception_tests)
test_generator_send_cleanup_exc_state(exception_tests)
test_3114(exception_tests)
test_raise_does_not_create_context_chain_cycle(exception_tests)
test_no_hang_on_context_chain_cycle1(exception_tests)
test_no_hang_on_context_chain_cycle2(exception_tests)
test_no_hang_on_context_chain_cycle3(exception_tests)
test_unicode_change_attributes(exception_tests)
test_unicode_errors_no_object(exception_tests)
test_badisinstance(exception_tests)
test_trashcan_recursion(exception_tests)
test_recursion_normalizing_exception(exception_tests)
test_recursion_normalizing_infinite_exception(exception_tests)
test_recursion_in_except_handler(exception_tests)
test_recursion_normalizing_with_no_memory(exception_tests)
test_MemoryError(exception_tests)
test_exception_with_doc(exception_tests)
test_memory_error_cleanup(exception_tests)
test_recursion_error_cleanup(exception_tests)
test_errno_ENOTDIR(exception_tests)
test_unraisable(exception_tests)
test_unhandled(exception_tests)
test_memory_error_in_PyErr_PrintEx(exception_tests)
test_yield_in_nested_try_excepts(exception_tests)
test_generator_doesnt_retain_old_exc2(exception_tests)
test_raise_in_generator(exception_tests)
test_assert_shadowing(exception_tests)
test_memory_error_subclasses(exception_tests)
name_error_tests = NameErrorTests()
test_name_error_has_name(name_error_tests)
test_name_error_suggestions(name_error_tests)
test_name_error_suggestions_from_globals(name_error_tests)
test_name_error_suggestions_from_builtins(name_error_tests)
test_name_error_suggestions_do_not_trigger_for_long_names(name_error_tests)
test_name_error_bad_suggestions_do_not_trigger_for_small_names(name_error_tests)
test_name_error_suggestions_do_not_trigger_for_too_many_locals(name_error_tests)
test_name_error_with_custom_exceptions(name_error_tests)
test_unbound_local_error_doesn_not_match(name_error_tests)
test_issue45826(name_error_tests)
test_issue45826_focused(name_error_tests)
attribute_error_tests = AttributeErrorTests()
test_attributes(attribute_error_tests)
test_getattr_has_name_and_obj(attribute_error_tests)
test_getattr_has_name_and_obj_for_method(attribute_error_tests)
test_getattr_suggestions(attribute_error_tests)
test_getattr_suggestions_do_not_trigger_for_long_attributes(attribute_error_tests)
test_getattr_error_bad_suggestions_do_not_trigger_for_small_names(attribute_error_tests)
test_getattr_suggestions_do_not_trigger_for_big_dicts(attribute_error_tests)
test_getattr_suggestions_no_args(attribute_error_tests)
test_getattr_suggestions_invalid_args(attribute_error_tests)
test_getattr_suggestions_for_same_name(attribute_error_tests)
test_attribute_error_with_failing_dict(attribute_error_tests)
test_attribute_error_with_bad_name(attribute_error_tests)
test_attribute_error_inside_nested_getattr(attribute_error_tests)
import_error_tests = ImportErrorTests()
test_attributes(import_error_tests)
test_reset_attributes(import_error_tests)
test_non_str_argument(import_error_tests)
test_copy_pickle(import_error_tests)
syntax_error_tests = SyntaxErrorTests()
test_range_of_offsets(syntax_error_tests)
test_encodings(syntax_error_tests)
test_non_utf8(syntax_error_tests)
test_attributes_new_constructor(syntax_error_tests)
test_attributes_old_constructor(syntax_error_tests)
test_incorrect_constructor(syntax_error_tests)
p_e_p626_tests = PEP626Tests()
test_lineno_after_raise_simple(p_e_p626_tests)
test_lineno_after_raise_in_except(p_e_p626_tests)
test_lineno_after_other_except(p_e_p626_tests)
test_lineno_in_named_except(p_e_p626_tests)
test_lineno_in_try(p_e_p626_tests)
test_lineno_in_finally_normal(p_e_p626_tests)
test_lineno_in_finally_except(p_e_p626_tests)
test_lineno_after_with(p_e_p626_tests)
test_missing_lineno_shows_as_none(p_e_p626_tests)
test_lineno_after_raise_in_with_exit(p_e_p626_tests)
general_float_cases = GeneralFloatCases()
test_float(general_float_cases)
test_noargs(general_float_cases)
test_underscores(general_float_cases)
test_non_numeric_input_types(general_float_cases)
test_float_memoryview(general_float_cases)
test_error_message(general_float_cases)
test_float_with_comma(general_float_cases)
test_floatconversion(general_float_cases)
test_keyword_args(general_float_cases)
test_is_integer(general_float_cases)
test_floatasratio(general_float_cases)
test_float_containment(general_float_cases)
test_float_floor(general_float_cases)
test_float_ceil(general_float_cases)
test_float_mod(general_float_cases)
test_float_pow(general_float_cases)
test_hash(general_float_cases)
test_hash_nan(general_float_cases)
format_functions_test_case = FormatFunctionsTestCase()
setUp(format_functions_test_case)
test_getformat(format_functions_test_case)
test_setformat(format_functions_test_case)
tearDown(format_functions_test_case)
unknown_format_test_case = UnknownFormatTestCase()
setUp(unknown_format_test_case)
test_double_specials_dont_unpack(unknown_format_test_case)
test_float_specials_dont_unpack(unknown_format_test_case)
tearDown(unknown_format_test_case)
i_e_e_e_format_test_case = IEEEFormatTestCase()
test_double_specials_do_unpack(i_e_e_e_format_test_case)
test_float_specials_do_unpack(i_e_e_e_format_test_case)
test_serialized_float_rounding(i_e_e_e_format_test_case)
format_test_case = FormatTestCase()
test_format(format_test_case)
test_format_testfile(format_test_case)
test_issue5864(format_test_case)
test_issue35560(format_test_case)
repr_test_case = ReprTestCase()
test_repr(repr_test_case)
test_short_repr(repr_test_case)
round_test_case = RoundTestCase()
test_inf_nan(round_test_case)
test_large_n(round_test_case)
test_small_n(round_test_case)
test_overflow(round_test_case)
test_previous_round_bugs(round_test_case)
test_matches_float_format(round_test_case)
test_format_specials(round_test_case)
test_None_ndigits(round_test_case)
inf_nan_test = InfNanTest()
test_inf_from_str(inf_nan_test)
test_inf_as_str(inf_nan_test)
test_nan_from_str(inf_nan_test)
test_nan_as_str(inf_nan_test)
test_inf_signs(inf_nan_test)
test_nan_signs(inf_nan_test)
hex_float_test_case = HexFloatTestCase()
test_ends(hex_float_test_case)
test_invalid_inputs(hex_float_test_case)
test_whitespace(hex_float_test_case)
test_from_hex(hex_float_test_case)
test_roundtrip(hex_float_test_case)
test_subclass(hex_float_test_case)
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
fraction_test = FractionTest()
testInit(fraction_test)
testInitFromFloat(fraction_test)
testInitFromDecimal(fraction_test)
testFromString(fraction_test)
testImmutable(fraction_test)
testFromFloat(fraction_test)
testFromDecimal(fraction_test)
test_as_integer_ratio(fraction_test)
testLimitDenominator(fraction_test)
testConversions(fraction_test)
testBoolGuarateesBoolReturn(fraction_test)
testRound(fraction_test)
testArithmetic(fraction_test)
testLargeArithmetic(fraction_test)
testMixedArithmetic(fraction_test)
testMixingWithDecimal(fraction_test)
testComparisons(fraction_test)
testComparisonsDummyRational(fraction_test)
testComparisonsDummyFloat(fraction_test)
testMixedLess(fraction_test)
testMixedLessEqual(fraction_test)
testBigFloatComparisons(fraction_test)
testBigComplexComparisons(fraction_test)
testMixedEqual(fraction_test)
testStringification(fraction_test)
testHash(fraction_test)
testApproximatePi(fraction_test)
testApproximateCos1(fraction_test)
test_copy_deepcopy_pickle(fraction_test)
test_slots(fraction_test)
test_int_subclass(fraction_test)
test_frozen = TestFrozen()
test_frozen(test_frozen)
test_case = TestCase()
test__format__lookup(test_case)
test_ast(test_case)
test_ast_line_numbers(test_case)
test_ast_line_numbers_multiple_formattedvalues(test_case)
test_ast_line_numbers_nested(test_case)
test_ast_line_numbers_duplicate_expression(test_case)
test_ast_numbers_fstring_with_formatting(test_case)
test_ast_line_numbers_multiline_fstring(test_case)
test_ast_line_numbers_with_parentheses(test_case)
test_docstring(test_case)
test_literal_eval(test_case)
test_ast_compile_time_concat(test_case)
test_compile_time_concat_errors(test_case)
test_literal(test_case)
test_unterminated_string(test_case)
test_mismatched_parens(test_case)
test_double_braces(test_case)
test_compile_time_concat(test_case)
test_comments(test_case)
test_many_expressions(test_case)
test_format_specifier_expressions(test_case)
test_side_effect_order(test_case)
test_missing_expression(test_case)
test_parens_in_expressions(test_case)
test_newlines_before_syntax_error(test_case)
test_backslashes_in_string_part(test_case)
test_misformed_unicode_character_name(test_case)
test_no_backslashes_in_expression_part(test_case)
test_no_escapes_for_braces(test_case)
test_newlines_in_expressions(test_case)
test_lambda(test_case)
test_yield(test_case)
test_yield_send(test_case)
test_expressions_with_triple_quoted_strings(test_case)
test_multiple_vars(test_case)
test_closure(test_case)
test_arguments(test_case)
test_locals(test_case)
test_missing_variable(test_case)
test_missing_format_spec(test_case)
test_global(test_case)
test_shadowed_global(test_case)
test_call(test_case)
test_nested_fstrings(test_case)
test_invalid_string_prefixes(test_case)
test_leading_trailing_spaces(test_case)
test_not_equal(test_case)
test_equal_equal(test_case)
test_conversions(test_case)
test_assignment(test_case)
test_del(test_case)
test_mismatched_braces(test_case)
test_if_conditional(test_case)
test_empty_format_specifier(test_case)
test_str_format_differences(test_case)
test_errors(test_case)
test_filename_in_syntaxerror(test_case)
test_loop(test_case)
test_dict(test_case)
test_backslash_char(test_case)
test_debug_conversion(test_case)
test_walrus(test_case)
test_invalid_syntax_error_message(test_case)
test_with_two_commas_in_format_specifier(test_case)
test_with_two_underscore_in_format_specifier(test_case)
test_with_a_commas_and_an_underscore_in_format_specifier(test_case)
test_with_an_underscore_and_a_comma_in_format_specifier(test_case)
test_syntax_error_for_starred_expressions(test_case)
test_p_e_p479 = TestPEP479()
test_stopiteration_wrapping(test_p_e_p479)
test_stopiteration_wrapping_context(test_p_e_p479)
signal_and_yield_from_test = SignalAndYieldFromTest()
test_raise_and_yield_from(signal_and_yield_from_test)
finalization_test = FinalizationTest()
test_frame_resurrect(finalization_test)
test_refcycle(finalization_test)
test_lambda_generator(finalization_test)
generator_test = GeneratorTest()
test_name(generator_test)
test_copy(generator_test)
test_pickle(generator_test)
test_send_non_none_to_new_gen(generator_test)
exception_test = ExceptionTest()
test_except_throw(exception_test)
test_except_next(exception_test)
test_except_gen_except(exception_test)
test_except_throw_exception_context(exception_test)
test_except_throw_bad_exception(exception_test)
test_stopiteration_error(exception_test)
test_tutorial_stopiteration(exception_test)
test_return_tuple(exception_test)
test_return_stopiteration(exception_test)
generator_throw_test = GeneratorThrowTest()
test_exception_context_with_yield(generator_throw_test)
test_exception_context_with_yield_inside_generator(generator_throw_test)
test_exception_context_with_yield_from(generator_throw_test)
test_exception_context_with_yield_from_with_context_cycle(generator_throw_test)
test_throw_after_none_exc_type(generator_throw_test)
generator_stack_trace_test = GeneratorStackTraceTest()
test_send_with_yield_from(generator_stack_trace_test)
test_throw_with_yield_from(generator_stack_trace_test)
yield_from_tests = YieldFromTests()
test_generator_gi_yieldfrom(yield_from_tests)
global_tests = GlobalTests()
setUp(global_tests)
test1(global_tests)
test2(global_tests)
test3(global_tests)
test4(global_tests)
tearDown(global_tests)
int_test_cases = IntTestCases()
test_basic(int_test_cases)
test_underscores(int_test_cases)
test_small_ints(int_test_cases)
test_no_args(int_test_cases)
test_keyword_args(int_test_cases)
test_int_base_limits(int_test_cases)
test_int_base_bad_types(int_test_cases)
test_int_base_indexable(int_test_cases)
test_non_numeric_input_types(int_test_cases)
test_int_memoryview(int_test_cases)
test_string_float(int_test_cases)
test_intconversion(int_test_cases)
test_int_subclass_with_index(int_test_cases)
test_int_subclass_with_int(int_test_cases)
test_int_returns_int_subclass(int_test_cases)
test_error_message(int_test_cases)
test_issue31619(int_test_cases)
test_hex_oct_bin = TestHexOctBin()
test_hex_baseline(test_hex_oct_bin)
test_hex_unsigned(test_hex_oct_bin)
test_oct_baseline(test_hex_oct_bin)
test_oct_unsigned(test_hex_oct_bin)
test_bin_baseline(test_hex_oct_bin)
test_bin_unsigned(test_hex_oct_bin)
test_is_instance_exceptions = TestIsInstanceExceptions()
test_class_has_no_bases(test_is_instance_exceptions)
test_bases_raises_other_than_attribute_error(test_is_instance_exceptions)
test_dont_mask_non_attribute_error(test_is_instance_exceptions)
test_mask_attribute_error(test_is_instance_exceptions)
test_isinstance_dont_mask_non_attribute_error(test_is_instance_exceptions)
test_is_subclass_exceptions = TestIsSubclassExceptions()
test_dont_mask_non_attribute_error(test_is_subclass_exceptions)
test_mask_attribute_error(test_is_subclass_exceptions)
test_dont_mask_non_attribute_error_in_cls_arg(test_is_subclass_exceptions)
test_mask_attribute_error_in_cls_arg(test_is_subclass_exceptions)
test_is_instance_is_subclass = TestIsInstanceIsSubclass()
test_isinstance_normal(test_is_instance_is_subclass)
test_isinstance_abstract(test_is_instance_is_subclass)
test_subclass_normal(test_is_instance_is_subclass)
test_subclass_abstract(test_is_instance_is_subclass)
test_subclass_tuple(test_is_instance_is_subclass)
test_subclass_recursion_limit(test_is_instance_is_subclass)
test_isinstance_recursion_limit(test_is_instance_is_subclass)
test_issubclass_refcount_handling(test_is_instance_is_subclass)
test_infinite_recursion_in_bases(test_is_instance_is_subclass)
test_infinite_recursion_via_bases_tuple(test_is_instance_is_subclass)
test_infinite_cycle_in_bases(test_is_instance_is_subclass)
test_infinitely_many_bases(test_is_instance_is_subclass)
test_case = TestCase()
test_iter_basic(test_case)
test_iter_idempotency(test_case)
test_iter_for_loop(test_case)
test_iter_independence(test_case)
test_nested_comprehensions_iter(test_case)
test_nested_comprehensions_for(test_case)
test_iter_class_for(test_case)
test_iter_class_iter(test_case)
test_seq_class_for(test_case)
test_seq_class_iter(test_case)
test_mutating_seq_class_iter_pickle(test_case)
test_mutating_seq_class_exhausted_iter(test_case)
test_new_style_iter_class(test_case)
test_iter_callable(test_case)
test_iter_function(test_case)
test_iter_function_stop(test_case)
test_exception_function(test_case)
test_exception_sequence(test_case)
test_stop_sequence(test_case)
test_iter_big_range(test_case)
test_iter_empty(test_case)
test_iter_tuple(test_case)
test_iter_range(test_case)
test_iter_string(test_case)
test_iter_dict(test_case)
test_iter_file(test_case)
test_builtin_list(test_case)
test_builtin_tuple(test_case)
test_builtin_filter(test_case)
test_builtin_max_min(test_case)
test_builtin_map(test_case)
test_builtin_zip(test_case)
test_unicode_join_endcase(test_case)
test_in_and_not_in(test_case)
test_countOf(test_case)
test_indexOf(test_case)
test_writelines(test_case)
test_unpack_iter(test_case)
test_ref_counting_behavior(test_case)
test_sinkstate_list(test_case)
test_sinkstate_tuple(test_case)
test_sinkstate_string(test_case)
test_sinkstate_sequence(test_case)
test_sinkstate_callable(test_case)
test_sinkstate_dict(test_case)
test_sinkstate_yield(test_case)
test_sinkstate_range(test_case)
test_sinkstate_enumerate(test_case)
test_3720(test_case)
test_extending_list_with_iterator_does_not_segfault(test_case)
test_iter_overflow(test_case)
test_iter_neg_setstate(test_case)
test_free_after_iterating(test_case)
test_error_iter(test_case)
test_repeat = TestRepeat()
setUp(test_repeat)
test_xrange = TestXrange()
setUp(test_xrange)
test_xrange_custom_reversed = TestXrangeCustomReversed()
setUp(test_xrange_custom_reversed)
test_tuple = TestTuple()
setUp(test_tuple)
test_deque = TestDeque()
setUp(test_deque)
test_deque_reversed = TestDequeReversed()
setUp(test_deque_reversed)
test_dict_keys = TestDictKeys()
setUp(test_dict_keys)
test_dict_items = TestDictItems()
setUp(test_dict_items)
test_dict_values = TestDictValues()
setUp(test_dict_values)
test_set = TestSet()
setUp(test_set)
test_list = TestList()
setUp(test_list)
test_mutation(test_list)
test_list_reversed = TestListReversed()
setUp(test_list_reversed)
test_mutation(test_list_reversed)
test_length_hint_exceptions = TestLengthHintExceptions()
test_issue1242657(test_length_hint_exceptions)
test_invalid_hint(test_length_hint_exceptions)
keyword_only_arg_test_case = KeywordOnlyArgTestCase()
testSyntaxErrorForFunctionDefinition(keyword_only_arg_test_case)
testSyntaxForManyArguments(keyword_only_arg_test_case)
testTooManyPositionalErrorMessage(keyword_only_arg_test_case)
testSyntaxErrorForFunctionCall(keyword_only_arg_test_case)
testRaiseErrorFuncallWithUnexpectedKeywordArgument(keyword_only_arg_test_case)
testFunctionCall(keyword_only_arg_test_case)
testKwDefaults(keyword_only_arg_test_case)
test_kwonly_methods(keyword_only_arg_test_case)
test_issue13343(keyword_only_arg_test_case)
test_mangling(keyword_only_arg_test_case)
test_default_evaluation_order(keyword_only_arg_test_case)
long_test = LongTest()
test_division(long_test)
test_karatsuba(long_test)
test_bitop_identities(long_test)
test_format(long_test)
test_long(long_test)
test_conversion(long_test)
test_float_conversion(long_test)
test_float_overflow(long_test)
test_logs(long_test)
test_mixed_compares(long_test)
test__format__(long_test)
test_nan_inf(long_test)
test_mod_division(long_test)
test_true_division(long_test)
test_floordiv(long_test)
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