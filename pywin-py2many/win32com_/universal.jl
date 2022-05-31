import win32com_.client.build

using ext_modules: pythoncom
using win32com_.client: gencache
abstract type AbstractArg end
abstract type AbstractMethod end
abstract type AbstractDefinition end
com_error = pythoncom.com_error
_univgw = pythoncom._univgw
function RegisterInterfaces(
    typelibGUID,
    lcid,
    major,
    minor,
    interface_names = nothing,
)::Vector
    ret = []
    try
        mod = gencache.GetModuleForTypelib(typelibGUID, lcid, major, minor)
    catch exn
        if exn isa ImportError
            mod = nothing
        end
    end
    if mod === nothing
        tlb = pythoncom.LoadRegTypeLib(typelibGUID, major, minor, lcid)
        typecomp_lib = GetTypeComp(tlb)
        if interface_names === nothing
            interface_names = []
            for i = 0:GetTypeInfoCount(tlb)-1
                info = GetTypeInfo(tlb, i)
                doc = GetDocumentation(tlb, i)
                attr = GetTypeAttr(info)
                if attr.typekind == pythoncom.TKIND_INTERFACE ||
                   attr.typekind == pythoncom.TKIND_DISPATCH &&
                   attr.wTypeFlags & pythoncom.TYPEFLAG_FDUAL
                    push!(interface_names, doc[1])
                end
            end
        end
        for name in interface_names
            type_info, type_comp = BindType(typecomp_lib, name)
            if type_info === nothing
                throw(ValueError("The interface \'$(name)\' can not be located"))
            end
            attr = GetTypeAttr(type_info)
            if attr.typekind == pythoncom.TKIND_DISPATCH
                refhtype = GetRefTypeOfImplType(type_info, -1)
                type_info = GetRefTypeInfo(type_info, refhtype)
                attr = GetTypeAttr(type_info)
            end
            item = win32com_.client.build.VTableItem(
                type_info,
                attr,
                GetDocumentation(type_info, -1),
            )
            _doCreateVTable(
                item.clsid,
                item.python_name,
                item.bIsDispatch,
                item.vtableFuncs,
            )
            for info in item.vtableFuncs
                names, dispid, desc = info
                invkind = desc[5]
                push!(ret, (dispid, invkind, names[1]))
            end
        end
    else
        if !(interface_names)
            interface_names = collect(values(mod.VTablesToClassMap))
        end
        for name in interface_names
            try
                iid = mod.NamesToIIDMap[name+1]
            catch exn
                if exn isa KeyError
                    throw(
                        ValueError(
                            "Interface \'$(name)\' does not exist in this cached typelib",
                        ),
                    )
                end
            end
            sub_mod = gencache.GetModuleForCLSID(iid)
            is_dispatch = (
                hasfield(typeof(sub_mod), :name + "_vtables_dispatch_") ?
                getfield(sub_mod, :name + "_vtables_dispatch_") : nothing
            )
            method_defs = (
                hasfield(typeof(sub_mod), :name + "_vtables_") ?
                getfield(sub_mod, :name + "_vtables_") : nothing
            )
            if is_dispatch === nothing || method_defs === nothing
                throw(ValueError("Interface \'$(name)\' is IDispatch only"))
            end
            _doCreateVTable(iid, name, is_dispatch, method_defs)
            for info in method_defs
                names, dispid, desc = info
                invkind = desc[5]
                push!(ret, (dispid, invkind, names[1]))
            end
        end
    end
    return ret
end

function _doCreateVTable(iid, interface_name, is_dispatch, method_defs)
    defn = Definition(iid, is_dispatch, method_defs)
    vtbl = CreateVTable(_univgw, defn, is_dispatch)
    RegisterVTable(_univgw, vtbl, iid, interface_name)
end

function _CalcTypeSize(typeTuple)
    t = typeTuple[1]
    if t & (pythoncom.VT_BYREF | pythoncom.VT_ARRAY)
        cb = SizeOfVT(_univgw, pythoncom.VT_PTR)[2]
    elseif t == pythoncom.VT_RECORD
        cb = SizeOfVT(_univgw, pythoncom.VT_PTR)[2]
    else
        cb = SizeOfVT(_univgw, t)[2]
    end
    return cb
