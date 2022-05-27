using Test



abstract type AbstractUserStringTest <: string_tests.CommonTest end
abstract type Abstractustr2 <: UserString end
abstract type Abstractustr3 <: Abstractustr2 end
mutable struct UserStringTest <: string_tests.CommonTest
type2test

                    UserStringTest(type2test = UserString) =
                        new(type2test)
end
function checkequal(self::UserStringTest, result, object, methodname)
result = fixtype(self, result)
object = fixtype(self, object)
realresult = getfield(object, :methodname)(args..., kwargs)
@test (result == realresult)
end

function checkraises(self::UserStringTest, exc, obj, methodname)
obj = fixtype(self, obj)
assertRaises(self, exc) do cm 
getfield(obj, :methodname)(args...)
end
assertNotEqual(self, string(cm.exception), "")
end

function checkcall(self::UserStringTest, object, methodname)
object = fixtype(self, object)
getfield(object, :methodname)(args...)
end

function test_rmod(self::ustr3)
mutable struct ustr2 <: Abstractustr2

end

mutable struct ustr3 <: Abstractustr3

end
function __rmod__(self::ustr3, other)
return __rmod__(super(), other)
end

fmt2 = ustr2("value is %s")
str3 = ustr3("TEST")
assertEqual(self, __mod__(fmt2, str3), "value is TEST")
end

function test_encode_default_args(self::UserStringTest)
checkequal(self, b"hello", "hello", "encode")
checkequal(self, b"\xf0\xa3\x91\x96", "𣑖", "encode")
checkraises(self, UnicodeError, "\ud800", "encode")
end

function test_encode_explicit_none_args(self::UserStringTest)
checkequal(self, b"hello", "hello", "encode")
checkequal(self, b"\xf0\xa3\x91\x96", "𣑖", "encode")
checkraises(self, UnicodeError, "\ud800", "encode")
end

if abspath(PROGRAM_FILE) == @__FILE__
user_string_test = UserStringTest()
checkequal(user_string_test)
checkraises(user_string_test)
checkcall(user_string_test)
test_rmod(user_string_test)
test_encode_default_args(user_string_test)
test_encode_explicit_none_args(user_string_test)
end