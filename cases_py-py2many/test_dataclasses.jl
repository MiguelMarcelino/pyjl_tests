# Transpiled with flags: 
# - oop
using ObjectOriented
using Test






import abc

import inspect
import builtins


using unittest.mock: Mock



using functools: total_ordering


@oodef mutable struct CustomError <: Exception
                    
                    
                    
                end
                

mutable struct C

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                

mutable struct C

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                

mutable struct C
x::Int64
end

                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.x) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.x)
                end
                

mutable struct C
x::Int64
end

                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.x) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.x)
                end
                

mutable struct C
x::Int64
y::Int64
function new(x::Int64, y::Int64 = 0)
x = x
y = y
new(x, y)
end

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.x, self.y) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.x, self.y)
                end
                
mutable struct C
x::Int64
end
function __hash__(self::@like(C))::Int64
return 301
end


                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.x) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.x)
                end
                

mutable struct C
x::Int64
end
function __eq__(self::@like(C), other)::Bool
return false
end


                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.x) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.x)
                end
                

mutable struct C
x::Int64
end
function __eq__(self::@like(C))
#= pass =#
end


                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.x) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __hash__(self::AbstractC)
                    return __key(self)
                end
                

                function __key(self::AbstractC)
                    (self.x)
                end
                

mutable struct Base
x::AbstractAny
y::Int64
function new(x = 15.0, y::Int64 = 0)
x = x
y = y
new(x, y)
end

end

                function __repr__(self::AbstractBase)::String 
                    return AbstractBase(self.x, self.y) 
                end
            

                function __eq__(self::AbstractBase, other::AbstractBase)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractBase)
                    (__key(self.x), self.y)
                end
                
mutable struct C1 <: Base
x::Int64
y::Int64
z::Int64
function new(x::Int64 = 15, y::Int64 = 0, z::Int64 = 10)
x = x
y = y
z = z
new(x, y, z)
end

end

                function __repr__(self::AbstractC1)::String 
                    return AbstractC1(self.x, self.y, self.z) 
                end
            

                function __eq__(self::AbstractC1, other::AbstractC1)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC1)
                    (self.x, self.y, self.z)
                end
                
mutable struct C
self::String
end

                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.self) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.self)
                end
                

mutable struct C
selfx::String
end

                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.selfx) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.selfx)
                end
                

mutable struct C
object::String
end

                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.object) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.object)
                end
                

mutable struct C
object::String
end

                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.object) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.object)
                end
                

mutable struct C0

end

                function __repr__(self::AbstractC0)::String 
                    return AbstractC0() 
                end
            

                function __eq__(self::AbstractC0, other::AbstractC0)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC0)
                    ()
                end
                

mutable struct C1

end

                function __repr__(self::AbstractC1)::String 
                    return AbstractC1() 
                end
            

                function __eq__(self::AbstractC1, other::AbstractC1)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC1)
                    ()
                end
                

mutable struct C

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __lt__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) < __key(other)
                end

                function __le__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) <= __key(other)
                end

                function __gt__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) > __key(other)
                end

                function __ge__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) >= __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                

mutable struct C0
x::Int64
end

                function __repr__(self::AbstractC0)::String 
                    return AbstractC0(self.x) 
                end
            

                function __eq__(self::AbstractC0, other::AbstractC0)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC0)
                    (self.x)
                end
                

mutable struct C1
x::Int64
end

                function __repr__(self::AbstractC1)::String 
                    return AbstractC1(self.x) 
                end
            

                function __eq__(self::AbstractC1, other::AbstractC1)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC1)
                    (self.x)
                end
                

mutable struct C
x::Int64
end

                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.x) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __lt__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) < __key(other)
                end

                function __le__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) <= __key(other)
                end

                function __gt__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) > __key(other)
                end

                function __ge__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) >= __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.x)
                end
                

mutable struct C0
x::Int64
y::Int64
end

                function __repr__(self::AbstractC0)::String 
                    return AbstractC0(self.x, self.y) 
                end
            

                function __eq__(self::AbstractC0, other::AbstractC0)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC0)
                    (self.x, self.y)
                end
                

mutable struct C1
x::Int64
y::Int64
end

                function __repr__(self::AbstractC1)::String 
                    return AbstractC1(self.x, self.y) 
                end
            

                function __eq__(self::AbstractC1, other::AbstractC1)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC1)
                    (self.x, self.y)
                end
                

mutable struct C
x::Int64
y::Int64
end

                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.x, self.y) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __lt__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) < __key(other)
                end

                function __le__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) <= __key(other)
                end

                function __gt__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) > __key(other)
                end

                function __ge__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) >= __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.x, self.y)
                end
                

mutable struct B
i::Int64
end

                function __repr__(self::AbstractB)::String 
                    return AbstractB(self.i) 
                end
            

                function __eq__(self::AbstractB, other::AbstractB)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractB)
                    (self.i)
                end
                

mutable struct C <: B
i::Int64
end

                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.i) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.i)
                end
                

mutable struct C
x::Int64
function new(x::Int64 = field())
x = x
new(x)
end

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.x) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.x)
                end
                
mutable struct C
x::object
function new(x::object = field(default = default))
x = x
new(x)
end

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.x) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.x)
                end
                
mutable struct C
x::Int64
function new(x::Int64 = field(repr = false))
x = x
new(x)
end

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.x) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.x)
                end
                
mutable struct C
y::Int64
x::Int64
function new(y::Int64, x::Int64 = field(repr = false))
y = y
x = x
new(y, x)
end

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.y, self.x) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.y, self.x)
                end
                
mutable struct C
x::Int64
y::Int64
function new(x::Int64 = 0, y::Int64 = field(compare = false, default = 4))
x = x
y = y
new(x, y)
end

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.x, self.y) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.x, self.y)
                end
                
mutable struct C
x::Int64
function new(x::Int64 = field(init = false))
x = x
new(x)
end

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.x) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.x)
                end
                
mutable struct C
x::Int64
t::Int64
y::Int64
z::Int64
function new(x::Int64, t::Int64 = 10, y::Int64 = 0, z::Int64 = field(init = false))
x = x
t = t
y = y
z = z
new(x, t, y, z)
end

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.x, self.t, self.y, self.z) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.x, self.t, self.y, self.z)
                end
                
mutable struct C
x::Int64
y::String
z::String
function new(x::Int64, y::String = field(init = false, default = nothing), z::String = field(repr = false))
x = x
y = y
z = z
new(x, y, z)
end

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.x, self.y, self.z) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.x, self.y, self.z)
                end
                
mutable struct B
a::String
b::String
c::String
function new(a::String = "B:a", b::String = "B:b", c::String = "B:c")
a = a
b = b
c = c
new(a, b, c)
end

end

                function __repr__(self::AbstractB)::String 
                    return AbstractB(self.a, self.b, self.c) 
                end
            

                function __eq__(self::AbstractB, other::AbstractB)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractB)
                    (self.a, self.b, self.c)
                end
                
mutable struct C <: B
i::Int64
b::String
function new(i::Int64, b::String = "C:b")
i = i
b = b
new(i, b)
end

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.i, self.b) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.i, self.b)
                end
                
mutable struct D <: B
i::Int64
c::String
function new(i::Int64, c::String = "D:c")
i = i
c = c
new(i, c)
end

end

                function __repr__(self::AbstractD)::String 
                    return AbstractD(self.i, self.c) 
                end
            

                function __eq__(self::AbstractD, other::AbstractD)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractD)
                    (self.i, self.c)
                end
                
mutable struct E <: D
i::Int64
a::String
c::String
d::String
function new(i::Int64, a::String = "E:a", c::String = "D:c", d::String = "E:d")
i = i
a = a
c = c
d = d
new(i, a, c, d)
end

end

                function __repr__(self::AbstractE)::String 
                    return AbstractE(self.i, self.a, self.c, self.d) 
                end
            

                function __eq__(self::AbstractE, other::AbstractE)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractE)
                    (self.i, self.a, self.c, self.d)
                end
                
mutable struct C
x::Int64
t::Int64
y::Int64
z::object
function new(x::Int64, t::Int64 = field(default = 100), y::Int64 = field(repr = false), z::object = default)
x = x
t = t
y = y
z = z
new(x, t, y, z)
end

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.x, self.t, self.y, self.z) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.x, self.t, self.y, self.z)
                end
                
@oodef mutable struct Mutable
                    
                    l::Vector
                    
function new(l::Vector = [])
@mk begin
l = l
end
end

                end
                

mutable struct C
x::AbstractMutable
end

                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.x) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (__key(self.x))
                end
                

mutable struct C
x::Int64
end

                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.x) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.x)
                end
                

mutable struct Point
x::Int64
y::Int64
end

                function __repr__(self::AbstractPoint)::String 
                    return AbstractPoint(self.x, self.y) 
                end
            

                function __eq__(self::AbstractPoint, other::AbstractPoint)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractPoint)
                    (self.x, self.y)
                end
                

mutable struct C
x::Int64
y::Int64
end

                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.x, self.y) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.x, self.y)
                end
                

mutable struct Point3D
x::Int64
y::Int64
z::Int64
end

                function __repr__(self::AbstractPoint3D)::String 
                    return AbstractPoint3D(self.x, self.y, self.z) 
                end
            

                function __eq__(self::AbstractPoint3D, other::AbstractPoint3D)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractPoint3D)
                    (self.x, self.y, self.z)
                end
                

mutable struct Date
year::Int64
month::Int64
day::Int64
end

                function __repr__(self::AbstractDate)::String 
                    return AbstractDate(self.year, self.month, self.day) 
                end
            

                function __eq__(self::AbstractDate, other::AbstractDate)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractDate)
                    (self.year, self.month, self.day)
                end
                

mutable struct Point3Dv1
x::Int64
y::Int64
z::Int64
function new(x::Int64 = 0, y::Int64 = 0, z::Int64 = 0)
x = x
y = y
z = z
new(x, y, z)
end

end

                function __repr__(self::AbstractPoint3Dv1)::String 
                    return AbstractPoint3Dv1(self.x, self.y, self.z) 
                end
            

                function __eq__(self::AbstractPoint3Dv1, other::AbstractPoint3Dv1)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractPoint3Dv1)
                    (self.x, self.y, self.z)
                end
                
@oodef mutable struct F
                    
                    
                    
                end
                

mutable struct C
i::Int64
j::String
k::AbstractF
l::Float64
z::Complex
function new(i::Int64, j::String, k::F = f, l::Float64 = field(default = nothing), z::Complex = field(default = 3 + 4im, init = false))
i = i
j = j
k = k
l = l
z = z
new(i, j, k, l, z)
end

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.i, self.j, self.k, self.l, self.z) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.i, self.j, __key(self.k), self.l, self.z)
                end
                
mutable struct C
i::Int64
j::String
k::AbstractF
l::Float64
z::Complex
function new(i::Int64, j::String, k::F = f, l::Float64 = field(default = nothing), z::Complex = field(default = 3 + 4im, init = false))
i = i
j = j
k = k
l = l
z = z
new(i, j, k, l, z)
end

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.i, self.j, self.k, self.l, self.z) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __hash__(self::AbstractC)
                    return __key(self)
                end
                

                function __key(self::AbstractC)
                    (self.i, self.j, __key(self.k), self.l, self.z)
                end
                
mutable struct C
x::Int64
function new(x::Int64 = field(default = MISSING))
x = x
new(x)
end

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.x) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.x)
                end
                
mutable struct D
x::Int64
end

                function __repr__(self::AbstractD)::String 
                    return AbstractD(self.x) 
                end
            

                function __eq__(self::AbstractD, other::AbstractD)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractD)
                    (self.x)
                end
                

mutable struct C
x::Int64
function new(x::Int64 = field(default_factory = MISSING))
x = x
new(x)
end

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.x) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.x)
                end
                
mutable struct D
x::Int64
function new(x::Int64 = field(default = MISSING, default_factory = MISSING))
x = x
new(x)
end

end

                function __repr__(self::AbstractD)::String 
                    return AbstractD(self.x) 
                end
            

                function __eq__(self::AbstractD, other::AbstractD)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractD)
                    (self.x)
                end
                
mutable struct C
i::Int64
end
function foo(self::@like(C))::Int64
return 4
end

function bar(self::@like(C))::Int64
return 5
end


                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.i) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.i)
                end
                

mutable struct C

end
function __post_init__(self::@like(C))
throw(CustomError())
end


                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                

mutable struct C
i::Int64
function new(i::Int64 = 10)
i = i
new(i)
end

end
function __post_init__(self::@like(C))
if self.i == 10
throw(CustomError())
end
end


                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.i) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.i)
                end
                
mutable struct C

end
function __post_init__(self::@like(C))
throw(CustomError())
end


                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                

mutable struct C
x::Int64
function new(x::Int64 = 0)
x = x
new(x)
end

end
function __post_init__(self::@like(C))
self.x *= 2
end


                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.x) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.x)
                end
                
mutable struct C
x::Int64
function new(x::Int64 = 0)
x = x
new(x)
end

end
function __post_init__(self::@like(C))
self.x *= 2
end


                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.x) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.x)
                end
                
@oodef mutable struct B
                    
                    
                    
                end
                function __post_init__(self::@like(B))
throw(CustomError())
end


mutable struct C <: B
i::Int64
end
function __post_init__(self::@like(C))
self.x = 5
end


                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.i) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.i)
                end
                

mutable struct C <: B
i::Int64
end
function __post_init__(self::@like(C))
B()
end


                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.i) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.i)
                end
                

mutable struct C <: B
i::Int64
end

                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.i) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.i)
                end
                

mutable struct C
x::Int64
y::Int64
end
function __post_init__()
# Not Supported
# nonlocal flag
flag = true
end


                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.x, self.y) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.x, self.y)
                end
                

mutable struct C
x::Int64
y::Int64
end
function __post_init__(cls)
cls.flag = true
end


                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.x, self.y) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.x, self.y)
                end
                

mutable struct C
x::Int64
s::AbstractClassVar
t::ClassVar{Int64}
w::ClassVar{Int64}
y::Int64
z::ClassVar{Int64}
function new(x::Int64, s::ClassVar = 4000, t::ClassVar{Int64} = 3000, w::ClassVar{Int64} = 2000, y::Int64 = 10, z::ClassVar{Int64} = 1000)
x = x
s = s
t = t
w = w
y = y
z = z
new(x, s, t, w, y, z)
end

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.x, self.s, self.t, self.w, self.y, self.z) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.x, __key(self.s), self.t, self.w, self.y, self.z)
                end
                
mutable struct C
x::ClassVar{Int64}
end

                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.x) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.x)
                end
                

mutable struct C
x::ClassVar{Int64}
function new(x::ClassVar{Int64} = 10)
x = x
new(x)
end

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.x) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.x)
                end
                
mutable struct C
x::ClassVar{Int64}
function new(x::ClassVar{Int64} = field(default = 10))
x = x
new(x)
end

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.x) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.x)
                end
                
mutable struct C
x::Int64
t::ClassVar{Int64}
w::ClassVar{Int64}
y::Int64
z::ClassVar{Int64}
function new(x::Int64, t::ClassVar{Int64} = 3000, w::ClassVar{Int64} = 2000, y::Int64 = 10, z::ClassVar{Int64} = 1000)
x = x
t = t
w = w
y = y
z = z
new(x, t, w, y, z)
end

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.x, self.t, self.w, self.y, self.z) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.x, self.t, self.w, self.y, self.z)
                end
                
mutable struct C
x::InitVar{Int64}
end

                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.x) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.x)
                end
                

mutable struct C
x::InitVar{Int64}
function new(x::InitVar{Int64} = 10)
x = x
new(x)
end

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.x) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.x)
                end
                
mutable struct C
x::InitVar{Int64}
function new(x::InitVar{Int64} = field(default = 10))
x = x
new(x)
end

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.x) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.x)
                end
                
mutable struct C
init_param::InitVar{Int64}
x::Int64
function new(init_param::InitVar{Int64} = nothing, x::Int64 = nothing)
init_param = init_param
x = x
new(init_param, x)
end

end
function __post_init__(self::@like(C), init_param)
if self.x === nothing
self.x = init_param*2
end
end


                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.init_param, self.x) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.init_param, self.x)
                end
                
mutable struct Base
x::Int64
init_base::InitVar{Int64}
end

                function __repr__(self::AbstractBase)::String 
                    return AbstractBase(self.x, self.init_base) 
                end
            

                function __eq__(self::AbstractBase, other::AbstractBase)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractBase)
                    (self.x, self.init_base)
                end
                

mutable struct C <: Base
init_derived::InitVar{Int64}
y::Int64
x::AbstractAny
function new(init_derived::InitVar{Int64}, y::Int64, x = 15.0)
init_derived = init_derived
y = y
x = x
new(init_derived, y, x)
end

end
function __post_init__(self::@like(C), init_base, init_derived)
self.x = self.x + init_base
self.y = self.y + init_derived
end


                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.init_derived, self.y, self.x) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.init_derived, self.y, __key(self.x))
                end
                
mutable struct C
x::Int64
y::Vector
function new(x::Int64, y::Vector = field(default_factory = Vector))
x = x
y = y
new(x, y)
end

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.x, self.y) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.x, self.y)
                end
                
mutable struct C
x::Int64
y::Vector
function new(x::Int64, y::Vector = field(default_factory = () -> l))
x = x
y = y
new(x, y)
end

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.x, self.y) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.x, self.y)
                end
                
mutable struct C
x::Vector
function new(x::Vector = field(default_factory = Vector, repr = false))
x = x
new(x)
end

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.x) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.x)
                end
                
mutable struct C
x::Vector
function new(x::Vector = field(default_factory = Vector, hash = false))
x = x
new(x)
end

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.x) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __hash__(self::AbstractC)
                    return __key(self)
                end
                

                function __key(self::AbstractC)
                    (self.x)
                end
                
