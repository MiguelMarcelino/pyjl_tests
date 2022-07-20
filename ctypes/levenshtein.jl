using Libdl
using StringEncodings

function load_module()
    cmodule = Libdl.dlopen("./levenshtein.so")
    return cmodule
end

if abspath(PROGRAM_FILE) == @__FILE__
    cmodule = load_module()
    source = "levenshtein"
    target = "levenstein"
    insert_cost = 1
    delete_cost = 1
    replace_cost = 2
    levenshtein = Libdl.dlsym(cmodule, :levenshtein) # Added 
    res = ccall(levenshtein, Cint, (Ptr{Cchar}, Ptr{Cchar}, Cint, Cint, Cint),
        encode(source, "UTF-8"), 
        encode(target, "UTF-8"),
        Int32(insert_cost),
        Int32(delete_cost),
        Int32(replace_cost))
    println("Levenshtein distance between $(source) and $(target): $(res)")
    # Where to put this?
    Libdl.dlclose(cmodule)
end

# Mapping ctypes to Julia
# ctypes.c_char_p --> Ptr{Cchar}
# ctypes.c_int --> Cint

