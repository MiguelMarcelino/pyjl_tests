#= genpy.py - The worker for makepy.  See makepy.py for more details

This code was moved simply to speed Python in normal circumstances.  As the makepy.py
is normally run from the command line, it reparses the code each time.  Now makepy
is nothing more than the command line handler and public interface.

The makepy command line etc handling is also getting large enough in its own right!
 =#
using Dates
using OrderedCollections

import win32com_
using ext_modules: pythoncom
include("build.jl")
abstract type AbstractWritableItem end
abstract type AbstractRecordItem <: build.OleItem end
abstract type AbstractAliasItem <: build.OleItem end
abstract type AbstractEnumerationItem <: build.OleItem end
abstract type AbstractVTableItem <: build.VTableItem end
abstract type AbstractDispatchItem <: build.DispatchItem end
abstract type AbstractCoClassItem <: build.OleItem end
abstract type AbstractGeneratorProgress end
abstract type AbstractGenerator end
error = "makepy.error"
makepy_version = "0.5.01"
GEN_FULL = "full"
GEN_DEMAND_BASE = "demand(base)"
GEN_DEMAND_CHILD = "demand(child)"
mapVTToTypeString = Dict(
    pythoncom.VT_I2 => "types.IntType",
    pythoncom.VT_I4 => "types.IntType",
    pythoncom.VT_R4 => "types.FloatType",
    pythoncom.VT_R8 => "types.FloatType",
    pythoncom.VT_BSTR => "types.StringType",
    pythoncom.VT_BOOL => "types.IntType",
    pythoncom.VT_VARIANT => "types.TypeType",
    pythoncom.VT_I1 => "types.IntType",
    pythoncom.VT_UI1 => "types.IntType",
    pythoncom.VT_UI2 => "types.IntType",
    pythoncom.VT_UI4 => "types.IntType",
    pythoncom.VT_I8 => "types.LongType",
    pythoncom.VT_UI8 => "types.LongType",
    pythoncom.VT_INT => "types.IntType",
    pythoncom.VT_DATE => "pythoncom.PyTimeType",
    pythoncom.VT_UINT => "types.IntType",
)
function MakeDefaultArgsForPropertyPut(argsDesc)::Tuple
    ret = []
    for desc in argsDesc[2:end]
        default = build.MakeDefaultArgRepr(desc)
        if default === nothing
            break
        end
        push!(ret, default)
    end
    return tuple(ret)
end

function MakeMapLineEntry(dispid, wFlags, retType, argTypes, user, resultCLSID)
    argTypes = tuple([what[begin:2] for what in argTypes])
    return "($(dispid), $(wFlags), $(retType[begin:2]), $(argTypes), \"$(user)\", $(resultCLSID))"
end

function MakeEventMethodName(eventName)::String
    if eventName[begin:2] == "On"
        return eventName
    else
        return "On" + eventName
    end
end

function WriteSinkEventMap(obj, stream)
    write(stream, "\t_dispid_to_func_ = {")
    for (name, entry) in append!(
        append!(collect(items(obj.propMapGet)), collect(items(obj.propMapPut))),
        collect(items(obj.mapFuncs)),
    )
        fdesc = entry.desc
        write(stream, "\t\t$(fdesc.memid)d : \"$(MakeEventMethodName(entry.names[1]))\",")
    end
    write(stream, "\t\t}")
end

mutable struct WritableItem <: AbstractWritableItem
    doc
    order
end
function __cmp__(self::AbstractWritableItem, other)
    #= Compare for sorting =#
    ret = cmp(self.order, other.order)
    if ret == 0 && self.doc
        ret = cmp(self.doc[1], other.doc[1])
    end
    return ret
end

function __lt__(self::AbstractWritableItem, other)::Bool
    if self.order == other.order
        return self.doc < other.doc
    end
    return self.order < other.order
end

function __repr__(self::AbstractWritableItem)
    return "OleItem: doc=$(repr(self.doc)), order=$(self.order)"
end

mutable struct RecordItem <: build.OleItem
    clsid
    bForUser::Int64
    doc
    order::Int64
    typename::String

    RecordItem(typeInfo, typeAttr, doc = nothing, bForUser = 1, clsid = typeAttr[1]) = begin
        build.OleItem.__init__(self, doc)
        new(typeInfo, typeAttr, doc, bForUser, clsid)
    end
end
function WriteClass(self::AbstractRecordItem, generator)
    #= pass =#
end

function WriteAliasesForItem(item, aliasItems, stream)
    for alias in values(aliasItems)
        if item.doc && alias.aliasDoc && alias.aliasDoc[1] == item.doc[1]
            WriteAliasItem(alias, aliasItems, stream)
        end
    end
end

mutable struct AliasItem <: build.OleItem
    aliasAttr
    aliasDoc
    attr
    bWritten::Int64
    bForUser::Int64
    doc
    order::Int64
    typename::String

    AliasItem(typeinfo, attr, doc = nothing, bForUser = 1, ai = attr[15]) = begin
        build.OleItem.__init__(self, doc)
        if type_(ai) == type_(()) && type_(ai[2]) == type_(0)
            href = ai[2]
            alinfo = typeinfo.GetRefTypeInfo(href)
            aliasDoc = alinfo.GetDocumentation(-1)
            aliasAttr = alinfo.GetTypeAttr()
        else
            aliasDoc = nothing
            aliasAttr = nothing
        end
        new(typeinfo, attr, doc, bForUser, ai)
    end
end
function WriteAliasItem(self::AbstractAliasItem, aliasDict, stream)
    if self.bWritten
        return
    end
    if self.aliasDoc
        depName = self.aliasDoc[1]
        if depName ∈ aliasDict
            WriteAliasItem(aliasDict[depName+1], aliasDict, stream)
        end
        write(stream, "$(self.doc[1]) = $(depName)")
    else
        ai = self.attr[15]
        if type_(ai) == type_(0)
            try
                typeStr = mapVTToTypeString[ai]
                write(stream, "# $(self.doc[1])=$(typeStr)")
            catch exn
                if exn isa KeyError
                    write(
                        stream,
                        "$(self.doc[1]) = None # Can\'t convert alias info $(string(ai))",
                    )
                end
            end
        end
    end
    write(stream, "")
    self.bWritten = 1
