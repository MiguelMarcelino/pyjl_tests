
include("../client/gencache.jl")
include("../client/dynamic.jl")
include("util.jl")
abstract type AbstractRegexTest <: win32com_.test.util.TestCase end
mutable struct RegexTest <: AbstractRegexTest
end
function _CheckMatches(self::AbstractRegexTest, match, expected)
    found = []
    for imatch in match
        push!(found, imatch.FirstIndex)
    end
    assertEqual(self, collect(found), collect(expected))
end

function _TestVBScriptRegex(self::AbstractRegexTest, re)
    StringToSearch = "Python python pYthon Python"
    re.Pattern = "Python"
    re.Global = true
    re.IgnoreCase = true
    match = Execute(re, StringToSearch)
    expected = (0, 7, 14, 21)
    _CheckMatches(self, match, expected)
    re.IgnoreCase = false
    match = Execute(re, StringToSearch)
    expected = (0, 21)
    _CheckMatches(self, match, expected)
end

function testDynamic(self::AbstractRegexTest)
    re = DumbDispatch("VBScript.Regexp")
    _TestVBScriptRegex(self, re)
end

function testGenerated(self::AbstractRegexTest)
    re = EnsureDispatch("VBScript.Regexp")
    _TestVBScriptRegex(self, re)
end

if abspath(PROGRAM_FILE) == @__FILE__
end
