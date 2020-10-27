MACRO(add_to_fs_libs lib)
	message ("\tGot ${lib}")
	get_property(tmp GLOBAL PROPERTY EXTERNAL_LIBS_TEST_FROM_PROJECT)
	list (APPEND tmp ${lib})
	set_property(GLOBAL PROPERTY EXTERNAL_LIBS_TEST_FROM_PROJECT ${tmp} )

ENDMACRO(add_to_fs_libs)

message("\nInternal test libs:")


# Adding the lib headers to the test source
add_include_dirs_target( ${CMAKE_CURRENT_SOURCE_DIR} EXT_TEST_SRC)

# YOU MUST CREATE THE CMAKE LIBRARY THERE and call add_to_fs_libs on it

# Add external libs from source. Exemple:
add_subdirectory(an_extern_lib) 
add_to_fs_libs(eprof2)







