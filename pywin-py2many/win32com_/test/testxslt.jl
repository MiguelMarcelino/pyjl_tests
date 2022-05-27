<<<<<<< HEAD
using Printf

import tempfile

import win32com_.test.util
abstract type AbstractXSLT <: win32com_.test.util.TestCase end
expected_output = "The jscript test worked.\nThe Python test worked"
mutable struct XSLT <: AbstractXSLT

end
function testAll(self::XSLT)
output_name = mktemp("-pycom-test")
cmd = "cscript //nologo testxslt.js doesnt_matter.xml testxslt.xsl " + output_name
ExecuteShellCommand(cmd, self)
try
f = open(output_name)
try
got = read(f)
if got != expected_output
@printf("ERROR: XSLT expected output of %r\n", expected_output)
@printf("but got %r\n", got)
end
finally
close(f)
end
finally
try
unlink(output_name)
catch exn
if exn isa os.error
#= pass =#
end
end
end
end

if abspath(PROGRAM_FILE) == @__FILE__
end
=======
using Printf

import tempfile

import win32com_.test.util
abstract type AbstractXSLT <: win32com_.test.util.TestCase end
expected_output = "The jscript test worked.\nThe Python test worked"
mutable struct XSLT <: AbstractXSLT
end
function testAll(self::XSLT)
    output_name = mktemp("-pycom-test")
    cmd = "cscript //nologo testxslt.js doesnt_matter.xml testxslt.xsl " + output_name
    ExecuteShellCommand(cmd, self)
    try
        f = open(output_name)
        try
            got = read(f)
            if got != expected_output
                @printf("ERROR: XSLT expected output of %r\n", expected_output)
                @printf("but got %r\n", got)
            end
        finally
            close(f)
        end
    finally
        try
            unlink(output_name)
        catch exn
            if exn isa os.error
                #= pass =#
            end
        end
    end
end

if abspath(PROGRAM_FILE) == @__FILE__
end
>>>>>>> f214ca7f5ced7424e7132e581746e8672e842fb6
