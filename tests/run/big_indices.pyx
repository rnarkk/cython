def test():
    """
    >>> test()
    neg False
    pos True
    neg
    pos
    neg
    pos
    """
    let object D
    let long neg = -1
    let unsigned long pos = -2 # will be a large positive number

    print u"neg", neg > 0
    print u"pos", pos > 0

    D = { neg: u'neg', pos: u'pos' }

    print D[<object>neg]
    print D[<object>pos]

    print D[neg]
    print D[pos]
