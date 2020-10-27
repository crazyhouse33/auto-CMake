set(ARCHIVE_OUTPUT_DIRECTORY ${SOURCELIBDIR})

get_C_sources(${CMAKE_CURRENT_SOURCE_DIR} TEST_INTERN_SRC_FILES)
JOIN("${TEST_INTERN_SRC_FILES}" \n\t pretty)
message ("\nInternal test shared sources for test build in ${CMAKE_CURRENT_SOURCE_DIR}:\n ${pretty}")



add_library(TEST_INTERN_SRC ${INTERAL_LIBS_MODE} ${TEST_INTERN_SRC_FILES})
add_include_dirs_target( ${CMAKE_CURRENT_SOURCE_DIR} TEST_INTERN_SRC)
# Adding other importants test libs TEST_INTERN_SRC shoul be called TEST_SRC now, but we cant copy libs in cmake

get_property(EXTERNAL_LIBS_TEST_FROM_PROJECT GLOBAL PROPERTY EXTERNAL_LIBS_TEST_FROM_PROJECT)

target_link_libraries( TEST_INTERN_SRC PUBLIC EXT_TEST_SRC ${EXTERNAL_LIBS_TEST_FROM_PROJECT} ${LIB_FROM_SYSTEM_TEST})


