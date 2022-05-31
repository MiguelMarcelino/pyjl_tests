using Test
using win32com_.test.util: RegisterPythonServer
using win32com_.test: pippo_server



using ext_modules: pythoncom
using win32com_.client: Dispatch
using win32com_.client.gencache: EnsureDispatch
abstract type AbstractPippoTester end
mutable struct PippoTester <: AbstractPippoTester
object
end
function setUp(self::AbstractPippoTester)
RegisterPythonServer(pippo_server.__file__, "Python.Test.Pippo")
self.object = Dispatch("Python.Test.Pippo")
end

function testLeaks(self::AbstractPippoTester)
try
gtrc = sys.gettotalrefcount
catch exn
if exn isa AttributeError
println("Please run this with python_d for leak tests")
gtrc = () -> 0
end
end
Method1(self.object)
start = gtrc()
for i in 0:999
object = Dispatch("Python.Test.Pippo")
Method1(object)
end
object = nothing
end_ = gtrc()
if (end_ - start) > 5
fail(self, "$(end_ - start) references!")
end
end

function testResults(self::AbstractPippoTester)
rc, out1 = Method2(self.object, 123, 111)
@test (rc == 123)
@test (out1 == 222)
end

function testPythonArrays(self::AbstractPippoTester)
_testArray(self, [-3, -2, -1, 0, 1, 2, 3])
_testArray(self, [-3.14, -2, -0.1, 0.0, 1.1, 2.5, 3])
end

function testNumpyArrays(self::AbstractPippoTester)
try
catch exn
println("Numpy test not possible because numpy module failed to import")
return
end
_testArray(self, Vector{Float64}()([-3, -2, -1, 0, 1, 2, 3]))
_testArray(self, Vector{Float64}()([-3.14, -2, -0.1, 0.0, 1.1, 2.5, 3]))
end

function testByteArrays(self::AbstractPippoTester)
if "bytes" ∈ dir(__builtins__)
_testArray(self, eval("b\'abcdef\'"))
_testArray(self, eval("bytearray(b\'abcdef\')"))
end
end

function _testArray(self::AbstractPippoTester, inArray)
outArray = Method3(self.object, inArray)
@test (collect(outArray) == collect(inArray))
end

function testLeaksGencache(self::AbstractPippoTester)
try
gtrc = sys.gettotalrefcount
catch exn
if exn isa AttributeError
println("Please run this with python_d for leak tests")
gtrc = () -> 0
end
end
object = EnsureDispatch("Python.Test.Pippo")
start = gtrc()
for i in 0:999
object = EnsureDispatch("Python.Test.Pippo")
Method1(object)
end
object = nothing
end_ = gtrc()
if (end_ - start) > 10
fail(self, "$(end_ - start) references!")
end
end

if abspath(PROGRAM_FILE) == @__FILE__
pippo_tester = PippoTester()
setUp(pippo_tester)
testLeaks(pippo_tester)
testResults(pippo_tester)
testPythonArrays(pippo_tester)
testNumpyArrays(pippo_tester)
testByteArrays(pippo_tester)
_testArray(pippo_tester)
testLeaksGencache(pippo_tester)
end