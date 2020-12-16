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




cmake_minimum_required(VERSION 3.12)#TESTS

#Common use functions
include(build-helpers/utils.cmake) # general purpose stuff
include(build-helpers/sources.cmake) # Intense globbing functions
include(build-helpers/find_lib.cmake) # Getting external libs func
include(build-helpers/rings.cmake) # ring stuff


# Set global variables
include(build-helpers/cmake_git.cmake) # Retrieving BRANCH_NAME


#MODIFY THESES---------------------------------------------------
if(${BRANCH_NAME} MATCHES  dev|totobranch)
	message ("Skipping test build") 
	set (BUILD_TEST OFF)
else()
	set (BUILD_TEST ON)
	set (CMAKE_BUILD_TYPE Debug) 

endif()

project(ull C )

# Control external lib dependencies from the system. 
set_if_not_set(LIB_FROM_SYSTEM_code "")
set_if_not_set(LIB_FROM_SYSTEM_test "omptatattata;OpenMP")
set_if_not_set(LIB_FROM_SYSTEM_perf "eprof")

# Set the list of extensions you recognize as headers
set_if_not_set(HEADER_EXTENSIONS "h") 
# Set the list of extensions you recognize as source 
set_if_not_set(SOURCE_EXTENSIONS "c") 
set_if_not_set(PROJECT_NAME ULL)
set_if_not_set (version 0.6)

# Used on targets to avoid collisions
set_if_not_set( RING_PREFIX_code "")
set_if_not_set( RING_PREFIX_test "test-")
set_if_not_set( RING_PREFIX_perf "perf-")
#lib prefix are automatically prepended with lib- for libraries targets (not result file). Prefix have no effect if you set RENAME_ENTRY/LIB on a particular entry. 

# Default libraries modes. Set to STATIC or SHARED (SHARED should reduce build time)
set_if_not_set (INTERNAL_LIB_MODE SHARED)

# Uncomment to put a particular ring as static
#set_if_not_set (INTERNAL_LIB_MODE_code STATIC)
#set_if_not_set (INTERNAL_LIB_MODE_test STATIC)
#set_if_not_set (INTERNAL_LIB_MODE_perf STATIC)
#set_if_not_set (INTERNAL_LIB_MODE_EXT_SRC_perf STATIC) # You can controle the external sources mode as well for each rings
#set_if_not_set (INTERNAL_LIB_MODE_code_ub_lib1 STATIC) # Or a sublib of a particular code



# Mode of the installed version of libraries. Can be:
#STATIC
#SHARED
#NO: dont install
#SAME the mode of the lib will be the same as the INTERNAL_LIB_MODE 
set_if_not_set (INSTALL_LIB_MODE NO)
#set_if_not_set (INSTALL_LIB_MODE_code STATIC)
#set_if_not_set (INSTALL_LIB_MODE_test SHARED)
#set_if_not_set (INSTALL_LIB_MODE_perf SAME)
#set_if_not_set (INSTALL_LIB_MODE_code_sub_lib1 STATIC) # Or a sublib of a particular code


# Uncomment one or both of thoses line to install a whole ring on the system (Never tested, I dont know what will be the mode of installed libs)
#set_if_not_set (INSTALL_RING_code my_lib_name) 
#set_if_not_set (INSTALL_RING_test my_lib_name)
#set_if_not_set (INSTALL_RING_perf my_lib_name)


# DEFAULT install rules of entries: 
# Yes: exec.c -> prefix + exec
# evaluate to false: dont_install
set_if_not_set (INSTALL_ENTRY_code YES) 
set_if_not_set (INSTALL_ENTRY_test NO)
set_if_not_set (INSTALL_ENTRY_perf NO)
set_if_not_set (INSTALL_ENTRY_code_entry3 NO) # Uncomment to disable installation of entry entry3 from the code ring

# RENAME targets (use on libs/entries to avoid targets collisions). This wont use the ring prefix. You can use this feature to activate names based functionnalities of generators. For exemple, on make wont print targets starting with __ in the help
# Evaluate to False: dont rename
set_if_not_set (RENAME_ENTRY_code_entry1 my_super_exec) 
set_if_not_set (RENAME_LIB_code_lib1 my_super_lib) 







# PERF ring  kvhf related

# Comment to not allow gone keys
set (perf-allow-gone ON)

# List to name of executable you want to monitor the size in the perfs
set (perf-exec_to_mesurate_size "exec1;perf-empty")




#STOP-MODIFY----------------------------------------------------------

# Need to include after project call
include(GNUInstallDirs) #system headers place
set_if_not_set (SOURCELIBDIR ${CMAKE_BINARY_DIR}/backend_libs)
set_if_not_set (DATA_TEST_DIR ${CMAKE_SOURCE_DIR}/rings/test/data) 
set_if_not_set (DATA_PERF_DIR ${CMAKE_SOURCE_DIR}/rings/perf/data) 



#Setting compilation options
set(CMAKE_C_FLAGS_DEBUG "-ggdb3 -fdiagnostics-color=always")
set(CMAKE_C_FLAGS "-fdiagnostics-color=always")

#allow C programs to get the version
add_definitions("-D${PROJECT_NAME}_VERSION=${version}")

set_property(GLOBAL PROPERTY LIB_FROM_SYSTEM_test ${LIB_FROM_SYSTEM_test})
set_property(GLOBAL PROPERTY LIB_FROM_SYSTEM_code ${LIB_FROM_SYSTEM_code})
set_property(GLOBAL PROPERTY LIB_FROM_SYSTEM_perf ${LIB_FROM_SYSTEM_perf})



# Configure 
add_subdirectory(build-helpers/configure)
#if we are not in master, we need to us templates to fill some files for master

# Building main executable if there is and getting all src in a library
add_subdirectory(rings/code)


##### TEST 
if(CMAKE_PROJECT_NAME STREQUAL PROJECT_NAME AND BUILD_TEST)
include (CTest)
set(VALGRIND_COMMAND_OPTIONS "--error-exitcode=100")

#Getting rings for developpers 
add_subdirectory(rings/test)

add_subdirectory(rings/perf)



endif()


