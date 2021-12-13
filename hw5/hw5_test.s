/* ========================= */
/*       DATA section        */
/* ========================= */
	.data
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
input_start:
	.asciz "Input array: \000"
format_middle:
	.asciz "%d, \000"
result_start:
	.asciz "Result array: \000"
new_line:
	.asciz "%d\n\000"


/* ========================= */
/*       TEXT section        */
/* ========================= */
	.section .text
	.global main
	.extern printf
	.type main,%function

main:
	MOV ip, sp
	STMFD sp!,{fp, ip, lr, pc}
	SUB fp, ip, #4


		/* ---------------print input array-----------------*/
			//print initial format
	ldr r0, =input_start
	bl printf

			//print the numbers between start and end.
	mov r5, #0	//use r5 as counter, start from second value
PRINTF_INPUT_ARRAY:
	ldr r9, =.input_array
	add r9, r9, r5, lsl #2	//get the address of wanted value, that is, initial addaress + offset
	ldr r0, =format_middle
	ldr r1, [r9]	//get value
	bl printf

	add r5, #1
	cmp r5, #22		//compare r5 with array_size
	bne PRINTF_INPUT_ARRAY
		
		//print new_line
	ldr r9, =.input_array
	ldr r0, =new_line
	ldr r1, [r9, #88]	//get the value of final address
	bl printf

		/* put array size into r0 */
	mov r0, #23

		/* put array address into r1 */
	ldr r1, =.input_array
		/*-------------- end print input array------------*/

	bl NumSort

			/* --- print result --- */
	mov r10, r0 					//r10 point ot output array

		/* print output array */
			//print initial format
	mov r8, r10	//r8:temp initial address of result array
	ldr r0, =result_start
	bl printf

			//print the numbers between start and end.
	mov r5, #0	//use r5 as counter, start from first value
PRINTF_OUTPUT_ARRAY:
	//ldr r9, =.input_array
	mov r8, r10			//
	add r8, r8, r5, lsl #2	//get the address of wanted value, that is, initial addaress + offset
	ldr r0, =format_middle
	ldr r1, [r8]	//get value
	bl printf

	add r5, #1
	cmp r5, #22		//compare r5 with array_size-1, because I will only print 22 numbers, and left the final one in the end
	bne PRINTF_OUTPUT_ARRAY
		
		//print new_line
	mov r8, r10
	ldr r0, =new_line
	ldr r1,	[r8, #88] //get the value of final address
	bl printf

	nop
	LDMEA fp,{fp, sp, pc}
	.end
