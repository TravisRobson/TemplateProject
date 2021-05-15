

#include <iostream>

#include "template.hpp"


int main(int argc, char* argv[]) {

  std::cout << argv[0] << " version " << Template_VERSION << "\n";

  std::cout << "Usage:\n";
  std::cout << argv[0] << " [-h]";
  std::cout << std::endl;


  temp::dummy();


  std::cout << "Template driver completed.\n";
  return 0;

}

