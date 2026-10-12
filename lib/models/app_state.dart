import 'package:flutter/foundation.dart';

import '../data/trilha_mock.dart';

/// Uma questão de múltipla escolha (dados mockados locais).
class Questao {
  const Questao({
    required this.enunciado,
    required this.opcoes,
    required this.correta,
    this.codigo,
  });

  final String enunciado;
  final String? codigo;
  final List<String> opcoes;
  final int correta; // índice da opção correta
}

/// Um item da trilha de aprendizado (Variáveis, Tipos de dados, ...).
class TrilhaItem {
  TrilhaItem({
    required this.nome,
    required this.descricao,
    required this.questoes,
    this.concluido = false,
  });

  final String nome;
  final String descricao;
  final List<Questao> questoes;
  bool concluido;
}

/// ARGUMENTO enviado para a rota '/desafio' (Navigator.pushNamed(arguments:)).
class DesafioArgs {
  const DesafioArgs(this.tema);
  final String tema;
}

/// RESULTADO devolvido pela rota '/desafio' (Navigator.pop(context, valor)).
class DesafioResultado {
  const DesafioResultado({
    required this.tema,
    required this.acertos,
    required this.total,
  });

  final String tema;
  final int acertos;
  final int total;

  int get xp => acertos;
  bool get aprovado => acertos * 2 > total;

  @override
  String toString() => 'DesafioResultado($tema, $acertos/$total, +$xp XP)';
}

class AppState extends ChangeNotifier {
  AppState._();
  static final AppState instance = AppState._();

  String userName = 'Juliana';
  int xp = 12;
  int streak = 3;
  int metaDiaria = 5;

  final List<TrilhaItem> trilha = criarTrilhaMock();
  final List<String> historico = [
    '+3 XP: Variáveis',
    '+2 XP: Tipos de dados',
    '+7 XP: Desafios diários',
  ];

  int get nivel => xp ~/ 20 + 1;
  int get concluidos => trilha.where((t) => t.concluido).length;
  double get progresso => concluidos / trilha.length;

  TrilhaItem? get proximo {
    for (final t in trilha) {
      if (!t.concluido) return t;
    }
    return null;
  }

  bool desbloqueado(int i) => trilha[i].concluido || trilha[i] == proximo;

  TrilhaItem trilhaPorNome(String nome) =>
      trilha.firstWhere((t) => t.nome == nome);

  void registrar(DesafioResultado r) {
    xp += r.xp;
    if (r.aprovado) {
      trilhaPorNome(r.tema).concluido = true;
    }
    historico.insert(0, '+${r.xp} XP: ${r.tema}');
    notifyListeners();
  }

  void definirNome(String nome) {
    userName = nome.trim().isEmpty ? 'Aluno' : nome.trim();
    notifyListeners();
  }

  void definirMeta(int meta) {
    metaDiaria = meta;
    notifyListeners();
  }
}