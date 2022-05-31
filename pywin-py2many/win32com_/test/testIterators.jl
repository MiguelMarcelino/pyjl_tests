
using win32com_.client.gencache: EnsureDispatch
using win32com_.client: Dispatch
import win32com_.server.util
import win32com_.test.util
using ext_modules: pythoncom
abstract type Abstract_BaseTestCase <: win32com_.test.util.TestCase end
abstract type AbstractVBTestCase <: Abstract_BaseTestCase end
abstract type AbstractSomeObject end
abstract type AbstractWrappedPythonCOMServerTestCase <: Abstract_BaseTestCase end
mutable struct _BaseTestCase <: Abstract_BaseTestCase
    expected_data
end
function test_enumvariant_vb(self::Abstract_BaseTestCase)
    ob, iter = iter_factory(self)
    got = []
    for v in iter
        push!(got, v)
    end
    assertEqual(self, got, self.expected_data)
end

function test_yield(self::Abstract_BaseTestCase)
    ob, i = iter_factory(self)
    got = []
    for v in (x for x in i)
        push!(got, v)
    end
    assertEqual(self, got, self.expected_data)
end

function _do_test_nonenum(self::Abstract_BaseTestCase, object)
    try
        for i in object
            #= pass =#
        end
        fail(self, "Could iterate over a non-iterable object")
    catch exn
        if exn isa TypeError
            #= pass =#
        end
    end
    assertRaises(self, TypeError, iter, object)
    assertRaises(self, AttributeError, getattr, object, "next")
end

function test_nonenum_wrapper(self::Abstract_BaseTestCase)
    ob = self.object._oleobj_
    try
        for i in ob
            #= pass =#
        end
        fail(self, "Could iterate over a non-iterable object")
    catch exn
        if exn isa TypeError
            #= pass =#
        end
    end
    assertRaises(self, TypeError, iter, ob)
    assertRaises(self, AttributeError, getattr, ob, "next")
    ob = self.object
    try
        for i in ob
            #= pass =#
        end
        fail(self, "Could iterate over a non-iterable object")
    catch exn
        if exn isa TypeError
            #= pass =#
        end
    end
    try
        next((x for x in ob))
        fail(self, "Expected a TypeError fetching this iterator")
    catch exn
        if exn isa TypeError
            #= pass =#
        end
    end
    assertRaises(self, AttributeError, getattr, ob, "next")
end

mutable struct VBTestCase <: AbstractVBTestCase
    object
    expected_data
    iter_factory
end
function setUp(self::AbstractVBTestCase)
    function factory()::Tuple
        ob = self.object.EnumerableCollectionProperty
        for i in self.expected_data
            Add(ob, i)
        end
        invkind = pythoncom.DISPATCH_METHOD | pythoncom.DISPATCH_PROPERTYGET
        iter = InvokeTypes(ob._oleobj_, pythoncom.DISPID_NEWENUM, 0, invkind, (13, 10), ())
        return (ob, QueryInterface(iter, pythoncom.IID_IEnumVARIANT))
    end

    self.object = EnsureDispatch("PyCOMVBTest.Tester")
    self.expected_data = [1, "Two", "3"]
    self.iter_factory = factory
end

function tearDown(self::AbstractVBTestCase)
    self.object = nothing
end

mutable struct SomeObject <: AbstractSomeObject
    data
    _public_methods_::Vector{String}
end
function GetCollection(self::AbstractSomeObject)
    return win32com_.server.util.NewCollection(self.data)
end

mutable struct WrappedPythonCOMServerTestCase <: AbstractWrappedPythonCOMServerTestCase
    expected_data
    object
    iter_factory
end
function setUp(self::AbstractWrappedPythonCOMServerTestCase)
    function factory()::Tuple
        ob = GetCollection(self.object)
        flags = pythoncom.DISPATCH_METHOD | pythoncom.DISPATCH_PROPERTYGET
        enum = Invoke(ob._oleobj_, pythoncom.DISPID_NEWENUM, 0, flags, 1)
        return (ob, QueryInterface(enum, pythoncom.IID_IEnumVARIANT))
    end

    self.expected_data = [1, "Two", 3]
    sv = win32com_.server.util.wrap(SomeObject(self.expected_data))
    self.object = Dispatch(sv)
    self.iter_factory = factory
end

function tearDown(self::AbstractWrappedPythonCOMServerTestCase)
    self.object = nothing
end

function suite()
    suite = unittest.TestSuite()
    for item in collect(values(globals()))
        if type_(item) == type_(unittest.TestCase) &&
           item <: unittest.TestCase &&
           item != _BaseTestCase
            addTest(suite, unittest.makeSuite(item))
        end
    end
    return suite
end

if abspath(PROGRAM_FILE) == @__FILE__
end
