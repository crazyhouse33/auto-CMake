
#Create variable of ring. if instalable_entries True entrie will be installed
MACRO(init_ring name entry_description)
	message ("\n--------RING ${name}--------\n")
	set(ring_name ${name})
	set (ring_dir ${CMAKE_CURRENT_SOURCE_DIR})
	#Setting up all code/libs
	ring_core()

	# Dealing with entries
	ring_entries(${ring_dir}/entry ${entry_description})
ENDMACRO()

#  Get the ring global setting for the_stuff if it was not defined. If there is no global setting for the ring either, return the given fail value if given, otherwise fail
FUNCTION (ring_get_value prefix the_stuff result)

	set (default_str "${prefix}_${ring_name}")
	set (the_stuff_str "${default_str}_${the_stuff}")
	if (DEFINED ${the_stuff_str})
		set (${result} ${${the_stuff_str}} PARENT_SCOPE)
	elseif(DEFINED ${default_str})
		set (${result} ${${default_str}} PARENT_SCOPE)
	elseif(DEFINED ${prefix})
		set (${result} ${${prefix}} PARENT_SCOPE)
	elseif(ARGN)
		list(GET ARGN 0 fail)
		set(${result} ${fail} PARENT_SCOPE)
	else()
		message( FATAL_ERROR "Could not find a value for ${the_stuff_str}. Please either define a default value for the ring, or an exception for this case" )
	endif()		

ENDFUNCTION()

#TODO Put part of this function into ring_init
# Manage the src folder of a ring
FUNCTION(ring_core)

	#0 Recolt necessary extern dependencies for ring (src and libs)
	ring_ext_folder()

	#1 Finding external libs
	get_property(LIB_FROM_SYSTEM GLOBAL PROPERTY "LIB_FROM_SYSTEM_${ring_name}")

	if (LIB_FROM_SYSTEM)
		message("\nFinding system libs:")
		find_libraries("${LIB_FROM_SYSTEM}" FOUNDED_LIBS)
	endif()
	my_manual_find_libs(${ring_name}) # Getting others libs the dirty way

	#2 Getting libs from the intern ring

	set (target_name RING_${ring_name}) 
	add_library(${target_name} INTERFACE)
	message("\nInternal sources libs\n")

	dir_to_sub_libs(${CMAKE_CURRENT_SOURCE_DIR}/src ${target_name} "")
	
	#3 Getting external libs from the ring
	get_property(EXTERNAL_LIBS_FROM_PROJECT GLOBAL PROPERTY EXTERNAL_LIBS_FROM_PROJECT_${ring_name})


	set(to_link EXT_SRC_${ring_name} ${EXTERNAL_LIBS_FROM_PROJECT} ${FOUNDED_LIBS})

	message("\nLinked with: ${to_link}")
	target_link_libraries( ${target_name} INTERFACE ${to_link} )

	#4 Install the ring if asked
	if (DEFINED INSTALL_RING_${ring_name})
		set(lib_name ${INSTALL_LIB_${ring_name})
		set_target_properties(${target_name} PROPERTIES OUTPUT_NAME ${lib_name})
		INSTALL(TARGETS ${target_name} DESTINATION lib/${lib_name} PUBLIC_HEADER DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}/${lib_name}")
	endif()


	#5 appending ring to the chain
	get_property(RINGS_CHAIN GLOBAL PROPERTY RINGS_CHAIN)
	list (PREPEND RINGS_CHAIN ${target_name})
	set_property(GLOBAL PROPERTY RINGS_CHAIN ${RINGS_CHAIN} )
ENDFUNCTION()

# CORE is always included, dont put it twice. Call set_rings(TEST,PERF) so next ring_core will integrate the rings. The order matter (Monkey_patching). First one have priority (here, test will monkeypatch PERF in case of redefine). Code ring is always put in the end
FUNCTION(set_rings ring_list)
	set (ring_list ${RINGS_CHAIN} "code" )
	set_property(GLOBAL PROPERTY RINGS_CHAIN ${ring_list}  )
ENDFUNCTION()

FUNCTION(target_link_ring target_to_link)
	get_property(RINGS_CHAIN GLOBAL PROPERTY RINGS_CHAIN)
	target_link_libraries( ${target_to_link} ${RINGS_CHAIN})
ENDFUNCTION()


# Accumulate sources from external project. Should be call in extern/ring/src 
FUNCTION(ring_ext_folder )
	# Adding manual libs
	add_subdirectory(${ring_dir}/extern/lib)

	# Autodetecting sources
	message ("\nExternal sources:\n")
	add_library(EXT_SRC_${ring_name} INTERFACE)
	dir_to_sub_libs(${ring_dir}/extern/src EXT_SRC_${ring_name} "EXT")

ENDFUNCTION()

FUNCTION(ring_ext_lib)
	message ("\nManual libraries:\n")
	MACRO(add_to_fs_libs lib)
		message ("\tGot ${lib}")
		get_property(tmp GLOBAL PROPERTY EXTERNAL_LIBS_FROM_PROJECT_${ring_name})
		list (APPEND tmp ${lib})
		set_property(GLOBAL PROPERTY EXTERNAL_LIBS_FROM_PROJECT_${ring_name} ${tmp} )
		unset(tmp)
	ENDMACRO(add_to_fs_libs)

	# Adding includes to extern sources
	#add_include_dirs_target( ${CMAKE_CURRENT_SOURCE_DIR} EXT_SRC_${ring_name})
ENDFUNCTION()

# Collect entries in dir. The function call get_entry_target. The User can overide the default given function to get different behaviour
FUNCTION(ring_entries dir description)

	#compile ext-test ones, which are just unrelated programs
	file(GLOB_RECURSE entries CONFIGURE_DEPENDS ${dir}/*.c)
	if(entries)
		message("\n${description}:\n")
	endif()
	foreach(file ${entries})

		get_filename_component (name_without_extension ${file} NAME_WE)
		# Process possible RENAME 
		set (rename ${RENAME_ENTRY_${ring_name}_${name_without_extension}})
		if ( ${rename} )
			set (name ${${rename}})
		else()
			set (name ${RING_PREFIX_${ring_name}}${name_without_extension})
		endif()


		if (NOT TARGET ${name})# If target had allready been manually created, ignore

			get_entry_target(${file} ${name})

			ring_get_value(RING_ENTRY_BIN_OUTPUT ${name_without_extension} destination ${PROJECT_SOURCE_DIR}/bin/${ring_name} )
			set_target_properties(${name}
				PROPERTIES
				RUNTIME_OUTPUT_DIRECTORY ${destination} 
				)
			ring_get_value(INSTALL_ENTRY ${name_without_extension} need_install )
			if(${need_install})
				INSTALL(TARGETS ${name})
			endif()
		endif()
	endforeach()
ENDFUNCTION()

#DEFAULT get_entry_target. Overide if you need a different comportement for your ring. Use a maccro to benefit from some variables set higher(OUTPUT_DIR...)
FUNCTION(get_entry_target path name)
	message("\t${path}")
	add_executable(${name} ${path})
	target_link_ring(${name})
ENDFUNCTION()


