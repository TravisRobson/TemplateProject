# A useful resource has been
# https://cmake.org/cmake/help/latest/guide/tutorial/index.html#id1

cmake_minimum_required(VERSION 3.10)

# grab version from CHANGELOG.md
execute_process(COMMAND bash -c "cat ../CHANGELOG.md | sed -nre 's/^[^0-9]*(([0-9]+\.)*[0-9]+).*/\\1/p'"
  OUTPUT_VARIABLE version)
string(STRIP ${version} version)

project(Template VERSION ${version} LANGUAGES CXX)

option(BUILT_TESTS "Build tests" OFF)


# https://cliutils.gitlab.io/modern-cmake/chapters/projects/submodule.html
find_package(Git)
if (GIT_FOUND AND EXISTS "${PROJECT_SOURCE_DIR}/.git")
  option(GIT_SUBMODULE "Checkout submodules during build" ON)
  if (GIT_SUBMODULE)
    message(STATUS "Submodule updated")
    execute_process(COMMAND ${GIT_EXECUTABLE} submodule update --init --recursive
      WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
      RESULT_VARIABLE GIT_SUBMOD_RESULT)
    if (NOT GIT_SUBMOD_RESULT EQUAL "0")
      message(FATAL_ERROR "git submodule update --init failed with ${GIT_SUBMOD_RESULT}, please checkout submodules.")
    endif()
  endif()
endif()

if (NOT EXISTS "${PROJECT_SOURCE_DIR}/extern/googletest/CMakeLists.txt")
  message(FATA_ERROR "The submodules were not downloaded! GIT_SUBMODULE option was turned off or \
failed. Please update submodules and try again.")
endif()


if (BUILD_TESTS)
  enable_testing()
  add_subdirectory(extern/googletest)
  include(GoogleTest)
  message(STATUS "Included Google Test")
endif()


# specify the C++ standard
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED True)

add_subdirectory(src)

