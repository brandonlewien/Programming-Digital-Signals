	.text
	.equ	LEDs,		0xFF200000
	.equ	SWITCHES,	0xFF200040
	.global _start
_start:
	movia	r2, LEDs	# Address of LEDs         
	movia	r3, SWITCHES	# Address of switches

LOOP:
	ldwio	r4, (r3)	# Read the state of switches
        srli 	r5,  r4,  5     # Shift right 5 bits, switches 5-9
	andi    r9,  r5,  31    # Keep bottom 5 bits, mask rest with 0b0s, MASK
	andi    r10,  r4,  31   # Keep bottom 5 bits, mask rest with 0b0s, MASK
	add     r8,  r10,  r9   # Adder 
	stwio	r8, (r2)	# Display the state on LEDs
	br	LOOP
.end
