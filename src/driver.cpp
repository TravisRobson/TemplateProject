

#include <iostream>
#include <stdexcept>
#include <string>

#include "template.hpp"

void usage();
void process_args(int argc, char* argv[]);

int main(int argc, char* argv[]) {

  std::cout << argv[0] << " version " << Template_VERSION << "\n";

  try {
    process_args(argc, argv);
    temp::dummy();
    std::cout << "Template driver completed.\n";
  } catch (std::exception& err) {
    std::cerr << "Exception caught in main: " << err.what() << "\n";
    return 1;
  } catch (...) {
    std::cerr << "Unknown exception caught in main.\n";
    return 1;
  }
  
  return 0;

}


void usage(char* argv[]) {

  std::cout << "Usage:\n";
  std::cout << "\t" << argv[0] << " [ -h | --help ]\n";
  std::cout << "\n";
  std::cout << "Options:\n";
  std::cout << "  -h, --help     Display this usage message.\n";
  std::cout << "\n";

}

void process_args(int argc, char* argv[]) {

  for (int i = 1; i < argc; ++argc) {

    std::string arg(argv[i]);
    if (arg == "-h" || arg == "--help") {
      usage(argv);
      exit(0);
    }
    else {
      throw std::runtime_error("Invalid argument: " + arg);
    }

  }

}

