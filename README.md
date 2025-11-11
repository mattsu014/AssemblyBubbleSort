# 🧠 Projeto Assembly — Leitura, Conversão e Ordenação (Bubble Sort)

📜 **Descrição:**
Programa em **Assembly MIPS** que:

1. 📂 Lê um arquivo de texto (`lista.txt`) contendo números separados por vírgula;
2. 🔢 Converte os valores de texto para inteiros (inclusive negativos);
3. 🧮 Ordena os números com o algoritmo **Bubble Sort**;
4. 🖨️ Exibe os números ordenados no console.

---

## 🗂️ Estrutura do Projeto

| Arquivo     | Função                                               |
| ----------- | ---------------------------------------------------- |
| `main.s`    | Código fonte Assembly MIPS                           |
| `lista.txt` | Arquivo de entrada com números separados por vírgula |

📍 **Exemplo de conteúdo do arquivo:**

```
10,3,-7,42,0,5
```

---

## ⚙️ Requisitos

✅ Simulador MIPS compatível com syscalls:

> 🧩 **MARS** ou **SPIM/PCSpim**

⚠️ **Importante:**
O caminho do arquivo está definido **de forma absoluta** na seção `.data`:

```asm
localArquivo: .asciiz "C:/Caminho_do_Arquivo/lista.txt"
```

➡️ Altere esse caminho conforme o local onde o arquivo está salvo no seu computador.

---

## 🧩 Etapas do Funcionamento

### 🏁 1. Abertura e Leitura do Arquivo

O programa usa as *syscalls*:

* `13` → abre o arquivo (`read-only`);
* `14` → lê até **1024 bytes** do conteúdo;
* `16` → fecha o arquivo.

📍 Caso ocorra erro na leitura, o programa exibe:

```
Erro ao abrir ou ler o arquivo.
```

---

### 🔡 2. Conversão de Texto → Inteiros

O programa percorre cada caractere do `buffer` e faz o parsing manual dos números.

🔍 **Registradores principais:**

| Registrador | Função                               |
| ----------- | ------------------------------------ |
| `$t2`       | Ponteiro para o buffer de texto      |
| `$t3`       | Ponteiro para o vetor `arrayNumeros` |
| `$t4`       | Acumulador do número atual           |
| `$t5`       | Sinal (`0`=positivo, `1`=negativo)   |
| `$t6`       | Flag indicando se há dígitos válidos |
| `$t7`       | Quantidade total de números lidos    |

📌 **Lógica:**

* Ignora caracteres não numéricos (exceto `,` e `-`);
* Se encontra uma vírgula `,`, armazena o número atual;
* Se encontra `-`, marca o número como negativo;
* Se encontra `'0'..'9'`, multiplica o acumulador por 10 e soma o dígito;
* No final, trata o último número (caso o arquivo não termine com vírgula).

🧠 **Suporta:**
✅ Números negativos
✅ Último número sem vírgula
🚫 Espaços e quebras de linha são ignorados

---

### 🔁 3. Ordenação — Algoritmo Bubble Sort

💡 **Ideia:**
Compara pares adjacentes (`a[j]`, `a[j+1]`) e troca se estiverem fora de ordem.
Repete o processo `n` vezes até que o vetor esteja ordenado.

📊 **Complexidade:**

* Tempo: `O(n²)`
* Espaço: `O(1)` (in-place)

🧮 **Laços principais:**

```asm
for_i:   # i = 0 → n-1
for_j:   # j = 0 → n-2
```

👉 Se `a[j] > a[j+1]`, os valores são trocados usando `sw` e `lw`.

---

### 🖨️ 4. Impressão do Vetor Ordenado

Após a ordenação:

* Cada número é impresso com syscall `1` (print integer);
* Uma quebra de linha é exibida após cada número (`\n`).

🧾 **Exemplo de saída:**

```
-7
0
3
5
10
42
```

---

## 🧰 Registradores — Resumo Geral

| Registrador | Uso Principal                                            |
| ----------- | -------------------------------------------------------- |
| `$t0`       | Índice externo do laço (i) / descritor do arquivo        |
| `$t1`       | Índice interno (j) / bytes lidos / ponteiro de impressão |
| `$t2`       | Ponteiro para buffer                                     |
| `$t3`       | Ponteiro para vetor                                      |
| `$t4`       | Acumulador do número atual                               |
| `$t5`       | Sinal ou valor `a[j]`                                    |
| `$t6`       | Flag de dígito ou valor `a[j+1]`                         |
| `$t7`       | Quantidade de números lidos                              |

---

## ⚠️ Tratamento de Erros

Se o arquivo não existir ou não puder ser lido:

```asm
msgErro: .asciiz "Erro ao abrir ou ler o arquivo.\n"
```

O programa salta para o rótulo `erro` e encerra com syscall `10`.

## 🧪 Exemplo de Execução no MARS

1. 🧭 Ajuste o caminho de `localArquivo` no código.
2. ▶️ Execute o programa no MARS.
3. ✅ Veja a lista ordenada sendo exibida no console.

**Entrada (`lista.txt`):**

```
12,-5,0,99,3
```

**Saída esperada:**

```
-5
0
3
12
99
```

---

## 🧠 Conclusão

Este projeto demonstra:

* Manipulação de **arquivos** via syscalls;
* Conversão de **strings ASCII para inteiros**;
* Implementação clássica do **Bubble Sort** em Assembly;
* Impressão formatada dos resultados.

É um ótimo exercício de **lógica, manipulação de memória e controle de fluxo** em Assembly MIPS 🧩

---

👨‍💻 **Autor:** Mateus Valentim*

🏫 **Arquitetura de Computadores**

🗓️ **Ano:** 2025

📁 **Documentação do Trabalho**: [Trabalho Assembly - Codigo.pdf](https://ead.unifor.br/ava/pluginfile.php/5129033/assignsubmission_file/submission_files/2542235/Trabalho%20Assembly%20-%20Codigo.pdf?forcedownload=1)

---

