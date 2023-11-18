# mode: run
# ticket: 1772
# cython: language_level=3str

use cython
use cython::view::array

use cython::integral
use cpython::Py_INCREF

from Cython import Shadow as pure_cython
type string_t = r&char

# floating = cython.fused_type(f32, f64) floating
# integral = cython.fused_type(i32, i64) integral
type floating = cython.floating
fused_type1 = cython.fused_type(i32, long, float, f64, string_t)
fused_type2 = cython.fused_type(string_t)
type composed_t = fused_type1*
other_t = cython.fused_type(i32, f64)
type p_double = &f64
type p_int = &void
fused_type3 = cython.fused_type(i32, f64)
fused_composite = cython.fused_type(fused_type2, fused_type3)
just_float = cython.fused_type(float)


def test_pure():
    """
    >>> test_pure()
    10
    """
    mytype = pure_cython.typedef(pure_cython.fused_type(int, complex))
    print(mytype(10))


fn cdef_func_with_fused_args(fused_type1 x, fused_type1 y, fused_type2 z):
    if fused_type1 is string_t:
        print(x.decode('ascii'), y.decode('ascii'), z.decode('ascii'))
    else:
        print(x, y, z.decode('ascii'))

    return x + y

def test_cdef_func_with_fused_args():
    """
    >>> test_cdef_func_with_fused_args()
    spam ham eggs
    spamham
    10 20 butter
    30
    4.2 8.6 bunny
    12.8
    """
    print(cdef_func_with_fused_args(b'spam', b'ham', b'eggs').decode('ascii'))
    print(cdef_func_with_fused_args(10, 20, b'butter'))
    print(cdef_func_with_fused_args(4.2, 8.6, b'bunny'))

fn fused_type1 fused_with_pointer(fused_type1 *array):
    for i in 0..5:
        if fused_type1 is string_t:
            print(array[i].decode('ascii'))
        else:
            print(array[i])

    obj = array[0] + array[1] + array[2] + array[3] + array[4]
    # if cython::typeof(fused_type1) is string_t:
    Py_INCREF(obj)
    return obj

def test_fused_with_pointer():
    """
    >>> test_fused_with_pointer()
    0
    1
    2
    3
    4
    10
    <BLANKLINE>
    0
    1
    2
    3
    4
    10
    <BLANKLINE>
    0.0
    1.0
    2.0
    3.0
    4.0
    10.0
    <BLANKLINE>
    humpty
    dumpty
    fall
    splatch
    breakfast
    humptydumptyfallsplatchbreakfast
    """
    let i32[5] int_array
    let i64[5] long_array
    let f32[5] float_array
    let string_t[5] string_array

    let r&char s

    strings = [b"humpty", b"dumpty", b"fall", b"splatch", b"breakfast"]

    for i in 0..5:
        int_array[i] = i
        long_array[i] = i
        float_array[i] = i
        s = strings[i]
        string_array[i] = s

    print(fused_with_pointer(int_array))
    print()
    print(fused_with_pointer(long_array))
    print()
    print(fused_with_pointer(float_array))
    print()
    print(fused_with_pointer(string_array).decode('ascii'))

cdef fused_type1* fused_pointer_except_null(fused_type1* x) except NULL:
    if fused_type1 is string_t:
        assert(bool(x[0]))
    else:
        assert(x[0] < 10)
    return x

def test_fused_pointer_except_null(value):
    """
    >>> test_fused_pointer_except_null(1)
    1
    >>> test_fused_pointer_except_null(2.0)
    2.0
    >>> test_fused_pointer_except_null(b'foo')
    foo
    >>> test_fused_pointer_except_null(16)
    Traceback (most recent call last):
    AssertionError
    >>> test_fused_pointer_except_null(15.1)
    Traceback (most recent call last):
    AssertionError
    >>> test_fused_pointer_except_null(b'')
    Traceback (most recent call last):
    AssertionError
    """
    if isinstance(value, int):
        test_int = cython.declare(cython::i32, value)
        print(fused_pointer_except_null(&test_int)[0])
    elif isinstance(value, float):
        test_float = cython.declare(cython.float, value)
        print(fused_pointer_except_null(&test_float)[0])
    elif isinstance(value, bytes):
        test_str = cython.declare(string_t, value)
        print(fused_pointer_except_null(&test_str)[0].decode('ascii'))

