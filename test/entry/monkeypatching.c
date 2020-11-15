#include "shared_test.h"
#include "ext_test_lib.h"
#include "munit.h"//This is to test that we access ext_test_src part of test ring

#include "ext_src.h"
#include "ext_lib.h"
#include "int_src.h"
#include <stdio.h>

//testing the monkey pathching of internal sources  (int_src just crash normally)
//TODO it would be good to test the monkey patching of everything, but I am lazy
void int_src(){
	puts("int_src");
	//Test reading from the good place
	FILE *fp;
	char buff[255];

	fp = fopen("data.dat", "r");
	fscanf(fp, "%s", buff);
	printf("content of data.dat: %s\n", buff );
   	fclose(fp);

	//Test that the produce is at the good place
	remove("product/test_prod.out");


   	fp = fopen("/tmp/test.txt", "w");
   	fprintf(fp, "Output of my test");
   	fclose(fp);
}

int main(){
	ext_src();
	ext_lib();
	
	shared_test();
	ext_test_lib();
	munit_assert_true(1);
	int_src();
	return 0;

}
