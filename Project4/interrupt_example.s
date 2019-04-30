.include "address_map_nios2.s"
.text
.global _start

_start:
    /* set up the stack */
	movia 	sp, SDRAM_END - 3	# stack starts from largest memory address

	movia	r16, TIMER_BASE		# interval timer base address
	/* set the interval timer period for scrolling the HEX displays */
	movia	r13, SPEED		# 1/(100 MHz) x (5 x 10^6) = 50 msec
	ldw     r12, 0(r13)
	sthio	r12, 8(r16)		# store the low half word of counter start value
	srli	r12, r12, 16
	sthio	r12, 0xC(r16)		# high half word of counter start value

	/* start interval timer, enable its interrupts */
	movi	r15, 0b0111		# START = 1, CONT = 1, ITO = 1
	sthio	r15, 4(r16)

	/* write to the pushbutton port interrupt mask register */
	movia	r15, KEY_BASE		# pushbutton key base address
	movi	r7, 0b11		# set interrupt mask bits
	stwio	r7, 8(r15)		# interrupt mask register is (base + 8)

	/* enable Nios II processor interrupts */
	movia	r7, 0x00000001		# get interrupt mask bit for interval timer
	movia	r8, 0x00000002		# get interrupt mask bit for pushbuttons
	or	r7, r7, r8
	wrctl	ienable, r7		# enable interrupts for the given mask bits
	movi	r7, 1
	
	wrctl	status, r7		# turn on Nios II interrupt processing

	mov	r20, r0
	mov	 r21, r0		
	movia	r21, PATTERN		# set up a pointer to the display pattern
	movi  	r5, 18		
	movi 	r6, 0
IDLE:
	br	IDLE

.data
.global	PATTERN
PATTERN:
	.word 0b00000000, 0b01110110, 0b01111001, 0b00111000, 0b00111000, 0b00111111, 0b00000000, 0b01111111, 0b00111110, 0b01110001, 0b01110001, 0b01101101, 0b01000000, 0b01000000, 0b01000000, 0b00000000, 0b00000000, 0b00000000, 0b00000000 
.global SPEED
SPEED:
	.word 50000000
.global COUNTER
COUNTER:
	.word 4
.global HOWMUCH
HOWMUCH:
	.word 10000000
.global INCREMENT
INCREMENT:
	.word 1
.global STOP
STOP:
	.word 7
.end
