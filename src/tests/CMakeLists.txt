

add_executable(TemplateTests
  TemplateTests.cpp
  )

target_link_libraries(TemplateTests PUBLIC gtest gtest_main)
install(TARGETS TemplateTests DESTINATION bin)

add_test(NAME google_tests COMMAND TemplateTests --gtest_color=yes)
