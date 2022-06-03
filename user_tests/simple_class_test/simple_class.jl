
abstract type AbstractPerson end
abstract type AbstractStudent <: AbstractPerson end

mutable struct Person <: AbstractPerson
    name::String
end
function get_name(self::AbstractPerson)::String
    return self.name
end

mutable struct Student <: AbstractStudent
    name::String
    student_number::Int64
    domain::String

    Student(name::String, student_number::Int64, domain::String = "school.student.pt") =
        begin
            if student_number < 0
                throw(ValueError("Student number must be a positive number"))
            end
            new(name, student_number, domain)
        end
end