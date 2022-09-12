# Transpiled with flags: 
# - oop
#= Tests for binary operators on subtypes of built-in types. =#
using ObjectOriented
using Test


using abc: ABCMeta
function gcd(a, b)
#= Greatest common divisor using Euclid's algorithm. =#
while a
(a, b) = (b % a, a)
end
return b
end

function isint(x)
#= Test whether an object is an instance of int. =#
return isa(x, Int64)
end

function isnum(x)::Int64
#= Test whether an object is an instance of a built-in numeric type. =#
for T in (Int64, Float64, Complex)
if isa(x, T)
return 1
end
end
return 0
end

function isRat(x)
#= Test whether an object is an instance of the Rat class. =#
return isa(x, Rat)
end

@oodef mutable struct Rat <: object
                    #= Rational number implemented as a normalized pair of ints. =#

                    __num::Int64
__den::Int64
                    
function new(num = 0, den = 1, __num::Int64 = parse(Int, num ÷ g), __den::Int64 = parse(Int, den ÷ g), __slots__::Vector{String} = ["_Rat__num", "_Rat__den"], num = property(_get_num, nothing), den = property(_get_den, nothing), __radd__ = __add__, __rmul__ = __mul__)
if !isint(num)
throw(TypeError("Rat numerator must be int ($(num))"))
end
if !isint(den)
throw(TypeError("Rat denominator must be int ($(den))"))
end
if den == 0
throw(ZeroDivisionError("zero denominator"))
end
g = gcd(den, num)
@mk begin
__num = __num
__den = __den
end
end

                end
                function _get_num(self::@like(Rat))::Int64
#= Accessor function for read-only 'num' attribute of Rat. =#
return self.__num
end

function _get_den(self::@like(Rat))::Int64
#= Accessor function for read-only 'den' attribute of Rat. =#
return self.__den
end

function Base.show(self::@like(Rat))
                #= Convert a Rat to a string resembling a Rat constructor call. =#
return "Rat($(self.__num), $(self.__den))"
            end
function __str__(self::@like(Rat))::String
#= Convert a Rat to a string resembling a decimal numeric value. =#
return string(float(self))
end

function __float__(self::@like(Rat))
#= Convert a Rat to a float. =#
return self.__num*1.0 / self.__den
end

function __int__(self::@like(Rat))::Int64
#= Convert a Rat to an int; self.den must be 1. =#
if self.__den == 1
try
return Int(self.__num)
catch exn
if exn isa OverflowError
throw(OverflowError("$(repr(self)) too large to convert to int"))
end
end
end
throw(ValueError("can\'t convert $(repr(self)) to int"))
end

function __add__(self::@like(Rat), other)::Rat
#= Add two Rats, or a Rat and a number. =#
if isint(other)
other = Rat(other)
end
if isRat(other)
return Rat(self.__num*other.__den + other.__num*self.__den, self.__den*other.__den)
end
if isnum(other) != 0
return zero(Float64) + other
end
return NotImplemented
end

function __sub__(self::@like(Rat), other)::Rat
#= Subtract two Rats, or a Rat and a number. =#
if isint(other)
other = Rat(other)
end
if isRat(other)
return Rat(self.__num*other.__den - other.__num*self.__den, self.__den*other.__den)
end
if isnum(other) != 0
return zero(Float64) - other
end
return NotImplemented
end

function __rsub__(self::@like(Rat), other)::Rat
#= Subtract two Rats, or a Rat and a number (reversed args). =#
if isint(other)
other = Rat(other)
end
if isRat(other)
return Rat(other.__num*self.__den - self.__num*other.__den, self.__den*other.__den)
end
if isnum(other) != 0
return other - zero(Float64)
end
return NotImplemented
end

function __mul__(self::@like(Rat), other)::Rat
#= Multiply two Rats, or a Rat and a number. =#
if isRat(other)
return Rat(self.__num*other.__num, self.__den*other.__den)
end
if isint(other)
return Rat(self.__num*other, self.__den)
end
if isnum(other) != 0
return zero(Float64)*other
end
return NotImplemented
end

