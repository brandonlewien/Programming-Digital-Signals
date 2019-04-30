1.
Orhi takes register r0, does the OR operand with %hi(X) (high part of x) and stores the result in register 2
Ori takes register 2, does the OR operand with %lo(x) (low part of x) and stores it into the same place
Movia takes the address of Y and stores that address to register 3
Movia takes the address of N and stores that address to register 4
Ldw takes the value of r4 as a pointer to memory and adds the offset 0 to it. It then loads a word (4 bytes) of data from that address in memory and stores that data in r4.
Add adds register 0 with itself and stores it into r5. Basically a times two operand to r0.
Label is like a while/for loop
Ldw loads the next value of x
Stw stores the next value of x in r6 into the next value of y in r3
Addi increments pointer to x
Addi incrementes pointer to y to line up with x
Subi decrements the counter N for loop purposes
Bgt is like the checker, checks if N > 0 (when we cleared it) - Jumps to LABEL, loop
STOP stops the program
Data stores specific things into N, X, or Y. N is holding 6, X is holding various integers, Y is holding 6 zeros.

void atoc() {
	int N = 6;
	int X[6] = {5, 3, -6, 19, 8, 12};
	int Y[6] = {0, 0, 0, 0, 0, 0};
	int Increment = 0;

	while(N>0) {
		Y[Increment] = X[Increment];  // Store X into Y
		++Increment;                  // Increment Counter
		--N;                          // Decrement N
	}
}
---
2.
stw r4, -28(r19)
---
3.
0x2D9D203A
