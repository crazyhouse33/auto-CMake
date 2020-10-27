set(ARCHIVE_OUTPUT_DIRECTORY ${SOURCELIBDIR})

get_C_sources(${CMAKE_CURRENT_SOURCE_DIR} EXT_TEST_SRC_FILES)
JOIN("${EXT_TEST_SRC_FILES}" \n\t pretty)
message ("\nExternal test sources:\n\n\t\t ${pretty}\n")



add_library(EXT_TEST_SRC ${INTERAL_LIBS_MODE} ${EXT_TEST_SRC_FILES})
add_include_dirs_target( ${CMAKE_CURRENT_SOURCE_DIR} EXT_TEST_SRC)

