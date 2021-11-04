/*	To do:
	( ) 1 - Leitura dos Conjuntos
	( ) 2 - Encontrar União
	( ) 3 - Encontrar Intersecção
	( ) 4 - Encontrar a Diferença
	( ) 5 - Encontrar o Complementar
*/

.section .data

	opening_msg:			.asciz	"\nManipulador de Conjuntos Numericos\n"
	
	main_menu:				.asciz	"\nMenu de Opcoes:\n\n\t1 - Leitura dos Conjuntos\n\t2 - Encontrar Uniao\n\t3 - Encontrar Intersecao\n\t4 - Encontrar a Diferenca\n\t5 - Encontrar o Complementar\n\t6 - Sair\n\n"
	ask_option:				.asciz	"Digite a opcao escolhida: "
	invalid_option_msg:		.asciz	"Opcao Invalida, tente novamente.\n"
	invalid_value_msg:		.asciz	"Valor Invalido, tente novamente.\n"
	repeat_value_msg:		.asciz	"Elemento ja presente no conjunto, tente novamente.\n"

	read_values_msg:		.asciz	"\nLeitura dos Conjuntos\n\n"
	read_values_menu:		.asciz	"\n\t1. Inserir Conjunto A\n\t2. Inserir Conjunto B\n\t3. Sair\n\n"

	ask_number_of_values:	.asciz	"Digite o numero de elementos do conjunto (max. %d): "
	ask_values:				.asciz	"Digite o elemento %d do conjunto: "

	print_values_A:			.asciz	"Valores do Conjunto A: "
	print_values_B:			.asciz	"Valores do Conjunto B: "
	print_value:			.asciz	"%d "
	skip_line:				.asciz	"\n"

	set_A:		.space	80
	set_B:		.space	80
	
	max_number_of_elements:				.int	20
	number_of_elements_A:	.int	0
	number_of_elements_B:	.int	0

	element:		.int	0
	flag:			.int	0
	aux:			.int	0
	
	option:		.int	0
	int_type:	.asciz	"%d"

.section .text
.globl	_start

_start:

	// Printa a mensagem de abertura e o menu
	pushl	$opening_msg	
	call	printf

_main_menu:
	pushl	$main_menu
	call	printf

	addl	$8, %esp

_get_main_option_loop:

	// Loop para pegar a opcao do usuario, repete ate receber uma opcao valida
	pushl	$ask_option
	call	printf
	addl	$4, %esp

	pushl	$option
	pushl	$int_type
	call	scanf
	addl	$8, %esp

	movl	option, %eax
	
	// Leitura dos Conjuntos
	cmpl	$1, %eax	
	je	_read_sets

	// Encontrar Uniao
	cmpl	$2, %eax	
	je	_option2

	// Encontrar Intersecao
	cmpl	$3, %eax	
	je	_option3

	// Encontrar a Diferenca
	cmpl	$4, %eax	
	je	_option4

	// Encontrar o Complementar
	cmpl	$5, %eax	
	je	_option5

	// Sair
	cmpl	$6, %eax	
	je	_end

	pushl	$invalid_option_msg
	call	printf
	addl	$4, %esp

	jmp _get_main_option_loop

_read_sets:
	/*	
	Leitura dos Conjuntos
		Valores em A: X X X X X X X X
		Valores em B: X X X X X X X X

		1. Editar Conjunto A
		2. Editar Conjunto B
		3. Sair
	*/

	pushl	$read_values_msg	
	call	printf
	addl	$4, %esp

	call	_print_values_A
	call	_print_values_B

	pushl	$read_values_menu
	call	printf
	addl	$4, %esp

	_get_read_option_loop:

		// Loop para pegar a opcao do usuario, repete ate receber uma opcao valida
		pushl	$ask_option
		call	printf
		addl	$4, %esp

		pushl	$option
		pushl	$int_type
		call	scanf
		addl	$8, %esp

		movl	option, %eax
		
		// Leitura dos Conjunto A
		cmpl	$1, %eax	
		je	_read_set_A

		// Leitura dos Conjunto B
		cmpl	$2, %eax	
		je	_read_set_B

		// Voltar ao menu principal
		cmpl	$3, %eax	
		je	_main_menu

		pushl	$invalid_option_msg
		call	printf
		addl	$4, %esp

		jmp _get_read_option_loop

	_read_set_A:
	
		pushl	max_number_of_elements
		pushl	$ask_number_of_values
		call	printf
		addl	$4, %esp

		pushl	$number_of_elements_A
		pushl	$int_type
		call	scanf
		addl	$8, %esp

		movl	number_of_elements_A, %eax
		cmpl	max_number_of_elements,	%eax
		jg	_invalid_value_A
		cmpl	$0,	%eax
		jl	_invalid_value_A


		call _get_values_for_A


		jmp	_read_sets

		_invalid_value_A:
			pushl	$invalid_value_msg
			call	printf
			addl	$4, %esp
			
			jmp	_read_set_A


	_read_set_B:
	
		pushl	max_number_of_elements
		pushl	$ask_number_of_values
		call	printf
		addl	$4, %esp

		pushl	$number_of_elements_B
		pushl	$int_type
		call	scanf
		addl	$8, %esp

		movl	number_of_elements_B, %eax
		cmpl	max_number_of_elements,	%eax
		jg	_invalid_value_B
		cmpl	$0,	%eax
		jl	_invalid_value_B

		call _get_values_for_B


		jmp	_read_sets

		_invalid_value_B:
			pushl	$invalid_value_msg
			call	printf
			addl	$4, %esp
			
			jmp	_read_set_B

