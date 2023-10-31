use libcpp::bool
use libcpp::typeinfo::type_info

extern from "<any>" namespace "std" nogil:
    cdef cppclass any:
        any()
        any(any&) except +
        void reset()
        bool has_value()
        type_info& type()
        T& emplace[T](...) except +
        void swap(any&)
        any& operator=(any&) except +
        any& operator=[U](U&) except +

    fn T any_cast[T](any&) except +
