ring_core( )


# Here if user want to install shared but we used static as backend, we need to recreate the lib in missing mode
#
#if (INSTALL_SOURCES_AS_STATIC_LIB )
#	if (${INTERAL_LIBS_MODE} EQUAL SHARED)
#		add_library(INTERN_SRC_ALTERNATE_MODE STATIC ${INTERN_SRC})
#		target_include_directories(INTERN_SRC_ALTERNATE_MODE PUBLIC ${sub_dirs})
#		target_link_libraries( INTERN_SRC_ALTERNATE_MODE PUBLIC EXT_SRC ${EXTERNAL_LIBS_FROM_PROJECT} ${FOUNDED_LIBS})
#		set(TO_INSTALL INTERN_SRC_ALTERNATE_MODE)
#	else()
#		set(TO_INSTALL INTERN_SRC_core)
#	endif()
#	INSTALL(TARGETS ${TO_INSTALL} 
#		ARCHIVE DESTINATION ${INSTALL_SOURCES_AS_STATIC_LIB}
#		LIBRARY DESTINATION ${INSTALL_SOURCES_AS_STATIC_LIB}
#		)
#endif()
#
#if (INSTALL_SOURCES_AS_SHARED_LIB )
#	if(${INTERAL_LIBS_MODE} EQUAL STATIC)
#		add_library(INTERN_SRC_ALTERNATE_MODE SHARED ${INTERN_SRC_FILES})
#		target_include_directories(INTERN_SRC_ALTERNATE_MODE PUBLIC ${sub_dirs})
#		target_link_libraries( INTERN_SRC_ALTERNATE_MODE PUBLIC EXT_SRC ${EXTERNAL_LIBS_FROM_PROJECT} ${FOUNDED_LIBS})
#
#		set (TO_INSTALL INTERN_SRC_ALTERNATE_MODE)
#	else()
#		set (TO_INSTALL INTERN_SRC_core)
#	endif()
#	INSTALL(TARGETS ${TO_INSTALL} 
#		ARCHIVE DESTINATION ${INSTALL_SOURCES_AS_STATIC_LIB}
#		LIBRARY DESTINATION ${INSTALL_SOURCES_AS_STATIC_LIB}
#		)
#
#endif()
