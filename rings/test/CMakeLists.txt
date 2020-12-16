init_ring(test)

# Places of markers for lazy testing (used by entry and lazy_testing cmake files)
set (marker_dir ${CMAKE_BINARY_DIR}/markers/test_succeed)
set (marker_normal_dir ${marker_dir}/normal)
set (marker_memory_dir ${marker_dir}/memory)
set (marker_suffix "_succeed.marker")

set(VALGRIND_COMMAND_OPTIONS "--error-exitcode=100")


# Compile test internal lib and link to external 
add_subdirectory(src)

# Compile and link tests
add_subdirectory(entry)

# Compile external programs needed for tests
add_subdirectory(needed)

#Adittional usefull test targets
include(${CMAKE_SOURCE_DIR}/.auto-cmake/cmake_lazy_testing_targets.cmake) # need to be after test discovery




