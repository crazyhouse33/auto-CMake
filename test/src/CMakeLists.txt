set(ARCHIVE_OUTPUT_DIRECTORY ${SOURCELIBDIR})

get_C_sources(${CMAKE_CURRENT_SOURCE_DIR} TEST_INTERN_SRC_FILES)
JOIN("${TEST_INTERN_SRC_FILES}" \n\t pretty)
message ("\nDetected internal test shared sources for test build in ${CMAKE_CURRENT_SOURCE_DIR}:\n ${pretty}")



add_library(TEST_INTERN_SRC ${INTERAL_LIBS_MODE} ${TEST_INTERN_SRC_FILES})
get_non_hidden_subdirectories( ${CMAKE_CURRENT_SOURCE_DIR} sub_dirs)
target_include_directories(TEST_INTERN_SRC PUBLIC ${sub_dirs})
