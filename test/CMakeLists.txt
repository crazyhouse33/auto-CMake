# entries are not instalable
init_ring(test NO)

# Compile test internal lib and link to external 
add_subdirectory(src)

# Compile and link tests
add_subdirectory(entry)

# Compile external programs needed for tests
add_subdirectory(needed)

#Adittional usefull test targets
include(${CMAKE_SOURCE_DIR}/build-helpers/cmake_lazy_testing_targets.cmake) # need to be after test discovery




