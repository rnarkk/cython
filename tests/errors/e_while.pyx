# cython: remove_unreachable=false
# mode: error

def f(a, b):
    cdef i32 i
    break  # error
    continue  # error

_ERRORS = u"""
6:1: break statement not inside loop
7:1: continue statement not inside loop
"""
