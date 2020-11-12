set(SOURCES ${CMAKE_CURRENT_SOURCE_DIR}/ext_lib.c ${CMAKE_CURRENT_SOURCE_DIR}/includes/ext_lib.h )

set(ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)

add_library(ext_lib_normal STATIC ${SOURCES})

target_include_directories(ext_lib_normal PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/includes)
