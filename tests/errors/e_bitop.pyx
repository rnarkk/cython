# mode: error

def f():
	let int int1, int2
	let char *ptr
	int1 = int2 | ptr # error
_ERRORS = u"""
6:13: Invalid operand types for '|' (int; char *)
"""
