# In this file you specify the orders of the rings to use during the build. In this exemple, dev rings are not included if the detected branch is master.

if(${BRANCH_NAME} MATCHES  master|another_branch)
	message ("Skipping test build") 
	set (BUILD_TEST OFF)
	set (BUILD_PERF OFF)
else()
	set (BUILD_TEST ON)
	set (BUILD_PERF ON)
	set (CMAKE_BUILD_TYPE Debug) 

endif()

# We always use rings/code
add_subdirectory(rings/code)

if(CMAKE_PROJECT_NAME STREQUAL PROJECT_NAME) 
	if(BUILD_TEST)
		include (CTest) # This must be her since it must be before add_subdirectory
		add_subdirectory(rings/test)
	endif()

	if (BUILD_PERF)
		add_subdirectory(rings/perf)
	endif()

endif()





