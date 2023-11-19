import cython

use super::super::Plex::Scanners::Scanner

cdef unicode any_string_prefix, IDENT

fn get_lexicon()
fn initial_compile_time_env()

# # methods commented with '# #' out are used by Parsing.py when compiled.

#[cython::final]
cdef class CompileTimeScope:
    pub dict entries
    pub CompileTimeScope outer
    # # fn declare(self, name, value)
    # # fn lookup_here(self, name)
    # # cpdef lookup(self, name)

#[cython::final]
cdef class PyrexScanner(Scanner):
    pub context
    pub list included_files
    pub CompileTimeScope compile_time_env
    pub u2 compile_time_eval
    pub u2 compile_time_expr
    pub u2 parse_comments
    pub u2 in_python_file
    pub source_encoding
    cdef dict keywords
    pub list indentation_stack
    pub indentation_char
    pub int bracket_nesting_level
    cdef readonly u2 async_enabled
    pub unicode sy
    pub systring  # EncodedString
    pub list put_back_on_failure

    fn isize current_level(self)
    # cpdef commentline(self, text)
    # cpdef open_bracket_action(self, text)
    # cpdef close_bracket_action(self, text)
    # cpdef newline_action(self, text)
    # cpdef begin_string_action(self, text)
    # cpdef end_string_action(self, text)
    # cpdef unclosed_string_action(self, text)

    #[cython::locals(current_level=isize, new_level=isize)]
    cpdef indentation_action(self, text)

    # cpdef eof_action(self, text)
    # # cdef next(self)
    # # cdef peek(self)
    # cpdef put_back(self, sy, systring)
    # # fn u2 expect(self, what, message = *) except -2
    # # fn expect_keyword(self, what, message = *)
    # # fn expected(self, what, message = *)
    # # fn expect_indent(self)
    # # fn expect_dedent(self)
    # # fn expect_newline(self, message=*, u2 ignore_semicolon=*)
    # # fn int enter_async(self) except -1
    # # fn int exit_async(self) except -1
    fn void error_at_scanpos(self, str message) except *
