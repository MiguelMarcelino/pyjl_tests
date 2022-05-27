using StringEncodings
using Test


abstract type AbstractPEP3120Test end
abstract type AbstractBuiltinCompileTests end
mutable struct PEP3120Test <: AbstractPEP3120Test

end
function test_pep3120(self::PEP3120Test)
@test (encode("Питон", "utf-8") == b"\xd0\x9f\xd0\xb8\xd1\x82\xd0\xbe\xd0\xbd")
@test (encode("\\П", "utf-8") == b"\\\xd0\x9f")
end

function test_badsyntax(self::PEP3120Test)
try
catch exn
 let msg = exn
if msg isa SyntaxError
msg = lower(string(msg))
@test "utf-8" ∈ msg
end
end
end
end

mutable struct BuiltinCompileTests <: AbstractBuiltinCompileTests

end
function test_latin1(self::BuiltinCompileTests)
source_code = encode("# coding: Latin-1\nu = \"Ç\"\n", "Latin-1")
try
code = compile(source_code, "<dummy>", "exec")
catch exn
if exn isa SyntaxError
fail(self, "compile() cannot handle Latin-1 source")
end
end
ns = Dict()
exec(code, ns)
@test ("Ç" == ns["u"])
end

if abspath(PROGRAM_FILE) == @__FILE__
p_e_p3120_test = PEP3120Test()
test_pep3120(p_e_p3120_test)
test_badsyntax(p_e_p3120_test)
builtin_compile_tests = BuiltinCompileTests()
test_latin1(builtin_compile_tests)
end