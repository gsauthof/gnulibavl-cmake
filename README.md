CMake build file for [GNU libavl][1].

2014-05-01, Georg Sauthoff <mail@georg.so>

## Getting started

Clone the repository to `avl-2.0.3`.

Then extract the libavl source into the working directory:

    $ cd parent-dir/of/git-repository
    $ curl -O http://ftp.gnu.org/gnu/avl/avl-2.0.3.tar.gz
    $ tar xf avl-2.0.3.tar.gz
    $ cd avl-2.0.3
    $ mkdir build
    $ cd build

The `build` directory is created for doing out-of-source builds.

## Configure

The files `init.cmake` and `init_solaris.cmake` contain some default settings
for a common Linux distribution and for Solaris. You can use them like this to
populate the initial cmake variable cache:

    $ cmake -C ../init.cmake ..
    $ make

or

    $ cmake -C ../init_solaris.cmake ..
    $ gmake

You can also override some defaults like this:

    $ cmake -C ../init.cmake -D LIB_SUB_DIR=lib64  -D CMAKE_BUILD_TYPE=Debug ..
    $ make

Alternatively you can also edit those cmake initialization files, of course.

Note that those variables are cached between cmake runs and are not overridden.
To start clean you can do something like:

    $ rm -rf CMakeCache.txt CMakeFiles
    $ cmake -C ../init.cmake ..
    $ make

## Install for Packaging

To create a `DESTDIR` installation:

    $ mkdir dest
    $ DESTDIR=dest cmake -C ../init.cmake -D LIB_SUB_DIR=lib64 -DCMAKE_INSTALL_PREFIX=/usr ..
    $ DESTDIR=dest make install

Which prints something like:

    -- Install configuration: "Release"
    -- Installing: dest/usr/lib64/libgnuavl.so.2.0.3
    -- Installing: dest/usr/lib64/libgnuavl.so.2
    -- Installing: dest/usr/lib64/libgnuavl.so
    -- Installing: dest/usr/lib64/libgnuavl.a
    -- Installing: dest/usr/include/gnuavl/bst.h
    -- Installing: dest/usr/include/gnuavl/avl.h
    -- Installing: dest/usr/include/gnuavl/rb.h
    -- Installing: dest/usr/include/gnuavl/tbst.h
    -- Installing: dest/usr/include/gnuavl/tavl.h
    -- Installing: dest/usr/include/gnuavl/trb.h
    -- Installing: dest/usr/include/gnuavl/rtbst.h
    -- Installing: dest/usr/include/gnuavl/rtavl.h
    -- Installing: dest/usr/include/gnuavl/rtrb.h
    -- Installing: dest/usr/include/gnuavl/pbst.h
    -- Installing: dest/usr/include/gnuavl/pavl.h
    -- Installing: dest/usr/include/gnuavl/prb.h
    -- Installing: dest/usr/share/info/libavl.info
    -- Installing: dest/usr/share/info/libavl.info-1
    -- Installing: dest/usr/share/info/libavl.info-2
    -- Installing: dest/usr/share/info/libavl.info-3
    -- Installing: dest/usr/share/info/libavl.info-4
    -- Installing: dest/usr/share/doc/libgnuavl-2.0.3/AUTHORS
    -- Installing: dest/usr/share/doc/libgnuavl-2.0.3/COPYING
    -- Installing: dest/usr/share/doc/libgnuavl-2.0.3/COPYING.DOC
    -- Installing: dest/usr/share/doc/libgnuavl-2.0.3/COPYING.LIB
    -- Installing: dest/usr/share/doc/libgnuavl-2.0.3/NEWS
    -- Installing: dest/usr/share/doc/libgnuavl-2.0.3/OUTLINE
    -- Installing: dest/usr/share/doc/libgnuavl-2.0.3/README
    -- Installing: dest/usr/share/doc/libgnuavl-2.0.3/ROADMAP
    -- Installing: dest/usr/share/doc/libgnuavl-2.0.3/THANKS
    -- Installing: dest/usr/share/doc/libgnuavl-2.0.3/TODO

