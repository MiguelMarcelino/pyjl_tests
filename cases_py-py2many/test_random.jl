# Transpiled with flags: 
# - oop
using ObjectOriented
using Pickle
using Random
using Test
using Xsum
import _random







import warnings

using functools: partial


using fractions: Fraction

@oodef mutable struct MySeed <: object
                    
                    
                    
                end
                function __hash__(self::@like(MySeed))::Int64
return -1729
end


@oodef mutable struct SeqSet <: {abc.Sequence, abc.Set}
                    
                    _items
                    
function new(items, _items = items)
@mk begin
_items = _items
end
end

                end
                function __len__(self::@like(SeqSet))::Int64
return length(self._items)
end

function __getitem__(self::@like(SeqSet), index)
return self._items[index + 1]
end


@oodef mutable struct TestBasicOps
                    
                    
                    
                end
                function randomlist(self::@like(TestBasicOps), n)
#= Helper function to make a list of random numbers =#
return [random(self.gen) for i in 0:n - 1]
end

function test_autoseed(self::@like(TestBasicOps))
seed(self.gen)
state1 = getstate(self.gen)
time.sleep(0.1)
seed(self.gen)
state2 = getstate(self.gen)
assertNotEqual(self, state1, state2)
end

function test_saverestore(self::@like(TestBasicOps))
N = 1000
seed(self.gen)
state = getstate(self.gen)
randseq = randomlist(self, N)
setstate(self.gen, state)
assertEqual(self, randseq, randomlist(self, N))
end

function test_seedargs(self::@like(TestBasicOps))
for arg in [nothing, 0, 1, -1, 10^20, -(10^20), false, true, 3.14, "a"]
seed(self.gen, arg)
end
for arg in [1 + 2im, tuple("abc"), MySeed()]
assertWarns(self, DeprecationWarning) do 
seed(self.gen, arg)
end
end
for arg in [collect(0:2), dict(one = 1)]
assertWarns(self, DeprecationWarning) do 
assertRaises(self, TypeError, self.gen.seed, arg)
end
end
assertRaises(self, TypeError, self.gen.seed, 1, 2, 3, 4)
assertRaises(self, TypeError, type_(self.gen), [])
end

function test_seed_no_mutate_bug_44018(self::@like(TestBasicOps))
a = Vector{UInt8}(b"1234")
seed(self.gen, a)
assertEqual(self, a, Vector{UInt8}(b"1234"))
end

function test_seed_when_randomness_source_not_found(self::@like(TestBasicOps), urandom_mock)
urandom_mock.side_effect = NotImplementedError
test_seedargs(self)
end

function test_shuffle(self::@like(TestBasicOps))
shuffle = self.gen.shuffle
lst = []
shuffle(lst)
assertEqual(self, lst, [])
lst = [37]
shuffle(lst)
assertEqual(self, lst, [37])
seqs = [collect(0:n - 1) for n in 0:9]
shuffled_seqs = [collect(0:n - 1) for n in 0:9]
for shuffled_seq in shuffled_seqs
shuffle(shuffled_seq)
end
for (seq, shuffled_seq) in zip(seqs, shuffled_seqs)
assertEqual(self, length(seq), length(shuffled_seq))
assertEqual(self, Set(seq), Set(shuffled_seq))
end
lst = collect(0:999)
shuffled_lst = collect(0:999)
shuffle(shuffled_lst)
assertTrue(self, lst != shuffled_lst)
shuffle(lst)
assertTrue(self, lst != shuffled_lst)
assertRaises(self, TypeError, shuffle, (1, 2, 3))
end

function test_shuffle_random_argument(self::@like(TestBasicOps))
shuffle = self.gen.shuffle
mock_random = unittest.Mock(return_value = 0.5)
seq = Vector{UInt8}(b"abcdefghijk")
assertWarns(self, DeprecationWarning) do 
shuffle(seq, mock_random)
end
assert_called_with(mock_random)
end

function test_choice(self::@like(TestBasicOps))
choice = self.gen.choice
assertRaises(self, IndexError) do 
choice([])
end
assertEqual(self, choice([50]), 50)
assertIn(self, choice([25, 75]), [25, 75])
end

function test_sample(self::@like(TestBasicOps))
N = 100
population = 0:N - 1
for k in 0:N
s = sample(self.gen, population, k)
assertEqual(self, length(s), k)
uniq = Set(s)
assertEqual(self, length(uniq), k)
assertTrue(self, uniq <= Set(population))
end
assertEqual(self, sample(self.gen, [], 0), [])
assertRaises(self, ValueError, self.gen.sample, population, N + 1)
assertRaises(self, ValueError, self.gen.sample, [], -1)
end

function test_sample_distribution(self::@like(TestBasicOps))
n = 5
pop = 0:n - 1
trials = 10000
for k in 0:n - 1
expected = factorial(n) ÷ factorial(n - k)
perms = Dict()
has_break = false
for i in 0:trials - 1
perms[tuple(sample(self.gen, pop, k))] = nothing
if length(perms) == expected
has_break = true
break;
end
end
if has_break != true
fail(self)
end
end
end

function test_sample_inputs(self::@like(TestBasicOps))
sample(self.gen, 0:19, 2)
sample(self.gen, 0:19, 2)
sample(self.gen, string("abcdefghijklmnopqrst"), 2)
sample(self.gen, tuple("abcdefghijklmnopqrst"), 2)
end

function test_sample_on_dicts(self::@like(TestBasicOps))
assertRaises(self, TypeError, self.gen.sample, fromkeys(dict, "abcdef"), 2)
end

function test_sample_on_sets(self::@like(TestBasicOps))
assertWarns(self, DeprecationWarning) do 
population = Set([10, 20, 30, 40, 50, 60, 70])
sample(self.gen, population, k = 5)
end
end

function test_sample_on_seqsets(self::@like(TestBasicOps))
population = SeqSet([2, 4, 1, 3])
warnings.catch_warnings() do 
warnings.simplefilter("error", DeprecationWarning)
sample(self.gen, population, k = 2)
end
end

