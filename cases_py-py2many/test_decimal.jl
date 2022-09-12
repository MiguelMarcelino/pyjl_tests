# Transpiled with flags: 
# - oop
#= 
These are the test cases for the Decimal module.

There are two groups of tests, Arithmetic and Behaviour. The former test
the Decimal arithmetic using the tests provided by Mike Cowlishaw. The latter
test the pythonic behaviour according to PEP 327.

Cowlishaw's tests can be downloaded from:

   http://speleotrove.com/decimal/dectest.zip

This test module can be called from command line with one parameter (Arithmetic
or Behaviour) to test each part, or without parameter to test both parts. If
you're working through IDLE, you can import this test module and call test_main()
with the corresponding argument.
 =#
using ObjectOriented
using OrderedCollections
using Random
using Test
import _testcapi
using locale: CHAR_MAX
using doctest: IGNORE_EXCEPTION_DETAIL
import optparse



import warnings
import copy


import locale


using test.support.import_helper: import_fresh_module


import inspect
import threading
if sys.platform == "darwin"
darwin_malloc_err_warning("test_decimal")
end
C = import_fresh_module("decimal", fresh = ["_decimal"])
P = import_fresh_module("decimal", blocked = ["_decimal"])
import decimal as orig_sys_decimal
cfractions = import_fresh_module("fractions", fresh = ["fractions"])
sys.modules["decimal"] = P
pfractions = import_fresh_module("fractions", fresh = ["fractions"])
sys.modules["decimal"] = C
fractions = Dict(C => cfractions, P => pfractions)
sys.modules["decimal"] = orig_sys_decimal
Signals = Dict(C => C ? (tuple(keys(getcontext(C).flags))) : (nothing), P => tuple(keys(getcontext(P).flags)))
OrderedSignals = Dict(C => C ? ([C.Clamped, C.Rounded, C.Inexact, C.Subnormal, C.Underflow, C.Overflow, C.DivisionByZero, C.InvalidOperation, C.FloatOperation]) : (nothing), P => [P.Clamped, P.Rounded, P.Inexact, P.Subnormal, P.Underflow, P.Overflow, P.DivisionByZero, P.InvalidOperation, P.FloatOperation])
function assert_signals(cls, context, attr, expected)
d = getfield(context, :attr)
@test all((s ∈ expected ? (d[s + 1]) : (!(d[s + 1])) for s in d))
end

ROUND_UP = P.ROUND_UP
ROUND_DOWN = P.ROUND_DOWN
ROUND_CEILING = P.ROUND_CEILING
ROUND_FLOOR = P.ROUND_FLOOR
ROUND_HALF_UP = P.ROUND_HALF_UP
ROUND_HALF_DOWN = P.ROUND_HALF_DOWN
ROUND_HALF_EVEN = P.ROUND_HALF_EVEN
ROUND_05UP = P.ROUND_05UP
RoundingModes = [ROUND_UP, ROUND_DOWN, ROUND_CEILING, ROUND_FLOOR, ROUND_HALF_UP, ROUND_HALF_DOWN, ROUND_HALF_EVEN, ROUND_05UP]
ORIGINAL_CONTEXT = Dict(C => C ? (copy(getcontext(C))) : (nothing), P => copy(getcontext(P)))
function init(m)
if !m
return
end
DefaultTestContext = Context(m, prec = 9, rounding = ROUND_HALF_EVEN, traps = fromkeys(dict, Signals[m], 0))
setcontext(m, DefaultTestContext)
end

TESTDATADIR = "decimaltestdata"
if abspath(PROGRAM_FILE) == @__FILE__
file = ARGS[0]
test_numbers = TestNumbers()
test_int(test_numbers)
test_float(test_numbers)
test_complex(test_numbers)
aug_assign_test = AugAssignTest()
testBasic(aug_assign_test)
testInList(aug_assign_test)
testInDict(aug_assign_test)
testSequences(aug_assign_test)
testCustomMethods1(aug_assign_test)
testCustomMethods2(aug_assign_test)
legacy_base64_test_case = LegacyBase64TestCase()
test_encodebytes(legacy_base64_test_case)
test_decodebytes(legacy_base64_test_case)
test_encode(legacy_base64_test_case)
test_decode(legacy_base64_test_case)
base_x_y_test_case = BaseXYTestCase()
test_b64encode(base_x_y_test_case)
test_b64decode(base_x_y_test_case)
test_b64decode_padding_error(base_x_y_test_case)
test_b64decode_invalid_chars(base_x_y_test_case)
test_b32encode(base_x_y_test_case)
test_b32decode(base_x_y_test_case)
test_b32decode_casefold(base_x_y_test_case)
test_b32decode_error(base_x_y_test_case)
test_b32hexencode(base_x_y_test_case)
test_b32hexencode_other_types(base_x_y_test_case)
test_b32hexdecode(base_x_y_test_case)
test_b32hexdecode_other_types(base_x_y_test_case)
test_b32hexdecode_error(base_x_y_test_case)
test_b16encode(base_x_y_test_case)
test_b16decode(base_x_y_test_case)
test_a85encode(base_x_y_test_case)
test_b85encode(base_x_y_test_case)
test_a85decode(base_x_y_test_case)
test_b85decode(base_x_y_test_case)
test_a85_padding(base_x_y_test_case)
test_b85_padding(base_x_y_test_case)
test_a85decode_errors(base_x_y_test_case)
test_b85decode_errors(base_x_y_test_case)
test_decode_nonascii_str(base_x_y_test_case)
test_ErrorHeritage(base_x_y_test_case)
test_RFC4648_test_cases(base_x_y_test_case)
test_main = TestMain()
test_encode_decode(test_main)
test_encode_file(test_main)
test_encode_from_stdin(test_main)
test_decode(test_main)
tearDown(test_main)
rat_test_case = RatTestCase()
test_gcd(rat_test_case)
test_constructor(rat_test_case)
test_add(rat_test_case)
test_sub(rat_test_case)
test_mul(rat_test_case)
test_div(rat_test_case)
test_floordiv(rat_test_case)
test_eq(rat_test_case)
test_true_div(rat_test_case)
operation_order_tests = OperationOrderTests()
test_comparison_orders(operation_order_tests)
fallback_blocking_tests = FallbackBlockingTests()
test_fallback_rmethod_blocking(fallback_blocking_tests)
test_fallback_ne_blocking(fallback_blocking_tests)
bool_test = BoolTest()
test_repr(bool_test)
test_str(bool_test)
test_int(bool_test)
test_float(bool_test)
test_math(bool_test)
test_convert(bool_test)
test_keyword_args(bool_test)
test_format(bool_test)
test_hasattr(bool_test)
test_callable(bool_test)
test_isinstance(bool_test)
test_issubclass(bool_test)
test_contains(bool_test)
test_string(bool_test)
test_boolean(bool_test)
test_fileclosed(bool_test)
test_types(bool_test)
test_operator(bool_test)
test_marshal(bool_test)
test_pickle(bool_test)
test_picklevalues(bool_test)
test_convert_to_bool(bool_test)
test_from_bytes(bool_test)
test_sane_len(bool_test)
test_blocked(bool_test)
test_real_and_imag(bool_test)
test_bool_called_at_least_once(bool_test)
builtin_test = BuiltinTest()
test_import(builtin_test)
test_abs(builtin_test)
test_all(builtin_test)
test_any(builtin_test)
test_ascii(builtin_test)
test_neg(builtin_test)
test_callable(builtin_test)
test_chr(builtin_test)
test_cmp(builtin_test)
test_compile(builtin_test)
test_compile_top_level_await_no_coro(builtin_test)
test_compile_top_level_await(builtin_test)
test_compile_top_level_await_invalid_cases(builtin_test)
test_compile_async_generator(builtin_test)
test_delattr(builtin_test)
test_dir(builtin_test)
test_divmod(builtin_test)
test_eval(builtin_test)
test_general_eval(builtin_test)
test_exec(builtin_test)
test_exec_globals(builtin_test)
test_exec_redirected(builtin_test)
test_filter(builtin_test)
test_filter_pickle(builtin_test)
test_getattr(builtin_test)
test_hasattr(builtin_test)
test_hash(builtin_test)
test_hex(builtin_test)
test_id(builtin_test)
test_iter(builtin_test)
test_isinstance(builtin_test)
test_issubclass(builtin_test)
test_len(builtin_test)
test_map(builtin_test)
test_map_pickle(builtin_test)
test_max(builtin_test)
test_min(builtin_test)
test_next(builtin_test)
test_oct(builtin_test)
test_open(builtin_test)
test_open_default_encoding(builtin_test)
test_open_non_inheritable(builtin_test)
test_ord(builtin_test)
test_pow(builtin_test)
test_input(builtin_test)
test_repr(builtin_test)
test_round(builtin_test)
test_round_large(builtin_test)
test_bug_27936(builtin_test)
test_setattr(builtin_test)
test_sum(builtin_test)
test_type(builtin_test)
test_vars(builtin_test)
test_zip(builtin_test)
test_zip_pickle(builtin_test)
test_zip_pickle_strict(builtin_test)
test_zip_pickle_strict_fail(builtin_test)
test_zip_bad_iterable(builtin_test)
test_zip_strict(builtin_test)
test_zip_strict_iterators(builtin_test)
test_zip_strict_error_handling(builtin_test)
test_zip_strict_error_handling_stopiteration(builtin_test)
test_zip_result_gc(builtin_test)
test_format(builtin_test)
test_bin(builtin_test)
test_bytearray_translate(builtin_test)
test_bytearray_extend_error(builtin_test)
test_construct_singletons(builtin_test)
test_warning_notimplemented(builtin_test)
test_breakpoint = TestBreakpoint()
setUp(test_breakpoint)
test_breakpoint(test_breakpoint)
test_breakpoint_with_breakpointhook_set(test_breakpoint)
test_breakpoint_with_breakpointhook_reset(test_breakpoint)
test_breakpoint_with_args_and_keywords(test_breakpoint)
test_breakpoint_with_passthru_error(test_breakpoint)
test_envar_good_path_builtin(test_breakpoint)
test_envar_good_path_other(test_breakpoint)
test_envar_good_path_noop_0(test_breakpoint)
test_envar_good_path_empty_string(test_breakpoint)
test_envar_unimportable(test_breakpoint)
test_envar_ignored_when_hook_is_set(test_breakpoint)
pty_tests = PtyTests()
test_input_tty(pty_tests)
test_input_tty_non_ascii(pty_tests)
test_input_tty_non_ascii_unicode_errors(pty_tests)
test_input_no_stdout_fileno(pty_tests)
test_sorted = TestSorted()
test_basic(test_sorted)
test_bad_arguments(test_sorted)
test_inputtypes(test_sorted)
test_baddecorator(test_sorted)
shutdown_test = ShutdownTest()
test_cleanup(shutdown_test)
test_type = TestType()
test_new_type(test_type)
test_type_nokwargs(test_type)
test_type_name(test_type)
test_type_qualname(test_type)
test_type_doc(test_type)
test_bad_args(test_type)
test_bad_slots(test_type)
test_namespace_order(test_type)
bytes_test = BytesTest()
test_getitem_error(bytes_test)
test_buffer_is_readonly(bytes_test)
test_bytes_blocking(bytes_test)
test_repeat_id_preserving(bytes_test)
byte_array_test = ByteArrayTest()
test_getitem_error(byte_array_test)
test_setitem_error(byte_array_test)
test_nohash(byte_array_test)
test_bytearray_api(byte_array_test)
test_reverse(byte_array_test)
test_clear(byte_array_test)
test_copy(byte_array_test)
test_regexps(byte_array_test)
test_setitem(byte_array_test)
test_delitem(byte_array_test)
test_setslice(byte_array_test)
test_setslice_extend(byte_array_test)
test_fifo_overrun(byte_array_test)
test_del_expand(byte_array_test)
test_extended_set_del_slice(byte_array_test)
test_setslice_trap(byte_array_test)
test_iconcat(byte_array_test)
test_irepeat(byte_array_test)
test_irepeat_1char(byte_array_test)
test_alloc(byte_array_test)
test_init_alloc(byte_array_test)
test_extend(byte_array_test)
test_remove(byte_array_test)
test_pop(byte_array_test)
test_nosort(byte_array_test)
test_append(byte_array_test)
test_insert(byte_array_test)
test_copied(byte_array_test)
test_partition_bytearray_doesnt_share_nullstring(byte_array_test)
test_resize_forbidden(byte_array_test)
test_obsolete_write_lock(byte_array_test)
test_iterator_pickling2(byte_array_test)
test_iterator_length_hint(byte_array_test)
test_repeat_after_setslice(byte_array_test)
assorted_bytes_test = AssortedBytesTest()
test_repr_str(assorted_bytes_test)
test_format(assorted_bytes_test)
test_compare_bytes_to_bytearray(assorted_bytes_test)
test_doc(assorted_bytes_test)
test_from_bytearray(assorted_bytes_test)
test_to_str(assorted_bytes_test)
test_literal(assorted_bytes_test)
test_split_bytearray(assorted_bytes_test)
test_rsplit_bytearray(assorted_bytes_test)
test_return_self(assorted_bytes_test)
test_compare(assorted_bytes_test)
bytearray_p_e_p3137_test = BytearrayPEP3137Test()
test_returns_new_copy(bytearray_p_e_p3137_test)
byte_array_as_string_test = ByteArrayAsStringTest()
bytes_as_string_test = BytesAsStringTest()
byte_array_subclass_test = ByteArraySubclassTest()
test_init_override(byte_array_subclass_test)
bytes_subclass_test = BytesSubclassTest()
test_user_objects = TestUserObjects()
test_str_protocol(test_user_objects)
test_list_protocol(test_user_objects)
test_dict_protocol(test_user_objects)
test_list_copy(test_user_objects)
test_dict_copy(test_user_objects)
test_chain_map = TestChainMap()
test_basics(test_chain_map)
test_ordering(test_chain_map)
test_constructor(test_chain_map)
test_bool(test_chain_map)
test_missing(test_chain_map)
test_order_preservation(test_chain_map)
test_iter_not_calling_getitem_on_maps(test_chain_map)
test_dict_coercion(test_chain_map)
test_new_child(test_chain_map)
test_union_operators(test_chain_map)
test_named_tuple = TestNamedTuple()
test_factory(test_named_tuple)
test_defaults(test_named_tuple)
test_readonly(test_named_tuple)
test_factory_doc_attr(test_named_tuple)
test_field_doc(test_named_tuple)
test_field_doc_reuse(test_named_tuple)
test_field_repr(test_named_tuple)
test_name_fixer(test_named_tuple)
test_module_parameter(test_named_tuple)
test_instance(test_named_tuple)
test_tupleness(test_named_tuple)
test_odd_sizes(test_named_tuple)
test_pickle(test_named_tuple)
test_copy(test_named_tuple)
test_name_conflicts(test_named_tuple)
test_repr(test_named_tuple)
test_keyword_only_arguments(test_named_tuple)
test_namedtuple_subclass_issue_24931(test_named_tuple)
test_field_descriptor(test_named_tuple)
test_new_builtins_issue_43102(test_named_tuple)
test_match_args(test_named_tuple)
a_b_c_test_case = ABCTestCase()
test_counter = TestCounter()
test_basics(test_counter)
test_init(test_counter)
test_total(test_counter)
test_order_preservation(test_counter)
test_update(test_counter)
test_copying(test_counter)
test_copy_subclass(test_counter)
test_conversions(test_counter)
test_invariant_for_the_in_operator(test_counter)
test_multiset_operations(test_counter)
test_inplace_operations(test_counter)
test_subtract(test_counter)
test_unary(test_counter)
test_repr_nonsortable(test_counter)
test_helper_function(test_counter)
test_multiset_operations_equivalent_to_set_operations(test_counter)
test_eq(test_counter)
test_le(test_counter)
test_lt(test_counter)
test_ge(test_counter)
test_gt(test_counter)
comparison_test = ComparisonTest()
test_comparisons(comparison_test)
test_id_comparisons(comparison_test)
test_ne_defaults_to_not_eq(comparison_test)
test_ne_high_priority(comparison_test)
test_ne_low_priority(comparison_test)
test_other_delegation(comparison_test)
test_issue_1393(comparison_test)
complex_test = ComplexTest()
test_truediv(complex_test)
test_truediv_zero_division(complex_test)
test_floordiv(complex_test)
test_floordiv_zero_division(complex_test)
test_richcompare(complex_test)
test_richcompare_boundaries(complex_test)
test_mod(complex_test)
test_mod_zero_division(complex_test)
test_divmod(complex_test)
test_divmod_zero_division(complex_test)
test_pow(complex_test)
test_pow_with_small_integer_exponents(complex_test)
test_boolcontext(complex_test)
test_conjugate(complex_test)
test_constructor(complex_test)
test_constructor_special_numbers(complex_test)
test_underscores(complex_test)
test_hash(complex_test)
test_abs(complex_test)
test_repr_str(complex_test)
test_negative_zero_repr_str(complex_test)
test_neg(complex_test)
test_getnewargs(complex_test)
test_plus_minus_0j(complex_test)
test_negated_imaginary_literal(complex_test)
test_overflow(complex_test)
test_repr_roundtrip(complex_test)
test_format(complex_test)
test_contains = TestContains()
test_common_tests(test_contains)
test_builtin_sequence_types(test_contains)
test_nonreflexive(test_contains)
test_block_fallback(test_contains)
test_abstract_context_manager = TestAbstractContextManager()
test_enter(test_abstract_context_manager)
test_exit_is_abstract(test_abstract_context_manager)
test_structural_subclassing(test_abstract_context_manager)
context_manager_test_case = ContextManagerTestCase()
test_contextmanager_plain(context_manager_test_case)
test_contextmanager_finally(context_manager_test_case)
test_contextmanager_no_reraise(context_manager_test_case)
test_contextmanager_trap_yield_after_throw(context_manager_test_case)
test_contextmanager_except(context_manager_test_case)
test_contextmanager_except_stopiter(context_manager_test_case)
test_contextmanager_except_pep479(context_manager_test_case)
test_contextmanager_do_not_unchain_non_stopiteration_exceptions(context_manager_test_case)
test_contextmanager_attribs(context_manager_test_case)
test_contextmanager_doc_attrib(context_manager_test_case)
test_instance_docstring_given_cm_docstring(context_manager_test_case)
test_keywords(context_manager_test_case)
test_nokeepref(context_manager_test_case)
test_param_errors(context_manager_test_case)
test_recursive(context_manager_test_case)
closing_test_case = ClosingTestCase()
test_instance_docs(closing_test_case)
test_closing(closing_test_case)
test_closing_error(closing_test_case)
nullcontext_test_case = NullcontextTestCase()
test_nullcontext(nullcontext_test_case)
file_context_test_case = FileContextTestCase()
testWithOpen(file_context_test_case)
lock_context_test_case = LockContextTestCase()
testWithLock(lock_context_test_case)
testWithRLock(lock_context_test_case)
testWithCondition(lock_context_test_case)
testWithSemaphore(lock_context_test_case)
testWithBoundedSemaphore(lock_context_test_case)
test_context_decorator = TestContextDecorator()
test_instance_docs(test_context_decorator)
test_contextdecorator(test_context_decorator)
test_contextdecorator_with_exception(test_context_decorator)
test_decorator(test_context_decorator)
test_decorator_with_exception(test_context_decorator)
test_decorating_method(test_context_decorator)
test_typo_enter(test_context_decorator)
test_typo_exit(test_context_decorator)
test_contextdecorator_as_mixin(test_context_decorator)
test_contextmanager_as_decorator(test_context_decorator)
test_exit_stack = TestExitStack()
test_redirect_stdout = TestRedirectStdout()
test_redirect_stderr = TestRedirectStderr()
test_suppress = TestSuppress()
test_instance_docs(test_suppress)
test_no_result_from_enter(test_suppress)
test_no_exception(test_suppress)
test_exact_exception(test_suppress)
test_exception_hierarchy(test_suppress)
test_other_exception(test_suppress)
test_no_args(test_suppress)
test_multiple_exception_args(test_suppress)
test_cm_is_reentrant(test_suppress)
test_abstract_async_context_manager = TestAbstractAsyncContextManager()
test_exit_is_abstract(test_abstract_async_context_manager)
test_structural_subclassing(test_abstract_async_context_manager)
async_context_manager_test_case = AsyncContextManagerTestCase()
test_contextmanager_attribs(async_context_manager_test_case)
test_contextmanager_doc_attrib(async_context_manager_test_case)
aclosing_test_case = AclosingTestCase()
test_instance_docs(aclosing_test_case)
test_async_exit_stack = TestAsyncExitStack()
setUp(test_async_exit_stack)
test_async_nullcontext = TestAsyncNullcontext()
test_case = TestCase()
test_no_fields(test_case)
test_no_fields_but_member_variable(test_case)
test_one_field_no_default(test_case)
test_field_default_default_factory_error(test_case)
test_field_repr(test_case)
test_named_init_params(test_case)
test_two_fields_one_default(test_case)
test_overwrite_hash(test_case)
test_overwrite_fields_in_derived_class(test_case)
test_field_named_self(test_case)
test_field_named_object(test_case)
test_field_named_object_frozen(test_case)
test_field_named_like_builtin(test_case)
test_field_named_like_builtin_frozen(test_case)
test_0_field_compare(test_case)
test_1_field_compare(test_case)
test_simple_compare(test_case)
test_compare_subclasses(test_case)
test_eq_order(test_case)
test_field_no_default(test_case)
test_field_default(test_case)
test_not_in_repr(test_case)
test_not_in_compare(test_case)
test_hash_field_rules(test_case)
test_init_false_no_default(test_case)
test_class_marker(test_case)
test_field_order(test_case)
test_class_attrs(test_case)
test_disallowed_mutable_defaults(test_case)
test_deliberately_mutable_defaults(test_case)
test_no_options(test_case)
test_not_tuple(test_case)
test_not_other_dataclass(test_case)
test_function_annotations(test_case)
test_missing_default(test_case)
test_missing_default_factory(test_case)
test_missing_repr(test_case)
test_dont_include_other_annotations(test_case)
test_post_init(test_case)
test_post_init_super(test_case)
test_post_init_staticmethod(test_case)
test_post_init_classmethod(test_case)
test_class_var(test_case)
test_class_var_no_default(test_case)
test_class_var_default_factory(test_case)
test_class_var_with_default(test_case)
test_class_var_frozen(test_case)
test_init_var_no_default(test_case)
test_init_var_default_factory(test_case)
test_init_var_with_default(test_case)
test_init_var(test_case)
test_init_var_preserve_type(test_case)
test_init_var_inheritance(test_case)
test_default_factory(test_case)
test_default_factory_with_no_init(test_case)
test_default_factory_not_called_if_value_given(test_case)
test_default_factory_derived(test_case)
test_intermediate_non_dataclass(test_case)
test_classvar_default_factory(test_case)
test_is_dataclass(test_case)
test_is_dataclass_when_getattr_always_returns(test_case)
test_is_dataclass_genericalias(test_case)
test_helper_fields_with_class_instance(test_case)
test_helper_fields_exception(test_case)
test_helper_asdict(test_case)
test_helper_asdict_raises_on_classes(test_case)
test_helper_asdict_copy_values(test_case)
test_helper_asdict_nested(test_case)
test_helper_asdict_builtin_containers(test_case)
test_helper_asdict_builtin_object_containers(test_case)
test_helper_asdict_factory(test_case)
test_helper_asdict_namedtuple(test_case)
test_helper_asdict_namedtuple_key(test_case)
test_helper_asdict_namedtuple_derived(test_case)
test_helper_astuple(test_case)
test_helper_astuple_raises_on_classes(test_case)
test_helper_astuple_copy_values(test_case)
test_helper_astuple_nested(test_case)
test_helper_astuple_builtin_containers(test_case)
test_helper_astuple_builtin_object_containers(test_case)
test_helper_astuple_factory(test_case)
test_helper_astuple_namedtuple(test_case)
test_dynamic_class_creation(test_case)
test_dynamic_class_creation_using_field(test_case)
test_init_in_order(test_case)
test_items_in_dicts(test_case)
test_alternate_classmethod_constructor(test_case)
test_field_metadata_default(test_case)
test_field_metadata_mapping(test_case)
test_field_metadata_custom_mapping(test_case)
test_generic_dataclasses(test_case)
test_generic_extending(test_case)
test_generic_dynamic(test_case)
test_dataclasses_pickleable(test_case)
test_dataclasses_qualnames(test_case)
test_field_no_annotation = TestFieldNoAnnotation()
test_field_without_annotation(test_field_no_annotation)
test_field_without_annotation_but_annotation_in_base(test_field_no_annotation)
test_field_without_annotation_but_annotation_in_base_not_dataclass(test_field_no_annotation)
test_doc_string = TestDocString()
test_existing_docstring_not_overridden(test_doc_string)
test_docstring_no_fields(test_doc_string)
test_docstring_one_field(test_doc_string)
test_docstring_two_fields(test_doc_string)
test_docstring_three_fields(test_doc_string)
test_docstring_one_field_with_default(test_doc_string)
test_docstring_one_field_with_default_none(test_doc_string)
test_docstring_list_field(test_doc_string)
test_docstring_list_field_with_default_factory(test_doc_string)
test_docstring_deque_field(test_doc_string)
test_docstring_deque_field_with_default_factory(test_doc_string)
test_init = TestInit()
test_base_has_init(test_init)
test_no_init(test_init)
test_overwriting_init(test_init)
test_inherit_from_protocol(test_init)
test_repr = TestRepr()
test_repr(test_repr)
test_no_repr(test_repr)
test_overwriting_repr(test_repr)
test_eq = TestEq()
test_no_eq(test_eq)
test_overwriting_eq(test_eq)
test_ordering = TestOrdering()
test_functools_total_ordering(test_ordering)
test_no_order(test_ordering)
test_overwriting_order(test_ordering)
test_hash = TestHash()
test_unsafe_hash(test_hash)
test_hash_rules(test_hash)
test_eq_only(test_hash)
test_0_field_hash(test_hash)
test_1_field_hash(test_hash)
test_hash_no_args(test_hash)
test_frozen = TestFrozen()
test_frozen(test_frozen)
test_inherit(test_frozen)
test_inherit_nonfrozen_from_empty_frozen(test_frozen)
test_inherit_nonfrozen_from_empty(test_frozen)
test_inherit_nonfrozen_from_frozen(test_frozen)
test_inherit_frozen_from_nonfrozen(test_frozen)
test_inherit_from_normal_class(test_frozen)
test_non_frozen_normal_derived(test_frozen)
test_overwriting_frozen(test_frozen)
test_frozen_hash(test_frozen)
test_slots = TestSlots()
test_simple(test_slots)
test_derived_added_field(test_slots)
test_generated_slots(test_slots)
test_add_slots_when_slots_exists(test_slots)
test_generated_slots_value(test_slots)
test_returns_new_class(test_slots)
test_frozen_pickle(test_slots)
test_slots_with_default_no_init(test_slots)
test_slots_with_default_factory_no_init(test_slots)
test_descriptors = TestDescriptors()
test_set_name(test_descriptors)
test_non_descriptor(test_descriptors)
test_lookup_on_instance(test_descriptors)
test_lookup_on_class(test_descriptors)
test_string_annotations = TestStringAnnotations()
test_classvar(test_string_annotations)
test_isnt_classvar(test_string_annotations)
test_initvar(test_string_annotations)
test_isnt_initvar(test_string_annotations)
test_classvar_module_level_import(test_string_annotations)
test_text_annotations(test_string_annotations)
test_make_dataclass = TestMakeDataclass()
test_simple(test_make_dataclass)
test_no_mutate_namespace(test_make_dataclass)
test_base(test_make_dataclass)
test_base_dataclass(test_make_dataclass)
test_init_var(test_make_dataclass)
test_class_var(test_make_dataclass)
test_other_params(test_make_dataclass)
test_no_types(test_make_dataclass)
test_invalid_type_specification(test_make_dataclass)
test_duplicate_field_names(test_make_dataclass)
test_keyword_field_names(test_make_dataclass)
test_non_identifier_field_names(test_make_dataclass)
test_underscore_field_names(test_make_dataclass)
test_funny_class_names_names(test_make_dataclass)
test_replace = TestReplace()
test(test_replace)
test_frozen(test_replace)
test_invalid_field_name(test_replace)
test_invalid_object(test_replace)
test_no_init(test_replace)
test_classvar(test_replace)
test_initvar_is_specified(test_replace)
test_initvar_with_default_value(test_replace)
test_recursive_repr(test_replace)
test_recursive_repr_two_attrs(test_replace)
test_recursive_repr_indirection(test_replace)
test_recursive_repr_indirection_two(test_replace)
test_recursive_repr_misc_attrs(test_replace)
test_abstract = TestAbstract()
test_abc_implementation(test_abstract)
test_maintain_abc(test_abstract)
test_match_args = TestMatchArgs()
test_match_args(test_match_args)
test_explicit_match_args(test_match_args)
test_bpo_43764(test_match_args)
test_match_args_argument(test_match_args)
test_make_dataclasses(test_match_args)
test_keyword_args = TestKeywordArgs()
test_no_classvar_kwarg(test_keyword_args)
test_field_marked_as_kwonly(test_keyword_args)
test_match_args(test_keyword_args)
test_KW_ONLY(test_keyword_args)
test_KW_ONLY_as_string(test_keyword_args)
test_KW_ONLY_twice(test_keyword_args)
test_post_init(test_keyword_args)
test_defaults(test_keyword_args)
test_make_dataclass(test_keyword_args)
else
file = @__FILE__
end
testdir = os.dirname(file)||os.curdir
directory = ((testdir + os.sep) + TESTDATADIR) + os.sep
skip_expected = !os.isdir(directory)
EXTENDEDERRORTEST = false
EXTRA_FUNCTIONALITY = hasfield(typeof(C), :DecClamped) ? (true) : (false)
requires_extra_functionality = unittest.skipUnless(EXTRA_FUNCTIONALITY, "test requires build with -DEXTRA_FUNCTIONALITY")
skip_if_extra_functionality = unittest.skipIf(EXTRA_FUNCTIONALITY, "test requires regular build")
@oodef mutable struct IBMTestCases <: unittest.TestCase
                    #= Class which tests the Decimal class against the IBM test cases. =#

                    ChangeDict::Dict{String, Any}
ErrorNames::Dict{String, Any}
LogicalFunctions::Tuple{String}
NameAdapter::Dict{String, String}
RoundingDict::Dict{String, Any}
context
ignore_list::Vector{String}
readcontext
skipped_test_ids
                    
