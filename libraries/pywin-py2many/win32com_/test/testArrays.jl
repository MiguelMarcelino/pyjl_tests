using win32com_.client: gencache
using win32com_.test: util

abstract type AbstractArrayTest <: util.TestCase end
ZeroD = 0
OneDEmpty = []
OneD = [1, 2, 3]
TwoD = [[1, 2, 3], [1, 2, 3], [1, 2, 3]]
TwoD1 = [[[1, 2, 3, 5], [1, 2, 3], [1, 2, 3]], [[1, 2, 3], [1, 2, 3], [1, 2, 3]]]
OneD1 = [[[1, 2, 3], [1, 2, 3], [1, 2, 3]], [[1, 2, 3], [1, 2, 3]]]
OneD2 = [[1, 2, 3], [1, 2, 3, 4, 5], [[1, 2, 3, 4, 5], [1, 2, 3, 4, 5], [1, 2, 3, 4, 5]]]
ThreeD = [[[1, 2, 3], [1, 2, 3], [1, 2, 3]], [[1, 2, 3], [1, 2, 3], [1, 2, 3]]]
FourD = [
    [
        [[1, 2, 3], [1, 2, 3], [1, 2, 3]],
        [[1, 2, 3], [1, 2, 3], [1, 2, 3]],
        [[1, 2, 3], [1, 2, 3], [1, 2, 3]],
    ],
    [
        [[1, 2, 3], [1, 2, 3], [1, 2, 3]],
        [[1, 2, 3], [1, 2, 3], [1, 2, 3]],
        [[1, 2, 3], [1, 2, 3], [1, 2, 3]],
    ],
]
LargeD = repeat([[repeat([collect(0:9)], 10)]], 512)
function _normalize_array(a)::Vector
    if type_(a) != type_(())
        return a
    end
    ret = []
    for i in a
        push!(ret, _normalize_array(i))
    end
    return ret
end

mutable struct ArrayTest <: AbstractArrayTest
    arr
end
function setUp(self::AbstractArrayTest)
    self.arr = gencache.EnsureDispatch("PyCOMTest.ArrayTest")
end

function tearDown(self::AbstractArrayTest)
    self.arr = nothing
end

function _doTest(self::AbstractArrayTest, array)
    self.arr.Array = array
    assertEqual(self, _normalize_array(self.arr.Array), array)
end

function testZeroD(self::AbstractArrayTest)
    _doTest(self, ZeroD)
end

function testOneDEmpty(self::AbstractArrayTest)
    _doTest(self, OneDEmpty)
end

function testOneD(self::AbstractArrayTest)
    _doTest(self, OneD)
end

function testTwoD(self::AbstractArrayTest)
    _doTest(self, TwoD)
end

function testThreeD(self::AbstractArrayTest)
    _doTest(self, ThreeD)
end

function testFourD(self::AbstractArrayTest)
    _doTest(self, FourD)
end

function testTwoD1(self::AbstractArrayTest)
    _doTest(self, TwoD1)
end

function testOneD1(self::AbstractArrayTest)
    _doTest(self, OneD1)
end

function testOneD2(self::AbstractArrayTest)
    _doTest(self, OneD2)
end

function testLargeD(self::AbstractArrayTest)
    _doTest(self, LargeD)
end

if abspath(PROGRAM_FILE) == @__FILE__
    try
        util.testmain()
    catch exn
        let rc = exn
            if rc isa SystemExit
                if !(rc)
                    error()
                end
            end
        end
    end
end
