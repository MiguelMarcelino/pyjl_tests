using PyCall
win32api = pyimport("win32api")
import win32con
import win32com_.client
using util: CheckClean
using win32com_.client: gencache, constants
using ext_modules: pythoncom

ammodule = nothing
function GetDefaultProfileName()
try
key = win32api.RegOpenKey(win32con.HKEY_CURRENT_USER, "Software\\Microsoft\\Windows NT\\CurrentVersion\\Windows Messaging Subsystem\\Profiles")
try
return win32api.RegQueryValueEx(key, "DefaultProfile")[1]
finally
Close(key)
end
catch exn
if exn isa win32api.error
return nothing
end
end
end

function DumpFolder(folder, indent = 0)
println(" "*inden$(folder.Name)")
folders = folder.Folders
folder = GetFirst(folders)
while folder
DumpFolder(folder, indent + 1)
folder = GetNext(folders)
end
end

function DumpFolders(session)
try
infostores = session.InfoStores
catch exn
if exn isa AttributeError
store = session.DefaultStore
folder = GetRootFolder(store)
DumpFolder(folder)
return
end
end
println(infostores)
println("There are  infostores")
for i in 0:infostores.Count - 1
infostore = infostores[i + 2]
println("Infostore = $(infostore.Name)")
try
folder = infostore.RootFolder
catch exn
 let details = exn
if details isa pythoncom.com_error
hr, msg, exc, arg = details
if exc && exc[end] == -2147221219
println("This info store is currently not available")
continue;
end
end
end
end
DumpFolder(folder)
end
end

PropTagsById = Dict()
if ammodule
for (name, val) in items(ammodule.constants.__dict__)
PropTagsById[val] = name
end
end
function TestAddress(session)
#= pass =#
end

function TestUser(session)
ae = session.CurrentUser
fields = (hasfield(typeof(ae), :Fields) ? 
                getfield(ae, :Fields) : [])
println("User has  fields")
for f in 0:length(fields) - 1
field = fields[f + 2]
try
id = PropTagsById[field.ID]
catch exn
if exn isa KeyError
id = field.ID
end
end
println("$(field.Name)$(id)$(field.Value)")
end
end

function test()
oldcwd = os.getcwd()
try
session = gencache.EnsureDispatch("MAPI.Session")
try
Logon(session, GetDefaultProfileName())
catch exn
 let details = exn
if details isa pythoncom.com_error
println("Could not log on to MAPI:$(details)")
return
end
end
end
catch exn
if exn isa pythoncom.error
app = gencache.EnsureDispatch("Outlook.Application")
session = app.Session
end
end
try
TestUser(session)
TestAddress(session)
DumpFolders(session)
finally
Logoff(session)
os.chdir(oldcwd)
end
end

if abspath(PROGRAM_FILE) == @__FILE__
test()
CheckClean()
end