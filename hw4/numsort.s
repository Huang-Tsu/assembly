	.section .text
	.global NumSort
	.type NumSort,%function

NumSort:
	/* functnio start */
	STMFD sp!, {r0-r9, fp, ip, lr}

	/* --- function begin --- */

	/* Get array size from r9 */

	/*Get array address from r10 */

	/* ------ Do NumSort ------ */

	/* ------ End NumSort ------ */

	/* put result array's address into r10 */


	/* --- function end --- */
	LDMFD sp!, {r0-r9, fp, ip, pc}
	.end
