.extern _bss_start
.extern _bss_end
.extern _text_end
.extern _data_start
.extern _data_end

.section .startup

.text

vectors:
	dc.l	0x420000		/* Initial stack pointer */
	dc.l	start			/* Start of program Code */
	dc.l	INT			/* Bus error */
	dc.l	INT 			/* Address error */
	dc.l	INT			/* Illegal instruction */
	dc.l	INT			/* Division by zero */
	dc.l	INT			/* CHK exception */
	dc.l	INT			/* TRAPV exception */
	dc.l	INT			/* Privilage violation */
	dc.l	INT			/* TRACE exception */
	dc.l	INT			/* Line-A emulator */
	dc.l	INT			/* Line-F emulator */
	dc.l	INT			/* Reserved (NOT USED) */
	dc.l	INT			/* Co-processor protocol violation */
	dc.l	INT			/* Format error */
	dc.l	INT			/* Uninitialized Interrupt */
	dc.l	INT			/* Reserved (NOT USED) */
	dc.l	INT			/* Reserved (NOT USED) */
	dc.l	INT			/* Reserved (NOT USED) */
	dc.l	INT			/* Reserved (NOT USED) */
	dc.l	INT			/* Reserved (NOT USED) */
	dc.l	INT			/* Reserved (NOT USED) */
	dc.l	INT			/* Reserved (NOT USED) */
	dc.l	INT			/* Reserved (NOT USED) */
	dc.l	INT			/* Spurious Interrupt */
	dc.l	INT			/* IRQ Level 1 */
	dc.l	INT			/* IRQ Level 2 */
	dc.l	INT			/* IRQ Level 3 */
	dc.l	INT			/* IRQ Level 4 */
	dc.l	INT			/* IRQ Level 5 */
	dc.l	INT			/* IRQ Level 6 */
	dc.l	INT			/* IRQ Level 7 */
	dc.l	INT			/* TRAP #00 Exception */
	dc.l	INT			/* TRAP #01 Exception */
	dc.l	INT			/* TRAP #02 Exception */
	dc.l	INT			/* TRAP #03 Exception */
	dc.l	INT			/* TRAP #04 Exception */
	dc.l	INT			/* TRAP #05 Exception */
	dc.l	INT			/* TRAP #06 Exception */
	dc.l	INT			/* TRAP #07 Exception */
	dc.l	INT			/* TRAP #08 Exception */
	dc.l	INT			/* TRAP #09 Exception */
	dc.l	INT			/* TRAP #10 Exception */
	dc.l	INT			/* TRAP #11 Exception */
	dc.l	INT			/* TRAP #12 Exception */
	dc.l	INT			/* TRAP #13 Exception */
	dc.l	INT			/* TRAP #14 Exception */
	dc.l	INT			/* TRAP #15 Exception */
	dc.l	INT			/* (FP) Branch or Set on Unordered Condition */
	dc.l	INT			/* (FP) Inexact Result */
	dc.l	INT			/* (FP) Divide by Zero */
	dc.l	INT			/* (FP) Underflow */
	dc.l	INT			/* (FP) Operand Error */
	dc.l	INT			/* (FP) Overflow */
	dc.l	INT			/* (FP) Signaling NAN */
	dc.l	INT			/* (FP) Unimplemented Data Type */
	dc.l	INT			/* MMU Configuration Error */
	dc.l	INT			/* MMU Illegal Operation Error */
	dc.l	INT			/* MMU Access Violation Error */
	dc.l	INT			/* Reserved (NOT USED) */
	dc.l	INT			/* Reserved (NOT USED) */
	dc.l	INT			/* Reserved (NOT USED) */
	dc.l	INT			/* Reserved (NOT USED) */
	dc.l	INT			/* Reserved (NOT USED) */

start:
	lea     0x420000,%sp	/* set our stack pointer! */


hwinit:


clearbss:
	#clear bss
	lea.l	_bss_start,%a0	/* Clear bss */
	move.l	#_bss_end,%d0
1:	cmp.l	%d0,%a0
	beq.s	2f
	clr.b	(%a0)+
	bra.s	1b
2:

copydata:
        lea.l   _text_end,%a0   /* data is located after the text */
        lea.l   _data_start,%a1 /* the data's real start address */
        move.l  #_data_end,%d0  /* the data's real end address */
1:      cmp.l   %a1,%d0         /* copy data from where ever a0 points until a1 equals the end of the data */
        beq.s   2f
        move.b  (%a0)+,(%a1)+
        bra.s   1b
2:

	jmp	main

INT:
	reset


