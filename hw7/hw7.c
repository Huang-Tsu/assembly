#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <string.h>

typedef struct timespec timespec;
timespec diff(timespec start, timespec end);

int main(){
	FILE *fptr;
	int i, j;
	timespec time_start, time_end;
	int time_diff[3][2];	//time_diff[input, process, output][tv_sec, tv_nsec]
	
	float a[200][198]__attribute__((aligned));
	float b[200][198]__attribute__((aligned));
	float c[200]__attribute__((aligned));

		
	clock_gettime(CLOCK_MONOTONIC, &time_start);
	fptr = fopen("data.txt", "r");

		//initialize c[]
	for(i=0; i<200; i++){
		c[i] = 0;
	}
	
//============== read data form data.txt ==========
		//build matrix A
	for(i=0; i<200; i++){
		for(j=0; j<198; j++){
			fscanf(fptr, "%e", &a[i][j]);	//read first 200 row in data.txt
		}
	}
		//build matrix B
	for(i=0; i<200; i++){
		for(j=0; j<198; j++){
			fscanf(fptr, "%e", &b[i][j]);	//read 201~400 row in data.txt
		}
	}
		clock_gettime(CLOCK_MONOTONIC, &time_end);
			//count and store time_diff
		time_diff[0][0] = diff(time_start, time_end).tv_sec;
		time_diff[0][1] = diff(time_start, time_end).tv_nsec;
		
	fclose(fptr);

//============== caculate result ===================
	fptr = fopen("output.txt", "w+");

		clock_gettime(CLOCK_MONOTONIC, &time_start);
			//caculate total value of each column of B
	for(i=1; i<200; i++){
		for(j=0; j<198; j++){
			b[0][j] += b[i][j];
		}
			//說明:在READEME.txt當中詳細說明
				//	c[i] = A[i][0]*(B[0][0]+B[1][0]+...+B[200][0]) + A[i][1]*(B[0][1]+B[1][1]+...+B[200][1]) + ... + A[i][197]*(B[0][197]+B[1][197]+...+B[200][197]) 	
				//			 = A[i][0]*(sum of coloumn 0 of b) + A[i][1](sum of coloumn 1 of b) + ... + A[i][1](sum of coloumn 197 of b)
	}

			//compute c[i]
	for(i=0; i<200; i++){
		for(j=0; j<198; j++){
			c[i] +=  a[i][j]*b[0][j];	//each row of A mul corresponding value of total colum of B
		}
	}
		clock_gettime(CLOCK_MONOTONIC, &time_end);
			//count and store time_diff
		time_diff[1][0] = diff(time_start, time_end).tv_sec;
		time_diff[1][1] = diff(time_start, time_end).tv_nsec;

// =============== output ==============
	clock_gettime(CLOCK_MONOTONIC, &time_start);
	for(i=0; i<200; i++){
		fprintf(fptr, "%f\n", c[i]);
	}
		clock_gettime(CLOCK_MONOTONIC, &time_end);
			//count and store time_diff
		time_diff[2][0] = diff(time_start, time_end).tv_sec;
		time_diff[2][1] = diff(time_start, time_end).tv_nsec;

		//print time
	puts("C program without SIMD:");
	printf("\tread time:\tcompute time:\twrite time:\n");
	for(i=0; i<3; i++){
		time_diff[i][0] = time_diff[i][0]*1000000000+time_diff[i][1];
		printf("\t%f", time_diff[i][0]/1000000000.0);
	}
	puts("");

	fclose(fptr);
	
	return 0;
}
timespec diff(timespec start, timespec end){
	timespec temp;
	if ((end.tv_nsec-start.tv_nsec)<0) {
		temp.tv_sec = end.tv_sec-start.tv_sec-1;
		temp.tv_nsec = 1000000000+end.tv_nsec-start.tv_nsec;
	} else {
		temp.tv_sec = end.tv_sec-start.tv_sec;
		temp.tv_nsec = end.tv_nsec-start.tv_nsec;
	}
	return temp;
}
