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
	ldr r3, [r10], #4		//copy input_array[r0] to output_array[r0], and let it point to the next idx
	str r3, [r1], #4 	//put the value get from input_array to output_array, and let output_array point to next idx	
	add r0, r0, #1	//add counter 1
	cmp r0, r9			//compare counter with array size
	bne LOOP_INIT		//if not equal, do it again, until 23 times

	/* ------ Do NumSort ------ */
	mov r0, #0 //initialize LOOP_BUBBLE_OUTER counter
	sub r9, #1 //we only need to do 21 times, because we only need to bubble 22 big number to the tail. so minor array_size by 1
	LOOP_BUBBLE_OUTER:
	/* --- inner bubble loop start --- */
		ldr r1, .output_array
		mov r2, #0	//set r2 as LOOP_BUBBLE_INNER counter, and init it as 0
		sub r8, r9, r0	//set the limit of LOOP_BUBBLE_INNER as r8, and init it as array_size - outer counter
		LOOP_BUBBLE_INNER:
			ldr r5, [r1]		//set r5 as the compared value 1
			ldr r6,	[r1, #4] //set r6 as the compared value 2

			cmp r5, r6		//compare two values

				//if r5 greater then r6, then swap the value, and store it back to register
			movgt r7, r5		//r7:temp register(for swap)
			movgt r5, r6
			movgt r6, r7
			strgt r5, [r1]
			strgt r6, [r1, #4]

			add r1, #4		//move r1 to next idx
			
			add r2, r2, #1	//add counter by 1
			cmp r2, r8			//compare counter with array size
			bne LOOP_BUBBLE_INNER		//if not equal, do it again, until limit
	/* --- inner bubble loop end --- */

		add r0, r0, #1	//add counter by 1
		cmp r0, r9			//compare counter with array size
		bne LOOP_BUBBLE_OUTER		//if not equal, do it again, until 23 times
	/* ------ End NumSort ------ */

	/* put result array's address into r10 */
	ldr r10, .output_array


	/* --- function end --- */
	LDMFD sp!, {r0-r9, fp, ip, pc}
	.end
