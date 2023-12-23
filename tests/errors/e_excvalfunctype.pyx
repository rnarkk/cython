# mode: error

ctypedef i32 (*spamfunc)(i32, r&mut i8) except 42
ctypedef i32 (*grailfunc)(i32, r&mut i8) noexcept

cdef grailfunc grail
cdef spamfunc spam

grail = spam # type mismatch
spam = grail # type mismatch


_ERRORS = u"""
9:8: Cannot assign type 'spamfunc' (alias of 'int (*)(int, char *) except 42') to 'grailfunc' (alias of 'int (*)(int, char *) noexcept'). Exception values are incompatible. Suggest adding 'noexcept' to type 'int (int, char *) except 42'.
10:7: Cannot assign type 'grailfunc' (alias of 'int (*)(int, char *) noexcept') to 'spamfunc' (alias of 'int (*)(int, char *) except 42'). Exception values are incompatible.
"""
