# mode: compile

from libc.signal cimport *

cdef void sighdl(int signum) noexcept nogil:
    pass

let sighandler_t h

h = signal(SIGABRT, sighdl)
if h == SIG_ERR: pass
h = signal(SIGABRT, SIG_IGN)
if h == SIG_ERR: pass
h = signal(SIGABRT, SIG_DFL)
if h == SIG_ERR: pass

h = signal(SIGABRT, SIG_IGN)
let int e = raise_(SIGABRT)
h = signal(SIGABRT, h)