function test_sample_with_counts(self::@like(TestBasicOps))
sample = self.gen.sample
colors = ["red", "green", "blue", "orange", "black", "brown", "amber"]
counts = [500, 200, 20, 10, 5, 0, 1]
k = 700
summary_ = Counter(sample(colors, counts = counts, k = k))
assertEqual(self, sum(values(summary_)), k)
for (color, weight) in zip(colors, counts)
assertLessEqual(self, summary_[color + 1], weight)
end
assertNotIn(self, "brown", summary_)
k = sum(counts)
summary_ = Counter(sample(colors, counts = counts, k = k))
assertEqual(self, sum(values(summary_)), k)
for (color, weight) in zip(colors, counts)
assertLessEqual(self, summary_[color + 1], weight)
end
assertNotIn(self, "brown", summary_)
summary_ = Counter(sample(["x"], counts = [10], k = 8))
assertEqual(self, summary_, Counter(x = 8))
nc = length(colors)
summary_ = Counter(sample(colors, counts = repeat([10],nc), k = 10*nc))
assertEqual(self, summary_, Counter(repeat(colors,10)))
assertRaises(self, TypeError) do 
sample(["red", "green", "blue"], counts = 10, k = 10)
end
assertRaises(self, ValueError) do 
sample(["red", "green", "blue"], counts = [-3, -7, -8], k = 2)
end
assertRaises(self, ValueError) do 
sample(["red", "green", "blue"], counts = [0, 0, 0], k = 2)
end
assertRaises(self, ValueError) do 
sample(["red", "green"], counts = [10, 10], k = 21)
end
assertRaises(self, ValueError) do 
sample(["red", "green", "blue"], counts = [1, 2], k = 2)
end
assertRaises(self, ValueError) do 
sample(["red", "green", "blue"], counts = [1, 2, 3, 4], k = 2)
end
end

function test_choices(self::@like(TestBasicOps))
choices = self.gen.choices
data = ["red", "green", "blue", "yellow"]
str_data = "abcd"
range_data = 0:3
set_data = Set(0:3)
for sample in [choices(data, k = 5), choices(data, 0:3, k = 5), choices(k = 5, population = data, weights = 0:3), choices(k = 5, population = data, cum_weights = 0:3)]
assertEqual(self, length(sample), 5)
assertEqual(self, type_(sample), Vector)
assertTrue(self, Set(sample) <= Set(data))
end
assertRaises(self, TypeError) do 
choices(2)
end
assertEqual(self, choices(data, k = 0), [])
assertEqual(self, choices(data, k = -1), [])
assertRaises(self, TypeError) do 
choices(data, k = 2.5)
end
assertTrue(self, Set(choices(str_data, k = 5)) <= Set(str_data))
assertTrue(self, Set(choices(range_data, k = 5)) <= Set(range_data))
assertRaises(self, TypeError) do 
choices(set_data, k = 2)
end
assertTrue(self, Set(choices(data, nothing, k = 5)) <= Set(data))
assertTrue(self, Set(choices(data, weights = nothing, k = 5)) <= Set(data))
assertRaises(self, ValueError) do 
choices(data, [1, 2], k = 5)
end
assertRaises(self, TypeError) do 
choices(data, 10, k = 5)
end
assertRaises(self, TypeError) do 
choices(data, repeat([nothing],4), k = 5)
end
for weights in [[15, 10, 25, 30], [15.1, 10.2, 25.2, 30.3], [Fraction(1, 3), Fraction(2, 6), Fraction(3, 6), Fraction(4, 6)], [true, false, true, false]]
assertTrue(self, Set(choices(data, weights, k = 5)) <= Set(data))
end
assertRaises(self, ValueError) do 
choices(data, cum_weights = [1, 2], k = 5)
end
assertRaises(self, TypeError) do 
choices(data, cum_weights = 10, k = 5)
end
assertRaises(self, TypeError) do 
choices(data, cum_weights = repeat([nothing],4), k = 5)
end
assertRaises(self, TypeError) do 
choices(data, 0:3, cum_weights = 0:3, k = 5)
end
for weights in [[15, 10, 25, 30], [15.1, 10.2, 25.2, 30.3], [Fraction(1, 3), Fraction(2, 6), Fraction(3, 6), Fraction(4, 6)]]
assertTrue(self, Set(choices(data, cum_weights = weights, k = 5)) <= Set(data))
end
assertEqual(self, choices("abcd", [1, 0, 0, 0]), ["a"])
assertEqual(self, choices("abcd", [0, 1, 0, 0]), ["b"])
assertEqual(self, choices("abcd", [0, 0, 1, 0]), ["c"])
assertEqual(self, choices("abcd", [0, 0, 0, 1]), ["d"])
assertRaises(self, IndexError) do 
choices([], k = 1)
end
assertRaises(self, IndexError) do 
choices([], weights = [], k = 1)
end
assertRaises(self, IndexError) do 
choices([], cum_weights = [], k = 5)
end
end

function test_choices_subnormal(self::@like(TestBasicOps))
choices = self.gen.choices
choices(population = [1, 2], weights = [1e-323, 1e-323], k = 5000)
end

function test_choices_with_all_zero_weights(self::@like(TestBasicOps))
assertRaises(self, ValueError) do 
choices(self.gen, "AB", [0.0, 0.0])
end
end

function test_choices_negative_total(self::@like(TestBasicOps))
assertRaises(self, ValueError) do 
choices(self.gen, "ABC", [3, -5, 1])
end
end

function test_choices_infinite_total(self::@like(TestBasicOps))
assertRaises(self, ValueError) do 
choices(self.gen, "A", [parse(Float64, "inf")])
end
assertRaises(self, ValueError) do 
choices(self.gen, "AB", [0.0, parse(Float64, "inf")])
end
assertRaises(self, ValueError) do 
choices(self.gen, "AB", [-parse(Float64, "inf"), 123])
end
assertRaises(self, ValueError) do 
choices(self.gen, "AB", [0.0, parse(Float64, "nan")])
end
assertRaises(self, ValueError) do 
choices(self.gen, "AB", [parse(Float64, "-inf"), parse(Float64, "inf")])
end
end

function test_gauss(self::@like(TestBasicOps))
for seed in (1, 12, 123, 1234, 12345, 123456, 654321)
seed(self.gen, seed)
x1 = random(self.gen)
y1 = gauss(self.gen, 0, 1)
seed(self.gen, seed)
x2 = random(self.gen)
y2 = gauss(self.gen, 0, 1)
assertEqual(self, x1, x2)
assertEqual(self, y1, y2)
end
end

function test_getrandbits(self::@like(TestBasicOps))
for k in 1:999
assertTrue(self, 0 <= getrandbits(self.gen, k) < (2^k))
end
assertEqual(self, getrandbits(self.gen, 0), 0)
getbits = self.gen.getrandbits
for span in [1, 2, 3, 4, 31, 32, 32, 52, 53, 54, 119, 127, 128, 129]
all_bits = 2^span - 1
cum = 0
cpl_cum = 0
for i in 0:99
v = getbits(span)
cum |= v
cpl_cum |= all_bits ⊻ v
end
assertEqual(self, cum, all_bits)
assertEqual(self, cpl_cum, all_bits)
end
assertRaises(self, TypeError, self.gen.getrandbits)
assertRaises(self, TypeError, self.gen.getrandbits, 1, 2)
assertRaises(self, ValueError, self.gen.getrandbits, -1)
assertRaises(self, TypeError, self.gen.getrandbits, 10.1)
end

