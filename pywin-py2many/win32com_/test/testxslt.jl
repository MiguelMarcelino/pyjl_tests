using Printf

import tempfile

include("util.jl")
abstract type AbstractXSLT <: win32com_.test.util.TestCase end
expected_output = "The jscript test worked.\nThe Python test worked"
mutable struct XSLT <: AbstractXSLT
end
function testAll(self::AbstractXSLT)
    output_name = tempfile.mktemp("-pycom-test")
    cmd = "cscript //nologo testxslt.js doesnt_matter.xml testxslt.xsl " + output_name
    win32com_.test.util.ExecuteShellCommand(cmd, self)
    try
        f = open(output_name)
        try
            got = read(f)
            if got != expected_output
                @printf("ERROR: XSLT expected output of %r\n", (expected_output,))
                @printf("but got %r\n", (got,))
            end
        finally
            close(f)
        end
    finally
        try
            rm(output_name)
        catch exn
            if exn isa os.error
                #= pass =#
            end
        end
    end
end

if abspath(PROGRAM_FILE) == @__FILE__
end
