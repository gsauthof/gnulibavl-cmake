set(CMAKE_VERBOSE_MAKEFILE  true
  CACHE BOOL   "be verbose by default")
set(CMAKE_BUILD_TYPE        Release
  CACHE STRING "Debug, Release ... built type" )
set(CMAKE_C_FLAGS_INIT      "-m32"
  CACHE STRING "default init for cflags")
set(CMAKE_C_FLAGS_RELEASE   "-xO3"
  CACHE STRING "default for release mode")
