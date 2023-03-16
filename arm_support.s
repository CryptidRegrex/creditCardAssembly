	.global		expand
	.type		expand, %function
expand:	push {r0, r1}
	push	{r4-r8,r9}
	mov	r7, #0x2400	@ Place to store max byte_at calls
	mov	r8, #29		@ Minimum byte_at calls
	strb	r8, [r7]
	ldrb	r4, [r0]	@Moving by 1 byte every loop
	mov	r9, #0
	cmp	r4, #0x30	@ Comparing digits given
	addge	r9, r9, #1
	cmp	r4, #0x46
	addle	r9, r9, #1
	cmp	r9, #2
	beq	L1

E1:				@This loop will increment our place in memeory and check for ending value
	add	r0, #1
	ldrb	r4, [r0]
	mov	r9, #0
	cmp	r4, #0x30
	addge	r9, r9, #1
	cmp	r4, #0x46
	addle	r9, r9, #1
	cmp	r9, #2
	beq	L1
	pop	{r4-r8,r9}
	mov	pc, lr

L1:	
	cmp	r4, #0x40	@Determines if digit or not
	subge	r5, r4, #0x41
	cmp	r4, #0x40
	addge	r5, r5, #10
	cmp	r4, #0x40
	sublt	r5, r4, #0x30


	cmp	r5, #8		@Checks for 1 in 8's position
	movge	r6, #0x31
	cmp	r5, #8
	movlt	r6, #0x30
	strb	r6, [r1], #1
	cmp	r5, #8
	subge	r5, r5, #0x08

	cmp	r5, #4		@Checks for 1 in 4's position
	movge	r6, #0x31
	cmp	r5, #4
	movlt	r6, #0x30
	strb	r6, [r1], #1
	cmp	r5, #4
	subge	r5, r5, #0x04

	cmp	r5, #2		@Checks for 1 in 2's position
	movge	r6, #0x31
	cmp	r5, #2
	movlt	r6, #0x30
	strb	r6, [r1], #1
	cmp	r5, #2
	subge	r5, r5, #0x02

	cmp	r5, #1		@Checks for 1 in 1's position
	movge	r6, #0x31
	cmp	r5, #1
	movlt	r6, #0x30
	strb	r6, [r1], #1
	b	E1





	.global		byte_at
	.type		byte_at, %function
byte_at:push	{r0, r1}	@Push our values into fucntion
	push	{r4,r5,r6,r7,r8,r9,r10,r11,r12}	
	mov	r12, #0x2400				@This will fist set up location to store max byte_at calls	
	mov	r9, #0x2300				@This will track all byte_at calls
	mov	r11, #29
	mov	r10, #0
	mov	r8, #0
	mov	r5, #5
	
	mov	r7, #0x2100
	ldrb	r7, [r7]


	@cmp	r0, #6					
	@mulle	r8, r0, r5
	@movgt	r8, r0
	sub	r0, r0, r7				@ Subs first postion number after first byte_at call

	ldrb	r6, [r9]
	cmp	r6, #4
	ble	E8

	cmp	r0, #4
	mulle	r8, r0, r5
	movgt	r8, r0

	mul	r5, r5, r7				@ Calculates our postion times 5 and adds r0
	add	r5, r5, r8

	add	r1, r1, r5
	ldrb	r4, [r1], #1
	mov	r7, #0x2000
	strb	r0, [r7]
	mov	r5, #0
	mov	r7, #0

	cmp	r4, #0x30
	beq	L2
	cmp	r4, #0x31
	addeq	r7, r7, #1
	beq	L2
	bne	L6

E8:							@ Only is access if is under 4 increments on first byte_at
	cmp	r0, #4
	mulle	r8, r0, r5				@ This will do the calcuation for only the first byte_at
	movgt	r8, r0

	mul	r5, r5, r7
	add	r5, r5, r8

	add	r1, r1, r5
	ldrb	r4, [r1], #1
	mov	r7, #0x2000
	strb	r0, [r7]
	mov	r5, #0
	mov	r7, #0

	cmp	r4, #0x30
	beq	L2
	cmp	r4, #0x31
	addeq	r7, r7, #1
	beq	L2
	bne	L6


