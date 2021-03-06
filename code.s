/*	To do:
	(X) 1 - Leitura dos Conjuntos
	(X) 2 - Encontrar União
	(X) 3 - Encontrar Intersecção
	(X) 4 - Encontrar a Diferença
	(X) 5 - Encontrar o Complementar
*/

.section .data

	opening_msg:			.asciz	"\nManipulador de Conjuntos Numericos\n"
	main_menu:				.asciz	"\nMenu de Opcoes:\n\n\t1 - Leitura dos Conjuntos\n\t2 - Encontrar Uniao\n\t3 - Encontrar Intersecao\n\t4 - Encontrar a Diferenca\n\t5 - Encontrar o Complementar\n\t6 - Sair\n\n"
	ask_option:				.asciz	"Digite a opcao escolhida: "
	invalid_option_msg:		.asciz	"Opcao Invalida, tente novamente.\n"
	invalid_value_msg:		.asciz	"Valor Invalido, tente novamente.\n"
	repeat_value_msg:		.asciz	"Elemento ja presente no conjunto, tente novamente.\n"
	empty_set_error_msg:	.asciz	"\nUm ou mais conjuntos estao vazios. Preencha-os antes de executar essa opcao\n"
	enter_to_return_msg:	.asciz	"\nPressione 1 para retornar ao menu principal\n"

	read_values_msg:		.asciz	"\nLeitura dos Conjuntos\n\n"
	read_values_menu:		.asciz	"\n\t1. Inserir Conjunto A\n\t2. Inserir Conjunto B\n\t3. Sair\n\n"

	union_msg:				.asciz	"\nEncontrar a Uniao dos Conjuntos\n\n"
	intersect_msg:			.asciz	"\nEncontrar a Intersecao dos Conjuntos\n\n"
	comp_msg:				.asciz	"\nEncontrar o Complementar dos Conjuntos\n\n"

	diff_msg:				.asciz	"\nEncontrar a Diferenca dos Conjuntos\n\n"
	diff_A_B_msg:			.asciz	"Diferenca A - B: "
	diff_B_A_msg:			.asciz	"Diferenca B - A: "

	A_is_in_B_msg:			.asciz	"A eh subconjunto de B\n"
	B_is_in_A_msg:			.asciz	"B eh subconjunto de A\n"

	ask_number_of_values:	.asciz	"Digite o numero de elementos do conjunto: "
	ask_values:				.asciz	"Digite o elemento %d do conjunto: "

	print_values_A:			.asciz	"Valores do Conjunto A: "
	print_values_B:			.asciz	"Valores do Conjunto B: "
	print_values_C:			.asciz	"Resultado: "

	print_value:			.asciz	"%d "
	skip_line:				.asciz	"\n"

	set_A:		.space	4
	set_B:		.space	4
	set_C:		.space	4
	set_ptr:	.space	4

	number_of_elements_A:		.int	0
	number_of_elements_B:		.int	0
	number_of_elements_C:		.int	0
	number_of_elements_aux:		.int	0

	element:		.int	0
	flag:			.int	0
	aux:			.int	0
	
	option:			.int	0
	int_type:		.asciz	"%d"
	str_type:		.asciz	"%s"

.section .text
.globl	_start

_start:

	// Printa a mensagem de abertura e o menu
	pushl	$opening_msg	
	call	printf
	addl	$4, %esp

_main_menu:
	pushl	$main_menu
	call	printf
	addl	$4, %esp

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
		
		movl	number_of_elements_A,	%eax
		movl	set_A,	%ebx

		call	_fill_set

		movl	%eax,	number_of_elements_A
		movl	%ebx,	set_A

		jmp		_read_sets

	_read_set_B:
		// Leitura do conjunto B

		movl	number_of_elements_B,	%eax
		movl	set_B,	%ebx

		call	_fill_set

		movl	%eax,	number_of_elements_B
		movl	%ebx,	set_B

		jmp		_read_sets


