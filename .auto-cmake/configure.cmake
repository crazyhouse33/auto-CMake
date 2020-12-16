# Configuring files as if it was the root directory
message ("\nConfiguring files:\n")

set (configure_root_path ${CMAKE_SOURCE_DIR}/auto-cmake.conf/configure)
file (GLOB_RECURSE ALL_FILES LIST_DIRECTORIES FALSE RELATIVE ${configure_root_path} "${configure_root_path}/*" )
FOREACH( SUB_FILE ${ALL_FILES})
	message("\t${SUB_FILE}")
	configure_file("${configure_root_path}/${SUB_FILE}" "${CMAKE_SOURCE_DIR}/${SUB_FILE}")
ENDFOREACH()

