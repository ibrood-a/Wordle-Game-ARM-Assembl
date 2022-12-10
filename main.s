	.arch armv7-a
	.text
	.comm	guessesMade,4,4
	.comm	colorCodes,30,4
	.comm	correctWord,5,4
	.comm	userGuesses,30,4
	.section	.rodata
	.align	2
fileNameMsg:
	.ascii	"5Letter.txt\000"
	.align	2
defaultStateMsg:
	.ascii	"\033[0m----- \000"
	.align	2
guessPromptMsg:
	.ascii	"enter your guess: \000"
	.align	2
stringFormatMsg:
	.ascii	"%s\000"
	.align	2
clearConsoleMsg:
	.ascii	"\033c\000"
	.align	2
invalidWordMsg:
	.ascii	"follow the rules please.. you need to choose a real"
	.ascii	" five letter word\000"
	.align	2
correctWordMsg:
	.ascii	"\033[0mcongrats you win!\012\000"
	.align	2
loseMsg:
	.ascii	"\033[0mnice try, however the word was: %s\012\000"
	.text
	.align	2
	.global	main
	.arch armv7-a
	.syntax unified
	.arm
	.fpu vfpv3-d16
	.type	main, %function
main:
	push	{r4, fp, lr}
	add	fp, sp, #8
	sub	sp, sp, #20
	ldr	r4, .L11
.LPIC1:
	add	r4, pc, r4
	mov	r0, #0
	bl	time				@ time(0)
	mov	r3, r0
	mov	r0, r3
	bl	srand				@ srand(time(0))
	ldr	r3, .L11+4			@ fileNameMsg