## Solaris Notes

GNU libavl compiles with the Oracle Solaris Studio C compiler (I've tested it
with 12.3 - but it should work with older versions, too).

Cmake is (fortunately) available as [OpenCSW][2] package.

Although the generated makefile should be compatible with Sun make, I recommend to use GNU make (`gmake`).

For creating both 32/64 versions you can do something like this (assuming a Solaris SPARC system):

    $ mkdir build
    $ cd build
    $ DESTDIR=dest cmake -C ../init_solaris.cmake -DCMAKE_INSTALL_PREFIX=/opt/sw ..
    $ DESTDIR=dest gmake install
    $ rm -rf CMakeCache.txt CMakeFiles
    $ DESTDIR=dest cmake -C ../init_solaris.cmake -DCMAKE_INSTALL_PREFIX=/opt/sw -DCMAKE_C_FLAGS_INIT=-m64 -DLIB_SUB_DIR=lib/sparcv9 ..
    $ DESTDIR=dest gmake install

Then you get in the second run:

    /opt/csw/bin/cmake -P cmake_install.cmake
    -- Install configuration: "Release"
    -- Installing: dest/opt/sw/lib/sparcv9/libgnuavl.so.2.0.3
    -- Installing: dest/opt/sw/lib/sparcv9/libgnuavl.so.2
    -- Installing: dest/opt/sw/lib/sparcv9/libgnuavl.so
    -- Installing: dest/opt/sw/lib/sparcv9/libgnuavl.a
    -- Up-to-date: dest/opt/sw/include/gnuavl/bst.h
    -- Up-to-date: dest/opt/sw/include/gnuavl/avl.h
    -- Up-to-date: dest/opt/sw/include/gnuavl/rb.h
    [..]

## Test

The GNU libavl comes with some tests. They are also included in the build file - it provides the target check, i.e.

    $ cmake -C ../init.cmake ..
    $ make check

builds and executes them all and should produce output like this one:

    Test project /home/juser/src/avl-2.0.3/build
          Start  1: bst-test
     1/12 Test  #1: bst-test .........................   Passed    0.02 sec
          Start  2: avl-test
     2/12 Test  #2: avl-test .........................   Passed    0.02 sec
          Start  3: rb-test
     3/12 Test  #3: rb-test ..........................   Passed    0.05 sec
          Start  4: tbst-test
     4/12 Test  #4: tbst-test ........................   Passed    0.04 sec
          Start  5: tavl-test
     5/12 Test  #5: tavl-test ........................   Passed    0.07 sec
          Start  6: trb-test
     6/12 Test  #6: trb-test .........................   Passed    0.04 sec
          Start  7: rtbst-test
     7/12 Test  #7: rtbst-test .......................   Passed    0.02 sec
          Start  8: rtavl-test
     8/12 Test  #8: rtavl-test .......................   Passed    0.02 sec
          Start  9: rtrb-test
     9/12 Test  #9: rtrb-test ........................   Passed    0.02 sec
          Start 10: pbst-test
    10/12 Test #10: pbst-test ........................   Passed    0.04 sec
          Start 11: pavl-test
    11/12 Test #11: pavl-test ........................   Passed    0.02 sec
          Start 12: prb-test
    12/12 Test #12: prb-test .........................   Passed    0.02 sec
    
    100% tests passed, 0 tests failed out of 12


## Info pages

When installing the info-pages there is some post-install step necessary, e.g.:


    $ install-info --info-dir test/usr/local/share/info --section Development Development \
      --entry '* libavl: (libavl).           The GNU AVL library.' inst/usr/local/share/info/libavl.info

Then you preview them via:

    $ info -d test/usr/local/share/info libavl


## Other build generators

You can also select other build generators with cmake, e.g. on Fedora (>= 19):

    $ cmake -G Ninja -C ../init.cmake ..
    $ ninja-build


## Licence

I don't think that this build file is copyrightable. Thus, if you need to - feel
free to assume GPL, BSD, MIT or something like that.


[1]: http://adtinfo.org/
[2]: http://www.opencsw.org/
