if ( ${CMAKE_SOURCE_DIR} STREQUAL ${CMAKE_BINARY_DIR} )
	message( FATAL_ERROR "In-source builds not allowed. Run cmake .. into the build directory. You need to remove CMakeFiles and CMakeCache.txt as it can not be done automatically inside the CMakeList. run:
	rm CMakeCache.txt
	rm -rf CMakeFiles	
	" )
	# Does not work
    file(REMOVE_RECURSE CMakeFiles)
    file(REMOVE CMakeCache.txt)
endif()

#TODO set it to the real value
cmake_minimum_required(VERSION 3.12)#TESTS
set (auto_cmake_dir ${CMAKE_SOURCE_DIR}/.auto-cmake)

# Set git variables
include(${auto_cmake_dir}/cmake_git.cmake) # Retrieving BRANCH_NAME

# Common use functions
include(${auto_cmake_dir}/utils.cmake) # general purpose stuff
include(${auto_cmake_dir}/sources.cmake) # Source globbing functions
include(${auto_cmake_dir}/find_lib.cmake) # Getting external libs func


# Configure project
include(${auto_cmake_dir}/configure.cmake)


