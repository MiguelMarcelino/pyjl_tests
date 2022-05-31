#= Utility file for generating PyIEnum support.

This is almost a 'template' file.  It simplay contains almost full
C++ source code for PyIEnum* support, and the Python code simply
substitutes the appropriate interface name.

This module is notmally not used directly - the @makegw@ module
automatically calls this.
 =#
import win32com_.ext_modules.string as string
function is_interface_enum(enumtype)
return !(enumtype[1] ∈ string.uppercase && enumtype[3] ∈ string.uppercase)
end

function _write_enumifc_cpp(f, interface)
enumtype = interface.name[6:end]
if is_interface_enum(enumtype)
enum_interface = "I" + enumtype[begin:-1]
converter = "PyObject *ob = PyCom_PyObjectFromIUnknown(rgVar[i], IID_enum_interface)s, FALSE);"
arraydeclare = "enum_interface)s **rgVar = new enum_interface)s *[celt];"
else
converter = "PyObject *ob = PyCom_PyObjectFromenumtype)s(&rgVar[i]);"
arraydeclare = "enumtype)s *rgVar = new enumtype)s[celt];"
end
write(f, "
// ---------------------------------------------------
//
// Interface Implementation

PyIEnumenumtype)s::PyIEnumenumtype)s(IUnknown *pdisp):
	PyIUnknown(pdisp)
{
	ob_type = &type;
}

PyIEnumenumtype)s::~PyIEnumenumtype)s()
{
}

/* static */ IEnumenumtype)s *PyIEnumenumtype)s::GetI(PyObject *self)
{
	return (IEnumenumtype)s *)PyIUnknown::GetI(self);
}

// @pymethod object|PyIEnumenumtype)s|Next|Retrieves a specified number of items in the enumeration sequence.
PyObject *PyIEnumenumtype)s::Next(PyObject *self, PyObject *args)
{
	long celt = 1;
	// @pyparm int|num|1|Number of items to retrieve.
	if ( !PyArg_ParseTuple(args, "|l:Next", &celt) )
		return NULL;

	IEnumenumtype)s *pIEenumtype)s = GetI(self);
	if ( pIEenumtype)s == NULL )
		return NULL;

	arraydeclare)s
	if ( rgVar == NULL ) {
		PyErr_SetString(PyExc_MemoryError, "allocating result enumtype)ss");
		return NULL;
	}

	int i;
/*	for ( i = celt; i--; )
		// *** possibly init each structure element???
*/

	ULONG celtFetched = 0;
	PY_INTERFACE_PRECALL;
	HRESULT hr = pIEenumtype)s->Next(celt, rgVar, &celtFetched);
	PY_INTERFACE_POSTCALL;
	if (  HRESULT_CODE(hr) != ERROR_NO_MORE_ITEMS && FAILED(hr) )
	{
		delete [] rgVar;
		return PyCom_BuildPyException(hr,pIEenumtype)s, IID_IEenumtype)s);
	}

	PyObject *result = PyTuple_New(celtFetched);
	if ( result != NULL )
	{
		for ( i = celtFetched; i--; )
		{
			converter)s
			if ( ob == NULL )
			{
				Py_DECREF(result);
				result = NULL;
				break;
			}
			PyTuple_SET_ITEM(result, i, ob);
		}
	}

/*	for ( i = celtFetched; i--; )
		// *** possibly cleanup each structure element???
*/
	delete [] rgVar;
	return result;
}

// @pymethod |PyIEnumenumtype)s|Skip|Skips over the next specified elementes.
PyObject *PyIEnumenumtype)s::Skip(PyObject *self, PyObject *args)
{
	long celt;
	if ( !PyArg_ParseTuple(args, "l:Skip", &celt) )
		return NULL;

	IEnumenumtype)s *pIEenumtype)s = GetI(self);
	if ( pIEenumtype)s == NULL )
		return NULL;

	PY_INTERFACE_PRECALL;
	HRESULT hr = pIEenumtype)s->Skip(celt);
	PY_INTERFACE_POSTCALL;
	if ( FAILED(hr) )
		return PyCom_BuildPyException(hr, pIEenumtype)s, IID_IEenumtype)s);

	Py_INCREF(Py_None);
	return Py_None;
}