index:
	add	r3, pc, r3
	mov	r0, r3
	bl	wordCount			@ find number of possible words
	str	r0, [fp, #-24]
	ldr	r1, [fp, #-24]		@ max
	mov	r0, #0				@ min
	bl	getRandom			@ getRandom(min, max)
	str	r0, [fp, #-28]		@ [fp, #-28] - index
	ldr	r3, .L11+8			@ globals_correctWord
	ldr	r3, [r4, r3]
	mov	r2, r3
	ldr	r1, [fp, #-28]
	ldr	r3, .L11+12 		@ fileNameMsg
findWord:
	add	r3, pc, r3
	mov	r0, r3				@ 
	bl	getWord				@ get the word from the index
	mov	r3, #0				@ i = 0 (loop)
	str	r3, [fp, #-16]
	b	setupBoard
setupDefaultMsg:
	ldr	r3, .L11+16 		@ defaultStateMsg
defaultPrint:
	add	r3, pc, r3
	mov	r0, r3				
	bl	puts				@ printf("\033[0m----- \n");
	ldr	r3, [fp, #-16]
	add	r3, r3, #1
	str	r3, [fp, #-16]
setupBoard:
	ldr	r3, [fp, #-16]		@ local_i
	cmp	r3, #4				@ i < MAXGUESS
	ble	setupDefaultMsg		@ setup printf
	mov	r3, #0
	str	r3, [fp, #-20]		@ local_greenCounter
	b	.L4
preparePromptMsg:
	ldr	r3, .L11+20 		@ guessPromptMsg
promptPrint:
	add	r3, pc, r3
	mov	r0, r3				@ "enter your guess: "
	bl	printf				@ printf("enter your guess: ")
	ldr	r3, .L11+24 		@ globals_guessesMade
	ldr	r3, [r4, r3]
	ldr	r3, [r3]
	mov	r2, #6
	mul	r3, r2, r3
	ldr	r2, .L11+28 		@ globals_userGuesses
	ldr	r2, [r4, r2]
	add	r3, r3, r2
	mov	r1, r3				@ userGuesses[guessesMade]
	ldr	r3, .L11+32 		@ stringFormatMsg
getGuess:
	add	r3, pc, r3
	mov	r0, r3				@ "%s"
	bl	__isoc99_scanf		@ scanf("%s", userGuesses[guessesMade]);
	ldr	r3, .L11+36 		@ clearConsoleMsg
.LPIC6:
	add	r3, pc, r3
	mov	r0, r3				@ "\033c"
	bl	printf				@ printf("\033c");
	ldr	r3, .L11+24 		@ globals_guessesMade
ldr	r3, [r4, r3]
	ldr	r3, [r3]
	mov	r2, #6
	mul	r3, r2, r3
	ldr	r2, .L11+28 		@ globals_userGuesses
	ldr	r2, [r4, r2]
	add	r3, r3, r2
	mov	r1, r3				@ userGuesses[guessesMade]
	ldr	r3, .L11+40 		@ fileNameMsg
.LPIC7:
	add	r3, pc, r3
	mov	r0, r3				@ "5Letter.txt"
	bl	validWord			@ validWord("5Letter.txt", userGuesses[guessesMade])
	mov	r3, r0
	cmp	r3, #0				@ if (!validWord(..., ...)
	bne	.L5					
	ldr	r3, .L11+44			@ invalidWordMsg
.LPIC8:
	add	r3, pc, r3
	mov	r0, r3				@ "follow the rules please.. you need to choose a real five letter word"
	bl	puts				@ print("follow the rules please.. you need to choose a real five letter word")
	b	.L4
.L5:
	bl	findColorCodes		@ get all color codes
	bl	printInColor		@ print board showing color codes
	str	r0, [fp, #-20]		@ local_greenCounter
	ldr	r3, .L11+24 		@ globals_guessesMade
	ldr	r3, [r4, r3]
	ldr	r3, [r3]
	add	r2, r3, #1			@ guessesMade++
	ldr	r3, .L11+24 		@ globals_guessesMade
	ldr	r3, [r4, r3]
	str	r2, [r3]
.L4:
	ldr	r3, [fp, #-20]		@ local_greenCounter
	cmp	r3, #5				
	beq	.L6					@ while (greenCounter != WORDLENGTH && ..)
	ldr	r3, .L11+24 		@ globals_guessesMade
	ldr	r3, [r4, r3]
	ldr	r3, [r3]
	cmp	r3, #4				@ while (.. && guessesMade < MAXGUESS)
	ble	preparePromptMsg	
.L6:
	ldr	r3, [fp, #-20]		@ local_greenCounter
	cmp	r3, #5				@ greenCounter == WORDLENGTH
	bne	.L8
	ldr	r3, .L11+48			@ correctWordMsg
.LPIC9:
	add	r3, pc, r3
	mov	r2, r3				@ correctWordMsg
	b	.L9					@ printf("congrats you win!\n")
.L8:
	ldr	r3, .L11+52			@ loseMsg
.LPIC10:
	add	r3, pc, r3
	mov	r2, r3				@ printf("nice try, however the word was: %s\n")
.L9:
	ldr	r3, .L11+8 			@ correctWord (global variable)
	ldr	r3, [r4, r3]
	mov	r1, r3
	mov	r0, r2
	bl	printf				@ print result
	mov	r3, #0
	mov	r0, r3
	sub	sp, fp, #8
	@ sp needed
	pop	{r4, fp, pc}
.L12:
	.align	2
.L11:
	.word	_GLOBAL_OFFSET_TABLE_-(.LPIC1+8)
	.word	fileNameMsg-(index+8)
	.word	correctWord(GOT)
	.word	fileNameMsg-(findWord+8)
	.word	defaultStateMsg-(defaultPrint+8)
	.word	guessPromptMsg-(promptPrint+8)
	.word	guessesMade(GOT)
	.word	userGuesses(GOT)
	.word	stringFormatMsg-(getGuess+8)
	.word	clearConsoleMsg-(.LPIC6+8)
	.word	fileNameMsg-(.LPIC7+8)
	.word	invalidWordMsg-(.LPIC8+8)
	.word	correctWordMsg-(.LPIC9+8)
	.word	loseMsg-(.LPIC10+8)
	.size	main, .-main
	.ident	"GCC: (Debian 8.3.0-6) 8.3.0"
	.section	.note.GNU-stack,"",%progbits
