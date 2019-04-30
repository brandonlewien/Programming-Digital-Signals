	.text
	.equ	LEDs,		0xFF200000
	.equ	SWITCHES,	0xFF200040
	.global _start
_start:
	movia   sp, 0x10
	addi    sp, sp, -0x10
        stw     fp, 12(sp)
        addi    fp, sp, 0xc

        stw     r4, -12(fp)
        stw     r3, -8(fp)
        stw     r2, -4(fp)

LOOP:
	ldwio	r4, (r3)		# Read the state of switches
	stwio	r4, (r2)		# Display the state on LEDs
	br	LOOP

.end
