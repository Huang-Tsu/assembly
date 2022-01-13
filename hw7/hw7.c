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

	fptr = fopen("data.txt", "r");
	
	float a[200][198]__attribute__((aligned));
	float b[200][198]__attribute__((aligned));
	float b_column_total[198]__attribute__((aligned));		//store the total value of each column in b
	float c[200]__attribute__((aligned));

		
		clock_gettime(CLOCK_MONOTONIC, &time_start);
		//initialize b_column_total[] & c[]
	memset(b_column_total, 0, 198*sizeof(float));
	memset(c, 0, 198*sizeof(float));

			//input data.txt
		//build A
	for(i=0; i<200; i++){
		for(j=0; j<198; j++){
			fscanf(fptr, "%e", &a[i][j]);	//read first 200 row in data.txt
		}
	}
		//build B
	for(i=0; i<200; i++){
		for(j=0; j<198; j++){
			fscanf(fptr, "%e", &b[i][j]);	//read 201~400 row in data.txt
		}
	}
	
		clock_gettime(CLOCK_MONOTONIC, &time_end);
		time_diff[0][0] = diff(time_start, time_end).tv_sec;
		time_diff[0][1] = diff(time_start, time_end).tv_nsec;
		
	fclose(fptr);

	//============== caculate result ===================
	fptr = fopen("output.txt", "w+");

		clock_gettime(CLOCK_MONOTONIC, &time_start);
		//caculate total of each column
				//because C[i] = A[i][0]*B[0][0] + A[i][1]*B[0][1] + ... + A[i][197]*B[0][197]	//i row of A * 0 row of B
				//						 + A[i][0]*B[1][0] + A[i][1]*B[1][1] + ... + A[i][197]*B[1][197]	//i row of A * 1 row of B
				//						 + A[i][0]*B[2][0] + A[i][1]*B[2][1] + ... + A[i][197]*B[2][197]	//i row of A * 2 row of B
				//						 + A[i][0]*B[3][0] + A[i][1]*B[3][1] + ... + A[i][197]*B[3][197]	//i row of A * 3 row of B
				//						 +
				//						 .
				//						 .
				//						 .
				//						 +
				//						 + A[i][0]*B[200][0] + A[i][1]*B[200][1] + ... + A[i][197]*B[200][197]	//i row of A * 200 row of B
				//thus	  c[i] = A[i][0]*(B[0][0]+B[1][0]+...+B[200][0]) + A[i][1]*(B[0][1]+B[1][1]+...+B[200][1]) + ... + A[i][197]*(B[0][197]+B[1][197]+...+B[200][197]) 	
				//						 = A[i][0]*(sum of coloumn 0 of b) + A[i][1](sum of coloumn 1 of b) + ... + A[i][1](sum of coloumn 197 of b)
	for(i=1; i<200; i++){
		for(j=0; j<198; j++){
			b[0][j] += b[i][j];
		}
	}

	for(i=0; i<200; i++){
		for(j=0; j<198; j++){
			c[i] +=  a[i][j]*b[0][j];
		}
	}
		clock_gettime(CLOCK_MONOTONIC, &time_end);
		time_diff[1][0] = diff(time_start, time_end).tv_sec;
		time_diff[1][1] = diff(time_start, time_end).tv_nsec;

		clock_gettime(CLOCK_MONOTONIC, &time_start);
		//outupt
	for(i=0; i<200; i++){
		fprintf(fptr, "%f\n", c[i]);
	}
		clock_gettime(CLOCK_MONOTONIC, &time_end);
		time_diff[2][0] = diff(time_start, time_end).tv_sec;
		time_diff[2][1] = diff(time_start, time_end).tv_nsec;

	for(i=0; i<3; i++){
		fprintf(fptr, "%d.%d\n", time_diff[i][0], time_diff[i][1]);
	}
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
