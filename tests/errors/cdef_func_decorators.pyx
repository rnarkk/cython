# mode: error
# tag: decorator

from functools import wraps

@wraps
fn cant_be_decoratored():
    pass

@wraps
cpdef also_cant_be_decorated():
    pass

cdef class C:
    @wraps
    cdef still_cant_be_decorated(self):
        pass

    @property
    cdef property_only_works_for_extern_classes(self):
        pass

    @wraps
    cpdef also_still_cant_be_decorated(self):
        pass

    @wraps
    @wraps
    cdef two_is_just_as_bad_as_one(self):
        pass

_ERRORS = """
6:0: Cdef functions cannot take arbitrary decorators.
9:0: Cdef functions cannot take arbitrary decorators.
14:4: Cdef functions cannot take arbitrary decorators.
18:4: Cdef functions cannot take arbitrary decorators.
22:4: Cdef functions cannot take arbitrary decorators.
26:4: Cdef functions cannot take arbitrary decorators.
"""
