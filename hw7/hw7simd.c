#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <xmmintrin.h> 	//_mm_setzero_ps()

typedef struct timespec timespec;
timespec diff(timespec start, timespec end);

int main(){
	FILE *fptr;
	int i, j;
	timespec time_start, time_end;
	int time_diff[3][2];	//time_diff[input, process, output][tv_sec, tv_nsec]

	fptr = fopen("data.txt", "r");
	
	float **a = (float**)calloc(200, sizeof(float*));
	float **b = (float**)calloc(200, sizeof(float*));
	float b_column_total[198]__attribute__((aligned(16)));		//store the total value of each column in b
	float c[200]__attribute__((aligned(16)));
	float temp[4] __attribute__((aligned(16)));
	float temp1[4] __attribute__((aligned(16)));
	for(i=0; i<200; i++){
		a[i] = (float*)calloc(198, sizeof(float));	//calloc will align 16 bytes
		b[i] = (float*)calloc(198, sizeof(float));
	}
	__m128 **A = (__m128**)a;
	__m128 **B = (__m128**)b;
	__m128 *B_total = (__m128*)b_column_total;
	__m128 *C = (__m128*)c;
	__m128 *temp_total = (__m128*)temp;
	__m128 *temp_total1 = (__m128*)temp1;

		
		clock_gettime(CLOCK_MONOTONIC, &time_start);
		//initialize b_column_total[] & c[]
	*B_total = _mm_setzero_ps();
	*C = _mm_setzero_ps();

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
	fptr = fopen("output_simd.txt", "w+");

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
	/*
	for(i=0; i<200; i+=2){
		for(j=0; (j+1)*4<198; j++){
			B_total[j] += _mm_add_ps(B[i][j], B[i+1][j]);
					printf("B[%d][%d]:%p, B[%d][%d]:%p\n", i, j, &B[i][j], i+1, j, &B[i+1][j]);
				printf("i:%d, j:%d\n", i, j);
				for(int k=0; k<4; k++){
					printf("b_total[%d]:%f\n", j*4+k, b_column_total[j+k]);
				}
		}
	}
	*/
					for(i=1; i<200; i++){
						for(j=0; (j+1)*4<198; j++){
							B[0][j] = _mm_add_ps(B[0][j], B[i][j]);
								printf("i:%d, j:%d\n", i, j);
								for(int k=0; k<4; k++){
									printf("b[0][%d]:%f\n", j*4+k, b[0][j*4+k]);
								}
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

		//free()
	for(i=0; i<200; i++){
		free(a[i]), free(b[i]);
	}
	free(a), free(b);
	
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
