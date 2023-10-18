# cython: remove_unreachable=False
# mode: error

cdef object f(object x) nogil:
    pass

cdef void g(i32 x) nogil:
    cdef object z
    z = None

cdef void h(i32 x) nogil:  # allowed
    p()

cdef object p() nogil:
    pass

cdef void r() nogil:  # allowed
    q()  # allowed

cdef object m():
    cdef object x, y = 0, obj
    cdef int i, j, k
    global fred
    q()
    with nogil:
        r()  # allowed to call plain C functions
        q()
        i = 42   # allowed with type inference
        obj = None
        17L  # allowed
        <object>7j
        help
        xxx = `"Hello"`
        import fred
        from fred import obj
        for x in obj:
            pass
        obj[i]
        obj[i:j]
        obj[i:j:k]
        obj.fred
        (x, y)
        [x, y]
        {x: y}
        {x, y}
        obj and x
        t(obj)
        f(42)
        x + obj
        -obj
        x = y = obj
        x, y = y, x
        obj[i] = x
        obj.fred = x
        print obj  # allowed!
        del fred
        return obj
        raise obj  # allowed!
        if obj:
            pass
        while obj:
            pass
        for x <= obj <= y:
            pass
        try:
            pass
        except:
            pass
        try:
            pass
        finally:
            pass

cdef void q():
    pass

cdef class C:
    pass

cdef void t(C c) nogil:
    pass

def ticket_338():
    cdef object obj
    with nogil:
        for obj from 0 <= obj < 4:
            pass

def bare_pyvar_name(object x):
    with nogil:
        x

cdef int fstrings(i32 x, object obj) except -1 nogil:
    f""         # allowed
    f"a"        # allowed
    f"a"f"b"    # allowed
    f"{x}"
    f"{obj}"

cdef void slice_array() nogil:
    with gil:
        b = [1, 2, 3, 4]
    cdef int[4] a = b[:]

cdef i32[:] main() nogil:
    cdef i32[4] a = [1,2,3,4]
    return a


_ERRORS = u"""
4:5: Function with Python return type cannot be declared nogil
7:5: Function declared nogil has Python locals or temporaries
9:4: Assignment of Python object not allowed without gil
12:5: Discarding owned Python object not allowed without gil
14:5: Function with Python return type cannot be declared nogil
18:5: Calling gil-requiring function not allowed without gil
27:9: Calling gil-requiring function not allowed without gil
29:8: Assignment of Python object not allowed without gil
31:16: Constructing complex number not allowed without gil
33:8: Assignment of Python object not allowed without gil
33:14: Backquote expression not allowed without gil
34:15: Assignment of Python object not allowed without gil
34:15: Python import not allowed without gil
35:13: Python import not allowed without gil
35:25: Constructing Python list not allowed without gil
36:17: Iterating over Python object not allowed without gil
38:11: Discarding owned Python object not allowed without gil
38:11: Indexing Python object not allowed without gil
39:11: Discarding owned Python object not allowed without gil
39:11: Slicing Python object not allowed without gil
40:11: Constructing Python slice object not allowed without gil
40:11: Discarding owned Python object not allowed without gil
40:11: Indexing Python object not allowed without gil
40:12: Converting to Python object not allowed without gil
40:14: Converting to Python object not allowed without gil
40:16: Converting to Python object not allowed without gil
41:11: Accessing Python attribute not allowed without gil
41:11: Discarding owned Python object not allowed without gil
42:9: Constructing Python tuple not allowed without gil
42:9: Discarding owned Python object not allowed without gil
43:8: Constructing Python list not allowed without gil
43:8: Discarding owned Python object not allowed without gil
44:9: Constructing Python dict not allowed without gil
44:9: Discarding owned Python object not allowed without gil
45:9: Constructing Python set not allowed without gil
45:9: Discarding owned Python object not allowed without gil
46:12: Discarding owned Python object not allowed without gil
46:12: Truth-testing Python object not allowed without gil
47:10: Python type test not allowed without gil
48:9: Discarding owned Python object not allowed without gil
49:10: Discarding owned Python object not allowed without gil
49:10: Operation not allowed without gil
50:8: Discarding owned Python object not allowed without gil
50:8: Operation not allowed without gil
51:8: Assignment of Python object not allowed without gil
51:12: Assignment of Python object not allowed without gil
52:8: Assignment of Python object not allowed without gil
52:11: Assignment of Python object not allowed without gil
52:15: Creating temporary Python reference not allowed without gil
52:18: Creating temporary Python reference not allowed without gil
53:11: Assignment of Python object not allowed without gil
53:11: Indexing Python object not allowed without gil
54:11: Accessing Python attribute not allowed without gil
54:11: Assignment of Python object not allowed without gil

56:8: Deleting Python object not allowed without gil
57:8: Returning Python object not allowed without gil

59:11: Truth-testing Python object not allowed without gil
61:14: Truth-testing Python object not allowed without gil
63:8: For-loop using object bounds or target not allowed without gil
63:12: Coercion from Python not allowed without the GIL
63:24: Coercion from Python not allowed without the GIL
65:8: Try-except statement not allowed without gil
86:8: For-loop using object bounds or target not allowed without gil

97:4: Discarding owned Python object not allowed without gil
97:6: String formatting not allowed without gil
98:4: Discarding owned Python object not allowed without gil
98:6: String formatting not allowed without gil

103:21: Coercion from Python not allowed without the GIL
103:21: Slicing Python object not allowed without gil
107:11: Operation not allowed without gil
"""
