
/* ========================= */
/*       DATA section        */
/* ========================= */
	.data
	.align 4
/* ========================= */
/*       TEXT section        */
/* ========================= */
	.section .text
	.global NumSort
	.type NumSort,%function
NumSort:
	/* functnio start */
//	mov ip, sp
//	STMFD sp!, {r4-r10, fp, ip, lr, pc}
//	sub fp, ip, #4
STMFD sp!, {r4-r9, fp, ip, lr}

	/* --- function begin --- */

		/* Get array size from r0 */
	mov r9, r0

		/*Get initial array address from r1 */
	mov r10, r1

		/* allocate memory space for output_array */
	mov r0, r0, lsl #2		//the bytes we need are array_size * 4
	add r0, r0, #4				//prepare extra space for safe
	bl malloc		//return address will store in r0
		/* copy input_array to output_array */
	mov r1, r0
	mov r4, #0 //initialize counter
LOOP_INIT:
	ldr r3, [r10], #4		//copy input_array[r4] to output_array[r4], and let it point to the next idx
	str r3, [r1], #4 	//put the value get from input_array to output_array, and let output_array point to next idx	
	add r4, r4, #1	//add counter 1
	cmp r4, r9			//compare counter with array size
	bne LOOP_INIT		//if not equal, do it again, until 23 times

		/* ------ Do NumSort ------ */
	mov r4, #0 //initialize LOOP_BUBBLE_OUTER counter
	sub r9, #1 //we only need to do 21 times, because we only need to bubble 22 big number to the tail. so minor array_size by 1
	LOOP_BUBBLE_OUTER:
	/* --- inner bubble loop start --- */
		mov r1, r0
		mov r2, #0	//set r2 as LOOP_BUBBLE_INNER counter, and init it as 0
		sub r8, r9, r4	//set the limit of LOOP_BUBBLE_INNER as r8, and init it as array_size - outer counter
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

		add r4, r4, #1	//add counter by 1
		cmp r4, r9			//compare counter with array size
		bne LOOP_BUBBLE_OUTER		//if not equal, do it again, until 23 times
	/* ------ End NumSort ------ */

		/* put result array's address into r1 */
	mov r1, r0


		/* --- function end --- */
	//LDMEA fp, {r4-r10, fp, sp, pc}
	LDMFD sp!, {r4-r9, fp, ip, pc}
	.end