function test_pickling(self::@like(TestBasicOps))
for proto in 0:pickle.HIGHEST_PROTOCOL
state = pickle.dumps(self.gen, proto)
origseq = [random(self.gen) for i in 0:9]
newgen = pickle.loads(state)
restoredseq = [random(newgen) for i in 0:9]
assertEqual(self, origseq, restoredseq)
end
end

function test_bug_41052(self::@like(TestBasicOps))
for proto in 0:pickle.HIGHEST_PROTOCOL
r = _random.Random()
assertRaises(self, TypeError, pickle.dumps, r, proto)
end
end

function test_bug_42008(self::@like(TestBasicOps))
r1 = _random.Random()
seed(r1, 8675309)
r2 = _random.Random(8675309)
assertEqual(self, random(r1), random(r2))
end

function test_bug_1727780(self::@like(TestBasicOps))
files = [("randv2_32.pck", 780), ("randv2_64.pck", 866), ("randv3.pck", 343)]
for (file, value) in files
readline(support.findfile(file)) do f 
r = Pickle.load(f)
end
assertEqual(self, parse(Int, random(r)*1000), value)
end
end

function test_bug_9025(self::@like(TestBasicOps))
n = 100000
randrange = self.gen.randrange
k = sum(((randrange(6755399441055744) % 3) == 2 for i in 0:n - 1))
assertTrue(self, 0.3 < (k / n) < 0.37, k / n)
end

function test_randbytes(self::@like(TestBasicOps))
for n in 1:9
data = randbytes(self.gen, n)
assertEqual(self, type_(data), Array{UInt8})
assertEqual(self, length(data), n)
end
assertEqual(self, randbytes(self.gen, 0), b"")
assertRaises(self, TypeError, self.gen.randbytes)
assertRaises(self, TypeError, self.gen.randbytes, 1, 2)
assertRaises(self, ValueError, self.gen.randbytes, -1)
assertRaises(self, TypeError, self.gen.randbytes, 1.0)
end


try
random(random.SystemRandom())
catch exn
if exn isa NotImplementedError
SystemRandom_available = false
end
end
@oodef mutable struct SystemRandom_TestBasicOps <: {TestBasicOps, unittest.TestCase}
                    
                    gen
                    
function new(gen = random.SystemRandom())
gen = gen
new(gen)
end

                end
                function test_autoseed(self::@like(SystemRandom_TestBasicOps))
seed(self.gen)
end

function test_saverestore(self::@like(SystemRandom_TestBasicOps))
@test_throws
@test_throws
end

function test_seedargs(self::@like(SystemRandom_TestBasicOps))
seed(self.gen, 100)
end

function test_gauss(self::@like(SystemRandom_TestBasicOps))
self.gen.gauss_next = nothing
seed(self.gen, 100)
@test (self.gen.gauss_next == nothing)
end

function test_pickling(self::@like(SystemRandom_TestBasicOps))
for proto in 0:pickle.HIGHEST_PROTOCOL
@test_throws
end
end

function test_53_bits_per_float(self::@like(SystemRandom_TestBasicOps))
span = 2^53
cum = 0
for i in 0:99
cum |= parse(Int, random(self.gen)*span)
end
@test (cum == span - 1)
end

function test_bigrand(self::@like(SystemRandom_TestBasicOps))
span = 2^500
cum = 0
for i in 0:99
r = randrange(self.gen, span)
@test 0 <= r < span
cum |= r
end
@test (cum == span - 1)
end

function test_bigrand_ranges(self::@like(SystemRandom_TestBasicOps))
for i in [40, 80, 160, 200, 211, 250, 375, 512, 550]
start = randrange(self.gen, 2^(i - 2))
stop = randrange(self.gen, 2^i)
if stop <= start
continue;
end
@test start <= randrange(self.gen, start, stop) < stop
end
end

function test_rangelimits(self::@like(SystemRandom_TestBasicOps))
for (start, stop) in [(-2, 0), (-(2^60) - 2, -(2^60)), (2^60, 2^60 + 2)]
@test (Set(start:stop - 1) == Set([randrange(self.gen, start, stop) for i in 0:99]))
end
end

function test_randrange_nonunit_step(self::@like(SystemRandom_TestBasicOps))
rint = randrange(self.gen, 0, 10, 2)
assertIn(self, rint, (0, 2, 4, 6, 8))
rint = randrange(self.gen, 0, 2, 2)
@test (rint == 0)
end

function test_randrange_errors(self::@like(SystemRandom_TestBasicOps))
raises = partial(@test_throws, ValueError, self.gen.randrange)
raises(3, 3)
raises(-721)
raises(0, 100, -12)
assertWarns(self, DeprecationWarning, raises, 3.14159)
assertWarns(self, DeprecationWarning, self.gen.randrange, 3.0)
assertWarns(self, DeprecationWarning, self.gen.randrange, Fraction(3, 1))
assertWarns(self, DeprecationWarning, raises, "3")
assertWarns(self, DeprecationWarning, raises, 0, 2.71828)
assertWarns(self, DeprecationWarning, self.gen.randrange, 0, 2.0)
assertWarns(self, DeprecationWarning, self.gen.randrange, 0, Fraction(2, 1))
assertWarns(self, DeprecationWarning, raises, 0, "2")
raises(0, 42, 0)
assertWarns(self, DeprecationWarning, raises, 0, 42, 0.0)
assertWarns(self, DeprecationWarning, raises, 0, 0, 0.0)
assertWarns(self, DeprecationWarning, raises, 0, 42, 3.14159)
assertWarns(self, DeprecationWarning, self.gen.randrange, 0, 42, 3.0)
assertWarns(self, DeprecationWarning, self.gen.randrange, 0, 42, Fraction(3, 1))
assertWarns(self, DeprecationWarning, raises, 0, 42, "3")
assertWarns(self, DeprecationWarning, self.gen.randrange, 0, 42, 1.0)
assertWarns(self, DeprecationWarning, raises, 0, 0, 1.0)
end

function test_randrange_argument_handling(self::@like(SystemRandom_TestBasicOps))
randrange = self.gen.randrange
assertWarns(self, DeprecationWarning) do 
randrange(10.0, 20, 2)
end
assertWarns(self, DeprecationWarning) do 
randrange(10, 20.0, 2)
end
assertWarns(self, DeprecationWarning) do 
randrange(10, 20, 1.0)
end
assertWarns(self, DeprecationWarning) do 
randrange(10, 20, 2.0)
end
assertWarns(self, DeprecationWarning) do 
@test_throws ValueError do 
randrange(10.5)
end
end
assertWarns(self, DeprecationWarning) do 
@test_throws ValueError do 
randrange(10, 20.5)
end
end
assertWarns(self, DeprecationWarning) do 
@test_throws ValueError do 
randrange(10, 20, 1.5)
end
end
end

