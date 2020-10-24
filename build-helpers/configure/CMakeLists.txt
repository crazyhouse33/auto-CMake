# Configuring files as if it was the root directory
message ("Configuring files in ${CMAKE_CURRENT_SOURCE_DIR}:")
file (GLOB_RECURSE ALL_FILES LIST_DIRECTORIES FALSE RELATIVE "${CMAKE_CURRENT_SOURCE_DIR}/root" "root/*" )
FOREACH( SUB_FILE ${ALL_FILES})
	message("\tConfiguring ${SUB_FILE}")

	configure_file("root/${SUB_FILE}" "${CMAKE_SOURCE_DIR}/${SUB_FILE}")
ENDFOREACH()

