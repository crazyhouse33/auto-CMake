

# Control external lib dependencies from the system. 
set_if_not_set(LIB_FROM_SYSTEM_code "")
set_if_not_set(LIB_FROM_SYSTEM_test "omptatattata;OpenMP")
set_if_not_set(LIB_FROM_SYSTEM_perf "eprof")

# Set the list of extensions you recognize as headers
set_if_not_set(HEADER_EXTENSIONS "h") 
# Set the list of extensions you recognize as source 
set_if_not_set(SOURCE_EXTENSIONS "c") 

# RENAME targets (use on libs/entries to avoid targets collisions). This wont use the ring prefix. You can use this feature to activate names based functionnalities of generators. For exemple, on make wont print targets starting with __ in the help
# Evaluate to False: dont rename
set_if_not_set (RENAME_ENTRY_code_entry1 my_super_exec) 
set_if_not_set (RENAME_LIB_code_lib1 my_super_lib) 


##### PERF ######
# Allow a key to disapear during 2 consecutives commits)
set (perf-allow-gone ON)

# List to name of executable you want to monitor the size with perf ring mechanism
set (perf-exec_to_mesurate_size "exec1;perf-empty")

##### PERF #####


# Default libraries modes. Set to STATIC or SHARED (SHARED should reduce build time)
set_if_not_set (INTERNAL_LIB_MODE SHARED)
set_if_not_set (INTERNAL_EXT_LIB_MODE SHARED) # Controling the Extern src folder

# Uncomment to put a particular ring as static
#set_if_not_set (INTERNAL_LIB_MODE_code STATIC)
#set_if_not_set (INTERNAL_LIB_MODE_test STATIC)
#set_if_not_set (INTERNAL_LIB_MODE_perf STATIC)
#set_if_not_set (INTERNAL_LIB_MODE_EXT_SRC_perf STATIC) # You can controle the external sources mode as well for each rings
#set_if_not_set (INTERNAL_LIB_MODE_code_ub_lib1 STATIC) # Or a sublib of a particular code
set_if_not_set (INTERNAL_EXT_LIB_MODE_SRC_code_dependenc1 STATIC) 



# Mode of the installed version of libraries. Can be:
#STATIC
#SHARED
#NO: dont install
#SAME the mode will be the same as INTERNAL_LIB_MODE 
set_if_not_set (INSTALL_LIB_MODE NO)
set_if_not_set (INSTALL_EXT_LIB_MODE NO)
#set_if_not_set (INSTALL_LIB_MODE_code STATIC)
#set_if_not_set (INSTALL_LIB_MODE_test SHARED)
#set_if_not_set (INSTALL_LIB_MODE_perf SAME)
set_if_not_set (INSTALL_LIB_MODE_code_sub STATIC) # Or a sublib of a particular code
set_if_not_set (INSTALL_EXT_LIB_MODE_code_dependenc1 SAME) # 



# Uncomment one or both of thoses line to install a whole ring on the system (Never tested, I dont know what will be the mode of installed libs)
#set_if_not_set (INSTALL_RING_code my_lib_name) 
#set_if_not_set (INSTALL_RING_test my_lib_name)
#set_if_not_set (INSTALL_RING_perf my_lib_name)

# DEFAULT install rules of entries: 
# Yes: exec.c -> prefix + exec
# evaluate to false: dont_install
set_if_not_set (INSTALL_ENTRY_code YES) 
set_if_not_set (INSTALL_ENTRY_test NO)
set_if_not_set (INSTALL_ENTRY_perf NO)
#set_if_not_set (INSTALL_ENTRY_code_entry3 NO) # Uncomment to disable installation of entry entry3 from the code ring



######### Theses one you should probably not touch them (#TODO put it elsewhere. Maybe put all the default(INSTALL, MODES...) of code perf and test as well and documentate them)
# Used on targets to avoid collisions
set_if_not_set( RING_PREFIX_code "")
set_if_not_set( RING_PREFIX_test "test-")
set_if_not_set( RING_PREFIX_perf "perf-")
#lib prefix are automatically prepended with lib- for libraries targets (not result file). Prefix have no effect if you set RENAME_ENTRY/LIB on a particular entry. 


# Where to write executable's of entries. Default is to bin/ringname
set_if_not_set( RING_ENTRY_BIN_OUTPUT_perf "${CMAKE_SOURCE_DIR}/rings/perf/data")
set_if_not_set( RING_ENTRY_BIN_OUTPUT_test "${CMAKE_SOURCE_DIR}/rings/test/data")
# set_if_not_set( RING_ENTRY_BIN_OUTPUT_code_entry1 "where_I_want")







