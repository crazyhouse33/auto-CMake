#putting test in bin/test
set(EXECUTABLE_OUTPUT_PATH ${PROJECT_SOURCE_DIR}/bin/test)

message("\nTests exe discovery:\n")
file(GLOB_RECURSE TESTS CONFIGURE_DEPENDS *.c)
foreach(file ${TESTS})
  message ("\t${file} detected as a test to compile")
  get_filename_component (name_without_extension ${file} NAME_WE)
  add_executable(${name_without_extension} ${file})
  target_link_libraries(${name_without_extension} TEST_INTERN_SRC INTERN_SRC)
  add_test(NAME ${name_without_extension} COMMAND ${name_without_extension} WORKING_DIRECTORY ${DATA_TEST_DIR})
endforeach()


#listing dependencies of test 
#add_dependencies(executor child-buf-controle)

#managing special dependencies
#add_dependencies (integration authbreak)#integration test must provoke recompiling the soft



