using SuperEnum

@se Colors begin
    RED => "red"
    GREEN => "green"
    BLUE => "blue"
end

function show()
    color_map =
        Dict{Colors, String}(Colors.RED => "1", Colors.GREEN => "2", Colors.BLUE => "3")
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