end

mutable struct EnumerationItem <: build.OleItem
    clsid
    hidden
    mapVars::Dict
    bForUser::Int64
    doc
    order::Int64
    typename::String

    EnumerationItem(
        typeinfo,
        attr,
        doc = nothing,
        bForUser = 1,
        clsid = attr[1],
        mapVars = Dict(),
        typeFlags = attr[12],
        hidden = typeFlags & pythoncom.TYPEFLAG_FHIDDEN ||
                 typeFlags & pythoncom.TYPEFLAG_FRESTRICTED,
    ) = begin
        build.OleItem.__init__(self, doc)
        for j = 0:attr[8]-1
            vdesc = typeinfo.GetVarDesc(j)
            name = typeinfo.GetNames(vdesc[1])[1]
            mapVars[name] = build.MapEntry(vdesc)
        end
        new(typeinfo, attr, doc, bForUser, clsid, mapVars, typeFlags, hidden)
    end
end
function WriteEnumerationItems(self::AbstractEnumerationItem, stream)::Int64
    num = 0
    enumName = self.doc[1]
    names = collect(keys(self.mapVars))
    sort(names)
    for name in names
        entry = self.mapVars[name]
        vdesc = entry.desc
        if vdesc[5] == pythoncom.VAR_CONST
            val = vdesc[2]
            use = repr(val)
            try
                compile(use, "<makepy>", "eval")
            catch exn
                if exn isa SyntaxError
                    use = replace(use, "\"", "\'")
                    use =
                        ("\"" + use) *
                        "\"" *
                        " # This VARIANT type cannot be converted automatically"
                end
            end
            write(
                stream,
                "\t$(build.MakePublicAttributeName(name, true))s=$(use)s # from enum $(enumName)",
            )
            num += 1
        end
    end
    return num
end

mutable struct VTableItem <: build.VTableItem
    bIsDispatch
    bWritten::Int64
    python_name
    vtableFuncs
    order::Int64
end
function WriteClass(self::AbstractVTableItem, generator)
    WriteVTableMap(self, generator)
    self.bWritten = 1
end

function WriteVTableMap(self::AbstractVTableItem, generator)
    stream = generator.file
    write(stream, "$(self.python_name)_vtables_dispatch_ = $(self.bIsDispatch)")
    write(stream, "$(self.python_name)_vtables_ = [")
    for v in self.vtableFuncs
        names, dispid, desc = v
        @assert(desc.desckind == pythoncom.DESCKIND_FUNCDESC)
        arg_reprs = []
        item_num = 0
        write(stream, "\t((")
        for name in names
            write(stream, "$(repr(name)) ,")
            item_num = item_num + 1
            if (item_num % 5) == 0
                write(stream, "\n\t\t\t")
            end
        end
        write(stream, "), $(dispid), ($(desc.memid), $(desc.scodeArray), [")
        for arg in desc.args
            item_num = item_num + 1
            if (item_num % 5) == 0
                write(stream, "\n\t\t\t")
            end
            defval = build.MakeDefaultArgRepr(arg)
            if arg[4] === nothing
                arg3_repr = nothing
            else
                arg3_repr = repr(arg[4])
            end
            write(stream, "$(repr((arg[1], arg[2], defval, arg3_repr))) ,")
        end
        write(stream, "],")
        write(stream, "$(repr(desc.funckind)) ,")
        write(stream, "$(repr(desc.invkind)) ,")
        write(stream, "$(repr(desc.callconv)) ,")
        write(stream, "$(repr(desc.cParamsOpt)) ,")
        write(stream, "$(repr(desc.oVft)) ,")
        write(stream, "$(repr(desc.rettype)) ,")
        write(stream, "$(repr(desc.wFuncFlags)) ,")
        write(stream, ")),")
    end
    write(stream, "]")
    write(stream, "")
end

mutable struct DispatchItem <: build.DispatchItem
    bIsDispatch
    bIsSink
    bWritten::Int64
    clsid
    coclass_clsid
    mapFuncs
    python_name
    type_attr
    doc
    order::Int64

    DispatchItem(typeinfo, attr, doc = nothing, coclass_clsid = nothing) = begin
        build.DispatchItem.__init__(self, typeinfo, attr, doc)
        new(typeinfo, attr, doc, coclass_clsid)
    end
end
function WriteClass(self::AbstractDispatchItem, generator)
    if !(self.bIsDispatch) && !(self.type_attr.typekind == pythoncom.TKIND_DISPATCH)
        return
    end
    if self.bIsSink
        WriteEventSinkClassHeader(self, generator)
        WriteCallbackClassBody(self, generator)
    else
        WriteClassHeader(self, generator)
        WriteClassBody(self, generator)
    end
    write(generator.file, "")
    self.bWritten = 1
end

function WriteClassHeader(self::AbstractDispatchItem, generator)
    checkWriteDispatchBaseClass(generator)
    doc = self.doc
    stream = generator.file
    write(stream, "class $(self.python_name)(DispatchBaseClass):")
    if doc[2]
        write(stream, "\t$(build._makeDocString(doc[2]))")
    end
    try
        progId = pythoncom.ProgIDFromCLSID(self.clsid)
        write(stream, "\t# This class is creatable by the name \'$(progId)\'")
    catch exn
        if exn isa pythoncom.com_error
            #= pass =#
        end
    end
    write(stream, "\tCLSID = $(repr(self.clsid))")
    if self.coclass_clsid === nothing
        write(stream, "\tcoclass_clsid = None")
    else
        write(stream, "\tcoclass_clsid = $(repr(self.coclass_clsid))")
    end
    write(stream, "")
    self.bWritten = 1
