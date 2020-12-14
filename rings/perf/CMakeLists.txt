init_ring(perf)
# Shared perf sources
add_subdirectory(src)

# Compile and link perf collecters
add_subdirectory(entry)

# Compile external programs needed for tests
add_subdirectory(needed)

