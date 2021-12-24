.set SWI_Write, 0x5
.set SWI_Open, 0x1
.set SWI_Close, 0x2
.set AngelSWI, 0x123456
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

.sprintf_format1:
	.asciz	"%d\000"
	.align	4
.sprintf_format2:
	.asciz	", %d\000"
	.align	4
.printf_format:
	.asciz	"%s\000"
	.align	4
.result_string_adr:
	.space  4400, 0		//at most 100 number, -> 4000bytes
	.align 	4

	//for SWI
filename:
	.asciz "result.txt\000"
.open_param:
	.word filename
	.word 0x4
	.word 0xa		//length of "result.txt"
.write_param:
	.space 4   /* file descriptor */
	.space 4   /* address of the string */
	.space 4   /* length of the string */
.close_param:
	.space 4
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

		//===== prepare array size and input_array address =====
		/* put array size into r0 */
	mov r0, #23

		/* put array address into r1 */
	ldr r1, =.input_array

		// Number sort start
	bl NumSort
		// Number sort end

	mov r10, r0 					//put the address of result array in r10

			// ============ transform integer array to character array ==============

			//transform first element of sorted array because it's format is different
	ldr r0, =.result_string_adr		
	ldr r1, =.sprintf_format1
	ldr r2, [r10], #4		//move r10 one word forward
	bl sprintf

	mov r4, #1			//set r4 as counter
IntegerToString:			//====== loop start =========
	ldr r0, =.result_string_adr
	bl strlen			//get the string length of result_string_adr right now
	mov r3, r0		//store the length in r3

	ldr r0, =.result_string_adr
	add r0, r3		//next word sould insert in the end of result_string_adr
	ldr r1, =.sprintf_format2
	ldr r2, [r10], #4		//move r10 one word forward
	bl sprintf

	add r4, #1
	cmp r4, #23
	bne IntegerToString
			//======== loop end =============
	
			// ====================== transform end ======================


			//================= put result array into result.txt ===============
		//get length of string, I will use this length in write later
	ldr r0, =.result_string_adr
	bl strlen			//get the string length of result_string_adr right now
	mov r7, r0		//store the length of string in r7

		//open a file
	mov r0, #SWI_Open
	ldr r1, =.open_param
	swi AngelSWI
	mov r2, r0                /* r2 is file descriptor */

		//write sorted array into the file
	ldr r1, =.write_param
	str r2, [r1, #0]          /* store file descriptor */
	
	ldr r3, =.result_string_adr
	str r3, [r1, #4]          /* store the address of string */

	mov r3, r7								//move the length of string from r7(which we got in above) to r3
	str r3, [r1, #8]          /* store the length of the string */

	mov r0, #SWI_Write
	swi AngelSWI

		// close a file 
	ldr r1, =.close_param
	str r2, [r1, #0]					/* store file descriptor into r1(argument array) */
	
	mov r0, #SWI_Close
	swi AngelSWI
	
	nop
	LDMEA fp,{fp, sp, pc}
	.end