end

function WriteEventSinkClassHeader(self::AbstractDispatchItem, generator)
    checkWriteEventBaseClass(generator)
    doc = self.doc
    stream = generator.file
    write(stream, "class $(self.python_name):")
    if doc[2]
        write(stream, "\t$(build._makeDocString(doc[2]))")
    end
    try
        progId = pythoncom.ProgIDFromCLSID(self.clsid)
        write(stream, "\t# This class is creatable by the name \'$(progId)\'")
    catch exn
        if exn isa pythoncom.com_error
            #= pass =#
        end
    end
    write(stream, "\tCLSID = CLSID_Sink = $(repr(self.clsid))")
    if self.coclass_clsid === nothing
        write(stream, "\tcoclass_clsid = None")
    else
        write(stream, "\tcoclass_clsid = $(repr(self.coclass_clsid))")
    end
    write(stream, "\t_public_methods_ = [] # For COM Server support")
    WriteSinkEventMap(self, stream)
    write(stream, "")
    write(stream, "\tdef __init__(self, oobj = None):")
    write(stream, "\t\tif oobj is None:")
    write(stream, "\t\t\tself._olecp = None")
    write(stream, "\t\telse:")
    write(stream, "\t\t\timport win32com_.server.util")
    write(stream, "\t\t\tfrom win32com_.server.policy import EventHandlerPolicy")
    write(
        stream,
        "\t\t\tcpc=oobj._oleobj_.QueryInterface(pythoncom.IID_IConnectionPointContainer)",
    )
    write(stream, "\t\t\tcp=cpc.FindConnectionPoint(self.CLSID_Sink)")
    write(
        stream,
        "\t\t\tcookie=cp.Advise(win32com_.server.util.wrap(self, usePolicy=EventHandlerPolicy))",
    )
    write(stream, "\t\t\tself._olecp,self._olecp_cookie = cp,cookie")
    write(stream, "\tdef __del__(self):")
    write(stream, "\t\ttry:")
    write(stream, "\t\t\tself.close()")
    write(stream, "\t\texcept pythoncom.com_error:")
    write(stream, "\t\t\tpass")
    write(stream, "\tdef close(self):")
    write(stream, "\t\tif self._olecp is not None:")
    write(
        stream,
        "\t\t\tcp,cookie,self._olecp,self._olecp_cookie = self._olecp,self._olecp_cookie,None,None",
    )
    write(stream, "\t\t\tcp.Unadvise(cookie)")
    write(stream, "\tdef _query_interface_(self, iid):")
    write(stream, "\t\timport win32com_.server.util")
    write(stream, "\t\tif iid==self.CLSID_Sink: return win32com_.server.util.wrap(self)")
    write(stream, "")
    self.bWritten = 1
end

function WriteCallbackClassBody(self::AbstractDispatchItem, generator)
    stream = generator.file
    write(stream, "\t# Event Handlers")
    write(stream, "\t# If you create handlers, they should have the following prototypes:")
    for (name, entry) in append!(
        append!(collect(items(self.propMapGet)), collect(items(self.propMapPut))),
        collect(items(self.mapFuncs)),
    )
        fdesc = entry.desc
        methName = MakeEventMethodName(entry.names[1])
        write(
            stream,
            "#\tdef $(methName)(self$(build.BuildCallList(fdesc, entry.names, "defaultNamedOptArg", "defaultNamedNotOptArg", "defaultUnnamedArg", "pythoncom.Missing", is_comment = true))):",
        )
        if entry.doc && entry.doc[2]
            write(stream, "#\t\t$(build._makeDocString(entry.doc[2]))")
        end
    end
    write(stream, "")
    self.bWritten = 1
end

