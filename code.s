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

	ask_number_of_values:	.asciz	"Digite o numero de elementos do conjunto: "
	ask_values:				.asciz	"Digite o elemento %d do conjunto: "

	print_values_A:			.asciz	"Valores do Conjunto A: "
	print_values_B:			.asciz	"Valores do Conjunto B: "
	print_value:			.asciz	"%d "
	skip_line:				.asciz	"\n"

	set_A:		.space	4
	set_B:		.space	4
	set_ptr:	.space	4

	number_of_elements_A:		.int	0
	number_of_elements_B:		.int	0

	element:		.int	0
	flag:			.int	0
	aux:			.int	0
	
	option:			.int	0
	int_type:		.asciz	"%d"

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
	je		_read_sets

	// Encontrar Uniao
	cmpl	$2, %eax	
	je		_find_union

	// Encontrar Intersecao
	cmpl	$3, %eax	
	je		_find_intersection

	// Encontrar a Diferenca
	cmpl	$4, %eax	
	je		_find_difference

	// Encontrar o Complementar
	cmpl	$5, %eax	
	je		_find_complement

	// Sair
	cmpl	$6, %eax	
	je		_end

	pushl	$invalid_option_msg
	call	printf
	addl	$4, %esp

	jmp		_get_main_option_loop

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
		je		_read_set_A

		// Leitura dos Conjunto B
		cmpl	$2, %eax	
		je		_read_set_B

		// Voltar ao menu principal
		cmpl	$3, %eax	
		je		_main_menu
		
		// Emite opcao invalida
		pushl	$invalid_option_msg
		call	printf
		addl	$4, %esp

		jmp 	_get_read_option_loop

	_read_set_A:
		// Leitura do conjunto A

		// se ja estiver alocado, desaloca e continua
		movl	$0,	%eax
		cmpl	number_of_elements_A,	%eax
		jne		_free_A_before_read
			_free_A_before_read_ret:

		// Pede o numero de elementos do conjunto A
		pushl	$ask_number_of_values
		call	printf
		addl	$4, %esp

		pushl	$number_of_elements_A
		pushl	$int_type
		call	scanf
		addl	$8, %esp

		// Ve se o numero de elementos eh um valor invalido
		movl	number_of_elements_A, %eax
		cmpl	$0,	%eax
		jle		_invalid_value_A

		// Aloca o espaco para o conjunto A
		movl	$4, %eax
		mull	number_of_elements_A
		call	_alloc_set
		movl	%eax, set_A

		// Chama funcao que le os valores para o conjunto A
		movl	number_of_elements_A, %ecx
		movl	set_A, %edi
		call 	_get_values_for_set


		jmp		_read_sets

		_invalid_value_A:
			// Se o valor for invalido, exibe a mensagem e tenta novamente
			pushl	$invalid_value_msg
			call	printf
			addl	$4, %esp
			
			jmp		_read_set_A

		_free_A_before_read:
			// desaloca A e retorna
			pushl	set_A
			call	free

			jmp		_free_A_before_read_ret

	_read_set_B:
		// Leitura do conjunto B

		// se ja estiver alocado, desaloca e continua
		movl	$0,	%eax
		cmpl	number_of_elements_B,	%eax
		jne		_free_B_before_read
			_free_B_before_read_ret:

		// Pede o numero de elementos do conjunto B
		pushl	$ask_number_of_values
		call	printf
		addl	$4, %esp

		pushl	$number_of_elements_B
		pushl	$int_type
		call	scanf
		addl	$8, %esp

		// Ve se o numero de elementos eh um valor invalido
		movl	number_of_elements_B, %eax
		cmpl	$0,	%eax
		jle		_invalid_value_B

		// Aloca o espaco para o conjunto B
		movl	$4, %eax
		mull	number_of_elements_B
		call	_alloc_set
		movl	%eax, set_B

		// Chama funcao que le os valores para o conjunto B
		movl	number_of_elements_B, %ecx
		movl	set_B, %edi
		call 	_get_values_for_set


		jmp		_read_sets

		_invalid_value_B:
			// Se o valor for invalido, exibe a mensagem e tenta novamente
			pushl	$invalid_value_msg
			call	printf
			addl	$4, %esp
			
			jmp		_read_set_B

		_free_B_before_read:
			// desaloca B e retorna
			pushl	set_B
			call	free

			jmp		_free_B_before_read_ret
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

	//	se foi alocado valores nos conjuntos, desalocar
	movl	$0,	%eax
	cmpl	number_of_elements_A, %eax
	// jne		_call_free_A
		_call_free_A_ret:
	cmpl	number_of_elements_B, %eax
	// jne		_call_free_B
		_call_free_B_ret:

	pushl	$0
	call	exit

