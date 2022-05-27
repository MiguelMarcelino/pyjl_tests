using PyCall
win32api = pyimport("win32api")
pythoncom = pyimport("pythoncom")

sys.coinit_flags = 2


using win32com_.server: factory
usage = "Invalid command line arguments\n\nThis program provides LocalServer COM support\nfor Python COM objects.\n\nIt is typically run automatically by COM, passing as arguments\nThe ProgID or CLSID of the Python Server(s) to be hosted\n"
function serve(clsids)
infos = RegisterClassFactories(clsids)
EnableQuitMessage(GetCurrentThreadId())
CoResumeClassObjects()
PumpMessages()
RevokeClassFactories(infos)
CoUninitialize()
end

function main()
if length(sys.argv) == 1
MessageBox(0, usage, "Python COM Server")
exit(1)
end
serve(sys.argv[2:end])
end

if abspath(PROGRAM_FILE) == @__FILE__
main()
end