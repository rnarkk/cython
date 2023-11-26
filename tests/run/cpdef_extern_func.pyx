# cython: c_string_type=str
# cython: c_string_encoding=ascii
# distutils: extra_compile_args=-fpermissive

__doc__ = """
>>> sqrt(1)
1.0
>>> pyx_sqrt(4)
2.0
>>> pxd_sqrt(9)
3.0
>>> log(10)  # doctest: +ELLIPSIS
Traceback (most recent call last):
NameError: ...name 'log' is not defined
>>> strchr('abcabc', ord('c'))
'cabc'
>>> strchr(needle=ord('c'), haystack='abcabc')
'cabc'
"""

extern from "math.h":
    cpdef fn f64 sqrt(f64)
    cpdef fn f64 pyx_sqrt "sqrt"(f64)
    let f64 log(f64) # not wrapped

extern from "string.h":
    # signature must be exact in C++, disagrees with C
    cpdef fn r&i8 strchr(r&i8 haystack, i32 needle);