mutable struct C
x::Vector
function new(x::Vector = field(default_factory = Vector, init = false))
x = x
new(x)
end

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.x) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.x)
                end
                
mutable struct C
x::Vector
function new(x::Vector = field(default_factory = Vector, compare = false))
x = x
new(x)
end

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.x) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.x)
                end
                
mutable struct C
x::Vector
function new(x::Vector = field(default_factory = factory, init = false))
x = x
new(x)
end

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.x) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.x)
                end
                
mutable struct C
x::Int64
function new(x::Int64 = field(default_factory = factory))
x = x
new(x)
end

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.x) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.x)
                end
                
mutable struct Foo
x::dict
function new(x::dict = field(default_factory = dict))
x = x
new(x)
end

end

                function __repr__(self::AbstractFoo)::String 
                    return AbstractFoo(self.x) 
                end
            

                function __eq__(self::AbstractFoo, other::AbstractFoo)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractFoo)
                    (self.x)
                end
                
mutable struct Bar <: Foo
x::dict
y::Int64
function new(x::dict = field(default_factory = dict), y::Int64 = 1)
x = x
y = y
new(x, y)
end

end

                function __repr__(self::AbstractBar)::String 
                    return AbstractBar(self.x, self.y) 
                end
            

                function __eq__(self::AbstractBar, other::AbstractBar)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractBar)
                    (self.x, self.y)
                end
                
mutable struct Baz <: Foo
x::dict
function new(x::dict = field(default_factory = dict))
x = x
new(x)
end

end

                function __repr__(self::AbstractBaz)::String 
                    return AbstractBaz(self.x) 
                end
            

                function __eq__(self::AbstractBaz, other::AbstractBaz)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractBaz)
                    (self.x)
                end
                
mutable struct A
x::Int64
end

                function __repr__(self::AbstractA)::String 
                    return AbstractA(self.x) 
                end
            

                function __eq__(self::AbstractA, other::AbstractA)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractA)
                    (self.x)
                end
                

@oodef mutable struct B <: A
                    
                    y::Int64
x::Int64
                    
                end
                

mutable struct C <: B
z::Int64
i::Int64
end

                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.z, self.i) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.z, self.i)
                end
                

@oodef mutable struct D <: C
                    
                    t::Int64
                    
                end
                

@oodef mutable struct NotDataClass
                    
                    
                    
                end
                

mutable struct C
x::Int64
end

                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.x) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.x)
                end
                

mutable struct D
d::AbstractC
e::Int64
end

                function __repr__(self::AbstractD)::String 
                    return AbstractD(self.d, self.e) 
                end
            

                function __eq__(self::AbstractD, other::AbstractD)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractD)
                    (__key(self.d), self.e)
                end
                

@oodef mutable struct A
                    
                    
                    
                end
                function Base.getproperty(self::@like(A), key::Symbol)
                if hasproperty(self, Symbol(key))
                    return Base.getfield(self, Symbol(key))
                end
                return 0
            end

@oodef mutable struct B
                    
                    
                    
                end
                

mutable struct A <: types.GenericAlias
origin::type
args::type
end

                function __repr__(self::AbstractA)::String 
                    return AbstractA(self.origin, self.args) 
                end
            

                function __eq__(self::AbstractA, other::AbstractA)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractA)
                    (self.origin, self.args)
                end
                

mutable struct C
x::Int64
y::Float64
end

                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.x, self.y) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.x, self.y)
                end
                

@oodef mutable struct C
                    
                    
                    
                end
                

mutable struct C
x::Int64
y::Int64
end

                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.x, self.y) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.x, self.y)
                end
                

mutable struct C
x::Int64
y::Int64
end

                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.x, self.y) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.x, self.y)
                end
                

mutable struct C
x::Int64
y::Vector{Int64}
function new(x::Int64, y::Vector{Int64} = field(default_factory = Vector))
x = x
y = y
new(x, y)
end

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.x, self.y) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.x, self.y)
                end
                
mutable struct UserId
token::Int64
group::Int64
end

                function __repr__(self::AbstractUserId)::String 
                    return AbstractUserId(self.token, self.group) 
                end
            

                function __eq__(self::AbstractUserId, other::AbstractUserId)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractUserId)
                    (self.token, self.group)
                end
                

mutable struct User
name::String
id::AbstractUserId
end

                function __repr__(self::AbstractUser)::String 
                    return AbstractUser(self.name, self.id) 
                end
            

                function __eq__(self::AbstractUser, other::AbstractUser)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractUser)
                    (self.name, __key(self.id))
                end
                

mutable struct User
name::String
id::Int64
end

                function __repr__(self::AbstractUser)::String 
                    return AbstractUser(self.name, self.id) 
                end
            

                function __eq__(self::AbstractUser, other::AbstractUser)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractUser)
                    (self.name, self.id)
                end
                

mutable struct GroupList
id::Int64
users::Vector{User}
end

                function __repr__(self::AbstractGroupList)::String 
                    return AbstractGroupList(self.id, self.users) 
                end
            

                function __eq__(self::AbstractGroupList, other::AbstractGroupList)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractGroupList)
                    (self.id, self.users)
                end
                

mutable struct GroupTuple
id::Int64
users::Tuple{User, Any}
end

                function __repr__(self::AbstractGroupTuple)::String 
                    return AbstractGroupTuple(self.id, self.users) 
                end
            

                function __eq__(self::AbstractGroupTuple, other::AbstractGroupTuple)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractGroupTuple)
                    (self.id, self.users)
                end
                

mutable struct GroupDict
id::Int64
users::Dict{String, User}
end

                function __repr__(self::AbstractGroupDict)::String 
                    return AbstractGroupDict(self.id, self.users) 
                end
            

                function __eq__(self::AbstractGroupDict, other::AbstractGroupDict)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractGroupDict)
                    (self.id, self.users)
                end
                

mutable struct Child
d::object
end

                function __repr__(self::AbstractChild)::String 
                    return AbstractChild(self.d) 
                end
            

                function __eq__(self::AbstractChild, other::AbstractChild)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractChild)
                    (self.d)
                end
                

mutable struct Parent
child::AbstractChild
end

                function __repr__(self::AbstractParent)::String 
                    return AbstractParent(self.child) 
                end
            

                function __eq__(self::AbstractParent, other::AbstractParent)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractParent)
                    (__key(self.child))
                end
                

mutable struct C
x::Int64
y::Int64
end

                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.x, self.y) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.x, self.y)
                end
                

mutable struct C
x::String
y::AbstractT
end

                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.x, self.y) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.x, __key(self.y))
                end
                

mutable struct C
f::dict
end

                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.f) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.f)
                end
                

@oodef mutable struct T <: namedtuple("Tbase", "a")
                    
                    
                    
                end
                function my_a(self::@like(T))
return self.a
end


mutable struct C
f::AbstractT
end

                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.f) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (__key(self.f))
                end
                

mutable struct C
x::Int64
y::Int64
function new(x::Int64, y::Int64 = 0)
x = x
y = y
new(x, y)
end

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.x, self.y) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.x, self.y)
                end
                
mutable struct C
x::Int64
y::Int64
end

                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.x, self.y) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.x, self.y)
                end
                

mutable struct C
x::Int64
y::Vector{Int64}
function new(x::Int64, y::Vector{Int64} = field(default_factory = Vector))
x = x
y = y
new(x, y)
end

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.x, self.y) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.x, self.y)
                end
                
mutable struct UserId
token::Int64
group::Int64
end

                function __repr__(self::AbstractUserId)::String 
                    return AbstractUserId(self.token, self.group) 
                end
            

                function __eq__(self::AbstractUserId, other::AbstractUserId)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractUserId)
                    (self.token, self.group)
                end
                

mutable struct User
name::String
id::AbstractUserId
end

                function __repr__(self::AbstractUser)::String 
                    return AbstractUser(self.name, self.id) 
                end
            

                function __eq__(self::AbstractUser, other::AbstractUser)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractUser)
                    (self.name, __key(self.id))
                end
                

mutable struct User
name::String
id::Int64
end

                function __repr__(self::AbstractUser)::String 
                    return AbstractUser(self.name, self.id) 
                end
            

                function __eq__(self::AbstractUser, other::AbstractUser)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractUser)
                    (self.name, self.id)
                end
                

mutable struct GroupList
id::Int64
users::Vector{User}
end

                function __repr__(self::AbstractGroupList)::String 
                    return AbstractGroupList(self.id, self.users) 
                end
            

                function __eq__(self::AbstractGroupList, other::AbstractGroupList)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractGroupList)
                    (self.id, self.users)
                end
                

mutable struct GroupTuple
id::Int64
users::Tuple{User, Any}
end

                function __repr__(self::AbstractGroupTuple)::String 
                    return AbstractGroupTuple(self.id, self.users) 
                end
            

                function __eq__(self::AbstractGroupTuple, other::AbstractGroupTuple)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractGroupTuple)
                    (self.id, self.users)
                end
                

mutable struct GroupDict
id::Int64
users::Dict{String, User}
end

                function __repr__(self::AbstractGroupDict)::String 
                    return AbstractGroupDict(self.id, self.users) 
                end
            

                function __eq__(self::AbstractGroupDict, other::AbstractGroupDict)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractGroupDict)
                    (self.id, self.users)
                end
                

mutable struct Child
d::object
end

                function __repr__(self::AbstractChild)::String 
                    return AbstractChild(self.d) 
                end
            

                function __eq__(self::AbstractChild, other::AbstractChild)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractChild)
                    (self.d)
                end
                

mutable struct Parent
child::AbstractChild
end

                function __repr__(self::AbstractParent)::String 
                    return AbstractParent(self.child) 
                end
            

                function __eq__(self::AbstractParent, other::AbstractParent)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractParent)
                    (__key(self.child))
                end
                

mutable struct C
x::Int64
y::Int64
end

                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.x, self.y) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.x, self.y)
                end
                

mutable struct C
x::String
y::AbstractT
end

                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.x, self.y) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.x, __key(self.y))
                end
                

mutable struct C
a::Int64
b::Int64
c::Vector
d::Vector
e::Int64
f::Int64
function new(a::Int64, b::Int64 = field(), c::Vector = field(default_factory = Vector, init = false), d::Vector = field(default_factory = Vector), e::Int64 = field(default = 4, init = false), f::Int64 = 4)
a = a
b = b
c = c
d = d
e = e
f = f
new(a, b, c, d, e, f)
end

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.a, self.b, self.c, self.d, self.e, self.f) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.a, self.b, self.c, self.d, self.e, self.f)
                end
                
mutable struct C
a::Int64
b::Vector
c::Vector
d::Int64
e::Int64
function new(a::Int64, b::Vector = field(default_factory = Vector, init = false), c::Vector = field(default_factory = Vector), d::Int64 = field(default = 4, init = false), e::Int64 = 0)
a = a
b = b
c = c
d = d
e = e
new(a, b, c, d, e)
end

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.a, self.b, self.c, self.d, self.e) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.a, self.b, self.c, self.d, self.e)
                end
                
mutable struct C
x::Int64
end
function from_file(cls, filename)
value_in_file = 20
return cls(value_in_file)
end


                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.x) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.x)
                end
                

mutable struct C
i::Int64
end

                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.i) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.i)
                end
                

mutable struct C
i::Int64
function new(i::Int64 = field(metadata = d))
i = i
new(i)
end

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.i) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.i)
                end
                
mutable struct C
i::Int64
function new(i::Int64 = field(metadata = d))
i = i
new(i)
end

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.i) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.i)
                end
                
@oodef mutable struct SimpleNameSpace
                    
                    
                    
function new()
update(self.__dict__, kw)
@mk begin

end
end

                end
                function __getitem__(self::@like(SimpleNameSpace), item)::String
if item == "xyzzy"
return "plugh"
end
return getfield
end

function __len__(self::@like(SimpleNameSpace))
return __len__(self.__dict__)
end


mutable struct C
i::Int64
function new(i::Int64 = field(metadata = SimpleNameSpace(a = 10)))
i = i
new(i)
end

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.i) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.i)
                end
                
mutable struct LabeledBox <: Generic[__add__(T, 1)]
content::AbstractT
label::String
function new(content::T, label::String = "<unknown>")
content = content
label = label
new(content, label)
end

end

                function __repr__(self::AbstractLabeledBox)::String 
                    return AbstractLabeledBox(self.content, self.label) 
                end
            

                function __eq__(self::AbstractLabeledBox, other::AbstractLabeledBox)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractLabeledBox)
                    (__key(self.content), self.label)
                end
                
mutable struct Base <: Generic[(T, S) + 1]
x::AbstractT
y::AbstractS
end

                function __repr__(self::AbstractBase)::String 
                    return AbstractBase(self.x, self.y) 
                end
            

                function __eq__(self::AbstractBase, other::AbstractBase)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractBase)
                    (__key(self.x), __key(self.y))
                end
                

mutable struct DataDerived <: Base[(Int64, T) + 1]
new_field::String
end

                function __repr__(self::AbstractDataDerived)::String 
                    return AbstractDataDerived(self.new_field) 
                end
            

                function __eq__(self::AbstractDataDerived, other::AbstractDataDerived)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractDataDerived)
                    (self.new_field)
                end
                

@oodef mutable struct NonDataDerived <: Base[(Int64, T) + 1]
                    
                    
                    
                end
                function new_method(self::@like(NonDataDerived))
return self.y
end


mutable struct Parent <: Generic[__add__(T, 1)]
x::AbstractT
end

                function __repr__(self::AbstractParent)::String 
                    return AbstractParent(self.x) 
                end
            

                function __eq__(self::AbstractParent, other::AbstractParent)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractParent)
                    (__key(self.x))
                end
                

mutable struct P
x::Int64
y::Int64
function new(x::Int64, y::Int64 = 0)
x = x
y = y
new(x, y)
end

end

                function __repr__(self::AbstractP)::String 
                    return AbstractP(self.x, self.y) 
                end
            

                function __eq__(self::AbstractP, other::AbstractP)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractP)
                    (self.x, self.y)
                end
                
mutable struct Q
x::Int64
y::Int64
function new(x::Int64, y::Int64 = field(default = 0, init = false))
x = x
y = y
new(x, y)
end

end

                function __repr__(self::AbstractQ)::String 
                    return AbstractQ(self.x, self.y) 
                end
            

                function __eq__(self::AbstractQ, other::AbstractQ)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractQ)
                    (self.x, self.y)
                end
                
mutable struct R
x::Int64
y::Vector{Int64}
function new(x::Int64, y::Vector{Int64} = field(default_factory = Vector))
x = x
y = y
new(x, y)
end

end

                function __repr__(self::AbstractR)::String 
                    return AbstractR(self.x, self.y) 
                end
            

                function __eq__(self::AbstractR, other::AbstractR)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractR)
                    (self.x, self.y)
                end
                
mutable struct A
x::Int64
y::Int64
end

                function __repr__(self::AbstractA)::String 
                    return AbstractA(self.x, self.y) 
                end
            

                function __eq__(self::AbstractA, other::AbstractA)::Bool
                    return __key(self) == __key(other)
                end
            

                function __lt__(self::AbstractA, other::AbstractA)::Bool
                    return __key(self) < __key(other)
                end

                function __le__(self::AbstractA, other::AbstractA)::Bool
                    return __key(self) <= __key(other)
                end

                function __gt__(self::AbstractA, other::AbstractA)::Bool
                    return __key(self) > __key(other)
                end

                function __ge__(self::AbstractA, other::AbstractA)::Bool
                    return __key(self) >= __key(other)
                end
            

                function __hash__(self::AbstractA)
                    return __key(self)
                end
                

                function __key(self::AbstractA)
                    (self.x, self.y)
                end
                

@oodef mutable struct TestCase <: unittest.TestCase
                    
                    i::Int64
x::Int64
y::Int64
z::typ
                    
function new(i::Int64 = field(metadata = 0), x::Int64 = field(default = 1, default_factory = Int64), y::Int64 = 0, z::typ = Subclass())
i = i
x = x
y = y
z = z
new(i, x, y, z)
end

                end
                function test_no_fields(self::@like(TestCase))
o = C()
@test (length(fields(C)) == 0)
end

function test_no_fields_but_member_variable(self::@like(TestCase))
o = C()
@test (length(fields(C)) == 0)
end

function test_one_field_no_default(self::@like(TestCase))
o = C(42)
@test (o.x == 42)
end

function test_field_default_default_factory_error(self::TestCase)
msg = "cannot specify both default and default_factory"
assertRaisesRegex(self, ValueError, msg) do 
mutable struct C

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                

end
end

function test_field_repr(self::TestCase)
int_field = field(default = 1, init = true, repr = false)
int_field.name = "id"
repr_output = repr(int_field)
expected_output = "Field(name=\'id\',type=None,default=1,default_factory=$(MISSING),init=True,repr=False,hash=None,compare=True,metadata=mappingproxy({}),kw_only=$(MISSING),_field_type=None)"
@test (repr_output == expected_output)
end

function test_named_init_params(self::TestCase)
o = C(x = 32)
@test (o.x == 32)
end

function test_two_fields_one_default(self::TestCase)
o = C(3)
@test ((o.x, o.y) == (3, 0))
assertRaisesRegex(self, TypeError, "non-default argument \'y\' follows default argument") do 
mutable struct C

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                

end
assertRaisesRegex(self, TypeError, "non-default argument \'y\' follows default argument") do 
mutable struct B

end

                function __repr__(self::AbstractB)::String 
                    return AbstractB() 
                end
            

                function __eq__(self::AbstractB, other::AbstractB)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractB)
                    ()
                end
                

mutable struct C <: B

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                

end
assertRaisesRegex(self, TypeError, "non-default argument \'y\' follows default argument") do 
mutable struct B

end

                function __repr__(self::AbstractB)::String 
                    return AbstractB() 
                end
            

                function __eq__(self::AbstractB, other::AbstractB)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractB)
                    ()
                end
                

