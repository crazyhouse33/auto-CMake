#putting test in bin/test
# We redefine the normal get_target_ macro to get must fail message and add to test suit
FUNCTION(get_entry_target path name)
	set (exec_name "test-${name}")
	add_executable(${exec_name} ${path})
	target_link_ring(${exec_name})
	add_test(NAME ${exec_name} COMMAND ${exec_name} WORKING_DIRECTORY ${DATA_TEST_DIR})

	if (${name} MATCHES ".*_WF")
		message ("\t${path} (Must fail)")
		set_tests_properties(${exec_name} PROPERTIES WILL_FAIL TRUE)
	else()
		message ("\t${path}")
	endif()
	#set (${to_install} ${name} PARENT_SCOPE) # It does not make sens to install the tests
ENDFUNCTION()

ring_entries("Test executable")


#List additionnals dependencies of test here:

#add_dependencies(executor child-buf-controle)

#managing special dependencies
#add_dependencies (integration authbreak)#integration test must provoke recompiling the soft



