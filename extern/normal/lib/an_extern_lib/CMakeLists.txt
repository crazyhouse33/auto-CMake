set(SOURCES ${CMAKE_CURRENT_SOURCE_DIR}/eprof.c ${CMAKE_CURRENT_SOURCE_DIR}/includes/eprof.h )

set(ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)

add_library(eprof STATIC ${SOURCES})

set_target_properties(eprof PROPERTIES VERSION ${version})
target_include_directories(eprof PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/includes)

INSTALL(TARGETS eprof
	ARCHIVE DESTINATION eprof
)
