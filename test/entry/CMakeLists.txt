#putting test in bin/test
# We redefine the normal get_target_function to get Must fail message and add to test suit
FUNCTION(get_entry_target path name)
	add_executable(${name} ${path})
	target_link_ring(${name})
	add_test(NAME ${name} COMMAND ${name} WORKING_DIRECTORY ${DATA_TEST_DIR})

	if (${name_without_extension} MATCHES ".*_WF")
		message ("\t${path} (Must fail)")
		set_tests_properties(${name_without_extension} PROPERTIES WILL_FAIL TRUE)
	else()
		message ("\t${path}")
	endif()
ENDFUNCTION()
ring_entries("Test executable")


#List additionnals dependencies of test here:

#add_dependencies(executor child-buf-controle)

#managing special dependencies
#add_dependencies (integration authbreak)#integration test must provoke recompiling the soft



