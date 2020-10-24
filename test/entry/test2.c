#include "shared_test.h"
#include "ext_test_src.h"
#include "ext_test_lib.h"

#include "ext_src.h"
#include "ext_lib.h"
#include "int_src.h"

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
	ext_test_src();
	int_src();

}
