set(EXECUTABLE_OUTPUT_PATH ${PROJECT_SOURCE_DIR}/bin)
message("Executable discovery:\n")
file(GLOB_RECURSE EXES *.c)
foreach(file ${EXES})
  get_filename_component (name_without_extension ${file} NAME_WE)
  message("\t${file} detected as an executable to build")
  add_executable(${name_without_extension} ${file})
  target_link_libraries(${name_without_extension} INTERN_SRC EXT_SRC)
  INSTALL(TARGETS ${name_without_extension}
	RUNTIME DESTINATION ${name_without_extension} 
  )
endforeach()