function __truediv__(self::@like(Rat), other)::Rat
#= Divide two Rats, or a Rat and a number. =#
if isRat(other)
return Rat(self.__num*other.__den, self.__den*other.__num)
end
if isint(other)
return Rat(self.__num, self.__den*other)
end
if isnum(other) != 0
return zero(Float64) / other
end
return NotImplemented
end

function __rtruediv__(self::@like(Rat), other)::Rat
#= Divide two Rats, or a Rat and a number (reversed args). =#
if isRat(other)
return Rat(other.__num*self.__den, other.__den*self.__num)
end
if isint(other)
return Rat(other*self.__den, self.__num)
end
if isnum(other) != 0
return other / zero(Float64)
end
return NotImplemented
end

function __floordiv__(self::@like(Rat), other)
#= Divide two Rats, returning the floored result. =#
if isint(other)
other = Rat(other)
elseif !isRat(other)
return NotImplemented
end
x = self / other
return x.__num ÷ x.__den
end

function __rfloordiv__(self::@like(Rat), other)
#= Divide two Rats, returning the floored result (reversed args). =#
x = other / self
return x.__num ÷ x.__den
end

function __divmod__(self::@like(Rat), other)::Tuple
#= Divide two Rats, returning quotient and remainder. =#
if isint(other)
other = Rat(other)
elseif !isRat(other)
return NotImplemented
end
x = self ÷ other
return (x, self - other*x)
end

function __rdivmod__(self::@like(Rat), other)
#= Divide two Rats, returning quotient and remainder (reversed args). =#
if isint(other)
other = Rat(other)
elseif !isRat(other)
return NotImplemented
end
return div(other)
end

function __mod__(self::@like(Rat), other)
#= Take one Rat modulo another. =#
return div(other)[2]
end

function __rmod__(self::@like(Rat), other)
#= Take one Rat modulo another (reversed args). =#
return div(other)[2]
end

function __eq__(self::@like(Rat), other)::Bool
#= Compare two Rats for equality. =#
if isint(other)
return self.__den == 1&&self.__num == other
end
if isRat(other)
return self.__num == other.__num&&self.__den == other.__den
end
if isnum(other) != 0
return zero(Float64) == other
end
return NotImplemented
end


@oodef mutable struct RatTestCase <: unittest.TestCase
                    #= Unit tests for Rat class and its support utilities. =#

                    
                    
                end
                function test_gcd(self::@like(RatTestCase))
@test (gcd(10, 12) == 2)
@test (gcd(10, 15) == 5)
@test (gcd(10, 11) == 1)
@test (gcd(100, 15) == 5)
@test (gcd(-10, 2) == -2)
@test (gcd(10, -2) == 2)
@test (gcd(-10, -2) == -2)
for i in 1:19
for j in 1:19
@test gcd(i, j) > 0
@test gcd(-i, j) < 0
@test gcd(i, -j) > 0
@test gcd(-i, -j) < 0
end
end
end

function test_constructor(self::@like(RatTestCase))
a = Rat(10, 15)
@test (a.num == 2)
@test (a.den == 3)
a = Rat(10, -15)
@test (a.num == -2)
@test (a.den == 3)
a = Rat(-10, 15)
@test (a.num == -2)
@test (a.den == 3)
a = Rat(-10, -15)
@test (a.num == 2)
@test (a.den == 3)
a = Rat(7)
@test (a.num == 7)
@test (a.den == 1)
try
a = Rat(1, 0)
catch exn
if exn isa ZeroDivisionError
#= pass =#
end
end
for bad in ("0", 0.0, 0im, (), [], Dict(), nothing, Rat, unittest)
try
a = Rat(bad)
catch exn
if exn isa TypeError
#= pass =#
end
end
try
a = Rat(1, bad)
catch exn
if exn isa TypeError
#= pass =#
end
end
end
end

