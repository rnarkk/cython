# ticket: t354

cdef class Test:
    """
    >>> t = Test(true)
    >>> t.some_ro_bool
    True
    >>> t.some_public_bool
    True
    """
    cdef pub bint some_public_bool
    cdef readonly bint some_ro_bool

    def __init__(self, bint boolval):
        self.some_ro_bool = boolval
        self.some_public_bool = boolval
