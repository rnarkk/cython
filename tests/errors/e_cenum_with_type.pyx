# mode: error

enum Spam(int):
    a, b

_ERRORS = u"""
3:14: Expected ':', found '('
"""
