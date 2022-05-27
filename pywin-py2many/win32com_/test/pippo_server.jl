using Printf
using PyCall
pythoncom = pyimport("pythoncom")
using distutils.dep_util: newer
import win32com_.server.register


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

                    CPippo(MyProp1::Int64, _com_interfaces_::Vector{String} = ["IPippo"], _reg_clsid_::String = "{1F0F75D6-BD63-41B9-9F88-2D9D2E1AA5C3}", _reg_desc_::String = "Pippo Python test object", _reg_progid_::String = "Python.Test.Pippo", _typelib_guid_::String = "{7783054E-9A20-4584-8C62-6ED2A08F6AC6}", _typelib_version_::Tuple{Int64} = (1, 0)) =
                        new(MyProp1, _com_interfaces_, _reg_clsid_, _reg_desc_, _reg_progid_, _typelib_guid_, _typelib_version_)
end
function Method1(self::CPippo)
return wrap(CPippo())
end

function Method2(self::CPippo, in1, inout1)
return (in1, inout1*2)
end

function Method3(self::CPippo, in1)::Vector
return collect(in1)
end

function BuildTypelib()
this_dir = dirname(__file__)
idl = abspath(os.path, joinpath(this_dir, "pippo.idl"))
tlb = splitext(os.path, idl)[1] + ".tlb"
if newer(idl, tlb)
@printf("Compiling %s\n", idl)
rc = system("midl \"%s\"" % (idl,))
if rc
throw(RuntimeError("Compiling MIDL failed!"))
end
for fname in split("dlldata.c pippo_i.c pippo_p.c pippo.h")
remove(joinpath(this_dir, fname))
end
end
@printf("Registering %s\n", tlb)
tli = LoadTypeLib(tlb)
RegisterTypeLib(tli, tlb)
end

function UnregisterTypelib()
k = CPippo
try
UnRegisterTypeLib(k._typelib_guid_, k._typelib_version_[1], k._typelib_version_[2], 0, pythoncom.SYS_WIN32)
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
argv = sys.argv[2:end]
end
if "--unregister" ∈ argv
UnregisterTypelib()
else
BuildTypelib()
end
UseCommandLine(CPippo)
end

if abspath(PROGRAM_FILE) == @__FILE__
main(sys.argv)
end
