.text
# int factorial(int n);
factorial:
    addi	sp, sp, -0xc		        # allocate 12 bytes
    stw		ra, 8(sp)			# 4 for ra
    stw		fp, 4(sp)			# 4 for fp
    addi	fp, sp, 4			# another 4 for caller-saved r4 (n)

# compare if n == 1
    movi	r5, 1
    beq		r4, r5, base_case

# n != 1
    stw		r4, -4(fp)			# store n to the stack
    subi	r4, r4, 1			# n-1
    call	factorial			# factorial(n-1)

    ldw		r4, -4(fp)			# restore n
    mul		r2, r2, r4			# n * factorial(n-1)
    br		factorial_out		        # can't just ret, need to deallocate

 base_case:
    movi	r2, 1				# if (n == 1) return 
 factorial_out:
    mov         sp, fp				# deallocate our stack
    ldw		ra, 4(sp)			# restore ra
    ldw		fp, 0(sp)			# restore fp
    addi	sp, sp, 8			# deallocate ra/fp space
    ret


.global _start
_start:
    movia	sp, 0x03FFFFFC

    movi	r4, 5
    call	factorial

  done:
	br	done
