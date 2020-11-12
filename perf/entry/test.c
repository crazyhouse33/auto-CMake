#include <eprof/eprof.h>

int main(){
	  Eprof* global_profiler = new_eprofiler("results/test", true);
	  eprof_event_start(global_profiler, test);
	  eprof_event_end(global_profiler, test);
	  return 0;
}
