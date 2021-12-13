/* ========================= */
/*       DATA section        */
/* ========================= */
	.data
	.align 4
/* --- input array --- */
	.type input_array, %object
	.size input_array, 400	//save 400(100 numbers) bytes for input array
.input_format_start:
	.asciz "Input array: %d"
.input_format_middle:
	.asciz ", %d"

.output_format_start:
	.asciz "Output array: %d\000"
.output_format_middle:
	.asciz ", %d\000"

.print_next_line:
	.asciz "\n\000"

.input_array:
	.word 123
	.word 423
	.word 98123
	.word 1231
	.word 1111
	.word 2222
	.word 1212
	.word 12389124
	.word 123111
	.word 52341
	.word 51341234
	.word 1
	.word 5
	.word 4
	.word 123
	.word 1233
	.word 9191
	.word 919
	.word 19231
	.word 1291
	.word 923852
	.word 999
	.word 0

/* ========================= */
/*       TEXT section        */
/* ========================= */
	.section .text
	.global main
	.type main,%function


main:
	MOV ip, sp
	STMFD sp!,{fp, ip, lr, pc}
	SUB fp, ip, #4


		/* put array size into r0 */
	mov r0, #23

		/* put array address into r1 */
	ldr r1, =.input_array

	bl NumSort

		/*
			 r0:format fof printf()
			 r1:input value of printf()
			 r5:counter for LOOP for printf()
			 r6:offset
			 r7:address of value now
			 r9:starting address of input array
			 r10:start address of output array
		*/
	ldr r9, =.input_array		//r9 point to input array
	mov r10, r0 					//r10 point ot output array
			/* --- print result --- */
		/* print input array */
			//print initial format
	ldr r0, =.input_format_start
	ldr r1, [r9] 	//get first element of input_array and move forward one word-size
	bl printf

			//print the numbers between start and end.
	mov r5, #1	//use r5 as counter, start from second value
PRINTF_INPUT_ARRAY:
	mov r6, r5, lsl #2 //r6:offest from starting address of input array
	ldr r9, =.input_array
	add r7, r9, r6	//get the address of wanted value, that is, initial addaress + offset
	ldr r0, =.input_format_middle
	ldr r1, [r7]	//get value
	bl printf

	add r5, #1
	cmp r5, #23		//compare r5 with array_size
	bne PRINTF_INPUT_ARRAY
		
		//print new_line
	ldr r0, =.print_next_line
	bl printf

	
	

		/* print output array */
			//print initial format
	ldr r0, =.output_format_start
	ldr r1, [r1] 	//get first element of input_array and move forward one word-size
	bl printf

			//print the numbers between start and end.
	mov r5, #1	//use r5 as counter, start from second value
PRINTF_OUTPUT_ARRAY:
	mov r6, r5, lsl #2 //r6:offest from starting address of input array
	//ldr r9, =.input_array
	add r7, r10, r6	//get the address of wanted value, that is, initial addaress + offset
	ldr r0, =.output_format_middle
	ldr r1, [r7]	//get value
	bl printf

	add r5, #1
	cmp r5, #23		//compare r5 with array_size
	bne PRINTF_OUTPUT_ARRAY
		
		//print new_line
	ldr r0, =.print_next_line
	bl printf

	nop
	LDMEA fp,{fp, sp, pc}
	.end
