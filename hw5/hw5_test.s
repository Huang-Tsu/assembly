/* ========================= */
/*       DATA section        */
/* ========================= */
	.data
	.align 4
/* --- input array --- */
	.type input_array, %object
	.size input_array, 400	//save 400(100 numbers) bytes for input array
.input_format:
	.ascii "Input array: %d\n\000"
.output_format:
	.ascii "Output array: %d\000"
input_array:
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

.input_array:
	.word input_array


main:
	MOV ip, sp
	STMFD sp!,{fp, ip, lr, pc}
	SUB fp, ip, #4


		/* put array size into r0 */
	mov r0, #23

		/* put array address into r1 */
	ldr r1, .input_array

	bl NumSort

	ldr r9, .input_array		//r9 point to input array
		mov r9, r9
	mov r10, r1 					//r10 point ot output array
			/* --- print result --- */
		/* print input array */
	ldr r0, =.input_format	
	mov r1, #100 	//get first element of input_array and move forward one word-size
	bl printf

		/* print output array */

	nop
	LDMEA fp,{fp, sp, pc}
	.end
