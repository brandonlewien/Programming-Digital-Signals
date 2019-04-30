	.text
	.equ	LEDs,		0xFF200000
	.equ	SEGMENT03,	0xFF200020
	.global _start

DELAY:
	movhi   r22, 0x08D                  # About half a second
	addi    r22, r22, 0x7840            # Bottom of half of second
	addi    r23, r23, 0x01              # Counter, reset is below every time this delay is called
	bne	    r22, r23, DELAY             # If statement
	ret
PAT:
#Pattern A
	ldw		r8, 0(r10)                  # Load pattern
	add 	r11, r11, r8                # Add battern to half of seven segment
    slli 	r11, r11, 16                # Shift bits to fit other half of pattern in other half of seven segment
	add 	r11, r11, r8                # Add other half
#Pattern B
	addi    r10, r10, 4                 # Increment array
	ldw		r8, 0(r10)                  # Load pattern
	add 	r12, r12, r8                # Add battern to half of seven segment
    slli 	r12, r12, 16                # Shift bits to fit other half of pattern in other half of seven segment
	add 	r12, r12, r8                # Add other half
#Pattern C
	addi    r10, r10, 4                 # Increment array
	ldw		r8, 0(r10)                  # Load pattern
	add 	r13, r13, r8                # Add battern to half of seven segment
    slli 	r13, r13, 16                # Shift bits to fit other half of pattern in other half of seven segment
	add 	r13, r13, r8                # Add other half
INVERTED:
	addi  	r15, r15, 1	                # Increment, clear is in start
	stwio   r11, (r3)					# Display the state on segments
	call 	DELAY                       # Delay 1s, return here
	movui   r23, 0x0                    # Reset counter register within delay
	stwio   r12, (r3)					# Display the state on segments
	call 	DELAY                       # Delay 1s, return here
	movui   r23, 0x0                    # Reset counter register within delay
	bne 	r14, r15, INVERTED     
ALLFORONE:
	addi  	r16, r16, 1		            # Increment, clear is in start
	stwio   r13, (r3)					# Display the state on segments
	call 	DELAY                       # Delay 1s, return here
	movui   r23, 0x0                    # Reset counter register within delay
	stwio   r0, (r3)					# Display the state on segments
	call 	DELAY                       # Delay 1s, return here
	movui   r23, 0x0                    # Reset counter register within delay
	bne 	r14, r16, ALLFORONE     	
	
_start:
	movia   r3, SEGMENT03				# Address of Segment 0-3          
	movia   r5, WHOLESTRING				# Address of Go Buffs---____
	movia   r10, PATTERN                # Address of Pattern
	movhi   r20, 0x0000                 # Store 0x0000 to high part of r20
	addi    r20, r20, 0x0000            # Store 0x0000 to low part of r20
	movi    r14, 0x3                    # For iteration loop value            
	and 	r6, r6, r0                  # Clear r6
	and 	r7, r7, r0                  # Clear r7
	and 	r8, r8, r0                  # Clear r8
	and 	r11, r11, r0                # Clear r11
	and 	r12, r12, r0                # Clear r12
	and 	r13, r13, r0                # Clear r13
	and  	r15, r15, r0 				# Clear r15
	and     r16, r16, r0				# Clear r16
	ldw     r7, 0(r5)                   # Preset r7 to char H
LOOP:
	slli 	r6, r6, 8                   # Shift left 8, useful when loading new things
	add 	r6, r6, r7                  # Add 'catcher' register to output register
	stwio   r6, (r3)					# Display the state on segments
	addi    r5, r5, 4                   # Shift register by 4
	ldw     r7, 0(r5)                   # Load new information from r5 to r7
	call 	DELAY                       # Delay 1s, return here
	movui   r23, 0x0                    # Reset counter register within delay
	beq     r6, r20, PAT                # Branch if 0x00000000, Pattern loop, reset state by going back to start after done
	br LOOP                             # Repeat loop if branch criteria above not met

.data
WHOLESTRING:
	.word 0b01110110, 0b01111001, 0b00111000, 0b00111000, 0b00111111, 0b0, 0b01111100, 0b00111110, 0b01110001, 0b01110001, 0b01101101, 0b01000000, 0b01000000, 0b01000000, 0b0, 0b0, 0b0, 0b0
PATTERN:
	.word 0x4949, 0x3636, 0x7F7F

    .end