function test_randrange_step(self::@like(SystemRandom_TestBasicOps))
randrange = self.gen.randrange
@test_throws TypeError do 
randrange(1000, step = 100)
end
@test_throws TypeError do 
randrange(1000, nothing, step = 100)
end
end

function test_randbelow_logic(self::@like(SystemRandom_TestBasicOps), _log = log, int = int)
for i in 1:999
n = 1 << i
numbits = i + 1
k = parse(Int, 1.00001 + _log(n, 2))
@test (k == numbits)
@test (n == 2^(k - 1))
n += n - 1
k = parse(Int, 1.00001 + _log(n, 2))
assertIn(self, k, [numbits, numbits + 1])
@test (2^k) > n > (2^(k - 2))
n -= n >> 15
k = parse(Int, 1.00001 + _log(n, 2))
@test (k == numbits)
@test (2^k) > n > (2^(k - 1))
end
end


@oodef mutable struct BadInt <: Int64
                    
                    
                    
                end
                function __abs__(self::@like(BadInt))
return nothing
end


@oodef mutable struct MersenneTwister_TestBasicOps <: {TestBasicOps, unittest.TestCase}
                    
                    gen
                    
function new(gen = random.Random())
gen = gen
new(gen)
end

                end
                function test_guaranteed_stable(self::@like(MersenneTwister_TestBasicOps))
seed(self.gen, 3456147, version = 1)
@test ([hex(random(self.gen)) for i in 0:3] == ["0x1.ac362300d90d2p-1", "0x1.9d16f74365005p-1", "0x1.1ebb4352e4c4dp-1", "0x1.1a7422abf9c11p-1"])
seed(self.gen, "the quick brown fox", version = 2)
@test ([hex(random(self.gen)) for i in 0:3] == ["0x1.1239ddfb11b7cp-3", "0x1.b3cbb5c51b120p-4", "0x1.8c4f55116b60fp-1", "0x1.63eb525174a27p-1"])
end

function test_bug_27706(self::@like(MersenneTwister_TestBasicOps))
seed(self.gen, "nofar", version = 1)
@test ([hex(random(self.gen)) for i in 0:3] == ["0x1.8645314505ad7p-1", "0x1.afb1f82e40a40p-5", "0x1.2a59d2285e971p-1", "0x1.56977142a7880p-6"])
seed(self.gen, "rachel", version = 1)
@test ([hex(random(self.gen)) for i in 0:3] == ["0x1.0b294cc856fcdp-1", "0x1.2ad22d79e77b8p-3", "0x1.3052b9c072678p-2", "0x1.578f332106574p-3"])
seed(self.gen, "", version = 1)
@test ([hex(random(self.gen)) for i in 0:3] == ["0x1.b0580f98a7dbep-1", "0x1.84129978f9c1ap-1", "0x1.aeaa51052e978p-2", "0x1.092178fb945a6p-2"])
end

function test_bug_31478(self::@like(MersenneTwister_TestBasicOps))
try
seed(self.gen, BadInt())
catch exn
if exn isa TypeError
#= pass =#
end
end
end

function test_bug_31482(self::@like(MersenneTwister_TestBasicOps))
seed(self.gen, b"nofar", version = 1)
@test ([hex(random(self.gen)) for i in 0:3] == ["0x1.8645314505ad7p-1", "0x1.afb1f82e40a40p-5", "0x1.2a59d2285e971p-1", "0x1.56977142a7880p-6"])
seed(self.gen, b"rachel", version = 1)
@test ([hex(random(self.gen)) for i in 0:3] == ["0x1.0b294cc856fcdp-1", "0x1.2ad22d79e77b8p-3", "0x1.3052b9c072678p-2", "0x1.578f332106574p-3"])
seed(self.gen, b"", version = 1)
@test ([hex(random(self.gen)) for i in 0:3] == ["0x1.b0580f98a7dbep-1", "0x1.84129978f9c1ap-1", "0x1.aeaa51052e978p-2", "0x1.092178fb945a6p-2"])
b = b"\x00 @`\x80\xa0\xc0\xe0\xf0"
seed(self.gen, b, version = 1)
@test ([hex(random(self.gen)) for i in 0:3] == ["0x1.52c2fde444d23p-1", "0x1.875174f0daea4p-2", "0x1.9e9b2c50e5cd2p-1", "0x1.fa57768bd321cp-2"])
end

function test_setstate_first_arg(self::@like(MersenneTwister_TestBasicOps))
@test_throws
end

function test_setstate_middle_arg(self::@like(MersenneTwister_TestBasicOps))
start_state = getstate(self.gen)
@test_throws
@test_throws
@test_throws
@test_throws
@test_throws (ValueError, OverflowError) do 
setstate(self.gen, (2, repeat([(1,)...],624) + (625,), nothing))
end
@test_throws (ValueError, OverflowError) do 
setstate(self.gen, (2, repeat([(1,)...],624) + (-1,), nothing))
end
bits100 = getrandbits(self.gen, 100)
setstate(self.gen, start_state)
@test (getrandbits(self.gen, 100) == bits100)
state_values = getstate(self.gen)[2]
state_values = collect(state_values)
state_values[end] = parse(Float64, "nan")
state = (parse(Int, x) for x in state_values)
@test_throws
end

function test_referenceImplementation(self::@like(MersenneTwister_TestBasicOps))
expected = [0.4583980307371326, 0.8605781520197878, 0.9284833172678215, 0.3593268111978246, 0.08182349376244957, 0.1433222647016933, 0.08429782382352002, 0.5381486467183145, 0.0892150249119934, 0.7848619610537291]
seed(self.gen, ((61731 + (24903 << 32)) + (614 << 64)) + (42143 << 96))
actual = randomlist(self, 2000)[length(randomlist(self, 2000)) - 10 + 1:end]
for (a, e) in zip(actual, expected)
assertAlmostEqual(self, a, e, places = 14)
end
end

function test_strong_reference_implementation(self::@like(MersenneTwister_TestBasicOps))
expected = [4128882400830239, 7751398889519013, 8363034243334166, 3236528186029503, 737000512037440, 1290932195808883, 759287295919497, 4847212089661076, 803577505899006, 7069408070677702]
seed(self.gen, ((61731 + (24903 << 32)) + (614 << 64)) + (42143 << 96))
actual = randomlist(self, 2000)[length(randomlist(self, 2000)) - 10 + 1:end]
for (a, e) in zip(actual, expected)
@test (parse(Int, ldexp(a, 53)) == e)
end
end

function test_long_seed(self::@like(MersenneTwister_TestBasicOps))
seed = (1 << 10000*8) - 1
seed(self.gen, seed)
end

