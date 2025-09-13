<img width="50%" height="1024" alt="image" src="https://github.com/user-attachments/assets/fa38080a-d537-4056-a30e-7dd141912307" />

# 2025 UWB C++ GCSDD BootUp Notes

These notes summarize our 2-hour crash course on **C++ concepts vs. Java**. They include explanations, annotated code you can copy-paste, and sample outputs. Use them as a reference when practicing.

---

## Session recording
[Video](https://washington.zoom.us/rec/play/sfHTcVjWI0RKddK66Dn4OVYHxtXkwM2mVgNshWN_o7LrCndQaQmFlZ0o3FCoDeOc3HOf9pQnLTqU8GAl.kO7viQ7LynIqxHtL?eagerLoadZvaPages=sidemenu.billing.plan_management&accessLevel=meeting&canPlayFromShare=true&from=share_recording_detail&continueMode=true&componentName=rec-play&originRequestUrl=https%3A%2F%2Fwashington.zoom.us%2Frec%2Fshare%2FORfjYpG7WYhTyTljUTfgdhi3FwzlPFPVkg8HgYwreW1VUhRjen8tSnkeajHATHtT.WBuHSi61QC-6SeBn)

## Got Question?
Contact pengdu@uw.edu

## Class Survey
https://tinyurl.com/gcsdd-eval-f25

---

## 0. Compilation: Code → Binary

Unlike Java (compile to bytecode + JVM), C++ compiles directly to native machine code.

**Minimal program:**

```cpp
#include <iostream>
int main() {
    std::cout << "Hello C++ BootUp!" << std::endl;
    return 0;
}
```

**Compile & run:**

```bash
g++ -std=c++17 -O2 -Wall -Wextra -o mariolab main.cpp
./mariolab
```

---

## 0.1 Assembly Peek (Stack Frames)

```cpp
#include <iostream>
int max2(int a, int b) { return (a > b) ? a : b; }
int main() {
    std::cout << max2(41, 42) << "\n";
}
```

👉 Function calls push a **stack frame**, locals live in it, and `ret` uses the return address stored on the stack.

---

## 1. Baby Steps in C++ (Homework-style warmup)

```cpp
#include <iostream>
#include <string>
#include <cstdio>

int main() {
    std::string message = "Hello C++ BootUp!";
    std::cout << message << std::endl;
    printf("%s\n", message.c_str());

    // primitive variable
    int n = 5;
    std::string messages[] = {
            "C++",
            "this",
            "is",
            "so",
            "much",
            "fun"
    };

    // for loop with condition
    for (int i = 0; i < n; ++i) {
        if (i % 2 == 0) {
            std::cout << messages[i] << std::endl;
        }
    }

    // infinite loop with break
    for (int i = 0;; ++i) {
        if (i == n) {
            break;
        }
        std::cout << messages[i] << std::endl;
    }

    // while loop with break
    int i = 0;
    while (true) {
        if (i == n) {
            break;
        }
        std::cout << messages[i++] << std::endl;
    }
}
```

👉 These baby steps cover: strings, arrays, `for` loops, and `while` loops. Great practice before diving into memory and pointers.

---

## 2. Passing Semantics: Value, Reference, Pointer

```cpp
#include <iostream>

void bumpByValue(int x) { x++; }
void bumpByRef(int& x) { x++; }
void bumpByPtr(int* x) { if (x) (*x)++; }

void swapByValue(int a, int b) { int t=a; a=b; b=t; }
void swapByRef(int& a, int& b) { int t=a; a=b; b=t; }
void swapByPtr(int* a, int* b) { int t=*a; *a=*b; *b=t; }

int main() {
    int a = 10, b = 20;
    bumpByValue(a);
    bumpByRef(a);
    bumpByPtr(&a);

    swapByValue(a, b);
    std::cout << a << "," << b << "\n";

    swapByRef(a, b);
    std::cout << a << "," << b << "\n";

    swapByPtr(&a, &b);
    std::cout << a << "," << b << "\n";
}
```

👉 In Java, objects are always passed by value **of reference**. In C++, you explicitly choose **value/ref/pointer**.

---

## 2.1 Pointer Arithmetic with Arrays

```cpp
#include <iostream>

// Finds the element-wise maximum between two arrays of length n
void maxArrays(const int* arr1, const int* arr2, int* result, int n) {
    const int* p1 = arr1;
    const int* p2 = arr2;
    int* pr = result;

    for (int i = 0; i < n; ++i) {
        *pr = (*p1 > *p2) ? *p1 : *p2;
        p1++;
        p2++;
        pr++;
    }
}

int main() {
    int a[] = {1, 7, 3, 9, 5};
    int b[] = {2, 6, 4, 8, 10};
    int result[5];

    maxArrays(a, b, result, 5);

    std::cout << "Element-wise max array: ";
    for (int i = 0; i < 5; ++i) {
        std::cout << result[i] << " ";
    }
    std::cout << "\n";
}
```

👉 Demonstrates how pointers can walk through arrays: `p++` moves the pointer by `sizeof(int)` and `*p` accesses the value. This is equivalent to indexing (`arr[i]`), but shows how arrays and pointers are deeply connected in C++.

---

## 2.2 Pointer Arithmetic with Arrays (Returning a New Result Array)

```cpp
#include <iostream>

// Allocate a new array and return pointer to result
int* maxArraysNew(const int* arr1, const int* arr2, int n) {
    int* result = new int[n]; // caller must remember to delete[] this

    const int* p1 = arr1;
    const int* p2 = arr2;
    int* pr = result;

    for (int i = 0; i < n; ++i) {
        *pr = (*p1 > *p2) ? *p1 : *p2;
        p1++;
        p2++;
        pr++;
    }

    return result;
}

int main() {
    int a[] = {1, 7, 3, 9, 5};
    int b[] = {2, 6, 4, 8, 10};

    int* result = maxArraysNew(a, b, 5);

    std::cout << "Element-wise max array: ";
    for (int i = 0; i < 5; ++i) {
        std::cout << result[i] << " ";
    }
    std::cout << "\n";

    delete[] result; // important to avoid memory leak
}
```

👉 This version dynamically allocates the result array and returns it. In production C++, prefer `std::vector<int>` or smart pointers to manage memory automatically.

⚠️ **Memory Leak Warning:** If you forget the `delete[] result;` line, tools like Valgrind will show output.

---

## 3. Objects & Copying (Mario Theme)

```cpp
#include <iostream>
#include <string>

class Character {
protected:
    std::string name;
public:
    Character(const std::string& n) : name(n) {
        std::cout << "Character ctor\n";
    }
  
    virtual ~Character() { std::cout << "Character dtor\n"; }

    virtual std::string ability() const { return "?"; }

};

class Mario : public Character {
public:
    Mario(const std::string& n) : Character(n) { std::cout << "Mario ctor\n"; }
    Mario(const Mario& m) : Character(m) { std::cout << "Mario copy ctor\n"; }
    ~Mario() override { std::cout << "Mario dtor\n"; }
    std::string ability() const override { return "Fireball"; }
};

void trainByValue(Mario m) { (void)m; }
void trainByRef(Mario& m) { (void)m; }
void trainByPtr(Mario* m) { (void)m; }

int main() {
    Mario hero("Mario");
    trainByValue(hero);
    trainByRef(hero);
    trainByPtr(&hero);
}
```

---

## 4. Polymorphism & Slicing (Mario Theme)

```cpp
#include <iostream>
#include <vector>

class Character {
protected:
    std::string name;
public:
    Character(const std::string& n)
    : name(n)
    {
        std::cout << "Character ctor\n";
    }
    virtual ~Character() {}
    virtual std::string ability() const { return "?"; }

};

class Mario : public Character {
public:
    Mario(const std::string& n) : Character(n) { std::cout << "Mario ctor\n"; }
    std::string ability() const override { return "Fireball"; }
};

class Luigi : public Character {
public:
    Luigi(const std::string& n) : Character(n) { std::cout << "Luigi ctor\n"; }
    std::string ability() const override { return "High Jump"; }
};

class Bowser : public Character {
public:
    Bowser(const std::string& n) : Character(n) { std::cout << "Bowser ctor\n"; }
    std::string ability() const override { return "Flame Breath"; }
};

void showByValue(Character c) {
    std::cout << c.ability() << "\n";
}
void showByRef(const Character& c) {
    std::cout << c.ability() << "\n";
}

int main() {
    Mario mario("Mario");
    Luigi luigi("Luigi");
    Bowser bowser("Bowser");

    // --- Slicing Demo ---
    showByValue(mario); // prints "?" (sliced)
    showByRef(mario);   // prints "Fireball" (no slicing)

    std::vector<Character> byValue;
    byValue.push_back(mario);
    std::cout << byValue[0].ability() << "\n"; // prints "?" (sliced)

    std::vector<Character*> party;
    party.push_back(new Mario("Mario"));
    party.push_back(new Luigi("Luigi"));
    party.push_back(new Bowser("Bowser"));

    for (auto p : party) std::cout << p->ability() << "\n"; // correct polymorphism

    // cleanup
    for (auto p : party) delete p;
}
```

---

## 5. Stack vs Heap & RAII (Mario Theme)

<img width="50%" height="736" alt="image" src="https://github.com/user-attachments/assets/d05d07c4-bf76-4b13-9238-65135da99371" />


```cpp
#include <iostream>
#include <string>

class Character {
protected:
    std::string name;
public:
    Character(const std::string& n)
    : name(n)
    {
        std::cout << "Character ctor\n";
    }
    virtual ~Character() { std::cout << "~Character for " << name << "\n"; }
    virtual std::string ability() const { return "?"; }
};

class Luigi : public Character {
public:
    Luigi(const std::string& n) : Character(n) { std::cout << "Luigi ctor\n"; }
    ~Luigi() override { std::cout << "~Luigi cleanup for " << name << "\n"; }
    std::string ability() const override { return "High Jump"; }
};

int main() {
    Luigi stackLuigi("Luigi");
    std::cout << stackLuigi.ability() << "\n";

    Luigi* heapLuigi = new Luigi("Luigi");
    std::cout << heapLuigi->ability() << "\n";
    delete heapLuigi;

    Luigi* rawPtr = new Luigi("Luigi");
    std::cout << rawPtr->ability() << "\n";
    delete rawPtr;
}
```

---

## 6. Virtual Destructors (Mario Theme)

```cpp
#include <iostream>
#include <string>

class Character {
protected:
    std::string name;
public:
    Character(const std::string& n)
    : name(n)
    {
        std::cout << "Character ctor\n";
    }
    virtual ~Character() { std::cout << "~Character\n"; }
    virtual std::string ability() const { return "?"; }
};

class Bowser : public Character {
    int* heavy = new int[256];
public:
    Bowser(const std::string& n) : Character(n) { std::cout << "Bowser ctor\n"; }
    ~Bowser() override {
        std::cout << "~Bowser releasing resources\n";
        delete[] heavy;
    }
    std::string ability() const override { return "Flame Breath"; }
};

int main() {
    Character* p = new Bowser("Bowser");
    delete p;
}
```

---

## Key Differences vs Java

1. **Compilation:** Java → bytecode/JVM. C++ → native binary.
2. **Memory model:** Java hides addresses; C++ exposes `&`, pointers.
3. **Passing:** Java passes primitives by value and objects by value of reference. C++ lets you choose value, reference, or pointer for any type.
4. **Polymorphism:** Java methods are virtual by default. In C++, you must mark with `virtual` and use references/pointers to enable dynamic dispatch; value semantics can slice.
5. **Lifetime:** Java has GC. C++ uses RAII and destructors; raw pointers require explicit delete.
6. **Slicing:** Only in C++ if you store/pass a derived object **by value** as its base.

---

## Practice Prompts

1. Change `showByRef(const Character&)` to take `const Character` by value. What changes, and why?
2. Add a large `std::array<int, 2048>` to `Mario`; measure cost of copies vs refs using `std::chrono`.
3. Store characters in `std::vector<Character>` vs `std::vector<Character*>`; explain outputs.
4. Temporarily remove `virtual` from `~Character` and observe destructor calls.

---

## Appendix: Build Files

### Makefile Example

```make
CXX := g++
CXXFLAGS := -std=c++17 -O2 -Wall -Wextra
SRC := $(wildcard src/*.cpp)
OBJ := $(SRC:.cpp=.o)
BIN := mariolab

all: $(BIN)

$(BIN): $(OBJ)
	$(CXX) $(CXXFLAGS) $^ -o $@

clean:
	rm -f $(OBJ) $(BIN)
```

### CMakeLists.txt Example

```cmake
cmake_minimum_required(VERSION 3.15)
project(mariolab LANGUAGES CXX)

# Require C++17
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

# Default build type = Release if not set
if(NOT CMAKE_BUILD_TYPE AND NOT CMAKE_CONFIGURATION_TYPES)
  set(CMAKE_BUILD_TYPE Release CACHE STRING "Build type" FORCE)
endif()

# Collect all .cpp files from src/
file(GLOB SRC_FILES CONFIGURE_DEPENDS "${CMAKE_SOURCE_DIR}/src/*.cpp")

# Define executable
add_executable(mariolab ${SRC_FILES})

# Compiler options
if(MSVC)
  target_compile_options(mariolab PRIVATE /W4 /permissive-)
else()
  target_compile_options(mariolab PRIVATE -Wall -Wextra)
  target_compile_options(mariolab PRIVATE $<$<CONFIG:Release>:-O2>)
endif()

set(CMAKE_POSITION_INDEPENDENT_CODE ON)
```

---

**End of Notes — Good luck for your study and happy hoding!**


