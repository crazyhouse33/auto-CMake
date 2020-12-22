# Get directories in a directory, himself and hiden ones excluded
FUNCTION (get_dirs dir res)

	FILE(GLOB children ${dir}/*)

	SET(dirlist "")
	FOREACH(child ${children})
		IF(IS_DIRECTORY ${child})
			LIST(APPEND dirlist ${child})
		ENDIF()
	ENDFOREACH()
	remove_hidden(${dir} "${dirlist}" end_res)
	set (${res} ${end_res} PARENT_SCOPE)
ENDFUNCTION()



# Remove files contained in a hidden subdir 
FUNCTION (remove_hidden basedir files out)

	get_filename_component(absdirectory ${basedir} REALPATH )
	FOREACH(sub ${files})
		string(REPLACE ${absdirectory} "" relative ${sub}) #Here lie the trick to not include .git and other bullshit
		IF (NOT ${relative} MATCHES ".*/\\..*")
			list (APPEND out_var ${sub})
		ENDIF()
	ENDFOREACH()

	set (${out} ${out_var} PARENT_SCOPE)
ENDFUNCTION()


# Return prefixed version of a list
FUNCTION(prefix a_list prefix out)
	FOREACH(item ${a_list})
		LIST(APPEND res "${prefix}${item}")
	ENDFOREACH()

	set (${out} ${res} PARENT_SCOPE)
ENDFUNCTION()

# Return prefixed version of a list
FUNCTION(postfix a_list postfix out)
	FOREACH(item ${a_list})
		LIST(APPEND res "${item}${postfix}")
	ENDFOREACH()
	set (${out} ${res} PARENT_SCOPE)
ENDFUNCTION()


FUNCTION(find_extension dir extensions out)


	prefix("${extensions}" "${dir}/*." search_motif)

	file(GLOB_RECURSE result_files CONFIGURE_DEPENDS ${search_motif})


	remove_hidden(${dir} "${result_files}" result_files)


	set (${out} ${result_files} PARENT_SCOPE)
ENDFUNCTION()


# Separate a folder into his sources, headersn abd include dirs. If you dont care about one of the results, set it to an non false variable to avoid the overidde of computing it, it will be returned unmodified
MACRO(get_sources directory include_dirs headers sources)

	if (NOT ${headers})
		find_extension( ${directory} "${HEADER_EXTENSIONS}" ${headers})
	endif()

	if (NOT ${sources})

		find_extension( ${directory} "${SOURCE_EXTENSIONS}" ${sources})
	endif()
	if (NOT ${include_dirs})
		FOREACH(header ${${headers}})
			get_filename_component(the_dir ${header} DIRECTORY)
			if (NOT ${the_dir} IN_LIST ${include_dirs})
				LIST(APPEND ${include_dirs} ${the_dir})
			endif()
		ENDFOREACH()
	endif()

ENDMACRO()

FUNCTION (sources_to_lib inc headers sources target_name lib_name lib_mode )

	set(ARCHIVE_OUTPUT_DIRECTORY ${SOURCELIBDIR})
	set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${SOURCELIBDIR})


	add_library( ${target_name} ${libmod} ${headers} ${sources})
	target_include_directories(${target_name} PUBLIC ${inc})
	set_target_properties(${target_name} PROPERTIES PUBLIC_HEADER "${headers}")
	set_target_properties(${target_name} PROPERTIES OUTPUT_NAME ${lib_name})
	if (NOT sources) #https://stackoverflow.com/questions/11801186/cmake-unable-to-determine-linker-language-with-c
		set_target_properties(${target_name} PROPERTIES LINKER_LANGUAGE ${C_OR_CPP_LANG})

	endif()


ENDFUNCTION()

FUNCTION(dir_to_lib dir target_name lib_name libmod )
	get_sources( ${dir} inc headers sources)

	JOIN("${sources}" "\n\t\t" pretty)
	message ("\n\tDetected sources:\n\n\t\t${pretty}")

	JOIN("${headers}" "\n\t\t" pretty)
	message ("\n\tDetected headers:\n\n\t\t${pretty}")

	JOIN("${inc}" "\n\t\t" pretty)
	message ("\n\tDetected includes:\n\n\t\t${pretty}")
	sources_to_lib("${inc}" "${headers}" "${sources}" ${target_name} ${lib_name} ${libmod})
ENDFUNCTION()


# Install a library with given mode (SHARED...). If mode dont match the one at creation, create a copy with the good type and install it
FUNCTION(reinstall_lib target mode)

	get_target_property(old_mode ${target} TYPE)
	get_target_property(lib_name ${target} OUTPUT_NAME)

	if (old_mode MATCHES ".*${mode}.*") # STATIC-lib->STATIC
		set (the_target_to_install ${target})
	else()
		get_target_property(sources ${target} SOURCES)
		get_target_property(inc ${target} INCLUDE_DIRECTORIES)
		get_target_property(headers ${target} PUBLIC_HEADER)
		set (new_name ${lib_name}_COPY_${mode})
		sources_to_lib( "${inc}" "${headers}" "${sources}" __lib-${new_name} ${new_name} ${mode})
		set (the_target_to_install __lib-${new_name})
	endif()

	INSTALL(TARGETS ${the_target_to_install} DESTINATION lib/${lib_name} PUBLIC_HEADER DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}/${lib_name}")

ENDFUNCTION()

# Each subdir will be considered as a library, the given target will be linked with all results. All the complex prefix mechanic is there to resolve collisions at best and quickely understand wich folder is wrong in case of compilation poblems with libs, and to give a way to have different configuration perf function call as well.
FUNCTION(dir_to_sub_libs dir target_to_be_linked config_prefix)
	# Manage the empty config_prefix case cleanely (handling anoyings  __ in configuration)
	if(NOT config_prefix STREQUAL "")
		set( config_prefix_right ${config_prefix}_)
		set( config_prefix_t_right ${config_prefix}-)
		set(config_prefix _${config_prefix}_)
	endif()

	get_dirs( ${dir} child_dirs)

	FOREACH(dir ${child_dirs})
		get_filename_component(the_dir ${dir} NAME)
		# Getting user wanted name for lib
		set (rename ${RENAME_${config_prefix_right}LIB_${ring_name}${config_prefix}${the_dir}})
		if ( ${rename} )
			set (lib_name ${${rename}})
		else()
			set (lib_name ${config_prefix_right}${RING_PREFIX_${ring_name}}${the_dir})
		endif()		

		# Getting appropriate library mode
		ring_get_value(INTERNAL_${config_prefix_right}LIB_MODE ${the_dir} libmod)

		# Getting the appropriate library mode for installed version
		ring_get_value(INSTALL_${config_prefix_right}LIB_MODE ${the_dir} install_mode)

		# Getting the installed mode
		if(install_mode)
			if (install_mode EQUAL SAME)
				set (install_mode ${libmod})
			endif()
			set (install_message ", INSTALLED ${install_mode}")
		endif()



		message("\t${lib_name} (${libmod}${install_message})")
		dir_to_lib(${dir} auto-lib-${lib_name} ${lib_name} ${libmod} )
		target_link_libraries(${target_to_be_linked} INTERFACE auto-lib-${lib_name})

		#4 Install the lib if asked
		if (install_mode)
			reinstall_lib(auto-lib-${lib_name} ${install_mode} )
		endif()

	ENDFOREACH()
ENDFUNCTION()