function test_53_bits_per_float(self::@like(MersenneTwister_TestBasicOps))
span = 2^53
cum = 0
for i in 0:99
cum |= parse(Int, random(self.gen)*span)
end
@test (cum == span - 1)
end

function test_bigrand(self::@like(MersenneTwister_TestBasicOps))
span = 2^500
cum = 0
for i in 0:99
r = randrange(self.gen, span)
@test 0 <= r < span
cum |= r
end
@test (cum == span - 1)
end

function test_bigrand_ranges(self::@like(MersenneTwister_TestBasicOps))
for i in [40, 80, 160, 200, 211, 250, 375, 512, 550]
start = randrange(self.gen, 2^(i - 2))
stop = randrange(self.gen, 2^i)
if stop <= start
continue;
end
@test start <= randrange(self.gen, start, stop) < stop
end
end

function test_rangelimits(self::@like(MersenneTwister_TestBasicOps))
for (start, stop) in [(-2, 0), (-(2^60) - 2, -(2^60)), (2^60, 2^60 + 2)]
@test (Set(start:stop - 1) == Set([randrange(self.gen, start, stop) for i in 0:99]))
end
end

function test_getrandbits(self::@like(MersenneTwister_TestBasicOps))
TestBasicOps()
seed(self.gen, 1234567)
@test (getrandbits(self.gen, 100) == 97904845777343510404718956115)
end

function test_randrange_uses_getrandbits(self::@like(MersenneTwister_TestBasicOps))
seed(self.gen, 1234567)
@test (randrange(self.gen, 2^99) == 97904845777343510404718956115)
end

function test_randbelow_logic(self::@like(MersenneTwister_TestBasicOps), _log = log, int = int)
for i in 1:999
n = 1 << i
numbits = i + 1
k = parse(Int, 1.00001 + _log(n, 2))
@test (k == numbits)
@test (n == 2^(k - 1))
n += n - 1
k = parse(Int, 1.00001 + _log(n, 2))
assertIn(self, k, [numbits, numbits + 1])
@test (2^k) > n > (2^(k - 2))
n -= n >> 15
k = parse(Int, 1.00001 + _log(n, 2))
@test (k == numbits)
@test (2^k) > n > (2^(k - 1))
end
end

function test_randbelow_without_getrandbits(self::@like(MersenneTwister_TestBasicOps))
maxsize = 1 << random.BPF
warnings.catch_warnings() do 
warnings.simplefilter("ignore", UserWarning)
_randbelow_without_getrandbits(self.gen, maxsize + 1, maxsize = maxsize)
end
_randbelow_without_getrandbits(self.gen, 5640, maxsize = maxsize)
x = _randbelow_without_getrandbits(self.gen, 0, maxsize = maxsize)
@test (x == 0)
n = 42
epsilon = 0.01
limit = (maxsize - (maxsize % n)) / maxsize
unittest.mock.object(random.Random, "random") do random_mock 
random_mock.side_effect = [limit + epsilon, limit - epsilon]
_randbelow_without_getrandbits(self.gen, n, maxsize = maxsize)
@test (random_mock.call_count == 2)
end
end

function test_randrange_bug_1590891(self::@like(MersenneTwister_TestBasicOps))
start = 1000000000000
stop = -100000000000000000000
step_ = -200
x = randrange(self.gen, start, stop, step_)
@test stop < x <= start
@test ((x + stop) % step_ == 0)
end

function test_choices_algorithms(self::@like(MersenneTwister_TestBasicOps))
choices = self.gen.choices
n = 104729
seed(self.gen, 8675309)
a = choices(self.gen, 0:n - 1, k = 10000)
seed(self.gen, 8675309)
b = choices(self.gen, 0:n - 1, repeat([1],n), k = 10000)
@test (a == b)
seed(self.gen, 8675309)
c = choices(self.gen, 0:n - 1, cum_weights = 1:n, k = 10000)
@test (a == c)
population = ["Red", "Black", "Green"]
weights = [18, 18, 2]
cum_weights = [18, 36, 38]
expanded_population = [[repeat(["Red"],18); repeat(["Black"],18)]; repeat(["Green"],2)]
seed(self.gen, 9035768)
a = choices(self.gen, expanded_population, k = 10000)
seed(self.gen, 9035768)
b = choices(self.gen, population, weights, k = 10000)
@test (a == b)
seed(self.gen, 9035768)
c = choices(self.gen, population, cum_weights = cum_weights, k = 10000)
@test (a == c)
end

function test_randbytes(self::@like(MersenneTwister_TestBasicOps))
TestBasicOps()
seed = 8675309
expected = b"3\xa8\xf9f\xf4\xa4\xd06\x19\x8f\x9f\x82\x02oe\xf0"
seed(self.gen, seed)
@test (randbytes(self.gen, 16) == expected)
seed(self.gen, seed)
@test (randbytes(self.gen, 0) == b"")
@test (randbytes(self.gen, 16) == expected)
seed(self.gen, seed)
@test (join(b"", [randbytes(self.gen, 4) for _ in 0:3]) == expected)
seed(self.gen, seed)
expected1 = expected[4:4:end]
@test (join(b"", (randbytes(self.gen, 1) for _ in 0:3)) == expected1)
seed(self.gen, seed)
expected2 = join(b"", (expected[i + 3:i + 4] for i in 0:4:length(expected) - 1))
@test (join(b"", (randbytes(self.gen, 2) for _ in 0:3)) == expected2)
seed(self.gen, seed)
expected3 = join(b"", (expected[i + 2:i + 4] for i in 0:4:length(expected) - 1))
@test (join(b"", (randbytes(self.gen, 3) for _ in 0:3)) == expected3)
end

function test_randbytes_getrandbits(self::@like(MersenneTwister_TestBasicOps))
seed = 2849427419
gen2 = random.Random()
seed(self.gen, seed)
seed(gen2, seed)
for n in 0:8
@test (randbytes(self.gen, n) == to_bytes(getrandbits(gen2, n*8), n, "little"))
end
end

function test_sample_counts_equivalence(self::@like(MersenneTwister_TestBasicOps))
sample = self.gen.sample
seed = self.gen.seed
colors = ["red", "green", "blue", "orange", "black", "amber"]
counts = [500, 200, 20, 10, 5, 1]
k = 700
seed(8675309)
s1 = sample(colors, counts = counts, k = k)
seed(8675309)
expanded = [color for (color, count) in zip(colors, counts) for i in 0:count - 1]
@test (length(expanded) == sum(counts))
s2 = sample(expanded, k = k)
@test (s1 == s2)
pop = "abcdefghi"
counts = [10, 9, 8, 7, 6, 5, 4, 3, 2]
seed(8675309)
s1 = join(sample(pop, counts = counts, k = 30), "")
expanded = join([letter for (letter, count) in zip(pop, counts) for i in 0:count - 1], "")
seed(8675309)
s2 = join(sample(expanded, k = 30), "")
@test (s1 == s2)
end


