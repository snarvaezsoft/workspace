#!/bin/bash

touch NEWS README AUTHORS ChangeLog COPYING

mkdir -p src

cat > src/hello.c <<\
"--------------"
#include <stdio.h>
int main(){ printf("Hi.\n"); }
--------------

cat > Makefile.am <<\
"--------------"
SUBDIRS = src
--------------


cat > src/Makefile.am <<\
"--------------"
## Append to CFLAGS.  Used by gcc to compile c programs
AM_CFLAGS =  -std=gnu11

## Append to CXXFLAGS. Used by g++ to complite cpp programs
AM_CXXFLAGS = -std=c++11

bin_PROGRAMS=hello
hello_SOURCES=hello.c

##testpow_LDFLAGS = -lm
--------------



cat > callmake.sh <<\
"--------------"
#!/bin/bash
# call make with extra parameters
make CXXFLAGS='-g3 -Wall -O0 '  CFLAGS='-g3 -Wall -O0 '
--------------

chmod +x callmake.sh



autoscan

## sed 10i: insert AM_INIT_AUTOMAKE in the 10th line of the configure.ac file

sed -e 's/FULL-PACKAGE-NAME/hello/' \
-e 's/VERSION/1/' \
-e 's|BUG-REPORT-ADDRESS|/dev/null|' \
-e '10i\
AM_INIT_AUTOMAKE' \
< configure.scan > configure.ac


##automake --add-missing

autoreconf -iv

# ./configure

## produce tarball for distribution
# make distcheck
