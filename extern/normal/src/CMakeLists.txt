set(ARCHIVE_OUTPUT_DIRECTORY ${SOURCELIBDIR})

get_C_sources(${CMAKE_CURRENT_SOURCE_DIR} EXT_SRC_FILES)
JOIN("${EXT_SRC_FILES}" "\n\t" pretty)
message ("\nExternal sources:\n\n\t${pretty}")

add_library(EXT_SRC ${INTERAL_LIBS_MODE} ${EXT_SRC_FILES})
add_include_dirs_target( ${CMAKE_CURRENT_SOURCE_DIR} EXT_SRC)