function gamma(z, sqrt2pi = __mul__(2.0, pi)^0.5)
if z < 0.5
return __div__(pi, sin(__mul__(pi, z))) / gamma(1.0 - z)
end
az = z + (7.0 - 0.5)
return (az^(z - 0.5) / exp(az))*sqrt2pi*xsum([0.9999999999995183, 676.5203681218835 / z, -1259.139216722289 / (z + 1.0), 771.3234287757674 / (z + 2.0), -176.6150291498386 / (z + 3.0), 12.50734324009056 / (z + 4.0), -0.1385710331296526 / (z + 5.0), 9.934937113930748e-06 / (z + 6.0), 1.659470187408462e-07 / (z + 7.0)])
end

@oodef mutable struct TestDistributions <: unittest.TestCase
                    
                    
                    
                end
                function test_zeroinputs(self::@like(TestDistributions))
g = random.Random()
x = [random(g) for i in 0:49] + repeat([0.0],5)
g.random = x[begin:end].pop
uniform(g, 1, 10)
g.random = x[begin:end].pop
paretovariate(g, 1.0)
g.random = x[begin:end].pop
expovariate(g, 1.0)
g.random = x[begin:end].pop
weibullvariate(g, 1.0, 1.0)
g.random = x[begin:end].pop
vonmisesvariate(g, 1.0, 1.0)
g.random = x[begin:end].pop
normalvariate(g, 0.0, 1.0)
g.random = x[begin:end].pop
gauss(g, 0.0, 1.0)
g.random = x[begin:end].pop
lognormvariate(g, 0.0, 1.0)
g.random = x[begin:end].pop
vonmisesvariate(g, 0.0, 1.0)
g.random = x[begin:end].pop
gammavariate(g, 0.01, 1.0)
g.random = x[begin:end].pop
gammavariate(g, 1.0, 1.0)
g.random = x[begin:end].pop
gammavariate(g, 200.0, 1.0)
g.random = x[begin:end].pop
betavariate(g, 3.0, 3.0)
g.random = x[begin:end].pop
triangular(g, 0.0, 1.0, 1.0 / 3.0)
end

function test_avg_std(self::@like(TestDistributions))
g = random.Random()
N = 5000
x = [i / float(N) for i in 1:N - 1]
for (variate, args, mu, sigmasqrd) in [(g.uniform, (1.0, 10.0), (10.0 + 1.0) / 2, (10.0 - 1.0)^2 / 12), (g.triangular, (0.0, 1.0, 1.0 / 3.0), 4.0 / 9.0, (7.0 / 9.0) / 18.0), (g.expovariate, (1.5,), 1 / 1.5, 1 / 1.5^2), (g.vonmisesvariate, (1.23, 0), pi, __pow__(pi, 2) / 3), (g.paretovariate, (5.0,), 5.0 / (5.0 - 1), 5.0 / (5.0 - 1)^2*(5.0 - 2)), (g.weibullvariate, (1.0, 3.0), gamma(1 + (1 / 3.0)), gamma(1 + (2 / 3.0)) - gamma(1 + (1 / 3.0))^2)]
g.random = x[begin:end].pop
y = []
for i in 0:length(x) - 1
try
push!(y, variate(args...))
catch exn
if exn isa IndexError
#= pass =#
end
end
end
s1=s2 = 0
for e in y
s1 += e
s2 += (e - mu)^2
end
N = length(y)
assertAlmostEqual(self, s1 / N, mu, places = 2, msg = "$(variate.__name__)$(args)")
assertAlmostEqual(self, s2 / (N - 1), sigmasqrd, places = 2, msg = "$(variate.__name__)$(args)")
end
end

function test_constant(self::@like(TestDistributions))
g = random.Random()
N = 100
for (variate, args, expected) in [(g.uniform, (10.0, 10.0), 10.0), (g.triangular, (10.0, 10.0), 10.0), (g.triangular, (10.0, 10.0, 10.0), 10.0), (g.expovariate, (parse(Float64, "inf"),), 0.0), (g.vonmisesvariate, (3.0, parse(Float64, "inf")), 3.0), (g.gauss, (10.0, 0.0), 10.0), (g.lognormvariate, (0.0, 0.0), 1.0), (g.lognormvariate, (-parse(Float64, "inf"), 0.0), 0.0), (g.normalvariate, (10.0, 0.0), 10.0), (g.paretovariate, (parse(Float64, "inf"),), 1.0), (g.weibullvariate, (10.0, parse(Float64, "inf")), 10.0), (g.weibullvariate, (0.0, 10.0), 0.0)]
for i in 0:N - 1
@test (variate(args...) == expected)
end
end
end

function test_von_mises_range(self::@like(TestDistributions))
g = random.Random()
N = 100
for mu in (0.0, 0.1, 3.1, 6.2)
for kappa in (0.0, 2.3, 500.0)
for _ in 0:N - 1
sample = vonmisesvariate(g, mu, kappa)
@test 0 <= sample <= random.TWOPI
end
end
end
end

function test_von_mises_large_kappa(self::@like(TestDistributions))
random.vonmisesvariate(0, 1000000000000000.0)
random.vonmisesvariate(0, 1e+100)
end

function test_gammavariate_errors(self::@like(TestDistributions))
@test_throws
@test_throws
@test_throws
@test_throws
end

function test_gammavariate_alpha_greater_one(self::@like(TestDistributions), random_mock)
random_mock.side_effect = [1e-08, 0.5, 0.3]
returned_value = random.gammavariate(1.1, 2.3)
assertAlmostEqual(self, returned_value, 2.53)
end

function test_gammavariate_alpha_equal_one(self::@like(TestDistributions), random_mock)
random_mock.side_effect = [0.45]
returned_value = random.gammavariate(1.0, 3.14)
assertAlmostEqual(self, returned_value, 1.877208182372648)
end

function test_gammavariate_alpha_equal_one_equals_expovariate(self::@like(TestDistributions), random_mock)
beta = 3.14
random_mock.side_effect = [1e-08, 1e-08]
gammavariate_returned_value = random.gammavariate(1.0, beta)
expovariate_returned_value = random.expovariate(1.0 / beta)
assertAlmostEqual(self, gammavariate_returned_value, expovariate_returned_value)
end

