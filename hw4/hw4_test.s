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
/* ========================= */
/*       TEXT section        */
/* ========================= */
	.section .text
	.global main
	.type main,%function

main:
	MOV ip, sp
	STDFD sp!,{fp, ip, lr, pc}
	SUB fp, ip, #4

	/* prepare input array */
	//...

	/* put array size into r9 */

	/* put array address into r10 */

	bl NumSort
	/* --- end of NumSort --- */
	nop
	LDMEA fp,{fp, sp, pc}
	.end
