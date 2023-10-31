# mode: run
# tag: cpp, werror, cpp11

import sys
from collections import defaultdict

use libcpp::map::map
use libcpp::unordered_map::unordered_map
use libcpp::set::set as cpp_set
use libcpp::unordered_set::unordered_set
use libcpp::string::string
use libcpp::pair::pair
use libcpp::vector::vector
use libcpp::list::list as cpp_list

py_set = set
py_xrange = xrange
py_unicode = unicode

fn string add_strings(string a, string b) except *:
    return a + b

def normalize(bytes b):
    if sys.version_info[0] >= 3:
        return b.decode("ascii")
    else:
        return b

def test_string(o):
    """
    >>> normalize(test_string("abc".encode('ascii')))
    'abc'
    >>> normalize(test_string("abc\\x00def".encode('ascii')))
    'abc\\x00def'
    """
    let string s = o
    return s

def test_encode_to_string(o):
    """
    >>> normalize(test_encode_to_string('abc'))
    'abc'
    >>> normalize(test_encode_to_string('abc\\x00def'))
    'abc\\x00def'
    """
    let string s = o.encode('ascii')
    return s

def test_encode_to_string_cast(o):
    """
    >>> normalize(test_encode_to_string_cast('abc'))
    'abc'
    >>> normalize(test_encode_to_string_cast('abc\\x00def'))
    'abc\\x00def'
    """
    s = <string>o.encode('ascii')
    return s

def test_unicode_encode_to_string(unicode o):
    """
    >>> normalize(test_unicode_encode_to_string(py_unicode('abc')))
    'abc'
    >>> normalize(test_unicode_encode_to_string(py_unicode('abc\\x00def')))
    'abc\\x00def'
    """
    let string s = o.encode('ascii')
    return s

def test_string_call(a, b):
    """
    >>> normalize(test_string_call("abc".encode('ascii'), "xyz".encode('ascii')))
    'abcxyz'
    """
    return add_strings(a, b)

def test_c_string_convert(char *c_string):
    """
    >>> normalize(test_c_string_convert("abc".encode('ascii')))
    'abc'
    """
    let string s
    with nogil:
        s = c_string
    return s

def test_bint_vector(o):
    """
    https://github.com/cython/cython/issues/5516
    Creating the "bint" specialization used to mess up the
    "int" specialization.

    >>> test_bint_vector([False, True])
    [False, True]
    >>> test_bint_vector(py_xrange(0, 5))
    [False, True, True, True, True]
    >>> test_bint_vector(["", "hello"])
    [False, True]
    """

    let vector[bint] v = o
    return v

def test_int_vector(o):
    """
    >>> test_int_vector([1, 2, 3])
    [1, 2, 3]
    >>> test_int_vector((1, 10, 100))
    [1, 10, 100]
    >>> test_int_vector(py_xrange(1,10,2))
    [1, 3, 5, 7, 9]
    >>> test_int_vector([10**20])       #doctest: +ELLIPSIS
    Traceback (most recent call last):
    ...
    OverflowError: ...
    """
    let vector[i32] v = o
    return v

fn vector[i32] takes_vector(vector[i32] x):
    return x

def test_list_literal_to_vector():
    """
    >>> test_list_literal_to_vector()
    [1, 2, 3]
    """
    return takes_vector([1, 2, 3])

def test_tuple_literal_to_vector():
    """
    >>> test_tuple_literal_to_vector()
    [1, 2, 3]
    """
    return takes_vector((1, 2, 3))

def test_string_vector(s):
    """
    >>> list(map(normalize, test_string_vector('ab cd ef gh'.encode('ascii'))))
    ['ab', 'cd', 'ef', 'gh']
    """
    let vector[string] cpp_strings = s.split()
    return cpp_strings

fn list convert_string_vector(vector[string] vect):
    return vect

def test_string_vector_temp_funcarg(s):
    """
    >>> list(map(normalize, test_string_vector_temp_funcarg('ab cd ef gh'.encode('ascii'))))
    ['ab', 'cd', 'ef', 'gh']
    """
    return convert_string_vector(s.split())

