	.arch armv7-a
	.text
	.align	2
	.global	findColorCodes
	.arch armv7-a
	.syntax unified
	.arm
	.fpu vfpv3-d16
	.type	findColorCodes, %function
findColorCodes:
	str	fp, [sp, #-4]!
	add	fp, sp, #0
	sub	sp, sp, #20
	ldr	r3, .L12
setupWords:
	add	r3, pc, r3
	ldr	r2, .L12+4		@ globals_guessesMade
	ldr	r2, [r3, r2]
	ldr	r2, [r2]
	mov	r1, #6
	mul	r2, r1, r2
	ldr	r1, .L12+8		@ globals_usersGuesses
	ldr	r1, [r3, r1]
	add	r2, r2, r1
	str	r2, [fp, #-16]
	ldr	r2, .L12+4		@ globals_guessesMade
	ldr	r2, [r3, r2]
	ldr	r2, [r2]
	mov	r1, #6
	mul	r2, r1, r2
	ldr	r1, .L12+12		@ globals_colorCodes
	ldr	r1, [r3, r1]
	add	r2, r2, r1
	str	r2, [fp, #-20]
	mov	r2, #0
	str	r2, [fp, #-8]
	b	checkLoop
outerLoop:
	ldr	r2, [fp, #-8]
	ldr	r1, [fp, #-20]
	add	r2, r1, r2
	mov	r1, #48			@ colorCode[letter] = '0';
	strb	r1, [r2]
	ldr	r2, [fp, #-8]
	ldr	r1, [fp, #-16]
	add	r2, r1, r2
	ldrb	r1, [r2]	
	ldr	r2, .L12+16		@ globals_correctWord
	ldr	r0, [r3, r2]
	ldr	r2, [fp, #-8]
	add	r2, r0, r2
	ldrb	r2, [r2]	
	cmp	r1, r2			@ if (testWord[letter] == correctWord[letter])
	bne	initializeColor				@ continue;
	ldr	r2, [fp, #-8]
	ldr	r1, [fp, #-20]
	add	r2, r1, r2
	mov	r1, #50			@ colorCode[letter] = '2';
	strb	r1, [r2]
	b	incrementLetter				@ incrementLetter
initializeColor:
	mov	r2, #0			@ colorCode[letter] = '0';
	str	r2, [fp, #-12]
	b	checkLoop2				@ incrementLetter2
innerLoop:
	ldr	r2, [fp, #-8]
	ldr	r1, [fp, #-20]
	add	r2, r1, r2
	ldrb	r2, [r2]	
	cmp	r2, #50			@ if (colorCode[letter] == '2')
	beq	.L11			@ continue;
	ldr	r2, [fp, #-8]
	ldr	r1, [fp, #-16]
	add	r2, r1, r2
	ldrb	r1, [r2]	
	ldr	r2, .L12+16		@ globals_correctWord
	ldr	r0, [r3, r2]
	ldr	r2, [fp, #-12]
	add	r2, r0, r2
	ldrb	r2, [r2]	
	cmp	r1, r2			@ if (testWord[letter] == correctWord[letter2])
	bne	incrementLetter2				@ @ incrementLetter2
	ldr	r2, [fp, #-8]
	ldr	r1, [fp, #-20]
	add	r2, r1, r2
	mov	r1, #49			@ colorCode[letter] = '1';
	strb	r1, [r2]
	b	incrementLetter				@ incrementLetter
.L11:
	nop
incrementLetter2:
	ldr	r2, [fp, #-12]
	add	r2, r2, #1		@ letter2++
	str	r2, [fp, #-12]
checkLoop2:
	ldr	r2, [fp, #-12]
	cmp	r2, #4			@ letter2 < 5
	ble	innerLoop
incrementLetter:
	ldr	r2, [fp, #-8]
	add	r2, r2, #1		@ letter++
	str	r2, [fp, #-8]
checkLoop:
	ldr	r2, [fp, #-8]
	cmp	r2, #4			@ letter < 5
	ble	outerLoop
	
	add	sp, fp, #0
	ldr	fp, [sp], #4
	bx	lr
.L13:
	.align	2
.L12:
	.word	_GLOBAL_OFFSET_TABLE_-(setupWords+8)
	.word	guessesMade(GOT)
	.word	userGuesses(GOT)
	.word	colorCodes(GOT)
	.word	correctWord(GOT)
	.size	findColorCodes, .-findColorCodes
	.ident	"GCC: (Debian 8.3.0-6) 8.3.0"
	.section	.note.GNU-stack,"",%progbits