L2:
	ldrb	r4, [r1], #1				@ Calculates our digit value by comparing to binary value
	cmp	r4, #0x31
	addeq	r5, r5, #8
	addeq	r7, r7, #1
	
	ldrb	r4, [r1], #1
	cmp	r4, #0x31
	addeq	r5, r5, #4
	addeq	r7,r7, #1

	ldrb	r4, [r1], #1
	cmp	r4, #0x31
	addeq	r5, r5, #2
	addeq	r7, r7, #1

	ldrb	r4, [r1]
	cmp	r4, #0x31
	addeq	r5, r5, #1
	addeq	r7, r7, #1

	and	r7, r7, #0x01
	cmp	r7, #1
	bne	L6
	
	@cmp	r5, #9
	@ble	L3
	@bgt	L4
	b	L4

L3:
	mov	r0, r5					@ Moves values back to main
	pop	{r4,r5,r6,r7,r8,r9,r10,r11,r12}	
	@ldm	r11, {r4-r11}
	mov	pc, lr

L4:
	cmp	r5, #0					@ Converts value to character value in ascii format
	moveq	r5, #0x30
	cmp	r5, #1
	moveq	r5, #0x31
	cmp	r5, #2
	moveq	r5, #0x32
	cmp	r5, #3
	moveq	r5, #0x33
	cmp	r5, #4
	moveq	r5, #0x34
	cmp	r5, #5
	moveq	r5, #0x35
	cmp	r5, #6
	moveq	r5, #0x36
	cmp	r5, #7
	moveq	r5, #0x37
	cmp	r5, #8
	moveq	r5, #0x38
	cmp	r5, #9
	moveq	r5, #0x39
	cmp	r5, #10
	moveq	r5, #':'
	cmp	r5, #11
	moveq	r5, #';'
	beq	E2
	cmp	r5, #12
	moveq	r5, #'<'
	cmp	r5, #13
	moveq	r5, #'='
	cmp	r5, #14
	moveq	r5, #'>'
	cmp	r5, #15
	moveq	r5, #'?'
	mov	r0, r5

	ldrb	r6, [r9]				@ Increments our space in memeory at 0x2300
	add	r6, r6, #1
	ldrb	r11, [r12]				@ Sets loads and compares to our max byte_at calls
	cmp	r6, r11
	bge	E9
	strb	r6, [r9]				@ Stores incremented value
	

	pop	{r4,r5,r6,r7,r8,r9,r10,r11,r12}
	mov	pc, lr

E9:
	mov	r7, #0x2100				@ Resets stored values in 0x2100 and 0x2300
	mov	r10, #0
	strb	r10, [r7]
	mov	r6, #0
	strb	r6, [r9]
	

	pop	{r4,r5,r6,r7,r8,r9,r10,r11,r12}
	mov	pc, lr

E2:
	mov	r7, #0x2100				@ Updates value in 0x2400 by adding r7 then returning value
	strb	r0, [r7]
	add	r11, r0, r11
	strb	r11, [r12]
	mov	r0, r5

	ldrb	r6, [r9]
	add	r6, r6, #1
	strb	r6, [r9]

	pop	{r4,r5,r6,r7,r8,r9,r10,r11,r12}
	mov	pc, lr

L6:		
	mov	r0, #'E'				@ Checks for errors
	mov	r7, #0x2100				@ If error exists reset values in 0x2100 and 0x2300
	mov	r10, #0					@ By doing this we error out and are ready for our next 40 character hex string
	strb	r10, [r7]

	ldrb	r6, [r9]
	mov	r6, #0
	strb	r6, [r9]

	pop	{r4,r5,r6,r7,r8,r9,r10,r11,r12}		
	mov	pc, lr






	.global		digits
	.type		digits, %function
