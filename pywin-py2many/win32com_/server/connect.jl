#= Utilities for Server Side connections.

  A collection of helpers for server side connection points.
 =#
using OrderedCollections
using Printf
using ext_modules: pythoncom
using exception: Exception
import winerror
using win32com_: olectl
include("util.jl")
abstract type AbstractConnectableServer end
IConnectionPointContainer_methods = ["EnumConnectionPoints", "FindConnectionPoint"]
IConnectionPoint_methods = [
    "EnumConnections",
    "Unadvise",
    "Advise",
    "GetConnectionPointContainer",
    "GetConnectionInterface",
]
mutable struct ConnectableServer <: AbstractConnectableServer
    _connect_interfaces_
    connections::Dict
    cookieNo::Int64
    _com_interfaces_::Vector
    _public_methods_::Vector{String}
    ConnectableServer(cookieNo = 0, connections = OrderedDict()) =
        new(cookieNo, connections)
end
function EnumConnections(self::AbstractConnectableServer)
    throw(Exception(winerror.E_NOTIMPL))
end

function GetConnectionInterface(self::AbstractConnectableServer)
    throw(Exception(winerror.E_NOTIMPL))
end

function GetConnectionPointContainer(self::AbstractConnectableServer)
    return win32com_.server.util.wrap(self)
end

function Advise(self::AbstractConnectableServer, pUnk)::Int64
    try
        interface =
            QueryInterface(pUnk, self._connect_interfaces_[1], pythoncom.IID_IDispatch)
    catch exn
        if exn isa pythoncom.com_error
            throw(Exception(scode = olectl.CONNECT_E_NOCONNECTION))
        end
    end
    self.cookieNo = self.cookieNo + 1
    self.connections[self.cookieNo] = interface
    return self.cookieNo
end

function Unadvise(self::AbstractConnectableServer, cookie)
    try
        delete!(self.connections, cookie)
    catch exn
        if exn isa KeyError
            throw(Exception(scode = winerror.E_UNEXPECTED))
        end
    end
end

function EnumConnectionPoints(self::AbstractConnectableServer)
    throw(Exception(winerror.E_NOTIMPL))
end

function FindConnectionPoint(self::AbstractConnectableServer, iid)
    if iid ∈ self._connect_interfaces_
        return win32com_.server.util.wrap(self)
    end
end

function _BroadcastNotify(self::AbstractConnectableServer, broadcaster, extraArgs)
    for interface in values(self.connections)
        try
            broadcaster((interface,) + extraArgs...)
        catch exn
            let details = exn
                if details isa pythoncom.com_error
                    _OnNotifyFail(self, interface, details)
                end
            end
        end
    end
end

function _OnNotifyFail(self::AbstractConnectableServer, interface, details)
    @printf("Ignoring COM error to connection - %s\n", repr(details))
end
