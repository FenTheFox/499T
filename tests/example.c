#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "hwtime.h"

int main(int argc, char const *argv[])
{	
	void *helloptr = malloc(10),
		*worldptr = malloc(100);
	
	printf("Malloc'd %d bytes\n", 110);

	return 0;
}