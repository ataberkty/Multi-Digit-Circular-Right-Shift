.intel_syntax noprefix

.section .data
digits:
	.asciz "Enter number of digits:"
nums:
	.asciz "Enter %d. digit:"
rotate1:
	.asciz "\nEnter number of bits to rotate:"
rotate2:
	.asciz "\nAfter the rotations\n"
format1:
	.asciz "\nA :="
format2:
	.asciz "\nC :="
format3:
	.asciz " + (0x%lX * (2^64)^%d)"
format4:
	.asciz ";\n"
input1:
	.asciz "%d"
input2:
	.asciz "%lX"
arr:
	.skip 100
arr2:
	.skip 100	
tmp:
	.quad 0
no_digits:
	.quad 0	

.section .text
.global main
main:
	push rbx
	push r12
	push r13
	push r14
	push r15
	
	mov rbx,0
	mov r12,0

	#printf "Enter number of digits:"
	push rax
	push rcx
	lea rdi, [digits]
	xor rax, rax
	call printf
	pop rax
	pop rcx

	#scanf number of digits
	push rax
	push rcx
	lea rdi, [input1]
	lea rsi, [tmp]
	xor rax, rax
	call scanf
	pop rax
	pop rcx

	mov rcx, [tmp]			# number of digits
	mov [no_digits], rcx 	# number of digits
	mov r14, rcx			# number of digits
	dec r14					# number of digits - 1
	mov r15, rcx			# number of digits
	movq [tmp], 0			# clear tmp

	while:
		cmp rcx, 0		# if( n != 0 ) içeri gir
		jle print_a

		dec r15
		#printf "Enter %d. digit:"
		mov rsi, r15

		push rax
		push rcx
		lea rdi, [nums]
		xor rax, rax
		call printf
		pop rax
		pop rcx

		#scanf num
		push rax
		push rcx
		lea rdi, [input2]
		lea rsi, [tmp]
		xor rax, rax
		call scanf
		pop rax
		pop rcx

		mov r9, [tmp]	# number of digits
		mov [arr+ 8 * rbx], r9
		mov r10, [arr+ 8 * rbx]
		inc rbx
		movq [tmp], 0		# clear tmp
		dec rcx
		jmp while
		




	print_a:
		# print "a=:"
		push rax
		push rcx
		lea rdi, [format1]
		xor rax, rax
		call printf
		pop rax
		pop rcx

		mov r13,r14				# (2^64)^2 'yi eşitliyorum

		loop:
			cmp r14, 0		# n < 0 ise gir
			jl print_noktali_virgul

			#arrayi printliyorum "
			mov rsi, [arr + 8 * r12]
			mov rdx, r14				# (2^64)^%d

			push rax
			push rcx
			lea rdi, [format3]
			xor rax, rax
			call printf
			pop rax
			pop rcx

			dec r14
			inc r12
			jmp loop

print_noktali_virgul:
		# print ";\n"
		push rax
		push rcx
		lea rdi, [format4]
		xor rax, rax
		call printf
		pop rax
		pop rcx


		# print "\nEnter number of bits to rotate:"
		push rax
		push rcx
		lea rdi, [rotate1]
		xor rax, rax
		call printf
		pop rax
		pop rcx

		#scanf number of bits to rotate:
		push rax
		push rcx
		lea rdi, [input1]
		lea rsi, [tmp]
		xor rax, rax
		call scanf
		pop rax
		pop rcx

		mov rdx, [tmp]		# number of bits to rotate
		mov r15, rdx		# number of bits to rotate
		movq [tmp], 0		# clear tmp

		#rotate işlemi
		mov r12, 0					# index
		mov r9, 1

		inc r15
	#loop koytyyyy!!!!!!!
while2:
	dec r15
	cmp r15, 0
	jle rotate_finished
	mov r12, 0					# index
	
	rotate:
		cmp r12, [no_digits]		# number of digits ile karşılaştırıyorum
		jge while2
		shr r9, 1					# carry 'yi eski haline getirdim
		
		mov rax, [arr + 8 * r12]	# arrayi koyuyorum
		#mov rcx, r15				# rcx = number_of_bits_to_rotate
		rcr rax, 1			
		
		jnc notCarry	# carrym  yoksa öbür sayıya devam et
		mov r9, 1		# carry'i sakladım
		jmp continue
		notCarry:
			mov r9, 0
		continue:
		
		mov [arr + 8 * r12] , rax	# array'i güncelledim
		mov [arr2 + 8 * r12] ,rax	# daha sonra printlemek için yeni array'e yaziyorum.
		
		inc r12	
		jmp rotate



	
rotate_finished:
		# print "\nAfter the rotations\n"
		push rax
		push rcx
		lea rdi, [rotate2]
		xor rax, rax
		call printf
		pop rax
		pop rcx
		
		# print "\nC :="
		push rax
		push rcx
		lea rdi, [format2]
		xor rax, rax
		call printf
		pop rax
		pop rcx
	
		mov r12, 0				#index = 0
		mov r14, [no_digits]	# number of digits
		dec r14					# number of digits - 1
		
		loop2:
			cmp r14, 0		# n >= 0 ise gir
			jl print_noktali_virgul2

			#arrayi printliyorum "
			mov rsi, [arr + 8 * r12]
			mov rdx, r14				# (2^64)^%d

			push rax
			push rcx
			lea rdi, [format3]
			xor rax, rax
			call printf
			pop rax
			pop rcx

			dec r14
			inc r12
			jmp loop2

	print_noktali_virgul2:
		# print ";\n"
		push rax
		push rcx
		lea rdi, [format4]
		xor rax, rax
		call printf
		pop rax
		pop rcx
	




exit:


	pop r15
	pop r14
	pop r13
	pop r12
	pop rbx
	ret
