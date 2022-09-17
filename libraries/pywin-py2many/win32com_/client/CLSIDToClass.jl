#= Manages a dictionary of CLSID strings to Python classes.

Primary use of this module is to allow modules generated by
makepy.py to share classes.  @makepy@ automatically generates code
which interacts with this module.  You should never need to reference
this module directly.

This module only provides support for modules which have been previously
been imported.  The gencache module provides some support for loading modules
on demand - once done, this module supports it...

As an example, the MSACCESS.TLB type library makes reference to the
CLSID of the Database object, as defined in DAO3032.DLL.  This
allows code using the MSAccess wrapper to natively use Databases.

This obviously applies to all cooperating objects, not just DAO and
Access.
 =#
mapCLSIDToClass = Dict()
function RegisterCLSID(clsid, pythonClass)
    #= Register a class that wraps a CLSID

        This function allows a CLSID to be globally associated with a class.
        Certain module will automatically convert an IDispatch object to an
        instance of the associated class.
         =#
    mapCLSIDToClass[string(clsid)] = pythonClass
end

function RegisterCLSIDsFromDict(dict)
    #= Register a dictionary of CLSID's and classes.

        This module performs the same function as @RegisterCLSID@, but for
        an entire dictionary of associations.

        Typically called by makepy generated modules at import time.
         =#
    update(mapCLSIDToClass, dict)
end

function GetClass(clsid)::Dict
    #= Given a CLSID, return the globally associated class.

        clsid -- a string CLSID representation to check.
         =#
    return mapCLSIDToClass[clsid]
end

function HasClass(clsid)::Bool
    #= Determines if the CLSID has an associated class.

        clsid -- the string CLSID to check
         =#
    return clsid ∈ mapCLSIDToClass
end