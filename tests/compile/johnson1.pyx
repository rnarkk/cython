# mode: compile

enum foo:
    FOO

cdef void func():
    cdef foo x
    map = [FOO]
    x = map[0]

func()
