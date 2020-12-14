# Uninstalable  entries, and we use the normal procedures for targets
init_ring(perf NO)
# Shared perf sources
add_subdirectory(src)

# Compile and link perf collecters
add_subdirectory(entry)

# Compile external programs needed for tests
add_subdirectory(needed)

