# This file allow to get the apropriate language when you have both C++ and C in same project
get_property(ENABLED_LANGUAGES GLOBAL PROPERTY ENABLED_LANGUAGES)
if("CXX" IN_LIST ENABLED_LANGUAGES)
	set (C_OR_CPP_LANG "CXX")
elseif("C" IN_LIST ENABLED_LANGUAGES)
	set (C_OR_CPP_LANG "C")
endif()