_find_union:
	// Encontrar Uniao
	call	_is_empty_error
	call	_make_set_C_free

	pushl	$union_msg
	call	printf
	addl	$4, %esp
	call	_print_values_A
	call	_print_values_B

	movl	number_of_elements_A,	%eax
	addl	number_of_elements_B,	%eax
	movl	$4,	%ebx
	mull	%ebx
	call	_alloc_set
	movl	%eax,	set_C

	movl	number_of_elements_A,	%ecx
	movl	set_A,	%edi   
	call	_fill_union

	movl	number_of_elements_B,	%ecx
	movl	set_B,	%edi   
	call	_fill_union

	call	_print_values_C
	jmp		_main_menu


_find_intersection:
	// Encontrar Intersecao
	call	_is_empty_error
	call	_make_set_C_free

	pushl	$intersect_msg
	call	printf
	addl	$4, %esp
	call	_print_values_A
	call	_print_values_B

	movl	number_of_elements_A,	%eax
	addl	number_of_elements_B,	%eax
	movl	$4,	%ebx
	mull	%ebx
	call	_alloc_set
	movl	%eax,	set_C

	movl	number_of_elements_A,	%ecx
	movl	set_A,	%edi   
	call	_fill_intersect

	call	_print_values_C
	jmp		_main_menu


_find_difference:
	// Encontrar a Diferenca
	call	_is_empty_error

	pushl	$diff_msg
	call	printf
	addl	$4, %esp
	call	_print_values_A
	call	_print_values_B

	//	A - B
	call	_make_set_C_free

	movl	number_of_elements_A,	%eax
	addl	number_of_elements_B,	%eax
	movl	$4,	%ebx
	mull	%ebx
	call	_alloc_set
	movl	%eax,	set_C

	movl	number_of_elements_B,	%ecx
	movl	%ecx,	number_of_elements_aux
	movl	set_B,	%edi 
	movl	%edi,	set_ptr

	movl	number_of_elements_A,	%ecx
	movl	set_A,	%edi 
	call	_fill_diff
	
	call	_print_diff_A_B

	//	B - A
	call	_make_set_C_free

	movl	number_of_elements_A,	%eax
	addl	number_of_elements_B,	%eax
	movl	$4,	%ebx
	mull	%ebx
	call	_alloc_set
	movl	%eax,	set_C

	movl	number_of_elements_A,	%ecx
	movl	%ecx,	number_of_elements_aux
	movl	set_A,	%edi 
	movl	%edi,	set_ptr

	movl	number_of_elements_B,	%ecx
	movl	set_B,	%edi 
	call	_fill_diff
	
	call	_print_diff_B_A

	jmp		_main_menu


_find_complement:
	// Encontrar o Complementar
	call	_is_empty_error
	call	_make_set_C_free

	pushl	$comp_msg
	call	printf
	addl	$4, %esp
	call	_print_values_A
	call	_print_values_B

	//	verifica se um conjunto é subconjunto do outro
	//	retorno é pelo %eax
	call	_fill_comp

	//	se A for subconjunto de B retorna 1
	cmpl	$1,	%eax
	je		_find_comp_A_B

	//	se B for subconjunto de A retorna 2
	cmpl	$2,	%eax
	je		_find_comp_B_A

		_find_comp_ret:
	//	se nenhum for subconjunto retorna 0, ou seja, continua normalmente

	call	_print_values_C
	jmp		_main_menu

	_find_comp_A_B:

		pushl	$A_is_in_B_msg
		call	printf
		addl	$4,	%esp

		jmp		_find_comp_ret

	_find_comp_B_A:

		pushl	$B_is_in_A_msg
		call	printf
		addl	$4,	%esp

		jmp		_find_comp_ret



_end:

	//	se foi alocado valores nos conjuntos, desalocar
	movl	$0,	%eax

	call	_make_set_A_free
	call	_make_set_B_free
	call	_make_set_C_free

	pushl	$0
	call	exit

###############################################################################################

_print_values_A:
	// Mostra os valores do conjunto A

	pushl	$print_values_A
	call	printf
	addl	$4, %esp

	movl	number_of_elements_A, %ecx
	movl	set_A, %edi

	call	_print_set_values

