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
	empty_set_error_msg:	.asciz	"\nUm ou mais conjuntos estao vazios. Preencha-os antes de executar essa opcao\n"

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
	je	_find_union

	// Encontrar Intersecao
	cmpl	$3, %eax	
	je	_find_intersection

	// Encontrar a Diferenca
	cmpl	$4, %eax	
	je	_find_difference

	// Encontrar o Complementar
	cmpl	$5, %eax	
	je	_find_complement

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
		
		// Emite opcao invalida
		pushl	$invalid_option_msg
		call	printf
		addl	$4, %esp

		jmp _get_read_option_loop

	_read_set_A:
		// Leitura do conjunto A

		// Pede o numero de elementos do conjunto A
		pushl	max_number_of_elements
		pushl	$ask_number_of_values
		call	printf
		addl	$4, %esp

		pushl	$number_of_elements_A
		pushl	$int_type
		call	scanf
		addl	$8, %esp

		// Ve se o numero de elementos eh um valor invalido
		movl	number_of_elements_A, %eax
		cmpl	max_number_of_elements,	%eax
		jg	_invalid_value_A
		cmpl	$0,	%eax
		jl	_invalid_value_A

		// Chama funcao que le os valores para o conjunto A
		call _get_values_for_A


		jmp	_read_sets

		_invalid_value_A:
			// Se o valor for invalido, exibe a mensagem e tenta novamente
			pushl	$invalid_value_msg
			call	printf
			addl	$4, %esp
			
			jmp	_read_set_A


	_read_set_B:
		// Leitura do conjunto B

		// Pede o numero de elementos do conjunto B
		pushl	max_number_of_elements
		pushl	$ask_number_of_values
		call	printf
		addl	$4, %esp

		pushl	$number_of_elements_B
		pushl	$int_type
		call	scanf
		addl	$8, %esp

		// Ve se o numero de elementos eh um valor invalido
		movl	number_of_elements_B, %eax
		cmpl	max_number_of_elements,	%eax
		jg	_invalid_value_B
		cmpl	$0,	%eax
		jl	_invalid_value_B

		// Chama funcao que le os valores para o conjunto B
		call _get_values_for_B


		jmp	_read_sets

		_invalid_value_B:
			// Se o valor for invalido, exibe a mensagem e tenta novamente
			pushl	$invalid_value_msg
			call	printf
			addl	$4, %esp
			
			jmp	_read_set_B

_find_union:
	// Encontrar Uniao
	movl	number_of_elements_A, %eax
	movl	number_of_elements_B, %ebx
	cmpl	$0, %eax
	je		_empty_set_error
	cmpl	$0, %ebx
	je		_empty_set_error

_find_intersection:
	// Encontrar Intersecao
	movl	number_of_elements_A, %eax
	movl	number_of_elements_B, %ebx
	cmpl	$0, %eax
	je		_empty_set_error
	cmpl	$0, %ebx
	je		_empty_set_error


_find_difference:
	// Encontrar a Diferenca
	movl	number_of_elements_A, %eax
	movl	number_of_elements_B, %ebx
	cmpl	$0, %eax
	je		_empty_set_error
	cmpl	$0, %ebx
	je		_empty_set_error


_find_complement:
	// Encontrar o Complementar
	movl	number_of_elements_A, %eax
	movl	number_of_elements_B, %ebx
	cmpl	$0, %eax
	je		_empty_set_error
	cmpl	$0, %ebx
	je		_empty_set_error


_end:

	pushl	$0
	call	exit

_empty_set_error:

	// Exibe a mensagem de erro para o caso do conjunto estar vazio
	pushl	$empty_set_error_msg	
	call	printf

	// Retorna ao menu principal
	jmp	_main_menu

_print_values_A:
	// Mostra os valores do conjunto A

	pushl	$print_values_A
	call	printf
	addl	$4, %esp

	movl	$1, %ebx
	movl	number_of_elements_A, %ecx
	movl	$set_A, %edi

	// Se esiver vazio, pula para o fim da funcao
	cmpl	$0,	%ecx
	je	_print_values_A_end

	_print_values_A_loop:

		// pushl pra backup
		pushl	%ebx	
		pushl	%ecx
		pushl	%edi


		// pega o valor e printa
		movl	(%edi), %eax
		movl	%eax, element

		pushl	element	
		pushl	$print_value
		call	printf
		addl	$8, %esp

		// restaurando backup
		popl	%edi
		popl	%ecx
		popl	%ebx

		addl	$4, %edi
		incl	%ebx

	loop	_print_values_A_loop

	_print_values_A_end:
		// final da função, pula a linha e retorna
	pushl	$skip_line	
	call	printf
	addl	$4, %esp

ret

_print_values_B:
	// Mostra os valores do conjunto B
	pushl	$print_values_B
	call	printf
	addl	$4, %esp

	movl	$1, %ebx
	movl	number_of_elements_B, %ecx
	movl	$set_B, %edi

	// Se esiver vazio, pula para o fim da funcao
	cmpl	$0,	%ecx
	je	_print_values_B_end

	_print_values_B_loop:
		// pushl pra backup
		pushl	%ebx
		pushl	%ecx
		pushl	%edi

		// pega o valor e printa
		movl	(%edi), %eax
		movl	%eax, element

		pushl	element	
		pushl	$print_value
		call	printf
		addl	$8, %esp

		// restaurando backup
		popl	%edi
		popl	%ecx
		popl	%ebx

		addl	$4, %edi
		incl	%ebx

	loop	_print_values_B_loop

	_print_values_B_end:
		// final da função, pula a linha e retorna
	pushl	$skip_line	
	call	printf
	addl	$4, %esp