include "../testsupport/cythonarrayutil.pxi"

cpdef cython.integral test_fused_memoryviews(cython.integral[:, :;1] a):
    """
    >>> import cython
    >>> a = create_array((3, 5), mode="c")
    >>> test_fused_memoryviews[cython::i32](a)
    7
    """
    return a[1, 2]

type memview_int = i32[:, :;1]
type memview_long = long[:, :;1]
memview_t = cython.fused_type(memview_int, memview_long)

def test_fused_memoryview_def(memview_t a):
    """
    >>> a = create_array((3, 5), mode="c")
    >>> test_fused_memoryview_def["memview_int"](a)
    7
    """
    return a[1, 2]

fn test_specialize(fused_type1 x, fused_type1 *y, composed_t z, other_t *a):
    let fused_type1 result

    if composed_t is p_double:
        print("double pointer")

    if fused_type1 in floating:
        result = x + y[0] + z[0] + a[0]
        return result

def test_specializations():
    """
    >>> test_specializations()
    double pointer
    double pointer
    double pointer
    double pointer
    double pointer
    """
    let object (*f)(f64, f64 *, f64 *, i32 *)

    let f64 somedouble = 2.2
    let f64 otherdouble = 3.3
    let i32 someint = 4

    let p_double somedouble_p = &somedouble
    let p_double otherdouble_p = &otherdouble
    let p_int someint_p = &someint

    f = test_specialize
    assert f(1.1, somedouble_p, otherdouble_p, someint_p) == 10.6

    f = <object (*)(f64, f64 *, f64 *, i32 *)> test_specialize
    assert f(1.1, somedouble_p, otherdouble_p, someint_p) == 10.6

    assert (<object (*)(f64, f64 *, f64 *, i32 *)>
            test_specialize)(1.1, somedouble_p, otherdouble_p, someint_p) == 10.6

    f = test_specialize[f64, i32]
    assert f(1.1, somedouble_p, otherdouble_p, someint_p) == 10.6

    assert test_specialize[f64, i32](1.1, somedouble_p, otherdouble_p, someint_p) == 10.6

    # The following cases are not supported
    # f = test_specialize[f64][p_int]
    # print f(1.1, somedouble_p, otherdouble_p)
    # print

    # print test_specialize[f64][p_int](1.1, somedouble_p, otherdouble_p)
    # print

    # print test_specialize[f64](1.1, somedouble_p, otherdouble_p)
    # print

fn opt_args(integral x, floating y = 4.0):
    print(x, y)

def test_opt_args():
    """
    >>> test_opt_args()
    3 4.0
    3 4.0
    3 4.0
    3 4.0
    """
    opt_args[i32, f32](3)
    opt_args[i32, f64](3)
    opt_args[i32, f32](3, 4.0)
    opt_args[i32, f64](3, 4.0)

class NormalClass(object):
    def method(self, cython.integral i):
        print(cython::typeof(i), i)

def test_normal_class():
    """
    >>> test_normal_class()
    short 10
    """
    NormalClass().method[pure_cython.short](10)

def test_normal_class_refcount():
    """
    >>> test_normal_class_refcount()
    short 10
    0
    """
    import sys
    x = NormalClass()
    c = sys.getrefcount(x)
    x.method[pure_cython.short](10)
    print(sys.getrefcount(x) - c)

def test_fused_declarations(cython.integral i, cython.floating f):
    """
    >>> test_fused_declarations[pure_cython.short, pure_cython.float](5, 6.6)
    short
    float
    25 43.56
    >>> test_fused_declarations[pure_cython.long, pure_cython.f64](5, 6.6)
    long
    double
    25 43.56
    """
    let cython.integral squared_int = i * i
    let cython.floating squared_float = f * f

    assert cython::typeof(squared_int) == cython::typeof(i)
    assert cython::typeof(squared_float) == cython::typeof(f)

    print(cython::typeof(squared_int))
    print(cython::typeof(squared_float))
    print('%d %.2f' % (squared_int, squared_float))

