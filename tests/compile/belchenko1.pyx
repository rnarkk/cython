# mode: compile

extern from *:
    ctypedef int intptr_t

fn i32 _is_aligned(void *ptr):
    return ((<intptr_t>ptr) & ((sizeof(int))-1)) == 0

_is_aligned(NULL)
