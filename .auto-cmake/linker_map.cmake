
# We use thin archive to be able to get: object_name -> path of object in the linker map
# I am not sure to get this right. This is poorly documented and found thoses on mailing lists
IF (WIN32)
	set(CMAKE_STATIC_LIBRARY_OPTIONS /llvmlibthin)
ELSE()
	#set(CMAKE_STATIC_LINKER_FLAGS -T)
ENDIF()

if (CMAKE_C_COMPILER_ID STREQUAL "GNU")
	#	set(LINKER_MAP_CREATION "-Wl,--cref,-Map=")
	set(LINKER_MAP_CREATION "-Wl,-Map=../")
elseif (CMAKE_C_COMPILER_ID STREQUAL "MSVC")
	set(LINKER_MAP_CREATION "/MAP:")

	#TODO dont know what is the id for ARM compiler. Mark the command anywayw since it take time to find those informations
elseif (CMAKE_C_COMPILER_ID STREQUAL "ARMCC")
	set(LINKER_MAP_CREATION "--map --list=")
else()
	message("Linker map creation is not supported by your compiler ")
endif()

FUNCTION(produce_linker_map target name)
	if (LINKER_MAP_CREATION)
		get_target_property(LINK_OPS ${target} LINK_OPTIONS)
		if (NOT LINK_OPS)
			set (LINK_OPS "")
		endif()
		list(APPEND LINK_OPS "${LINKER_MAP_CREATION}${name}") 
		set_target_properties(${target} PROPERTIES LINK_OPTIONS ${LINK_OPS} )
	endif()
ENDFUNCTION()
