	.arch armv7-a
	.text
	.section	.rodata
	.align	2
defaultStateMsg:
	.ascii	"\033[0m----- \000"
	.align	2
defaultColorMsg:
	.ascii	"\033[0m\000"
	.align	2
charFormatMsg:
	.ascii	"%s%c\000"
	.align	2
yellowColorMsg:
	.ascii	"\033[1;43m\000"
	.align	2
greenColorMsg:
	.ascii	"\033[1;42m\000"
	.text
	.align	2
	.global	printInColor
	.arch armv7-a
	.syntax unified
	.arm
	.fpu vfpv3-d16
	.type	printInColor, %function
printInColor:
	push	{r4, fp, lr}
	add	fp, sp, #8
	sub	sp, sp, #20
	ldr	r4, .L13
setupRow:
	add	r4, pc, r4
	mov	r3, #0
	str	r3, [fp, #-16]
	mov	r3, #0
	str	r3, [fp, #-20]		@ row = 0
	b	loopOne
limitColorPrinting:
	ldr	r3, .L13+4			@ guessesMade
	ldr	r3, [r4, r3]
	ldr	r3, [r3]
	ldr	r2, [fp, #-20]		@ row
	cmp	r2, r3				@ row > guessesMade
	ble	setupCol
	ldr	r3, .L13+8	        @ defaultStateMsg
printDefault:
	add	r3, pc, r3
	mov	r0, r3
	bl	puts				@ printf("\033[0m----- \n");
	b	incrementRow
setupCol:
	mov	r3, #0
	str	r3, [fp, #-16]		@ greenCounter = 0
	mov	r3, #0
	str	r3, [fp, #-24]		@ col = 0
	b	loopTwo
switchCodes:
	ldr	r3, .L13+12			@ globals_userGuesses
	ldr	r2, [r4, r3]
	ldr	r3, [fp, #-20]
	mov	r1, #6
	mul	r3, r1, r3
	add	r2, r2, r3
	ldr	r3, [fp, #-24]
	add	r3, r2, r3
	ldrb	r3, [r3]
	strb	r3, [fp, #-25]
	ldrb	r3, [fp, #-25] 	@ guessLetter = userGuesses[row][col];
	mov	r0, r3				
	bl	tolower				@ convert char to lower
	mov	r3, r0
	uxtb	r0, r3
	ldr	r3, .L13+12			@ globals_userGuesses
	ldr	r2, [r4, r3]
	ldr	r3, [fp, #-20]
	mov	r1, #6
	mul	r3, r1, r3
	add	r2, r2, r3
	ldr	r3, [fp, #-24]
	add	r3, r2, r3
	mov	r2, r0
	strb	r2, [r3]		@ userGuesses[row][col] = tolower(guessLetter);
	ldr	r3, .L13+16			@ globals_colorCodes
	ldr	r2, [r4, r3]
	ldr	r3, [fp, #-20]
	mov	r1, #6
	mul	r3, r1, r3
	add	r2, r2, r3
	ldr	r3, [fp, #-24]
	add	r3, r2, r3
	ldrb	r3, [r3]	
	cmp	r3, #49				@ case '1'
	beq	prepareYellow		@ print yellow
	cmp	r3, #50				@ case '2'
	beq	prepareGreen	    @ print green
	cmp	r3, #48				@ case '0'
	beq	prepareDefault		@ print default
	bl	incrementCol
prepareDefault:
	ldrb	r3, [fp, #-25]	
	mov	r2, r3
	ldr	r3, .L13+20	        @ defaultColorMsg
.LPIC2:
	add	r3, pc, r3
	mov	r1, r3				@ move letter to r1
	ldr	r3, .L13+24			@ charFormatMsg
printLetter2:
	add	r3, pc, r3
	mov	r0, r3
	bl	printf				@ printf("%s%c")
	b	incrementCol
prepareYellow:
	ldrb	r3, [fp, #-25]
	mov	r2, r3
	ldr	r3, .L13+28			@ yellowColorMsg
.LPIC3:
	add	r3, pc, r3
	mov	r1, r3
	ldr	r3, .L13+32			@ charFormatMsg
printLetter3:
	add	r3, pc, r3
	mov	r0, r3
	bl	printf(PLT)			@ printf("%s%c")
	b	incrementCol
prepareGreen:
	ldr	r3, [fp, #-16]
	add	r3, r3, #1			@ greenCounter++
	str	r3, [fp, #-16]
	ldrb	r3, [fp, #-25]	
	mov	r2, r3
	ldr	r3, .L13+36			@ greenColorMsg
.LPIC4:
	add	r3, pc, r3
	mov	r1, r3
	ldr	r3, .L13+40			@ charFormatMsg
.LPIC5:
	add	r3, pc, r3
	mov	r0, r3
	bl	printf				@ printf("%s%c")
	nop
incrementCol:
	ldr	r3, [fp, #-24]
	add	r3, r3, #1			@ col++
	str	r3, [fp, #-24]
loopTwo:
	ldr	r3, [fp, #-24]
	cmp	r3, #4
	ble	switchCodes			@ printInColor
	mov	r0, #10
	bl	putchar				@ printf("\n");
incrementRow:
	ldr	r3, [fp, #-20]
	add	r3, r3, #1			@ row++
	str	r3, [fp, #-20]
loopOne:
	ldr	r3, [fp, #-20]		@ load row
	cmp	r3, #4				@ row < MAXGUESS
	ble	limitColorPrinting
	ldr	r0, .L13+44			@ defaultColorMsg
epilogue:
	add	r3, pc, r3
	mov	r0, r3
	bl	puts				@ 
	ldr	r3, [fp, #-16]
	mov	r0, r3
	sub	sp, fp, #8
	@ sp needed
	pop	{r4, fp, pc}
.L14:
	.align	2
.L13:
	.word	_GLOBAL_OFFSET_TABLE_-(setupRow+8)
	.word	guessesMade(GOT)
	.word	defaultStateMsg-(printDefault+8)
	.word	userGuesses(GOT)
	.word	colorCodes(GOT)
	.word	defaultColorMsg-(.LPIC2+8)
	.word	charFormatMsg-(printLetter2+8)
	.word	yellowColorMsg-(.LPIC3+8)
	.word	charFormatMsg-(printLetter3+8)
	.word	greenColorMsg-(.LPIC4+8)
	.word	charFormatMsg-(.LPIC5+8)
	.word	defaultColorMsg-(epilogue+8)
	.size	printInColor, .-printInColor
	.ident	"GCC: (Debian 8.3.0-6) 8.3.0"
	.section	.note.GNU-stack,"",%progbits
