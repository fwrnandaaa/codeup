import 'package:flutter/material.dart';

import '../app_routes.dart';
import '../models/app_state.dart';

/// Abre a tela de desafio na pilha do Navigator MAIS PRÓXIMO (ou seja, da aba
/// atual) enviando [DesafioArgs] como argumento e aguardando o
/// [DesafioResultado] devolvido via Navigator.pop(context, resultado).
Future<void> abrirDesafio(BuildContext context, String tema) async {
  // Sem <T> no pushNamed: as rotas das abas são MaterialPageRoute<dynamic>,
  // e o Dart não converte Route<dynamic> em Route<DesafioResultado>.
  // O tipo do retorno é conferido logo abaixo com "is".
  final retorno = await Navigator.of(context).pushNamed(
    AppRoutes.desafio,
    arguments: DesafioArgs(tema),
  );

  if (retorno is! DesafioResultado) {
    debugPrint('[NAV] Desafio "$tema" fechado sem resultado (pop sem valor)');
    return;
  }

  final resultado = retorno;
  debugPrint('[NAV] Resultado recebido do pop: $resultado');
  AppState.instance.registrar(resultado);

  if (!context.mounted) return;
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(resultado.aprovado
            ? '"$tema" concluído! +${resultado.xp} XP'
            : '+${resultado.xp} XP. Acerte mais da metade para concluir "$tema".'),
        backgroundColor: resultado.aprovado ? Colors.green : Colors.orange,
      ),
    );
}