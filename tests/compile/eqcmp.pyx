# mode: compile

cdef void foo():
    let int bool, int1=0, int2=0
    cdef float float1=0, float2=0
    let char *ptr1=NULL, *ptr2=NULL
    let int *ptr3
    bool = int1 == int2
    bool = int1 != int2
    bool = float1 == float2
    bool = ptr1 == ptr2
    bool = int1 == float2
    bool = ptr1 is ptr2
    bool = ptr1 is not ptr2

foo()
