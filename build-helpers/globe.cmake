# Get directories in a directory, himself and hiden ones excluded
FUNCTION (get_dirs dir res)
	FILE(GLOB children RELATIVE ${curdir} ${curdir}/*)
	SET(dirlist "")
	FOREACH(child ${children})
		IF(IS_DIRECTORY ${curdir}/${child})
			LIST(APPEND dirlist ${child})
		ENDIF()
	ENDFOREACH()
	remove_hidden(${dir} ${children} end_res)
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

FUNCTION(dir_to_lib libmod dir target_name )
	get_sources( ${dir} inc headers sources)

	JOIN("${sources}" "\n\t\t" pretty)
	message ("\n\tDetected sources:\n\n\t\t${pretty}")

	JOIN("${headers}" "\n\t\t" pretty)
	message ("\n\tDetected headers:\n\n\t\t${pretty}")

	JOIN("${inc}" "\n\t\t" pretty)
	message ("\n\tDetected includes:\n\n\t\t${pretty}")
	add_library(${target_name} ${libmod} ${headers} ${sources})
	target_include_directories(${target_name} PUBLIC ${inc})
	set_target_properties(${target_name} PROPERTIES PUBLIC_HEADER "${headers}")

ENDFUNCTION()
