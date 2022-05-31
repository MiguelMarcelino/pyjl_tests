include("../server/util.jl")
include("../server/policy.jl")
include("../client/dynamic.jl")
using ext_modules: pythoncom
import winerror
include("../server/exception.jl")
abstract type AbstractVeryPermissive end
error = "testDynamic error"
iid = pythoncom.MakeIID("{b48969a0-784b-11d0-ae71-d23f56000000}")
mutable struct VeryPermissive <: AbstractVeryPermissive
end
function _dynamic_(self::AbstractVeryPermissive, name, lcid, wFlags, args)
    if wFlags & pythoncom.DISPATCH_METHOD
        return getfield(self, :name)(args...)
    end
    if wFlags & pythoncom.DISPATCH_PROPERTYGET
        try
            ret = self.__dict__[name]
            if type_(ret) == type_(())
                ret = collect(ret)
            end
            return ret
        catch exn
            if exn isa KeyError
                throw(Exception(scode = winerror.DISP_E_MEMBERNOTFOUND))
            end
        end
    end
    if wFlags & (pythoncom.DISPATCH_PROPERTYPUT | pythoncom.DISPATCH_PROPERTYPUTREF)
        setattr(self, name, args[1])
        return
    end
    throw(Exception(scode = winerror.E_INVALIDARG, desc = "invalid wFlags"))
end

function write(self::AbstractVeryPermissive)
    if length(args) == 0
        throw(Exception(scode = winerror.DISP_E_BADPARAMCOUNT))
    end
    for arg in args[begin:end-1]
        print("$(string(arg))")
    end
    println(string(args[end]))
end

function Test()
    ob = win32com_.server.util.wrap(
        VeryPermissive(),
        usePolicy = win32com_.server.policy.DynamicPolicy,
    )
    try
        handle = pythoncom.RegisterActiveObject(ob, iid, 0)
    catch exn
        let details = exn
            if details isa pythoncom.com_error
                println("Warning - could not register the object in the ROT: $(details)")
                handle = nothing
            end
        end
    end
    try
        client = win32com_.client.dynamic.Dispatch(iid)
        client.ANewAttr = "Hello"
        if client.ANewAttr != "Hello"
            throw(error("Could not set dynamic property"))
        end
        v = ["Hello", "From", "Python", 1.4]
        client.TestSequence = v
        if v != collect(client.TestSequence)
            throw(
                error(
                    "Dynamic sequences not working! $(repr(v))/$(repr(client.testSequence))",
                ),
            )
        end
        write(client, "This", "output", "has", "come", "via", "testDynamic.py")
        _FlagAsMethod(client, "NotReallyAMethod")
        if !callable(client.NotReallyAMethod)
            throw(error("Method I flagged as callable isn\'t!"))
        end
        client = nothing
    finally
        if handle !== nothing
            pythoncom.RevokeActiveObject(handle)
        end
    end
    println("Test worked!")
end

if abspath(PROGRAM_FILE) == @__FILE__
    Test()
end