digits:push	{r0, r1, r2}	@ pushes value into our prgm
	push	{r4-r12}
	mov	r11, #0x2300
	mov	r12, #0
	mov	r6, r14		@ Tracks link register
	mov	r7, #0x2100
	ldrb	r10, [r7]
	mov	r8, r1		@ Holds length
	cmp	r0, #85
	subge	r0, r0, r10
	bge	L11
	mov	r7, #0x2000	@ Moves last place register was at and moves into r7
	ldrb	r0, [r7]	@ Loads value of r7 into r0
	add	r0, r0, #1
	mov	r1, r2		@ Moves memory address of r2 into r1

	add	r8, r8, #1

	cmp	r8, #17		@ Determines if it is looking for length of 16
	beq	L7		@ Branch and links to byte_at to check all values
	
	cmp	r8, #11		@ Determines if it is looking for length of 10
	b	L9	

L7:
	mov	r1, r2
	mov	r9, #0x2000
	cmp	r8, #0
	blgt	byte_at_two
	cmp	r0, #'E'	@ Checks for error

	beq	E10
		
	cmp	r0, #'='	@ Check for seperator
	beq	L8

	ldrb	r0, [r9]
	add	r0, r0, #1	@ Add 1 to our position to start at
	strb	r0, [r9]
	sub	r8, r8, #1	@ Sub from our length counter
	cmp	r8, #0		@ Compares r9 to 0 to determine if finished
	moveq	r14, r6
	popeq	{r4-r12}
	moveq	pc, lr		@ Move back to saved mem location in r6		
	b	L7
	
L8:
	cmp	r8, #1
	movne	r0, #0
	movne	pc, r6
	mov	r0, #'='
	mov	r14, r6
	pop	{r4-r12}
	mov	pc, lr
	

L9:
	mov	r1, r2
	mov	r9, #0x2000
	cmp	r8, #0
	blgt	byte_at_two
	cmp	r0, #'E'	@ Checks for error
	beq	E12
		
	cmp	r0, #'?'	@ Check for seperator
	beq	L10

	ldrb	r0, [r9]
	add	r0, r0, #1	@ Add 1 to our position to start at
	strb	r0, [r9]
	sub	r8, r8, #1	@ Sub from our length counter
	cmp	r8, #0		@ Compares r9 to 0 to determine if finished
	moveq	r14, r6
	popeq	{r4-r12}
	moveq	pc, lr		@ Move back to saved mem location in r6		
	b	L9
	
L10:
	cmp	r8, #1
	movne	r0, #0
	movne	pc, r6
	mov	r0, #'?'
	mov	r14, r6
	pop	{r4-r12}
	mov	pc, lr

L11:
	add	r8, r8, #1

	@cmp	r8, #17		@ Determines if it is looking for length of 16
	@beq	L12		@ Branch and links to byte_at to check all values
	
	cmp	r8, #11		@ Determines if it is looking for length of 10
	beq	L13	
	
L13:	
	mov	r1, r2
	cmp	r8, #1
	blgt	byte_at_two
	cmp	r0, #'E'	@ Checks for error
	beq	E11

		
	cmp	r0, #'?'	@ Check for seperator
	beq	L10

	mov	r7, #0x2000
	ldrb	r0, [r7]
	@add	r0, r0, #5
	
	sub	r8, r8, #1
	cmp	r8, #1
	moveq	r14, r6
	popeq	{r4-r12}
	moveq	pc, lr
	b	L13


byte_at_two:
	@push	{r0, r1}	@ This is a speical byte_at for call only by digits
	mov	r10, #0		@ This one implements some extra code to deal with position number from first byte_at
	mov	r5, #5		@ It will check by determining if the value is over 85 which is what is sent in the 
	@cmp	r0, #91		@ second call to digits
	@bgt	E6
	cmp	r0, #85
	bge	L17
	mul	r5, r5, r0
	add	r1, r1, r5
	ldrb	r4, [r1], #1
	mov	r7, #0x2000
	strb	r0, [r7]
	mov	r5, #0
	mov	r7, #0

	cmp	r4, #0x30
	beq	L14
	cmp	r4, #0x31
	addeq	r7, r7, #1
	beq	L14
	bne	L18

