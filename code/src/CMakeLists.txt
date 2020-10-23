set(ARCHIVE_OUTPUT_DIRECTORY ${SOURCELIBDIR})

get_C_sources(${CMAKE_CURRENT_SOURCE_DIR} INTERN_SRC_FILES)
JOIN("${INTERN_SRC_FILES}" \n\t pretty)
message ("\nDetected internal sources in code/src:\n ${pretty}")



add_library(INTERN_SRC ${INTERAL_LIBS_MODE} ${INTERN_SRC_FILES})
get_non_hidden_subdirectories( ${CMAKE_CURRENT_SOURCE_DIR} sub_dirs)
target_include_directories(INTERN_SRC PUBLIC ${sub_dirs})

# Here if user want to install shared but we used static as backend, we need to recreate the lib in missing mode

if (INSTALL_SOURCES_AS_STATIC_LIB )
	if (${INTERAL_LIBS_MODE} EQUAL SHARED)
		add_library(INTERN_SRC_ALTERNATE_MODE STATIC ${INTERN_SRC})
		target_include_directories(INTERN_SRC_ALTERNATE_MODE PUBLIC ${sub_dirs})
		set(TO_INSTALL INTERN_SRC_ALTERNATE_MODE)
	else()
		set(TO_INSTALL INTERN_SRC)
	endif()
	INSTALL(TARGETS ${TO_INSTALL} 
		ARCHIVE DESTINATION ${INSTALL_SOURCES_AS_STATIC_LIB}
		LIBRARY DESTINATION ${INSTALL_SOURCES_AS_STATIC_LIB}
		)
endif()

if (INSTALL_SOURCES_AS_SHARED_LIB )
	if(${INTERAL_LIBS_MODE} EQUAL STATIC)
		add_library(INTERN_SRC_ALTERNATE_MODE SHARED ${INTERN_SRC_FILES})
		target_include_directories(INTERN_SRC_ALTERNATE_MODE PUBLIC ${sub_dirs})
		set (TO_INSTALL INTERN_SRC_ALTERNATE_MODE)
	else()
		set (TO_INSTALL INTERN_SRC)
	endif()
	INSTALL(TARGETS ${TO_INSTALL} 
		ARCHIVE DESTINATION ${INSTALL_SOURCES_AS_STATIC_LIB}
		LIBRARY DESTINATION ${INSTALL_SOURCES_AS_STATIC_LIB}
		)

endif()
