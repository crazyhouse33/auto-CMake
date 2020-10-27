set(SOURCES ${CMAKE_CURRENT_SOURCE_DIR}/ext_test_lib.c ${CMAKE_CURRENT_SOURCE_DIR}/includes/ext_test_lib.h )

set(ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)

add_library(eprof2 STATIC ${SOURCES})

target_include_directories(eprof2 PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/includes)

