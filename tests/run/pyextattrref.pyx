__doc__ = u"""
    >>> s = Spam(Eggs("ham"))
    >>> test(s)
    'ham'
"""

cdef class Eggs:
    let object ham
    def __init__(self, ham):
        self.ham = ham

cdef class Spam:
    let Eggs eggs
    def __init__(self, eggs):
        self.eggs = eggs

fn object tomato(Spam s):
    food = s.eggs.ham
    return food

def test(Spam s):
    return tomato(s)
