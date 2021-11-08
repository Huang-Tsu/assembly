/* ========================= */
/*       DATA section        */
/* ========================= */
	.data
	.align 4

/* --- variable a --- */
	.type A, %object
	.size A, 32	//save 32 bytes for matrix A
A:
	.word 1 //[1,1]
	.word 2 //[1,2]
	.word 3 
	.word 4 //[1,4]
	.word 5 //[2,1]
	.word 6
	.word 7
	.word 8 //[2,4]

/* --- variable b --- */
	.type B, %object
	.size B, 32 //save 32 bytes for matrix B
B:
	.word 8 //[1,1]
	.word 7 //[1,2]
	.word 7 //[2,1]
	.word 6 //[2,2]
	.word 4
	.word 3
	.word 2 //[4,1]
	.word 1 //[4,2]

C:
	.space 16, 0 //save 16 bytes for matrix C

/* ========================= */
/*       TEXT section        */
/* ========================= */
	.section .text
	.global main
	.type main,%function
.matrix:
	.word A
	.word B
	.word C
main:
	ldr r0, .matrix     //r0 point to matrix A
	ldr r1, .matrix + 4 //r1 point to matrix B
	ldr r2, .matrix + 8 //r2 point to matrix C

//======Compute [1,1] of C=======
	mov r3, #0 //sum of multiplication
		//first time
	ldr r5, [r0], #4 		//get [1,1] of A, and move r0 to [1,2]
	ldr r6, [r1], #8	 //get [1,1] of B, and move r1 to [2,1]
	mul r4, r5, r6		//multiply corresponding entries
	add r3, r3, r4   //add result of multiplication to sum
		//second time
	ldr r5, [r0], #4 		//get [1,2] of A, and move r0 to [1,3]
	ldr r6, [r1], #8	 //get [2,1] of B, and move r1 to [3,1]
	mul r4, r5, r6		//multiply corresponding entries
	add r3, r3, r4   //add result of multiplication to sum
		//third time
	ldr r5, [r0], #4 		//get [1,3] of A, and move r0 to [1,4]
	ldr r6, [r1], #8	 //get [3,1] of B, and move r1 to [4,1]
	mul r4, r5, r6		//multiply corresponding entries
	add r3, r3, r4   //add result of multiplication to sum
		//forth time
	ldr r5, [r0], #4 		//get [1,4] of A, and move r0 to [2,1]
	ldr r6, [r1], #8	 //get [4,1] of B, and move r1 to [1,2]
	mul r4, r5, r6		//multiply corresponding entries
	add r3, r3, r4   //add result of multiplication to sum

	str r3, [r2], #4	//store the sum of ROW1 of A and COLUM1 of B to [1,1] of C
	
//======Compute [1,2] of C=======
	ldr r0, .matrix  //reset r0 to [1,1] of A
	ldr r1, .matrix + 4 //reset r1 to [1,1] of B
	add r1, #4 		//set the r1 to [1,2] of B because we are going to compute second column of B

	mov r3, #0 //sum of multiplication
		//first time
	ldr r5, [r0], #4 		//get [2,1] of A, and move r0 to [2,2]
	ldr r6, [r1], #8	 //get [1,2] of B, and move r1 to [2,2]
	mul r4, r5, r6    //multiply corresponding entries
	add r3, r3, r4   //add result of multiplication to sum
		//second time
	ldr r5, [r0], #4 		//get [2,2] of A, and move r0 to [2,3]
	ldr r6, [r1], #8	 //get [2,2] of B, and move r1 to [3,2]
	mul r4, r5, r6   //multiply corresponding entries
	add r3, r3, r4   //add result of multiplication to sum
		//third time
	ldr r5, [r0], #4 		//get [2,3] of A, and move r0 to [2,4]
	ldr r6, [r1], #8	 //get [3,2] of B, and move r1 to [4,2]
	mul r4, r5, r6    //multiply corresponding entries
	add r3, r3, r4   //add result of multiplication to sum
		//forth time
	ldr r5, [r0], #4 		//get [2,4] of A, and move r0 to [3,1]
	ldr r6, [r1], #8	 //get [4,2] of B, and move r1 to out of boundary
	mul r4, r5, r6		//multiply corresponding entries
	add r3, r3, r4   //add result of multiplication to sum

	str r3, [r2], #4	//store the sum of ROW1 of A and COLUM2 of B to [1,2] of C

