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
	
	option:		.int	0

	int_type:	.asciz	"%d"

.section .text
.globl	_start

_start:

	// Printa a mensagem de abertura e o menu
	pushl	$opening_msg	
	call	printf

	pushl	$main_menu
	call	printf

	addl	$8, %esp

_getOption:

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
	je	_option1

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

	jmp _getOption

_option1:

_option2:

_option3:

_option4:

_option5:

_end:

	pushl	$0
	call	exit
