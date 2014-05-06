# 2014-04-01, Georg Sauthoff
cmake_minimum_required(VERSION 2.8)
project(libgnuavl C)

set(LIB_SRC
  bst.c
  avl.c
  rb.c
  tbst.c
  tavl.c
  trb.c
  rtbst.c
  rtavl.c
  rtrb.c
  pbst.c
  pavl.c
  prb.c
)

set(LIB_VERSION_MAJOR 2)
set(LIB_VERSION_MINOR 0)
set(LIB_VERSION_PATCH 3)
set(LIB_VERSION_STRING ${LIB_VERSION_MAJOR}.${LIB_VERSION_MINOR}.${LIB_VERSION_PATCH})

set(GNUAVL "gnuavl" CACHE STRING "e.g. gnuavl, as used in libgnuavl.a etc.")

add_library(${GNUAVL} SHARED
  ${LIB_SRC}
)
add_library(${GNUAVL}_static STATIC
  ${LIB_SRC}
)

set_target_properties(${GNUAVL} PROPERTIES VERSION ${LIB_VERSION_STRING}
                                           SOVERSION ${LIB_VERSION_MAJOR})

# static libraries are usually not versioned
# and those properties are not picked up for static library targets
#set_target_properties(gnuavl_static PROPERTIES VERSION ${LIB_VERSION_STRING}
#                                             SOVERSION ${LIB_VERSION_MAJOR})

# under windows shared/static libraries have the same extension ...
if(${UNIX})
  set_target_properties(${GNUAVL}_static PROPERTIES OUTPUT_NAME ${GNUAVL})
endif()

# or lib64
set(LIB_SUB_DIR "lib"
  CACHE STRING
  "Set to 'lib', 'lib64', 'lib/sparcv9' or 'lib/64' (which is usually a symlink to 'lib/sparcv9'"
  )

install(TARGETS
  ${GNUAVL} 
  ${GNUAVL}_static
  LIBRARY DESTINATION ${LIB_SUB_DIR}
  ARCHIVE DESTINATION ${LIB_SUB_DIR}
)

# static libraries are usually not versioned
if(${VERSION_STATIC})
if(${UNIX} AND ${VERSION_STATIC})
  install(CODE "
    EXECUTE_PROCESS(COMMAND ln -sf lib${GNUAVL}.a lib${GNUAVL}.a.${LIB_VERSION_STRING}
                    COMMAND ln -sf lib${GNUAVL}.a lib${GNUAVL}.a.${LIB_VERSION_MAJOR}
         WORKING_DIRECTORY $ENV{DESTDIR}/${CMAKE_INSTALL_PREFIX}/${LIB_SUB_DIR}
    )
  ")
endif()
endif()

set(INCLUDE_SUB_DIR ${GNUAVL} CACHE STRING "e.g. gnuavl, as in include/gnuavl")
set(HEADERS
  bst.h
  avl.h
  rb.h
  tbst.h
  tavl.h
  trb.h
  rtbst.h
  rtavl.h
  rtrb.h
  pbst.h
  pavl.h
  prb.h
)

INSTALL(FILES ${HEADERS} DESTINATION include/${INCLUDE_SUB_DIR})

set(INFO_PAGES
  libavl.info 
  libavl.info-1  
  libavl.info-2 
  libavl.info-3
  libavl.info-4
)

INSTALL(FILES ${INFO_PAGES} DESTINATION share/info)

if(${UNIX})
  foreach(IFILE ${INFO_PAGES})
  install(CODE "
    EXECUTE_PROCESS(COMMAND gzip -f -9 ${IFILE}
         WORKING_DIRECTORY $ENV{DESTDIR}/${CMAKE_INSTALL_PREFIX}/share/info
    )
  ")
  endforeach()
endif()

set(DOC_FILES
  AUTHORS
  COPYING
  COPYING.DOC
  COPYING.LIB
  NEWS
  OUTLINE
  README
  ROADMAP
  THANKS
  TODO
)
INSTALL(FILES ${DOC_FILES} DESTINATION share/doc/lib${GNUAVL}-${LIB_VERSION_STRING})

enable_testing()

set(TESTS
  bst-test
  avl-test
  rb-test
  tbst-test
  tavl-test
  trb-test
  rtbst-test
  rtavl-test
  rtrb-test
  pbst-test
  pavl-test
  prb-test
)

foreach(TEST ${TESTS})
  add_executable(${TEST}
    ${TEST}.c
    test.c
  )
  target_link_libraries(${TEST}
    ${GNUAVL}_static
  )
  add_test(${TEST} ${TEST})
endforeach()

foreach(TEST bsts)
  add_executable(${TEST}
    ${TEST}.c
    test.c
  )
  target_link_libraries(${TEST}
    ${GNUAVL}_static
  )
endforeach()

set(EXTRA_TESTS
  seq-test
  bin-ary-test
  srch-test
)

foreach(TEST ${EXTRA_TESTS})
  add_executable(${TEST}
    ${TEST}.c
  )
endforeach()

add_custom_target(check COMMAND ${CMAKE_CTEST_COMMAND}
  DEPENDS
  ${TESTS}
)

