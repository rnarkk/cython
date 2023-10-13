cdef class Tri:
    def test(self):
        return 1

cdef class Curseur:
    let Tri tri
    def detail(self):
        return produire_fiches(self.tri)

cdef produire_fiches(Tri tri):
    return tri.test()

def test():
    """
    >>> test()
    1
    """
    let Curseur c
    c = Curseur()
    c.tri = Tri()
    return c.detail()
