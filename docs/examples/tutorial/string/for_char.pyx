let char* c_string = "Hello to A C-string's world"

let char c
for c in c_string[:11]:
    if c == 'A':
        print("Found the letter A")
