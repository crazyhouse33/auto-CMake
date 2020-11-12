set(SOURCES ${CMAKE_CURRENT_SOURCE_DIR}/ext_perf_lib.c ${CMAKE_CURRENT_SOURCE_DIR}/includes/ext_perf_lib.h )

set(ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)

add_library(ext_lib_perf STATIC ${SOURCES})

target_include_directories(ext_lib_perf PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/includes)

