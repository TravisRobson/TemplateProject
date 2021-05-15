

configure_file( template.hpp.in template.hpp)

add_library(template
  template.cpp
  )

target_compile_definitions(template
  PRIVATE
    $<$<CONFIG:Debug>:DEBUG>   # For debug_print in utils.hpp
  )

target_include_directories(template
  PUBLIC
    ${CMAKE_CURRENT_BINARY_DIR} # So that code compiles and runs in build tree
  )

install(TARGETS template DESTINATION lib)
install(FILES
  "${CMAKE_CURRENT_BINARY_DIR}/template.hpp"
  DESTINATION include
  )


add_executable(driver driver.cpp)
target_link_libraries(driver PUBLIC template)
install(TARGETS driver DESTINATION bin)


if (BUILD_TESTS)
  add_test(NAME driver_completes COMMAND driver)
  set_tests_properties(driver_completes PROPERTIES PASS_REGULAR_EXPRESSION "completed")
endif()

