# mode: error

struct Spam

extern int spam(void)           # function argument cannot be void
extern int grail(int i, void v) # function argument cannot be void
fn int tomato(Spam s):             # incomplete type
	pass

_ERRORS = """
5:21: Use spam() rather than spam(void) to declare a function with no arguments.
6:29: Use spam() rather than spam(void) to declare a function with no arguments.
7:16: Argument type 'Spam' is incomplete
"""