function new(ChangeDict::Dict{String, Any} = Dict{String, Any}("precision" => self.change_precision, "rounding" => self.change_rounding_method, "maxexponent" => self.change_max_exponent, "minexponent" => self.change_min_exponent, "clamp" => self.change_clamp), ErrorNames::Dict{String, Any} = Dict{String, Any}("clamped" => self.decimal.Clamped, "conversion_syntax" => self.decimal.InvalidOperation, "division_by_zero" => self.decimal.DivisionByZero, "division_impossible" => self.decimal.InvalidOperation, "division_undefined" => self.decimal.InvalidOperation, "inexact" => self.decimal.Inexact, "invalid_context" => self.decimal.InvalidOperation, "invalid_operation" => self.decimal.InvalidOperation, "overflow" => self.decimal.Overflow, "rounded" => self.decimal.Rounded, "subnormal" => self.decimal.Subnormal, "underflow" => self.decimal.Underflow), LogicalFunctions::Tuple{String} = ("is_canonical", "is_finite", "is_infinite", "is_nan", "is_normal", "is_qnan", "is_signed", "is_snan", "is_subnormal", "is_zero", "same_quantum"), NameAdapter::Dict{String, String} = Dict{String, String}("and" => "logical_and", "apply" => "_apply", "class" => "number_class", "comparesig" => "compare_signal", "comparetotal" => "compare_total", "comparetotmag" => "compare_total_mag", "copy" => "copy_decimal", "copyabs" => "copy_abs", "copynegate" => "copy_negate", "copysign" => "copy_sign", "divideint" => "divide_int", "invert" => "logical_invert", "iscanonical" => "is_canonical", "isfinite" => "is_finite", "isinfinite" => "is_infinite", "isnan" => "is_nan", "isnormal" => "is_normal", "isqnan" => "is_qnan", "issigned" => "is_signed", "issnan" => "is_snan", "issubnormal" => "is_subnormal", "iszero" => "is_zero", "maxmag" => "max_mag", "minmag" => "min_mag", "nextminus" => "next_minus", "nextplus" => "next_plus", "nexttoward" => "next_toward", "or" => "logical_or", "reduce" => "normalize", "remaindernear" => "remainder_near", "samequantum" => "same_quantum", "squareroot" => "sqrt", "toeng" => "to_eng_string", "tointegral" => "to_integral_value", "tointegralx" => "to_integral_exact", "tosci" => "to_sci_string", "xor" => "logical_xor"), RoundingDict::Dict{String, Any} = Dict{String, Any}("ceiling" => ROUND_CEILING, "down" => ROUND_DOWN, "floor" => ROUND_FLOOR, "half_down" => ROUND_HALF_DOWN, "half_even" => ROUND_HALF_EVEN, "half_up" => ROUND_HALF_UP, "up" => ROUND_UP, "05up" => ROUND_05UP), context = Context(self.decimal), ignore_list::Vector{String} = ["#"], readcontext = Context(self.decimal), skipped_test_ids = Set(["scbx164", "scbx165", "expx901", "expx902", "expx903", "expx905", "lnx901", "lnx902", "lnx903", "lnx905", "logx901", "logx902", "logx903", "logx905", "powx1183", "powx1184", "powx4001", "powx4002", "powx4003", "powx4005", "powx4008", "powx4010", "powx4012", "powx4014"]))
ChangeDict = ChangeDict
ErrorNames = ErrorNames
LogicalFunctions = LogicalFunctions
NameAdapter = NameAdapter
RoundingDict = RoundingDict
context = context
ignore_list = ignore_list
readcontext = readcontext
skipped_test_ids = skipped_test_ids
new(ChangeDict, ErrorNames, LogicalFunctions, NameAdapter, RoundingDict, context, ignore_list, readcontext, skipped_test_ids)
end

                end
                function setUp(self::@like(IBMTestCases))
self.context = Context(self.decimal)
self.readcontext = Context(self.decimal)
self.ignore_list = ["#"]
self.skipped_test_ids = Set(["scbx164", "scbx165", "expx901", "expx902", "expx903", "expx905", "lnx901", "lnx902", "lnx903", "lnx905", "logx901", "logx902", "logx903", "logx905", "powx1183", "powx1184", "powx4001", "powx4002", "powx4003", "powx4005", "powx4008", "powx4010", "powx4012", "powx4014"])
if self.decimal == C
add(self.skipped_test_ids, "pwsx803")
add(self.skipped_test_ids, "pwsx805")
add(self.skipped_test_ids, "powx4302")
add(self.skipped_test_ids, "powx4303")
add(self.skipped_test_ids, "powx4342")
add(self.skipped_test_ids, "powx4343")
add(self.skipped_test_ids, "pwmx325")
add(self.skipped_test_ids, "pwmx326")
end
self.ChangeDict = Dict{String, Any}("precision" => self.change_precision, "rounding" => self.change_rounding_method, "maxexponent" => self.change_max_exponent, "minexponent" => self.change_min_exponent, "clamp" => self.change_clamp)
self.NameAdapter = Dict{String, String}("and" => "logical_and", "apply" => "_apply", "class" => "number_class", "comparesig" => "compare_signal", "comparetotal" => "compare_total", "comparetotmag" => "compare_total_mag", "copy" => "copy_decimal", "copyabs" => "copy_abs", "copynegate" => "copy_negate", "copysign" => "copy_sign", "divideint" => "divide_int", "invert" => "logical_invert", "iscanonical" => "is_canonical", "isfinite" => "is_finite", "isinfinite" => "is_infinite", "isnan" => "is_nan", "isnormal" => "is_normal", "isqnan" => "is_qnan", "issigned" => "is_signed", "issnan" => "is_snan", "issubnormal" => "is_subnormal", "iszero" => "is_zero", "maxmag" => "max_mag", "minmag" => "min_mag", "nextminus" => "next_minus", "nextplus" => "next_plus", "nexttoward" => "next_toward", "or" => "logical_or", "reduce" => "normalize", "remaindernear" => "remainder_near", "samequantum" => "same_quantum", "squareroot" => "sqrt", "toeng" => "to_eng_string", "tointegral" => "to_integral_value", "tointegralx" => "to_integral_exact", "tosci" => "to_sci_string", "xor" => "logical_xor")
self.RoundingDict = Dict{String, Any}("ceiling" => ROUND_CEILING, "down" => ROUND_DOWN, "floor" => ROUND_FLOOR, "half_down" => ROUND_HALF_DOWN, "half_even" => ROUND_HALF_EVEN, "half_up" => ROUND_HALF_UP, "up" => ROUND_UP, "05up" => ROUND_05UP)
self.ErrorNames = Dict{String, Any}("clamped" => self.decimal.Clamped, "conversion_syntax" => self.decimal.InvalidOperation, "division_by_zero" => self.decimal.DivisionByZero, "division_impossible" => self.decimal.InvalidOperation, "division_undefined" => self.decimal.InvalidOperation, "inexact" => self.decimal.Inexact, "invalid_context" => self.decimal.InvalidOperation, "invalid_operation" => self.decimal.InvalidOperation, "overflow" => self.decimal.Overflow, "rounded" => self.decimal.Rounded, "subnormal" => self.decimal.Subnormal, "underflow" => self.decimal.Underflow)
self.LogicalFunctions = ("is_canonical", "is_finite", "is_infinite", "is_nan", "is_normal", "is_qnan", "is_signed", "is_snan", "is_subnormal", "is_zero", "same_quantum")
end

function read_unlimited(self::@like(IBMTestCases), v, context)
#= Work around the limitations of the 32-bit _decimal version. The
           guaranteed maximum values for prec, Emax etc. are 425000000,
           but higher values usually work, except for rare corner cases.
           In particular, all of the IBM tests pass with maximum values
           of 1070000000. =#
if self.decimal == C&&self.decimal.MAX_EMAX == 425000000
_unsafe_setprec(self.readcontext, 1070000000)
_unsafe_setemax(self.readcontext, 1070000000)
_unsafe_setemin(self.readcontext, -1070000000)
return create_decimal(self.readcontext, v)
else
return Decimal(self.decimal, v, context)
end
end

function eval_file(self::@like(IBMTestCases), file)
global skip_expected
if skip_expected
throw(unittest.SkipTest)
end
readline(file) do f 
for line in f
line = replace(replace(line, "\r\n", ""), "\n", "")
try
t = eval_line(self, line)
catch exn
 let exception = exn
if exception isa self.decimal.DecimalException
fail(self, (("Exception \"" + exception.__class__.__name__) + "\" raised on line ") + line)
end
end
end
end
end
end

function eval_line(self::@like(IBMTestCases), s)
if find(s, " -> ") >= 0&&s[begin:2] != "--"&&!startswith(s, "  --")
s = strip((split(s, "->")[1] + "->") + split(split(s, "->")[2], "--")[1])
else
s = strip(split(s, "--")[1])
end
for ignore in self.ignore_list
if find(s, ignore) >= 0
return
end
end
if !s
return
elseif ":" ∈ s
return eval_directive(self, s)
else
return eval_equation(self, s)
end
end

function eval_directive(self::@like(IBMTestCases), s)
(funct, value) = (lower(strip(x)) for x in split(s, ":"))
if funct == "rounding"
value = self.RoundingDict[value]
else
try
value = parse(Int, value)
catch exn
if exn isa ValueError
#= pass =#
end
end
end
funct = get(self.ChangeDict, funct, () -> nothing)
funct(value)
end

function eval_equation(self::@like(IBMTestCases), s)
if !TEST_ALL&&rand() < 0.9
return
end
clear_flags(self.context)
try
Sides = split(s, "->")
L = split(strip(Sides[1]))
id = L[1]
if DEBUG
println("Test  $(id)")
end
funct = lower(L[2])
valstemp = L[3:end]
L = split(strip(Sides[2]))
ans = L[1]
exceptions = L[2:end]
catch exn
if exn isa (TypeError, AttributeError, IndexError)
throw(self.decimal.InvalidOperation)
end
end
function FixQuotes(val::@like(IBMTestCases))
val = replace(replace(val, "\'\'", "SingleQuote"), "\"\"", "DoubleQuote")
val = replace(replace(val, "\'", ""), "\"", "")
val = replace(replace(val, "SingleQuote", "\'"), "DoubleQuote", "\"")
return val
end

if id ∈ self.skipped_test_ids
return
end
fname = get(self.NameAdapter, funct, funct)
if fname == "rescale"
return
end
funct = getfield(self.context, :fname)
vals = []
conglomerate = ""
quote_ = 0
theirexceptions = [self.ErrorNames[lower(x)] for x in exceptions]
for exception in Signals[self.decimal]
self.context.traps[exception + 1] = 1
end
for exception in theirexceptions
self.context.traps[exception + 1] = 0
end
for (i, val) in enumerate(valstemp)
if (count(val, "\'") % 2) == 1
quote_ = 1 - quote_
end
if quote_
conglomerate = conglomerate + " " + val
continue;
else
val = conglomerate + val
conglomerate = ""
end
v = FixQuotes(val)
if fname ∈ ("to_sci_string", "to_eng_string")
if EXTENDEDERRORTEST
for error_ in theirexceptions
self.context.traps[error_ + 1] = 1
try
funct(create_decimal(self.context, v))
catch exn
if exn isa error_
#= pass =#
end
 let e = exn
if e isa Signals[self.decimal + 1]
fail(self, "Raised $(e) in $(s) when $(error_) disabled")
end
end
end
self.context.traps[error_ + 1] = 0
end
end
v = create_decimal(self.context, v)
else
v = read_unlimited(self, v, self.context)
end
push!(vals, v)
end
ans = FixQuotes(ans)
if EXTENDEDERRORTEST&&fname ∉ ("to_sci_string", "to_eng_string")
for error_ in theirexceptions
self.context.traps[error_ + 1] = 1
try
funct(vals...)
catch exn
if exn isa error_
#= pass =#
end
 let e = exn
if e isa Signals[self.decimal]
fail(self, "Raised $(e) in $(s) when $(error_) disabled")
end
end
end
self.context.traps[error_ + 1] = 0
end
ordered_errors = [e for e in OrderedSignals[self.decimal] if e ∈ theirexceptions ]
for error_ in ordered_errors
self.context.traps[error_ + 1] = 1
try
funct(vals...)
catch exn
if exn isa error_
#= pass =#
end
 let e = exn
if e isa Signals[self.decimal]
fail(self, "Raised $(type_(e)) in $(s); expected $(error_)")
end
end
end
end
for error_ in ordered_errors
self.context.traps[error_ + 1] = 0
end
end
if DEBUG
println("-- $(self.context)")
end
try
result = string(funct(vals...))
if fname ∈ self.LogicalFunctions
result = string(parse(Int, py"result"))
end
catch exn
 let error = exn
if error isa Signals[self.decimal]
fail(self, "Raised $(error) in $(s)")
end
end
println("ERROR: $(s)")
error()
end
myexceptions = getexceptions(self)
sort(myexceptions, key = repr)
sort(theirexceptions, key = repr)
@test (result == ans)
@test (myexceptions == theirexceptions)
end

function getexceptions(self::@like(IBMTestCases))::Any
return [e for e in Signals[self.decimal] if self.context.flags[e + 1] ]
end

function change_precision(self::@like(IBMTestCases), prec)
if self.decimal == C&&self.decimal.MAX_PREC == 425000000
_unsafe_setprec(self.context, prec)
else
self.context.prec = prec
end
end

function change_rounding_method(self::@like(IBMTestCases), rounding)
self.context.rounding_ = rounding
end

function change_min_exponent(self::@like(IBMTestCases), exp)
if self.decimal == C&&self.decimal.MAX_PREC == 425000000
_unsafe_setemin(self.context, exp)
else
self.context.Emin = exp
end
end

function change_max_exponent(self::@like(IBMTestCases), exp)
if self.decimal == C&&self.decimal.MAX_PREC == 425000000
_unsafe_setemax(self.context, exp)
else
self.context.Emax = exp
end
end

function change_clamp(self::@like(IBMTestCases), clamp)
self.context.clamp_ = clamp
end


@oodef mutable struct CIBMTestCases <: IBMTestCases
                    
                    ChangeDict::Dict{String, Any}
ErrorNames::Dict{String, Any}
LogicalFunctions::Tuple{String}
NameAdapter::Dict{String, String}
RoundingDict::Dict{String, Any}
context
decimal
ignore_list::Vector{String}
readcontext
skipped_test_ids
                    
function new(ChangeDict::Dict{String, Any} = Dict{String, Any}("precision" => self.change_precision, "rounding" => self.change_rounding_method, "maxexponent" => self.change_max_exponent, "minexponent" => self.change_min_exponent, "clamp" => self.change_clamp), ErrorNames::Dict{String, Any} = Dict{String, Any}("clamped" => self.decimal.Clamped, "conversion_syntax" => self.decimal.InvalidOperation, "division_by_zero" => self.decimal.DivisionByZero, "division_impossible" => self.decimal.InvalidOperation, "division_undefined" => self.decimal.InvalidOperation, "inexact" => self.decimal.Inexact, "invalid_context" => self.decimal.InvalidOperation, "invalid_operation" => self.decimal.InvalidOperation, "overflow" => self.decimal.Overflow, "rounded" => self.decimal.Rounded, "subnormal" => self.decimal.Subnormal, "underflow" => self.decimal.Underflow), LogicalFunctions::Tuple{String} = ("is_canonical", "is_finite", "is_infinite", "is_nan", "is_normal", "is_qnan", "is_signed", "is_snan", "is_subnormal", "is_zero", "same_quantum"), NameAdapter::Dict{String, String} = Dict{String, String}("and" => "logical_and", "apply" => "_apply", "class" => "number_class", "comparesig" => "compare_signal", "comparetotal" => "compare_total", "comparetotmag" => "compare_total_mag", "copy" => "copy_decimal", "copyabs" => "copy_abs", "copynegate" => "copy_negate", "copysign" => "copy_sign", "divideint" => "divide_int", "invert" => "logical_invert", "iscanonical" => "is_canonical", "isfinite" => "is_finite", "isinfinite" => "is_infinite", "isnan" => "is_nan", "isnormal" => "is_normal", "isqnan" => "is_qnan", "issigned" => "is_signed", "issnan" => "is_snan", "issubnormal" => "is_subnormal", "iszero" => "is_zero", "maxmag" => "max_mag", "minmag" => "min_mag", "nextminus" => "next_minus", "nextplus" => "next_plus", "nexttoward" => "next_toward", "or" => "logical_or", "reduce" => "normalize", "remaindernear" => "remainder_near", "samequantum" => "same_quantum", "squareroot" => "sqrt", "toeng" => "to_eng_string", "tointegral" => "to_integral_value", "tointegralx" => "to_integral_exact", "tosci" => "to_sci_string", "xor" => "logical_xor"), RoundingDict::Dict{String, Any} = Dict{String, Any}("ceiling" => ROUND_CEILING, "down" => ROUND_DOWN, "floor" => ROUND_FLOOR, "half_down" => ROUND_HALF_DOWN, "half_even" => ROUND_HALF_EVEN, "half_up" => ROUND_HALF_UP, "up" => ROUND_UP, "05up" => ROUND_05UP), context = Context(self.decimal), decimal = C, ignore_list::Vector{String} = ["#"], readcontext = Context(self.decimal), skipped_test_ids = Set(["scbx164", "scbx165", "expx901", "expx902", "expx903", "expx905", "lnx901", "lnx902", "lnx903", "lnx905", "logx901", "logx902", "logx903", "logx905", "powx1183", "powx1184", "powx4001", "powx4002", "powx4003", "powx4005", "powx4008", "powx4010", "powx4012", "powx4014"]))
ChangeDict = ChangeDict
ErrorNames = ErrorNames
LogicalFunctions = LogicalFunctions
NameAdapter = NameAdapter
RoundingDict = RoundingDict
context = context
decimal = decimal
ignore_list = ignore_list
readcontext = readcontext
skipped_test_ids = skipped_test_ids
new(ChangeDict, ErrorNames, LogicalFunctions, NameAdapter, RoundingDict, context, decimal, ignore_list, readcontext, skipped_test_ids)
end

                end
                

@oodef mutable struct PyIBMTestCases <: IBMTestCases
                    
                    ChangeDict::Dict{String, Any}
ErrorNames::Dict{String, Any}
LogicalFunctions::Tuple{String}
NameAdapter::Dict{String, String}
RoundingDict::Dict{String, Any}
context
decimal
ignore_list::Vector{String}
readcontext
skipped_test_ids
                    
function new(ChangeDict::Dict{String, Any} = Dict{String, Any}("precision" => self.change_precision, "rounding" => self.change_rounding_method, "maxexponent" => self.change_max_exponent, "minexponent" => self.change_min_exponent, "clamp" => self.change_clamp), ErrorNames::Dict{String, Any} = Dict{String, Any}("clamped" => self.decimal.Clamped, "conversion_syntax" => self.decimal.InvalidOperation, "division_by_zero" => self.decimal.DivisionByZero, "division_impossible" => self.decimal.InvalidOperation, "division_undefined" => self.decimal.InvalidOperation, "inexact" => self.decimal.Inexact, "invalid_context" => self.decimal.InvalidOperation, "invalid_operation" => self.decimal.InvalidOperation, "overflow" => self.decimal.Overflow, "rounded" => self.decimal.Rounded, "subnormal" => self.decimal.Subnormal, "underflow" => self.decimal.Underflow), LogicalFunctions::Tuple{String} = ("is_canonical", "is_finite", "is_infinite", "is_nan", "is_normal", "is_qnan", "is_signed", "is_snan", "is_subnormal", "is_zero", "same_quantum"), NameAdapter::Dict{String, String} = Dict{String, String}("and" => "logical_and", "apply" => "_apply", "class" => "number_class", "comparesig" => "compare_signal", "comparetotal" => "compare_total", "comparetotmag" => "compare_total_mag", "copy" => "copy_decimal", "copyabs" => "copy_abs", "copynegate" => "copy_negate", "copysign" => "copy_sign", "divideint" => "divide_int", "invert" => "logical_invert", "iscanonical" => "is_canonical", "isfinite" => "is_finite", "isinfinite" => "is_infinite", "isnan" => "is_nan", "isnormal" => "is_normal", "isqnan" => "is_qnan", "issigned" => "is_signed", "issnan" => "is_snan", "issubnormal" => "is_subnormal", "iszero" => "is_zero", "maxmag" => "max_mag", "minmag" => "min_mag", "nextminus" => "next_minus", "nextplus" => "next_plus", "nexttoward" => "next_toward", "or" => "logical_or", "reduce" => "normalize", "remaindernear" => "remainder_near", "samequantum" => "same_quantum", "squareroot" => "sqrt", "toeng" => "to_eng_string", "tointegral" => "to_integral_value", "tointegralx" => "to_integral_exact", "tosci" => "to_sci_string", "xor" => "logical_xor"), RoundingDict::Dict{String, Any} = Dict{String, Any}("ceiling" => ROUND_CEILING, "down" => ROUND_DOWN, "floor" => ROUND_FLOOR, "half_down" => ROUND_HALF_DOWN, "half_even" => ROUND_HALF_EVEN, "half_up" => ROUND_HALF_UP, "up" => ROUND_UP, "05up" => ROUND_05UP), context = Context(self.decimal), decimal = P, ignore_list::Vector{String} = ["#"], readcontext = Context(self.decimal), skipped_test_ids = Set(["scbx164", "scbx165", "expx901", "expx902", "expx903", "expx905", "lnx901", "lnx902", "lnx903", "lnx905", "logx901", "logx902", "logx903", "logx905", "powx1183", "powx1184", "powx4001", "powx4002", "powx4003", "powx4005", "powx4008", "powx4010", "powx4012", "powx4014"]))
ChangeDict = ChangeDict
ErrorNames = ErrorNames
LogicalFunctions = LogicalFunctions
NameAdapter = NameAdapter
RoundingDict = RoundingDict
context = context
decimal = decimal
ignore_list = ignore_list
readcontext = readcontext
skipped_test_ids = skipped_test_ids
new(ChangeDict, ErrorNames, LogicalFunctions, NameAdapter, RoundingDict, context, decimal, ignore_list, readcontext, skipped_test_ids)
end

                end
                

@oodef mutable struct ExplicitConstructionTest <: unittest.TestCase
                    #= Unit tests for Explicit Construction cases of Decimal. =#

                    
                    
                end
                function test_explicit_empty(self::@like(ExplicitConstructionTest))
Decimal = self.decimal.Decimal
@test (Decimal() == Decimal("0"))
end

function test_explicit_from_None(self::@like(ExplicitConstructionTest))
Decimal = self.decimal.Decimal
@test_throws
end

function test_explicit_from_int(self::@like(ExplicitConstructionTest))
Decimal = self.decimal.Decimal
d = Decimal(45)
@test (string(d) == "45")
d = Decimal(500000123)
@test (string(d) == "500000123")
d = Decimal(-45)
@test (string(d) == "-45")
d = Decimal(0)
@test (string(d) == "0")
for n in 0:31
for sign_ in (-1, 1)
for x in -5:4
i = sign_*(2^n + x)
d = Decimal(i)
@test (string(d) == string(i))
end
end
end
end

function test_explicit_from_string(self::@like(ExplicitConstructionTest))
Decimal = self.decimal.Decimal
InvalidOperation = self.decimal.InvalidOperation
localcontext = self.decimal.localcontext
@test (string(Decimal("")) == "NaN")
@test (string(Decimal("45")) == "45")
@test (string(Decimal("45.34")) == "45.34")
@test (string(Decimal("45e2")) == "4.5E+3")
@test (string(Decimal("ugly")) == "NaN")
@test (string(Decimal("1.3E4 \n")) == "1.3E+4")
@test (string(Decimal("  -7.89")) == "-7.89")
@test (string(Decimal("  3.45679  ")) == "3.45679")
@test (string(Decimal("1_3.3e4_0")) == "1.33E+41")
@test (string(Decimal("1_0_0_0")) == "1000")
for lead in ["", " ", " ", " "]
for trail in ["", " ", " ", " "]
@test (string(Decimal(lead * "9.311E+28" * trail)) == "9.311E+28")
end
end
localcontext() do c 
c.traps[InvalidOperation + 1] = true
@test_throws
@test_throws
@test_throws
@test_throws
@test_throws
@test_throws
@test_throws
@test_throws
end
end

function test_from_legacy_strings(self::@like(ExplicitConstructionTest))
Decimal = self.decimal.Decimal
context = Context(self.decimal)
s = _testcapi.unicode_legacy_string("9.999999")
@test (string(Decimal(s)) == "9.999999")
@test (string(create_decimal(context, s)) == "9.999999")
end

function test_explicit_from_tuples(self::@like(ExplicitConstructionTest))
Decimal = self.decimal.Decimal
d = Decimal((0, (0,), 0))
@test (string(d) == "0")
d = Decimal((1, (4, 5), 0))
@test (string(d) == "-45")
d = Decimal((0, (4, 5, 3, 4), -2))
@test (string(d) == "45.34")
d = Decimal((1, (4, 3, 4, 9, 1, 3, 5, 3, 4), -25))
@test (string(d) == "-4.34913534E-17")
d = Decimal((0, (), "F"))
@test (string(d) == "Infinity")
@test_throws
@test_throws
@test_throws
@test_throws
@test_throws
@test_throws
@test_throws
@test_throws
@test_throws
@test_throws
@test_throws
@test_throws
end

function test_explicit_from_list(self::@like(ExplicitConstructionTest))
Decimal = self.decimal.Decimal
d = Decimal([0, [0], 0])
@test (string(d) == "0")
d = Decimal([1, [4, 3, 4, 9, 1, 3, 5, 3, 4], -25])
@test (string(d) == "-4.34913534E-17")
d = Decimal([1, (4, 3, 4, 9, 1, 3, 5, 3, 4), -25])
@test (string(d) == "-4.34913534E-17")
d = Decimal((1, [4, 3, 4, 9, 1, 3, 5, 3, 4], -25))
@test (string(d) == "-4.34913534E-17")
end

function test_explicit_from_bool(self::@like(ExplicitConstructionTest))
Decimal = self.decimal.Decimal
@test self === Bool(Decimal(0))
@test self === Bool(Decimal(1))
@test (Decimal(false) == Decimal(0))
@test (Decimal(true) == Decimal(1))
end

function test_explicit_from_Decimal(self::@like(ExplicitConstructionTest))
Decimal = self.decimal.Decimal
d = Decimal(45)
e = Decimal(d)
@test (string(e) == "45")
d = Decimal(500000123)
e = Decimal(d)
@test (string(e) == "500000123")
d = Decimal(-45)
e = Decimal(d)
@test (string(e) == "-45")
d = Decimal(0)
e = Decimal(d)
@test (string(e) == "0")
end

function test_explicit_from_float(self::@like(ExplicitConstructionTest))
Decimal = self.decimal.Decimal
r = Decimal(0.1)
@test (type_(r) == Decimal)
@test (string(r) == "0.1000000000000000055511151231257827021181583404541015625")
@test is_qnan(Decimal(parse(Float64, "nan")))
@test is_infinite(Decimal(parse(Float64, "inf")))
@test is_infinite(Decimal(parse(Float64, "-inf")))
@test (string(Decimal(parse(Float64, "nan"))) == string(Decimal("NaN")))
@test (string(Decimal(parse(Float64, "inf"))) == string(Decimal("Infinity")))
@test (string(Decimal(parse(Float64, "-inf"))) == string(Decimal("-Infinity")))
@test (string(Decimal(parse(Float64, "-0.0"))) == string(Decimal("-0")))
for i in 0:199
x = random.expovariate(0.01)*(rand()*2.0 - 1.0)
@test (x == float(Decimal(x)))
end
end

function test_explicit_context_create_decimal(self::@like(ExplicitConstructionTest))
Decimal = self.decimal.Decimal
InvalidOperation = self.decimal.InvalidOperation
Rounded = self.decimal.Rounded
nc = copy.copy(getcontext(self.decimal))
nc.prec = 3
d = Decimal()
@test (string(d) == "0")
d = create_decimal(nc)
@test (string(d) == "0")
@test_throws
d = create_decimal(nc, 456)
@test isa(self, d)
@test (create_decimal(nc, 45678) == create_decimal(nc, "457E+2"))
d = Decimal("456789")
@test (string(d) == "456789")
d = create_decimal(nc, "456789")
@test (string(d) == "4.57E+5")
@test (string(create_decimal(nc, "3.14\n")) == "NaN")
d = Decimal((1, (4, 3, 4, 9, 1, 3, 5, 3, 4), -25))
@test (string(d) == "-4.34913534E-17")
d = create_decimal(nc, (1, (4, 3, 4, 9, 1, 3, 5, 3, 4), -25))
@test (string(d) == "-4.35E-17")
prevdec = Decimal(500000123)
d = Decimal(prevdec)
@test (string(d) == "500000123")
d = create_decimal(nc, prevdec)
@test (string(d) == "5.00E+8")
nc.prec = 28
nc.traps[InvalidOperation + 1] = true
for v in [-(2^63) - 1, -(2^63), -(2^31) - 1, -(2^31), 0, 2^31 - 1, 2^31, 2^63 - 1, 2^63]
d = create_decimal(nc, v)
@test isa(d, Decimal)
@test (parse(Int, d) == v)
end
nc.prec = 3
nc.traps[Rounded + 1] = true
@test_throws
nc.prec = 28
@test (string(create_decimal(nc, "0E-017")) == "0E-17")
@test (string(create_decimal(nc, "45")) == "45")
@test (string(create_decimal(nc, "-Inf")) == "-Infinity")
@test (string(create_decimal(nc, "NaN123")) == "NaN123")
@test_throws
@test_throws
@test_throws
@test_throws
@test_throws
nc.prec = 3
@test_throws
@test_throws
nc.traps[InvalidOperation + 1] = false
@test (string(create_decimal(nc, "NaN12345")) == "NaN")
@test nc.flags[InvalidOperation + 1]
nc.flags[InvalidOperation + 1] = false
@test (string(create_decimal(nc, Decimal("NaN12345"))) == "NaN")
@test nc.flags[InvalidOperation + 1]
end

function test_explicit_context_create_from_float(self::@like(ExplicitConstructionTest))
Decimal = self.decimal.Decimal
nc = Context(self.decimal)
r = create_decimal(nc, 0.1)
@test (type_(r) == Decimal)
@test (string(r) == "0.1000000000000000055511151231")
@test is_qnan(create_decimal(nc, parse(Float64, "nan")))
@test is_infinite(create_decimal(nc, parse(Float64, "inf")))
@test is_infinite(create_decimal(nc, parse(Float64, "-inf")))
@test (string(create_decimal(nc, parse(Float64, "nan"))) == string(create_decimal(nc, "NaN")))
@test (string(create_decimal(nc, parse(Float64, "inf"))) == string(create_decimal(nc, "Infinity")))
@test (string(create_decimal(nc, parse(Float64, "-inf"))) == string(create_decimal(nc, "-Infinity")))
@test (string(create_decimal(nc, parse(Float64, "-0.0"))) == string(create_decimal(nc, "-0")))
nc.prec = 100
for i in 0:199
x = random.expovariate(0.01)*(rand()*2.0 - 1.0)
@test (x == float(create_decimal(nc, x)))
end
end