_option2:
	// Encontrar Uniao

_option3:
	// Encontrar Intersecao

_option4:
	// Encontrar a Diferenca

_option5:
	// Encontrar o Complementar

_end:

	pushl	$0
	call	exit

_print_values_A:

	pushl	$print_values_A
	call	printf
	addl	$4, %esp

	movl	$1, %ebx
	movl	number_of_elements_A, %ecx
	movl	$set_A, %edi

	cmpl	$0,	%ecx
	je	_print_values_B_end

	_print_values_A_loop:

		pushl	%ebx
		pushl	%ecx
		pushl	%edi


		movl	(%edi), %eax
		movl	%eax, element

		pushl	element	
		pushl	$print_value
		call	printf
		addl	$8, %esp


		popl	%edi
		popl	%ecx
		popl	%ebx

		addl	$4, %edi
		incl	%ebx

	loop	_print_values_A_loop

	_print_values_A_end:

	pushl	$skip_line	
	call	printf
	addl	$4, %esp

ret

_print_values_B:

	pushl	$print_values_B
	call	printf
	addl	$4, %esp

	movl	$1, %ebx
	movl	number_of_elements_B, %ecx
	movl	$set_B, %edi

	cmpl	$0,	%ecx
	je	_print_values_B_end

	_print_values_B_loop:

		pushl	%ebx
		pushl	%ecx
		pushl	%edi


		movl	(%edi), %eax
		movl	%eax, element

		pushl	element	
		pushl	$print_value
		call	printf
		addl	$8, %esp


		popl	%edi
		popl	%ecx
		popl	%ebx

		addl	$4, %edi
		incl	%ebx

	loop	_print_values_B_loop

	_print_values_B_end:
	pushl	$skip_line	
	call	printf
	addl	$4, %esp

ret

_get_values_for_A:

	movl	$1, %ebx
	movl	number_of_elements_A, %ecx
	movl	$set_A, %edi

	_read_set_A_loop:
		movl	$0,	flag
		movl	%ebx,	aux
		decl	aux

		pushl	%ebx
		pushl	%ecx
		pushl	%edi

		pushl	%ebx
		pushl	$ask_values
		call	printf
		addl	$8, %esp

		pushl	$element
		pushl	$int_type
		call	scanf
		addl	$8, %esp

		call	_check_for_repeat_A

		popl	%edi
		popl	%ecx
		popl	%ebx

		movl	flag,	%eax
		cmpl	$1,	%eax
		je	_read_set_A_loop

		movl	element, %eax
		movl	%eax, (%edi)
		addl	$4, %edi
		incl	%ebx

	loop	_read_set_A_loop

ret

_get_values_for_B:

	movl	$1, %ebx
	movl	number_of_elements_B, %ecx
	movl	$set_B, %edi

	_read_set_B_loop:
		movl	$0,	flag
		movl	%ebx,	aux
		decl	aux

		pushl	%ebx
		pushl	%ecx
		pushl	%edi

		pushl	%ebx
		pushl	$ask_values
		call	printf
		addl	$8, %esp

		pushl	$element
		pushl	$int_type
		call	scanf
		addl	$8, %esp

		call	_check_for_repeat_B

		popl	%edi
		popl	%ecx
		popl	%ebx

		movl	flag,	%eax
		cmpl	$1,	%eax
		je	_read_set_B_loop

		movl	element, %eax
		movl	%eax, (%edi)
		addl	$4, %edi
		incl	%ebx

	loop	_read_set_B_loop
			
ret

_check_for_repeat_A:

	movl	$1, %ebx
	movl	aux, %ecx
	movl	$set_A, %edi

	cmpl	$0, %ecx
	jle	_check_for_repeat_A_end

	_check_for_repeat_A_loop:

		pushl	%ebx
		pushl	%ecx
		pushl	%edi


		movl	(%edi), %eax
		cmpl	element, %eax
		je	_is_element_A_repeat
		_is_element_A_repeat_ret:

		popl	%edi
		popl	%ecx
		popl	%ebx

		addl	$4, %edi
		incl	%ebx

	loop	_check_for_repeat_A_loop

_check_for_repeat_A_end:
ret

_is_element_A_repeat:
	movl	$0,	flag
	call _repeat_value_error
	jmp	_is_element_A_repeat_ret

_check_for_repeat_B:

	movl	$1, %ebx
	movl	aux, %ecx
	movl	$set_B, %edi

	cmpl	$0, %ecx
	jle	_check_for_repeat_B_end

	_check_for_repeat_B_loop:

		pushl	%ebx
		pushl	%ecx
		pushl	%edi


		movl	(%edi), %eax
		cmpl	element, %eax
		je	_is_element_B_repeat
		_is_element_B_repeat_ret:

		popl	%edi
		popl	%ecx
		popl	%ebx

		addl	$4, %edi
		incl	%ebx

	loop	_check_for_repeat_B_loop


_check_for_repeat_B_end:
ret

_is_element_B_repeat:
	movl	$0,	flag
	call _repeat_value_error
	jmp	_is_element_B_repeat_ret

_repeat_value_error:

	pushl	$repeat_value_msg
	call	printf
	addl	$4, %esp
	movl	$1,	flag

ret
