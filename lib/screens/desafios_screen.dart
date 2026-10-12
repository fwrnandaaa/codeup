import 'package:flutter/material.dart';

import '../models/app_state.dart';
import '../navigation/navigation_helpers.dart';
import '../navigation/shell_scope.dart';

/// Aba "Desafios": lista de desafios -> Quiz (2 níveis de pilha).
class DesafiosScreen extends StatelessWidget {
  const DesafiosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    return ListenableBuilder(
      listenable: state,
      builder: (context, _) => Scaffold(
        backgroundColor: const Color(0xFFF7FBFF),
        appBar: AppBar(
          leading: const MenuButton(),
          title: const Text('Desafios'),
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text('Meta diária: ${state.metaDiaria} questões',
                style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 12),
            for (var i = 0; i < state.trilha.length; i++)
              Card(
                child: ListTile(
                  leading: Icon(
                    state.desbloqueado(i) ? Icons.flag : Icons.lock_outline,
                    color: const Color(0xFFE8896B),
                  ),
                  title: Text('Desafio: ${state.trilha[i].nome}'),
                  subtitle: Text('${state.trilha[i].questoes.length} questões'),
                  onTap: () {
                    if (state.desbloqueado(i)) {
                      abrirDesafio(context, state.trilha[i].nome);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Desafio bloqueado.'),
                          backgroundColor: Colors.orange,
                        ),
                      );
                    }
                  },
                ),
              ),
            const SizedBox(height: 16),
            const Text('Histórico de XP',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            for (final h in state.historico.take(8))
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Text(h),
              ),
          ],
        ),
      ),
    );
  }
}