mutable struct C <: B

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                

end
end

function test_overwrite_hash(self::TestCase)
@test (hash(C(100)) == 301)
@test (hash(C(100)) == hash((100,)))
assertRaisesRegex(self, TypeError, "Cannot overwrite attribute __hash__") do 
mutable struct C

end
function __hash__(self::@like(C))
#= pass =#
end


                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __hash__(self::AbstractC)
                    return __key(self)
                end
                

                function __key(self::AbstractC)
                    ()
                end
                

end
@test (hash(C(10)) == hash((10,)))
assertRaisesRegex(self, TypeError, "Cannot overwrite attribute __hash__") do 
mutable struct C

end
function __eq__(self::@like(C))
#= pass =#
end

function __hash__(self::@like(C))
#= pass =#
end


                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __hash__(self::AbstractC)
                    return __key(self)
                end
                

                function __key(self::AbstractC)
                    ()
                end
                

end
end

function test_overwrite_fields_in_derived_class(self::TestCase)
o = Base()
@test (repr(o) == "TestCase.test_overwrite_fields_in_derived_class.<locals>.Base(x=15.0, y=0)")
o = C1()
@test (repr(o) == "TestCase.test_overwrite_fields_in_derived_class.<locals>.C1(x=15, y=0, z=10)")
o = C1(x = 5)
@test (repr(o) == "TestCase.test_overwrite_fields_in_derived_class.<locals>.C1(x=5, y=0, z=10)")
end

function test_field_named_self(self::TestCase)
c = C("foo")
@test (c.self == "foo")
sig = inspect.signature(C.__init__)
first_ = next((x for x in sig.parameters))
@test ("self" != first)
sig = inspect.signature(C.__init__)
first_ = next((x for x in sig.parameters))
@test ("self" == first)
end

function test_field_named_object(self::TestCase)
c = C("foo")
@test (c.object == "foo")
end

function test_field_named_object_frozen(self::TestCase)
c = C("foo")
@test (c.object == "foo")
end

function test_field_named_like_builtin(self::TestCase)
exclusions = Set(["None", "True", "False"])
builtins_names = sorted((b for b in builtins.keys() if !startswith(b, "__")&&b ∉ exclusions ))
attributes = [(name, String) for name in builtins_names]
C = make_dataclass("C", attributes)
c = C([name for name in builtins_names]...)
for name in builtins_names
@test (getfield(c, :name) == name)
end
end

function test_field_named_like_builtin_frozen(self::TestCase)
exclusions = Set(["None", "True", "False"])
builtins_names = sorted((b for b in builtins.keys() if !startswith(b, "__")&&b ∉ exclusions ))
attributes = [(name, String) for name in builtins_names]
C = make_dataclass("C", attributes, frozen = true)
c = C([name for name in builtins_names]...)
for name in builtins_names
@test (getfield(c, :name) == name)
end
end

function test_0_field_compare(self::TestCase)
for cls in [C0, C1]
subTest(self, cls = cls) do 
@test (cls() == cls())
for (idx, fn) in enumerate([(a, b) -> a < b, (a, b) -> a <= b, (a, b) -> a > b, (a, b) -> a >= b])
subTest(self, idx = idx) do 
assertRaisesRegex(self, TypeError, "not supported between instances of \'$(cls.__name__)\' and \'$(cls.__name__)\'") do 
fn(cls(), cls())
end
end
end
end
end
assertLessEqual(self, C(), C())
assertGreaterEqual(self, C(), C())
end

function test_1_field_compare(self::TestCase)
for cls in [C0, C1]
subTest(self, cls = cls) do 
@test (cls(1) == cls(1))
@test (cls(0) != cls(1))
for (idx, fn) in enumerate([(a, b) -> a < b, (a, b) -> a <= b, (a, b) -> a > b, (a, b) -> a >= b])
subTest(self, idx = idx) do 
assertRaisesRegex(self, TypeError, "not supported between instances of \'$(cls.__name__)\' and \'$(cls.__name__)\'") do 
fn(cls(0), cls(0))
end
end
end
end
end
assertLess(self, C(0), C(1))
assertLessEqual(self, C(0), C(1))
assertLessEqual(self, C(1), C(1))
assertGreater(self, C(1), C(0))
assertGreaterEqual(self, C(1), C(0))
assertGreaterEqual(self, C(1), C(1))
end

function test_simple_compare(self::TestCase)
for cls in [C0, C1]
subTest(self, cls = cls) do 
@test (cls(0, 0) == cls(0, 0))
@test (cls(1, 2) == cls(1, 2))
@test (cls(1, 0) != cls(0, 0))
@test (cls(1, 0) != cls(1, 1))
for (idx, fn) in enumerate([(a, b) -> a < b, (a, b) -> a <= b, (a, b) -> a > b, (a, b) -> a >= b])
subTest(self, idx = idx) do 
assertRaisesRegex(self, TypeError, "not supported between instances of \'$(cls.__name__)\' and \'$(cls.__name__)\'") do 
fn(cls(0, 0), cls(0, 0))
end
end
end
end
end
for (idx, fn) in enumerate([(a, b) -> a == b, (a, b) -> a <= b, (a, b) -> a >= b])
subTest(self, idx = idx) do 
@test fn(C(0, 0), C(0, 0))
end
end
for (idx, fn) in enumerate([(a, b) -> a < b, (a, b) -> a <= b, (a, b) -> a != b])
subTest(self, idx = idx) do 
@test fn(C(0, 0), C(0, 1))
@test fn(C(0, 1), C(1, 0))
@test fn(C(1, 0), C(1, 1))
end
end
for (idx, fn) in enumerate([(a, b) -> a > b, (a, b) -> a >= b, (a, b) -> a != b])
subTest(self, idx = idx) do 
@test fn(C(0, 1), C(0, 0))
@test fn(C(1, 0), C(0, 1))
@test fn(C(1, 1), C(1, 0))
end
end
end

function test_compare_subclasses(self::TestCase)
for (idx, (fn, expected)) in enumerate([((a, b) -> a == b, false), ((a, b) -> a != b, true)])
subTest(self, idx = idx) do 
@test (fn(B(0), C(0)) == expected)
end
end
for (idx, fn) in enumerate([(a, b) -> a < b, (a, b) -> a <= b, (a, b) -> a > b, (a, b) -> a >= b])
subTest(self, idx = idx) do 
assertRaisesRegex(self, TypeError, "not supported between instances of \'B\' and \'C\'") do 
fn(B(0), C(0))
end
end
end
end

function test_eq_order(self::TestCase)
for (eq, order, result) in [(false, false, "neither"), (false, true, "exception"), (true, false, "eq_only"), (true, true, "both")]
subTest(self, eq = eq, order = order) do 
if result == "exception"
assertRaisesRegex(self, ValueError, "eq must be true if order is true") do 
mutable struct C

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __lt__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) < __key(other)
                end

                function __le__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) <= __key(other)
                end

                function __gt__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) > __key(other)
                end

                function __ge__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) >= __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                

end
else
mutable struct C

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __lt__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) < __key(other)
                end

                function __le__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) <= __key(other)
                end

                function __gt__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) > __key(other)
                end

                function __ge__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) >= __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                

if result == "neither"
assertNotIn(self, "__eq__", C.__dict__)
assertNotIn(self, "__lt__", C.__dict__)
assertNotIn(self, "__le__", C.__dict__)
assertNotIn(self, "__gt__", C.__dict__)
assertNotIn(self, "__ge__", C.__dict__)
elseif result == "both"
assertIn(self, "__eq__", C.__dict__)
assertIn(self, "__lt__", C.__dict__)
assertIn(self, "__le__", C.__dict__)
assertIn(self, "__gt__", C.__dict__)
assertIn(self, "__ge__", C.__dict__)
elseif result == "eq_only"
assertIn(self, "__eq__", C.__dict__)
assertNotIn(self, "__lt__", C.__dict__)
assertNotIn(self, "__le__", C.__dict__)
assertNotIn(self, "__gt__", C.__dict__)
assertNotIn(self, "__ge__", C.__dict__)
else
@assert(false)
end
end
end
end
end

function test_field_no_default(self::TestCase)
@test (C(5).x == 5)
assertRaisesRegex(self, TypeError, "__init__\\(\\) missing 1 required positional argument: \'x\'") do 
C()
end
end

function test_field_default(self::TestCase)
default = object()
@test self === C.x
c = C(10)
@test (c.x == 10)
# Delete Unsupported
# del(c.x)
@test self === c.x
@test self === C().x
end

function test_not_in_repr(self::TestCase)
@test_throws TypeError do 
C()
end
c = C(10)
@test (repr(c) == "TestCase.test_not_in_repr.<locals>.C()")
c = C(10, 20)
@test (repr(c) == "TestCase.test_not_in_repr.<locals>.C(y=20)")
end

function test_not_in_compare(self::TestCase)
@test (C() == C(0, 20))
@test (C(1, 10) == C(1, 20))
@test (C(3) != C(4, 10))
@test (C(3, 10) != C(4, 10))
end

function test_hash_field_rules(self::TestCase)
for (hash_, compare, result) in [(true, false, "field"), (true, true, "field"), (false, false, "absent"), (false, true, "absent"), (nothing, false, "absent"), (nothing, true, "field")]
subTest(self, hash = hash_, compare = compare) do 
mutable struct C

function new(x::Int64 = field(compare = compare, hash = hash_, default = 5))
x = x
new(x)
end

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __hash__(self::AbstractC)
                    return __key(self)
                end
                

                function __key(self::AbstractC)
                    ()
                end
                
if result == "field"
@test (hash(C(5)) == hash((5,)))
elseif result == "absent"
@test (hash(C(5)) == hash(()))
else
@assert(false)
end
end
end
end

function test_init_false_no_default(self::TestCase)
assertNotIn(self, "x", C().__dict__)
assertNotIn(self, "z", C(0).__dict__)
@test (vars(C(5)) == Dict{str, int}("t" => 10, "x" => 5, "y" => 0))
end

function test_class_marker(self::TestCase)
the_fields = fields(C)
@test isa(self, the_fields)
for f in the_fields
@test self === type_(f)
assertIn(self, f.name, C.__annotations__)
end
@test (length(the_fields) == 3)
@test (the_fields[1].name == "x")
@test (the_fields[1].type == Int64)
@test !(hasfield(typeof(C), :x))
@test the_fields[1].init
@test the_fields[1].repr
@test (the_fields[2].name == "y")
@test (the_fields[2].type == String)
assertIsNone(self, getfield(C, :y))
@test !(the_fields[2].init)
@test the_fields[2].repr
@test (the_fields[3].name == "z")
@test (the_fields[3].type == String)
@test !(hasfield(typeof(C), :z))
@test the_fields[3].init
@test !(the_fields[3].repr)
end

function test_field_order(self::TestCase)
@test ([(f.name, f.default) for f in fields(C)] == [("a", "B:a"), ("b", "C:b"), ("c", "B:c")])
@test ([(f.name, f.default) for f in fields(D)] == [("a", "B:a"), ("b", "B:b"), ("c", "D:c")])
@test ([(f.name, f.default) for f in fields(E)] == [("a", "E:a"), ("b", "B:b"), ("c", "D:c"), ("d", "E:d")])
end

function test_class_attrs(self::TestCase)
default = object()
@test !(hasfield(typeof(C), :x))
@test !(hasfield(typeof(C), :y))
@test self === C.z
@test (C.t == 100)
end

function test_disallowed_mutable_defaults(self::TestCase)
for (typ, empty_, non_empty) in [(Vector, [], [1]), (dict, Dict(), Dict{int, int}(0 => 1)), (set, Set(), Set([1]))]
subTest(self, typ = typ) do 
assertRaisesRegex(self, ValueError, "mutable default $(typ) for field x is not allowed") do 
mutable struct Point

end

                function __repr__(self::AbstractPoint)::String 
                    return AbstractPoint() 
                end
            

                function __eq__(self::AbstractPoint, other::AbstractPoint)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractPoint)
                    ()
                end
                

end
assertRaisesRegex(self, ValueError, "mutable default $(typ) for field y is not allowed") do 
mutable struct Point

end

                function __repr__(self::AbstractPoint)::String 
                    return AbstractPoint() 
                end
            

                function __eq__(self::AbstractPoint, other::AbstractPoint)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractPoint)
                    ()
                end
                

end
@oodef mutable struct Subclass <: typ
                    
                    
                    
                end
                

assertRaisesRegex(self, ValueError, "mutable default .*Subclass\'> for field z is not allowed") do 
mutable struct Point

end

                function __repr__(self::AbstractPoint)::String 
                    return AbstractPoint() 
                end
            

                function __eq__(self::AbstractPoint, other::AbstractPoint)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractPoint)
                    ()
                end
                

end
mutable struct C

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                

mutable struct C

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                

end
end
end

function test_deliberately_mutable_defaults(self::TestCase)
lst = Mutable()
o1 = C(lst)
o2 = C(lst)
@test (o1 == o2)
extend(o1.x.l, [1, 2])
@test (o1 == o2)
@test (o1.x.l == [1, 2])
@test self === o1.x
end

function test_no_options(self::TestCase)
@test (C(42).x == 42)
end

function test_not_tuple(self::TestCase)
@test (Point(1, 2) != (1, 2))
@test (Point(1, 3) != C(1, 3))
end

function test_not_other_dataclass(self::TestCase)
@test (Point3D(2017, 6, 3) != Date(2017, 6, 3))
@test (Point3D(1, 2, 3) != (1, 2, 3))
assertRaisesRegex(self, TypeError, "unpack") do 
(x, y, z) = Point3D(4, 5, 6)
end
@test (Point3D(0, 0, 0) != Point3Dv1())
end

function test_function_annotations(self::TestCase)
f = F()
function validate_class(cls::TestCase)
@test (cls.__annotations__["i"] == Int64)
@test (cls.__annotations__["j"] == String)
@test (cls.__annotations__["k"] == F)
@test (cls.__annotations__["l"] == Float64)
@test (cls.__annotations__["z"] == Complex)
signature = inspect.signature(cls.__init__)
@test self === signature.return_annotation
params = (x for x in values(signature.parameters))
param = next(params)
@test (param.name == "self")
param = next(params)
@test (param.name == "i")
@test self === param.annotation
@test (param.default == inspect.Parameter.empty)
@test (param.kind == inspect.Parameter.POSITIONAL_OR_KEYWORD)
param = next(params)
@test (param.name == "j")
@test self === param.annotation
@test (param.default == inspect.Parameter.empty)
@test (param.kind == inspect.Parameter.POSITIONAL_OR_KEYWORD)
param = next(params)
@test (param.name == "k")
@test self === param.annotation
@test (param.kind == inspect.Parameter.POSITIONAL_OR_KEYWORD)
param = next(params)
@test (param.name == "l")
@test self === param.annotation
@test (param.kind == inspect.Parameter.POSITIONAL_OR_KEYWORD)
@test_throws
end

validate_class(C)
validate_class(C)
end

function test_missing_default(self::TestCase)
assertRaisesRegex(self, TypeError, "__init__\\(\\) missing 1 required positional argument") do 
C()
end
assertNotIn(self, "x", C.__dict__)
assertRaisesRegex(self, TypeError, "__init__\\(\\) missing 1 required positional argument") do 
D()
end
assertNotIn(self, "x", D.__dict__)
end

function test_missing_default_factory(self::TestCase)
assertRaisesRegex(self, TypeError, "__init__\\(\\) missing 1 required positional argument") do 
C()
end
assertNotIn(self, "x", C.__dict__)
assertRaisesRegex(self, TypeError, "__init__\\(\\) missing 1 required positional argument") do 
D()
end
assertNotIn(self, "x", D.__dict__)
end

function test_missing_repr(self::TestCase)
assertIn(self, "MISSING_TYPE object", repr(MISSING))
end

function test_dont_include_other_annotations(self::TestCase)
@test (collect(C.__annotations__) == ["i"])
@test (foo(C(10)) == 4)
@test (C(10).bar == 5)
@test (C(10).i == 10)
end

function test_post_init(self::TestCase)
@test_throws CustomError do 
C()
end
@test_throws CustomError do 
C()
end
C(5)
C()
@test (C().x == 0)
@test (C(2).x == 4)
@test_throws FrozenInstanceError do 
C()
end
end

function test_post_init_super(self::TestCase)
@test (C().x == 5)
@test_throws CustomError do 
C()
end
@test_throws CustomError do 
C()
end
end

function test_post_init_staticmethod(self::TestCase)
flag = false
@test !(flag)
c = C(3, 4)
@test ((c.x, c.y) == (3, 4))
@test flag
end

function test_post_init_classmethod(self::TestCase)
@test !(C.flag)
c = C(3, 4)
@test ((c.x, c.y) == (3, 4))
@test C.flag
end

function test_class_var(self::TestCase)
c = C(5)
@test (repr(c) == "TestCase.test_class_var.<locals>.C(x=5, y=10)")
@test (length(fields(C)) == 2)
@test (length(C.__annotations__) == 6)
@test (c.z == 1000)
@test (c.w == 2000)
@test (c.t == 3000)
@test (c.s == 4000)
C.z += 1
@test (c.z == 1001)
c = C(20)
@test ((c.x, c.y) == (20, 10))
@test (c.z == 1001)
@test (c.w == 2000)
@test (c.t == 3000)
@test (c.s == 4000)
end

function test_class_var_no_default(self::TestCase)
assertNotIn(self, "x", C.__dict__)
end

function test_class_var_default_factory(self::TestCase)
assertRaisesRegex(self, TypeError, "cannot have a default factory") do 
mutable struct C

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                

assertNotIn(self, "x", C.__dict__)
end
end

function test_class_var_with_default(self::TestCase)
@test (C.x == 10)
@test (C.x == 10)
end

