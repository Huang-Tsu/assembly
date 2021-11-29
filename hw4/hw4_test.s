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
