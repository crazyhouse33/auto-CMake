#putting test in bin/test
# We redefine the normal get_target_ macro to get must fail message and add to test suit

FUNCTION(get_entry_target_name name new_name)
	set (${new_name} "test-${name}" PARENT_SCOPE) 
ENDFUNCTION()

FUNCTION(get_entry_target path exec_name)
	add_executable(${exec_name} ${path})
	target_link_ring(${exec_name})
	add_test(NAME ${exec_name} COMMAND ${exec_name} WORKING_DIRECTORY ${DATA_TEST_DIR})

	# Adding to the list of test for the lazytest cmake file
	get_property(TESTS GLOBAL PROPERTY ALL_TESTS )
	LIST (APPEND TESTS ${exec_name})
	set_property( GLOBAL PROPERTY ALL_TESTS ${TESTS})

	# Removing sucess markers when rebuild
	add_custom_command(TARGET ${exec_name}
		POST_BUILD
		COMMAND ${CMAKE_COMMAND} -E rm -f "${marker_memory_dir}/${exec_name}${marker_suffix}" "${marker_normal_dir}/${exec_name}${marker_suffix}"
		COMMENT "${exec_name} target outdated, removing success markers"
		)
	
	#Formatting will fail diferently
	if (${name} MATCHES ".*_WF")
		message ("\t${path} (Must fail)")
		set_tests_properties(${exec_name} PROPERTIES WILL_FAIL TRUE)
	else()
		message ("\t${path}")
	endif()

		



	#set (${to_install} ${name} PARENT_SCOPE) # It does not make sens to install the tests
ENDFUNCTION()


# This call the previous function
ring_entries("Test executable" ${DATA_TEST_DIR})

#List additionnals dependencies of test here:

#add_dependencies(executor child-buf-controle)

#managing special dependencies
#add_dependencies (integration authbreak)#integration test must provoke recompiling the soft

