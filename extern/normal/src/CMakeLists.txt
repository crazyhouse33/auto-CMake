set(ARCHIVE_OUTPUT_DIRECTORY ${SOURCELIBDIR})

get_C_sources(${CMAKE_CURRENT_SOURCE_DIR} EXT_SRC_FILES)
JOIN("${EXT_SRC_FILES}" "\n\t" pretty)
message ("\nDetected external sources in ${CMAKE_CURRENT_SOURCE_DIR}:\n\t${pretty}")



add_library(EXT_SRC ${INTERAL_LIBS_MODE} ${EXT_SRC_FILES})
get_non_hidden_subdirectories( ${CMAKE_CURRENT_SOURCE_DIR} sub_dirs)
target_include_directories(EXT_SRC PUBLIC ${sub_dirs})
