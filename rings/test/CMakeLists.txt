# We redefine the normal get_target function to get must fail message and add to test suit

FUNCTION(get_entry_target path exec_name)
	add_executable(${exec_name} ${path})
	target_link_ring(${exec_name})
	add_test(NAME ${exec_name} COMMAND ${exec_name} WORKING_DIRECTORY ${RING_ENTRY_BIN_OUTPUT_test})

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

ENDFUNCTION()


# Places of markers for lazy testing (used by entry and lazy_testing cmake files)
set (marker_dir ${CMAKE_BINARY_DIR}/markers/test_succeed)
set (marker_normal_dir ${marker_dir}/normal)
set (marker_memory_dir ${marker_dir}/memory)
set (marker_suffix "_succeed.marker")

set(VALGRIND_COMMAND_OPTIONS "--error-exitcode=100")


init_ring(test "Test executables")

#Adittional usefull test targets
include(${CMAKE_SOURCE_DIR}/.auto-cmake/cmake_lazy_testing_targets.cmake) # need to be after test discovery




