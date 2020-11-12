ring_ext_lib()

# YOU MUST CREATE THE CMAKE LIBRARY THERE and call add_to_fs_libs on it
add_subdirectory(an_extern_lib) 
add_to_fs_libs(ext_lib_normal)