L14:					
	ldrb	r4, [r1], #1
	cmp	r4, #0x31
	addeq	r5, r5, #8
	addeq	r7, r7, #1
	
	ldrb	r4, [r1], #1
	cmp	r4, #0x31
	addeq	r5, r5, #4
	addeq	r7,r7, #1

	ldrb	r4, [r1], #1
	cmp	r4, #0x31
	addeq	r5, r5, #2
	addeq	r7, r7, #1

	ldrb	r4, [r1]
	cmp	r4, #0x31
	addeq	r5, r5, #1
	addeq	r7, r7, #1

	and	r7, r7, #0x01
	cmp	r7, #1
	bne	L18
	
	b	L16

L15:
	mov	r0, r5
	mov	pc, lr

L16:
	cmp	r5, #0
	moveq	r5, #0x30
	cmp	r5, #1
	moveq	r5, #0x31
	cmp	r5, #2
	moveq	r5, #0x32
	cmp	r5, #3
	moveq	r5, #0x33
	cmp	r5, #4
	moveq	r5, #0x34
	cmp	r5, #5
	moveq	r5, #0x35
	cmp	r5, #6
	moveq	r5, #0x36
	cmp	r5, #7
	moveq	r5, #0x37
	cmp	r5, #8
	moveq	r5, #0x38
	cmp	r5, #9
	moveq	r5, #0x39
	cmp	r5, #10
	moveq	r5, #':'
	cmp	r5, #11
	moveq	r5, #';'
	beq	E5
	cmp	r5, #12
	moveq	r5, #'<'
	cmp	r5, #13
	moveq	r5, #'='
	cmp	r5, #14
	moveq	r5, #'>'
	cmp	r5, #15
	moveq	r5, #'?'
	mov	r0, r5
	mov	pc, lr

E5:
	mov	r7, #0x2100
	strb	r0, [r7]
	mov	r0, r5
	mov	pc, lr

L17:
	cmp	r0, #85
	bgt	E6
	b	E7


L18:
	mov	r0, #'E'
	strb	r12, [r11]
	mov	pc, lr


E6:
	cmp	r0, #95
	mov	r7, #0x2100
	ldrb	r10, [r7]	
	b	E7
	
E7:
	mov	r7, #0x2100
	ldrb	r10, [r7]
	mov	r5, #5
	cmp	r0, #85
	moveq	r0, #17
	cmp	r0, #90
	moveq	r0, #18
	cmp	r0, #95
	moveq	r0, #19
	cmp	r0, #100
	moveq	r0, #20
	cmp	r0, #105
	moveq	r0, #21
	cmp	r0, #110
	moveq	r0, #22
	cmp	r0, #115
	moveq	r0, #23
	cmp	r0, #120
	moveq	r0, #24
	cmp	r0, #125
	moveq	r0, #25
	cmp	r0, #130
	moveq	r0, #26
	cmp	r0, #135
	moveq	r0, #27
	cmp	r0, #140
	moveq	r0, #28
	cmp	r0, #145
	moveq	r0, #29
	cmp	r0, #150
	moveq	r0, #30
	cmp	r0, #155
	moveq	r0, #31
	cmp	r0, #160
	moveq	r0, #32
	cmp	r0, #19
	addle	r0, r0, r10
	addgt	r0, r0, #1
	mul	r5, r5, r0
	add	r1, r1, r5

	

	ldrb	r4, [r1], #1
	mov	r7, #0x2000
	strb	r5, [r7]
	mov	r5, #0
	mov	r7, #0

	cmp	r4, #0x30
	beq	L14
	cmp	r4, #0x31
	addeq	r7, r7, #1
	beq	L14
	bne	L18

E10:
	strb	r12, [r11]
	mov	r0, #0		@ Stores 0 if error exists
	mov	pc, r6		@ Sends back to program with zero

E11:
	strb	r12, [r11]
	mov	r14, r6
	mov	r0, #0		@ Stores 0 if error exists
	pop	{r4-r12}
	mov	pc, lr		@ Sends back to program with zero

E12:
	strb	r12, [r11]
	mov	r14, r6
	mov	r0, #0		@ Stores 0 if error exists
	pop	{r4-r12}
	mov	pc, lr		@ Sends back to program with zero



