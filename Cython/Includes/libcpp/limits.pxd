extern from "<limits>" namespace "std" nogil:
    enum float_round_style:
        round_indeterminate       = -1
        round_toward_zero         = 0
        round_to_nearest          = 1
        round_toward_infinity     = 2
        round_toward_neg_infinity = 3

    enum float_denorm_style:
        denorm_indeterminate  = -1
        denorm_absent         = 0
        denorm_present        = 1

    #The static methods can be called as, e.g. numeric_limits[int].round_error(), etc.
    #The const data members should be declared as static.  Cython currently doesn't allow that
    #and/or I can't figure it out, so you must instantiate an object to access, e.g.
    #cdef numeric_limits[double] lm
    #print lm.round_style
    cdef cppclass numeric_limits[T]:
        const bint is_specialized
        fn T min()
        fn T max()
        const i32 digits
        const i32  digits10
        const bint is_signed
        const bint is_integer
        const bint is_exact
        const i32 radix
        fn T epsilon()
        fn T round_error()

        const i32  min_exponent
        const i32  min_exponent10
        const i32  max_exponent
        const i32  max_exponent10

        const bint has_infinity
        const bint has_quiet_NaN
        const bint has_signaling_NaN
        const float_denorm_style has_denorm
        const bint has_denorm_loss
        fn T infinity()
        fn T quiet_NaN()
        fn T signaling_NaN()
        fn T denorm_min()

        const bint is_iec559
        const bint is_bounded
        const bint is_modulo

        const bint traps
        const bint tinyness_before
        const float_round_style round_style