function WriteClassBody(self::AbstractDispatchItem, generator)
    stream = generator.file
    names = collect(keys(self.mapFuncs))
    sort(names)
    specialItems = Dict(
        "count" => nothing,
        "item" => nothing,
        "value" => nothing,
        "_newenum" => nothing,
    )
    itemCount = nothing
    for name in names
        entry = self.mapFuncs[name+1]
        @assert(entry.desc.desckind == pythoncom.DESCKIND_FUNCDESC)
        dispid = entry.desc.memid
        if entry.desc.wFuncFlags & pythoncom.FUNCFLAG_FRESTRICTED &&
           dispid != pythoncom.DISPID_NEWENUM
            continue
        end
        if entry.desc.funckind != pythoncom.FUNC_DISPATCH
            continue
        end
        if dispid == pythoncom.DISPID_VALUE
            lkey = "value"
        elseif dispid == pythoncom.DISPID_NEWENUM
            specialItems["_newenum"] = (entry, entry.desc.invkind, nothing)
            continue
        else
            lkey = lower(name)
        end
        if lkey ∈ keys(specialItems) && specialItems[lkey] === nothing
            specialItems[lkey] = (entry, entry.desc.invkind, nothing)
        end
        if generator.bBuildHidden || !(entry.hidden)
            if GetResultName(entry)
                write(stream, "\t# Result is of type $(GetResultName(entry))")
            end
            if entry.wasProperty
                write(
                    stream,
                    "\t# The method $(name) is actually a property, but must be used as a method to correctly pass the arguments",
                )
            end
            ret = MakeFuncMethod(self, entry, build.MakePublicAttributeName(name))
            for line in ret
                write(stream, "$(line)")
            end
        end
    end
    write(stream, "\t_prop_map_get_ = {")
    names = collect(keys(self.propMap))
    sort(names)
    for key in names
        entry = self.propMap[key+1]
        if generator.bBuildHidden || !(entry.hidden)
            resultName = GetResultName(entry)
            if resultName
                write(
                    stream,
                    "\t\t# Property \'$(key)\' is an object of type \'$(resultName)\'",
                )
            end
            lkey = lower(key)
            details = entry.desc
            resultDesc = details[3]
            argDesc = ()
            mapEntry = MakeMapLineEntry(
                details.memid,
                pythoncom.DISPATCH_PROPERTYGET,
                resultDesc,
                argDesc,
                key,
                GetResultCLSIDStr(entry),
            )
            if details.memid == pythoncom.DISPID_VALUE
                lkey = "value"
            elseif details.memid == pythoncom.DISPID_NEWENUM
                lkey = "_newenum"
            else
                lkey = lower(key)
            end
            if lkey ∈ keys(specialItems) && specialItems[lkey] === nothing
                specialItems[lkey] = (entry, pythoncom.DISPATCH_PROPERTYGET, mapEntry)
                if details.memid == pythoncom.DISPID_NEWENUM
                    continue
                end
            end
            write(stream, "\t\t\"$(build.MakePublicAttributeName(key))\": $(mapEntry),")
        end
    end
    names = collect(keys(self.propMapGet))
    sort(names)
    for key in names
        entry = self.propMapGet[key+1]
        if generator.bBuildHidden || !(entry.hidden)
            if GetResultName(entry)
                write(
                    stream,
                    "\t\t# Method \'$(key)\' returns object of type \'$(GetResultName(entry))\'",
                )
            end
            details = entry.desc
            @assert(details.desckind == pythoncom.DESCKIND_FUNCDESC)
            lkey = lower(key)
            argDesc = details[3]
            resultDesc = details[9]
            mapEntry = MakeMapLineEntry(
                details[1],
                pythoncom.DISPATCH_PROPERTYGET,
                resultDesc,
                argDesc,
                key,
                GetResultCLSIDStr(entry),
            )
            if details.memid == pythoncom.DISPID_VALUE
                lkey = "value"
            elseif details.memid == pythoncom.DISPID_NEWENUM
                lkey = "_newenum"
            else
                lkey = lower(key)
            end
            if lkey ∈ keys(specialItems) && specialItems[lkey] === nothing
                specialItems[lkey] = (entry, pythoncom.DISPATCH_PROPERTYGET, mapEntry)
                if details.memid == pythoncom.DISPID_NEWENUM
                    continue
                end
            end
            write(stream, "\t\t\"$(build.MakePublicAttributeName(key))\": $(mapEntry),")
        end
    end
    write(stream, "\t}")
    write(stream, "\t_prop_map_put_ = {")
    names = collect(keys(self.propMap))
    sort(names)
    for key in names
        entry = self.propMap[key+1]
        if generator.bBuildHidden || !(entry.hidden)
            lkey = lower(key)
            details = entry.desc
            defArgDesc = build.MakeDefaultArgRepr(details[3])
            if defArgDesc === nothing
                defArgDesc = ""
            else
                defArgDesc = defArgDesc * ","
            end
            write(
                stream,
                "\t\t\"$(build.MakePublicAttributeName(key))\" : (($(details[1]), LCID, $(pythoncom.DISPATCH_PROPERTYPUT), 0),($(defArgDesc))),",
            )
        end
    end
    names = collect(keys(self.propMapPut))
    sort(names)
    for key in names
        entry = self.propMapPut[key+1]
        if generator.bBuildHidden || !(entry.hidden)
            details = entry.desc
            defArgDesc = MakeDefaultArgsForPropertyPut(details[3])
            write(
                stream,
                "\t\t\"$(build.MakePublicAttributeName(key))\": (($(details[1]), LCID, $(details[5]), 0),$(defArgDesc)),",
            )
        end
    end
    write(stream, "\t}")
    if specialItems["value"]
        entry, invoketype, propArgs = specialItems["value"]
        if propArgs === nothing
            typename = "method"
            ret = MakeFuncMethod(self, entry, "__call__")
        else
            typename = "property"
            ret = ["\tdef __call__(self):\n\t\treturn self._ApplyTypes_(*$(propArgs))"]
        end
        write(stream, "\t# Default $(typename) for this class is \'$(entry.names[1])\'")
        for line in ret
            write(stream, "$(line)")
        end
        write(stream, "\tdef __str__(self, *args):")
        write(stream, "\t\treturn str(self.__call__(*args))")
        write(stream, "\tdef __int__(self, *args):")
        write(stream, "\t\treturn int(self.__call__(*args))")
    end
    if specialItems["_newenum"]
        enumEntry, invoketype, propArgs = specialItems["_newenum"]
        @assert(enumEntry.desc.desckind == pythoncom.DESCKIND_FUNCDESC)
        invkind = enumEntry.desc.invkind
        resultCLSID = GetResultCLSIDStr(enumEntry)
    else
        invkind = pythoncom.DISPATCH_METHOD | pythoncom.DISPATCH_PROPERTYGET
        resultCLSID = "None"
    end
    if resultCLSID == "None" && "Item" ∈ self.mapFuncs
        resultCLSID = GetResultCLSIDStr(self.mapFuncs["Item"])
    end
    write(stream, "\tdef __iter__(self):")
    write(stream, "\t\t\"Return a Python iterator for this object\"")
    write(stream, "\t\ttry:")
    write(
        stream,
        "\t\t\tob = self._oleobj_.InvokeTypes($(pythoncom.DISPID_NEWENUM),LCID,$(invkind),(13, 10),())",
    )
    write(stream, "\t\texcept pythoncom.error:")
    write(stream, "\t\t\traise TypeError(\"This object does not support enumeration\")")
    write(stream, "\t\treturn win32com_.client.util.Iterator(ob, $(resultCLSID))")
    if specialItems["item"]
        entry, invoketype, propArgs = specialItems["item"]
        resultCLSID = GetResultCLSIDStr(entry)
        write(
            stream,
            "\t#This class has Item property/method which allows indexed access with the object[key] syntax.",
        )
        write(
            stream,
            "\t#Some objects will accept a string or other type of key in addition to integers.",
        )
        write(stream, "\t#Note that many Office objects do not use zero-based indexing.")
        write(stream, "\tdef __getitem__(self, key):")
        write(
            stream,
            "\t\treturn self._get_good_object_(self._oleobj_.Invoke(*($(entry.desc.memid), LCID, $(invoketype), 1, key)), \"Item\", $(resultCLSID))",
        )
    end
    if specialItems["count"]
        entry, invoketype, propArgs = specialItems["count"]
        if propArgs === nothing
            typename = "method"
            ret = MakeFuncMethod(self, entry, "__len__")
        else
            typename = "property"
            ret = ["\tdef __len__(self):\n\t\treturn self._ApplyTypes_(*$(propArgs))"]
        end
        write(
            stream,
            "\t#This class has Count() $(typename) - allow len(ob) to provide this",
        )
        for line in ret
            write(stream, "$(line)")
        end
        write(
            stream,
            "\t#This class has a __len__ - this is needed so \'if object:\' always returns TRUE.",
        )
        write(stream, "\tdef __nonzero__(self):")
        write(stream, "\t\treturn True")
    end
