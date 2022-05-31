#= Utility functions for writing out gateway C++ files

  This module will generate a C++/Python binding for a specific COM
  interface.

  At this stage, no command line interface exists.  You must start Python, 
  import this module,  change to the directory where the generated code should
  be written, and run the public function.

  This module is capable of generating both 'Interfaces' (ie, Python
  client side support for the interface) and 'Gateways' (ie, Python
  server side support for the interface).  Many COM interfaces are useful
  both as Client and Server.  Other interfaces, however, really only make
  sense to implement one side or the other.  For example, it would be pointless
  for Python to implement Server side for 'IRunningObjectTable', unless we were
  implementing core COM for an operating system in Python (hey - now there's an idea!)

  Most COM interface code is totally boiler-plate - it consists of
  converting arguments, dispatching the call to Python, and processing
  any result values.

  This module automates the generation of such code.  It has the ability to
  parse a .H file generated by the MIDL tool (ie, almost all COM .h files)
  and build almost totally complete C++ code.

  The module understands some of the well known data types, and how to
  convert them.  There are only a couple of places where hand-editing is
  necessary, as detailed below:

  unsupported types -- If a type is not known, the generator will
  pretty much ignore it, but write a comment to the generated code.  You
  may want to add custom support for this type.  In some cases, C++ compile errors
  will result.  These are intentional - generating code to remove these errors would
  imply a false sense of security that the generator has done the right thing.

  other return policies -- By default, Python never sees the return SCODE from
  a COM function.  The interface usually returns None if OK, else a COM exception
  if "FAILED(scode)" is TRUE.  You may need to change this if:
  * EXCEPINFO is passed to the COM function.  This is not detected and handled
  * For some reason Python should always see the result SCODE, even if it
    did fail or succeed.  For example, some functions return a BOOLEAN result
    in the SCODE, meaning Python should always see it.
  * FAILED(scode) for the interface still has valid data to return (by default,
    the code generated does not process the return values, and raise an exception
    to Python/COM

 =#
include("makegwenum.jl")

include("makegwparse.jl")
function make_framework_support(
    header_file_name,
    interface_name,
    bMakeInterface = 1,
    bMakeGateway = 1,
)
    #= Generate C++ code for a Python Interface and Gateway

        header_file_name -- The full path to the .H file which defines the interface.
        interface_name -- The name of the interface to search for, and to generate.
        bMakeInterface = 1 -- Should interface (ie, client) support be generated.
        bMakeGatewayInterface = 1 -- Should gateway (ie, server) support be generated.

        This method will write a .cpp and .h file into the current directory,
        (using the name of the interface to build the file name.

         =#
    fin = readline(header_file_name)
    try
        interface = makegwparse.parse_interface_info(interface_name, fin)
    finally
        close(fin)
    end
    if bMakeInterface && bMakeGateway
        desc = "Interface and Gateway"
    elseif bMakeInterface && !(bMakeGateway)
        desc = "Interface"
    else
        desc = "Gateway"
    end
    if interface.name[begin:5] == "IEnum"
        ifc_cpp_writer = win32com_.makegw.makegwenum._write_enumifc_cpp
        gw_cpp_writer = win32com_.makegw.makegwenum._write_enumgw_cpp
    else
        ifc_cpp_writer = _write_ifc_cpp
        gw_cpp_writer = _write_gw_cpp
    end
    fout = readline("Py$(interface.name).cpp")
    try
        write(
            fout,
            "// This file implements the $(interface.name) $(desc) for Python.\n// Generated by makegw.py\n\n#include \"shell_pch.h\"\n",
        )
        write(
            fout,
            "#include \"Py$(interface.name).h\"\n\n// @doc - This file contains autoduck documentation\n",
        )
        if bMakeInterface
            ifc_cpp_writer(fout, interface)
        end
        if bMakeGateway
            gw_cpp_writer(fout, interface)
        end
    finally
        close(fout)
    end
    fout = readline("Py$(interface.name).h")
    try
        write(
            fout,
            "// This file declares the $(interface.name) $(desc) for Python.\n// Generated by makegw.py\n",
        )
        if bMakeInterface
            _write_ifc_h(fout, interface)
        end
        if bMakeGateway
            _write_gw_h(fout, interface)
        end
    finally
        close(fout)
    end
end

function _write_ifc_h(f, interface)
    write(
        f,
        "// ---------------------------------------------------\n//\n// Interface Declaration\n\nclass Py$(interface.name) : public Py$(interface.base)\n{\npublic:\n\tMAKE_PYCOM_CTOR(Py$(interface.name));\n\tstatic $(interface.name) *GetI(PyObject *self);\n\tstatic PyComTypeObject type;\n\n\t// The Python methods\n",
    )
    for method in interface.methods
        write(f, "\tstatic PyObject *$(method.name)(PyObject *self, PyObject *args);\n")
    end
    write(
        f,
        "\nprotected:\n\tPy$(interface.name)(IUnknown *pdisp);\n\t~Py$(interface.name)();\n};\n",
    )
end

function _write_ifc_cpp(f, interface)
    name = interface.name
    write(
        f,
        "// ---------------------------------------------------\n//\n// Interface Implementation\n\nPy%(name)s::Py%(name)s(IUnknown *pdisp):\n\tPy%(base)s(pdisp)\n{\n\tob_type = &type;\n}\n\nPy%(name)s::~Py%(name)s()\n{\n}\n\n/* static */ %(name)s *Py%(name)s::GetI(PyObject *self)\n{\n\treturn (%(name)s *)Py%(base)s::GetI(self);\n}\n\n",
    )
    ptr =
    # Unsupported use of re.sub with less than 3 arguments
        sub()("[a-z]", "", interface.name)
    strdict = Dict("interfacename" => interface.name, "ptr" => ptr)
    for method in interface.methods
        strdict["method"] = method.name
        write(
            f,
            "// @pymethod |Py%(interfacename)s|%(method)s|Description of %(method)s.\nPyObject *Py%(interfacename)s::%(method)s(PyObject *self, PyObject *args)\n{\n\t%(interfacename)s *p%(ptr)s = GetI(self);\n\tif ( p%(ptr)s == NULL )\n\t\treturn NULL;\n",
        )
        argsParseTuple = ""
        argsCOM = ""
        formatChars = ""
        codePost = ""
        codePobjects = ""
        codeCobjects = ""
        cleanup = ""
        cleanup_gil = ""
        needConversion = 0
        for arg in method.args
            try
                argCvt = makegwparse.make_arg_converter(arg)
                if HasAttribute(arg, "in")
                    val = GetFormatChar(argCvt)
                    if val
                        write(f, ("\t" + GetAutoduckString(argCvt)) * "\n")
                        formatChars = formatChars + val
                        argsParseTuple = argsParseTuple * ", " + GetParseTupleArg(argCvt)
                        codePobjects =
                            codePobjects + DeclareParseArgTupleInputConverter(argCvt)
                        codePost = codePost + GetParsePostCode(argCvt)
                        needConversion = needConversion || NeedUSES_CONVERSION(argCvt)
                        cleanup = cleanup + GetInterfaceArgCleanup(argCvt)
                        cleanup_gil = cleanup_gil + GetInterfaceArgCleanupGIL(argCvt)
                    end
                end
                comArgName, comArgDeclString = GetInterfaceCppObjectInfo(argCvt)
                if comArgDeclString
                    codeCobjects = codeCobjects * "\t$(comArgDeclString);\n"
                end
                argsCOM = argsCOM * ", " + comArgName
            catch exn
                let why = exn
                    if why isa makegwparse.error_not_supported
                        write(
                            f,
                            "// *** The input argument $(arg.name) of type \"$(arg.raw_type)\" was not processed ***\n//     Please check the conversion function is appropriate and exists!\n",
                        )
                        write(f, "\t$(arg.type) $(arg.name);\n\tPyObject *ob$(arg.name);\n")
                        write(
                            f,
                            "\t// @pyparm <o Py$(arg.type)>|$(arg.name)||Description for $(arg.name)\n",
                        )
                        codePost =
                            codePost +
                            "\tif (bPythonIsHappy && !PyObject_As$(arg.type)( ob$(arg.name), &$(arg.name) )) bPythonIsHappy = FALSE;\n"
                        formatChars = formatChars * "O"
                        argsParseTuple = argsParseTuple * ", &ob$(arg.name)"
                        argsCOM = argsCOM * ", " + arg.name
                        cleanup = cleanup + "\tPyObject_Free$(arg.type)($(arg.name));\n"
                    end
                end
            end
        end
        if needConversion != 0
            write(f, "\tUSES_CONVERSION;\n")
        end
        write(f, codePobjects)
        write(f, codeCobjects)
        write(
            f,
            "\tif ( !PyArg_ParseTuple(args, \"$(formatChars):$(method.name)\"$(argsParseTuple)) )\n\t\treturn NULL;\n",
        )
        if codePost
            write(f, "\tBOOL bPythonIsHappy = TRUE;\n")
            write(f, codePost)
            write(f, "\tif (!bPythonIsHappy) return NULL;\n")
        end
        strdict["argsCOM"] = argsCOM[2:end]
        strdict["cleanup"] = cleanup
        strdict["cleanup_gil"] = cleanup_gil
        write(
            f,
            "\tHRESULT hr;\n\tPY_INTERFACE_PRECALL;\n\thr = p%(ptr)s->%(method)s(%(argsCOM)s );\n%(cleanup)s\n\tPY_INTERFACE_POSTCALL;\n%(cleanup_gil)s\n\tif ( FAILED(hr) )\n\t\treturn PyCom_BuildPyException(hr, p%(ptr)s, IID_%(interfacename)s );\n",
        )
        codePre = ""
        codePost = ""
        formatChars = ""
        codeVarsPass = ""
        codeDecl = ""
        for arg in method.args
            if !HasAttribute(arg, "out")
                continue
            end
            try
                argCvt = makegwparse.make_arg_converter(arg)
                formatChar = GetFormatChar(argCvt)
                if formatChar
                    formatChars = formatChars + formatChar
                    codePre = codePre + GetBuildForInterfacePreCode(argCvt)
                    codePost = codePost + GetBuildForInterfacePostCode(argCvt)
                    codeVarsPass = codeVarsPass * ", " + GetBuildValueArg(argCvt)
                    codeDecl = codeDecl + DeclareParseArgTupleInputConverter(argCvt)
                end
            catch exn
                let why = exn
                    if why isa makegwparse.error_not_supported
                        write(
                            f,
                            "// *** The output argument $(arg.name) of type \"$(arg.raw_type)\" was not processed ***\n//     $(why)\n",
                        )
                        continue
                    end
                end
            end
        end
        if formatChars
            write(
                f,
                "$(codeDecl)\n$(codePre)\tPyObject *pyretval = Py_BuildValue(\"$(formatChars)\"$(codeVarsPass));\n$(codePost)\treturn pyretval;",
            )
        else
            write(f, "\tPy_INCREF(Py_None);\n\treturn Py_None;\n")
        end
        write(f, "\n}\n\n")
    end
    write(f, "// @object Py$(name)|Description of the interface\n")
    write(f, "static struct PyMethodDef Py$(name)_methods[] =\n{\n")
    for method in interface.methods
        write(
            f,
            "\t{ \"$(method.name)\", Py$(interface.name)::$(method.name), 1 }, // @pymeth $(method.name)|Description of $(method.name)\n",
        )
    end
    interfacebase = interface.base
    write(
        f,
        "\t{ NULL }\n};\n\nPyComTypeObject Py%(name)s::type(\"Py%(name)s\",\n\t\t&Py%(interfacebase)s::type,\n\t\tsizeof(Py%(name)s),\n\t\tPy%(name)s_methods,\n\t\tGET_PYCOM_CTOR(Py%(name)s));\n",
    )
end

function _write_gw_h(f, interface)
    if interface.name[1] == "I"
        gname = "PyG" + interface.name[2:end]
    else
        gname = "PyG" + interface.name
    end
    name = interface.name
    if interface.base == "IUnknown" || interface.base == "IDispatch"
        base_name = "PyGatewayBase"
    elseif interface.base[1] == "I"
        base_name = "PyG" + interface.base[2:end]
    else
        base_name = "PyG" + interface.base
    end
    write(
        f,
        "// ---------------------------------------------------\n//\n// Gateway Declaration\n\nclass $(gname) : public $(base_name), public $(name)\n{\nprotected:\n\t$(gname)(PyObject *instance) : $(base_name)(instance) { ; }\n\tPYGATEWAY_MAKE_SUPPORT2($(gname), $(name), IID_$(name), $(base_name))\n\n",
    )
    if interface.base != "IUnknown"
        write(
            f,
            "\t// $(interface.base)\n\t// *** Manually add $(interface.base) method decls here\n\n",
        )
    else
        write(f, "\n\n")
    end
    write(f, "\t// $(name)\n")
    for method in interface.methods
        write(f, "\tSTDMETHOD($(method.name))(\n")
        if method.args
            for arg in method.args[begin:end-1]
                write(f, "\t\t$(GetRawDeclaration(arg)),\n")
            end
            arg = method.args[end]
            write(f, "\t\t$(GetRawDeclaration(arg)));\n\n")
        else
            write(f, "\t\tvoid);\n\n")
        end
    end
    write(f, "};\n")
    close(f)
end

function _write_gw_cpp(f, interface)
    if interface.name[1] == "I"
        gname = "PyG" + interface.name[2:end]
    else
        gname = "PyG" + interface.name
    end
    name = interface.name
    if interface.base == "IUnknown" || interface.base == "IDispatch"
        base_name = "PyGatewayBase"
    elseif interface.base[1] == "I"
        base_name = "PyG" + interface.base[2:end]
    else
        base_name = "PyG" + interface.base
    end
    write(
        f,
        "// ---------------------------------------------------\n//\n// Gateway Implementation\n" %
        Dict("name" => name, "gname" => gname, "base_name" => base_name),
    )
    for method in interface.methods
        write(f, "STDMETHODIMP $(gname)::$(method.name)(\n")
        if method.args
            for arg in method.args[begin:end-1]
                inoutstr = join(arg.inout, "][")
                write(f, "\t\t/* [$(inoutstr)] */ $(GetRawDeclaration(arg)),\n")
            end
            arg = method.args[end]
            inoutstr = join(arg.inout, "][")
            write(f, "\t\t/* [$(inoutstr)] */ $(GetRawDeclaration(arg)))\n")
        else
            write(f, "\t\tvoid)\n")
        end
        write(f, "{\n\tPY_GATEWAY_METHOD;\n")
        cout = 0
        codePre = ""
        codePost = ""
        codeVars = ""
        argStr = ""
        needConversion = 0
        formatChars = ""
        if method.args
            for arg in method.args
                if HasAttribute(arg, "out")
                    cout = cout + 1
                    if arg.indirectionLevel == 2
                        write(f, "\tif ($(arg.name)==NULL) return E_POINTER;\n")
                    end
                end
                if HasAttribute(arg, "in")
                    try
                        argCvt = makegwparse.make_arg_converter(arg)
                        SetGatewayMode(argCvt)
                        formatchar = GetFormatChar(argCvt)
                        needConversion = needConversion || NeedUSES_CONVERSION(argCvt)
                        if formatchar
                            formatChars = formatChars + formatchar
                            codeVars = codeVars + DeclareParseArgTupleInputConverter(argCvt)
                            argStr = argStr * ", " + GetBuildValueArg(argCvt)
                        end
                        codePre = codePre + GetBuildForGatewayPreCode(argCvt)
                        codePost = codePost + GetBuildForGatewayPostCode(argCvt)
                    catch exn
                        let why = exn
                            if why isa makegwparse.error_not_supported
                                write(
                                    f,
                                    "// *** The input argument $(arg.name) of type \"$(arg.raw_type)\" was not processed ***\n//   - Please ensure this conversion function exists, and is appropriate\n//   - $(why)\n",
                                )
                                write(
                                    f,
                                    "\tPyObject *ob$(arg.name) = PyObject_From$(arg.type)($(arg.name));\n",
                                )
                                write(
                                    f,
                                    "\tif (ob$(arg.name)==NULL) return MAKE_PYCOM_GATEWAY_FAILURE_CODE(\"$(method.name)\");\n",
                                )
                                codePost = codePost + "\tPy_DECREF(ob$(arg.name));\n"
                                formatChars = formatChars * "O"
                                argStr = argStr * ", ob$(arg.name)"
                            end
                        end
                    end
                end
            end
        end
        if needConversion != 0
            write(f, "\tUSES_CONVERSION;\n")
        end
        write(f, codeVars)
        write(f, codePre)
        if cout != 0
            write(f, "\tPyObject *result;\n")
            resStr = "&result"
        else
            resStr = "NULL"
        end
        if formatChars
            fullArgStr = "$(resStr), \"$(formatChars)\"$(argStr)"
        else
            fullArgStr = resStr
        end
        write(f, "\tHRESULT hr=InvokeViaPolicy(\"$(method.name)\", $(fullArgStr));\n")
        write(f, codePost)
        if cout != 0
            write(f, "\tif (FAILED(hr)) return hr;\n")
            write(
                f,
                "\t// Process the Python results, and convert back to the real params\n",
            )
            formatChars = ""
            codePobjects = ""
            codePost = ""
            argsParseTuple = ""
            needConversion = 0
            for arg in method.args
                if !HasAttribute(arg, "out")
                    continue
                end
                try
                    argCvt = makegwparse.make_arg_converter(arg)
                    SetGatewayMode(argCvt)
                    val = GetFormatChar(argCvt)
                    if val
                        formatChars = formatChars + val
                        argsParseTuple = argsParseTuple * ", " + GetParseTupleArg(argCvt)
                        codePobjects =
                            codePobjects + DeclareParseArgTupleInputConverter(argCvt)
                        codePost = codePost + GetParsePostCode(argCvt)
                        needConversion = needConversion || NeedUSES_CONVERSION(argCvt)
                    end
                catch exn
                    let why = exn
                        if why isa makegwparse.error_not_supported
                            write(
                                f,
                                "// *** The output argument $(arg.name) of type \"$(arg.raw_type)\" was not processed ***\n//     $(why)\n",
                            )
                        end
                    end
                end
            end
            if formatChars
                if length(formatChars) == 1
                    parseFn = "PyArg_Parse"
                else
                    parseFn = "PyArg_ParseTuple"
                end
                if codePobjects
                    write(f, codePobjects)
                end
                write(
                    f,
                    "\tif (!$(parseFn)(result, \"$(formatChars)\" $(argsParseTuple)))\n\t\treturn MAKE_PYCOM_GATEWAY_FAILURE_CODE(\"$(method.name)\");\n",
                )
            end
            if codePost
                write(f, "\tBOOL bPythonIsHappy = TRUE;\n")
                write(f, codePost)
                write(
                    f,
                    "\tif (!bPythonIsHappy) hr = MAKE_PYCOM_GATEWAY_FAILURE_CODE(\"$(method.name)\");\n",
                )
            end
            write(f, "\tPy_DECREF(result);\n")
        end
        write(f, "\treturn hr;\n}\n\n")
    end
end

function test()
    make_framework_support("d:\\msdev\\include\\objidl.h", "IStorage")
end
