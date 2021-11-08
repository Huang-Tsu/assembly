/* ========================= */
/*       DATA section        */
/* ========================= */
	.data
	.align 4

/* --- variable a --- */
	.type A, %object
	.size A, 32	;save 8 bytes for matrix A
A:
	.word 1 ;[1,1]
	.word 2 ;[1,2]
	.word 3 
	.word 4 ;[1,4]
	.word 5 ;[2,1]
	.word 6
	.word 7
	.word 8 ;[2,4]

/* --- variable b --- */
	.type B, %object
	.size B, 32 ;save 8 bytes for matrix B
B:
	.word 8 ;[1,1]
	.word 7 ;[1,2]
	.word 7 ;[2,1]
	.word 6 ;[2,2]
	.word 4
	.word 3
	.word 2 ;[4,1]
	.word 1 ;[4,2]

C:
	.space 16, 0 ;save 4 bytes for matrix C

/* ========================= */
/*       TEXT section        */
/* ========================= */
	.section .text
	.global main
	.type main,%function
.matrix:
	.word a
	.word b
	.word c
main:
	ldr r0, .matrix
	ldr r1, [r0], #4  /* r1 := mem32[r0] */
			  /* r0 := r0 + 4    */
	ldr r2, [r0]

	ldr r0, .matrix + 4
	ldr r3, [r0]      /* r3 := mem32[r0] */

	ldr r4, .matrix + 8

	mul r5, r3, r1
	mul r6, r3, r2

	str r5, [r4], #4  /* mem32[r4] := r5 */
                          /* r4 := r4 + 4    */
	str r6, [r4]
        nop

