# CMake Overview:
# ---------------
# CMake is a cross-platform build system generator. Instead of writing
# platform-specific Makefiles (Linux/Unix) or project files (Windows),
# you write one CMakeLists.txt and CMake generates the appropriate build files.
# This makes it easier to build the same project on Linux, Windows, and macOS.

# Minimum version of CMake we require
# (3.15+ is safe and works across Linux, macOS, Windows)
cmake_minimum_required(VERSION 3.15)

# Project name and language
project(mariolab LANGUAGES CXX)

# ---- C++ standard ----
# Require C++17, disable compiler-specific extensions (so code is portable).
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

# ---- Build type ----
# If the user didn’t set a build type (like Debug/Release),
# default to Release (optimized).
if(NOT CMAKE_BUILD_TYPE AND NOT CMAKE_CONFIGURATION_TYPES)
  set(CMAKE_BUILD_TYPE Release CACHE STRING "Build type" FORCE)
endif()

# ---- Collect source files ----
# Look for all .cpp files under src/ folder.
# CONFIGURE_DEPENDS tells CMake to re-check when new files are added.
file(GLOB SRC_FILES CONFIGURE_DEPENDS "${CMAKE_SOURCE_DIR}/src/*.cpp")

# ---- Define the program ----
# Create an executable named "mariolab" from those sources.
add_executable(mariolab ${SRC_FILES})

# ---- Compiler warnings and optimizations ----
if(MSVC)  # Microsoft Visual C++ compiler (Windows)
  # /W4 = show lots of warnings
  # /permissive- = force stricter C++ standard compliance
  target_compile_options(mariolab PRIVATE /W4 /permissive-)
else()    # GCC or Clang (Linux, macOS, MinGW, LLVM)
  # -Wall -Wextra = show lots of warnings
  target_compile_options(mariolab PRIVATE -Wall -Wextra)

  # Add -O2 (optimize) in Release builds (CMake already sets -O3 sometimes,
  # but this matches your original Makefile more closely).
  target_compile_options(mariolab PRIVATE
    $<$<CONFIG:Release>:-O2>
  )
endif()

# ---- Platform niceties ----
# On macOS/Linux, enable "rpath" so executables can find shared libraries easily.
set(CMAKE_MACOSX_RPATH ON)

# On Windows, define UNICODE macros so wide-character APIs are enabled.
if(MSVC)
  target_compile_definitions(mariolab PRIVATE UNICODE _UNICODE)
endif()

# Enable position independent code (good practice if later building shared libs).
set(CMAKE_POSITION_INDEPENDENT_CODE ON)