ret

_print_values_B:
	// Mostra os valores do conjunto B
	pushl	$print_values_B
	call	printf
	addl	$4, %esp

	movl	number_of_elements_B, %ecx
	movl	set_B, %edi

	call	_print_set_values

ret

_print_values_C:
	// Mostra os valores do conjunto C
	pushl	$print_values_C
	call	printf
	addl	$4, %esp

	movl	number_of_elements_C, %ecx
	movl	set_C, %edi

	call	_print_set_values

ret

_print_diff_A_B:
	// Mostra os valores das diferencas

	pushl	$diff_A_B_msg
	call	printf
	addl	$4, %esp

	movl	number_of_elements_C, %ecx
	movl	set_C, %edi

	call	_print_set_values

ret

_print_diff_B_A:
	// Mostra os valores das diferencas

	pushl	$diff_B_A_msg
	call	printf
	addl	$4, %esp

	movl	number_of_elements_C, %ecx
	movl	set_C, %edi

	call	_print_set_values

ret


_print_set_values:
	// Mostra os valores do conjunto
	
	// movl	number_of_elements_B, %ecx
	// movl	set_B, %edi			(feito antes de chamar a funcao)

	// Se esiver vazio, pula para o fim da funcao
	cmpl	$0,	%ecx
	je		_print_values_end

	movl	$1, %ebx
	_print_values_loop:
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

	loop	_print_values_loop

	_print_values_end:
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
		je		_repeat_value_error

		// se nao houve repetição segue o loop
		movl	element, %eax
		movl	%eax, (%edi)
		addl	$4, %edi
		incl	%ebx
		incl	aux

	loop	_get_values_loop
			
ret


_repeat_value_error:

	pushl	%ebx
	pushl	%ecx
	pushl	%edi

	pushl	$repeat_value_msg
	call	printf
	addl	$4, %esp
	
	popl	%edi
	popl	%ecx
	popl	%ebx

	jmp		_get_values_loop

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

		// remove os backups
		addl	$12, %esp

		// retorna para a execução
		jmp		_check_for_repeat_end


_alloc_set:

	// aloca um conjunto de tamanho que está em %eax, e guarda o valor em %eax msm
	pushl	%eax
	call	malloc
	addl	$4, %esp

ret

_fill_set:

	movl	%eax,	number_of_elements_aux
	movl	%ebx,	set_ptr

	// se ja estiver alocado, desaloca e continua
	movl	$0,	%eax
	cmpl	number_of_elements_aux,	%eax
	jne		_free_set_before_read
		_free_set_before_read_ret:

	// Pede o numero de elementos do conjunto
	pushl	$ask_number_of_values
	call	printf
	addl	$4, %esp

	pushl	$number_of_elements_aux
	pushl	$int_type
	call	scanf
	addl	$8, %esp

	// Ve se o numero de elementos eh um valor invalido
	movl	number_of_elements_aux, %eax
	cmpl	$0,	%eax
	jle		_invalid_value

	// Aloca o espaco para o conjunto
	movl	$4, %eax
	mull	number_of_elements_aux
	call	_alloc_set
	movl	%eax, set_ptr

	// Chama funcao que le os valores para o conjunto
	movl	number_of_elements_aux, %ecx
	movl	set_ptr, %edi
	call 	_get_values_for_set

	movl	number_of_elements_aux,	%eax	
	movl	set_ptr,	%ebx

ret

	_invalid_value:
		// Se o valor for invalido, exibe a mensagem e tenta novamente
		pushl	$invalid_value_msg
		call	printf
		addl	$4, %esp
		
		jmp		_fill_set

	_free_set_before_read:
		// desaloca conjunto e retorna
		pushl	set_ptr
		call	free
		addl	$4, %esp

		jmp		_free_set_before_read_ret

_is_empty_error:
	movl	number_of_elements_A, %eax
	movl	number_of_elements_B, %ebx
	cmpl	$0, %eax
	je		_empty_set_error
	cmpl	$0, %ebx
	je		_empty_set_error