end

mutable struct CoClassItem <: build.OleItem
    bIsDispatch::Int64
    bWritten::Int64
    clsid
    interfaces
    python_name
    sources
    bForUser::Int64
    doc
    order::Int64
    typename::String

    CoClassItem(
        typeinfo,
        attr,
        doc = nothing,
        sources = [],
        interfaces = [],
        bForUser = 1,
        clsid = attr[1],
        bIsDispatch = 1,
    ) = begin
        build.OleItem.__init__(self, doc)
        new(typeinfo, attr, doc, sources, interfaces, bForUser, clsid, bIsDispatch)
    end
end
function WriteClass(self::AbstractCoClassItem, generator)
    checkWriteCoClassBaseClass(generator)
    doc = self.doc
    stream = generator.file
    if generator.generate_type == GEN_DEMAND_CHILD
        referenced_items = []
        for (ref, flag) in self.sources
            push!(referenced_items, ref)
        end
        for (ref, flag) in self.interfaces
            push!(referenced_items, ref)
        end
        write(stream, "import sys")
        for ref in referenced_items
            write(stream, "__import__(\'$(generator.base_mod_name).$(ref.python_name)\')")
            write(
                stream,
                "$(ref.python_name) = sys.modules[\'$(generator.base_mod_name).$(ref.python_name)\'].$(ref.python_name)",
            )
            ref.bWritten = 1
        end
    end
    try
        progId = pythoncom.ProgIDFromCLSID(self.clsid)
        write(stream, "# This CoClass is known by the name \'$(progId)\'")
    catch exn
        if exn isa pythoncom.com_error
            #= pass =#
        end
    end
    write(stream, "class $(self.python_name)(CoClassBaseClass): # A CoClass")
    if doc && doc[2]
        write(stream, "\t# $(doc[2])")
    end
    write(stream, "\tCLSID = $(self.clsid)")
    write(stream, "\tcoclass_sources = [")
    defItem = nothing
    for (item, flag) in self.sources
        if flag & pythoncom.IMPLTYPEFLAG_FDEFAULT
            defItem = item
        end
        if item.bWritten
            key = item.python_name
        else
            key = repr(string(item.clsid))
        end
        write(stream, "\t\t$(key),")
    end
    write(stream, "\t]")
    if defItem
        if defItem.bWritten
            defName = defItem.python_name
        else
            defName = repr(string(defItem.clsid))
        end
        write(stream, "\tdefault_source = $(defName)")
    end
    write(stream, "\tcoclass_interfaces = [")
    defItem = nothing
    for (item, flag) in self.interfaces
        if flag & pythoncom.IMPLTYPEFLAG_FDEFAULT
            defItem = item
        end
        if item.bWritten
            key = item.python_name
        else
            key = repr(string(item.clsid))
        end
        write(stream, "\t\t$(key),")
    end
    write(stream, "\t]")
    if defItem
        if defItem.bWritten
            defName = defItem.python_name
        else
            defName = repr(string(defItem.clsid))
        end
        write(stream, "\tdefault_interface = $(defName)")
    end
    self.bWritten = 1
    write(stream, "")
end

mutable struct GeneratorProgress <: AbstractGeneratorProgress
    tlb_desc

    GeneratorProgress() = begin
        #= pass =#
        new()
    end
end
function Starting(self::AbstractGeneratorProgress, tlb_desc)
    #= Called when the process starts. =#
    self.tlb_desc = tlb_desc
end

function Finished(self::AbstractGeneratorProgress)
    #= Called when the process is complete. =#
end

function SetDescription(self::AbstractGeneratorProgress, desc, maxticks = nothing)
    #= We are entering a major step.  If maxticks, then this
            is how many ticks we expect to make until finished
             =#
end

function Tick(self::AbstractGeneratorProgress, desc = nothing)
    #= Minor progress step.  Can provide new description if necessary =#
end

function VerboseProgress(self::AbstractGeneratorProgress, desc)
    #= Verbose/Debugging output. =#
end

function LogWarning(self::AbstractGeneratorProgress, desc)
    #= If a warning is generated =#
end

function LogBeginGenerate(self::AbstractGeneratorProgress, filename)
    #= pass =#
end

function Close(self::AbstractGeneratorProgress)
    #= pass =#
end

mutable struct Generator <: AbstractGenerator
    bBuildHidden
    bHaveWrittenCoClassBaseClass::Int64
    bHaveWrittenDispatchBaseClass::Int64
    bHaveWrittenEventBaseClass::Int64
    base_mod_name
    file
    generate_type::String
    progress
    sourceFilename
    typelib
    bUnicodeToString

    Generator(
        typelib,
        sourceFilename,
        progressObject,
        bBuildHidden = 1,
        bUnicodeToString = nothing,
        bHaveWrittenDispatchBaseClass = 0,
        bHaveWrittenCoClassBaseClass = 0,
        bHaveWrittenEventBaseClass = 0,
        file = nothing,
    ) = begin
        @assert(bUnicodeToString === nothing)
        new(
            typelib,
            sourceFilename,
            progressObject,
            bBuildHidden,
            bUnicodeToString,
            bHaveWrittenDispatchBaseClass,
            bHaveWrittenCoClassBaseClass,
            bHaveWrittenEventBaseClass,
            file,
        )
    end
