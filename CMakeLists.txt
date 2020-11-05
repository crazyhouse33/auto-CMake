# Protection to not mess up sources
if ( ${CMAKE_SOURCE_DIR} STREQUAL ${CMAKE_BINARY_DIR} )
	message( FATAL_ERROR "In-source builds not allowed. Run cmake .. into the build directory. You need to remove CMakeFiles and CMakeCache.txt as it can not be done automatically inside the CMakeList. run:
	rm CMakeCache.txt
	rm -rf CMakeFiles	
	" )
	# Does not work
    file(REMOVE_RECURSE CMakeFiles)
    file(REMOVE CMakeCache.txt)
endif()



# AUTODETECTED Sources:
# code/src is for internal source lib -> INTERN_SRC
# test/src is sources shared by all tests -> TEST_INTERN_SRC
# extern/normal/src is to get sources of externals projects -> EXT_SRC
# extern/test/src is the same but will be used only by tests -> EXT_TEST_SRC
# test/needed/*.c refer to external executable to compile needed by test and dont use sources

# What are the produced lib and exec?

#CREATING EXE
	# Every code/entry/*.c is an instalable executable linked against INTERN_SRC PUBLISHED_INTERL_SRC EXT_SRC
	# Each test/*.c (Not in a special folder) is a test executable linked against TEST_INTERN_SRC INTERN_SRC EXT_SRC EXT_TEST_SRC

#CREATING LIB
	#INSTALL_SOURCES_AS_SHARED(STATIC)_LIB variable, if set, this will include your sources in the instalable stuff as a library(make install)


cmake_minimum_required(VERSION 3.9)

#Common use functions
include(build-helpers/cmakefunc.cmake) # Intense globbing functions
include(build-helpers/cmake_dependencies_set_up.cmake) # Getting external libs func
include(build-helpers/cmake_git.cmake) # Retrieving BRANCH_NAME


#MODIFY THESES---------------------------------------------------
if(${BRANCH_NAME} MATCHES  dev|totobranch)
	message ("Skipping test build") 
	set (BUILD_TESTING OFF)
else()
	set (BUILD_TESTING ON)
	set (CMAKE_BUILD_TYPE Debug) 

endif()

project(ull C )
set_if_not_set(PROJECT_NAME ULL)
set_if_not_set (version 0.6)

# Set to STATIC or SHARED (SHARED will reduce compile time)
set_if_not_set (INTERAL_LIBS_MODE SHARED)

# Uncomment one or both of thoses line to render publish your internals sources to the system as a static or shared LIB
#set_if_not_set (INSTALL_SOURCES_AS_STATIC_LIB my_static_lib_name)
#set_if_not_set (INSTALL_SOURCES_AS_SHARED_LIB my_shared_lib_name)

# Control external lib dependencies from the system. 
set_if_not_set(LIB_FROM_SYSTEM  "")
set_if_not_set(LIB_FROM_SYSTEM_TEST "omptatattata;OpenMP")

#STOP-MODIFY----------------------------------------------------------

set_if_not_set (SOURCELIBDIR ${CMAKE_BINARY_DIR}/backend_libs)
set_if_not_set (DATA_TEST_DIR ${CMAKE_SOURCE_DIR}/test/data) 



#Setting compilation options
set(CMAKE_C_FLAGS_DEBUG "-ggdb3 -fdiagnostics-color=always")
set(CMAKE_C_FLAGS "-fdiagnostics-color=always")

#allow C programs to get the version
add_definitions("-D${PROJECT_NAME}_VERSION=${version}")

set_property(GLOBAL PROPERTY EXTERNAL_LIBS_FROM_PROJECT)
set_property(GLOBAL PROPERTY EXTERNAL_LIBS_TEST_FROM_PROJECT)

set_property(GLOBAL PROPERTY LIB_FROM_SYSTEM_TEST ${LIB_FROM_SYSTEM_TEST})
set_property(GLOBAL PROPERTY LIB_FROM_SYSTEM ${LIB_FROM_SYSTEM})



# Configure 
add_subdirectory(build-helpers/configure)
#if we are not in master, we need to us templates to fill some files for master




# Getting external projects sources in another lib
add_subdirectory(extern)



# Including other libs
#add_subdirectory(${CMAKE_CURRENT_SOURCE_DIR}/extern/normal/lib/eprof/libs/C)

# Building main executable if there is and getting all src in a library
add_subdirectory(code)




##### TEST 
if(CMAKE_PROJECT_NAME STREQUAL PROJECT_NAME AND BUILD_TESTING)
include (CTest)
set(VALGRIND_COMMAND_OPTIONS "--error-exitcode=100")

#Getting shared source for tests in a lib
add_subdirectory(test)
add_subdirectory(perfs)

endif()