function test_gammavariate_alpha_between_zero_and_one(self::@like(TestDistributions), random_mock)
_e = random._e
_exp = random._exp
_log = random._log
alpha = 0.35
beta = 1.45
b = (_e + alpha) / _e
epsilon = 0.01
r1 = 0.8859296441566
r2 = 0.3678794411714
random_mock.side_effect = [r1, r2 + epsilon, r1, r2]
returned_value = random.gammavariate(alpha, beta)
assertAlmostEqual(self, returned_value, 1.4499999999997544)
r1 = 0.8959296441566
r2 = 0.9445400408898141
random_mock.side_effect = [r1, r2 + epsilon, r1, r2]
returned_value = random.gammavariate(alpha, beta)
assertAlmostEqual(self, returned_value, 1.5830349561760781)
end

function test_betavariate_return_zero(self::@like(TestDistributions), gammavariate_mock)
gammavariate_mock.return_value = 0.0
@test (0.0 == random.betavariate(2.71828, 3.14159))
end


@oodef mutable struct Subclass <: random.Random
                    
                    
                    
function new(newarg = nothing)
@mk begin
random()
end
end

                end
                

@oodef mutable struct SubClass1 <: random.Random
                    
                    
                    
                end
                function random(self::@like(SubClass1))
add(called, "SubClass1.random")
return rand()
end

function getrandbits(self::@like(SubClass1), n)
add(called, "SubClass1.getrandbits")
return getrandbits(n)
end


@oodef mutable struct SubClass2 <: random.Random
                    
                    
                    
                end
                function random(self::@like(SubClass2))
add(called, "SubClass2.random")
return rand()
end


@oodef mutable struct SubClass3 <: SubClass2
                    
                    
                    
                end
                function getrandbits(self::@like(SubClass3), n)
add(called, "SubClass3.getrandbits")
return random.getrandbits(n)
end


@oodef mutable struct SubClass4 <: SubClass3
                    
                    
                    
                end
                function random(self::@like(SubClass4))
add(called, "SubClass4.random")
return rand()
end


@oodef mutable struct Mixin1
                    
                    
                    
                end
                function random(self::@like(Mixin1))
add(called, "Mixin1.random")
return rand()
end


@oodef mutable struct Mixin2
                    
                    
                    
                end
                function getrandbits(self::@like(Mixin2), n)
add(called, "Mixin2.getrandbits")
return random.getrandbits(n)
end


@oodef mutable struct SubClass5 <: {Mixin1, random.Random}
                    
                    
                    
                end
                

@oodef mutable struct SubClass6 <: {Mixin2, random.Random}
                    
                    
                    
                end
                

@oodef mutable struct SubClass7 <: {Mixin1, Mixin2, random.Random}
                    
                    
                    
                end
                

@oodef mutable struct SubClass8 <: {Mixin2, Mixin1, random.Random}
                    
                    
                    
                end
                

@oodef mutable struct TestRandomSubclassing <: unittest.TestCase
                    
                    
                    
                end
                function test_random_subclass_with_kwargs(self::@like(TestRandomSubclassing))
Subclass(newarg = 1)
end

function test_subclasses_overriding_methods(self::@like(TestRandomSubclassing))
called = Set()
randrange(SubClass1(), 42)
@test (called == Set(["SubClass1.getrandbits"]))
called = Set()
randrange(SubClass2(), 42)
@test (called == Set(["SubClass2.random"]))
called = Set()
randrange(SubClass3(), 42)
@test (called == Set(["SubClass3.getrandbits"]))
called = Set()
randrange(SubClass4(), 42)
@test (called == Set(["SubClass4.random"]))
called = Set()
randrange(SubClass5(), 42)
@test (called == Set(["Mixin1.random"]))
called = Set()
randrange(SubClass6(), 42)
@test (called == Set(["Mixin2.getrandbits"]))
called = Set()
randrange(SubClass7(), 42)
@test (called == Set(["Mixin1.random"]))
called = Set()
randrange(SubClass8(), 42)
@test (called == Set(["Mixin2.getrandbits"]))
end


@oodef mutable struct TestModule <: unittest.TestCase
                    
                    
                    
                end
                function testMagicConstants(self::@like(TestModule))
assertAlmostEqual(self, random.NV_MAGICCONST, 1.71552776992141)
assertAlmostEqual(self, random.TWOPI, 6.28318530718)
assertAlmostEqual(self, random.LOG4, 1.38629436111989)
assertAlmostEqual(self, random.SG_MAGICCONST, 2.50407739677627)
end

function test__all__(self::@like(TestModule))
@test Set(random.__all__) <= Set(dir(random))
end

