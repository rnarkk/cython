# mode: compile

enum Spam:
    A
    B, C,
    D, E, F
    G = 42

fn void eggs():
    let Spam s1, s2 = Spam::A
    let i32 i
    s1 = s2
    s1 = Spam::C
    i = <i32>s1

eggs()