function test_unicode_digits(self::@like(ExplicitConstructionTest))
Decimal = self.decimal.Decimal
test_values = OrderedDict("１" => "1", "٠.٠٣٧٢e-٣" => "0.0000372", "-nan౨౪౦౦" => "-NaN2400")
for (input, expected) in collect(test_values)
@test (string(Decimal(input)) == expected)
end
end


@oodef mutable struct CExplicitConstructionTest <: ExplicitConstructionTest
                    
                    decimal
                    
function new(decimal = C)
decimal = decimal
new(decimal)
end

                end
                

@oodef mutable struct PyExplicitConstructionTest <: ExplicitConstructionTest
                    
                    decimal
                    
function new(decimal = P)
decimal = decimal
new(decimal)
end

                end
                

@oodef mutable struct E
                    
                    
                    
                end
                function __divmod__(self::@like(E), other)::String
return "divmod " * string(other)
end

function __rdivmod__(self::@like(E), other)::String
return string(other) * " rdivmod"
end

function __lt__(self::@like(E), other)::String
return "lt " * string(other)
end

function __gt__(self::@like(E), other)::String
return "gt " * string(other)
end

function __le__(self::@like(E), other)::String
return "le " * string(other)
end

function __ge__(self::@like(E), other)::String
return "ge " * string(other)
end

function __eq__(self::@like(E), other)::String
return "eq " * string(other)
end

function __ne__(self::@like(E), other)::String
return "ne " * string(other)
end


@oodef mutable struct ImplicitConstructionTest <: unittest.TestCase
                    #= Unit tests for Implicit Construction cases of Decimal. =#

                    
                    
                end
                function test_implicit_from_None(self::@like(ImplicitConstructionTest))
Decimal = self.decimal.Decimal
@test_throws
end

function test_implicit_from_int(self::@like(ImplicitConstructionTest))
Decimal = self.decimal.Decimal
@test (string(Decimal(5) + 45) == "50")
@test (Decimal(5) + 123456789000 == Decimal(123456789000))
end

function test_implicit_from_string(self::@like(ImplicitConstructionTest))
Decimal = self.decimal.Decimal
@test_throws
end

function test_implicit_from_float(self::@like(ImplicitConstructionTest))
Decimal = self.decimal.Decimal
@test_throws
end

function test_implicit_from_Decimal(self::@like(ImplicitConstructionTest))
Decimal = self.decimal.Decimal
@test (Decimal(5) + Decimal(45) == Decimal(50))
end

function test_rop(self::@like(ImplicitConstructionTest))
Decimal = self.decimal.Decimal
@test (div(E()) == "divmod 10")
@test (div(Decimal(10)) == "10 rdivmod")
@test (py""Decimal(10) < E()"" == "gt 10")
@test (py""Decimal(10) > E()"" == "lt 10")
@test (py""Decimal(10) <= E()"" == "ge 10")
@test (py""Decimal(10) >= E()"" == "le 10")
@test (py""Decimal(10) == E()"" == "eq 10")
@test (py""Decimal(10) != E()"" == "ne 10")
oplist = [("+", "__add__", "__radd__"), ("-", "__sub__", "__rsub__"), ("*", "__mul__", "__rmul__"), ("/", "__truediv__", "__rtruediv__"), ("%", "__mod__", "__rmod__"), ("//", "__floordiv__", "__rfloordiv__"), ("**", "__pow__", "__rpow__")]
for (sym, lop, rop) in oplist
setfield!(E, :lop, (self, other) -> "str" * lop * string(other))
setfield!(E, :rop, (self, other) -> string(other) * rop * "str")
@test (py""E()" * sym * "Decimal(10)"" == "str" * lop * "10")
@test (py""Decimal(10)" * sym * "E()"" == "10" * rop * "str")
end
end


@oodef mutable struct CImplicitConstructionTest <: ImplicitConstructionTest
                    
                    decimal
                    
function new(decimal = C)
decimal = decimal
new(decimal)
end

                end
                

@oodef mutable struct PyImplicitConstructionTest <: ImplicitConstructionTest
                    
                    decimal
                    
function new(decimal = P)
decimal = decimal
new(decimal)
end

                end
                

@oodef mutable struct A <: self.decimal.Decimal
                    
                    a_type
                    
function new(a, a_type = type_(a))
@mk begin
a_type = a_type
end
end

                end
                

@oodef mutable struct FormatTest <: unittest.TestCase
                    #= Unit tests for the format function. =#

                    
                    
                end
                function test_formatting(self::@like(FormatTest))
Decimal = self.decimal.Decimal
test_values = [("e", "0E-15", "0e-15"), ("e", "2.3E-15", "2.3e-15"), ("e", "2.30E+2", "2.30e+2"), ("e", "2.30000E-15", "2.30000e-15"), ("e", "1.23456789123456789e40", "1.23456789123456789e+40"), ("e", "1.5", "1.5e+0"), ("e", "0.15", "1.5e-1"), ("e", "0.015", "1.5e-2"), ("e", "0.0000000000015", "1.5e-12"), ("e", "15.0", "1.50e+1"), ("e", "-15", "-1.5e+1"), ("e", "0", "0e+0"), ("e", "0E1", "0e+1"), ("e", "0.0", "0e-1"), ("e", "0.00", "0e-2"), (".6e", "0E-15", "0.000000e-9"), (".6e", "0", "0.000000e+6"), (".6e", "9.999999", "9.999999e+0"), (".6e", "9.9999999", "1.000000e+1"), (".6e", "-1.23e5", "-1.230000e+5"), (".6e", "1.23456789e-3", "1.234568e-3"), ("f", "0", "0"), ("f", "0.0", "0.0"), ("f", "0E-2", "0.00"), ("f", "0.00E-8", "0.0000000000"), ("f", "0E1", "0"), ("f", "3.2E1", "32"), ("f", "3.2E2", "320"), ("f", "3.20E2", "320"), ("f", "3.200E2", "320.0"), ("f", "3.2E-6", "0.0000032"), (".6f", "0E-15", "0.000000"), (".6f", "0E1", "0.000000"), (".6f", "0", "0.000000"), (".0f", "0", "0"), (".0f", "0e-2", "0"), (".0f", "3.14159265", "3"), (".1f", "3.14159265", "3.1"), (".4f", "3.14159265", "3.1416"), (".6f", "3.14159265", "3.141593"), (".7f", "3.14159265", "3.1415926"), (".8f", "3.14159265", "3.14159265"), (".9f", "3.14159265", "3.141592650"), ("g", "0", "0"), ("g", "0.0", "0.0"), ("g", "0E1", "0e+1"), ("G", "0E1", "0E+1"), ("g", "0E-5", "0.00000"), ("g", "0E-6", "0.000000"), ("g", "0E-7", "0e-7"), ("g", "-0E2", "-0e+2"), (".0g", "3.14159265", "3"), (".0n", "3.14159265", "3"), (".1g", "3.14159265", "3"), (".2g", "3.14159265", "3.1"), (".5g", "3.14159265", "3.1416"), (".7g", "3.14159265", "3.141593"), (".8g", "3.14159265", "3.1415926"), (".9g", "3.14159265", "3.14159265"), (".10g", "3.14159265", "3.14159265"), ("%", "0E1", "0%"), ("%", "0E0", "0%"), ("%", "0E-1", "0%"), ("%", "0E-2", "0%"), ("%", "0E-3", "0.0%"), ("%", "0E-4", "0.00%"), (".3%", "0", "0.000%"), (".3%", "0E10", "0.000%"), (".3%", "0E-10", "0.000%"), (".3%", "2.34", "234.000%"), (".3%", "1.234567", "123.457%"), (".0%", "1.23", "123%"), ("e", "NaN", "NaN"), ("f", "-NaN123", "-NaN123"), ("+g", "NaN456", "+NaN456"), (".3e", "Inf", "Infinity"), (".16f", "-Inf", "-Infinity"), (".0g", "-sNaN", "-sNaN"), ("", "1.00", "1.00"), ("6", "123", "   123"), ("<6", "123", "123   "), (">6", "123", "   123"), ("^6", "123", " 123  "), ("=+6", "123", "+  123"), ("#<10", "NaN", "NaN#######"), ("#<10", "-4.3", "-4.3######"), ("#<+10", "0.0130", "+0.0130###"), ("#< 10", "0.0130", " 0.0130###"), ("@>10", "-Inf", "@-Infinity"), ("#>5", "-Inf", "-Infinity"), ("?^5", "123", "?123?"), ("%^6", "123", "%123%%"), (" ^6", "-45.6", "-45.6 "), ("/=10", "-45.6", "-/////45.6"), ("/=+10", "45.6", "+/////45.6"), ("/= 10", "45.6", " /////45.6"), ("\0=10", "-inf", "-\0Infinity"), ("\0^16", "-inf", "\0\0\0-Infinity\0\0\0\0"), ("\0>10", "1.2345", "\0\0\0\01.2345"), ("\0<10", "1.2345", "1.2345\0\0\0\0"), (",", "1234567", "1,234,567"), (",", "123456", "123,456"), (",", "12345", "12,345"), (",", "1234", "1,234"), (",", "123", "123"), (",", "12", "12"), (",", "1", "1"), (",", "0", "0"), (",", "-1234567", "-1,234,567"), (",", "-123456", "-123,456"), ("7,", "123456", "123,456"), ("8,", "123456", " 123,456"), ("08,", "123456", "0,123,456"), ("+08,", "123456", "+123,456"), (" 08,", "123456", " 123,456"), ("08,", "-123456", "-123,456"), ("+09,", "123456", "+0,123,456"), ("07,", "1234.56", "1,234.56"), ("08,", "1234.56", "1,234.56"), ("09,", "1234.56", "01,234.56"), ("010,", "1234.56", "001,234.56"), ("011,", "1234.56", "0,001,234.56"), ("012,", "1234.56", "0,001,234.56"), ("08,.1f", "1234.5", "01,234.5"), (",", "1.23456789", "1.23456789"), (",%", "123.456789", "12,345.6789%"), (",e", "123456", "1.23456e+5"), (",E", "123456", "1.23456E+5"), ("a=-7.0", "0.12345", "aaaa0.1"), ("<^+15.20%", "inf", "<<+Infinity%<<<"), ("\a>,%", "sNaN1234567", "sNaN1234567%"), ("=10.10%", "NaN123", "   NaN123%")]
for (fmt, d, result) in test_values
@test (Decimal(d) == result)
end
@test_throws
end

function test_n_format(self::@like(FormatTest))
Decimal = self.decimal.Decimal
try
catch exn
if exn isa ImportError
skipTest(self, "locale.CHAR_MAX not available")
end
end
function make_grouping(lst::@like(FormatTest))
return self.decimal == C ? (join([Char(x) for x in lst], "")) : (lst)
end

function get_fmt(x::@like(FormatTest), override = nothing, fmt = "n")
if self.decimal == C
return __format__(Decimal(x), fmt, override)
else
return __format__(Decimal(x), fmt, _localeconv = override)
end
end

en_US = Dict{String, Any}("decimal_point" => ".", "grouping" => make_grouping([3, 3, 0]), "thousands_sep" => ",")
fr_FR = Dict{String, Any}("decimal_point" => ",", "grouping" => make_grouping([CHAR_MAX]), "thousands_sep" => "")
ru_RU = Dict{String, Any}("decimal_point" => ",", "grouping" => make_grouping([3, 3, 0]), "thousands_sep" => " ")
crazy = Dict{String, Any}("decimal_point" => "&", "grouping" => make_grouping([1, 4, 2, CHAR_MAX]), "thousands_sep" => "-")
dotsep_wide = Dict{String, Any}("decimal_point" => decode(b"\xc2\xbf", "utf-8"), "grouping" => make_grouping([3, 3, 0]), "thousands_sep" => decode(b"\xc2\xb4", "utf-8"))
@test (get_fmt(Decimal("12.7"), en_US) == "12.7")
@test (get_fmt(Decimal("12.7"), fr_FR) == "12,7")
@test (get_fmt(Decimal("12.7"), ru_RU) == "12,7")
@test (get_fmt(Decimal("12.7"), crazy) == "1-2&7")
@test (get_fmt(123456789, en_US) == "123,456,789")
@test (get_fmt(123456789, fr_FR) == "123456789")
@test (get_fmt(123456789, ru_RU) == "123 456 789")
@test (get_fmt(1234567890123, crazy) == "123456-78-9012-3")
@test (get_fmt(123456789, en_US, ".6n") == "1.23457e+8")
@test (get_fmt(123456789, fr_FR, ".6n") == "1,23457e+8")
@test (get_fmt(123456789, ru_RU, ".6n") == "1,23457e+8")
@test (get_fmt(123456789, crazy, ".6n") == "1&23457e+8")
@test (get_fmt(1234, fr_FR, "03n") == "1234")
@test (get_fmt(1234, fr_FR, "04n") == "1234")
@test (get_fmt(1234, fr_FR, "05n") == "01234")
@test (get_fmt(1234, fr_FR, "06n") == "001234")
@test (get_fmt(12345, en_US, "05n") == "12,345")
@test (get_fmt(12345, en_US, "06n") == "12,345")
@test (get_fmt(12345, en_US, "07n") == "012,345")
@test (get_fmt(12345, en_US, "08n") == "0,012,345")
@test (get_fmt(12345, en_US, "09n") == "0,012,345")
@test (get_fmt(12345, en_US, "010n") == "00,012,345")
@test (get_fmt(123456, crazy, "06n") == "1-2345-6")
@test (get_fmt(123456, crazy, "07n") == "1-2345-6")
@test (get_fmt(123456, crazy, "08n") == "1-2345-6")
@test (get_fmt(123456, crazy, "09n") == "01-2345-6")
@test (get_fmt(123456, crazy, "010n") == "0-01-2345-6")
@test (get_fmt(123456, crazy, "011n") == "0-01-2345-6")
@test (get_fmt(123456, crazy, "012n") == "00-01-2345-6")
@test (get_fmt(123456, crazy, "013n") == "000-01-2345-6")
@test (get_fmt(Decimal("-1.5"), dotsep_wide, "020n") == "-0´000´000´000´001¿5")
end

function test_wide_char_separator_decimal_point(self::@like(FormatTest))
Decimal = self.decimal.Decimal
decimal_point = locale.localeconv()["decimal_point"]
thousands_sep = locale.localeconv()["thousands_sep"]
if decimal_point != "٫"
skipTest(self, "inappropriate decimal point separator (!a not !a)")
end
if thousands_sep != "٬"
skipTest(self, "inappropriate thousands separator (!a not !a)")
end
@test (Decimal("100000000.123") == "100٬000٬000٫123")
end

function test_decimal_from_float_argument_type(self::@like(FormatTest))
a = A.from_float(42.5)
@test (self.decimal.Decimal == a.a_type)
a = A.from_float(42)
@test (self.decimal.Decimal == a.a_type)
end


@oodef mutable struct CFormatTest <: FormatTest
                    
                    decimal
                    
function new(decimal = C)
decimal = decimal
new(decimal)
end

                end
                

@oodef mutable struct PyFormatTest <: FormatTest
                    
                    decimal
                    
function new(decimal = P)
decimal = decimal
new(decimal)
end

                end
                

@oodef mutable struct ArithmeticOperatorsTest <: unittest.TestCase
                    #= Unit tests for all arithmetic operators, binary and unary. =#

                    
                    
                end
                function test_addition(self::@like(ArithmeticOperatorsTest))
Decimal = self.decimal.Decimal
d1 = Decimal("-11.1")
d2 = Decimal("22.2")
@test (d1 + d2 == Decimal("11.1"))
@test (d2 + d1 == Decimal("11.1"))
c = d1 + 5
@test (c == Decimal("-6.1"))
@test (type_(c) == type_(d1))
c = 5 + d1
@test (c == Decimal("-6.1"))
@test (type_(c) == type_(d1))
d1 += d2
@test (d1 == Decimal("11.1"))
d1 += 5
@test (d1 == Decimal("16.1"))
end

function test_subtraction(self::@like(ArithmeticOperatorsTest))
Decimal = self.decimal.Decimal
d1 = Decimal("-11.1")
d2 = Decimal("22.2")
@test (d1 - d2 == Decimal("-33.3"))
@test (d2 - d1 == Decimal("33.3"))
c = d1 - 5
@test (c == Decimal("-16.1"))
@test (type_(c) == type_(d1))
c = 5 - d1
@test (c == Decimal("16.1"))
@test (type_(c) == type_(d1))
d1 -= d2
@test (d1 == Decimal("-33.3"))
d1 -= 5
@test (d1 == Decimal("-38.3"))
end

function test_multiplication(self::@like(ArithmeticOperatorsTest))
Decimal = self.decimal.Decimal
d1 = Decimal("-5")
d2 = Decimal("3")
@test (d1*d2 == Decimal("-15"))
@test (d2*d1 == Decimal("-15"))
c = d1*5
@test (c == Decimal("-25"))
@test (type_(c) == type_(d1))
c = 5*d1
@test (c == Decimal("-25"))
@test (type_(c) == type_(d1))
d1 *= d2
@test (d1 == Decimal("-15"))
d1 *= 5
@test (d1 == Decimal("-75"))
end

function test_division(self::@like(ArithmeticOperatorsTest))
Decimal = self.decimal.Decimal
d1 = Decimal("-5")
d2 = Decimal("2")
@test (d1 / d2 == Decimal("-2.5"))
@test (d2 / d1 == Decimal("-0.4"))
c = d1 / 4
@test (c == Decimal("-1.25"))
@test (type_(c) == type_(d1))
c = 4 / d1
@test (c == Decimal("-0.8"))
@test (type_(c) == type_(d1))
d1 /= d2
@test (d1 == Decimal("-2.5"))
d1 /= 4
@test (d1 == Decimal("-0.625"))
end

function test_floor_division(self::@like(ArithmeticOperatorsTest))
Decimal = self.decimal.Decimal
d1 = Decimal("5")
d2 = Decimal("2")
@test (d1 ÷ d2 == Decimal("2"))
@test (d2 ÷ d1 == Decimal("0"))
c = d1 ÷ 4
@test (c == Decimal("1"))
@test (type_(c) == type_(d1))
c = 7 ÷ d1
@test (c == Decimal("1"))
@test (type_(c) == type_(d1))
d1 ÷= d2
@test (d1 == Decimal("2"))
d1 ÷= 2
@test (d1 == Decimal("1"))
end

function test_powering(self::@like(ArithmeticOperatorsTest))
Decimal = self.decimal.Decimal
d1 = Decimal("5")
d2 = Decimal("2")
@test (d1^d2 == Decimal("25"))
@test (d2^d1 == Decimal("32"))
c = d1^4
@test (c == Decimal("625"))
@test (type_(c) == type_(d1))
c = 7^d1
@test (c == Decimal("16807"))
@test (type_(c) == type_(d1))
d1 ^= d2
@test (d1 == Decimal("25"))
d1 ^= 4
@test (d1 == Decimal("390625"))
end

function test_module(self::@like(ArithmeticOperatorsTest))
Decimal = self.decimal.Decimal
d1 = Decimal("5")
d2 = Decimal("2")
@test (d1 % d2 == Decimal("1"))
@test (d2 % d1 == Decimal("2"))
c = d1 % 4
@test (c == Decimal("1"))
@test (type_(c) == type_(d1))
c = 7 % d1
@test (c == Decimal("2"))
@test (type_(c) == type_(d1))
d1 %= d2
@test (d1 == Decimal("1"))
d1 %= 4
@test (d1 == Decimal("1"))
end

function test_floor_div_module(self::@like(ArithmeticOperatorsTest))
Decimal = self.decimal.Decimal
d1 = Decimal("5")
d2 = Decimal("2")
(p, q) = div(d1)
@test (p == Decimal("2"))
@test (q == Decimal("1"))
@test (type_(p) == type_(d1))
@test (type_(q) == type_(d1))
(p, q) = div(d1)
@test (p == Decimal("1"))
@test (q == Decimal("1"))
@test (type_(p) == type_(d1))
@test (type_(q) == type_(d1))
(p, q) = div(7)
@test (p == Decimal("1"))
@test (q == Decimal("2"))
@test (type_(p) == type_(d1))
@test (type_(q) == type_(d1))
end

function test_unary_operators(self::@like(ArithmeticOperatorsTest))
Decimal = self.decimal.Decimal
@test (+Decimal(45) == Decimal(+45))
@test (-Decimal(45) == Decimal(-45))
@test (abs(Decimal(45)) == abs(Decimal(-45)))
end

function test_nan_comparisons(self::@like(ArithmeticOperatorsTest))
Decimal = self.decimal.Decimal
InvalidOperation = self.decimal.InvalidOperation
localcontext = self.decimal.localcontext
n = Decimal("NaN")
s = Decimal("sNaN")
i = Decimal("Inf")
f = Decimal("2")
qnan_pairs = ((n, n), (n, i), (i, n), (n, f), (f, n))
snan_pairs = ((s, n), (n, s), (s, i), (i, s), (s, f), (f, s), (s, s))
order_ops = (operator.lt, operator.le, operator.gt, operator.ge)
equality_ops = (operator.eq, operator.ne)
for (x, y) in qnan_pairs + snan_pairs
for op in order_ops + equality_ops
got = op(x, y)
expected = op === operator.ne ? (true) : (false)
@test self === expected
end
end
localcontext() do ctx 
ctx.traps[InvalidOperation + 1] = 1
for (x, y) in qnan_pairs
for op in equality_ops
got = op(x, y)
expected = op === operator.ne ? (true) : (false)
@test self === expected
end
end
for (x, y) in snan_pairs
for op in equality_ops
@test_throws
@test_throws
end
end
for (x, y) in qnan_pairs + snan_pairs
for op in order_ops
@test_throws
end
end
end
end

function test_copy_sign(self::@like(ArithmeticOperatorsTest))
Decimal = self.decimal.Decimal
d = copy_sign(Decimal(1), Decimal(-2))
@test (copy_sign(Decimal(1), -2) == d)
@test_throws
end


@oodef mutable struct CArithmeticOperatorsTest <: ArithmeticOperatorsTest
                    
                    decimal
                    
function new(decimal = C)
decimal = decimal
new(decimal)
end

                end
                

@oodef mutable struct PyArithmeticOperatorsTest <: ArithmeticOperatorsTest
                    
                    decimal
                    
function new(decimal = P)
decimal = decimal
new(decimal)
end

                end
                

function thfunc1(cls)
Decimal = cls.decimal.Decimal
InvalidOperation = cls.decimal.InvalidOperation
DivisionByZero = cls.decimal.DivisionByZero
Overflow = cls.decimal.Overflow
Underflow = cls.decimal.Underflow
Inexact = cls.decimal.Inexact
getcontext = cls.decimal.getcontext
localcontext = cls.decimal.localcontext
d1 = Decimal(1)
d3 = Decimal(3)
test1 = d1 / d3
set(cls.finish1)
wait(cls.synchro)
test2 = d1 / d3
localcontext() do c2 
@test c2.flags[Inexact + 1]
@test_throws
@test c2.flags[DivisionByZero + 1]
localcontext() do c3 
@test c3.flags[Inexact + 1]
@test c3.flags[DivisionByZero + 1]
@test_throws
@test c3.flags[InvalidOperation + 1]
# Delete Unsupported
# del(c3)
end
@test !(c2.flags[InvalidOperation + 1])
# Delete Unsupported
# del(c2)
end
@test (test1 == Decimal("0.333333333333333333333333"))
@test (test2 == Decimal("0.333333333333333333333333"))
c1 = getcontext()
@test c1.flags[Inexact + 1]
for sig in (Overflow, Underflow, DivisionByZero, InvalidOperation)
@test !(c1.flags[sig + 1])
end
end

function thfunc2(cls)
Decimal = cls.decimal.Decimal
InvalidOperation = cls.decimal.InvalidOperation
DivisionByZero = cls.decimal.DivisionByZero
Overflow = cls.decimal.Overflow
Underflow = cls.decimal.Underflow
Inexact = cls.decimal.Inexact
getcontext = cls.decimal.getcontext
localcontext = cls.decimal.localcontext
d1 = Decimal(1)
d3 = Decimal(3)
test1 = d1 / d3
thiscontext = getcontext()
thiscontext.prec = 18
test2 = d1 / d3
localcontext() do c2 
@test c2.flags[Inexact + 1]
@test_throws
@test c2.flags[Overflow + 1]
localcontext(thiscontext) do c3 
@test c3.flags[Inexact + 1]
@test !(c3.flags[Overflow + 1])
c3.traps[Underflow + 1] = true
@test_throws
@test c3.flags[Underflow + 1]
# Delete Unsupported
# del(c3)
end
@test !(c2.flags[Underflow + 1])
@test !(c2.traps[Underflow + 1])
# Delete Unsupported
# del(c2)
end
set(cls.synchro)
set(cls.finish2)
@test (test1 == Decimal("0.333333333333333333333333"))
@test (test2 == Decimal("0.333333333333333333"))
@test !(thiscontext.traps[Underflow + 1])
@test thiscontext.flags[Inexact + 1]
for sig in (Overflow, Underflow, DivisionByZero, InvalidOperation)
@test !(thiscontext.flags[sig + 1])
end
end

@oodef mutable struct ThreadingTest <: unittest.TestCase
                    #= Unit tests for thread local contexts in Decimal. =#

                    finish1
finish2
synchro
                    
function new(finish1 = threading.Event(), finish2 = threading.Event(), synchro = threading.Event())
finish1 = finish1
finish2 = finish2
synchro = synchro
new(finish1, finish2, synchro)
end

                end
                function test_threading(self::@like(ThreadingTest))
DefaultContext = self.decimal.DefaultContext
if self.decimal == C&&!(self.decimal.HAVE_THREADS)
skipTest(self, "compiled without threading")
end
save_prec = DefaultContext.prec
save_emax = DefaultContext.Emax
save_emin = DefaultContext.Emin
DefaultContext.prec = 24
DefaultContext.Emax = 425000000
DefaultContext.Emin = -425000000
self.synchro = threading.Event()
self.finish1 = threading.Event()
self.finish2 = threading.Event()
th1 = threading.Thread(target = thfunc1, args = (self,))
th2 = threading.Thread(target = thfunc2, args = (self,))
start(th1)
start(th2)
wait(self.finish1)
wait(self.finish2)
for sig in Signals[self.decimal]
@test !(DefaultContext.flags[sig + 1])
end
join(th1)
join(th2)
DefaultContext.prec = save_prec
DefaultContext.Emax = save_emax
DefaultContext.Emin = save_emin
end


@oodef mutable struct CThreadingTest <: ThreadingTest
                    
                    decimal
finish1
finish2
synchro
                    
function new(decimal = C, finish1 = threading.Event(), finish2 = threading.Event(), synchro = threading.Event())
decimal = decimal
finish1 = finish1
finish2 = finish2
synchro = synchro
new(decimal, finish1, finish2, synchro)
end

                end
                

@oodef mutable struct PyThreadingTest <: ThreadingTest
                    
                    decimal
finish1
finish2
synchro
                    
function new(decimal = P, finish1 = threading.Event(), finish2 = threading.Event(), synchro = threading.Event())
decimal = decimal
finish1 = finish1
finish2 = finish2
synchro = synchro
new(decimal, finish1, finish2, synchro)
end

                end
                

@oodef mutable struct H
                    
                    
                    
                end
                function __hash__(self::@like(H))::Int64
return 42
end


@oodef mutable struct D <: {Decimal, H}
                    
                    
                    
                end
                

@oodef mutable struct MyDecimal <: Decimal
                    
                    y
                    
function new(y = nothing)
y = y
new(y)
end

                end
                

@oodef mutable struct UsabilityTest <: unittest.TestCase
                    #= Unit tests for Usability cases of Decimal. =#

                    
                    
                end
                function test_comparison_operators(self::@like(UsabilityTest))
Decimal = self.decimal.Decimal
da = Decimal("23.42")
db = Decimal("23.42")
dc = Decimal("45")
assertGreater(self, dc, da)
assertGreaterEqual(self, dc, da)
assertLess(self, da, dc)
assertLessEqual(self, da, dc)
@test (da == db)
@test (da != dc)
assertLessEqual(self, da, db)
assertGreaterEqual(self, da, db)
assertGreater(self, dc, 23)
assertLess(self, 23, dc)
@test (dc == 45)
@test (da != "ugly")
@test (da != 32.7)
@test (da != object())
@test (da != object)
a = collect(map(Decimal, 0:99))
b = a[begin:end]
shuffle(a)
sort(a)
@test (a == b)
end

function test_decimal_float_comparison(self::@like(UsabilityTest))
Decimal = self.decimal.Decimal
da = Decimal("0.25")
db = Decimal("3.0")
assertLess(self, da, 3.0)
assertLessEqual(self, da, 3.0)
assertGreater(self, db, 0.25)
assertGreaterEqual(self, db, 0.25)
@test (da != 1.5)
@test (da == 0.25)
assertGreater(self, 3.0, da)
assertGreaterEqual(self, 3.0, da)
assertLess(self, 0.25, db)
assertLessEqual(self, 0.25, db)
@test (0.25 != db)
@test (3.0 == db)
@test (0.1 != Decimal("0.1"))
end

function test_decimal_complex_comparison(self::@like(UsabilityTest))
Decimal = self.decimal.Decimal
da = Decimal("0.25")
db = Decimal("3.0")
@test (da != 1.5 + 0im)
@test (1.5 + 0im != da)
@test (da == 0.25 + 0im)
@test (0.25 + 0im == da)
@test (3.0 + 0im == db)
@test (db == 3.0 + 0im)
@test (db != 3.0 + 1im)
@test (3.0 + 1im != db)
@test self === __lt__(db, 3.0 + 0im)
@test self === __le__(db, 3.0 + 0im)
@test self === __gt__(db, 3.0 + 0im)
@test self === __le__(db, 3.0 + 0im)
end

