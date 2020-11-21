# This provide a lazy-test which:
# 1. Compile necessary tests (Change in src or tests)
# 2. Lazy testing (run only failed previous failed test or changed test / code depency)
# If you have a large test suite, this target will save you a crazy amount of time 
SET(Python_ADDITIONAL_VERSIONS 3 3.6 3.5 3.4 3.3 3.2 3.1 3.0)
find_package(PythonInterp) # The building process use python to provide lazy-testing

if (PYTHONINTERP_FOUND)


	# BUILD tests only targets

	get_property(TESTS GLOBAL PROPERTY ALL_TESTS )
	add_custom_target(build-tests
		DEPENDS ${TESTS}
		COMMENT "Compile all tests"
		)

	# LAZY test target

	postfix( "${TESTS}" ${marker_suffix} lazy_test_depends)  
	prefix( "${lazy_test_depends}" "${marker_normal_dir}/" lazy_test_depends )  

	add_custom_command(OUTPUT ${lazy_test_depends}
		COMMAND ${PYTHON_EXECUTABLE} ${CMAKE_SOURCE_DIR}/build-helpers/lazy-test-cache.py -v ${TESTS} --ctestPath ${CMAKE_CTEST_COMMAND} --marks-dir ${marker_normal_dir}
		DEPENDS ${TESTS}
		COMMENT "Run all test that need to be run"
		WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
		)

	add_custom_target(lazy-test
		DEPENDS ${lazy_test_depends}
		)

	# Lazy memory test target

	postfix( "${TESTS}" ${marker_suffix} lazy_test_mem_depends )  
	prefix( "${lazy_test_mem_depends}" "${marker_memory_dir}/" lazy_test_mem_depends )  
	add_custom_command(OUTPUT ${lazy_test_mem_depends}
		COMMAND ${PYTHON_EXECUTABLE} ${CMAKE_SOURCE_DIR}/build-helpers/lazy-test-cache.py -v ${TESTS} --ctestPath ${CMAKE_CTEST_COMMAND} --marks-dir ${marker_memory_dir} -o \"-T memcheck\"
		COMMENT "Run all memory test that need to be run"
		DEPENDS ${TESTS}
		WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
		)

	add_custom_target(lazy-mem-test
		DEPENDS ${lazy_test_mem_depends}
		)



	# This one test the full build process including the generator, and memory checks
	add_custom_target(full-test

		COMMAND ${CMAKE_CTEST_COMMAND} --build-and-test ${CMAKE_SOURCE_DIR} ${CMAKE_BINARY_DIR} --build-generator ${CMAKE_GENERATOR} --build-target all --test-command ${CMAKE_CTEST_COMMAND} -T memcheck
		WORKING_DIRECTORY "${CMAKE_BINARY_DIR}" 
		COMMENT "Force recreation of generator, recompilation of everything, and run every test with memcheck"
		VERBATIM
		USES_TERMINAL
		)
endif()