end
function CollectOleItemInfosFromType(self::AbstractGenerator)::Vector
    ret = []
    for i = 0:GetTypeInfoCount(self.typelib)-1
        info = GetTypeInfo(self.typelib, i)
        infotype = GetTypeInfoType(self.typelib, i)
        doc = GetDocumentation(self.typelib, i)
        attr = GetTypeAttr(info)
        push!(ret, (info, infotype, doc, attr))
    end
    return ret
end

function _Build_CoClass(self::AbstractGenerator, type_info_tuple)
    info, infotype, doc, attr = type_info_tuple
    child_infos = []
    for j = 0:attr[9]-1
        flags = GetImplTypeFlags(info, j)
        try
            refType = GetRefTypeInfo(info, GetRefTypeOfImplType(info, j))
        catch exn
            if exn isa pythoncom.com_error
                continue
            end
        end
        refAttr = GetTypeAttr(refType)
        push!(
            child_infos,
            (
                info,
                refAttr.typekind,
                refType,
                GetDocumentation(refType, -1),
                refAttr,
                flags,
            ),
        )
    end
    newItem = CoClassItem(info, attr, doc)
    return (newItem, child_infos)
end

function _Build_CoClassChildren(
    self::AbstractGenerator,
    coclass,
    coclass_info,
    oleItems,
    vtableItems,
)
    sources = Dict()
    interfaces = Dict()
    for (info, info_type, refType, doc, refAttr, flags) in coclass_info
        if refAttr.typekind == pythoncom.TKIND_DISPATCH ||
           refAttr.typekind == pythoncom.TKIND_INTERFACE &&
           refAttr[12] & pythoncom.TYPEFLAG_FDISPATCHABLE
            clsid = refAttr[1]
            if clsid ∈ oleItems
                dispItem = oleItems[clsid+1]
            else
                dispItem = DispatchItem(refType, refAttr, doc)
                oleItems[dispItem.clsid+1] = dispItem
            end
            dispItem.coclass_clsid = coclass.clsid
            if flags & pythoncom.IMPLTYPEFLAG_FSOURCE
                dispItem.bIsSink = 1
                sources[dispItem.clsid] = (dispItem, flags)
            else
                interfaces[dispItem.clsid] = (dispItem, flags)
            end
            if clsid ∉ vtableItems && refAttr[12] & pythoncom.TYPEFLAG_FDUAL
                refType = GetRefTypeInfo(refType, GetRefTypeOfImplType(refType, -1))
                refAttr = GetTypeAttr(refType)
                @assert(refAttr.typekind == pythoncom.TKIND_INTERFACE)
                vtableItem = VTableItem(refType, refAttr, doc)
                vtableItems[clsid+1] = vtableItem
            end
        end
    end
    coclass.sources = collect(values(sources))
    coclass.interfaces = collect(values(interfaces))
end

function _Build_Interface(self::AbstractGenerator, type_info_tuple)::Tuple
    info, infotype, doc, attr = type_info_tuple
    oleItem = nothing
    vtableItem = nothing
    if infotype == pythoncom.TKIND_DISPATCH ||
       infotype == pythoncom.TKIND_INTERFACE && attr[12] & pythoncom.TYPEFLAG_FDISPATCHABLE
        oleItem = DispatchItem(info, attr, doc)
        if attr.wTypeFlags & pythoncom.TYPEFLAG_FDUAL
            refhtype = GetRefTypeOfImplType(info, -1)
            info = GetRefTypeInfo(info, refhtype)
            attr = GetTypeAttr(info)
            infotype = pythoncom.TKIND_INTERFACE
        else
            infotype = nothing
        end
    end
    @assert(infotype ∈ [nothing, pythoncom.TKIND_INTERFACE])
    if infotype == pythoncom.TKIND_INTERFACE
        vtableItem = VTableItem(info, attr, doc)
    end
    return (oleItem, vtableItem)
end

function BuildOleItemsFromType(self::AbstractGenerator)
    @assert(self.bBuildHidden)
    oleItems = OrderedDict()
    enumItems = Dict()
    recordItems = OrderedDict()
    vtableItems = OrderedDict()
    for type_info_tuple in CollectOleItemInfosFromType(self)
        info, infotype, doc, attr = type_info_tuple
        clsid = attr[1]
        if infotype == pythoncom.TKIND_ENUM || infotype == pythoncom.TKIND_MODULE
            newItem = EnumerationItem(info, attr, doc)
            enumItems[newItem.doc[1]] = newItem
        elseif infotype ∈ [pythoncom.TKIND_DISPATCH, pythoncom.TKIND_INTERFACE]
            if clsid ∉ oleItems
                oleItem, vtableItem = _Build_Interface(self, type_info_tuple)
                oleItems[clsid] = oleItem
                if vtableItem !== nothing
                    vtableItems[clsid] = vtableItem
                end
            end
        elseif infotype == pythoncom.TKIND_RECORD || infotype == pythoncom.TKIND_UNION
            newItem = RecordItem(info, attr, doc)
            recordItems[newItem.clsid] = newItem
        elseif infotype == pythoncom.TKIND_ALIAS
            continue
        elseif infotype == pythoncom.TKIND_COCLASS
            newItem, child_infos = _Build_CoClass(self, type_info_tuple)
            _Build_CoClassChildren(self, newItem, child_infos, oleItems, vtableItems)
            oleItems[newItem.clsid] = newItem
        else
            LogWarning(self.progress, "Unknown TKIND found: $(infotype)")
        end
    end
    return (oleItems, enumItems, recordItems, vtableItems)
