
abstract type AbstractColors <: str end
@enum Colors::String begin end
function show()
    color_map = Dict(Colors.RED => "1", Colors.GREEN => "2", Colors.BLUE => "3")
    a = Colors.GREEN
    if a == Colors.GREEN
        println("green")
    else
        println("Not green")
    end
    println(length(color_map))
end

if abspath(PROGRAM_FILE) == @__FILE__
    show()
end