function test_class_var_frozen(self::TestCase)
c = C(5)
@test (repr(C(5)) == "TestCase.test_class_var_frozen.<locals>.C(x=5, y=10)")
@test (length(fields(C)) == 2)
@test (length(C.__annotations__) == 5)
@test (c.z == 1000)
@test (c.w == 2000)
@test (c.t == 3000)
C.z += 1
@test (c.z == 1001)
c = C(20)
@test ((c.x, c.y) == (20, 10))
@test (c.z == 1001)
@test (c.w == 2000)
@test (c.t == 3000)
end

function test_init_var_no_default(self::TestCase)
assertNotIn(self, "x", C.__dict__)
end

function test_init_var_default_factory(self::TestCase)
assertRaisesRegex(self, TypeError, "cannot have a default factory") do 
mutable struct C

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                

assertNotIn(self, "x", C.__dict__)
end
end

function test_init_var_with_default(self::TestCase)
@test (C.x == 10)
@test (C.x == 10)
end

function test_init_var(self::TestCase)
c = C(init_param = 10)
@test (c.x == 20)
end

function test_init_var_preserve_type(self::TestCase)
@test (InitVar[Int64 + 1].type == Int64)
@test (repr(InitVar[Int64 + 1]) == "dataclasses.InitVar[int]")
@test (repr(InitVar[Vector[Int64 + 1] + 1]) == "dataclasses.InitVar[typing.List[int]]")
@test (repr(InitVar[Vector[Int64 + 1] + 1]) == "dataclasses.InitVar[list[int]]")
end

function test_init_var_inheritance(self::TestCase)
b = Base(0, 10)
@test (vars(b) == Dict{str, int}("x" => 0))
c = C(10, 11, 50, 51)
@test (vars(c) == Dict{str, int}("x" => 21, "y" => 101))
end

function test_default_factory(self::TestCase)
c0 = C(3)
c1 = C(3)
@test (c0.x == 3)
@test (c0.y == [])
@test (c0 == c1)
assertIsNot(self, c0.y, c1.y)
@test (astuple(C(5, [1])) == (5, [1]))
l = []
c0 = C(3)
c1 = C(3)
@test (c0.x == 3)
@test (c0.y == [])
@test (c0 == c1)
@test self === c0.y
@test (astuple(C(5, [1])) == (5, [1]))
@test (repr(C()) == "TestCase.test_default_factory.<locals>.C()")
@test (C().x == [])
@test (astuple(C()) == ([],))
@test (hash(C()) == hash(()))
@test (astuple(C()) == ([],))
@test (C() == C([1]))
end

function test_default_factory_with_no_init(self::TestCase)
factory = Mock()
C().x
@test (factory.call_count == 1)
C().x
@test (factory.call_count == 2)
end

function test_default_factory_not_called_if_value_given(self::TestCase)
factory = Mock()
C().x
@test (factory.call_count == 1)
@test (C(10).x == 10)
@test (factory.call_count == 1)
C().x
@test (factory.call_count == 2)
end

function test_default_factory_derived(self::TestCase)
@test (Foo().x == Dict())
@test (Bar().x == Dict())
@test (Bar().y == 1)
@test (Baz().x == Dict())
end

function test_intermediate_non_dataclass(self::TestCase)
c = C(1, 3)
@test ((c.x, c.z) == (1, 3))
assertRaisesRegex(self, AttributeError, "object has no attribute") do 
c.y
end
d = D(4, 5)
@test ((d.x, d.z) == (4, 5))
end

function test_classvar_default_factory(self::TestCase)
assertRaisesRegex(self, TypeError, "cannot have a default factory") do 
mutable struct C

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                

end
end

function test_is_dataclass(self::TestCase)
@test !(is_dataclass(0))
@test !(is_dataclass(Int64))
@test !(is_dataclass(NotDataClass))
@test !(is_dataclass(NotDataClass()))
c = C(10)
d = D(c, 4)
@test is_dataclass(C)
@test is_dataclass(c)
@test !(is_dataclass(c.x))
@test is_dataclass(d.d)
@test !(is_dataclass(d.e))
end

function test_is_dataclass_when_getattr_always_returns(self::TestCase)
@test !(is_dataclass(A))
a = A()
b = B()
b.__dataclass_fields__ = []
for obj in (a, b)
subTest(self, obj = obj) do 
@test !(is_dataclass(obj))
assertRaisesRegex(self, TypeError, "should be called on dataclass instances") do 
asdict(obj)
end
assertRaisesRegex(self, TypeError, "should be called on dataclass instances") do 
astuple(obj)
end
assertRaisesRegex(self, TypeError, "should be called on dataclass instances") do 
replace(obj, x = 0)
end
end
end
end

function test_is_dataclass_genericalias(self::TestCase)
@test is_dataclass(A)
a = A(Vector, Int64)
@test is_dataclass(type_(a))
@test is_dataclass(a)
end

function test_helper_fields_with_class_instance(self::TestCase)
@test (fields(C) == fields(C(0, 0.0)))
end

function test_helper_fields_exception(self::TestCase)
assertRaisesRegex(self, TypeError, "dataclass type or instance") do 
fields(0)
end
assertRaisesRegex(self, TypeError, "dataclass type or instance") do 
fields(C)
end
assertRaisesRegex(self, TypeError, "dataclass type or instance") do 
fields(C())
end
end

function test_helper_asdict(self::TestCase)
c = C(1, 2)
@test (asdict(c) == Dict{str, int}("x" => 1, "y" => 2))
@test (asdict(c) == asdict(c))
assertIsNot(self, asdict(c), asdict(c))
c.x = 42
@test (asdict(c) == Dict{str, int}("x" => 42, "y" => 2))
@test self === type_(asdict(c))
end

function test_helper_asdict_raises_on_classes(self::TestCase)
assertRaisesRegex(self, TypeError, "dataclass instance") do 
asdict(C)
end
assertRaisesRegex(self, TypeError, "dataclass instance") do 
asdict(Int64)
end
end

function test_helper_asdict_copy_values(self::TestCase)
initial = []
c = C(1, initial)
d = asdict(c)
@test (d["y"] == initial)
assertIsNot(self, d["y"], initial)
c = C(1)
d = asdict(c)
append(d["y"], 1)
@test (c.y == [])
end

function test_helper_asdict_nested(self::TestCase)
u = User("Joe", UserId(123, 1))
d = asdict(u)
@test (d == Dict{str, Any}("name" => "Joe", "id" => Dict{str, int}("token" => 123, "group" => 1)))
assertIsNot(self, asdict(u), asdict(u))
u.id.group = 2
@test (asdict(u) == Dict{str, Any}("name" => "Joe", "id" => Dict{str, int}("token" => 123, "group" => 2)))
end

function test_helper_asdict_builtin_containers(self::TestCase)
a = User("Alice", 1)
b = User("Bob", 2)
gl = GroupList(0, [a, b])
gt = GroupTuple(0, (a, b))
gd = GroupDict(0, Dict{str, User}("first" => a, "second" => b))
@test (asdict(gl) == Dict{str, Any}("id" => 0, "users" => [Dict{str, Any}("name" => "Alice", "id" => 1), Dict{str, Any}("name" => "Bob", "id" => 2)]))
@test (asdict(gt) == Dict{str, Any}("id" => 0, "users" => (Dict{str, Any}("name" => "Alice", "id" => 1), Dict{str, Any}("name" => "Bob", "id" => 2))))
@test (asdict(gd) == Dict{str, Any}("id" => 0, "users" => Dict{str, Dict[(str, Any)]}("first" => Dict{str, Any}("name" => "Alice", "id" => 1), "second" => Dict{str, Any}("name" => "Bob", "id" => 2))))
end

function test_helper_asdict_builtin_object_containers(self::TestCase)
@test (asdict(Parent(Child([1]))) == Dict{str, Dict[(str, List[int])]}("child" => Dict{str, List[int]}("d" => [1])))
@test (asdict(Parent(Child(Dict{int, int}(1 => 2)))) == Dict{str, Dict[(str, Dict[(int, int)])]}("child" => Dict{str, Dict[(int, int)]}("d" => Dict{int, int}(1 => 2))))
end

function test_helper_asdict_factory(self::TestCase)
c = C(1, 2)
d = asdict(c, dict_factory = OrderedDict)
@test (d == OrderedDict([("x", 1), ("y", 2)]))
assertIsNot(self, d, asdict(c, dict_factory = OrderedDict))
c.x = 42
d = asdict(c, dict_factory = OrderedDict)
@test (d == OrderedDict([("x", 42), ("y", 2)]))
@test self === type_(d)
end

function test_helper_asdict_namedtuple(self::TestCase)
T = namedtuple("T", "a b c")
c = C("outer", T(1, C("inner", T(11, 12, 13)), 2))
d = asdict(c)
@test (d == Dict{str, Any}("x" => "outer", "y" => T(1, Dict{str, Any}("x" => "inner", "y" => T(11, 12, 13)), 2)))
d = asdict(c, dict_factory = OrderedDict)
@test (d == Dict{str, Any}("x" => "outer", "y" => T(1, Dict{str, Any}("x" => "inner", "y" => T(11, 12, 13)), 2)))
@test self === type_(d)
@test self === type_(d["y"][2])
end

function test_helper_asdict_namedtuple_key(self::TestCase)
T = namedtuple("T", "a")
c = C(Dict{Any, int}(T("an a") => 0))
@test (asdict(c) == Dict{str, Dict[(Any, int)]}("f" => Dict{Any, int}(T(a = "an a") => 0)))
end

function test_helper_asdict_namedtuple_derived(self::TestCase)
t = T(6)
c = C(t)
d = asdict(c)
@test (d == Dict{str, T}("f" => T(a = 6)))
assertIsNot(self, d["f"], t)
@test (my_a(d["f"]) == 6)
end

function test_helper_astuple(self::TestCase)
c = C(1)
@test (astuple(c) == (1, 0))
@test (astuple(c) == astuple(c))
assertIsNot(self, astuple(c), astuple(c))
c.y = 42
@test (astuple(c) == (1, 42))
@test self === type_(astuple(c))
end

function test_helper_astuple_raises_on_classes(self::TestCase)
assertRaisesRegex(self, TypeError, "dataclass instance") do 
astuple(C)
end
assertRaisesRegex(self, TypeError, "dataclass instance") do 
astuple(Int64)
end
end

function test_helper_astuple_copy_values(self::TestCase)
initial = []
c = C(1, initial)
t = astuple(c)
@test (t[2] == initial)
assertIsNot(self, t[2], initial)
c = C(1)
t = astuple(c)
append(t[2], 1)
@test (c.y == [])
end

function test_helper_astuple_nested(self::TestCase)
u = User("Joe", UserId(123, 1))
t = astuple(u)
@test (t == ("Joe", (123, 1)))
assertIsNot(self, astuple(u), astuple(u))
u.id.group = 2
@test (astuple(u) == ("Joe", (123, 2)))
end

function test_helper_astuple_builtin_containers(self::TestCase)
a = User("Alice", 1)
b = User("Bob", 2)
gl = GroupList(0, [a, b])
gt = GroupTuple(0, (a, b))
gd = GroupDict(0, Dict{str, User}("first" => a, "second" => b))
@test (astuple(gl) == (0, [("Alice", 1), ("Bob", 2)]))
@test (astuple(gt) == (0, (("Alice", 1), ("Bob", 2))))
@test (astuple(gd) == (0, Dict{str, Any}("first" => ("Alice", 1), "second" => ("Bob", 2))))
end

function test_helper_astuple_builtin_object_containers(self::TestCase)
@test (astuple(Parent(Child([1]))) == (([1],),))
@test (astuple(Parent(Child(Dict{int, int}(1 => 2)))) == ((Dict{int, int}(1 => 2),),))
end

function test_helper_astuple_factory(self::TestCase)
NT = namedtuple("NT", "x y")
function nt(lst::TestCase)
return NT(lst...)
end

c = C(1, 2)
t = astuple(c, tuple_factory = nt)
@test (t == NT(1, 2))
assertIsNot(self, t, astuple(c, tuple_factory = nt))
c.x = 42
t = astuple(c, tuple_factory = nt)
@test (t == NT(42, 2))
@test self === type_(t)
end

function test_helper_astuple_namedtuple(self::TestCase)
T = namedtuple("T", "a b c")
c = C("outer", T(1, C("inner", T(11, 12, 13)), 2))
t = astuple(c)
@test (t == ("outer", T(1, ("inner", (11, 12, 13)), 2)))
t = astuple(c, tuple_factory = Vector)
@test (t == ["outer", T(1, ["inner", T(11, 12, 13)], 2)])
end

function test_dynamic_class_creation(self::TestCase)
cls_dict = Dict{String, Dict{str, Any}}("__annotations__" => Dict{str, Any}("x" => Int64, "y" => Int64))
cls = type_("C", (), cls_dict)
cls1 = dataclass(cls)
@test (cls1 == cls)
@test (asdict(cls(1, 2)) == Dict{str, int}("x" => 1, "y" => 2))
end

function test_dynamic_class_creation_using_field(self::TestCase)
cls_dict = Dict{String, Any}("__annotations__" => Dict{str, Any}("x" => Int64, "y" => Int64), "y" => field(default = 5))
cls = type_("C", (), cls_dict)
cls1 = dataclass(cls)
@test (cls1 == cls)
@test (asdict(cls1(1)) == Dict{str, int}("x" => 1, "y" => 5))
end

function test_init_in_order(self::TestCase)
calls = []
function setattr(self::TestCase, name, value)
push!(calls, (name, value))
end

C.__setattr__ = setattr
c = C(0, 1)
@test (("a", 0) == calls[1])
@test (("b", 1) == calls[2])
@test (("c", []) == calls[3])
@test (("d", []) == calls[4])
assertNotIn(self, ("e", 4), calls)
@test (("f", 4) == calls[5])
end

function test_items_in_dicts(self::TestCase)
c = C(0)
assertNotIn(self, "a", C.__dict__)
assertNotIn(self, "b", C.__dict__)
assertNotIn(self, "c", C.__dict__)
assertIn(self, "d", C.__dict__)
@test (C.d == 4)
assertIn(self, "e", C.__dict__)
@test (C.e == 0)
assertIn(self, "a", c.__dict__)
@test (c.a == 0)
assertIn(self, "b", c.__dict__)
@test (c.b == [])
assertIn(self, "c", c.__dict__)
@test (c.c == [])
assertNotIn(self, "d", c.__dict__)
assertIn(self, "e", c.__dict__)
@test (c.e == 0)
end

function test_alternate_classmethod_constructor(self::TestCase)
@test (from_file("filename").x == 20)
end

function test_field_metadata_default(self::TestCase)
@test !(fields(C)[1].metadata)
@test (length(fields(C)[1].metadata) == 0)
assertRaisesRegex(self, TypeError, "does not support item assignment") do 
fields(C)[1].metadata["test"] = 3
end
end

function test_field_metadata_mapping(self::TestCase)
@test_throws TypeError do 
mutable struct C

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                

end
d = Dict()
@test !(fields(C)[1].metadata)
@test (length(fields(C)[1].metadata) == 0)
d["foo"] = 1
@test (length(fields(C)[1].metadata) == 1)
@test (fields(C)[1].metadata["foo"] == 1)
assertRaisesRegex(self, TypeError, "does not support item assignment") do 
fields(C)[1].metadata["test"] = 3
end
d = Dict("test" => 10, "bar" => "42", 3 => "three")
@test (length(fields(C)[1].metadata) == 3)
@test (fields(C)[1].metadata["test"] == 10)
@test (fields(C)[1].metadata["bar"] == "42")
@test (fields(C)[1].metadata[4] == "three")
d["foo"] = 1
@test (length(fields(C)[1].metadata) == 4)
@test (fields(C)[1].metadata["foo"] == 1)
@test_throws KeyError do 
fields(C)[1].metadata["baz"]
end
assertRaisesRegex(self, TypeError, "does not support item assignment") do 
fields(C)[1].metadata["test"] = 3
end
end

function test_field_metadata_custom_mapping(self::TestCase)
@test (length(fields(C)[1].metadata) == 1)
@test (fields(C)[1].metadata["a"] == 10)
@test_throws AttributeError do 
fields(C)[1].metadata["b"]
end
@test (fields(C)[1].metadata["xyzzy"] == "plugh")
end

function test_generic_dataclasses(self::TestCase)
T = TypeVar("T")
box = LabeledBox(42)
@test (box.content == 42)
@test (box.label == "<unknown>")
Alias = Vector[LabeledBox[Int64 + 1] + 1]
end

function test_generic_extending(self::TestCase)
S = TypeVar("S")
T = TypeVar("T")
Alias = DataDerived[String + 1]
c = Alias(0, "test1", "test2")
@test (astuple(c) == (0, "test1", "test2"))
Alias = NonDataDerived[Float64 + 1]
c = Alias(10, 1.0)
@test (new_method(c) == 1.0)
end

function test_generic_dynamic(self::TestCase)
T = TypeVar("T")
Child = make_dataclass("Child", [("y", T), ("z", Optional[__add__(T, 1)], nothing)], bases = (Parent[Int64 + 1], Generic[__add__(T, 1)]), namespace = Dict{str, int}("other" => 42))
@test self === Child[Int64 + 1](1, 2).z
@test (Child[Int64 + 1](1, 2, 3).z == 3)
@test (Child[Int64 + 1](1, 2, 3).other == 42)
Alias = Child[__add__(T, 1)]
@test (Alias[Int64 + 1](1, 2).x == 1)
@test (Child.__mro__ == (Child, Parent, Generic, object))
end

function test_dataclasses_pickleable(self::TestCase)
global P, Q, R
q = Q(1)
q.y = 2
samples = [P(1), P(1, 2), Q(1), q, R(1), R(1, [2, 3, 4])]
for sample in samples
for proto in 0:pickle.HIGHEST_PROTOCOL
subTest(self, sample = sample, proto = proto) do 
new_sample = pickle.loads(pickle.dumps(sample, proto))
@test (sample.x == new_sample.x)
@test (sample.y == new_sample.y)
assertIsNot(self, sample, new_sample)
new_sample.x = 42
another_new_sample = pickle.loads(pickle.dumps(new_sample, proto))
@test (new_sample.x == another_new_sample.x)
@test (sample.y == another_new_sample.y)
end
end
end
end

