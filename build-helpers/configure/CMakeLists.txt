# Configuring files as if it was the root directory
message ("\nConfiguring files in ${CMAKE_CURRENT_SOURCE_DIR}:\n")
file (GLOB_RECURSE ALL_FILES LIST_DIRECTORIES FALSE RELATIVE "${CMAKE_CURRENT_SOURCE_DIR}/root" "root/*" )
FOREACH( SUB_FILE ${ALL_FILES})
	message("\t${SUB_FILE}")

	configure_file("root/${SUB_FILE}" "${CMAKE_SOURCE_DIR}/${SUB_FILE}")
ENDFOREACH()

