.data
arrayNumeros:   .space 400              # até 100 numeros (100 * 4 = 400)
buffer:         .space 1024             # para ler o arquivo
localArquivo:   .asciiz "C:/Caminho_do_arquivo/lista.txt"
nova_linha:     .asciiz "\n"
msgErro:        .asciiz "Erro ao abrir ou ler o arquivo.\n"

.text
main:

    # abrir o arquivo no modo leitura
    li $v0, 13              # syscall open
    la $a0, localArquivo    # nome do arquivo
    li $a1, 0               # 0 = leitura
    syscall
    move $t0, $v0           # $t0 = descritor
    bltz $t0, erro          # se der erro, sai

    # ler o conteudo do arquivo
    move $a0, $t0           # descritor
    la  $a1, buffer         # destino
    li  $a2, 1024           # tamanho maximo
    li  $v0, 14             # syscall read
    syscall
    move $t1, $v0           # $t1 = bytes lidos
    blez $t1, erro          # se nao leu nada -> erro

    # fechar o arquivo
    li $v0, 16
    move $a0, $t0
    syscall

    # converter texto -> numeros
    la $t2, buffer          # ponteiro para chars
    la $t3, arrayNumeros    # ponteiro para vetor
    li $t4, 0               # acumulador do numero
    li $t5, 0               # sinal (0=+, 1=-)
    li $t6, 0               # flag: tem digito?
    li $t7, 0               # qtd de numeros lidos

ler_char:
    lb $t8, 0($t2)          # le 1 caractere
    beqz $t8, fim_texto     # fim do texto (byte 0)

    # se for virgula -> armazenar numero
    li $t9, 44              # ','
    beq $t8, $t9, armazena

    # se for '-'
    li $t9, 45
    beq $t8, $t9, marca_neg

    # se for digito '0'..'9'
    li $t9, 48              # '0'
    li $t0, 57              # '9'
    blt $t8, $t9, prox_char
    bgt $t8, $t0, prox_char

    # converte p/ digito
    sub $t8, $t8, $t9       # digito = char - '0'
    mul $t4, $t4, 10
    add $t4, $t4, $t8
    li $t6, 1               # temos digito
    j prox_char

marca_neg:
    li $t5, 1               # marca como negativo
    j prox_char

armazena:
    # so armazena se tinha digito
    beqz $t6, prox_char

    # aplica sinal se tiver
    beqz $t5, armazena_dir
    sub $t4, $zero, $t4     # negativo

armazena_dir:
    sw $t4, 0($t3)          # guarda no vetor
    addi $t3, $t3, 4
    addi $t7, $t7, 1        # conta mais um numero

    # zera tudo pra proximo
    li $t4, 0
    li $t5, 0
    li $t6, 0
    j prox_char

prox_char:
    addi $t2, $t2, 1
    j ler_char

fim_texto:
    # pode ter um numero no final sem virgula
    beqz $t6, ordenar       # se nao tinha digito, vai ordenar
    beqz $t5, ultimo_ok
    sub $t4, $zero, $t4
ultimo_ok:
    sw $t4, 0($t3)
    addi $t7, $t7, 1

ordenar:
    li $t0, 0               # i = 0

for_i:
    beq $t0, $t7, imprimir  # i == n -> acabou
    li $t1, 0               # j = 0

for_j:
    add $t2, $t1, $zero
    addi $t2, $t2, 1
    bge  $t2, $t7, inc_i    # se j+1 >= n, sai do j

    # endereço de array[j]
    sll $t3, $t1, 2         # j * 4
    la  $t4, arrayNumeros
    add $t4, $t4, $t3
    lw  $t5, 0($t4)         # a[j]
    lw  $t6, 4($t4)         # a[j+1]

    ble $t5, $t6, sem_troca

    # troca a[j] e a[j+1]
    sw $t6, 0($t4)
    sw $t5, 4($t4)

sem_troca:
    addi $t1, $t1, 1
    j for_j

inc_i:
    addi $t0, $t0, 1
    j for_i

# imprimir vetor ordenado
imprimir:
    li $t0, 0
    la $t1, arrayNumeros

print_loop:
    beq $t0, $t7, fim
    lw $a0, 0($t1)
    li $v0, 1
    syscall
    li $v0, 4
    la $a0, nova_linha
    syscall
    addi $t1, $t1, 4
    addi $t0, $t0, 1
    j print_loop

erro:
    li $v0, 4
    la $a0, msgErro
    syscall
    j fim

fim:
    li $v0, 10
    syscall
