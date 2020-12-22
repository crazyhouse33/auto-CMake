#include "ext_src.h"
#include "ext_lib.h"
#include "int_src.h"

int main(){

	ext_src();
	ext_lib();
	ext_lib2();//This is to check linker map generation format
	int_src();

}