function test_decimal_fraction_comparison(self::@like(UsabilityTest))
D = self.decimal.Decimal
F = fractions[self.decimal].Fraction
Context = self.decimal.Context
localcontext = self.decimal.localcontext
InvalidOperation = self.decimal.InvalidOperation
emax = C ? (C.MAX_EMAX) : (999999999)
emin = C ? (C.MIN_EMIN) : (-999999999)
etiny = C ? (C.MIN_ETINY) : (-1999999997)
c = Context(Emax = emax, Emin = emin)
localcontext(c) do 
c.prec = emax
assertLess(self, D(0), F(1, 9999999999999999999999999999999999999))
assertLess(self, F(-1, 9999999999999999999999999999999999999), D(0))
assertLess(self, F(0, 1), D("1e" * string(etiny)))
assertLess(self, D("-1e" * string(etiny)), F(0, 1))
assertLess(self, F(0, 9999999999999999999999999), D("1e" * string(etiny)))
assertLess(self, D("-1e" * string(etiny)), F(0, 9999999999999999999999999))
@test (D("0.1") == F(1, 10))
@test (F(1, 10) == D("0.1"))
c.prec = 300
@test (D(1) / 3 != F(1, 3))
@test (F(1, 3) != D(1) / 3)
assertLessEqual(self, F(120984237, 9999999999), D("9e" * string(emax)))
assertGreaterEqual(self, D("9e" * string(emax)), F(120984237, 9999999999))
assertGreater(self, D("inf"), F(99999999999, 123))
assertGreater(self, D("inf"), F(-99999999999, 123))
assertLess(self, D("-inf"), F(99999999999, 123))
assertLess(self, D("-inf"), F(-99999999999, 123))
@test_throws
@test self === NotImplemented
@test (D("nan") != F(-9, 123))
@test (F(-9, 123) != D("nan"))
end
end

function test_copy_and_deepcopy_methods(self::@like(UsabilityTest))
Decimal = self.decimal.Decimal
d = Decimal("43.24")
c = copy.copy(d)
@test (id(c) == id(d))
dc = copy.deepcopy(d)
@test (id(dc) == id(d))
end

function test_hash_method(self::@like(UsabilityTest))
Decimal = self.decimal.Decimal
localcontext = self.decimal.localcontext
function hashit(d::@like(UsabilityTest))
a = hash(d)
b = __hash__(d)
@test (a == b)
return a
end

hashit(Decimal(23))
hashit(Decimal("Infinity"))
hashit(Decimal("-Infinity"))
hashit(Decimal("nan123"))
hashit(Decimal("-NaN"))
test_values = [Decimal(sign*(2^m + n)) for m in [0, 14, 15, 16, 17, 30, 31, 32, 33, 61, 62, 63, 64, 65, 66] for n in -10:9 for sign in [-1, 1]]
extend(test_values, [Decimal("-1"), Decimal("-0"), Decimal("0.00"), Decimal("-0.000"), Decimal("0E10"), Decimal("-0E12"), Decimal("10.0"), Decimal("-23.00000"), Decimal("1230E100"), Decimal("-4.5678E50"), Decimal((2^64 + 2^32) - 1), Decimal("1.634E100"), Decimal("90.697E100"), Decimal("188.83E100"), Decimal("1652.9E100"), Decimal("56531E100")])
for value in test_values
@test (hashit(value) == hash(parse(Int, value)))
end
test_strings = ["inf", "-Inf", "0.0", "-.0e1", "34.0", "2.5", "112390.625", "-0.515625"]
for s in test_strings
f = parse(Float64, s)
d = Decimal(s)
@test (hashit(d) == hash(f))
end
localcontext() do c 
x = Decimal("123456789.1")
c.prec = 6
h1 = hashit(x)
c.prec = 10
h2 = hashit(x)
c.prec = 16
h3 = hashit(x)
@test (h1 == h2)
@test (h1 == h3)
c.prec = 10000
x = 1100^1248
@test (hashit(Decimal(x)) == hashit(x))
end
end

function test_hash_method_nan(self::@like(UsabilityTest))
Decimal = self.decimal.Decimal
@test_throws
value = Decimal("NaN")
@test (hash(value) == __hash__(object, value))
value = D("NaN")
@test (hash(value) == __hash__(object, value))
end

function test_min_and_max_methods(self::@like(UsabilityTest))
Decimal = self.decimal.Decimal
d1 = Decimal("15.32")
d2 = Decimal("28.5")
l1 = 15
l2 = 28
@test self === min(d1, d2)
@test self === min(d2, d1)
@test self === max(d1, d2)
@test self === max(d2, d1)
@test self === min(d1, l2)
@test self === min(l2, d1)
@test self === max(l1, d2)
@test self === max(d2, l1)
end

function test_as_nonzero(self::@like(UsabilityTest))
Decimal = self.decimal.Decimal
@test !(Decimal(0))
@test Decimal("0.372")
end

function test_tostring_methods(self::@like(UsabilityTest))
Decimal = self.decimal.Decimal
d = Decimal("15.32")
@test (string(d) == "15.32")
@test (repr(d) == "Decimal(\'15.32\')")
end

function test_tonum_methods(self::@like(UsabilityTest))
Decimal = self.decimal.Decimal
d1 = Decimal("66")
d2 = Decimal("15.32")
@test (parse(Int, d1) == 66)
@test (parse(Int, d2) == 15)
@test (float(d1) == 66)
@test (float(d2) == 15.32)
test_pairs = [("123.00", 123), ("3.2", 3), ("3.54", 3), ("3.899", 3), ("-2.3", -3), ("-11.0", -11), ("0.0", 0), ("-0E3", 0), ("89891211712379812736.1", 89891211712379812736)]
for (d, i) in test_pairs
@test (floor(Int, Decimal(d)) == i)
end
@test_throws
@test_throws
@test_throws
@test_throws
@test_throws
test_pairs = [("123.00", 123), ("3.2", 4), ("3.54", 4), ("3.899", 4), ("-2.3", -2), ("-11.0", -11), ("0.0", 0), ("-0E3", 0), ("89891211712379812736.1", 89891211712379812737)]
for (d, i) in test_pairs
@test (math.ceil(Decimal(d)) == i)
end
@test_throws
@test_throws
@test_throws
@test_throws
@test_throws
test_pairs = [("123.00", 123), ("3.2", 3), ("3.54", 4), ("3.899", 4), ("-2.3", -2), ("-11.0", -11), ("0.0", 0), ("-0E3", 0), ("-3.5", -4), ("-2.5", -2), ("-1.5", -2), ("-0.5", 0), ("0.5", 0), ("1.5", 2), ("2.5", 2), ("3.5", 4)]
for (d, i) in test_pairs
@test (round(Decimal(d)) == i)
end
@test_throws
@test_throws
@test_throws
@test_throws
@test_throws
test_triples = [("123.456", -4, "0E+4"), ("123.456", -3, "0E+3"), ("123.456", -2, "1E+2"), ("123.456", -1, "1.2E+2"), ("123.456", 0, "123"), ("123.456", 1, "123.5"), ("123.456", 2, "123.46"), ("123.456", 3, "123.456"), ("123.456", 4, "123.4560"), ("123.455", 2, "123.46"), ("123.445", 2, "123.44"), ("Inf", 4, "NaN"), ("-Inf", -23, "NaN"), ("sNaN314", 3, "NaN314")]
for (d, n, r) in test_triples
@test (string(round(Decimal(d), digits = n)) == r)
end
end

function test_nan_to_float(self::@like(UsabilityTest))
Decimal = self.decimal.Decimal
for s in ("nan", "nan1234", "-nan", "-nan2468")
f = float(Decimal(s))
@test math.isnan(f)
sign_ = math.copysign(1.0, f)
@test (sign_ == startswith(s, "-") ? (-1.0) : (1.0))
end
end

function test_snan_to_float(self::@like(UsabilityTest))
Decimal = self.decimal.Decimal
for s in ("snan", "-snan", "snan1357", "-snan1234")
d = Decimal(s)
@test_throws
end
end

function test_eval_round_trip(self::@like(UsabilityTest))
Decimal = self.decimal.Decimal
d = Decimal((0, (0,), 0))
@test (d == py"repr(d)")
d = Decimal((1, (4, 5), 0))
@test (d == py"repr(d)")
d = Decimal((0, (4, 5, 3, 4), -2))
@test (d == py"repr(d)")
d = Decimal((1, (4, 3, 4, 9, 1, 3, 5, 3, 4), -25))
@test (d == py"repr(d)")
end

function test_as_tuple(self::@like(UsabilityTest))
Decimal = self.decimal.Decimal
d = Decimal(0)
@test (as_tuple(d) == (0, (0,), 0))
d = Decimal(-45)
@test (as_tuple(d) == (1, (4, 5), 0))
d = Decimal("-4.34913534E-17")
@test (as_tuple(d) == (1, (4, 3, 4, 9, 1, 3, 5, 3, 4), -25))
d = Decimal("Infinity")
@test (as_tuple(d) == (0, (0,), "F"))
d = Decimal((0, (0, 0, 4, 0, 5, 3, 4), -2))
@test (as_tuple(d) == (0, (4, 0, 5, 3, 4), -2))
d = Decimal((1, (0, 0, 0), 37))
@test (as_tuple(d) == (1, (0,), 37))
d = Decimal((1, (), 37))
@test (as_tuple(d) == (1, (0,), 37))
d = Decimal((0, (0, 0, 4, 0, 5, 3, 4), "n"))
@test (as_tuple(d) == (0, (4, 0, 5, 3, 4), "n"))
d = Decimal((1, (0, 0, 0), "N"))
@test (as_tuple(d) == (1, (), "N"))
d = Decimal((1, (), "n"))
@test (as_tuple(d) == (1, (), "n"))
d = Decimal((0, (0,), "F"))
@test (as_tuple(d) == (0, (0,), "F"))
d = Decimal((0, (4, 5, 3, 4), "F"))
@test (as_tuple(d) == (0, (0,), "F"))
d = Decimal((1, (0, 2, 7, 1), "F"))
@test (as_tuple(d) == (1, (0,), "F"))
end

function test_as_integer_ratio(self::@like(UsabilityTest))
Decimal = self.decimal.Decimal
@test_throws
@test_throws
@test_throws
@test_throws
for exp_ in -4:1
for coeff in 0:999
for sign_ in ("+", "-")
d = Decimal("$(sign_)$(coeff)E$(exp_)")
pq = as_integer_ratio(d)
(p, q) = pq
@test isa(self, pq)
@test isa(self, p)
@test isa(self, q)
assertGreater(self, q, 0)
@test (math.gcd(p, q) == 1)
@test (Decimal(p) / Decimal(q) == d)
end
end
end
end

function test_subclassing(self::@like(UsabilityTest))
Decimal = self.decimal.Decimal
d1 = MyDecimal(1)
d2 = MyDecimal(2)
d = __add__(d1, d2)
@test self === type_(d)
d = max(d1, d2)
@test self === type_(d)
d = copy.copy(d1)
@test self === type_(d)
@test (d == d1)
d = copy.deepcopy(d1)
@test self === type_(d)
@test (d == d1)
d = Decimal("1.0")
x = Decimal(d)
@test self === type_(x)
@test (x == d)
m = MyDecimal(d)
@test self === type_(m)
@test (m == d)
@test self === m.y
x = Decimal(m)
@test self === type_(x)
@test (x == d)
m.y = 9
x = MyDecimal(m)
@test self === type_(x)
@test (x == d)
@test self === x.y
end

function test_implicit_context(self::@like(UsabilityTest))
Decimal = self.decimal.Decimal
getcontext = self.decimal.getcontext
c = getcontext()
@test (string(sqrt(Decimal(0))) == string(sqrt(c, Decimal(0))))
end

function test_none_args(self::@like(UsabilityTest))
Decimal = self.decimal.Decimal
Context = self.decimal.Context
localcontext = self.decimal.localcontext
InvalidOperation = self.decimal.InvalidOperation
DivisionByZero = self.decimal.DivisionByZero
Overflow = self.decimal.Overflow
Underflow = self.decimal.Underflow
Subnormal = self.decimal.Subnormal
Inexact = self.decimal.Inexact
Rounded = self.decimal.Rounded
Clamped = self.decimal.Clamped
localcontext(Context()) do c 
c.prec = 7
c.Emax = 999
c.Emin = -999
x = Decimal("111")
y = Decimal("1e9999")
z = Decimal("1e-9999")
clear_flags(c)
@test (string(exp(x, context = nothing)) == "1.609487E+48")
@test c.flags[Inexact + 1]
@test c.flags[Rounded + 1]
clear_flags(c)
@test_throws
@test c.flags[Overflow + 1]
@test self === is_normal(z, context = nothing)
@test self === is_subnormal(z, context = nothing)
clear_flags(c)
@test (string(ln(x, context = nothing)) == "4.709530")
@test c.flags[Inexact + 1]
@test c.flags[Rounded + 1]
clear_flags(c)
@test_throws
@test c.flags[InvalidOperation + 1]
clear_flags(c)
@test (string(log10(x, context = nothing)) == "2.045323")
@test c.flags[Inexact + 1]
@test c.flags[Rounded + 1]
clear_flags(c)
@test_throws
@test c.flags[InvalidOperation + 1]
clear_flags(c)
@test (string(logb(x, context = nothing)) == "2")
@test_throws
@test c.flags[DivisionByZero + 1]
clear_flags(c)
@test (string(logical_invert(x, context = nothing)) == "1111000")
@test_throws
@test c.flags[InvalidOperation + 1]
clear_flags(c)
@test (string(next_minus(y, context = nothing)) == "9.999999E+999")
@test_throws
@test c.flags[InvalidOperation + 1]
clear_flags(c)
@test (string(next_plus(y, context = nothing)) == "Infinity")
@test_throws
@test c.flags[InvalidOperation + 1]
clear_flags(c)
@test (string(normalize(z, context = nothing)) == "0")
@test_throws
@test c.flags[Overflow + 1]
@test (string(number_class(z, context = nothing)) == "+Subnormal")
clear_flags(c)
@test (string(sqrt(z, context = nothing)) == "0E-1005")
@test c.flags[Clamped + 1]
@test c.flags[Inexact + 1]
@test c.flags[Rounded + 1]
@test c.flags[Subnormal + 1]
@test c.flags[Underflow + 1]
clear_flags(c)
@test_throws
@test c.flags[Overflow + 1]
c.capitals = 0
@test (string(to_eng_string(z, context = nothing)) == "1e-9999")
c.capitals = 1
clear_flags(c)
ans = string(compare(x, Decimal("Nan891287828"), context = nothing))
@test (ans == "NaN1287828")
@test_throws
@test c.flags[InvalidOperation + 1]
clear_flags(c)
ans = string(compare_signal(x, 8224, context = nothing))
@test (ans == "-1")
@test_throws
@test c.flags[InvalidOperation + 1]
clear_flags(c)
ans = string(logical_and(x, 101, context = nothing))
@test (ans == "101")
@test_throws
@test c.flags[InvalidOperation + 1]
clear_flags(c)
ans = string(logical_or(x, 101, context = nothing))
@test (ans == "111")
@test_throws
@test c.flags[InvalidOperation + 1]
clear_flags(c)
ans = string(logical_xor(x, 101, context = nothing))
@test (ans == "10")
@test_throws
@test c.flags[InvalidOperation + 1]
clear_flags(c)
ans = string(max(x, 101, context = nothing))
@test (ans == "111")
@test_throws
@test c.flags[InvalidOperation + 1]
clear_flags(c)
ans = string(max_mag(x, 101, context = nothing))
@test (ans == "111")
@test_throws
@test c.flags[InvalidOperation + 1]
clear_flags(c)
ans = string(min(x, 101, context = nothing))
@test (ans == "101")
@test_throws
@test c.flags[InvalidOperation + 1]
clear_flags(c)
ans = string(min_mag(x, 101, context = nothing))
@test (ans == "101")
@test_throws
@test c.flags[InvalidOperation + 1]
clear_flags(c)
ans = string(remainder_near(x, 101, context = nothing))
@test (ans == "10")
@test_throws
@test c.flags[InvalidOperation + 1]
clear_flags(c)
ans = string(rotate(x, 2, context = nothing))
@test (ans == "11100")
@test_throws
@test c.flags[InvalidOperation + 1]
clear_flags(c)
ans = string(scaleb(x, 7, context = nothing))
@test (ans == "1.11E+9")
@test_throws
@test c.flags[InvalidOperation + 1]
clear_flags(c)
ans = string(shift(x, 2, context = nothing))
@test (ans == "11100")
@test_throws
@test c.flags[InvalidOperation + 1]
clear_flags(c)
ans = string(fma(x, 2, 3, context = nothing))
@test (ans == "225")
@test_throws
@test c.flags[Overflow + 1]
c.rounding = ROUND_HALF_EVEN
ans = string(to_integral(Decimal("1.5"), rounding = nothing, context = nothing))
@test (ans == "2")
c.rounding = ROUND_DOWN
ans = string(to_integral(Decimal("1.5"), rounding = nothing, context = nothing))
@test (ans == "1")
ans = string(to_integral(Decimal("1.5"), rounding = ROUND_UP, context = nothing))
@test (ans == "2")
clear_flags(c)
@test_throws
@test c.flags[InvalidOperation + 1]
c.rounding = ROUND_HALF_EVEN
ans = string(to_integral_value(Decimal("1.5"), rounding = nothing, context = nothing))
@test (ans == "2")
c.rounding = ROUND_DOWN
ans = string(to_integral_value(Decimal("1.5"), rounding = nothing, context = nothing))
@test (ans == "1")
ans = string(to_integral_value(Decimal("1.5"), rounding = ROUND_UP, context = nothing))
@test (ans == "2")
clear_flags(c)
@test_throws
@test c.flags[InvalidOperation + 1]
c.rounding = ROUND_HALF_EVEN
ans = string(to_integral_exact(Decimal("1.5"), rounding = nothing, context = nothing))
@test (ans == "2")
c.rounding = ROUND_DOWN
ans = string(to_integral_exact(Decimal("1.5"), rounding = nothing, context = nothing))
@test (ans == "1")
ans = string(to_integral_exact(Decimal("1.5"), rounding = ROUND_UP, context = nothing))
@test (ans == "2")
clear_flags(c)
@test_throws
@test c.flags[InvalidOperation + 1]
c.rounding = ROUND_UP
ans = string(quantize(Decimal("1.50001"), exp = Decimal("1e-3"), rounding = nothing, context = nothing))
@test (ans == "1.501")
c.rounding = ROUND_DOWN
ans = string(quantize(Decimal("1.50001"), exp = Decimal("1e-3"), rounding = nothing, context = nothing))
@test (ans == "1.500")
ans = string(quantize(Decimal("1.50001"), exp = Decimal("1e-3"), rounding = ROUND_UP, context = nothing))
@test (ans == "1.501")
clear_flags(c)
@test_throws
@test c.flags[InvalidOperation + 1]
end
localcontext(Context()) do context 
context.prec = 7
context.Emax = 999
context.Emin = -999
localcontext(ctx = nothing) do c 
@test (c.prec == 7)
@test (c.Emax == 999)
@test (c.Emin == -999)
end
end
end

function test_conversions_from_int(self::@like(UsabilityTest))
Decimal = self.decimal.Decimal
@test (compare(Decimal(4), 3) == compare(Decimal(4), Decimal(3)))
@test (compare_signal(Decimal(4), 3) == compare_signal(Decimal(4), Decimal(3)))
@test (compare_total(Decimal(4), 3) == compare_total(Decimal(4), Decimal(3)))
@test (compare_total_mag(Decimal(4), 3) == compare_total_mag(Decimal(4), Decimal(3)))
@test (logical_and(Decimal(10101), 1001) == logical_and(Decimal(10101), Decimal(1001)))
@test (logical_or(Decimal(10101), 1001) == logical_or(Decimal(10101), Decimal(1001)))
@test (logical_xor(Decimal(10101), 1001) == logical_xor(Decimal(10101), Decimal(1001)))
@test (max(Decimal(567), 123) == max(Decimal(567), Decimal(123)))
@test (max_mag(Decimal(567), 123) == max_mag(Decimal(567), Decimal(123)))
@test (min(Decimal(567), 123) == min(Decimal(567), Decimal(123)))
@test (min_mag(Decimal(567), 123) == min_mag(Decimal(567), Decimal(123)))
@test (next_toward(Decimal(567), 123) == next_toward(Decimal(567), Decimal(123)))
@test (quantize(Decimal(1234), 100) == quantize(Decimal(1234), Decimal(100)))
@test (remainder_near(Decimal(768), 1234) == remainder_near(Decimal(768), Decimal(1234)))
@test (rotate(Decimal(123), 1) == rotate(Decimal(123), Decimal(1)))
@test (same_quantum(Decimal(1234), 1000) == same_quantum(Decimal(1234), Decimal(1000)))
@test (scaleb(Decimal("9.123"), -100) == scaleb(Decimal("9.123"), Decimal(-100)))
@test (shift(Decimal(456), -1) == shift(Decimal(456), Decimal(-1)))
@test (fma(Decimal(-12), Decimal(45), 67) == fma(Decimal(-12), Decimal(45), Decimal(67)))
@test (fma(Decimal(-12), 45, 67) == fma(Decimal(-12), Decimal(45), Decimal(67)))
@test (fma(Decimal(-12), 45, Decimal(67)) == fma(Decimal(-12), Decimal(45), Decimal(67)))
end


@oodef mutable struct CUsabilityTest <: UsabilityTest
                    
                    decimal
                    
function new(decimal = C)
decimal = decimal
new(decimal)
end

                end
                

@oodef mutable struct PyUsabilityTest <: UsabilityTest
                    
                    decimal
                    
function new(decimal = P)
decimal = decimal
new(decimal)
end

                end
                

@oodef mutable struct MyDecimal <: Decimal
                    
                    x::String
                    
function new(_, x::String = "y")
@mk begin
x = x
end
end

                end
                

@oodef mutable struct PythonAPItests <: unittest.TestCase
                    
                    
                    
                end
                function test_abc(self::@like(PythonAPItests))
Decimal = self.decimal.Decimal
@test Decimal <: numbers.Number
@test !(Decimal <: Real)
@test isa(self, Decimal(0))
assertNotIsInstance(self, Decimal(0), Real)
end

function test_pickle(self::@like(PythonAPItests))
for proto in 0:pickle.HIGHEST_PROTOCOL
Decimal = self.decimal.Decimal
savedecimal = sys.modules["decimal"]
sys.modules["decimal"] = self.decimal
d = Decimal("-3.141590000")
p = pickle.dumps(d, proto)
e = pickle.loads(p)
@test (d == e)
if C
x = Decimal(C, "-3.123e81723")
y = Decimal(P, "-3.123e81723")
sys.modules["decimal"] = C
sx = pickle.dumps(x, proto)
sys.modules["decimal"] = P
r = pickle.loads(sx)
@test isa(self, r)
@test (r == y)
sys.modules["decimal"] = P
sy = pickle.dumps(y, proto)
sys.modules["decimal"] = C
r = pickle.loads(sy)
@test isa(self, r)
@test (r == x)
x = as_tuple(Decimal(C, "-3.123e81723"))
y = as_tuple(Decimal(P, "-3.123e81723"))
sys.modules["decimal"] = C
sx = pickle.dumps(x, proto)
sys.modules["decimal"] = P
r = pickle.loads(sx)
@test isa(self, r)
@test (r == y)
sys.modules["decimal"] = P
sy = pickle.dumps(y, proto)
sys.modules["decimal"] = C
r = pickle.loads(sy)
@test isa(self, r)
@test (r == x)
end
sys.modules["decimal"] = savedecimal
end
end

function test_int(self::@like(PythonAPItests))
Decimal = self.decimal.Decimal
for x in -250:249
s = "$((x / 100.0)).2f"
@test (parse(Int, Decimal(s)) == Int(floor(float(s))))
d = Decimal(s)
r = to_integral(d, ROUND_DOWN)
@test (Decimal(parse(Int, d)) == r)
end
@test_throws
@test_throws
@test_throws
@test_throws
end

function test_trunc(self::@like(PythonAPItests))
Decimal = self.decimal.Decimal
for x in -250:249
s = "$((x / 100.0)).2f"
@test (parse(Int, Decimal(s)) == Int(floor(float(s))))
d = Decimal(s)
r = to_integral(d, ROUND_DOWN)
@test (Decimal(trunc(d)) == r)
end
end

function test_from_float(self::@like(PythonAPItests))
Decimal = self.decimal.Decimal
@test MyDecimal <: Decimal
r = MyDecimal.from_float(0.1)
@test (type_(r) == MyDecimal)
@test (string(r) == "0.1000000000000000055511151231257827021181583404541015625")
@test (r.x == "y")
bigint = 12345678901234567890123456789
@test (MyDecimal.from_float(bigint) == MyDecimal(bigint))
@test is_qnan(MyDecimal.from_float(parse(Float64, "nan")))
@test is_infinite(MyDecimal.from_float(parse(Float64, "inf")))
@test is_infinite(MyDecimal.from_float(parse(Float64, "-inf")))
@test (string(MyDecimal.from_float(parse(Float64, "nan"))) == string(Decimal("NaN")))
@test (string(MyDecimal.from_float(parse(Float64, "inf"))) == string(Decimal("Infinity")))
@test (string(MyDecimal.from_float(parse(Float64, "-inf"))) == string(Decimal("-Infinity")))
@test_throws
for i in 0:199
x = random.expovariate(0.01)*(rand()*2.0 - 1.0)
@test (x == float(MyDecimal.from_float(x)))
end
end

function test_create_decimal_from_float(self::@like(PythonAPItests))
Decimal = self.decimal.Decimal
Context = self.decimal.Context
Inexact = self.decimal.Inexact
context = Context(prec = 5, rounding = ROUND_DOWN)
@test (create_decimal_from_float(context, math.pi) == Decimal("3.1415"))
context = Context(prec = 5, rounding = ROUND_UP)
@test (create_decimal_from_float(context, math.pi) == Decimal("3.1416"))
context = Context(prec = 5, traps = [Inexact])
@test_throws
@test (repr(create_decimal_from_float(context, -0.0)) == "Decimal(\'-0\')")
@test (repr(create_decimal_from_float(context, 1.0)) == "Decimal(\'1\')")
@test (repr(create_decimal_from_float(context, 10)) == "Decimal(\'10\')")
end

function test_quantize(self::@like(PythonAPItests))
Decimal = self.decimal.Decimal
Context = self.decimal.Context
InvalidOperation = self.decimal.InvalidOperation
c = Context(Emax = 99999, Emin = -99999)
@test (quantize(Decimal("7.335"), Decimal(".01")) == Decimal("7.34"))
@test (quantize(Decimal("7.335"), Decimal(".01"), rounding = ROUND_DOWN) == Decimal("7.33"))
@test_throws
c = Context()
d = Decimal("0.871831e800")
x = quantize(d, context = c, exp = Decimal("1e797"), rounding = ROUND_DOWN)
@test (x == Decimal("8.71E+799"))
end

function test_complex(self::@like(PythonAPItests))
Decimal = self.decimal.Decimal
x = Decimal("9.8182731e181273")
@test (x.real == x)
@test (x.imag == 0)
@test (conjugate(x) == x)
x = Decimal("1")
@test (complex(x) == complex(float(1)))
@test_throws
@test_throws
@test_throws
@test_throws
end

function test_named_parameters(self::@like(PythonAPItests))
D = self.decimal.Decimal
Context = self.decimal.Context
localcontext = self.decimal.localcontext
InvalidOperation = self.decimal.InvalidOperation
Overflow = self.decimal.Overflow
xc = Context()
xc.prec = 1
xc.Emax = 1
xc.Emin = -1
localcontext() do c 
clear_flags(c)
@test (D(9, xc) == 9)
@test (D(9, context = xc) == 9)
@test (D(context = xc, value = 9) == 9)
@test (D(context = xc) == 0)
clear_flags(xc)
@test_throws
@test xc.flags[InvalidOperation + 1]
@test !(c.flags[InvalidOperation + 1])
clear_flags(xc)
@test (exp(D(2), context = xc) == 7)
@test_throws
@test xc.flags[Overflow + 1]
@test !(c.flags[Overflow + 1])
clear_flags(xc)
@test (ln(D(2), context = xc) == D("0.7"))
@test_throws
@test xc.flags[InvalidOperation + 1]
@test !(c.flags[InvalidOperation + 1])
@test (log10(D(0), context = xc) == D("-inf"))
@test (next_minus(D(-1), context = xc) == -2)
@test (next_plus(D(-1), context = xc) == D("-0.9"))
@test (normalize(D("9.73"), context = xc) == D("1E+1"))
@test (to_integral(D("9999"), context = xc) == 9999)
@test (to_integral_exact(D("-2000"), context = xc) == -2000)
@test (to_integral_value(D("123"), context = xc) == 123)
@test (sqrt(D("0.0625"), context = xc) == D("0.2"))
@test (compare(D("0.0625"), context = xc, other = 3) == -1)
clear_flags(xc)
@test_throws
@test xc.flags[InvalidOperation + 1]
@test !(c.flags[InvalidOperation + 1])
@test (max(D("0.01"), D("0.0101"), context = xc) == D("0.0"))
@test (max(D("0.01"), D("0.0101"), context = xc) == D("0.0"))
@test (max_mag(D("0.2"), D("-0.3"), context = xc) == D("-0.3"))
@test (min(D("0.02"), D("-0.03"), context = xc) == D("-0.0"))
@test (min_mag(D("0.02"), D("-0.03"), context = xc) == D("0.0"))
@test (next_toward(D("0.2"), D("-1"), context = xc) == D("0.1"))
clear_flags(xc)
@test_throws
@test xc.flags[InvalidOperation + 1]
@test !(c.flags[InvalidOperation + 1])
@test (remainder_near(D("9.99"), D("1.5"), context = xc) == D("-0.5"))
@test (fma(D("9.9"), third = D("0.9"), context = xc, other = 7) == D("7E+1"))
@test_throws
@test_throws
@test_throws
@test_throws
@test_throws
@test_throws
@test_throws
@test_throws
@test !(is_normal(D("0.01"), context = xc))
@test is_subnormal(D("0.01"), context = xc)
@test_throws
@test_throws
@test_throws
@test (logb(D(-111), context = xc) == 2)
@test (logical_invert(D(0), context = xc) == 1)
@test (number_class(D("0.01"), context = xc) == "+Subnormal")
@test (to_eng_string(D("0.21"), context = xc) == "0.21")
@test (logical_and(D("11"), D("10"), context = xc) == 0)
@test (logical_or(D("11"), D("10"), context = xc) == 1)
@test (logical_xor(D("01"), D("10"), context = xc) == 1)
@test (rotate(D("23"), 1, context = xc) == 3)
@test (rotate(D("23"), 1, context = xc) == 3)
clear_flags(xc)
@test_throws
@test xc.flags[Overflow + 1]
@test !(c.flags[Overflow + 1])
@test (shift(D("23"), -1, context = xc) == 0)
@test_throws
@test_throws
@test (canonical(D(1)) == 1)
@test_throws
@test_throws
@test_throws
@test_throws
end
end

