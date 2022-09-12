# Transpiled with flags: 
# - oop
using ObjectOriented
using Test

@oodef mutable struct C
                    
                    a::Int64
b::String
                    
function new(a::Int64 = 3, b::String = 4)
a = a
b = b
new(a, b)
end

                end
                

@oodef mutable struct C
                    
                    my_annotations
                    
function new(name = nothing, bases = nothing, d = nothing, my_annotations = nothing)
@mk begin
my_annotations = my_annotations
end
end

                end
                function __annotations__(self::@like(C))
if !hasfield
self.my_annotations = Dict()
end
if !isa(self.my_annotations, dict)
self.my_annotations = Dict()
end
return self.my_annotations
end

function __annotations__(self::@like(C), value)
if !isa(value, dict)
throw(ValueError("can only set __annotations__ to a dict"))
end
self.my_annotations = value
end

function __annotations__(self::@like(C))
if getfield(my_annotations, :false) === nothing
throw(AttributeError("__annotations__"))
end
self.my_annotations = nothing
end


@oodef mutable struct D
                    
                    
                    
                end
                

@oodef mutable struct TypeAnnotationTests <: unittest.TestCase
                    
                    
                    
                end
                function test_lazy_create_annotations(self::@like(TypeAnnotationTests))
foo = type_("Foo", (), Dict())
for i in 0:2
@test !("__annotations__" ∈ foo.__dict__)
d = foo.__annotations__
@test "__annotations__" ∈ foo.__dict__
@test (foo.__annotations__ == d)
@test (foo.__dict__["__annotations__"] == d)
# Delete Unsupported
# del(foo.__annotations__)
end
end

function test_setting_annotations(self::@like(TypeAnnotationTests))
foo = type_("Foo", (), Dict())
for i in 0:2
@test !("__annotations__" ∈ foo.__dict__)
d = Dict{String, Any}("a" => Int64)
foo.__annotations__ = d
@test "__annotations__" ∈ foo.__dict__
@test (foo.__annotations__ == d)
@test (foo.__dict__["__annotations__"] == d)
# Delete Unsupported
# del(foo.__annotations__)
end
end

function test_annotations_getset_raises(self::@like(TypeAnnotationTests))
@test_throws AttributeError do 
println(Float64.__annotations__)
end
@test_throws TypeError do 
float.__annotations__ = Dict()
end
@test_throws TypeError do 
# Delete Unsupported
# del(Float64.__annotations__)
end
foo = type_("Foo", (), Dict())
foo.__annotations__ = Dict()
# Delete Unsupported
# del(foo.__annotations__)
@test_throws AttributeError do 
# Delete Unsupported
# del(foo.__annotations__)
end
end

function test_annotations_are_created_correctly(self::@like(TypeAnnotationTests))
@test "__annotations__" ∈ C.__dict__
# Delete Unsupported
# del(C.__annotations__)
@test !("__annotations__" ∈ C.__dict__)
end

function test_descriptor_still_works(self::@like(TypeAnnotationTests))
c = C()
@test (c.__annotations__ == Dict())
d = Dict{String, String}("a" => "int")
c.__annotations__ = d
@test (c.__annotations__ == d)
@test_throws ValueError do 
c.__annotations__ = 123
end
# Delete Unsupported
# del(c.__annotations__)
@test_throws AttributeError do 
# Delete Unsupported
# del(c.__annotations__)
end
@test (c.__annotations__ == Dict())
@test (D.__annotations__ == Dict())
d = Dict{String, String}("a" => "int")
D.__annotations__ = d
@test (D.__annotations__ == d)
@test_throws ValueError do 
D.__annotations__ = 123
end
# Delete Unsupported
# del(D.__annotations__)
@test_throws AttributeError do 
# Delete Unsupported
# del(D.__annotations__)
end
@test (D.__annotations__ == Dict())
end