end

function open_writer(self::AbstractGenerator, filename, encoding = "mbcs")
    temp_filename = get_temp_filename(self, filename)
    return readline(temp_filename)
end

function finish_writer(self::AbstractGenerator, filename, f, worked)
    close(f)
    try
        rm(filename)
    catch exn
        if exn isa os.error
            #= pass =#
        end
    end
    temp_filename = get_temp_filename(self, filename)
    if worked
        try
            os.rename(temp_filename, filename)
        catch exn
            if exn isa os.error
                try
                    rm(filename)
                catch exn
                    if exn isa os.error
                        #= pass =#
                    end
                end
                os.rename(temp_filename, filename)
            end
        end
    else
        rm(temp_filename)
    end
end

function get_temp_filename(self::AbstractGenerator, filename)
    return "$(filename).$(os.getpid()).temp"
end

function generate(self::AbstractGenerator, file, is_for_demand = 0)
    if is_for_demand
        self.generate_type = GEN_DEMAND_BASE
    else
        self.generate_type = GEN_FULL
    end
    self.file = file
    do_generate(self)
    self.file = nothing
    Finished(self.progress)
end

function do_gen_file_header(self::AbstractGenerator)
    la = GetLibAttr(self.typelib)
    moduleDoc = GetDocumentation(self.typelib, -1)
    docDesc = ""
    if moduleDoc[2]
        docDesc = moduleDoc[2]
    end
    self.bHaveWrittenDispatchBaseClass = 0
    self.bHaveWrittenCoClassBaseClass = 0
    self.bHaveWrittenEventBaseClass = 0
    @assert(self.file.encoding)
    encoding = self.file.encoding
    write(self.file, "# -*- coding: $(encoding) -*-")
    write(self.file, "# Created by makepy.py version $(makepy_version)")
    write(self.file, "# By python version $(replace(sys.version, "\n", "-"))")
    if self.sourceFilename
        write(self.file, "# From type library \'$(splitdir(self.sourceFilename)[2])\'")
    end
    write(
        self.file,
        "# On $(Dates.format(Dates.epochms2datetime(Dates.datetime2unix(Dates.now())()), Dates.RFC1123Format))",
    )
    write(self.file, "$(build._makeDocString(docDesc))")
    write(self.file, "makepy_version = $(repr(makepy_version))")
    write(self.file, "python_version = 0x$(sys.hexversion)")
    write(self.file, "")
    write(self.file, "import win32com_.client.CLSIDToClass, pythoncom, pywintypes")
    write(self.file, "import win32com_.client.util")
    write(self.file, "from pywintypes import IID")
    write(self.file, "from win32com_.client import Dispatch")
    write(self.file, "")
    write(self.file, "# The following 3 lines may need tweaking for the particular server")
    write(self.file, "# Candidates are pythoncom.Missing, .Empty and .ArgNotFound")
    write(self.file, "defaultNamedOptArg=pythoncom.Empty")
    write(self.file, "defaultNamedNotOptArg=pythoncom.Empty")
    write(self.file, "defaultUnnamedArg=pythoncom.Empty")
    write(self.file, "")
    write(self.file, "CLSID = $(repr(la[1]))")
    write(self.file, "MajorVersion = $(string(la[4]))")
    write(self.file, "MinorVersion = $(string(la[5]))")
    write(self.file, "LibraryFlags = $(string(la[6]))")
    write(self.file, "LCID = $(hex(la[2]))")
    write(self.file, "")
end

function do_generate(self::AbstractGenerator)
    moduleDoc = GetDocumentation(self.typelib, -1)
    stream = self.file
    docDesc = ""
    if moduleDoc[2]
        docDesc = moduleDoc[2]
    end
    Starting(self.progress, docDesc)
    SetDescription(self.progress, "Building definitions from type library...")
    do_gen_file_header(self)
    oleItems, enumItems, recordItems, vtableItems = BuildOleItemsFromType(self)
    SetDescription(
        self.progress,
        "Generating...",
        (length(oleItems) + length(enumItems)) + length(vtableItems),
    )
    if enumItems
        write(stream, "class constants:")
        items = collect(values(enumItems))
        sort(items)
        num_written = 0
        for oleitem in items
            num_written += WriteEnumerationItems(oleitem, stream)
            Tick(self.progress)
        end
        if !(num_written) != 0
            write(stream, "\tpass")
        end
        write(stream, "")
    end
    if self.generate_type == GEN_FULL
        items = [l for l in values(oleItems) if l !== nothing]
        sort(items)
        for oleitem in items
            Tick(self.progress)
            WriteClass(oleitem, self)
        end
        items = collect(values(vtableItems))
        sort(items)
        for oleitem in items
            Tick(self.progress)
            WriteClass(oleitem, self)
        end
    else
        Tick(self.progress, length(oleItems) + length(vtableItems))
    end
    write(stream, "RecordMap = {")
    for record in values(recordItems)
        if record.clsid == pythoncom.IID_NULL
            write(
                stream,
                "\t###$(repr(record.doc[1])): $(repr(string(record.clsid))), # Record disabled because it doesn\'t have a non-null GUID",
            )
        else
            write(stream, "\t$(repr(record.doc[1])): $(repr(string(record.clsid))),")
        end
    end
    write(stream, "}")
    write(stream, "")
    if self.generate_type == GEN_FULL
        write(stream, "CLSIDToClassMap = {")
        for item in values(oleItems)
            if item !== nothing && item.bWritten
                write(stream, "\t\'$(string(item.clsid))\' : $(item.python_name),")
            end
        end
        write(stream, "}")
        write(stream, "CLSIDToPackageMap = {}")
        write(
            stream,
            "win32com_.client.CLSIDToClass.RegisterCLSIDsFromDict( CLSIDToClassMap )",
        )
        write(stream, "VTablesToPackageMap = {}")
        write(stream, "VTablesToClassMap = {")
        for item in values(vtableItems)
            write(stream, "\t\'$(item.clsid)\' : \'$(item.python_name)\',")
        end
        write(stream, "}")
        write(stream, "")
    else
        write(stream, "CLSIDToClassMap = {}")
        write(stream, "CLSIDToPackageMap = {")
        for item in values(oleItems)
            if item !== nothing
                write(stream, "\t\'$(string(item.clsid))\' : $(repr(item.python_name)),")
            end
        end
        write(stream, "}")
        write(stream, "VTablesToClassMap = {}")
        write(stream, "VTablesToPackageMap = {")
        for item in values(vtableItems)
            write(stream, "\t\'$(item.clsid)\' : \'$(item.python_name)\',")
        end
        write(stream, "}")
        write(stream, "")
    end
    write(stream, "")
    map = OrderedDict()
    for item in values(oleItems)
        if item !== nothing && !isa(item, CoClassItem)
            map[item.python_name] = item.clsid
        end
    end
    for item in values(vtableItems)
        map[item.python_name] = item.clsid
    end
    write(stream, "NamesToIIDMap = {")
    for (name, iid) in collect(map)
        write(stream, "\t\'$(name)\' : \'$(iid)\',")
    end
    write(stream, "}")
    write(stream, "")
    if enumItems
        write(stream, "win32com_.client.constants.__dicts__.append(constants.__dict__)")
    end
    write(stream, "")
