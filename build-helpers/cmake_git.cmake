find_package (Git)
if (GIT_FOUND)
	message("Found git ${GIT_VERSION_STRING}")
	execute_process(
			COMMAND ${GIT_EXECUTABLE} rev-parse --abbrev-ref HEAD
			RESULT_VARIABLE git_res
			OUTPUT_VARIABLE BRANCH_NAME
			OUTPUT_STRIP_TRAILING_WHITESPACE
)

	if(${git_res} EQUAL 0)
		message("\tDetected branch name: ${BRANCH_NAME}")
	else()
		message("Could not detect branch name. Is the project versionned?")
		unset (BRANCH_NAME)
	endif()

else()
	message ("Cant find git, Could not detect branch name.")
endif (GIT_FOUND)
# Cleaning mess
unset(git_res) 

