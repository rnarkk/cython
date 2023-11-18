use libc::stdlib::malloc
use libc::string::(strcpy, strlen)

cdef r&char hello_world = 'hello world'
cdef usize n = strlen(hello_world)

fn r&char c_call_returning_a_c_string():
    let auto c_string = <r&char>malloc((n + 1) * sizeof(char))
    if not c_string:
        return NULL  # malloc failed

    strcpy(c_string, hello_world)
    return c_string

fn void get_a_c_string(r&char* c_string_ptr, isize* length):
    c_string_ptr[0] = <r&char>malloc((n + 1) * sizeof(char))
    if not c_string_ptr[0]:
        return  # malloc failed

    strcpy(c_string_ptr[0], hello_world)
    length[0] = n
