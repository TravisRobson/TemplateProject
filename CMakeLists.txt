# A useful resource has been
# https://cmake.org/cmake/help/latest/guide/tutorial/index.html#id1

cmake_minimum_required(VERSION 3.10)

# grab version from CHANGELOG.md
execute_process(COMMAND bash -c "cat ../CHANGELOG.md | sed -nre 's/^[^0-9]*(([0-9]+\.)*[0-9]+).*/\\1/p'"
  OUTPUT_VARIABLE version)
string(STRIP ${version} version)

project(Template VERSION ${version} LANGUAGES CXX)

option(BUILT_TESTS "Build tests" OFF)

if (BUILD_TESTS)
  enable_testing()
endif()

# specify the C++ standard
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED True)

add_subdirectory(src)

