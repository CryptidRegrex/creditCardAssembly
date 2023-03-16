	.cpu arm7tdmi
	.eabi_attribute 20, 1
	.eabi_attribute 21, 1
	.eabi_attribute 23, 3
	.eabi_attribute 24, 1
	.eabi_attribute 25, 1
	.eabi_attribute 26, 1
	.eabi_attribute 30, 6
	.eabi_attribute 34, 0
	.eabi_attribute 18, 4
	.file	"arm_tracktwo.c"
	.text
	.syntax divided
	


@ ============================
@ Bill's glue logic for ARMsim
@ ============================
                 .global _start
_start:          ldr	r13, =0x4000
		 bl    main
                 swi   0x11	@ Back from main so halt

swi_open:        swi   0x66
                 mov   pc, lr

swi_close:       swi   0x68
                 mov   pc, lr

swi_read:        swi   0x6a
                 mov   pc, lr

swi_clear:       swi   0x206	@ Clears the LCD
                 mov   pc, lr

swi_lcd_string:  swi   0x204	@ Display at x, y, string
                 mov   pc, lr

swi_lcd_char:    swi   0x207	@ Display at x, y, character
                 mov   pc, lr

swi_button_wait: swi   0x202	@ Check button press
                 ands  r0, r0, r0
                 beq   swi_button_wait	@ Not yet!
_unpress:        swi   0x202	@ Wait for release
                 ands  r0, r0, r0
                 bne   _unpress
                 mov   pc, lr


	.arm
	.syntax unified
	.align	2
	.global	isdigit
	.arch armv4t
	.syntax unified
	.arm
	.fpu softvfp
	.type	isdigit, %function
