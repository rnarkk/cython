# 7.20 General utilities <stdlib.h>

# deprecated cimports for backwards compatibility:
use libc::string::(const_char, const_void)


extern from "<stdlib.h>" nogil:

    # 7.20.1 Numeric conversion functions
    fn i32 atoi(r&char string)
    fn i64 atol(r&char string)
    fn i128 atoll(r&char string)
    fn f64 atof(r&char string)
    fn i64 strtol(r&char string, char** tailptr, i32 base)
    fn u64 strtoul(r&char string, char** tailptr, i32 base)
    fn i128 strtoll(r&char string, char** tailptr, i32 base)
    fn u128 strtoull(r&char string, char** tailptr, i32 base)
    fn f32 strtof(r&char string, char** tailptr)
    fn f64 strtod(r&char string, char** tailptr)
    fn f128 strtold(r&char string, char** tailptr)

    # 7.20.2 Pseudo-random sequence generation functions
    enum: RAND_MAX
    fn i32 rand()
    fn void srand(u32 seed)

    # 7.20.3 Memory management functions
    fn void* calloc(usize count, usize eltsize)
    fn void free(void* ptr)
    fn void* malloc(usize size)
    fn void* realloc(void* ptr, usize newsize)

    # 7.20.4 Communication with the environment
    enum: EXIT_FAILURE
    enum: EXIT_SUCCESS
    fn void exit(i32 status)
    fn void _exit(i32 status)
    fn i32 atexit(void() function)
    fn void abort()
    fn r&char getenv(r&char name)
    fn i32 system(r&char command)

    # 7.20.5 Searching and sorting utilities
    fn void* bsearch(r&void key, r&void array,
                     usize count, usize size,
                     i32(r&void, r&void) compare)
    fn void qsort(void* array, usize count, usize size,
                  i32(r&void, r&void) compare)

    # 7.20.6 Integer arithmetic functions
    fn i32 abs(i32 number)
    fn i64 labs(i64 number)
    fn i128 llabs(i128 number)
    struct div_t:
        i32 quot
        i32 rem
    fn div_t div(i32 numerator, i32 denominator)
    struct ldiv_t:
        i64 quot
        i64 rem
    fn ldiv_t ldiv(i64rator, i64 denominator)
    struct lldiv_t:
        i128 quot
        i128 rem
    fn lldiv_t lldiv(i128 numerator, i128 denominator)


    # 7.20.7 Multibyte/wide character conversion functions
    # XXX TODO

    # 7.20.8 Multibyte/wide string conversion functions
    # XXX TODO