//======Compute [2,1] of C=======
	ldr r0, .matrix 		//r0 point to start of matrix A
	add r0, #16					//Because we want to start from row to of A, we set r0 point to [2,1] of matrix A
	ldr r1, .matrix + 4 //r1 point to matrix B

	mov r3, #0 //sum of multiplication
		//first time
	ldr r5, [r0], #4 		//get [2,1] of A, and move r0 to [2,2]
	ldr r6, [r1], #8	 //get [1,1] of B, and move r1 to [2,1]
	mul r4, r5, r6		//multiply corresponding entries
	add r3, r3, r4	 //add result of multiplication to sum
		//second time
	ldr r5, [r0], #4 		//get [2,2] of A, and move r0 to [2,3]
	ldr r6, [r1], #8	 //get [2,1] of B, and move r1 to [3,1]
	mul r4, r5, r6		//multiply corresponding entries
	add r3, r3, r4   //add result of multiplication to sum
		//third time
	ldr r5, [r0], #4 		//get [2,3] of A, and move r0 to [2,4]
	ldr r6, [r1], #8	 //get [3,1] of B, and move r1 to [4,1]
	mul r4, r5, r6		//multiply corresponding entries
	add r3, r3, r4   //add result of multiplication to sum
		//forth time
	ldr r5, [r0], #4 		//get [2,4] of A, and move to out of boundary
	ldr r6, [r1], #8	 //get [4,1] of B, and move to out of boundary
	mul r4, r5, r6		//multiply corresponding entries
	add r3, r3, r4   //add result of multiplication to sum

	str r3, [r2], #4	//store the sum of ROW2 of A and COLUM1 of B to [2,1] of C
	
//======Compute [2,2] of C=======
	ldr r0, .matrix 		//r0 point to start of matrix A
	add r0, #16					//set r0 point to [2,1] of matrix A
	ldr r1, .matrix + 4 //reset r1 to [1,1] of B
	add r1, #4 		//set r1 point to [1,2] of B because we are going to compute second column of B

	mov r3, #0 //sum of multiplication
		//first time
	ldr r5, [r0], #4 		//get [2,1] of A, and move r0 to [2,2]
	ldr r6, [r1], #8	 //get [1,2] of B, and move r1 to [2,2]
	mul r4, r5, r6		//multiply corresponding entries
	add r3, r3, r4   //add result of multiplication to sum
		//second time
	ldr r5, [r0], #4 		//get [2,2] of A, and move r0 to [2,3]
	ldr r6, [r1], #8	 //get [2,2] of B, and move r1 to [3,2]
	mul r4, r5, r6		//multiply corresponding entries
	add r3, r3, r4   //add result of multiplication to sum
		//third time
	ldr r5, [r0], #4 		//get [2,3] of A, and move r0 to [2,4]
	ldr r6, [r1], #8	 //get [3,2] of B, and move r1 to [4,2]
	mul r4, r5, r6		//multiply corresponding entries
	add r3, r3, r4   //add result of multiplication to sum
		//forth time
	ldr r5, [r0], #4 		//get [2,4] of A, and move r0 to [3,1]
	ldr r6, [r1], #8	 //get [4,2] of B, and move r1 to out of boundary
	mul r4, r5, r6		//multiply corresponding entries
	add r3, r3, r4   //add result of multiplication to sum

	str r3, [r2], #4	//store the sum of ROW2 of A and COLUM2 of B to [2,2] of C

	ldr r1, .matrix + 8  //let r1 point to matrix C (To fulfill the requriment of this assignment:"After computation, register r1 will point to the address of C’s first element.")
        nop