isdigit:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 1, uses_anonymous_args = 0
	@ link register save eliminated.
	str	fp, [sp, #-4]!
	add	fp, sp, #0
	sub	sp, sp, #12
	str	r0, [fp, #-8]
	ldr	r3, [fp, #-8]
	cmp	r3, #47
	ble	.L2
	ldr	r3, [fp, #-8]
	cmp	r3, #57
	bgt	.L2
	mov	r3, #1
	b	.L4
.L2:
	mov	r3, #0
.L4:
	mov	r0, r3
	add	sp, fp, #0
	@ sp needed
	ldr	fp, [sp], #4
	bx	lr
	.size	isdigit, .-isdigit
	.align	2
	.global	strcpy
	.syntax unified
	.arm
	.fpu softvfp
	.type	strcpy, %function
strcpy:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 1, uses_anonymous_args = 0
	@ link register save eliminated.
	str	fp, [sp, #-4]!
	add	fp, sp, #0
	sub	sp, sp, #12
	str	r0, [fp, #-8]
	str	r1, [fp, #-12]
	nop
.L6:
	ldr	r2, [fp, #-12]
	add	r3, r2, #1
	str	r3, [fp, #-12]
	ldr	r3, [fp, #-8]
	add	r1, r3, #1
	str	r1, [fp, #-8]
	ldrb	r2, [r2]	@ zero_extendqisi2
	strb	r2, [r3]
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #0
	bne	.L6
	nop
	mov	r0, r3
	add	sp, fp, #0
	@ sp needed
	ldr	fp, [sp], #4
	bx	lr
	.size	strcpy, .-strcpy
	.align	2
	.global	strncmp
	.syntax unified
	.arm
	.fpu softvfp
	.type	strncmp, %function
strncmp:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 16
	@ frame_needed = 1, uses_anonymous_args = 0
	@ link register save eliminated.
	str	fp, [sp, #-4]!
	add	fp, sp, #0
	sub	sp, sp, #20
	str	r0, [fp, #-8]
	str	r1, [fp, #-12]
	str	r2, [fp, #-16]
	b	.L8
.L11:
	ldr	r3, [fp, #-8]
	ldrb	r2, [r3]	@ zero_extendqisi2
	ldr	r3, [fp, #-12]
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r2, r3
	beq	.L9
	ldr	r3, [fp, #-8]
	ldrb	r3, [r3]	@ zero_extendqisi2
	mov	r2, r3
	ldr	r3, [fp, #-12]
	ldrb	r3, [r3]	@ zero_extendqisi2
	sub	r3, r2, r3
	b	.L10
.L9:
	ldr	r3, [fp, #-8]
	add	r3, r3, #1
	str	r3, [fp, #-8]
	ldr	r3, [fp, #-12]
	add	r3, r3, #1
	str	r3, [fp, #-12]
	ldr	r3, [fp, #-16]
	sub	r3, r3, #1
	str	r3, [fp, #-16]
.L8:
	ldr	r3, [fp, #-16]
	cmp	r3, #0
	bne	.L11
	mov	r3, #0
.L10:
	mov	r0, r3
	add	sp, fp, #0
	@ sp needed
	ldr	fp, [sp], #4
	bx	lr
	.size	strncmp, .-strncmp
	.comm	data,43,4
	.comm	expanded,161,4
	.section	.rodata
	.align	2
.LC0:
	.ascii	"T2DATA.TXT\000"
	.align	2
.LC1:
	.ascii	"This was a good card.\000"
	.align	2
.LC2:
	.ascii	"Account: \000"
	.align	2
.LC3:
	.ascii	"YYMMAAABBB: \000"
	.align	2
.LC4:
	.ascii	"Bad data: no end sentinel\000"
	.align	2
.LC5:
	.ascii	"Bad data: not 10 digits after the =\000"
	.align	2
.LC6:
	.ascii	"Bad data: didn't look like a '='\000"
	.align	2
.LC7:
	.ascii	"Bad data for the account number\000"
	.text
	.align	2
	.global	main
	.syntax unified
	.arm
	.fpu softvfp
	.type	main, %function
main:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 24
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{r4, fp, lr}
	add	fp, sp, #8
	sub	sp, sp, #28
	str	r0, [fp, #-32]
	str	r1, [fp, #-36]
	mov	r1, #0
	ldr	r0, .L32
	bl	swi_open
	str	r0, [fp, #-28]
	b	.L13
.L30:
	ldr	r1, .L32+4
	ldr	r0, .L32+8
	bl	expand
	mov	r3, #0
	str	r3, [fp, #-16]
	b	.L14
.L29:
	ldr	r1, .L32+4
	ldr	r0, [fp, #-16]
	bl	byte_at
	mov	r3, r0
	cmp	r3, #59
	bne	.L15
	ldr	r3, [fp, #-16]
	add	r3, r3, #5
	ldr	r2, .L32+4
	mov	r1, #16
	mov	r0, r3
	bl	digits
	mov	r3, r0
	cmp	r3, #0
	beq	.L16
	ldr	r3, [fp, #-16]
	add	r3, r3, #85
	ldr	r1, .L32+4
	mov	r0, r3
	bl	byte_at
	mov	r3, r0
	cmp	r3, #61
	bne	.L17
	ldr	r3, [fp, #-16]
	add	r3, r3, #90
	ldr	r2, .L32+4
	mov	r1, #10
	mov	r0, r3
	bl	digits
	mov	r3, r0
	cmp	r3, #0
	beq	.L18
	ldr	r3, [fp, #-16]
	add	r3, r3, #140
	ldr	r1, .L32+4
	mov	r0, r3
	bl	byte_at
	mov	r3, r0
	cmp	r3, #63
	bne	.L19
	ldr	r2, .L32+12
	mov	r1, #0
	mov	r0, #0
	bl	swi_lcd_string
	ldr	r2, .L32+16
	mov	r1, #1
	mov	r0, #0
	bl	swi_lcd_string
	mov	r3, #0
	str	r3, [fp, #-20]
	b	.L20
.L21:
	ldr	r3, [fp, #-20]
	add	r4, r3, #8
	ldr	r3, [fp, #-16]
	add	r1, r3, #5
	ldr	r2, [fp, #-20]
	mov	r3, r2
	lsl	r3, r3, #2
	add	r3, r3, r2
	add	r3, r1, r3
	ldr	r1, .L32+4
	mov	r0, r3
	bl	byte_at
	mov	r3, r0
	mov	r2, r3
	mov	r1, #1
	mov	r0, r4
	bl	swi_lcd_char
	ldr	r3, [fp, #-20]
	add	r3, r3, #1
	str	r3, [fp, #-20]
.L20:
	ldr	r3, [fp, #-20]
	cmp	r3, #15
	ble	.L21
	ldr	r2, .L32+20
	mov	r1, #2
	mov	r0, #0
	bl	swi_lcd_string
	mov	r3, #0
	str	r3, [fp, #-24]
	b	.L22
.L23:
	ldr	r3, [fp, #-24]
	add	r4, r3, #11
	ldr	r3, [fp, #-16]
	add	r1, r3, #90
	ldr	r2, [fp, #-24]
	mov	r3, r2
	lsl	r3, r3, #2
	add	r3, r3, r2
	add	r3, r1, r3
	ldr	r1, .L32+4
	mov	r0, r3
	bl	byte_at
	mov	r3, r0
	mov	r2, r3
	mov	r1, #2
	mov	r0, r4
	bl	swi_lcd_char
	ldr	r3, [fp, #-24]
	add	r3, r3, #1
	str	r3, [fp, #-24]
.L22:
	ldr	r3, [fp, #-24]
	cmp	r3, #9
	ble	.L23
	b	.L28
.L19:
	ldr	r2, .L32+24
	mov	r1, #2
	mov	r0, #0
	bl	swi_lcd_string
	b	.L28
.L18:
	ldr	r2, .L32+28
	mov	r1, #2
	mov	r0, #0
	bl	swi_lcd_string
	b	.L28
.L17:
	ldr	r2, .L32+32
	mov	r1, #2
	mov	r0, #0
	bl	swi_lcd_string
	b	.L28
.L16:
	ldr	r2, .L32+36
	mov	r1, #2
	mov	r0, #0
	bl	swi_lcd_string
	b	.L28
.L15:
	ldr	r3, [fp, #-16]
	add	r3, r3, #1
	str	r3, [fp, #-16]
.L14:
	ldr	r3, [fp, #-16]
	cmp	r3, #154
	ble	.L29
.L28:
	bl	swi_button_wait
	bl	swi_clear
.L13:
	mov	r2, #43
	ldr	r1, .L32+8
	ldr	r0, [fp, #-28]
	bl	swi_read
	mov	r3, r0
	cmp	r3, #39
	bgt	.L30
	ldr	r0, [fp, #-28]
	bl	swi_close
	mov	r3, #0
	mov	r0, r3
	sub	sp, fp, #8
	@ sp needed
	pop	{r4, fp, lr}
	bx	lr
.L33:
	.align	2
.L32:
	.word	.LC0
	.word	expanded
	.word	data
	.word	.LC1
	.word	.LC2
	.word	.LC3
	.word	.LC4
	.word	.LC5
	.word	.LC6
	.word	.LC7
	.size	main, .-main
