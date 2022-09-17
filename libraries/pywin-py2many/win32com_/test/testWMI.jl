using win32com_.client: GetObject
include("util.jl")

abstract type AbstractSimple <: win32com_.test.util.TestCase end
mutable struct Simple <: AbstractSimple
end
function testit(self::AbstractSimple)
    cses = InstancesOf(GetObject("WinMgMts:"), "Win32_Process")
    vals = []
    for cs in cses
        val = Properties_(cs, "Caption").Value
        push!(vals, val)
    end
    assertFalse(self, length(vals) < 5, "We only found $(length(vals)) processes!")
end

if abspath(PROGRAM_FILE) == @__FILE__
end
