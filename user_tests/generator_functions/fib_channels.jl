function fib_channels()
    Channel() do ch
        a = 0
        b = 1
        while true
            put!(ch, a)
            a, b = b, a+b
        end
    end
end