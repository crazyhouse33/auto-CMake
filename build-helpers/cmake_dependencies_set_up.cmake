# From a package that had been found, found a lib. The approach is to implement unsuported conventions till supporting most of the cases

FUNCTION(package_to_lib package res)
	get_property(languages GLOBAL PROPERTY ENABLED_LANGUAGES)

	if("CXX" IN_LIST languages)
		set (languages CXX)
	elseif("C" IN_LIST languages)
		set (languages C)
	endif()

	# Pass trought convention
	set(identityconv ${package})
	if (TARGET ${identityconv})
		set(${res} ${identityconv} PARENT_SCOPE)
	endif()

	#OpenMP convention
	set (ompconv "${package}::${package}_${languages}") 
	if (TARGET ${ompconv})
		set(${res} ${ompconv} PARENT_SCOPE)
	endif()

ENDFUNCTION()

# Return founded libs
MACRO(find_libraries libs res)
FOREACH(lib ${libs})
	message("\n\t${lib}:\n")
	find_package(${lib} QUIET )
	if(NOT ${lib}_FOUND)
		find_library( ${lib} ${lib} )
		if (${${lib}} STREQUAL "${lib}-NOTFOUND")
			message("\t\tWARNING: Not found, wont be linked against")
		else()
			message("\t\t Library found")
			LIST(APPEND ${res} ${lib})
		endif()
		#Cleaning state
	else()#Package found
		message("\t\tPackage found")
		package_to_lib(${lib} tmp)
		LIST(APPEND ${res} ${tmp})
		unset(tmp)
	endif()
ENDFOREACH()
ENDMACRO(find_libraries)

# Add here libs you want to use and cant be obtained the simple way
MACRO(my_manual_find_libs)
ENDMACRO()

MACRO(my_manual_find_libs_test)
ENDMACRO()

