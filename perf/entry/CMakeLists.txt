add_custom_target(perf-collect-all
	COMMENT "Run all performance collecters")
#-----------You can set theses to modify the interaction with kvhf

# Comment to not allow gone keys
set (allow-gone "--allow-gone-key")

# List to name of executable you want to monitor the size in the perfs
set (exec_to_mesurate_size "exec1;perf-empty")
#-----------

find_program(eprof_bin eprof REQUIRED)
find_program(kvhfutils kvhfutils REQUIRED)

FUNCTION(get_entry_target path name)
	message("\t${path}")
	set (exe_name "perf-${name}")
	add_executable(${exe_name} ${path})
	set (recolt_out "${DATA_PERF_DIR}/results/${name}")
	set (recolt_out_file ${recolt_out}/S)
	target_compile_definitions(${exe_name} PUBLIC EPROF_OUTPUT=\"${recolt_out}\")
	target_link_ring(${exe_name})

	set (target_recolt "perf-collect-${name}")

	add_custom_command(OUTPUT ${recolt_out_file}
		COMMAND ${exe_name}
		COMMENT "Running perf executable ${exe_name}"
		DEPENDS ${exe_name}
		WORKING_DIRECTORY ${DATA_PERF_DIR}
		)

	set (kvf_out ${DATA_PERF_DIR}/results/kvf/${name}.kvf)

	add_custom_command(OUTPUT ${kvf_out}
		COMMAND ${eprof_bin} ${recolt_out} -o ${kvf_out} 
		DEPENDS ${recolt_out_file}
		WORKING_DIRECTORY ${DATA_PERF_DIR}
		COMMENT "Transforming ${name} eprof output to kvf"
		)
	add_custom_target(${target_recolt}
		DEPENDS ${kvf_out}
		WORKING_DIRECTORY ${DATA_PERF_DIR}
		)
	add_dependencies( perf-collect-all  ${target_recolt} )
	#set (${to_install} ${name} PARENT_SCOPE) # It does not make sense to install perf suit
ENDFUNCTION()

ring_entries("Performance collecter" ${DATA_PERF_DIR})

# Agregate all the kvf
add_custom_command(OUTPUT "all.kvf"
	COMMAND ${kvhfutils} kvf -m -o all.kvf
	WORKING_DIRECTORY ${DATA_PERF_DIR}/results
	COMMENT "Merging every kvf files into all.kvf"
	)

add_custom_target(perf-aggregate
	DEPENDS "all.kvf")

add_custom_target(perf-check-resume
	COMMAND ${kvhfutils} --required-length 1 --check-file --actualized all.kvf
	WORKING_DIRECTORY ${DATA_PERF_DIR}/results
	COMMENT "Checking correctness of all.kvf"
	)

add_custom_target(perf-save-resume
	COMMAND kvhfutils -o history.kvhf --historic-merge history.kvhf all.kvf --allow-gone-key
	WORKING_DIRECTORY ${DATA_PERF_DIR}/results
	COMMENT "Adding all.kvf to the history"
	)
add_dependencies(perf-save-resume perf-check-resume)


add_custom_target(perf-collect-size-all
	COMMENT "Collects sizes of wanted targets" )


FOREACH(exec ${exec_to_mesurate_size})
	set(kvf_out ${DATA_PERF_DIR}/results/kvf/size_${exec}.kvf)
	add_custom_command(OUTPUT ${kvf_out} 
		COMMAND  ${CMAKE_COMMAND} -E remove ${kvf_out}
		COMMAND ${PYTHON_EXECUTABLE} ${PROJECT_SOURCE_DIR}/build-helpers/scripts/add_size.py ${kvf_out} $<TARGET_FILE:${exec}> -n ${exec}_size
		DEPENDS ${exec}

		COMMENT "Collect size of ${exec}"
	)

	add_custom_target(perf-collect-size-${exec}
		DEPENDS ${kvf_out}
		)
	add_dependencies(perf-collect-size-all perf-collect-size-${exec})
ENDFOREACH()

add_dependencies(perf-collect-all perf-collect-size-all)