function test_add(self::@like(RatTestCase))
@test (Rat(2, 3) + Rat(1, 3) == 1)
@test (Rat(2, 3) + 1 == Rat(5, 3))
@test (1 + Rat(2, 3) == Rat(5, 3))
@test (1.0 + Rat(1, 2) == 1.5)
@test (Rat(1, 2) + 1.0 == 1.5)
end

function test_sub(self::@like(RatTestCase))
@test (Rat(7, 2) - Rat(7, 5) == Rat(21, 10))
@test (Rat(7, 5) - 1 == Rat(2, 5))
@test (1 - Rat(3, 5) == Rat(2, 5))
@test (Rat(3, 2) - 1.0 == 0.5)
@test (1.0 - Rat(1, 2) == 0.5)
end

function test_mul(self::@like(RatTestCase))
@test (Rat(2, 3)*Rat(5, 7) == Rat(10, 21))
@test (Rat(10, 3)*3 == 10)
@test (3*Rat(10, 3) == 10)
@test (Rat(10, 5)*0.5 == 1.0)
@test (0.5*Rat(10, 5) == 1.0)
end

function test_div(self::@like(RatTestCase))
@test (Rat(10, 3) / Rat(5, 7) == Rat(14, 3))
@test (Rat(10, 3) / 3 == Rat(10, 9))
@test (2 / Rat(5) == Rat(2, 5))
@test (3.0*Rat(1, 2) == 1.5)
@test (Rat(1, 2)*3.0 == 1.5)
end

function test_floordiv(self::@like(RatTestCase))
@test (Rat(10) ÷ Rat(4) == 2)
@test (Rat(10, 3) ÷ Rat(4, 3) == 2)
@test (Rat(10) ÷ 4 == 2)
@test (10 ÷ Rat(4) == 2)
end

function test_eq(self::@like(RatTestCase))
@test (Rat(10) == Rat(20, 2))
@test (Rat(10) == 10)
@test (10 == Rat(10))
@test (Rat(10) == 10.0)
@test (10.0 == Rat(10))
end

function test_true_div(self::@like(RatTestCase))
@test (Rat(10, 3) / Rat(5, 7) == Rat(14, 3))
@test (Rat(10, 3) / 3 == Rat(10, 9))
@test (2 / Rat(5) == Rat(2, 5))
@test (3.0*Rat(1, 2) == 1.5)
@test (Rat(1, 2)*3.0 == 1.5)
@test (py""1/2"" == 0.5)
end


@oodef mutable struct OperationLogger
                    #= Base class for classes with operation logging. =#

                    logger
                    
function new(logger)
@mk begin
logger = logger
end
end

                end
                function log_operation(self::@like(OperationLogger), args...)
logger(self, args...)
end


function op_sequence(op, classes...)::Vector
#= Return the sequence of operations that results from applying
    the operation `op` to instances of the given classes. =#
log_ = []
instances_ = []
for c in classes
push!(instances_, c(log_.append))
end
try
op(instances_...)
catch exn
if exn isa TypeError
#= pass =#
end
end
return log_
end

@oodef mutable struct A <: OperationLogger
                    
                    logger
                    
function new(logger = logger)
logger = logger
new(logger)
end

                end
                function __eq__(self::@like(A), other)
log_operation(self, "A.__eq__")
return NotImplemented
end

function __le__(self::@like(A), other)
log_operation(self, "A.__le__")
return NotImplemented
end

function __ge__(self::@like(A), other)
log_operation(self, "A.__ge__")
return NotImplemented
end


@oodef mutable struct B <: OperationLogger
                    
                    logger
                    
function new(logger = logger)
logger = logger
new(logger)
end

                end
                function __eq__(self::@like(B), other)
log_operation(self, "B.__eq__")
return NotImplemented
end

function __le__(self::@like(B), other)
log_operation(self, "B.__le__")
return NotImplemented
end

function __ge__(self::@like(B), other)
log_operation(self, "B.__ge__")
return NotImplemented
end