function test_exception_hierarchy(self::@like(PythonAPItests))
decimal = self.decimal
DecimalException = decimal.DecimalException
InvalidOperation = decimal.InvalidOperation
FloatOperation = decimal.FloatOperation
DivisionByZero = decimal.DivisionByZero
Overflow = decimal.Overflow
Underflow = decimal.Underflow
Subnormal = decimal.Subnormal
Inexact = decimal.Inexact
Rounded = decimal.Rounded
Clamped = decimal.Clamped
@test DecimalException <: ArithmeticError
@test InvalidOperation <: DecimalException
@test FloatOperation <: DecimalException
@test FloatOperation <: TypeError
@test DivisionByZero <: DecimalException
@test DivisionByZero <: ZeroDivisionError
@test Overflow <: Rounded
@test Overflow <: Inexact
@test Overflow <: DecimalException
@test Underflow <: Inexact
@test Underflow <: Rounded
@test Underflow <: Subnormal
@test Underflow <: DecimalException
@test Subnormal <: DecimalException
@test Inexact <: DecimalException
@test Rounded <: DecimalException
@test Clamped <: DecimalException
@test decimal.ConversionSyntax <: InvalidOperation
@test decimal.DivisionImpossible <: InvalidOperation
@test decimal.DivisionUndefined <: InvalidOperation
@test decimal.DivisionUndefined <: ZeroDivisionError
@test decimal.InvalidContext <: InvalidOperation
end


@oodef mutable struct CPythonAPItests <: PythonAPItests
                    
                    decimal
                    
function new(decimal = C)
decimal = decimal
new(decimal)
end

                end
                

@oodef mutable struct PyPythonAPItests <: PythonAPItests
                    
                    decimal
                    
function new(decimal = P)
decimal = decimal
new(decimal)
end

                end
                

@oodef mutable struct ContextAPItests <: unittest.TestCase
                    
                    
                    
                end
                function test_none_args(self::@like(ContextAPItests))
Context = self.decimal.Context
InvalidOperation = self.decimal.InvalidOperation
DivisionByZero = self.decimal.DivisionByZero
Overflow = self.decimal.Overflow
c1 = Context()
c2 = Context(prec = nothing, rounding = nothing, Emax = nothing, Emin = nothing, capitals = nothing, clamp = nothing, flags = nothing, traps = nothing)
for c in [c1, c2]
@test (c.prec == 28)
@test (c.rounding == ROUND_HALF_EVEN)
@test (c.Emax == 999999)
@test (c.Emin == -999999)
@test (c.capitals == 1)
@test (c.clamp == 0)
assert_signals(c, "flags", [])
assert_signals(c, "traps", [InvalidOperation, DivisionByZero, Overflow])
end
end

function test_from_legacy_strings(self::@like(ContextAPItests))
c = Context(self.decimal)
for rnd in RoundingModes
c.rounding = _testcapi.unicode_legacy_string(rnd)
@test (c.rounding == rnd)
end
s = _testcapi.unicode_legacy_string("")
@test_throws
s = _testcapi.unicode_legacy_string("ROUND_\0UP")
@test_throws
end

function test_pickle(self::@like(ContextAPItests))
for proto in 0:pickle.HIGHEST_PROTOCOL
Context = self.decimal.Context
savedecimal = sys.modules["decimal"]
sys.modules["decimal"] = self.decimal
c = Context()
e = pickle.loads(pickle.dumps(c, proto))
@test (c.prec == e.prec)
@test (c.Emin == e.Emin)
@test (c.Emax == e.Emax)
@test (c.rounding == e.rounding)
@test (c.capitals == e.capitals)
@test (c.clamp == e.clamp)
@test (c.flags == e.flags)
@test (c.traps == e.traps)
combinations = C ? ([(C, P), (P, C)]) : ([(P, P)])
for (dumper, loader) in combinations
for (ri, _) in enumerate(RoundingModes)
for (fi, _) in enumerate(OrderedSignals[dumper])
for (ti, _) in enumerate(OrderedSignals[dumper])
prec = random.randrange(1, 100)
emin = random.randrange(-100, 0)
emax = random.randrange(1, 100)
caps = random.randrange(2)
clamp_ = random.randrange(2)
sys.modules["decimal"] = dumper
c = Context(dumper, prec = prec, Emin = emin, Emax = emax, rounding = RoundingModes[ri + 1], capitals = caps, clamp = clamp_, flags = OrderedSignals[dumper][begin:fi], traps = OrderedSignals[dumper][begin:ti])
s = pickle.dumps(c, proto)
sys.modules["decimal"] = loader
d = pickle.loads(s)
@test isa(self, d)
@test (d.prec == prec)
@test (d.Emin == emin)
@test (d.Emax == emax)
@test (d.rounding == RoundingModes[ri + 1])
@test (d.capitals == caps)
@test (d.clamp_ == clamp)
assert_signals(d, "flags", OrderedSignals[loader][begin:fi])
assert_signals(d, "traps", OrderedSignals[loader][begin:ti])
end
end
end
end
sys.modules["decimal"] = savedecimal
end
end

function test_equality_with_other_types(self::@like(ContextAPItests))
Decimal = self.decimal.Decimal
assertIn(self, Decimal(10), ["a", 1.0, Decimal(10), (1, 2), Dict()])
assertNotIn(self, Decimal(10), ["a", 1.0, (1, 2), Dict()])
end

function test_copy(self::@like(ContextAPItests))
Decimal = self.decimal.Decimal
Context = self.decimal.Context
c = Context()
d = copy(c)
@test (id(c) != id(d))
@test (id(c.flags) != id(d.flags))
@test (id(c.traps) != id(d.traps))
k1 = Set(keys(c.flags))
k2 = Set(keys(d.flags))
@test (k1 == k2)
@test (c.flags == d.flags)
end

function test__clamp(self::@like(ContextAPItests))
Context = self.decimal.Context
c = Context()
@test_throws
end

function test_abs(self::@like(ContextAPItests))
Decimal = self.decimal.Decimal
Context = self.decimal.Context
c = Context()
d = abs(c, Decimal(-1))
@test (abs(c, -1) == d)
@test_throws
end

function test_add(self::@like(ContextAPItests))
Decimal = self.decimal.Decimal
Context = self.decimal.Context
c = Context()
d = add(c, Decimal(1), Decimal(1))
@test (add(c, 1, 1) == d)
@test (add(c, Decimal(1), 1) == d)
@test (add(c, 1, Decimal(1)) == d)
@test_throws
@test_throws
end

function test_compare(self::@like(ContextAPItests))
Decimal = self.decimal.Decimal
Context = self.decimal.Context
c = Context()
d = compare(c, Decimal(1), Decimal(1))
@test (compare(c, 1, 1) == d)
@test (compare(c, Decimal(1), 1) == d)
@test (compare(c, 1, Decimal(1)) == d)
@test_throws
@test_throws
end

function test_compare_signal(self::@like(ContextAPItests))
Decimal = self.decimal.Decimal
Context = self.decimal.Context
c = Context()
d = compare_signal(c, Decimal(1), Decimal(1))
@test (compare_signal(c, 1, 1) == d)
@test (compare_signal(c, Decimal(1), 1) == d)
@test (compare_signal(c, 1, Decimal(1)) == d)
@test_throws
@test_throws
end

function test_compare_total(self::@like(ContextAPItests))
Decimal = self.decimal.Decimal
Context = self.decimal.Context
c = Context()
d = compare_total(c, Decimal(1), Decimal(1))
@test (compare_total(c, 1, 1) == d)
@test (compare_total(c, Decimal(1), 1) == d)
@test (compare_total(c, 1, Decimal(1)) == d)
@test_throws
@test_throws
end

function test_compare_total_mag(self::@like(ContextAPItests))
Decimal = self.decimal.Decimal
Context = self.decimal.Context
c = Context()
d = compare_total_mag(c, Decimal(1), Decimal(1))
@test (compare_total_mag(c, 1, 1) == d)
@test (compare_total_mag(c, Decimal(1), 1) == d)
@test (compare_total_mag(c, 1, Decimal(1)) == d)
@test_throws
@test_throws
end

function test_copy_abs(self::@like(ContextAPItests))
Decimal = self.decimal.Decimal
Context = self.decimal.Context
c = Context()
d = copy_abs(c, Decimal(-1))
@test (copy_abs(c, -1) == d)
@test_throws
end

function test_copy_decimal(self::@like(ContextAPItests))
Decimal = self.decimal.Decimal
Context = self.decimal.Context
c = Context()
d = copy_decimal(c, Decimal(-1))
@test (copy_decimal(c, -1) == d)
@test_throws
end

function test_copy_negate(self::@like(ContextAPItests))
Decimal = self.decimal.Decimal
Context = self.decimal.Context
c = Context()
d = copy_negate(c, Decimal(-1))
@test (copy_negate(c, -1) == d)
@test_throws
end

function test_copy_sign(self::@like(ContextAPItests))
Decimal = self.decimal.Decimal
Context = self.decimal.Context
c = Context()
d = copy_sign(c, Decimal(1), Decimal(-2))
@test (copy_sign(c, 1, -2) == d)
@test (copy_sign(c, Decimal(1), -2) == d)
@test (copy_sign(c, 1, Decimal(-2)) == d)
@test_throws
@test_throws
end

function test_divide(self::@like(ContextAPItests))
Decimal = self.decimal.Decimal
Context = self.decimal.Context
c = Context()
d = divide(c, Decimal(1), Decimal(2))
@test (divide(c, 1, 2) == d)
@test (divide(c, Decimal(1), 2) == d)
@test (divide(c, 1, Decimal(2)) == d)
@test_throws
@test_throws
end

function test_divide_int(self::@like(ContextAPItests))
Decimal = self.decimal.Decimal
Context = self.decimal.Context
c = Context()
d = divide_int(c, Decimal(1), Decimal(2))
@test (divide_int(c, 1, 2) == d)
@test (divide_int(c, Decimal(1), 2) == d)
@test (divide_int(c, 1, Decimal(2)) == d)
@test_throws
@test_throws
end

function test_divmod(self::@like(ContextAPItests))
Decimal = self.decimal.Decimal
Context = self.decimal.Context
c = Context()
d = divmod(c, Decimal(1), Decimal(2))
@test (divmod(c, 1, 2) == d)
@test (divmod(c, Decimal(1), 2) == d)
@test (divmod(c, 1, Decimal(2)) == d)
@test_throws
@test_throws
end

function test_exp(self::@like(ContextAPItests))
Decimal = self.decimal.Decimal
Context = self.decimal.Context
c = Context()
d = exp(c, Decimal(10))
@test (exp(c, 10) == d)
@test_throws
end

function test_fma(self::@like(ContextAPItests))
Decimal = self.decimal.Decimal
Context = self.decimal.Context
c = Context()
d = fma(c, Decimal(2), Decimal(3), Decimal(4))
@test (fma(c, 2, 3, 4) == d)
@test (fma(c, Decimal(2), 3, 4) == d)
@test (fma(c, 2, Decimal(3), 4) == d)
@test (fma(c, 2, 3, Decimal(4)) == d)
@test (fma(c, Decimal(2), Decimal(3), 4) == d)
@test_throws
@test_throws
@test_throws
@test_throws
@test_throws
@test_throws
@test_throws
end

function test_is_finite(self::@like(ContextAPItests))
Decimal = self.decimal.Decimal
Context = self.decimal.Context
c = Context()
d = is_finite(c, Decimal(10))
@test (is_finite(c, 10) == d)
@test_throws
end

function test_is_infinite(self::@like(ContextAPItests))
Decimal = self.decimal.Decimal
Context = self.decimal.Context
c = Context()
d = is_infinite(c, Decimal(10))
@test (is_infinite(c, 10) == d)
@test_throws
end

function test_is_nan(self::@like(ContextAPItests))
Decimal = self.decimal.Decimal
Context = self.decimal.Context
c = Context()
d = is_nan(c, Decimal(10))
@test (is_nan(c, 10) == d)
@test_throws
end

function test_is_normal(self::@like(ContextAPItests))
Decimal = self.decimal.Decimal
Context = self.decimal.Context
c = Context()
d = is_normal(c, Decimal(10))
@test (is_normal(c, 10) == d)
@test_throws
end

function test_is_qnan(self::@like(ContextAPItests))
Decimal = self.decimal.Decimal
Context = self.decimal.Context
c = Context()
d = is_qnan(c, Decimal(10))
@test (is_qnan(c, 10) == d)
@test_throws
end

function test_is_signed(self::@like(ContextAPItests))
Decimal = self.decimal.Decimal
Context = self.decimal.Context
c = Context()
d = is_signed(c, Decimal(10))
@test (is_signed(c, 10) == d)
@test_throws
end

function test_is_snan(self::@like(ContextAPItests))
Decimal = self.decimal.Decimal
Context = self.decimal.Context
c = Context()
d = is_snan(c, Decimal(10))
@test (is_snan(c, 10) == d)
@test_throws
end

function test_is_subnormal(self::@like(ContextAPItests))
Decimal = self.decimal.Decimal
Context = self.decimal.Context
c = Context()
d = is_subnormal(c, Decimal(10))
@test (is_subnormal(c, 10) == d)
@test_throws
end

function test_is_zero(self::@like(ContextAPItests))
Decimal = self.decimal.Decimal
Context = self.decimal.Context
c = Context()
d = is_zero(c, Decimal(10))
@test (is_zero(c, 10) == d)
@test_throws
end

function test_ln(self::@like(ContextAPItests))
Decimal = self.decimal.Decimal
Context = self.decimal.Context
c = Context()
d = ln(c, Decimal(10))
@test (ln(c, 10) == d)
@test_throws
end

function test_log10(self::@like(ContextAPItests))
Decimal = self.decimal.Decimal
Context = self.decimal.Context
c = Context()
d = log10(c, Decimal(10))
@test (log10(c, 10) == d)
@test_throws
end

function test_logb(self::@like(ContextAPItests))
Decimal = self.decimal.Decimal
Context = self.decimal.Context
c = Context()
d = logb(c, Decimal(10))
@test (logb(c, 10) == d)
@test_throws
end

function test_logical_and(self::@like(ContextAPItests))
Decimal = self.decimal.Decimal
Context = self.decimal.Context
c = Context()
d = logical_and(c, Decimal(1), Decimal(1))
@test (logical_and(c, 1, 1) == d)
@test (logical_and(c, Decimal(1), 1) == d)
@test (logical_and(c, 1, Decimal(1)) == d)
@test_throws
@test_throws
end

function test_logical_invert(self::@like(ContextAPItests))
Decimal = self.decimal.Decimal
Context = self.decimal.Context
c = Context()
d = logical_invert(c, Decimal(1000))
@test (logical_invert(c, 1000) == d)
@test_throws
end

function test_logical_or(self::@like(ContextAPItests))
Decimal = self.decimal.Decimal
Context = self.decimal.Context
c = Context()
d = logical_or(c, Decimal(1), Decimal(1))
@test (logical_or(c, 1, 1) == d)
@test (logical_or(c, Decimal(1), 1) == d)
@test (logical_or(c, 1, Decimal(1)) == d)
@test_throws
@test_throws
end

function test_logical_xor(self::@like(ContextAPItests))
Decimal = self.decimal.Decimal
Context = self.decimal.Context
c = Context()
d = logical_xor(c, Decimal(1), Decimal(1))
@test (logical_xor(c, 1, 1) == d)
@test (logical_xor(c, Decimal(1), 1) == d)
@test (logical_xor(c, 1, Decimal(1)) == d)
@test_throws
@test_throws
end

function test_max(self::@like(ContextAPItests))
Decimal = self.decimal.Decimal
Context = self.decimal.Context
c = Context()
d = max(c, Decimal(1), Decimal(2))
@test (max(c, 1, 2) == d)
@test (max(c, Decimal(1), 2) == d)
@test (max(c, 1, Decimal(2)) == d)
@test_throws
@test_throws
end

function test_max_mag(self::@like(ContextAPItests))
Decimal = self.decimal.Decimal
Context = self.decimal.Context
c = Context()
d = max_mag(c, Decimal(1), Decimal(2))
@test (max_mag(c, 1, 2) == d)
@test (max_mag(c, Decimal(1), 2) == d)
@test (max_mag(c, 1, Decimal(2)) == d)
@test_throws
@test_throws
end

function test_min(self::@like(ContextAPItests))
Decimal = self.decimal.Decimal
Context = self.decimal.Context
c = Context()
d = min(c, Decimal(1), Decimal(2))
@test (min(c, 1, 2) == d)
@test (min(c, Decimal(1), 2) == d)
@test (min(c, 1, Decimal(2)) == d)
@test_throws
@test_throws
end

function test_min_mag(self::@like(ContextAPItests))
Decimal = self.decimal.Decimal
Context = self.decimal.Context
c = Context()
d = min_mag(c, Decimal(1), Decimal(2))
@test (min_mag(c, 1, 2) == d)
@test (min_mag(c, Decimal(1), 2) == d)
@test (min_mag(c, 1, Decimal(2)) == d)
@test_throws
@test_throws
end

function test_minus(self::@like(ContextAPItests))
Decimal = self.decimal.Decimal
Context = self.decimal.Context
c = Context()
d = minus(c, Decimal(10))
@test (minus(c, 10) == d)
@test_throws
end

function test_multiply(self::@like(ContextAPItests))
Decimal = self.decimal.Decimal
Context = self.decimal.Context
c = Context()
d = multiply(c, Decimal(1), Decimal(2))
@test (multiply(c, 1, 2) == d)
@test (multiply(c, Decimal(1), 2) == d)
@test (multiply(c, 1, Decimal(2)) == d)
@test_throws
@test_throws
end

function test_next_minus(self::@like(ContextAPItests))
Decimal = self.decimal.Decimal
Context = self.decimal.Context
c = Context()
d = next_minus(c, Decimal(10))
@test (next_minus(c, 10) == d)
@test_throws
end

function test_next_plus(self::@like(ContextAPItests))
Decimal = self.decimal.Decimal
Context = self.decimal.Context
c = Context()
d = next_plus(c, Decimal(10))
@test (next_plus(c, 10) == d)
@test_throws
end

function test_next_toward(self::@like(ContextAPItests))
Decimal = self.decimal.Decimal
Context = self.decimal.Context
c = Context()
d = next_toward(c, Decimal(1), Decimal(2))
@test (next_toward(c, 1, 2) == d)
@test (next_toward(c, Decimal(1), 2) == d)
@test (next_toward(c, 1, Decimal(2)) == d)
@test_throws
@test_throws
end

function test_normalize(self::@like(ContextAPItests))
Decimal = self.decimal.Decimal
Context = self.decimal.Context
c = Context()
d = normalize(c, Decimal(10))
@test (normalize(c, 10) == d)
@test_throws
end

function test_number_class(self::@like(ContextAPItests))
Decimal = self.decimal.Decimal
Context = self.decimal.Context
c = Context()
@test (number_class(c, 123) == number_class(c, Decimal(123)))
@test (number_class(c, 0) == number_class(c, Decimal(0)))
@test (number_class(c, -45) == number_class(c, Decimal(-45)))
end

function test_plus(self::@like(ContextAPItests))
Decimal = self.decimal.Decimal
Context = self.decimal.Context
c = Context()
d = plus(c, Decimal(10))
@test (plus(c, 10) == d)
@test_throws
end

function test_power(self::@like(ContextAPItests))
Decimal = self.decimal.Decimal
Context = self.decimal.Context
c = Context()
d = power(c, Decimal(1), Decimal(4))
@test (power(c, 1, 4) == d)
@test (power(c, Decimal(1), 4) == d)
@test (power(c, 1, Decimal(4)) == d)
@test (power(c, Decimal(1), Decimal(4)) == d)
@test_throws
@test_throws
@test (power(c, modulo = 5, b = 8, a = 2) == 1)
end

function test_quantize(self::@like(ContextAPItests))
Decimal = self.decimal.Decimal
Context = self.decimal.Context
c = Context()
d = quantize(c, Decimal(1), Decimal(2))
@test (quantize(c, 1, 2) == d)
@test (quantize(c, Decimal(1), 2) == d)
@test (quantize(c, 1, Decimal(2)) == d)
@test_throws
@test_throws
end

function test_remainder(self::@like(ContextAPItests))
Decimal = self.decimal.Decimal
Context = self.decimal.Context
c = Context()
d = remainder(c, Decimal(1), Decimal(2))
@test (remainder(c, 1, 2) == d)
@test (remainder(c, Decimal(1), 2) == d)
@test (remainder(c, 1, Decimal(2)) == d)
@test_throws
@test_throws
end

function test_remainder_near(self::@like(ContextAPItests))
Decimal = self.decimal.Decimal
Context = self.decimal.Context
c = Context()
d = remainder_near(c, Decimal(1), Decimal(2))
@test (remainder_near(c, 1, 2) == d)
@test (remainder_near(c, Decimal(1), 2) == d)
@test (remainder_near(c, 1, Decimal(2)) == d)
@test_throws
@test_throws
end

function test_rotate(self::@like(ContextAPItests))
Decimal = self.decimal.Decimal
Context = self.decimal.Context
c = Context()
d = rotate(c, Decimal(1), Decimal(2))
@test (rotate(c, 1, 2) == d)
@test (rotate(c, Decimal(1), 2) == d)
@test (rotate(c, 1, Decimal(2)) == d)
@test_throws
@test_throws
end

function test_sqrt(self::@like(ContextAPItests))
Decimal = self.decimal.Decimal
Context = self.decimal.Context
c = Context()
d = sqrt(c, Decimal(10))
@test (sqrt(c, 10) == d)
@test_throws
end

function test_same_quantum(self::@like(ContextAPItests))
Decimal = self.decimal.Decimal
Context = self.decimal.Context
c = Context()
d = same_quantum(c, Decimal(1), Decimal(2))
@test (same_quantum(c, 1, 2) == d)
@test (same_quantum(c, Decimal(1), 2) == d)
@test (same_quantum(c, 1, Decimal(2)) == d)
@test_throws
@test_throws
end

function test_scaleb(self::@like(ContextAPItests))
Decimal = self.decimal.Decimal
Context = self.decimal.Context
c = Context()
d = scaleb(c, Decimal(1), Decimal(2))
@test (scaleb(c, 1, 2) == d)
@test (scaleb(c, Decimal(1), 2) == d)
@test (scaleb(c, 1, Decimal(2)) == d)
@test_throws
@test_throws
end

function test_shift(self::@like(ContextAPItests))
Decimal = self.decimal.Decimal
Context = self.decimal.Context
c = Context()
d = shift(c, Decimal(1), Decimal(2))
@test (shift(c, 1, 2) == d)
@test (shift(c, Decimal(1), 2) == d)
@test (shift(c, 1, Decimal(2)) == d)
@test_throws
@test_throws
end

function test_subtract(self::@like(ContextAPItests))
Decimal = self.decimal.Decimal
Context = self.decimal.Context
c = Context()
d = subtract(c, Decimal(1), Decimal(2))
@test (subtract(c, 1, 2) == d)
@test (subtract(c, Decimal(1), 2) == d)
@test (subtract(c, 1, Decimal(2)) == d)
@test_throws
@test_throws
end

function test_to_eng_string(self::@like(ContextAPItests))
Decimal = self.decimal.Decimal
Context = self.decimal.Context
c = Context()
d = to_eng_string(c, Decimal(10))
@test (to_eng_string(c, 10) == d)
@test_throws
end

function test_to_sci_string(self::@like(ContextAPItests))
Decimal = self.decimal.Decimal
Context = self.decimal.Context
c = Context()
d = to_sci_string(c, Decimal(10))
@test (to_sci_string(c, 10) == d)
@test_throws
end

function test_to_integral_exact(self::@like(ContextAPItests))
Decimal = self.decimal.Decimal
Context = self.decimal.Context
c = Context()
d = to_integral_exact(c, Decimal(10))
@test (to_integral_exact(c, 10) == d)
@test_throws
end

function test_to_integral_value(self::@like(ContextAPItests))
Decimal = self.decimal.Decimal
Context = self.decimal.Context
c = Context()
d = to_integral_value(c, Decimal(10))
@test (to_integral_value(c, 10) == d)
@test_throws
@test_throws
end


@oodef mutable struct CContextAPItests <: ContextAPItests
                    
                    decimal
                    
function new(decimal = C)
decimal = decimal
new(decimal)
end

                end
                

@oodef mutable struct PyContextAPItests <: ContextAPItests
                    
                    decimal
                    
function new(decimal = P)
decimal = decimal
new(decimal)
end

                end
                

@oodef mutable struct ContextWithStatement <: unittest.TestCase
                    
                    
                    
                end
                function test_localcontext(self::@like(ContextWithStatement))
getcontext = self.decimal.getcontext
localcontext = self.decimal.localcontext
orig_ctx = getcontext()
localcontext() do enter_ctx 
set_ctx = getcontext()
end
final_ctx = getcontext()
@test self === orig_ctx
assertIsNot(self, orig_ctx, set_ctx, "did not copy the context")
@test self === set_ctx
end

function test_localcontextarg(self::@like(ContextWithStatement))
Context = self.decimal.Context
getcontext = self.decimal.getcontext
localcontext = self.decimal.localcontext
localcontext = self.decimal.localcontext
orig_ctx = getcontext()
new_ctx = Context(prec = 42)
localcontext(new_ctx) do enter_ctx 
set_ctx = getcontext()
end
final_ctx = getcontext()
@test self === orig_ctx
@test (set_ctx.prec == new_ctx.prec)
assertIsNot(self, new_ctx, set_ctx, "did not copy the context")
@test self === set_ctx
end

function test_nested_with_statements(self::@like(ContextWithStatement))
Decimal = self.decimal.Decimal
Context = self.decimal.Context
getcontext = self.decimal.getcontext
localcontext = self.decimal.localcontext
Clamped = self.decimal.Clamped
Overflow = self.decimal.Overflow
orig_ctx = getcontext()
clear_flags(orig_ctx)
new_ctx = Context(Emax = 384)
localcontext() do c1 
@test (c1.flags == orig_ctx.flags)
@test (c1.traps == orig_ctx.traps)
c1.traps[Clamped + 1] = true
c1.Emin = -383
@test (orig_ctx.Emin != -383)
@test_throws
@test c1.flags[Clamped + 1]
localcontext(new_ctx) do c2 
@test (c2.flags == new_ctx.flags)
@test (c2.traps == new_ctx.traps)
@test_throws
@test !(c2.flags[Clamped + 1])
@test c2.flags[Overflow + 1]
# Delete Unsupported
# del(c2)
end
@test !(c1.flags[Overflow + 1])
# Delete Unsupported
# del(c1)
end
@test (orig_ctx.Emin != -383)
@test !(orig_ctx.flags[Clamped + 1])
@test !(orig_ctx.flags[Overflow + 1])
@test !(new_ctx.flags[Clamped + 1])
@test !(new_ctx.flags[Overflow + 1])
end

function test_with_statements_gc1(self::@like(ContextWithStatement))
localcontext = self.decimal.localcontext
localcontext() do c1 
# Delete Unsupported
# del(c1)
localcontext() do c2 
# Delete Unsupported
# del(c2)
localcontext() do c3 
# Delete Unsupported
# del(c3)
localcontext() do c4 
# Delete Unsupported
# del(c4)
end
end
end
end
end

function test_with_statements_gc2(self::@like(ContextWithStatement))
localcontext = self.decimal.localcontext
localcontext() do c1 
localcontext(c1) do c2 
# Delete Unsupported
# del(c1)
localcontext(c2) do c3 
# Delete Unsupported
# del(c2)
localcontext(c3) do c4 
# Delete Unsupported
# del(c3)
# Delete Unsupported
# del(c4)
end
end
end
end
end

function test_with_statements_gc3(self::@like(ContextWithStatement))
Context = self.decimal.Context
localcontext = self.decimal.localcontext
getcontext = self.decimal.getcontext
setcontext = self.decimal.setcontext
localcontext() do c1 
# Delete Unsupported
# del(c1)
n1 = Context(prec = 1)
setcontext(n1)
localcontext(n1) do c2 
# Delete Unsupported
# del(n1)
@test (c2.prec == 1)
# Delete Unsupported
# del(c2)
n2 = Context(prec = 2)
setcontext(n2)
# Delete Unsupported
# del(n2)
@test (getcontext().prec == 2)
n3 = Context(prec = 3)
setcontext(n3)
@test (getcontext().prec == 3)
localcontext(n3) do c3 
# Delete Unsupported
# del(n3)
@test (c3.prec == 3)
# Delete Unsupported
# del(c3)
n4 = Context(prec = 4)
setcontext(n4)
# Delete Unsupported
# del(n4)
@test (getcontext().prec == 4)
localcontext() do c4 
@test (c4.prec == 4)
# Delete Unsupported
# del(c4)
end
end
end
end
end


@oodef mutable struct CContextWithStatement <: ContextWithStatement
                    
                    decimal
                    
function new(decimal = C)
decimal = decimal
new(decimal)
end

                end
                

@oodef mutable struct PyContextWithStatement <: ContextWithStatement
                    
                    decimal
                    
function new(decimal = P)
decimal = decimal
new(decimal)
end

                end
                

@oodef mutable struct ContextFlags <: unittest.TestCase
                    
                    
                    
                end
                function test_flags_irrelevant(self::@like(ContextFlags))
Decimal = self.decimal.Decimal
Context = self.decimal.Context
Inexact = self.decimal.Inexact
Rounded = self.decimal.Rounded
Underflow = self.decimal.Underflow
Clamped = self.decimal.Clamped
Subnormal = self.decimal.Subnormal
function raise_error(context::@like(ContextFlags), flag)
if self.decimal == C
context.flags[flag + 1] = true
if context.traps[flag + 1]
throw(flag)
end
else
_raise_error(context, flag)
end
end

context = Context(prec = 9, Emin = -425000000, Emax = 425000000, rounding = ROUND_HALF_EVEN, traps = [], flags = [])
operations = [(context._apply, [Decimal("100E-425000010")]), (context.sqrt, [Decimal(2)]), (context.add, [Decimal("1.23456789"), Decimal("9.87654321")]), (context.multiply, [Decimal("1.23456789"), Decimal("9.87654321")]), (context.subtract, [Decimal("1.23456789"), Decimal("9.87654321")])]
flagsets = [[Inexact], [Rounded], [Underflow], [Clamped], [Subnormal], [Inexact, Rounded, Underflow, Clamped, Subnormal]]
for (fn, args) in operations
clear_flags(context)
ans = fn(args...)
flags = [k for (k, v) in items(context.flags) if v ]
for extra_flags in flagsets
clear_flags(context)
for flag in extra_flags
raise_error(context, flag)
end
new_ans = fn(args...)
expected_flags = collect(flags)
for flag in extra_flags
if flag ∉ expected_flags
push!(expected_flags, flag)
end
end
sort(expected_flags, key = id)
new_flags = [k for (k, v) in items(context.flags) if v ]
sort(new_flags, key = id)
@test (ans == new_ans)
@test (new_flags == expected_flags)
end
end
end

