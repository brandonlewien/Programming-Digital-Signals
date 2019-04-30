.include "address_map_nios2.s"
.include "globals.s"
.extern	PATTERN					# externally defined variables
.extern SPEED
.extern COUNTER
.extern HOWMUCH
.extern INCREMENT

/*******************************************************************************
 * Pushbutton - Interrupt Service Routine
 *
 * This routine checks which KEY has been pressed and updates the global
 * variables as required.
 ******************************************************************************/
.global	PUSHBUTTON_ISR
PUSHBUTTON_ISR:
	subi	sp, sp, 44				# reserve space on the stack
	stw		ra, 0(sp)
	stw		r10, 4(sp)
	stw		r11, 8(sp)
	stw		r12, 12(sp)
	stw		r13, 16(sp)
	stw		r14, 20(sp)
	stw		r15, 24(sp)
	stw     r7,  28(sp)
	stw     r8,  32(sp)
	stw     r9,  36(sp)
	stw     r4,  40(sp)

	movia	r10, KEY_BASE					# base address of pushbutton KEY parallel port
	ldwio	r11, 0xC(r10)					# read edge capture register
	stwio	r11, 0xC(r10)					# clear the interrupt	  
CHECY_KEYBOTH:
	andi 	r13, r11, 0b0011
	movi    r10, 3
	bne 	r13, r10, CHECK_KEY1
	br 		INCREMENTZERO	
CHECK_KEY1:
	andi	r13, r11, 0b0010				# check KEY1
	beq		r13, zero, CHECK_KEY0

	movia   r8, COUNTER
	ldw 	r4, 0(r8)
	movia   r7, 7
	blt  	r4, r7, INCREMENTUP 
CHECKPOINT:
	movia	r16, TIMER_BASE					# interval timer base address
	movia	r13, SPEED		  		
	ldw     r12, 0(r13)
	sthio	r12, 8(r16)						# store the low half word of counter start value
	srli	r12, r12, 16
	sthio	r12, 0xC(r16)					# high half word of counter start value
	movi	r15, 0b0111						# START = 1, CONT = 1, ITO = 1
	sthio	r15, 4(r16)	
CHECK_KEY0:
	andi	r13, r11, 0b0001				# check KEY0
	beq		r13, zero, END_PUSHBUTTON_ISR

	movia   r8, INCREMENT
	ldw 	r7, 0(r8)
	movia   r8, COUNTER
	ldw 	r4, 0(r8)
	bgt  	r4, r7, INCREMENTDOWN
CHECKPOINT1:
	movia	r16, TIMER_BASE					# interval timer base address
	movia	r13, SPEED		  				
	ldw     r12, 0(r13)
	sthio	r12, 8(r16)						# store the low half word of counter start value
	srli	r12, r12, 16
	sthio	r12, 0xC(r16)					# high half word of counter start value
	movi	r15, 0b0111						# START = 1, CONT = 1, ITO = 1
	sthio	r15, 4(r16)  
END_PUSHBUTTON_ISR:
	ldw		ra,  0(sp)						# Restore all used register to previous
	ldw		r10, 4(sp)
	ldw		r11, 8(sp)
	ldw		r12, 12(sp)
	ldw		r13, 16(sp)
	ldw		r14, 20(sp)
	ldw		r15, 24(sp)
	ldw     r7,  28(sp)
	ldw     r8,  32(sp)
	ldw     r9,  36(sp)
	ldw     r4,  40(sp)
	addi	sp,  sp, 44
	ret
INCREMENTUP:
	addi    r4, r4, 1
	stw     r4, 0(r8)
	movia   r9, SPEED
	ldw  	r11, 0(r9)
	movia   r10, HOWMUCH
	ldw  	r15, 0(r10)
	add     r11, r11, r15
	stw  	r11, 0(r9)
	br 		CHECKPOINT
INCREMENTDOWN:
	subi    r4, r4, 1
	stw     r4, 0(r8)
	movia   r9, SPEED
	ldw  	r11, 0(r9)
	movia   r10, HOWMUCH
	ldw  	r15, 0(r10)
	sub     r11, r11, r15
	stw  	r11, 0(r9)
	br 		CHECKPOINT1
INCREMENTZERO:
	movia   r9, SPEED
	stw  	r0, 0(r9)
	br 		CHECKPOINT1
.end	


