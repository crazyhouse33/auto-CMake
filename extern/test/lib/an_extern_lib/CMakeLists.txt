set(SOURCES ${CMAKE_CURRENT_SOURCE_DIR}/ext_test_lib.c ${CMAKE_CURRENT_SOURCE_DIR}/includes/ext_test_lib.h )

set(ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)

add_library(ext_lib_test STATIC ${SOURCES})

target_include_directories(ext_lib_test PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/includes)

