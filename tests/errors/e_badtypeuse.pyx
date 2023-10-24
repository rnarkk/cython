# mode: error

struct Grail

cdef extern object xobj # Python object cannot be extern
cdef object aobj[42]    # array element cannot be Python object
cdef object *pobj       # pointer base type cannot be Python object

cdef i32 spam[] # incomplete variable type
cdef Grail g     # incomplete variable type
cdef void nada   # incomplete variable type

cdef i32 a_spam[17][]  # incomplete element type
cdef Grail a_g[42]     # incomplete element type
cdef void a_nada[88]   # incomplete element type

struct Eggs:
    i32 spam[]

fn f(Grail g,   # incomplete argument type
     void v,         # incomplete argument type
     i32 a[]):
    pass

cdef NoSuchType* ptr
ptr = None             # This should not produce another error

_ERRORS = u"""
5:19: Python object cannot be declared extern
6:16: Array element cannot be a Python object
7:12: Pointer base type cannot be a Python object
9:13: Variable type 'int []' is incomplete
10:11: Variable type 'Grail' is incomplete
11:10: Variable type 'void' is incomplete
13:15: Array element type 'int []' is incomplete
14:14: Array element type 'Grail' is incomplete
15:16: Array element type 'void' is incomplete
18:12: Variable type 'int []' is incomplete
#19:1: Function argument cannot be void
21:5: Use spam() rather than spam(void) to declare a function with no arguments.
20:5: Argument type 'Grail' is incomplete
21:5: Invalid use of 'void'
25:5: 'NoSuchType' is not a type identifier
"""
