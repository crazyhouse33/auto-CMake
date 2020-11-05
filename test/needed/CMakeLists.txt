#putting test in bin/test
set(EXECUTABLE_OUTPUT_PATH ${DATA_TEST_DIR}/bin)

message("\nExternal executable needed by tests:\n")

#compile ext-test ones, which are just unrelated programs
file(GLOB_RECURSE TEST_DEPENDENCIES CONFIGURE_DEPENDS *.c)
foreach(file ${TEST_DEPENDENCIES})
	message(\t${file})
	get_filename_component (name_without_extension ${file} NAME_WE)
  	add_executable(${name_without_extension} ${file})
	target_link_libraries(${name_without_extension} TEST_INTERN_SRC INTERN_SRC)
endforeach()

#listing dependencies of test 
#add_dependencies(executor child-buf-controle)

#managing special dependencies
#add_dependencies (integration authbreak)#integration test must provoke recompiling the soft



