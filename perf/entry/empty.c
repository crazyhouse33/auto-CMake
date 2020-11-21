#include <eprof/eprof.h>

//Here we make the exe work even out of buildsystem
#ifndef EPROF_OUTPUT
#define EPROF_OUTPUT "eprof_res"
#endif

int main(){
	//IMPORTANT the first argument must be results/${name_of_this_file_without_extension} in order for autoCMake to collect properly the kvhf file	
	  Eprof* global_profiler = new_eprofiler(EPROF_OUTPUT, false);//EPROF_OUTPUT come from the build system
	  eprof_event_start(global_profiler, test);
	  eprof_event_end(global_profiler, test);
	  return 0;
}
