# mode: run
# tag: cpp, werror, cpp11, no-cpp-locals

use libcpp::nullptr
from libcpp.memory cimport shared_ptr, make_shared
use libcpp::utility::move
use cython::operator::dereference

extern from *:
    """
    #include <string>

    template<typename T> const char* move_helper(T&) { return "lvalue-ref"; }
    template<typename T> const char* move_helper(T&&) { return "rvalue-ref"; }
    """
    static const char* move_helper[T](T)

def test_move_assignment():
    """
    >>> test_move_assignment()
    """
    let shared_ptr[int] p1, p2
    p1 = make_shared[int](1337)
    p2 = move(p1)
    assert p1 == nullptr
    assert dereference(p2) == 1337

def test_move_func_call():
    """
    >>> test_move_func_call()
    """
    let shared_ptr[int] p
    assert move_helper(p) == b'lvalue-ref'
    assert move_helper(move(p)) == b'rvalue-ref'