_call_free_A:
	call _free_set_A
	jmp _call_free_A_ret
	
_call_free_B:
	call _free_set_B
	jmp _call_free_B_ret
	
_empty_set_error:

	// Exibe a mensagem de erro para o caso do conjunto estar vazio
	pushl	$empty_set_error_msg	
	call	printf

	// Retorna ao menu principal
	jmp		_main_menu

_print_values_A:
	// Mostra os valores do conjunto A

	pushl	$print_values_A
	call	printf
	addl	$4, %esp

	movl	$1, %ebx
	movl	number_of_elements_A, %ecx
	movl	set_A, %edi

	// Se esiver vazio, pula para o fim da funcao
	cmpl	$0,	%ecx
	je		_print_values_A_end

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
	movl	set_B, %edi

	// Se esiver vazio, pula para o fim da funcao
	cmpl	$0,	%ecx
	je		_print_values_B_end

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

_get_values_for_set:
	// le os valores do usuario e coloca no conjunto

	// movl	number_of_elements_B, %ecx
	// movl	set_B, %edi		(isso deve ser feito antes de chamar a funcao)

	movl	$1, %ebx
	movl	$0,	aux
	movl	%edi,	set_ptr

	_get_values_loop:
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
		movl	aux, %ecx
		movl	set_ptr, %edi
		call	_check_for_repeat

		// restaurando backup
		popl	%edi
		popl	%ecx
		popl	%ebx

		// se houve repetição tenta novamente sem incrementar o contador
		movl	flag,	%eax
		cmpl	$1,	%eax
		je	_get_values_loop

		// se nao houve repetição segue o loop
		movl	element, %eax
		movl	%eax, (%edi)
		addl	$4, %edi
		incl	%ebx
		incl	aux

	loop	_get_values_loop
			
ret

_check_for_repeat:
	// funcao para checar se o elemento eh repetido no conjunto

	// movl	aux, %ecx
	// movl	set_ptr, %edi   (isso deve ser feito antes de chamar a funcao)

	// se for o primeiro elemento não precisa checar, pula para o fim
	cmpl	$0, %ecx
	jle		_check_for_repeat_end

	movl	$1, %ebx

	_check_for_repeat_loop:

		// pushl pra backup
		pushl	%ebx
		pushl	%ecx
		pushl	%edi

		// se o elemento for repetido, pula para a funcao
		movl	(%edi), %eax
		cmpl	element, %eax
		je		_element_is_repeating

		// restaurando backup
		popl	%edi
		popl	%ecx
		popl	%ebx

		addl	$4, %edi
		incl	%ebx

	loop	_check_for_repeat_loop


	_check_for_repeat_end:
		// final da função, retorna
ret

	_element_is_repeating:
		// levanta a flag, printa a mensagem de erro na tela e retorna

		movl	$1,	flag
		pushl	$repeat_value_msg
		call	printf
		addl	$4, %esp
		
		// remove os backups
		addl	$12, %esp

		// retorna para a execução
		jmp		_check_for_repeat_end

_repeated_value_error:
	// levanta a flag, printa a mensagem de erro na tela e retorna
	pushl	$repeat_value_msg
	call	printf
	addl	$4, %esp
	movl	$1,	flag
ret

_alloc_set:

	// aloca um conjunto de tamanho que está em %eax, e guarda o valor em %eax msm
	pushl	%eax
	call	malloc
	addl	$4, %esp

ret

_free_set_A:
	// desaloca o set_A
	pushl	set_A
	call	free
	addl	$4, %esp
ret

_free_set_B:
	// desaloca o set_B
	pushl	set_B
	call	free
	addl	$4, %esp
ret