end

mutable struct Arg <: AbstractArg
    name
    size
    offset::Int64
    Arg(arg_info, name = nothing, size = _CalcTypeSize(arg_info), offset = 0) =
        new(arg_info, name, size, offset)
end

mutable struct Method <: AbstractMethod
    _gw_in_args
    _gw_out_args
    args::Vector
    cbArgs::Int64
    dispid
    invkind
    name
    isEventSink::Int64

    Method(
        method_info,
        isEventSink = 0,
        name = all_names[1],
        names = all_names[2:end],
        invkind = desc[5],
        arg_defs = desc[3],
        ret_def = desc[9],
        dispid = dispid,
        cbArgs = 0,
        args = [],
        _gw_in_args = _GenerateInArgTuple(),
        _gw_out_args = _GenerateOutArgTuple(),
    ) = begin
        if isEventSink && name[begin:2] != "On"
            name = "On$(name)"
        end
        for argDesc in arg_defs
            arg = Arg(argDesc)
            arg.offset = cbArgs
            cbArgs = cbArgs + arg.size
            args.append(arg)
        end
        new(
            method_info,
            isEventSink,
            name,
            names,
            invkind,
            arg_defs,
            ret_def,
            dispid,
            cbArgs,
            args,
            _gw_in_args,
            _gw_out_args,
        )
    end
end
function _GenerateInArgTuple(self::AbstractMethod)::Tuple
    l = []
    for arg in self.args
        if arg.inOut & pythoncom.PARAMFLAG_FIN || arg.inOut == 0
            push!(l, (arg.vt, arg.offset, arg.size))
        end
    end
    return tuple(l)
end

function _GenerateOutArgTuple(self::AbstractMethod)::Tuple
    l = []
    for arg in self.args
        if arg.inOut & pythoncom.PARAMFLAG_FOUT ||
           arg.inOut & pythoncom.PARAMFLAG_FRETVAL ||
           arg.inOut == 0
            push!(l, (arg.vt, arg.offset, arg.size, arg.clsid))
        end
    end
    return tuple(l)
end

mutable struct Definition <: AbstractDefinition
    _iid
    _methods::Vector
    _is_dispatch

    Definition(iid, is_dispatch, method_defs, _methods = []) = begin
        for info in method_defs
            entry = Method(info)
            _methods.append(entry)
        end
        new(iid, is_dispatch, method_defs, _methods)
    end
end
function iid(self::AbstractDefinition)
    return self._iid
end

function vtbl_argsizes(self::AbstractDefinition)
    return [m.cbArgs for m in self._methods]
end

function vtbl_argcounts(self::AbstractDefinition)
    return [length(m.args) for m in self._methods]
end

function dispatch(
    self::AbstractDefinition,
    ob,
    index,
    argPtr,
    ReadFromInTuple = _univgw.ReadFromInTuple,
    WriteFromOutTuple = _univgw.WriteFromOutTuple,
)::Int64
    #= Dispatch a call to an interface method. =#
    meth = self._methods[index+1]
    hr = 0
    args = ReadFromInTuple(meth._gw_in_args, argPtr)
    ob = (hasfield(typeof(ob), :policy) ? getfield(ob, :policy) : ob)
    ob._dispid_to_func_[meth.dispid+1] = meth.name
    retVal = _InvokeEx_(ob, meth.dispid, 0, meth.invkind, args, nothing, nothing)
    if type_(retVal) == tuple
        if length(retVal) == (length(meth._gw_out_args) + 1)
            hr = retVal[1]
            retVal = retVal[2:end]
        else
            throw(
                TypeError(
                    "Expected $(length(meth._gw_out_args) + 1) return values, got: $(length(retVal))",
                ),
            )
        end
    else
        retVal = [retVal]
        append!(retVal, repeat([nothing], (length(meth._gw_out_args) - 1)))
        retVal = tuple(retVal)
    end
    WriteFromOutTuple(retVal, meth._gw_out_args, argPtr)
    return hr
end
