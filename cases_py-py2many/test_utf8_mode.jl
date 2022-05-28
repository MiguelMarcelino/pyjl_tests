#= 
Test the implementation of the PEP 540: the UTF-8 Mode.
 =#
using StringEncodings
using Test
import locale
import subprocess

import textwrap


using test.support.script_helper: assert_python_ok, assert_python_failure

abstract type AbstractUTF8ModeTests end
MS_WINDOWS = sys.platform == "win32"
POSIX_LOCALES = ("C", "POSIX")
VXWORKS = sys.platform == "vxworks"
mutable struct UTF8ModeTests <: AbstractUTF8ModeTests
DEFAULT_ENV::Dict{String, String}

                    UTF8ModeTests(DEFAULT_ENV::Dict{String, String} = Dict("PYTHONUTF8" => "", "PYTHONLEGACYWINDOWSFSENCODING" => "", "PYTHONCOERCECLOCALE" => "0")) =
                        new(DEFAULT_ENV)
end
function posix_locale(self)::Bool
loc = setlocale(locale.LC_CTYPE, nothing)
return loc ∈ POSIX_LOCALES
end

function get_output(self)
kw = dict(self.DEFAULT_ENV, None = kw)
if failure
out = assert_python_failure(args..., None = kw)
out = out[3]
else
out = assert_python_ok(args..., None = kw)
out = out[2]
end
return rstrip(decode(out), "\n\r")
end

function test_posix_locale(self)
code = "import sys; print(sys.flags.utf8_mode)"
for loc in POSIX_LOCALES
subTest(self, LC_ALL = loc) do 
out = get_output(self)
@test (out == "1")
end
end
end

function test_xoption(self)
code = "import sys; print(sys.flags.utf8_mode)"
out = get_output(self)
@test (out == "1")
out = get_output(self)
@test (out == "1")
out = get_output(self)
@test (out == "0")
if MS_WINDOWS
out = get_output(self)
@test (out == "0")
end
end

function test_env_var(self)
code = "import sys; print(sys.flags.utf8_mode)"
out = get_output(self)
@test (out == "1")
out = get_output(self)
@test (out == "0")
out = get_output(self)
@test (out == "0")
if MS_WINDOWS
out = get_output(self)
@test (out == "0")
end
if !posix_locale(self)
out = get_output(self)
@test (out == "0")
end
out = get_output(self)
assertIn(self, "invalid PYTHONUTF8 environment variable value", rstrip(out))
end

function test_filesystemencoding(self)
code = dedent("\n            import sys\n            print(\"{}/{}\".format(sys.getfilesystemencoding(),\n                                 sys.getfilesystemencodeerrors()))\n        ")
if MS_WINDOWS
expected = "utf-8/surrogatepass"
else
expected = "utf-8/surrogateescape"
end
out = get_output(self)
@test (out == expected)
if MS_WINDOWS
out = get_output(self)
@test (out == "mbcs/replace")
end
end

function test_stdio(self)
code = dedent("\n            import sys\n            print(f\"stdin: {sys.stdin.encoding}/{sys.stdin.errors}\")\n            print(f\"stdout: {sys.stdout.encoding}/{sys.stdout.errors}\")\n            print(f\"stderr: {sys.stderr.encoding}/{sys.stderr.errors}\")\n        ")
out = get_output(self)
@test (splitlines(out) == ["stdin: utf-8/surrogateescape", "stdout: utf-8/surrogateescape", "stderr: utf-8/backslashreplace"])
out = get_output(self)
@test (splitlines(out) == ["stdin: iso8859-1/strict", "stdout: iso8859-1/strict", "stderr: iso8859-1/backslashreplace"])
out = get_output(self)
@test (splitlines(out) == ["stdin: utf-8/namereplace", "stdout: utf-8/namereplace", "stderr: utf-8/backslashreplace"])
end

function test_io(self)
code = dedent("\n            import sys\n            filename = sys.argv[1]\n            with open(filename) as fp:\n                print(f\"{fp.encoding}/{fp.errors}\")\n        ")
filename = __file__
out = get_output(self)
@test (out == "UTF-8/strict")
end

