set(ARCHIVE_OUTPUT_DIRECTORY ${SOURCELIBDIR})

get_property(LIB_FROM_SYSTEM_TEST GLOBAL PROPERTY LIB_FROM_SYSTEM_TEST)
message("GOOOOOOOOOOT ${LIB_FROM_SYSTEM_TEST}")

if (${LIB_FROM_SYSTEM_TEST})
message("\nFinding system libs: ${LIB_FROM_SYSTEM_TEST}")
find_libraries("${LIB_FROM_SYSTEM_TEST}")
endif()

get_C_sources(${CMAKE_CURRENT_SOURCE_DIR} TEST_INTERN_SRC_FILES)
JOIN("${TEST_INTERN_SRC_FILES}" \n\t pretty)
message ("\nInternal test shared sources:\n\t ${pretty}")



add_library(TEST_INTERN_SRC ${INTERAL_LIBS_MODE} ${TEST_INTERN_SRC_FILES})
add_include_dirs_target( ${CMAKE_CURRENT_SOURCE_DIR} TEST_INTERN_SRC)
# Adding other importants test libs TEST_INTERN_SRC shoul be called TEST_SRC now, but we cant copy libs in cmake

get_property(EXTERNAL_LIBS_TEST_FROM_PROJECT GLOBAL PROPERTY EXTERNAL_LIBS_TEST_FROM_PROJECT)

message("\n\nTests sources linked with: EXT_TEST_SRC ${EXTERNAL_LIBS_TEST_FROM_PROJECT} ${LIB_FROM_SYSTEM_TEST}")

target_link_libraries( TEST_INTERN_SRC PUBLIC EXT_TEST_SRC ${EXTERNAL_LIBS_TEST_FROM_PROJECT} ${LIB_FROM_SYSTEM_TEST})


