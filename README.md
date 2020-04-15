# c-project-use-c-lib
c project use c++ lib

<https://www.teddy.ch/c++_library_in_c/> 

# Tutorial: How To integrate a C++ library/class into a C programm

Emagine the situation: You have written a program in C and now you have the requirement to integrate an existing third parity C++ library into your program.

## The C++ Library

The only thing you have is the class definition in the header file of the library:

| MyClass.h                                                    |
| ------------------------------------------------------------ |
| `#ifndef __MYCLASS_H #define __MYCLASS_H  class MyClass {         private:                 int m_i;         public:                 void int_set(int i);                  int int_get(); };  #endif` |

It is a simple class with only one member variable m_i and one setter and one getter method.

Perhaps you don't have the source code of the library, perhaps you only have a compiled version. To be able to reproduce the example here is the source of the class:

| MyClass.cc                                                   |
| ------------------------------------------------------------ |
| `#include "MyClass.h" void MyClass::int_set(int i) {         m_i = i; }  int MyClass::int_get() {         return m_i; }` |

To compile the class with GNU C++ comiler simply type:

This gives you the object file that can be linked into your programm. In this place I won't explain how to create a complete library.

## The C++ way

Just for comparison here a simple C++ program that uses our new class:

| MyMain_c++.cc                                                |
| ------------------------------------------------------------ |
| `#include "MyClass.h" #include <iostream>  using namespace std;  int main(int argc, char* argv[]) {         MyClass *c = new MyClass();         c->int_set(3);         cout << c->int_get() << endl;         delete c; }` |

This program can be compiled with:

And linked with:

Start the C++ program with:

## The Problem

If we want to access a C++ library from C code we have two problems that we have to solve:

- The name mangling of C is differnt to C++.
- C doesn't know classes.

## The C-Wrapper

To solve these problems we have to write a C-wrapper around our C++ class. Our wrapper header file will be readable by the C and the C++ compiler.

| MyWrapper.h                                                  |
| ------------------------------------------------------------ |
| `#ifndef __MYWRAPPER_H #define __MYWRAPPER_H  #ifdef __cplusplus extern "C" { #endif  typedef struct MyClass MyClass;  MyClass* newMyClass();  void MyClass_int_set(MyClass* v, int i);  int MyClass_int_get(MyClass* v);  void deleteMyClass(MyClass* v);  #ifdef __cplusplus } #endif #endif` |

The extern "C" {} statement tells the C++ compiler to use the C style name mangling so a C compiler will find the correct symbols in the object file later. The #ifdef __cplusplus contition is because the C compiler does not know the keyword extern.

For the C compiler we define a dummy class handler with typedef struct MyClass MyClass.

And then the constructor, method and destructor wrappers.

The following file is the wrapper code, written in C++, but with one important thing: it is defined as extern "C"!

| MyWrapper.cc                                                 |
| ------------------------------------------------------------ |
| `#include "MyClass.h" #include "MyWrapper.h"  extern "C" {         MyClass* newMyClass() {                 return new MyClass();         }          void MyClass_int_set(MyClass* v, int i) {                 v->int_set(i);         }          int MyClass_int_get(MyClass* v) {                 return v->int_get();         }          void deleteMyClass(MyClass* v) {                 delete v;         } }` |

To compile the wrapper with GNU C++ comiler simply type:

## The C Program

Now we are ready to use the C++ class in our C code:

| MyMain_c.c                                                   |
| ------------------------------------------------------------ |
| `#include "MyWrapper.h" #include <stdio.h>  int main(int argc, char* argv[]) {         struct MyClass* c = newMyClass();         MyClass_int_set(c, 3);         printf("%i\n", MyClass_int_get(c));         deleteMyClass(c); }` |

This program can be compiled with the C compiler:

**Note that the linking has to be done with the C++ comiler, a C linker like ldd does not work:**

Start the C program with:

You should now get the same result as with your C++ program above.

I hope this mini tutorial helped you.