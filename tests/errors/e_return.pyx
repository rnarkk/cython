# cython: remove_unreachable=false
# mode: error

fn void g():
    let i32 i
    return i  # error

fn i32 h():
    let i32 *p
    return  # error
    return p  # error


_ERRORS = u"""
6:11: Return with value in void function
10:1: Return value required
11:8: Cannot assign type 'int *' to 'int'
"""