function test_flag_comparisons(self::@like(ContextFlags))
Context = self.decimal.Context
Inexact = self.decimal.Inexact
Rounded = self.decimal.Rounded
c = Context()
@test (c.flags != c.traps)
@test (c.traps != c.flags)
c.flags = c.traps
@test (c.flags == c.traps)
@test (c.traps == c.flags)
c.flags[Rounded + 1] = true
c.traps = c.flags
@test (c.flags == c.traps)
@test (c.traps == c.flags)
d = Dict()
update(d, c.flags)
@test (d == c.flags)
@test (c.flags == d)
d[Inexact] = true
@test (d != c.flags)
@test (c.flags != d)
d = Dict{Any, Bool}(Inexact => false)
@test (d != c.flags)
@test (c.flags != d)
d = ["xyz"]
@test (d != c.flags)
@test (c.flags != d)
end

function test_float_operation(self::@like(ContextFlags))
Decimal = self.decimal.Decimal
FloatOperation = self.decimal.FloatOperation
localcontext = self.decimal.localcontext
localcontext() do c 
@test !(c.traps[FloatOperation + 1])
clear_flags(c)
@test (Decimal(7.5) == 7.5)
@test c.flags[FloatOperation + 1]
clear_flags(c)
@test (create_decimal(c, 7.5) == 7.5)
@test c.flags[FloatOperation + 1]
clear_flags(c)
x = from_float(Decimal, 7.5)
@test !(c.flags[FloatOperation + 1])
@test (x == 7.5)
@test c.flags[FloatOperation + 1]
clear_flags(c)
x = create_decimal_from_float(c, 7.5)
@test !(c.flags[FloatOperation + 1])
@test (x == 7.5)
@test c.flags[FloatOperation + 1]
c.traps[FloatOperation + 1] = true
clear_flags(c)
@test_throws
@test c.flags[FloatOperation + 1]
clear_flags(c)
@test_throws
@test c.flags[FloatOperation + 1]
clear_flags(c)
x = from_float(Decimal, 7.5)
@test !(c.flags[FloatOperation + 1])
clear_flags(c)
x = create_decimal_from_float(c, 7.5)
@test !(c.flags[FloatOperation + 1])
end
end

function test_float_comparison(self::@like(ContextFlags))
Decimal = self.decimal.Decimal
Context = self.decimal.Context
FloatOperation = self.decimal.FloatOperation
localcontext = self.decimal.localcontext
function assert_attr(a::@like(ContextFlags), b, attr, context, signal = nothing)
clear_flags(context)
f = getfield(a, :attr)
if signal == FloatOperation
@test_throws
else
@test self === f(b)
end
@test context.flags[FloatOperation + 1]
end

small_d = Decimal("0.25")
big_d = Decimal("3.0")
small_f = 0.25
big_f = 3.0
zero_d = Decimal("0.0")
neg_zero_d = Decimal("-0.0")
zero_f = 0.0
neg_zero_f = -0.0
inf_d = Decimal("Infinity")
neg_inf_d = Decimal("-Infinity")
inf_f = parse(Float64, "inf")
neg_inf_f = parse(Float64, "-inf")
function doit(c::@like(ContextFlags), signal = nothing)
for attr in ("__lt__", "__le__")
assert_attr(small_d, big_f, attr, c, signal)
end
for attr in ("__gt__", "__ge__")
assert_attr(big_d, small_f, attr, c, signal)
end
assert_attr(small_d, small_f, "__eq__", c, nothing)
assert_attr(neg_zero_d, neg_zero_f, "__eq__", c, nothing)
assert_attr(neg_zero_d, zero_f, "__eq__", c, nothing)
assert_attr(zero_d, neg_zero_f, "__eq__", c, nothing)
assert_attr(zero_d, zero_f, "__eq__", c, nothing)
assert_attr(neg_inf_d, neg_inf_f, "__eq__", c, nothing)
assert_attr(inf_d, inf_f, "__eq__", c, nothing)
assert_attr(small_d, big_f, "__ne__", c, nothing)
assert_attr(Decimal("0.1"), 0.1, "__ne__", c, nothing)
assert_attr(neg_inf_d, inf_f, "__ne__", c, nothing)
assert_attr(inf_d, neg_inf_f, "__ne__", c, nothing)
assert_attr(Decimal("NaN"), parse(Float64, "nan"), "__ne__", c, nothing)
end

function test_containers(c::@like(ContextFlags), signal = nothing)
clear_flags(c)
s = Set([100.0, Decimal("100.0")])
@test (length(s) == 1)
@test c.flags[FloatOperation + 1]
clear_flags(c)
if signal
@test_throws
else
s = sorted([10.0, Decimal("10.0")])
end
@test c.flags[FloatOperation + 1]
clear_flags(c)
b = 10.0 ∈ [Decimal("10.0"), 1.0]
@test c.flags[FloatOperation + 1]
clear_flags(c)
b = 10.0 ∈ keys(Dict{Any, str}(Decimal("10.0") => "a", 1.0 => "b"))
@test c.flags[FloatOperation + 1]
end

nc = Context()
localcontext(nc) do c 
@test !(c.traps[FloatOperation + 1])
doit(c, signal = nothing)
test_containers(c, signal = nothing)
c.traps[FloatOperation + 1] = true
doit(c, signal = FloatOperation)
test_containers(c, signal = FloatOperation)
end
end

function test_float_operation_default(self::@like(ContextFlags))
Decimal = self.decimal.Decimal
Context = self.decimal.Context
Inexact = self.decimal.Inexact
FloatOperation = self.decimal.FloatOperation
context = Context()
@test !(context.flags[FloatOperation + 1])
@test !(context.traps[FloatOperation + 1])
clear_traps(context)
context.traps[Inexact + 1] = true
context.traps[FloatOperation + 1] = true
@test context.traps[FloatOperation + 1]
@test context.traps[Inexact + 1]
end


@oodef mutable struct CContextFlags <: ContextFlags
                    
                    decimal
                    
function new(decimal = C)
decimal = decimal
new(decimal)
end

                end
                

@oodef mutable struct PyContextFlags <: ContextFlags
                    
                    decimal
                    
function new(decimal = P)
decimal = decimal
new(decimal)
end

                end
                

@oodef mutable struct SpecialContexts <: unittest.TestCase
                    #= Test the context templates. =#

                    
                    
                end
                function test_context_templates(self::@like(SpecialContexts))
BasicContext = self.decimal.BasicContext
ExtendedContext = self.decimal.ExtendedContext
getcontext = self.decimal.getcontext
setcontext = self.decimal.setcontext
InvalidOperation = self.decimal.InvalidOperation
DivisionByZero = self.decimal.DivisionByZero
Overflow = self.decimal.Overflow
Underflow = self.decimal.Underflow
Clamped = self.decimal.Clamped
assert_signals(BasicContext, "traps", [InvalidOperation, DivisionByZero, Overflow, Underflow, Clamped])
savecontext = copy(getcontext())
basic_context_prec = BasicContext.prec
extended_context_prec = ExtendedContext.prec
ex = nothing
try
BasicContext.prec=ExtendedContext.prec = 441
for template in (BasicContext, ExtendedContext)
setcontext(template)
c = getcontext()
assertIsNot(self, c, template)
@test (c.prec == 441)
end
catch exn
 let e = exn
if e isa Exception
ex = e.__class__
end
end
finally
BasicContext.prec = basic_context_prec
ExtendedContext.prec = extended_context_prec
setcontext(savecontext)
if ex
throw(ex)
end
end
end

function test_default_context(self::@like(SpecialContexts))
DefaultContext = self.decimal.DefaultContext
BasicContext = self.decimal.BasicContext
ExtendedContext = self.decimal.ExtendedContext
getcontext = self.decimal.getcontext
setcontext = self.decimal.setcontext
InvalidOperation = self.decimal.InvalidOperation
DivisionByZero = self.decimal.DivisionByZero
Overflow = self.decimal.Overflow
@test (BasicContext.prec == 9)
@test (ExtendedContext.prec == 9)
assert_signals(DefaultContext, "traps", [InvalidOperation, DivisionByZero, Overflow])
savecontext = copy(getcontext())
default_context_prec = DefaultContext.prec
ex = nothing
try
c = getcontext()
saveprec = c.prec
DefaultContext.prec = 961
c = getcontext()
@test (c.prec == saveprec)
setcontext(DefaultContext)
c = getcontext()
assertIsNot(self, c, DefaultContext)
@test (c.prec == 961)
catch exn
 let e = exn
if e isa Exception
ex = e.__class__
end
end
finally
DefaultContext.prec = default_context_prec
setcontext(savecontext)
if ex
throw(ex)
end
end
end


@oodef mutable struct CSpecialContexts <: SpecialContexts
                    
                    decimal
                    
function new(decimal = C)
decimal = decimal
new(decimal)
end

                end
                

@oodef mutable struct PySpecialContexts <: SpecialContexts
                    
                    decimal
                    
function new(decimal = P)
decimal = decimal
new(decimal)
end

                end
                

@oodef mutable struct ContextInputValidation <: unittest.TestCase
                    
                    
                    
                end
                function test_invalid_context(self::@like(ContextInputValidation))
Context = self.decimal.Context
DefaultContext = self.decimal.DefaultContext
c = copy(DefaultContext)
for attr in ["prec", "Emax"]
setfield!(c, :attr, 999999)
@test (getfield(c, :attr) == 999999)
@test_throws
@test_throws
end
setfield!(c, :"Emin", -999999)
@test (getfield(c, :Emin) == -999999)
@test_throws
@test_throws
@test_throws
@test_throws
@test_throws
@test_throws
for attr in ["capitals", "clamp"]
@test_throws
@test_throws
@test_throws
end
@test_throws
@test_throws
@test_throws
@test_throws
for attr in ["prec", "Emax", "Emin", "rounding", "capitals", "clamp", "flags", "traps"]
@test_throws
end
@test_throws
@test_throws
@test_throws
@test_throws
@test_throws
@test_throws
@test_throws
@test_throws
@test_throws
@test_throws
end


@oodef mutable struct CContextInputValidation <: ContextInputValidation
                    
                    decimal
                    
function new(decimal = C)
decimal = decimal
new(decimal)
end

                end
                

@oodef mutable struct PyContextInputValidation <: ContextInputValidation
                    
                    decimal
                    
function new(decimal = P)
decimal = decimal
new(decimal)
end

                end
                

@oodef mutable struct MyContext <: Context
                    
                    prec
rounding
Emin
Emax
capitals
clamp
flags
traps
                    
function new(prec = nothing, rounding = nothing, Emin = nothing, Emax = nothing, capitals = nothing, clamp = nothing, flags = nothing, traps = nothing)
Context()
if prec !== nothing
self.prec = prec
end
if rounding !== nothing
self.rounding_ = rounding
end
if Emin !== nothing
self.Emin = Emin
end
if Emax !== nothing
self.Emax = Emax
end
if capitals !== nothing
self.capitals = capitals
end
if clamp !== nothing
self.clamp_ = clamp
end
if flags !== nothing
if isa(flags, Vector)
flags = Dict(v => v ∈ flags for v in OrderedSignals[decimal] + flags)
end
self.flags = flags
end
if traps !== nothing
if isa(traps, Vector)
traps = Dict(v => v ∈ traps for v in OrderedSignals[decimal] + traps)
end
self.traps = traps
end
@mk begin
prec = prec
rounding = rounding
Emin = Emin
Emax = Emax
capitals = capitals
clamp = clamp
flags = flags
traps = traps
end
end

                end
                

@oodef mutable struct ContextSubclassing <: unittest.TestCase
                    
                    
                    
                end
                function test_context_subclassing(self::@like(ContextSubclassing))
decimal = self.decimal
Decimal = decimal.Decimal
Context = decimal.Context
Clamped = decimal.Clamped
DivisionByZero = decimal.DivisionByZero
Inexact = decimal.Inexact
Overflow = decimal.Overflow
Rounded = decimal.Rounded
Subnormal = decimal.Subnormal
Underflow = decimal.Underflow
InvalidOperation = decimal.InvalidOperation
c = Context()
d = MyContext()
for attr in ("prec", "rounding", "Emin", "Emax", "capitals", "clamp", "flags", "traps")
@test (getfield(c, :attr) == getfield(d, :attr))
end
@test_throws
c = MyContext(prec = 1)
@test (c.prec == 1)
@test_throws
@test_throws
c = MyContext(rounding = ROUND_DOWN, prec = 1)
@test (c.rounding == ROUND_DOWN)
@test (plus(c, Decimal("9.9")) == 9)
@test_throws
c = MyContext(Emin = -1, prec = 1)
@test (c.Emin == -1)
x = add(c, Decimal("1e-99"), Decimal("2.234e-2000"))
@test (x == Decimal("0.0"))
for signal in (Inexact, Underflow, Subnormal, Rounded, Clamped)
@test c.flags[signal + 1]
end
@test_throws
c = MyContext(Emax = 1, prec = 1)
@test (c.Emax == 1)
@test_throws
if self.decimal == C
for signal in (Inexact, Overflow, Rounded)
@test c.flags[signal + 1]
end
end
@test_throws
c = MyContext(capitals = 0)
@test (c.capitals == 0)
x = create_decimal(c, "1E222")
@test (to_sci_string(c, x) == "1e+222")
@test_throws
c = MyContext(clamp = 1, Emax = 99)
@test (c.clamp == 1)
x = plus(c, Decimal("1e99"))
@test (string(x) == "1.000000000000000000000000000E+99")
@test_throws
c = MyContext(flags = [Rounded, DivisionByZero])
for signal in (Rounded, DivisionByZero)
@test c.flags[signal + 1]
end
clear_flags(c)
for signal in OrderedSignals[decimal]
@test !(c.flags[signal + 1])
end
@test_throws
c = MyContext(traps = [Rounded, DivisionByZero])
for signal in (Rounded, DivisionByZero)
@test c.traps[signal + 1]
end
clear_traps(c)
for signal in OrderedSignals[decimal]
@test !(c.traps[signal + 1])
end
end


@oodef mutable struct CContextSubclassing <: ContextSubclassing
                    
                    decimal
                    
function new(decimal = C)
decimal = decimal
new(decimal)
end

                end
                

@oodef mutable struct PyContextSubclassing <: ContextSubclassing
                    
                    decimal
                    
function new(decimal = P)
decimal = decimal
new(decimal)
end

                end
                

@oodef mutable struct CheckAttributes <: unittest.TestCase
                    
                    
                    
                end
                function test_module_attributes(self::@like(CheckAttributes))
@test (C.MAX_PREC == P.MAX_PREC)
@test (C.MAX_EMAX == P.MAX_EMAX)
@test (C.MIN_EMIN == P.MIN_EMIN)
@test (C.MIN_ETINY == P.MIN_ETINY)
@test C.HAVE_THREADS === true||C.HAVE_THREADS === false
@test P.HAVE_THREADS === true||P.HAVE_THREADS === false
@test (C.__version__ == P.__version__)
@test (dir(C) == dir(P))
end

function test_context_attributes(self::@like(CheckAttributes))
x = [s for s in dir(Context(C)) if "__" ∈ s||!startswith(s, "_") ]
y = [s for s in dir(Context(P)) if "__" ∈ s||!startswith(s, "_") ]
@test (Set(x) - Set(y) == Set())
end

function test_decimal_attributes(self::@like(CheckAttributes))
x = [s for s in dir(Decimal(C, 9)) if "__" ∈ s||!startswith(s, "_") ]
y = [s for s in dir(Decimal(C, 9)) if "__" ∈ s||!startswith(s, "_") ]
@test (Set(x) - Set(y) == Set())
end


@oodef mutable struct Coverage <: unittest.TestCase
                    
                    
                    
                end
                function test_adjusted(self::@like(Coverage))
Decimal = self.decimal.Decimal
@test (adjusted(Decimal("1234e9999")) == 10002)
@test (adjusted(Decimal("nan")) == 0)
@test (adjusted(Decimal("inf")) == 0)
end

function test_canonical(self::@like(Coverage))
Decimal = self.decimal.Decimal
getcontext = self.decimal.getcontext
x = canonical(Decimal(9))
@test (x == 9)
c = getcontext()
x = canonical(c, Decimal(9))
@test (x == 9)
end

function test_context_repr(self::@like(Coverage))
c = copy(self.decimal.DefaultContext)
c.prec = 425000000
c.Emax = 425000000
c.Emin = -425000000
c.rounding = ROUND_HALF_DOWN
c.capitals = 0
c.clamp = 1
for sig in OrderedSignals[self.decimal]
c.flags[sig + 1] = false
c.traps[sig + 1] = false
end
s = __repr__(c)
t = "Context(prec=425000000, rounding=ROUND_HALF_DOWN, Emin=-425000000, Emax=425000000, capitals=0, clamp=1, flags=[], traps=[])"
@test (s == t)
end

function test_implicit_context(self::@like(Coverage))
Decimal = self.decimal.Decimal
localcontext = self.decimal.localcontext
localcontext() do c 
c.prec = 1
c.Emax = 1
c.Emin = -1
@test (abs(Decimal("-10")) == 10)
@test (Decimal("7") + 1 == 8)
@test (Decimal("10") / 5 == 2)
@test (Decimal("10") ÷ 7 == 1)
@test (fma(Decimal("1.2"), Decimal("0.01"), 1) == 1)
@test self === is_nan(fma(Decimal("NaN"), 7, 1))
@test (pow(Decimal(10), 2, 7) == 2)
@test (exp(Decimal("1.01")) == 3)
@test self === is_normal(Decimal("0.01"))
@test self === is_subnormal(Decimal("0.01"))
@test (ln(Decimal("20")) == 3)
@test (log10(Decimal("20")) == 1)
@test (logb(Decimal("580")) == 2)
@test (logical_invert(Decimal("10")) == 1)
@test (-Decimal("-10") == 10)
@test (Decimal("2")*4 == 8)
@test (next_minus(Decimal("10")) == 9)
@test (next_plus(Decimal("10")) == Decimal("2E+1"))
@test (normalize(Decimal("-10")) == Decimal("-1E+1"))
@test (number_class(Decimal("10")) == "+Normal")
@test (+Decimal("-1") == -1)
@test (Decimal("10") % 7 == 3)
@test (Decimal("10") - 7 == 3)
@test (to_integral_exact(Decimal("1.12345")) == 1)
@test is_canonical(Decimal("1"))
@test is_finite(Decimal("1"))
@test is_finite(Decimal("1"))
@test is_snan(Decimal("snan"))
@test is_signed(Decimal("-1"))
@test is_zero(Decimal("0"))
@test is_zero(Decimal("0"))
end
localcontext() do c 
c.prec = 10000
x = 1228^1523
y = -Decimal(x)
z = copy_abs(y)
@test (z == x)
z = copy_negate(y)
@test (z == x)
z = copy_sign(y, Decimal(1))
@test (z == x)
end
end

function test_divmod(self::@like(Coverage))
Decimal = self.decimal.Decimal
localcontext = self.decimal.localcontext
InvalidOperation = self.decimal.InvalidOperation
DivisionByZero = self.decimal.DivisionByZero
localcontext() do c 
(q, r) = div(Decimal("10912837129"))
@test (q == Decimal("10901935"))
@test (r == Decimal("194"))
(q, r) = div(Decimal("NaN"))
@test is_nan(q)&&is_nan(r)
c.traps[InvalidOperation + 1] = false
(q, r) = div(Decimal("NaN"))
@test is_nan(q)&&is_nan(r)
c.traps[InvalidOperation + 1] = false
clear_flags(c)
(q, r) = div(Decimal("inf"))
@test is_nan(q)&&is_nan(r)
@test c.flags[InvalidOperation + 1]
clear_flags(c)
(q, r) = div(Decimal("inf"))
@test is_infinite(q)&&is_nan(r)
@test c.flags[InvalidOperation + 1]
clear_flags(c)
(q, r) = div(Decimal(0))
@test is_nan(q)&&is_nan(r)
@test c.flags[InvalidOperation + 1]
c.traps[DivisionByZero + 1] = false
clear_flags(c)
(q, r) = div(Decimal(11))
@test is_infinite(q)&&is_nan(r)
@test c.flags[InvalidOperation + 1]&&c.flags[DivisionByZero + 1]
end
end

function test_power(self::@like(Coverage))
Decimal = self.decimal.Decimal
localcontext = self.decimal.localcontext
Overflow = self.decimal.Overflow
Rounded = self.decimal.Rounded
localcontext() do c 
c.prec = 3
clear_flags(c)
@test (Decimal("1.0")^100 == Decimal("1.00"))
@test c.flags[Rounded + 1]
c.prec = 1
c.Emax = 1
c.Emin = -1
clear_flags(c)
c.traps[Overflow + 1] = false
@test (Decimal(10000)^Decimal("0.5") == Decimal("inf"))
@test c.flags[Overflow + 1]
end
end

function test_quantize(self::@like(Coverage))
Decimal = self.decimal.Decimal
localcontext = self.decimal.localcontext
InvalidOperation = self.decimal.InvalidOperation
localcontext() do c 
c.prec = 1
c.Emax = 1
c.Emin = -1
c.traps[InvalidOperation + 1] = false
x = quantize(Decimal(99), Decimal("1e1"))
@test is_nan(x)
end
end

function test_radix(self::@like(Coverage))
Decimal = self.decimal.Decimal
getcontext = self.decimal.getcontext
c = getcontext()
@test (radix(Decimal("1")) == 10)
@test (radix(c) == 10)
end

function test_rop(self::@like(Coverage))
Decimal = self.decimal.Decimal
for attr in ("__radd__", "__rsub__", "__rmul__", "__rtruediv__", "__rdivmod__", "__rmod__", "__rfloordiv__", "__rpow__")
@test self === getfield(Decimal("1"), :attr)("xyz")
end
end

function test_round(self::@like(Coverage))
Decimal = self.decimal.Decimal
localcontext = self.decimal.localcontext
localcontext() do c 
c.prec = 28
@test (string(__round__(Decimal("9.99"))) == "10")
@test (string(__round__(Decimal("9.99e-5"))) == "0")
@test (string(__round__(Decimal("1.23456789"), 5)) == "1.23457")
@test (string(__round__(Decimal("1.2345"), 10)) == "1.2345000000")
@test (string(__round__(Decimal("1.2345"), -10)) == "0E+10")
@test_throws
@test_throws
end
end

function test_create_decimal(self::@like(Coverage))
c = Context(self.decimal)
@test_throws
end

function test_int(self::@like(Coverage))
Decimal = self.decimal.Decimal
localcontext = self.decimal.localcontext
localcontext() do c 
c.prec = 9999
x = Decimal(1221^1271) / 10^3923
@test (parse(Int, x) == 1)
@test (to_integral(x) == 2)
end
end

function test_copy(self::@like(Coverage))
Context = self.decimal.Context
c = Context()
c.prec = 10000
x = -(1172^1712)
y = copy_abs(c, x)
@test (y == -x)
y = copy_negate(c, x)
@test (y == -x)
y = copy_sign(c, x, 1)
@test (y == -x)
end


@oodef mutable struct CCoverage <: Coverage
                    
                    decimal
                    
function new(decimal = C)
decimal = decimal
new(decimal)
end

                end
                

@oodef mutable struct PyCoverage <: Coverage
                    
                    decimal
                    
function new(decimal = P)
decimal = decimal
new(decimal)
end

                end
                

@oodef mutable struct PyFunctionality <: unittest.TestCase
                    #= Extra functionality in decimal.py =#

                    
                    
                end
                function test_py_alternate_formatting(self::@like(PyFunctionality))
Decimal = P.Decimal
localcontext = P.localcontext
test_values = [(".0e", "1.0", "1e+0"), ("#.0e", "1.0", "1.e+0"), (".0f", "1.0", "1"), ("#.0f", "1.0", "1."), ("g", "1.1", "1.1"), ("#g", "1.1", "1.1"), (".0g", "1", "1"), ("#.0g", "1", "1."), (".0%", "1.0", "100%"), ("#.0%", "1.0", "100.%")]
for (fmt, d, result) in test_values
@test (Decimal(d) == result)
end
end


@oodef mutable struct PyWhitebox <: unittest.TestCase
                    #= White box testing for decimal.py =#

                    
                    
                end
                function test_py_exact_power(self::@like(PyWhitebox))
Decimal = P.Decimal
localcontext = P.localcontext
localcontext() do c 
c.prec = 8
x = Decimal(2^16)^Decimal("-0.5")
@test (x == Decimal("0.00390625"))
x = Decimal(2^16)^Decimal("-0.6")
@test (x == Decimal("0.0012885819"))
x = Decimal("256e7")^Decimal("-0.5")
x = Decimal(152587890625)^Decimal("-0.0625")
@test (x == Decimal("0.2"))
x = Decimal("152587890625e7")^Decimal("-0.0625")
x = Decimal(5^2659)^Decimal("-0.0625")
c.prec = 1
x = Decimal("152587890625")^Decimal("-0.5")
c.prec = 201
x = Decimal(2^578)^Decimal("-0.5")
end
end

function test_py_immutability_operations(self::@like(PyWhitebox))
Decimal = P.Decimal
DefaultContext = P.DefaultContext
setcontext = P.setcontext
c = copy(DefaultContext)
c.traps = dict(((s, 0) for s in OrderedSignals[P]))
setcontext(c)
d1 = Decimal("-25e55")
b1 = Decimal("-25e55")
d2 = Decimal("33e+33")
b2 = Decimal("33e+33")
function checkSameDec(operation::@like(PyWhitebox), useOther = false)
if useOther
py""d1." + operation + "(d2)""
@test (d1._sign == b1._sign)
@test (d1._int == b1._int)
@test (d1._exp == b1._exp)
@test (d2._sign == b2._sign)
@test (d2._int == b2._int)
@test (d2._exp == b2._exp)
else
py""d1." + operation + "()""
@test (d1._sign == b1._sign)
@test (d1._int == b1._int)
@test (d1._exp == b1._exp)
end
end

Decimal(d1)
@test (d1._sign == b1._sign)
@test (d1._int == b1._int)
@test (d1._exp == b1._exp)
checkSameDec("__abs__")
checkSameDec("__add__", true)
checkSameDec("__divmod__", true)
checkSameDec("__eq__", true)
checkSameDec("__ne__", true)
checkSameDec("__le__", true)
checkSameDec("__lt__", true)
checkSameDec("__ge__", true)
checkSameDec("__gt__", true)
checkSameDec("__float__")
checkSameDec("__floordiv__", true)
checkSameDec("__hash__")
checkSameDec("__int__")
checkSameDec("__trunc__")
checkSameDec("__mod__", true)
checkSameDec("__mul__", true)
checkSameDec("__neg__")
checkSameDec("__bool__")
checkSameDec("__pos__")
checkSameDec("__pow__", true)
checkSameDec("__radd__", true)
checkSameDec("__rdivmod__", true)
checkSameDec("__repr__")
checkSameDec("__rfloordiv__", true)
checkSameDec("__rmod__", true)
checkSameDec("__rmul__", true)
checkSameDec("__rpow__", true)
checkSameDec("__rsub__", true)
checkSameDec("__str__")
checkSameDec("__sub__", true)
checkSameDec("__truediv__", true)
checkSameDec("adjusted")
checkSameDec("as_tuple")
checkSameDec("compare", true)
checkSameDec("max", true)
checkSameDec("min", true)
checkSameDec("normalize")
checkSameDec("quantize", true)
checkSameDec("remainder_near", true)
checkSameDec("same_quantum", true)
checkSameDec("sqrt")
checkSameDec("to_eng_string")
checkSameDec("to_integral")
end

function test_py_decimal_id(self::@like(PyWhitebox))
Decimal = P.Decimal
d = Decimal(45)
e = Decimal(d)
@test (string(e) == "45")
@test (id(d) != id(e))
end

function test_py_rescale(self::@like(PyWhitebox))
Decimal = P.Decimal
localcontext = P.localcontext
localcontext() do c 
x = _rescale(Decimal("NaN"), 3, ROUND_UP)
@test is_nan(x)
end
end

function test_py__round(self::@like(PyWhitebox))
Decimal = P.Decimal
@test_throws
end


@oodef mutable struct CFunctionality <: unittest.TestCase
                    #= Extra functionality in _decimal =#

                    
                    
                end
                function test_c_ieee_context(self::@like(CFunctionality))
IEEEContext = C.IEEEContext
DECIMAL32 = C.DECIMAL32
DECIMAL64 = C.DECIMAL64
DECIMAL128 = C.DECIMAL128
function assert_rest(self::@like(CFunctionality), context)
@test (context.clamp == 1)
assert_signals(context, "traps", [])
assert_signals(context, "flags", [])
end

c = IEEEContext(DECIMAL32)
@test (c.prec == 7)
@test (c.Emax == 96)
@test (c.Emin == -95)
assert_rest(c)
c = IEEEContext(DECIMAL64)
@test (c.prec == 16)
@test (c.Emax == 384)
@test (c.Emin == -383)
assert_rest(c)
c = IEEEContext(DECIMAL128)
@test (c.prec == 34)
@test (c.Emax == 6144)
@test (c.Emin == -6143)
assert_rest(c)
@test_throws
@test_throws
@test_throws
end

function test_c_context(self::@like(CFunctionality))
Context = C.Context
c = Context(flags = C.DecClamped, traps = C.DecRounded)
@test (c._flags == C.DecClamped)
@test (c._traps == C.DecRounded)
end

function test_constants(self::@like(CFunctionality))
cond = (C.DecClamped, C.DecConversionSyntax, C.DecDivisionByZero, C.DecDivisionImpossible, C.DecDivisionUndefined, C.DecFpuError, C.DecInexact, C.DecInvalidContext, C.DecInvalidOperation, C.DecMallocError, C.DecFloatOperation, C.DecOverflow, C.DecRounded, C.DecSubnormal, C.DecUnderflow)
@test (C.DECIMAL32 == 32)
@test (C.DECIMAL64 == 64)
@test (C.DECIMAL128 == 128)
@test (C.IEEE_CONTEXT_MAX_BITS == 512)
for (i, v) in enumerate(cond)
@test (v == 1 << i)
end
@test (C.DecIEEEInvalidOperation == (((((C.DecConversionSyntax | C.DecDivisionImpossible) | C.DecDivisionUndefined) | C.DecFpuError) | C.DecInvalidContext) | C.DecInvalidOperation) | C.DecMallocError)
@test (C.DecErrors == C.DecIEEEInvalidOperation | C.DecDivisionByZero)
@test (C.DecTraps == (C.DecErrors | C.DecOverflow) | C.DecUnderflow)
end


