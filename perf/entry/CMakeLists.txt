add_custom_target(perf-collect-all
		COMMENT "Run all performance collecters")

FUNCTION(get_entry_target path name)
	message("\t${path}")
	set (exe_name "perf-${name}")
	add_executable(${exe_name} ${path})
	target_link_ring(${exe_name})
	
	set (target_recolt "perf-collect-${name}")

	add_custom_target(${target_recolt}
		         COMMAND ${exe_name}
			 WORKING_DIRECTORY ${DATA_PERF_DIR}
			 )
	add_dependencies( perf-collect-all  ${target_recolt} )
ENDFUNCTION()

ring_entries("Performance collecter")



# Add some target s
#add_custom_target(eprof-get-resume
#	DEPENDS authbreak perf_attaque
#	COMMENT "Extract eprof resume"
#	COMMAND authbreak --allow-miss "perf_attaque '{0:3,charset=0123456789}'" -s status==1;
#	WORKING_DIRECTORY ${EXECUTABLE_OUTPUT_PATH}
#	USES_TERMINAL
#)
#
#set(perf_dir  ${PROJECT_SOURCE_DIR}/perfs)
#
#add_custom_target(kvhf
#DEPENDS kvhf-check
#COMMENT "Accumulate the per commit file to the historic one"
#	COMMAND kvhfutils -o ${perf_dir}/accumulator.kvhf --historic-merge ${perf_dir}/accumulator.kvhf ${perf_dir}/commit_resume.hkvf --allow-gone-key
#	VERBATIM
#	USES_TERMINAL
#)
#
#add_custom_target(kvhf-check
#	COMMENT "Check that the per commit kvhf resume is actualized and aligned"
#	COMMAND kvhfutils --required-length 1 --check-file --actualized ${perf_dir}/commit_resume.hkvf 
#	VERBATIM
#	USES_TERMINAL
#)
#
#add_custom_target(kvhf-add-size
#	DEPENDS kvhf-create
#	COMMENT "Add size of executable to kvhf file"
#	COMMAND ${PYTHON_EXECUTABLE} add_size.py 
#	VERBATIM
#	USES_TERMINAL
#	WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}/build-helpers/scripts
#)
#
#
#add_custom_target(kvhf-create
#	DEPENDS eprof-get-resume
#	COMMENT "Extract hkvf"
#	COMMAND eprof authbreak_perfs -o ${perf_dir}/commit_resume.hkvf
#	VERBATIM
#	WORKING_DIRECTORY ${EXECUTABLE_OUTPUT_PATH}
#	USES_TERMINAL
#)
#
#
