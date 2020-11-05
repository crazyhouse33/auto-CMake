#My cmake basic functions to do cool stuff

# List subdir
MACRO(SUBDIRLIST result curdir)
  FILE(GLOB_RECURSE children CONFIGURE_DEPENDS LIST_DIRECTORIES true ${curdir}/* )

  SET(dirlist "")
  FOREACH(child ${children})
    IF(IS_DIRECTORY ${child})
      LIST(APPEND dirlist ${child})
    ENDIF()
  ENDFOREACH()

  SET(${result} ${dirlist})
ENDMACRO()

#List subdir and dir
MACRO(DIR_AND_SUBDIRS_LIST result curdir)
SUBDIRLIST( SUBS curdir)
set(${result} ${curdir}) 
LIST(APPEND ${result} {$SUBS})
ENDMACRO()




# Append/return non hidden subdirectories and dir to out
MACRO(get_non_hidden_subdirectories directory out)
SUBDIRLIST(subdirs ${directory})

list (APPEND ${out} ${directory})

get_filename_component(absdirectory ${directory} REALPATH )
FOREACH(sub ${subdirs})
	string(REPLACE ${absdirectory} "" relative ${sub}) #Here lie the trick to not include .git and other bullshit
	IF (NOT ${relative} MATCHES ".*/\\..*")
		list (APPEND ${out} ${sub})
	ENDIF()
ENDFOREACH()
ENDMACRO(get_non_hidden_subdirectories)

MACRO(get_include_dirs dir out)

get_non_hidden_subdirectories( ${dir} ${out})
#Filter thoses that dont contain any .h

ENDMACRO()

MACRO(add_include_dirs dir)
get_include_dirs( ${dir} out)
JOIN("${out}" "\n\t\t" pretty)
message ("\n\tAdding include dirs:\n\n\t\t${pretty}")
include_directories(${out})
ENDMACRO()


MACRO(add_include_dirs_target dir target)

get_include_dirs( ${dir} out)

JOIN("${out}" "\n\t\t" pretty)
message ("\n\tAdding include dirs:\n\n\t\t${pretty}")
target_include_directories(${target} PUBLIC ${out})

ENDMACRO()


#Join a list with GLUE
MACRO(JOIN VALUES GLUE OUTPUT)
  string (REPLACE ";" "${GLUE}" _TMP_STR "${VALUES}")
  set (${OUTPUT} "${_TMP_STR}")
ENDMACRO()


MACRO(get_C_sources directory out)
file(GLOB_RECURSE ${out} CONFIGURE_DEPENDS ${directory}/*.h ${directory}/*.c)
ENDMACRO(get_C_sources)

MACRO(set_if_not_set var value)
	if (NOT DEFINED ${var})
		set(${var} ${value})
	endif()	
ENDMACRO(set_if_not_set)