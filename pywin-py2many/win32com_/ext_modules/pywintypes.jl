import _win32sysloader
import site
import sysconfig
import importlib.util
import importlib.machinery
function __import_pywin32_system_module__(modname, globs)
    suffix = "_d.pyd" ∈ importlib.machinery.EXTENSION_SUFFIXES ? ("_d") : ("")
    filename = "$(modname)39$(suffix).dll"
    if hasfield(typeof(sys), :frozen)
        has_break = false
        for look in sys.path
            if isfile(look)
                look = dirname(look)
            end
            found = joinpath(look, filename)
            if isfile(found)
                break
            end
        end
        if has_break != true
            throw(
                ImportError("Module \'$(modname)\' isn\'t in frozen sys.path $(sys.path)"),
            )
        end
    else
        found = _win32sysloader.GetModuleFilename(filename)
        if found === nothing
            found = _win32sysloader.LoadModule(filename)
        end
        if found === nothing
            if isfile(joinpath(sys.prefix, filename))
                found = joinpath(sys.prefix, filename)
            end
        end
        if found === nothing
            if isfile(joinpath(dirname(__file__), filename))
                found = joinpath(dirname(__file__), filename)
            end
        end
        if found === nothing
            maybe = joinpath(site.USER_SITE, "pywin32_system32", filename)
            if isfile(maybe)
                found = maybe
            end
        end
        if found === nothing
            maybe = joinpath(sysconfig.get_paths()["platlib"], "pywin32_system32", filename)
            if isfile(maybe)
                found = maybe
            end
        end
        if found === nothing
            throw(ImportError("No system module \'$(modname)\' ($(filename))"))
        end
    end
    old_mod = sys.modules[modname+1]
    loader = importlib.machinery.ExtensionFileLoader(modname, found)
    spec = importlib.machinery.ModuleSpec(name = modname, loader = loader, origin = found)
    mod = importlib.util.module_from_spec(spec)
    exec_module(spec.loader, mod)
    @assert(sys.modules[modname+1] === mod)
    sys.modules[modname+1] = old_mod
    update(globs, mod.__dict__)
end

__import_pywin32_system_module__("pywintypes", globals())
