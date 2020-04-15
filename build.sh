#!/bin/sh

rm -rf ./*.o	
	
rm -rf ./*.a	
	
g++ -c MyClass.cc -o MyClass.o	

ar -r libMyClass.a MyClass.o

g++ -c MyWrapper.cc -o MyWrapper.o

ar -r libMyWrapper.a MyWrapper.o

gcc -c MyMain_c.c -o MyMain_c.o

g++ MyMain_c.o -o MyMain_c -L. -lMyWrapper -lMyClass