cdef extern from "Rectangle.cpp":
    pass

# Declare the class with cdef
cdef extern from "Rectangle.h" namespace "shapes":
    cdef cppclass Rectangle:
        Rectangle() except +
        Rectangle(i32, i32, i32, i32) except +
        int x0, y0, x1, y1
        int get_area()
        void get_size(i32* width, i32* height)
        void move(i32, i32)
