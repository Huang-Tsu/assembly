#include <stdio.h>
#include <stdlib.h>

#define GOLDEN_RATIO  0.61803398		//Golden ratio, for hash function

int main(){
	FILE *fptr = fopen("data.txt", "w+");
	int i, j;
	float test;
	int data;
	
	for(i=0; i<400; i++){
		for(j=0; j<198; j++){
			data = random();	
			test = (int)(3.0*((double)data*GOLDEN_RATIO - (int)((double)data*GOLDEN_RATIO)));
			//fprintf(fptr, "%ld ", random() & ((1<<4)-1));
			fprintf(fptr, "%f ", test);
		}
		fprintf(fptr, "\n");
	}
	
	fclose(fptr);
	
	return 0;
}
