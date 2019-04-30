.text
.global sum_two
sum_two:
    addi    sp, sp, -16            # 16 allocated
    stw     r16, 0(sp)             # Allocate r16

    add     r16, r4, r5            # Add two registers
    mov     r2, r16                # Move calculated to return
    ldw     r16, 0(sp)             # Restore r16
    addi    sp, sp, 16             # Restore stack pointer
    ret
    
.global op_three
op_three:
    addi    sp, sp, -20            # 20 allocated
    stw     ra, 16(sp)             # Allocate ra
    stw     fp, 12(sp)             # Also fp
    addi    fp, sp, 12             # 12 for registers r4, r5, r6
    
    stw     r4, -12(fp)            # Store r4 to stack
    stw     r5, -8(fp)             # Store r5 to stack
    stw     r6, -4(fp)             # Store r6 to stack
    
    call    op_two                 
    mov     r4, r2                 # Store return to r4 for reuse
    mov     r5, r6                 # Store r6 to r5 for use
    call    op_two
    
    ldw     r4, -12(fp)            # Restore r4
    ldw     r5, -8(fp)             # Restore r5          
    ldw     r6, -4(fp)             # Restore r6
    ldw     ra, 12(sp)             # Restore ra due to calls
    br      opthree_done           # Done loop
opthree_done:
    mov     sp, fp                 # deallocate stack
    ldw     ra, 4(sp)              # restore ra
    ldw     fp, 0(sp)              # restore fp
    addi    sp, sp, 8              # deallocate ra/fp space
    ret
    
.global fibonacci
fibonacci:
    addi    sp, sp, -20            # 20 allocate bytes
    stw     ra, 16(sp)             # Allocate ra
    stw     fp, 12(sp)             # Allocate fp
    addi    fp, sp, 12             # 12 for r4, r7, r8 

    stw     r8, -12(fp)            # Store r8 
    stw     r7, -8(fp)             # Store r7 
    stw     r4, -4(fp)             # Store counter

    subi    r4, r4, 1              # Count down from given
    beq     r2, r0, zero_case      # If zero, set to 1, go to top
    add     r8, r2, r7             # Fibonacci
    mov     r7, r2                 # Store previous
    mov     r2, r8                 # Store current
    beq     r0, r4, fib_done       # Branch if done
    call    fibonacci              # Loop if not

    ldw     r4, -4(fp)             # Restore r4
    ldw     r7, -8(fp)             # Restore r7
    ldw     r8, -12(fp)            # Restore r8
    br      fib_done               # Deallocate before ret
zero_case:
    movi    r2, 1                  # Set r17 which is 0 to 1
    mov     r7, r0                 # Clear r7
    mov     r8, r0                 # Clear r8

    mov     sp, fp                 # deallocate stack once
    ldw     ra, 4(sp)              # restore ra
    ldw     fp, 0(sp)              # restore fp
    addi    sp, sp, 8              # deallocate ra/fp space
    br      fibonacci              # Go to top of Fibonacci
fib_done:
    mov     sp, fp                 # deallocate stack
    ldw     ra, 4(sp)              # restore ra
    ldw     fp, 0(sp)              # restore fp
    addi    sp, sp, 8              # deallocate ra/fp space
    ret