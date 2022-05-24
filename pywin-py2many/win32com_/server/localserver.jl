using PyCall
win32api = pyimport("win32api")
pythoncom = pyimport("pythoncom")

sys.coinit_flags = 2

using win32com_.server: factory
usage = "Invalid command line arguments\n\nThis program provides LocalServer COM support\nfor Python COM objects.\n\nIt is typically run automatically by COM, passing as arguments\nThe ProgID or CLSID of the Python Server(s) to be hosted\n"
function serve(clsids)
    infos = factory.RegisterClassFactories(clsids)
    pythoncom.EnableQuitMessage(win32api.GetCurrentThreadId())
    pythoncom.CoResumeClassObjects()
    pythoncom.PumpMessages()
    factory.RevokeClassFactories(infos)
    pythoncom.CoUninitialize()
end

function main()
    if length(append!([PROGRAM_FILE], ARGS)) == 1
        win32api.MessageBox(0, usage, "Python COM Server")
        quit(1)
    end
    serve(append!([PROGRAM_FILE], ARGS)[2:end])
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end