function test_dataclasses_qualnames(self::TestCase)
@test (A.__init__.__name__ == "__init__")
for function_ in ("__eq__", "__lt__", "__le__", "__gt__", "__ge__", "__hash__", "__init__", "__repr__", "__setattr__", "__delattr__")
@test (getfield(A, :function_).__qualname__ == "TestCase.test_dataclasses_qualnames.<locals>.A.$(function_)")
end
assertRaisesRegex(self, TypeError, "A\\.__init__\\(\\) missing") do 
A()
end
end


mutable struct B
f::Int64
end

                function __repr__(self::AbstractB)::String 
                    return AbstractB(self.f) 
                end
            

                function __eq__(self::AbstractB, other::AbstractB)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractB)
                    (self.f)
                end
                

@oodef mutable struct B
                    
                    f::Int64
                    
                end
                

@oodef mutable struct TestFieldNoAnnotation <: unittest.TestCase
                    
                    
                    
                end
                function test_field_without_annotation(self::TestFieldNoAnnotation)
assertRaisesRegex(self, TypeError, "\'f\' is a field but has no type annotation") do 
mutable struct C

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                

end
end

function test_field_without_annotation_but_annotation_in_base(self::TestFieldNoAnnotation)
assertRaisesRegex(self, TypeError, "\'f\' is a field but has no type annotation") do 
mutable struct C <: B
i::Int64
end

                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.i) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.i)
                end
                

end
end

function test_field_without_annotation_but_annotation_in_base_not_dataclass(self::TestFieldNoAnnotation)
assertRaisesRegex(self, TypeError, "\'f\' is a field but has no type annotation") do 
mutable struct C <: B
i::Int64
end

                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.i) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.i)
                end
                

end
end


mutable struct C
x::Int64
end

                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.x) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.x)
                end
                

mutable struct C

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                

mutable struct C
x::Int64
end

                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.x) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.x)
                end
                

mutable struct C
x::Int64
y::Int64
end

                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.x, self.y) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.x, self.y)
                end
                

mutable struct C
x::Int64
y::Int64
z::String
end

                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.x, self.y, self.z) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.x, self.y, self.z)
                end
                

mutable struct C
x::Int64
function new(x::Int64 = 3)
x = x
new(x)
end

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.x) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.x)
                end
                
mutable struct C
x::Union{Int64, Nothing}
function new(x::Union{Int64, Nothing} = nothing)
x = x
new(x)
end

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.x) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.x)
                end
                
mutable struct C
x::Vector{Int64}
end

                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.x) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.x)
                end
                

mutable struct C
x::Vector{Int64}
function new(x::Vector{Int64} = field(default_factory = Vector))
x = x
new(x)
end

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.x) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.x)
                end
                
mutable struct C
x::Abstractdeque
end

                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.x) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (__key(self.x))
                end
                

mutable struct C
x::Abstractdeque
function new(x::deque = field(default_factory = deque))
x = x
new(x)
end

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.x) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (__key(self.x))
                end
                
@oodef mutable struct TestDocString <: unittest.TestCase
                    
                    
                    
                end
                function assertDocStrEqual(self::@like(TestDocString), a, b)
@test (replace(a, " ", "") == replace(b, " ", ""))
end

function test_existing_docstring_not_overridden(self::@like(TestDocString))
@test (C.__doc__ == "Lorem ipsum")
end

function test_docstring_no_fields(self::@like(TestDocString))
assertDocStrEqual(self, C.__doc__, "C()")
end

function test_docstring_one_field(self::@like(TestDocString))
assertDocStrEqual(self, C.__doc__, "C(x:int)")
end

function test_docstring_two_fields(self::@like(TestDocString))
assertDocStrEqual(self, C.__doc__, "C(x:int, y:int)")
end

function test_docstring_three_fields(self::@like(TestDocString))
assertDocStrEqual(self, C.__doc__, "C(x:int, y:int, z:str)")
end

function test_docstring_one_field_with_default(self::@like(TestDocString))
assertDocStrEqual(self, C.__doc__, "C(x:int=3)")
end

function test_docstring_one_field_with_default_none(self::@like(TestDocString))
assertDocStrEqual(self, C.__doc__, "C(x:Optional[int]=None)")
end

function test_docstring_list_field(self::@like(TestDocString))
assertDocStrEqual(self, C.__doc__, "C(x:List[int])")
end

function test_docstring_list_field_with_default_factory(self::@like(TestDocString))
assertDocStrEqual(self, C.__doc__, "C(x:List[int]=<factory>)")
end

function test_docstring_deque_field(self::@like(TestDocString))
assertDocStrEqual(self, C.__doc__, "C(x:collections.deque)")
end

function test_docstring_deque_field_with_default_factory(self::@like(TestDocString))
assertDocStrEqual(self, C.__doc__, "C(x:collections.deque=<factory>)")
end


@oodef mutable struct B
                    
                    z::Int64
                    
function new(z::Int64 = 100)
#= pass =#
@mk begin
z = z
end
end

                end
                

mutable struct C <: B
i::Int64
x::Int64
function new(i::Int64, x::Int64 = 0)
i = i
x = x
new(i, x)
end

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.i, self.x) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.i, self.x)
                end
                
mutable struct C <: B
i::Int64
x::Int64
function new(i::Int64, x::Int64 = 10)
i = i
x = x
new(i, x)
end

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.i, self.x) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.i, self.x)
                end
                
@oodef mutable struct C
                    
                    i::Int64
                    
function new(i::Int64 = 0)
i = i
new(i)
end

                end
                

@oodef mutable struct C
                    
                    i::Int64
i::Int64
                    
function new(i::Int64 = 3, i::Int64 = 2)
@mk begin
i = i
end
end

                end
                

mutable struct C
x::Int64
function new(x)
@mk begin
x = x
end
end

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.x) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.x)
                end
                
mutable struct C
x::Int64
function new(x)
@mk begin
x = x
end
end

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.x) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.x)
                end
                
mutable struct C
x::Int64
function new(x)
@mk begin
x = x
end
end

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.x) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.x)
                end
                
@oodef mutable struct P <: Protocol
                    
                    a::Int64
                    
                end
                

mutable struct C <: P
a::Int64
x::Int64
y::Int64
function new(a::Int64, x::Int64, y::Int64 = 0)
a = a
x = x
y = y
new(a, x, y)
end

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.a, self.x, self.y) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.a, self.x, self.y)
                end
                
mutable struct D <: P

function new(a)
@mk begin

end
end

end

                function __repr__(self::AbstractD)::String 
                    return AbstractD() 
                end
            

                function __eq__(self::AbstractD, other::AbstractD)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractD)
                    ()
                end
                
@oodef mutable struct TestInit <: unittest.TestCase
                    
                    
                    
                end
                function test_base_has_init(self::@like(TestInit))
c = C(10)
@test (c.x == 10)
assertNotIn(self, "z", vars(c))
c = C()
@test (c.x == 10)
@test (c.z == 100)
end

function test_no_init(self::@like(TestInit))
dataclass(init = false)
@test (C().i == 0)
dataclass(init = false)
@test (C().i == 3)
end

function test_overwriting_init(self::@like(TestInit))
@test (C(3).x == 6)
@test (C(4).x == 8)
@test (C(5).x == 10)
end

function test_inherit_from_protocol(self::@like(TestInit))
@test (C(5).a == 5)
@test (D(5).a == 10)
end


mutable struct B
x::Int64
end

                function __repr__(self::AbstractB)::String 
                    return AbstractB(self.x) 
                end
            

                function __eq__(self::AbstractB, other::AbstractB)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractB)
                    (self.x)
                end
                

mutable struct C <: B
i::Int64
y::Int64
function new(i::Int64, y::Int64 = 10)
i = i
y = y
new(i, y)
end

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.i, self.y) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.i, self.y)
                end
                
mutable struct D <: C
x::Int64
function new(x::Int64 = 20)
x = x
new(x)
end

end

                function __repr__(self::AbstractD)::String 
                    return AbstractD(self.x) 
                end
            

                function __eq__(self::AbstractD, other::AbstractD)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractD)
                    (self.x)
                end
                
mutable struct C

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                

mutable struct C
x::Int64
end

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.x)
                end
                

mutable struct C
x::Int64
end
function Base.show(self::@like(C))
                return "C-class"
            end

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.x)
                end
                

mutable struct C
x::Int64
end
function Base.show(self::@like(C))
                return "x"
            end

                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.x) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.x)
                end
                

mutable struct C
x::Int64
end
function Base.show(self::@like(C))
                return "x"
            end

                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.x) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.x)
                end
                

mutable struct C
x::Int64
end
function Base.show(self::@like(C))
                return "x"
            end

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.x)
                end
                

mutable struct D <: AbstractC
i::Int64
end

                function __repr__(self::AbstractD)::String 
                    return AbstractD(self.i) 
                end
            

                function __eq__(self::AbstractD, other::AbstractD)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractD)
                    (self.i)
                end
                

mutable struct E <: AbstractC

end

                function __repr__(self::AbstractE)::String 
                    return AbstractE() 
                end
            

                function __eq__(self::AbstractE, other::AbstractE)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractE)
                    ()
                end
                

@oodef mutable struct TestRepr <: unittest.TestCase
                    
                    
                    
                end
                function test_repr(self::@like(TestRepr))
o = C(4)
@test (repr(o) == "TestRepr.test_repr.<locals>.C(x=4, y=10)")
@test (repr(D()) == "TestRepr.test_repr.<locals>.D(x=20, y=10)")
@test (repr(C.D(0)) == "TestRepr.test_repr.<locals>.C.D(i=0)")
@test (repr(C.E()) == "TestRepr.test_repr.<locals>.C.E()")
end

function test_no_repr(self::@like(TestRepr))
assertIn(self, "$(__name__).TestRepr.test_no_repr.<locals>.C object at", repr(C(3)))
@test (repr(C(3)) == "C-class")
end

function test_overwriting_repr(self::@like(TestRepr))
@test (repr(C(0)) == "x")
@test (repr(C(0)) == "x")
@test (repr(C(0)) == "x")
end


mutable struct C
x::Int64
end

                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.x) 
                end
            

                function __key(self::AbstractC)
                    (self.x)
                end
                

mutable struct C
x::Int64
end
function __eq__(self::@like(C), other)::Bool
return other == 10
end


                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.x) 
                end
            

                function __key(self::AbstractC)
                    (self.x)
                end
                

mutable struct C
x::Int64
end
function __eq__(self::@like(C), other)::Bool
return other == 3
end


                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.x) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.x)
                end
                

mutable struct C
x::Int64
end
function __eq__(self::@like(C), other)::Bool
return other == 4
end


                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.x) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.x)
                end
                

mutable struct C
x::Int64
end
function __eq__(self::@like(C), other)::Bool
return other == 5
end


                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.x) 
                end
            

                function __key(self::AbstractC)
                    (self.x)
                end
                

@oodef mutable struct TestEq <: unittest.TestCase
                    
                    
                    
                end
                function test_no_eq(self::@like(TestEq))
@test (C(0) != C(0))
c = C(3)
@test (c == c)
@test (C(3) == 10)
end

function test_overwriting_eq(self::@like(TestEq))
@test (C(1) == 3)
@test (C(1) != 1)
@test (C(1) == 4)
@test (C(1) != 1)
@test (C(1) == 5)
@test (C(1) != 1)
end


mutable struct C
x::Int64
end
function __lt__(self::@like(C), other)::Bool
return self.x >= other
end


                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.x) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.x)
                end
                

mutable struct C
x::Int64
end

                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.x) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.x)
                end
                

mutable struct C
x::Int64
end
function __lt__(self::@like(C), other)::Bool
return false
end


                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.x) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.x)
                end
                

@oodef mutable struct TestOrdering <: unittest.TestCase
                    
                    x::Int64
                    
                end
                function test_functools_total_ordering(self::@like(TestOrdering))
assertLess(self, C(0), -1)
assertLessEqual(self, C(0), -1)
assertGreater(self, C(0), 1)
assertGreaterEqual(self, C(0), 1)
end

function test_no_order(self::@like(TestOrdering))
assertNotIn(self, "__le__", C.__dict__)
assertNotIn(self, "__lt__", C.__dict__)
assertNotIn(self, "__ge__", C.__dict__)
assertNotIn(self, "__gt__", C.__dict__)
assertNotIn(self, "__le__", C.__dict__)
assertNotIn(self, "__ge__", C.__dict__)
assertNotIn(self, "__gt__", C.__dict__)
end

function test_overwriting_order(self::TestOrdering)
assertRaisesRegex(self, TypeError, "Cannot overwrite attribute __lt__.*using functools.total_ordering") do 
mutable struct C

end
function __lt__(self::@like(C))
#= pass =#
end


                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __lt__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) < __key(other)
                end

                function __le__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) <= __key(other)
                end

                function __gt__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) > __key(other)
                end

                function __ge__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) >= __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                

end
assertRaisesRegex(self, TypeError, "Cannot overwrite attribute __le__.*using functools.total_ordering") do 
mutable struct C

end
function __le__(self::@like(C))
#= pass =#
end


                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __lt__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) < __key(other)
                end

                function __le__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) <= __key(other)
                end

                function __gt__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) > __key(other)
                end

                function __ge__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) >= __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                

end
assertRaisesRegex(self, TypeError, "Cannot overwrite attribute __gt__.*using functools.total_ordering") do 
mutable struct C

end
function __gt__(self::@like(C))
#= pass =#
end


                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __lt__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) < __key(other)
                end

                function __le__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) <= __key(other)
                end

                function __gt__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) > __key(other)
                end

                function __ge__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) >= __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                

end
assertRaisesRegex(self, TypeError, "Cannot overwrite attribute __ge__.*using functools.total_ordering") do 
mutable struct C

end
function __ge__(self::@like(C))
#= pass =#
end


                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __lt__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) < __key(other)
                end

                function __le__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) <= __key(other)
                end

                function __gt__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) > __key(other)
                end

                function __ge__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) >= __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                

end
end


mutable struct C
x::Int64
y::String
end

                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.x, self.y) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __hash__(self::AbstractC)
                    return __key(self)
                end
                

                function __key(self::AbstractC)
                    (self.x, self.y)
                end
                

mutable struct C
i::Int64
end
function __eq__(self::@like(C), other)::Bool
return self.i == other.i
end


                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.i) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.i)
                end
                

mutable struct C
i::Int64
end
function __eq__(self::@like(C), other)::Bool
return self.i == other.i
end


                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.i) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __hash__(self::AbstractC)
                    return __key(self)
                end
                

                function __key(self::AbstractC)
                    (self.i)
                end
                

mutable struct C
i::Int64
end
function __eq__(self::@like(C), other)
return self.i == 3&&self.i == other.i
end


                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.i) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __hash__(self::AbstractC)
                    return __key(self)
                end
                

                function __key(self::AbstractC)
                    (self.i)
                end
                

mutable struct C

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                

mutable struct C

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __hash__(self::AbstractC)
                    return __key(self)
                end
                

                function __key(self::AbstractC)
                    ()
                end
                

mutable struct C
x::Int64
end

                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.x) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.x)
                end
                

mutable struct C
x::Int64
end

                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.x) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __hash__(self::AbstractC)
                    return __key(self)
                end
                

                function __key(self::AbstractC)
                    (self.x)
                end
                

@oodef mutable struct Base
                    
                    
                    
                end
                function __hash__(self::@like(Base))::Int64
return 301
end


@oodef mutable struct TestHash <: unittest.TestCase
                    
                    i::Int64
                    
                end
                function test_unsafe_hash(self::@like(TestHash))
@test (hash(C(1, "foo")) == hash((1, "foo")))
end

function test_hash_rules(self::TestHash)
function non_bool(value::@like(TestHash))::Int64
if value === nothing
return nothing
end
if value
return (3,)
end
return 0
end

function test(case::TestHash, unsafe_hash, eq, frozen, with_hash, result)
subTest(self, case = case, unsafe_hash = unsafe_hash, eq = eq, frozen = frozen) do 
if result != "exception"
if with_hash
mutable struct C

end
function __hash__(self)
return 0
end


                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __hash__(self::AbstractC)
                    return __key(self)
                end
                

                function __key(self::AbstractC)
                    ()
                end
                

else
mutable struct C

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __hash__(self::AbstractC)
                    return __key(self)
                end
                

                function __key(self::AbstractC)
                    ()
                end
                

end
end
if result == "fn"
assertIn(self, "__hash__", C.__dict__)
assertIsNotNone(self, C.__dict__["__hash__"])
elseif result == ""
if !with_hash
assertNotIn(self, "__hash__", C.__dict__)
end
elseif result == "none"
assertIn(self, "__hash__", C.__dict__)
assertIsNone(self, C.__dict__["__hash__"])
elseif result == "exception"
@assert(with_hash)
assertRaisesRegex(self, TypeError, "Cannot overwrite attribute __hash__") do 
mutable struct C

end
function __hash__(self::@like(C))::Int64
return 0
end


                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __hash__(self::AbstractC)
                    return __key(self)
                end
                

                function __key(self::AbstractC)
                    ()
                end
                

end
else
@assert(false)
end
end
end

for (case, (unsafe_hash, eq, frozen, res_no_defined_hash, res_defined_hash)) in enumerate([(false, false, false, "", ""), (false, false, true, "", ""), (false, true, false, "none", ""), (false, true, true, "fn", ""), (true, false, false, "fn", "exception"), (true, false, true, "fn", "exception"), (true, true, false, "fn", "exception"), (true, true, true, "fn", "exception")])
test(case, unsafe_hash, eq, frozen, false, res_no_defined_hash)
test(case, unsafe_hash, eq, frozen, true, res_defined_hash)
test(case, non_bool(unsafe_hash), non_bool(eq), non_bool(frozen), false, res_no_defined_hash)
test(case, non_bool(unsafe_hash), non_bool(eq), non_bool(frozen), true, res_defined_hash)
end
end

