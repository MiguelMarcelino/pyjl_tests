
if abspath(PROGRAM_FILE) == @__FILE__
    write_ = x -> write(stdout, x)
    stdout.write(b"Test\n")
    write_(b"P4\n")
    flush_ = flush(stdout)
    stdout.flush()
end
