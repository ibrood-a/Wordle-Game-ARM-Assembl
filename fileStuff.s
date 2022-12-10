	.arch armv7-a
	.file	"fileStuff.c"
	.text
	.section	.rodata
	.align	2
.LC0:
	.ascii	"r\000"
	.align	2
.LC1:
	.ascii	"%s\000"
	.text
	.align	2



	@@ ----------------------- @@
	@@ wordCount Function here @@
	@@ ----------------------- @@

	.global	wordCount
	.arch armv7-a
	.syntax unified
	.arm
	.fpu vfpv3-d16
	.type	wordCount, %function
wordCount:
	push	{fp, lr}
	add	fp, sp, #4
	sub	sp, sp, #24
	str	r0, [fp, #-24]
	mov	r3, #0
	str	r3, [fp, #-8]
	ldr	r3, .L5
openFile:
	add	r3, pc, r3
	mov	r1, r3
	ldr	r0, [fp, #-24]
	bl	fopen
	str	r0, [fp, #-12]
	b	epilogue
.L3:
	sub	r3, fp, #20
	mov	r2, r3
	ldr	r3, .L5+4
countWords:
	add	r3, pc, r3
	mov	r1, r3
	ldr	r0, [fp, #-12]
	bl	__isoc99_fscanf
	ldr	r3, [fp, #-8]
	add	r3, r3, #1
	str	r3, [fp, #-8]
epilogue:
	ldr	r0, [fp, #-12]
	bl	feof
	mov	r3, r0
	cmp	r3, #0
	beq	.L3
	ldr	r0, [fp, #-12]
	bl	fclose
	ldr	r3, [fp, #-8]
	mov	r0, r3
	sub	sp, fp, #4
	@ sp needed
	pop	{fp, pc}
.L6:
	.align	2
.L5:
	.word	.LC0-(openFile+8)
	.word	.LC1-(countWords+8)
	.size	wordCount, .-wordCount
	.align	2
	


	@@ --------------------- @@
	@@ getWord Function here @@
	@@ --------------------- @@
	
	.global	getWord
	.syntax unified
	.arm
	.fpu vfpv3-d16
	.type	getWord, %function
getWord:
	push	{fp, lr}
	add	fp, sp, #4
	sub	sp, sp, #24
	str	r0, [fp, #-16]
	str	r1, [fp, #-20]
	str	r2, [fp, #-24]
	mov	r3, #0
	str	r3, [fp, #-8]
	ldr	r3, .L12
.LPIC2:
	add	r3, pc, r3
	mov	r1, r3
	ldr	r0, [fp, #-16]
	bl	fopen
	str	r0, [fp, #-12]
	b	.L8
.L10:
	ldr	r2, [fp, #-24]
	ldr	r3, .L12+4
.LPIC3:
	add	r3, pc, r3
	mov	r1, r3
	ldr	r0, [fp, #-12]
	bl	__isoc99_fscanf
	ldr	r3, [fp, #-8]
	add	r3, r3, #1
	str	r3, [fp, #-8]
.L8:
	ldr	r0, [fp, #-12]
	bl	feof
	mov	r3, r0
	cmp	r3, #0
	bne	.L9
	ldr	r2, [fp, #-8]
	ldr	r3, [fp, #-20]
	cmp	r2, r3
	blt	.L10
.L9:
	ldr	r0, [fp, #-12]
	bl	fclose
	nop
	sub	sp, fp, #4
	@ sp needed
	pop	{fp, pc}
.L13:
	.align	2
.L12:
	.word	.LC0-(.LPIC2+8)
	.word	.LC1-(.LPIC3+8)
	.size	getWord, .-getWord
	.align	2



	@@ ----------------------- @@
	@@ validWord Function here @@
	@@ ----------------------- @@

	.global	validWord
	.syntax unified
	.arm
	.fpu vfpv3-d16
	.type	validWord, %function
validWord:
	push	{fp, lr}
	add	fp, sp, #4
	sub	sp, sp, #32
	str	r0, [fp, #-32]
	str	r1, [fp, #-36]
	mov	r3, #0
	str	r3, [fp, #-8]
	mov	r3, #0
	str	r3, [fp, #-12]
	ldr	r3, .L19
.LPIC4:
	add	r3, pc, r3
	mov	r1, r3
	ldr	r0, [fp, #-32]
	bl	fopen
	str	r0, [fp, #-16]
	b	.L15
.L17:
	sub	r3, fp, #24
	mov	r2, r3
	ldr	r3, .L19+4
.LPIC5:
	add	r3, pc, r3
	mov	r1, r3
	ldr	r0, [fp, #-16]
	bl	__isoc99_fscanf
	ldr	r3, [fp, #-8]
	add	r3, r3, #1
	str	r3, [fp, #-8]
	sub	r3, fp, #24
	mov	r1, r3
	ldr	r0, [fp, #-36]
	bl	strcmp
	mov	r3, r0
	cmp	r3, #0
	bne	.L15
	mov	r3, #1
	str	r3, [fp, #-12]
	b	.L16
.L15:
	ldr	r0, [fp, #-16]
	bl	feof
	mov	r3, r0
	cmp	r3, #0
	beq	.L17
.L16:
	ldr	r0, [fp, #-16]
	bl	fclose
	ldr	r3, [fp, #-12]
	mov	r0, r3
	sub	sp, fp, #4
	@ sp needed
	pop	{fp, pc}
epilogue0:
	.align	2
.L19:
	.word	.LC0-(.LPIC4+8)
	.word	.LC1-(.LPIC5+8)
	.size	validWord, .-validWord
	.ident	"GCC: (Debian 8.3.0-6) 8.3.0"
	.section	.note.GNU-stack,"",%progbits
