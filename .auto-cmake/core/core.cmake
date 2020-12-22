

# Need to include after project call
include(GNUInstallDirs) #system headers place
include(${auto_cmake_dir}/linker_map.cmake) # Function to produce a linker map (need cmake project() call)
include(${auto_cmake_dir}/language.cmake) # Get c++ or C variable (need cmake project() call)



# Set place for data
set_if_not_set (SOURCELIBDIR ${CMAKE_BINARY_DIR}/backend_libs)



#Setting use compilation options
set(CMAKE_C_FLAGS_DEBUG "-ggdb3")
# Color output
set(CMAKE_C_FLAGS "-fdiagnostics-color=always")

#allow C programs to get the version
add_definitions("-D${PROJECT_NAME}_VERSION=${CMAKE_PROJECT_VERSION}")


# Ring stuff
include(${auto_cmake_dir}/rings.cmake) # ring stuff

# Conf
include(auto-cmake.conf/conf.cmake)

# Need to transform some user passed variable to globals
set_property(GLOBAL PROPERTY LIB_FROM_SYSTEM_test ${LIB_FROM_SYSTEM_test})
set_property(GLOBAL PROPERTY LIB_FROM_SYSTEM_code ${LIB_FROM_SYSTEM_code})
set_property(GLOBAL PROPERTY LIB_FROM_SYSTEM_perf ${LIB_FROM_SYSTEM_perf})
include(auto-cmake.conf/rings_order.cmake)



