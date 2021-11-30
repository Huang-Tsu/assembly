/* ========================= */
/*       DATA section        */
/* ========================= */
	.data
	.align 4

/* --- output array --- */
output_array:
	.space 400, 0//save 400(100 numbers) bytes for output array

/* ========================= */
/*       TEXT section        */
/* ========================= */
	.section .text
	.global NumSort
	.type NumSort,%function

.output_array:
	.word output_array	
NumSort:
	/* functnio start */
	STMFD sp!, {r0-r9, fp, ip, lr}

	/* --- function begin --- */

	/* Get array size from r9 */
	mov r9, r9

	/*Get array address from r10 */
	mov r10, r10

	/* copy input_array to output_array */
	ldr r1, .output_array
	mov r0, #0 //initialize counter
LOOP_INIT:
	ldr r1, [r10, r0]		//copy input_array[r0] to output_array[r0]	
	add r0, r0, #1	//add counter 1
	cmp r0, r9			//compare counter with array size
	bne LOOP_INIT		//if not equal, do it again, until 23 times

	/* ------ Do NumSort ------ */

	/* ------ End NumSort ------ */

	/* put result array's address into r10 */


	/* --- function end --- */
	LDMFD sp!, {r0-r9, fp, ip, pc}
	.end
