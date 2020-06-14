#!/bin/bash

touch NEWS README AUTHORS ChangeLog COPYING

mkdir -p src

cat > src/example-0.c <<\
"--------------"
#include <glib.h>
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[])
{

    char seedstr[100];

    g_snprintf (seedstr, sizeof (seedstr), "R02S%08x%08x%08x%08x", g_random_int(), g_random_int(), g_random_int(), g_random_int());

    printf ("%s\n", seedstr );


    return 0;
}
--------------


cat > Makefile.am <<\
"--------------"
SUBDIRS = src

## Define an independent executable script for inclusion in the distribution
## archive. It will not be installed on an end user's system, however.
dist_noinst_SCRIPTS = autogen.sh
--------------


cat > src/Makefile.am <<\
"--------------"
## Append to CFLAGS.  Used by gcc to compile c programs
AM_CFLAGS =  -std=gnu11

## Append to CXXFLAGS. Used by g++ to complite cpp programs
AM_CXXFLAGS = -std=c++11


## Place generated object files (.o) into the same directory as their source
## files, in order to avoid collisions when non-recursive make is used.
AUTOMAKE_OPTIONS = subdir-objects

## Additional flags to pass to aclocal when it is invoked automatically at
## make time. The ${ACLOCAL_FLAGS} variable is picked up from the environment
## to provide a way for the user to supply additional arguments.
ACLOCAL_AMFLAGS = ${ACLOCAL_FLAGS}

## Set the default command-line flags for the C preprocessor to the value
## obtained from pkg-config via PKG_CHECK_MODULES in configure.ac.  These
## flags are passed to the compiler for both C and C++, in addition to the
## language-specific options.
AM_CPPFLAGS = $(GLIB_CFLAGS)

## Define an executable target, which will be installed into the
## directory named by the predefined variable $(bindir).
bin_PROGRAMS = example-0

## Set the library dependencies for the "example" target to the value obtained
## from pkg-config via PKG_CHECK_MODULES in configure.ac.  These libraries are
## passed to the linker in addition to the other linker flags.
example_0_LDADD = $(GLIB_LIBS)

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
-e '12i\
AM_INIT_AUTOMAKE' \
-e '14i\
PKG_CHECK_MODULES([GLIB], [glib-2.0])' \
-e '16i\
# https://autotools.io/pkgconfig/pkg_check_modules.html # The main interface between autoconf and pkg-config is the PKG_CHECK_MODULES macro, which provides a very basic and easy way to check for the presence of a given package in the system # By default,the macro will set up two variables, joining the given prefix with the suffixes _CFLAGS and _LIBS. # As we are using the GLIB prefix, This will setup the variable GLIB_CFLAGS  with the output of  pkg-config --cflags gtk+-3.0 # AND GLIB_LIBS with the output of: pkg-config --libs gtk+-3.0 # Those variables are used later in the file  src/Makefile.am' \
< configure.scan > configure.ac


##automake --add-missing

autoreconf -iv

# ./configure

## produce tarball for distribution
# make distcheck
