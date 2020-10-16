.text
	.equ	HEX,		0xFF200020
	.equ	KEY,		0xFF200050
    .equ	E, 			0b01111001
	.equ	three, 		0b01001111
	.equ	dash,		0b01000000
	.equ	blank,		0b00000000
	.equ	pattern, 	0b01001001

busy_wait:
	subi	r7, r7, 1			# Keeps the CPU busy subtracting 1 from r7
    bgt		r7, r0, busy_wait	# Loops until r7 is zero
    ret

# The following button wait functions ensure that if the button is held, rather than pressed, the program with wait
button_wait1:
	ldwio	r8, 0(r5)			# Reading from the button outputs
	bne		r8, r0, button_wait1# We wait until the button has been released
	br		loop1				# When the button has been released, we branch to loop2
button_wait2:
	ldwio	r8, 0(r5)			# Reading from the button outputs
	bne		r8, r0, button_wait2# We wait until the button has been released
	br		loop2				# When the button has been released, we branch to loop2

display:						# For first loop
#Function prologue
	subi	sp, sp, 4			# Moving the stack pointer
    stw		ra, 0(sp)			# Storing the return address to the stack
    
	stwio	r6, 0(r4)			# Displaying value at r5 to the HEX displays
    movi	r7, 10000			# Busy_wait will count down from 10000
    slli	r7, r7, 10			# Shift 7 bits for the online simulator and 10 for the DE10-Lite
    
    call 	busy_wait
    
    slli	r6, r6, 8
#Function epilogue
    ldw		ra, 0(sp)			# Loading the original return address from the stack
    addi	sp, sp, 4			# Moving the stack pointer to its position before the function call
	ret



	.global _start
_start:
	movia	r4, HEX				# Address of HEX 0-3   
	movia	r5, KEY				# Address of the button KEYs 
    movia 	sp, 0x04000000		# Stack Pointer
    subi	sp, sp, 4

loop1:
	ori		r6, r6, E			# Starting with an E
	call 	display
	ldwio	r8, 0(r5)			# Reading from the button outputs
	bne		r8, r0, button_wait2# If a button is pressed, we branch to button_wait2

    ori		r6, r6,	pattern		# Insert the next letter into spots 7-0 for HEX0
	call 	display				# Display function
	ldwio	r8, 0(r5)
	bne		r8, r0, button_wait2
    ori		r6, r6,	pattern		# Repeat
    call 	display
	ldwio	r8, 0(r5)
	bne		r8, r0, button_wait2
    ori		r6, r6,	pattern
    call 	display
	ldwio	r8, 0(r5)
	bne		r8, r0, button_wait2
    ori		r6, r6,	blank
    call 	display
	ldwio	r8, 0(r5)
	bne		r8, r0, button_wait2
	ori		r6, r6,	blank
    call 	display
	ldwio	r8, 0(r5)
	bne		r8, r0, button_wait2
	ori		r6, r6,	blank
    call 	display
	ldwio	r8, 0(r5)
	bne		r8, r0, button_wait2
	ori		r6, r6,	blank
    call 	display
	
	ldwio	r8, 0(r5)			# Reading from the button outputs
	bne		r8, r0, button_wait2# If a button is pressed, we branch to button_wait
	br 		loop1				# Otherwise, we stay in this loop
	
loop2:
	ori		r6, r6, blank
	call 	display
	ldwio	r8, 0(r5)
	bne		r8, r0, button_wait1

    ori		r6, r6,	blank
	call 	display
	ldwio	r8, 0(r5)
	bne		r8, r0, button_wait1
    ori		r6, r6,	blank
    call 	display
	ldwio	r8, 0(r5)
	bne		r8, r0, button_wait1
    ori		r6, r6,	blank
    call 	display
	ldwio	r8, 0(r5)
	bne		r8, r0, button_wait1
    ori		r6, r6,	pattern
    call 	display
	ldwio	r8, 0(r5)
	bne		r8, r0, button_wait1
	ori		r6, r6,	pattern
    call 	display
	ldwio	r8, 0(r5)
	bne		r8, r0, button_wait1
	ori		r6, r6,	pattern
    call 	display
	ldwio	r8, 0(r5)
	bne		r8, r0, button_wait1
	ori		r6, r6,	three
    call 	display
	
	ldwio	r8, 0(r5)			# Reading from the button outputs
	bne		r8, r0, button_wait1# If a button is pressed, we branch to button_wait
	br 		loop2				# Otherwise, we stay in this loop
