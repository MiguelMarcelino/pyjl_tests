using Test


abstract type AbstractTestPEP479 end
mutable struct TestPEP479 <: AbstractTestPEP479

end
function test_stopiteration_wrapping(self::TestPEP479)
Channel() do ch_test_stopiteration_wrapping 
function f()
throw(StopIteration)
end

function g()
Channel() do ch_g 
put!(ch_g, f())
end
end

assertRaisesRegex(self, RuntimeError, "generator raised StopIteration") do 
next(g())
end
end
end

function test_stopiteration_wrapping_context(self::TestPEP479)
Channel() do ch_test_stopiteration_wrapping_context 
function f()
throw(StopIteration)
end

function g()
Channel() do ch_g 
put!(ch_g, f())
end
end

try
next(g())
catch exn
 let exc = exn
if exc isa RuntimeError
assertIs(self, type_(exc.__cause__), StopIteration)
assertIs(self, type_(exc.__context__), StopIteration)
@test exc.__suppress_context__
end
end
end
end
end

if abspath(PROGRAM_FILE) == @__FILE__
test_p_e_p479 = TestPEP479()
test_stopiteration_wrapping(test_p_e_p479)
test_stopiteration_wrapping_context(test_p_e_p479)
end