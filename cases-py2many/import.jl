import toposort
using fib: fib
if abspath(PROGRAM_FILE) == @__FILE__
    println(fib(10))
end