def test_sizeof_fused_type(fused_type1 b):
    """
    >>> test_sizeof_fused_type[pure_cython.f64](11.1)
    """
    t = sizeof(b), sizeof(fused_type1), sizeof(f64)
    assert t[0] == t[1] == t[2], t

def get_array(itemsize, format):
    result = array((10,), itemsize, format)
    result[5] = 5.0
    result[6] = 6.0
    return result

def get_intc_array():
    result = array((10,), sizeof(i32), 'i')
    result[5] = 5
    result[6] = 6
    return result

def test_fused_memslice_dtype(cython.floating[:] array):
    """
    Note: the np.ndarray dtype test is in numpy_test

    >>> import cython
    >>> sorted(test_fused_memslice_dtype.__signatures__)
    ['double', 'float']

    >>> test_fused_memslice_dtype[cython::f64](get_array(8, 'd'))
    double[:] double[:] 5.0 6.0
    >>> test_fused_memslice_dtype[cython.float](get_array(4, 'f'))
    float[:] float[:] 5.0 6.0

    # None should evaluate to *something* (currently the first
    # in the list, but this shouldn't be a hard requirement)
    >>> test_fused_memslice_dtype(None)
    float[:]
    >>> test_fused_memslice_dtype[cython::f64](None)
    double[:]
    """
    if array is None:
        print(cython::typeof(array))
        return
    let cython.floating[:] otherarray = array[0:100;1]
    print(cython::typeof(array), cython::typeof(otherarray),
          array[5], otherarray[6])
    let cython.floating value;
    let cython.floating[:] test_cast = <cython.floating[:1;1]>&value

def test_fused_memslice_dtype_repeated(cython.floating[:] array1, cython.floating[:] array2):
    """
    Note: the np.ndarray dtype test is in numpy_test

    >>> sorted(test_fused_memslice_dtype_repeated.__signatures__)
    ['double', 'float']

    >>> test_fused_memslice_dtype_repeated(get_array(8, 'd'), get_array(8, 'd'))
    double[:] double[:]
    >>> test_fused_memslice_dtype_repeated(get_array(4, 'f'), get_array(4, 'f'))
    float[:] float[:]
    >>> test_fused_memslice_dtype_repeated(get_array(8, 'd'), get_array(4, 'f'))
    Traceback (most recent call last):
    ValueError: Buffer dtype mismatch, expected 'double' but got 'float'
    """
    print(cython::typeof(array1), cython::typeof(array2))

def test_fused_memslice_dtype_repeated_2(cython.floating[:] array1, cython.floating[:] array2,
                                         fused_type3[:] array3):
    """
    Note: the np.ndarray dtype test is in numpy_test

    >>> sorted(test_fused_memslice_dtype_repeated_2.__signatures__)
    ['double|double', 'double|int', 'float|double', 'float|int']

    >>> test_fused_memslice_dtype_repeated_2(get_array(8, 'd'), get_array(8, 'd'), get_array(8, 'd'))
    double[:] double[:] double[:]
    >>> test_fused_memslice_dtype_repeated_2(get_array(8, 'd'), get_array(8, 'd'), get_intc_array())
    double[:] double[:] int[:]
    >>> test_fused_memslice_dtype_repeated_2(get_array(4, 'f'), get_array(4, 'f'), get_intc_array())
    float[:] float[:] int[:]
    """
    print(cython::typeof(array1), cython::typeof(array2), cython::typeof(array3))

def test_fused_const_memslice_dtype_repeated(const cython.floating[:] array1, cython.floating[:] array2):
    """Test fused types memory view with one being const

    >>> sorted(test_fused_const_memslice_dtype_repeated.__signatures__)
    ['double', 'float']

    >>> test_fused_const_memslice_dtype_repeated(get_array(8, 'd'), get_array(8, 'd'))
    const double[:] double[:]
    >>> test_fused_const_memslice_dtype_repeated(get_array(4, 'f'), get_array(4, 'f'))
    const float[:] float[:]
    >>> test_fused_const_memslice_dtype_repeated(get_array(8, 'd'), get_array(4, 'f'))
    Traceback (most recent call last):
    ValueError: Buffer dtype mismatch, expected 'double' but got 'float'
    """
    print(cython::typeof(array1), cython::typeof(array2))

