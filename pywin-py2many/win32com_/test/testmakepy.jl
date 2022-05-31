using PyCall
win32api = pyimport("win32api")



import glob

import win32com_.test.util
using win32com_.client: makepy, selecttlb, gencache
using ext_modules: pythoncom
import winerror
function TestBuildAll(verbose = 1)::Int64
num = 0
tlbInfos = selecttlb.EnumTlbs()
for info in tlbInfos
if verbose
println("$(info.desc)$(info.dll))")
end
try
makepy.GenerateFromTypeLibSpec(info)
num += 1
catch exn
 let details = exn
if details isa pythoncom.com_error
if details.hresult ∉ [winerror.TYPE_E_CANTLOADLIBRARY, winerror.TYPE_E_LIBNOTREGISTERED]
println("** COM error on$(info.desc)")
println(details)
end
end
end
if exn isa KeyboardInterrupt
println("Interrupted!")
throw(KeyboardInterrupt)
end
println("Failed:$(info.desc)")
current_exceptions() != [] ? current_exceptions()[end] : nothing()
end
if makepy.bForDemandDefault
tinfo = (info.clsid, info.lcid, info.major, info.minor)
mod = gencache.EnsureModule(info.clsid, info.lcid, info.major, info.minor)
for name in keys(mod.NamesToIIDMap)
makepy.GenerateChildFromTypeLibSpec(name, tinfo)
end
end
end
return num
end

function TestAll(verbose = 0)
num = TestBuildAll(verbose)
println("Generated and imported$(num)modules")
win32com_.test.util.CheckClean()
end

if abspath(PROGRAM_FILE) == @__FILE__
TestAll("-q" ∉ append!([PROGRAM_FILE], ARGS))
end