function test_after_fork(self::@like(TestModule))
(r, w) = os.pipe()
pid = os.fork()
if pid == 0
try
val = random.getrandbits(128)
readline(w) do f 
write(f, string(val))
end
finally
os._exit(0)
end
else
os.close(w)
val = random.getrandbits(128)
readline(r) do f 
child_val = py"read(f)"
end
@test (val != child_val)
support.wait_process(pid, exitcode = 0)
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
long_exp_text = LongExpText()
test_longexp(long_exp_text)
math_tests = MathTests()
testConstants(math_tests)
testAcos(math_tests)
testAcosh(math_tests)
testAsin(math_tests)
testAsinh(math_tests)
testAtan(math_tests)
testAtanh(math_tests)
testAtan2(math_tests)
testCeil(math_tests)
testCopysign(math_tests)
testCos(math_tests)
testCosh(math_tests)
testDegrees(math_tests)
testExp(math_tests)
testFabs(math_tests)
testFactorial(math_tests)
testFactorialNonIntegers(math_tests)
testFactorialHugeInputs(math_tests)
testFloor(math_tests)
testFmod(math_tests)
testFrexp(math_tests)
testFsum(math_tests)
testGcd(math_tests)
testHypot(math_tests)
testHypotAccuracy(math_tests)
testDist(math_tests)
testIsqrt(math_tests)
test_lcm(math_tests)
testLdexp(math_tests)
testLog(math_tests)
testLog1p(math_tests)
testLog2(math_tests)
testLog2Exact(math_tests)
testLog10(math_tests)
testModf(math_tests)
testPow(math_tests)
testRadians(math_tests)
testRemainder(math_tests)
testSin(math_tests)
testSinh(math_tests)
testSqrt(math_tests)
testTan(math_tests)
testTanh(math_tests)
testTanhSign(math_tests)
test_trunc(math_tests)
testIsfinite(math_tests)
testIsnan(math_tests)
testIsinf(math_tests)
test_nan_constant(math_tests)
test_inf_constant(math_tests)
test_exceptions(math_tests)
test_testfile(math_tests)
test_mtestfile(math_tests)
test_prod(math_tests)
testPerm(math_tests)
testComb(math_tests)
test_nextafter(math_tests)
test_ulp(math_tests)
test_issue39871(math_tests)
is_close_tests = IsCloseTests()
test_negative_tolerances(is_close_tests)
test_identical(is_close_tests)
test_eight_decimal_places(is_close_tests)
test_near_zero(is_close_tests)
test_identical_infinite(is_close_tests)
test_inf_ninf_nan(is_close_tests)
test_zero_tolerance(is_close_tests)
test_asymmetry(is_close_tests)
test_integers(is_close_tests)
test_decimals(is_close_tests)
test_fractions(is_close_tests)
hash_test = HashTest()
test_bools(hash_test)
test_integers(hash_test)
test_binary_floats(hash_test)
test_complex(hash_test)
test_decimals(hash_test)
test_fractions(hash_test)
test_hash_normalization(hash_test)
comparison_test = ComparisonTest()
test_mixed_comparisons(comparison_test)
test_complex(comparison_test)
py_operator_test_case = PyOperatorTestCase()
c_operator_test_case = COperatorTestCase()
py_py_operator_pickle_test_case = PyPyOperatorPickleTestCase()
py_c_operator_pickle_test_case = PyCOperatorPickleTestCase()
c_py_operator_pickle_test_case = CPyOperatorPickleTestCase()
c_c_operator_pickle_test_case = CCOperatorPickleTestCase()
pow_test = PowTest()
test_powint(pow_test)
test_powfloat(pow_test)
test_other(pow_test)
test_bug643260(pow_test)
test_bug705231(pow_test)
test_negative_exponent(pow_test)
test_print = TestPrint()
test_print(test_print)
test_print_flush(test_print)
test_py2_migration_hint = TestPy2MigrationHint()
test_normal_string(test_py2_migration_hint)
test_string_with_soft_space(test_py2_migration_hint)
test_string_with_excessive_whitespace(test_py2_migration_hint)
test_string_with_leading_whitespace(test_py2_migration_hint)
test_string_with_semicolon(test_py2_migration_hint)
test_string_in_loop_on_same_line(test_py2_migration_hint)
test_stream_redirection_hint_for_py2_migration(test_py2_migration_hint)
test_raise = TestRaise()
test_invalid_reraise(test_raise)
test_reraise(test_raise)
test_except_reraise(test_raise)
test_finally_reraise(test_raise)
test_nested_reraise(test_raise)
test_raise_from_None(test_raise)
test_with_reraise1(test_raise)
test_with_reraise2(test_raise)
test_yield_reraise(test_raise)
test_erroneous_exception(test_raise)
test_new_returns_invalid_instance(test_raise)
test_assert_with_tuple_arg(test_raise)
test_cause = TestCause()
testCauseSyntax(test_cause)
test_invalid_cause(test_cause)
test_class_cause(test_cause)
test_instance_cause(test_cause)
test_erroneous_cause(test_cause)
test_traceback = TestTraceback()
test_sets_traceback(test_traceback)
test_accepts_traceback(test_traceback)
test_traceback_type = TestTracebackType()
test_attrs(test_traceback_type)
test_constructor(test_traceback_type)
test_context = TestContext()
test_instance_context_instance_raise(test_context)
test_class_context_instance_raise(test_context)
test_class_context_class_raise(test_context)
test_c_exception_context(test_context)
test_c_exception_raise(test_context)
test_noraise_finally(test_context)
test_raise_finally(test_context)
test_context_manager(test_context)
test_cycle_broken(test_context)
test_reraise_cycle_broken(test_context)
test_not_last(test_context)
test_3118(test_context)
test_3611(test_context)
test_removed_functionality = TestRemovedFunctionality()
test_tuples(test_removed_functionality)
test_strings(test_removed_functionality)
system_random__test_basic_ops = SystemRandom_TestBasicOps()
test_autoseed(system_random__test_basic_ops)
test_saverestore(system_random__test_basic_ops)
test_seedargs(system_random__test_basic_ops)
test_gauss(system_random__test_basic_ops)
test_pickling(system_random__test_basic_ops)
test_53_bits_per_float(system_random__test_basic_ops)
test_bigrand(system_random__test_basic_ops)
test_bigrand_ranges(system_random__test_basic_ops)
test_rangelimits(system_random__test_basic_ops)
test_randrange_nonunit_step(system_random__test_basic_ops)
test_randrange_errors(system_random__test_basic_ops)
test_randrange_argument_handling(system_random__test_basic_ops)
test_randrange_step(system_random__test_basic_ops)
test_randbelow_logic(system_random__test_basic_ops)
mersenne_twister__test_basic_ops = MersenneTwister_TestBasicOps()
test_guaranteed_stable(mersenne_twister__test_basic_ops)
test_bug_27706(mersenne_twister__test_basic_ops)
test_bug_31478(mersenne_twister__test_basic_ops)
test_bug_31482(mersenne_twister__test_basic_ops)
test_setstate_first_arg(mersenne_twister__test_basic_ops)
test_setstate_middle_arg(mersenne_twister__test_basic_ops)
test_referenceImplementation(mersenne_twister__test_basic_ops)
test_strong_reference_implementation(mersenne_twister__test_basic_ops)
test_long_seed(mersenne_twister__test_basic_ops)
test_53_bits_per_float(mersenne_twister__test_basic_ops)
test_bigrand(mersenne_twister__test_basic_ops)
test_bigrand_ranges(mersenne_twister__test_basic_ops)
test_rangelimits(mersenne_twister__test_basic_ops)
test_getrandbits(mersenne_twister__test_basic_ops)
test_randrange_uses_getrandbits(mersenne_twister__test_basic_ops)
test_randbelow_logic(mersenne_twister__test_basic_ops)
test_randbelow_without_getrandbits(mersenne_twister__test_basic_ops)
test_randrange_bug_1590891(mersenne_twister__test_basic_ops)
test_choices_algorithms(mersenne_twister__test_basic_ops)
test_randbytes(mersenne_twister__test_basic_ops)
test_randbytes_getrandbits(mersenne_twister__test_basic_ops)
test_sample_counts_equivalence(mersenne_twister__test_basic_ops)
test_distributions = TestDistributions()
test_zeroinputs(test_distributions)
test_avg_std(test_distributions)
test_constant(test_distributions)
test_von_mises_range(test_distributions)
test_von_mises_large_kappa(test_distributions)
test_gammavariate_errors(test_distributions)
test_gammavariate_alpha_greater_one(test_distributions)
test_gammavariate_alpha_equal_one(test_distributions)
test_gammavariate_alpha_equal_one_equals_expovariate(test_distributions)
test_gammavariate_alpha_between_zero_and_one(test_distributions)
test_betavariate_return_zero(test_distributions)
test_random_subclassing = TestRandomSubclassing()
test_random_subclass_with_kwargs(test_random_subclassing)
test_subclasses_overriding_methods(test_random_subclassing)
test_module = TestModule()
testMagicConstants(test_module)
test__all__(test_module)
test_after_fork(test_module)
end