using PyCall
pywintypes = pyimport("pywintypes")

__import_pywin32_system_module__("pythoncom", globals())
