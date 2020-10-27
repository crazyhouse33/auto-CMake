set(SOURCES ${CMAKE_CURRENT_SOURCE_DIR}/ext_lib.c ${CMAKE_CURRENT_SOURCE_DIR}/includes/ext_lib.h )

set(ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)

add_library(eprof STATIC ${SOURCES})

target_include_directories(eprof PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/includes)