@oodef mutable struct X <: Float64
                    
                    
                    
                end
                function as_integer_ratio(self::@like(X))::Int64
return 1
end

function __abs__(self::@like(X))
return self
end


@oodef mutable struct Y <: Float64
                    
                    
                    
                end
                function __abs__(self::@like(Y))::Vector
return repeat([1],200)
end


@oodef mutable struct I <: Int64
                    
                    
                    
                end
                function bit_length(self::@like(I))::Vector
return repeat([1],200)
end


@oodef mutable struct Z <: Float64
                    
                    
                    
                end
                function as_integer_ratio(self::@like(Z))
return (I(1), I(1))
end

function __abs__(self::@like(Z))
return self
end


@oodef mutable struct CWhitebox <: unittest.TestCase
                    #= Whitebox testing for _decimal =#

                    
                    
                end
                function test_bignum(self::@like(CWhitebox))
Decimal = C.Decimal
localcontext = C.localcontext
b1 = 10^35
b2 = 10^36
localcontext() do c 
c.prec = 1000000
for i in 0:4
a = random.randrange(b1, b2)
b = random.randrange(1000, 1200)
x = a^b
y = Decimal(a)^Decimal(b)
@test (x == y)
end
end
end

function test_invalid_construction(self::@like(CWhitebox))
@test_throws
end

function test_c_input_restriction(self::@like(CWhitebox))
Decimal = C.Decimal
InvalidOperation = C.InvalidOperation
Context = C.Context
localcontext = C.localcontext
localcontext(Context()) do 
@test_throws
end
end

function test_c_context_repr(self::@like(CWhitebox))
DefaultContext = C.DefaultContext
FloatOperation = C.FloatOperation
c = copy(DefaultContext)
c.prec = 425000000
c.Emax = 425000000
c.Emin = -425000000
c.rounding = ROUND_HALF_DOWN
c.capitals = 0
c.clamp = 1
for sig in OrderedSignals[C]
c.flags[sig + 1] = true
c.traps[sig + 1] = true
end
c.flags[FloatOperation + 1] = true
c.traps[FloatOperation + 1] = true
s = __repr__(c)
t = "Context(prec=425000000, rounding=ROUND_HALF_DOWN, Emin=-425000000, Emax=425000000, capitals=0, clamp=1, flags=[Clamped, InvalidOperation, DivisionByZero, Inexact, FloatOperation, Overflow, Rounded, Subnormal, Underflow], traps=[Clamped, InvalidOperation, DivisionByZero, Inexact, FloatOperation, Overflow, Rounded, Subnormal, Underflow])"
@test (s == t)
end

function test_c_context_errors(self::@like(CWhitebox))
Context = C.Context
InvalidOperation = C.InvalidOperation
Overflow = C.Overflow
FloatOperation = C.FloatOperation
localcontext = C.localcontext
getcontext = C.getcontext
setcontext = C.setcontext
HAVE_CONFIG_64 = C.MAX_PREC > 425000000
c = Context()
@test_throws
@test_throws
@test_throws
@test_throws
@test_throws
@test_throws
@test_throws
@test_throws
d = copy(c.flags)
# Delete Unsupported
# del(d)
d["XYZ"] = 91283719
@test_throws
@test_throws
int_max = HAVE_CONFIG_64 ? (2^63 - 1) : (2^31 - 1)
gt_max_emax = HAVE_CONFIG_64 ? (10^18) : (10^9)
for attr in ["prec", "Emax"]
@test_throws
end
@test_throws
@test_throws
@test_throws
@test_throws
@test_throws
@test_throws
@test_throws
@test_throws
@test_throws
for attr in ("prec", "Emin", "Emax", "capitals", "clamp")
@test_throws
@test_throws
if sys.platform != "win32"
@test_throws
@test_throws
end
end
if C.MAX_PREC == 425000000
@test_throws
@test_throws
@test_throws
end
if C.MAX_PREC == 425000000
@test_throws
@test_throws
@test_throws
@test_throws
@test_throws
@test_throws
end
for attr in ["capitals", "clamp"]
@test_throws
@test_throws
@test_throws
if HAVE_CONFIG_64
@test_throws
@test_throws
end
end
@test_throws
@test_throws
saved_context = getcontext()
@test_throws
setcontext(saved_context)
end

function test_rounding_strings_interned(self::@like(CWhitebox))
@test self === C.ROUND_UP
@test self === C.ROUND_DOWN
@test self === C.ROUND_CEILING
@test self === C.ROUND_FLOOR
@test self === C.ROUND_HALF_UP
@test self === C.ROUND_HALF_DOWN
@test self === C.ROUND_HALF_EVEN
@test self === C.ROUND_05UP
end

function test_c_context_errors_extra(self::@like(CWhitebox))
Context = C.Context
InvalidOperation = C.InvalidOperation
Overflow = C.Overflow
localcontext = C.localcontext
getcontext = C.getcontext
setcontext = C.setcontext
HAVE_CONFIG_64 = C.MAX_PREC > 425000000
c = Context()
int_max = HAVE_CONFIG_64 ? (2^63 - 1) : (2^31 - 1)
@test_throws
@test_throws
if sys.platform != "win32"
@test_throws
@test_throws
end
for attr in ("_flags", "_traps")
@test_throws
@test_throws
if sys.platform != "win32"
@test_throws
@test_throws
end
end
@test_throws
@test_throws
@test_throws
if HAVE_CONFIG_64
@test_throws
@test_throws
end
for attr in ["_flags", "_traps"]
@test_throws
@test_throws
end
end

function test_c_valid_context(self::@like(CWhitebox))
DefaultContext = C.DefaultContext
Clamped = C.Clamped
Underflow = C.Underflow
Inexact = C.Inexact
Rounded = C.Rounded
Subnormal = C.Subnormal
c = copy(DefaultContext)
c.prec = 34
c.rounding = ROUND_HALF_UP
c.Emax = 3000
c.Emin = -3000
c.capitals = 1
c.clamp = 0
@test (c.prec == 34)
@test (c.rounding == ROUND_HALF_UP)
@test (c.Emin == -3000)
@test (c.Emax == 3000)
@test (c.capitals == 1)
@test (c.clamp == 0)
@test (Etiny(c) == -3033)
@test (Etop(c) == 2967)
if C.MAX_PREC == 425000000
_unsafe_setprec(c, 999999999)
_unsafe_setemax(c, 999999999)
_unsafe_setemin(c, -999999999)
@test (c.prec == 999999999)
@test (c.Emax == 999999999)
@test (c.Emin == -999999999)
end
end

function test_c_valid_context_extra(self::@like(CWhitebox))
DefaultContext = C.DefaultContext
c = copy(DefaultContext)
@test (c._allcr == 1)
c._allcr = 0
@test (c._allcr == 0)
end

function test_c_round(self::@like(CWhitebox))
Decimal = C.Decimal
InvalidOperation = C.InvalidOperation
localcontext = C.localcontext
MAX_EMAX = C.MAX_EMAX
MIN_ETINY = C.MIN_ETINY
int_max = C.MAX_PREC > 425000000 ? (2^63 - 1) : (2^31 - 1)
localcontext() do c 
c.traps[InvalidOperation + 1] = true
@test_throws
@test_throws
@test_throws
@test_throws
@test_throws
@test_throws
end
end

function test_c_format(self::@like(CWhitebox))
Decimal = C.Decimal
HAVE_CONFIG_64 = C.MAX_PREC > 425000000
@test_throws
@test_throws
@test_throws
@test_throws
maxsize = HAVE_CONFIG_64 ? (2^63 - 1) : (2^31 - 1)
@test_throws
end

function test_c_integral(self::@like(CWhitebox))
Decimal = C.Decimal
Inexact = C.Inexact
localcontext = C.localcontext
x = Decimal(10)
@test (to_integral(x) == 10)
@test_throws
@test_throws
@test_throws
@test (to_integral_value(x) == 10)
@test_throws
@test_throws
@test_throws
@test (to_integral_exact(x) == 10)
@test_throws
@test_throws
@test_throws
localcontext() do c 
x = to_integral_value(Decimal("99999999999999999999999999.9"), ROUND_UP)
@test (x == Decimal("100000000000000000000000000"))
x = to_integral_exact(Decimal("99999999999999999999999999.9"), ROUND_UP)
@test (x == Decimal("100000000000000000000000000"))
c.traps[Inexact + 1] = true
@test_throws
end
end

function test_c_funcs(self::@like(CWhitebox))
Decimal = C.Decimal
InvalidOperation = C.InvalidOperation
DivisionByZero = C.DivisionByZero
getcontext = C.getcontext
localcontext = C.localcontext
@test (to_eng_string(Decimal("9.99e10")) == "99.9E+9")
@test_throws
@test_throws
@test_throws
@test_throws
@test_throws
@test_throws
@test_throws
localcontext() do c 
clear_traps(c)
@test_throws
@test_throws
@test_throws
@test_throws
@test_throws
@test (string(canonical(c, Decimal(200))) == "200")
@test (radix(c) == 10)
c.traps[DivisionByZero + 1] = true
@test_throws
@test_throws
@test c.flags[InvalidOperation + 1]
clear_flags(c)
c.traps[InvalidOperation + 1] = true
@test_throws
@test_throws
@test c.flags[DivisionByZero + 1]
c.traps[InvalidOperation + 1] = true
c.prec = 2
@test_throws
end
end

function test_va_args_exceptions(self::@like(CWhitebox))
Decimal = C.Decimal
Context = C.Context
x = Decimal("10001111111")
for attr in ["exp", "is_normal", "is_subnormal", "ln", "log10", "logb", "logical_invert", "next_minus", "next_plus", "normalize", "number_class", "sqrt", "to_eng_string"]
func = getfield(x, :attr)
@test_throws
@test_throws
end
for attr in ["compare", "compare_signal", "logical_and", "logical_or", "max", "max_mag", "min", "min_mag", "remainder_near", "rotate", "scaleb", "shift"]
func = getfield(x, :attr)
@test_throws
@test_throws
end
@test_throws
@test_throws
@test_throws
@test_throws
@test_throws
@test_throws
@test_throws
@test_throws
@test_throws
@test_throws
@test_throws
@test_throws
@test_throws
@test_throws
c = Context()
@test_throws
@test_throws
@test_throws
end

function test_c_context_templates(self::@like(CWhitebox))
@test (C.BasicContext._traps == (((C.DecIEEEInvalidOperation | C.DecDivisionByZero) | C.DecOverflow) | C.DecUnderflow) | C.DecClamped)
@test (C.DefaultContext._traps == (C.DecIEEEInvalidOperation | C.DecDivisionByZero) | C.DecOverflow)
end

function test_c_signal_dict(self::@like(CWhitebox))
Context = C.Context
DefaultContext = C.DefaultContext
InvalidOperation = C.InvalidOperation
FloatOperation = C.FloatOperation
DivisionByZero = C.DivisionByZero
Overflow = C.Overflow
Subnormal = C.Subnormal
Underflow = C.Underflow
Rounded = C.Rounded
Inexact = C.Inexact
Clamped = C.Clamped
DecClamped = C.DecClamped
DecInvalidOperation = C.DecInvalidOperation
DecIEEEInvalidOperation = C.DecIEEEInvalidOperation
function assertIsExclusivelySet(signal::@like(CWhitebox), signal_dict)
for sig in signal_dict
if sig == signal
@test signal_dict[sig + 1]
else
@test !(signal_dict[sig + 1])
end
end
end

c = copy(DefaultContext)
@test Overflow ∈ c.traps
clear_traps(c)
for k in keys(c.traps)
c.traps[k + 1] = true
end
for v in values(c.traps)
@test v
end
clear_traps(c)
for (k, v) in items(c.traps)
@test !(v)
end
@test !(get(c.flags, Overflow))
@test self === get(c.flags, "x")
@test (get(c.flags, "x", "y") == "y")
@test_throws
@test (length(c.flags) == length(c.traps))
s = sys.getsizeof(c.flags)
s = sys.getsizeof(c.traps)
s = __repr__(c.flags)
clear_flags(c)
c._flags = DecClamped
@test c.flags[Clamped + 1]
clear_traps(c)
c._traps = DecInvalidOperation
@test c.traps[InvalidOperation + 1]
clear_flags(c)
d = copy(c.flags)
d[DivisionByZero + 1] = true
c.flags = d
assertIsExclusivelySet(DivisionByZero, c.flags)
clear_traps(c)
d = copy(c.traps)
d[Underflow + 1] = true
c.traps = d
assertIsExclusivelySet(Underflow, c.traps)
IntSignals = Dict(Clamped => C.DecClamped, Rounded => C.DecRounded, Inexact => C.DecInexact, Subnormal => C.DecSubnormal, Underflow => C.DecUnderflow, Overflow => C.DecOverflow, DivisionByZero => C.DecDivisionByZero, FloatOperation => C.DecFloatOperation, InvalidOperation => C.DecIEEEInvalidOperation)
IntCond = [C.DecDivisionImpossible, C.DecDivisionUndefined, C.DecFpuError, C.DecInvalidContext, C.DecInvalidOperation, C.DecMallocError, C.DecConversionSyntax]
lim = length(OrderedSignals[C])
for r in 0:lim - 1
for t in 0:lim - 1
for round in RoundingModes
flags = random.sample(OrderedSignals[C], r)
traps = random.sample(OrderedSignals[C], t)
prec = random.randrange(1, 10000)
emin = random.randrange(-10000, 0)
emax = random.randrange(0, 10000)
clamp_ = random.randrange(0, 2)
caps = random.randrange(0, 2)
cr = random.randrange(0, 2)
c = Context(prec = prec, rounding = round, Emin = emin, Emax = emax, capitals = caps, clamp = clamp_, flags = collect(flags), traps = collect(traps))
@test (c.prec == prec)
@test (c.rounding == round)
@test (c.Emin == emin)
@test (c.Emax == emax)
@test (c.capitals == caps)
@test (c.clamp_ == clamp)
f = 0
for x in flags
f |= IntSignals[x]
end
@test (c._flags == f)
f = 0
for x in traps
f |= IntSignals[x]
end
@test (c._traps == f)
end
end
end
for cond in IntCond
c._flags = cond
@test c._flags & DecIEEEInvalidOperation
assertIsExclusivelySet(InvalidOperation, c.flags)
end
for cond in IntCond
c._traps = cond
@test c._traps & DecIEEEInvalidOperation
assertIsExclusivelySet(InvalidOperation, c.traps)
end
end

function test_invalid_override(self::@like(CWhitebox))
Decimal = C.Decimal
try
catch exn
if exn isa ImportError
skipTest(self, "locale.CHAR_MAX not available")
end
end
function make_grouping(lst::@like(CWhitebox))
return join([Char(x) for x in lst], "")
end

function get_fmt(x::@like(CWhitebox), override = nothing, fmt = "n")
return __format__(Decimal(x), fmt, override)
end

invalid_grouping = Dict{String, Any}("decimal_point" => ",", "grouping" => make_grouping([255, 255, 0]), "thousands_sep" => ",")
invalid_dot = Dict{String, Any}("decimal_point" => "xxxxx", "grouping" => make_grouping([3, 3, 0]), "thousands_sep" => ",")
invalid_sep = Dict{String, Any}("decimal_point" => ".", "grouping" => make_grouping([3, 3, 0]), "thousands_sep" => "yyyyy")
if CHAR_MAX == 127
@test_throws
end
@test_throws
@test_throws
end

function test_exact_conversion(self::@like(CWhitebox))
Decimal = C.Decimal
localcontext = C.localcontext
InvalidOperation = C.InvalidOperation
localcontext() do c 
c.traps[InvalidOperation + 1] = true
x = "0e$(typemax(Int))"
@test_throws
x = "0e$((-(typemax(Int)) - 1))"
@test_throws
x = "1e$(typemax(Int))"
@test_throws
x = "1e$((-(typemax(Int)) - 1))"
@test_throws
end
end

function test_from_tuple(self::@like(CWhitebox))
Decimal = C.Decimal
localcontext = C.localcontext
InvalidOperation = C.InvalidOperation
Overflow = C.Overflow
Underflow = C.Underflow
localcontext() do c 
c.traps[InvalidOperation + 1] = true
c.traps[Overflow + 1] = true
c.traps[Underflow + 1] = true
x = (1, (), typemax(Int))
@test (string(create_decimal(c, x)) == "-0E+999999")
@test_throws
x = (1, (0, 1, 2), typemax(Int))
@test_throws
@test_throws
x = (1, (), -(typemax(Int)) - 1)
@test (string(create_decimal(c, x)) == "-0E-1000007")
@test_throws
x = (1, (0, 1, 2), -(typemax(Int)) - 1)
@test_throws
@test_throws
x = (1, (), typemax(Int) + 1)
@test_throws
@test_throws
x = (1, (), -(typemax(Int)) - 2)
@test_throws
@test_throws
x = (1, (), "N")
@test (string(Decimal(x)) == "-sNaN")
x = (1, (0,), "N")
@test (string(Decimal(x)) == "-sNaN")
x = (1, (0, 1), "N")
@test (string(Decimal(x)) == "-sNaN1")
end
end

function test_sizeof(self::@like(CWhitebox))
Decimal = C.Decimal
HAVE_CONFIG_64 = C.MAX_PREC > 425000000
assertGreater(self, __sizeof__(Decimal(0)), 0)
if HAVE_CONFIG_64
x = __sizeof__(Decimal(10^19*24))
y = __sizeof__(Decimal(10^19*25))
@test (y == x + 8)
else
x = __sizeof__(Decimal(10^9*24))
y = __sizeof__(Decimal(10^9*25))
@test (y == x + 4)
end
end

function test_internal_use_of_overridden_methods(self::@like(CWhitebox))
Decimal = C.Decimal
for cls in (X, Y, Z)
@test (from_float(Decimal, cls(101.1)) == from_float(Decimal, 101.1))
end
end

function test_maxcontext_exact_arith(self::@like(CWhitebox))
MaxContextSkip = ["logical_invert", "next_minus", "next_plus", "logical_and", "logical_or", "logical_xor", "next_toward", "rotate", "shift"]
Decimal = C.Decimal
Context = C.Context
localcontext = C.localcontext
maxcontext = Context(prec = C.MAX_PREC, Emin = C.MIN_EMIN, Emax = C.MAX_EMAX)
localcontext(maxcontext) do 
@test (exp(Decimal(0)) == 1)
@test (ln(Decimal(1)) == 0)
@test (log10(Decimal(1)) == 0)
@test (log10(Decimal(10^2)) == 2)
@test (log10(Decimal(10^223)) == 223)
@test (logb(Decimal(10^19)) == 19)
@test (sqrt(Decimal(4)) == 2)
@test (sqrt(Decimal("40E9")) == Decimal("2.0E+5"))
@test (div(Decimal(10)) == (3, 1))
@test (Decimal(10) ÷ 3 == 3)
@test (Decimal(4) / 2 == 2)
@test (Decimal(400)^-1 == Decimal("0.0025"))
end
end


@oodef mutable struct SignatureTest <: unittest.TestCase
                    #= Function signatures =#

                    
                    
                end
                function test_inspect_module(self::@like(SignatureTest))
for attr in dir(P)
if startswith(attr, "_")
continue;
end
p_func = getfield(P, :attr)
c_func = getfield(C, :attr)
if attr == "Decimal"||attr == "Context"||inspect.isfunction(p_func)
p_sig = inspect.signature(p_func)
c_sig = inspect.signature(c_func)
c_names = collect(keys(c_sig.parameters))
p_names = [x for x in keys(p_sig.parameters) if !startswith(x, "_") ]
@test (c_names == p_names)
c_kind = [x.kind for x in values(c_sig.parameters)]
p_kind = [x[2].kind for x in items(p_sig.parameters) if !startswith(x[1], "_") ]
if attr != "setcontext"
@test (c_kind == p_kind)
end
end
end
end

function test_inspect_types(self::@like(SignatureTest))
POS = inspect._ParameterKind.POSITIONAL_ONLY
POS_KWD = inspect._ParameterKind.POSITIONAL_OR_KEYWORD
pdict = Dict{Any, Dict{String, Any}}(C => Dict{str, Any}("other" => Decimal(C, 1), "third" => Decimal(C, 1), "x" => Decimal(C, 1), "y" => Decimal(C, 1), "z" => Decimal(C, 1), "a" => Decimal(C, 1), "b" => Decimal(C, 1), "c" => Decimal(C, 1), "exp" => Decimal(C, 1), "modulo" => Decimal(C, 1), "num" => "1", "f" => 1.0, "rounding" => C.ROUND_HALF_UP, "context" => getcontext(C)), P => Dict{str, Any}("other" => Decimal(P, 1), "third" => Decimal(P, 1), "a" => Decimal(P, 1), "b" => Decimal(P, 1), "c" => Decimal(P, 1), "exp" => Decimal(P, 1), "modulo" => Decimal(P, 1), "num" => "1", "f" => 1.0, "rounding" => P.ROUND_HALF_UP, "context" => getcontext(P)))
function mkargs(module_::@like(SignatureTest), sig)
args = []
kwargs = Dict()
for (name, param) in items(sig.parameters)
if name == "self"
continue;
end
if param.kind == POS
push!(args, pdict[module_][name])
elseif param.kind == POS_KWD
kwargs[name] = pdict[module_][name]
else
throw(TestFailed("unexpected parameter kind"))
end
end
return (args, kwargs)
end

function tr(s::@like(SignatureTest))::String
#= The C Context docstrings use 'x' in order to prevent confusion
               with the article 'a' in the descriptions. =#
if s == "x"
return "a"
end
if s == "y"
return "b"
end
if s == "z"
return "c"
end
return s
end

function doit(ty::@like(SignatureTest))
p_type = getfield(P, :ty)
c_type = getfield(C, :ty)
for attr in dir(p_type)
if startswith(attr, "_")
continue;
end
p_func = getfield(p_type, :attr)
c_func = getfield(c_type, :attr)
if inspect.isfunction(p_func)
p_sig = inspect.signature(p_func)
c_sig = inspect.signature(c_func)
p_names = collect(keys(p_sig.parameters))
c_names = [tr(x) for x in keys(c_sig.parameters)]
@test (c_names == p_names)
p_kind = [x.kind for x in values(p_sig.parameters)]
c_kind = [x.kind for x in values(c_sig.parameters)]
@test self === p_kind[1]
@test self === c_kind[1]
if ty == "Decimal"
@test (c_kind[2:end] == p_kind[2:end])
else
@test (length(c_kind) == length(p_kind))
end
(args, kwds) = mkargs(C, c_sig)
try
getfield(c_type(9), :attr)(args..., None = kwds)
catch exn
if exn isa Exception
throw(TestFailed("invalid signature for $(c_func): $(args) $(kwds)"))
end
end
(args, kwds) = mkargs(P, p_sig)
try
getfield(p_type(9), :attr)(args..., None = kwds)
catch exn
if exn isa Exception
throw(TestFailed("invalid signature for $(p_func): $(args) $(kwds)"))
end
end
end
end
end

doit("Decimal")
doit("Context")
end


all_tests = [CExplicitConstructionTest, PyExplicitConstructionTest, CImplicitConstructionTest, PyImplicitConstructionTest, CFormatTest, PyFormatTest, CArithmeticOperatorsTest, PyArithmeticOperatorsTest, CThreadingTest, PyThreadingTest, CUsabilityTest, PyUsabilityTest, CPythonAPItests, PyPythonAPItests, CContextAPItests, PyContextAPItests, CContextWithStatement, PyContextWithStatement, CContextFlags, PyContextFlags, CSpecialContexts, PySpecialContexts, CContextInputValidation, PyContextInputValidation, CContextSubclassing, PyContextSubclassing, CCoverage, PyCoverage, CFunctionality, PyFunctionality, CWhitebox, PyWhitebox, CIBMTestCases, PyIBMTestCases]
if !C
all_tests = all_tests[2:2:end]
else
insert(all_tests, 0, CheckAttributes)
insert(all_tests, 1, SignatureTest)
end
function test_main(arith = nothing, verbose = nothing, todo_tests = nothing, debug = nothing)
#=  Execute the tests.

    Runs all arithmetic tests if arith is True or if the "decimal" resource
    is enabled in regrtest.py
     =#
init(C)
init(P)
global TEST_ALL, DEBUG
TEST_ALL = arith !== nothing ? (arith) : (is_resource_enabled("decimal"))
DEBUG = debug
if todo_tests === nothing
test_classes = all_tests
else
test_classes = [CIBMTestCases, PyIBMTestCases]
end
for filename in os.listdir(directory)
if ".decTest" ∉ filename||startswith(filename, ".")
continue;
end
(head, tail_) = split(filename, ".")
if todo_tests !== nothing&&head ∉ todo_tests
continue;
end
tester = (self, f) -> eval_file(self, directory + f)
setfield!(CIBMTestCases, :"test_" + head, tester)
setfield!(PyIBMTestCases, :"test_" + head, tester)
# Delete Unsupported
# del(tester)
end
try
run_unittest(test_classes...)
if todo_tests === nothing
savedecimal = sys.modules["decimal"]
if C
sys.modules["decimal"] = C
run_doctest(C, verbose, optionflags = IGNORE_EXCEPTION_DETAIL)
end
sys.modules["decimal"] = P
run_doctest(P, verbose)
sys.modules["decimal"] = savedecimal
end
finally
if C
setcontext(C, ORIGINAL_CONTEXT[__add__(C, 1)])
end
setcontext(P, ORIGINAL_CONTEXT[P])
if !C
warnings.warn("C tests skipped: no module named _decimal.", UserWarning)
end
if !(orig_sys_decimal === sys.modules["decimal"])
throw(TestFailed("Internal error: unbalanced number of changes to sys.modules[\'decimal\']."))
end
end
end