// @pymethod |PyIEnumenumtype)s|Reset|Resets the enumeration sequence to the beginning.
PyObject *PyIEnumenumtype)s::Reset(PyObject *self, PyObject *args)
{
	if ( !PyArg_ParseTuple(args, ":Reset") )
		return NULL;

	IEnumenumtype)s *pIEenumtype)s = GetI(self);
	if ( pIEenumtype)s == NULL )
		return NULL;

	PY_INTERFACE_PRECALL;
	HRESULT hr = pIEenumtype)s->Reset();
	PY_INTERFACE_POSTCALL;
	if ( FAILED(hr) )
		return PyCom_BuildPyException(hr, pIEenumtype)s, IID_IEenumtype)s);

	Py_INCREF(Py_None);
	return Py_None;
}

// @pymethod <o PyIEnumenumtype)s>|PyIEnumenumtype)s|Clone|Creates another enumerator that contains the same enumeration state as the current one
PyObject *PyIEnumenumtype)s::Clone(PyObject *self, PyObject *args)
{
	if ( !PyArg_ParseTuple(args, ":Clone") )
		return NULL;

	IEnumenumtype)s *pIEenumtype)s = GetI(self);
	if ( pIEenumtype)s == NULL )
		return NULL;

	IEnumenumtype)s *pClone;
	PY_INTERFACE_PRECALL;
	HRESULT hr = pIEenumtype)s->Clone(&pClone);
	PY_INTERFACE_POSTCALL;
	if ( FAILED(hr) )
		return PyCom_BuildPyException(hr, pIEenumtype)s, IID_IEenumtype)s);

	return PyCom_PyObjectFromIUnknown(pClone, IID_IEnumenumtype)s, FALSE);
}

// @object PyIEnumenumtype)s|A Python interface to IEnumenumtype)s
static struct PyMethodDef PyIEnumenumtype)s_methods[] =
{
	{ "Next", PyIEnumenumtype)s::Next, 1 },    // @pymeth Next|Retrieves a specified number of items in the enumeration sequence.
	{ "Skip", PyIEnumenumtype)s::Skip, 1 },	// @pymeth Skip|Skips over the next specified elementes.
	{ "Reset", PyIEnumenumtype)s::Reset, 1 },	// @pymeth Reset|Resets the enumeration sequence to the beginning.
	{ "Clone", PyIEnumenumtype)s::Clone, 1 },	// @pymeth Clone|Creates another enumerator that contains the same enumeration state as the current one.
	{ NULL }
};

PyComEnumTypeObject PyIEnumenumtype)s::type("PyIEnumenumtype)s",
		&PyIUnknown::type,
		sizeof(PyIEnumenumtype)s),
		PyIEnumenumtype)s_methods,
		GET_PYCOM_CTOR(PyIEnumenumtype)s));
")
end

function _write_enumgw_cpp(f, interface)
enumtype = interface.name[6:end]
if is_interface_enum(enumtype)
enum_interface = "I" + enumtype[begin:-1]
converter = "if ( !PyCom_InterfaceFromPyObject(ob, IID_enum_interface)s, (void **)&rgVar[i], FALSE) )"
argdeclare = "enum_interface)s __RPC_FAR * __RPC_FAR *rgVar"
else
argdeclare = "enumtype)s __RPC_FAR *rgVar"
converter = "if ( !PyCom_PyObjectAsenumtype)s(ob, &rgVar[i]) )"
end
write(f, "
// ---------------------------------------------------
//
// Gateway Implementation

// Std delegation
STDMETHODIMP_(ULONG) PyGEnumenumtype)s::AddRef(void) {return PyGatewayBase::AddRef();}
STDMETHODIMP_(ULONG) PyGEnumenumtype)s::Release(void) {return PyGatewayBase::Release();}
STDMETHODIMP PyGEnumenumtype)s::QueryInterface(REFIID iid, void ** obj) {return PyGatewayBase::QueryInterface(iid, obj);}
STDMETHODIMP PyGEnumenumtype)s::GetTypeInfoCount(UINT FAR* pctInfo) {return PyGatewayBase::GetTypeInfoCount(pctInfo);}
STDMETHODIMP PyGEnumenumtype)s::GetTypeInfo(UINT itinfo, LCID lcid, ITypeInfo FAR* FAR* pptInfo) {return PyGatewayBase::GetTypeInfo(itinfo, lcid, pptInfo);}
STDMETHODIMP PyGEnumenumtype)s::GetIDsOfNames(REFIID refiid, OLECHAR FAR* FAR* rgszNames, UINT cNames, LCID lcid, DISPID FAR* rgdispid) {return PyGatewayBase::GetIDsOfNames( refiid, rgszNames, cNames, lcid, rgdispid);}
STDMETHODIMP PyGEnumenumtype)s::Invoke(DISPID dispid, REFIID riid, LCID lcid, WORD wFlags, DISPPARAMS FAR* params, VARIANT FAR* pVarResult, EXCEPINFO FAR* pexcepinfo, UINT FAR* puArgErr) {return PyGatewayBase::Invoke( dispid, riid, lcid, wFlags, params, pVarResult, pexcepinfo, puArgErr);}

