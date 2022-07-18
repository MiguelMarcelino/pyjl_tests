using ObjectOriented
@oodef mutable struct Foo


    function bar(self::Foo)::Int64
        return self.baz()
    end

    function baz(self::Foo)::Int64
        return 10
    end

    function bar_str(self::Foo)::String
        return "a"
    end

end
@oodef mutable struct Person
    name::String


    function new(name::String)

        @mk begin

            name = name
        end
    end

    function get_name(self::Person)::String
        return self.name
    end

end
@oodef mutable struct Student <: Person
    name::String
    student_number::Int64
    domain::String


    function new(name::String, student_number::Int64, domain::String = "school.student.pt")
        # if student_number < 0
        #     throw(ValueError("Student number must be a positive number"))
        # end
        @mk begin

            name = name
            student_number = student_number
            domain = domain
        end
    end

    function get_name(self::Student)
        return "$(self.name) - $(self.student_number)"
    end

end
@oodef mutable struct Worker <: Person
    company_name::String
    hours_per_week::Int64


    function new(name::String, company_name::String, hours_per_week::Int64)

        @mk begin
            Person(name)
            company_name = company_name
            hours_per_week = hours_per_week
        end
    end

end
@oodef mutable struct StudentWorker <: {Student, Worker}
    is_exhausted::Bool


    function new(
        name::String,
        student_number::Int64,
        domain::String,
        company_name::String,
        hours_per_week::Int64,
        is_exhausted::Bool,
    )

        @mk begin
            Student(name, student_number, domain),
            Worker(name, company_name, hours_per_week)
            is_exhausted = is_exhausted
        end
    end

end
if abspath(PROGRAM_FILE) == @__FILE__
    f = Foo()
    b = f.bar()
    @assert(b == 10)
    c = f.bar_str()
    @assert(c == "a")
    p = Person("P")
    s = Student("S", 111111)
    @assert(p.get_name() == "P")
    @assert(s.get_name() == "S - 111111")
    sw = StudentWorker("Timo Marcello", 1111, "school.student.pt", "Cisco", 40, true)
    @assert(sw.company_name == "Cisco")
    @assert(sw.is_exhausted == true)
    println("OK")
end
