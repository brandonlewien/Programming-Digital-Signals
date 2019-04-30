	.text
	.equ	SEGMENT03,	0xFF200020
	.equ	BUTTONS,	0xFF200050
	.global _start

DELAY:
	ldwio	r8, 0(r4)                   # Read switch state
	cmpeqi  r19, r8, 2                  # Check if bottom button is pressed
	cmpeqi 	r18, r8, 1                  # Check if top button is pressed
	or      r18, r19, r18		    # Doesn't matter which one is pressed
        beq     r18, r9, CONDITION	    # If switch is pressed, go to condition

	movia   r22, 0x02D7840
	addi    r23, r23, 0x01              # Counter, reset is below every time this delay is called
	bne	r22, r23, DELAY             # If statement
	ret
CONDITION:
	cmpeqi 	r15, r16, 1                 # If Flag and 1, set r15 as true, else false, toggle basically
	ret
BFOR:
	movia   r6, 0                       # Reset whatever is in r6
	mov     r6, r13                     # Set whatever is in r13 into r16
	movi    r16, 1			    # Flag setter
	movia   r5, FW      		    # Address of Forward Pattern Resetter
	call 	FORWARD
FBACK:
	movia   r13, 0                      # Reset whatever is in r13
	mov 	r13, r6                     # Set whatever is in r16 into r13
	movi    r16, 0			    # Flag setter
	movia   r10, BW      		    # Address of Forward Pattern Resetter
 	call 	BACKWARD
FORWARD:
	beq     r16, r0, BFOR               # Check if previous state was backward
	movi    r16, 1			    # Flag setter
	ldw     r7, 0(r5)                   # Load new information from r5 to r7
	slli 	r6, r6, 8                   # Shift left 8, useful when loading new things
	add 	r6, r6, r7                  # Add 'catcher' register to output register
	stwio   r6, (r3)		    # Display the state on segments
	addi    r5, r5, 4                   # Shift register by 4
	call 	DELAY			    # Call to Delay above, will return here
	movui   r23, 0x0                    # Reset counter register within delay
	beq     r6, r20, SKIPQUEUE          # Branch if 0x00000000 for reset purposes
	br      LOOP		            # Otherwise go to loop directly
BACKWARD:
	beq     r16, r9, FBACK              # Check if previous state was forward
	movi    r16, 0			    # Flag setter
	ldw     r12, 0(r10)                 # Load new information from r10 to r12
	slli    r12, r12, 24		    # Shift logical left by 24 bits to line up with leftmost edge
	srli 	r13, r13, 8                 # Shift right 8, useful when loading new things
	add 	r13, r13, r12               # Add 'catcher' register to output register
	stwio   r13, (r3)		    # Display the state on segments
	addi    r10, r10, 4                 # Shift register by 4
	call 	DELAY			    # Call to Delay above, will return here
	movui   r23, 0x0                    # Reset counter register within delay
	beq     r13, r20, SKIPQUEUE         # Branch if 0x00000000 for reset purposes
	br	LOOP                        # Otherwise go to loop directly
SKIPQUEUE:

_start:
	movia   r3, SEGMENT03		    # Address of Segment 0-3
	movia   r4, BUTTONS 		    # Address of Both buttons                   
	movia   r5, FW      	            # Address of Forward Pattern
	movia   r10, BW                     # Address of Backward Pattern
	movhi   r20, 0x0000                 # Store 0x0000 to high part of r20
	addi    r20, r20, 0x0000            # Store 0x0000 to low part of r20
	movi    r9, 1                       # Register to hold the 1 value for comparison
	and 	r6, r6, r0                  # Clear r6
	and 	r7, r7, r0                  # Clear r7
LOOP:
	ldwio	r8, 0(r4)                   # Read switch state
	cmpeqi  r19, r8, 2                  # Check if bottom button is pressed
	cmpeqi 	r18, r8, 1                  # Check if top button is pressed
	or      r18, r19, r18		    # Doesn't matter which one is pressed
        beq     r18, r9, CONDITION	    # If switch is pressed, go to condition
DELAYCASE:
	beq 	r15, r0, FORWARD            # If r15 false, forward - will set flag to 1
	beq     r15, r9, BACKWARD           # If r15 true, backward - will set flag to 0
	br      LOOP                        # Repeat loop if branch criteria above not met

.data
FW:
	.word 0b01111001, 0b01001001, 0b01001001, 0b01001001, 0b0, 0b0, 0b0, 0b0
BW:
	.word 0b01001111, 0b01001001, 0b01001001, 0b01001001, 0b0, 0b0, 0b0, 0b0 

.end
