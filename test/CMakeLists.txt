# entries are not instalable
init_ring(test NO)

# Places of markers for lazy testing (used by entryand lazy_testing cmake files)
set (marker_dir ${CMAKE_BINARY_DIR}/markers/test_succeed)
set (marker_normal_dir ${marker_dir}/normal)
set (marker_memory_dir ${marker_dir}/memory)
set (marker_suffix "_succeed.marker")

# Compile test internal lib and link to external 
add_subdirectory(src)

# Compile and link tests
add_subdirectory(entry)

# Compile external programs needed for tests
add_subdirectory(needed)

#Adittional usefull test targets
include(${CMAKE_SOURCE_DIR}/build-helpers/cmake_lazy_testing_targets.cmake) # need to be after test discovery




