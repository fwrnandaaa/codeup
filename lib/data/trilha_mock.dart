import '../models/app_state.dart';

/// Dados mockados locais da trilha de Python.
List<TrilhaItem> criarTrilhaMock() => [
  TrilhaItem(
    nome: 'Variáveis',
    descricao:
    'Variáveis guardam valores na memória. Em Python basta escrever '
        'nome = valor, sem declarar o tipo.',
    concluido: true,
    questoes: const [
      Questao(
        enunciado: 'Qual será o resultado do código abaixo?',
        codigo: 'x = 10\ny = 5\nprint(y + x)',
        opcoes: ['5', '10', '15'],
        correta: 2,
      ),
      Questao(
        enunciado: 'Qual linha cria uma variável em Python?',
        opcoes: ['nome = "Ana"', 'var nome = "Ana"', 'string nome = "Ana"'],
        correta: 0,
      ),
      Questao(
        enunciado: 'Qual será o resultado do código abaixo?',
        codigo: 'a = 3\na = a + 2\nprint(a)',
        opcoes: ['3', '5', '32'],
        correta: 1,
      ),
    ],
  ),
  TrilhaItem(
    nome: 'Tipos de dados',
    descricao:
    'Os tipos básicos são int (inteiros), float (decimais), str '
        '(texto) e bool (True/False).',
    concluido: true,
    questoes: const [
      Questao(
        enunciado: 'Qual é o tipo do valor abaixo?',
        codigo: 'type(3.14)',
        opcoes: ['int', 'float', 'str'],
        correta: 1,
      ),
      Questao(
        enunciado: 'Qual será o resultado do código abaixo?',
        codigo: 'print("5" + "3")',
        opcoes: ['53', '8', 'Erro'],
        correta: 0,
      ),
      Questao(
        enunciado: 'Qual dos valores abaixo é do tipo bool?',
        opcoes: ['True', '"True"', '1'],
        correta: 0,
      ),
    ],
  ),
  TrilhaItem(
    nome: 'Operadores',
    descricao:
    'Operadores aritméticos: + - * / // (divisão inteira) % (resto) '
        'e ** (potência).',
    concluido: true,
    questoes: const [
      Questao(
        enunciado: 'Qual será o resultado do código abaixo?',
        codigo: 'print(7 // 2)',
        opcoes: ['3.5', '3', '4'],
        correta: 1,
      ),
      Questao(
        enunciado: 'Qual será o resultado do código abaixo?',
        codigo: 'print(2 ** 3)',
        opcoes: ['6', '8', '5'],
        correta: 1,
      ),
      Questao(
        enunciado: 'Qual será o resultado do código abaixo?',
        codigo: 'print(10 % 3)',
        opcoes: ['1', '3', '0'],
        correta: 0,
      ),
    ],
  ),
  TrilhaItem(
    nome: 'Condicionais',
    descricao: 'Aprenda a usar condicionais como if, elif e else para '
        'tomar decisões no código.',
    questoes: const [
      Questao(
        enunciado: 'O que o código abaixo imprime?',
        codigo: 'x = 7\nif x > 10:\n    print("A")\nelse:\n    print("B")',
        opcoes: ['A', 'B', 'Nada'],
        correta: 1,
      ),
      Questao(
        enunciado: 'Qual palavra-chave testa uma segunda condição?',
        opcoes: ['elif', 'else if', 'elseif'],
        correta: 0,
      ),
      Questao(
        enunciado: 'O que o código abaixo imprime?',
        codigo:
        'x = 4\nif x % 2 == 0:\n    print("par")\nelse:\n    print("impar")',
        opcoes: ['par', 'impar', 'Erro'],
        correta: 0,
      ),
    ],
  ),
  TrilhaItem(
    nome: 'Funções',
    descricao: 'Funções agrupam um bloco de código reutilizável. São '
        'criadas com def e podem devolver valores com return.',
    questoes: const [
      Questao(
        enunciado: 'Qual palavra-chave define uma função?',
        opcoes: ['def', 'function', 'fun'],
        correta: 0,
      ),
      Questao(
        enunciado: 'Qual será o resultado do código abaixo?',
        codigo: 'def dobro(n):\n    return n * 2\n\nprint(dobro(4))',
        opcoes: ['4', '8', '2'],
        correta: 1,
      ),
      Questao(
        enunciado: 'O que o return faz?',
        opcoes: [
          'Devolve um valor para quem chamou',
          'Imprime na tela',
          'Apaga a função',
        ],
        correta: 0,
      ),
    ],
  ),
];