function test_eq_only(self::TestHash)
@test (C(1) == C(1))
@test (C(1) != C(4))
@test (C(1) == C(1.0))
@test (hash(C(1)) == hash(C(1.0)))
@test (C(3) == C(3))
@test (C(1) != C(1))
@test (hash(C(1)) == hash(C(1.0)))
end

function test_0_field_hash(self::TestHash)
@test (hash(C()) == hash(()))
@test (hash(C()) == hash(()))
end

function test_1_field_hash(self::TestHash)
@test (hash(C(4)) == hash((4,)))
@test (hash(C(42)) == hash((42,)))
@test (hash(C(4)) == hash((4,)))
@test (hash(C(42)) == hash((42,)))
end

function test_hash_no_args(self::TestHash)
for (frozen, eq, base, expected) in [(nothing, nothing, object, "unhashable"), (nothing, nothing, Base, "unhashable"), (nothing, false, object, "object"), (nothing, false, Base, "base"), (nothing, true, object, "unhashable"), (nothing, true, Base, "unhashable"), (false, nothing, object, "unhashable"), (false, nothing, Base, "unhashable"), (false, false, object, "object"), (false, false, Base, "base"), (false, true, object, "unhashable"), (false, true, Base, "unhashable"), (true, nothing, object, "tuple"), (true, nothing, Base, "tuple"), (true, false, object, "object"), (true, false, Base, "base"), (true, true, object, "tuple"), (true, true, Base, "tuple")]
subTest(self, frozen = frozen, eq = eq, base = base, expected = expected) do 
if frozen === nothing&&eq === nothing
mutable struct C <: base

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                

elseif frozen === nothing
mutable struct C <: base

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                

elseif eq === nothing
mutable struct C <: base

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                

else
mutable struct C <: base

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                

end
if expected == "unhashable"
c = C(10)
assertRaisesRegex(self, TypeError, "unhashable type") do 
hash(c)
end
elseif expected == "base"
@test (hash(C(10)) == 301)
elseif expected == "object"
@test self === C.__hash__
elseif expected == "tuple"
@test (hash(C(42)) == hash((42,)))
else
@assert(false)
end
end
end
end


mutable struct C
i::Int64
end

                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.i) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.i)
                end
                

mutable struct C
i::Int64
end

                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.i) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.i)
                end
                

mutable struct D <: C
j::Int64
end

                function __repr__(self::AbstractD)::String 
                    return AbstractD(self.j) 
                end
            

                function __eq__(self::AbstractD, other::AbstractD)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractD)
                    (self.j)
                end
                

mutable struct C

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                

mutable struct C

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                

mutable struct D <: C
j::Int64
end

                function __repr__(self::AbstractD)::String 
                    return AbstractD(self.j) 
                end
            

                function __eq__(self::AbstractD, other::AbstractD)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractD)
                    (self.j)
                end
                

mutable struct D
x::Int64
y::Int64
function new(x::Int64, y::Int64 = 10)
x = x
y = y
new(x, y)
end

end

                function __repr__(self::AbstractD)::String 
                    return AbstractD(self.x, self.y) 
                end
            

                function __eq__(self::AbstractD, other::AbstractD)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractD)
                    (self.x, self.y)
                end
                
@oodef mutable struct S <: D
                    
                    i::Int64
c::String
                    
function new(i::Int64, c::String = "D:c")
i = i
c = c
new(i, c)
end

                end
                

mutable struct C
x::Int64
end
function __setattr__(self::@like(C), name, value)
self.__dict__[Symbol("x")] = value*2
end


                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.x) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.x)
                end
                

mutable struct C
x::AbstractAny
end

                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.x) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (__key(self.x))
                end
                

@oodef mutable struct TestFrozen <: unittest.TestCase
                    
                    __dict__::Dict{Symbol, Any}
                    
TestFrozen(__dict__::Dict{Symbol, Any} = Dict{Symbol, Any}()) = new(__dict__)
                end
                function test_frozen(self::@like(TestFrozen))
c = C(10)
@test (c.i == 10)
@test_throws FrozenInstanceError do 
c.i = 5
end
@test (c.i == 10)
end

function test_inherit(self::@like(TestFrozen))
d = D(0, 10)
@test_throws FrozenInstanceError do 
d.i = 5
end
@test_throws FrozenInstanceError do 
d.j = 6
end
@test (d.i == 0)
@test (d.j == 10)
end

function test_inherit_nonfrozen_from_empty_frozen(self::TestFrozen)
assertRaisesRegex(self, TypeError, "cannot inherit non-frozen dataclass from a frozen one") do 
mutable struct D <: C

end

                function __repr__(self::AbstractD)::String 
                    return AbstractD() 
                end
            

                function __eq__(self::AbstractD, other::AbstractD)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractD)
                    ()
                end
                

end
end

function test_inherit_nonfrozen_from_empty(self::TestFrozen)
d = D(3)
@test (d.j == 3)
@test isa(self, d)
end

function test_inherit_nonfrozen_from_frozen(self::TestFrozen)
for intermediate_class in [true, false]
subTest(self, intermediate_class = intermediate_class) do 
mutable struct C

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                

if intermediate_class
@oodef mutable struct I <: C
                    
                    
                    
                end
                

else
I = C
end
assertRaisesRegex(self, TypeError, "cannot inherit non-frozen dataclass from a frozen one") do 
mutable struct D <: I

end

                function __repr__(self::AbstractD)::String 
                    return AbstractD() 
                end
            

                function __eq__(self::AbstractD, other::AbstractD)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractD)
                    ()
                end
                

end
end
end
end

function test_inherit_frozen_from_nonfrozen(self::TestFrozen)
for intermediate_class in [true, false]
subTest(self, intermediate_class = intermediate_class) do 
mutable struct C

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                

if intermediate_class
@oodef mutable struct I <: C
                    
                    
                    
                end
                

else
I = C
end
assertRaisesRegex(self, TypeError, "cannot inherit frozen dataclass from a non-frozen one") do 
mutable struct D <: I

end

                function __repr__(self::AbstractD)::String 
                    return AbstractD() 
                end
            

                function __eq__(self::AbstractD, other::AbstractD)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractD)
                    ()
                end
                

end
end
end
end

function test_inherit_from_normal_class(self::TestFrozen)
for intermediate_class in [true, false]
subTest(self, intermediate_class = intermediate_class) do 
@oodef mutable struct C
                    
                    
                    
                end
                

if intermediate_class
@oodef mutable struct I <: C
                    
                    
                    
                end
                

else
I = C
end
mutable struct D <: I

end

                function __repr__(self::AbstractD)::String 
                    return AbstractD() 
                end
            

                function __eq__(self::AbstractD, other::AbstractD)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractD)
                    ()
                end
                

end
d = D(10)
@test_throws FrozenInstanceError do 
d.i = 5
end
end
end

function test_non_frozen_normal_derived(self::TestFrozen)
s = S(3)
@test (s.x == 3)
@test (s.y == 10)
s.cached = true
@test_throws FrozenInstanceError do 
s.x = 5
end
@test_throws FrozenInstanceError do 
s.y = 5
end
@test (s.x == 3)
@test (s.y == 10)
@test (s.cached == true)
end

function test_overwriting_frozen(self::TestFrozen)
assertRaisesRegex(self, TypeError, "Cannot overwrite attribute __setattr__") do 
mutable struct C

end
function __setattr__(self::@like(C))
#= pass =#
end


                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                

end
assertRaisesRegex(self, TypeError, "Cannot overwrite attribute __delattr__") do 
mutable struct C

end
function __delattr__(self::@like(C))
#= pass =#
end


                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                

end
@test (C(10).x == 20)
end

function test_frozen_hash(self::TestFrozen)
hash(C(3))
assertRaisesRegex(self, TypeError, "unhashable type") do 
hash(C(Dict()))
end
end


mutable struct C
x::AbstractAny
end

                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.x) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (__key(self.x))
                end
                

mutable struct Base
x::AbstractAny
end

                function __repr__(self::AbstractBase)::String 
                    return AbstractBase(self.x) 
                end
            

                function __eq__(self::AbstractBase, other::AbstractBase)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractBase)
                    (__key(self.x))
                end
                

mutable struct Derived <: Base
x::Int64
y::Int64
end

                function __repr__(self::AbstractDerived)::String 
                    return AbstractDerived(self.x, self.y) 
                end
            

                function __eq__(self::AbstractDerived, other::AbstractDerived)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractDerived)
                    (self.x, self.y)
                end
                

mutable struct C
x::Int64
y::Int64
end

                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.x, self.y) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.x, self.y)
                end
                

mutable struct Base
x::Int64
end

                function __repr__(self::AbstractBase)::String 
                    return AbstractBase(self.x) 
                end
            

                function __eq__(self::AbstractBase, other::AbstractBase)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractBase)
                    (self.x)
                end
                

mutable struct Delivered <: Base
y::Int64
x::AbstractAny
function new(y::Int64, x = 15.0)
y = y
x = x
new(y, x)
end

end

                function __repr__(self::AbstractDelivered)::String 
                    return AbstractDelivered(self.y, self.x) 
                end
            

                function __eq__(self::AbstractDelivered, other::AbstractDelivered)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractDelivered)
                    (self.y, __key(self.x))
                end
                
mutable struct AnotherDelivered <: Base
z::Int64
x::AbstractAny
y::Int64
function new(z::Int64, x = 15.0, y::Int64 = 0)
z = z
x = x
y = y
new(z, x, y)
end

end

                function __repr__(self::AbstractAnotherDelivered)::String 
                    return AbstractAnotherDelivered(self.z, self.x, self.y) 
                end
            

                function __eq__(self::AbstractAnotherDelivered, other::AbstractAnotherDelivered)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractAnotherDelivered)
                    (self.z, __key(self.x), self.y)
                end
                
@oodef mutable struct A
                    
                    x::Int64
                    
                end
                

mutable struct FrozenSlotsClass <: AbstractTestSlots
foo::String
bar::Int64
end

                function __repr__(self::AbstractFrozenSlotsClass)::String 
                    return AbstractFrozenSlotsClass(self.foo, self.bar) 
                end
            

                function __eq__(self::AbstractFrozenSlotsClass, other::AbstractFrozenSlotsClass)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractFrozenSlotsClass)
                    (self.foo, self.bar)
                end
                

mutable struct FrozenWithoutSlotsClass <: AbstractTestSlots
foo::String
bar::Int64
end

                function __repr__(self::AbstractFrozenWithoutSlotsClass)::String 
                    return AbstractFrozenWithoutSlotsClass(self.foo, self.bar) 
                end
            

                function __eq__(self::AbstractFrozenWithoutSlotsClass, other::AbstractFrozenWithoutSlotsClass)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractFrozenWithoutSlotsClass)
                    (self.foo, self.bar)
                end
                

mutable struct A
a::String
b::String
function new(a::String, b::String = field(default = "b", init = false))
a = a
b = b
new(a, b)
end

end

                function __repr__(self::AbstractA)::String 
                    return AbstractA(self.a, self.b) 
                end
            

                function __eq__(self::AbstractA, other::AbstractA)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractA)
                    (self.a, self.b)
                end
                
mutable struct A
a::String
b::String
function new(a::String, b::String = field(default_factory = () -> "b", init = false))
a = a
b = b
new(a, b)
end

end

                function __repr__(self::AbstractA)::String 
                    return AbstractA(self.a, self.b) 
                end
            

                function __eq__(self::AbstractA, other::AbstractA)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractA)
                    (self.a, self.b)
                end
                
@oodef mutable struct TestSlots <: unittest.TestCase
                    
                    __dict__::Dict{Symbol, Any}
                    
TestSlots(__dict__::Dict{Symbol, Any} = Dict{Symbol, Any}(), __slots__::Tuple{String} = ("x",)) = new(__dict__, __slots__)
                end
                function test_simple(self::@like(TestSlots))
assertRaisesRegex(self, TypeError, "__init__\\(\\) missing 1 required positional argument: \'x\'") do 
C()
end
c = C(10)
@test (c.x == 10)
c.x = 5
@test (c.x == 5)
assertRaisesRegex(self, AttributeError, "\'C\' object has no attribute \'y\'") do 
c.y = 5
end
end

function test_derived_added_field(self::@like(TestSlots))
d = Derived(1, 2)
@test ((d.x, d.y) == (1, 2))
d.z = 10
end

function test_generated_slots(self::@like(TestSlots))
c = C(1, 2)
@test ((c.x, c.y) == (1, 2))
c.x = 3
c.y = 4
@test ((c.x, c.y) == (3, 4))
assertRaisesRegex(self, AttributeError, "\'C\' object has no attribute \'z\'") do 
c.z = 5
end
end

function test_add_slots_when_slots_exists(self::TestSlots)
assertRaisesRegex(self, TypeError, "^C already specifies __slots__\$") do 
mutable struct C

function new(x::Int64, __slots__::Tuple{String} = ("x",))
x = x
__slots__ = __slots__
new(x, __slots__)
end

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                
end
end

function test_generated_slots_value(self::TestSlots)
@test (Base.__slots__ == ("x",))
@test (Delivered.__slots__ == ("x", "y"))
@test "__slots__" ∉ AnotherDelivered.__dict__
end

function test_returns_new_class(self::TestSlots)
B = dataclass(A, slots = true)
assertIsNot(self, A, B)
@test !(hasfield(typeof(A), :__slots__))
@test hasfield(typeof(B), :__slots__)
end

function test_frozen_pickle(self::TestSlots)
@test (self.FrozenSlotsClass.__slots__ == ("foo", "bar"))
for proto in 0:pickle.HIGHEST_PROTOCOL
subTest(self, proto = proto) do 
obj = FrozenSlotsClass(self, "a", 1)
p = pickle.loads(pickle.dumps(obj, protocol = proto))
assertIsNot(self, obj, p)
@test (obj == p)
obj = FrozenWithoutSlotsClass(self, "a", 1)
p = pickle.loads(pickle.dumps(obj, protocol = proto))
assertIsNot(self, obj, p)
@test (obj == p)
end
end
end

function test_slots_with_default_no_init(self::TestSlots)
obj = A("a")
@test (obj.a == "a")
@test (obj.b == "b")
end

function test_slots_with_default_factory_no_init(self::TestSlots)
obj = A("a")
@test (obj.a == "a")
@test (obj.b == "b")
end


@oodef mutable struct D
                    
                    __dict__::Dict{Symbol, Any}
                    
D(__dict__::Dict{Symbol, Any} = Dict{Symbol, Any}()) = new(__dict__)
                end
                function __set_name__(self::@like(D), owner, name)
self.name = name + "x"
end

function __get__(self::@like(D), instance, owner)::Int64
if instance !== nothing
return 1
end
return self
end


mutable struct C
c::Int64
function new(c::Int64 = D())
c = c
new(c)
end

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.c) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.c)
                end
                
mutable struct C
c::Int64
function new(c::Int64 = field(default = D(), init = false))
c = c
new(c)
end

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.c) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.c)
                end
                
@oodef mutable struct D
                    
                    __dict__::Dict{Symbol, Any}
                    
D(__dict__::Dict{Symbol, Any} = Dict{Symbol, Any}()) = new(__dict__)
                end
                function __set_name__(self::@like(D), owner, name)
self.name = name + "x"
end


mutable struct C
c::Int64
function new(c::Int64 = field(default = D(), init = false))
c = c
new(c)
end

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.c) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.c)
                end
                
@oodef mutable struct D
                    
                    
                    
                end
                

mutable struct C
i::Int64
function new(i::Int64 = field(default = d, init = false))
i = i
new(i)
end

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.i) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.i)
                end
                
@oodef mutable struct D
                    
                    
                    
                end
                

mutable struct C
i::Int64
function new(i::Int64 = field(default = D(), init = false))
i = i
new(i)
end

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.i) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.i)
                end
                
@oodef mutable struct TestDescriptors <: unittest.TestCase
                    
                    __dict__::Dict{Symbol, Any}
                    
TestDescriptors(__dict__::Dict{Symbol, Any} = Dict{Symbol, Any}()) = new(__dict__)
                end
                function test_set_name(self::@like(TestDescriptors))
@test (C.c.name == "cx")
@test (C.c.name == "cx")
@test (C().c == 1)
end

function test_non_descriptor(self::@like(TestDescriptors))
@test (C.c.name == "cx")
end

function test_lookup_on_instance(self::@like(TestDescriptors))
d = D()
d.__set_name__ = Mock()
@test (d.__set_name__.call_count == 0)
end

function test_lookup_on_class(self::@like(TestDescriptors))
D.__set_name__ = Mock()
@test (D.__set_name__.call_count == 1)
end


@oodef mutable struct TestStringAnnotations <: unittest.TestCase
                    
                    __dict__::Dict{Symbol, Any}
                    
TestStringAnnotations(__dict__::Dict{Symbol, Any} = Dict{Symbol, Any}()) = new(__dict__)
                end
                function test_classvar(self::TestStringAnnotations)
for typestr in ("ClassVar[int]", "ClassVar [int]", " ClassVar [int]", "ClassVar", " ClassVar ", "typing.ClassVar[int]", "typing.ClassVar[str]", " typing.ClassVar[str]", "typing .ClassVar[str]", "typing. ClassVar[str]", "typing.ClassVar [str]", "typing.ClassVar [ str]", "typing.ClassVar.[int]", "typing.ClassVar+")
subTest(self, typestr = typestr) do 
mutable struct C

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                

C()
assertNotIn(self, "x", C.__dict__)
end
end
end