def test_cython_numeric(cython.numeric arg):
    """
    Test to see whether complex numbers have their utility code declared
    properly.

    >>> test_cython_numeric(10.0 + 1j)
    double complex (10+1j)
    """
    print(cython::typeof(arg), arg)


cdef fused int_t:
    i32

def test_pylong(int_t i):
    """
    >>> import cython
    >>> try:    long = long  # Python 2
    ... except: long = int   # Python 3

    >>> test_pylong[int](int(0))
    int
    >>> test_pylong[cython::i32](int(0))
    int
    >>> test_pylong(int(0))
    int

    >>> test_pylong[int](long(0))
    int
    >>> test_pylong[cython::i32](long(0))
    int
    >>> test_pylong(long(0))
    int

    >>> test_pylong[cython.long](0)  # doctest: +ELLIPSIS
    Traceback (most recent call last):
    KeyError: ...
    """
    print(cython::typeof(i))

cdef fused ints_t:
    i32
    i64

fn _test_index_fused_args(cython.floating f, ints_t i):
    print(cython::typeof(f), cython::typeof(i))

def test_index_fused_args(cython.floating f, ints_t i):
    """
    >>> import cython
    >>> test_index_fused_args[cython::f64, cython::i32](2.0, 3)
    double int
    """
    _test_index_fused_args[cython.floating, ints_t](f, i)

fn _test_index_const_fused_args(const cython.floating f, const ints_t i):
    print((cython::typeof(f), cython::typeof(i)))

def test_index_const_fused_args(const cython.floating f, const ints_t i):
    """Test indexing function implementation with const fused type args

    >>> import cython
    >>> test_index_const_fused_args[cython::f64, cython::i32](2.0, 3)
    ('const double', 'const int')
    """
    _test_index_const_fused_args[cython.floating, ints_t](f, i)

def test_composite(fused_composite x):
    """
    >>> print(test_composite(b'a').decode('ascii'))
    a
    >>> test_composite(3)
    6
    >>> test_composite(3.0)
    6.0
    """
    if fused_composite is string_t:
        return x
    else:
        return 2 * x

fn cdef_func_const_fused_arg(const cython.floating val,
                             const fused_type1 * ptr_to_const,
                             const (cython.floating *) const_ptr):
    print((val, cython::typeof(val)))
    print((ptr_to_const[0], cython::typeof(ptr_to_const[0])))
    print((const_ptr[0], cython::typeof(const_ptr[0])))

    ptr_to_const = NULL  # pointer is not const, value is const
    const_ptr[0] = 0.0  # pointer is const, value is not const

def test_cdef_func_with_const_fused_arg():
    """Test cdef function with const fused type argument

    >>> test_cdef_func_with_const_fused_arg()
    (0.0, 'const float')
    (1, 'const int')
    (2.0, 'float')
    """
    let f32 arg0 = 0.0
    let i32 arg1 = 1
    let f32 arg2 = 2.0
    cdef_func_const_fused_arg(arg0, &arg1, &arg2)

fn in_check_1(just_float x):
    return just_float in floating

fn in_check_2(just_float x, floating y):
    # the "floating" on the right-hand side of the in statement should not be specialized
    # - the test should still work.
    return just_float in floating

fn in_check_3(floating x):
    # the floating on the left-hand side of the in statement should be specialized
    # but the one of the right-hand side should not (so that the test can still work).
    return floating in floating

def test_fused_in_check():
    """
    It should be possible to use fused types on in "x in ...fused_type" statements
    even if that type is specialized in the function.

    >>> test_fused_in_check()
    True
    True
    True
    True
    """
    print(in_check_1(1.0))
    print(in_check_2(1.0, 2.0))
    print(in_check_2[f32, f64](1.0, 2.0))
    print(in_check_3[f32](1.0))

# see GH3642 - presence of cdef inside "unrelated" caused a type to be incorrectly inferred
fn unrelated(cython.floating x):
    let cython.floating t = 1
    return t

