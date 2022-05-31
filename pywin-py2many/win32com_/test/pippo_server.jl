using Printf
using distutils.dep_util: newer
import win32com_.server.register

using ext_modules: pythoncom
import win32com_
import winerror
using win32com_.server.util: wrap
abstract type AbstractCPippo end
mutable struct CPippo <: AbstractCPippo
    MyProp1::Int64
    _com_interfaces_::Vector{String}
    _reg_clsid_::String
    _reg_desc_::String
    _reg_progid_::String
    _typelib_guid_::String
    _typelib_version_::Tuple{Int64}
    CPippo(MyProp1 = 10) = new(MyProp1)
end
function Method1(self::AbstractCPippo)
    return wrap(CPippo())
end

function Method2(self::AbstractCPippo, in1, inout1)
    return (in1, inout1 * 2)
end

function Method3(self::AbstractCPippo, in1)::Vector
    return collect(in1)
end

function BuildTypelib()
    this_dir = dirname(__file__)
    idl = abspath(os.path, joinpath(this_dir, "pippo.idl"))
    tlb = splitext(os.path, idl)[1] + ".tlb"
    if newer(idl, tlb)
        @printf("Compiling %s\n", (idl,))
        rc = os.system("midl \"$(idl)\"")
        if rc
            throw(RuntimeError("Compiling MIDL failed!"))
        end
        for fname in split("dlldata.c pippo_i.c pippo_p.c pippo.h")
            rm(joinpath(this_dir, fname))
        end
    end
    @printf("Registering %s\n", (tlb,))
    tli = pythoncom.LoadTypeLib(tlb)
    pythoncom.RegisterTypeLib(tli, tlb)
end

function UnregisterTypelib()
    k = CPippo
    try
        pythoncom.UnRegisterTypeLib(
            k._typelib_guid_,
            k._typelib_version_[1],
            k._typelib_version_[2],
            0,
            pythoncom.SYS_WIN32,
        )
        println("Unregistered typelib")
    catch exn
        let details = exn
            if details isa pythoncom.error
                if details[1] == winerror.TYPE_E_REGISTRYACCESS
                    #= pass =#
                else
                    error()
                end
            end
        end
    end
end

function main(argv = nothing)
    if argv === nothing
        argv = append!([PROGRAM_FILE], ARGS)[2:end]
    end
    if "--unregister" ∈ argv
        UnregisterTypelib()
    else
        BuildTypelib()
    end
    win32com_.server.register.UseCommandLine(CPippo)
end

if abspath(PROGRAM_FILE) == @__FILE__
    main(append!([PROGRAM_FILE], ARGS))
end