function test_isnt_classvar(self::TestStringAnnotations)
for typestr in ("CV", "t.ClassVar", "t.ClassVar[int]", "typing..ClassVar[int]", "Classvar", "Classvar[int]", "typing.ClassVarx[int]", "typong.ClassVar[int]", "dataclasses.ClassVar[int]", "typingxClassVar[str]")
subTest(self, typestr = typestr) do 
mutable struct C

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                

@test (C(10).x == 10)
end
end
end

function test_initvar(self::TestStringAnnotations)
for typestr in ("InitVar[int]", "InitVar [int] InitVar [int]", "InitVar", " InitVar ", "dataclasses.InitVar[int]", "dataclasses.InitVar[str]", " dataclasses.InitVar[str]", "dataclasses .InitVar[str]", "dataclasses. InitVar[str]", "dataclasses.InitVar [str]", "dataclasses.InitVar [ str]", "dataclasses.InitVar.[int]", "dataclasses.InitVar+")
subTest(self, typestr = typestr) do 
mutable struct C

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                

assertRaisesRegex(self, AttributeError, "object has no attribute \'x\'") do 
C(1).x
end
end
end
end

function test_isnt_initvar(self::TestStringAnnotations)
for typestr in ("IV", "dc.InitVar", "xdataclasses.xInitVar", "typing.xInitVar[int]")
subTest(self, typestr = typestr) do 
mutable struct C

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC() 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    ()
                end
                

@test (C(10).x == 10)
end
end
end

function test_classvar_module_level_import(self::TestStringAnnotations)
for m in (dataclass_module_1, dataclass_module_1_str, dataclass_module_2, dataclass_module_2_str)
subTest(self, m = m) do 
if m.USING_STRINGS
c = CV(m, 10)
else
c = CV(m)
end
@test (c.cv0 == 20)
c = IV(m, 0, 1, 2, 3, 4)
for field_name in ("iv0", "iv1", "iv2", "iv3")
subTest(self, field_name = field_name) do 
assertRaisesRegex(self, AttributeError, "object has no attribute \'$(field_name)\'") do 
getfield(c, :field_name)
end
end
end
if m.USING_STRINGS
assertIn(self, "not_iv4", c.__dict__)
@test (c.not_iv4 == 4)
else
assertNotIn(self, "not_iv4", c.__dict__)
end
end
end
end

function test_text_annotations(self::TestStringAnnotations)
@test (get_type_hints(dataclass_textanno.Bar) == Dict{str, Any}("foo" => dataclass_textanno.Foo))
@test (get_type_hints(dataclass_textanno.Bar.__init___) == Dict{str, Any}("foo" => dataclass_textanno.Foo, "return" => type_(nothing)))
end


@oodef mutable struct Base1
                    
                    
                    
                end
                

@oodef mutable struct Base2
                    
                    
                    
                end
                

mutable struct Base1
x::Int64
end

                function __repr__(self::AbstractBase1)::String 
                    return AbstractBase1(self.x) 
                end
            

                function __eq__(self::AbstractBase1, other::AbstractBase1)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractBase1)
                    (self.x)
                end
                

@oodef mutable struct Base2
                    
                    
                    
                end
                

@oodef mutable struct TestMakeDataclass <: unittest.TestCase
                    
                    __dict__::Dict{Symbol, Any}
                    
TestMakeDataclass(__dict__::Dict{Symbol, Any} = Dict{Symbol, Any}()) = new(__dict__)
                end
                function test_simple(self::@like(TestMakeDataclass))
C = make_dataclass("C", [("x", Int64), ("y", Int64, field(default = 5))], namespace = Dict{str, Any}("add_one" => (self) -> self.x + 1))
c = C(10)
@test ((c.x, c.y) == (10, 5))
@test (add_one(c) == 11)
end

function test_no_mutate_namespace(self::@like(TestMakeDataclass))
ns = Dict()
C = make_dataclass("C", [("x", Int64), ("y", Int64, field(default = 5))], namespace = ns)
@test (ns == Dict())
end

function test_base(self::@like(TestMakeDataclass))
C = make_dataclass("C", [("x", Int64)], bases = (Base1, Base2))
c = C(2)
@test isa(self, c)
@test isa(self, c)
@test isa(self, c)
end

function test_base_dataclass(self::@like(TestMakeDataclass))
C = make_dataclass("C", [("y", Int64)], bases = (Base1, Base2))
assertRaisesRegex(self, TypeError, "required positional") do 
c = C(2)
end
c = C(1, 2)
@test isa(self, c)
@test isa(self, c)
@test isa(self, c)
@test ((c.x, c.y) == (1, 2))
end

function test_init_var(self::@like(TestMakeDataclass))
function post_init(self::@like(TestMakeDataclass), y)
self.x *= y
end

C = make_dataclass("C", [("x", Int64), ("y", InitVar[Int64 + 1])], namespace = Dict{str, Any}("__post_init__" => post_init))
c = C(2, 3)
@test (vars(c) == Dict{str, int}("x" => 6))
@test (length(fields(c)) == 1)
end

function test_class_var(self::@like(TestMakeDataclass))
C = make_dataclass("C", [("x", Int64), ("y", ClassVar[Int64 + 1], 10), ("z", ClassVar[Int64 + 1], field(default = 20))])
c = C(1)
@test (vars(c) == Dict{str, int}("x" => 1))
@test (length(fields(c)) == 1)
@test (C.y == 10)
@test (C.z == 20)
end

function test_other_params(self::@like(TestMakeDataclass))
C = make_dataclass("C", [("x", Int64), ("y", ClassVar[Int64 + 1], 10), ("z", ClassVar[Int64 + 1], field(default = 20))], init = false)
assertNotIn(self, "__init__", vars(C))
assertIn(self, "__repr__", vars(C))
assertRaisesRegex(self, TypeError, "unexpected keyword argument") do 
C = make_dataclass("C", [], xxinit = false)
end
end

function test_no_types(self::@like(TestMakeDataclass))
C = make_dataclass("Point", ["x", "y", "z"])
c = C(1, 2, 3)
@test (vars(c) == Dict{str, int}("x" => 1, "y" => 2, "z" => 3))
@test (C.__annotations__ == Dict{str, str}("x" => "typing.Any", "y" => "typing.Any", "z" => "typing.Any"))
C = make_dataclass("Point", ["x", ("y", Int64), "z"])
c = C(1, 2, 3)
@test (vars(c) == Dict{str, int}("x" => 1, "y" => 2, "z" => 3))
@test (C.__annotations__ == Dict{str, Any}("x" => "typing.Any", "y" => Int64, "z" => "typing.Any"))
end

function test_invalid_type_specification(self::@like(TestMakeDataclass))
for bad_field in [(), (1, 2, 3, 4)]
subTest(self, bad_field = bad_field) do 
assertRaisesRegex(self, TypeError, "Invalid field: ") do 
make_dataclass("C", ["a", bad_field])
end
end
end
for bad_field in [Float64, (x) -> x]
subTest(self, bad_field = bad_field) do 
assertRaisesRegex(self, TypeError, "has no len\\(\\)") do 
make_dataclass("C", ["a", bad_field])
end
end
end
end

function test_duplicate_field_names(self::@like(TestMakeDataclass))
for field in ["a", "ab"]
subTest(self, field = field) do 
assertRaisesRegex(self, TypeError, "Field name duplicated") do 
make_dataclass("C", [field, "a", field])
end
end
end
end

function test_keyword_field_names(self::@like(TestMakeDataclass))
for field in ["for", "async", "await", "as"]
subTest(self, field = field) do 
assertRaisesRegex(self, TypeError, "must not be keywords") do 
make_dataclass("C", ["a", field])
end
assertRaisesRegex(self, TypeError, "must not be keywords") do 
make_dataclass("C", [field])
end
assertRaisesRegex(self, TypeError, "must not be keywords") do 
make_dataclass("C", [field, "a"])
end
end
end
end

function test_non_identifier_field_names(self::@like(TestMakeDataclass))
for field in ["()", "x,y", "*", "2@3", "", "little johnny tables"]
subTest(self, field = field) do 
assertRaisesRegex(self, TypeError, "must be valid identifiers") do 
make_dataclass("C", ["a", field])
end
assertRaisesRegex(self, TypeError, "must be valid identifiers") do 
make_dataclass("C", [field])
end
assertRaisesRegex(self, TypeError, "must be valid identifiers") do 
make_dataclass("C", [field, "a"])
end
end
end
end

function test_underscore_field_names(self::@like(TestMakeDataclass))
make_dataclass("C", ["_", "_a", "a_a", "a_"])
end

function test_funny_class_names_names(self::@like(TestMakeDataclass))
for classname in ["()", "x,y", "*", "2@3", ""]
subTest(self, classname = classname) do 
C = make_dataclass(classname, ["a", "b"])
@test (C.__name__ == classname)
end
end
end


mutable struct C
x::Int64
y::Int64
end

                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.x, self.y) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.x, self.y)
                end
                

mutable struct C
x::Int64
y::Int64
t::Int64
z::Int64
function new(x::Int64, y::Int64, t::Int64 = field(init = false, default = 100), z::Int64 = field(init = false, default = 10))
x = x
y = y
t = t
z = z
new(x, y, t, z)
end

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.x, self.y, self.t, self.z) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.x, self.y, self.t, self.z)
                end
                
mutable struct C
x::Int64
y::Int64
end

                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.x, self.y) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.x, self.y)
                end
                

mutable struct C
x::Int64
y::Int64
end

                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.x, self.y) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.x, self.y)
                end
                

mutable struct C
x::Int64
y::Int64
function new(x::Int64, y::Int64 = field(init = false, default = 10))
x = x
y = y
new(x, y)
end

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.x, self.y) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.x, self.y)
                end
                
mutable struct C
x::Int64
y::ClassVar{Int64}
function new(x::Int64, y::ClassVar{Int64} = 1000)
x = x
y = y
new(x, y)
end

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.x, self.y) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.x, self.y)
                end
                
mutable struct C
x::Int64
y::InitVar{Int64}
end
function __post_init__(self::@like(C), y)
self.x *= y
end


                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.x, self.y) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.x, self.y)
                end
                

mutable struct C
x::Int64
y::InitVar{Int64}
z::InitVar{Int64}
function new(x::Int64, y::InitVar{Int64} = nothing, z::InitVar{Int64} = 42)
x = x
y = y
z = z
new(x, y, z)
end

end
function __post_init__(self::@like(C), y, z)
if y !== nothing
self.x += y
end
if z !== nothing
self.x += z
end
end


                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.x, self.y, self.z) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.x, self.y, self.z)
                end
                
mutable struct C
f::AbstractC
end

                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.f) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (__key(self.f))
                end
                

mutable struct C
f::AbstractC
g::AbstractC
end

                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.f, self.g) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (__key(self.f), __key(self.g))
                end
                

mutable struct C
f::AbstractD
end

                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.f) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (__key(self.f))
                end
                

mutable struct D
f::AbstractC
end

                function __repr__(self::AbstractD)::String 
                    return AbstractD(self.f) 
                end
            

                function __eq__(self::AbstractD, other::AbstractD)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractD)
                    (__key(self.f))
                end
                

mutable struct C
f::AbstractD
end

                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.f) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (__key(self.f))
                end
                

mutable struct D
f::AbstractE
end

                function __repr__(self::AbstractD)::String 
                    return AbstractD(self.f) 
                end
            

                function __eq__(self::AbstractD, other::AbstractD)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractD)
                    (__key(self.f))
                end
                

mutable struct E
f::AbstractC
end

                function __repr__(self::AbstractE)::String 
                    return AbstractE(self.f) 
                end
            

                function __eq__(self::AbstractE, other::AbstractE)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractE)
                    (__key(self.f))
                end
                

mutable struct C
f::AbstractC
g::Int64
end

                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.f, self.g) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (__key(self.f), self.g)
                end
                

@oodef mutable struct TestReplace <: unittest.TestCase
                    
                    __dict__::Dict{Symbol, Any}
                    
TestReplace(__dict__::Dict{Symbol, Any} = Dict{Symbol, Any}()) = new(__dict__)
                end
                function test(self::@like(TestReplace))
c = C(1, 2)
c1 = replace(c, x = 3)
@test (c1.x == 3)
@test (c1.y == 2)
end

function test_frozen(self::@like(TestReplace))
c = C(1, 2)
c1 = replace(c, x = 3)
@test ((c.x, c.y, c.z, c.t) == (1, 2, 10, 100))
@test ((c1.x, c1.y, c1.z, c1.t) == (3, 2, 10, 100))
assertRaisesRegex(self, ValueError, "init=False") do 
replace(c, x = 3, z = 20, t = 50)
end
assertRaisesRegex(self, ValueError, "init=False") do 
replace(c, z = 20)
replace(c, x = 3, z = 20, t = 50)
end
assertRaisesRegex(self, FrozenInstanceError, "cannot assign to field \'x\'") do 
c1.x = 3
end
assertRaisesRegex(self, TypeError, "__init__\\(\\) got an unexpected keyword argument \'a\'") do 
c1 = replace(c, x = 20, a = 5)
end
end

function test_invalid_field_name(self::@like(TestReplace))
c = C(1, 2)
assertRaisesRegex(self, TypeError, "__init__\\(\\) got an unexpected keyword argument \'z\'") do 
c1 = replace(c, z = 3)
end
end

function test_invalid_object(self::@like(TestReplace))
assertRaisesRegex(self, TypeError, "dataclass instance") do 
replace(C, x = 3)
end
assertRaisesRegex(self, TypeError, "dataclass instance") do 
replace(0, x = 3)
end
end

function test_no_init(self::@like(TestReplace))
c = C(1)
c.y = 20
c1 = replace(c, x = 5)
@test ((c1.x, c1.y) == (5, 10))
assertRaisesRegex(self, ValueError, "init=False") do 
replace(c, x = 2, y = 30)
end
assertRaisesRegex(self, ValueError, "init=False") do 
replace(c, y = 30)
end
end

function test_classvar(self::@like(TestReplace))
c = C(1)
d = C(2)
@test self === c.y
@test (c.y == 1000)
assertRaisesRegex(self, TypeError, "__init__\\(\\) got an unexpected keyword argument \'y\'") do 
replace(c, y = 30)
end
replace(c, x = 5)
end

function test_initvar_is_specified(self::@like(TestReplace))
c = C(1, 10)
@test (c.x == 10)
assertRaisesRegex(self, ValueError, "InitVar \'y\' must be specified with replace()") do 
replace(c, x = 3)
end
c = replace(c, x = 3, y = 5)
@test (c.x == 15)
end

function test_initvar_with_default_value(self::@like(TestReplace))
c = C(x = 1, y = 10, z = 1)
@test (replace(c) == C(x = 12))
@test (replace(c, y = 4) == C(x = 12, y = 4, z = 42))
@test (replace(c, y = 4, z = 1) == C(x = 12, y = 4, z = 1))
end

function test_recursive_repr(self::@like(TestReplace))
c = C(nothing)
c.f = c
@test (repr(c) == "TestReplace.test_recursive_repr.<locals>.C(f=...)")
end

function test_recursive_repr_two_attrs(self::@like(TestReplace))
c = C(nothing, nothing)
c.f = c
c.g = c
@test (repr(c) == "TestReplace.test_recursive_repr_two_attrs.<locals>.C(f=..., g=...)")
end

function test_recursive_repr_indirection(self::@like(TestReplace))
c = C(nothing)
d = D(nothing)
c.f = d
d.f = c
@test (repr(c) == "TestReplace.test_recursive_repr_indirection.<locals>.C(f=TestReplace.test_recursive_repr_indirection.<locals>.D(f=...))")
end

function test_recursive_repr_indirection_two(self::@like(TestReplace))
c = C(nothing)
d = D(nothing)
e = E(nothing)
c.f = d
d.f = e
e.f = c
@test (repr(c) == "TestReplace.test_recursive_repr_indirection_two.<locals>.C(f=TestReplace.test_recursive_repr_indirection_two.<locals>.D(f=TestReplace.test_recursive_repr_indirection_two.<locals>.E(f=...)))")
end

function test_recursive_repr_misc_attrs(self::@like(TestReplace))
c = C(nothing, 1)
c.f = c
@test (repr(c) == "TestReplace.test_recursive_repr_misc_attrs.<locals>.C(f=..., g=1)")
end


@oodef mutable struct Ordered <: abc.ABC
                    
                    __dict__::Dict{Symbol, Any}
                    
Ordered(__dict__::Dict{Symbol, Any} = Dict{Symbol, Any}()) = new(__dict__)
                end
                function __lt__(self::@like(Ordered), other)
#= pass =#
end

function __le__(self::@like(Ordered), other)
#= pass =#
end


mutable struct Date <: Ordered
day::int
month::Month
year::Int64
__dict__::Dict{Symbol, Any}
function new(day::Int64, month::Month, year::Int64, __dict__::Dict{Symbol, Any} = Dict{Symbol, Any}())
day = day
month = month
year = year
__dict__ = __dict__
new(day, month, year, __dict__)
end

end

                function __repr__(self::AbstractDate)::String 
                    return AbstractDate(self.day, self.month, self.year, self.__dict__) 
                end
            

                function __eq__(self::AbstractDate, other::AbstractDate)::Bool
                    return __key(self) == __key(other)
                end
            

                function __lt__(self::AbstractDate, other::AbstractDate)::Bool
                    return __key(self) < __key(other)
                end

                function __le__(self::AbstractDate, other::AbstractDate)::Bool
                    return __key(self) <= __key(other)
                end

                function __gt__(self::AbstractDate, other::AbstractDate)::Bool
                    return __key(self) > __key(other)
                end

                function __ge__(self::AbstractDate, other::AbstractDate)::Bool
                    return __key(self) >= __key(other)
                end
            

                function __key(self::AbstractDate)
                    (self.day, self.month, self.year, self.__dict__)
                end
                