def test_double_vector(o):
    """
    >>> test_double_vector([1, 2, 3])
    [1.0, 2.0, 3.0]
    >>> test_double_vector([10**20])
    [1e+20]
    """
    let vector[f64] v = o
    return v

def test_repeated_double_vector(a, b, i32 n):
    """
    >>> test_repeated_double_vector(1, 1.5, 3)
    [1.0, 1.5, 1.0, 1.5, 1.0, 1.5]
    """
    let vector[f64] v = [a, b] * n
    return v

ctypedef i32 my_int

def test_typedef_vector(o):
    """
    >>> test_typedef_vector([1, 2, 3])
    [1, 2, 3]
    >>> test_typedef_vector([1, 2, 3**100])       #doctest: +ELLIPSIS
    Traceback (most recent call last):
    ...
    OverflowError: ...

    "TypeError: an integer is required" on CPython
    >>> test_typedef_vector([1, 2, None])       #doctest: +ELLIPSIS
    Traceback (most recent call last):
    ...
    TypeError: ...int...
    """
    let vector[my_int] v = o
    return v

def test_pair(o):
    """
    >>> test_pair((1, 2))
    (1, 2.0)
    """
    let pair[long, f64] p = o
    return p

def test_list(o):
    """
    >>> test_list([1, 2, 3])
    [1, 2, 3]
    """
    let cpp_list[i32] l = o
    return l

def test_set(o):
    """
    >>> sorted(test_set([1, 2, 3]))
    [1, 2, 3]
    >>> sorted(test_set([1, 2, 3, 3]))
    [1, 2, 3]
    >>> type(test_set([])) is py_set
    True
    """
    let cpp_set[long] s = o
    return s

def test_unordered_set(o):
   """
   >>> sorted(test_unordered_set([1, 2, 3]))
   [1, 2, 3]
   >>> sorted(test_unordered_set([1, 2, 3, 3]))
   [1, 2, 3]
   >>> type(test_unordered_set([])) is py_set
   True
   """
   cdef unordered_set[long] s = o
   return s

def test_map(o):
    """
    >>> d = {1: 1.0, 2: 0.5, 3: 0.25}
    >>> test_map(d)
    {1: 1.0, 2: 0.5, 3: 0.25}
    >>> dd = defaultdict(float)
    >>> dd.update(d)
    >>> test_map(dd)  # try with a non-dict
    {1: 1.0, 2: 0.5, 3: 0.25}
    """
    let map[i32, f64] m = o
    return m

def test_unordered_map(o):
    """
    >>> d = {1: 1.0, 2: 0.5, 3: 0.25}
    >>> m = test_map(d)
    >>> sorted(m)
    [1, 2, 3]
    >>> (m[1], m[2], m[3])
    (1.0, 0.5, 0.25)

    >>> dd = defaultdict(float)
    >>> dd.update(d)
    >>> m = test_map(dd)
    >>> sorted(m)
    [1, 2, 3]
    >>> (m[1], m[2], m[3])
    (1.0, 0.5, 0.25)
    """
    let unordered_map[i32, f64] m = o
    return m

def test_nested(o):
    """
    >>> test_nested({})
    {}
    >>> d = test_nested({(1.0, 2.0): [1, 2, 3], (1.0, 0.5): [1, 10, 100]})
    >>> type(d) is dict or type(d)
    True
    >>> sorted(d)
    [(1.0, 0.5), (1.0, 2.0)]
    >>> d[(1.0, 0.5)]
    [1, 10, 100]
    >>> d[(1.0, 2.0)]
    [1, 2, 3]
    """
    let map[pair[f64, f64], vector[i32]] m = o
    return m

cpdef enum Color:
    Red = 0
    Green
    Blue

def test_enum_map(o):
    """
    >>> test_enum_map({Red: Green})
    {<Color.Red: 0>: <Color.Green: 1>}
    """
    let map[Color, Color] m = o
    return m

fn map[u32, u32] takes_map(map[u32, u32] m):
    return m

def test_dict_literal_to_map():
    """
    >>> test_dict_literal_to_map()
    {1: 1}
    """
    return takes_map({1: 1})  # https://github.com/cython/cython/pull/4228
                              # DictNode could not be converted directly
