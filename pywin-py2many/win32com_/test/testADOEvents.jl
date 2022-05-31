include("testAccess.jl")
using win32com_.client: Dispatch, DispatchWithEvents, constants
using ext_modules: pythoncom

abstract type AbstractADOEvents end
finished = 0
mutable struct ADOEvents <: AbstractADOEvents
end
function OnWillConnect(self::AbstractADOEvents, str, user, pw, opt, sts, cn)
    #= pass =#
end

function OnConnectComplete(self::AbstractADOEvents, error, status, connection)
    println("connection is $(connection)")
    println("Connected to $(Properties(connection, "Data Source"))")
    global finished
    finished = 1
end

function OnCommitTransComplete(self::AbstractADOEvents, pError, adStatus, pConnection)
    #= pass =#
end

function OnInfoMessage(self::AbstractADOEvents, pError, adStatus, pConnection)
    #= pass =#
end

function OnDisconnect(self::AbstractADOEvents, adStatus, pConnection)
    #= pass =#
end

function OnBeginTransComplete(
    self::AbstractADOEvents,
    TransactionLevel,
    pError,
    adStatus,
    pConnection,
)
    #= pass =#
end

function OnRollbackTransComplete(self::AbstractADOEvents, pError, adStatus, pConnection)
    #= pass =#
end

function OnExecuteComplete(
    self::AbstractADOEvents,
    RecordsAffected,
    pError,
    adStatus,
    pCommand,
    pRecordset,
    pConnection,
)
    #= pass =#
end

function OnWillExecute(
    self::AbstractADOEvents,
    Source,
    CursorType,
    LockType,
    Options,
    adStatus,
    pCommand,
    pRecordset,
    pConnection,
)
    #= pass =#
end

function TestConnection(dbname)
    c = DispatchWithEvents("ADODB.Connection", ADOEvents)
    dsn = "Driver={Microsoft Access Driver (*.mdb)};Dbq=$(dbname)"
    user = "system"
    pw = "manager"
    Open(c, dsn, user, pw, constants.adAsyncConnect)
    end_time = time.clock() + 10
    while time.clock() < end_time
        pythoncom.PumpWaitingMessages()
    end
    if !(finished) != 0
        println("XXX - Failed to connect!")
    end
end

function Test()
    try
        testAccess.GenerateSupport()
    catch exn
        if exn isa pythoncom.com_error
            println("*** Can not import the MSAccess type libraries - tests skipped")
            return
        end
    end
    dbname = testAccess.CreateTestAccessDatabase()
    try
        TestConnection(dbname)
    finally
        rm(dbname)
    end
end

if abspath(PROGRAM_FILE) == @__FILE__
    Test()
end
