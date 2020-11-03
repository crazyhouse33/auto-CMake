# This provide a new target lazy-test which:
# 1-Lazy recompile before testing.
# 2-Lazy testing (run only failed previous failed test or changed test / code depency)
# If you have a large test suite, this target will save you a crazy amount of time 

if (PYTHONINTERP_FOUND)

# Make make test also create a timestamp

#TODO CMAKE_TESTING_ENABLED check that


set(test_timestamp_file ${CMAKE_BINARY_DIR}/ts-since-lazy-test)
set(full_test_timestamp_file ${CMAKE_BINARY_DIR}/ts-since-full-test)

##TODO replace target all by tests only
#
add_custom_target(build-tests
	DEPENDS ${list_mandatory_tests} ${list_lazy_tests}
	COMMENT "Compile all tests"
)


add_custom_target(lazy-test
                  COMMAND ${PYTHON_EXECUTABLE} ${CMAKE_SOURCE_DIR}/build-helpers/lazy-test-cache.py --lazy ${list_lazy_tests} --mandatory ${list_mandatory_tests} --ctestPath ${CMAKE_CTEST_COMMAND} --cmakePath ${CMAKE_COMMAND}                  WORKING_DIRECTORY ${CMAKE_BINARY_DIR} 
		  COMMENT "Recompile modified dependency of project run the test that changed since since lastlazy/full/all test and the ones that failed previously"
		  VERBATIM
                  USES_TERMINAL
                  )

# This one test the full build process including the generator, and memory checks
add_custom_target(full-test

                  COMMAND ${CMAKE_CTEST_COMMAND} --build-and-test ${CMAKE_SOURCE_DIR} ${CMAKE_BINARY_DIR} --build-generator ${CMAKE_GENERATOR} --build-target all --test-command ${CMAKE_CTEST_COMMAND} -T memcheck
                  WORKING_DIRECTORY "${CMAKE_BINARY_DIR}" 
		  COMMENT "Force recreation of generator, recompilation of everything, and run every test with memcheck"
		  VERBATIM
                  USES_TERMINAL
                  )

add_custom_target(mem-test

                  COMMAND ${CMAKE_CTEST_COMMAND} -T memcheck
                  WORKING_DIRECTORY "${CMAKE_BINARY_DIR}" 
		  COMMENT "Check memory with valgrind"
		  VERBATIM
                  USES_TERMINAL
                  )

#adding some timestamp on test for the cache to check
#This is gonna overide the default test target (=run all test without compiling) so we can add a timestamp (fighting cmake)
#TODO try to use add_custom_command instead. Rn the timestamp are added even if the command failed, leading to bugs
#
ADD_CUSTOM_TARGET (
    all-test 
    COMMAND ${CMAKE_CTEST_COMMAND} # Run all test
    VERBATIM
)



#TODO for loop
add_custom_command(TARGET full-test
                   POST_BUILD
                   COMMAND ${CMAKE_COMMAND} -E touch ${test_timestamp_file}
                   WORKING_DIRECTORY ${CMAKE_BINARY_DIR} 
                   COMMENT "Actualizing timestamp for test session"
		   VERBATIM)

add_custom_command(TARGET lazy-test
                   POST_BUILD
                   COMMAND ${CMAKE_COMMAND} -E touch ${test_timestamp_file}
                   WORKING_DIRECTORY ${CMAKE_BINARY_DIR} 
                   COMMENT "Actualizing timestamp for test session"
		   VERBATIM)

add_custom_command(TARGET all-test
                   POST_BUILD
                   COMMAND ${CMAKE_COMMAND} -E touch ${test_timestamp_file}
                   WORKING_DIRECTORY ${CMAKE_BINARY_DIR} 
                   COMMENT "Actualizing timestamp for test session"
		   VERBATIM)

add_custom_command(TARGET full-test
                   POST_BUILD
                   COMMAND ${CMAKE_COMMAND} -E touch ${full_test_timestamp_file}
                   WORKING_DIRECTORY ${CMAKE_BINARY_DIR} 
                   COMMENT "Actualizing timestamp for full test session"
		   VERBATIM)

add_custom_command(TARGET all-test
                   POST_BUILD
                   COMMAND ${CMAKE_COMMAND} -E touch ${full_test_timestamp_file}
                   WORKING_DIRECTORY ${CMAKE_BINARY_DIR} 
                   COMMENT "Actualizing timestamp for full test session"
		   VERBATIM)


add_dependencies(all-test build-tests ) #forcing re compilation before tests
add_dependencies(mem-test build-tests ) #forcing re compilation before tests


endif()