ret

_get_values_for_A:
	// le os valores do usuario e coloca no conjunto A

	movl	$1, %ebx
	movl	number_of_elements_A, %ecx
	movl	$set_A, %edi
	movl	$0,	aux

	_read_set_A_loop:
		// no inicio do loop, reseta a flag de repeticao
		movl	$0,	flag

		// pushl pra backup
		pushl	%ebx
		pushl	%ecx
		pushl	%edi

		// pede um valor
		pushl	%ebx
		pushl	$ask_values
		call	printf
		addl	$8, %esp

		pushl	$element
		pushl	$int_type
		call	scanf
		addl	$8, %esp

		// verifica repetição, se houver levanta a flag
		call	_check_for_repeat_A

		// restaurando backup
		popl	%edi
		popl	%ecx
		popl	%ebx

		// se houve repetição tenta novamente sem incrementar o contador
		movl	flag,	%eax
		cmpl	$1,	%eax
		je	_read_set_A_loop

		// se nao houve repetição segue o loop
		movl	element, %eax
		movl	%eax, (%edi)
		addl	$4, %edi
		incl	%ebx
		incl	aux

	loop	_read_set_A_loop

ret

_get_values_for_B:
	// le os valores do usuario e coloca no conjunto B
	movl	$1, %ebx
	movl	number_of_elements_B, %ecx
	movl	$set_B, %edi
	movl	$0,	aux

	_read_set_B_loop:
		// no inicio do loop, reseta a flag de repeticao
		movl	$0,	flag

		// pushl pra backup
		pushl	%ebx
		pushl	%ecx
		pushl	%edi

		// pede um valor
		pushl	%ebx
		pushl	$ask_values
		call	printf
		addl	$8, %esp

		pushl	$element
		pushl	$int_type
		call	scanf
		addl	$8, %esp

		// verifica repetição, se houver levanta a flag
		call	_check_for_repeat_B

		// restaurando backup
		popl	%edi
		popl	%ecx
		popl	%ebx

		// se houve repetição tenta novamente sem incrementar o contador
		movl	flag,	%eax
		cmpl	$1,	%eax
		je	_read_set_B_loop

		// se nao houve repetição segue o loop
		movl	element, %eax
		movl	%eax, (%edi)
		addl	$4, %edi
		incl	%ebx
		incl	aux

	loop	_read_set_B_loop
			
ret

_check_for_repeat_A:
	// funcao para checar se o elemento eh repetido em A
	movl	$1, %ebx
	movl	aux, %ecx
	movl	$set_A, %edi

	// se for o primeiro elemento não precisa checar, pula para o fim
	cmpl	$0, %ecx
	jle	_check_for_repeat_A_end

	_check_for_repeat_A_loop:

		// pushl pra backup
		pushl	%ebx
		pushl	%ecx
		pushl	%edi

		// se o elemento for repetido, pula para a funcao
		movl	(%edi), %eax
		cmpl	element, %eax
		je	_element_in_A_is_repeated
		_element_in_A_is_repeated_ret:
			// label de retorno
		
		// restaurando backup
		popl	%edi
		popl	%ecx
		popl	%ebx

		addl	$4, %edi
		incl	%ebx

	loop	_check_for_repeat_A_loop

_check_for_repeat_A_end:
	// final da função, retorna
ret

_element_in_A_is_repeated:
	//	chama a função para printar a mensagem de erro na tela e levantar flag
	movl	$0,	flag
	call _repeat_value_error
	// retorna para a execução
	jmp	_element_in_A_is_repeated_ret

_check_for_repeat_B:
	// funcao para checar se o elemento eh repetido em A

	movl	$1, %ebx
	movl	aux, %ecx
	movl	$set_B, %edi

	// se for o primeiro elemento não precisa checar, pula para o fim
	cmpl	$0, %ecx
	jle	_check_for_repeat_B_end

	_check_for_repeat_B_loop:

		// pushl pra backup
		pushl	%ebx
		pushl	%ecx
		pushl	%edi

		// se o elemento for repetido, pula para a funcao
		movl	(%edi), %eax
		cmpl	element, %eax
		je	_is_element_B_repeat
		_is_element_B_repeat_ret:
			// label de retorno
		// restaurando backup
		popl	%edi
		popl	%ecx
		popl	%ebx

		addl	$4, %edi
		incl	%ebx

	loop	_check_for_repeat_B_loop


_check_for_repeat_B_end:
	// final da função, retorna
ret

_is_element_B_repeat:
	//	chama a função para printar a mensagem de erro na tela e levantar flag
	movl	$0,	flag
	call _repeat_value_error
	// retorna para a execução
	jmp	_is_element_B_repeat_ret

_repeat_value_error:

	// levanta a flag, printa a mensagem de erro na tela e retorna
	pushl	$repeat_value_msg
	call	printf
	addl	$4, %esp
	movl	$1,	flag

ret
