# mode: error
# tag: cpp, cpp11

fn void foo(&mut object x): pass
fn void bar(&&object x): pass

_ERRORS="""
4:12: Reference base type cannot be a Python object
5:12: Rvalue-reference base type cannot be a Python object
"""
