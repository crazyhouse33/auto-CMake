#Join a list with GLUE
MACRO(JOIN VALUES GLUE OUTPUT)
	string (REPLACE ";" "${GLUE}" _TMP_STR "${VALUES}")
	set (${OUTPUT} "${_TMP_STR}")
ENDMACRO()

MACRO(set_if_not_set var value)
	if (NOT DEFINED ${var})
		set(${var} ${value})
	endif()	
ENDMACRO(set_if_not_set)