ret

	_empty_set_error:

		// Exibe a mensagem de erro para o caso do conjunto estar vazio
		pushl	$empty_set_error_msg	
		call	printf
		
		// Remove o endereço de retorno do call e retorna ao menu principal
		addl	$4, %esp
		jmp		_main_menu
	
_make_set_A_free:
	movl	number_of_elements_A,	%eax
	cmpl	$0,	%eax
	jne		_free_set_A
		_free_set_A_ret:
ret		
	_free_set_A:
		pushl	set_A
		call	free
		addl	$4, %esp
		movl	$0,	number_of_elements_A

		jmp 	_free_set_A_ret



_make_set_B_free:
	movl	number_of_elements_B,	%eax
	cmpl	$0,	%eax
	jne		_free_set_B
		_free_set_B_ret:
ret		
	_free_set_B:
		pushl	set_B
		call	free
		addl	$4, %esp
		movl	$0,	number_of_elements_B
		
		jmp 	_free_set_B_ret
		


_make_set_C_free:

	movl	number_of_elements_C,	%eax
	cmpl	$0,	%eax
	jne		_free_set_C
		_free_set_C_ret:
ret		

	_free_set_C:
		pushl	set_C
		call	free
		addl	$4, %esp
		movl	$0,	number_of_elements_C

		jmp		_free_set_C_ret


_fill_union:
	
	// movl	number_of_elements_A,	%ecx
	// movl	set_A,	%edi   		(fazer isso antes de chamar a funcao)

	movl	$1,	%ebx

	_find_union_loop:
		// no inicio do loop, reseta a flag de repeticao
		movl	$0,	flag

		// pushl pra backup
		pushl	%ebx
		pushl	%ecx
		pushl	%edi

		//	pega o elemento do conjunto e ve se ele esta em C
		movl	(%edi), %eax
		movl	%eax, element
		movl	number_of_elements_C, %ecx
		movl	set_C, %edi
		call	_check_for_repeat


		//	se estiver em C, segue o loop, se nao estiver, adiciona
		movl	flag,	%eax
		cmpl	$0,	%eax
		je		_add_to_union
			_add_to_union_ret:

		// restaurando backup
		popl	%edi
		popl	%ecx
		popl	%ebx

		addl	$4, %edi
		incl	%ebx

	loop	_find_union_loop
ret

	_add_to_union:
		//	se estiver em C, segue o loop, se nao estiver, adiciona
		call	_add_to_C
		jmp	_add_to_union_ret


_fill_intersect:
	
	// movl	number_of_elements_A,	%ecx
	// movl	set_A,	%edi   		(fazer isso antes de chamar a funcao)

	movl	$1,	%ebx

	_fill_intersect_loop:
		// no inicio do loop, reseta a flag de repeticao
		movl	$0,	flag

		// pushl pra backup
		pushl	%ebx
		pushl	%ecx
		pushl	%edi

		//	pega o elemento do conjunto e ve se ele esta em B
		movl	(%edi), %eax
		movl	%eax, element
		movl	number_of_elements_B, %ecx
		movl	set_B, %edi
		call	_check_for_repeat


		//	se estiver em B, adiciona, se nao estiver, segue o loop
		movl	flag,	%eax
		cmpl	$1,	%eax
		je		_add_to_intersect
			_add_to_intersect_ret:

		// restaurando backup
		popl	%edi
		popl	%ecx
		popl	%ebx

		addl	$4, %edi
		incl	%ebx

	loop	_fill_intersect_loop
ret

	_add_to_intersect:
		call	_add_to_C
		jmp	_add_to_intersect_ret

_fill_diff:

	// movl	number_of_elements_A,	%ecx
	// movl	set_A,	%edi   		(fazer isso antes de chamar a funcao)

	movl	$1,	%ebx

	_fill_diff_loop:
		// no inicio do loop, reseta a flag de repeticao
		movl	$0,	flag

		// pushl pra backup
		pushl	%ebx
		pushl	%ecx
		pushl	%edi

		//	pega o elemento do conjunto e ve se ele esta em set_ptr
		movl	(%edi), %eax
		movl	%eax, element
		movl	number_of_elements_aux, %ecx
		movl	set_ptr, %edi
		call	_check_for_repeat


		//	se estiver em set_ptr, segue o loop, se nao estiver, adiciona
		movl	flag,	%eax
		cmpl	$0,	%eax
		je		_add_to_diff
			_add_to_diff_ret:

		// restaurando backup
		popl	%edi
		popl	%ecx
		popl	%ebx

		addl	$4, %edi
		incl	%ebx

	loop	_fill_diff_loop