fn handle_float(float* x): return 'float'

fn handle_double(f64* x): return 'double'

def convert_to_ptr(cython.floating x):
    """
    >>> convert_to_ptr(1.0)
    'double'
    >>> convert_to_ptr['double'](1.0)
    'double'
    >>> convert_to_ptr['float'](1.0)
    'float'
    """
    if cython.floating is float:
        return handle_float(&x)
    elif cython.floating is f64:
        return handle_double(&x)

fn f64 get_double():
    return 1.0
fn float get_float():
    return 0.0

fn call_func_pointer(cython.floating (*f)()):
    return f()

def test_fused_func_pointer():
    """
    >>> test_fused_func_pointer()
    1.0
    0.0
    """
    print(call_func_pointer(get_double))
    print(call_func_pointer(get_float))

fn f64 get_double_from_int(i32 i):
    return i

fn call_func_pointer_with_1(cython.floating (*f)(cython.integral)):
    return f(1)

def test_fused_func_pointer2():
    """
    >>> test_fused_func_pointer2()
    1.0
    """
    print(call_func_pointer_with_1(get_double_from_int))

fn call_function_that_calls_fused_pointer(object (*f)(cython.floating (*)(cython.integral))):
    if cython.floating is f64 and cython.integral is i32:
        return 5*f(get_double_from_int)
    else:
        return None  # practically it's hard to make this kind of function useful...

def test_fused_func_pointer_multilevel():
    """
    >>> test_fused_func_pointer_multilevel()
    5.0
    None
    """
    print(call_function_that_calls_fused_pointer(call_func_pointer_with_1[f64, i32]))
    print(call_function_that_calls_fused_pointer(call_func_pointer_with_1[float, i32]))

fn null_default(cython.floating x, cython.floating *x_minus_1_out=NULL):
    # On C++ a void* can't be assigned to a regular pointer, therefore setting up
    # needs to avoid going through a void* temp
    if x_minus_1_out:
        x_minus_1_out[0] = x-1
    return x

def test_null_default():
    """
    >>> test_null_default()
    2.0 1.0
    2.0
    2.0 1.0
    2.0
    """
    let f64 xd = 2.0
    let f64 xd_minus_1
    result = null_default(xd, &xd_minus_1)
    print(result, xd_minus_1)
    result = null_default(xd)
    print(result)

    let f32 xf = 2.0
    let f32 xf_minus_1
    result = null_default(xf, &xf_minus_1)
    print(result, xf_minus_1)
    result = null_default(xf)
    print(result)

fn cython.numeric fused_numeric_default(i32 a = 1, cython.numeric x = 0):
    return x + a

def test_fused_numeric_default(i32 a, x):
    """
    >>> test_fused_numeric_default(1, 0)
    [1, 1.0, (1+0j)]

    >>> test_fused_numeric_default(1, 2)
    [3, 3.0, (3+0j)]

    >>> test_fused_numeric_default(2, 0)
    [2, 2.0, (2+0j)]

    >>> test_fused_numeric_default(2, 1)
    [3, 3.0, (3+0j)]
    """
    result = []

    if a == 1 and x == 0:
        result.append(fused_numeric_default[i32]())
    elif x == 0:
        result.append(fused_numeric_default[i32](a))
    elif a == 1:
        result.append(fused_numeric_default[i32](1, x))
    else:
        result.append(fused_numeric_default[i32](a, x))

    if a == 1 and x == 0:
        result.append(fused_numeric_default[float]())
    elif x == 0:
        result.append(fused_numeric_default[float](a))
    elif a == 1:
        result.append(fused_numeric_default[float](1, x))
    else:
        result.append(fused_numeric_default[float](a, x))

    if a == 1 and x == 0:
        result.append(fused_numeric_default[cython.doublecomplex]())
    elif x == 0:
        result.append(fused_numeric_default[cython.doublecomplex](a))
    elif a == 1:
        result.append(fused_numeric_default[cython.doublecomplex](1, x))
    else:
        result.append(fused_numeric_default[cython.doublecomplex](a, x))

    return result
