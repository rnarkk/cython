extern from "ctypedefextern.h":

    ctypedef int some_int
    ctypedef some_int *some_ptr

cdef void spam():
    let some_int i
    let some_ptr p
    p[0] = i
