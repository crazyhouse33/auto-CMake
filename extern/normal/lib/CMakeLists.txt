MACRO(add_to_fs_libs lib)
	message ("\tGot ${lib}")
	get_property(tmp GLOBAL PROPERTY EXTERNAL_LIBS_FROM_PROJECT)
	list (APPEND tmp ${lib})
	set_property(GLOBAL PROPERTY EXTERNAL_LIBS_FROM_PROJECT ${tmp} )
	
ENDMACRO(add_to_fs_libs)

message("\nInternal libs:")

# Adding includes to extern sources
add_include_dirs_target( ${CMAKE_CURRENT_SOURCE_DIR} EXT_SRC)

add_subdirectory(an_extern_lib) 
add_to_fs_libs(eprof)

# YOU MUST CREATE THE CMAKE LIBRARY THERE and call add_to_fs_libs on it

