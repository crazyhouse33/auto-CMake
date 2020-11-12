
#Create variable of ring. if instalable_entries True entrie will be installed
MACRO(init_ring name instalable_entries)
	message ("\n--------RING ${name}--------\n")
	set(ring_name ${name})
	if (NOT DEFINED INTERNAL_LIBS_MODE_${name})
		set (libmod ${INTERNAL_LIBS_MODE})
	endif()
	set(ring_instalable_entries ${instalable_entries})
ENDMACRO()

# Manage the src folder of a ring
FUNCTION(ring_core)

	#0 Recolt necessary extern dependencies for ring
	add_subdirectory(${CMAKE_SOURCE_DIR}/extern/${ring_name} ${CMAKE_CURRENT_BINARY_DIR}/extern/${ring_name})

	#1 Finding external libs
	set(ARCHIVE_OUTPUT_DIRECTORY ${SOURCELIBDIR})
	# Finding Externals libs
	get_property(LIB_FROM_SYSTEM GLOBAL PROPERTY "LIB_FROM_SYSTEM_${ring_name}")

	if (LIB_FROM_SYSTEM)
		message("\nFinding system libs:")
		find_libraries("${LIB_FROM_SYSTEM}" FOUNDED_LIBS)
	endif()
	my_manual_find_libs(${ring_name}) # Getting others libs the dirty way

	#2 Getting lib from the intern ring
	message("\nInternal sources\n")
	dir_to_lib(${libmod} ${CMAKE_CURRENT_SOURCE_DIR} INTERN_${ring_name})


	#3 Getting external libs from the ring
	get_property(EXTERNAL_LIBS_FROM_PROJECT GLOBAL PROPERTY EXTERNAL_LIBS_FROM_PROJECT_${ring_name})

	#4 Get previous rings
	get_property(RINGS_CHAIN GLOBAL PROPERTY RINGS_CHAIN)

	set(to_link EXT_SRC_${ring_name} ${FOUNDED_LIBS} ${EXTERNAL_LIBS_FROM_PROJECT})

	message("\nLinked with: ${to_link}")
	target_link_libraries( INTERN_${ring_name} PUBLIC ${to_link} )


	#5 appending ring to the chain
	list (PREPEND RINGS_CHAIN INTERN_${ring_name})
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
	if (${ARGN})
		set(dest ${ARGN0})
	endif()
	set(EXECUTABLE_OUTPUT_PATH  ${dest})

	#compile ext-test ones, which are just unrelated programs
	file(GLOB_RECURSE entries CONFIGURE_DEPENDS *.c)
	if(entries)
		message("\n${description}:\n")
	endif()
	foreach(file ${entries})
		get_filename_component (name_without_extension ${file} NAME_WE)
		get_entry_target(${file} ${name_without_extension})
		if(${ring_instalable_entries})
			INSTALL(TARGETS ${name}
				RUNTIME DESTINATION ${name} 
				)
		endif()
	endforeach()
ENDFUNCTION()

#DEFAULT get_entry_target overide if you need a different comportement for your ring
FUNCTION(get_entry_target path name)
	message("\t${path}")
	add_executable(${name} ${path})
	target_link_ring(${name})

ENDFUNCTION()


