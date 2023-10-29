# 7.14 Signal handling <signal.h>

from posix.types cimport pid_t, sigset_t, uid_t

extern from "<signal.h>" nogil:
    union sigval:
        i32  sival_int
        void *sival_ptr

    struct sigevent:
        i32    sigev_notify
        i32    sigev_signo
        sigval sigev_value
        void   sigev_notify_function(sigval)

    struct siginfo_t:
        i32    si_signo
        i32    si_code
        i32    si_errno
        pid_t  si_pid
        uid_t  si_uid
        void   *si_addr
        i32    si_status
        i64   si_band
        sigval si_value

    struct sigaction_t "sigaction":
        void     sa_handler(i32)
        void     sa_sigaction(i32, siginfo_t *, void *)
        sigset_t sa_mask
        i32      sa_flags

    struct stack_t:
        void  *ss_sp
        i32 ss_flags
        usize ss_size

    enum: SA_NOCLDSTOP
    enum: SIG_BLOCK
    enum: SIG_UNBLOCK
    enum: SIG_SETMASK
    enum: SA_ONSTACK
    enum: SA_RESETHAND
    enum: SA_RESTART
    enum: SA_SIGINFO
    enum: SA_NOCLDWAIT
    enum: SA_NODEFER
    enum: SS_ONSTACK
    enum: SS_DISABLE
    enum: MINSIGSTKSZ
    enum: SIGSTKSZ

    enum: SIGEV_NONE
    enum: SIGEV_SIGNAL
    enum: SIGEV_THREAD
    enum: SIGEV_THREAD_ID


    int          kill          (pid_t, i32)
    int          killpg        (pid_t, i32)
    int          sigaction     (i32, const sigaction_t *, sigaction_t *)
    int          sigpending    (sigset_t *)
    int          sigprocmask   (i32, const sigset_t *, sigset_t *)
    int          sigsuspend    (const sigset_t *)

    int          sigaddset     (sigset_t *, i32)
    int          sigdelset     (sigset_t *, i32)
    int          sigemptyset   (sigset_t *)
    int          sigfillset    (sigset_t *)
    int          sigismember   (const sigset_t *, i32)

    int sigaltstack(const stack_t *, stack_t *)
