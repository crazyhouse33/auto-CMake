
#Create variable of ring. if instalable_entries True entrie will be installed
MACRO(init_ring name)
	message ("\n--------RING ${name}--------\n")
	set(ring_name ${name})
	if (NOT DEFINED INTERNAL_LIBS_MODE_${name})
		set (libmod ${INTERNAL_LIBS_MODE})
	endif()
ENDMACRO()

#  Get the ring global setting for the_stuff if it was not defined. If there is no global setting for the ring either, return the given fail value if given, otherwise fail
FUNCTION (ring_get_value prefix the_stuff result)

	set (default_str "${prefix}_${ring_name}")
	set (the_stuff_str "${default_str}_${the_stuff}")
	if (DEFINED ${the_stuff_str})
		set (${result} ${the_stuff_str} PARENT_SCOPE)
	elseif(DEFINED ${default_str})
		set (${result} ${default_str} PARENT_SCOPE)
	elseif(ARGN)
		list(GET ARGN 0 fail)
		set(${result} ${fail} PARENT_SCOPE)
	else()
		message( FATAL_ERROR "Could not find a value for ${the_stuff_str}. Please either define a default value for the ring, or an exception for this case" )
	endif()		

ENDFUNCTION()

# Manage the src folder of a ring
FUNCTION(ring_core)

	#0 Recolt necessary extern dependencies for ring
	add_subdirectory(${CMAKE_SOURCE_DIR}/extern/${ring_name} ${CMAKE_CURRENT_BINARY_DIR}/extern/${ring_name})

	#1 Finding external libs
	get_property(LIB_FROM_SYSTEM GLOBAL PROPERTY "LIB_FROM_SYSTEM_${ring_name}")

	if (LIB_FROM_SYSTEM)
		message("\nFinding system libs:")
		find_libraries("${LIB_FROM_SYSTEM}" FOUNDED_LIBS)
	endif()
	my_manual_find_libs(${ring_name}) # Getting others libs the dirty way

	#2 Getting libs from the intern ring
	message("\nInternal sources libs\n")
	set (target_name RING_${ring_name})
	dir_to_lib(${libmod} ${CMAKE_CURRENT_SOURCE_DIR} ${target_name})
	get_dirs( ${CMAKE_CURRENT_SOURCE_DIR} child_dirs)

	#	FOREACH(dir ${child_dirs})
	#		get_filename_component(the_dir ${dir} NAME)
	#		ring_get_default(INSTALL_LIB ${the_dir})
	#
	#		
	#			if (NOT ${the_dir} IN_LIST ${include_dirs})
	#				LIST(APPEND ${include_dirs} ${the_dir})
	#			endif()
	#		ENDFOREACH()



	#3 Getting external libs from the ring
	get_property(EXTERNAL_LIBS_FROM_PROJECT GLOBAL PROPERTY EXTERNAL_LIBS_FROM_PROJECT_${ring_name})


	set(to_link EXT_SRC_${ring_name} ${EXTERNAL_LIBS_FROM_PROJECT} ${FOUNDED_LIBS})

	message("\nLinked with: ${to_link}")
	target_link_libraries( ${target_name} PUBLIC ${to_link} )

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


# Accumulate sources from extneral project. Should be call in extern/ring/src 
FUNCTION(ring_ext_source )
	message ("\nExternal source:\n")
	set(ARCHIVE_OUTPUT_DIRECTORY ${SOURCELIBDIR})
	dir_to_lib(${libmod} ${CMAKE_CURRENT_SOURCE_DIR} EXT_SRC_${ring_name})
ENDFUNCTION()

FUNCTION(ring_ext_lib)
	message ("\nExternal libraries\n")
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

FUNCTION(ring_entries description)
	set (dest ${PROJECT_SOURCE_DIR}/bin/${ring_name})
	if (ARGN)
		list(GET ARGN 0 dest)
	endif()

	set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${dest})

	#compile ext-test ones, which are just unrelated programs
	file(GLOB_RECURSE entries CONFIGURE_DEPENDS *.c)
	if(entries)
		message("\n${description}:\n")
	endif()
	foreach(file ${entries})
		get_filename_component (name_without_extension ${file} NAME_WE)
		get_entry_target_name( ${name_without_extension} name)
		if (NOT TARGET ${name})# If target had been manually created, ignore
			get_entry_target(${file} ${name})
			ring_get_value(INSTALL_ENTRY ${name} need_install )
			if(${need_install})
				INSTALL(TARGETS ${name})
			endif()
		endif()
	endforeach()
ENDFUNCTION()

#DEFAULT get_entry_target_name. If you want to change the way a target is named in your ring, overide
FUNCTION(get_entry_target_name name new_name)
	set (${new_name} ${name} PARENT_SCOPE) 
ENDFUNCTION()

#DEFAULT get_entry_target. Overide if you need a different comportement for your ring. Use a maccro to benefit from some variables set higher(OUTPUT_DIR...)
FUNCTION(get_entry_target path name)
	message("\t${path}")
	add_executable(${name} ${path})
	target_link_ring(${name})
ENDFUNCTION()


