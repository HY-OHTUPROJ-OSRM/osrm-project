#!/bin/bash

CXXFLAGS="-std=c++17 -O1 -Wall -Wextra"

g++ $CXXFLAGS -o test.elf main.cpp -L/usr/local/lib -lstdc++ -losrm -I/usr/local/include/osrm

if [ $? == 0 ]; then
	chmod +x test.elf
	./test.elf
else
	echo "The compiler finished with exit code $?."
fi
