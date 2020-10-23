#include "shared_test.h"
#include "ext_test_src.h"
#include "ext_test_lib.h"

#include "ext_src.h"
#include "ext_lib.h"
#include "int_src.h"

int main(){
	ext_src();
	ext_lib();
	int_src();

	shared_test();

}
