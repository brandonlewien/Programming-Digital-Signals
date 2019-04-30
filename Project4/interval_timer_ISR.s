.include "address_map_nios2.s"
.extern	PATTERN					# externally defined variables
	
/*******************************************************************************
 * Interval timer - Interrupt Service Routine
 *
 * Shifts a PATTERN being displayed. The shift direction is determined by the 
 * external variable SHIFT_DIR. Whether the shifting occurs or not is determined
 * by the external variable SHIFT_ON.
 ******************************************************************************/
.global INTERVAL_TIMER_ISR
INTERVAL_TIMER_ISR:					
	subi	sp, sp, 40			# reserve space on the stack
	stw	ra, 0(sp)
	stw	r4, 4(sp)
	stw	r8, 16(sp)
	stw	r10, 20(sp)
	stw	r20, 24(sp)
	stw	r22, 32(sp)
	stw	r23, 36(sp)

	movia	r10, TIMER_BASE			# interval timer base address
	sthio	r0,  0(r10)			# clear the interrupt

	movia	r20, HEX3_HEX0_BASE		# HEX3_HEX0 base address
	stwio 	r6, 0(r20)
SHIFT_L:
	ldw	r6, 0(r21)			# load the pattern
	or	r6, r6, r9			# Logical OR current value of r6 with old value 
	stwio	r6, 0(r20)			# store to HEX3 ... HEX0
	slli	r9, r6, 8 			# Shifts left to next hex display 
	bne 	r19, r5, INT_DELAY 
	movi 	r19, 0				# Reset
	movia 	r21, PATTERN
INT_DELAY:
	addi 	r19, r19, 1
	addi 	r21, r21, 4 			# Increment pointer of HBUFFS
END_INTERVAL_TIMER_ISR:
	ldw	ra, 0(sp)			# restore registers
	ldw	r4, 4(sp)
	ldw	r8, 16(sp)
	ldw	r10, 20(sp)
	ldw	r20, 24(sp)
	ldw	r22, 32(sp)
	ldw	r23, 36(sp)	
	addi	sp,  sp, 40			# release the reserved space on the stack
	ret
.end	