function _check_io_encoding(self, module_, encoding = nothing, errors = nothing)
filename = __file__
args = []
if encoding
push!(args, "encoding=$('encoding')")
end
if errors
push!(args, "errors=$('errors')")
end
code = dedent("\n            import sys\n            from %s import open\n            filename = sys.argv[1]\n            with open(filename, %s) as fp:\n                print(f\"{fp.encoding}/{fp.errors}\")\n        ") % (module_, join(args, ", "))
out = get_output(self)
if !(encoding)
encoding = "UTF-8"
end
if !(errors)
errors = "strict"
end
@test (out == "$(encoding)/$(errors)")
end

function check_io_encoding(self, module_)
_check_io_encoding(self, module_)
_check_io_encoding(self, module_)
_check_io_encoding(self, module_)
end

function test_io_encoding(self)
check_io_encoding(self, "io")
end

function test_pyio_encoding(self)
check_io_encoding(self, "_pyio")
end

function test_locale_getpreferredencoding(self)
code = "import locale; print(locale.getpreferredencoding(False), locale.getpreferredencoding(True))"
out = get_output(self)
@test (out == "UTF-8 UTF-8")
for loc in POSIX_LOCALES
subTest(self, LC_ALL = loc) do 
out = get_output(self)
@test (out == "UTF-8 UTF-8")
end
end
end

function test_cmd_line(self)
arg = encode("h\xe9€", "utf-8")
arg_utf8 = decode(arg, "utf-8")
arg_ascii = decode(arg, "ascii", "surrogateescape")
code = "import locale, sys; print(\"%s:%s\" % (locale.getpreferredencoding(), ascii(sys.argv[1:])))"
function check(utf8_opt, expected)
out = get_output(self)
args = rstrip(partition(out, ":")[3])
@test (args == ascii(expected))
end

check("utf8", [arg_utf8])
for loc in POSIX_LOCALES
subTest(self, LC_ALL = loc) do 
check("utf8", [arg_utf8])
end
end
if sys.platform == "darwin" || support.is_android || VXWORKS
c_arg = arg_utf8
elseif startswith(sys.platform, "aix")
c_arg = decode(arg, "iso-8859-1")
else
c_arg = arg_ascii
end
for loc in POSIX_LOCALES
subTest(self, LC_ALL = loc) do 
check("utf8=0", [c_arg])
end
end
end

function test_optim_level(self)
code = "import sys; print(sys.flags.optimize)"
out = get_output(self)
@test (out == "1")
out = get_output(self)
@test (out == "2")
code = "import sys; print(sys.flags.ignore_environment)"
out = get_output(self)
@test (out == "1")
end

function test_device_encoding(self)
if !isatty(sys.stdout)
skipTest(self, "sys.stdout is not a TTY")
end
filename = "out.txt"
addCleanup(self, os_helper.unlink, filename)
code = "import os, sys; fd = sys.stdout.fileno(); out = open($('filename'), \"w\", encoding=\"utf-8\"); print(os.isatty(fd), os.device_encoding(fd), file=out); out.close()"
cmd = [sys.executable, "-X", "utf8", "-c", code]
proc = run(cmd, text = true)
@test (proc.returncode == 0)
readline(filename) do fp 
out = rstrip(read(fp))
end
@test (out == "True UTF-8")
end

if abspath(PROGRAM_FILE) == @__FILE__
u_t_f8_mode_tests = UTF8ModeTests()
posix_locale(u_t_f8_mode_tests)
get_output(u_t_f8_mode_tests)
test_posix_locale(u_t_f8_mode_tests)
test_xoption(u_t_f8_mode_tests)
test_env_var(u_t_f8_mode_tests)
test_filesystemencoding(u_t_f8_mode_tests)
test_stdio(u_t_f8_mode_tests)
test_io(u_t_f8_mode_tests)
_check_io_encoding(u_t_f8_mode_tests)
check_io_encoding(u_t_f8_mode_tests)
test_io_encoding(u_t_f8_mode_tests)
test_pyio_encoding(u_t_f8_mode_tests)
test_locale_getpreferredencoding(u_t_f8_mode_tests)
test_cmd_line(u_t_f8_mode_tests)
test_optim_level(u_t_f8_mode_tests)
test_device_encoding(u_t_f8_mode_tests)
end