STDMETHODIMP PyGEnumenumtype)s::Next( 
            /* [in] */ ULONG celt,
            /* [length_is][size_is][out] */ argdeclare)s,
            /* [out] */ ULONG __RPC_FAR *pCeltFetched)
{
	PY_GATEWAY_METHOD;
	PyObject *result;
	HRESULT hr = InvokeViaPolicy("Next", &result, "i", celt);
	if ( FAILED(hr) )
		return hr;

	if ( !PySequence_Check(result) )
		goto error;
	int len;
	len = PyObject_Length(result);
	if ( len == -1 )
		goto error;
	if ( len > (int)celt)
		len = celt;

	if ( pCeltFetched )
		*pCeltFetched = len;

	int i;
	for ( i = 0; i < len; ++i )
	{
		PyObject *ob = PySequence_GetItem(result, i);
		if ( ob == NULL )
			goto error;

		converter)s
		{
			Py_DECREF(result);
			return PyCom_SetCOMErrorFromPyException(IID_IEnumenumtype)s);
		}
	}

	Py_DECREF(result);

	return len < (int)celt ? S_FALSE : S_OK;

  error:
	PyErr_Clear();	// just in case
	Py_DECREF(result);
	return PyCom_HandleIEnumNoSequence(IID_IEnumenumtype)s);
}

STDMETHODIMP PyGEnumenumtype)s::Skip( 
            /* [in] */ ULONG celt)
{
	PY_GATEWAY_METHOD;
	return InvokeViaPolicy("Skip", NULL, "i", celt);
}

STDMETHODIMP PyGEnumenumtype)s::Reset(void)
{
	PY_GATEWAY_METHOD;
	return InvokeViaPolicy("Reset");
}

STDMETHODIMP PyGEnumenumtype)s::Clone( 
            /* [out] */ IEnumenumtype)s __RPC_FAR *__RPC_FAR *ppEnum)
{
	PY_GATEWAY_METHOD;
	PyObject * result;
	HRESULT hr = InvokeViaPolicy("Clone", &result);
	if ( FAILED(hr) )
		return hr;

	/*
	** Make sure we have the right kind of object: we should have some kind
	** of IUnknown subclass wrapped into a PyIUnknown instance.
	*/
	if ( !PyIBase::is_object(result, &PyIUnknown::type) )
	{
		/* the wrong kind of object was returned to us */
		Py_DECREF(result);
		return PyCom_SetCOMErrorFromSimple(E_FAIL, IID_IEnumenumtype)s);
	}

	/*
	** Get the IUnknown out of the thing. note that the Python ob maintains
	** a reference, so we don't have to explicitly AddRef() here.
	*/
	IUnknown *punk = ((PyIUnknown *)result)->m_obj;
	if ( !punk )
	{
		/* damn. the object was released. */
		Py_DECREF(result);
		return PyCom_SetCOMErrorFromSimple(E_FAIL, IID_IEnumenumtype)s);
	}

	/*
	** Get the interface we want. note it is returned with a refcount.
	** This QI is actually going to instantiate a PyGEnumenumtype)s.
	*/
	hr = punk->QueryInterface(IID_IEnumenumtype)s, (LPVOID *)ppEnum);

	/* done with the result; this DECREF is also for <punk> */
	Py_DECREF(result);

	return PyCom_CheckIEnumNextResult(hr, IID_IEnumenumtype)s);
}
")
end
