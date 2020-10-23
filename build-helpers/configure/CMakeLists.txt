# Configuring files as if it was the root directory
message ("Configuring files in ${CMAKE_CURRENT_SOURCE_DIR}:")
file(GLOB_RECURSE ALL_FILES root-mirror LIST_DIRECTORIES FALSE RELATIVE root-mirror CONFIGURE_DEPENDS)
FOREACH( SUB_FILE ${ALL_FILES})
	message("\tConfiguring ${SUB_FILE}")

	configure_file(${SUB_FILE} "${CMAKE_SOURCE_DIR}/${SUB_FILE}")
ENDFOREACH()

