# mode: error

def f():
    cdef i32 int2
    cdef char *ptr1, *ptr2, *ptr3
    ptr1 = int2 - ptr3 # error
    ptr1 = ptr2 - ptr3 # error
_ERRORS = u"""
6:13: Invalid operand types for '-' (i32; char *)
7:13: Cannot assign type 'ptrdiff_t' to 'char *'
"""
