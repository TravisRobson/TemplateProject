#!/usr/bin/env bash
################################################################################
# 
# 
################################################################################

set -o errexit # Abort upon nonzero exit status
set -o pipefail # Don't hide errors in pipes

red="\033[31m"
green="\033[32m"
blue="\033[34m"
reset="\033[0m"
bold="\033[1m"


# Use with sed -nre to grab the version from commands.
# https://superuser.com/questions/363865/how-to-extract-a-version-number-using-sed
get_version_string='s/^[^0-9]*(([0-9]+\.)*[0-9]+).*/\1/p'


################################################################################
# Report a message in a given color 
################################################################################
function message() {
  if [ $1 == INFO ]; then
    printf "${green}-- INFO $2${reset}\n"
  elif [ $1 = ERROR ]; then
    printf "${red}-- ERROR $2${reset}\n"
  else 
    essage ERROR "Invalid message() type."
  fi
}


function clean() {
  rm -rf build bin lib include
}


function runTests() {
  ctest
}


function runDriver() {
  if [ $install == true ]; then
    popd
    echo "" # Give some space between driver output and this script's output.
    ./bin/driver
  else
    pushd src > /dev/null
    echo "" # Give some space between driver output and this script's output.
    ./driver
  fi
}


################################################################################
# Default options
################################################################################
cmake_build_type=Debug
cmake_verbose_makefile=OFF
build_tests=OFF
install=false
run_tests=false
run_driver=true


# <INSTALL> indicates optional install path, I need to figure out how to support with command line options
usage="Configure CMake build, compile code, execute driver.
usage:
  $(basename "$0") [ -h | --help ] 
                   [ -i | --install <INSTALL> ] 

options:

  build rules & envirnoment:
    -i, --install       Install the project.
    -r, --release       Compile in Release mode (default mode is Debug).
    --build-tests       Build tests.
    -v, --verbose       Display verbose Make commands.
  
  other:
    -c, --clean         Clean up everything produced by this project.
    -d, --driver        Run the driver.
    -h, --help          Display this help message.
    -t, --test          Run the tests.
"

################################################################################
# Process command line options
################################################################################
while [[ $# -gt 0 ]]; do
  case $1 in 
    # build rules & environment
    --build-tests) build_tests=true ;;
    -i|--install) install=true;;
    -r|--release) cmake_build_type=Release ;;
    -v|--verbose) cmake_verbose_makefile=ON ;;

    # other
    -c|--clean) clean ; message INFO "Project cleaned" ; exit 0 ;;
#    -d|--driver)
    -h|--help) echo "$usage" ; exit 0 ;;
    -t|--test) run_tests=true ; run_driver=false build_tests=true ;;
    *) message ERROR "Unknown option: $1" ; printf "${red}$usage${reset}\n" >&2 ; exit 1 ;;
  esac
  shift
done 
message INFO "Processed command line options."


################################################################################
# Environment checks
################################################################################
if [ !command -v cmake &> /dev/null ]; then
  # Above if
  message ERROR "CMake not found."
  exit 1
else
  version=$(cmake --version | sed -nre ${get_version_string})
  message INFO "CMake found, version $version"
fi

# Create build/ if it doesn't exist.
[ ! -d build ] && mkdir build
pushd build > /dev/null

# Configure the CMake build
cmake -G "Unix Makefiles" \
  -D CMAKE_BUILD_TYPE=$cmake_build_type \
  -D CMAKE_VERBOSE_MAKEFILE:BOOL=$cmake_verbose_makefile \
  -D CMAKE_INSTALL_PREFIX=.. \
  -D BUILD_TESTS=$build_tests \
  ..

# Compile the codebase
if [ $install == true ]; then
  # To uninstall https://stackoverflow.com/a/44649542
  make -j install --no-print-directory # --no-print silences cd'ing that CMake does.
else
  make -j --no-print-directory # --no-print silences cd'ing that CMake does.
fi

[ $run_tests == true ] && runTests
[ $run_driver == true ] && runDriver

