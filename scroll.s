	.text
	.equ	HEX,		0xFF200020
	.equ	H,			0b01110110 
    .equ	E, 			0b01111001
    .equ	l,			0b00110000
	.equ	O,			0b00111111
	.equ	B,			0b01111111
	.equ	U,			0b00111110
	.equ	f,			0b01110001
	.equ	S,			0b01101101
	.equ	dash,		0b01000000
	.equ	blank,		0b00000000
	.equ	patternA,	0b01001001
	.equ	patternB,	0b00110110
	.equ	patternC,	0b01111111
					
busy_wait:
	subi	r7, r7, 1			# Keeps the CPU busy subtracting 1 from r7
    bgt		r7, r0, busy_wait	# Loops until r7 is zero
    ret

display:
#Function prologue
	subi	sp, sp, 4			# Moving the stack pointer
    stw		ra, 0(sp)			# Storing the return address to the stack
    
	stwio	r5, 0(r4)			# Displaying value at r5 to the HEX displays
    movi	r7, 5000			# Busy_wait will count down from 10000
    slli	r7, r7, 10			# Shift 7 bits for the online simulator and 10 for the DE10-Lite
    
    call 	busy_wait
    
    slli	r5, r5, 8
#Function epilogue
    ldw		ra, 0(sp)			# Loading the original return address from the stack
    addi	sp, sp, 4			# Moving the stack pointer to its position before the function call
	ret
    

	.global _start
_start:
	movia	r4, HEX				# Address of HEX 0-3    
    movia 	sp, 0x04000000		# Stack Pointer
    subi	sp, sp, 4
    

LOOP:
	movi	r5, H				# Starting with an H pattern on the first HEX
	stwio	r5, (r4)			# Load the HEX displays
    movi	r7, 10000
    call 	busy_wait			# Wait
    
    slli	r5, r5, 8			# Shift the letter over
    ori		r5, r5,	E			# Insert the next letter into spots 7-0 for HEX0
	call 	display				# Display
    
    ori		r5, r5,	l			# Repeat
    call 	display

    ori		r5, r5,	l
    call 	display
    
    ori		r5, r5,	O
    call 	display
    
    ori		r5, r5,	blank
    call 	display
    
    ori		r5, r5,	B
    call 	display
    
    ori		r5, r5,	U
    call 	display
    
    ori		r5, r5,	f
    call 	display
    
    ori		r5, r5,	f
    call 	display
    
    ori		r5, r5,	S
    call 	display

# Final Pattern
	ori		r5, r5,	dash
    call 	display
    ori		r5, r5,	dash
    call 	display
    ori		r5, r5,	dash
    call 	display
    ori		r5, r5,	blank
    call 	display
    ori		r5, r5, blank
    call 	display
    ori		r5, r5,	blank
    call 	display
	ori		r5, r5,	blank
    call 	display
	ori		r5, r5,	patternA
    call 	display
    ori		r5, r5,	patternB
    call 	display
    ori		r5, r5,	patternA
    call 	display
    ori		r5, r5,	patternB
    call 	display
    ori		r5, r5,	patternA
    call 	display
    ori		r5, r5,	patternB
    call 	display
    ori		r5, r5,	patternC
    call 	display
    ori		r5, r5,	blank
    call 	display
    ori		r5, r5,	patternC
    call 	display
    ori		r5, r5,	blank
    call 	display
    ori		r5, r5,	patternC
    call 	display
    ori		r5, r5,	blank
	stwio	r5, (r4)
    movi	r7, 10000
    call 	busy_wait
    
	br		LOOP
	.end