if abspath(PROGRAM_FILE) == @__FILE__
p = optparse.OptionParser("test_decimal.py [--debug] [{--skip | test1 [test2 [...]]}]")
add_option(p, "--debug", "-d", action = "store_true", help = "shows the test number and context before each test")
add_option(p, "--skip", "-s", action = "store_true", help = "skip over 90% of the arithmetic tests")
(opt, args) = parse_args(p)
if opt.skip
test_main(arith = false, verbose = true)
elseif args
test_main(arith = true, verbose = true, todo_tests = args, debug = opt.debug)
else
test_main(arith = true, verbose = true)
end
test_numbers = TestNumbers()
test_int(test_numbers)
test_float(test_numbers)
test_complex(test_numbers)
aug_assign_test = AugAssignTest()
testBasic(aug_assign_test)
testInList(aug_assign_test)
testInDict(aug_assign_test)
testSequences(aug_assign_test)
testCustomMethods1(aug_assign_test)
testCustomMethods2(aug_assign_test)
legacy_base64_test_case = LegacyBase64TestCase()
test_encodebytes(legacy_base64_test_case)
test_decodebytes(legacy_base64_test_case)
test_encode(legacy_base64_test_case)
test_decode(legacy_base64_test_case)
base_x_y_test_case = BaseXYTestCase()
test_b64encode(base_x_y_test_case)
test_b64decode(base_x_y_test_case)
test_b64decode_padding_error(base_x_y_test_case)
test_b64decode_invalid_chars(base_x_y_test_case)
test_b32encode(base_x_y_test_case)
test_b32decode(base_x_y_test_case)
test_b32decode_casefold(base_x_y_test_case)
test_b32decode_error(base_x_y_test_case)
test_b32hexencode(base_x_y_test_case)
test_b32hexencode_other_types(base_x_y_test_case)
test_b32hexdecode(base_x_y_test_case)
test_b32hexdecode_other_types(base_x_y_test_case)
test_b32hexdecode_error(base_x_y_test_case)
test_b16encode(base_x_y_test_case)
test_b16decode(base_x_y_test_case)
test_a85encode(base_x_y_test_case)
test_b85encode(base_x_y_test_case)
test_a85decode(base_x_y_test_case)
test_b85decode(base_x_y_test_case)
test_a85_padding(base_x_y_test_case)
test_b85_padding(base_x_y_test_case)
test_a85decode_errors(base_x_y_test_case)
test_b85decode_errors(base_x_y_test_case)
test_decode_nonascii_str(base_x_y_test_case)
test_ErrorHeritage(base_x_y_test_case)
test_RFC4648_test_cases(base_x_y_test_case)
test_main = TestMain()
test_encode_decode(test_main)
test_encode_file(test_main)
test_encode_from_stdin(test_main)
test_decode(test_main)
tearDown(test_main)
rat_test_case = RatTestCase()
test_gcd(rat_test_case)
test_constructor(rat_test_case)
test_add(rat_test_case)
test_sub(rat_test_case)
test_mul(rat_test_case)
test_div(rat_test_case)
test_floordiv(rat_test_case)
test_eq(rat_test_case)
test_true_div(rat_test_case)
operation_order_tests = OperationOrderTests()
test_comparison_orders(operation_order_tests)
fallback_blocking_tests = FallbackBlockingTests()
test_fallback_rmethod_blocking(fallback_blocking_tests)
test_fallback_ne_blocking(fallback_blocking_tests)
bool_test = BoolTest()
test_repr(bool_test)
test_str(bool_test)
test_int(bool_test)
test_float(bool_test)
test_math(bool_test)
test_convert(bool_test)
test_keyword_args(bool_test)
test_format(bool_test)
test_hasattr(bool_test)
test_callable(bool_test)
test_isinstance(bool_test)
test_issubclass(bool_test)
test_contains(bool_test)
test_string(bool_test)
test_boolean(bool_test)
test_fileclosed(bool_test)
test_types(bool_test)
test_operator(bool_test)
test_marshal(bool_test)
test_pickle(bool_test)
test_picklevalues(bool_test)
test_convert_to_bool(bool_test)
test_from_bytes(bool_test)
test_sane_len(bool_test)
test_blocked(bool_test)
test_real_and_imag(bool_test)
test_bool_called_at_least_once(bool_test)
builtin_test = BuiltinTest()
test_import(builtin_test)
test_abs(builtin_test)
test_all(builtin_test)
test_any(builtin_test)
test_ascii(builtin_test)
test_neg(builtin_test)
test_callable(builtin_test)
test_chr(builtin_test)
test_cmp(builtin_test)
test_compile(builtin_test)
test_compile_top_level_await_no_coro(builtin_test)
test_compile_top_level_await(builtin_test)
test_compile_top_level_await_invalid_cases(builtin_test)
test_compile_async_generator(builtin_test)
test_delattr(builtin_test)
test_dir(builtin_test)
test_divmod(builtin_test)
test_eval(builtin_test)
test_general_eval(builtin_test)
test_exec(builtin_test)
test_exec_globals(builtin_test)
test_exec_redirected(builtin_test)
test_filter(builtin_test)
test_filter_pickle(builtin_test)
test_getattr(builtin_test)
test_hasattr(builtin_test)
test_hash(builtin_test)
test_hex(builtin_test)
test_id(builtin_test)
test_iter(builtin_test)
test_isinstance(builtin_test)
test_issubclass(builtin_test)
test_len(builtin_test)
test_map(builtin_test)
test_map_pickle(builtin_test)
test_max(builtin_test)
test_min(builtin_test)
test_next(builtin_test)
test_oct(builtin_test)
test_open(builtin_test)
test_open_default_encoding(builtin_test)
test_open_non_inheritable(builtin_test)
test_ord(builtin_test)
test_pow(builtin_test)
test_input(builtin_test)
test_repr(builtin_test)
test_round(builtin_test)
test_round_large(builtin_test)
test_bug_27936(builtin_test)
test_setattr(builtin_test)
test_sum(builtin_test)
test_type(builtin_test)
test_vars(builtin_test)
test_zip(builtin_test)
test_zip_pickle(builtin_test)
test_zip_pickle_strict(builtin_test)
test_zip_pickle_strict_fail(builtin_test)
test_zip_bad_iterable(builtin_test)
test_zip_strict(builtin_test)
test_zip_strict_iterators(builtin_test)
test_zip_strict_error_handling(builtin_test)
test_zip_strict_error_handling_stopiteration(builtin_test)
test_zip_result_gc(builtin_test)
test_format(builtin_test)
test_bin(builtin_test)
test_bytearray_translate(builtin_test)
test_bytearray_extend_error(builtin_test)
test_construct_singletons(builtin_test)
test_warning_notimplemented(builtin_test)
test_breakpoint = TestBreakpoint()
setUp(test_breakpoint)
test_breakpoint(test_breakpoint)
test_breakpoint_with_breakpointhook_set(test_breakpoint)
test_breakpoint_with_breakpointhook_reset(test_breakpoint)
test_breakpoint_with_args_and_keywords(test_breakpoint)
test_breakpoint_with_passthru_error(test_breakpoint)
test_envar_good_path_builtin(test_breakpoint)
test_envar_good_path_other(test_breakpoint)
test_envar_good_path_noop_0(test_breakpoint)
test_envar_good_path_empty_string(test_breakpoint)
test_envar_unimportable(test_breakpoint)
test_envar_ignored_when_hook_is_set(test_breakpoint)
pty_tests = PtyTests()
test_input_tty(pty_tests)
test_input_tty_non_ascii(pty_tests)
test_input_tty_non_ascii_unicode_errors(pty_tests)
test_input_no_stdout_fileno(pty_tests)
test_sorted = TestSorted()
test_basic(test_sorted)
test_bad_arguments(test_sorted)
test_inputtypes(test_sorted)
test_baddecorator(test_sorted)
shutdown_test = ShutdownTest()
test_cleanup(shutdown_test)
test_type = TestType()
test_new_type(test_type)
test_type_nokwargs(test_type)
test_type_name(test_type)
test_type_qualname(test_type)
test_type_doc(test_type)
test_bad_args(test_type)
test_bad_slots(test_type)
test_namespace_order(test_type)
bytes_test = BytesTest()
test_getitem_error(bytes_test)
test_buffer_is_readonly(bytes_test)
test_bytes_blocking(bytes_test)
test_repeat_id_preserving(bytes_test)
byte_array_test = ByteArrayTest()
test_getitem_error(byte_array_test)
test_setitem_error(byte_array_test)
test_nohash(byte_array_test)
test_bytearray_api(byte_array_test)
test_reverse(byte_array_test)
test_clear(byte_array_test)
test_copy(byte_array_test)
test_regexps(byte_array_test)
test_setitem(byte_array_test)
test_delitem(byte_array_test)
test_setslice(byte_array_test)
test_setslice_extend(byte_array_test)
test_fifo_overrun(byte_array_test)
test_del_expand(byte_array_test)
test_extended_set_del_slice(byte_array_test)
test_setslice_trap(byte_array_test)
test_iconcat(byte_array_test)
test_irepeat(byte_array_test)
test_irepeat_1char(byte_array_test)
test_alloc(byte_array_test)
test_init_alloc(byte_array_test)
test_extend(byte_array_test)
test_remove(byte_array_test)
test_pop(byte_array_test)
test_nosort(byte_array_test)
test_append(byte_array_test)
test_insert(byte_array_test)
test_copied(byte_array_test)
test_partition_bytearray_doesnt_share_nullstring(byte_array_test)
test_resize_forbidden(byte_array_test)
test_obsolete_write_lock(byte_array_test)
test_iterator_pickling2(byte_array_test)
test_iterator_length_hint(byte_array_test)
test_repeat_after_setslice(byte_array_test)
assorted_bytes_test = AssortedBytesTest()
test_repr_str(assorted_bytes_test)
test_format(assorted_bytes_test)
test_compare_bytes_to_bytearray(assorted_bytes_test)
test_doc(assorted_bytes_test)
test_from_bytearray(assorted_bytes_test)
test_to_str(assorted_bytes_test)
test_literal(assorted_bytes_test)
test_split_bytearray(assorted_bytes_test)
test_rsplit_bytearray(assorted_bytes_test)
test_return_self(assorted_bytes_test)
test_compare(assorted_bytes_test)
bytearray_p_e_p3137_test = BytearrayPEP3137Test()
test_returns_new_copy(bytearray_p_e_p3137_test)
byte_array_as_string_test = ByteArrayAsStringTest()
bytes_as_string_test = BytesAsStringTest()
byte_array_subclass_test = ByteArraySubclassTest()
test_init_override(byte_array_subclass_test)
bytes_subclass_test = BytesSubclassTest()
test_user_objects = TestUserObjects()
test_str_protocol(test_user_objects)
test_list_protocol(test_user_objects)
test_dict_protocol(test_user_objects)
test_list_copy(test_user_objects)
test_dict_copy(test_user_objects)
test_chain_map = TestChainMap()
test_basics(test_chain_map)
test_ordering(test_chain_map)
test_constructor(test_chain_map)
test_bool(test_chain_map)
test_missing(test_chain_map)
test_order_preservation(test_chain_map)
test_iter_not_calling_getitem_on_maps(test_chain_map)
test_dict_coercion(test_chain_map)
test_new_child(test_chain_map)
test_union_operators(test_chain_map)
test_named_tuple = TestNamedTuple()
test_factory(test_named_tuple)
test_defaults(test_named_tuple)
test_readonly(test_named_tuple)
test_factory_doc_attr(test_named_tuple)
test_field_doc(test_named_tuple)
test_field_doc_reuse(test_named_tuple)
test_field_repr(test_named_tuple)
test_name_fixer(test_named_tuple)
test_module_parameter(test_named_tuple)
test_instance(test_named_tuple)
test_tupleness(test_named_tuple)
test_odd_sizes(test_named_tuple)
test_pickle(test_named_tuple)
test_copy(test_named_tuple)
test_name_conflicts(test_named_tuple)
test_repr(test_named_tuple)
test_keyword_only_arguments(test_named_tuple)
test_namedtuple_subclass_issue_24931(test_named_tuple)
test_field_descriptor(test_named_tuple)
test_new_builtins_issue_43102(test_named_tuple)
test_match_args(test_named_tuple)
a_b_c_test_case = ABCTestCase()
test_counter = TestCounter()
test_basics(test_counter)
test_init(test_counter)
test_total(test_counter)
test_order_preservation(test_counter)
test_update(test_counter)
test_copying(test_counter)
test_copy_subclass(test_counter)
test_conversions(test_counter)
test_invariant_for_the_in_operator(test_counter)
test_multiset_operations(test_counter)
test_inplace_operations(test_counter)
test_subtract(test_counter)
test_unary(test_counter)
test_repr_nonsortable(test_counter)
test_helper_function(test_counter)
test_multiset_operations_equivalent_to_set_operations(test_counter)
test_eq(test_counter)
test_le(test_counter)
test_lt(test_counter)
test_ge(test_counter)
test_gt(test_counter)
comparison_test = ComparisonTest()
test_comparisons(comparison_test)
test_id_comparisons(comparison_test)
test_ne_defaults_to_not_eq(comparison_test)
test_ne_high_priority(comparison_test)
test_ne_low_priority(comparison_test)
test_other_delegation(comparison_test)
test_issue_1393(comparison_test)
complex_test = ComplexTest()
test_truediv(complex_test)
test_truediv_zero_division(complex_test)
test_floordiv(complex_test)
test_floordiv_zero_division(complex_test)
test_richcompare(complex_test)
test_richcompare_boundaries(complex_test)
test_mod(complex_test)
test_mod_zero_division(complex_test)
test_divmod(complex_test)
test_divmod_zero_division(complex_test)
test_pow(complex_test)
test_pow_with_small_integer_exponents(complex_test)
test_boolcontext(complex_test)
test_conjugate(complex_test)
test_constructor(complex_test)
test_constructor_special_numbers(complex_test)
test_underscores(complex_test)
test_hash(complex_test)
test_abs(complex_test)
test_repr_str(complex_test)
test_negative_zero_repr_str(complex_test)
test_neg(complex_test)
test_getnewargs(complex_test)
test_plus_minus_0j(complex_test)
test_negated_imaginary_literal(complex_test)
test_overflow(complex_test)
test_repr_roundtrip(complex_test)
test_format(complex_test)
test_contains = TestContains()
test_common_tests(test_contains)
test_builtin_sequence_types(test_contains)
test_nonreflexive(test_contains)
test_block_fallback(test_contains)
test_abstract_context_manager = TestAbstractContextManager()
test_enter(test_abstract_context_manager)
test_exit_is_abstract(test_abstract_context_manager)
test_structural_subclassing(test_abstract_context_manager)
context_manager_test_case = ContextManagerTestCase()
test_contextmanager_plain(context_manager_test_case)
test_contextmanager_finally(context_manager_test_case)
test_contextmanager_no_reraise(context_manager_test_case)
test_contextmanager_trap_yield_after_throw(context_manager_test_case)
test_contextmanager_except(context_manager_test_case)
test_contextmanager_except_stopiter(context_manager_test_case)
test_contextmanager_except_pep479(context_manager_test_case)
test_contextmanager_do_not_unchain_non_stopiteration_exceptions(context_manager_test_case)
test_contextmanager_attribs(context_manager_test_case)
test_contextmanager_doc_attrib(context_manager_test_case)
test_instance_docstring_given_cm_docstring(context_manager_test_case)
test_keywords(context_manager_test_case)
test_nokeepref(context_manager_test_case)
test_param_errors(context_manager_test_case)
test_recursive(context_manager_test_case)
closing_test_case = ClosingTestCase()
test_instance_docs(closing_test_case)
test_closing(closing_test_case)
test_closing_error(closing_test_case)
nullcontext_test_case = NullcontextTestCase()
test_nullcontext(nullcontext_test_case)
file_context_test_case = FileContextTestCase()
testWithOpen(file_context_test_case)
lock_context_test_case = LockContextTestCase()
testWithLock(lock_context_test_case)
testWithRLock(lock_context_test_case)
testWithCondition(lock_context_test_case)
testWithSemaphore(lock_context_test_case)
testWithBoundedSemaphore(lock_context_test_case)
test_context_decorator = TestContextDecorator()
test_instance_docs(test_context_decorator)
test_contextdecorator(test_context_decorator)
test_contextdecorator_with_exception(test_context_decorator)
test_decorator(test_context_decorator)
test_decorator_with_exception(test_context_decorator)
test_decorating_method(test_context_decorator)
test_typo_enter(test_context_decorator)
test_typo_exit(test_context_decorator)
test_contextdecorator_as_mixin(test_context_decorator)
test_contextmanager_as_decorator(test_context_decorator)
test_exit_stack = TestExitStack()
test_redirect_stdout = TestRedirectStdout()
test_redirect_stderr = TestRedirectStderr()
test_suppress = TestSuppress()
test_instance_docs(test_suppress)
test_no_result_from_enter(test_suppress)
test_no_exception(test_suppress)
test_exact_exception(test_suppress)
test_exception_hierarchy(test_suppress)
test_other_exception(test_suppress)
test_no_args(test_suppress)
test_multiple_exception_args(test_suppress)
test_cm_is_reentrant(test_suppress)
test_abstract_async_context_manager = TestAbstractAsyncContextManager()
test_exit_is_abstract(test_abstract_async_context_manager)
test_structural_subclassing(test_abstract_async_context_manager)
async_context_manager_test_case = AsyncContextManagerTestCase()
test_contextmanager_attribs(async_context_manager_test_case)
test_contextmanager_doc_attrib(async_context_manager_test_case)
aclosing_test_case = AclosingTestCase()
test_instance_docs(aclosing_test_case)
test_async_exit_stack = TestAsyncExitStack()
setUp(test_async_exit_stack)
test_async_nullcontext = TestAsyncNullcontext()
test_case = TestCase()
test_no_fields(test_case)
test_no_fields_but_member_variable(test_case)
test_one_field_no_default(test_case)
test_field_default_default_factory_error(test_case)
test_field_repr(test_case)
test_named_init_params(test_case)
test_two_fields_one_default(test_case)
test_overwrite_hash(test_case)
test_overwrite_fields_in_derived_class(test_case)
test_field_named_self(test_case)
test_field_named_object(test_case)
test_field_named_object_frozen(test_case)
test_field_named_like_builtin(test_case)
test_field_named_like_builtin_frozen(test_case)
test_0_field_compare(test_case)
test_1_field_compare(test_case)
test_simple_compare(test_case)
test_compare_subclasses(test_case)
test_eq_order(test_case)
test_field_no_default(test_case)
test_field_default(test_case)
test_not_in_repr(test_case)
test_not_in_compare(test_case)
test_hash_field_rules(test_case)
test_init_false_no_default(test_case)
test_class_marker(test_case)
test_field_order(test_case)
test_class_attrs(test_case)
test_disallowed_mutable_defaults(test_case)
test_deliberately_mutable_defaults(test_case)
test_no_options(test_case)
test_not_tuple(test_case)
test_not_other_dataclass(test_case)
test_function_annotations(test_case)
test_missing_default(test_case)
test_missing_default_factory(test_case)
test_missing_repr(test_case)
test_dont_include_other_annotations(test_case)
test_post_init(test_case)
test_post_init_super(test_case)
test_post_init_staticmethod(test_case)
test_post_init_classmethod(test_case)
test_class_var(test_case)
test_class_var_no_default(test_case)
test_class_var_default_factory(test_case)
test_class_var_with_default(test_case)
test_class_var_frozen(test_case)
test_init_var_no_default(test_case)
test_init_var_default_factory(test_case)
test_init_var_with_default(test_case)
test_init_var(test_case)
test_init_var_preserve_type(test_case)
test_init_var_inheritance(test_case)
test_default_factory(test_case)
test_default_factory_with_no_init(test_case)
test_default_factory_not_called_if_value_given(test_case)
test_default_factory_derived(test_case)
test_intermediate_non_dataclass(test_case)
test_classvar_default_factory(test_case)
test_is_dataclass(test_case)
test_is_dataclass_when_getattr_always_returns(test_case)
test_is_dataclass_genericalias(test_case)
test_helper_fields_with_class_instance(test_case)
test_helper_fields_exception(test_case)
test_helper_asdict(test_case)
test_helper_asdict_raises_on_classes(test_case)
test_helper_asdict_copy_values(test_case)
test_helper_asdict_nested(test_case)
test_helper_asdict_builtin_containers(test_case)
test_helper_asdict_builtin_object_containers(test_case)
test_helper_asdict_factory(test_case)
test_helper_asdict_namedtuple(test_case)
test_helper_asdict_namedtuple_key(test_case)
test_helper_asdict_namedtuple_derived(test_case)
test_helper_astuple(test_case)
test_helper_astuple_raises_on_classes(test_case)
test_helper_astuple_copy_values(test_case)
test_helper_astuple_nested(test_case)
test_helper_astuple_builtin_containers(test_case)
test_helper_astuple_builtin_object_containers(test_case)
test_helper_astuple_factory(test_case)
test_helper_astuple_namedtuple(test_case)
test_dynamic_class_creation(test_case)
test_dynamic_class_creation_using_field(test_case)
test_init_in_order(test_case)
test_items_in_dicts(test_case)
test_alternate_classmethod_constructor(test_case)
test_field_metadata_default(test_case)
test_field_metadata_mapping(test_case)
test_field_metadata_custom_mapping(test_case)
test_generic_dataclasses(test_case)
test_generic_extending(test_case)
test_generic_dynamic(test_case)
test_dataclasses_pickleable(test_case)
test_dataclasses_qualnames(test_case)
test_field_no_annotation = TestFieldNoAnnotation()
test_field_without_annotation(test_field_no_annotation)
test_field_without_annotation_but_annotation_in_base(test_field_no_annotation)
test_field_without_annotation_but_annotation_in_base_not_dataclass(test_field_no_annotation)
test_doc_string = TestDocString()
test_existing_docstring_not_overridden(test_doc_string)
test_docstring_no_fields(test_doc_string)
test_docstring_one_field(test_doc_string)
test_docstring_two_fields(test_doc_string)
test_docstring_three_fields(test_doc_string)
test_docstring_one_field_with_default(test_doc_string)
test_docstring_one_field_with_default_none(test_doc_string)
test_docstring_list_field(test_doc_string)
test_docstring_list_field_with_default_factory(test_doc_string)
test_docstring_deque_field(test_doc_string)
test_docstring_deque_field_with_default_factory(test_doc_string)
test_init = TestInit()
test_base_has_init(test_init)
test_no_init(test_init)
test_overwriting_init(test_init)
test_inherit_from_protocol(test_init)
test_repr = TestRepr()
test_repr(test_repr)
test_no_repr(test_repr)
test_overwriting_repr(test_repr)
test_eq = TestEq()
test_no_eq(test_eq)
test_overwriting_eq(test_eq)
test_ordering = TestOrdering()
test_functools_total_ordering(test_ordering)
test_no_order(test_ordering)
test_overwriting_order(test_ordering)
test_hash = TestHash()
test_unsafe_hash(test_hash)
test_hash_rules(test_hash)
test_eq_only(test_hash)
test_0_field_hash(test_hash)
test_1_field_hash(test_hash)
test_hash_no_args(test_hash)
test_frozen = TestFrozen()
test_frozen(test_frozen)
test_inherit(test_frozen)
test_inherit_nonfrozen_from_empty_frozen(test_frozen)
test_inherit_nonfrozen_from_empty(test_frozen)
test_inherit_nonfrozen_from_frozen(test_frozen)
test_inherit_frozen_from_nonfrozen(test_frozen)
test_inherit_from_normal_class(test_frozen)
test_non_frozen_normal_derived(test_frozen)
test_overwriting_frozen(test_frozen)
test_frozen_hash(test_frozen)
test_slots = TestSlots()
test_simple(test_slots)
test_derived_added_field(test_slots)
test_generated_slots(test_slots)
test_add_slots_when_slots_exists(test_slots)
test_generated_slots_value(test_slots)
test_returns_new_class(test_slots)
test_frozen_pickle(test_slots)
test_slots_with_default_no_init(test_slots)
test_slots_with_default_factory_no_init(test_slots)
test_descriptors = TestDescriptors()
test_set_name(test_descriptors)
test_non_descriptor(test_descriptors)
test_lookup_on_instance(test_descriptors)
test_lookup_on_class(test_descriptors)
test_string_annotations = TestStringAnnotations()
test_classvar(test_string_annotations)
test_isnt_classvar(test_string_annotations)
test_initvar(test_string_annotations)
test_isnt_initvar(test_string_annotations)
test_classvar_module_level_import(test_string_annotations)
test_text_annotations(test_string_annotations)
test_make_dataclass = TestMakeDataclass()
test_simple(test_make_dataclass)
test_no_mutate_namespace(test_make_dataclass)
test_base(test_make_dataclass)
test_base_dataclass(test_make_dataclass)
test_init_var(test_make_dataclass)
test_class_var(test_make_dataclass)
test_other_params(test_make_dataclass)
test_no_types(test_make_dataclass)
test_invalid_type_specification(test_make_dataclass)
test_duplicate_field_names(test_make_dataclass)
test_keyword_field_names(test_make_dataclass)
test_non_identifier_field_names(test_make_dataclass)
test_underscore_field_names(test_make_dataclass)
test_funny_class_names_names(test_make_dataclass)
test_replace = TestReplace()
test(test_replace)
test_frozen(test_replace)
test_invalid_field_name(test_replace)
test_invalid_object(test_replace)
test_no_init(test_replace)
test_classvar(test_replace)
test_initvar_is_specified(test_replace)
test_initvar_with_default_value(test_replace)
test_recursive_repr(test_replace)
test_recursive_repr_two_attrs(test_replace)
test_recursive_repr_indirection(test_replace)
test_recursive_repr_indirection_two(test_replace)
test_recursive_repr_misc_attrs(test_replace)
test_abstract = TestAbstract()
test_abc_implementation(test_abstract)
test_maintain_abc(test_abstract)
test_match_args = TestMatchArgs()
test_match_args(test_match_args)
test_explicit_match_args(test_match_args)
test_bpo_43764(test_match_args)
test_match_args_argument(test_match_args)
test_make_dataclasses(test_match_args)
test_keyword_args = TestKeywordArgs()
test_no_classvar_kwarg(test_keyword_args)
test_field_marked_as_kwonly(test_keyword_args)
test_match_args(test_keyword_args)
test_KW_ONLY(test_keyword_args)
test_KW_ONLY_as_string(test_keyword_args)
test_KW_ONLY_twice(test_keyword_args)
test_post_init(test_keyword_args)
test_defaults(test_keyword_args)
test_make_dataclass(test_keyword_args)
i_b_m_test_cases = IBMTestCases()
setUp(i_b_m_test_cases)
explicit_construction_test = ExplicitConstructionTest()
test_explicit_empty(explicit_construction_test)
test_explicit_from_None(explicit_construction_test)
test_explicit_from_int(explicit_construction_test)
test_explicit_from_string(explicit_construction_test)
test_from_legacy_strings(explicit_construction_test)
test_explicit_from_tuples(explicit_construction_test)
test_explicit_from_list(explicit_construction_test)
test_explicit_from_bool(explicit_construction_test)
test_explicit_from_Decimal(explicit_construction_test)
test_explicit_from_float(explicit_construction_test)
test_explicit_context_create_decimal(explicit_construction_test)
test_explicit_context_create_from_float(explicit_construction_test)
test_unicode_digits(explicit_construction_test)
implicit_construction_test = ImplicitConstructionTest()
test_implicit_from_None(implicit_construction_test)
test_implicit_from_int(implicit_construction_test)
test_implicit_from_string(implicit_construction_test)
test_implicit_from_float(implicit_construction_test)
test_implicit_from_Decimal(implicit_construction_test)
test_rop(implicit_construction_test)
format_test = FormatTest()
test_formatting(format_test)
test_n_format(format_test)
test_wide_char_separator_decimal_point(format_test)
test_decimal_from_float_argument_type(format_test)
arithmetic_operators_test = ArithmeticOperatorsTest()
test_addition(arithmetic_operators_test)
test_subtraction(arithmetic_operators_test)
test_multiplication(arithmetic_operators_test)
test_division(arithmetic_operators_test)
test_floor_division(arithmetic_operators_test)
test_powering(arithmetic_operators_test)
test_module(arithmetic_operators_test)
test_floor_div_module(arithmetic_operators_test)
test_unary_operators(arithmetic_operators_test)
test_nan_comparisons(arithmetic_operators_test)
test_copy_sign(arithmetic_operators_test)
threading_test = ThreadingTest()
test_threading(threading_test)
usability_test = UsabilityTest()
test_comparison_operators(usability_test)
test_decimal_float_comparison(usability_test)
test_decimal_complex_comparison(usability_test)
test_decimal_fraction_comparison(usability_test)
test_copy_and_deepcopy_methods(usability_test)
test_hash_method(usability_test)
test_hash_method_nan(usability_test)
test_min_and_max_methods(usability_test)
test_as_nonzero(usability_test)
test_tostring_methods(usability_test)
test_tonum_methods(usability_test)
test_nan_to_float(usability_test)
test_snan_to_float(usability_test)
test_eval_round_trip(usability_test)
test_as_tuple(usability_test)
test_as_integer_ratio(usability_test)
test_subclassing(usability_test)
test_implicit_context(usability_test)
test_none_args(usability_test)
test_conversions_from_int(usability_test)
python_a_p_itests = PythonAPItests()
test_abc(python_a_p_itests)
test_pickle(python_a_p_itests)
test_int(python_a_p_itests)
test_trunc(python_a_p_itests)
test_from_float(python_a_p_itests)
test_create_decimal_from_float(python_a_p_itests)
test_quantize(python_a_p_itests)
test_complex(python_a_p_itests)
test_named_parameters(python_a_p_itests)
test_exception_hierarchy(python_a_p_itests)
context_a_p_itests = ContextAPItests()
test_none_args(context_a_p_itests)
test_from_legacy_strings(context_a_p_itests)
test_pickle(context_a_p_itests)
test_equality_with_other_types(context_a_p_itests)
test_copy(context_a_p_itests)
test__clamp(context_a_p_itests)
test_abs(context_a_p_itests)
test_add(context_a_p_itests)
test_compare(context_a_p_itests)
test_compare_signal(context_a_p_itests)
test_compare_total(context_a_p_itests)
test_compare_total_mag(context_a_p_itests)
test_copy_abs(context_a_p_itests)
test_copy_decimal(context_a_p_itests)
test_copy_negate(context_a_p_itests)
test_copy_sign(context_a_p_itests)
test_divide(context_a_p_itests)
test_divide_int(context_a_p_itests)
test_divmod(context_a_p_itests)
test_exp(context_a_p_itests)
test_fma(context_a_p_itests)
test_is_finite(context_a_p_itests)
test_is_infinite(context_a_p_itests)
test_is_nan(context_a_p_itests)
test_is_normal(context_a_p_itests)
test_is_qnan(context_a_p_itests)
test_is_signed(context_a_p_itests)
test_is_snan(context_a_p_itests)
test_is_subnormal(context_a_p_itests)
test_is_zero(context_a_p_itests)
test_ln(context_a_p_itests)
test_log10(context_a_p_itests)
test_logb(context_a_p_itests)
test_logical_and(context_a_p_itests)
test_logical_invert(context_a_p_itests)
test_logical_or(context_a_p_itests)
test_logical_xor(context_a_p_itests)
test_max(context_a_p_itests)
test_max_mag(context_a_p_itests)
test_min(context_a_p_itests)
test_min_mag(context_a_p_itests)
test_minus(context_a_p_itests)
test_multiply(context_a_p_itests)
test_next_minus(context_a_p_itests)
test_next_plus(context_a_p_itests)
test_next_toward(context_a_p_itests)
test_normalize(context_a_p_itests)
test_number_class(context_a_p_itests)
test_plus(context_a_p_itests)
test_power(context_a_p_itests)
test_quantize(context_a_p_itests)
test_remainder(context_a_p_itests)
test_remainder_near(context_a_p_itests)
test_rotate(context_a_p_itests)
test_sqrt(context_a_p_itests)
test_same_quantum(context_a_p_itests)
test_scaleb(context_a_p_itests)
test_shift(context_a_p_itests)
test_subtract(context_a_p_itests)
test_to_eng_string(context_a_p_itests)
test_to_sci_string(context_a_p_itests)
test_to_integral_exact(context_a_p_itests)
test_to_integral_value(context_a_p_itests)
context_with_statement = ContextWithStatement()
test_localcontext(context_with_statement)
test_localcontextarg(context_with_statement)
test_nested_with_statements(context_with_statement)
test_with_statements_gc1(context_with_statement)
test_with_statements_gc2(context_with_statement)
test_with_statements_gc3(context_with_statement)
context_flags = ContextFlags()
test_flags_irrelevant(context_flags)
test_flag_comparisons(context_flags)
test_float_operation(context_flags)
test_float_comparison(context_flags)
test_float_operation_default(context_flags)
special_contexts = SpecialContexts()
test_context_templates(special_contexts)
test_default_context(special_contexts)
context_input_validation = ContextInputValidation()
test_invalid_context(context_input_validation)
context_subclassing = ContextSubclassing()
test_context_subclassing(context_subclassing)
check_attributes = CheckAttributes()
test_module_attributes(check_attributes)
test_context_attributes(check_attributes)
test_decimal_attributes(check_attributes)
coverage = Coverage()
test_adjusted(coverage)
test_canonical(coverage)
test_context_repr(coverage)
test_implicit_context(coverage)
test_divmod(coverage)
test_power(coverage)
test_quantize(coverage)
test_radix(coverage)
test_rop(coverage)
test_round(coverage)
test_create_decimal(coverage)
test_int(coverage)
test_copy(coverage)
py_functionality = PyFunctionality()
test_py_alternate_formatting(py_functionality)
py_whitebox = PyWhitebox()
test_py_exact_power(py_whitebox)
test_py_immutability_operations(py_whitebox)
test_py_decimal_id(py_whitebox)
test_py_rescale(py_whitebox)
test_py__round(py_whitebox)
c_functionality = CFunctionality()
test_c_ieee_context(c_functionality)
test_c_context(c_functionality)
test_constants(c_functionality)
c_whitebox = CWhitebox()
test_bignum(c_whitebox)
test_invalid_construction(c_whitebox)
test_c_input_restriction(c_whitebox)
test_c_context_repr(c_whitebox)
test_c_context_errors(c_whitebox)
test_rounding_strings_interned(c_whitebox)
test_c_context_errors_extra(c_whitebox)
test_c_valid_context(c_whitebox)
test_c_valid_context_extra(c_whitebox)
test_c_round(c_whitebox)
test_c_format(c_whitebox)
test_c_integral(c_whitebox)
test_c_funcs(c_whitebox)
test_va_args_exceptions(c_whitebox)
test_c_context_templates(c_whitebox)
test_c_signal_dict(c_whitebox)
test_invalid_override(c_whitebox)
test_exact_conversion(c_whitebox)
test_from_tuple(c_whitebox)
test_sizeof(c_whitebox)
test_internal_use_of_overridden_methods(c_whitebox)
test_maxcontext_exact_arith(c_whitebox)
signature_test = SignatureTest()
test_inspect_module(signature_test)
test_inspect_types(signature_test)
end