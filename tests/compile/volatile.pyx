# mode: compile

cdef volatile i32 x = 1

cdef const volatile char* greeting1 = "hello world"
cdef volatile const char* greeting2 = "goodbye"


cdef extern from "stdlib.h":
    volatile void* malloc(size_t)

cdef volatile i64* test(volatile size_t s):
    cdef volatile i64* arr = <i64*><volatile long*>malloc(s)
    return arr


test(64)
