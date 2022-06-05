@resumable function fib_resumable() :: Int
    a = 0
    b = 1
    while true
        @yield a
        a, b = b, a + b
    end
end