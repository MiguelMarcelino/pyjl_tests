import _win32sysloader
import site
import sysconfig
import importlib.util
import importlib.machinery
function __import_pywin32_system_module__(modname, globs)
    suffix = "_d.pyd" ∈ importlib.machinery.EXTENSION_SUFFIXES ? ("_d") : ("")
    filename = "%s%d%d%s.dll" % (modname, sys.version_info[1], sys.version_info[2], suffix)
    if hasfield(typeof(sys), :frozen)
        has_break = false
        for look in sys.path
            if isfile(os.path, look)
                look = dirname(look)
            end
            found = joinpath(look, filename)
            if isfile(os.path, found)
                has_break = true
                break
            end
        end
        if has_break != true
            throw(
                ImportError(
                    "Module \'%s\' isn\'t in frozen sys.path %s" % (modname, sys.path),
                ),
            )
        end
    else
        found = GetModuleFilename(filename)
        if found === nothing
            found = LoadModule(filename)
        end
        if found === nothing
            if isfile(os.path, joinpath(sys.prefix, filename))
                found = joinpath(sys.prefix, filename)
            end
        end
        if found === nothing
            if isfile(os.path, joinpath(dirname(__file__), filename))
                found = joinpath(dirname(__file__), filename)
            end
        end
        if found === nothing
            maybe = joinpath(site.USER_SITE, "pywin32_system32", filename)
            if isfile(os.path, maybe)
                found = maybe
            end
        end
        if found === nothing
            maybe = joinpath(get_paths()["platlib"], "pywin32_system32", filename)
            if isfile(os.path, maybe)
                found = maybe
            end
        end
        if found === nothing
            throw(ImportError("No system module \'%s\' (%s)" % (modname, filename)))
        end
    end
    old_mod = sys.modules[modname+1]
    loader = ExtensionFileLoader(modname, found)
    spec = ModuleSpec(modname, loader, found)
    mod = module_from_spec(spec)
    exec_module(spec.loader, mod)
    @assert(sys.modules[modname+1] === mod)
    sys.modules[modname+1] = old_mod
    update(globs, mod.__dict__)
end

__import_pywin32_system_module__("pywintypes", globals())
