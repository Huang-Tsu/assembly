#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <xmmintrin.h> 	//_mm_setzero_ps()
#include <pmmintrin.h>	//_mm_hadd_ps()

typedef struct timespec timespec;
timespec diff(timespec start, timespec end);

int main(){
	FILE *fptr;
	int i, j;
	timespec time_start, time_end;
	int time_diff[3][2];	//time_diff[input, process, output][tv_sec, tv_nsec]
	
	float **a = (float**)calloc(200, sizeof(float*));	//allocate 200 row for a
	float **b = (float**)calloc(200, sizeof(float*));
	float temp[4]__attribute__((aligned(16)));		//will be used later in computing c[i]
	float c[200]__attribute__((aligned(16)));

	for(i=0; i<200; i++){
					//calloc will align 16 bytes
		a[i] = (float*)calloc(200, sizeof(float));		//allocate 200 float for each row
		b[i] = (float*)calloc(200, sizeof(float));		//因為__m128一次會存取四個float，故申請200個float，並將最後兩個float初始化為0(calloc自動完成)，也就是實際只觀察前198個float
	}
	__m128 **A = (__m128**)a;			//convert array of float to array of __m128
	__m128 **B = (__m128**)b;
	__m128 *temp_total = (__m128*)temp;

		
		clock_gettime(CLOCK_MONOTONIC, &time_start);
	fptr = fopen("data.txt", "r");		//open file for read only

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
	fptr = fopen("output_simd.txt", "w+");

		clock_gettime(CLOCK_MONOTONIC, &time_start);
			//caculate total value of each column of B
		for(i=1; i<200; i++){
			for(j=0; j*4+3<200; j++){
				B[0][j] = _mm_add_ps(B[0][j], B[i][j]);
			}
			//說明:在READEME.txt當中詳細說明
				//	c[i] = A[i][0]*(B[0][0]+B[1][0]+...+B[200][0]) + A[i][1]*(B[0][1]+B[1][1]+...+B[200][1]) + ... + A[i][197]*(B[0][197]+B[1][197]+...+B[200][197]) 	
				//			 = A[i][0]*(sum of coloumn 0 of b) + A[i][1](sum of coloumn 1 of b) + ... + A[i][1](sum of coloumn 197 of b)
		}

			//compute c[i]
	for(i=0; i<200; i++){
		for(j=0; j*4+7<200; j+=2){
			*temp_total = _mm_add_ps(_mm_mul_ps(A[i][j], B[0][j]), _mm_mul_ps(A[i][j+1], B[0][j+1]));
				//=>把vector a1(4個float, ROWi of A 的j~j+3 column)跟vector b1(Row0 of B(該column的總和) 的j~j+3 column)相乘，再把vector a2 b2相乘，然後把vector a1b1 和vector a2b2加起來，得到vector temp
			for(int k=0; k<4; k++){
				c[i] += temp[k];	//，把上面得到的vector temp裡的4個float + 到c[i]裡面
			}
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
	fclose(fptr);

		//print using time
	puts("C program with SIMD:");
	printf("\tread time:\tcompute time:\twrite time:\n");
	for(i=0; i<3; i++){
		time_diff[i][0] = time_diff[i][0]*1000000000+time_diff[i][1];
		printf("\t%f", time_diff[i][0]/1000000000.0);
	}
	puts("");

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