@oodef mutable struct C <: B
                    
                    logger
                    
function new(logger = logger)
logger = logger
new(logger)
end

                end
                function __eq__(self::@like(C), other)
log_operation(self, "C.__eq__")
return NotImplemented
end

function __le__(self::@like(C), other)
log_operation(self, "C.__le__")
return NotImplemented
end

function __ge__(self::@like(C), other)
log_operation(self, "C.__ge__")
return NotImplemented
end


@oodef mutable struct V <: OperationLogger
                    #= Virtual subclass of B =#

                    logger
                    
function new(logger = logger)
logger = logger
new(logger)
end

                end
                function __eq__(self::@like(V), other)
log_operation(self, "V.__eq__")
return NotImplemented
end

function __le__(self::@like(V), other)
log_operation(self, "V.__le__")
return NotImplemented
end

function __ge__(self::@like(V), other)
log_operation(self, "V.__ge__")
return NotImplemented
end


B.register(V)
@oodef mutable struct OperationOrderTests <: unittest.TestCase
                    
                    
                    
                end
                function test_comparison_orders(self::@like(OperationOrderTests))
@test (op_sequence(eq) == ["A.__eq__", "A.__eq__"])
@test (op_sequence(eq) == ["A.__eq__", "B.__eq__"])
@test (op_sequence(eq) == ["B.__eq__", "A.__eq__"])
@test (op_sequence(eq) == ["C.__eq__", "B.__eq__"])
@test (op_sequence(eq) == ["C.__eq__", "B.__eq__"])
@test (op_sequence(le) == ["A.__le__", "A.__ge__"])
@test (op_sequence(le) == ["A.__le__", "B.__ge__"])
@test (op_sequence(le) == ["B.__le__", "A.__ge__"])
@test (op_sequence(le) == ["C.__ge__", "B.__le__"])
@test (op_sequence(le) == ["C.__le__", "B.__ge__"])
@test V <: B
@test (op_sequence(eq) == ["B.__eq__", "V.__eq__"])
@test (op_sequence(le) == ["B.__le__", "V.__ge__"])
end


@oodef mutable struct SupEq <: object
                    #= Class that can test equality =#

                    
                    
                end
                function __eq__(self::@like(SupEq), other)::Bool
return true
end


@oodef mutable struct S <: SupEq
                    #= Subclass of SupEq that should fail =#

                    __eq__
                    
function new(__eq__ = nothing)
__eq__ = __eq__
new(__eq__)
end

                end
                

@oodef mutable struct F <: object
                    #= Independent class that should fall back =#

                    
                    
                end
                

@oodef mutable struct X <: object
                    #= Independent class that should fail =#

                    __eq__
                    
function new(__eq__ = nothing)
__eq__ = __eq__
new(__eq__)
end

                end
                

@oodef mutable struct SN <: SupEq
                    #= Subclass of SupEq that can test equality, but not non-equality =#

                    __ne__
                    
function new(__ne__ = nothing)
__ne__ = __ne__
new(__ne__)
end

                end
                

@oodef mutable struct XN
                    #= Independent class that can test equality, but not non-equality =#

                    __ne__
                    
function new(__ne__ = nothing)
__ne__ = __ne__
new(__ne__)
end

                end
                function __eq__(self::@like(XN), other)::Bool
return true
end


@oodef mutable struct FallbackBlockingTests <: unittest.TestCase
                    #= Unit tests for None method blocking =#

                    
                    
                end
                function test_fallback_rmethod_blocking(self::@like(FallbackBlockingTests))
(e, f, s, x) = (SupEq(), F(), S(), X())
@test (e == e)
@test (e == f)
@test (f == e)
@test (e == x)
@test_throws
@test_throws
@test_throws
end

function test_fallback_ne_blocking(self::@like(FallbackBlockingTests))
(e, sn, xn) = (SupEq(), SN(), XN())
@test !(e != e)
@test_throws
@test_throws
@test !(e != xn)
@test_throws
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
end