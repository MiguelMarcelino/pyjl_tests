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
    levenshtein = Libdl.dlsym(cmodule, :levenshtein)
    res = ccall(
        levenshtein,
        Cint,
        (Ptr{Cchar}, Ptr{Cchar}, Cint, Cint, Cint),
        encode(source, "utf-8"),
        encode(target, "utf-8"),
        Int32(insert_cost),
        Int32(delete_cost),
        Int32(replace_cost),
    )
    println("Levenshtein distance between \'$(source)\' and \'$(target)\': $(res)")
end