ret

	_add_to_diff:
		call	_add_to_C
		jmp	_add_to_diff_ret

_fill_comp:
	//	verifica se um coonjunto é sub conjunto do outro
	//	se A for subconjunto de B retorna 1
	//	se B for subconjunto de A retorna 2
	//	se nenhum for subconjunto retorna 0
	//	retorno é pelo %eax

	movl	number_of_elements_A,	%eax
	cmpl	number_of_elements_B,	%eax
	jl		_is_A_subset_B
	cmpl	number_of_elements_B,	%eax
	jg		_is_B_subset_A

	movl	$0,	%eax
	_fill_comp_end:
ret

	_is_A_subset_B:
		call	_make_set_C_free

		movl	number_of_elements_A,	%eax
		addl	number_of_elements_B,	%eax
		movl	$4,	%ebx
		mull	%ebx
		call	_alloc_set
		movl	%eax,	set_C

		movl	number_of_elements_B,	%ecx
		movl	%ecx,	number_of_elements_aux
		movl	set_B,	%edi 
		movl	%edi,	set_ptr

		movl	number_of_elements_A,	%ecx
		movl	set_A,	%edi 
		call	_fill_diff

		movl	number_of_elements_C,	%eax
		cmpl	$0,	%eax
		je		_A_is_in_B

		movl	$0,	%eax
		call	_make_set_C_free
		ret

	_is_B_subset_A:
		call	_make_set_C_free
	
		movl	number_of_elements_A,	%eax
		addl	number_of_elements_B,	%eax
		movl	$4,	%ebx
		mull	%ebx
		call	_alloc_set
		movl	%eax,	set_C

		movl	number_of_elements_A,	%ecx
		movl	%ecx,	number_of_elements_aux
		movl	set_A,	%edi 
		movl	%edi,	set_ptr

		movl	number_of_elements_B,	%ecx
		movl	set_B,	%edi 
		call	_fill_diff

		movl	number_of_elements_C,	%eax
		cmpl	$0,	%eax
		je		_B_is_in_A
		
		movl	$0,	%eax
		call	_make_set_C_free
		ret

	_A_is_in_B:
		call	_make_set_C_free

		movl	number_of_elements_A,	%eax
		addl	number_of_elements_B,	%eax
		movl	$4,	%ebx
		mull	%ebx
		call	_alloc_set
		movl	%eax,	set_C

		movl	number_of_elements_A,	%ecx
		movl	%ecx,	number_of_elements_aux
		movl	set_A,	%edi 
		movl	%edi,	set_ptr

		movl	number_of_elements_B,	%ecx
		movl	set_B,	%edi 
		call	_fill_diff


		movl	$1,	%eax
		ret

	_B_is_in_A:
		call	_make_set_C_free

		movl	number_of_elements_A,	%eax
		addl	number_of_elements_B,	%eax
		movl	$4,	%ebx
		mull	%ebx
		call	_alloc_set
		movl	%eax,	set_C

		movl	number_of_elements_B,	%ecx
		movl	%ecx,	number_of_elements_aux
		movl	set_B,	%edi 
		movl	%edi,	set_ptr

		movl	number_of_elements_A,	%ecx
		movl	set_A,	%edi 
		call	_fill_diff

		movl	$2,	%eax
		ret

_add_to_C:
		movl	number_of_elements_C,	%eax
		movl	$4,	%ebx
		mull	%ebx

		movl	set_C,	%edi
		addl	%eax,	%edi

		movl	element, %eax
		movl	%eax, (%edi)
		incl	number_of_elements_C
ret