end

function generate_child(self::AbstractGenerator, child, dir)
    #= Generate a single child.  May force a few children to be built as we generate deps =#
    self.generate_type = GEN_DEMAND_CHILD
    la = GetLibAttr(self.typelib)
    lcid = la[2]
    clsid = la[1]
    major = la[4]
    minor = la[5]
    self.base_mod_name =
        ("win32com_.gen_py." + string(clsid)[1:end-1]) + "x$(lcid)x$(major)x$(minor)"
    try
        oleItems = OrderedDict()
        vtableItems = OrderedDict()
        infos = CollectOleItemInfosFromType(self)
        found = 0
        for type_info_tuple in infos
            info, infotype, doc, attr = type_info_tuple
            if infotype == pythoncom.TKIND_COCLASS
                coClassItem, child_infos = _Build_CoClass(self, type_info_tuple)
                found = build.MakePublicAttributeName(doc[1]) == child
                if !(found)
                    for (info, info_type, refType, doc, refAttr, flags) in child_infos
                        if build.MakePublicAttributeName(doc[1]) == child
                            found = 1
                            break
                        end
                    end
                end
                if found
                    oleItems[coClassItem.clsid] = coClassItem
                    _Build_CoClassChildren(
                        self,
                        coClassItem,
                        child_infos,
                        oleItems,
                        vtableItems,
                    )
                    break
                end
            end
        end
        if !(found) != 0
            for type_info_tuple in infos
                info, infotype, doc, attr = type_info_tuple
                if infotype ∈ [pythoncom.TKIND_INTERFACE, pythoncom.TKIND_DISPATCH]
                    if build.MakePublicAttributeName(doc[1]) == child
                        found = 1
                        oleItem, vtableItem = _Build_Interface(self, type_info_tuple)
                        oleItems[clsid] = oleItem
                        if vtableItem !== nothing
                            vtableItems[clsid] = vtableItem
                        end
                    end
                end
            end
        end
        @assert(found)
        items = OrderedDict()
        for (key, value) in collect(oleItems)
            items[key] = (value, nothing)
        end
        for (key, value) in collect(vtableItems)
            existing = get(items, key, nothing)
            if existing !== nothing
                new_val = (existing[1], value)
            else
                new_val = (nothing, value)
            end
            items[key] = new_val
        end
        SetDescription(self.progress, "Generating...", length(items))
        for (oleitem, vtableitem) in values(items)
            an_item = oleitem || vtableitem
            @assert(!(self.file))
            out_name = joinpath(dir, an_item.python_name) + ".py"
            worked = false
            self.file = open_writer(self, out_name)
            try
                if oleitem !== nothing
                    do_gen_child_item(self, oleitem)
                end
                if vtableitem !== nothing
                    do_gen_child_item(self, vtableitem)
                end
                Tick(self.progress)
                worked = true
            finally
                finish_writer(self, out_name, self.file, worked)
                self.file = nothing
            end
        end
    finally
        Finished(self.progress)
    end
end

function do_gen_child_item(self::AbstractGenerator, oleitem)
    moduleDoc = GetDocumentation(self.typelib, -1)
    docDesc = ""
    if moduleDoc[2]
        docDesc = moduleDoc[2]
    end
    Starting(self.progress, docDesc)
    SetDescription(self.progress, "Building definitions from type library...")
    do_gen_file_header(self)
    WriteClass(oleitem, self)
    if oleitem.bWritten
        write(
            self.file,
            "win32com_.client.CLSIDToClass.RegisterCLSID( \"$(oleitem.clsid)\", $(oleitem.python_name) )",
        )
    end
end

function checkWriteDispatchBaseClass(self::AbstractGenerator)
    if !(self.bHaveWrittenDispatchBaseClass) != 0
        write(self.file, "from win32com_.client import DispatchBaseClass")
        self.bHaveWrittenDispatchBaseClass = 1
    end
end

function checkWriteCoClassBaseClass(self::AbstractGenerator)
    if !(self.bHaveWrittenCoClassBaseClass) != 0
        write(self.file, "from win32com_.client import CoClassBaseClass")
        self.bHaveWrittenCoClassBaseClass = 1
    end
end

function checkWriteEventBaseClass(self::AbstractGenerator)
    if !(self.bHaveWrittenEventBaseClass) != 0
        self.bHaveWrittenEventBaseClass = 1
    end
end

if abspath(PROGRAM_FILE) == @__FILE__
    println("This is a worker module.  Please use makepy to generate Python files.")
end
