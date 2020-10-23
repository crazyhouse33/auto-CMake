
# Compile and link tests
add_subdirectory(entry)

# Compile external programs needed for tests
add_subdirectory(needed)

#Adittional usefull test targets
include(${CMAKE_SOURCE_DIR}/build-helpers/cmake_lazy_testing_targets) # need to be after test discovery