@oodef mutable struct A <: abc.ABC
                    
                    __dict__::Dict{Symbol, Any}
                    
A(__dict__::Dict{Symbol, Any} = Dict{Symbol, Any}()) = new(__dict__)
                end
                function foo(self::@like(A))
#= pass =#
end


mutable struct Date <: A
year::Int64
month::Month
day::int
x::Int64
end

                function __repr__(self::AbstractDate)::String 
                    return AbstractDate(self.year, self.month, self.day, self.x) 
                end
            

                function __eq__(self::AbstractDate, other::AbstractDate)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractDate)
                    (self.year, self.month, self.day, self.x)
                end
                

@oodef mutable struct TestAbstract <: unittest.TestCase
                    
                    __dict__::Dict{Symbol, Any}
                    
TestAbstract(__dict__::Dict{Symbol, Any} = Dict{Symbol, Any}()) = new(__dict__)
                end
                function test_abc_implementation(self::@like(TestAbstract))
@test !(inspect.isabstract(Date))
assertGreater(self, Date(2020, 12, 25), Date(2020, 8, 31))
end

function test_maintain_abc(self::@like(TestAbstract))
@test inspect.isabstract(Date)
msg = "class Date with abstract method foo"
@test_throws TypeError Date(Date)
            @test match(@r_str(msg), repr(Date))
end


mutable struct C
a::Int64
end

                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.a) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.a)
                end
                

mutable struct C
a::Int64
end

                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.a) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.a)
                end
                

mutable struct X
a::Int64
b::Int64
c::Int64
end

                function __key(self::AbstractX)
                    (self.a, self.b, self.c)
                end
                

mutable struct X
a::Int64
end

                function __repr__(self::AbstractX)::String 
                    return AbstractX(self.a) 
                end
            

                function __eq__(self::AbstractX, other::AbstractX)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractX)
                    (self.a)
                end
                

mutable struct Y
a::Int64
__match_args__::Tuple{String}
function new(a::Int64, __match_args__::Tuple{String} = ("b",))
a = a
__match_args__ = __match_args__
new(a, __match_args__)
end

end

                function __repr__(self::AbstractY)::String 
                    return AbstractY(self.a, self.__match_args__) 
                end
            

                function __eq__(self::AbstractY, other::AbstractY)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractY)
                    (self.a, self.__match_args__)
                end
                
mutable struct Z <: Y
z::Int64
a::Int64
end

                function __repr__(self::AbstractZ)::String 
                    return AbstractZ(self.z, self.a) 
                end
            

                function __eq__(self::AbstractZ, other::AbstractZ)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractZ)
                    (self.z, self.a)
                end
                

mutable struct A
a::Int64
z::Int64
end

                function __repr__(self::AbstractA)::String 
                    return AbstractA(self.a, self.z) 
                end
            

                function __eq__(self::AbstractA, other::AbstractA)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractA)
                    (self.a, self.z)
                end
                

mutable struct B <: A
b::Int64
x::Int64
end

                function __repr__(self::AbstractB)::String 
                    return AbstractB(self.b, self.x) 
                end
            

                function __eq__(self::AbstractB, other::AbstractB)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractB)
                    (self.b, self.x)
                end
                

@oodef mutable struct TestMatchArgs <: unittest.TestCase
                    
                    __dict__::Dict{Symbol, Any}
                    
TestMatchArgs(__dict__::Dict{Symbol, Any} = Dict{Symbol, Any}()) = new(__dict__)
                end
                function test_match_args(self::@like(TestMatchArgs))
@test (C(42).__match_args__ == ("a",))
end

function test_explicit_match_args(self::@like(TestMatchArgs))
ma = ()
@test self === C(42).__match_args__
end

function test_bpo_43764(self::@like(TestMatchArgs))
@test (X.__match_args__ == ("a", "b", "c"))
end

function test_match_args_argument(self::@like(TestMatchArgs))
assertNotIn(self, "__match_args__", X.__dict__)
@test (Y.__match_args__ == ("b",))
@test (Z.__match_args__ == ("b",))
@test (B.__match_args__ == ("a", "z"))
end

function test_make_dataclasses(self::@like(TestMatchArgs))
C = make_dataclass("C", [("x", Int64), ("y", Int64)])
@test (C.__match_args__ == ("x", "y"))
C = make_dataclass("C", [("x", Int64), ("y", Int64)], match_args = true)
@test (C.__match_args__ == ("x", "y"))
C = make_dataclass("C", [("x", Int64), ("y", Int64)], match_args = false)
assertNotIn(self, "__match__args__", C.__dict__)
C = make_dataclass("C", [("x", Int64), ("y", Int64)], namespace = Dict{str, Tuple[str]}("__match_args__" => ("z",)))
@test (C.__match_args__ == ("z",))
end


mutable struct A
a::Int64
end

                function __repr__(self::AbstractA)::String 
                    return AbstractA(self.a) 
                end
            

                function __eq__(self::AbstractA, other::AbstractA)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractA)
                    (self.a)
                end
                

mutable struct A
a::Int64
function new(a::Int64 = field(kw_only = true))
a = a
new(a)
end

end

                function __repr__(self::AbstractA)::String 
                    return AbstractA(self.a) 
                end
            

                function __eq__(self::AbstractA, other::AbstractA)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractA)
                    (self.a)
                end
                
mutable struct A
a::Int64
function new(a::Int64 = field(kw_only = false))
a = a
new(a)
end

end

                function __repr__(self::AbstractA)::String 
                    return AbstractA(self.a) 
                end
            

                function __eq__(self::AbstractA, other::AbstractA)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractA)
                    (self.a)
                end
                
mutable struct A
a::Int64
end

                function __repr__(self::AbstractA)::String 
                    return AbstractA(self.a) 
                end
            

                function __eq__(self::AbstractA, other::AbstractA)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractA)
                    (self.a)
                end
                

mutable struct A
a::Int64
function new(a::Int64 = field(kw_only = true))
a = a
new(a)
end

end

                function __repr__(self::AbstractA)::String 
                    return AbstractA(self.a) 
                end
            

                function __eq__(self::AbstractA, other::AbstractA)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractA)
                    (self.a)
                end
                
mutable struct A
a::Int64
function new(a::Int64 = field(kw_only = false))
a = a
new(a)
end

end

                function __repr__(self::AbstractA)::String 
                    return AbstractA(self.a) 
                end
            

                function __eq__(self::AbstractA, other::AbstractA)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractA)
                    (self.a)
                end
                
mutable struct A
a::Int64
end

                function __repr__(self::AbstractA)::String 
                    return AbstractA(self.a) 
                end
            

                function __eq__(self::AbstractA, other::AbstractA)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractA)
                    (self.a)
                end
                

mutable struct A
a::Int64
function new(a::Int64 = field(kw_only = true))
a = a
new(a)
end

end

                function __repr__(self::AbstractA)::String 
                    return AbstractA(self.a) 
                end
            

                function __eq__(self::AbstractA, other::AbstractA)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractA)
                    (self.a)
                end
                
mutable struct A
a::Int64
function new(a::Int64 = field(kw_only = false))
a = a
new(a)
end

end

                function __repr__(self::AbstractA)::String 
                    return AbstractA(self.a) 
                end
            

                function __eq__(self::AbstractA, other::AbstractA)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractA)
                    (self.a)
                end
                
mutable struct C
a::Int64
end

                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.a) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.a)
                end
                

mutable struct C
a::Int64
b::Int64
function new(a::Int64, b::Int64 = field(kw_only = true))
a = a
b = b
new(a, b)
end

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC(self.a, self.b) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self.a, self.b)
                end
                
mutable struct A
a::Int64
_::KW_ONLY
b::Int64
c::Int64
end

                function __repr__(self::AbstractA)::String 
                    return AbstractA(self.a, self._, self.b, self.c) 
                end
            

                function __eq__(self::AbstractA, other::AbstractA)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractA)
                    (self.a, self._, self.b, self.c)
                end
                

mutable struct B
a::Int64
_::KW_ONLY
b::Int64
c::Int64
end

                function __repr__(self::AbstractB)::String 
                    return AbstractB(self.a, self._, self.b, self.c) 
                end
            

                function __eq__(self::AbstractB, other::AbstractB)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractB)
                    (self.a, self._, self.b, self.c)
                end
                

mutable struct C
_::KW_ONLY
a::Int64
b::Int64
c::Int64
function new(_::KW_ONLY, a::Int64, b::Int64, c::Int64 = field(kw_only = false))
_ = _
a = a
b = b
c = c
new(_, a, b, c)
end

end

                function __repr__(self::AbstractC)::String 
                    return AbstractC(self._, self.a, self.b, self.c) 
                end
            

                function __eq__(self::AbstractC, other::AbstractC)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractC)
                    (self._, self.a, self.b, self.c)
                end
                
mutable struct A
a::Int64
_::dataclasses.KW_ONLY
b::Int64
c::Int64
end

                function __repr__(self::AbstractA)::String 
                    return AbstractA(self.a, self._, self.b, self.c) 
                end
            

                function __eq__(self::AbstractA, other::AbstractA)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractA)
                    (self.a, self._, self.b, self.c)
                end
                

mutable struct A
_::KW_ONLY
a::Int64
b::Int64
c::Int64
function new(_::KW_ONLY, a::Int64, b::Int64, c::Int64 = field(kw_only = true))
_ = _
a = a
b = b
c = c
new(_, a, b, c)
end

end

                function __repr__(self::AbstractA)::String 
                    return AbstractA(self._, self.a, self.b, self.c) 
                end
            

                function __eq__(self::AbstractA, other::AbstractA)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractA)
                    (self._, self.a, self.b, self.c)
                end
                
mutable struct A
a::Int64
_::KW_ONLY
b::Int64
c::Int64
end

                function __repr__(self::AbstractA)::String 
                    return AbstractA(self.a, self._, self.b, self.c) 
                end
            

                function __eq__(self::AbstractA, other::AbstractA)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractA)
                    (self.a, self._, self.b, self.c)
                end
                

mutable struct B <: A
_::KW_ONLY
d::Int64
x::Int64
end

                function __repr__(self::AbstractB)::String 
                    return AbstractB(self._, self.d, self.x) 
                end
            

                function __eq__(self::AbstractB, other::AbstractB)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractB)
                    (self._, self.d, self.x)
                end
                

mutable struct A
a::Int64
_::KW_ONLY
b::InitVar{Int64}
c::Int64
d::InitVar{Int64}
end
function __post_init__(self::@like(A), b, d)
throw(CustomError("b=$(b) d=$(d)"))
end


                function __repr__(self::AbstractA)::String 
                    return AbstractA(self.a, self._, self.b, self.c, self.d) 
                end
            

                function __eq__(self::AbstractA, other::AbstractA)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractA)
                    (self.a, self._, self.b, self.c, self.d)
                end
                

mutable struct B
a::Int64
_::KW_ONLY
b::InitVar{Int64}
c::Int64
d::InitVar{Int64}
end
function __post_init__(self::@like(B), b, d)
self.a = b
self.c = d
end


                function __repr__(self::AbstractB)::String 
                    return AbstractB(self.a, self._, self.b, self.c, self.d) 
                end
            

                function __eq__(self::AbstractB, other::AbstractB)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractB)
                    (self.a, self._, self.b, self.c, self.d)
                end
                

mutable struct A
_::KW_ONLY
a::Int64
b::Int64
c::Int64
d::Int64
function new(_::KW_ONLY = 0, a::Int64 = 0, b::Int64 = 0, c::Int64 = 1, d::Int64 = 0)
_ = _
a = a
b = b
c = c
d = d
new(_, a, b, c, d)
end

end

                function __repr__(self::AbstractA)::String 
                    return AbstractA(self._, self.a, self.b, self.c, self.d) 
                end
            

                function __eq__(self::AbstractA, other::AbstractA)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractA)
                    (self._, self.a, self.b, self.c, self.d)
                end
                
@oodef mutable struct TestKeywordArgs <: unittest.TestCase
                    
                    __dict__::Dict{Symbol, Any}
a::ClassVar{Int64}
c::Int64
b::Int64
_::KW_ONLY
d::Int64
z::Int64
                    
TestKeywordArgs(__dict__::Dict{Symbol, Any} = Dict{Symbol, Any}(), a::Int64 = 0, c::Int64 = 1, b::Int64 = 0, _::Int64 = 0, d::Int64 = 0, z::Int64 = 0) = new(__dict__, a, c, b, _, d, z)
                end
                function test_no_classvar_kwarg(self::TestKeywordArgs)
msg = "field a is a ClassVar but specifies kw_only"
assertRaisesRegex(self, TypeError, msg) do 
mutable struct A

end

                function __repr__(self::AbstractA)::String 
                    return AbstractA() 
                end
            

                function __eq__(self::AbstractA, other::AbstractA)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractA)
                    ()
                end
                

end
assertRaisesRegex(self, TypeError, msg) do 
mutable struct A

end

                function __repr__(self::AbstractA)::String 
                    return AbstractA() 
                end
            

                function __eq__(self::AbstractA, other::AbstractA)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractA)
                    ()
                end
                

end
assertRaisesRegex(self, TypeError, msg) do 
mutable struct A

function new(a::ClassVar{Int64} = field(kw_only = false))
a = a
new(a)
end

end

                function __repr__(self::AbstractA)::String 
                    return AbstractA() 
                end
            

                function __eq__(self::AbstractA, other::AbstractA)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractA)
                    ()
                end
                
end
end

function test_field_marked_as_kwonly(self::TestKeywordArgs)
@test fields(A)[1].kw_only
@test fields(A)[1].kw_only
@test !(fields(A)[1].kw_only)
@test !(fields(A)[1].kw_only)
@test fields(A)[1].kw_only
@test !(fields(A)[1].kw_only)
@test !(fields(A)[1].kw_only)
@test fields(A)[1].kw_only
@test !(fields(A)[1].kw_only)
end

function test_match_args(self::TestKeywordArgs)
@test (C(a = 42).__match_args__ == ())
@test (C(42, b = 10).__match_args__ == ("a",))
end

function test_KW_ONLY(self::TestKeywordArgs)
A(3, c = 5, b = 4)
msg = "takes 2 positional arguments but 4 were given"
assertRaisesRegex(self, TypeError, msg) do 
A(3, 4, 5)
end
B(a = 3, b = 4, c = 5)
msg = "takes 1 positional argument but 4 were given"
assertRaisesRegex(self, TypeError, msg) do 
B(3, 4, 5)
end
c = C(1, 2, b = 3)
@test (c.a == 1)
@test (c.b == 3)
@test (c.c == 2)
c = C(1, b = 3, c = 2)
@test (c.a == 1)
@test (c.b == 3)
@test (c.c == 2)
c = C(1, b = 3, c = 2)
@test (c.a == 1)
@test (c.b == 3)
@test (c.c == 2)
c = C(c = 2, b = 3, a = 1)
@test (c.a == 1)
@test (c.b == 3)
@test (c.c == 2)
end

function test_KW_ONLY_as_string(self::TestKeywordArgs)
A(3, c = 5, b = 4)
msg = "takes 2 positional arguments but 4 were given"
assertRaisesRegex(self, TypeError, msg) do 
A(3, 4, 5)
end
end

function test_KW_ONLY_twice(self::TestKeywordArgs)
msg = "\'Y\' is KW_ONLY, but KW_ONLY has already been specified"
assertRaisesRegex(self, TypeError, msg) do 
mutable struct A

end

                function __repr__(self::AbstractA)::String 
                    return AbstractA() 
                end
            

                function __eq__(self::AbstractA, other::AbstractA)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractA)
                    ()
                end
                

end
assertRaisesRegex(self, TypeError, msg) do 
mutable struct A

end

                function __repr__(self::AbstractA)::String 
                    return AbstractA() 
                end
            

                function __eq__(self::AbstractA, other::AbstractA)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractA)
                    ()
                end
                

end
assertRaisesRegex(self, TypeError, msg) do 
mutable struct A

end

                function __repr__(self::AbstractA)::String 
                    return AbstractA() 
                end
            

                function __eq__(self::AbstractA, other::AbstractA)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractA)
                    ()
                end
                

end
assertRaisesRegex(self, TypeError, msg) do 
mutable struct A

end

                function __repr__(self::AbstractA)::String 
                    return AbstractA() 
                end
            

                function __eq__(self::AbstractA, other::AbstractA)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractA)
                    ()
                end
                

mutable struct B <: A

end

                function __repr__(self::AbstractB)::String 
                    return AbstractB() 
                end
            

                function __eq__(self::AbstractB, other::AbstractB)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractB)
                    ()
                end
                

end
end

function test_post_init(self::TestKeywordArgs)
assertRaisesRegex(self, CustomError, "b=3 d=4") do 
A(1, c = 2, b = 3, d = 4)
end
b = B(1, c = 2, b = 3, d = 4)
@test (asdict(b) == Dict{str, int}("a" => 3, "c" => 4))
end

function test_defaults(self::TestKeywordArgs)
a = A(d = 4, b = 3)
@test (a.a == 0)
@test (a.b == 3)
@test (a.c == 1)
@test (a.d == 4)
err_regex = "non-default argument \'z\' follows default argument"
assertRaisesRegex(self, TypeError, err_regex) do 
mutable struct A

end

                function __repr__(self::AbstractA)::String 
                    return AbstractA() 
                end
            

                function __eq__(self::AbstractA, other::AbstractA)::Bool
                    return __key(self) == __key(other)
                end
            

                function __key(self::AbstractA)
                    ()
                end
                

end
end

function test_make_dataclass(self::TestKeywordArgs)
A = make_dataclass("A", ["a"], kw_only = true)
@test fields(A)[1].kw_only
B = make_dataclass("B", ["a", ("b", Int64, field(kw_only = false))], kw_only = true)
@test fields(B)[1].kw_only
@test !(fields(B)[2].kw_only)
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
end